// package swrdma

// import common.storage._
// import common.axi._
// import chisel3._
// import chisel3.util._
// import chisel3.experimental.ChiselEnum
// import common.Collector

// class DataReader() extends Module{
// 	val io = IO(new Bundle{

// 		val meta_in	        	= Flipped(Decoupled(new Dma_meta()))

// 		val dma_out				= (Decoupled(new Dma()))
// 	})


// }