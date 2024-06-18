package qdma

import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._
import common.ToZero


class AXIL extends AXI(
	ADDR_WIDTH=32,
	DATA_WIDTH=32,
	ID_WIDTH=0,
	USER_WIDTH=0,
	LEN_WIDTH=0,
){
}

class AXIB extends AXI(
	ADDR_WIDTH=64,
	DATA_WIDTH=512,
	ID_WIDTH=4,
	USER_WIDTH=0,
	LEN_WIDTH=8,
){
}

class AXIB_SLAVE extends AXI(
	ADDR_WIDTH=64,
	DATA_WIDTH=512,
	ID_WIDTH=4,
	USER_WIDTH=64,
	LEN_WIDTH=8,
){
	override val aw	= (Decoupled(new AXI_ADDR(64, 512, 4, 12, 8)))
	override val ar	= (Decoupled(new AXI_ADDR(64, 512, 4, 12, 8)))
}

class TestAXI2Reg extends Module{
	val io = IO(new Bundle{
		val axi = Flipped(new AXIL)
		val reg_control = Output(Vec(16,UInt(32.W))) 
		val reg_status = Input(Vec(16,UInt(32.W)))
	})

	val axi2reg = Module(new PoorAXIL2Reg(new AXIL, 16, 32))

	axi2reg.io <> io
}

class QDMA[T <: Module with BaseTLB](
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
	def getTCL() = {
		val s1 = "\ncreate_ip -name qdma -vendor xilinx.com -library ip -version 4.0 -module_name QDMABlackBox\n"
		var s2 = "set_property -dict [list CONFIG.Component_Name {QDMABlackBox} CONFIG.mode_selection {Advanced} CONFIG.axist_bypass_en {true} CONFIG.pcie_extended_tag {false} CONFIG.pcie_blk_locn {PCIE4C_X1Y0} "
		if (VIVADO_VERSION == "202001") {
			s2 = s2 + "CONFIG.dsc_bypass_rd {true} CONFIG.dsc_bypass_wr {true} "
		} else {
			s2 = s2 + "CONFIG.dsc_byp_mode {Descriptor_bypass_and_internal} "
		}
		if (PCIE_WIDTH == 16) {
			s2 = s2 + "CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} CONFIG.pl_link_cap_max_link_width {X16} "
		} else {
			s2 = s2 + "CONFIG.pl_link_cap_max_link_speed {16.0_GT/s} CONFIG.pl_link_cap_max_link_width {X8} "
		}
		if (SLAVE_BRIDGE == true) {
			s2 = s2 + "CONFIG.en_bridge_slv {true} CONFIG.csr_axilite_slave {false} CONFIG.axibar_notranslate {true} "
		}
		s2 = s2 + s"CONFIG.cfg_mgmt_if {false} CONFIG.testname {st} CONFIG.pf0_bar4_enabled_qdma {true} CONFIG.pf0_bar4_64bit_qdma {true} CONFIG.pf0_bar4_scale_qdma {${BRIDGE_BAR_SCALE}} CONFIG.pf0_bar4_size_qdma {${BRIDGE_BAR_SIZE}} CONFIG.dma_intf_sel_qdma {AXI_MM_and_AXI_Stream_with_Completion} CONFIG.en_axi_mm_qdma {false}] [get_ips QDMABlackBox]\n"
		println( s1 + s2)
	}
	val io = IO(new Bundle{
		val pin		= new QDMAPin(PCIE_WIDTH)

		val pcie_clk 	= Output(Clock())
		val pcie_arstn	= Output(Bool())

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

	val sw_reset = io.reg_control(14) === 1.U

	val perst_n = IBUF(io.pin.sys_rst_n)

	val ibufds_gte4_inst = Module(new IBUFDS_GTE4(REFCLK_HROW_CK_SEL=0))
	ibufds_gte4_inst.io.IB		:= io.pin.sys_clk_n
	ibufds_gte4_inst.io.I		:= io.pin.sys_clk_p
	ibufds_gte4_inst.io.CEB		:= 0.U
	val pcie_ref_clk_gt			= ibufds_gte4_inst.io.O
	val pcie_ref_clk			= ibufds_gte4_inst.io.ODIV2

	val fifo_h2c_data_in	= Wire(Decoupled(new H2C_DATA))
	val fifo_h2c_data		= XConverter(new H2C_DATA, io.pcie_clk, io.pcie_arstn, io.user_clk)
	fifo_h2c_data.io.in		<> withClockAndReset (io.pcie_clk, !io.pcie_arstn) {RegSlice(fifo_h2c_data_in)}
	fifo_h2c_data.io.out	<> io.h2c_data

	val fifo_c2h_data		= XConverter(new C2H_DATA, io.user_clk, io.user_arstn, io.pcie_clk)
	val fifo_c2h_data_out	= withClockAndReset (io.pcie_clk, !io.pcie_arstn) {RegSlice(fifo_c2h_data.io.out)}
	val fifo_h2c_cmd		= XConverter(new H2C_CMD, io.user_clk, io.user_arstn, io.pcie_clk)
	val fifo_h2c_cmd_out	= withClockAndReset (io.pcie_clk, !io.pcie_arstn) {RegSlice(fifo_h2c_cmd.io.out)}
	val fifo_c2h_cmd		= XConverter(new C2H_CMD, io.user_clk, io.user_arstn, io.pcie_clk)
	val fifo_c2h_cmd_out	= withClockAndReset (io.pcie_clk, !io.pcie_arstn) {RegSlice(fifo_c2h_cmd.io.out)}

	val check_c2h			= withClockAndReset(io.user_clk,!io.user_arstn){Module(new CMDBoundaryCheck(new C2H_CMD, 0x200000, 0x1000))}//(31*128 Byte)
	check_c2h.io.in			<> withClockAndReset (io.user_clk, !io.user_arstn) {RegSlice(io.c2h_cmd)}
	val check_h2c			= withClockAndReset(io.user_clk,!io.user_arstn){Module(new CMDBoundaryCheck(new H2C_CMD, 0x200000, 0x8000))}
	check_h2c.io.in			<> withClockAndReset (io.user_clk, !io.user_arstn) {RegSlice(io.h2c_cmd)}

	val tlb = withClockAndReset(io.user_clk,!io.user_arstn){Module(TLB_TYPE)}
	// val tlb			= {Module(new TLB)}
	tlb.io.h2c_in		<> withClockAndReset (io.user_clk, !io.user_arstn) {RegSlice(check_h2c.io.out)}
	tlb.io.c2h_in		<> withClockAndReset (io.user_clk, !io.user_arstn) {RegSlice(check_c2h.io.out)}
	fifo_h2c_cmd.io.in	<> withClockAndReset (io.user_clk, !io.user_arstn) {RegSlice(tlb.io.h2c_out)}


	val fifo_wr_tlb		= Wire(Decoupled(new WR_TLB()))// XConverter(new WR_TLB, io.user_clk, io.user_arstn, io.user_clk)
	fifo_wr_tlb.bits.is_base		:= io.reg_control(12)(0)
	fifo_wr_tlb.bits.paddr_high	:= io.reg_control(11)
	fifo_wr_tlb.bits.paddr_low	:= io.reg_control(10)
	fifo_wr_tlb.bits.vaddr_high	:= io.reg_control(9)
	fifo_wr_tlb.bits.vaddr_low	:= io.reg_control(8)

	fifo_wr_tlb.valid		:=  withClockAndReset(io.user_clk,!io.user_arstn)(RegNext(!RegNext(io.reg_control(13)(0)) & io.reg_control(13)(0)))

	tlb.io.wr_tlb.bits 			:= fifo_wr_tlb.bits
	tlb.io.wr_tlb.valid 		:= fifo_wr_tlb.valid
	fifo_wr_tlb.ready	:= 1.U

	val axil2reg = withClockAndReset(io.user_clk,!io.user_arstn){Module(new PoorAXIL2Reg(new AXIL, 512, 32))}

	axil2reg.io.reg_status	<> io.reg_status
	axil2reg.io.reg_control <> io.reg_control
	Collector.report(tlb.io.tlb_miss_count)
	
	val axib = Wire(new AXIB)
	ToZero(axib.ar.bits)
	ToZero(axib.aw.bits)
	ToZero(axib.w.bits)
	io.axib <> XAXIConverter(axib, io.pcie_clk,io.pcie_arstn,io.user_clk,io.user_arstn)

	val s_axib = if (SLAVE_BRIDGE) {
		Some(XAXIConverter(io.s_axib.get, io.user_clk,io.user_arstn,io.pcie_clk,io.pcie_arstn))
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

	axil2reg.io.axi <> XAXIConverter(axil, io.pcie_clk,!io.pcie_arstn,io.user_clk,!io.user_arstn)

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

	withClockAndReset(io.pcie_clk, !io.pcie_arstn || sw_reset){
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
		
	val qdma_inst = Module(new QDMABlackBox(VIVADO_VERSION, PCIE_WIDTH, SLAVE_BRIDGE, AXI_BRIDGE=true))
	qdma_inst.io.sys_rst_n				:= perst_n
	qdma_inst.io.sys_clk				:= pcie_ref_clk
	qdma_inst.io.sys_clk_gt				:= pcie_ref_clk_gt

	qdma_inst.io.pci_exp_txn			<> io.pin.tx_n
	qdma_inst.io.pci_exp_txp			<> io.pin.tx_p
	qdma_inst.io.pci_exp_rxn			:= io.pin.rx_n
	qdma_inst.io.pci_exp_rxp			:= io.pin.rx_p

	qdma_inst.io.axi_aclk				<> io.pcie_clk
	qdma_inst.io.axi_aresetn			<> io.pcie_arstn
	qdma_inst.io.soft_reset_n			:= 1.U

	//h2c cmd
	qdma_inst.io.h2c_byp_in_st_addr		:= fifo_h2c_cmd_out.bits.addr
	qdma_inst.io.h2c_byp_in_st_len		:= fifo_h2c_cmd_out.bits.len
	qdma_inst.io.h2c_byp_in_st_eop		:= fifo_h2c_cmd_out.bits.eop
	qdma_inst.io.h2c_byp_in_st_sop		:= fifo_h2c_cmd_out.bits.sop
	qdma_inst.io.h2c_byp_in_st_mrkr_req	:= fifo_h2c_cmd_out.bits.mrkr_req
	qdma_inst.io.h2c_byp_in_st_sdi		:= fifo_h2c_cmd_out.bits.sdi
	qdma_inst.io.h2c_byp_in_st_qid		:= fifo_h2c_cmd_out.bits.qid
	qdma_inst.io.h2c_byp_in_st_error	:= fifo_h2c_cmd_out.bits.error
	qdma_inst.io.h2c_byp_in_st_func		:= fifo_h2c_cmd_out.bits.func
	qdma_inst.io.h2c_byp_in_st_cidx		:= fifo_h2c_cmd_out.bits.cidx
	qdma_inst.io.h2c_byp_in_st_port_id	:= fifo_h2c_cmd_out.bits.port_id
	qdma_inst.io.h2c_byp_in_st_no_dma	:= fifo_h2c_cmd_out.bits.no_dma
	qdma_inst.io.h2c_byp_in_st_vld		:= fifo_h2c_cmd_out.valid
	qdma_inst.io.h2c_byp_in_st_rdy		<> fifo_h2c_cmd_out.ready

	//c2h cmd
	qdma_inst.io.c2h_byp_in_st_csh_addr		:= fifo_c2h_cmd_out.bits.addr
	qdma_inst.io.c2h_byp_in_st_csh_qid		:= fifo_c2h_cmd_out.bits.qid
	qdma_inst.io.c2h_byp_in_st_csh_error	:= fifo_c2h_cmd_out.bits.error
	qdma_inst.io.c2h_byp_in_st_csh_func		:= fifo_c2h_cmd_out.bits.func
	qdma_inst.io.c2h_byp_in_st_csh_port_id	:= fifo_c2h_cmd_out.bits.port_id
	qdma_inst.io.c2h_byp_in_st_csh_pfch_tag	:= fifo_c2h_cmd_out.bits.pfch_tag
	qdma_inst.io.c2h_byp_in_st_csh_vld		:= fifo_c2h_cmd_out.valid
	qdma_inst.io.c2h_byp_in_st_csh_rdy		<> fifo_c2h_cmd_out.ready

	//c2h data
	qdma_inst.io.s_axis_c2h_tdata			:= fifo_c2h_data_out.bits.data
	qdma_inst.io.s_axis_c2h_tcrc			:= fifo_c2h_data_out.bits.tcrc
	qdma_inst.io.s_axis_c2h_ctrl_marker		:= fifo_c2h_data_out.bits.ctrl_marker
	qdma_inst.io.s_axis_c2h_ctrl_ecc		:= fifo_c2h_data_out.bits.ctrl_ecc
	qdma_inst.io.s_axis_c2h_ctrl_len		:= fifo_c2h_data_out.bits.ctrl_len
	qdma_inst.io.s_axis_c2h_ctrl_port_id	:= fifo_c2h_data_out.bits.ctrl_port_id
	qdma_inst.io.s_axis_c2h_ctrl_qid		:= fifo_c2h_data_out.bits.ctrl_qid
	qdma_inst.io.s_axis_c2h_ctrl_has_cmpt	:= fifo_c2h_data_out.bits.ctrl_has_cmpt
	qdma_inst.io.s_axis_c2h_mty				:= fifo_c2h_data_out.bits.mty
	qdma_inst.io.s_axis_c2h_tlast			:= fifo_c2h_data_out.bits.last
	qdma_inst.io.s_axis_c2h_tvalid			:= fifo_c2h_data_out.valid
	qdma_inst.io.s_axis_c2h_tready			<> fifo_c2h_data_out.ready

	//h2c data
	qdma_inst.io.m_axis_h2c_tdata			<> fifo_h2c_data_in.bits.data
	qdma_inst.io.m_axis_h2c_tcrc			<> fifo_h2c_data_in.bits.tcrc
	qdma_inst.io.m_axis_h2c_tuser_qid		<> fifo_h2c_data_in.bits.tuser_qid
	qdma_inst.io.m_axis_h2c_tuser_port_id	<> fifo_h2c_data_in.bits.tuser_port_id
	qdma_inst.io.m_axis_h2c_tuser_err		<> fifo_h2c_data_in.bits.tuser_err
	qdma_inst.io.m_axis_h2c_tuser_mdata		<> fifo_h2c_data_in.bits.tuser_mdata
	qdma_inst.io.m_axis_h2c_tuser_mty		<> fifo_h2c_data_in.bits.tuser_mty
	qdma_inst.io.m_axis_h2c_tuser_zero_byte	<> fifo_h2c_data_in.bits.tuser_zero_byte
	qdma_inst.io.m_axis_h2c_tlast			<> fifo_h2c_data_in.bits.last
	qdma_inst.io.m_axis_h2c_tvalid			<> fifo_h2c_data_in.valid
	qdma_inst.io.m_axis_h2c_tready			:= fifo_h2c_data_in.ready

	qdma_inst.io.m_axib_awid.get				<> axib.aw.bits.id
	qdma_inst.io.m_axib_awaddr.get				<> axib.aw.bits.addr
	qdma_inst.io.m_axib_awlen.get				<> axib.aw.bits.len
	qdma_inst.io.m_axib_awsize.get				<> axib.aw.bits.size
	qdma_inst.io.m_axib_awburst.get				<> axib.aw.bits.burst
	qdma_inst.io.m_axib_awprot.get				<> axib.aw.bits.prot
	qdma_inst.io.m_axib_awlock.get				<> axib.aw.bits.lock
	qdma_inst.io.m_axib_awcache.get				<> axib.aw.bits.cache
	qdma_inst.io.m_axib_awvalid.get				<> axib.aw.valid
	qdma_inst.io.m_axib_awready.get				<> axib.aw.ready

	qdma_inst.io.m_axib_wdata.get				<> axib.w.bits.data
	qdma_inst.io.m_axib_wstrb.get				<> axib.w.bits.strb
	qdma_inst.io.m_axib_wlast.get				<> axib.w.bits.last
	qdma_inst.io.m_axib_wvalid.get				<> axib.w.valid
	qdma_inst.io.m_axib_wready.get				<> axib.w.ready

	qdma_inst.io.m_axib_bid.get					<> axib.b.bits.id
	qdma_inst.io.m_axib_bresp.get				<> axib.b.bits.resp
	qdma_inst.io.m_axib_bvalid.get				<> axib.b.valid
	qdma_inst.io.m_axib_bready.get				<> axib.b.ready

	qdma_inst.io.m_axib_arid.get				<> axib.ar.bits.id
	qdma_inst.io.m_axib_araddr.get				<> axib.ar.bits.addr
	qdma_inst.io.m_axib_arlen.get				<> axib.ar.bits.len
	qdma_inst.io.m_axib_arsize.get				<> axib.ar.bits.size
	qdma_inst.io.m_axib_arburst.get				<> axib.ar.bits.burst
	qdma_inst.io.m_axib_arprot.get				<> axib.ar.bits.prot
	qdma_inst.io.m_axib_arlock.get				<> axib.ar.bits.lock
	qdma_inst.io.m_axib_arcache.get				<> axib.ar.bits.cache
	qdma_inst.io.m_axib_arvalid.get				<> axib.ar.valid
	qdma_inst.io.m_axib_arready.get				<> axib.ar.ready

	qdma_inst.io.m_axib_rid.get					<> axib.r.bits.id
	qdma_inst.io.m_axib_rdata.get				<> axib.r.bits.data
	qdma_inst.io.m_axib_rresp.get				<> axib.r.bits.resp
	qdma_inst.io.m_axib_rlast.get				<> axib.r.bits.last
	qdma_inst.io.m_axib_rvalid.get				<> axib.r.valid
	qdma_inst.io.m_axib_rready.get				<> axib.r.ready

	qdma_inst.io.m_axil_awaddr				<> axil.aw.bits.addr
	qdma_inst.io.m_axil_awvalid				<> axil.aw.valid
	qdma_inst.io.m_axil_awready				<> axil.aw.ready

	qdma_inst.io.m_axil_wdata				<> axil.w.bits.data
	qdma_inst.io.m_axil_wstrb				<> axil.w.bits.strb
	qdma_inst.io.m_axil_wvalid				<> axil.w.valid
	qdma_inst.io.m_axil_wready				<> axil.w.ready

	qdma_inst.io.m_axil_bresp				<> axil.b.bits.resp
	qdma_inst.io.m_axil_bvalid				<> axil.b.valid
	qdma_inst.io.m_axil_bready				<> axil.b.ready

	qdma_inst.io.m_axil_araddr				<> axil.ar.bits.addr
	qdma_inst.io.m_axil_arvalid				<> axil.ar.valid
	qdma_inst.io.m_axil_arready				<> axil.ar.ready

	qdma_inst.io.m_axil_rdata				<> axil.r.bits.data
	qdma_inst.io.m_axil_rresp				<> axil.r.bits.resp
	qdma_inst.io.m_axil_rvalid				<> axil.r.valid
	qdma_inst.io.m_axil_rready				<> axil.r.ready

	//other

	qdma_inst.io.s_axis_c2h_cmpt_tdata					:= 0.U
	qdma_inst.io.s_axis_c2h_cmpt_size					:= 0.U
	qdma_inst.io.s_axis_c2h_cmpt_dpar					:= 0.U
	qdma_inst.io.s_axis_c2h_cmpt_tvalid					:= 0.U
	qdma_inst.io.s_axis_c2h_cmpt_ctrl_qid				:= 0.U
	qdma_inst.io.s_axis_c2h_cmpt_ctrl_cmpt_type			:= 0.U
	qdma_inst.io.s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id	:= 0.U
	if(qdma_inst.io.s_axis_c2h_cmpt_ctrl_no_wrb_marker != None){
		qdma_inst.io.s_axis_c2h_cmpt_ctrl_no_wrb_marker.get		:= 0.U	
	}
	qdma_inst.io.s_axis_c2h_cmpt_ctrl_port_id			:= 0.U
	qdma_inst.io.s_axis_c2h_cmpt_ctrl_marker			:= 0.U
	qdma_inst.io.s_axis_c2h_cmpt_ctrl_user_trig			:= 0.U
	qdma_inst.io.s_axis_c2h_cmpt_ctrl_col_idx			:= 0.U
	qdma_inst.io.s_axis_c2h_cmpt_ctrl_err_idx			:= 0.U

	qdma_inst.io.h2c_byp_out_rdy			:= 1.U
	qdma_inst.io.c2h_byp_out_rdy			:= 1.U
	qdma_inst.io.tm_dsc_sts_rdy				:= 1.U
	
	qdma_inst.io.dsc_crdt_in_vld				:= 0.U
	qdma_inst.io.dsc_crdt_in_dir				:= 0.U
	qdma_inst.io.dsc_crdt_in_fence				:= 0.U
	qdma_inst.io.dsc_crdt_in_qid				:= 0.U
	qdma_inst.io.dsc_crdt_in_crdt				:= 0.U
	
	qdma_inst.io.qsts_out_rdy					:= 1.U
	
	qdma_inst.io.usr_irq_in_vld					:= 0.U
	qdma_inst.io.usr_irq_in_vec					:= 0.U
	qdma_inst.io.usr_irq_in_fnc					:= 0.U
	//note that above rdy must be 1, otherwise qdma device can not be found in ubuntu, I don't know why

	if (SLAVE_BRIDGE) {
		qdma_inst.io.s_axib_awid.get			<> s_axib.get.aw.bits.id
		qdma_inst.io.s_axib_awaddr.get			<> s_axib.get.aw.bits.addr
		qdma_inst.io.s_axib_awlen.get			<> s_axib.get.aw.bits.len
		qdma_inst.io.s_axib_awsize.get			<> s_axib.get.aw.bits.size
		qdma_inst.io.s_axib_awburst.get			<> s_axib.get.aw.bits.burst
		qdma_inst.io.s_axib_awvalid.get			<> s_axib.get.aw.valid
		qdma_inst.io.s_axib_awready.get			<> s_axib.get.aw.ready

		qdma_inst.io.s_axib_wdata.get			<> s_axib.get.w.bits.data
		qdma_inst.io.s_axib_wstrb.get			<> s_axib.get.w.bits.strb
		qdma_inst.io.s_axib_wlast.get			<> s_axib.get.w.bits.last
		qdma_inst.io.s_axib_wvalid.get			<> s_axib.get.w.valid
		qdma_inst.io.s_axib_wready.get			<> s_axib.get.w.ready

		qdma_inst.io.s_axib_bid.get				<> s_axib.get.b.bits.id
		qdma_inst.io.s_axib_bresp.get			<> s_axib.get.b.bits.resp
		qdma_inst.io.s_axib_bvalid.get			<> s_axib.get.b.valid
		qdma_inst.io.s_axib_bready.get			<> s_axib.get.b.ready

		qdma_inst.io.s_axib_arid.get			<> s_axib.get.ar.bits.id
		qdma_inst.io.s_axib_araddr.get			<> s_axib.get.ar.bits.addr
		qdma_inst.io.s_axib_arlen.get			<> s_axib.get.ar.bits.len
		qdma_inst.io.s_axib_arsize.get			<> s_axib.get.ar.bits.size
		qdma_inst.io.s_axib_arburst.get			<> s_axib.get.ar.bits.burst
		qdma_inst.io.s_axib_arvalid.get			<> s_axib.get.ar.valid
		qdma_inst.io.s_axib_arready.get			<> s_axib.get.ar.ready

		qdma_inst.io.s_axib_rid.get				<> s_axib.get.r.bits.id
		qdma_inst.io.s_axib_rdata.get			<> s_axib.get.r.bits.data
		qdma_inst.io.s_axib_rresp.get			<> s_axib.get.r.bits.resp
		qdma_inst.io.s_axib_rlast.get			<> s_axib.get.r.bits.last
		qdma_inst.io.s_axib_rvalid.get			<> s_axib.get.r.valid
		qdma_inst.io.s_axib_rready.get			<> s_axib.get.r.ready

		qdma_inst.io.st_rx_msg_data.get	 <> DontCare
		qdma_inst.io.st_rx_msg_last.get  <> DontCare
		qdma_inst.io.st_rx_msg_rdy.get	 <> 1.U
		qdma_inst.io.st_rx_msg_valid.get <> DontCare
	}
}