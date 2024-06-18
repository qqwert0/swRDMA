package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class mult_32_32() extends BlackBox{
	val io = IO(new Bundle{
		val CLK 					    = Input(Clock())

		val A				= Input(SInt(32.W))
		val B				= Input(SInt(32.W))
		val P				= Output(SInt(64.W))

	})
}

class div_32_32() extends BlackBox{
	val io = IO(new Bundle{
		val aclk 					    = Input(Clock())

		val s_axis_divisor_tvalid				= Input(UInt(1.W))
		val s_axis_divisor_tdata				= Input(SInt(32.W))
		val s_axis_dividend_tvalid				= Input(UInt(1.W))
		val s_axis_dividend_tdata				= Input(SInt(32.W))
		val m_axis_dout_tvalid				= Output(UInt(1.W))
		val m_axis_dout_tdata				= Output(SInt(64.W))                

	})
}