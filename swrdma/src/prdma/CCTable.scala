package swrdma

import common.storage._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector


class CCTable() extends Module{
	val io = IO(new Bundle{
		val rx2cc_req  	    = Flipped(Decoupled(new CC_req()))
		val tx2cc_req	    = Flipped(Decoupled(new CC_req()))
		val cc_init	        = Flipped(Decoupled(new CC_init()))
		val cc2tx_rsp	    = (Decoupled(new CC_state()))
        val cc2rx_rsp	    = (Decoupled(new CC_state()))
        // val rx_lock         = Output(UInt(16.W))
        // val tx_lock         = Output(UInt(16.W))
	})


    val cc_tx_fifo = XQueue(new CC_req(), entries=16)
    val cc_rx_fifo = XQueue(new CC_req(), entries=16)

    io.rx2cc_req                      <> cc_rx_fifo.io.in
    io.tx2cc_req                      <> cc_tx_fifo.io.in

    val cc_table = XRam(new CC_state(), CONFIG.MAX_QPS, latency = 1)

    val cc_request = RegInit(0.U.asTypeOf(new CC_req()))
    // val rx_request = RegInit(0.U.asTypeOf(new CC_req()))
    val cc_state_r = RegInit(0.U.asTypeOf(new CC_state()))
    val rx_lock = RegInit("hffff".U(16.W))
    val tx_lock = RegInit("hffff".U(16.W))





	val sIDLE :: sTXRSP :: sRXRSP :: sTXRSP2 :: sRXRSP2 :: Nil = Enum(5)
	val state                   = RegInit(sIDLE)
    cc_table.io.addr_a                 := 0.U
    cc_table.io.addr_b                 := 0.U
    cc_table.io.wr_en_a                := 0.U
    cc_table.io.data_in_a              := 0.U.asTypeOf(cc_table.io.data_in_a)

    cc_tx_fifo.io.out.ready               := (state === sIDLE) & (!io.cc_init.valid.asBool) & (cc_tx_fifo.io.out.bits.qpn =/= rx_lock)
    cc_rx_fifo.io.out.ready               := (state === sIDLE) & (!io.cc_init.valid.asBool) & (!cc_tx_fifo.io.out.fire()) & (cc_rx_fifo.io.out.bits.qpn =/= tx_lock)
    io.cc_init.ready                      := 1.U


    ToZero(io.cc2tx_rsp.valid)
    ToZero(io.cc2tx_rsp.bits)                  
    ToZero(io.cc2rx_rsp.valid)
    ToZero(io.cc2rx_rsp.bits) 


    switch(state){
        is(sIDLE){
            when(io.cc_init.fire()){
                cc_table.io.addr_a                    := io.cc_init.bits.qpn
                cc_table.io.wr_en_a                   := 1.U
                cc_table.io.data_in_a                 := io.cc_init.bits.cc_state
                state                                   := sIDLE        
            }.elsewhen(cc_tx_fifo.io.out.fire()){
                cc_request                            := cc_tx_fifo.io.out.bits
                when(cc_tx_fifo.io.out.bits.lock){
                    tx_lock                             := cc_tx_fifo.io.out.bits.qpn
                }.otherwise{
                    tx_lock                             := "hffff".U
                }
                when(cc_tx_fifo.io.out.bits.is_wr){
                    cc_table.io.addr_a                    := cc_tx_fifo.io.out.bits.qpn
                    cc_table.io.wr_en_a                   := 1.U
                    cc_table.io.data_in_a                 := cc_tx_fifo.io.out.bits.cc_state
                    state                                   := sIDLE
                }.otherwise{
                    cc_table.io.addr_b             := cc_tx_fifo.io.out.bits.qpn
                    state                            := sTXRSP
                }
            }.elsewhen(cc_rx_fifo.io.out.fire()){
                cc_request                            := cc_rx_fifo.io.out.bits
                when(cc_rx_fifo.io.out.bits.lock){
                    rx_lock                             := cc_rx_fifo.io.out.bits.qpn
                }.otherwise{
                    rx_lock                             := "hffff".U
                }                
                when(cc_rx_fifo.io.out.bits.is_wr){
                    cc_table.io.addr_a                    := cc_rx_fifo.io.out.bits.qpn
                    cc_table.io.wr_en_a                   := 1.U
                    cc_table.io.data_in_a                 := cc_rx_fifo.io.out.bits.cc_state
                    state                                   := sIDLE
                }.otherwise{                
                    cc_table.io.addr_b             := cc_rx_fifo.io.out.bits.qpn
                    state                            := sRXRSP
                }
            }.otherwise{
                state                           := sIDLE
            } 
        }
        is(sTXRSP){
            when(io.cc2tx_rsp.ready){
                io.cc2tx_rsp.valid 		    := 1.U 
                io.cc2tx_rsp.bits 		    <> cc_table.io.data_out_b    
                state                           := sIDLE            
            }.otherwise{
                cc_state_r                    <> cc_table.io.data_out_b
                state                           := sTXRSP2
            }
        }
        is(sRXRSP){
            when(io.cc2rx_rsp.ready){
                io.cc2rx_rsp.valid 		    := 1.U 
                io.cc2rx_rsp.bits 		    <> cc_table.io.data_out_b    
                state                           := sIDLE            
            }.otherwise{
                cc_state_r                    <> cc_table.io.data_out_b
                state                           := sRXRSP2
            }
        }
        is(sTXRSP2){
            when(io.cc2tx_rsp.ready){
                io.cc2tx_rsp.valid 		    := 1.U 
                io.cc2tx_rsp.bits 		    <> cc_state_r
                state                           := sIDLE              
            }
        }
        is(sRXRSP2){
            when(io.cc2rx_rsp.ready){
                io.cc2rx_rsp.valid 		    := 1.U 
                io.cc2rx_rsp.bits 		    <> cc_state_r  
                state                           := sIDLE              
            }
        }
    }

}