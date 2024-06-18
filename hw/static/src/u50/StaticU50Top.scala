package static.u50

import chisel3._
import chisel3.util._
import qdma.{QDMAPin, QDMABlackBox}
import common.CMACPin
// import hbm.HBMBlackBox
import common._
import static._
import qdma.AXIB_SLAVE

class StaticU50Top extends RawModule {

	// Configure the parameters.

	val USE_AXI_SLAVE_BRIDGE	= false		// Turn on this if you want to enable QDMA's Slave bridge.
	val ENABLE_CMAC 			= true		// Turn on this if you want to enable CMAC

	// I/O ports.

	// Board system clocks.
	val sysClkP			= IO(Input(Clock()))
	val sysClkN			= IO(Input(Clock()))
	// PCIe-related clocks and resets are here, including pcie refclk and pcie perstn.
	val qdmaPin 		= IO(new QDMAPin(PCIE_WIDTH=8))
	// CMAC pins, including gt clocks.
	val cmacPin			= if (ENABLE_CMAC) Some(IO(new CMACPin())) else None
	// LED, now it just hangs.
	val hbmCattrip		= IO(Output(UInt(1.W)))

	// System clock conversion

	val sysClk 		= BUFG(IBUFDS(sysClkP, sysClkN))

	val userClk  	= Wire(Clock())
	val userRstn 	= Wire(Bool())

	hbmCattrip	:= 0.U

	// Basic I/O Modules

	// QDMA
	val instQdma = Module(new QDMABlackBox(
		VIVADO_VERSION = "202101", 
		PCIE_WIDTH = 8, 
		SLAVE_BRIDGE = USE_AXI_SLAVE_BRIDGE, 
		AXI_BRIDGE = true
	))

	val ibufds_gte4_inst = Module(new IBUFDS_GTE4(REFCLK_HROW_CK_SEL=0))
	ibufds_gte4_inst.io.IB		:= qdmaPin.sys_clk_n
	ibufds_gte4_inst.io.I		:= qdmaPin.sys_clk_p
	ibufds_gte4_inst.io.CEB		:= 0.U
	val pcie_ref_clk_gt			= ibufds_gte4_inst.io.O
	val pcie_ref_clk			= ibufds_gte4_inst.io.ODIV2

	instQdma.io.sys_rst_n	:= IBUF(qdmaPin.sys_rst_n)
	instQdma.io.sys_clk		:= pcie_ref_clk
	instQdma.io.sys_clk_gt	:= pcie_ref_clk_gt
	
	instQdma.io.pci_exp_txn	<> qdmaPin.tx_n
	instQdma.io.pci_exp_txp	<> qdmaPin.tx_p
	instQdma.io.pci_exp_rxn	:= qdmaPin.rx_n
	instQdma.io.pci_exp_rxp	:= qdmaPin.rx_p

	val mmcmUsrClk	= Module(new MMCME4_ADV_Wrapper(
		CLKFBOUT_MULT_F 		= 11.875,
		MMCM_DIVCLK_DIVIDE		= 1,
		MMCM_CLKOUT0_DIVIDE_F	= 4.75,
		MMCM_CLKIN1_PERIOD 		= 10
	))

	mmcmUsrClk.io.CLKIN1	:= sysClk
	mmcmUsrClk.io.RST		:= 0.U
	userClk		:= mmcmUsrClk.io.CLKOUT0
	userRstn	:= mmcmUsrClk.io.LOCKED.asBool

	// Dynamic part inputs

	val core = Module(new AlveoDynamicBlackBox(
		SLAVE_BRIDGE  = USE_AXI_SLAVE_BRIDGE,
		ENABLE_CMAC_1 = ENABLE_CMAC
	))

	withClockAndReset(userClk, ~userRstn) {	// Function barrier to prevent method too large
		core.io.clock	:= userClk.asUInt
		core.io.reset	:= ~userRstn
		core.io.io_sysClk			:= sysClk.asUInt

		if (ENABLE_CMAC) {
			core.io.io_cmacPin_tx_p.get		<> cmacPin.get.tx_p
			core.io.io_cmacPin_tx_n.get		<> cmacPin.get.tx_n
			core.io.io_cmacPin_rx_p.get		<> cmacPin.get.rx_p
			core.io.io_cmacPin_rx_n.get		<> cmacPin.get.rx_n
			core.io.io_cmacPin_gt_clk_p.get	<> cmacPin.get.gt_clk_p.asUInt
			core.io.io_cmacPin_gt_clk_n.get	<> cmacPin.get.gt_clk_n.asUInt
		}
		// core.io.io_hbmClk	:= hbmClk.asUInt
		// core.io.io_hbmRstn	:= hbmRstn
		core.io.io_qdma_axi_aclk							 <> instQdma.io.axi_aclk.asUInt
		core.io.io_qdma_axi_aresetn							 <> instQdma.io.axi_aresetn
		core.io.io_qdma_m_axib_awid                          <> instQdma.io.m_axib_awid.get
		core.io.io_qdma_m_axib_awaddr                        <> instQdma.io.m_axib_awaddr.get
		core.io.io_qdma_m_axib_awlen                         <> instQdma.io.m_axib_awlen.get
		core.io.io_qdma_m_axib_awsize                        <> instQdma.io.m_axib_awsize.get
		core.io.io_qdma_m_axib_awburst                       <> instQdma.io.m_axib_awburst.get
		core.io.io_qdma_m_axib_awprot                        <> instQdma.io.m_axib_awprot.get
		core.io.io_qdma_m_axib_awlock                        <> instQdma.io.m_axib_awlock.get
		core.io.io_qdma_m_axib_awcache                       <> instQdma.io.m_axib_awcache.get
		core.io.io_qdma_m_axib_awvalid                       <> instQdma.io.m_axib_awvalid.get
		core.io.io_qdma_m_axib_awready                       <> instQdma.io.m_axib_awready.get
		core.io.io_qdma_m_axib_wdata                         <> instQdma.io.m_axib_wdata.get
		core.io.io_qdma_m_axib_wstrb                         <> instQdma.io.m_axib_wstrb.get
		core.io.io_qdma_m_axib_wlast                         <> instQdma.io.m_axib_wlast.get
		core.io.io_qdma_m_axib_wvalid                        <> instQdma.io.m_axib_wvalid.get
		core.io.io_qdma_m_axib_wready                        <> instQdma.io.m_axib_wready.get
		core.io.io_qdma_m_axib_bid                           <> instQdma.io.m_axib_bid.get
		core.io.io_qdma_m_axib_bresp                         <> instQdma.io.m_axib_bresp.get
		core.io.io_qdma_m_axib_bvalid                        <> instQdma.io.m_axib_bvalid.get
		core.io.io_qdma_m_axib_bready                        <> instQdma.io.m_axib_bready.get
		core.io.io_qdma_m_axib_arid                          <> instQdma.io.m_axib_arid.get
		core.io.io_qdma_m_axib_araddr                        <> instQdma.io.m_axib_araddr.get
		core.io.io_qdma_m_axib_arlen                         <> instQdma.io.m_axib_arlen.get
		core.io.io_qdma_m_axib_arsize                        <> instQdma.io.m_axib_arsize.get
		core.io.io_qdma_m_axib_arburst                       <> instQdma.io.m_axib_arburst.get
		core.io.io_qdma_m_axib_arprot                        <> instQdma.io.m_axib_arprot.get
		core.io.io_qdma_m_axib_arlock                        <> instQdma.io.m_axib_arlock.get
		core.io.io_qdma_m_axib_arcache                       <> instQdma.io.m_axib_arcache.get
		core.io.io_qdma_m_axib_arvalid                       <> instQdma.io.m_axib_arvalid.get
		core.io.io_qdma_m_axib_arready                       <> instQdma.io.m_axib_arready.get
		core.io.io_qdma_m_axib_rid                           <> instQdma.io.m_axib_rid.get
		core.io.io_qdma_m_axib_rdata                         <> instQdma.io.m_axib_rdata.get
		core.io.io_qdma_m_axib_rresp                         <> instQdma.io.m_axib_rresp.get
		core.io.io_qdma_m_axib_rlast                         <> instQdma.io.m_axib_rlast.get
		core.io.io_qdma_m_axib_rvalid                        <> instQdma.io.m_axib_rvalid.get
		core.io.io_qdma_m_axib_rready                        <> instQdma.io.m_axib_rready.get
		core.io.io_qdma_m_axil_awaddr                        <> instQdma.io.m_axil_awaddr
		core.io.io_qdma_m_axil_awvalid                       <> instQdma.io.m_axil_awvalid
		core.io.io_qdma_m_axil_awready                       <> instQdma.io.m_axil_awready
		core.io.io_qdma_m_axil_wdata                         <> instQdma.io.m_axil_wdata
		core.io.io_qdma_m_axil_wstrb                         <> instQdma.io.m_axil_wstrb
		core.io.io_qdma_m_axil_wvalid                        <> instQdma.io.m_axil_wvalid
		core.io.io_qdma_m_axil_wready                        <> instQdma.io.m_axil_wready
		core.io.io_qdma_m_axil_bresp                         <> instQdma.io.m_axil_bresp
		core.io.io_qdma_m_axil_bvalid                        <> instQdma.io.m_axil_bvalid
		core.io.io_qdma_m_axil_bready                        <> instQdma.io.m_axil_bready
		core.io.io_qdma_m_axil_araddr                        <> instQdma.io.m_axil_araddr
		core.io.io_qdma_m_axil_arvalid                       <> instQdma.io.m_axil_arvalid
		core.io.io_qdma_m_axil_arready                       <> instQdma.io.m_axil_arready
		core.io.io_qdma_m_axil_rdata                         <> instQdma.io.m_axil_rdata
		core.io.io_qdma_m_axil_rresp                         <> instQdma.io.m_axil_rresp
		core.io.io_qdma_m_axil_rvalid                        <> instQdma.io.m_axil_rvalid
		core.io.io_qdma_m_axil_rready                        <> instQdma.io.m_axil_rready
		core.io.io_qdma_soft_reset_n                         <> instQdma.io.soft_reset_n
		core.io.io_qdma_h2c_byp_in_st_addr                   <> instQdma.io.h2c_byp_in_st_addr
		core.io.io_qdma_h2c_byp_in_st_len                    <> instQdma.io.h2c_byp_in_st_len
		core.io.io_qdma_h2c_byp_in_st_eop                    <> instQdma.io.h2c_byp_in_st_eop
		core.io.io_qdma_h2c_byp_in_st_sop                    <> instQdma.io.h2c_byp_in_st_sop
		core.io.io_qdma_h2c_byp_in_st_mrkr_req               <> instQdma.io.h2c_byp_in_st_mrkr_req
		core.io.io_qdma_h2c_byp_in_st_sdi                    <> instQdma.io.h2c_byp_in_st_sdi
		core.io.io_qdma_h2c_byp_in_st_qid                    <> instQdma.io.h2c_byp_in_st_qid
		core.io.io_qdma_h2c_byp_in_st_error                  <> instQdma.io.h2c_byp_in_st_error
		core.io.io_qdma_h2c_byp_in_st_func                   <> instQdma.io.h2c_byp_in_st_func
		core.io.io_qdma_h2c_byp_in_st_cidx                   <> instQdma.io.h2c_byp_in_st_cidx
		core.io.io_qdma_h2c_byp_in_st_port_id                <> instQdma.io.h2c_byp_in_st_port_id
		core.io.io_qdma_h2c_byp_in_st_no_dma                 <> instQdma.io.h2c_byp_in_st_no_dma
		core.io.io_qdma_h2c_byp_in_st_vld                    <> instQdma.io.h2c_byp_in_st_vld
		core.io.io_qdma_h2c_byp_in_st_rdy                    <> instQdma.io.h2c_byp_in_st_rdy
		core.io.io_qdma_c2h_byp_in_st_csh_addr               <> instQdma.io.c2h_byp_in_st_csh_addr
		core.io.io_qdma_c2h_byp_in_st_csh_qid                <> instQdma.io.c2h_byp_in_st_csh_qid
		core.io.io_qdma_c2h_byp_in_st_csh_error              <> instQdma.io.c2h_byp_in_st_csh_error
		core.io.io_qdma_c2h_byp_in_st_csh_func               <> instQdma.io.c2h_byp_in_st_csh_func
		core.io.io_qdma_c2h_byp_in_st_csh_port_id            <> instQdma.io.c2h_byp_in_st_csh_port_id
		core.io.io_qdma_c2h_byp_in_st_csh_pfch_tag           <> instQdma.io.c2h_byp_in_st_csh_pfch_tag
		core.io.io_qdma_c2h_byp_in_st_csh_vld                <> instQdma.io.c2h_byp_in_st_csh_vld
		core.io.io_qdma_c2h_byp_in_st_csh_rdy                <> instQdma.io.c2h_byp_in_st_csh_rdy
		core.io.io_qdma_s_axis_c2h_tdata                     <> instQdma.io.s_axis_c2h_tdata
		core.io.io_qdma_s_axis_c2h_tcrc                      <> instQdma.io.s_axis_c2h_tcrc
		core.io.io_qdma_s_axis_c2h_ctrl_marker               <> instQdma.io.s_axis_c2h_ctrl_marker
		core.io.io_qdma_s_axis_c2h_ctrl_ecc                  <> instQdma.io.s_axis_c2h_ctrl_ecc
		core.io.io_qdma_s_axis_c2h_ctrl_len                  <> instQdma.io.s_axis_c2h_ctrl_len
		core.io.io_qdma_s_axis_c2h_ctrl_port_id              <> instQdma.io.s_axis_c2h_ctrl_port_id
		core.io.io_qdma_s_axis_c2h_ctrl_qid                  <> instQdma.io.s_axis_c2h_ctrl_qid
		core.io.io_qdma_s_axis_c2h_ctrl_has_cmpt             <> instQdma.io.s_axis_c2h_ctrl_has_cmpt
		core.io.io_qdma_s_axis_c2h_mty                       <> instQdma.io.s_axis_c2h_mty
		core.io.io_qdma_s_axis_c2h_tlast                     <> instQdma.io.s_axis_c2h_tlast
		core.io.io_qdma_s_axis_c2h_tvalid                    <> instQdma.io.s_axis_c2h_tvalid
		core.io.io_qdma_s_axis_c2h_tready                    <> instQdma.io.s_axis_c2h_tready
		core.io.io_qdma_m_axis_h2c_tdata                     <> instQdma.io.m_axis_h2c_tdata
		core.io.io_qdma_m_axis_h2c_tcrc                      <> instQdma.io.m_axis_h2c_tcrc
		core.io.io_qdma_m_axis_h2c_tuser_qid                 <> instQdma.io.m_axis_h2c_tuser_qid
		core.io.io_qdma_m_axis_h2c_tuser_port_id             <> instQdma.io.m_axis_h2c_tuser_port_id
		core.io.io_qdma_m_axis_h2c_tuser_err                 <> instQdma.io.m_axis_h2c_tuser_err
		core.io.io_qdma_m_axis_h2c_tuser_mdata               <> instQdma.io.m_axis_h2c_tuser_mdata
		core.io.io_qdma_m_axis_h2c_tuser_mty                 <> instQdma.io.m_axis_h2c_tuser_mty
		core.io.io_qdma_m_axis_h2c_tuser_zero_byte           <> instQdma.io.m_axis_h2c_tuser_zero_byte
		core.io.io_qdma_m_axis_h2c_tlast                     <> instQdma.io.m_axis_h2c_tlast
		core.io.io_qdma_m_axis_h2c_tvalid                    <> instQdma.io.m_axis_h2c_tvalid
		core.io.io_qdma_m_axis_h2c_tready                    <> instQdma.io.m_axis_h2c_tready
		core.io.io_qdma_axis_c2h_status_drop                 <> instQdma.io.axis_c2h_status_drop
		core.io.io_qdma_axis_c2h_status_last                 <> instQdma.io.axis_c2h_status_last
		core.io.io_qdma_axis_c2h_status_cmp                  <> instQdma.io.axis_c2h_status_cmp
		core.io.io_qdma_axis_c2h_status_valid                <> instQdma.io.axis_c2h_status_valid
		core.io.io_qdma_axis_c2h_status_qid                  <> instQdma.io.axis_c2h_status_qid
		core.io.io_qdma_s_axis_c2h_cmpt_tdata                <> instQdma.io.s_axis_c2h_cmpt_tdata
		core.io.io_qdma_s_axis_c2h_cmpt_size                 <> instQdma.io.s_axis_c2h_cmpt_size
		core.io.io_qdma_s_axis_c2h_cmpt_dpar                 <> instQdma.io.s_axis_c2h_cmpt_dpar
		core.io.io_qdma_s_axis_c2h_cmpt_tvalid               <> instQdma.io.s_axis_c2h_cmpt_tvalid
		core.io.io_qdma_s_axis_c2h_cmpt_tready               <> instQdma.io.s_axis_c2h_cmpt_tready
		core.io.io_qdma_s_axis_c2h_cmpt_ctrl_qid             <> instQdma.io.s_axis_c2h_cmpt_ctrl_qid
		core.io.io_qdma_s_axis_c2h_cmpt_ctrl_cmpt_type       <> instQdma.io.s_axis_c2h_cmpt_ctrl_cmpt_type
		core.io.io_qdma_s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id <> instQdma.io.s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id
		core.io.io_qdma_s_axis_c2h_cmpt_ctrl_no_wrb_marker   <> instQdma.io.s_axis_c2h_cmpt_ctrl_no_wrb_marker.get
		core.io.io_qdma_s_axis_c2h_cmpt_ctrl_port_id         <> instQdma.io.s_axis_c2h_cmpt_ctrl_port_id
		core.io.io_qdma_s_axis_c2h_cmpt_ctrl_marker          <> instQdma.io.s_axis_c2h_cmpt_ctrl_marker
		core.io.io_qdma_s_axis_c2h_cmpt_ctrl_user_trig       <> instQdma.io.s_axis_c2h_cmpt_ctrl_user_trig
		core.io.io_qdma_s_axis_c2h_cmpt_ctrl_col_idx         <> instQdma.io.s_axis_c2h_cmpt_ctrl_col_idx
		core.io.io_qdma_s_axis_c2h_cmpt_ctrl_err_idx         <> instQdma.io.s_axis_c2h_cmpt_ctrl_err_idx
		core.io.io_qdma_h2c_byp_out_rdy                      <> instQdma.io.h2c_byp_out_rdy
		core.io.io_qdma_c2h_byp_out_rdy                      <> instQdma.io.c2h_byp_out_rdy
		core.io.io_qdma_tm_dsc_sts_rdy                       <> instQdma.io.tm_dsc_sts_rdy
		core.io.io_qdma_dsc_crdt_in_vld                      <> instQdma.io.dsc_crdt_in_vld
		core.io.io_qdma_dsc_crdt_in_rdy                      <> instQdma.io.dsc_crdt_in_rdy
		core.io.io_qdma_dsc_crdt_in_dir                      <> instQdma.io.dsc_crdt_in_dir
		core.io.io_qdma_dsc_crdt_in_fence                    <> instQdma.io.dsc_crdt_in_fence
		core.io.io_qdma_dsc_crdt_in_qid                      <> instQdma.io.dsc_crdt_in_qid
		core.io.io_qdma_dsc_crdt_in_crdt                     <> instQdma.io.dsc_crdt_in_crdt
		core.io.io_qdma_qsts_out_rdy                         <> instQdma.io.qsts_out_rdy
		core.io.io_qdma_usr_irq_in_vld                       <> instQdma.io.usr_irq_in_vld
		core.io.io_qdma_usr_irq_in_vec                       <> instQdma.io.usr_irq_in_vec
		core.io.io_qdma_usr_irq_in_fnc                       <> instQdma.io.usr_irq_in_fnc
		core.io.io_qdma_usr_irq_out_ack                      <> instQdma.io.usr_irq_out_ack
		core.io.io_qdma_usr_irq_out_fail                     <> instQdma.io.usr_irq_out_fail
		if (USE_AXI_SLAVE_BRIDGE) {
			core.io.io_qdma_s_axib_awid.get                  <> instQdma.io.s_axib_awid.get
			core.io.io_qdma_s_axib_awaddr.get                <> instQdma.io.s_axib_awaddr.get
			core.io.io_qdma_s_axib_awlen.get                 <> instQdma.io.s_axib_awlen.get
			core.io.io_qdma_s_axib_awsize.get                <> instQdma.io.s_axib_awsize.get
			core.io.io_qdma_s_axib_awuser.get                <> instQdma.io.s_axib_awuser.get
			core.io.io_qdma_s_axib_awburst.get               <> instQdma.io.s_axib_awburst.get
			core.io.io_qdma_s_axib_awregion.get              <> instQdma.io.s_axib_awregion.get
			core.io.io_qdma_s_axib_awvalid.get               <> instQdma.io.s_axib_awvalid.get
			core.io.io_qdma_s_axib_awready.get               <> instQdma.io.s_axib_awready.get
			core.io.io_qdma_s_axib_wdata.get                 <> instQdma.io.s_axib_wdata.get
			core.io.io_qdma_s_axib_wstrb.get                 <> instQdma.io.s_axib_wstrb.get
			core.io.io_qdma_s_axib_wuser.get                 <> instQdma.io.s_axib_wuser.get
			core.io.io_qdma_s_axib_wlast.get                 <> instQdma.io.s_axib_wlast.get
			core.io.io_qdma_s_axib_wvalid.get                <> instQdma.io.s_axib_wvalid.get
			core.io.io_qdma_s_axib_wready.get                <> instQdma.io.s_axib_wready.get
			core.io.io_qdma_s_axib_bid.get                   <> instQdma.io.s_axib_bid.get
			core.io.io_qdma_s_axib_bresp.get                 <> instQdma.io.s_axib_bresp.get
			core.io.io_qdma_s_axib_bvalid.get                <> instQdma.io.s_axib_bvalid.get
			core.io.io_qdma_s_axib_bready.get                <> instQdma.io.s_axib_bready.get
			core.io.io_qdma_s_axib_arid.get                  <> instQdma.io.s_axib_arid.get
			core.io.io_qdma_s_axib_araddr.get                <> instQdma.io.s_axib_araddr.get
			core.io.io_qdma_s_axib_arlen.get                 <> instQdma.io.s_axib_arlen.get
			core.io.io_qdma_s_axib_arsize.get                <> instQdma.io.s_axib_arsize.get
			core.io.io_qdma_s_axib_aruser.get                <> instQdma.io.s_axib_aruser.get
			core.io.io_qdma_s_axib_arburst.get               <> instQdma.io.s_axib_arburst.get
			core.io.io_qdma_s_axib_arregion.get              <> instQdma.io.s_axib_arregion.get
			core.io.io_qdma_s_axib_arvalid.get               <> instQdma.io.s_axib_arvalid.get
			core.io.io_qdma_s_axib_arready.get               <> instQdma.io.s_axib_arready.get
			core.io.io_qdma_s_axib_rid.get                   <> instQdma.io.s_axib_rid.get
			core.io.io_qdma_s_axib_rdata.get                 <> instQdma.io.s_axib_rdata.get
			core.io.io_qdma_s_axib_rresp.get                 <> instQdma.io.s_axib_rresp.get
			core.io.io_qdma_s_axib_ruser.get                 <> instQdma.io.s_axib_ruser.get
			core.io.io_qdma_s_axib_rlast.get                 <> instQdma.io.s_axib_rlast.get
			core.io.io_qdma_s_axib_rvalid.get                <> instQdma.io.s_axib_rvalid.get
			core.io.io_qdma_s_axib_rready.get                <> instQdma.io.s_axib_rready.get
			core.io.io_qdma_st_rx_msg_data.get               <> instQdma.io.st_rx_msg_data.get
			core.io.io_qdma_st_rx_msg_last.get               <> instQdma.io.st_rx_msg_last.get
			core.io.io_qdma_st_rx_msg_rdy.get                <> instQdma.io.st_rx_msg_rdy.get
			core.io.io_qdma_st_rx_msg_valid.get              <> instQdma.io.st_rx_msg_valid.get
		}
	}

	core.io.S_BSCAN_drck		<> DontCare
	core.io.S_BSCAN_shift		<> DontCare
	core.io.S_BSCAN_tdi			<> DontCare
	core.io.S_BSCAN_update		<> DontCare
	core.io.S_BSCAN_sel			<> DontCare
	core.io.S_BSCAN_tdo			<> DontCare
	core.io.S_BSCAN_tms			<> DontCare
	core.io.S_BSCAN_tck			<> DontCare
	core.io.S_BSCAN_runtest		<> DontCare
	core.io.S_BSCAN_reset		<> DontCare
	core.io.S_BSCAN_capture		<> DontCare
	core.io.S_BSCAN_bscanid_en	<> DontCare
}