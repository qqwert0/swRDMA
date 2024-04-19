package swrdma

import common.storage._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector



class RX_CC() extends Module{
	val io = IO(new Bundle{
        val cc_meta_in      = Flipped(Decoupled(new Pkg_meta()))
        val cc_state_in     = Flipped(Decoupled(new CC_state()))
        val cc_req          = (Decoupled(new CC_req()))
        val cc_meta_out     = (Decoupled(new Pkg_meta()))

	})

    val cc_meta_fifo = XQueue(new Pkg_meta(), entries=16)
    val cc_state_fifo = XQueue(new CC_state(), entries=16)

    io.cc_meta_in                      <> cc_meta_fifo.io.in
    io.cc_state_in                     <> cc_state_fifo.io.in

    val csr = Module(new CSR())

    val meta_reg = RegInit(0.U.asTypeOf(new Pkg_meta()))

	val sIDLE :: sWAIT :: sDONE :: Nil = Enum(3)
	val state                   = RegInit(sIDLE)

    cc_meta_fifo.io.out.ready               := (state === sIDLE) & (csr.io.has_event_rd === 0.U) & (cc_state_fifo.io.out.valid)
    cc_state_fifo.io.out.ready              := (state === sIDLE) & (csr.io.has_event_rd === 0.U) & (cc_meta_fifo.io.out.valid)

    ToZero(csr.io.cmd)
    ToZero(csr.io.addr)
    ToZero(csr.io.data_in)
    ToZero(csr.io.has_event_wr)
    ToZero(csr.io.user_csr_wr)
    ToZero(io.cc_meta_out.valid)
    ToZero(io.cc_meta_out.bits)
    ToZero(io.cc_req.valid)
    ToZero(io.cc_req.bits)    

    switch(state){
        is(sIDLE){
            when((csr.io.has_event_rd === 0.U) & cc_meta_fifo.io.out.fire() & cc_state_fifo.io.out.fire()){
                meta_reg                        := cc_meta_fifo.io.out.bits
                csr.io.has_event_wr             := 1.U
                csr.io.user_csr_wr(0)           := cc_meta_fifo.io.out.bits.op_code.asUInt
                csr.io.user_csr_wr(1)           := cc_meta_fifo.io.out.bits.qpn
                csr.io.user_csr_wr(2)           := cc_meta_fifo.io.out.bits.pkg_length
                for(i <- 0 until 11){
                    csr.io.user_csr_wr(i+3)     := cc_meta_fifo.io.out.bits.user_define(i*8+7,i*8)
                }                
                csr.io.user_csr_wr(16)          := cc_state_fifo.io.out.bits.credit
                csr.io.user_csr_wr(17)          := cc_state_fifo.io.out.bits.rate
                csr.io.user_csr_wr(18)          := cc_state_fifo.io.out.bits.timer
                for(i <- 0 until 11){
                    csr.io.user_csr_wr(i+19)    := cc_state_fifo.io.out.bits.user_define(i*8+7,i*8)
                }
                state                           := sWAIT
            }                 
        }
        is(sWAIT){
            when(io.cc_meta_out.ready & io.cc_req.ready ){
                state                           := sDONE
            }
        }
        is(sDONE){
            when((csr.io.has_event_rd === 0.U)&(csr.io.event_recv_cnt === csr.io.event_processed_cnt)){
                io.cc_meta_out.valid            := 1.U
                io.cc_meta_out.bits             := meta_reg
                io.cc_meta_out.bits.op_code     := IB_OPCODE.safe(csr.io.user_csr_rd(0)(7,0))._1
                io.cc_meta_out.bits.qpn         := csr.io.user_csr_rd(1)
                io.cc_meta_out.bits.pkg_length  := csr.io.user_csr_rd(2)
                io.cc_req.valid                 := 1.U
                io.cc_req.bits.is_wr            := true.B
                io.cc_req.bits.lock             := false.B
                io.cc_req.bits.qpn              := csr.io.user_csr_rd(1)
                io.cc_req.bits.cc_state.credit  := csr.io.user_csr_rd(16)
                io.cc_req.bits.cc_state.rate    := csr.io.user_csr_rd(17) 
                io.cc_req.bits.cc_state.timer   := csr.io.user_csr_rd(18)  
                io.cc_req.bits.cc_state.user_define := Cat(csr.io.user_csr_rd(29),csr.io.user_csr_rd(28),csr.io.user_csr_rd(27),csr.io.user_csr_rd(26),csr.io.user_csr_rd(25),csr.io.user_csr_rd(24),
                                                            csr.io.user_csr_rd(23),csr.io.user_csr_rd(22),csr.io.user_csr_rd(21),csr.io.user_csr_rd(20),csr.io.user_csr_rd(19))          
                state                           := sIDLE
            }
        }
    }
}
