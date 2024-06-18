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
        val pkg_type_to_cc  = Output(UInt(32.W))
        val axi             = new AXI(33, 256, 6, 0, 4)

	})

    ///////////////////////////////////riscv

	val cpu_started = RegNext(io.cpu_started)
	// riscv-mini
	val config = MiniConfig()
	val rx_core = withClockAndReset(clock, cpu_started.asBool) { 
		Module(new Tile(
		coreParams = config.core, 
		bramParams = config.bram,
		nastiParams = config.nasti, 
		cacheParams = config.cache,
        file = "inst_rx.mem"
		))
	}

    Collector.report(rx_core.io.rdma_print_addr)
	Collector.report(rx_core.io.rdma_print_addr)
	Collector.report(rx_core.io.rdma_print_string_num)
	Collector.report(rx_core.io.rdma_print_string_len)
	Collector.report(rx_core.io.rdma_trap)

	io.axi.aw <> rx_core.io.nasti.aw
	io.axi.w <> rx_core.io.nasti.w
	io.axi.ar <> rx_core.io.nasti.ar
	io.axi.r <> rx_core.io.nasti.r
	io.axi.b <> rx_core.io.nasti.b

	rx_core.io.host := DontCare
    io.pkg_type_to_cc   := rx_core.io.pkg_type_to_cc


    /////////////////////////////////

    val cc_meta_fifo = XQueue(new Pkg_meta(), entries=16)
    val cc_state_fifo = XQueue(new CC_state(), entries=16)

    io.cc_meta_in                      <> cc_meta_fifo.io.in
    io.cc_state_in                     <> cc_state_fifo.io.in

    // val csr = Module(new CSR())

    val meta_reg = RegInit(0.U.asTypeOf(new Pkg_meta()))
    val cc_reg = RegInit(0.U.asTypeOf(new CC_state()))

	val sIDLE :: sCC_STATE :: sWR_CORE :: sWAIT :: sDONE :: Nil = Enum(5)
	val state                   = RegInit(sIDLE)
    val pkg_meta_addr_base      = RegInit(0.U(5.W))

    pkg_meta_addr_base          := rx_core.io.user_table_size

    cc_meta_fifo.io.out.ready               := (state === sIDLE) & (io.cc_req.ready)
    cc_state_fifo.io.out.ready              := (state === sCC_STATE) & (io.cc_req.ready)

    // ToZero(csr.io.cmd)
    // ToZero(csr.io.addr)
    // ToZero(csr.io.data_in)
    ToZero(rx_core.io.has_event_wr)
    ToZero(rx_core.io.user_csr_wr)
    ToZero(io.cc_meta_out.valid)
    ToZero(io.cc_meta_out.bits)
    ToZero(io.cc_req.valid)
    ToZero(io.cc_req.bits)    

    switch(state){
        is(sIDLE){
            when(cc_meta_fifo.io.out.fire){
                meta_reg                        := cc_meta_fifo.io.out.bits
                io.cc_req.valid                 := 1.U
                io.cc_req.bits.is_wr            := false.B
                io.cc_req.bits.lock             := false.B
                io.cc_req.bits.qpn              := cc_meta_fifo.io.out.bits.qpn
                state                           := sCC_STATE
            }                 
        }    
        is(sCC_STATE){
            when(cc_state_fifo.io.out.fire){
                cc_reg                          := cc_state_fifo.io.out.bits
                when(cc_state_fifo.io.out.bits.lock === true.B){
                    io.cc_req.valid                 := 1.U
                    io.cc_req.bits.is_wr            := false.B
                    io.cc_req.bits.lock             := false.B
                    io.cc_req.bits.qpn              := meta_reg.qpn     
                    state                           := sCC_STATE                
                }.otherwise{
                    state                           := sWR_CORE
                }
            }                 
        }         
        is(sWR_CORE){
            when((rx_core.io.has_event_rd === 0.U)){
                rx_core.io.has_event_wr             := 1.U
                for(i <- 0 until 11){
                    rx_core.io.user_csr_wr(i.U+4.U+pkg_meta_addr_base)     := meta_reg.user_define(i*8+7,i*8)
                    rx_core.io.user_csr_wr(i+1)    := cc_reg.user_define(i*8+7,i*8)
                }
                rx_core.io.user_csr_wr(1.U+pkg_meta_addr_base)           := meta_reg.op_code.asUInt
                rx_core.io.user_csr_wr(2.U+pkg_meta_addr_base)           := meta_reg.pkg_length
                rx_core.io.user_csr_wr(3.U+pkg_meta_addr_base)           := 0.U
                rx_core.io.user_csr_wr(0)          := cc_reg.credit
                // rx_core.io.user_csr_wr(1)          := cc_reg.rate
                // rx_core.io.user_csr_wr(2)          := cc_reg.timer
                state                           := sWAIT
            }                 
        }
        is(sWAIT){
            when(io.cc_meta_out.ready & io.cc_req.ready ){
                state                           := sDONE
            }
        }
        is(sDONE){
            when((rx_core.io.has_event_rd === 0.U)&(rx_core.io.event_recv_cnt === rx_core.io.event_processed_cnt)){
                io.cc_meta_out.valid            := 1.U
                io.cc_meta_out.bits             := meta_reg
                // io.cc_meta_out.bits.qpn         := rx_core.io.user_csr_rd(1.U+pkg_meta_addr_base)
                io.cc_meta_out.bits.op_code     := IB_OPCODE.safe(rx_core.io.user_csr_rd(1.U+pkg_meta_addr_base)(7,0))._1
                io.cc_meta_out.bits.pkg_length  := rx_core.io.user_csr_rd(2.U+pkg_meta_addr_base)
                // io.cc_meta_out.bits.header_len  := rx_core.io.user_header_len
                io.cc_req.valid                 := 1.U
                io.cc_req.bits.is_wr            := true.B
                io.cc_req.bits.lock             := false.B
                io.cc_req.bits.qpn              := meta_reg.qpn
                io.cc_req.bits.cc_state.credit  := rx_core.io.user_csr_rd(0)
                // io.cc_req.bits.cc_state.rate    := rx_core.io.user_csr_rd(1) 
                // io.cc_req.bits.cc_state.timer   := rx_core.io.user_csr_rd(2)  
                io.cc_req.bits.cc_state.user_define := Cat(rx_core.io.user_csr_rd(11),rx_core.io.user_csr_rd(10),rx_core.io.user_csr_rd(9),rx_core.io.user_csr_rd(8),rx_core.io.user_csr_rd(7),rx_core.io.user_csr_rd(6),
                                                            rx_core.io.user_csr_rd(5),rx_core.io.user_csr_rd(4),rx_core.io.user_csr_rd(3),rx_core.io.user_csr_rd(2),rx_core.io.user_csr_rd(1))          
                state                           := sIDLE
            }
        }
    }
}
