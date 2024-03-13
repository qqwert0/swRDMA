package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._
import common.axi._
import common.storage._
import chisel3.util.{switch, is}

class PkgDelay extends Module{
	val io = IO(new Bundle{
		val delay_cycle = Input(UInt(32.W))
		val data_in	  = Flipped(Decoupled(new AXIS(512)))
		val data_out	= Decoupled(new AXIS(512)) 
	})

	val cursor_len = RegNext(io.delay_cycle) 

	val packFifo    = XQueue(UInt(512.W),300)
	io.data_in.ready:= packFifo.io.in.ready  //io.data_out.ready
	val packtpFifo    = XQueue(UInt(32.W),300)
	val timestamp    = RegInit(0.U(32.W))
    val packFiforeg = RegInit(0.U(512.W))
	val packtpFiforeg = RegInit(0.U(32.W))
	val packFifo_empty = RegInit(0.U(32.W))
	packFifo_empty :=  packFifo.io.out.valid === 0.U 

	val s1 :: s2 :: Nil = Enum(2)
	val state = RegInit(s1)
	switch(state){
		is(s1){
			when(io.data_in.valid===1.U&&io.data_in.ready===1.U&&io.data_in.bits.last===0.U){
					state:=s2
				}.otherwise{
				state:=s1
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
	
	io.data_out.bits.last:=1.U
	io.data_out.bits.keep:= "hffffffffffffffff".U(64.W)



	packFifo.io.in.valid:=state === s1 &&io.data_in.valid===1.U
	packtpFifo.io.in.valid:=state === s1 &&io.data_in.valid===1.U


	packFifo.io.in.bits:=Cat(1.U(32.W),(io.data_in.bits.data(479,0)).asUInt)
	packtpFifo.io.in.bits := timestamp

	//timestamp:=(timestamp+1.U)%cursor_len
	when(timestamp === cursor_len - 1.U){
		timestamp:=0.U
	}.otherwise{
		timestamp:=timestamp+1.U
	}

	val k1 :: k2 :: k3 :: Nil = Enum(3)
	val state2 = RegInit(k1)
	switch(state2){
		is(k1){
			when(packFifo.io.out.fire()&&packtpFifo.io.out.fire()){
				state2:=k2
			}.otherwise{
				state2:=k1
			}
		}
		is(k2){
			when(timestamp === packtpFiforeg ){
				state2:=k3
			}.otherwise{
				state2:=k2
			}
		}
		is(k3){
			when(io.data_out.ready===1.U&&io.data_out.valid===1.U){
				state2:=k1
			}.otherwise{
				state2:=k3
			}
		}
	}

	when(state2 === k3){
		io.data_out.valid :=  1.U
		io.data_out.bits.data:=packFiforeg
	}.otherwise{
		io.data_out.valid :=  0.U
		io.data_out.bits.data:=0.U
	}


	when(state2 === k1){
		packFifo.io.out.ready:=1.U
		packtpFifo.io.out.ready := 1.U
	}.elsewhen(state2 === k2){
		packFiforeg:=packFifo.io.out.bits
		packtpFiforeg:=packtpFifo.io.out.bits
		packFifo.io.out.ready:=0.U
		packtpFifo.io.out.ready := 0.U
	}.elsewhen(state2 === k3){
		packFifo.io.out.ready:=0.U
		packtpFifo.io.out.ready := 0.U
	}.otherwise{
		packFifo.io.out.ready:=0.U
		packtpFifo.io.out.ready := 0.U
	}

}