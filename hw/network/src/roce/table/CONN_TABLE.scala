package network.roce.table

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector


class CONN_TABLE() extends Module{
	val io = IO(new Bundle{
		val tx2conn_req	    = Flipped(Decoupled(UInt(24.W)))
		val conn_init	    = Flipped(Decoupled(new CONN_REQ()))
		val conn2tx_rsp	    = (Decoupled(new CONN_STATE()))
	})


    val conn_tx_fifo = XQueue(new CONN_STATE(), entries=16)


    io.conn2tx_rsp                       <> conn_tx_fifo.io.out

    val conn_table = XRam(new CONN_STATE(), CONFIG.MAX_QPS, latency = 1)

    val conn_request = RegInit(0.U.asTypeOf(new CONN_REQ()))

	


	val sIDLE :: sTXRSP :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)
    Collector.report(state===sIDLE, "CONN_TABLE===sIDLE")
    conn_table.io.addr_a                 := 0.U
    conn_table.io.addr_b                 := 0.U
    conn_table.io.wr_en_a                := 0.U
    conn_table.io.data_in_a              := 0.U.asTypeOf(conn_table.io.data_in_a)

    io.tx2conn_req.ready                := (!io.conn_init.valid.asBool) & (!conn_tx_fifo.io.almostfull)
    io.conn_init.ready                  := 1.U


    conn_tx_fifo.io.in.valid                 := 0.U
    conn_tx_fifo.io.in.bits                  := 0.U.asTypeOf(conn_tx_fifo.io.in.bits)


    //cycle1
    when(io.conn_init.fire){
        conn_table.io.addr_a                    := io.conn_init.bits.qpn
        conn_table.io.wr_en_a                   := 1.U
        conn_table.io.data_in_a.remote_qpn      := io.conn_init.bits.remote_qpn
        conn_table.io.data_in_a.remote_ip       := io.conn_init.bits.remote_ip
        conn_table.io.data_in_a.remote_udp_port := io.conn_init.bits.remote_udp_port
        state                                   := sIDLE        
    }.elsewhen(io.tx2conn_req.fire){
        conn_table.io.addr_b             := io.tx2conn_req.bits
        state                            := sTXRSP
    }.otherwise{
        state                           := sIDLE
    }    


    //cycle2

    when(state === sTXRSP){
		conn_tx_fifo.io.in.valid 		    := 1.U 
		conn_tx_fifo.io.in.bits 		    <> conn_table.io.data_out_b
    } 








    
	// switch(state){
	// 	is(sIDLE){
    //         when(conn_tx_fifo.io.deq.fire){
    //             conn_table.io.addr_b             := conn_tx_fifo.io.deq.bits
    //             state                           := sTXRSP
    //         }.elsewhen(conn_init_fifo.io.deq.fire){
    //             conn_table.io.addr_a                    := conn_init_fifo.io.deq.bits.qpn
    //             conn_table.io.wr_en_a                   := 1.U
    //             conn_table.io.data_in_a.remote_qpn      := conn_init_fifo.io.deq.bits.remote_qpn
    //             conn_table.io.data_in_a.remote_ip       := conn_init_fifo.io.deq.bits.remote_ip
    //             conn_table.io.data_in_a.remote_udp_port := conn_init_fifo.io.deq.bits.remote_udp_port
    //             state                                   := sIDLE
    //         }.otherwise{
    //             state                           := sIDLE
    //         }
	// 	}
	// 	is(sTXRSP){
	// 		when(io.conn2tx_rsp.ready){
	// 			io.conn2tx_rsp.valid 		    := 1.U 
	// 			io.conn2tx_rsp.bits 		        <> conn_table.io.data_out_b
    //             state                           := sIDLE
	// 		}.otherwise{
    //             state                           := sTXRSP
    //         }
	// 	}	
	// }

}