package network.roce.tx_exh

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.BaseILA
import common.Collector



class TX_MEM_PAYLOAD() extends Module{
	val io = IO(new Bundle{
		val pkg_info  		= Flipped(Decoupled(new PKG_INFO()))

		val s_mem_read_data	= Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val s_send_data		= Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val reth_data_out	= (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val aeth_data_out	= (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val raw_data_out	= (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
	})



	Collector.fire(io.pkg_info)
	// Collector.report(io.s_send_data.ready)
	val pkg_info_fifo = Module(new Queue(new PKG_INFO(), 8))
	io.pkg_info                     <> pkg_info_fifo.io.enq

	val length_cnt = RegInit(0.U(16.W))
	val last_err	= RegInit(false.B)
	val pkg_info = RegInit(0.U.asTypeOf(new PKG_INFO()))
	val mem_read_length_err = RegInit(false.B)
	val sIDLE :: sAETH :: sRETH :: sRAW :: Nil = Enum(4)
	val state          = RegInit(sIDLE)	
	Collector.report(state===sIDLE, "TX_MEM_PAYLOAD===sIDLE") 
	Collector.report(last_err, "TX_MEM_PAYLOAD::last_err") 
	
	pkg_info_fifo.io.deq.ready := (state === sIDLE)

	io.s_mem_read_data.ready := 0.U
	io.s_send_data.ready := 0.U

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
			}.otherwise{
				state		:= sIDLE
			}
		}
		is(sAETH){
			when(pkg_info.data_from_mem){
				io.s_mem_read_data.ready := io.aeth_data_out.ready
				when(io.s_mem_read_data.fire){
					io.aeth_data_out.valid 			:= 1.U 
					io.aeth_data_out.bits.data 		:= io.s_mem_read_data.bits.data
					io.aeth_data_out.bits.keep 		:= io.s_mem_read_data.bits.keep
					length_cnt						:= length_cnt + 64.U;
					when(length_cnt === (pkg_info.pkg_length - 64.U)){
						when(io.s_mem_read_data.bits.last =/= 1.U){
							last_err				:= true.B
						}
						length_cnt					:= 0.U
						io.aeth_data_out.bits.last 	:= 1.U
						state						:= sIDLE
					}
				}				
			}.otherwise{
				io.s_send_data.ready := io.aeth_data_out.ready
				when(io.s_send_data.fire){
					io.aeth_data_out.valid 			:= 1.U 
					io.aeth_data_out.bits.data 		:= io.s_send_data.bits.data
					io.aeth_data_out.bits.keep 		:= io.s_send_data.bits.keep
					length_cnt						:= length_cnt + 64.U;
					when(length_cnt === (pkg_info.pkg_length - 64.U)){
						when(io.s_send_data.bits.last =/= 1.U){
							last_err				:= true.B
						}						
						length_cnt					:= 0.U
						io.aeth_data_out.bits.last 	:= 1.U
						state						:= sIDLE
					}					
				}					
			}

		}
		is(sRETH){
			when(pkg_info.data_from_mem){
				io.s_mem_read_data.ready := io.reth_data_out.ready
				when(io.s_mem_read_data.fire){
					io.reth_data_out.valid 			:= 1.U 
					io.reth_data_out.bits.data 		:= io.s_mem_read_data.bits.data
					io.reth_data_out.bits.keep 		:= io.s_mem_read_data.bits.keep
					length_cnt						:= length_cnt + 64.U;
					when(length_cnt === (pkg_info.pkg_length - 64.U)){
						when(io.s_mem_read_data.bits.last =/= 1.U){
							last_err				:= true.B
						}						
						length_cnt					:= 0.U
						io.reth_data_out.bits.last 	:= 1.U
						state						:= sIDLE
					}					
				}	
			}.otherwise{
				io.s_send_data.ready := io.reth_data_out.ready
				when(io.s_send_data.fire){
					io.reth_data_out.valid 			:= 1.U 
					io.reth_data_out.bits.data 		:= io.s_send_data.bits.data
					io.reth_data_out.bits.keep 		:= io.s_send_data.bits.keep
					length_cnt						:= length_cnt + 64.U;
					when(length_cnt === (pkg_info.pkg_length - 64.U)){
						when(io.s_send_data.bits.last =/= 1.U){
							last_err				:= true.B
						}						
						length_cnt					:= 0.U
						io.reth_data_out.bits.last 	:= 1.U
						state						:= sIDLE
					}					
				}				
			}	
		}
		is(sRAW){
			when(pkg_info.data_from_mem){
				io.s_mem_read_data.ready := io.raw_data_out.ready
				when(io.s_mem_read_data.fire){
					io.raw_data_out.valid 			:= 1.U 
					io.raw_data_out.bits.data 		:= io.s_mem_read_data.bits.data
					io.raw_data_out.bits.keep 		:= io.s_mem_read_data.bits.keep
					length_cnt						:= length_cnt + 64.U;
					when(length_cnt === (pkg_info.pkg_length - 64.U)){
						when(io.s_mem_read_data.bits.last =/= 1.U){
							last_err				:= true.B
						}						
						length_cnt					:= 0.U
						io.raw_data_out.bits.last 	:= 1.U
						state						:= sIDLE
					}								
				}		
			}.otherwise{
				io.s_send_data.ready := io.raw_data_out.ready
				when(io.s_send_data.fire){
					io.raw_data_out.valid 			:= 1.U 
					io.raw_data_out.bits.data 		:= io.s_send_data.bits.data
					io.raw_data_out.bits.keep 		:= io.s_send_data.bits.keep
					length_cnt						:= length_cnt + 64.U;	
					when(length_cnt === (pkg_info.pkg_length - 64.U)){
						when(io.s_send_data.bits.last =/= 1.U){
							last_err				:= true.B
						}						
						length_cnt					:= 0.U
						io.raw_data_out.bits.last 	:= 1.U
						state						:= sIDLE
					}								
				}				
			}	
		}		
	}


}