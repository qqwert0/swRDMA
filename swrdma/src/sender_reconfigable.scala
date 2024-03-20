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
import hbm._

class sender_reconfigable extends MultiIOModule {
	override val desiredName = "AlveoDynamicTop"
    val io = IO(Flipped(new AlveoStaticIO(
        VIVADO_VERSION = "202101", 
		QDMA_PCIE_WIDTH = 16, 
		QDMA_SLAVE_BRIDGE = true, 
		QDMA_AXI_BRIDGE = true,
		ENABLE_CMAC_1 = true,
		ENABLE_CMAC_2 = true,
		ENABLE_DDR_2=false
    )))

	val dbgBridgeInst = DebugBridge(IP_CORE_NAME="DebugBridge", clk=clock)
	dbgBridgeInst.getTCL()

	dontTouch(io)

    //* io.cmacPin.get <> DontCare

	val userClk  	= Wire(Clock())
	val userRstn 	= Wire(Bool())
    


	val qdmaInst = Module(new QDMADynamic(
		VIVADO_VERSION		= "202101",
		PCIE_WIDTH			= 16,
		SLAVE_BRIDGE		= true,
		BRIDGE_BAR_SCALE	= "Megabytes",
		BRIDGE_BAR_SIZE 	= 4
	))

    // qdma.io.s_axib.get  <> DontCare



	// ToZero(qdmaInst.io.reg_status)

    qdmaInst.io.qdma_port	<> io.qdma
	qdmaInst.io.user_clk	:= userClk
	qdmaInst.io.user_arstn	:= ~reset.asBool 

    // Init values
    qdmaInst.io.axib.ar.ready	:= 1.U
    qdmaInst.io.axib.aw.ready	:= 1.U
    qdmaInst.io.axib.w.ready	:= 1.U
    qdmaInst.io.axib.r.valid	:= 1.U
    ToZero(qdmaInst.io.axib.r.bits)
    qdmaInst.io.axib.b.valid	:= 1.U
    ToZero(qdmaInst.io.axib.b.bits)


	qdmaInst.io.h2c_data.ready	:= 0.U
	qdmaInst.io.c2h_data.valid	:= 0.U
	qdmaInst.io.c2h_data.bits	:= 0.U.asTypeOf(new C2H_DATA)

	qdmaInst.io.h2c_cmd.valid	:= 0.U
	qdmaInst.io.h2c_cmd.bits	:= 0.U.asTypeOf(new H2C_CMD)
	qdmaInst.io.c2h_cmd.valid	:= 0.U
	qdmaInst.io.c2h_cmd.bits	:= 0.U.asTypeOf(new C2H_CMD)
	
	
	
	val status_reg = qdmaInst.io.reg_status
	ToZero(status_reg)
	Collector.connect_to_status_reg(status_reg, 400)
	val control_reg = qdmaInst.io.reg_control

 	userClk		:= clock
	userRstn	:= ((~reset.asBool & ~control_reg(0)(0)).asClock).asBool

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

	
	// val ddr_rst=Wire(Bool())
    // val ddr_clk=Wire(Clock())

    // ddr_clk:=io.ddrPort2.get.clk
    // ddr_rst:=io.ddrPort2.get.rst
	// io.ddrPort2.get.axi.qdma_init()
	// io.ddrPort2.get.axi <> DontCare



	val DataWriterInst = withClockAndReset(userClk, ~userRstn.asBool){Module(new MemoryDataWriter())}
	val CallbackWriterInst = withClockAndReset(userClk, ~userRstn.asBool){Module(new MemoryCallbackWriter())}

    withClockAndReset(userClk, ~userRstn.asBool) {
        RegSlice(6)(DataWriterInst.io.c2hCmd)		<> qdmaInst.io.c2h_cmd
        RegSlice(6)(DataWriterInst.io.c2hData)	    <> qdmaInst.io.c2h_data
        AXIRegSlice(2)(CallbackWriterInst.io.sAxib)      <> qdmaInst.io.s_axib.get
    }


	CallbackWriterInst.io.callback <> DataWriterInst.io.callback

    

	val PkgProcInst = withClockAndReset(userClk, ~userRstn.asBool){Module(new PkgProc())}
	val PkgGenInst1 = withClockAndReset(userClk, ~userRstn.asBool){Module(new PkgGen())}
	val PkgGenInst2 = withClockAndReset(userClk, ~userRstn.asBool){Module(new PkgGen())}

	DataWriterInst.io.cpuReq  <> PkgProcInst.io.c2h_req
	DataWriterInst.io.memData <> PkgProcInst.io.q_time_out
	
	withClockAndReset(userClk, ~userRstn.asBool) {

		PkgProcInst.io.upload_length := RegNext(control_reg(210))
		PkgProcInst.io.upload_vaddr := Cat(control_reg(212),control_reg(211))
		PkgProcInst.io.queue_len	:= RegNext(control_reg(215))
		PkgProcInst.io.init_idle_cycle	:= RegNext(control_reg(216))
		PkgGenInst1.io.idle_cycle := RegNext(PkgProcInst.io.idle_cycle)
		PkgGenInst2.io.idle_cycle := RegNext(PkgProcInst.io.idle_cycle)
		PkgGenInst1.io.start := RegNext(control_reg(213))
		PkgGenInst2.io.start := RegNext(control_reg(214))
	}
	

		//withClockAndReset(user_clk, ~user_rstn.asBool){RegSlice(3)(
	//cmacInst.io.m_net_rx <> withClockAndReset(user_clk, ~user_rstn.asBool){RegSlice(3)(PkgProcInst.io.data_in)}
	PkgProcInst.io.data_in <> withClockAndReset(userClk, ~userRstn.asBool){RegSlice(3)(cmacInst.io.m_net_rx)}
	cmacInst.io.s_net_tx <> PkgGenInst1.io.data_out
	cmacInst2.io.m_net_rx <> DontCare
	cmacInst2.io.s_net_tx <> PkgGenInst2.io.data_out
	

	val hbmDriver = withClockAndReset(io.sysClk, false.B) {Module(new HBM_DRIVER(WITH_RAMA=false, IP_CORE_NAME="HBMBlackBox"))}
		hbmDriver.getTCL()

		for (i <- 0 until 32) {
			hbmDriver.io.axi_hbm(i).hbm_init()	// Read hbm_init function if you're not familiar with AXI.
		}


	val txdata = WireInit(0.U(160.W))
	txdata	:= cmacInst.io.s_net_tx.bits.data(159,0)
	val rxdata = WireInit(0.U(160.W))
	rxdata	:= cmacInst.io.m_net_rx.bits.data(159,0)

	class ila_net(seq:Seq[Data]) extends BaseILA(seq)	  
  	val ila_net = Module(new ila_net(Seq(	
		cmacInst.io.m_net_rx.valid,
		cmacInst.io.m_net_rx.ready,
		cmacInst.io.m_net_rx.bits.last,
		txdata,
		cmacInst.io.s_net_tx.valid,
		cmacInst.io.s_net_tx.ready,
		cmacInst.io.s_net_tx.bits.last,
		rxdata,
		PkgProcInst.io.idle_cycle
  	)))
  	ila_net.connect(userClk)
}