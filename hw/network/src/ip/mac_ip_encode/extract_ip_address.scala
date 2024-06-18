// package ip
package network.ip.mac_ip_encode
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import network.ip.util._

class ex_ipaddress extends Module{
    val io = IO(new Bundle{
        val data_in          =   Flipped(Decoupled(new AXIS(512)))
        val regsubnetmask    =   Input(UInt(32.W))
        val regdefaultgateway=   Input(UInt(32.W))
        val arptableout      =   Decoupled(UInt(32.W))
        val data_out         =   Decoupled(new AXIS(512))
	})

    val last        = RegInit(UInt(1.W), 1.U)
    val arp_out     = RegInit(UInt(32.W), 0.U)
    io.data_in.ready := io.data_out.ready && io.arptableout.ready
    io.data_out.bits := io.data_in.bits
    io.data_out.valid:= io.data_in.valid
    io.arptableout.valid:= 0.U//io.data_in.valid

    io.arptableout.bits:= arp_out
    when(io.data_in.fire){
        when(last === 1.U){
            when((io.data_in.bits.data(159,128) & io.regsubnetmask) === (io.regdefaultgateway & io.regsubnetmask)){
                io.arptableout.bits := io.data_in.bits.data(159,128)
                arp_out             := io.data_in.bits.data(159,128)
                io.arptableout.valid:= 1.U
            }.otherwise{
                io.arptableout.bits := io.regdefaultgateway
                arp_out             := io.regdefaultgateway
                io.arptableout.valid:= 1.U
            }
            last            := 0.U
        }
        
        when(io.data_in.bits.last === 1.U){
            last := 1.U
        }
    }
    

    
}