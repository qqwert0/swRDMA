package network.roce.table

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector


class VaddrTable() extends Module{
	val io = IO(new Bundle{
		val rx2vaddr_req  	= Flipped(Decoupled(new Vaddr_req()))
		val tx2vaddr_req	= Flipped(Decoupled(new Vaddr_req()))
		val vaddr2tx_rsp	    = (Decoupled(new Vaddr_rsp()))
        val vaddr2rx_rsp	    = (Decoupled(new Vaddr_rsp()))
	})



}