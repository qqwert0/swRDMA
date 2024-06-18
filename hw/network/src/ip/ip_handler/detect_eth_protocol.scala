// package ip
package network.ip.ip_handler
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import network.ip.util._


class detect_eth_protocol extends Module{
    val io = IO(new Bundle{
        val data_in          =   Flipped(Decoupled(new AXIS(512)))
        val data_out         =   Decoupled(new AXIS(512))
        val eth_protocol     =   Output(UInt(16.W))
	})
    val last           = RegInit(UInt(1.W),1.U)
    io.data_out.bits    := io.data_in.bits
    io.data_out.valid   := io.data_in.valid
    io.data_in.ready    := io.data_out.ready

    io.eth_protocol     := 0.U
    when(io.data_in.fire){
        when(last === 1.U){
            io.eth_protocol := io.data_in.bits.data(111,96)
            last            := 0.U
        }
        
        when(io.data_in.bits.last === 1.U){
            last := 1.U
        }
    }
}