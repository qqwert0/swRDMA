package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._


class PkgProc extends Module{
	val io = IO(new Bundle{
        val idle_cycle	= Output(UInt(32.W))

		val data_in	= Flipped(Decoupled(new AXIS(512)))
		val q_time_out = Decoupled(new UInt(512.W))
	})



}