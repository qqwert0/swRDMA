package mini.foo

import chisel3._
import chisel3.util._
import qdma.examples._
import qdma._
import common.axi._
import common._

class H2CWithAXI() extends Module{
	val io = IO(new Bundle{
		val start_addr	= Input(UInt(64.W))
		val length		= Input(UInt(32.W))
		val offset		= Input(UInt(32.W))
		val sop			= Input(UInt(32.W))
		val eop			= Input(UInt(32.W))
		val start		= Input(UInt(32.W))


		val total_words	= Input(UInt(32.W))//total_cmds*length/64
		val total_qs	= Input(UInt(32.W))
		val total_cmds	= Input(UInt(32.W))//
		val range		= Input(UInt(32.W))
		val range_words	= Input(UInt(32.W))
		val is_seq		= Input(UInt(32.W))
		// HBM 用
		// target_hbm
        val target_addr = Input(UInt(33.W))

		val cur_word	= Input(UInt(32.W))
		val count_word	= Output(UInt(512.W))
		val count_err	= Output(UInt(32.W))
		val count_time	= Output(UInt(32.W))

		val h2c_cmd		= Decoupled(new H2C_CMD)
		val hbmCtrlAw   = Decoupled(new AddrMsg)

	})

	val MAX_Q = 32
	// 对于地址和数据，各有一个队列
	val q_addr_seq		= RegInit(UInt(64.W),0.U)
	// 每个 addr 队列，对应的起始地址和结束地址（地址范围），以及当前在操作的地址
	val q_addrs			= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(64.W))))
	val q_addr_start	= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(64.W))))
	val q_addr_end		= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(64.W))))
	val cur_q			= RegInit(UInt(log2Up(MAX_Q).W),0.U)
	val count_err		= RegInit(UInt(32.W),0.U)
	val valid_cmd		= RegInit(Bool(),false.B)

	val send_cmd_count	= RegInit(UInt(32.W),0.U)
	val count_time		= RegInit(UInt(32.W),0.U)


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
	

	//state machine
	val sIDLE :: sSEND_CMD :: sDONE :: Nil = Enum(3)//must lower case for first letter!!!
	val state_cmd			= RegInit(sIDLE)

	val cmd_nearly_done = io.h2c_cmd.fire && (send_cmd_count + 1.U === io.total_cmds)

	when(io.start === 1.U){
		when(io.cur_word =/= io.total_words){
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
			q_addr_seq			:= io.start_addr
			// q_value_seq			:= io.offset
			for(i <- 0 until MAX_Q){
				q_addrs(i)		:= io.start_addr + i.U * io.range
				q_addr_start(i)	:= io.start_addr + i.U * io.range
				q_addr_end(i)	:= io.start_addr + (i.U+&1.U) * io.range
				// q_values(i)		:= q_value_start(i)
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

		when(cur_q+1.U === io.total_qs){
			cur_q	:= 0.U
		}.otherwise{
			cur_q	:= cur_q + 1.U
		}
	}

	val state_hbm = RegInit(sIDLE)
	val ctrl_valid = RegInit(Bool(), false.B)
	val target_addr = RegInit(UInt(33.W), 0.U)
	val length = RegInit(UInt(32.W), 0.U)
	io.hbmCtrlAw.bits.addr	:= target_addr
	io.hbmCtrlAw.bits.length	:= length

	switch(state_hbm) {
		is(sIDLE) {
			when (io.start === 1.U) {
				target_addr	:= io.target_addr
				length	:= io.length
				state_hbm := sSEND_CMD
			}.otherwise {
				ctrl_valid	:= false.B
				target_addr	:= 0.U
				length	:= 0.U
				state_hbm := sIDLE
			}
		}
		is(sSEND_CMD) {
			ctrl_valid	:= true.B
			when(io.hbmCtrlAw.fire) {
				target_addr := target_addr + io.length
				// ctrl_valid	:= false.B
			}
			when(cmd_nearly_done) {
				state_hbm := sDONE
				ctrl_valid	:= false.B
			}
		}
		is(sDONE) {
			when(rising_start) {
				state_hbm := sIDLE
			}
		}
	}
	io.hbmCtrlAw.valid := ctrl_valid

	io.count_err		:= 0.U
	io.count_word		:= io.cur_word.asUInt
	io.count_time		:= count_time
}