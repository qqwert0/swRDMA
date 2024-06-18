package network

import chisel3._
import chisel3.util._
import common._
import network.cmac._
import common.storage._
import common.axi._
import common.ToZero
import common.connection._
import network.ip.arp._
import network.ip.ip_handler._
import network.ip.mac_ip_encode._
import network.ip.util._
import network.ip._
import network.roce._
import network.roce.util._

class NetworkStackTop extends RawModule{
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

  	val init = Wire(Bool())
    val reset = Wire(UInt(1.W))
    val send = Wire(Bool())
    val index = Wire(UInt(8.W))
    val r_index = Wire(UInt(8.W))
	val length = Wire(UInt(32.W))


	class vio_net(seq:Seq[Data]) extends BaseVIO(seq)
  	val mod_vio = Module(new vio_net(Seq(
    	init,
        reset,
        send,
        index,
        r_index,
		length
  	)))
  	mod_vio.connect(user_clk)


	val network = Module(new NetworkStack())

	cmac_pin		<> network.io.pin

	network.io.drp_clk         := dbg_clk
	network.io.user_clk	    	:= user_clk
	network.io.user_arstn	    := user_rstn
	network.io.sys_reset 		:= !user_rstn


    network.io.m_mem_read_cmd.ready        := 1.U
    network.io.m_mem_write_cmd.ready       := 1.U
    network.io.m_mem_write_data.ready      := 1.U
    ToZero(network.io.s_mem_read_data.valid)
    ToZero(network.io.s_mem_read_data.bits)
    network.io.m_recv_data.ready           := 1.U
    network.io.m_recv_meta.ready           := 1.U
    network.io.m_cmpt_meta.ready           := 1.U




	withClockAndReset(user_clk, !user_rstn){

		val status_reg = Reg(Vec(512,UInt(32.W)))
		ToZero(status_reg)
		Collector.connect_to_status_reg(status_reg,0)


		val risingStartInit					= init && RegNext(!init)
		val valid 							= RegInit(UInt(1.W),0.U)
		when(risingStartInit === 1.U){
			valid							:= 1.U
		}.elsewhen(network.io.qp_init.fire){
			valid							:= 0.U
		}

        network.io.arp_req.valid                 := valid
        network.io.arp_req.bits                  := Cat(r_index,"hbda8c0".U)
        network.io.arp_rsp.ready                 := 1.U
        network.io.ip_address                       := Cat(index,"hbda8c0".U)



		network.io.qp_init.valid				:= valid
		network.io.qp_init.bits.remote_ip		:= Cat(r_index,"hbda8c0".U)
		network.io.qp_init.bits.credit			:= 2400.U
		network.io.qp_init.bits.remote_udp_port:= 4791.U


		network.io.qp_init.bits.qpn			:= 1.U
		network.io.qp_init.bits.remote_qpn		:= 1.U
		network.io.qp_init.bits.local_psn		:= 0x1001.U
		network.io.qp_init.bits.remote_psn		:= 0x1001.U



		val risingStartSend					= send && RegNext(!send)
		val s_valid 						= RegInit(UInt(1.W),0.U)
        val data_valid 						= RegInit(UInt(1.W),0.U)
        val data_start 						= RegInit(UInt(1.W),0.U)
        val data_cnt                        = RegInit(UInt(8.W),0.U)
		when(risingStartSend === 1.U){
			s_valid							:= 1.U
		}.elsewhen(network.io.s_tx_meta.fire){
			s_valid							:= 0.U
		}

		when(risingStartSend === 1.U){
			data_start							:= 1.U
		}.elsewhen((data_cnt === (length-1.U)) & network.io.s_send_data.fire){
			data_start							:= 0.U
		}

		when((data_cnt === (length-1.U)) & network.io.s_send_data.fire){
			data_cnt							:= 0.U
		}.elsewhen(network.io.s_send_data.fire){
			data_cnt							:= data_cnt + 1.U
		}


        network.io.s_tx_meta.valid                  := s_valid
        network.io.s_tx_meta.bits.rdma_cmd          := APP_OP_CODE.APP_SEND
        network.io.s_tx_meta.bits.qpn               := 1.U
        network.io.s_tx_meta.bits.local_vaddr       := 0.U
        network.io.s_tx_meta.bits.remote_vaddr      := 0.U
        network.io.s_tx_meta.bits.length            := length*64.U

        network.io.s_send_data.valid               := data_start
        network.io.s_send_data.bits.data           := data_cnt
        network.io.s_send_data.bits.keep           := "hffffffffffffffff".U
        network.io.s_send_data.bits.last           := data_cnt === (length-1.U) & network.io.s_send_data.fire


	}
}