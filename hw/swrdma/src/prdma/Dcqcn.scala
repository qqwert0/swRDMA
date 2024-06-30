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


class Dcqcn() extends Module{
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

	Collector.fire(io.cc_meta_in)
	Collector.fire(io.cc_state_in)
	Collector.fire(io.cc_req)
	Collector.fire(io.cc_meta_out)

	val cpu_started = RegNext(io.cpu_started)
	// riscv-mini

    Collector.fire(io.cc_meta_in)

	io.axi <> DontCare


    io.pkg_type_to_cc   := "h20fc0".U


    /////////////////////////////////

    val cc_meta_fifo = XQueue(new Pkg_meta(), entries=2)
    val cc_state_fifo = XQueue(new CC_state(), entries=16)

    io.cc_meta_in                      <> cc_meta_fifo.io.in
    io.cc_state_in                     <> cc_state_fifo.io.in

    // val csr = Module(new CSR())

    val meta_reg = RegInit(0.U.asTypeOf(new Pkg_meta()))
    val cc_reg = RegInit(0.U.asTypeOf(new CC_state()))

	val sIDLE :: sCC_STATE :: sWR_CORE :: sWAIT :: sDONE :: sDATAPKT :: Nil = Enum(6)
	val state                   = RegInit(sIDLE)

    cc_meta_fifo.io.out.ready               := (state === sIDLE) || (cc_meta_fifo.io.count>0.U)
    cc_state_fifo.io.out.ready              := (state === sCC_STATE) & (io.cc_req.ready)


    ToZero(io.cc_meta_out.valid)
    ToZero(io.cc_meta_out.bits)
    ToZero(io.cc_req.valid)
    ToZero(io.cc_req.bits)    


    val Timer = RegInit(0.U(64.W))
    val ecn = RegInit(0.U(32.W))
    val rate = RegInit(0.U(32.W))
    val byte_count = RegInit(0.U(32.W))
    val BC = RegInit(0.U(32.W))
    val T = RegInit(0.U(32.W))
    val last_time = RegInit(0.U(64.W))
    val rt = RegInit(0.U(32.W))
    val ecn_time = RegInit(0.U(64.W))
    val update_alfa = RegInit(false.B)

    val alfa    = RegInit(0.U(32.W))
    val tmp_b = RegInit(0.S(32.W))
    val mul_a = RegInit(0.S(64.W))
    val mul_b = RegInit(0.S(64.W))
    val gradient_pre    = RegInit(TIMELY.belta.S(32.W))
    val gradient    = RegInit(TIMELY.belta.S(32.W))
    val tmp0 = RegInit(0.S(32.W))
    val tmp1 = RegInit(0.S(32.W))
    val tmp2 = RegInit(0.S(32.W))
    val tmp3 = RegInit(0.S(32.W))
    val tmp4 = RegInit(0.S(32.W))
    val tmp5 = RegInit(0.S(64.W))
    val tmp6 = RegInit(0.S(32.W))
    val tmp7 = RegInit(0.S(32.W))
    val rc0 = RegInit(0.U(32.W))
    val rc1 = RegInit(0.U(32.W))
    val rc2 = RegInit(0.U(32.W))
    val rc3 = RegInit(0.U(64.W))
    val rt1 = RegInit(0.U(32.W))
    val rc = RegInit(0.U(32.W))
    val rc_reg = RegInit(0.U(32.W))
    val cc_timer = RegInit(0.U(32.W))
    val divede_rate = RegInit(0.U(32.W))
    val delay = RegInit(0.U(8.W))
    val cal_valid_shift = RegInit(0.U(40.W))
    val cal_valid = RegInit(0.U(1.W))

    val mul0 = Module(new mult_32_32())
    val mul1 = Module(new mult_32_32())
    val mul2 = Module(new mult_32_32())
    val mul3 = Module(new mult_32_32())
    val mul4 = Module(new mult_32_32())
    val mul5 = Module(new mult_32_32())
    val div0 = Module(new div_32_32())
    val div1 = Module(new div_32_32())
    val div2 = Module(new div_32_32())

    cal_valid_shift   := Cat(cal_valid_shift(38,0),cal_valid)
    rc_reg              := RegNext(RegNext(rc))

    when(!cpu_started){
        Timer       := Timer + 1.U;
    }.otherwise{
        Timer       := 0.U
    }

    //cycle 0
    when(state === sWR_CORE){
        ecn             := meta_reg.user_define(31,0)
        rate            := cc_reg.user_define(31,0)
        cc_timer        := cc_reg.user_define(63,32)
        byte_count      := cc_reg.user_define(127,96)
        BC              := cc_reg.user_define(159,128) 
        T               := cc_reg.user_define(191,160)
        last_time       := cc_reg.user_define(255,192)
        rt              := cc_reg.user_define(287,256)
        alfa            := cc_reg.user_define(319,288)
    }.elsewhen((cal_valid_shift(7) === 1.U)&(ecn=== "hffffffff".U)){
        rt              := rate
        update_alfa     := true.B
        alfa            := (mul_b.asUInt >> 16.U) + DCQCN.g.U
    }.elsewhen((cal_valid_shift(7) === 1.U)&((Timer - last_time)>=DCQCN.T_55us.U)){
        when(update_alfa){
            alfa            := (mul_b.asUInt >> 16.U)
        }.otherwise{
            update_alfa     := false.B
            alfa            := alfa
        }
        T               := T + 1.U
    }.elsewhen((cal_valid_shift(8) === 1.U)&((Timer - last_time)>=DCQCN.T_55us.U)&(T>5.U)){
        when(rt > 1200.U){
            rt              := rt
        }.otherwise{
            rt              := rt + DCQCN.Rai.U
        }
    }
    //cycle 1
    //cycle 4
    tmp_b               := 65536.S - (alfa.asSInt>>1.U)
    //cycle 5
    mul0.io.CLK         := clock
    mul0.io.A           := rate.asTypeOf(SInt())
    mul0.io.B           := tmp_b
    mul_a               := mul0.io.P
    //cycle 6
    mul1.io.CLK         := clock
    mul1.io.A           := alfa.asSInt
    mul1.io.B           := DCQCN.one_g.S
    mul_b               := mul1.io.P
    when((cal_valid_shift(7) === 1.U)&(ecn=== "hffffffff".U)){
        rc0             := mul_a.asUInt >> 16.U
        
    }
    
    when(cal_valid_shift(9) === 1.U){
        rc1            := (rate + rt) >> 1.U
    }   
    //16
    when(cal_valid_shift(10) === 1.U){
        when(ecn=== "hffffffff".U){
            rc          := rc0
        }.elsewhen(((Timer - last_time)>=DCQCN.T_55us.U)&(T>5.U)){
            rc          := rc1
            last_time   := Timer
        }.otherwise{
            rc          := rate
        }        
    }

    //
    div2.io.aclk                        := clock
	div2.io.s_axis_divisor_tvalid       := cal_valid_shift(11)
	div2.io.s_axis_divisor_tdata        := rc.asTypeOf(SInt())
	div2.io.s_axis_dividend_tvalid      := cal_valid_shift(11)
	div2.io.s_axis_dividend_tdata       := DCQCN.DIVEDE_RATE_U.S
    when(div2.io.m_axis_dout_tvalid === 1.U){
        divede_rate        := div2.io.m_axis_dout_tdata(63,32).asTypeOf(UInt())
    }  

    when(state === sWR_CORE){
        delay   := 0.U
    }.elsewhen(state === sWAIT){
        delay   := delay + 1.U
    }


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
                }.elsewhen(PKG_JUDGE.HAVE_DATA(meta_reg.op_code)){
                    state                           := sDATAPKT
                }.otherwise{
                    state                           := sWR_CORE
                }
            }                 
        } 
        is(sDATAPKT){
            when(io.cc_meta_out.ready){
                state                           := sIDLE  
                io.cc_meta_out.valid            := 1.U  
                io.cc_meta_out.bits             := meta_reg
                io.cc_meta_out.bits.op_code     := IB_OPCODE.RC_ACK
                io.cc_meta_out.bits.msg_length  := 0.U
                io.cc_meta_out.bits.pkg_length  := 0.U
                when(((Timer - ecn_time)>=DCQCN.T_50us.U)){
                    io.cc_meta_out.bits.user_define	:= meta_reg.user_define
                    ecn_time                        := Timer
                }.otherwise{
                    io.cc_meta_out.bits.user_define	:= 0.U
                }                
            }
        }                
        is(sWR_CORE){
            state                           := sWAIT  
            cal_valid                       := 1.U            
        }
        is(sWAIT){
            cal_valid                       := 0.U     
            when(div2.io.m_axis_dout_tvalid === 1.U){
                state                           := sDONE
            }
        }
        is(sDONE){
            when((io.cc_req.ready)){
                io.cc_req.valid                 := 1.U
                io.cc_req.bits.is_wr            := true.B
                io.cc_req.bits.lock             := false.B
                io.cc_req.bits.qpn              := meta_reg.qpn
                io.cc_req.bits.cc_state.credit  := 0.U
                io.cc_req.bits.cc_state.user_define := Cat(alfa,rt,last_time,T,BC,byte_count,divede_rate,cc_timer,rc)          
                state                           := sIDLE
            }
        }
    }

        class ila_timely(seq:Seq[Data]) extends BaseILA(seq)
        val inst_ila_timely = Module(new ila_timely(Seq(
            state,
            ecn,
            rc_reg,
            rate,
            rt,
        )))

        inst_ila_timely.connect(clock)

}

