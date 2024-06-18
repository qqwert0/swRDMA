package network.roce.table

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector


class CQ_TABLE() extends Module{
	val io = IO(new Bundle{
		val dir_wq_req  = Flipped(Decoupled(new CMPT_META()))
		val rq_req	    = Flipped(Decoupled(new CMPT_META()))
        val cq_init_req	= Flipped(Decoupled(new CQ_INIT()))
		val cmpt_meta	= (Decoupled(new CMPT_META()))
        
	})

    val dir_wq_fifo = XQueue(new CMPT_META(), entries=16)
    val rq_fifo = XQueue(new CMPT_META(), entries=16)
    val init_fifo = XQueue(new CQ_INIT(), entries=16)

    io.dir_wq_req                       <> dir_wq_fifo.io.in
    io.rq_req                           <> rq_fifo.io.in
    io.cq_init_req                      <> init_fifo.io.in

    val cq_table = XRam(new CQ_STATE(), CONFIG.MAX_QPS, latency = 1)

    val cq_request = RegInit(0.U.asTypeOf(new CMPT_META()))

	val sIDLE :: sTXRSP :: sRXRSP :: Nil = Enum(3)
	val state                   = RegInit(sIDLE)
    Collector.report(state===sIDLE, "CQ_TABLE===sIDLE")  
    cq_table.io.addr_a                 := 0.U
    cq_table.io.addr_b                 := 0.U
    cq_table.io.wr_en_a                := 0.U
    cq_table.io.data_in_a              := 0.U.asTypeOf(cq_table.io.data_in_a)

    dir_wq_fifo.io.out.ready           := state === sIDLE
    rq_fifo.io.out.ready               := state === sIDLE & (!dir_wq_fifo.io.out.valid.asBool) 
    init_fifo.io.out.ready             := state === sIDLE & (!dir_wq_fifo.io.out.valid.asBool) & (!rq_fifo.io.out.valid.asBool)

    io.cmpt_meta.valid                 := 0.U
    io.cmpt_meta.bits                  := 0.U.asTypeOf(io.cmpt_meta.bits)


    // Reporter.report(io.msn2tx_rsp.valid === 1.U,"undefined state")
    
	switch(state){
		is(sIDLE){
            when(dir_wq_fifo.io.out.fire){
                cq_request                      := dir_wq_fifo.io.out.bits
                cq_table.io.addr_b              := dir_wq_fifo.io.out.bits.qpn
                state                           := sRXRSP
            }.elsewhen(rq_fifo.io.out.fire){
                cq_request                      := rq_fifo.io.out.bits
                cq_table.io.addr_b              := rq_fifo.io.out.bits.qpn
                state                           := sTXRSP
            }.elsewhen(init_fifo.io.out.fire){
                cq_table.io.addr_a             := init_fifo.io.out.bits.qpn
                cq_table.io.wr_en_a            := 1.U
                cq_table.io.data_in_a.wq_num   := init_fifo.io.out.bits.wq_num
                cq_table.io.data_in_a.rq_num   := init_fifo.io.out.bits.rq_num
                cq_table.io.data_in_a.di_num   := init_fifo.io.out.bits.di_num
                state                           := sIDLE
            }.otherwise{
                state                           := sIDLE
            }
		}
		is(sTXRSP){
			when(io.cmpt_meta.ready){
				io.cmpt_meta.valid 		        := 1.U 
                when(cq_request.msg_type === 0.U){
                    cq_table.io.addr_a             := cq_request.qpn
                    cq_table.io.wr_en_a            := 1.U
                    cq_table.io.data_in_a.wq_num   := cq_table.io.data_out_b.wq_num
                    cq_table.io.data_in_a.rq_num   := cq_table.io.data_out_b.rq_num + 1.U
                    cq_table.io.data_in_a.di_num   := cq_table.io.data_out_b.di_num                   
                }.elsewhen(cq_request.msg_type === 1.U){
                    cq_table.io.addr_a             := cq_request.qpn
                    cq_table.io.wr_en_a            := 1.U
                    cq_table.io.data_in_a.wq_num   := cq_table.io.data_out_b.wq_num + 1.U
                    cq_table.io.data_in_a.rq_num   := cq_table.io.data_out_b.rq_num
                    cq_table.io.data_in_a.di_num   := cq_table.io.data_out_b.di_num 
                }.elsewhen(cq_request.msg_type === 2.U){
                    cq_table.io.addr_a             := cq_request.qpn
                    cq_table.io.wr_en_a            := 1.U
                    cq_table.io.data_in_a.wq_num   := cq_table.io.data_out_b.wq_num
                    cq_table.io.data_in_a.rq_num   := cq_table.io.data_out_b.rq_num
                    cq_table.io.data_in_a.di_num   := cq_table.io.data_out_b.di_num + 1.U 
                }
                io.cmpt_meta.bits.qpn 		        <> cq_request.qpn
                io.cmpt_meta.bits.msg_num 		    <> cq_table.io.data_out_b.rq_num + 1.U
				io.cmpt_meta.bits.msg_type 		    <> cq_request.msg_type
                state                               := sIDLE
			}.otherwise{
                state                           := sTXRSP
            }
		}
		is(sRXRSP){
			when(io.cmpt_meta.ready){
				io.cmpt_meta.valid 		        := 1.U 
                when(cq_request.msg_type === 0.U){
                    cq_table.io.addr_a             := cq_request.qpn
                    cq_table.io.wr_en_a            := 1.U
                    cq_table.io.data_in_a.wq_num   := cq_table.io.data_out_b.wq_num
                    cq_table.io.data_in_a.rq_num   := cq_table.io.data_out_b.rq_num + 1.U
                    cq_table.io.data_in_a.di_num   := cq_table.io.data_out_b.di_num                   
                }.elsewhen(cq_request.msg_type === 1.U){
                    cq_table.io.addr_a             := cq_request.qpn
                    cq_table.io.wr_en_a            := 1.U
                    cq_table.io.data_in_a.wq_num   := cq_table.io.data_out_b.wq_num + 1.U
                    cq_table.io.data_in_a.rq_num   := cq_table.io.data_out_b.rq_num
                    cq_table.io.data_in_a.di_num   := cq_table.io.data_out_b.di_num 
                }.elsewhen(cq_request.msg_type === 2.U){
                    cq_table.io.addr_a             := cq_request.qpn
                    cq_table.io.wr_en_a            := 1.U
                    cq_table.io.data_in_a.wq_num   := cq_table.io.data_out_b.wq_num
                    cq_table.io.data_in_a.rq_num   := cq_table.io.data_out_b.rq_num
                    cq_table.io.data_in_a.di_num   := cq_table.io.data_out_b.di_num + 1.U 
                }
                io.cmpt_meta.bits.qpn 		        <> cq_request.qpn
                io.cmpt_meta.bits.msg_num 		    <> cq_table.io.data_out_b.rq_num + 1.U
				io.cmpt_meta.bits.msg_type 		    <> cq_request.msg_type
                state                               := sIDLE
			}.otherwise{
                state                           := sTXRSP
            }			
		}	
	}

}