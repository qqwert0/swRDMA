package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._
import common.axi._
import chisel3.util.{switch, is}


class PkgGen extends Module{

	
	val io = IO(new Bundle{
		val start        = Input(UInt(1.W))
        val idle_cycle	= Input(UInt(32.W))
		val data_out	= Decoupled(new AXIS(512)) 
	})
	// 包大小固定为1024B，包括一个12B报头

	
	class User_Header()extends Bundle{
    	val des_port  = UInt(32.W)
    	val enqueue   = UInt(32.W)
    	val entime    = UInt(32.W)
    	val dequeue   = UInt(32.W)
    	val detime    = UInt(32.W)	    
	}

	val header_queue = 0.U(32.W)
	val time    = 0.U(32.W)
	val des_port = 0.U(32.W)
	
	val header = Wire(new User_Header)
	header.des_port:=3.U(32.W)
	header.enqueue:=0.U(32.W)
	header.entime:=0.U(32.W)
	header.dequeue:=0.U(32.W)
	header.detime:=0.U(32.W)

	val content =Wire(Vec(16,UInt(512.W)))
	content(0):=Cat(header.asUInt,0.U(352.W))
	for (contentid <- 1 until 16) {
		content(contentid):=0.U(512.W)
    }
	
	io.data_out.bits.keep := "hffffffffffffffff".U(64.W)

	val fsm_idle :: fsm_stop :: fsm_write0 :: fsm_write1 ::fsm_write2 :: Nil = Enum(5)
    val state=RegInit(fsm_idle)

	var idle_cnt = RegInit(0.U(32.W))
	var data_cnt = RegInit(0.U(32.W))
	val data_total = 14.U(32.W)
	

	switch(state){
		is(fsm_idle){
			when(io.start===1.U&&idle_cnt===io.idle_cycle){
				state:=fsm_write0
			}.elsewhen(io.start===1.U){
				state:=fsm_idle
			}
			.otherwise{
				state:=fsm_stop
			}
		}
		is(fsm_stop){
			when(io.start===1.U){
				state:=fsm_write0
			}
			.otherwise{
				state:=fsm_stop
			}
		}
		is(fsm_write0){
			when(io.data_out.ready===1.U&&io.data_out.valid===1.U){
				state:=fsm_write1
			}
			.otherwise{
				state:=fsm_write0
			}
		}
		is(fsm_write1){
			when(io.data_out.ready===1.U&&io.data_out.valid===1.U&&data_cnt===data_total){
				state:=fsm_write2
			}
			.otherwise{
				state:=fsm_write1
			}
		}
		is(fsm_write2){
			when(io.data_out.ready===1.U&&io.data_out.valid===1.U){
				state:=fsm_idle
			}
			.otherwise{
				state:=fsm_write2
			}
		}
	}

	when(state===fsm_idle){
		idle_cnt:=idle_cnt+1.U
	}

	when((state===fsm_write0||state===fsm_write1)&&io.data_out.ready===1.U&&io.data_out.valid===1.U){
		data_cnt:=data_cnt+1.U
	}

	when(state===fsm_write2){
		data_cnt:=0.U
		idle_cnt:=0.U
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

}