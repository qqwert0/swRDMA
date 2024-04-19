package swrdma

import common.storage._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector




class CSR() extends Module{
	val io = IO(new Bundle{
        //riscv interface
		val cmd  	        = Input(UInt(3.W))
        val addr            = Input(UInt(6.W))
        val data_in         = Input(UInt(32.W))
        val data_out        = Output(UInt(32.W))
        //hw interface
        val has_event_wr	    = Input(Bool())   //write pkg_meta & cc_state
        val has_event_rd	    = Output(Bool())  // has_event_rd ==0 &  event_recv_cnt == event_processed_cnt
        val event_recv_cnt	    = Output(UInt(32.W))
        val event_processed_cnt	= Output(UInt(32.W))
        val event_type	        = Output(UInt(32.W))
        val user_csr_wr	    = Input(Vec(32,UInt(32.W)))
		val user_csr_rd	    = Output(Vec(32,UInt(32.W)))
	})

    

    val CSR = RegInit(VecInit(Seq.fill(32)(0.U(32.W))))

    val has_event = RegInit(false.B)
    val event_recv_cnt = RegInit(0.U(32.W))
    val event_processed_cnt = RegInit(0.U(32.W))
    val event_type = RegInit(0.U(32.W))

    io.data_out     := 0.U    

    io.event_recv_cnt   := event_recv_cnt
    io.event_processed_cnt   := event_processed_cnt
    io.event_type   := event_type
    io.has_event_rd := has_event

    when(io.cmd === 1.U){
        CSR(io.addr)           := io.data_in
    }.elsewhen(io.cmd === 2.U){
        io.data_out         := CSR(io.addr) 
    }.elsewhen(io.has_event_wr){
        has_event           := true.B
        event_recv_cnt      := event_recv_cnt + 1.U
        CSR                 := io.user_csr_wr
    }

    when(has_event){  
        has_event           := false.B
    }

    when(event_recv_cnt =/= event_processed_cnt){
        event_processed_cnt := event_recv_cnt
    }

    io.user_csr_rd          := CSR


}