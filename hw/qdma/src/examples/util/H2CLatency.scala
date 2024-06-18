package qdma.examples

import chisel3._
import chisel3.util._
import common.storage._
import common._
import qdma._

class H2CLatency() extends Module{
	val io = IO(new Bundle{
		val start_addr			= Input(UInt(64.W))
		val burst_length		= Input(UInt(32.W))//in bytes
		val start				= Input(UInt(32.W))

		val total_words			= Input(UInt(32.W))//total_cmds*burst_length/64
		val total_cmds			= Input(UInt(32.W))
		val wait_cycles			= Input(UInt(32.W))

		val count_err_data		= Output(UInt(32.W))
		val count_right_data	= Output(UInt(32.W))
		val count_total_words	= Output(UInt(32.W))
		val count_send_cmd		= Output(UInt(32.W))
		val count_time			= Output(UInt(32.W))
		val count_latency		= Output(UInt(64.W))

		val h2c_cmd		= Decoupled(new H2C_CMD)
		val h2c_data	= Flipped(Decoupled(new H2C_DATA))
	})

	val MAX_Q = 32

	//counters
	val count_err_data 		= RegInit(UInt(32.W),0.U)
	val count_right_data 	= RegInit(UInt(32.W),0.U)
	val count_send_cmd 		= RegInit(UInt(32.W),0.U)
	val count_total_words	= RegInit(UInt(32.W),0.U)
	val count_time			= RegInit(UInt(32.W),0.U)
	val count_latency		= RegInit(UInt(64.W),0.U)

	val count_wait			= RegInit(UInt(32.W),0.U)

	when(io.start === 1.U){
		when(count_total_words =/= io.total_words){
			count_time	:= count_time + 1.U
		}.otherwise{
			count_time	:= count_time
		}
	}.otherwise{
		count_time	:= 0.U
	}

	when(io.start === 1.U){
		when(io.h2c_cmd.fire && (io.h2c_data.fire&&io.h2c_data.bits.last)){
			count_latency	:= count_latency
		}.elsewhen(io.h2c_cmd.fire){
			count_latency	:= count_latency - count_time
		}.elsewhen(io.h2c_data.fire&&io.h2c_data.bits.last){
			count_latency	:= count_latency + count_time
		}.otherwise{
			count_latency	:= count_latency
		}
	}.otherwise{
		count_latency	:= 0.U
	}

	val offset_addr				= RegInit(UInt(32.W),0.U)
	val offset_verify			= RegInit(UInt(32.W),0.U)

	ToZero(io.h2c_cmd.bits)
	io.h2c_cmd.bits.sop			:= 1.U
	io.h2c_cmd.bits.eop			:= 1.U
	io.h2c_cmd.bits.len			:= io.burst_length
	io.h2c_cmd.bits.qid			:= 0.U
	io.h2c_cmd.bits.addr		:= io.start_addr + offset_addr

	val sIDLE :: sSEND :: sWAIT :: sDONE :: Nil = Enum(4)
	val state_cmd = RegInit(sIDLE)

	val rising_start	= io.start===1.U & !RegNext(io.start===1.U)

	switch(state_cmd){
		is(sIDLE){
			when(io.start === 1.U){
				state_cmd		:= sSEND
			}
			count_right_data	:= 0.U
			count_err_data		:= 0.U
			count_total_words	:= 0.U
			count_send_cmd		:= 0.U
			offset_addr			:= 0.U
			offset_verify		:= 0.U
		}
		is(sSEND){
			when(io.h2c_cmd.fire){
				state_cmd		:= sWAIT
			}
			count_wait			:= 0.U
		}
		is(sWAIT){
			when(count_wait === io.wait_cycles){
				state_cmd		:= sSEND
			}
			when(count_send_cmd	=== io.total_cmds){
				state_cmd		:= sDONE
			}
		}
		is(sDONE){
			when(rising_start){
				state_cmd		:= sIDLE
			}
		}
	}
	when(state_cmd === sWAIT){
		count_wait 		:= count_wait + 1.U
	}
	io.h2c_cmd.valid	:= state_cmd === sSEND
	io.h2c_data.ready	:= 1.U

	when(io.h2c_cmd.fire){
		offset_addr		:= offset_addr + io.burst_length
		count_send_cmd	:= count_send_cmd + 1.U
	}

	when(io.h2c_data.fire){
		count_total_words	:= count_total_words + 1.U
		offset_verify		:= offset_verify + 64.U
		when(io.h2c_data.bits.data === offset_verify){
			count_right_data	:= count_right_data + 1.U
		}.otherwise{
			count_err_data		:= count_err_data + 1.U
		}
	}

	io.count_err_data		:= count_err_data
	io.count_right_data		:= count_right_data
	io.count_total_words	:= count_total_words
	io.count_send_cmd		:= count_send_cmd
	io.count_time			:= count_time
	io.count_latency		:= count_latency
}