package network.roce.table

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector


class CONN_TABLE() extends Module{
	val io = IO(new Bundle{
		val rx2conn_req  	= Flipped(Decoupled(new Conn_req()))
		val tx2conn_req	    = Flipped(Decoupled(new Conn_req()))
		val conn_init	    = Flipped(Decoupled(new Conn_init()))
		val conn2tx_rsp	    = (Decoupled(new Conn_rsp()))
        val conn2rx_rsp	    = (Decoupled(new Conn_rsp()))
	})



}