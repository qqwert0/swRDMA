package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class add_process_sim() extends Module{
    val io = IO(new Bundle{
        val meta_in	            = Flipped(Decoupled(new Event_meta()))
		val reth_data_in	    = Flipped(Decoupled(new AXIS(512)))
        val aeth_data_in	    = Flipped(Decoupled(new AXIS(512)))
        val raw_data_in	        = Flipped(Decoupled(new AXIS(512)))
		val conn_state	        = Flipped(Decoupled(new Conn_state()))
		val local_ip_address    = Input(UInt(32.W))

        val meta_out	        = (Decoupled(new Pkg_meta()))
		val reth_data_out	    = (Decoupled(new AXIS(512)))
        val aeth_data_out	    = (Decoupled(new AXIS(512)))
        val raw_data_out	    = (Decoupled(new AXIS(512)))
    })

    val head_add = Module(new HeadAdd())
    val head_process = Module(new HeadProcess())
    val data = Wire(Decoupled(new AXIS(512)))

    head_add.io.meta_in <> io.meta_in
    head_add.io.reth_data_in <> io.reth_data_in
    head_add.io.aeth_data_in <> io.aeth_data_in
    head_add.io.raw_data_in <> io.raw_data_in
    head_add.io.conn_state <> io.conn_state
    head_add.io.local_ip_address := io.local_ip_address
    head_add.io.tx_data_out <> data

    head_process.io.rx_data_in <> data
    head_process.io.meta_out <> io.meta_out
    head_process.io.reth_data_out <> io.reth_data_out
    head_process.io.aeth_data_out <> io.aeth_data_out
    head_process.io.raw_data_out <> io.raw_data_out
    

}