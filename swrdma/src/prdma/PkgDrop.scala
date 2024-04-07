package swrdma

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class PkgDrop() extends Module{
	val io = IO(new Bundle{

		val meta_in	        	= Flipped(Decoupled(new Drop_meta()))
		val rx_data_in			= Flipped(Decoupled(new AXIS(512)))

		val rx_data_out			= (Decoupled(new AXIS(512)))

	})

	val meta_fifo = XQueue(new Drop_meta(),entries=16)
	
	val rx_data_fifo = XQueue(new AXIS(512), entries=16)

	io.meta_in 				<> meta_fifo.io.in
	io.rx_data_in 		    <> rx_data_fifo.io.in

	val sIDLE :: sDROP :: sFWD :: Nil = Enum(3)
	val state          = RegInit(sIDLE)	
	
	meta_fifo.io.out.ready := (state === sIDLE) & (rx_data_fifo.io.out.valid) & io.rx_data_out.ready
	rx_data_fifo.io.out.ready 	:= ((state === sDROP) | (state === sFWD) | ((state === sIDLE) & (meta_fifo.io.out.valid))) & io.rx_data_out.ready
	

	io.rx_data_out.valid 			:= 0.U 
	io.rx_data_out.bits 		    := 0.U.asTypeOf(io.rx_data_out.bits)


	switch(state){
		is(sIDLE){
			when(meta_fifo.io.out.fire() & rx_data_fifo.io.out.fire()){
				when(meta_fifo.io.out.bits.is_drop){
                    when(rx_data_fifo.io.out.bits.last === 1.U){
                        state	:= sIDLE
                    }.otherwise{
                        state	:= sDROP
                    }	
				}.otherwise{
					io.rx_data_out.valid	:= 1.U
                    io.rx_data_out.bits     <> rx_data_fifo.io.out.bits
                    when(rx_data_fifo.io.out.bits.last === 1.U){
                        state	:= sIDLE
                    }.otherwise{
                        state	:= sFWD
                    }
				}
			}
		}
		is(sDROP){
			when(rx_data_fifo.io.out.fire()){
                when(rx_data_fifo.io.out.bits.last === 1.U){
                    state	:= sIDLE
                }.otherwise{
                    state	:= sDROP
                }
			}
		}
		is(sFWD){
			when(rx_data_fifo.io.out.fire()){
                io.rx_data_out.valid    := 1.U
                io.rx_data_out.bits     <> rx_data_fifo.io.out.bits
                when(rx_data_fifo.io.out.bits.last === 1.U){
                    state	:= sIDLE
                }.otherwise{
                    state	:= sFWD
                }
			}			
		}		
	}	


}