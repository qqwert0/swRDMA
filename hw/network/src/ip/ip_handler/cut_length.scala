// package ip
package network.ip.ip_handler
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import network.ip.util._


class cut_length extends Module{
    val io = IO(new Bundle{
        val data_in           =   Flipped(Decoupled(new AXIS(512)))
        val data_out          =   Decoupled(new AXIS(512))
	})
    io.data_in.ready         := io.data_out.ready
    io.data_out.valid        := io.data_in.valid
    io.data_out.bits.data    := io.data_in.bits.data
    io.data_out.bits.keep    := io.data_in.bits.keep
    io.data_out.bits.last    := io.data_in.bits.last
    val state			= RegInit(UInt(1.W),0.U)

    val totallength     = RegInit(UInt(16.W),0.U)
    switch(state){
        is(0.U){
            when(io.data_in.fire){
                when(io.data_in.bits.last === 1.U){
                    val aaa = Module(new change)
                    aaa.io.data_in := io.data_in.bits.data(21,16)
                    io.data_out.bits.keep := aaa.io.data_out 
                    state := 0.U                   
                }.otherwise{
                    state := 1.U
                }
            }.otherwise{
                state := 0.U
            }
        }
        is(1.U){
            when(io.data_in.bits.last === 1.U& io.data_in.fire){
                state := 0.U
            }
        }
    }
    
}

class change extends Module{
    val io = IO(new Bundle{
        val data_in           =   Input(UInt(6.W))
        val data_out          =   Output(UInt(64.W))
	})
    // io.data_out := 0.U
    when(io.data_in === 0.U){
        io.data_out := 0x00.U
    }.elsewhen(io.data_in === 1.U){
        io.data_out := 0x01.U
    }.elsewhen(io.data_in === 2.U){
        io.data_out := 0x03.U
    }.elsewhen(io.data_in === 3.U){
        io.data_out := 0x07.U
    }.elsewhen(io.data_in === 4.U){
        io.data_out := 0x0F.U
    }.elsewhen(io.data_in === 5.U){
        io.data_out := 0x1F.U
    }.elsewhen(io.data_in === 6.U){
        io.data_out := 0x3F.U
    }.elsewhen(io.data_in === 7.U){
        io.data_out := 0x7F.U
    }.elsewhen(io.data_in === 8.U){
        io.data_out := 0xFF.U
    }.elsewhen(io.data_in === 9.U){
        io.data_out := 0x1FF.U
    }.elsewhen(io.data_in === 10.U){
        io.data_out := 0x03FF.U
    }.elsewhen(io.data_in === 11.U){
        io.data_out := 0x07FF.U
    }.elsewhen(io.data_in === 12.U){
        io.data_out := 0x0FFF.U
    }.elsewhen(io.data_in === 13.U){
        io.data_out := 0x1FFF.U
    }.elsewhen(io.data_in === 14.U){
        io.data_out := 0x3FFF.U
    }.elsewhen(io.data_in === 15.U){
        io.data_out := 0x7FFF.U
    }.elsewhen(io.data_in === 16.U){
        io.data_out := 0xFFFF.U
    }.elsewhen(io.data_in === 17.U){
        io.data_out := 0x01FFFF.U
    }.elsewhen(io.data_in === 18.U){
        io.data_out := 0x03FFFF.U
    }.elsewhen(io.data_in === 19.U){
        io.data_out := 0x07FFFF.U
    }.elsewhen(io.data_in === 20.U){
        io.data_out := 0x0FFFFF.U
    }.elsewhen(io.data_in === 21.U){
        io.data_out := 0x1FFFFF.U
    }.elsewhen(io.data_in === 22.U){
        io.data_out := 0x3FFFFF.U
    }.elsewhen(io.data_in === 23.U){
        io.data_out := 0x7FFFFF.U
    }.elsewhen(io.data_in === 24.U){
        io.data_out := 0xFFFFFF.U
    }.elsewhen(io.data_in === 25.U){
        io.data_out := 0x01FFFFFF.U
    }.elsewhen(io.data_in === 26.U){
        io.data_out := 0x03FFFFFF.U
    }.elsewhen(io.data_in === 27.U){
        io.data_out := 0x07FFFFFF.U
    }.elsewhen(io.data_in === 28.U){
        io.data_out := 0x0FFFFFFF.U
    }.elsewhen(io.data_in === 29.U){
        io.data_out := 0x1FFFFFFF.U
    }.elsewhen(io.data_in === 30.U){
        io.data_out := 0x3FFFFFFF.U
    }.elsewhen(io.data_in === 31.U){
        io.data_out := 0x7FFFFFFF.U
    }.elsewhen(io.data_in === 32.U){
        io.data_out := Cat(0xFFFF.U,0xFFFF.U)
    }.otherwise{
        io.data_out:=0.U
    }
}