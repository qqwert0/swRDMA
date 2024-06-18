package network.roce.tx_exh

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.BaseILA
import common.Collector



class TX_ADD_EXH() extends Module{
	val io = IO(new Bundle{
		val pkg_info  		= Flipped(Decoupled(new TX_PKG_INFO()))

		val header_data_in  = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val reth_data_in	= Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val aeth_data_in	= Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val raw_data_in	    = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val tx_data_out	    = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
	})

    Collector.fire(io.pkg_info)
    Collector.fire(io.header_data_in)
    Collector.fire(io.tx_data_out)
	val pkg_info_fifo = Module(new Queue(new TX_PKG_INFO(),4))
	val header_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),4))
	val reth_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),16))
	val aeth_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),16))
	val raw_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),16))

	io.pkg_info 		<> pkg_info_fifo.io.enq
	io.header_data_in 	<> header_fifo.io.enq
	io.reth_data_in 	<> reth_fifo.io.enq
	io.aeth_data_in 	<> aeth_fifo.io.enq
	io.raw_data_in 		<> raw_fifo.io.enq


    val write_first = RegInit(1.U(1.W))
	val pkg_info = RegInit(0.U.asTypeOf(new TX_PKG_INFO()))
	val sIDLE :: sHEADER :: sAETH :: sRETH :: sRAW :: Nil = Enum(5)
	val state                   = RegInit(sIDLE)	
	Collector.report(state===sIDLE, "TX_ADD_EXH===sIDLE")  
	Collector.report(state===sHEADER, "TX_ADD_EXH===sHEADER")  
	Collector.report(state===sRETH, "TX_ADD_EXH===sRETH")  
    val curr_word               = RegInit(0.U.asTypeOf(new AXIS(CONFIG.DATA_WIDTH)))
	
	pkg_info_fifo.io.deq.ready           := (state === sIDLE)

	header_fifo.io.deq.ready     := (state === sHEADER) & io.tx_data_out.ready
    reth_fifo.io.deq.ready       := (state === sRETH) & io.tx_data_out.ready
    aeth_fifo.io.deq.ready       := (state === sAETH) & io.tx_data_out.ready
    raw_fifo.io.deq.ready        := (state === sRAW) & io.tx_data_out.ready


	io.tx_data_out.valid 			:= 0.U 
	io.tx_data_out.bits.data 		:= 0.U
	io.tx_data_out.bits.keep 		:= 0.U
	io.tx_data_out.bits.last 		:= 0.U	
	
	switch(state){
		is(sIDLE){
			when(pkg_info_fifo.io.deq.fire){
                write_first := 1.U
				pkg_info	:= pkg_info_fifo.io.deq.bits
				when(pkg_info_fifo.io.deq.bits.hasHeader){
					state	:= sHEADER
				}.otherwise{
					state	:= sRAW
				}
			}
		}
		is(sHEADER){
			when(header_fifo.io.deq.fire){
                curr_word                       <> header_fifo.io.deq.bits
				when(!pkg_info.hasPayload){
                    io.tx_data_out.valid 		:= 1.U
					io.tx_data_out.bits.last 	:= 1.U
                    io.tx_data_out.bits.data 	:= header_fifo.io.deq.bits.data
	                io.tx_data_out.bits.keep 	:= header_fifo.io.deq.bits.keep
					state						:= sIDLE
				}.otherwise{
                    curr_word.last              := 0.U
                    when(pkg_info.isAETH){
                        state                   := sAETH
                    }.otherwise{
                        state                   := sRETH    
                    }
                }
			}
		}
		is(sAETH){
			when(aeth_fifo.io.deq.fire){
                io.tx_data_out.valid 		:= 1.U
				io.tx_data_out.bits 		<> aeth_fifo.io.deq.bits                
				when(write_first === 1.U){
                    io.tx_data_out.bits.data    := Cat(aeth_fifo.io.deq.bits.data(CONFIG.DATA_WIDTH-1,CONFIG.AETH_HEADER_LEN),curr_word.data(CONFIG.AETH_HEADER_LEN-1,0))
					write_first					:= 0.U
				}               
                when(aeth_fifo.io.deq.bits.last === 1.U){
                    state                       := sIDLE
                }
			}
		}
		is(sRETH){
			when(reth_fifo.io.deq.fire){
                io.tx_data_out.valid 		:= 1.U
				io.tx_data_out.bits			<> reth_fifo.io.deq.bits               
				when(write_first === 1.U){                  
                    io.tx_data_out.bits.data 	:= Cat(reth_fifo.io.deq.bits.data(CONFIG.DATA_WIDTH-1,CONFIG.RETH_HEADER_LEN),curr_word.data(CONFIG.RETH_HEADER_LEN-1,0))
					write_first					:= 0.U
				}               
                when(reth_fifo.io.deq.bits.last === 1.U){
                    state                       := sIDLE
                }
			}			
		}
		is(sRAW){
			when(raw_fifo.io.deq.fire){
                io.tx_data_out.valid 		:= 1.U
				io.tx_data_out.bits 		<> raw_fifo.io.deq.bits                                
                when(raw_fifo.io.deq.bits.last === 1.U){
                    state                       := sIDLE
                }
			}			
		}		
	}

}

