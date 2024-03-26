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

		val meta_in	        	= Flipped(Decoupled(new Pkg_meta()))

		val conn_req 			= (Decoupled(new Conn_req()))
		val conn_rsp 			= Flipped(Decoupled(new Conn_rsp()))

		val drop_meta_out	    = (Decoupled(new Drop_meta()))
		val cc_meta_out			= (Decoupled(new CC_meta()))
		val dma_meta_out		= (Decoupled(new Dma_meta()))
		val event_meta_out		= (Decoupled(new Pkg_meta()))
	})


}