package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._
import common.axi._
import chisel3.util.{switch, is}

class PkgDelay extends Module{
	val io = IO(new Bundle{
		val delay_cycle = Input(UInt(32.W))
		val data_in	  = Flipped(Decoupled(new AXIS(512)))
		val data_out	= Decoupled(new AXIS(512)) 
	})

	io.data_in.ready:=io.data_out.ready

	val cursor_len = io.delay_cycle +1.U
	var cursor_head = RegInit(0.U(32.W))
	var cursor_tail = RegInit(cursor_len - 1.U)
	var data_queue = RegInit(VecInit(Seq.fill(5000)(0.U(512.W))))
	var data_queue_valid = RegInit(VecInit(Seq.fill(5000)(0.U(1.W))))
	//RegInit(Vec(Seq.fill(n)(0.U(32.W))))

	val s1 :: s2 :: Nil = Enum(2)
	val state = RegInit(s1)
	switch(state){
		is(s1){
			when(io.data_in.valid===1.U&&io.data_in.ready===1.U){
				data_queue(cursor_tail):=io.data_in.bits.data
				data_queue_valid(cursor_tail):=1.U(1.W)
				when(io.data_in.bits.last=/=1.U){
					state:=s2
				}
			}
		}
		is(s2){
			when(io.data_in.valid===1.U&&io.data_in.ready===1.U&&io.data_in.bits.last===1.U){
				state:=s1
			}.otherwise{
				state:=s2
			}
		}
	}
	io.data_out.valid := data_queue_valid(cursor_head) === 1.U
	io.data_out.bits.data:=data_queue(cursor_head)
	io.data_out.bits.last:=1.U
	io.data_out.bits.keep:= "hffffffffffffffff".U(64.W)
	when(io.data_out.ready===1.U){
		data_queue_valid(cursor_head) := 0.U
		cursor_head:=(cursor_head+1.U)%cursor_len
		cursor_tail:=(cursor_tail+1.U)%cursor_len
	}
}