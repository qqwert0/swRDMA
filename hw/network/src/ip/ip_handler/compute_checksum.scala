// package ip
package network.ip.ip_handler
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import common._
import network.ip.util._

class compute_checksum extends Module{
    val io = IO(new Bundle{
        val data_in           =   Flipped(Decoupled(new AXIS(512)))
        val data_out          =   Decoupled(new AXIS(512))
        val checksumvalid     =   Output(UInt(1.W))
	})
    io.data_in          <> io.data_out
    // val checknum		= WireInit(VecInit(Seq.fill(32)(0.U(18.W))))
    io.checksumvalid    := 1.U//checknum(1)
    // val aaa             = Module(new LSHIFT(14, 512))
    // aaa.io.in.valid   := io.data_in.valid
    // aaa.io.out.ready  := io.data_out.ready
    // aaa.io.in.bits    := io.data_in.bits
    // io.data_out.bits    := aaa.io.out.bits
    // io.data_out.valid   := aaa.io.out.valid
    // val last            = RegInit(UInt(1.W), 1.U)
    // val temp            = Wire(UInt(16.W))
    // val cics_iplen      = Wire(UInt(4.W))
    // var abc             = UInt
    // temp                := 0.U
    // cics_iplen          := 0.U
    

    // when(io.data_in.fire){
    //     when(last === 1.U){
            
    //         last            := 0.U
    //         cics_iplen      := io.data_in.bits.data(3,0)
    //         for(i <- 0 until 32){
    //             temp            := Reverse(io.data_in.bits.data(16*i+15, i*16))
    //             when(i.U =/= 5.U){
    //                 when((i/2).U < cics_iplen){
    //                     checknum(i) := temp + (temp>>16)
    //                 }
    //             }

                
    //         }
            
    //         // checknum(1)     := 1.U

    //     }
    //     when(io.data_out.bits.last === 1.U){
    //         last            := 1.U
    //         for(i <- 0 until 32){
    //             checknum(i) := 0.U
    //         }
    //     }
    // }
    
}