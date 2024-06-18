package network.roce.table

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector
import common.ToZero


class MSN_TABLE() extends Module{
	val io = IO(new Bundle{
		val rx2msn_req  	= Flipped(Decoupled(new MSN_REQ()))
        val rx2msn_wr       = Flipped(Decoupled(new MSN_REQ()))
		val tx2msn_req	= Flipped(Decoupled(new MSN_REQ()))
		val msn_init	= Flipped(Decoupled(new MSN_INIT()))
		val msn2rx_rsp	= (Decoupled(new MSN_RSP()))
		val msn2tx_rsp	= (Decoupled(new MSN_RSP()))
	})

    val msn_rx_fifo = Module(new Queue(new MSN_REQ(), entries=16))
    val msn_tx_fifo = Module(new Queue(new MSN_REQ(), entries=16))
    val msn_init_fifo = Module(new Queue(new MSN_INIT(), entries=16))
    val rx_rsp_fifo = XQueue(new MSN_RSP(), entries=16)
    val tx_rsp_fifo = XQueue(new MSN_RSP(), entries=16)


    io.rx2msn_req                       <> msn_rx_fifo.io.enq
    io.tx2msn_req                       <> msn_tx_fifo.io.enq
    io.msn_init                         <> msn_init_fifo.io.enq

    io.msn2rx_rsp                       <> rx_rsp_fifo.io.out
    io.msn2tx_rsp                       <> tx_rsp_fifo.io.out

    val msn_table = XRam(new MSN_STATE(), CONFIG.MAX_QPS, latency = 1)

    val msn_request = RegInit(0.U.asTypeOf(new MSN_REQ()))
    val msn_init_tmp = RegInit(0.U.asTypeOf(new MSN_INIT()))
    
    

	val sIDLE :: sTXRSP :: sRXRSP :: sRXWR :: sINIT :: Nil = Enum(5)
	val state                   = RegInit(sIDLE)
    Collector.report(state===sIDLE, "MSN_TABLE===sIDLE")  
    msn_table.io.addr_a                 := 0.U
    msn_table.io.addr_b                 := 0.U
    msn_table.io.wr_en_a                := 0.U
    msn_table.io.data_in_a              := 0.U.asTypeOf(msn_table.io.data_in_a)

    
    msn_init_fifo.io.deq.ready                  := 1.U
    msn_rx_fifo.io.deq.ready                    := (!msn_init_fifo.io.deq.valid.asBool) & (!rx_rsp_fifo.io.almostfull)
    msn_tx_fifo.io.deq.ready                    := (!msn_init_fifo.io.deq.valid.asBool) & (!msn_rx_fifo.io.deq.valid.asBool) & (!tx_rsp_fifo.io.almostfull)
    io.rx2msn_wr.ready                          := (!msn_init_fifo.io.deq.valid.asBool) & (!msn_rx_fifo.io.deq.valid.asBool) & (!msn_tx_fifo.io.deq.valid.asBool)

    ToZero(rx_rsp_fifo.io.in.valid)
    ToZero(rx_rsp_fifo.io.in.bits)
    ToZero(tx_rsp_fifo.io.in.valid)
    ToZero(tx_rsp_fifo.io.in.bits)

    //cycle 1

    when(msn_rx_fifo.io.deq.fire){
        msn_request                     := msn_rx_fifo.io.deq.bits
        msn_table.io.addr_b             := msn_rx_fifo.io.deq.bits.qpn
        state                           := sRXRSP
    }.elsewhen(io.rx2msn_wr.fire){
        msn_request                     := io.rx2msn_wr.bits
        msn_table.io.addr_b             := io.rx2msn_wr.bits.qpn
        state                           := sRXWR       
    }.elsewhen(msn_tx_fifo.io.deq.fire){
        msn_request                     := msn_tx_fifo.io.deq.bits
        msn_table.io.addr_b             := msn_tx_fifo.io.deq.bits.qpn
        state                           := sTXRSP
    }.elsewhen(msn_init_fifo.io.deq.fire){
        msn_init_tmp                    := msn_init_fifo.io.deq.bits
        state                           := sINIT
    }.otherwise{
        state                           := sIDLE
    }

    //cycle 2

    when(state === sRXRSP){
		rx_rsp_fifo.io.in.valid 		    := 1.U 
		rx_rsp_fifo.io.in.bits.msn_state 	:= msn_table.io.data_out_b   
        rx_rsp_fifo.io.in.bits.meta         := msn_request.meta   
        when((msn_request.meta.op_code === IB_OP_CODE.RC_WRITE_FIRST) || (msn_request.meta.op_code === IB_OP_CODE.RC_WRITE_ONLY)){
            msn_table.io.addr_a             := msn_request.meta.qpn
            msn_table.io.wr_en_a            := 1.U
            msn_table.io.data_in_a.msn      := msn_table.io.data_out_b.msn + 1.U
            msn_table.io.data_in_a.vaddr    := msn_request.meta.vaddr + msn_request.meta.udp_length -8.U-12.U-16.U-4.U 
            msn_table.io.data_in_a.length   := msn_request.meta.length - (msn_request.meta.udp_length -8.U-12.U-16.U-4.U)                      
            msn_table.io.data_in_a.pkg_num  := msn_table.io.data_out_b.pkg_num
            msn_table.io.data_in_a.pkg_total:= msn_table.io.data_out_b.pkg_total    
        }.elsewhen((msn_request.meta.op_code === IB_OP_CODE.RC_WRITE_MIDDLE) || (msn_request.meta.op_code === IB_OP_CODE.RC_WRITE_LAST)){
            msn_table.io.addr_a             := msn_request.meta.qpn
            msn_table.io.wr_en_a            := 1.U
            msn_table.io.data_in_a.msn      := msn_table.io.data_out_b.msn
            msn_table.io.data_in_a.vaddr    := msn_table.io.data_out_b.vaddr + msn_request.meta.udp_length -8.U-12.U-4.U 
            msn_table.io.data_in_a.length   := msn_table.io.data_out_b.length - (msn_request.meta.udp_length -8.U-12.U-4.U)                      
            msn_table.io.data_in_a.pkg_num  := msn_table.io.data_out_b.pkg_num
            msn_table.io.data_in_a.pkg_total:= msn_table.io.data_out_b.pkg_total  
        }.elsewhen((msn_request.meta.op_code === IB_OP_CODE.RC_READ_REQUEST)){
            msn_table.io.addr_a             := msn_request.meta.qpn
            msn_table.io.wr_en_a            := 1.U
            msn_table.io.data_in_a.msn      := msn_table.io.data_out_b.msn + 1.U
            msn_table.io.data_in_a.vaddr    := msn_table.io.data_out_b.vaddr
            msn_table.io.data_in_a.length   := msn_table.io.data_out_b.length                    
            msn_table.io.data_in_a.pkg_num  := msn_table.io.data_out_b.pkg_num
            msn_table.io.data_in_a.pkg_total:= msn_table.io.data_out_b.pkg_total             
        }.elsewhen((msn_request.meta.op_code === IB_OP_CODE.RC_READ_RESP_MIDDLE)){
            msn_table.io.addr_a             := msn_request.meta.qpn
            msn_table.io.wr_en_a            := 1.U
            msn_table.io.data_in_a.msn      := msn_table.io.data_out_b.msn
            msn_table.io.data_in_a.vaddr    := msn_table.io.data_out_b.vaddr + msn_request.meta.udp_length -8.U-12.U-4.U 
            msn_table.io.data_in_a.length   := msn_table.io.data_out_b.length - (msn_request.meta.udp_length -8.U-12.U-4.U)                     
            msn_table.io.data_in_a.pkg_num  := msn_table.io.data_out_b.pkg_num
            msn_table.io.data_in_a.pkg_total:= msn_table.io.data_out_b.pkg_total               
        }.elsewhen((msn_request.meta.op_code === IB_OP_CODE.RC_DIRECT_FIRST) || (msn_request.meta.op_code === IB_OP_CODE.RC_DIRECT_ONLY)){
            msn_table.io.addr_a             := msn_request.meta.qpn
            msn_table.io.wr_en_a            := 1.U
            msn_table.io.data_in_a.msn      := msn_table.io.data_out_b.msn + 1.U
            msn_table.io.data_in_a.vaddr    := msn_request.meta.vaddr + msn_request.meta.udp_length -8.U-12.U-16.U-4.U 
            msn_table.io.data_in_a.length   := msn_request.meta.length - (msn_request.meta.udp_length -8.U-12.U-16.U-4.U)                      
            msn_table.io.data_in_a.pkg_num  := 1.U
            msn_table.io.data_in_a.pkg_total:= msn_request.pkg_total               
        }.elsewhen((msn_request.meta.op_code === IB_OP_CODE.RC_DIRECT_MIDDLE) || (msn_request.meta.op_code === IB_OP_CODE.RC_DIRECT_LAST)){
            msn_table.io.addr_a             := msn_request.meta.qpn
            msn_table.io.wr_en_a            := 1.U
            msn_table.io.data_in_a.msn      := msn_table.io.data_out_b.msn
            msn_table.io.data_in_a.vaddr    := msn_table.io.data_out_b.vaddr + msn_request.meta.udp_length -8.U-12.U-4.U 
            msn_table.io.data_in_a.length   := msn_table.io.data_out_b.length - (msn_request.meta.udp_length -8.U-12.U-4.U)                      
            msn_table.io.data_in_a.pkg_num  := msn_table.io.data_out_b.pkg_num + 1.U
            msn_table.io.data_in_a.pkg_total:= msn_table.io.data_out_b.pkg_total           
        }.otherwise{
            msn_table.io.wr_en_a            := 0.U
        }
    }.elsewhen(state === sTXRSP){
		tx_rsp_fifo.io.in.valid 		    := 1.U 
		tx_rsp_fifo.io.in.bits.msn_state 	<> msn_table.io.data_out_b 
        tx_rsp_fifo.io.in.bits.meta         := msn_request.meta 
    }.elsewhen(state === sINIT){
        msn_table.io.addr_a                 := msn_init_tmp.qpn
        msn_table.io.wr_en_a                := 1.U
        msn_table.io.data_in_a.msn          := msn_init_tmp.msn
        msn_table.io.data_in_a.r_key        := msn_init_tmp.r_key        
    }.elsewhen(state === sRXWR){
        msn_table.io.addr_a             := msn_request.meta.qpn
        msn_table.io.wr_en_a            := 1.U
        msn_table.io.data_in_a.msn      := msn_request.msn
        msn_table.io.data_in_a.vaddr    := msn_request.vaddr
        msn_table.io.data_in_a.length   := msn_request.length               
        msn_table.io.data_in_a.pkg_num  := msn_request.pkg_num
        msn_table.io.data_in_a.pkg_total:= msn_request.pkg_total         
    }


}