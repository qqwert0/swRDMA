package network.roce.table

import common.storage._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector


class CONN_TABLE() extends Module{
	val io = IO(new Bundle{
		val rx2conn_req  	= Flipped(Decoupled(new Conn_req()))
		val tx2conn_req	    = Flipped(Decoupled(new Conn_req()))
		val conn_init	    = Flipped(Decoupled(new Conn_init()))
		val conn2tx_rsp	    = (Decoupled(new Conn_state()))
        val conn2rx_rsp	    = (Decoupled(new Conn_state()))
	})


    val conn_tx_fifo = XQueue(new Conn_req(), entries=16)
    val conn_rx_fifo = XQueue(new Conn_req(), entries=16)

    io.rx2conn_req                      <> conn_rx_fifo.io.in
    io.tx2conn_req                      <> conn_tx_fifo.io.in

    val conn_table = XRam(new Conn_state(), CONFIG.MAX_QPS, latency = 1)

    val conn_request = RegInit(0.U.asTypeOf(new Conn_req()))
    val conn_state_r = RegInit(0.U.asTypeOf(new Conn_state()))

	


	val sIDLE :: sTXRSP :: sRXRSP :: sTXRSP2 :: sRXRSP2 :: Nil = Enum(5)
	val state                   = RegInit(sIDLE)
    conn_table.io.addr_a                 := 0.U
    conn_table.io.addr_b                 := 0.U
    conn_table.io.wr_en_a                := 0.U
    conn_table.io.data_in_a              := 0.U.asTypeOf(conn_table.io.data_in_a)

    conn_tx_fifo.io.out.ready               := (state === sIDLE) & (!io.conn_init.valid.asBool)
    conn_rx_fifo.io.out.ready               := (state === sIDLE) & (!io.conn_init.valid.asBool) & (!conn_tx_fifo.io.out.valid.asBool)
    io.conn_init.ready                      := 1.U


    ToZero(io.conn2tx_rsp.valid)
    ToZero(io.conn2tx_rsp.bits)                  
    ToZero(io.conn2rx_rsp.valid)
    ToZero(io.conn2rx_rsp.bits) 

    switch(state){
        is(sIDLE){
            when(io.conn_init.fire()){
                conn_table.io.addr_a                    := io.conn_init.bits.qpn
                conn_table.io.wr_en_a                   := 1.U
                conn_table.io.data_in_a                 := io.conn_init.bits.conn_state
                state                                   := sIDLE        
            }.elsewhen(conn_tx_fifo.io.out.fire()){
                conn_request                            := conn_tx_fifo.io.out.bits
                when(conn_tx_fifo.io.out.bits.is_wr){
                    conn_table.io.addr_a                    := conn_tx_fifo.io.out.bits.qpn
                    conn_table.io.wr_en_a                   := 1.U
                    conn_table.io.data_in_a                 := conn_tx_fifo.io.out.bits.conn_state
                    state                                   := sIDLE
                }.otherwise{
                    conn_table.io.addr_b             := conn_tx_fifo.io.out.bits.qpn
                    state                            := sTXRSP
                }
            }.elsewhen(conn_rx_fifo.io.out.fire()){
                conn_request                            := conn_rx_fifo.io.out.bits
                when(conn_rx_fifo.io.out.bits.is_wr){
                    conn_table.io.addr_a                    := conn_rx_fifo.io.out.bits.qpn
                    conn_table.io.wr_en_a                   := 1.U
                    conn_table.io.data_in_a                 := conn_rx_fifo.io.out.bits.conn_state
                    state                                   := sIDLE
                }.otherwise{                
                    conn_table.io.addr_b             := conn_rx_fifo.io.out.bits.qpn
                    state                            := sRXRSP
                }
            }.otherwise{
                state                           := sIDLE
            } 
        }
        is(sTXRSP){
            when(io.conn2tx_rsp.ready){
                io.conn2tx_rsp.valid 		    := 1.U 
                io.conn2tx_rsp.bits 		    <> conn_table.io.data_out_b    
                state                           := sIDLE            
            }.otherwise{
                conn_state_r                    <> conn_table.io.data_out_b
                state                           := sTXRSP2
            }
        }
        is(sRXRSP){
            when(io.conn2rx_rsp.ready){
                io.conn2rx_rsp.valid 		    := 1.U 
                io.conn2rx_rsp.bits 		    <> conn_table.io.data_out_b    
                state                           := sIDLE            
            }.otherwise{
                conn_state_r                    <> conn_table.io.data_out_b
                state                           := sRXRSP2
            }
        }
        is(sTXRSP2){
            when(io.conn2tx_rsp.ready){
                io.conn2tx_rsp.valid 		    := 1.U 
                io.conn2tx_rsp.bits 		    <> conn_state_r
                state                           := sIDLE              
            }
        }
        is(sRXRSP2){
            when(io.conn2rx_rsp.ready){
                io.conn2rx_rsp.valid 		    := 1.U 
                io.conn2rx_rsp.bits 		    <> conn_state_r  
                state                           := sIDLE              
            }
        }
    }

}