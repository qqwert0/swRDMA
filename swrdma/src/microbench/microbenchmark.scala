package swrdma

import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._
import common.ToZero
import qdma._
import cmac._

class microbenchmark_recv extends RawModule{
    val qdma_pin		= IO(new QDMAPin())
	val led 			= IO(Output(UInt(1.W)))
	val sys_100M_0_p	= IO(Input(Clock()))
  	val sys_100M_0_n	= IO(Input(Clock()))
    val camc_pin        = IO(new CMACPin())
    val cmacClk         = IO(Input(Clock()))

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

    val qdma = Module(new QDMA(		VIVADO_VERSION	="202102",
        PCIE_WIDTH			= 16,
		SLAVE_BRIDGE		= false,
		BRIDGE_BAR_SCALE	= "Megabytes",
		BRIDGE_BAR_SIZE 	= 4))
	qdma.getTCL()

	ToZero(qdma.io.reg_status)
	qdma.io.pin <> qdma_pin
	qdma.io.user_clk	:= user_clk
	qdma.io.user_arstn	:= user_rstn
    qdma.io.h2c_cmd <>DontCare
	qdma.io.h2c_data <>DontCare
	qdma.io.c2h_cmd <> DontCare
	qdma.io.c2h_data <>DontCare
    qdma.io.axib <> DontCare
	val status_reg = qdma.io.reg_status
	Collector.connect_to_status_reg(status_reg, 400)
	val control_reg = qdma.io.reg_control


    val cmacInst = Module(new XCMAC(BOARD="u280", PORT=3, IP_CORE_NAME="CMACBlackBoxBase"))
	cmacInst.getTCL()
	// Connect CMAC's pins
	cmacInst.io.pin			<> cmacPin
	cmacInst.io.drp_clk		:= cmacClk  //todo need to be checked
	cmacInst.io.user_clk	:= user_clk   
	cmacInst.io.user_arstn	:= user_rstn   
	cmacInst.io.sys_reset	:= false.B  //todo need to be modified


    //! cmacInst.io.net_clk 
    //! cmacInst.io.net_rstn 

    val PkgDelayInst = Module(new PkgDelay())
    PkgDelayInst.io.delay_cycle =   control_reg(205)        //todo need to be modified
	PkgDelayInst.io.data_in	    <>  cmacInst.io.m_net_rx.ready
	PkgDelayInst.io.data_out    <>  cmacInst.io.s_net_tx.valid 


}