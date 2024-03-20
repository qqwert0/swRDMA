package static.u280

import chisel3._
import chisel3.util._
import cmac._
import common._
import common.storage._
import common.axi._
import hbm._
import ddr._
import static._
import common.partialReconfig.AlveoStaticIO

// Module name must be AlveoDynamicTop
class U280DynamicGreyBox extends MultiIOModule {

	// Configure the parameters.

	val USE_AXI_SLAVE_BRIDGE	= true		// Turn on this if you want to enable QDMA's Slave bridge.
	val ENABLE_CMAC_1			= true		// Turn on this if you want to enable CMAC at QSFP0
	val ENABLE_CMAC_2			= true		// Turn on this if you want to enable CMAC at QSFP1
	val ENABLE_DDR_1			= false		// Turn on this if you want to enable DDR at Channel 0
	val ENABLE_DDR_2			= false		// Turn on this if you want to enable DDR at Channel 1
	val ENABLE_HBM				= true		// Turn on this if you want to enable HBM

	assert((ENABLE_DDR_1 & ENABLE_HBM) != true, "DDR1 and HBM cannot be enabled at the same time.")

	override val desiredName = "AlveoDynamicTop"
    val io = IO(Flipped(new AlveoStaticIO(
        VIVADO_VERSION		 = "202101", 
		QDMA_PCIE_WIDTH 	= 16, 
		QDMA_SLAVE_BRIDGE 	= USE_AXI_SLAVE_BRIDGE, 
		QDMA_AXI_BRIDGE 	= true,
		ENABLE_CMAC_1 		= ENABLE_CMAC_1,
		ENABLE_CMAC_2 		= ENABLE_CMAC_2,
		ENABLE_DDR_1		= ENABLE_DDR_1,
		ENABLE_DDR_2		= ENABLE_DDR_2,
    )))

	val dbgBridgeInst = DebugBridge(IP_CORE_NAME="DebugBridgeBase", clk=clock)
	dbgBridgeInst.getTCL()

	// Since this is related to partial reonfiguration,
	// All ports, no matter used or not, should be precisely defined.
	dontTouch(io)

	val userClk  	= Wire(Clock())
	val userRstn 	= Wire(Bool())

	val qdmaInst = Module(new QDMADynamic(
		VIVADO_VERSION		= "202101",
		PCIE_WIDTH			= 16,
		TLB_TYPE			= new TLB,
		SLAVE_BRIDGE		= USE_AXI_SLAVE_BRIDGE,
		BRIDGE_BAR_SCALE	= "Megabytes",
		BRIDGE_BAR_SIZE 	= 4
	))

	qdmaInst.io.qdma_port	<> io.qdma
	qdmaInst.io.user_clk	:= userClk
	qdmaInst.io.user_arstn	:= userRstn

	// Connect QDMA's pins
	val controlReg  = qdmaInst.io.reg_control
	val statusReg   = qdmaInst.io.reg_status
	ToZero(statusReg)

	userClk		:= clock
	userRstn	:= ((~reset.asBool & ~controlReg(0)(0)).asClock).asBool

    ToZero(qdmaInst.io.c2h_cmd.bits)
    qdmaInst.io.c2h_cmd.valid   := 0.U
    ToZero(qdmaInst.io.c2h_data.bits)
    qdmaInst.io.c2h_data.valid   := 0.U
    ToZero(qdmaInst.io.h2c_cmd.bits)
    qdmaInst.io.h2c_cmd.valid   := 0.U
    qdmaInst.io.h2c_data.ready  := 1.U

    // In this case AXIB is not used. Just simply init it.
    qdmaInst.io.axib.ar.ready	:= 1.U
    qdmaInst.io.axib.aw.ready	:= 1.U
    qdmaInst.io.axib.w.ready	:= 1.U
    qdmaInst.io.axib.r.valid	:= 1.U
    ToZero(qdmaInst.io.axib.r.bits)
    qdmaInst.io.axib.b.valid	:= 1.U
    ToZero(qdmaInst.io.axib.b.bits)
	if (USE_AXI_SLAVE_BRIDGE) {
		ToZero(qdmaInst.io.s_axib.get.aw.bits)
		qdmaInst.io.s_axib.get.aw.valid   := 0.U
		ToZero(qdmaInst.io.s_axib.get.w.bits)
		qdmaInst.io.s_axib.get.w.valid   := 0.U
		ToZero(qdmaInst.io.s_axib.get.ar.bits)
		qdmaInst.io.s_axib.get.ar.valid   := 0.U
		qdmaInst.io.s_axib.get.b.ready	:= 1.U
		qdmaInst.io.s_axib.get.r.ready	:= 1.U
	}

	if (ENABLE_CMAC_1) {
		val cmacInst = Module(new XCMAC(BOARD="u280", PORT=0, IP_CORE_NAME="CMACBlackBoxBase"))
		cmacInst.getTCL()

		// Connect CMAC's pins
		cmacInst.io.pin			<> io.cmacPin.get
		cmacInst.io.drp_clk		:= io.cmacClk.get
		cmacInst.io.user_clk	:= userClk
		cmacInst.io.user_arstn	:= userRstn
		cmacInst.io.sys_reset	:= reset

		cmacInst.io.m_net_rx.ready  := 1.U
		ToZero(cmacInst.io.s_net_tx.bits)
		cmacInst.io.s_net_tx.valid  := 0.U
	}

	if (ENABLE_CMAC_2) {
		val cmacInst2 = Module(new XCMAC(BOARD="u280", PORT=1, IP_CORE_NAME="CMACBlackBoxBase2"))
		cmacInst2.getTCL()

		// Connect CMAC's pins
		cmacInst2.io.pin			<> io.cmacPin2.get
		cmacInst2.io.drp_clk		:= io.cmacClk.get
		cmacInst2.io.user_clk		:= userClk
		cmacInst2.io.user_arstn		:= userRstn
		cmacInst2.io.sys_reset		:= reset

		cmacInst2.io.m_net_rx.ready  := 1.U
		ToZero(cmacInst2.io.s_net_tx.bits)
		cmacInst2.io.s_net_tx.valid  := 0.U
	}

	if (ENABLE_DDR_1) {
		// Connect DDR's ports
		io.ddrPort.get.axi.qdma_init()
	}

	if (ENABLE_DDR_2) {
		// Connect DDR's ports
		io.ddrPort2.get.axi.qdma_init()
	}

	if (ENABLE_HBM) {
		val hbmDriver = withClockAndReset(io.sysClk, false.B) {Module(new HBM_DRIVER(WITH_RAMA=false, IP_CORE_NAME="HBMBlackBoxBase"))}
		hbmDriver.getTCL()

		for (i <- 0 until 32) {
			hbmDriver.io.axi_hbm(i).hbm_init()	// Read hbm_init function if you're not familiar with AXI.
		}
	}

    Collector.connect_to_status_reg(statusReg, 400)
}