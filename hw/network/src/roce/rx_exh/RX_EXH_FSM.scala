package network.roce.rx_exh

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.BaseILA
import common.Collector
import common.ToZero


class RX_EXH_FSM() extends Module{
	val io = IO(new Bundle{
		val ibh_meta_in         = Flipped(Decoupled(new IBH_META()))

        val msn2rx_rsp          = Flipped(Decoupled(new MSN_RSP()))
        val l_read_req_pop_rsp  = Flipped(Decoupled(new MQ_POP_RSP(UInt(64.W))))

		val m_mem_write_cmd     = (Decoupled(new MEM_CMD()))
        val m_recv_meta         = (Decoupled(new RECV_META()))

        val rx2msn_req          = (Decoupled(new MSN_REQ()))
        val rx2msn_wr           = (Decoupled(new MSN_REQ()))
        val l_read_req_pop_req  = (Decoupled(UInt(24.W)))
        val r_read_req_req      = (Decoupled(new RD_REQ()))
        val rq_req	            = (Decoupled(new CMPT_META()))

        val ack_event	        = (Decoupled(new IBH_META()))

        val pkg_type2exh        = (Decoupled(new RX_PKG_INFO()))
        val pkg_type2mem        = (Decoupled(new RX_PKG_INFO()))
	})


    // Collector.count(io.ibh_meta_in.fire & io.ibh_meta_in.bits.qpn === 1.U & io.ibh_meta_in.bits.op_code === IB_OP_CODE.RC_DIRECT_ONLY, "QPN1 PKG")
    // Collector.count(io.ibh_meta_in.fire & io.ibh_meta_in.bits.qpn === 1.U & io.ibh_meta_in.bits.op_code === IB_OP_CODE.RC_ACK, "QPN1 ACK")
    // Collector.count(io.ibh_meta_in.fire & io.ibh_meta_in.bits.qpn === 2.U & io.ibh_meta_in.bits.op_code === IB_OP_CODE.RC_DIRECT_ONLY, "QPN2 PKG")
    // Collector.count(io.ibh_meta_in.fire & io.ibh_meta_in.bits.qpn === 2.U & io.ibh_meta_in.bits.op_code === IB_OP_CODE.RC_ACK, "QPN2 ACK")

    val ibh_meta_fifo = Module(new Queue(new IBH_META(), 1024))
    val msn_rx_fifo = Module(new Queue(new MSN_RSP(), 16))
    

    val l_read_pop_fifo = Module(new Queue(new MQ_POP_RSP(UInt(64.W)), 16))

    val mem_write_cmd_fifo = XQueue(new MEM_CMD(), 4)
    val recv_meta_fifo = XQueue(new RECV_META(), 4)
    val rx2msn_wr_fifo = XQueue(new MSN_REQ(), 4)
    val r_read_req_fifo = XQueue(new RD_REQ(), 4)
    val rq_req_fifo = XQueue(new CMPT_META(), 4)
    val ack_event_fifo = XQueue(new IBH_META(), 4)
    val pkg_type2exh_fifo = XQueue(new RX_PKG_INFO(), 4)
    val pkg_type2mem_fifo = XQueue(new RX_PKG_INFO(), 4)



    io.ibh_meta_in                      <> ibh_meta_fifo.io.enq
    io.msn2rx_rsp                       <> msn_rx_fifo.io.enq
    io.l_read_req_pop_rsp               <> l_read_pop_fifo.io.enq


    io.m_mem_write_cmd                  <> mem_write_cmd_fifo.io.out
    io.m_recv_meta                      <> recv_meta_fifo.io.out
    io.rx2msn_wr                        <> rx2msn_wr_fifo.io.out
    io.r_read_req_req                   <> r_read_req_fifo.io.out
    io.rq_req                           <> rq_req_fifo.io.out
    io.ack_event                        <> ack_event_fifo.io.out
    io.pkg_type2exh                     <> pkg_type2exh_fifo.io.out
    io.pkg_type2mem                     <> pkg_type2mem_fifo.io.out


	val ibh_meta = WireInit(0.U.asTypeOf(new IBH_META()))
    val msn_meta = RegInit(0.U.asTypeOf(new MSN_RSP()))
    val msn_meta1 = RegInit(0.U.asTypeOf(new MSN_RSP()))
    val l_read_addr = RegInit(0.U(64.W))
    val consume_read_addr = RegInit(false.B)
    val num_pkg_total = RegInit(0.U(21.W))

    val payload_length = WireInit(0.U(16.W))
    val remain_length = WireInit(0.U(32.W))
    val credit_tmp = WireInit(0.U(13.W))
    

	val sIDLE :: sMETA :: sDATA :: Nil = Enum(3)
	val state                   = RegInit(sIDLE)	
    val state1                  = RegInit(sIDLE)
    Collector.report(state===sIDLE, "RX_EXH_FSM===sIDLE")


	ibh_meta_fifo.io.deq.ready      := Mux((ibh_meta_fifo.io.deq.bits.op_code === IB_OP_CODE.RC_READ_RESP_FIRST | ibh_meta_fifo.io.deq.bits.op_code === IB_OP_CODE.RC_READ_RESP_ONLY) , (io.rx2msn_req.ready & io.l_read_req_pop_req.ready) , io.rx2msn_req.ready )
    msn_rx_fifo.io.deq.ready        := !r_read_req_fifo.io.almostfull & (~consume_read_addr) & !pkg_type2exh_fifo.io.almostfull & !pkg_type2mem_fifo.io.almostfull & !ack_event_fifo.io.almostfull & !mem_write_cmd_fifo.io.almostfull & !recv_meta_fifo.io.almostfull & !rx2msn_wr_fifo.io.almostfull & !rq_req_fifo.io.almostfull
    l_read_pop_fifo.io.deq.ready    := (state === sMETA) && consume_read_addr & !r_read_req_fifo.io.almostfull & !pkg_type2exh_fifo.io.almostfull & !pkg_type2mem_fifo.io.almostfull & !ack_event_fifo.io.almostfull & !mem_write_cmd_fifo.io.almostfull & !recv_meta_fifo.io.almostfull & !rx2msn_wr_fifo.io.almostfull & !rq_req_fifo.io.almostfull

    // Collector.report(io.m_mem_write_cmd.ready)
    // Collector.report(io.m_recv_meta.ready)

    ToZero(mem_write_cmd_fifo.io.in.valid)
    ToZero(mem_write_cmd_fifo.io.in.bits)
    ToZero(recv_meta_fifo.io.in.valid)
    ToZero(recv_meta_fifo.io.in.bits)
    ToZero(rx2msn_wr_fifo.io.in.valid)
    ToZero(rx2msn_wr_fifo.io.in.bits)
    io.rx2msn_req.valid             := 0.U
    io.rx2msn_req.bits              := 0.U.asTypeOf(io.rx2msn_req.bits)   
    io.l_read_req_pop_req.valid     := 0.U
    io.l_read_req_pop_req.bits      := 0.U.asTypeOf(io.l_read_req_pop_req.bits)

    ToZero(r_read_req_fifo.io.in.valid)
    ToZero(r_read_req_fifo.io.in.bits)
    ToZero(rq_req_fifo.io.in.valid)
    ToZero(rq_req_fifo.io.in.bits)
    ToZero(ack_event_fifo.io.in.valid)
    ToZero(ack_event_fifo.io.in.bits)
    ToZero(pkg_type2exh_fifo.io.in.valid)
    ToZero(pkg_type2exh_fifo.io.in.bits)    
    ToZero(pkg_type2mem_fifo.io.in.valid)
    ToZero(pkg_type2mem_fifo.io.in.bits)      

    //cycle 0

	when(ibh_meta_fifo.io.deq.fire){
        io.rx2msn_req.valid             := 1.U
        io.rx2msn_req.bits.qpn          := ibh_meta_fifo.io.deq.bits.qpn   
        io.rx2msn_req.bits.meta         := ibh_meta_fifo.io.deq.bits          
        io.rx2msn_req.bits.pkg_total    := (ibh_meta_fifo.io.deq.bits.length + CONFIG.MTU.U-1.U) / CONFIG.MTU.U  
        when(ibh_meta_fifo.io.deq.bits.op_code === IB_OP_CODE.RC_READ_RESP_FIRST | ibh_meta_fifo.io.deq.bits.op_code === IB_OP_CODE.RC_READ_RESP_ONLY){
            io.l_read_req_pop_req.valid := 1.U
            io.l_read_req_pop_req.bits  := ibh_meta_fifo.io.deq.bits.qpn
        }
	}


    //cycle 1

    when(msn_rx_fifo.io.deq.fire){
        msn_meta                        <> msn_rx_fifo.io.deq.bits
        when((msn_rx_fifo.io.deq.bits.meta.op_code === IB_OP_CODE.RC_READ_RESP_FIRST | msn_rx_fifo.io.deq.bits.meta.op_code === IB_OP_CODE.RC_READ_RESP_ONLY)){
            consume_read_addr           := true.B
            state                       := sMETA
        }.otherwise{
            state                       := sDATA
        }
    }.elsewhen(consume_read_addr){
        msn_meta                    := msn_meta
        state                       := sMETA
    }.otherwise{
        msn_meta                    := msn_meta
        state                       := sIDLE
    }
    

    //cycle 2

    msn_meta1                       := msn_meta
    num_pkg_total                   := (msn_meta.meta.length + CONFIG.MTU.U-1.U) / CONFIG.MTU.U 
    when(state === sMETA){
        when(l_read_pop_fifo.io.deq.fire){
            consume_read_addr           := false.B
            l_read_addr                 <> l_read_pop_fifo.io.deq.bits.data
            state1                      := sDATA             
        }.otherwise{
            state1                      := sIDLE
        }
    }.elsewhen(state === sDATA){
        state1                      := sDATA
    }.otherwise{
        state1                      := sIDLE
    }

    //cycle 3

    ibh_meta                        := msn_meta1.meta
    when(state1===sDATA){
        switch(ibh_meta.op_code){
            is(IB_OP_CODE.RC_WRITE_FIRST){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-16.U-4.U //UDP, BTH, RETH, CRC
                remain_length                   := ibh_meta.length - payload_length
                mem_write_cmd_fifo.io.in.valid        := 1.U
                mem_write_cmd_fifo.io.in.bits.vaddr   := ibh_meta.vaddr
                mem_write_cmd_fifo.io.in.bits.length  := payload_length
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                printf(p"${credit_tmp}\n")
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.RETH
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.RETH  
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= true.B  
                pkg_type2mem_fifo.io.in.bits.length     := payload_length
            }
            is(IB_OP_CODE.RC_WRITE_ONLY){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-16.U-4.U //UDP, BTH, RETH, CRC
                remain_length                   := ibh_meta.length - payload_length
                mem_write_cmd_fifo.io.in.valid        := 1.U
                mem_write_cmd_fifo.io.in.bits.vaddr   := ibh_meta.vaddr
                mem_write_cmd_fifo.io.in.bits.length  := payload_length
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.RETH
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.RETH  
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= true.B
                pkg_type2mem_fifo.io.in.bits.length     := payload_length               
            }                
            is(IB_OP_CODE.RC_WRITE_MIDDLE ){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-4.U //UDP, BTH, CRC
                remain_length                   := msn_meta1.msn_state.length - payload_length
                mem_write_cmd_fifo.io.in.valid        := 1.U
                mem_write_cmd_fifo.io.in.bits.vaddr   := msn_meta1.msn_state.vaddr
                mem_write_cmd_fifo.io.in.bits.length  := payload_length
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.RAW
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.RAW 
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= true.B
                pkg_type2mem_fifo.io.in.bits.length     := payload_length
            }
            is( IB_OP_CODE.RC_WRITE_LAST){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-4.U //UDP, BTH, CRC
                remain_length                   := msn_meta1.msn_state.length - payload_length
                mem_write_cmd_fifo.io.in.valid        := 1.U
                mem_write_cmd_fifo.io.in.bits.vaddr   := msn_meta1.msn_state.vaddr
                mem_write_cmd_fifo.io.in.bits.length  := payload_length
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.RAW
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.RAW 
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= true.B
                pkg_type2mem_fifo.io.in.bits.length     := payload_length  
            }                
            is(IB_OP_CODE.RC_READ_REQUEST){
                r_read_req_fifo.io.in.valid         := 1.U
                r_read_req_fifo.io.in.bits.qpn      := ibh_meta.qpn
                r_read_req_fifo.io.in.bits.vaddr    := ibh_meta.vaddr
                r_read_req_fifo.io.in.bits.length   := ibh_meta.length
                r_read_req_fifo.io.in.bits.psn      := ibh_meta.psn
            }
            is(IB_OP_CODE.RC_READ_RESP_ONLY){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-4.U-4.U //UDP, BTH, AETH, CRCotherwise{
                mem_write_cmd_fifo.io.in.valid        := 1.U
                mem_write_cmd_fifo.io.in.bits.vaddr   := l_read_addr
                mem_write_cmd_fifo.io.in.bits.length  := payload_length
                rx2msn_wr_fifo.io.in.valid             := 1.U 
                rx2msn_wr_fifo.io.in.bits.msn_req_generate(ibh_meta.qpn, msn_meta1.msn_state.msn, l_read_addr+payload_length, 0.U, 0.U, true.B)                        
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                rq_req_fifo.io.in.valid                 := 1.U
                rq_req_fifo.io.in.bits.cmpt_meta_generate(ibh_meta.qpn,0.U,0.U)
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.AETH
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.AETH 
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= true.B
                pkg_type2mem_fifo.io.in.bits.length     := payload_length
            }
            is(IB_OP_CODE.RC_READ_RESP_FIRST){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-4.U-4.U //UDP, BTH, AETH, CRC
                mem_write_cmd_fifo.io.in.valid        := 1.U
                mem_write_cmd_fifo.io.in.bits.vaddr   := l_read_addr
                mem_write_cmd_fifo.io.in.bits.length  := payload_length
                rx2msn_wr_fifo.io.in.valid             := 1.U 
                rx2msn_wr_fifo.io.in.bits.msn_req_generate(ibh_meta.qpn, msn_meta1.msn_state.msn, l_read_addr+payload_length, 0.U, 0.U, true.B)                        
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.AETH
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.AETH 
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= true.B
                pkg_type2mem_fifo.io.in.bits.length     := payload_length
            }
            is(IB_OP_CODE.RC_READ_RESP_LAST){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-4.U-4.U //UDP, BTH, AETH, CRC
                mem_write_cmd_fifo.io.in.valid        := 1.U
                mem_write_cmd_fifo.io.in.bits.vaddr   := msn_meta1.msn_state.vaddr
                mem_write_cmd_fifo.io.in.bits.length  := payload_length
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                rq_req_fifo.io.in.valid                 := 1.U
                rq_req_fifo.io.in.bits.cmpt_meta_generate(ibh_meta.qpn,0.U,0.U)
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.AETH
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.AETH 
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= true.B
                pkg_type2mem_fifo.io.in.bits.length     := payload_length
            }                                
            is(IB_OP_CODE.RC_READ_RESP_MIDDLE){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-4.U //UDP, BTH, CRC
                mem_write_cmd_fifo.io.in.valid        := 1.U
                mem_write_cmd_fifo.io.in.bits.vaddr   := msn_meta1.msn_state.vaddr
                mem_write_cmd_fifo.io.in.bits.length  := payload_length                    
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.RAW
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.RAW 
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= true.B
                pkg_type2mem_fifo.io.in.bits.length     := payload_length
            }
            is(IB_OP_CODE.RC_DIRECT_FIRST){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-16.U-4.U //UDP, BTH, RETH, CRC
                remain_length                   := ibh_meta.length - payload_length
                recv_meta_fifo.io.in.valid            := 1.U
                recv_meta_fifo.io.in.bits.recv_meta_generate(ibh_meta.qpn,msn_meta1.msn_state.msn+1.U,1.U,num_pkg_total,payload_length)//fix me add pkg_num pkg total msg num
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.RETH
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.RETH  
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= false.B
                pkg_type2mem_fifo.io.in.bits.length     := payload_length               
            }
            is(IB_OP_CODE.RC_DIRECT_ONLY){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-16.U-4.U //UDP, BTH, RETH, CRC
                remain_length                   := ibh_meta.length - payload_length
                recv_meta_fifo.io.in.valid            := 1.U
                recv_meta_fifo.io.in.bits.recv_meta_generate(ibh_meta.qpn,msn_meta1.msn_state.msn+1.U,1.U,1.U,payload_length)//fix me add pkg_num pkg total msg num
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.RETH
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.RETH  
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= false.B
                pkg_type2mem_fifo.io.in.bits.length     := payload_length                 
            }                
            is(IB_OP_CODE.RC_DIRECT_MIDDLE ){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-4.U //UDP, BTH, CRC
                remain_length                   := msn_meta1.msn_state.length - payload_length
                recv_meta_fifo.io.in.valid            := 1.U
                recv_meta_fifo.io.in.bits.recv_meta_generate(ibh_meta.qpn,msn_meta1.msn_state.msn,msn_meta1.msn_state.pkg_num+1.U,msn_meta1.msn_state.pkg_total,payload_length)//fix me add pkg_num pkg total msg num                  
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.RAW
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.RAW 
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= false.B
                pkg_type2mem_fifo.io.in.bits.length     := payload_length
            }
            is( IB_OP_CODE.RC_DIRECT_LAST){
                payload_length                  := ibh_meta.udp_length -8.U-12.U-4.U //UDP, BTH, CRC
                remain_length                   := msn_meta1.msn_state.length - payload_length
                recv_meta_fifo.io.in.valid            := 1.U
                recv_meta_fifo.io.in.bits.recv_meta_generate(ibh_meta.qpn,msn_meta1.msn_state.msn,msn_meta1.msn_state.pkg_num+1.U,msn_meta1.msn_state.pkg_total,payload_length)//fix me add pkg_num pkg total msg num                    
                ack_event_fifo.io.in.valid              := 1.U
                credit_tmp                      := payload_length>>6.U
                ack_event_fifo.io.in.bits.ack_event(ibh_meta.qpn, ibh_meta.psn, credit_tmp, ibh_meta.is_wr_ack)
                pkg_type2exh_fifo.io.in.valid           := 1.U
                pkg_type2exh_fifo.io.in.bits.pkg_type   := PKG_TYPE.RAW
                pkg_type2mem_fifo.io.in.valid           := 1.U
                pkg_type2mem_fifo.io.in.bits.pkg_type   := PKG_TYPE.RAW 
                pkg_type2mem_fifo.io.in.bits.data_to_mem:= false.B
                pkg_type2mem_fifo.io.in.bits.length     := payload_length  
            }                
        }
    }
    

}
