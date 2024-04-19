package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class TxDispatch() extends Module{
	val io = IO(new Bundle{

		val meta_in	        	= Flipped(Decoupled(new Event_meta()))
		val conn_req 			= (Decoupled(new Conn_req()))
		val dma_meta_out		= (Decoupled(new Dma()))
		val event_meta_out		= (Decoupled(new Event_meta()))
	})

	val meta_fifo = XQueue(new Event_meta(), entries=16)
	io.meta_in 		    <> meta_fifo.io.in


	meta_fifo.io.out.ready				:= io.conn_req.ready & io.event_meta_out.ready & io.dma_meta_out.ready

	ToZero(io.conn_req.valid)
	ToZero(io.conn_req.bits)
	ToZero(io.dma_meta_out.valid)
	ToZero(io.dma_meta_out.bits)
	ToZero(io.event_meta_out.valid)
	ToZero(io.event_meta_out.bits)


	when(meta_fifo.io.out.fire){
		io.conn_req.valid				:= 1.U
		io.conn_req.bits.qpn			:= meta_fifo.io.out.bits.qpn
		io.conn_req.bits.is_wr			:= false.B
		io.event_meta_out.valid			:= 1.U
		io.event_meta_out.bits			:= meta_fifo.io.out.bits
		when(PKG_JUDGE.HAVE_DATA(meta_fifo.io.out.bits.op_code)){
			io.dma_meta_out.valid		:= 1.U
			io.dma_meta_out.bits.vaddr	:= meta_fifo.io.out.bits.l_vaddr
			io.dma_meta_out.bits.length	:= meta_fifo.io.out.bits.pkg_length
		}
	}
	



}