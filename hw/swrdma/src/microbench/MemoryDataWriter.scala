package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.storage._
import common.axi._
import common._
import qdma._

/* Memory Writer 
 * This Module accepts memory write request from CPU via QDMA control reg,
 * writes corresponding data according to memory address and length
 * and finally writes callback signal to memory.
 */

class MemoryDataWriter extends Module {
    val io = IO(new Bundle {
        // Request sent from CPU, including address, length and callback address.
        val cpuReq      = Flipped(Decoupled(new PacketRequest))
        // QDMA H2C DMA signals
		val c2hCmd		= Decoupled(new C2H_CMD)
		val c2hData	    = Decoupled(new C2H_DATA)
        // Callback signals, which contains callback address to write.
        val callback    = Decoupled(UInt(64.W))
        // Input data stream.
        val memData     = Flipped(Decoupled(AXIS(512)))
    })

    // Push parameter to C2H engine.
    val dataFifo2       = XQueue(AXIS(512), 512)
    object DataWState extends ChiselEnum {
        val sDataWIdle, sDataWReq, sDataWData, sDataWCbReq = Value
    }
    import DataWState._

    val dataWSt = RegInit(DataWState(), sDataWIdle)

    val dataFifoBaseAddr    = RegInit(UInt(64.W), 0.U)
    val dataFifoDataRemain  = RegInit(UInt(32.W), 0.U)
    val dataFifoCbAddr      = RegInit(UInt(64.W), 0.U)
    val curCmdLen           = RegInit(UInt(32.W), 0.U)

    val callbackFifo = XQueue(UInt(64.W), 16)

    io.cpuReq.ready := (dataWSt === sDataWIdle)

    switch (dataWSt) {
        is (sDataWIdle) {
            when (io.cpuReq.fire) {
                dataWSt := sDataWReq
            }
        }
        is (sDataWReq) {
            when (io.c2hCmd.fire) {
                dataWSt := sDataWData
            }.otherwise {
                dataWSt := sDataWReq
            }
        }
        is (sDataWData) {
            when (io.c2hData.bits.last && io.c2hData.fire) {
                when (dataFifoDataRemain === 0.U) {
                    dataWSt := sDataWCbReq
                }.otherwise {
                    dataWSt := sDataWReq
                }
            }.otherwise {
                dataWSt := sDataWData
            }
        }
        is (sDataWCbReq) {
            when (callbackFifo.io.in.fire) {
                dataWSt := sDataWIdle
            }.otherwise {
                dataWSt := sDataWCbReq
            }
        }
    }

    val dataLeftCount = RegInit(UInt(32.W), 0.U)

    when (io.cpuReq.fire) {
        dataFifoBaseAddr    := io.cpuReq.bits.addr
        dataFifoDataRemain  := io.cpuReq.bits.size
        dataFifoCbAddr      := io.cpuReq.bits.callback
        dataLeftCount       := io.cpuReq.bits.size
    }.elsewhen ((dataWSt === sDataWReq) && io.c2hCmd.fire) {
        dataFifoDataRemain := 0.U
        curCmdLen   := dataFifoDataRemain
    }

    // Send C2H command.
    ToZero(io.c2hCmd.bits)
    io.c2hCmd.valid         := dataWSt === sDataWReq
    io.c2hCmd.bits.qid      := 0.U
    io.c2hCmd.bits.addr     := dataFifoBaseAddr
    io.c2hCmd.bits.len      := dataFifoDataRemain
    io.c2hCmd.bits.pfch_tag := 0.U

    // Send C2H data.
    ToZero(io.c2hData.bits)
    io.memData                  <> dataFifo2.io.in
    dataFifo2.io.out.ready            := io.c2hData.ready && (dataWSt === sDataWData)
    io.c2hData.valid            := dataFifo2.io.out.valid && (dataWSt === sDataWData)
    io.c2hData.bits.data        := dataFifo2.io.out.bits.data
    io.c2hData.bits.last        := dataLeftCount === 64.U
    io.c2hData.bits.mty         := 0.U
    io.c2hData.bits.ctrl_len    := curCmdLen
    io.c2hData.bits.ctrl_qid    := 0.U 

    when ((dataWSt === sDataWData) && io.c2hData.fire) {
        dataLeftCount := dataLeftCount - 64.U
    }

    // Write callbacks.
    callbackFifo.io.in.valid    := dataWSt === sDataWCbReq
    callbackFifo.io.in.bits     := dataFifoCbAddr
    io.callback <> callbackFifo.io.out
}