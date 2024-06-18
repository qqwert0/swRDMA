package network.ip.arp
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import chisel3.experimental.{DataMirror, Direction, requireIsChiselType}
import network.ip.util._
import common.Collector
import common.BaseILA


class process_arp_pkg extends Module{
    val io = IO(new Bundle{
        val data_in          =   Flipped(Decoupled(new AXIS(512)))
        // val data_out         =   Decoupled(new AXIS(512))
        val replymeta        =   Decoupled(UInt(128.W))
        val arpinsert        =   Decoupled(UInt(81.W))
        val mymac            =   Input(UInt(48.W))
        val myip             =   Input(UInt(32.W))

	})

   	// class ila_arp_proc(seq:Seq[Data]) extends BaseILA(seq)
  	// val mod_arp_proc = Module(new ila_arp_proc(Seq(	
	// 	io.data_in,
    //     io.replymeta,
    //     io.arpinsert
  	// )))
  	// mod_arp_proc.connect(clock) 


    Collector.fire(io.data_in)
    Collector.fire(io.replymeta)
    Collector.fire(io.arpinsert)
    io.data_in.ready     := io.replymeta.ready & io.arpinsert.ready
    val last             = RegInit(UInt(1.W), 1.U)
    io.replymeta.bits    := 0.U
    io.replymeta.valid   := 0.U
    io.arpinsert.bits    := 0.U
    io.arpinsert.valid   := 0.U    
    when(io.data_in.fire){ 
        when(last === 1.U){
            // when(io.data_in.bits.data(335,304) === io.myip){
                when(io.data_in.bits.data(175,160) === 256.U){ // resquest
                    io.replymeta.bits   := Cat(Cat(io.data_in.bits.data(95, 48), io.data_in.bits.data(223,176)), io.data_in.bits.data(255, 224))
                    io.replymeta.valid  := 1.U 
                }.elsewhen(io.data_in.bits.data(175,160) === 512.U){
                    io.arpinsert.bits   := Cat(1.U, io.data_in.bits.data(223,176),io.data_in.bits.data(255, 224))
                    io.arpinsert.valid  := 1.U
                }
            // }
            last            := io.data_in.bits.last
        }
        
        when(io.data_in.bits.last === 1.U){
            last := 1.U
        }
    }
}