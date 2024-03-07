package demo

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._
import common.axi._
import chisel3.util.{switch, is}

class vector_add extends Module{
	val io = IO(new Bundle{
		val infor_in	= Decoupled(new infor_input) 
		val mem_interface = new AXI(33, 256, 6, 0, 4)
		val infor_out   = Decoupled(UInt(1.W))
	})

	//* state machine 1: total control
	val s_waiting :: s_computing :: s_computing_done :: Nil = Enum(3)

	val state1 = RegInit(s_waiting)
	var done = UInt(1.W)

	switch(state1){
		is(s_waiting){
			when(io.infor_in.valid === 1.U && io.infor_in.ready === 1.U){
				state1:=s_computing
			}
		}
		is(s_computing){
			when(done === 1.U ){
				state1:=s_computing_done
			}
		}
		is(s_computing_done){
			when(io.infor_out.valid === 1.U && io.infor_out.ready === 1.U){
				state1:=s_waiting
			}
		}
	}
	
	when(state1 === s_waiting){
		infor_in.ready := 1.U
	}.otherwise{
		infor_in.ready := 0.U
	}

	when(state1 === s_computing_done){
		infor_out.valid := 1.U
		infor_out.bits := 1.U
	}.otherwise{
		infor_out.valid := 0.U
		infor_out.bits := 0.U
	}

	//* state machine 2: computing
	val s1 :: s2 :: s3 :: s4 :: Nil = Enum(4)
	val state2 = RegInit(s1)
	val result = RegInit(0.U(512.W))

	switch(state2){
		is(s1){
			when(state1 === s_computing && io.mem_interface.ar.fire()){
				state2:=s2
			}
		}
		is(s2){
			when(io.mem_interface.r.fire() && io.mem_interface.r.bits.last === 1.U){
				state2:=s3
			}
		}
		is(s3){
			when(io.mem_interface.aw.fire() && io.mem_interface.w.fire() ){
				state2:=s4
			}
		}
		is(s4){
			when(sate1 === s_computing_done ){
				state2:=s1
			}
		}
	}

	done := sate2 === s4



	
	when(state2 === s1){
		io.mem_interface.aw.valid := 0.U
		io.mem_interface.w.valid := 0.U
		io.mem_interface.b.ready := 1.U
		io.mem_interface.ar.valid := state1 === s_computing 
		io.mem_interface.r.ready := 0.U
	}.elsewhen(state2 === s2){
		io.mem_interface.aw.valid := 0.U
		io.mem_interface.w.valid := 0.U
		io.mem_interface.b.ready := 1.U
		io.mem_interface.ar.valid := 0.U
		io.mem_interface.r.ready := 1.U
	}.elsewhen(state2 === s3){
		io.mem_interface.aw.valid := 1.U
		io.mem_interface.w.valid := 1.U
		io.mem_interface.b.ready := 1.U
		io.mem_interface.ar.valid := 0.U
		io.mem_interface.r.ready := 0.U
	}.otherwise{
		io.mem_interface.aw.valid := 0.U
		io.mem_interface.w.valid := 0.U
		io.mem_interface.b.ready := 1.U
		io.mem_interface.ar.valid := 0.U
		io.mem_interface.r.ready := 0.U
	}

	io.mem_interface.ar.bits.addr := io.infor_in.bits.addr_read
	io.mem_interface.ar.bits.burst := 1.U
	//io.mem_interface.ar.bits.cache := 0.U
	io.mem_interface.ar.bits.id := 0.U
	io.mem_interface.ar.bits.len := (io.infor_in.bits.len/32.U -1.U)(4.W)
	//io.mem_interface.ar.bits.lock := 0.U
	io.mem_interface.ar.bits.size := 5.U
	//io.mem_interface.ar.bits.prot := 0.U
	//io.mem_interface.ar.bits.qos := 0.U
	//io.mem_interface.ar.bits.region := 0.U
	//io.mem_interface.ar.bits.user := 0.U

	io.mem_interface.aw.bits.addr := io.infor_in.bits.addr_write
	io.mem_interface.aw.bits.burst := 1.U
	//io.mem_interface.aw.bits.cache := 0.U
	io.mem_interface.aw.bits.id := 0.U
	io.mem_interface.aw.bits.len := 0.U
	//io.mem_interface.aw.bits.lock := 0.U
	io.mem_interface.aw.bits.size := 5.U
	//io.mem_interface.aw.bits.prot := 0.U
	//io.mem_interface.aw.bits.qos := 0.U
	//io.mem_interface.aw.bits.region := 0.U
	//io.mem_interface.aw.bits.user := 0.U

	io.mem_interface.w.bits.data := result
	io.mem_interface.w.bits.strb := "hffffffff".U(32.W)
	io.mem_interface.w.bits.last := 1.U
	//io.mem_interface.w.bits.user := 0.U
	
	val vec_entry = RegInit(VecInit(Seq.fill(8)(0.U(32.W))))
	result := Cat(vec_entry(7),vec_entry(6),vec_entry(5),vec_entry(4),vec_entry(3),vec_entry(2),vec_entry(1),vec_entry(0))

	when(state2 === s2 && io.mem_interface.r.fire() ){
		vec_entry(0) := vec_entry(0)+io.mem_interface.r.bits.data(31,0)
		vec_entry(1) := vec_entry(1)+io.mem_interface.r.bits.data(63,32)
		vec_entry(2) := vec_entry(2)+io.mem_interface.r.bits.data(95,64)
		vec_entry(3) := vec_entry(3)+io.mem_interface.r.bits.data(127,96)
		vec_entry(4) := vec_entry(4)+io.mem_interface.r.bits.data(159,128)
		vec_entry(5) := vec_entry(5)+io.mem_interface.r.bits.data(191,160)
		vec_entry(6) := vec_entry(6)+io.mem_interface.r.bits.data(223,192)
		vec_entry(7) := vec_entry(7)+io.mem_interface.r.bits.data(255,224)
	}
	when(state2 === s1){
		vec_entry(0) := 0.U(32.W)
		vec_entry(1) := 0.U(32.W)
		vec_entry(2) := 0.U(32.W)
		vec_entry(3) := 0.U(32.W)
		vec_entry(4) := 0.U(32.W)
		vec_entry(5) := 0.U(32.W)
		vec_entry(6) := 0.U(32.W)
		vec_entry(7) := 0.U(32.W)
	}

}
