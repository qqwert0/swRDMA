package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class HeadAdd() extends Module{
	val io = IO(new Bundle{
		val meta_in	        = Flipped(Decoupled(new Event_meta()))
		val reth_data_in	    = Flipped(Decoupled(new AXIS(512)))
        val aeth_data_in	    = Flipped(Decoupled(new AXIS(512)))
        val raw_data_in	    = Flipped(Decoupled(new AXIS(512)))

		val conn_state	    = Flipped(Decoupled(new Conn_state()))
        val tx_data_out	   	= (Decoupled(new AXIS(512)))

		val local_ip_address= Input(UInt(32.W))

	})

	io.meta_in.ready := 1.U
	io.reth_data_in.ready := 1.U
	io.aeth_data_in.ready := 1.U
	io.raw_data_in.ready := 1.U
	io.conn_state.ready := 1.U

	ToZero(io.tx_data_out.valid)
	ToZero(io.tx_data_out.bits)

}