package swrdma

import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._
import common.ToZero
import qdma._
import cmac._
import ddr._

class microbenchmark_sender() extends RawModule{
    
    val qdma_pin		= IO(new QDMAPin())
	val led 			= IO(Output(UInt(1.W)))
	val sys_100M_0_p	= IO(Input(Clock()))
  	val sys_100M_0_n	= IO(Input(Clock()))
   	val cmac_pin1        = IO(new CMACPin())
    val cmac_pin2        = IO(new CMACPin())
  
	
    led := 0.U

	val mmcm = Module(new MMCME4_ADV_Wrapper(
		CLKFBOUT_MULT_F 		= 20,
		MMCM_DIVCLK_DIVIDE		= 2,
		MMCM_CLKOUT0_DIVIDE_F	= 4,
		MMCM_CLKOUT1_DIVIDE_F	= 10,
		
		MMCM_CLKIN1_PERIOD 		= 10
	))
    mmcm.io.CLKIN1	:= IBUFDS(sys_100M_0_p, sys_100M_0_n)
	mmcm.io.RST		:= 0.U
	val dbg_clk 	= BUFG(mmcm.io.CLKOUT1)
	dontTouch(dbg_clk)
	val user_clk = BUFG(mmcm.io.CLKOUT0)
	val user_rstn = mmcm.io.LOCKED
	
	val DataWriterInst = withClockAndReset(user_clk, ~user_rstn.asBool){Module(new MemoryDataWriter())}
	val CallbackWriterInst = withClockAndReset(user_clk, ~user_rstn.asBool){Module(new MemoryCallbackWriter())}

	CallbackWriterInst.io.callback <> DataWriterInst.io.callback

    val qdma = Module(new QDMA(
		VIVADO_VERSION	="202101",
        PCIE_WIDTH			= 16,
		SLAVE_BRIDGE		= true,
		BRIDGE_BAR_SCALE	= "Megabytes",
		BRIDGE_BAR_SIZE 	= 4
	))
	qdma.getTCL()

	ToZero(qdma.io.reg_status)
	qdma.io.pin <> qdma_pin
	qdma.io.user_clk	:= user_clk
	qdma.io.user_arstn	:= user_rstn
    qdma.io.h2c_cmd <>DontCare
	qdma.io.h2c_data <>DontCare
	qdma.io.c2h_cmd <> DataWriterInst.io.c2hCmd
	qdma.io.c2h_data <>DataWriterInst.io.c2hData
    qdma.io.axib <> DontCare
	qdma.io.s_axib.get  <> CallbackWriterInst.io.sAxib
	
	val status_reg = qdma.io.reg_status
	Collector.connect_to_status_reg(status_reg, 400)
	val control_reg = qdma.io.reg_control


    val cmacInst1 = Module(new XCMAC(BOARD="u280", PORT=0, IP_CORE_NAME="CMACBlackBoxBase"))
	cmacInst1.getTCL()
	// Connect CMAC's pins
	cmacInst1.io.pin			<> cmac_pin1
	cmacInst1.io.drp_clk		:= dbg_clk
	cmacInst1.io.user_clk	:= user_clk   
	cmacInst1.io.user_arstn	:= user_rstn   
	cmacInst1.io.sys_reset	:= !user_rstn  
    cmacInst1.io.net_clk <> DontCare
    cmacInst1.io.net_rstn <> DontCare

    val cmacInst2 = Module(new XCMAC(BOARD="u280", PORT=1, IP_CORE_NAME="CMACBlackBoxBase"))
	cmacInst2.getTCL()
	// Connect CMAC's pins
	cmacInst2.io.pin			<> cmac_pin2
	cmacInst2.io.drp_clk		:= dbg_clk
	cmacInst2.io.user_clk	:= user_clk   
	cmacInst2.io.user_arstn	:= user_rstn   
	cmacInst2.io.sys_reset	:= !user_rstn  
    cmacInst2.io.net_clk <> DontCare
    cmacInst2.io.net_rstn <> DontCare

    


	val PkgProcInst = withClockAndReset(user_clk, ~user_rstn.asBool){Module(new PkgProc())}
	val PkgGenInst1 = withClockAndReset(user_clk, ~user_rstn.asBool){Module(new PkgGen())}
	val PkgGenInst2 = withClockAndReset(user_clk, ~user_rstn.asBool){Module(new PkgGen())}

	DataWriterInst.io.cpuReq  <> PkgProcInst.io.c2h_req
	DataWriterInst.io.memData <> PkgProcInst.io.q_time_out
	
	PkgProcInst.io.upload_length := control_reg(211)
	PkgProcInst.io.upload_vaddr := control_reg(212)
	PkgGenInst1.io.idle_cycle := PkgProcInst.io.idle_cycle
	PkgGenInst2.io.idle_cycle := PkgProcInst.io.idle_cycle
	PkgGenInst1.io.start := control_reg(213)
	PkgGenInst2.io.start := control_reg(214)
	

		
	cmacInst1.io.m_net_rx <> PkgProcInst.io.data_in
	cmacInst1.io.s_net_tx <> PkgGenInst1.io.data_out
	cmacInst2.io.m_net_rx <> DontCare
	cmacInst2.io.s_net_tx <> PkgGenInst2.io.data_out	

    
}