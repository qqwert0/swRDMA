package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.storage._
import common._
import qdma._

/* Memory Callback Writer 
 * This module accepts callback address and write `1` to corresponding *physical* address
 * via QDMA AXI Slave Bridge interface.
 */

class MemoryCallbackWriter extends Module {
    val io = IO(new Bundle {
        val callback    = Flipped(Decoupled(UInt(64.W)))
        val sAxib       = new AXIB_SLAVE
    })

    val innerTimer = RegInit(UInt(16.W), 0.U)

    innerTimer  := innerTimer + 1.U(16.W)

    val callbackFifo = XQueue(new ValueWithTime(64, 16), 16)
    callbackFifo.io.in.valid    := io.callback.valid
    callbackFifo.io.in.bits.bits:= io.callback.bits
    callbackFifo.io.in.bits.time:= innerTimer
    io.callback.ready           := callbackFifo.io.in.ready

    // AXI slave bridge initialization
    io.sAxib.qdma_init()
    // Write callback to slave bridge.
    io.sAxib.aw.bits.addr       := Cat(Seq(callbackFifo.io.out.bits.bits(63, 6), 0.U(6.W)))
    io.sAxib.aw.bits.size       := 2.U(3.W)
    io.sAxib.aw.bits.len        := 0.U(8.W)
    io.sAxib.aw.valid           := callbackFifo.io.out.valid & Delay50Us(callbackFifo.io.out.bits.time, innerTimer)
    callbackFifo.io.out.ready   := io.sAxib.aw.ready & Delay50Us(callbackFifo.io.out.bits.time, innerTimer)

    // Control S_AXIB data offset.
    val callbackOffFifo = XQueue(UInt(6.W), 256)
    callbackOffFifo.io.in.valid     := callbackFifo.io.out.fire
    callbackOffFifo.io.in.bits      := callbackFifo.io.out.bits.bits(5, 0)
    io.sAxib.w.bits.data            := (1.U(63.W) << Cat(Seq(callbackOffFifo.io.out.bits, 0.U(3.W))))
    io.sAxib.w.bits.strb            := ("hf".U(63.W) << callbackOffFifo.io.out.bits)
    io.sAxib.w.bits.last            := 1.U
    io.sAxib.w.valid                := callbackOffFifo.io.out.valid
    callbackOffFifo.io.out.ready   := io.sAxib.w.ready
}

object Delay50Us {
    // Make a safe boundary for callback write.

    def apply(toCmp: UInt, current:UInt) = {
        assert(toCmp.getWidth == current.getWidth)
        assert(toCmp.getWidth >= 10)

        // Require: current >= toCmp + 500

        val res = Wire(Bool())

        res := (current - toCmp) >= 12500.U(toCmp.getWidth.W)

        res
    }
}

class ValueWithTime (
    VALUE_BITS : Int = 64,
    TIME_BITS  : Int = 12
) extends Bundle {
    val bits = Output(UInt(VALUE_BITS.W))
    val time = Output(UInt(TIME_BITS.W))
}