package network.roce.cmd_ctrl

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import java.text.Collator
import common.Collector
import common.ToZero

class CREDIT_JUDGE() extends Module{
	val io = IO(new Bundle{
		val exh_event           = Flipped(Decoupled(new IBH_META()))
        val ack_event           = Flipped(Decoupled(new IBH_META()))
        val fc2ack_rsp          = Flipped(Decoupled(new IBH_META()))
        val fc2tx_rsp           = Flipped(Decoupled(new IBH_META()))

        val tx2fc_req           = (Decoupled(new IBH_META()))
        val tx2fc_ack           = (Decoupled(new IBH_META()))
        val tx_exh_event	    = (Decoupled(new IBH_META()))
	})

    // Collector.count(io.exh_event.fire & io.exh_event.bits.qpn === 1.U & io.exh_event.bits.op_code === IB_OP_CODE.RC_DIRECT_ONLY, "QPN1 PKG")
    // Collector.count(io.ack_event.fire & io.ack_event.bits.qpn === 1.U & io.ack_event.bits.op_code === IB_OP_CODE.RC_ACK, "QPN1 ACK")
    // Collector.count(io.exh_event.fire & io.exh_event.bits.qpn === 2.U & io.exh_event.bits.op_code === IB_OP_CODE.RC_DIRECT_ONLY, "QPN2 PKG")
    // Collector.count(io.ack_event.fire & io.ack_event.bits.qpn === 2.U & io.ack_event.bits.op_code === IB_OP_CODE.RC_ACK, "QPN2 ACK")


    val exh_event_fifo = XQueue(new IBH_META(), entries=4)
    val ack_event_fifo = XQueue(new IBH_META(), entries=4)
    val tx2fc_req_fifo = XQueue(new IBH_META(), entries=16)
    val tx2fc_ack_fifo = XQueue(new IBH_META(), entries=16)

    io.exh_event                       <> exh_event_fifo.io.in
    io.ack_event                       <> ack_event_fifo.io.in
    io.tx2fc_req                        <> tx2fc_req_fifo.io.out
    io.tx2fc_ack                        <> tx2fc_ack_fifo.io.out
  

	val event_meta = RegInit(0.U.asTypeOf(new IBH_META()))

    val tmp_credit = WireInit(0.U(16.W))

    

	val sIDLE :: sGENERATE :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)	
	// Collector.report(state===sIDLE, "CREDIT_JUDGE===sIDLE") 
	ack_event_fifo.io.out.ready          := tx2fc_ack_fifo.io.in.ready
    exh_event_fifo.io.out.ready          := (!ack_event_fifo.io.out.valid) & tx2fc_req_fifo.io.in.ready   
    io.fc2ack_rsp.ready                  := io.tx_exh_event.ready
    io.fc2tx_rsp.ready                  := (!io.fc2ack_rsp.valid) & io.tx_exh_event.ready

    ToZero(tx2fc_req_fifo.io.in.bits)
    ToZero(tx2fc_req_fifo.io.in.valid)
    ToZero(tx2fc_ack_fifo.io.in.bits)
    ToZero(tx2fc_ack_fifo.io.in.valid)  
    ToZero(io.tx_exh_event.bits)
    ToZero(io.tx_exh_event.valid)       

	
    //cycle 1

    when(ack_event_fifo.io.out.fire){
        tx2fc_ack_fifo.io.in.valid 	        := 1.U 
        tx2fc_ack_fifo.io.in.bits       := ack_event_fifo.io.out.bits
        // state                       := sGENERATE
    }.elsewhen(exh_event_fifo.io.out.fire){
        event_meta                  := exh_event_fifo.io.out.bits
        when((exh_event_fifo.io.out.bits.op_code === IB_OP_CODE.RC_WRITE_FIRST) || (exh_event_fifo.io.out.bits.op_code === IB_OP_CODE.RC_DIRECT_FIRST)){
            tx2fc_req_fifo.io.in.valid 	        := 1.U  
            tx2fc_req_fifo.io.in.bits           := exh_event_fifo.io.out.bits
            tx2fc_req_fifo.io.in.bits.credit    := CONFIG.MTU_WORD.U
        }.otherwise{
            tx2fc_req_fifo.io.in.valid 	        := 1.U  
            tx2fc_req_fifo.io.in.bits           := exh_event_fifo.io.out.bits
            tx2fc_req_fifo.io.in.bits.credit    := exh_event_fifo.io.out.bits.length>>6.U       
        }                   
        // state                       := sGENERATE
	}.otherwise{
        // state                       := sIDLE
    }

    //cycle 2


    when(io.fc2ack_rsp.fire){
        io.tx_exh_event.valid   := 1.U
        io.tx_exh_event.bits    := io.fc2ack_rsp.bits
    }.elsewhen(io.fc2tx_rsp.fire){
        when(io.fc2tx_rsp.bits.valid_event){
            io.tx_exh_event.valid   := 1.U
            io.tx_exh_event.bits    := io.fc2tx_rsp.bits
        }        
    }


}