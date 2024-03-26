package swrdma

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class HandleTx() extends Module{
	val io = IO(new Bundle{

		val app_meta_in	        = Flipped(Decoupled(new App_meta()))
		val pkg_meta_out		= Flipped(Decoupled(new Pkg_meta()))

		val local_read_addr		= (Decoupled(new MQ_POP_REQ(UInt(64.W))))

		val event_meta_out		= (Decoupled(new Event_meta()))
	})


}