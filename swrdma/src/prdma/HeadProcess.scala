package swrdma

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class HeadProcess() extends Module{
	val io = IO(new Bundle{
		val rx_data_in          = Flipped(Decoupled(new AXIS(512)))
		val meta_out	        = (Decoupled(new Pkg_meta()))
		val reth_data_out	    = (Decoupled(new AXIS(512)))
        val aeth_data_out	    = (Decoupled(new AXIS(512)))
        val raw_data_out	    = (Decoupled(new AXIS(512)))

	})


}