package network.roce.table

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector


class VaddrTable() extends Module{
	val io = IO(new Bundle{
		val rx2vaddr_req  	= Flipped(Decoupled(new Vaddr_req()))
		val vaddr2rx_rsp	    = (Decoupled(new Vaddr_rsp()))
	})


    val vaddr_rx_fifo = XQueue(new Vaddr_req(), entries=16)

    io.rx2vaddr_req                      <> vaddr_rx_fifo.io.in

    val vaddr_table = XRam(new Vaddr_state (), CONFIG.MAX_QPS, latency = 1)

    val vaddr_request = RegInit(0.U.asTypeOf(new Vaddr_req()))
    val vaddr_state_r = RegInit(0.U.asTypeOf(new Vaddr_state()))

	


	val sIDLE :: sRXRSP :: sRXRSP2 :: Nil = Enum(3)
	val state                   = RegInit(sIDLE)
    vaddr_table.io.addr_a                 := 0.U
    vaddr_table.io.addr_b                 := 0.U
    vaddr_table.io.wr_en_a                := 0.U
    vaddr_table.io.data_in_a              := 0.U.asTypeOf(vaddr_table.io.data_in_a)

    vaddr_rx_fifo.io.out.ready               := (state === sIDLE) 


    ToZero(io.vaddr2rx_rsp.valid)
    ToZero(io.vaddr2rx_rsp.bits)                  


    switch(state){
        is(sIDLE){
            when(vaddr_rx_fifo.io.out.fire()){
                conn_request                            := vaddr_rx_fifo.io.out.bits
                when(vaddr_rx_fifo.io.out.bits.is_wr){
                    vaddr_table.io.addr_a                    := vaddr_rx_fifo.io.out.bits.qpn
                    vaddr_table.io.wr_en_a                   := 1.U
                    vaddr_table.io.data_in_a                 := vaddr_rx_fifo.io.out.bits.vaddr_state
                    state                                   := sIDLE
                }.otherwise{                
                    conn_table.io.addr_b             := vaddr_rx_fifo.io.out.bits.qpn
                    state                            := sRXRSP
                }    
            }.otherwise{
                state                           := sIDLE
            } 
        }
        is(sRXRSP){
            when(io.vaddr2rx_rsp.ready){
                io.vaddr2rx_rsp.valid 		    := 1.U 
                io.vaddr2rx_rsp.bits 		    <> vaddr_table.io.data_out_b    
                state                           := sIDLE            
            }.otherwise{
                vaddr_state_r                    <> vaddr_table.io.data_out_b
                state                           := sRXRSP2
            }
        }
        is(sRXRSP2){
            when(io.vaddr2rx_rsp.ready){
                io.vaddr2rx_rsp.valid 		    := 1.U 
                io.vaddr2rx_rsp.bits 		    <> vaddr_state_r  
                state                           := sIDLE              
            }
        }
    }



}