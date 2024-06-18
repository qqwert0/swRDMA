package qdma.examples

import chisel3._
import chisel3.util._
import qdma._

class H2C_AXIL() extends Module {
    val io = IO(new Bundle{
        val startAddress    = Input(UInt(64.W))
        val length          = Input(UInt(32.W))
        val sop             = Input(UInt(32.W))
        val eop             = Input(UInt(32.W))
        val start           = Input(UInt(32.W))

        val totalWords      = Input(UInt(32.W))
        val totalCommands   = Input(UInt(32.W))

        val countWords      = Output(UInt(32.W))
        val countError      = Output(UInt(32.W))
        val countTime       = Output(UInt(32.W))

        val h2cCommand      = Decoupled(new H2C_CMD)
        val h2cData         = Flipped(Decoupled(new H2C_DATA))
    })

    
    val address         = RegInit(0.U(64.W))
    val commandValid    = RegInit(false.B)
    val countTime       = RegInit(0.U(32.W))
    val countWord       = RegInit(0.U(32.W))
    val countCommand    = RegInit(0.U(32.W))
    val countError      = RegInit(0.U(32.W))
    val start           = RegNext(io.start)
    val startAddress    = RegNext(io.startAddress)

    // command
    val command         = io.h2cCommand.bits
    command             := 0.U.asTypeOf(new H2C_CMD)
    command.sop         := (io.sop === 1.U)
    command.eop         := (io.eop === 1.U)
    command.len         := io.length
    command.qid         := 0.U
    command.addr        := address
    
    io.h2cCommand.valid := commandValid

    // data
    val data            = io.h2cData.bits
    io.h2cData.ready    := true.B

    // state machine
    val sIDLE :: sSEND_CMD :: sDONE :: Nil = Enum(3)
    val h2cState        = RegInit(sIDLE)
    // state switch
    switch (h2cState) {
        is (sIDLE) {
            commandValid        := false.B
            when (start === 1.U) {
                h2cState        := sSEND_CMD
                countWord       := 0.U
                countCommand    := 0.U
                countError      := 0.U
                address         := startAddress
            }
        }

        is (sSEND_CMD) {
            commandValid    := true.B
            countTime       := countTime + 1.U
            when (start === 0.U && io.h2cCommand.fire) {
                h2cState        := sIDLE
                commandValid    := false.B
            }
        }

        is (sDONE) {
            h2cState        := sIDLE
        }
    }

    // H2C Command Update
    when (io.h2cCommand.fire) {
        countCommand    := Mux(
            countCommand =/= io.totalCommands - 1.U,
            countCommand + 1.U,
            0.U
        )
        
        address         := Mux(
            countCommand =/= io.totalCommands - 1.U,
            address + io.length,
            startAddress
        )
    }

    // H2C Data Verification
    when(io.h2cData.fire) {
        countWord       := Mux(
            countWord =/= io.totalWords - 1.U,
            countWord + 1.U,
            0.U
        )

        countError      := Mux(
            countWord =/= data.data(31,0),
            countError + 1.U,
            countError
        )
    }

    // Module Output
    io.countTime    := countTime
    io.countError   := countError
    io.countWords   := countWord
}