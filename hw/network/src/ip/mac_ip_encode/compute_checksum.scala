// package ip
package network.ip.mac_ip_encode
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import common._
import network.ip.util._

class compute_checksum1 extends Module{
    val io = IO(new Bundle{
        val data_in           =   Flipped(Decoupled(new AXIS(512)))
        val data_out          =   Decoupled(new AXIS(512))
        val checksum          =   Decoupled(UInt(16.W))
        val len               =   Output(UInt(16.W))
	})
    val checknum		= WireInit(VecInit(Seq.fill(32)(0.U(17.W))))
    
    val last            = RegInit(UInt(1.W), 1.U)
    val temp            = Wire(UInt(16.W))
    val cics_iplen      = Wire(UInt(4.W))
    val temp6           = Wire(UInt(17.W))
    val temp7           = RegInit(UInt(17.W), 0.U)
    var abc             = UInt
    temp                := 0.U
    cics_iplen          := 0.U
    temp6               := temp7

    io.data_in.ready    := io.data_out.ready

    ToZero(io.data_out.valid)
    ToZero(io.data_out.bits)

    ToZero(io.checksum.valid)
    ToZero(io.checksum.bits)

    when(io.data_in.fire){
        io.data_out.valid   := 1.U 
        io.data_out.bits    := io.data_in.bits
        when(last === 1.U){
            last            := 0.U
            cics_iplen      := io.data_in.bits.data(3,0)
            for(i <- 0 until 32){
                temp            := Reverse(io.data_in.bits.data(16*i+15, i*16))
                when(i.U =/= 5.U){
                    when((i/2).U < cics_iplen){
                        checknum(i) := ((temp + (temp>>16)) & 0xFFFF.U)
                    }
                }
            }
            val temp1 = WireInit(VecInit(Seq.fill(16)(0.U(17.W))))
            val temp2 = WireInit(VecInit(Seq.fill(8)(0.U(17.W))))
            val temp3 = WireInit(VecInit(Seq.fill(4)(0.U(17.W))))
            val temp4 = WireInit(VecInit(Seq.fill(2)(0.U(17.W))))
            val temp5 = WireInit(UInt(17.W), 0.U)
            for(i <- 0 until 16){
                temp1(i) := ((checknum(i) + checknum(i+16)) + ((checknum(i) + checknum(i+16))>>16)) & 0xFFFF.U
            }
            for(i <- 0 until 8){
                temp2(i) := ((temp1(i) + temp1(i+8)) + ((temp1(i) + temp1(i+8))>>16)) & 0xFFFF.U
            }
            for(i <- 0 until 4){
                temp3(i) := ((temp2(i) + temp2(i+4)) + ((temp2(i) + temp2(i+4))>>16)) & 0xFFFF.U
            }
            for(i <- 0 until 2){
                temp4(i) := ((temp3(i) + temp3(i+2)) + ((temp3(i) + temp3(i+2))>>16)) & 0xFFFF.U
            }
            temp5 := ((temp4(0) + temp4(1)) + ((temp4(0) + temp4(1))>>16)) & 0xFFFF.U
            temp6 := ~temp5
            temp7 := ~temp5
            io.checksum.valid   := 1.U 
            io.checksum.bits    := 0.U //temp6(15,0)
        }
        when(io.data_in.bits.last === 1.U){
            last            := 1.U
            for(i <- 0 until 32){
                checknum(i) := 0.U
            }
        }
    }
    io.len      := cics_iplen
}