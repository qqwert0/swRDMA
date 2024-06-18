// package ip
package network.ip.ip_handler
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import network.ip.util._


class extract_ip_meta extends Module{
    val io = IO(new Bundle{
        val data_in           =   Flipped(Decoupled(new AXIS(512)))
        val myip              =   Input(UInt(32.W))
        val data_out          =   Decoupled(new AXIS(512))
        val ipv4Type          =   Output(UInt(8.W))
        val validipaddr       =   Output(UInt(1.W))
        
	})
    io.data_in.ready    := io.data_out.ready
    io.data_out.valid   := io.data_in.valid
    io.data_out.bits    := io.data_in.bits
    val last    = RegInit(UInt(1.W), 1.U)
    val type1   = RegInit(UInt(8.W), 0.U)
    val addvalid= RegInit(UInt(1.W), 0.U) 
    val myip_tmp= Wire(UInt(32.W))
    myip_tmp        := io.data_in.bits.data(159,128)
    io.ipv4Type     := type1
    io.validipaddr  := addvalid
    when(io.data_in.fire){
        when(last === 1.U){
            last            := 0.U
            type1           := io.data_in.bits.data(79,72)
            io.ipv4Type     := io.data_in.bits.data(79,72)
            when(((myip_tmp === io.myip) )){//| (myip_tmp === Cat(0xFFFF.U,0xFFFF.U)
                addvalid        := 1.U
                io.validipaddr  := 1.U
            }.otherwise{
                addvalid        := 0.U
                io.validipaddr  := 0.U
            }
        }
        when(io.data_out.bits.last === 1.U){
            last            := 1.U
            type1           := 0.U
        }
        
    }
    
}