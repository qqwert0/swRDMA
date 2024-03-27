package swrdma

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class RxDispatch() extends Module{
	val io = IO(new Bundle{

		val meta_in	        	= Flipped(Decoupled(new Pkg_meta()))

		val conn_req 			= (Decoupled(new Conn_req()))
		val conn_rsp 			= Flipped(Decoupled(new Conn_rsp()))

		val drop_meta_out	    = (Decoupled(new Drop_meta()))
		val cc_meta_out			= (Decoupled(new CC_meta()))
		val dma_meta_out		= (Decoupled(new Dma_meta()))
		val event_meta_out		= (Decoupled(new Pkg_meta()))
	})

	val meta_fifo = XQueue(new Pkg_meta(), entries=16)
	io.ibh_meta_in 		    <> meta_fifo.io.enq

    val conn_rsp_fifo = XQueue(new Conn_rsp(), entries=16)
    io.conn_rsp                       <> conn_rsp_fifo.io.enq

    val psn_err                 = RegInit(false.B)
    Collector.report(psn_err)		

	ibh_meta_fifo.io.deq.ready                    := io.rx2psn_req.ready
    psn_rx_fifo.io.deq.ready                := io.ibh_meta_out.ready & io.drop_info_out.ready //& io.nak_event_out.ready


    io.rx2psn_req.valid                 := 0.U
    io.rx2psn_req.bits                  := 0.U.asTypeOf(io.rx2psn_req.bits)

    io.ibh_meta_out.valid               := 0.U
    io.ibh_meta_out.bits                := 0.U.asTypeOf(io.ibh_meta_out.bits)
    io.drop_info_out.valid              := 0.U
    io.drop_info_out.bits               := 0.U.asTypeOf(io.drop_info_out.bits)

    //cycle1

	when(ibh_meta_fifo.io.deq.fire()){
        io.rx2psn_req.valid             := 1.U
        io.rx2psn_req.bits.meta         := ibh_meta_fifo.io.deq.bits
        when(ibh_meta_fifo.io.deq.bits.op_code === IB_OP_CODE.RC_ACK){
            when(ibh_meta_fifo.io.deq.bits.isNAK){
                io.rx2psn_req.bits.is_nak := true.B   
            }
        }
	}

    //cycle2

    when(psn_rx_fifo.io.deq.fire()){
        io.ibh_meta_out.valid               := 1.U
        io.ibh_meta_out.bits                := psn_rx_fifo.io.deq.bits.meta
        when(psn_rx_fifo.io.deq.bits.meta.op_code === IB_OP_CODE.RC_ACK){   
            io.drop_info_out.valid          := 1.U
            io.drop_info_out.bits           := false.B 
        }.elsewhen(PKG_JUDGE.REQ_PKG(psn_rx_fifo.io.deq.bits.meta.op_code)){
            when(psn_rx_fifo.io.deq.bits.meta.psn === psn_rx_fifo.io.deq.bits.state.rx_epsn){                     
                io.drop_info_out.valid          := 1.U
                io.drop_info_out.bits           := false.B                                    
            }.elsewhen(psn_rx_fifo.io.deq.bits.meta.psn < psn_rx_fifo.io.deq.bits.state.rx_epsn){
                psn_err                         := true.B
                io.drop_info_out.valid          := 1.U
                io.drop_info_out.bits           := true.B   
            }otherwise{          
                psn_err                         := true.B          
                io.drop_info_out.valid          := 1.U
                io.drop_info_out.bits           := true.B 
            }  
        }.otherwise{
            when(psn_rx_fifo.io.deq.bits.meta.psn === psn_rx_fifo.io.deq.bits.state.tx_old_unack){
                io.drop_info_out.valid          := 1.U
                io.drop_info_out.bits           := false.B                                    
            }.elsewhen(psn_rx_fifo.io.deq.bits.meta.psn < psn_rx_fifo.io.deq.bits.state.tx_old_unack){
                psn_err                         := true.B
                io.drop_info_out.valid          := 1.U
                io.drop_info_out.bits           := true.B   
            }otherwise{                    
                psn_err                         := true.B
                io.drop_info_out.valid          := 1.U
                io.drop_info_out.bits           := true.B 
            }                    
        }
    } 	


}