// package ip
package network.ip.mac_ip_encode
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import common._
import network.ip.util._

class handle_arp_reply extends Module{
    val io = IO(new Bundle{
        val data_in          =   Flipped(Decoupled(new AXIS(512)))
        val arptablein       =   Flipped(Decoupled(new mac_out))
        val mymac            =   Input(UInt(48.W))
        val data_out         =   Decoupled(new AXIS(512))
        val ethheaderout     =   Decoupled(UInt(112.W))
	})

    val last        = RegInit(UInt(1.W), 1.U)
    val hit         = RegInit(UInt(1.W), 1.U)
    val temp        = RegInit(UInt(16.W), 0x0008.U)

    val data_fifo = XQueue(new AXIS(512),16)
    val arp_fifo = XQueue(new mac_out,16)

    io.data_in          <> data_fifo.io.in
    io.arptablein       <> arp_fifo.io.in


    // d 47:0 s 95:48 t 111,96
	val sIDLE :: sPAYLOAD :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)	

    data_fifo.io.out.ready      := (((state === sIDLE) & arp_fifo.io.out.valid & io.ethheaderout.ready) || (state === sPAYLOAD)) & io.data_out.ready
    arp_fifo.io.out.ready       := (state === sIDLE) & data_fifo.io.out.valid & io.data_out.ready & io.ethheaderout.ready

    ToZero(io.data_out.valid)
    ToZero(io.data_out.bits)

    ToZero(io.ethheaderout.valid)
    ToZero(io.ethheaderout.bits)

	switch(state){
		is(sIDLE){
			when(data_fifo.io.out.fire & arp_fifo.io.out.fire){
                hit                             := arp_fifo.io.out.bits.hit
                io.ethheaderout.bits            := Cat(Cat(temp, io.mymac),arp_fifo.io.out.bits.mac_addr)
                io.data_out.bits                <> data_fifo.io.out.bits
                when(arp_fifo.io.out.bits.hit === 1.U){
                    io.ethheaderout.valid       := 1.U
                    io.data_out.valid           := 1.U
                }.otherwise{
                    io.ethheaderout.valid       := 0.U
                    io.data_out.valid           := 0.U
                }


                when(data_fifo.io.out.bits.last =/= 1.U){
                    state               := sPAYLOAD
                }.otherwise{
                    state               := sIDLE
                }

			}
		}
		is(sPAYLOAD){
            when(data_fifo.io.out.fire){
                io.data_out.bits                <> data_fifo.io.out.bits
                when(hit === 1.U){
                    io.data_out.valid           := 1.U
                }.otherwise{
                    io.data_out.valid           := 0.U
                }

                when(data_fifo.io.out.bits.last === 1.U){
                    state               := sIDLE
                }                
            }
		}		
	}

    
}