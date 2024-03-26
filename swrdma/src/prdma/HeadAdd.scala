package swrdma

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class HeadAdd() extends Module{
	val io = IO(new Bundle{
		val meta_in	        = Flipped(Decoupled(new Event_meta()))
		val data_in			= Flipped(Decoupled(new AXIS(512)))

		val conn_rsp	    = Flipped(Decoupled(new Conn_rsp()))
        val tx_data_out	   	= (Decoupled(new AXIS(512)))

	})


}