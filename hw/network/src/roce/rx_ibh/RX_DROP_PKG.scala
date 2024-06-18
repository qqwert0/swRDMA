package network.roce.rx_ibh

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class RX_DROP_PKG() extends Module{
	val io = IO(new Bundle{
		val drop_info  		= Flipped(Decoupled(Bool()))
		val rx_meta_in		= Flipped(Decoupled(new IBH_META()))
		val rx_data_in	= Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val rx_data_out	= (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val rx_meta_out		= (Decoupled(new IBH_META()))
	})


	val drop_info_fifo = Module(new Queue(Bool(),16))
	val rx_data_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),16))
	val rx_meta_fifo = Module(new Queue(new IBH_META(),16))
	io.drop_info 			<> drop_info_fifo.io.enq
	io.rx_data_in 		    <> rx_data_fifo.io.enq
	io.rx_meta_in 		    <> rx_meta_fifo.io.enq

	val sIDLE :: sDROP :: sFWD :: Nil = Enum(3)
	val state          = RegInit(sIDLE)	
	Collector.report(state===sIDLE, "RX_DROP_PKG===sIDLE")
	
	drop_info_fifo.io.deq.ready := (state === sIDLE) & (rx_data_fifo.io.deq.valid) & (rx_meta_fifo.io.deq.valid) & io.rx_meta_out.ready & io.rx_data_out.ready
	rx_meta_fifo.io.deq.ready	:= (state === sIDLE) & (rx_data_fifo.io.deq.valid) & (drop_info_fifo.io.deq.valid) & io.rx_meta_out.ready & io.rx_data_out.ready
	rx_data_fifo.io.deq.ready 	:= ((state === sDROP) | (state === sFWD) | ((state === sIDLE) & (drop_info_fifo.io.deq.valid) & (rx_meta_fifo.io.deq.valid) & io.rx_meta_out.ready)) & io.rx_data_out.ready
	

	io.rx_data_out.valid 			:= 0.U 
	io.rx_data_out.bits 		    := 0.U.asTypeOf(io.rx_data_out.bits)
	io.rx_meta_out.valid 			:= 0.U 
	io.rx_meta_out.bits 		    := 0.U.asTypeOf(io.rx_meta_out.bits)

	switch(state){
		is(sIDLE){
			when(drop_info_fifo.io.deq.fire & rx_data_fifo.io.deq.fire & rx_meta_fifo.io.deq.fire){
				when(drop_info_fifo.io.deq.bits){
                    when(rx_data_fifo.io.deq.bits.last === 1.U){
                        state	:= sIDLE
                    }.otherwise{
                        state	:= sDROP
                    }	
				}.otherwise{
					when(!PKG_JUDGE.HAVE_DATA(rx_meta_fifo.io.deq.bits.op_code)){
						io.rx_data_out.valid:= 0.U
					}.otherwise{
						io.rx_data_out.valid:= 1.U
					}
                    io.rx_data_out.bits     <> rx_data_fifo.io.deq.bits
					io.rx_meta_out.valid    := 1.U
                    io.rx_meta_out.bits     <> rx_meta_fifo.io.deq.bits
                    when(rx_data_fifo.io.deq.bits.last === 1.U){
                        state	:= sIDLE
                    }.otherwise{
                        state	:= sFWD
                    }
				}
			}
		}
		is(sDROP){
			when(rx_data_fifo.io.deq.fire){
                when(rx_data_fifo.io.deq.bits.last === 1.U){
                    state	:= sIDLE
                }.otherwise{
                    state	:= sDROP
                }
			}
		}
		is(sFWD){
			when(rx_data_fifo.io.deq.fire){
                io.rx_data_out.valid    := 1.U
                io.rx_data_out.bits     <> rx_data_fifo.io.deq.bits
                when(rx_data_fifo.io.deq.bits.last === 1.U){
                    state	:= sIDLE
                }.otherwise{
                    state	:= sFWD
                }
			}			
		}		
	}


}