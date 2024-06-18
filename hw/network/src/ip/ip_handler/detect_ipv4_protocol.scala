// package ip
package network.ip.ip_handler
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import common.ToZero
import network.ip.util._


class detect_ipv4_protocol extends Module{
    val io = IO(new Bundle{
        val data_in          =   Flipped(Decoupled(new AXIS(512)))
        val type1            =   Input(UInt(8.W))
        val icmp_out         =   Decoupled(new AXIS(512))
        val udp_out         =   Decoupled(new AXIS(512))
        val tcp_out         =   Decoupled(new AXIS(512))
        val roce_out         =   Decoupled(new AXIS(512))
	})
    // val last           = RegInit(UInt(1.W),1.U)
    // val type1           = RegInit(UInt(8.W),0.U)
    io.data_in.ready    := io.icmp_out.ready && io.udp_out.ready && io.tcp_out.ready 
    io.icmp_out.valid   := 0.U
    io.udp_out.valid    := 0.U
    io.tcp_out.valid    := 0.U
    io.roce_out.valid   := 0.U
    io.icmp_out.bits.data   := 0.U
    io.icmp_out.bits.keep   := 0.U
    io.icmp_out.bits.last   := 0.U
    io.udp_out.bits.data    := 0.U
    io.udp_out.bits.keep   := 0.U
    io.udp_out.bits.last   := 0.U
    io.tcp_out.bits.data   := 0.U
    io.tcp_out.bits.keep   := 0.U
    io.tcp_out.bits.last   := 0.U
    io.roce_out.bits.data   := 0.U
    io.roce_out.bits.keep   := 0.U
    io.roce_out.bits.last   := 0.U
    when(io.data_in.fire){
        // when(last === 1.U){
        //     type1           := io.data_in.bits.data(79,72)
        //     last            := 0.U
        //     when(io.data_in.bits.data(79,72) === 0x01.U){
        //         io.icmp_out.bits := io.data_in.bits
        //         io.icmp_out.valid:= 1.U
        //     }.elsewhen(io.data_in.bits.data(79,72) === 0x11.U){
        //         io.udp_out.bits := io.data_in.bits
        //         io.roce_out.bits:= io.data_in.bits
        //         io.udp_out.valid    := 1.U
        //         io.roce_out.valid   := 1.U
        //     }.elsewhen(io.data_in.bits.data(79,72) === 0x06.U){
        //         io.tcp_out.bits :=  io.data_in.bits
        //         io.tcp_out.valid    := 1.U
        //     }
        // }
        when(io.type1 === 0x01.U){
            io.icmp_out.bits := io.data_in.bits
            io.icmp_out.valid:= 1.U
        }.elsewhen(io.type1 === 0x11.U){
            io.udp_out.bits := io.data_in.bits
            io.roce_out.bits:= io.data_in.bits
            io.udp_out.valid    := 1.U
            io.roce_out.valid   := 1.U
        }.elsewhen(io.type1 === 0x06.U){
            io.tcp_out.bits :=  io.data_in.bits
            io.tcp_out.valid    := 1.U
        }
        // when(io.data_in.bits.last === 1.U){
        //     last := 1.U
        // }
    }
}