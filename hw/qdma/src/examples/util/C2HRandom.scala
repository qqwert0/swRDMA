package qdma.examples

import chisel3._
import chisel3.util._
import common.storage._
import common._
import chisel3.util.random._
import qdma._

class C2HRandom extends Module{
	val io = IO(new Bundle{
		val start_addr				= Input(UInt(64.W))
		val burst_length			= Input(UInt(32.W))
		val busrt_length_shift		= Input(UInt(32.W))
		val start					= Input(UInt(32.W))

		val total_words				= Input(UInt(32.W))//total_cmds*length/64
		val total_qs				= Input(UInt(32.W))
		val total_cmds				= Input(UInt(32.W))

		val pfch_tag				= Input(UInt(32.W))
		val tag_index				= Input(UInt(32.W))

		val count_send_cmds 		= Output(UInt(32.W))
		val count_send_words 		= Output(UInt(32.W))
		val count_time				= Output(UInt(32.W))

		val c2h_cmd		= Decoupled(new C2H_CMD)
		val c2h_data	= Decoupled(new C2H_DATA) 
	})

	val MAX_Q = 32
	val cur_q_cmd				= RegInit(UInt(log2Up(MAX_Q).W),0.U)
	val cur_q_data				= RegInit(UInt(log2Up(MAX_Q).W),0.U)
	val tags					= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(7.W))))
	val rising_start			= io.start===1.U & !RegNext(io.start===1.U)

	when(io.tag_index === (RegNext(io.tag_index)+1.U)){
		tags(RegNext(io.tag_index))	:= io.pfch_tag
	}

	//random generator
	val fifo_random 			= XQueue(UInt(32.W), 64)
	val gen_random_en 			= fifo_random.io.in.fire
	val lfsr 					= LFSR(32,gen_random_en,Some(0x67893518))
	fifo_random.io.in.valid		:= fifo_random.io.in.ready === 1.U && !reset.asUInt
	fifo_random.io.in.bits 		:= lfsr
	val align_to_1GB			= Wire(UInt(30.W))
	align_to_1GB				:= fifo_random.io.out.bits << io.busrt_length_shift(3,0) //at most shift 2^15 = 32K
	fifo_random.io.out.ready	:= io.c2h_cmd.fire

	//data fifo
	val fifo_data				= XQueue(UInt(32.W), 64)
	fifo_data.io.in.bits		:= align_to_1GB
	fifo_data.io.in.valid		:= fifo_random.io.out.fire

	//counters
	val count_time			= RegInit(UInt(32.W),0.U)
	val count_send_cmds		= RegInit(UInt(32.W),0.U)
	val count_send_words	= RegInit(UInt(32.W),0.U)
	val valid_cmd			= RegInit(UInt(32.W),0.U)
	val valid_data			= RegInit(UInt(32.W),0.U)
	val offset_data			= RegInit(UInt(32.W),0.U)

	//cmd
	ToZero(io.c2h_cmd.bits)
	io.c2h_cmd.bits.qid			:= cur_q_cmd
	io.c2h_cmd.bits.pfch_tag	:= tags(cur_q_cmd)
	io.c2h_cmd.bits.addr		:= io.start_addr + align_to_1GB
	io.c2h_cmd.bits.len			:= io.burst_length
	io.c2h_cmd.valid			:= valid_cmd & fifo_data.io.in.ready //prevent addr data did not enter fifo_data

	//data
	ToZero(io.c2h_data.bits)
	io.c2h_data.valid			:= valid_data & fifo_data.io.out.valid //prevent issue unwanted data
	io.c2h_data.bits.ctrl_qid	:= cur_q_data
	io.c2h_data.bits.data		:= fifo_data.io.out.bits + offset_data


	when(io.start === 1.U){
		when(count_send_words =/= io.total_words){
			count_time	:= count_time + 1.U
		}.otherwise{
			count_time	:= count_time
		}
	}.otherwise{
		count_time	:= 0.U
	}

	//state machine
	val cmd_nearly_done = io.c2h_cmd.fire && (count_send_cmds + 1.U === io.total_cmds)
	val data_nearly_done = io.c2h_data.fire && (count_send_words + 1.U === io.total_words)

	val sIDLE :: sSEND :: sDONE :: Nil = Enum(3)
	val state_cmd			= RegInit(sIDLE)
	val state_data			= RegInit(sIDLE)
	switch(state_cmd){
		is(sIDLE){
			count_send_cmds			:= 0.U
			count_send_words		:= 0.U
			cur_q_cmd				:= 0.U
			cur_q_data				:= 0.U
			when(io.start===1.U){
				state_cmd			:= sSEND
			}
		}
		is(sSEND){
			valid_cmd				:= true.B
			when(cmd_nearly_done){
				state_cmd			:= sDONE
				valid_cmd			:= false.B
			}
		}
		is(sDONE){
			when(rising_start){
				state_cmd		:= sIDLE
			}
		}
	}

	switch(state_data){
		is(sIDLE){
			when(io.start === 1.U){
				state_data		:= sSEND
			}
		}
		is(sSEND){
			valid_data			:= true.B 
			when(data_nearly_done){
				state_data		:= sDONE
				valid_data		:= false.B
			}
		}
		is(sDONE){
			when(rising_start){
				state_data		:= sIDLE
			}
		}
	}

	when(io.c2h_cmd.fire){
		count_send_cmds		:= count_send_cmds + 1.U
		when(cur_q_cmd+1.U === io.total_qs){
			cur_q_cmd		:= 0.U
		}.otherwise{
			cur_q_cmd		:= cur_q_cmd + 1.U
		}
	}

	when(io.c2h_data.fire){
		count_send_words			:= count_send_words + 1.U
		when(offset_data+64.U === io.burst_length){
			io.c2h_data.bits.last	:= 1.U
			offset_data		:= 0.U
			when(cur_q_data+1.U === io.total_qs){
				cur_q_data			:= 0.U
			}.otherwise{
				cur_q_data			:= cur_q_data + 1.U
			}
		}.otherwise{
			offset_data				:= offset_data + 64.U
		}
	}

	when(io.c2h_data.fire && offset_data+64.U === io.burst_length){
		fifo_data.io.out.ready	:= 1.U
	}.otherwise{
		fifo_data.io.out.ready	:= 0.U
	}

	io.count_send_cmds	:= count_send_cmds
	io.count_send_words	:= count_send_words
	io.count_time		:= count_time
}