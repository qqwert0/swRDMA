// package network.cmac

// import chisel3._
// import chisel3.util._
// import chisel3.experimental.{DataMirror, requireIsChiselType}
// import common.axi._
// import common.storage._

// class CMACPin extends Bundle{
// 	val tx_p 		= Output(UInt(4.W))
// 	val tx_n 		= Output(UInt(4.W))
// 	val rx_p 		= Input(UInt(4.W))
// 	val rx_n 		= Input(UInt(4.W))
// 	val gt_clk_p   = Input(Clock())
// 	val gt_clk_n   = Input(Clock())
// }

