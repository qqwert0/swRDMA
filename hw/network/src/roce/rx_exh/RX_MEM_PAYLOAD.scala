package network.roce.rx_exh

import common.storage._
import common.axi._
import common.ToZero
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.BaseILA
import common.Collector

class RX_MEM_PAYLOAD() extends Module{
	val io = IO(new Bundle{
		val pkg_info  		= Flipped(Decoupled(new RX_PKG_INFO()))		
		val reth_data_in	= Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val aeth_data_in	= Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val raw_data_in	    = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))

        val m_mem_write_data	= (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val m_recv_data		= (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
	})




	val length_cnt = RegInit(0.U(16.W))
	val last_err	= RegInit(false.B)
	val pkg_info = RegInit(0.U.asTypeOf(new RX_PKG_INFO()))
	val sIDLE :: sAETH :: sRETH :: sRAW :: Nil = Enum(4)
	val state          = RegInit(sIDLE)	
	Collector.report(state===sIDLE, "RX_MEM_PAYLOAD===sIDLE")
	Collector.report(state===sRETH, "RX_MEM_PAYLOAD===sRETH")
    Collector.report(io.reth_data_in.ready)
    Collector.report(io.reth_data_in.valid)
    Collector.report(io.m_recv_data.ready)
	Collector.report(io.m_recv_data.valid)
    Collector.report(io.m_mem_write_data.ready)
	Collector.report(io.m_mem_write_data.valid)
	Collector.report(last_err, "RX_MEM_PAYLOAD::last_err")

	Collector.fire(io.m_recv_data)
	Collector.fire(io.m_mem_write_data)
	
	io.pkg_info.ready := (state === sIDLE)

	io.reth_data_in.ready               := (state === sRETH) & io.m_mem_write_data.ready & io.m_recv_data.ready
    io.aeth_data_in.ready               := (state === sAETH) & io.m_mem_write_data.ready & io.m_recv_data.ready
    io.raw_data_in.ready                := (state === sRAW) & io.m_mem_write_data.ready & io.m_recv_data.ready
	
	ToZero(io.m_mem_write_data.valid)
	ToZero(io.m_mem_write_data.bits)
	
	ToZero(io.m_recv_data.bits)		
	ToZero(io.m_recv_data.valid)

	// class ila_rx_mem(seq:Seq[Data]) extends BaseILA(seq)
  	// val mod_rx_mem = Module(new ila_rx_mem(Seq(	
	// 	pkg_info,
    //     length_cnt,
    //     io.m_recv_data.ready,
    //     io.m_recv_data.valid,
	// 	io.m_recv_data.bits.last,
    //     last_err,
    //     state
  	// )))
  	// mod_rx_mem.connect(clock)


	switch(state){
		is(sIDLE){
			when(io.pkg_info.fire){
				pkg_info	<> io.pkg_info.bits
				length_cnt	:= 0.U
				when(io.pkg_info.bits.pkg_type === PKG_TYPE.AETH){
					state	:= sAETH
				}.elsewhen(io.pkg_info.bits.pkg_type === PKG_TYPE.RETH){
                    state	:= sRETH
                }.otherwise{
					state	:= sRAW
				}
			}.otherwise{
				state	:= sIDLE
			}
		}
		is(sAETH){
			when(pkg_info.data_to_mem){
				when(io.aeth_data_in.fire){
					io.m_mem_write_data.valid 		:= 1.U 
					io.m_mem_write_data.bits 		<> io.aeth_data_in.bits
					length_cnt						:= length_cnt + 64.U
					when(io.aeth_data_in.bits.last === 1.U){
						when((length_cnt + 64.U) =/= pkg_info.length){
							last_err				:= true.B
						}
						state						:= sIDLE
					}.otherwise{
						state						:= sAETH
					}
				}				
			}.otherwise{
				when(io.aeth_data_in.fire){
					io.m_recv_data.valid 		:= 1.U 
					io.m_recv_data.bits 		<> io.aeth_data_in.bits
					length_cnt						:= length_cnt + 64.U
					when(io.aeth_data_in.bits.last === 1.U){
						when((length_cnt + 64.U) =/= pkg_info.length){
							last_err				:= true.B
						}
						state						:= sIDLE
					}.otherwise{
						state						:= sAETH
					}
				}					
			}

		}
		is(sRETH){
			when(pkg_info.data_to_mem){
				when(io.reth_data_in.fire){
					io.m_mem_write_data.valid 		:= 1.U 
					io.m_mem_write_data.bits 		<> io.reth_data_in.bits
					length_cnt						:= length_cnt + 64.U
					when(io.reth_data_in.bits.last === 1.U){
						when((length_cnt + 64.U) =/= pkg_info.length){
							last_err				:= true.B
						}
						state						:= sIDLE
					}.otherwise{
						state						:= sRETH
					}
				}	
			}.otherwise{
				when(io.reth_data_in.fire){
					io.m_recv_data.valid 		:= 1.U 
					io.m_recv_data.bits 		<> io.reth_data_in.bits
					length_cnt						:= length_cnt + 64.U
					when(io.reth_data_in.bits.last === 1.U){
						when((length_cnt + 64.U) =/= pkg_info.length){
							last_err				:= true.B
						}
						state						:= sIDLE
					}.otherwise{
						state						:= sRETH
					}
				}					
			}		
		}
		is(sRAW){
			when(pkg_info.data_to_mem){
				when(io.raw_data_in.fire){
					io.m_mem_write_data.valid 		:= 1.U 
					io.m_mem_write_data.bits 		<> io.raw_data_in.bits
					length_cnt						:= length_cnt + 64.U
					when(io.raw_data_in.bits.last === 1.U){
						when((length_cnt + 64.U) =/= pkg_info.length){
							last_err				:= true.B
						}
						state						:= sIDLE
					}.otherwise{
						state						:= sRAW
					}
				}	
			}.otherwise{
				when(io.raw_data_in.fire){
					io.m_recv_data.valid 		:= 1.U 
					io.m_recv_data.bits 		<> io.raw_data_in.bits
					length_cnt						:= length_cnt + 64.U
					when(io.raw_data_in.bits.last === 1.U){
						when((length_cnt + 64.U) =/= pkg_info.length){
							last_err				:= true.B
						}
						state						:= sIDLE
					}.otherwise{
						state						:= sRAW
					}
				}				
			}

		}		
	}


}