package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector
import mini.foo._
import mini.core._
import mini.junctions._


class RX_CC() extends Module{
	val io = IO(new Bundle{
        val cc_meta_in      = Flipped(Decoupled(new Pkg_meta()))
        val cc_state_in     = Flipped(Decoupled(new CC_state()))
        val cc_req          = (Decoupled(new CC_req()))
        val cc_meta_out     = (Decoupled(new Pkg_meta()))

        //
        val cpu_started     = Input(Bool())
        val axi             = new AXI(33, 256, 6, 0, 4)

	})

    ///////////////////////////////////riscv

	val cpu_started = RegNext(io.cpu_started)
	// riscv-mini
	val config = MiniConfig()
	val mini_core = withClockAndReset(clock, cpu_started.asBool) { 
		Module(new Tile(
		coreParams = config.core, 
		bramParams = config.bram,
		nastiParams = config.nasti, 
		cacheParams = config.cache
		))
	}

    Collector.report(mini_core.io.rdma_print_addr)
	Collector.report(mini_core.io.rdma_print_addr)
	Collector.report(mini_core.io.rdma_print_string_num)
	Collector.report(mini_core.io.rdma_print_string_len)
	Collector.report(mini_core.io.rdma_trap)

	io.axi.aw <> mini_core.io.nasti.aw
	io.axi.w <> mini_core.io.nasti.w
	io.axi.ar <> mini_core.io.nasti.ar
	io.axi.r <> mini_core.io.nasti.r
	io.axi.b <> mini_core.io.nasti.b

	mini_core.io.host := DontCare


    /////////////////////////////////

    val cc_meta_fifo = XQueue(new Pkg_meta(), entries=16)
    val cc_state_fifo = XQueue(new CC_state(), entries=16)

    io.cc_meta_in                      <> cc_meta_fifo.io.in
    io.cc_state_in                     <> cc_state_fifo.io.in

    // val csr = Module(new CSR())

    val meta_reg = RegInit(0.U.asTypeOf(new Pkg_meta()))

	val sIDLE :: sWAIT :: sDONE :: Nil = Enum(3)
	val state                   = RegInit(sIDLE)

    cc_meta_fifo.io.out.ready               := (state === sIDLE) & (mini_core.io.has_event_rd === 0.U) & (cc_state_fifo.io.out.valid)
    cc_state_fifo.io.out.ready              := (state === sIDLE) & (mini_core.io.has_event_rd === 0.U) & (cc_meta_fifo.io.out.valid)

    // ToZero(csr.io.cmd)
    // ToZero(csr.io.addr)
    // ToZero(csr.io.data_in)
    ToZero(mini_core.io.has_event_wr)
    ToZero(mini_core.io.user_csr_wr)
    ToZero(io.cc_meta_out.valid)
    ToZero(io.cc_meta_out.bits)
    ToZero(io.cc_req.valid)
    ToZero(io.cc_req.bits)    

    switch(state){
        is(sIDLE){
            when((mini_core.io.has_event_rd === 0.U) & cc_meta_fifo.io.out.fire & cc_state_fifo.io.out.fire){
                meta_reg                        := cc_meta_fifo.io.out.bits
                mini_core.io.has_event_wr       := 1.U
                mini_core.io.user_csr_wr(0)           := cc_meta_fifo.io.out.bits.op_code.asUInt
                mini_core.io.user_csr_wr(1)           := cc_meta_fifo.io.out.bits.qpn
                mini_core.io.user_csr_wr(2)           := cc_meta_fifo.io.out.bits.pkg_length
                for(i <- 0 until 11){
                    mini_core.io.user_csr_wr(i+3)     := cc_meta_fifo.io.out.bits.user_define(i*8+7,i*8)
                }                
                mini_core.io.user_csr_wr(16)          := cc_state_fifo.io.out.bits.credit
                mini_core.io.user_csr_wr(17)          := cc_state_fifo.io.out.bits.rate
                mini_core.io.user_csr_wr(18)          := cc_state_fifo.io.out.bits.timer
                for(i <- 0 until 11){
                    mini_core.io.user_csr_wr(i+19)    := cc_state_fifo.io.out.bits.user_define(i*8+7,i*8)
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
            when((mini_core.io.has_event_rd === 0.U)&(mini_core.io.event_recv_cnt === mini_core.io.event_processed_cnt)){
                io.cc_meta_out.valid            := 1.U
                io.cc_meta_out.bits             := meta_reg
                io.cc_meta_out.bits.op_code     := IB_OPCODE.safe(mini_core.io.user_csr_rd(0)(7,0))._1
                io.cc_meta_out.bits.qpn         := mini_core.io.user_csr_rd(1)
                io.cc_meta_out.bits.pkg_length  := mini_core.io.user_csr_rd(2)
                io.cc_req.valid                 := 1.U
                io.cc_req.bits.is_wr            := true.B
                io.cc_req.bits.lock             := false.B
                io.cc_req.bits.qpn              := mini_core.io.user_csr_rd(1)
                io.cc_req.bits.cc_state.credit  := mini_core.io.user_csr_rd(16)
                io.cc_req.bits.cc_state.rate    := mini_core.io.user_csr_rd(17) 
                io.cc_req.bits.cc_state.timer   := mini_core.io.user_csr_rd(18)  
                io.cc_req.bits.cc_state.user_define := Cat(mini_core.io.user_csr_rd(29),mini_core.io.user_csr_rd(28),mini_core.io.user_csr_rd(27),mini_core.io.user_csr_rd(26),mini_core.io.user_csr_rd(25),mini_core.io.user_csr_rd(24),
                                                            mini_core.io.user_csr_rd(23),mini_core.io.user_csr_rd(22),mini_core.io.user_csr_rd(21),mini_core.io.user_csr_rd(20),mini_core.io.user_csr_rd(19))          
                state                           := sIDLE
            }
        }
    }
}
