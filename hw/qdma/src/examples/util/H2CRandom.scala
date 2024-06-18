package qdma.examples

import chisel3._
import chisel3.util._
import common.storage._
import common._
import chisel3.util.random._
import qdma._

class H2CRandom() extends Module{
	val io = IO(new Bundle{
		val start_addr			= Input(UInt(64.W))
		val burst_length		= Input(UInt(32.W))//in bytes
		val busrt_length_shift 	= Input(UInt(32.W))//log2(burst_length)
		val start				= Input(UInt(32.W))

		val total_words			= Input(UInt(32.W))//total_cmds*burst_length/64
		val total_qs			= Input(UInt(32.W))
		val total_cmds			= Input(UInt(32.W))

		val count_words			= Output(UInt(512.W))
		val count_err_data		= Output(UInt(32.W))
		val count_right_data	= Output(UInt(32.W))
		val count_total_words	= Output(UInt(32.W))
		val count_send_cmd		= Output(UInt(32.W))
		val count_time			= Output(UInt(32.W))

		val h2c_cmd		= Decoupled(new H2C_CMD)
		val h2c_data	= Flipped(Decoupled(new H2C_DATA))
	})

	val MAX_Q = 32

	//counters
	val count_err_data 		= RegInit(UInt(32.W),0.U)
	val count_right_data 	= RegInit(UInt(32.W),0.U)
	val count_send_cmd 		= RegInit(UInt(32.W),0.U)
	val count_words			= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(32.W))))
	val count_total_words	= RegInit(UInt(32.W),0.U)
	val count_time			= RegInit(UInt(32.W),0.U)

	when(io.start === 1.U){
		when(count_total_words =/= io.total_words){
			count_time	:= count_time + 1.U
		}.otherwise{
			count_time	:= count_time
		}
	}.otherwise{
		count_time	:= 0.U
	}

	//random generator
	val fifo_random 		= XQueue(UInt(32.W), 64)
	val gen_random_en 		= fifo_random.io.in.fire
	val lfsr 				= LFSR(32,gen_random_en,Some(0x67893518))
	fifo_random.io.in.valid	:= fifo_random.io.in.ready === 1.U && !reset.asUInt
	fifo_random.io.in.bits 	:= lfsr
	val align_to_1GB		= Wire(UInt(30.W))
	align_to_1GB			:= fifo_random.io.out.bits << io.busrt_length_shift(3,0) //at most shift 2^15 = 32K

	//verify fifo
	val fifo_verify_data 	= XQueue(UInt(32.W), 128)
	val verify_offset		= RegInit(UInt(32.W),0.U)
	fifo_verify_data.io.in.bits		:= align_to_1GB
	fifo_verify_data.io.in.valid	:= fifo_random.io.out.fire
	fifo_verify_data.io.out.ready	:= io.h2c_data.fire && io.h2c_data.bits.last
	
	//h2c_cmd
	val valid_cmd				= RegInit(Bool(),false.B)
	val cur_q					= RegInit(UInt(log2Up(MAX_Q).W),0.U)
	
	ToZero(io.h2c_cmd.bits)
	io.h2c_cmd.bits.sop			:= 1.U
	io.h2c_cmd.bits.eop			:= 1.U
	io.h2c_cmd.bits.len			:= io.burst_length
	io.h2c_cmd.bits.qid			:= cur_q
	io.h2c_cmd.bits.addr		:= io.start_addr + align_to_1GB 
	io.h2c_cmd.valid			:= valid_cmd & fifo_verify_data.io.in.ready //prevent data did not enter verify data
	fifo_random.io.out.ready	:= io.h2c_cmd.fire

	when(io.h2c_cmd.fire){
		count_send_cmd			:= count_send_cmd + 1.U
		when(cur_q+1.U === io.total_qs){
			cur_q := 0.U
		}.otherwise{
			cur_q	:= cur_q + 1.U
		}
	}

	//state machine
	val sIDLE :: sSEND_CMD :: sDONE :: Nil = Enum(3)//must lower case for first letter!!!
	val state_cmd			= RegInit(sIDLE)
	
	val cmd_nearly_done = io.h2c_cmd.fire && (count_send_cmd + 1.U === io.total_cmds)
	val rising_start	= io.start===1.U & !RegNext(io.start===1.U)

	switch(state_cmd){
		is(sIDLE){
			when(io.start === 1.U){
				state_cmd		:= sSEND_CMD
			}
			count_right_data	:= 0.U
			count_err_data		:= 0.U
			count_total_words	:= 0.U
			count_send_cmd		:= 0.U
			for(i<-0 until MAX_Q){
				count_words(i)	:= 0.U
			}
		}
		is(sSEND_CMD){
			valid_cmd			:= true.B
			when(cmd_nearly_done){
				state_cmd		:= sDONE
				valid_cmd		:= false.B
			}
		}
		is(sDONE){
			when(rising_start){
				state_cmd		:= sIDLE
			}
		}
	}

	io.h2c_data.ready				:= 1.U
	when(io.h2c_data.fire){
		when(io.h2c_data.bits.last){
			verify_offset		:= 0.U
		}.otherwise{
			verify_offset			:= verify_offset+64.U //each word adds 64
		}
		when(fifo_verify_data.io.out.bits+verify_offset === io.h2c_data.bits.data){
			count_right_data	:= count_right_data + 1.U
		}.otherwise{
			count_err_data		:= count_err_data + 1.U
		}
		count_total_words		:= count_total_words + 1.U
		count_words(io.h2c_data.bits.tuser_qid)	:= count_words(io.h2c_data.bits.tuser_qid) + 1.U
	}

	io.count_words			:= count_words.asUInt
	io.count_err_data		:= count_err_data
	io.count_right_data		:= count_right_data
	io.count_total_words	:= count_total_words
	io.count_send_cmd		:= count_send_cmd
	io.count_time			:= count_time
}