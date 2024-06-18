package network.roce.rx_exh

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector


class RX_EXH_PAYLOAD() extends Module{
	val io = IO(new Bundle{
		val pkg_info  		= Flipped(Decoupled(new RX_PKG_INFO()))

		val rx_ibh_data_in	= Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val reth_data_out	= (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val aeth_data_out	= (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val raw_data_out	= (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
	})


	val pkg_info_fifo = Module(new Queue(new RX_PKG_INFO(),16))
	val exh_data_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),16))
	Collector.fire(io.rx_ibh_data_in)
	Collector.fire(io.reth_data_out)
	Collector.fire(io.raw_data_out)
	io.pkg_info 			<> pkg_info_fifo.io.enq
	io.rx_ibh_data_in 		<> exh_data_fifo.io.enq

	val length_cnt = RegInit(0.U(16.W))
	val pkg_info = RegInit(0.U.asTypeOf(new RX_PKG_INFO()))
	val sIDLE :: sAETH :: sRETH :: sRAW :: Nil = Enum(4)
	val state          = RegInit(sIDLE)	
	Collector.report(state===sIDLE, "RX_EXH_PAYLOAD===sIDLE")
	Collector.report(state===sRETH, "RX_EXH_PAYLOAD===sRETH")

    // Collector.report(io.rx_ibh_data_in.ready)
    // Collector.report(io.rx_ibh_data_in.valid)

    // Collector.report(io.reth_data_out.ready)
    // Collector.report(io.reth_data_out.valid)

	pkg_info_fifo.io.deq.ready := (state === sIDLE)

	exh_data_fifo.io.deq.ready := 0.U

	io.aeth_data_out.valid 			:= 0.U 
	io.aeth_data_out.bits.data 		:= 0.U
	io.aeth_data_out.bits.keep 		:= 0.U
	io.aeth_data_out.bits.last 		:= 0.U
	io.reth_data_out.valid 			:= 0.U 
	io.reth_data_out.bits.data 		:= 0.U
	io.reth_data_out.bits.keep 		:= 0.U
	io.reth_data_out.bits.last 		:= 0.U
	io.raw_data_out.valid 			:= 0.U 
	io.raw_data_out.bits.data 		:= 0.U
	io.raw_data_out.bits.keep 		:= 0.U
	io.raw_data_out.bits.last 		:= 0.U	


	
	switch(state){
		is(sIDLE){
			when(pkg_info_fifo.io.deq.fire){
				pkg_info	<> pkg_info_fifo.io.deq.bits
				length_cnt	:= 0.U
				when(pkg_info_fifo.io.deq.bits.pkg_type === PKG_TYPE.AETH){
					state	:= sAETH
				}.elsewhen(pkg_info_fifo.io.deq.bits.pkg_type === PKG_TYPE.RETH){
					state	:= sRETH
				}.otherwise{
					state	:= sRAW
				}
			}
		}
		is(sAETH){
			exh_data_fifo.io.deq.ready := io.aeth_data_out.ready
			when(exh_data_fifo.io.deq.fire){
				io.aeth_data_out.valid 			:= 1.U 
				io.aeth_data_out.bits 		    <> exh_data_fifo.io.deq.bits
				when(exh_data_fifo.io.deq.bits.last === 1.U){
					state						:= sIDLE
				}.otherwise{
                    state						:= sAETH
                }
			}
		}
		is(sRETH){
			exh_data_fifo.io.deq.ready := io.reth_data_out.ready
			when(exh_data_fifo.io.deq.fire){
				io.reth_data_out.valid 			:= 1.U 
				io.reth_data_out.bits 		    <> exh_data_fifo.io.deq.bits
				when(exh_data_fifo.io.deq.bits.last === 1.U){
					state						:= sIDLE
				}.otherwise{
                    state						:= sRETH
                }
			}			
		}
		is(sRAW){
			exh_data_fifo.io.deq.ready := io.raw_data_out.ready
			when(exh_data_fifo.io.deq.fire){
				io.raw_data_out.valid 			:= 1.U 
				io.raw_data_out.bits 		    <> exh_data_fifo.io.deq.bits
				when(exh_data_fifo.io.deq.bits.last === 1.U){
					state						:= sIDLE
				}.otherwise{
                    state						:= sRAW
                }
			}			
		}		
	}


}