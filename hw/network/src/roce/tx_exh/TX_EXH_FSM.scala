package network.roce.tx_exh

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class TX_EXH_FSM() extends Module{
	val io = IO(new Bundle{
		val event_in            = Flipped(Decoupled(new IBH_META()))

        val msn2tx_rsp          = Flipped(Decoupled(new MSN_RSP()))

        val tx2msn_req          = (Decoupled(new MSN_REQ()))

        val ibh_meta_out	    = (Decoupled(new IBH_META()))

        val pkg_type2exh        = (Decoupled(new TX_PKG_INFO()))
        val head_data_out       = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))


	})

    Collector.fire(io.event_in)
    // Collector.count(io.event_in.fire & io.event_in.bits.qpn === 1.U & io.event_in.bits.op_code === IB_OP_CODE.RC_DIRECT_ONLY, "QPN1 PKG")
    // Collector.count(io.event_in.fire & io.event_in.bits.qpn === 1.U & io.event_in.bits.op_code === IB_OP_CODE.RC_ACK, "QPN1 ACK")
    // Collector.count(io.event_in.fire & io.event_in.bits.qpn === 2.U & io.event_in.bits.op_code === IB_OP_CODE.RC_DIRECT_ONLY, "QPN2 PKG")
    // Collector.count(io.event_in.fire & io.event_in.bits.qpn === 2.U & io.event_in.bits.op_code === IB_OP_CODE.RC_ACK, "QPN2 ACK")

    val msn_tx_fifo = Module(new Queue(new MSN_RSP(), 4))
    val event_fifo = Module(new Queue(new IBH_META(), 4))

    io.msn2tx_rsp                       <> msn_tx_fifo.io.enq
    io.event_in                         <> event_fifo.io.enq

	val event_meta = WireInit(0.U.asTypeOf(new IBH_META()))
    val msn_meta = RegInit(0.U.asTypeOf(new MSN_RSP()))

    val reth_head = Wire(new RETH_HEADER())
    val aeth_head = Wire(new AETH_HEADER())

    reth_head       := 0.U.asTypeOf(reth_head)
    aeth_head       := 0.U.asTypeOf(aeth_head)

    val udp_length = WireInit(0.U(16.W))

	val sIDLE :: sGENERATE :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)
    Collector.report(state===sIDLE, "TX_EXH_FSM===sIDLE")  	
	
	event_fifo.io.deq.ready               := io.tx2msn_req.ready
    msn_tx_fifo.io.deq.ready             := io.ibh_meta_out.ready & io.head_data_out.ready & io.pkg_type2exh.ready



    io.tx2msn_req.valid             := 0.U
    io.tx2msn_req.bits              := 0.U.asTypeOf(io.tx2msn_req.bits)
    io.ibh_meta_out.valid           := 0.U
    io.ibh_meta_out.bits            := 0.U.asTypeOf(io.ibh_meta_out.bits)
    io.pkg_type2exh.valid           := 0.U
    io.pkg_type2exh.bits            := 0.U.asTypeOf(io.pkg_type2exh.bits)
    io.head_data_out.valid          := 0.U
    io.head_data_out.bits           := 0.U.asTypeOf(io.head_data_out.bits)


    //cycle 1
	when(event_fifo.io.deq.fire){
        io.tx2msn_req.valid             := 1.U
        io.tx2msn_req.bits.qpn          := event_fifo.io.deq.bits.qpn
        io.tx2msn_req.bits.meta         := event_fifo.io.deq.bits
	}

    //cycle 2

    when(msn_tx_fifo.io.deq.fire){
        msn_meta                        <> msn_tx_fifo.io.deq.bits
        event_meta                      := msn_tx_fifo.io.deq.bits.meta
        switch(event_meta.op_code){
            is(IB_OP_CODE.RC_WRITE_FIRST){
                reth_head.length                := Util.reverse(event_meta.length)
                reth_head.vaddr                 := Util.reverse(event_meta.vaddr)
                io.head_data_out.valid          := 1.U
                io.head_data_out.bits.data      := reth_head.asTypeOf(io.head_data_out.bits.data)
                io.head_data_out.bits.keep      := "hffff".U
                io.head_data_out.bits.last      := 1.U
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := false.B
                io.pkg_type2exh.bits.hasHeader  := true.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := CONFIG.MTU.U + 8.U+12.U+16.U+4.U //UDP, BTH, RETH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length  
                state                           := sIDLE                   
            }
            is(IB_OP_CODE.RC_WRITE_ONLY){
                reth_head.length                := Util.reverse(event_meta.length)
                reth_head.vaddr                 := Util.reverse(event_meta.vaddr)
                io.head_data_out.valid          := 1.U
                io.head_data_out.bits.data      := reth_head.asTypeOf(io.head_data_out.bits.data)
                io.head_data_out.bits.keep      := "hffff".U
                io.head_data_out.bits.last      := 1.U
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := false.B
                io.pkg_type2exh.bits.hasHeader  := true.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := event_meta.length + 8.U+12.U+16.U+4.U //UDP, BTH, RETH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE           
            }                
            is(IB_OP_CODE.RC_WRITE_MIDDLE ){
                reth_head.length                := Util.reverse(event_meta.length)
                reth_head.vaddr                 := Util.reverse(event_meta.vaddr)
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := false.B
                io.pkg_type2exh.bits.hasHeader  := false.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := CONFIG.MTU.U + 8.U+12.U+4.U //UDP, BTH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE   
            }
            is( IB_OP_CODE.RC_WRITE_LAST){
                reth_head.length                := Util.reverse(event_meta.length)
                reth_head.vaddr                 := Util.reverse(event_meta.vaddr)
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := false.B
                io.pkg_type2exh.bits.hasHeader  := false.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := event_meta.length + 8.U+12.U+4.U //UDP, BTH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE    
            }                
            is(IB_OP_CODE.RC_READ_REQUEST){
                reth_head.length                := Util.reverse(event_meta.length)
                reth_head.vaddr                 := Util.reverse(event_meta.vaddr)
                io.head_data_out.valid          := 1.U
                io.head_data_out.bits.data      := reth_head.asTypeOf(io.head_data_out.bits.data)
                io.head_data_out.bits.keep      := "hffff".U
                io.head_data_out.bits.last      := 1.U
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := false.B
                io.pkg_type2exh.bits.hasHeader  := true.B
                io.pkg_type2exh.bits.hasPayload := false.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := 8.U+12.U+16.U+4.U //UDP, BTH, RETH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                io.ibh_meta_out.bits.num_pkg    := (event_meta.length + CONFIG.MTU.U-1.U) / CONFIG.MTU.U
                state                           := sIDLE     
            }
            is(IB_OP_CODE.RC_READ_RESP_ONLY){
                aeth_head.msn                   := msn_tx_fifo.io.deq.bits.msn_state.msn
                aeth_head.isNAK                 := 0.U
                aeth_head.credit                := 0.U
                io.head_data_out.valid          := 1.U
                io.head_data_out.bits.data      := aeth_head.asTypeOf(io.head_data_out.bits.data)
                io.head_data_out.bits.keep      := "hf".U
                io.head_data_out.bits.last      := 1.U
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := true.B
                io.pkg_type2exh.bits.hasHeader  := true.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := event_meta.length  + 8.U+12.U+4.U+4.U //UDP, BTH, AETH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE  
            }
            is(IB_OP_CODE.RC_READ_RESP_FIRST){
                aeth_head.msn                   := msn_tx_fifo.io.deq.bits.msn_state.msn
                aeth_head.isNAK                 := 0.U
                aeth_head.credit                := 0.U
                io.head_data_out.valid          := 1.U
                io.head_data_out.bits.data      := aeth_head.asTypeOf(io.head_data_out.bits.data)
                io.head_data_out.bits.keep      := "hf".U
                io.head_data_out.bits.last      := 1.U
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := true.B
                io.pkg_type2exh.bits.hasHeader  := true.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := event_meta.length  + 8.U+12.U+4.U+4.U //UDP, BTH, AETH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE  
            }
            is(IB_OP_CODE.RC_READ_RESP_LAST){
                aeth_head.msn                   := msn_tx_fifo.io.deq.bits.msn_state.msn
                aeth_head.isNAK                 := 0.U
                aeth_head.credit                := 0.U
                io.head_data_out.valid          := 1.U
                io.head_data_out.bits.data      := aeth_head.asTypeOf(io.head_data_out.bits.data)
                io.head_data_out.bits.keep      := "hf".U
                io.head_data_out.bits.last      := 1.U
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := true.B
                io.pkg_type2exh.bits.hasHeader  := true.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := event_meta.length  + 8.U+12.U+4.U+4.U //UDP, BTH, AETH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE  
            }                                
            is(IB_OP_CODE.RC_READ_RESP_MIDDLE){
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := true.B
                io.pkg_type2exh.bits.hasHeader  := false.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := event_meta.length  + 8.U+12.U+4.U //UDP, BTH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE  
            }
            is(IB_OP_CODE.RC_ACK){
                aeth_head.msn                   := msn_tx_fifo.io.deq.bits.msn_state.msn
                when(event_meta.isNAK){
                    aeth_head.isNAK             := 3.U
                }.otherwise{
                    aeth_head.isNAK             := 0.U
                }                        
                aeth_head.credit                := event_meta.credit
                when(event_meta.is_wr_ack){
                    aeth_head.iswr_ack          := 1.U
                }.otherwise{
                    aeth_head.iswr_ack          := 0.U
                }                        
                io.head_data_out.valid          := 1.U
                io.head_data_out.bits.data      := aeth_head.asTypeOf(io.head_data_out.bits.data)
                io.head_data_out.bits.keep      := "hf".U
                io.head_data_out.bits.last      := 1.U
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := true.B
                io.pkg_type2exh.bits.hasHeader  := true.B
                io.pkg_type2exh.bits.hasPayload := false.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := 8.U+12.U+4.U+4.U //UDP, BTH, AETH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE  
            }
            is(IB_OP_CODE.RC_DIRECT_FIRST){
                reth_head.length                := Util.reverse(event_meta.length)
                reth_head.vaddr                 := Util.reverse(event_meta.vaddr)
                io.head_data_out.valid          := 1.U
                io.head_data_out.bits.data      := reth_head.asTypeOf(io.head_data_out.bits.data)
                io.head_data_out.bits.keep      := "hffff".U
                io.head_data_out.bits.last      := 1.U
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := false.B
                io.pkg_type2exh.bits.hasHeader  := true.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := CONFIG.MTU.U + 8.U+12.U+16.U+4.U //UDP, BTH, RETH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE                   
            }
            is(IB_OP_CODE.RC_DIRECT_ONLY){
                reth_head.length                := Util.reverse(event_meta.length)
                reth_head.vaddr                 := Util.reverse(event_meta.vaddr)
                io.head_data_out.valid          := 1.U
                io.head_data_out.bits.data      := reth_head.asTypeOf(io.head_data_out.bits.data)
                io.head_data_out.bits.keep      := "hffff".U
                io.head_data_out.bits.last      := 1.U
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := false.B
                io.pkg_type2exh.bits.hasHeader  := true.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := event_meta.length + 8.U+12.U+16.U+4.U //UDP, BTH, RETH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE           
            }                
            is(IB_OP_CODE.RC_DIRECT_MIDDLE ){
                reth_head.length                := Util.reverse(event_meta.length)
                reth_head.vaddr                 := Util.reverse(event_meta.vaddr)
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := false.B
                io.pkg_type2exh.bits.hasHeader  := false.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := CONFIG.MTU.U + 8.U+12.U+4.U //UDP, BTH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE   
            }
            is( IB_OP_CODE.RC_DIRECT_LAST){
                reth_head.length                := Util.reverse(event_meta.length)
                reth_head.vaddr                 := Util.reverse(event_meta.vaddr)
                io.pkg_type2exh.valid           := 1.U 
                io.pkg_type2exh.bits.isAETH     := false.B
                io.pkg_type2exh.bits.hasHeader  := false.B
                io.pkg_type2exh.bits.hasPayload := true.B  
                io.ibh_meta_out.valid           := 1.U
                udp_length                      := event_meta.length + 8.U+12.U+4.U //UDP, BTH, CRC
                io.ibh_meta_out.bits            := event_meta
                io.ibh_meta_out.bits.udp_length := udp_length
                state                           := sIDLE    
            }                        
        }
    }

    
    

}