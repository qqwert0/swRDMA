package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._
import common.axi._
import common.storage._
//import common.Util._
// import chisel3.util.{switch, is}


class PkgGen2 extends Module{

	
	val io = IO(new Bundle{
		val start        = Input(UInt(1.W))
        val idle_cycle	= Input(UInt(32.W))
		val timer		= Input(UInt(64.W))
		val pkg_num		= Input(UInt(32.W))
		val data_out	= Decoupled(new AXIS(512)) 
	})
	// 包大小固定为1024B，包括一个12B报头


	Collector.fire(io.data_out)
	Collector.fireLast(io.data_out)
	
	class User_Header()extends Bundle{    	
    	val enqueue   = UInt(32.W)
    	val entime    = UInt(32.W)
    	val dequeue   = UInt(32.W)
    	val detime    = UInt(32.W)
		val des_port  = UInt(32.W)	    
	}

	val header_queue = 0.U(32.W)
	val time    = 0.U(32.W)
	val des_port = 0.U(32.W)
	val timer	= RegNext(io.timer)
	
	val pkg_cnt = RegInit(0.U(32.W))
	val pkg_num = RegInit(0.U(32.W))
	pkg_num := RegNext(io.pkg_num)
	val state_reg = RegInit(0.U(32.W))
	
	val header = Wire(new User_Header)
	header.des_port:="h03000000".U(32.W) //Util.reverse(3.U(32.W))
	header.enqueue:=0.U(32.W)
	header.entime:=0.U(32.W)
	header.dequeue:=0.U(32.W)
	header.detime:=0.U(32.W)

	val content =Wire(Vec(16,UInt(512.W)))
	content(0):=Cat(0.U(288.W),timer,header.asUInt)
	for (contentid <- 1 until 16) {
		content(contentid):=0.U(512.W)
    }
	
	io.data_out.bits.keep := "hffffffffffffffff".U(64.W)

	val fsm_idle :: fsm_stop :: fsm_write0 :: fsm_write1 ::fsm_write2 :: Nil = Enum(5)
    val state=RegInit(fsm_idle)

	var idle_cnt = RegInit(0.U(32.W))
	var data_cnt = RegInit(0.U(32.W))
	val data_total = 14.U(32.W)
	
	when((state === fsm_write2)&io.data_out.fire()){
		pkg_cnt				:= pkg_cnt + 1.U
	}.elsewhen(io.start === 0.U){
		pkg_cnt				:= 0.U
	}.otherwise{
		pkg_cnt				:= pkg_cnt
	}

	Collector.report(pkg_cnt)
	Collector.report(pkg_num)
	state_reg := state
	Collector.report(state_reg)

	switch(state){
		is(fsm_idle){
			when((io.start===1.U)&&(idle_cnt >= (io.idle_cycle-16.U))){
				state:=fsm_write0	
			}.elsewhen(io.start===1.U){
				state:=fsm_idle
			}.otherwise{
				state:=fsm_stop
			}
		}
		is(fsm_stop){
			when((io.start===1.U) & (pkg_num === 0.U)){
				state:=fsm_write0
			}.elsewhen((io.start===1.U) & (pkg_cnt < (pkg_num - 1.U))){
				state:=fsm_write0
			}
			.otherwise{
				state:=fsm_stop
			}
		}
		is(fsm_write0){
			when(io.data_out.fire()){
				state:=fsm_write1
			}
			.otherwise{
				state:=fsm_write0
			}
		}
		is(fsm_write1){
			when(io.data_out.fire()&&(data_cnt===data_total)){
				state:=fsm_write2
			}
			.otherwise{
				state:=fsm_write1
			}
		}
		is(fsm_write2){
			when(io.data_out.fire() && (pkg_num === 0.U)){
				state:=fsm_idle
			}.elsewhen(io.data_out.fire() && (pkg_cnt < (pkg_num - 1.U))){
				state:=fsm_idle
			}.elsewhen(io.data_out.fire()){
				state:=fsm_stop
			}.otherwise{
				state:=fsm_write2
			}
		}
	}

	when(state===fsm_idle){
		idle_cnt:=idle_cnt+1.U
	}.otherwise{
		idle_cnt:=0.U
	}

	when((state===fsm_write0||state===fsm_write1)&&io.data_out.fire()){
		data_cnt:=data_cnt+1.U
	}.elsewhen(state===fsm_write2){
		data_cnt:=0.U
	}
	
	when(state===fsm_write0||state===fsm_write1||state===fsm_write2){
		io.data_out.valid:=1.U
	}.otherwise{
		io.data_out.valid:=0.U
	}

	when(state===fsm_write0){
		io.data_out.bits.data:=content(0)
	}.elsewhen(state===fsm_write1||state===fsm_write2){
		io.data_out.bits.data:=content(data_cnt)
	}.otherwise{
		io.data_out.bits.data:=0.U(512.W)
	}


	when(state===fsm_write2){
		io.data_out.bits.last:=1.U
	}.otherwise{
		io.data_out.bits.last:=0.U
	}


	// class ila_gen(seq:Seq[Data]) extends BaseILA(seq)	  
  	// val gen = Module(new ila_gen(Seq(	
	// 	state
  	// )))
  	// gen.connect(clock)

}