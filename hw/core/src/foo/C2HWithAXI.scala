package mini.foo

import chisel3._
import chisel3.util._
import qdma.examples._
import qdma._
import common.axi._
import common._

class C2HWithAXI() extends Module{
	val io = IO(new Bundle{
		val start_addr	= Input(UInt(64.W))
		val length		= Input(UInt(32.W))
		val offset		= Input(UInt(32.W))
		val start		= Input(UInt(32.W))

		val total_words	= Input(UInt(32.W))//total_cmds*length/64
		val total_qs	= Input(UInt(32.W))
		val total_cmds	= Input(UInt(32.W))
		val pfch_tag	= Input(UInt(32.W))
		val tag_index	= Input(UInt(32.W))
        // HBM 用
        val target_addr = Input(UInt(33.W))

		val cur_word	= Input(UInt(32.W))
		val count_cmd 	= Output(UInt(32.W))
		val count_word 	= Output(UInt(32.W))
		val count_time	= Output(UInt(32.W))
        
		val c2h_cmd		= Decoupled(new C2H_CMD)
		val hbmCtrlAr   = Decoupled(new AddrMsg)
	})

	val MAX_Q = 32
	
	val q_addr_seq			= RegInit(UInt(64.W),0.U)
	val tags				= RegInit(VecInit(Seq.fill(MAX_Q)(0.U(7.W))))
	
	val cur_q				= RegInit(UInt(log2Up(MAX_Q).W),0.U)
	val cur_data_q			= RegInit(UInt(log2Up(MAX_Q).W),0.U)
	val valid_cmd			= RegInit(UInt(32.W),0.U)
	val count_send_cmd		= RegInit(UInt(32.W),0.U)
	val count_time			= RegInit(UInt(32.W),0.U)
	val rising_start		= io.start===1.U & !RegNext(io.start===1.U)

	//port cmd
	val cmd_bits		= io.c2h_cmd.bits
	io.c2h_cmd.valid 	:= valid_cmd
	cmd_bits			:= 0.U.asTypeOf(new C2H_CMD)
	cmd_bits.qid		:= cur_q
	cmd_bits.addr		:= q_addr_seq

	cmd_bits.pfch_tag	:= tags(cur_q)
	cmd_bits.len		:= io.length


	when(io.tag_index === (RegNext(io.tag_index)+1.U)){
		tags(RegNext(io.tag_index))	:= io.pfch_tag
	}

	when(io.start === 1.U){
		when(io.cur_word =/= io.total_words){
			count_time	:= count_time + 1.U
		}.otherwise{
			count_time	:= count_time
		}
	}.otherwise{
		count_time	:= 0.U
	}

	//state machine
	val cmd_nearly_done = io.c2h_cmd.fire && (count_send_cmd + 1.U === io.total_cmds)

	val sIDLE :: sSEND :: sDONE :: Nil = Enum(3)
	val state_cmd			= RegInit(sIDLE)
	switch(state_cmd){
		is(sIDLE){
			count_send_cmd			:= 0.U
			cur_q					:= 0.U
			cur_data_q				:= 0.U
			q_addr_seq				:= io.start_addr
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

	when(io.c2h_cmd.fire){
		count_send_cmd		:= count_send_cmd + 1.U
		q_addr_seq			:= q_addr_seq + io.length
		
		when(cur_q+1.U === io.total_qs){
			cur_q			:= 0.U
		}.otherwise{
			cur_q			:= cur_q + 1.U
		}
	}

	val state_hbm = RegInit(sIDLE)
	val ctrl_valid = RegInit(Bool(), false.B)
	val target_addr = RegInit(UInt(33.W), 0.U)
	val length = RegInit(UInt(32.W), 0.U)
	io.hbmCtrlAr.valid := ctrl_valid
	io.hbmCtrlAr.bits.addr	:= target_addr
	io.hbmCtrlAr.bits.length	:= length
	switch(state_hbm) {
		is(sIDLE) {
			when (io.start === 1.U) {
				target_addr	:= io.target_addr
				length	:= io.length
				state_hbm := sSEND
			}.otherwise {
				ctrl_valid	:= false.B
				target_addr	:= 0.U
				length	:= 0.U
				state_hbm := sIDLE
			}
		}
		is(sSEND) {
			ctrl_valid	:= true.B
			when(io.hbmCtrlAr.fire) {
				target_addr := target_addr + io.length
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

	io.count_cmd			:= count_send_cmd
	io.count_word			:= io.cur_word
	io.count_time			:= count_time


}