package network.ip.arp
import common.Math
import common.ToZero
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import chisel3.experimental.{DataMirror, Direction, requireIsChiselType}
import network.ip.util._

class arp_table extends Module{
    val io = IO(new Bundle{
        val arpinsert        =   Flipped(Decoupled(UInt(81.W)))
        val arp_req1         =   Flipped(Decoupled(UInt(32.W)))
        val arp_req2         =   Flipped(Decoupled(UInt(32.W)))
        val arp_rsp1         =   Decoupled(new mac_out)
        val arp_rsp2         =   Decoupled(new mac_out)
        val requestmeta      =   Decoupled(UInt(32.W))
        val mymac            =   Input(UInt(48.W))
        val myip             =   Input(UInt(32.W))
	})
    
    val rsp_fifo1           = XQueue(new mac_out(), entries=16)
    val rsp_fifo2           = XQueue(new mac_out(), entries=16)
    val requestmeta_fifo    = XQueue(UInt(32.W), entries=16)

    rsp_fifo1.io.out        <> io.arp_rsp1
    rsp_fifo2.io.out        <> io.arp_rsp2
    requestmeta_fifo.io.out <> io.requestmeta
    
    val arp_table           =   XRam(UInt(81.W), 256, latency=1)
    val currRntryb          =   Wire(UInt(81.W))
    currRntryb              :=  arp_table.io.data_out_b

    val temp                = RegInit(UInt(32.W), 0.U)
    io.arpinsert.ready      := 1.U
    io.arp_req1.ready       := !io.arpinsert.valid.asBool() & (!rsp_fifo1.io.almostfull) & (!requestmeta_fifo.io.almostfull)
    io.arp_req2.ready       := !io.arpinsert.valid.asBool() & !io.arp_req1.valid.asBool() & (!rsp_fifo2.io.almostfull) & (!requestmeta_fifo.io.almostfull)

    ToZero(rsp_fifo1.io.in.valid)
    ToZero(rsp_fifo1.io.in.bits)
    ToZero(rsp_fifo2.io.in.valid)
    ToZero(rsp_fifo2.io.in.bits)
    ToZero(requestmeta_fifo.io.in.valid)
    ToZero(requestmeta_fifo.io.in.bits)
    ToZero(arp_table.io.wr_en_a)
    ToZero(arp_table.io.addr_a)
    ToZero(arp_table.io.addr_b)
    ToZero(arp_table.io.data_in_a)

	val sIDLE :: sARP1 :: sARP2 :: Nil = Enum(3)
	val state                   = RegInit(sIDLE)
    when(io.arpinsert.fire){
        arp_table.io.data_in_a  := io.arpinsert.bits
        arp_table.io.wr_en_a    := 1.U
        arp_table.io.addr_a     := io.arpinsert.bits(31,24)
        state                   := sIDLE
    }.elsewhen(io.arp_req1.fire){
        arp_table.io.addr_b     := io.arp_req1.bits(31,24)
        state                   := sARP1
        temp                    := io.arp_req1.bits(31,0)
    }.elsewhen(io.arp_req2.fire){
        arp_table.io.addr_b     := io.arp_req2.bits(31,24)
        state                   := sARP2
        temp                    := io.arp_req2.bits(31,0)
    }.otherwise{
        state                   := sIDLE
    }



    when(state === sARP1){
        rsp_fifo1.io.in.valid           := 1.U
        rsp_fifo1.io.in.bits.mac_addr   := currRntryb(79,32)
        rsp_fifo1.io.in.bits.hit        := currRntryb(80) && (currRntryb(31,0) === temp) 
        when(!(currRntryb(80) && (currRntryb(31,0) === temp))){
            requestmeta_fifo.io.in.valid    := 1.U
            requestmeta_fifo.io.in.bits     := temp            
        }
    }.elsewhen(state === sARP2){
        rsp_fifo2.io.in.valid           := 1.U
        rsp_fifo2.io.in.bits.mac_addr   := currRntryb(79,32)
        rsp_fifo2.io.in.bits.hit        := currRntryb(80) && (currRntryb(31,0) === temp)
        when(!(currRntryb(80) && (currRntryb(31,0) === temp))){
            requestmeta_fifo.io.in.valid    := 1.U
            requestmeta_fifo.io.in.bits     := temp            
        }        
    }
}