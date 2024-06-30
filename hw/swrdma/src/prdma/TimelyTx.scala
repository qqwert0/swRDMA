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



class TimelyTx() extends Module{
	val io = IO(new Bundle{
        val cc_meta_in      = Flipped(Decoupled(new Event_meta()))
        val cc_state_in     = Flipped(Decoupled(new CC_state()))
        val cc_req          = (Decoupled(new CC_req()))
        val cc_meta_out     = (Decoupled(new Event_meta()))

        val cpu_started     = Input(Bool())
        val tx_delay        = Input(UInt(32.W))
        val user_header_len = Output(UInt(32.W))
        val axi             = new AXI(33, 256, 6, 0, 4)

	})

    ///////////////////////////////////riscv
	Collector.fire(io.cc_meta_in)
    Collector.fire(io.cc_state_in)
    Collector.fire(io.cc_req)
    Collector.fire(io.cc_meta_out)

	io.axi <> DontCare

    io.user_header_len   := CONFIG.SWRDMA_HEADER_CHOICE.U


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


    val Timer = RegInit(0.U(64.W))
    val cpu_started = RegNext(io.cpu_started)
    val cc_timer = RegInit(0.U(32.W))
    val time_diff = RegInit(0.U(32.W))
    val divide_rate = RegInit(0.U(32.W))
    val delay = RegInit(0.U(32.W))
    val tx_delay = RegNext(io.tx_delay)



    when(!cpu_started){
        Timer       := Timer + 1.U;
    }.otherwise{
        Timer       := 0.U
    }

    

    when(state === sWR_CORE){
        delay   := 0.U
    }.elsewhen(state === sWAIT){
        delay   := delay + 1.U
    }



    cc_meta_fifo.io.out.ready               := (state === sIDLE) & (io.cc_req.ready)
    cc_state_fifo.io.out.ready              := (state === sCC_STATE) & (io.cc_req.ready)


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
            time_diff       := (Timer - cc_reg.user_define(63,32)) << 8.U;
            cc_timer        := cc_reg.user_define(63,32)
            divide_rate     := cc_reg.user_define(95,64) << meta_reg.len_log(4,0)
            state                           := sWAIT                
        }
        is(sWAIT){
            when((time_diff > divide_rate)&&(delay >= tx_delay)){   
                state                           := sDONE
            }
            time_diff       := (Timer - cc_timer) << 8.U;
        }
        is(sDONE){
                io.cc_meta_out.valid            := 1.U
                io.cc_meta_out.bits             := meta_reg
                // io.cc_meta_out.bits.qpn         := tx_core.io.user_csr_rd(1.U+pkg_meta_addr_base)
                io.cc_meta_out.bits.op_code     := meta_reg.op_code
                io.cc_meta_out.bits.header_len  := (CONFIG.SWRDMA_HEADER_LEN/8).U
                io.cc_meta_out.bits.user_define := 0.U//Cat("h0".U,Timer) 
                io.cc_req.valid                 := 1.U
                io.cc_req.bits.is_wr            := true.B
                io.cc_req.bits.lock             := false.B
                io.cc_req.bits.qpn              := meta_reg.qpn
                io.cc_req.bits.cc_state.credit  := 0.U
                io.cc_req.bits.cc_state.user_define := Cat("h0".U,cc_reg.divide_rate,Timer(31,0),cc_reg.rate)          
                state                           := sIDLE
        }
    }

	val len_log = WireInit(0.U(5.W))
	len_log	:= meta_reg.len_log(4,0)

        class ila_timelytx(seq:Seq[Data]) extends BaseILA(seq)
        val inst_ila_timelytx = Module(new ila_timelytx(Seq(
            state,
            time_diff,
            divide_rate,
        )))

        inst_ila_timelytx.connect(clock)


}
