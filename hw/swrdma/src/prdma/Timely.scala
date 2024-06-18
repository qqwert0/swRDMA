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


class Timely() extends Module{
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


    io.pkg_type_to_cc   := "h20000".U


    /////////////////////////////////

    val cc_meta_fifo = XQueue(new Pkg_meta(), entries=2)
    val cc_state_fifo = XQueue(new CC_state(), entries=16)

    io.cc_meta_in                      <> cc_meta_fifo.io.in
    io.cc_state_in                     <> cc_state_fifo.io.in

    // val csr = Module(new CSR())

    val meta_reg = RegInit(0.U.asTypeOf(new Pkg_meta()))
    val cc_reg = RegInit(0.U.asTypeOf(new CC_state()))

	val sIDLE :: sCC_STATE :: sWR_CORE :: sWAIT :: sDONE :: Nil = Enum(5)
	val state                   = RegInit(sIDLE)

    cc_meta_fifo.io.out.ready               := (state === sIDLE) || (cc_meta_fifo.io.count>0.U)
    cc_state_fifo.io.out.ready              := (state === sCC_STATE) & (io.cc_req.ready)


    ToZero(io.cc_meta_out.valid)
    ToZero(io.cc_meta_out.bits)
    ToZero(io.cc_req.valid)
    ToZero(io.cc_req.bits)    


    val Timer = RegInit(0.U(32.W))
    val ts = RegInit(0.U(32.W))
    val rate = RegInit(0.S(32.W))
    val new_rtt = RegInit(0.S(32.W))
    val prev_rtt = RegInit(540.S(32.W))
    val rtt_diff = RegInit(0.S(32.W))
    val new_rtt_diff = RegInit(0.S(32.W))
    val alfa    = RegInit(TIMELY.alfa.S(32.W))
    val belta    = RegInit(TIMELY.belta.S(32.W))
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
        ts              := meta_reg.user_define(31,0)
        rate            := cc_reg.user_define(31,0).asTypeOf(SInt())
        cc_timer        := cc_reg.user_define(63,32)
        prev_rtt        := cc_reg.user_define(127,96).asTypeOf(SInt())
        rtt_diff        := cc_reg.user_define(159,128).asTypeOf(SInt())  
    }.elsewhen(cal_valid_shift(9) === 1.U){
        rtt_diff        := (mul_a + mul_b) >> 16.U
    }.elsewhen(cal_valid_shift(2) === 1.U){
        prev_rtt        := new_rtt
    }
    //cycle 1
    when(cal_valid_shift(0) === 1.U){
        new_rtt         := (Timer - ts).asTypeOf(SInt())
    }
    //cycle 2
    when(cal_valid_shift(1) === 1.U){
        new_rtt_diff    := new_rtt - prev_rtt
    }
    //cycle 4
    tmp_b               := 65536.S - alfa
    //cycle 5
    mul0.io.CLK         := clock
    mul0.io.A           := rtt_diff
    mul0.io.B           := tmp_b
    mul_a               := mul0.io.P
    //cycle 6
    mul1.io.CLK         := clock
    mul1.io.A           := new_rtt_diff
    mul1.io.B           := alfa
    mul_b               := mul1.io.P
    //cycle 9
    div0.io.aclk                        := clock
	div0.io.s_axis_divisor_tvalid       := cal_valid_shift(10)
	div0.io.s_axis_divisor_tdata        := TIMELY.minRTT.S
	div0.io.s_axis_dividend_tvalid      := cal_valid_shift(10)
	div0.io.s_axis_dividend_tdata       := rtt_diff<< 16.U
    when(div0.io.m_axis_dout_tvalid === 1.U){
        gradient        := div0.io.m_axis_dout_tdata(63,32).asTypeOf(SInt())
    }
    //cycle 10
    when(cal_valid_shift(1) === 1.U){
        rc0             := rate.asTypeOf(UInt()) + TIMELY.Rai.U
    }
    //cycle 10
    div1.io.aclk                        := clock
	div1.io.s_axis_divisor_tvalid       := cal_valid_shift(1)
	div1.io.s_axis_divisor_tdata        := new_rtt
	div1.io.s_axis_dividend_tvalid      := cal_valid_shift(1)
	div1.io.s_axis_dividend_tdata       := TIMELY.Thigh.S<<16.U
    when(div1.io.m_axis_dout_tvalid === 1.U){
        tmp0        := div1.io.m_axis_dout_tdata(63,32).asTypeOf(SInt())
    }    
    //cycle 11
    tmp1            := 65536.S - tmp0
    //12
    mul2.io.CLK         := clock
    mul2.io.A           := belta
    mul2.io.B           := tmp1
    tmp2                := mul2.io.P    
    //14
    tmp4            := 65536.S - (tmp2 >> 16.U)
    //15
    mul3.io.CLK         := clock
    mul3.io.A           := rate
    mul3.io.B           := tmp4
    rc1                := (mul3.io.P >> 16.U).asTypeOf(UInt())
    //10
    rc2             := rate.asTypeOf(UInt()) + (TIMELY.Rai.U*5.U)
    //10
    mul4.io.CLK         := clock
    mul4.io.A           := belta
    mul4.io.B           := gradient
    tmp5                := mul4.io.P 
    //11  
    tmp6            := tmp5 >> 16.U
    //12
    tmp7            := 65536.S - tmp6
    //13
    mul5.io.CLK         := clock
    mul5.io.A           := rate
    mul5.io.B           := tmp7
    rc3                 := (mul5.io.P.asTypeOf(UInt()))     
    //16
    when(cal_valid_shift(38) === 1.U){
        when(new_rtt < TIMELY.Tlow.S){
            rc          := rc0
        }.elsewhen(new_rtt > TIMELY.Thigh.S){
            rc          := rc1
        }.elsewhen(gradient <= 0.S){
            rc          := rc2
        }.otherwise{
            rc          := rc3 >> 16.U
        }        
    }

    //
    div2.io.aclk                        := clock
	div2.io.s_axis_divisor_tvalid       := cal_valid_shift(39)
	div2.io.s_axis_divisor_tdata        := rc.asTypeOf(SInt())
	div2.io.s_axis_dividend_tvalid      := cal_valid_shift(39)
	div2.io.s_axis_dividend_tdata       := TIMELY.DIVEDE_RATE_U.S
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
                }.otherwise{
                    state                           := sWR_CORE
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
                io.cc_req.bits.cc_state.user_define := Cat(rtt_diff,prev_rtt,divede_rate,cc_timer,rc)          
                state                           := sIDLE
            }
        }
    }

        class ila_timely(seq:Seq[Data]) extends BaseILA(seq)
        val inst_ila_timely = Module(new ila_timely(Seq(
            state,
            new_rtt,
            rc_reg
        )))

        inst_ila_timely.connect(clock)

}

