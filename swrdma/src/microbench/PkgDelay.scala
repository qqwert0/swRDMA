package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._


class PkgDelay extends Module{
			val io = IO(new Bundle{
		val in	= 0.U(32.W)
		val out = 0.U(32.W)	
	})
	io.out	<> io.in
	/*
	val io = IO(new Bundle{
		val delay_cycle = Input(UInt(32.W))
        val idle_cycle	= Input(UInt(32.W))
		val data_out	= Decoupled(new AXIS(512)) 
	})*/
}