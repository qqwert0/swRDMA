package qdma.examples

import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._
import common.ToZero
import common.partialReconfig.AlveoStaticIO
import qdma._

class QDMAThroughputCPUTop extends MultiIOModule {
	override val desiredName = "AlveoDynamicTop"
    val io = IO(Flipped(new AlveoStaticIO(
        VIVADO_VERSION = "202101", 
		QDMA_PCIE_WIDTH = 16, 
		QDMA_SLAVE_BRIDGE = true, 
		QDMA_AXI_BRIDGE = true,
		ENABLE_CMAC_1 = true
    )))

	val dbgBridgeInst = DebugBridge(clk=clock)
	dbgBridgeInst.getTCL()

	dontTouch(io)

    io.cmacPin.get <> DontCare

	val userClk  	= Wire(Clock())
	val userRstn 	= Wire(Bool())
    
	userClk		:= clock
	userRstn	:= ~reset.asBool

	val qdma = Module(new QDMADynamic(
		VIVADO_VERSION		= "202002",
		PCIE_WIDTH			= 16,
		SLAVE_BRIDGE		= true,
		BRIDGE_BAR_SCALE	= "Megabytes",
		BRIDGE_BAR_SIZE 	= 4
	))

    qdma.io.s_axib.get  <> DontCare

	ToZero(qdma.io.reg_status)

    qdma.io.qdma_port	<> io.qdma
	qdma.io.user_clk	:= userClk
	qdma.io.user_arstn	:= ((~reset.asBool & ~qdma.io.reg_control(0)(0)).asClock).asBool

	qdma.io.h2c_data.ready	:= 0.U
	qdma.io.c2h_data.valid	:= 0.U
	qdma.io.c2h_data.bits	:= 0.U.asTypeOf(new C2H_DATA)

	qdma.io.h2c_cmd.valid	:= 0.U
	qdma.io.h2c_cmd.bits	:= 0.U.asTypeOf(new H2C_CMD)
	qdma.io.c2h_cmd.valid	:= 0.U
	qdma.io.c2h_cmd.bits	:= 0.U.asTypeOf(new C2H_CMD)

	val axi_slave = withClockAndReset(userClk, ~userRstn.asBool) {Module(new SimpleAXISlave(new AXIB))}
	axi_slave.io.axi	<> qdma.io.axib

	val r_data = axi_slave.io.axi.r.bits.data(31,0)

    val count_w_fire = withClockAndReset(userClk, ~userRstn.asBool) {RegInit(0.U(32.W))}
    when(qdma.io.axib.w.fire){
        count_w_fire	:= count_w_fire+1.U
    }
    qdma.io.reg_status(0)	:= count_w_fire
	val control_reg = qdma.io.reg_control
	val status_reg = qdma.io.reg_status
	
	//h2c
	val h2c =  withClockAndReset(userClk, ~userRstn.asBool){Module(new H2C())}

	h2c.io.start_addr	:= Cat(control_reg(100), control_reg(101))
	h2c.io.length		:= control_reg(102)
	h2c.io.offset		:= control_reg(103)
	h2c.io.sop			:= control_reg(104)
	h2c.io.eop			:= control_reg(105)
	h2c.io.start		:= control_reg(106)
	h2c.io.total_words	:= control_reg(107)
	h2c.io.total_qs		:= control_reg(108)
	h2c.io.total_cmds	:= control_reg(109)
	h2c.io.range		:= control_reg(110)
	h2c.io.range_words	:= control_reg(111)
	h2c.io.is_seq		:= control_reg(112)

	for(i <- 0 until 16){
		h2c.io.count_word(i*32+31,i*32)	<> status_reg(102+i)
	}
	h2c.io.count_err	<> status_reg(100)
	h2c.io.count_time	<> status_reg(101)
	h2c.io.h2c_cmd		<> qdma.io.h2c_cmd
	h2c.io.h2c_data		<> qdma.io.h2c_data

	//c2h
	val c2h = withClockAndReset(userClk, ~userRstn.asBool){Module(new C2H())}

	
	c2h.io.start_addr		:= Cat(control_reg(200), control_reg(201))
	c2h.io.length			:= control_reg(202)
	c2h.io.offset			:= control_reg(203)
	c2h.io.start			:= control_reg(204)
	c2h.io.total_words		:= control_reg(205)
	c2h.io.total_qs			:= control_reg(206)
	c2h.io.total_cmds		:= control_reg(207)
	c2h.io.pfch_tag			:= control_reg(209)
	c2h.io.tag_index		:= control_reg(210)
	
	c2h.io.count_cmd		<> status_reg(200)
	c2h.io.count_word		<> status_reg(201)
	c2h.io.count_time		<> status_reg(202)
	c2h.io.c2h_cmd			<> qdma.io.c2h_cmd
	c2h.io.c2h_data			<> qdma.io.c2h_data

	Collector.connect_to_status_reg(status_reg, 400)
}
