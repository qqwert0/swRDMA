package swrdma

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector
import common.connection._

class CusHeadProcess() extends Module{
	val io = IO(new Bundle{
		val rx_data_in          = Flipped(Decoupled(new AXIS(512)))
		val meta_in	        	= Flipped(Decoupled(new Pkg_meta()))
		val rx_data_out	    	= (Decoupled(new AXIS(512)))
		val meta_out	        = (Decoupled(new Pkg_meta()))
		val swrdma_head_choice	= Input(UInt(3.W))
	})

	val rx_data_fifo    = XQueue(new AXIS(512),64)
	rx_data_fifo.io.in <> io.rx_data_in
	val meta_fifo = XQueue(new Pkg_meta(),64)
	meta_fifo.io.in <> io.meta_in

	val s_head :: s_payload :: Nil = Enum(2)
	val state = RegInit(s_head)
	switch(state){
		is(s_head){
			when(rx_data_fifo.io.out.fire() && rx_data_fifo.io.out.bits.last =/= 1.U ){
				state := s_payload
			}.otherwise{
				state := s_head
			}
		}
		is(s_payload){
			when(rx_data_fifo.io.out.fire()&& rx_data_fifo.io.out.bits.last === 1.U){
				state := s_head
			}.otherwise{
				state := s_payload
			}
		}	
	}


	io.meta_out.bits.op_code 	 := meta_fifo.io.out.bits.op_code
	io.meta_out.bits.qpn     	 := meta_fifo.io.out.bits.qpn
	io.meta_out.bits.psn     	 := meta_fifo.io.out.bits.psn
	io.meta_out.bits.ecn     	 := meta_fifo.io.out.bits.ecn
	io.meta_out.bits.vaddr   	 := meta_fifo.io.out.bits.vaddr
	io.meta_out.bits.pkg_length  := meta_fifo.io.out.bits.pkg_length
	io.meta_out.bits.msg_length  := meta_fifo.io.out.bits.msg_length
	io.meta_out.bits.user_define := 0.U(336.W)
	switch(io.swrdma_head_choice){
		is(0.U){
			io.meta_out.bits.user_define := 0.U(336.W)
		}
		is(1.U){
			io.meta_out.bits.user_define := Cat(0.U((336-CONFIG.SWRDMA_HEADER_LEN1).W),rx_data_fifo.io.out.bits.data(CONFIG.SWRDMA_HEADER_LEN1-1,0))
		}
		is(2.U){
			io.meta_out.bits.user_define := Cat(0.U((336-CONFIG.SWRDMA_HEADER_LEN2).W),rx_data_fifo.io.out.bits.data(CONFIG.SWRDMA_HEADER_LEN2-1,0))
		}
		is(3.U){
			io.meta_out.bits.user_define := Cat(0.U((336-CONFIG.SWRDMA_HEADER_LEN3).W),rx_data_fifo.io.out.bits.data(CONFIG.SWRDMA_HEADER_LEN3-1,0))
		}
		is(4.U){
		    io.meta_out.bits.user_define := Cat(0.U((336-CONFIG.SWRDMA_HEADER_LEN4).W),rx_data_fifo.io.out.bits.data(CONFIG.SWRDMA_HEADER_LEN4-1,0))	
		}
		is(5.U){
			io.meta_out.bits.user_define := rx_data_fifo.io.out.bits.data(CONFIG.SWRDMA_HEADER_LEN5-1,0)
		}
	}

	val all_ready = io.meta_out.ready && io.rx_data_out.ready
	val all_valid = rx_data_fifo.io.out.valid && meta_fifo.io.out.valid
	io.rx_data_out.bits       := rx_data_fifo.io.out.bits

	io.meta_out.valid         := (state === s_head )  && all_ready && all_valid
	meta_fifo.io.out.ready    := (state === s_head) &&  all_ready && all_valid
	io.rx_data_out.valid      := ( rx_data_fifo.io.out.valid && state === s_payload )|| (state === s_head && all_ready && all_valid)
	rx_data_fifo.io.out.ready := (io.rx_data_out.ready && state === s_payload )|| (state === s_head && all_ready && all_valid)



}