package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class UserAdd() extends Module{
	val io = IO(new Bundle{
		val meta_in	        = Flipped(Decoupled(new Event_meta()))
		val data_in			= Flipped(Decoupled(new AXIS(512)))
		val meta_out	    = (Decoupled(new Event_meta()))
		val reth_data_out	= (Decoupled(new AXIS(512)))
        val aeth_data_out	= (Decoupled(new AXIS(512)))
        val raw_data_out	= (Decoupled(new AXIS(512)))
		val pkg_len			= Input(UInt(4.W))
	})

	Collector.fire(io.meta_in)
	Collector.fire(io.data_in)
	Collector.fire(io.meta_out)
	Collector.fire(io.reth_data_out)
	Collector.fire(io.aeth_data_out)	
	Collector.fire(io.raw_data_out)		

	val meta_fifo = XQueue(new Event_meta(), entries=16)
	val data_fifo = XQueue(new AXIS(512), entries=16)
	io.meta_in 		<> meta_fifo.io.in
	io.data_in 	    <> data_fifo.io.in


	val user_define = RegInit(0.U(352.W))
	val meta_reg = Reg(new Event_meta())
	val pkg_len = RegNext(io.pkg_len)

	val sIDLE :: sHeader :: sRETH :: sAETH :: sRAW :: sRETHDATA :: sAETHDATA :: sRAWDATA :: Nil = Enum(8)
	val state                   = RegInit(sIDLE)	
	

	meta_fifo.io.out.ready      := (state === sIDLE) & io.meta_out.ready
    data_fifo.io.out.ready  	:= (((state === sRETH) || (state === sRETHDATA)) & io.reth_data_out.ready) ||
									(((state === sAETH) || (state === sAETHDATA)) & io.aeth_data_out.ready) ||
									(((state === sRAW) || (state === sRAWDATA)) & io.raw_data_out.ready)


	ToZero(io.meta_out.valid) 			
	ToZero(io.meta_out.bits) 		    
	ToZero(io.reth_data_out.valid) 			
	ToZero(io.reth_data_out.bits)
	ToZero(io.aeth_data_out.valid) 			
	ToZero(io.aeth_data_out.bits)
	ToZero(io.raw_data_out.valid) 			
	ToZero(io.raw_data_out.bits)	

	
	switch(state){
		is(sIDLE){
			when(meta_fifo.io.out.fire){
				io.meta_out.valid						:= 1.U
				io.meta_out.bits						:= meta_fifo.io.out.bits
				meta_reg								:= meta_fifo.io.out.bits
				when(meta_fifo.io.out.bits.pkg_length === 0.U){
					state						:= sHeader
				}.elsewhen(PKG_JUDGE.RETH_PKG(meta_fifo.io.out.bits.op_code)){
					state                       := sRETH
				}.elsewhen(PKG_JUDGE.AETH_PKG(meta_fifo.io.out.bits.op_code)){
					state                       := sAETH				
				}.otherwise{
					state                       := sRAW
					
				}
			}
		}
		is(sHeader){
			when(PKG_JUDGE.RETH_PKG(meta_reg.op_code)&&io.reth_data_out.ready){
				io.reth_data_out.valid            := 1.U	
				state                       	  := sIDLE			
			}.elsewhen(PKG_JUDGE.AETH_PKG(meta_reg.op_code)&&io.aeth_data_out.ready){
				io.aeth_data_out.valid            := 1.U
				state                       		:= sIDLE
			}.elsewhen(io.raw_data_out.ready){
				io.raw_data_out.valid            := 1.U
				state                       	:= sIDLE
			}
			when(pkg_len === 1.U){
				io.reth_data_out.bits.data        := meta_reg.user_define
				io.reth_data_out.bits.keep        := "hf".U
				io.aeth_data_out.bits.data        := meta_reg.user_define
				io.aeth_data_out.bits.keep        := "hf".U
				io.raw_data_out.bits.data        := meta_reg.user_define
				io.raw_data_out.bits.keep        := "hf".U								
			}.elsewhen(pkg_len === 2.U){
				io.reth_data_out.bits.data        := meta_reg.user_define
				io.reth_data_out.bits.keep        := "hff".U
				io.aeth_data_out.bits.data        := meta_reg.user_define
				io.aeth_data_out.bits.keep        := "hff".U
				io.raw_data_out.bits.data        := meta_reg.user_define
				io.raw_data_out.bits.keep        := "hff".U					
			}.elsewhen(pkg_len === 3.U){
				io.reth_data_out.bits.data        := meta_reg.user_define
				io.reth_data_out.bits.keep        := "hffff".U
				io.aeth_data_out.bits.data        := meta_reg.user_define
				io.aeth_data_out.bits.keep        := "hffff".U
				io.raw_data_out.bits.data        := meta_reg.user_define
				io.raw_data_out.bits.keep        := "hffff".U					
			}.elsewhen(pkg_len === 4.U){
				io.reth_data_out.bits.data        := meta_reg.user_define
				io.reth_data_out.bits.keep        := "hffffffff".U
				io.aeth_data_out.bits.data        := meta_reg.user_define
				io.aeth_data_out.bits.keep        := "hffffffff".U
				io.raw_data_out.bits.data        := meta_reg.user_define
				io.raw_data_out.bits.keep        := "hffffffff".U					
			}.elsewhen(pkg_len === 5.U){
				io.reth_data_out.bits.data        := meta_reg.user_define
				io.reth_data_out.bits.keep        := "hffffffffffffffff".U
				io.aeth_data_out.bits.data        := meta_reg.user_define
				io.aeth_data_out.bits.keep        := "hffffffffffffffff".U
				io.raw_data_out.bits.data        := meta_reg.user_define
				io.raw_data_out.bits.keep        := "hffffffffffffffff".U					
			}.otherwise{
				io.reth_data_out.bits.data        := meta_reg.user_define
				io.reth_data_out.bits.keep        := "hf".U
				io.aeth_data_out.bits.data        := meta_reg.user_define
				io.aeth_data_out.bits.keep        := "hf".U
				io.raw_data_out.bits.data        := meta_reg.user_define
				io.raw_data_out.bits.keep        := "hf".U					
			}
			io.reth_data_out.bits.last        	:= 1.U
			io.aeth_data_out.bits.last        	:= 1.U
			io.raw_data_out.bits.last        	:= 1.U
		}
		is(sRETH){
			when(data_fifo.io.out.fire){
				io.reth_data_out.valid            := 1.U
				when(pkg_len === 0.U){
					io.reth_data_out.bits.data        := data_fifo.io.out.bits.data
				}.elsewhen(pkg_len === 1.U){
					io.reth_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN1),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN1-1,0))
				}.elsewhen(pkg_len === 2.U){
					io.reth_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN2),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN2-1,0))
				}.elsewhen(pkg_len === 3.U){
					io.reth_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN3),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN3-1,0))
				}.elsewhen(pkg_len === 4.U){
					io.reth_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN4),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN4-1,0))
				}.elsewhen(pkg_len === 5.U){
					io.reth_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN5),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN5-1,0))
				}.otherwise{
					io.reth_data_out.bits.data        := data_fifo.io.out.bits.data
				}
				io.reth_data_out.bits.last        := data_fifo.io.out.bits.last
				io.reth_data_out.bits.keep        := data_fifo.io.out.bits.keep
				when(data_fifo.io.out.bits.last === 1.U){
					state                       := sIDLE
				}.otherwise{
					state                       := sRETHDATA
				}
			}
		}
		is(sAETH){
			when(data_fifo.io.out.fire){
				io.aeth_data_out.valid            := 1.U
				when(pkg_len === 0.U){
					io.aeth_data_out.bits.data        := data_fifo.io.out.bits.data
				}.elsewhen(pkg_len === 1.U){
					io.aeth_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN1),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN1-1,0))
				}.elsewhen(pkg_len === 2.U){
					io.aeth_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN2),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN2-1,0))
				}.elsewhen(pkg_len === 3.U){
					io.aeth_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN3),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN3-1,0))
				}.elsewhen(pkg_len === 4.U){
					io.aeth_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN4),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN4-1,0))
				}.elsewhen(pkg_len === 5.U){
					io.aeth_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN5),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN5-1,0))
				}.otherwise{
					io.aeth_data_out.bits.data        := data_fifo.io.out.bits.data
				}
				io.aeth_data_out.bits.last        := data_fifo.io.out.bits.last
				io.aeth_data_out.bits.keep        := data_fifo.io.out.bits.keep
				when(data_fifo.io.out.bits.last === 1.U){
					state                       := sIDLE
				}.otherwise{
					state                       := sAETHDATA
				}
			}
		}
		is(sRAW){
			when(data_fifo.io.out.fire){
				io.raw_data_out.valid            := 1.U
				when(pkg_len === 0.U){
					io.raw_data_out.bits.data        := data_fifo.io.out.bits.data
				}.elsewhen(pkg_len === 1.U){
					io.raw_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN1),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN1-1,0))
				}.elsewhen(pkg_len === 2.U){
					io.raw_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN2),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN2-1,0))
				}.elsewhen(pkg_len === 3.U){
					io.raw_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN3),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN3-1,0))
				}.elsewhen(pkg_len === 4.U){
					io.raw_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN4),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN4-1,0))
				}.elsewhen(pkg_len === 5.U){
					io.raw_data_out.bits.data        := Cat(data_fifo.io.out.bits.data(511,CONFIG.SWRDMA_HEADER_LEN5),meta_reg.user_define(CONFIG.SWRDMA_HEADER_LEN5-1,0))
				}.otherwise{
					io.raw_data_out.bits.data        := data_fifo.io.out.bits.data
				}
				io.raw_data_out.bits.last        := data_fifo.io.out.bits.last
				io.raw_data_out.bits.keep        := data_fifo.io.out.bits.keep
				when(data_fifo.io.out.bits.last === 1.U){
					state                       := sIDLE
				}.otherwise{
					state                       := sRAWDATA
				}	
			}
		}		
		is(sRETHDATA){
			when(data_fifo.io.out.fire){
                io.reth_data_out.valid            := 1.U
                io.reth_data_out.bits             <> data_fifo.io.out.bits
				when(data_fifo.io.out.bits.last === 1.U){
                    state                       := sIDLE
                }
			}
		}
		is(sAETHDATA){
			when(data_fifo.io.out.fire){
                io.aeth_data_out.valid            := 1.U
                io.aeth_data_out.bits             <> data_fifo.io.out.bits
				when(data_fifo.io.out.bits.last === 1.U){
                    state                       := sIDLE
                }
			}
		}
		is(sRAWDATA){
			when(data_fifo.io.out.fire){
                io.raw_data_out.valid            := 1.U
                io.raw_data_out.bits             <> data_fifo.io.out.bits
				when(data_fifo.io.out.bits.last === 1.U){
                    state                       := sIDLE
                }
			}
		}
	}



}