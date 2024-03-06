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
		val idle_cycle	= Output(UInt(32.W))       
		val q_time_out = Decoupled(UInt(512.W))
	})
	
	val count_50us = Reg(UInt(32.W))
	val count_50us_max = 50000.U(32.W)

	val s_wait :: s_judge :: Nil = Enum(2)
	val state1 = RegInit(s_wait)
	var reg_idle_cycle = RegInit(1.U(32.W))

	var enqueue = Reg(UInt(32.W))
	enqueue := io.data_in.bits.data(489,458)
	switch(state1){
		is(s_wait){
			when(count_50us === count_50us_max){
				state1:=s_judge
			}
		}
		is(s_judge){
			when(io.data_in.valid === 1.U&&io.data_in.ready === 1.U&& enqueue > 10.U){	
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

	val s1 :: s2:: Nil = Enum(2)
	val state2 = RegInit(s1)
	var sending_cnt = RegInit(0.U(32.W))

	switch(state2){
		is(s1){
			when(io.data_in.valid === 1.U&&io.data_in.ready === 1.U&&enqueue > 10.U){
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
		sending_cnt := 0.U
	}

	
	io.data_in.ready := state2 === s1 || (state1 === s2 && io.q_time_out.ready === 1.U)
	io.q_time_out.bits := io.data_in.bits.data

}