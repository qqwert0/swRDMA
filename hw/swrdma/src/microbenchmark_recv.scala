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

class microbenchmark_recv() extends RawModule{
    
	val led 			= IO(Output(UInt(1.W)))
	val sys_100M_0_p	= IO(Input(Clock()))
  	val sys_100M_0_n	= IO(Input(Clock()))
   	val cmac_pin        = IO(new CMACPin())
  
	
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
	




    val cmacInst = Module(new XCMAC(BOARD="u280", PORT=1, IP_CORE_NAME="CMACBlackBoxBase"))
	cmacInst.getTCL()
	// Connect CMAC's pins
	cmacInst.io.pin			<> cmac_pin
	cmacInst.io.drp_clk		:= dbg_clk
	cmacInst.io.user_clk	:= user_clk   
	cmacInst.io.user_arstn	:= user_rstn   
	cmacInst.io.sys_reset	:= !user_rstn  


    cmacInst.io.net_clk <> DontCare
    cmacInst.io.net_rstn <> DontCare

    val PkgDelayInst = withClockAndReset(user_clk, ~user_rstn.asBool){Module(new PkgDelay())}
    //PkgDelayInst.io.delay_cycle :=   control_reg(211)        //todo need to be modified
	PkgDelayInst.io.data_in	    <>  cmacInst.io.m_net_rx
	PkgDelayInst.io.data_out    <>  cmacInst.io.s_net_tx

	class ila_tx(seq:Seq[Data]) extends BaseILA(seq)	  
  	val tx = Module(new ila_tx(Seq(	
		cmacInst.io.m_net_rx,
		cmacInst.io.s_net_tx
  	)))
  	tx.connect(user_clk)

	class vio_nx(seq:Seq[Data]) extends BaseVIO(seq)	  
  	val nx = Module(new vio_nx(Seq(	
		PkgDelayInst.io.delay_cycle
  	)))
  	nx.connect(user_clk)

}