package mini.foo

import chisel3._
import chisel3.util._
import qdma.examples._
import qdma._
import common.axi._
import common.storage._
import common._

class AddrMsg() extends Bundle{
    val addr        = UInt(33.W) 
    val length      = UInt(32.W) 
}

class AXIToHBM() extends RawModule {

    val io = IO(new Bundle{
        val userClk     = Input(Clock())
        val userRstn    = Input(UInt(1.W))

        val hbmClk      = Input(Clock())
        val hbmRstn     = Input(UInt(1.W))

        val hbmCtrlAw   = Flipped(Decoupled(new AddrMsg))
        val hbmCtrlW    = Flipped(Decoupled(new H2C_DATA))
        // val wordCountW       = Output(UInt(32.W))
        // val wordCountR       = Output(UInt(32.W))

        val hbmCtrlAr   = Flipped(Decoupled(new AddrMsg))
        val hbmCtrlR    = Decoupled(new C2H_DATA)

        val hbmAxi    = new AXI(33, 256, 6, 0, 4)
    })

    io.hbmAxi.hbm_init()
    // Write(AW W)
    val hbmCtrlAw   = Wire(Decoupled(new AddrMsg))
    val hbmCtrlW    = Wire(Decoupled(new H2C_DATA))

    val clkCvtAw = XConverter(new AddrMsg, io.userClk, io.userRstn.asBool, io.hbmClk)
    val clkCvtW = XConverter(new H2C_DATA, io.userClk, io.userRstn.asBool, io.hbmClk)

    clkCvtAw.io.in <> io.hbmCtrlAw
    clkCvtAw.io.out <> hbmCtrlAw
    // val hbmCtrlAw = clkCvtAw.io.out

    clkCvtW.io.in <> io.hbmCtrlW
    clkCvtW.io.out  <> hbmCtrlW
    // val hbmCtrlW  = clkCvtW.io.out
    
    withClockAndReset(io.hbmClk, ~io.hbmRstn.asBool) {
        // 在 HBM 端用 XQueue 构建 FIFO
        val ctrlFifoAw  = XQueue(new AddrMsg, 1024, almostfull_threshold=800)   // 参数什么意思
        val ctrlFifoAw_r  = XQueue(new AddrMsg, 1024, almostfull_threshold=800)
        val ctrlFifoW   = XQueue(new H2C_DATA, 1024, almostfull_threshold=800)

        ctrlFifoAw.io.in    <> hbmCtrlAw
        ctrlFifoW.io.in     <> hbmCtrlW

        ToZero(ctrlFifoAw_r.io.in.valid)
        ToZero(ctrlFifoAw_r.io.in.bits)

        val sIdle :: sWrite :: sWriteSecond :: Nil = Enum(3)
        val StateAw   = RegInit(sIdle)
        val StateW    = RegInit(sIdle)
        val ctrlAwAddr = RegInit(UInt(33.W), 0.U)
        val ctrlAwLen  = RegInit(UInt(32.W), 0.U)   // 我们从 addr 开始要传多少字节
        val ctrlWLen  = RegInit(UInt(32.W), 0.U)
        val wLen      = RegInit(UInt(9.W), 0.U)
        // val wData_1   = RegInit(UInt(256.W), 0.U)
        val wData_2   = RegInit(UInt(256.W), 0.U) // 这里只有高位需要寄存器

        ctrlFifoAw.io.out.ready := StateAw === sIdle
        ctrlFifoAw_r.io.out.ready := StateW  === sIdle
        ctrlFifoW.io.out.ready  := io.hbmAxi.w.fire && (StateW  === sWrite)
        io.hbmAxi.aw.valid      := StateAw === sWrite
        io.hbmAxi.aw.bits.addr  := ctrlAwAddr
        when(ctrlAwLen > 512.U) {
            io.hbmAxi.aw.bits.len := 15.U
        }.otherwise {
            io.hbmAxi.aw.bits.len := (ctrlAwLen >> 5.U) - 1.U
        }
        io.hbmAxi.w.bits.strb := "hffffffff".U
        io.hbmAxi.w.bits.data := Mux(ctrlWLen(5), wData_2, ctrlFifoW.io.out.bits.data(255, 0))
        io.hbmAxi.w.bits.last := ((wLen === 15.U)||(ctrlWLen <= 32.U)) && io.hbmAxi.w.fire
        io.hbmAxi.w.valid     := ((StateW === sWrite) && ctrlFifoW.io.out.valid) || (StateW === sWriteSecond)
    
        // AW
        switch(StateAw) {
            is(sIdle) {
                when (ctrlFifoAw.io.out.fire) {
                    ctrlAwAddr := ctrlFifoAw.io.out.bits.addr
                    ctrlAwLen  := ctrlFifoAw.io.out.bits.length
                    ctrlFifoAw_r.io.in.valid    := 1.U  // 最后怎么为 0 ？
                    ctrlFifoAw_r.io.in.bits     := ctrlFifoAw.io.out.bits
                    StateAw := sWrite
                }
            }
            is(sWrite) {
                when (io.hbmAxi.aw.fire) {
                    when (ctrlAwLen > 512.U) {
                        ctrlAwAddr := ctrlAwAddr + 512.U
                        ctrlAwLen  := ctrlAwLen - 512.U
                        StateAw := sWrite
                    }.otherwise {
                        StateAw := sIdle
                    }
                }
            }
        }
        // W
        switch(StateW) {
            is(sIdle) {
                // AW 的地址和长度已经到了 AW_r 的 FIFO 末尾
                when (ctrlFifoAw_r.io.out.fire) {
                    ctrlWLen := ctrlFifoAw_r.io.out.bits.length
                    wLen     := 0.U
                    StateW   := sWrite
                }
            }
            is(sWrite) {
                when (io.hbmAxi.w.fire) {
                    wLen := wLen + 1.U
                    ctrlWLen := ctrlWLen - 32.U
                    wData_2 := ctrlFifoW.io.out.bits.data(511, 256)
                    StateW := sWriteSecond
                }
            }
            is(sWriteSecond) {
                when (io.hbmAxi.w.fire) {
                    wLen := wLen + 1.U
                    when(wLen === 15.U){
                        wLen := 0.U
                    }
                    when(ctrlWLen > 32.U){
                        ctrlWLen := ctrlWLen - 32.U
                        StateW := sWrite
                    }.otherwise{
                        StateW := sIdle
                    }
                }
            }
        }
        // 写低 32 bytes 还是高 32 bytes
        io.hbmAxi.b.ready       := 1.U
        // val ctrlCountW = RegInit(UInt(32.W), 0.U)
        // when (io.hbmAxi.b.fire) {
        //     ctrlCountW := ctrlCountW + 1.U
        // }
        // io.wordCountW := ctrlCountW
    }


    // Read(AR R)
    val hbmCtrlAr   = Wire(Decoupled(new AddrMsg))
    val hbmCtrlR    = Wire(Decoupled(new C2H_DATA))

    val clkCvtAr = XConverter(new AddrMsg, io.userClk, io.userRstn.asBool, io.hbmClk)
    val clkCvtR = XConverter(new C2H_DATA, io.hbmClk, io.userRstn.asBool, io.userClk)

    clkCvtAr.io.in <> io.hbmCtrlAr
    clkCvtAr.io.out <> hbmCtrlAr
    // val hbmCtrlAr = clkCvtAr.io.out

    clkCvtR.io.out <> io.hbmCtrlR
    clkCvtR.io.in  <> hbmCtrlR
    // val hbmCtrlR  = clkCvtR.io.in

    withClockAndReset(io.hbmClk, ~io.hbmRstn.asBool) {
        val ctrlFifoAr  = XQueue(new AddrMsg, 1024, almostfull_threshold=800)   // 参数什么意思
        val ctrlFifoAr_r  = XQueue(new AddrMsg, 1024, almostfull_threshold=800)
        val ctrlFifoR   = XQueue(new C2H_DATA, 1024, almostfull_threshold=800)

        ctrlFifoAr.io.in    <> hbmCtrlAr
        ctrlFifoR.io.out    <> hbmCtrlR

        ToZero(ctrlFifoAr_r.io.in.valid)
        ToZero(ctrlFifoAr_r.io.in.bits)
        ToZero(ctrlFifoR.io.in.bits)

        val sIdle :: sWrite :: sWriteSecond :: Nil = Enum(3)
        val StateAr   = RegInit(sIdle)
        val StateR    = RegInit(sIdle)
        val ctrlArAddr = RegInit(UInt(33.W), 0.U)
        val ctrlArLen  = RegInit(UInt(32.W), 0.U)
        val ctrlRLen  = RegInit(UInt(32.W), 0.U)
        val rData_1   = RegInit(UInt(256.W), 0.U)
        io.hbmAxi.r.ready       := (StateR === sWrite)||((StateR  === sWriteSecond) && ctrlFifoR.io.out.ready)
        ctrlFifoAr.io.out.ready := StateAr === sIdle
        ctrlFifoAr_r.io.out.ready := StateR  === sIdle
        io.hbmAxi.ar.valid      := StateAr === sWrite
        io.hbmAxi.ar.bits.addr  := ctrlArAddr
        when(ctrlArLen > 512.U) {
            io.hbmAxi.ar.bits.len := 15.U
        }.otherwise {
            io.hbmAxi.ar.bits.len := (ctrlArLen >> 5.U) - 1.U
        }
        ctrlFifoR.io.in.valid   := ((StateR  === sWriteSecond)&& io.hbmAxi.r.fire)
        ctrlFifoR.io.in.bits.data    := Cat(io.hbmAxi.r.bits.data, rData_1)
        // ctrlFifoR.io.in.bits.last    := io.hbmAxi.r.bits.last
        ctrlFifoR.io.in.bits.last    := (StateR === sWriteSecond) && io.hbmAxi.r.fire && (ctrlRLen <= 32.U)
        ctrlFifoR.io.in.bits.ctrl_len := Mux(ctrlRLen <= 32.U, ctrlRLen, 32.U)


        // AR
        switch(StateAr) {
            is(sIdle) {
                when (ctrlFifoAr.io.out.fire) {
                    ctrlArAddr := ctrlFifoAr.io.out.bits.addr
                    ctrlArLen  := ctrlFifoAr.io.out.bits.length
                    ctrlFifoAr_r.io.in.valid    := 1.U
                    ctrlFifoAr_r.io.in.bits     := ctrlFifoAr.io.out.bits
                    StateAr := sWrite
                }
            }
            is(sWrite) {
                when (io.hbmAxi.ar.fire) {
                    when (ctrlArLen > 512.U) {
                        ctrlArAddr := ctrlArAddr + 512.U
                        ctrlArLen  := ctrlArLen - 512.U
                        StateAr := sWrite
                    }.otherwise {
                        StateAr := sIdle
                    }
                }
            }
        }
        // R
        switch(StateR) {
            is(sIdle) {
                when (ctrlFifoAr_r.io.out.fire) {
                    ctrlRLen := ctrlFifoAr_r.io.out.bits.length
                    StateR   := sWrite
                }
            }
            is(sWrite) {
                when (io.hbmAxi.r.fire) {
                    ctrlRLen := ctrlRLen - 32.U
                    rData_1 := io.hbmAxi.r.bits.data
                    StateR := sWriteSecond
                }
            }
            is(sWriteSecond) {
                when (io.hbmAxi.r.fire) {
                    when(ctrlRLen > 32.U){
                        ctrlRLen := ctrlRLen - 32.U
                        StateR := sWrite
                    }.otherwise{
                        StateR := sIdle
                    }
                }
            }
        }

        // val ctrlCountR = RegInit(UInt(32.W), 0.U)
        // when (hbmCtrlR.fire) {
        //     ctrlCountR := ctrlCountR + 1.U
        // }
        // io.wordCountR := ctrlCountR
    }   
}