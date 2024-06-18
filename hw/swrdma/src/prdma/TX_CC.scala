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
        val user_header_len = Output(UInt(32.W))
        val tx_delay        = Input(UInt(32.W))
        val axi             = new AXI(33, 256, 6, 0, 4)

	})

    ///////////////////////////////////riscv
	Collector.fire(io.cc_meta_in)
    Collector.fire(io.cc_state_in)
    Collector.fire(io.cc_req)
    Collector.fire(io.cc_meta_out)
    


	val cpu_started = RegNext(io.cpu_started)
	// riscv-mini
	val config = MiniConfig()
	val tx_core = withClockAndReset(clock, cpu_started.asBool) { 
		Module(new Tile(
		coreParams = config.core, 
		bramParams = config.bram,
		nastiParams = config.nasti, 
		cacheParams = config.cache,
        file = "inst_tx.mem"
		))
	}

    Collector.report(tx_core.io.rdma_print_addr)
	Collector.report(tx_core.io.rdma_print_addr)
	Collector.report(tx_core.io.rdma_print_string_num)
	Collector.report(tx_core.io.rdma_print_string_len)
	Collector.report(tx_core.io.rdma_trap)
    Collector.report(tx_core.io.event_recv_cnt)

	io.axi.aw <> tx_core.io.nasti.aw
	io.axi.w <> tx_core.io.nasti.w
	io.axi.ar <> tx_core.io.nasti.ar
	io.axi.r <> tx_core.io.nasti.r
	io.axi.b <> tx_core.io.nasti.b

	tx_core.io.host := DontCare
    io.user_header_len   := tx_core.io.user_header_len


    /////////////////////////////////

    val cc_meta_fifo = XQueue(new Event_meta(), entries=16)
    val cc_state_fifo = XQueue(new CC_state(), entries=16)

    io.cc_meta_in                      <> cc_meta_fifo.io.in
    io.cc_state_in                     <> cc_state_fifo.io.in

    // val csr = Module(new CSR())

    val meta_reg = RegInit(0.U.asTypeOf(new Event_meta()))
    val cc_reg = RegInit(0.U.asTypeOf(new CC_state()))

	val sIDLE :: sCC_STATE :: sWR_CORE :: sWAIT :: sDONE :: Nil = Enum(5)
	val state                   = RegInit(sIDLE)
    val state_reg               = Reg(UInt(32.W))
    state_reg                   := state
    Collector.report(state_reg)
    // val pkg_meta_addr_base      = RegInit(0.U(5.W))

    // pkg_meta_addr_base          := tx_core.io.user_table_size

    cc_meta_fifo.io.out.ready               := (state === sIDLE) & (io.cc_req.ready)
    cc_state_fifo.io.out.ready              := (state === sCC_STATE) & (io.cc_req.ready)

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
            when((tx_core.io.has_event_rd === 0.U)){
                tx_core.io.has_event_wr             := 1.U
                for(i <- 0 until TIMELY.USER_TABLE_SIZE){
                    tx_core.io.user_csr_wr(i+1)    := cc_reg.user_define(i*32+31,i*32)
                }  
                for(i <- 0 until 8){
                    tx_core.io.user_csr_wr(i+4+TIMELY.USER_TABLE_SIZE)     := meta_reg.user_define(i*32+31,i*32)
                }                 
                tx_core.io.user_csr_wr(1+TIMELY.USER_TABLE_SIZE)           := meta_reg.op_code.asUInt
                tx_core.io.user_csr_wr(2+TIMELY.USER_TABLE_SIZE)           := meta_reg.pkg_length
                tx_core.io.user_csr_wr(3+TIMELY.USER_TABLE_SIZE)           := meta_reg.len_log
                tx_core.io.user_csr_wr(0)          := cc_reg.credit
                // tx_core.io.user_csr_wr(1)          := cc_reg.rate
                // tx_core.io.user_csr_wr(2)          := cc_reg.timer
                state                           := sWAIT
            }                 
        }
        is(sWAIT){
            when(io.cc_meta_out.ready & io.cc_req.ready ){
                state                           := sDONE
            }
        }
        is(sDONE){
            when((tx_core.io.has_event_rd === 0.U)&(tx_core.io.event_processed_cnt(0).asBool)){
                io.cc_meta_out.valid            := 1.U
                io.cc_meta_out.bits             := meta_reg
                // io.cc_meta_out.bits.qpn         := tx_core.io.user_csr_rd(1.U+pkg_meta_addr_base)
                io.cc_meta_out.bits.op_code     := IB_OPCODE.safe(tx_core.io.user_csr_rd(1+TIMELY.USER_TABLE_SIZE)(7,0))._1
                io.cc_meta_out.bits.pkg_length  := tx_core.io.user_csr_rd(2+TIMELY.USER_TABLE_SIZE)
                io.cc_meta_out.bits.header_len  := tx_core.io.user_header_len
                io.cc_meta_out.bits.user_define := Cat(tx_core.io.user_csr_rd(8+TIMELY.USER_TABLE_SIZE),tx_core.io.user_csr_rd(7+TIMELY.USER_TABLE_SIZE),tx_core.io.user_csr_rd(6+TIMELY.USER_TABLE_SIZE),tx_core.io.user_csr_rd(5+TIMELY.USER_TABLE_SIZE),tx_core.io.user_csr_rd(4+TIMELY.USER_TABLE_SIZE)) 
                io.cc_req.valid                 := 1.U
                io.cc_req.bits.is_wr            := true.B
                io.cc_req.bits.lock             := false.B
                io.cc_req.bits.qpn              := meta_reg.qpn
                io.cc_req.bits.cc_state.credit  := tx_core.io.user_csr_rd(0)
                // io.cc_req.bits.cc_state.rate    := tx_core.io.user_csr_rd(1) 
                // io.cc_req.bits.cc_state.timer   := tx_core.io.user_csr_rd(2)  
                io.cc_req.bits.cc_state.user_define := Cat(tx_core.io.user_csr_rd(11),tx_core.io.user_csr_rd(10),tx_core.io.user_csr_rd(9),tx_core.io.user_csr_rd(8),tx_core.io.user_csr_rd(7),tx_core.io.user_csr_rd(6),
                                                            tx_core.io.user_csr_rd(5),tx_core.io.user_csr_rd(4),tx_core.io.user_csr_rd(3),tx_core.io.user_csr_rd(2),tx_core.io.user_csr_rd(1))          
                state                           := sIDLE
            }
        }
    }
}
