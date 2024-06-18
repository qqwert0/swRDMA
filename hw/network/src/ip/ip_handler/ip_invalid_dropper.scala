// package ip
package network.ip.ip_handler
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import network.ip.util._


class ip_invalid_dropper extends Module{
    val io = IO(new Bundle{
        val data_in           =   Flipped(Decoupled(new AXIS(512)))
        val validchecksum     =   Input(UInt(1.W))
        val validipaddress    =   Input(UInt(1.W))
        val data_out          =   Decoupled(new AXIS(512))
        val valid_out         =   Output(UInt(1.W))
	})
    val state			= RegInit(UInt(2.W),0.U)
    val valid_out       = RegInit(UInt(1.W),0.U)
    io.data_in.ready         :=  io.data_out.ready
    // io.data_out.valid        := io.data_in.valid
    io.data_out.bits         := io.data_in.bits
    io.valid_out             := valid_out
    io.data_out.valid        := 0.U
    
    switch(state){
        is(0.U){
            when(io.data_in.fire){
                when(io.validchecksum === 1.U && io.validipaddress === 1.U){
                    io.valid_out        := 1.U
                    valid_out           := 1.U
                    state               := 1.U
                    io.data_out.valid   := 1.U
                }.otherwise{
                    io.valid_out        := 0.U
                    valid_out           := 0.U
                    state               := 1.U
                    io.data_out.valid   := 0.U
                }   
            }.otherwise{
                io.data_out.valid        := 0.U
            }
        }
        is(1.U){
            when(io.data_in.fire){
                when(io.data_in.bits.last === 1.U){
                    state               := 0.U
                    valid_out           := 0.U
                    io.data_out.valid   := valid_out
                    // io.valid_out        := 0.U
                    // io.data_out.valid   := 0.U
                }.otherwise{
                    io.data_out.valid        := valid_out
                }                
            }.otherwise{
                io.data_out.valid        := 0.U
            }
        }
    }
    
}