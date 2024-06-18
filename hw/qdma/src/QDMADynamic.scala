package qdma

import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._
import common.ToZero

class QDMADynamic[T <: Module with BaseTLB](
	VIVADO_VERSION		: String,
	PCIE_WIDTH			: Int=16,
	SLAVE_BRIDGE		: Boolean=false,
	TLB_TYPE			: =>T=new TLB,
	BRIDGE_BAR_SCALE	: String="Gigabytes",
	BRIDGE_BAR_SIZE		: Int=1
) extends RawModule{
	require (Set("202001", "202002", "202101") contains VIVADO_VERSION)
	require (Set(8, 16) contains PCIE_WIDTH)
	require (Set("Megabytes", "Gigabytes") contains BRIDGE_BAR_SCALE)

	val io = IO(new Bundle{
		val qdma_port	= Flipped(new QDMAStaticIO(
			VIVADO_VERSION = VIVADO_VERSION,
			PCIE_WIDTH = PCIE_WIDTH,
			SLAVE_BRIDGE = SLAVE_BRIDGE,
			AXI_BRIDGE = true
		))

		val user_clk	= Input(Clock())
		val user_arstn	= Input(Bool())

		val h2c_cmd		= Flipped(Decoupled(new H2C_CMD))
		val h2c_data	= Decoupled(new H2C_DATA)
		val c2h_cmd		= Flipped(Decoupled(new C2H_CMD))
		val c2h_data	= Flipped(Decoupled(new C2H_DATA))

		val reg_control = Output(Vec(512,UInt(32.W)))
		val reg_status	= Input(Vec(512,UInt(32.W)))

		val axib 		= new AXIB
		val s_axib		= if (SLAVE_BRIDGE) {Some(Flipped(new AXIB_SLAVE))} else None
	})

	val sw_reset = BUFG(io.reg_control(14)(0).asClock).asBool

	val pcie_clk = io.qdma_port.axi_aclk.asBool.asClock
	val pcie_arstn = io.qdma_port.axi_aresetn.asBool

	val fifo_h2c_data_in	= Wire(Decoupled(new H2C_DATA))
	val fifo_h2c_data		= XConverter(new H2C_DATA, pcie_clk, pcie_arstn, io.user_clk)
	fifo_h2c_data.io.in		<> withClockAndReset (pcie_clk, !pcie_arstn) {RegSlice(fifo_h2c_data_in)}
	fifo_h2c_data.io.out	<> io.h2c_data

	val fifo_c2h_data		= XConverter(new C2H_DATA, io.user_clk, io.user_arstn, pcie_clk)
	val fifo_c2h_data_out	= withClockAndReset (pcie_clk, !pcie_arstn) {RegSlice(fifo_c2h_data.io.out)}
	val fifo_h2c_cmd		= XConverter(new H2C_CMD, io.user_clk, io.user_arstn, pcie_clk)
	val fifo_h2c_cmd_out	= withClockAndReset (pcie_clk, !pcie_arstn) {RegSlice(fifo_h2c_cmd.io.out)}
	val fifo_c2h_cmd		= XConverter(new C2H_CMD, io.user_clk, io.user_arstn, pcie_clk)
	val fifo_c2h_cmd_out	= withClockAndReset (pcie_clk, !pcie_arstn) {RegSlice(fifo_c2h_cmd.io.out)}

	val check_c2h			= withClockAndReset(io.user_clk,!io.user_arstn){Module(new CMDBoundaryCheck(new C2H_CMD, 0x200000, 0x1000))}//(31*128 Byte)
	check_c2h.io.in			<> withClockAndReset (io.user_clk, !io.user_arstn) {RegSlice(io.c2h_cmd)}
	val check_h2c			= withClockAndReset(io.user_clk,!io.user_arstn){Module(new CMDBoundaryCheck(new H2C_CMD, 0x200000, 0x8000))}
	check_h2c.io.in			<> withClockAndReset (io.user_clk, !io.user_arstn) {RegSlice(io.h2c_cmd)}

	val tlb = withClockAndReset(io.user_clk,!io.user_arstn){Module(TLB_TYPE)}
	// val tlb			= {Module(new TLB)}
	tlb.io.h2c_in		<> withClockAndReset (io.user_clk, !io.user_arstn) {RegSlice(check_h2c.io.out)}
	tlb.io.c2h_in		<> withClockAndReset (io.user_clk, !io.user_arstn) {RegSlice(check_c2h.io.out)}
	fifo_h2c_cmd.io.in	<> withClockAndReset (io.user_clk, !io.user_arstn) {RegSlice(tlb.io.h2c_out)}


	val wr_tlb		= Wire(Valid(new WR_TLB))
	wr_tlb.bits.is_base		:= io.reg_control(12)(0)
	wr_tlb.bits.paddr_high	:= io.reg_control(11)
	wr_tlb.bits.paddr_low	:= io.reg_control(10)
	wr_tlb.bits.vaddr_high	:= io.reg_control(9)
	wr_tlb.bits.vaddr_low	:= io.reg_control(8)

	wr_tlb.valid		:=  withClockAndReset(io.user_clk,!io.user_arstn)(RegNext(!RegNext(io.reg_control(13)(0)) & io.reg_control(13)(0)))

	tlb.io.wr_tlb.bits 			:= wr_tlb.bits
	tlb.io.wr_tlb.valid 		:= wr_tlb.valid

	val axil2reg = withClockAndReset(io.user_clk,!io.user_arstn){Module(new PoorAXIL2Reg(new AXIL, 512, 32))}

	axil2reg.io.reg_status	<> io.reg_status
	axil2reg.io.reg_control <> io.reg_control
	Collector.report(tlb.io.tlb_miss_count)
	
	val axib = Wire(new AXIB)
	ToZero(axib.ar.bits)
	ToZero(axib.aw.bits)
	ToZero(axib.w.bits)
	io.axib <> XAXIConverter(axib, pcie_clk, pcie_arstn, io.user_clk, io.user_arstn)

	val s_axib = if (SLAVE_BRIDGE) {
		Some(XAXIConverter(io.s_axib.get, io.user_clk,io.user_arstn,pcie_clk,pcie_arstn))
	} else None

	if (SLAVE_BRIDGE) {
		s_axib.get.r.bits.user	:= 0.U
		s_axib.get.b.bits.user	:= 0.U
	}

	val axil = Wire(new AXIL)
	ToZero(axil.ar.bits)
	ToZero(axil.aw.bits)
	ToZero(axil.w.bits)
	axil.w.bits.last	:= 1.U

	axil2reg.io.axi <> XAXIConverter(axil, pcie_clk,pcie_arstn,io.user_clk,io.user_arstn)

	//all refer to c2h
	val boundary_split = withClockAndReset(io.user_clk,!io.user_arstn){Module(new DataBoundarySplit)}
	boundary_split.io.cmd_in <> tlb.io.c2h_out
	boundary_split.io.data_in	<> io.c2h_data
	boundary_split.io.cmd_out	<> fifo_c2h_cmd.io.in
	boundary_split.io.data_out	<> fifo_c2h_data.io.in

	withClockAndReset(io.user_clk, !io.user_arstn || sw_reset){
		Collector.fire(io.c2h_cmd)
		Collector.fire(io.h2c_cmd)
		Collector.fire(io.c2h_data)
		Collector.fire(io.h2c_data)
	}

	withClockAndReset(pcie_clk, !pcie_arstn || sw_reset){
		Collector.fire(fifo_c2h_cmd.io.out)
		Collector.fire(fifo_h2c_cmd.io.out)
		Collector.fire(fifo_c2h_data.io.out)
		Collector.fire(fifo_h2c_data.io.in)
	}

	//valids and readys
	Collector.report(fifo_c2h_cmd.io.out.valid)
	Collector.report(fifo_c2h_cmd.io.out.ready)

	Collector.report(fifo_h2c_cmd.io.out.valid)
	Collector.report(fifo_h2c_cmd.io.out.ready)

	Collector.report(fifo_c2h_data.io.out.valid)
	Collector.report(fifo_c2h_data.io.out.ready)

	Collector.report(fifo_h2c_data.io.in.valid)
	Collector.report(fifo_h2c_data.io.in.ready)
		
	io.qdma_port.soft_reset_n			:= 1.U

	//h2c cmd
	io.qdma_port.h2c_byp_in_st_addr		:= fifo_h2c_cmd_out.bits.addr
	io.qdma_port.h2c_byp_in_st_len		:= fifo_h2c_cmd_out.bits.len
	io.qdma_port.h2c_byp_in_st_eop		:= fifo_h2c_cmd_out.bits.eop
	io.qdma_port.h2c_byp_in_st_sop		:= fifo_h2c_cmd_out.bits.sop
	io.qdma_port.h2c_byp_in_st_mrkr_req	:= fifo_h2c_cmd_out.bits.mrkr_req
	io.qdma_port.h2c_byp_in_st_sdi		:= fifo_h2c_cmd_out.bits.sdi
	io.qdma_port.h2c_byp_in_st_qid		:= fifo_h2c_cmd_out.bits.qid
	io.qdma_port.h2c_byp_in_st_error	:= fifo_h2c_cmd_out.bits.error
	io.qdma_port.h2c_byp_in_st_func		:= fifo_h2c_cmd_out.bits.func
	io.qdma_port.h2c_byp_in_st_cidx		:= fifo_h2c_cmd_out.bits.cidx
	io.qdma_port.h2c_byp_in_st_port_id	:= fifo_h2c_cmd_out.bits.port_id
	io.qdma_port.h2c_byp_in_st_no_dma	:= fifo_h2c_cmd_out.bits.no_dma
	io.qdma_port.h2c_byp_in_st_vld		:= fifo_h2c_cmd_out.valid
	io.qdma_port.h2c_byp_in_st_rdy		<> fifo_h2c_cmd_out.ready

	//c2h cmd
	io.qdma_port.c2h_byp_in_st_csh_addr		:= fifo_c2h_cmd_out.bits.addr
	io.qdma_port.c2h_byp_in_st_csh_qid		:= fifo_c2h_cmd_out.bits.qid
	io.qdma_port.c2h_byp_in_st_csh_error	:= fifo_c2h_cmd_out.bits.error
	io.qdma_port.c2h_byp_in_st_csh_func		:= fifo_c2h_cmd_out.bits.func
	io.qdma_port.c2h_byp_in_st_csh_port_id	:= fifo_c2h_cmd_out.bits.port_id
	io.qdma_port.c2h_byp_in_st_csh_pfch_tag	:= fifo_c2h_cmd_out.bits.pfch_tag
	io.qdma_port.c2h_byp_in_st_csh_vld		:= fifo_c2h_cmd_out.valid
	io.qdma_port.c2h_byp_in_st_csh_rdy		<> fifo_c2h_cmd_out.ready

	//c2h data
	io.qdma_port.s_axis_c2h_tdata			:= fifo_c2h_data_out.bits.data
	io.qdma_port.s_axis_c2h_tcrc			:= fifo_c2h_data_out.bits.tcrc
	io.qdma_port.s_axis_c2h_ctrl_marker		:= fifo_c2h_data_out.bits.ctrl_marker
	io.qdma_port.s_axis_c2h_ctrl_ecc		:= fifo_c2h_data_out.bits.ctrl_ecc
	io.qdma_port.s_axis_c2h_ctrl_len		:= fifo_c2h_data_out.bits.ctrl_len
	io.qdma_port.s_axis_c2h_ctrl_port_id	:= fifo_c2h_data_out.bits.ctrl_port_id
	io.qdma_port.s_axis_c2h_ctrl_qid		:= fifo_c2h_data_out.bits.ctrl_qid
	io.qdma_port.s_axis_c2h_ctrl_has_cmpt	:= fifo_c2h_data_out.bits.ctrl_has_cmpt
	io.qdma_port.s_axis_c2h_mty				:= fifo_c2h_data_out.bits.mty
	io.qdma_port.s_axis_c2h_tlast			:= fifo_c2h_data_out.bits.last
	io.qdma_port.s_axis_c2h_tvalid			:= fifo_c2h_data_out.valid
	io.qdma_port.s_axis_c2h_tready			<> fifo_c2h_data_out.ready

	//h2c data
	io.qdma_port.m_axis_h2c_tdata			<> fifo_h2c_data_in.bits.data
	io.qdma_port.m_axis_h2c_tcrc			<> fifo_h2c_data_in.bits.tcrc
	io.qdma_port.m_axis_h2c_tuser_qid		<> fifo_h2c_data_in.bits.tuser_qid
	io.qdma_port.m_axis_h2c_tuser_port_id	<> fifo_h2c_data_in.bits.tuser_port_id
	io.qdma_port.m_axis_h2c_tuser_err		<> fifo_h2c_data_in.bits.tuser_err
	io.qdma_port.m_axis_h2c_tuser_mdata		<> fifo_h2c_data_in.bits.tuser_mdata
	io.qdma_port.m_axis_h2c_tuser_mty		<> fifo_h2c_data_in.bits.tuser_mty
	io.qdma_port.m_axis_h2c_tuser_zero_byte	<> fifo_h2c_data_in.bits.tuser_zero_byte
	io.qdma_port.m_axis_h2c_tlast			<> fifo_h2c_data_in.bits.last
	io.qdma_port.m_axis_h2c_tvalid			<> fifo_h2c_data_in.valid
	io.qdma_port.m_axis_h2c_tready			:= fifo_h2c_data_in.ready

	io.qdma_port.m_axib_awid.get				<> axib.aw.bits.id
	io.qdma_port.m_axib_awaddr.get				<> axib.aw.bits.addr
	io.qdma_port.m_axib_awlen.get				<> axib.aw.bits.len
	io.qdma_port.m_axib_awsize.get				<> axib.aw.bits.size
	io.qdma_port.m_axib_awburst.get				<> axib.aw.bits.burst
	io.qdma_port.m_axib_awprot.get				<> axib.aw.bits.prot
	io.qdma_port.m_axib_awlock.get				<> axib.aw.bits.lock
	io.qdma_port.m_axib_awcache.get				<> axib.aw.bits.cache
	io.qdma_port.m_axib_awvalid.get				<> axib.aw.valid
	io.qdma_port.m_axib_awready.get				<> axib.aw.ready

	io.qdma_port.m_axib_wdata.get				<> axib.w.bits.data
	io.qdma_port.m_axib_wstrb.get				<> axib.w.bits.strb
	io.qdma_port.m_axib_wlast.get				<> axib.w.bits.last
	io.qdma_port.m_axib_wvalid.get				<> axib.w.valid
	io.qdma_port.m_axib_wready.get				<> axib.w.ready

	io.qdma_port.m_axib_bid.get					<> axib.b.bits.id
	io.qdma_port.m_axib_bresp.get				<> axib.b.bits.resp
	io.qdma_port.m_axib_bvalid.get				<> axib.b.valid
	io.qdma_port.m_axib_bready.get				<> axib.b.ready

	io.qdma_port.m_axib_arid.get				<> axib.ar.bits.id
	io.qdma_port.m_axib_araddr.get				<> axib.ar.bits.addr
	io.qdma_port.m_axib_arlen.get				<> axib.ar.bits.len
	io.qdma_port.m_axib_arsize.get				<> axib.ar.bits.size
	io.qdma_port.m_axib_arburst.get				<> axib.ar.bits.burst
	io.qdma_port.m_axib_arprot.get				<> axib.ar.bits.prot
	io.qdma_port.m_axib_arlock.get				<> axib.ar.bits.lock
	io.qdma_port.m_axib_arcache.get				<> axib.ar.bits.cache
	io.qdma_port.m_axib_arvalid.get				<> axib.ar.valid
	io.qdma_port.m_axib_arready.get				<> axib.ar.ready

	io.qdma_port.m_axib_rid.get					<> axib.r.bits.id
	io.qdma_port.m_axib_rdata.get				<> axib.r.bits.data
	io.qdma_port.m_axib_rresp.get				<> axib.r.bits.resp
	io.qdma_port.m_axib_rlast.get				<> axib.r.bits.last
	io.qdma_port.m_axib_rvalid.get				<> axib.r.valid
	io.qdma_port.m_axib_rready.get				<> axib.r.ready

	io.qdma_port.m_axil_awaddr				<> axil.aw.bits.addr
	io.qdma_port.m_axil_awvalid				<> axil.aw.valid
	io.qdma_port.m_axil_awready				<> axil.aw.ready

	io.qdma_port.m_axil_wdata				<> axil.w.bits.data
	io.qdma_port.m_axil_wstrb				<> axil.w.bits.strb
	io.qdma_port.m_axil_wvalid				<> axil.w.valid
	io.qdma_port.m_axil_wready				<> axil.w.ready

	io.qdma_port.m_axil_bresp				<> axil.b.bits.resp
	io.qdma_port.m_axil_bvalid				<> axil.b.valid
	io.qdma_port.m_axil_bready				<> axil.b.ready

	io.qdma_port.m_axil_araddr				<> axil.ar.bits.addr
	io.qdma_port.m_axil_arvalid				<> axil.ar.valid
	io.qdma_port.m_axil_arready				<> axil.ar.ready

	io.qdma_port.m_axil_rdata				<> axil.r.bits.data
	io.qdma_port.m_axil_rresp				<> axil.r.bits.resp
	io.qdma_port.m_axil_rvalid				<> axil.r.valid
	io.qdma_port.m_axil_rready				<> axil.r.ready

	//other

	io.qdma_port.s_axis_c2h_cmpt_tdata					:= 0.U
	io.qdma_port.s_axis_c2h_cmpt_size					:= 0.U
	io.qdma_port.s_axis_c2h_cmpt_dpar					:= 0.U
	io.qdma_port.s_axis_c2h_cmpt_tvalid					:= 0.U
	io.qdma_port.s_axis_c2h_cmpt_ctrl_qid				:= 0.U
	io.qdma_port.s_axis_c2h_cmpt_ctrl_cmpt_type			:= 0.U
	io.qdma_port.s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id	:= 0.U
	if(io.qdma_port.s_axis_c2h_cmpt_ctrl_no_wrb_marker != None){
		io.qdma_port.s_axis_c2h_cmpt_ctrl_no_wrb_marker.get		:= 0.U	
	}
	io.qdma_port.s_axis_c2h_cmpt_ctrl_port_id			:= 0.U
	io.qdma_port.s_axis_c2h_cmpt_ctrl_marker			:= 0.U
	io.qdma_port.s_axis_c2h_cmpt_ctrl_user_trig			:= 0.U
	io.qdma_port.s_axis_c2h_cmpt_ctrl_col_idx			:= 0.U
	io.qdma_port.s_axis_c2h_cmpt_ctrl_err_idx			:= 0.U

	io.qdma_port.h2c_byp_out_rdy			:= 1.U
	io.qdma_port.c2h_byp_out_rdy			:= 1.U
	io.qdma_port.tm_dsc_sts_rdy				:= 1.U
	
	io.qdma_port.dsc_crdt_in_vld				:= 0.U
	io.qdma_port.dsc_crdt_in_dir				:= 0.U
	io.qdma_port.dsc_crdt_in_fence				:= 0.U
	io.qdma_port.dsc_crdt_in_qid				:= 0.U
	io.qdma_port.dsc_crdt_in_crdt				:= 0.U
	
	io.qdma_port.qsts_out_rdy					:= 1.U
	
	io.qdma_port.usr_irq_in_vld					:= 0.U
	io.qdma_port.usr_irq_in_vec					:= 0.U
	io.qdma_port.usr_irq_in_fnc					:= 0.U
	//note that above rdy must be 1, otherwise qdma device can not be found in ubuntu, I don't know why

	if (SLAVE_BRIDGE) {
		io.qdma_port.s_axib_awid.get			<> s_axib.get.aw.bits.id
		io.qdma_port.s_axib_awaddr.get			<> s_axib.get.aw.bits.addr
		io.qdma_port.s_axib_awlen.get			<> s_axib.get.aw.bits.len
		io.qdma_port.s_axib_awsize.get			<> s_axib.get.aw.bits.size
		io.qdma_port.s_axib_awburst.get			<> s_axib.get.aw.bits.burst
		io.qdma_port.s_axib_awvalid.get			<> s_axib.get.aw.valid
		io.qdma_port.s_axib_awready.get			<> s_axib.get.aw.ready

		io.qdma_port.s_axib_wdata.get			<> s_axib.get.w.bits.data
		io.qdma_port.s_axib_wstrb.get			<> s_axib.get.w.bits.strb
		io.qdma_port.s_axib_wlast.get			<> s_axib.get.w.bits.last
		io.qdma_port.s_axib_wvalid.get			<> s_axib.get.w.valid
		io.qdma_port.s_axib_wready.get			<> s_axib.get.w.ready

		io.qdma_port.s_axib_bid.get				<> s_axib.get.b.bits.id
		io.qdma_port.s_axib_bresp.get			<> s_axib.get.b.bits.resp
		io.qdma_port.s_axib_bvalid.get			<> s_axib.get.b.valid
		io.qdma_port.s_axib_bready.get			<> s_axib.get.b.ready

		io.qdma_port.s_axib_arid.get			<> s_axib.get.ar.bits.id
		io.qdma_port.s_axib_araddr.get			<> s_axib.get.ar.bits.addr
		io.qdma_port.s_axib_arlen.get			<> s_axib.get.ar.bits.len
		io.qdma_port.s_axib_arsize.get			<> s_axib.get.ar.bits.size
		io.qdma_port.s_axib_arburst.get			<> s_axib.get.ar.bits.burst
		io.qdma_port.s_axib_arvalid.get			<> s_axib.get.ar.valid
		io.qdma_port.s_axib_arready.get			<> s_axib.get.ar.ready

		io.qdma_port.s_axib_rid.get				<> s_axib.get.r.bits.id
		io.qdma_port.s_axib_rdata.get			<> s_axib.get.r.bits.data
		io.qdma_port.s_axib_rresp.get			<> s_axib.get.r.bits.resp
		io.qdma_port.s_axib_rlast.get			<> s_axib.get.r.bits.last
		io.qdma_port.s_axib_rvalid.get			<> s_axib.get.r.valid
		io.qdma_port.s_axib_rready.get			<> s_axib.get.r.ready

		io.qdma_port.st_rx_msg_data.get	 <> DontCare
		io.qdma_port.st_rx_msg_last.get  <> DontCare
		io.qdma_port.st_rx_msg_rdy.get	 <> 1.U
		io.qdma_port.st_rx_msg_valid.get <> DontCare

		io.qdma_port.s_axib_aruser.get		<> DontCare
		io.qdma_port.s_axib_arregion.get	<> DontCare
		io.qdma_port.s_axib_awuser.get		<> DontCare
		io.qdma_port.s_axib_awregion.get	<> DontCare
		io.qdma_port.s_axib_wuser.get		<> DontCare
	}
}

class QDMAStaticIO(VIVADO_VERSION:String, PCIE_WIDTH:Int, SLAVE_BRIDGE:Boolean, AXI_BRIDGE:Boolean) extends Bundle{
    val axi_aclk                    = Output(UInt(1.W))
    val axi_aresetn                 = Output(UInt(1.W))

    val m_axib_awid					= if (AXI_BRIDGE){Some(Output(UInt(4.W)))} else None
    val m_axib_awaddr				= if (AXI_BRIDGE){Some(Output(UInt(64.W)))} else None
    val m_axib_awlen				= if (AXI_BRIDGE){Some(Output(UInt(8.W)))} else None
    val m_axib_awsize				= if (AXI_BRIDGE){Some(Output(UInt(3.W)))} else None
    val m_axib_awburst				= if (AXI_BRIDGE){Some(Output(UInt(2.W)))} else None
    val m_axib_awprot				= if (AXI_BRIDGE){Some(Output(UInt(3.W)))} else None
    val m_axib_awlock				= if (AXI_BRIDGE){Some(Output(UInt(1.W)))} else None
    val m_axib_awcache				= if (AXI_BRIDGE){Some(Output(UInt(4.W)))} else None
    val m_axib_awvalid				= if (AXI_BRIDGE){Some(Output(UInt(1.W)))} else None
    val m_axib_awready				= if (AXI_BRIDGE){Some(Input(UInt(1.W)))} else None

    val m_axib_wdata				= if (AXI_BRIDGE){Some(Output(UInt(512.W)))} else None
    val m_axib_wstrb				= if (AXI_BRIDGE){Some(Output(UInt(64.W)))} else None
    val m_axib_wlast				= if (AXI_BRIDGE){Some(Output(UInt(1.W)))} else None
    val m_axib_wvalid				= if (AXI_BRIDGE){Some(Output(UInt(1.W)))} else None
    val m_axib_wready				= if (AXI_BRIDGE){Some(Input(UInt(1.W)))} else None

    val m_axib_bid					= if (AXI_BRIDGE){Some(Input(UInt(4.W)))} else None
    val m_axib_bresp				= if (AXI_BRIDGE){Some(Input(UInt(2.W)))} else None
    val m_axib_bvalid				= if (AXI_BRIDGE){Some(Input(UInt(1.W)))} else None
    val m_axib_bready				= if (AXI_BRIDGE){Some(Output(UInt(1.W)))} else None

    val m_axib_arid					= if (AXI_BRIDGE){Some(Output(UInt(4.W)))} else None
    val m_axib_araddr				= if (AXI_BRIDGE){Some(Output(UInt(64.W)))} else None
    val m_axib_arlen				= if (AXI_BRIDGE){Some(Output(UInt(8.W)))} else None
    val m_axib_arsize				= if (AXI_BRIDGE){Some(Output(UInt(3.W)))} else None
    val m_axib_arburst				= if (AXI_BRIDGE){Some(Output(UInt(2.W)))} else None
    val m_axib_arprot				= if (AXI_BRIDGE){Some(Output(UInt(3.W)))} else None
    val m_axib_arlock				= if (AXI_BRIDGE){Some(Output(UInt(1.W)))} else None
    val m_axib_arcache				= if (AXI_BRIDGE){Some(Output(UInt(4.W)))} else None
    val m_axib_arvalid				= if (AXI_BRIDGE){Some(Output(UInt(1.W)))} else None
    val m_axib_arready				= if (AXI_BRIDGE){Some(Input(UInt(1.W)))} else None

    val m_axib_rid					= if (AXI_BRIDGE){Some(Input(UInt(4.W)))} else None
    val m_axib_rdata				= if (AXI_BRIDGE){Some(Input(UInt(512.W)))} else None
    val m_axib_rresp				= if (AXI_BRIDGE){Some(Input(UInt(2.W)))} else None
    val m_axib_rlast				= if (AXI_BRIDGE){Some(Input(UInt(1.W)))} else None
    val m_axib_rvalid				= if (AXI_BRIDGE){Some(Input(UInt(1.W)))} else None
    val m_axib_rready				= if (AXI_BRIDGE){Some(Output(UInt(1.W)))} else None


    val m_axil_awaddr				= Output(UInt(32.W))
    val m_axil_awvalid				= Output(UInt(1.W))
    val m_axil_awready				= Input(UInt(1.W))

    val m_axil_wdata				= Output(UInt(32.W))
    val m_axil_wstrb				= Output(UInt(4.W))
    val m_axil_wvalid				= Output(UInt(1.W))
    val m_axil_wready				= Input(UInt(1.W))

    val m_axil_bresp				= Input(UInt(2.W))
    val m_axil_bvalid				= Input(UInt(1.W))
    val m_axil_bready				= Output(UInt(1.W))

    val m_axil_araddr				= Output(UInt(32.W))
    val m_axil_arvalid				= Output(UInt(1.W))
    val m_axil_arready				= Input(UInt(1.W))

    val m_axil_rdata				= Input(UInt(32.W))
    val m_axil_rresp				= Input(UInt(2.W))
    val m_axil_rvalid				= Input(UInt(1.W))
    val m_axil_rready				= Output(UInt(1.W))

    val soft_reset_n				= Input(Bool())

    val h2c_byp_in_st_addr			= Input(UInt(64.W))
    val h2c_byp_in_st_len			= Input(UInt(32.W))
    val h2c_byp_in_st_eop			= Input(UInt(1.W))
    val h2c_byp_in_st_sop			= Input(UInt(1.W))
    val h2c_byp_in_st_mrkr_req		= Input(UInt(1.W))
    val h2c_byp_in_st_sdi			= Input(UInt(1.W))
    val h2c_byp_in_st_qid			= Input(UInt(11.W))
    val h2c_byp_in_st_error			= Input(UInt(1.W))
    val h2c_byp_in_st_func			= Input(UInt(8.W))
    val h2c_byp_in_st_cidx			= Input(UInt(16.W))
    val h2c_byp_in_st_port_id		= Input(UInt(3.W))
    val h2c_byp_in_st_no_dma		= Input(UInt(1.W))
    val h2c_byp_in_st_vld			= Input(UInt(1.W))
    val h2c_byp_in_st_rdy			= Output(UInt(1.W))

    val c2h_byp_in_st_csh_addr		= Input(UInt(64.W))
    val c2h_byp_in_st_csh_qid		= Input(UInt(11.W))
    val c2h_byp_in_st_csh_error		= Input(UInt(1.W))
    val c2h_byp_in_st_csh_func		= Input(UInt(8.W))
    val c2h_byp_in_st_csh_port_id	= Input(UInt(3.W))
    val c2h_byp_in_st_csh_pfch_tag	= Input(UInt(7.W))
    val c2h_byp_in_st_csh_vld		= Input(UInt(1.W))
    val c2h_byp_in_st_csh_rdy		= Output(UInt(1.W))

    val s_axis_c2h_tdata			= Input(UInt(512.W))
    val s_axis_c2h_tcrc				= Input(UInt(32.W))
    val s_axis_c2h_ctrl_marker		= Input(UInt(1.W))
    val s_axis_c2h_ctrl_ecc			= Input(UInt(7.W))
    val s_axis_c2h_ctrl_len			= Input(UInt(32.W))
    val s_axis_c2h_ctrl_port_id		= Input(UInt(3.W))
    val s_axis_c2h_ctrl_qid			= Input(UInt(11.W))
    val s_axis_c2h_ctrl_has_cmpt	= Input(UInt(1.W))
    val s_axis_c2h_mty				= Input(UInt(6.W))
    val s_axis_c2h_tlast			= Input(UInt(1.W))
    val s_axis_c2h_tvalid			= Input(UInt(1.W))
    val s_axis_c2h_tready			= Output(UInt(1.W))

    
    val m_axis_h2c_tdata			= Output(UInt(512.W))
    val m_axis_h2c_tcrc				= Output(UInt(32.W))
    val m_axis_h2c_tuser_qid		= Output(UInt(11.W))
    val m_axis_h2c_tuser_port_id	= Output(UInt(3.W))
    val m_axis_h2c_tuser_err		= Output(UInt(1.W))
    val m_axis_h2c_tuser_mdata		= Output(UInt(32.W))
    val m_axis_h2c_tuser_mty		= Output(UInt(6.W))
    val m_axis_h2c_tuser_zero_byte	= Output(UInt(1.W))
    val m_axis_h2c_tlast			= Output(UInt(1.W))
    val m_axis_h2c_tvalid			= Output(UInt(1.W))
    val m_axis_h2c_tready			= Input(UInt(1.W))

    val axis_c2h_status_drop		= Output(UInt(1.W))
    val axis_c2h_status_last		= Output(UInt(1.W))
    val axis_c2h_status_cmp			= Output(UInt(1.W))
    val axis_c2h_status_valid		= Output(UInt(1.W))
    val axis_c2h_status_qid			= Output(UInt(11.W))

    val s_axis_c2h_cmpt_tdata					= Input(UInt(512.W))
    val s_axis_c2h_cmpt_size					= Input(UInt(2.W))
    val s_axis_c2h_cmpt_dpar					= Input(UInt(16.W))
    val s_axis_c2h_cmpt_tvalid					= Input(UInt(1.W))
    val s_axis_c2h_cmpt_tready					= Output(UInt(1.W))
    val s_axis_c2h_cmpt_ctrl_qid				= Input(UInt(11.W))
    val s_axis_c2h_cmpt_ctrl_cmpt_type			= Input(UInt(2.W))
    val s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id	= Input(UInt(16.W))
    val s_axis_c2h_cmpt_ctrl_no_wrb_marker		= if(VIVADO_VERSION=="202101" || VIVADO_VERSION=="202002") Some(Input(UInt(1.W))) else None
    val s_axis_c2h_cmpt_ctrl_port_id			= Input(UInt(3.W))
    val s_axis_c2h_cmpt_ctrl_marker				= Input(UInt(1.W))
    val s_axis_c2h_cmpt_ctrl_user_trig			= Input(UInt(1.W))
    val s_axis_c2h_cmpt_ctrl_col_idx			= Input(UInt(3.W))
    val s_axis_c2h_cmpt_ctrl_err_idx			= Input(UInt(3.W))

    //ignore other
    val h2c_byp_out_rdy							= Input(UInt(1.W))

    //ignore other
    val c2h_byp_out_rdy							= Input(UInt(1.W))

    //ignore other
    val tm_dsc_sts_rdy							= Input(UInt(1.W))

    val dsc_crdt_in_vld							= Input(UInt(1.W))
    val dsc_crdt_in_rdy							= Output(UInt(1.W))
    val dsc_crdt_in_dir							= Input(UInt(1.W))
    val dsc_crdt_in_fence						= Input(UInt(1.W))
    val dsc_crdt_in_qid							= Input(UInt(11.W))
    val dsc_crdt_in_crdt						= Input(UInt(16.W))

    //ignore other
    val qsts_out_rdy							= Input(UInt(1.W))

    val usr_irq_in_vld							= Input(UInt(1.W))
    val usr_irq_in_vec							= Input(UInt(11.W))
    val usr_irq_in_fnc							= Input(UInt(8.W))
    val usr_irq_out_ack							= Output(UInt(1.W))
    val usr_irq_out_fail						= Output(UInt(1.W))

    val s_axib_awid					= if (SLAVE_BRIDGE) {Some(Input(UInt(4.W)))} else None
    val s_axib_awaddr				= if (SLAVE_BRIDGE) {Some(Input(UInt(64.W)))} else None
    val s_axib_awlen				= if (SLAVE_BRIDGE) {Some(Input(UInt(8.W)))} else None
    val s_axib_awsize				= if (SLAVE_BRIDGE) {Some(Input(UInt(3.W)))} else None
    val s_axib_awuser				= if (SLAVE_BRIDGE) {Some(Input(UInt(12.W)))} else None
    val s_axib_awburst				= if (SLAVE_BRIDGE) {Some(Input(UInt(2.W)))} else None
    val s_axib_awregion				= if (SLAVE_BRIDGE) {Some(Input(UInt(4.W)))} else None
    val s_axib_awvalid				= if (SLAVE_BRIDGE) {Some(Input(UInt(1.W)))} else None
    val s_axib_awready				= if (SLAVE_BRIDGE) {Some(Output(UInt(1.W)))} else None

    val s_axib_wdata				= if (SLAVE_BRIDGE) {Some(Input(UInt(512.W)))} else None
    val s_axib_wstrb				= if (SLAVE_BRIDGE) {Some(Input(UInt(64.W)))} else None
    val s_axib_wuser				= if (SLAVE_BRIDGE) {Some(Input(UInt(64.W)))} else None
    val s_axib_wlast				= if (SLAVE_BRIDGE) {Some(Input(UInt(1.W)))} else None
    val s_axib_wvalid				= if (SLAVE_BRIDGE) {Some(Input(UInt(1.W)))} else None
    val s_axib_wready				= if (SLAVE_BRIDGE) {Some(Output(UInt(1.W)))} else None

    val s_axib_bid					= if (SLAVE_BRIDGE) {Some(Output(UInt(4.W)))} else None
    val s_axib_bresp				= if (SLAVE_BRIDGE) {Some(Output(UInt(2.W)))} else None
    val s_axib_bvalid				= if (SLAVE_BRIDGE) {Some(Output(UInt(1.W)))} else None
    val s_axib_bready				= if (SLAVE_BRIDGE) {Some(Input(UInt(1.W)))} else None

    val s_axib_arid					= if (SLAVE_BRIDGE) {Some(Input(UInt(4.W)))} else None
    val s_axib_araddr				= if (SLAVE_BRIDGE) {Some(Input(UInt(64.W)))} else None
    val s_axib_arlen				= if (SLAVE_BRIDGE) {Some(Input(UInt(8.W)))} else None
    val s_axib_arsize				= if (SLAVE_BRIDGE) {Some(Input(UInt(3.W)))} else None
    val s_axib_aruser				= if (SLAVE_BRIDGE) {Some(Input(UInt(12.W)))} else None
    val s_axib_arburst				= if (SLAVE_BRIDGE) {Some(Input(UInt(2.W)))} else None
    val s_axib_arregion				= if (SLAVE_BRIDGE) {Some(Input(UInt(4.W)))} else None
    val s_axib_arvalid				= if (SLAVE_BRIDGE) {Some(Input(UInt(1.W)))} else None
    val s_axib_arready				= if (SLAVE_BRIDGE) {Some(Output(UInt(1.W)))} else None

    val s_axib_rid					= if (SLAVE_BRIDGE) {Some(Output(UInt(4.W)))} else None
    val s_axib_rdata				= if (SLAVE_BRIDGE) {Some(Output(UInt(512.W)))} else None
    val s_axib_rresp				= if (SLAVE_BRIDGE) {Some(Output(UInt(2.W)))} else None
    val s_axib_ruser				= if (SLAVE_BRIDGE) {Some(Output(UInt(64.W)))} else None
    val s_axib_rlast				= if (SLAVE_BRIDGE) {Some(Output(UInt(1.W)))} else None
    val s_axib_rvalid				= if (SLAVE_BRIDGE) {Some(Output(UInt(1.W)))} else None
    val s_axib_rready				= if (SLAVE_BRIDGE) {Some(Input(UInt(1.W)))} else None

    val st_rx_msg_data	= if (SLAVE_BRIDGE) {Some(Output(UInt(32.W)))} else None
    val st_rx_msg_last	= if (SLAVE_BRIDGE) {Some(Output(UInt(1.W)))} else None
    val st_rx_msg_rdy	= if (SLAVE_BRIDGE) {Some(Input(UInt(1.W)))} else None
    val st_rx_msg_valid	= if (SLAVE_BRIDGE) {Some(Output(UInt(1.W)))} else None
}