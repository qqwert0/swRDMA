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



class TX_CC() extends Module{
	val io = IO(new Bundle{
        val cc_meta_in      = Flipped(Decoupled(new Event_meta()))
        val cc_state_in     = Flipped(Decoupled(new CC_state()))
        val cc_req          = (Decoupled(new CC_req()))
        val cc_meta_out     = (Decoupled(new Event_meta()))

        val cpu_started     = Input(Bool())
        val axi             = new AXI(33, 256, 6, 0, 4)

	})

    ///////////////////////////////////riscv

	val cpu_started = RegNext(io.cpu_started)
	// riscv-mini
	val config = MiniConfig()
	val tx_core = withClockAndReset(clock, cpu_started.asBool) { 
		Module(new Tile(
		coreParams = config.core, 
		bramParams = config.bram,
		nastiParams = config.nasti, 
		cacheParams = config.cache
		))
	}

    Collector.report(tx_core.io.rdma_print_addr)
	Collector.report(tx_core.io.rdma_print_addr)
	Collector.report(tx_core.io.rdma_print_string_num)
	Collector.report(tx_core.io.rdma_print_string_len)
	Collector.report(tx_core.io.rdma_trap)

	io.axi.aw <> tx_core.io.nasti.aw
	io.axi.w <> tx_core.io.nasti.w
	io.axi.ar <> tx_core.io.nasti.ar
	io.axi.r <> tx_core.io.nasti.r
	io.axi.b <> tx_core.io.nasti.b

	tx_core.io.host := DontCare


    /////////////////////////////////

    val cc_meta_fifo = XQueue(new Event_meta(), entries=16)
    val cc_state_fifo = XQueue(new CC_state(), entries=16)

    io.cc_meta_in                      <> cc_meta_fifo.io.in
    io.cc_state_in                     <> cc_state_fifo.io.in

    // val csr = Module(new CSR())

    val meta_reg = RegInit(0.U.asTypeOf(new Event_meta()))

	val sIDLE :: sWAIT :: sDONE :: Nil = Enum(3)
	val state                   = RegInit(sIDLE)

    cc_meta_fifo.io.out.ready               := (state === sIDLE) & (tx_core.io.has_event_rd === 0.U) & (cc_state_fifo.io.out.valid)
    cc_state_fifo.io.out.ready              := (state === sIDLE) & (tx_core.io.has_event_rd === 0.U) & (cc_meta_fifo.io.out.valid)

    // ToZero(tx_core.io.cmd)
    // ToZero(tx_core.io.addr)
    // ToZero(tx_core.io.data_in)
    ToZero(tx_core.io.has_event_wr)
    ToZero(tx_core.io.user_csr_wr)
    ToZero(io.cc_meta_out.valid)
    ToZero(io.cc_meta_out.bits)
    ToZero(io.cc_req.valid)
    ToZero(io.cc_req.bits)    

    switch(state){
        is(sIDLE){
            when((tx_core.io.has_event_rd === 0.U) & cc_meta_fifo.io.out.fire & cc_state_fifo.io.out.fire){
                meta_reg                        := cc_meta_fifo.io.out.bits
                tx_core.io.has_event_wr             := 1.U
                tx_core.io.user_csr_wr(0)           := cc_meta_fifo.io.out.bits.op_code.asUInt
                tx_core.io.user_csr_wr(1)           := cc_meta_fifo.io.out.bits.qpn
                tx_core.io.user_csr_wr(2)           := cc_meta_fifo.io.out.bits.pkg_length
                for(i <- 0 until 11){
                    tx_core.io.user_csr_wr(i+3)     := cc_meta_fifo.io.out.bits.user_define(i*8+7,i*8)
                }                
                tx_core.io.user_csr_wr(16)          := cc_state_fifo.io.out.bits.credit
                tx_core.io.user_csr_wr(17)          := cc_state_fifo.io.out.bits.rate
                tx_core.io.user_csr_wr(18)          := cc_state_fifo.io.out.bits.timer
                for(i <- 0 until 11){
                    tx_core.io.user_csr_wr(i+19)    := cc_state_fifo.io.out.bits.user_define(i*8+7,i*8)
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
            when((tx_core.io.has_event_rd === 0.U)&(tx_core.io.event_recv_cnt === tx_core.io.event_processed_cnt)){
                io.cc_meta_out.valid            := 1.U
                io.cc_meta_out.bits             := meta_reg
                io.cc_meta_out.bits.op_code     := IB_OPCODE.safe(tx_core.io.user_csr_rd(0)(7,0))._1
                io.cc_meta_out.bits.qpn         := tx_core.io.user_csr_rd(1)
                io.cc_meta_out.bits.pkg_length  := tx_core.io.user_csr_rd(2)
                io.cc_meta_out.bits.header_len  := 1.U//fix it
                io.cc_req.valid                 := 1.U
                io.cc_req.bits.is_wr            := true.B
                io.cc_req.bits.lock             := false.B
                io.cc_req.bits.qpn              := tx_core.io.user_csr_rd(1)
                io.cc_req.bits.cc_state.credit  := tx_core.io.user_csr_rd(16)
                io.cc_req.bits.cc_state.rate    := tx_core.io.user_csr_rd(17) 
                io.cc_req.bits.cc_state.timer   := tx_core.io.user_csr_rd(18)  
                io.cc_req.bits.cc_state.user_define := Cat(tx_core.io.user_csr_rd(29),tx_core.io.user_csr_rd(28),tx_core.io.user_csr_rd(27),tx_core.io.user_csr_rd(26),tx_core.io.user_csr_rd(25),tx_core.io.user_csr_rd(24),
                                                            tx_core.io.user_csr_rd(23),tx_core.io.user_csr_rd(22),tx_core.io.user_csr_rd(21),tx_core.io.user_csr_rd(20),tx_core.io.user_csr_rd(19))          
                state                           := sIDLE
            }
        }
    }
}
