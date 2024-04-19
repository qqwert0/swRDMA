package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class Schedule() extends Module{
	val io = IO(new Bundle{

		val meta_in	        	= Flipped(Decoupled(new Event_meta()))
		val cc_req          	= (Decoupled(new CC_req()))
		val event_meta_out		= (Decoupled(new Event_meta()))
	})

	val meta_fifo = XQueue(new Event_meta(), entries=16)
	io.meta_in 		    <> meta_fifo.io.in


	meta_fifo.io.out.ready				:= io.cc_req.ready & io.event_meta_out.ready

	ToZero(io.cc_req.valid)
	ToZero(io.cc_req.bits)
	ToZero(io.event_meta_out.valid)
	ToZero(io.event_meta_out.bits)


	when(meta_fifo.io.out.fire){
		io.cc_req.valid					:= 1.U
		io.cc_req.bits.qpn				:= meta_fifo.io.out.bits.qpn
		io.cc_req.bits.is_wr			:= false.B
		io.cc_req.bits.lock				:= true.B
		io.event_meta_out.valid			:= 1.U
		io.event_meta_out.bits			:= meta_fifo.io.out.bits
	}
}