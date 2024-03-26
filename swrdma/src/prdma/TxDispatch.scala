package swrdma

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class RxDispatch() extends Module{
	val io = IO(new Bundle{

		val meta_in	        	= Flipped(Decoupled(new Event_meta()))

		val conn_req 			= (Decoupled(new Conn_req()))

		val dma_meta_out		= (Decoupled(new Dma_meta()))
		val event_meta_out		= (Decoupled(new Event_meta()))
	})


}