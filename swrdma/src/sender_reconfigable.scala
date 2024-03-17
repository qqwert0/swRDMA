package swrdma

import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._
import common.ToZero
import common.partialReconfig.AlveoStaticIO
import qdma._
import cmac._
import ddr._

class sender_reconfigable extends MultiIOModule {
	override val desiredName = "AlveoDynamicTop"
    val io = IO(Flipped(new AlveoStaticIO(
        VIVADO_VERSION = "202101", 
		QDMA_PCIE_WIDTH = 16, 
		QDMA_SLAVE_BRIDGE = false, 
		QDMA_AXI_BRIDGE = true,
		ENABLE_CMAC_1 = true,
		ENABLE_CMAC_2 = true,
		ENABLE_DDR_2=true
    )))

	val dbgBridgeInst = DebugBridge(IP_CORE_NAME="DebugBridgeBase", clk=clock)
	dbgBridgeInst.getTCL()

	dontTouch(io)

    //* io.cmacPin.get <> DontCare

	val userClk  	= Wire(Clock())
	val userRstn 	= Wire(Bool())
    
	userClk		:= clock
	userRstn	:= ~reset.asBool

	val qdma = Module(new QDMADynamic(
		VIVADO_VERSION		= "202101",
		PCIE_WIDTH			= 16,
		SLAVE_BRIDGE		= false,
		BRIDGE_BAR_SCALE	= "Megabytes",
		BRIDGE_BAR_SIZE 	= 4
	))

    //qdma.io.s_axib.get  <> DontCare

	ToZero(qdma.io.reg_status)

    qdma.io.qdma_port	<> io.qdma
	qdma.io.user_clk	:= userClk
	qdma.io.user_arstn	:= ((~reset.asBool & ~qdma.io.reg_control(0)(0)).asClock).asBool

	qdma.io.h2c_cmd <>DontCare
	qdma.io.h2c_data <>DontCare

	qdma.io.axib <> DontCare
	
	
	val status_reg = qdma.io.reg_status
	Collector.connect_to_status_reg(status_reg, 400)
	val control_reg = qdma.io.reg_control

 

    // not used cmac,but sould get it
		
	val cmacInst = Module(new XCMAC(BOARD="u280", PORT=0, IP_CORE_NAME="CMACBlackBox"))
	cmacInst.getTCL()
	// Connect CMAC's pins
	cmacInst.io.pin			<> io.cmacPin.get
	cmacInst.io.drp_clk		:= io.cmacClk.get
	cmacInst.io.user_clk	:= userClk
	cmacInst.io.user_arstn	:= userRstn
	cmacInst.io.sys_reset	:= reset
	

	
	val cmacInst2 = Module(new XCMAC(BOARD="u280", PORT=1, IP_CORE_NAME="CMACBlackBox2"))
	cmacInst2.getTCL()
	// Connect CMAC's pins
	cmacInst2.io.pin			<> io.cmacPin2.get
	cmacInst2.io.drp_clk		:= io.cmacClk.get
	cmacInst2.io.user_clk		:= userClk
	cmacInst2.io.user_arstn		:= userRstn
	cmacInst2.io.sys_reset		:= reset


    // //? DDR port
    // io.ddrPort2.get.axi<> DontCare

	
	val ddr_rst=Wire(Bool())
    val ddr_clk=Wire(Clock())

    ddr_clk:=io.ddrPort2.get.clk
    ddr_rst:=io.ddrPort2.get.rst
	io.ddrPort2.get.axi.qdma_init()
	io.ddrPort2.get.axi <> DontCare



	val DataWriterInst = withClockAndReset(userClk, ~userRstn.asBool){Module(new MemoryDataWriter())}
	val CallbackWriterInst = withClockAndReset(userClk, ~userRstn.asBool){Module(new MemoryCallbackWriter())}

    qdma.io.c2h_cmd <> DataWriterInst.io.c2hCmd
	qdma.io.c2h_data <>DataWriterInst.io.c2hData

	CallbackWriterInst.io.callback <> DataWriterInst.io.callback
    CallbackWriterInst.io.sAxib <> DontCare

	val PkgProcInst = withClockAndReset(userClk, ~userRstn.asBool){Module(new PkgProc())}
	val PkgGenInst1 = withClockAndReset(userClk, ~userRstn.asBool){Module(new PkgGen())}
	val PkgGenInst2 = withClockAndReset(userClk, ~userRstn.asBool){Module(new PkgGen())}

	DataWriterInst.io.cpuReq  <> PkgProcInst.io.c2h_req
	DataWriterInst.io.memData <> PkgProcInst.io.q_time_out
	
	PkgProcInst.io.upload_length := control_reg(210)
	PkgProcInst.io.upload_vaddr := Cat(control_reg(212),control_reg(211))
	PkgGenInst1.io.idle_cycle := PkgProcInst.io.idle_cycle
	PkgGenInst2.io.idle_cycle := PkgProcInst.io.idle_cycle
	PkgGenInst1.io.start := control_reg(213)
	PkgGenInst2.io.start := control_reg(214)
	

		//withClockAndReset(user_clk, ~user_rstn.asBool){RegSlice(3)(
	//cmacInst.io.m_net_rx <> withClockAndReset(user_clk, ~user_rstn.asBool){RegSlice(3)(PkgProcInst.io.data_in)}
	PkgProcInst.io.data_in <> withClockAndReset(userClk, ~userRstn.asBool){RegSlice(3)(cmacInst.io.m_net_rx)}
	cmacInst.io.s_net_tx <> PkgGenInst1.io.data_out
	cmacInst2.io.m_net_rx <> DontCare
	cmacInst2.io.s_net_tx <> PkgGenInst2.io.data_out
	


	class ila_net(seq:Seq[Data]) extends BaseILA(seq)	  
  	val ila_net = Module(new ila_net(Seq(	
		cmacInst.io.m_net_rx,
		cmacInst.io.s_net_tx,
		PkgProcInst.io.idle_cycle
  	)))
  	ila_net.connect(userClk)
}