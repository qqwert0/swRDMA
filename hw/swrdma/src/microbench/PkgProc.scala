package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._
import common.axi._
import chisel3.util.{switch, is}

class PkgProc extends Module{
	val io = IO(new Bundle{
		val data_in	= Flipped(Decoupled(new AXIS(512))) 
    	val upload_length = Input(UInt(32.W)) 
		val upload_vaddr  =  Input(UInt(64.W)) 
		val queue_len	= Input(UInt(32.W))  
		val init_idle_cycle	= Input(UInt(32.W))     
		val idle_cycle	= Output(UInt(32.W)) 
		val q_time_out = Decoupled(UInt(512.W))
		val c2h_req      = Decoupled(new PacketRequest)
	})
	
	io.c2h_req.bits.addr := RegNext(	io.upload_vaddr)
	io.c2h_req.bits.size := RegNext(io.upload_length)	
	io.c2h_req.bits.callback := 0.U(64.W)

	val count_50us = Reg(UInt(32.W))
	val count_50us_max = 50000.U(32.W)

	val s_init :: s_wait :: s_judge :: Nil = Enum(3)
	val state1 = RegInit(s_init)
	val queue_len = RegNext(io.queue_len)
	var reg_idle_cycle = RegInit(20.U(32.W))
	io.idle_cycle := reg_idle_cycle

	var enqueue = Wire(UInt(32.W))
	enqueue := Util.reverse(io.data_in.bits.data(127,96))
	switch(state1){
		is(s_init){
			reg_idle_cycle	:= io.init_idle_cycle
			when(io.data_in.fire){
				state1:=s_judge
			}
		}		
		is(s_wait){
			when(count_50us === count_50us_max){
				state1:=s_judge
			}
		}
		is(s_judge){
			when(io.data_in.fire&& (enqueue > queue_len)){	
				reg_idle_cycle := reg_idle_cycle * 2.U
				state1:=s_wait
			}
		}
	}
	when(state1 === s_wait){
		count_50us := count_50us + 1.U
	}.otherwise{
		count_50us := 0.U
	}

	
	val s1 :: s2:: s3 :: Nil = Enum(3)
	val state2 = RegInit(s1)
	var sending_cnt = RegInit(0.U(32.W))

	switch(state2){
		is(s1){
			when(io.data_in.valid === 1.U&&io.data_in.ready === 1.U&&(enqueue > queue_len)){
				state2:=s3
			}
		}
		is(s3){
			when(io.c2h_req.valid === 1.U&&io.c2h_req.ready === 1.U){
				state2:=s2
			}
		}
		is(s2){
			when(io.data_in.valid === 1.U&&io.data_in.ready === 1.U&&sending_cnt === io.upload_length){
				state2:=s1
			}
		}
	}
	when(state2 === s2){
		sending_cnt := sending_cnt + 1.U
		io.q_time_out.valid := 1.U
	}.otherwise{
		sending_cnt := 1.U
	}

	io.c2h_req.valid := state2 === s3
	io.data_in.ready := state2 === s1 || state2 === s3  || (state2 === s2 && io.q_time_out.ready === 1.U)
	io.q_time_out.bits := io.data_in.bits.data
	io.q_time_out.valid := io.data_in.fire && state2 === s2

	// class ila_proc(seq:Seq[Data]) extends BaseILA(seq)	  
  	// val proc = Module(new ila_proc(Seq(	
	// 	state1,
	// 	state2,
	// 	enqueue,
	// 	queue_len,
	// 	io.data_in.valid,
	// 	io.data_in.ready,
	// 	reg_idle_cycle

  	// )))
  	// proc.connect(clock)

}