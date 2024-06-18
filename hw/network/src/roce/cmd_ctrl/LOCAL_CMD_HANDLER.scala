package network.roce.cmd_ctrl

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.BaseILA
import common.Collector

class LOCAL_CMD_HANDLER() extends Module{
	val io = IO(new Bundle{
		val s_tx_meta  		= Flipped(Decoupled(new TX_META()))

		val local_read_addr	= (Decoupled(new MQ_POP_REQ(UInt(64.W))))
        val tx_local_event	= (Decoupled(new IBH_META()))
	})


	val rdma_meta = RegInit(0.U.asTypeOf(new TX_META()))
    val laddr = RegInit(0.U(48.W))
    val raddr = RegInit(0.U(48.W))
    val length = RegInit(0.U(32.W))

	val sIDLE :: sWRITE :: sSEND :: Nil = Enum(3)
	val state                   = RegInit(sIDLE)
    Collector.report(state===sIDLE, "LOCAL_CMD_HANDLER===sIDLE")	
	
	io.s_tx_meta.ready          := (state === sIDLE) & io.local_read_addr.ready & io.tx_local_event.ready

    io.local_read_addr.bits 	:= 0.U.asTypeOf(io.local_read_addr.bits)
    io.local_read_addr.valid 	:= 0.U

    io.tx_local_event.bits 		:= 0.U.asTypeOf(io.tx_local_event.bits)
    io.tx_local_event.valid 	:= 0.U



	
	switch(state){
		is(sIDLE){
			when(io.s_tx_meta.fire){
				rdma_meta	                        <> io.s_tx_meta.bits
				when(io.s_tx_meta.bits.rdma_cmd === APP_OP_CODE.APP_READ){
                    state	                        := sIDLE
					io.local_read_addr.valid        := 1.U
                    io.local_read_addr.bits.q_index := io.s_tx_meta.bits.qpn
                    io.local_read_addr.bits.data    := io.s_tx_meta.bits.local_vaddr
                    io.tx_local_event.valid         := 1.U
                    io.tx_local_event.bits.local_event(IB_OP_CODE.RC_READ_REQUEST, io.s_tx_meta.bits.qpn, io.s_tx_meta.bits.local_vaddr, io.s_tx_meta.bits.remote_vaddr, io.s_tx_meta.bits.length)                  
				}.elsewhen(io.s_tx_meta.bits.rdma_cmd === APP_OP_CODE.APP_WRITE){
                    when(io.s_tx_meta.bits.length > CONFIG.MTU.U){
                        state	                    := sWRITE
                        laddr                       := io.s_tx_meta.bits.local_vaddr + CONFIG.MTU.U
                        raddr                       := io.s_tx_meta.bits.remote_vaddr + CONFIG.MTU.U
                        length                      := io.s_tx_meta.bits.length - CONFIG.MTU.U  
                        io.tx_local_event.bits.local_event(IB_OP_CODE.RC_WRITE_FIRST, io.s_tx_meta.bits.qpn, io.s_tx_meta.bits.local_vaddr, io.s_tx_meta.bits.remote_vaddr, io.s_tx_meta.bits.length)                       
                    }.otherwise{
                        state	                    := sIDLE
                        laddr                       := io.s_tx_meta.bits.local_vaddr
                        raddr                       := io.s_tx_meta.bits.remote_vaddr
                        length                      := io.s_tx_meta.bits.length
                        io.tx_local_event.bits.local_event(IB_OP_CODE.RC_WRITE_ONLY, io.s_tx_meta.bits.qpn, io.s_tx_meta.bits.local_vaddr, io.s_tx_meta.bits.remote_vaddr, io.s_tx_meta.bits.length) 
                    }
                    io.tx_local_event.valid         := 1.U
                }.otherwise{
                    when(io.s_tx_meta.bits.length > CONFIG.MTU.U){
                        state	                    := sSEND
                        length                      := io.s_tx_meta.bits.length - CONFIG.MTU.U  
                        io.tx_local_event.bits.local_event(IB_OP_CODE.RC_DIRECT_FIRST, io.s_tx_meta.bits.qpn, io.s_tx_meta.bits.local_vaddr, io.s_tx_meta.bits.remote_vaddr, io.s_tx_meta.bits.length)                       
                    }.otherwise{
                        state	                    := sIDLE
                        length                      := io.s_tx_meta.bits.length
                        io.tx_local_event.bits.local_event(IB_OP_CODE.RC_DIRECT_ONLY, io.s_tx_meta.bits.qpn, io.s_tx_meta.bits.local_vaddr, io.s_tx_meta.bits.remote_vaddr, io.s_tx_meta.bits.length) 
                    }
                    io.tx_local_event.valid         := 1.U
				}
			}
		}
		is(sWRITE){
			when(io.tx_local_event.ready){
                when(length > CONFIG.MTU.U){
                    state	                    := sWRITE
                    laddr                       := laddr + CONFIG.MTU.U
                    raddr                       := raddr + CONFIG.MTU.U
                    length                      := length - CONFIG.MTU.U   
                    io.tx_local_event.bits.local_event(IB_OP_CODE.RC_WRITE_MIDDLE, rdma_meta.qpn, laddr, raddr, CONFIG.MTU.U)                     
                }.otherwise{
                    state	                    := sIDLE
                    laddr                       := 0.U
                    raddr                       := 0.U
                    length                      := 0.U
                    io.tx_local_event.bits.local_event(IB_OP_CODE.RC_WRITE_LAST, rdma_meta.qpn, laddr, raddr, length)
                }
                io.tx_local_event.valid         := 1.U  
			}
		}        
		is(sSEND){
			when(io.tx_local_event.ready){
                when(length > CONFIG.MTU.U){
                    state	                    := sSEND
                    length                      := length - CONFIG.MTU.U   
                    io.tx_local_event.bits.local_event(IB_OP_CODE.RC_DIRECT_MIDDLE, rdma_meta.qpn, 0.U, 0.U, CONFIG.MTU.U)                     
                }.otherwise{
                    state	                    := sIDLE
                    length                      := 0.U
                    io.tx_local_event.bits.local_event(IB_OP_CODE.RC_DIRECT_LAST, rdma_meta.qpn, 0.U, 0.U, length)
                }
                io.tx_local_event.valid         := 1.U  
			}
		} 
	}

}