package qdma.examples

import chisel3._
import chisel3.util._
import common._
import qdma._

class C2H_AXIL() extends Module {
    val io = IO(new Bundle{
        val startAddress    = Input(UInt(64.W))
        val length          = Input(UInt(32.W))
        val start           = Input(UInt(32.W))

        val totalWords      = Input(UInt(32.W))
        val totalCommands   = Input(UInt(32.W))
        val pfchTag         = Input(UInt(32.W))
        val tagIndex        = Input(UInt(32.W))

        val countWords      = Output(UInt(32.W))
        val countCommand    = Output(UInt(32.W))
        val countTime       = Output(UInt(32.W))

        val c2hCommand      = Decoupled(new C2H_CMD)
        val c2hData         = Decoupled(new C2H_DATA)
    })

    val tag                     = RegInit(0.U(7.W))
    val address                 = RegInit(0.U(64.W))
    val commandValid            = RegInit(false.B)
    val dataValid               = RegInit(false.B)
    val countTime               = RegInit(0.U(32.W))
    val countWords              = RegInit(0.U(32.W))
    val countWordsPerCommand    = RegInit(0.U(32.W))
    val countCommand            = RegInit(0.U(32.W))
    val start                   = RegNext(io.start)
    val startAddress            = RegNext(io.startAddress)

    // command
    val command             = io.c2hCommand.bits
    command                 := 0.U.asTypeOf(new C2H_CMD)
    command.qid             := 0.U
    command.addr            := address
    command.pfch_tag        := io.pfchTag
    command.len             := io.length

    io.c2hCommand.valid     := commandValid

    // data
    val data = io.c2hData.bits
    data                    := 0.U.asTypeOf(new C2H_DATA)
    data.data               := Cat(Seq.fill(16)(countWords)).asUInt
    data.ctrl_qid           := 0.U

    io.c2hData.valid        := dataValid

    // state machine
    val sIDLE :: sSEND :: sDONE :: Nil = Enum(3)
    val c2hState            = RegInit(sIDLE)
    // state switch
    switch (c2hState) {
        is (sIDLE) {
            commandValid            := false.B
            when ((countWords === io.totalWords - 1.U && io.c2hData.fire) || countWords === 0.U) {
                dataValid           := false.B
            }.otherwise {
                dataValid           := true.B
            }
            when (start === 1.U) {
                c2hState                := sSEND
                countCommand            := 0.U
                countWords              := 0.U
                countWordsPerCommand    := 0.U
                address                 := startAddress
            }
        }

        is (sSEND) {
            commandValid    := true.B
            dataValid       := true.B
            countTime       := countTime + 1.U
            when (start === 0.U && countCommand === io.totalCommands - 1.U && io.c2hCommand.fire) {
                c2hState    := sIDLE
                commandValid    := false.B
            }
        }
        is (sDONE) {
            c2hState        := sIDLE
        }
    }

    // C2H Command Update
    when (io.c2hCommand.fire) {
        countCommand        := Mux(
            countCommand =/= io.totalCommands - 1.U,
            countCommand + 1.U,
            0.U
        )
        
        address             := Mux(
            countCommand =/= io.totalCommands - 1.U,
            address + io.length,
            startAddress
        )
    }

    // C2H Data Update
    when (io.c2hData.fire) {
        countWords           := Mux(
            countWords =/= io.totalWords - 1.U,
            countWords + 1.U,
            0.U
        )
        
        when (countWordsPerCommand =/= io.length(31, 6) - 1.U) {
            countWordsPerCommand    := countWordsPerCommand + 1.U
            io.c2hData.bits.last    := 0.U
        }.otherwise {
            countWordsPerCommand    := 0.U
            io.c2hData.bits.last    := 1.U
        }
    }

    // Module Output
    io.countCommand     := countCommand
    io.countWords       := countWords
    io.countTime        := countTime

}