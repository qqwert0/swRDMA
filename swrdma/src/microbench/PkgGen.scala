package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._


class PkgGen extends Module{
	val io = IO(new Bundle{
		val start        = Input(UInt(1.W))
        val data_in	    = Flipped(Decoupled(new AXIS(512)))
		val data_out	= Decoupled(new AXIS(512)) 
	})
}