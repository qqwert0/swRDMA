package cmac

import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._
import common.ToZero

class CMACTop extends RawModule{
	val cmac_pin		= IO(new CMACPin())
	val led 			= IO(Output(UInt(1.W)))
	val sys_100M_0_p	= IO(Input(Clock()))
  	val sys_100M_0_n	= IO(Input(Clock()))

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

	val cmac = Module(new XCMAC())
	cmac.getTCL()

	cmac_pin		<> cmac.io.pin
	

	cmac.io.m_net_rx.ready := 1.U

	val rx_data = Wire(UInt(32.W))
	rx_data			:= cmac.io.m_net_rx.bits.data(31,0)
  	class ila_rx(seq:Seq[Data]) extends BaseILA(seq)
  	val mod_rx = Module(new ila_rx(Seq(	
		cmac.io.m_net_rx.valid,
	  	cmac.io.m_net_rx.ready,
    	rx_data,
    	cmac.io.m_net_rx.bits.last
  	)))
  	mod_rx.connect(user_clk)


	class ila_tx(seq:Seq[Data]) extends BaseILA(seq)	  
  	val tx = Module(new ila_tx(Seq(	
		cmac.io.s_net_tx.valid,
	  	cmac.io.s_net_tx.ready,
    	cmac.io.s_net_tx.bits.last
  	)))
  	tx.connect(user_clk)

  	val send = Wire(Bool())
	
	class vio_net(seq:Seq[Data]) extends BaseVIO(seq)
  	val mod_vio = Module(new vio_net(Seq(
    	send
  	)))
  	mod_vio.connect(user_clk)

	withClockAndReset(user_clk,!user_rstn){
		// val rst_delay_cnt = RegInit(0.U(32.W))
		// val cmac_sys_reset = RegInit(true.B)

		// when(rst_delay_cnt === 25000000.U){
		// 	rst_delay_cnt		:= rst_delay_cnt
		// }.otherwise{
		// 	rst_delay_cnt		:= rst_delay_cnt + 1.U
		// }

		// when(rst_delay_cnt === 25000000.U){
		// 	cmac_sys_reset		:= false.B
		// }.otherwise{
		// 	cmac_sys_reset		:= true.B
		// }

		cmac.io.sys_reset 	<> !user_rstn


		val data_cnt = RegInit(0.U(16.W))
		val tx_valid = RegInit(0.U(1.W))
		when(cmac.io.s_net_tx.fire()){
			when(data_cnt === 20.U){
				data_cnt	:= 0.U
			}.otherwise{
				data_cnt	:= data_cnt + 1.U;
			}
		}

		when((!RegNext(send))&send){
			tx_valid	:= 1.U
		}.elsewhen(data_cnt === 20.U){
			tx_valid	:= 0.U
		}.otherwise{
			tx_valid	:= tx_valid
		}	
		cmac.io.s_net_tx.valid 	:= tx_valid
		cmac.io.s_net_tx.bits.data		:= data_cnt
		cmac.io.s_net_tx.bits.keep		:= "hffffffffffffffff".U
		cmac.io.s_net_tx.bits.last		:= cmac.io.s_net_tx.fire() & (data_cnt === 20.U)
	}	  


	

    cmac.io.drp_clk         := dbg_clk
	cmac.io.user_clk	    := user_clk
	cmac.io.user_arstn	    := user_rstn

}