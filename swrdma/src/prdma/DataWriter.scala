package swrdma

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class DataWriter() extends Module{
	val io = IO(new Bundle{

		val meta_in	        	= Flipped(Decoupled(new Dma_meta()))

		val vaddr_req 			= (Decoupled(new Vaddr_req()))
		val vaddr_rsp 			= Flipped(Decoupled(new Vaddr_rsp()))
        
		val read_req_pop_req  	= (Decoupled(UInt(24.W)))
		val read_req_pop_rsp  	= Flipped(Decoupled(new MQ_POP_RSP(UInt(64.W))))

		val dma_out				= (Decoupled(new Dma()))
	})


}