package qdma.examples

import chisel3._
import chisel3.util._
import qdma._

class H2C() extends Module{
	val io = IO(new Bundle{
		val start_addr	= Input(UInt(64.W))
		val length		= Input(UInt(32.W))
		val offset		= Input(UInt(32.W))
		val sop			= Input(UInt(32.W))
		val eop			= Input(UInt(32.W))
		val start		= Input(UInt(32.W))


		val total_words	= Input(UInt(32.W))//total_cmds*length/64
		val total_qs	= Input(UInt(32.W))
		val total_cmds	= Input(UInt(32.W))
		val range		= Input(UInt(32.W))
		val range_words	= Input(UInt(32.W))
		val is_seq		= Input(UInt(32.W))

		val count_word	= Output(UInt(512.W))
		val count_err	= Output(UInt(32.W))
		val count_time	= Output(UInt(32.W))

		val h2c_cmd		= Decoupled(new H2C_CMD)
		val h2c_data	= Flipped(Decoupled(new H2C_DATA))
	})

	val MAX_Q = 32

	val q_addr_seq		= RegInit(UInt(64.W),0.U)
	val q_value_seq		= RegInit(UInt(32.W),0.U)
	val count_word		= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(32.W))))
	val q_values		= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(32.W))))
	val q_value_max		= VecInit(Seq.fill(MAX_Q)(0.U(32.W)))
	val q_value_start	= VecInit(Seq.fill(MAX_Q)(0.U(32.W)))
	val q_addrs			= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(64.W))))
	val q_addr_start	= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(64.W))))
	val q_addr_end		= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(64.W))))
	val cur_q			= RegInit(UInt(log2Up(MAX_Q).W),0.U)
	val count_err		= RegInit(UInt(32.W),0.U)
	val valid_cmd		= RegInit(Bool(),false.B)

	val send_cmd_count	= RegInit(UInt(32.W),0.U)
	val count_time		= RegInit(UInt(32.W),0.U)
	val cur_word		= RegInit(UInt(32.W),0.U)


	val rising_start	= io.start===1.U & !RegNext(io.start===1.U)
	

	//cmd
	val cmd_bits		= io.h2c_cmd.bits
	cmd_bits			:= 0.U.asTypeOf(new H2C_CMD)
	cmd_bits.sop		:= (io.sop===1.U)
	cmd_bits.eop		:= (io.eop===1.U)
	cmd_bits.len		:= io.length
	cmd_bits.qid		:= cur_q
	when(io.is_seq === 1.U){
		cmd_bits.addr		:= q_addr_seq
	}.otherwise{
		cmd_bits.addr		:= q_addrs(cur_q)
	}
	io.h2c_cmd.valid	:= valid_cmd
	

	//data
	val data_bits		= io.h2c_data.bits
	io.h2c_data.ready	:= true.B

	//state machine
	val sIDLE :: sSEND_CMD :: sDONE :: Nil = Enum(3)//must lower case for first letter!!!
	val state_cmd			= RegInit(sIDLE)

	val cmd_nearly_done = io.h2c_cmd.fire && (send_cmd_count + 1.U === io.total_cmds)

	for(i <- 0 until MAX_Q){
		q_value_max(i)			:= io.offset + i.U + io.range_words
		q_value_start(i)		:= io.offset + i.U
	}

	when(io.start === 1.U){
		when(cur_word =/= io.total_words){
			count_time	:= count_time + 1.U
		}.otherwise{
			count_time	:= count_time
		}
		
	}.otherwise{
		count_time	:= 0.U
	}

	switch(state_cmd){
		is(sIDLE){
			send_cmd_count		:= 0.U
			valid_cmd			:= false.B
			cur_q				:= 0.U
			count_err			:= 0.U
			cur_word			:= 0.U
			q_addr_seq			:= io.start_addr
			q_value_seq			:= io.offset
			for(i <- 0 until MAX_Q){
				q_addrs(i)		:= io.start_addr + i.U * io.range
				q_addr_start(i)	:= io.start_addr + i.U * io.range
				q_addr_end(i)	:= io.start_addr + (i.U+&1.U) * io.range
				q_values(i)		:= q_value_start(i)
				count_word(i)	:= 0.U
			}
			when(io.start===1.U){
				state_cmd		:= sSEND_CMD
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

	when(io.h2c_cmd.fire){
		send_cmd_count	:= send_cmd_count + 1.U
		q_addr_seq		:= q_addr_seq + io.length

		for(i <- 0 until MAX_Q){
			when(cur_q === i.U){
				when(q_addrs(i) + io.length === q_addr_end(i)){
					q_addrs(i)	:= q_addr_start(i)
				}.otherwise{
					q_addrs(i)	:= q_addrs(i) + io.length
				}
			}
		}

		// when(q_addrs(cur_q)+io.length === q_addr_end(cur_q)){
		// 	q_addrs(cur_q)	:= q_addr_start(cur_q)
		// }.otherwise{
		// 	q_addrs(cur_q)	:= q_addrs(cur_q) + io.length
		// }
		when(cur_q+1.U === io.total_qs){
			cur_q	:= 0.U
		}.otherwise{
			cur_q	:= cur_q + 1.U
		}
	}

	when(io.h2c_data.fire){
		cur_word							:= cur_word + 1.U
		count_word(data_bits.tuser_qid)		:= count_word(data_bits.tuser_qid) + 1.U
		q_value_seq							:= q_value_seq + 1.U
		when((q_values(data_bits.tuser_qid)+1.U) === q_value_max(data_bits.tuser_qid) ){
			q_values(data_bits.tuser_qid)		:= q_value_start(data_bits.tuser_qid)
		}.otherwise{
			q_values(data_bits.tuser_qid)		:= q_values(data_bits.tuser_qid) + 1.U
		}
		when(io.is_seq === 1.U){
			when(Cat(Seq.fill(16)(q_value_seq)).asUInt =/= data_bits.data){
				count_err		:= count_err + 1.U
			}
		}.otherwise{
			when(Cat(Seq.fill(16)(q_values(data_bits.tuser_qid))).asUInt =/= data_bits.data){
				count_err		:= count_err + 1.U
			}
		}
	}

	io.count_err		:= count_err
	io.count_word		:= count_word.asUInt
	io.count_time		:= count_time
}