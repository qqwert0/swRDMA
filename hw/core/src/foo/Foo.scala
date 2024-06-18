package mini.foo

import chisel3._
import chisel3.util._
import qdma._
import hbm._
import common._
import common.storage._
import common.axi._
import qdma.examples._
import common.partialReconfig.AlveoStaticIO
import mini.foo._
import mini.core._
import mini.junctions._


class Foo extends Module{
	override val desiredName = "AlveoDynamicTop"
    val io = IO(Flipped(new AlveoStaticIO(
        VIVADO_VERSION = "202101", 
		QDMA_PCIE_WIDTH = 16, 
		QDMA_SLAVE_BRIDGE = false, 
		QDMA_AXI_BRIDGE = true,
		ENABLE_CMAC_1 = true
    )))

	val dbgBridgeInst = DebugBridge(IP_CORE_NAME="DebugBridgeTest", clk=clock)
	dbgBridgeInst.getTCL()

	dontTouch(io)
    io.cmacPin.get <> DontCare

	val userClk  	= Wire(Clock())
	val userRstn 	= Wire(Bool())
    
	userClk		:= clock		// 这个就是 MMC 分频之后的
	userRstn	:= ~reset.asBool

	
	// 实例化 HBM 模块
	
	val hbm_driver = withClockAndReset(io.sysClk, false.B) {Module(new HBM_DRIVER(WITH_RAMA=false, IP_CORE_NAME="HBMBlackBox"))}
	hbm_driver.getTCL()
	for (i <- 0 until 32) {
		hbm_driver.io.axi_hbm(i).hbm_init()	// Read hbm_init function if you're not familiar with AXI.
	}
	val hbm_clk = Wire(Clock())
	val hbm_rstn = Wire(Bool())
	hbm_clk := hbm_driver.io.hbm_clk
	hbm_rstn := hbm_driver.io.hbm_rstn
	dontTouch(hbm_clk)
	dontTouch(hbm_rstn)

	// 实例化 QDMA 模块
	val qdma = Module(new QDMADynamic(
		VIVADO_VERSION		= "202101",
		PCIE_WIDTH			= 16,
		SLAVE_BRIDGE		= false,
		BRIDGE_BAR_SCALE	= "Megabytes",
		BRIDGE_BAR_SIZE 	= 4
	))

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
	
	qdma.io.axib := DontCare

	val reg_control = qdma.io.reg_control
	val reg_status = qdma.io.reg_status
	val qdma_h2c_cmd = qdma.io.h2c_cmd
	val qdma_h2c_data = qdma.io.h2c_data
	val qdma_c2h_cmd = qdma.io.c2h_cmd
	val qdma_c2h_data = qdma.io.c2h_data

	val h2c = withClockAndReset(userClk, !qdma.io.user_arstn){ Module(new H2CWithAXI()) }
	h2c.io.h2c_cmd		<> qdma_h2c_cmd
	// h2c.io.h2c_data		<> qdma_h2c_data

	val c2h = withClockAndReset(userClk, !qdma.io.user_arstn){ Module(new C2HWithAXI()) }
	c2h.io.c2h_cmd		<> qdma_c2h_cmd
	// c2h.io.c2h_data		<> qdma_c2h_data

	val axi2hbm = Module(new AXIToHBM())

	axi2hbm.io.userClk	 := userClk
	axi2hbm.io.userRstn  := qdma.io.user_arstn
	axi2hbm.io.hbmClk	 := hbm_clk
	axi2hbm.io.hbmRstn	 := hbm_rstn
	hbm_driver.io.axi_hbm(0) 	<> withClockAndReset(hbm_clk,!hbm_rstn){AXIRegSlice(2)(axi2hbm.io.hbmAxi)}
	axi2hbm.io.hbmCtrlAw <> h2c.io.hbmCtrlAw
	axi2hbm.io.hbmCtrlW	 <> qdma_h2c_data
	axi2hbm.io.hbmCtrlAr <> c2h.io.hbmCtrlAr
	axi2hbm.io.hbmCtrlR	 <> qdma_c2h_data
	val count_send_word_h2c	= RegInit(UInt(32.W),0.U)
	val count_send_word_c2h	= RegInit(UInt(32.W),0.U)
	when(qdma_h2c_data.fire){
		count_send_word_h2c			:= count_send_word_h2c + 1.U
	}
	when(qdma_c2h_data.fire){
		count_send_word_c2h			:= count_send_word_c2h + 1.U
	}
	h2c.io.cur_word 	 := count_send_word_h2c
	c2h.io.cur_word 	 := count_send_word_c2h
	

	h2c.io.start_addr	:= Cat(reg_control(100), reg_control(101))
	h2c.io.length		:= reg_control(102)
	h2c.io.offset		:= reg_control(103)
	h2c.io.sop			:= reg_control(104)
	h2c.io.eop			:= reg_control(105)
	h2c.io.start		:= reg_control(106)
	h2c.io.total_words	:= reg_control(107)
	h2c.io.total_qs		:= reg_control(108)
	h2c.io.total_cmds	:= reg_control(109)
	h2c.io.range		:= reg_control(110)
	h2c.io.range_words	:= reg_control(111)
	h2c.io.is_seq		:= reg_control(112)
	h2c.io.target_addr	:= reg_control(114)

	for(i <- 0 until 16){
		h2c.io.count_word(i*32+31,i*32)	<> reg_status(102+i)
	}
	h2c.io.count_err	<> reg_status(100)
	h2c.io.count_time	<> reg_status(101)

	c2h.io.start_addr		:= Cat(reg_control(200), reg_control(201))
	c2h.io.length			:= reg_control(202)
	c2h.io.offset			:= reg_control(203)
	c2h.io.start			:= reg_control(204)
	c2h.io.total_words		:= reg_control(205)
	c2h.io.total_qs			:= reg_control(206)
	c2h.io.total_cmds		:= reg_control(207)
	c2h.io.pfch_tag			:= reg_control(209)
	c2h.io.tag_index		:= reg_control(210)
	c2h.io.target_addr		:= reg_control(214)
	
	c2h.io.count_cmd		<> reg_status(200)
	c2h.io.count_word		<> reg_status(201)
	c2h.io.count_time		<> reg_status(202)

	Collector.connect_to_status_reg(reg_status, 400)

	val cpu_started = reg_control(222)(0)
	// riscv-mini
	val config = MiniConfig()
	val mini_core = withClockAndReset(userClk, cpu_started.asBool) { 
		Module(new Tile(
		enable_hbm = config.enable_hbm,
		coreParams = config.core, 
		bramParams = config.bram,
		nastiParams = config.nasti, 
		cacheParams = config.cache
		))
	}

	reg_status(300) := mini_core.io.rdma_print_addr
	reg_status(301) := mini_core.io.rdma_print_string_num
	reg_status(302) := mini_core.io.rdma_print_string_len
	reg_status(303) := mini_core.io.rdma_trap
	mini_core.io.pkg_type_to_cc  := DontCare
	mini_core.io.user_header_len := DontCare
	mini_core.io.user_table_size := DontCare
	mini_core.io.has_event_wr := DontCare
    mini_core.io.has_event_rd := DontCare
    mini_core.io.event_recv_cnt := DontCare
    mini_core.io.event_processed_cnt := DontCare
    mini_core.io.event_type := DontCare
    mini_core.io.user_csr_wr := DontCare
    mini_core.io.user_csr_rd := DontCare

	val hbm_port = hbm_driver.io.axi_hbm(1)

	val core_axi = Wire(new AXI(33, 256, 6, 0, 4))

	core_axi.aw <> mini_core.io.nasti.aw
	core_axi.w <> mini_core.io.nasti.w
	core_axi.ar <> mini_core.io.nasti.ar
	core_axi.r <> mini_core.io.nasti.r
	core_axi.b <> mini_core.io.nasti.b

	hbm_port <> withClockAndReset(hbm_clk,!hbm_rstn){AXIRegSlice(2)(XAXIConverter(core_axi,userClk,!cpu_started.asBool,hbm_clk,hbm_rstn))}

	mini_core.io.host := DontCare

}

