package qdma.examples

import chisel3._
import chisel3.util._
import common.storage._
import common._
import chisel3.util.random._
import qdma._

class C2HLatency extends Module{
	val io = IO(new Bundle{
		val start_addr				= Input(UInt(64.W))
		val burst_length			= Input(UInt(32.W))
		val offset					= Input(UInt(32.W))
		val start					= Input(UInt(32.W))

		val total_words				= Input(UInt(32.W))//total_cmds*burst_length/64
		val total_cmds				= Input(UInt(32.W))
		val wait_cycles				= Input(UInt(32.W))

		val pfch_tag				= Input(UInt(32.W))
		val tag_index				= Input(UInt(32.W))

		val ack_fire				= Input(UInt(1.W))

		val count_send_cmd	 		= Output(UInt(32.W))
		val count_send_word 		= Output(UInt(32.W))
		val count_time				= Output(UInt(32.W))
		val count_latency_cmd		= Output(UInt(64.W))
		val count_latency_data		= Output(UInt(64.W))
		val count_recv_ack			= Output(UInt(32.W))

		val c2h_cmd		= Decoupled(new C2H_CMD)
		val c2h_data	= Decoupled(new C2H_DATA) 
	})

	val MAX_Q = 32
	val tags					= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(7.W))))
	val rising_start			= io.start===1.U & !RegNext(io.start===1.U)

	//counters
	val count_time			= RegInit(UInt(32.W),0.U)
	val count_send_cmd		= RegInit(UInt(32.W),0.U)
	val count_send_word		= RegInit(UInt(32.W),0.U)
	val count_latency_cmd	= RegInit(UInt(64.W),0.U)
	val count_latency_data	= RegInit(UInt(64.W),0.U)
	val count_recv_ack		= RegInit(UInt(32.W),0.U)

	val count_wait				= RegInit(UInt(32.W),0.U)
	val count_bytes_in_burst	= RegInit(UInt(32.W),0.U)

	val offset_addr				= RegInit(UInt(32.W),0.U)
	val offset_data				= RegInit(UInt(32.W),0.U)

	val data_fire_last_beat = io.c2h_data.fire && io.c2h_data.bits.last
	val ack_fire = io.ack_fire===1.U
	
	when(io.start === 1.U){
		when(count_recv_ack =/= io.total_cmds){
			count_time	:= count_time + 1.U
		}.otherwise{
			count_time	:= count_time
		}
	}.otherwise{
		count_time	:= 0.U
	}

	when(io.start === 1.U){
		when(ack_fire){
			count_recv_ack	:= count_recv_ack + 1.U
		}
	}.otherwise{
		count_recv_ack	:= 0.U
	}

	when(io.start === 1.U){
		when(io.c2h_cmd.fire && ack_fire){
			count_latency_cmd	:= count_latency_cmd
		}.elsewhen(io.c2h_cmd.fire){
			count_latency_cmd	:= count_latency_cmd - count_time
		}.elsewhen(ack_fire){
			count_latency_cmd	:= count_latency_cmd + count_time
		}.otherwise{
			count_latency_cmd	:= count_latency_cmd
		}
	}.otherwise{
		count_latency_cmd		:= 0.U
	}

	
	when(io.start === 1.U){
		when(data_fire_last_beat && ack_fire){
			count_latency_data	:= count_latency_data
		}.elsewhen(data_fire_last_beat){
			count_latency_data	:= count_latency_data - count_time
		}.elsewhen(ack_fire){
			count_latency_data	:= count_latency_data + count_time
		}.otherwise{
			count_latency_data	:= count_latency_data
		}
	}.otherwise{
		count_latency_data		:= 0.U
	}

	when(io.tag_index === (RegNext(io.tag_index)+1.U)){
		tags(RegNext(io.tag_index))	:= io.pfch_tag
	}

	//cmd
	ToZero(io.c2h_cmd.bits)
	io.c2h_cmd.bits.pfch_tag	:= tags(0.U)//qid == 0
	io.c2h_cmd.bits.addr		:= io.start_addr + offset_addr
	io.c2h_cmd.bits.len			:= io.burst_length

	//data
	ToZero(io.c2h_data.bits)
	io.c2h_data.bits.data		:= offset_data

	val sIDLE :: sSEND :: sWAIT :: sDONE :: Nil = Enum(4)
	val state_cmd			= RegInit(sIDLE)
	val state_data			= RegInit(sIDLE)
	
	switch(state_cmd){
		is(sIDLE){
			when(io.start === 1.U){
				state_cmd	:= sSEND
			}
			count_send_cmd			:= 0.U
			count_send_word			:= 0.U
			offset_addr				:= 0.U
			offset_data				:= io.offset
		}
		is(sSEND){
			when(io.c2h_cmd.fire){
				state_cmd	:= sWAIT
			}
			count_wait 		:= 0.U
		}
		is(sWAIT){
			when(count_wait === io.wait_cycles){
				state_cmd	:= sSEND
			}
			when(count_send_cmd	=== io.total_cmds){
				state_cmd	:= sDONE
			}
		}
		is(sDONE){
			when(rising_start){
				state_cmd	:= sIDLE
			}
		}
	}
	io.c2h_cmd.valid	:= state_cmd === sSEND
	when(state_cmd === sWAIT){
		count_wait 		:= count_wait + 1.U
	}

	switch(state_data){
		is(sIDLE){
			when(io.start === 1.U){
				state_data		:= sSEND
			}
		}
		is(sSEND){
			when(io.c2h_data.fire && (count_send_word + 1.U === io.total_words)){
				state_data		:= sDONE
			}
		}
		is(sDONE){
			when(rising_start){
				state_data		:= sIDLE
			}
		}
	}
	io.c2h_data.valid	:= state_data === sSEND

	when(io.c2h_cmd.fire){
		offset_addr		:= offset_addr + io.burst_length
		count_send_cmd	:= count_send_cmd + 1.U
	}

	when(io.c2h_data.fire){
		count_send_word	:= count_send_word + 1.U
		offset_data		:= offset_data + 64.U

		when(count_bytes_in_burst + 64.U === io.burst_length){
			io.c2h_data.bits.last	:= 1.U
			count_bytes_in_burst	:= 0.U //reset
		}.otherwise{
			count_bytes_in_burst	:= count_bytes_in_burst + 64.U
		}
	}

	io.count_send_cmd		:= count_send_cmd
	io.count_send_word		:= count_send_word
	io.count_time			:= count_time
	io.count_latency_cmd	:= count_latency_cmd
	io.count_latency_data	:= count_latency_data
	io.count_recv_ack		:= count_recv_ack
}