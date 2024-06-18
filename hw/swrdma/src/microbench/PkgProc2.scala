package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._
import common.axi._
import chisel3.util.{switch, is}

class PkgProc2 extends Module{
	val io = IO(new Bundle{
		val data_in	= Flipped(Decoupled(new AXIS(512))) 
    	val upload_length = Input(UInt(32.W)) 
		val upload_vaddr  =  Input(UInt(64.W)) 
		val queue_len	= Input(UInt(32.W))  
		val init_idle_cycle	= Input(UInt(32.W))  
		val timer		= Input(UInt(64.W))   
		val base_rtt	= Input(UInt(32.W))
		val max_rate	= Input(UInt(32.W))
		val idle_cycle	= Output(UInt(32.W)) 
		val q_time_out = Decoupled(UInt(512.W))
		val c2h_req      = Decoupled(new PacketRequest)
	})
	
	Collector.fire(io.data_in)
	Collector.fire(io.q_time_out)

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

	val timer	= RegNext(io.timer)
	val base_rtt = RegNext(io.base_rtt)
	val max_rate = RegNext(io.max_rate)
	val rtt = RegInit(0.U(64.W))
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
			when(rtt > base_rtt){
				reg_idle_cycle	:= reg_idle_cycle + 1.U
			}.elsewhen(reg_idle_cycle <= max_rate){
				reg_idle_cycle	:= max_rate
			}.otherwise{
				reg_idle_cycle	:= reg_idle_cycle - 1.U
			}

			state1:=s_judge
		}
		is(s_judge){
			when(io.data_in.fire){	
				rtt := timer - io.data_in.bits.data(223,160)
				state1:=s_wait
			}
		}
	}
	when(state1 === s_wait){
		count_50us := count_50us + 1.U
	}.otherwise{
		count_50us := 0.U
	}

	
	val s1 :: s2:: s3 :: s4 :: Nil = Enum(4)
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
				state2:=s4
			}
		}
		is(s4){
			state2:=s4
		}

	}
	when((state2 === s2)&(io.data_in.fire)){
		sending_cnt := sending_cnt + 1.U
		io.q_time_out.valid := 1.U
	}.otherwise{
		sending_cnt := 1.U
	}

	io.c2h_req.valid := state2 === s3
	io.data_in.ready := state2 === s1 || state2 === s3  || (state2 === s2 && io.q_time_out.ready === 1.U)
	io.q_time_out.bits := io.data_in.bits.data
	io.q_time_out.valid := io.data_in.fire && state2 === s2

	class ila_proc(seq:Seq[Data]) extends BaseILA(seq)	  
  	val proc = Module(new ila_proc(Seq(	
		state1,
		rtt,
		io.data_in.valid,
		io.data_in.ready,
		reg_idle_cycle

  	)))
  	proc.connect(clock)

}