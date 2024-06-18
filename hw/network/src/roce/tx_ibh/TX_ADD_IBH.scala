package network.roce.tx_ibh

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class TX_ADD_IBH() extends Module{
	val io = IO(new Bundle{
		val ibh_header_in   = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val exh_data_in	    = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val tx_data_out	    = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
	})

    // Collector.fire(io.ibh_header_in)
    // Collector.fire(io.exh_data_in)
    // Collector.fire(io.tx_data_out)

	val ibh_header_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),16))
	val exh_data_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),16))

	val ibh_header_tmp = Wire(new IBH_HEADER())
    ibh_header_tmp                  := 0.U.asTypeOf(ibh_header_tmp)


	io.ibh_header_in 	<> ibh_header_fifo.io.enq
	io.exh_data_in 	    <> exh_data_fifo.io.enq


	val sIDLE :: sPAYLOAD :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)
	Collector.report(state===sIDLE, "TX_ADD_IBH===sIDLE")  	

	

	ibh_header_fifo.io.deq.ready     := (state === sIDLE) & io.tx_data_out.ready & exh_data_fifo.io.deq.valid
    exh_data_fifo.io.deq.ready       := ((state === sIDLE) & io.tx_data_out.ready & ibh_header_fifo.io.deq.valid) | ((state === sPAYLOAD) & io.tx_data_out.ready)




	io.tx_data_out.valid 			:= 0.U 
	io.tx_data_out.bits.data 		:= 0.U
	io.tx_data_out.bits.keep 		:= 0.U
	io.tx_data_out.bits.last 		:= 0.U	


	
	switch(state){
		is(sIDLE){
			when(ibh_header_fifo.io.deq.fire & exh_data_fifo.io.deq.fire){
				ibh_header_tmp          		:= ibh_header_fifo.io.deq.bits.data(CONFIG.IBH_HEADER_LEN-1,0).asTypeOf(ibh_header_tmp)
                io.tx_data_out.valid            := 1.U
                io.tx_data_out.bits.last        := 0.U
				io.tx_data_out.bits.keep        := exh_data_fifo.io.deq.bits.keep
                io.tx_data_out.bits.data        := Cat(exh_data_fifo.io.deq.bits.data(CONFIG.DATA_WIDTH-1,CONFIG.IBH_HEADER_LEN),ibh_header_fifo.io.deq.bits.data(CONFIG.IBH_HEADER_LEN-1,0))
				when(exh_data_fifo.io.deq.bits.last === 1.U){
                    state                       := sIDLE
                    io.tx_data_out.bits.last    := 1.U
                }.otherwise{
                    state                       := sPAYLOAD
                }
			}
		}
		is(sPAYLOAD){
			when(exh_data_fifo.io.deq.fire){
                io.tx_data_out.valid 		    := 1.U
				io.tx_data_out.bits 		    <> exh_data_fifo.io.deq.bits 
				when(exh_data_fifo.io.deq.bits.last === 1.U){
					state						:= sIDLE
				}
			}
		}
	}

}