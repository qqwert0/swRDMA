// package ip
package network.ip.mac_ip_encode
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import common._
import network.ip.util._

class insert_eth_header extends Module{
    val io = IO(new Bundle{
        val data_in          =   Flipped(Decoupled(new AXIS(512)))
        val header_in        =   Flipped(Decoupled(UInt(112.W)))
        val data_out         =   Decoupled(new AXIS(512))
	})

    val last        = RegInit(UInt(1.W), 1.U)

    val data_fifo = XQueue(new AXIS(512),16)
    val head_fifo = XQueue(UInt(112.W),16)

    io.data_in              <> data_fifo.io.in
    io.header_in            <> head_fifo.io.in

	val sIDLE :: sPAYLOAD :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)

    data_fifo.io.out.ready        := (((state === sIDLE) & head_fifo.io.out.valid) || (state === sPAYLOAD)) & io.data_out.ready
    head_fifo.io.out.ready      := (state === sIDLE) & data_fifo.io.out.valid & io.data_out.ready

    ToZero(io.data_out.valid)
    ToZero(io.data_out.bits)


	switch(state){
		is(sIDLE){
			when(data_fifo.io.out.fire & head_fifo.io.out.fire){
                io.data_out.valid           := 1.U
                io.data_out.bits            <> data_fifo.io.out.bits
                io.data_out.bits.data       := Cat(data_fifo.io.out.bits.data(511,112),head_fifo.io.out.bits)

                when(data_fifo.io.out.bits.last =/= 1.U){
                    state               := sPAYLOAD
                }

			}
		}
		is(sPAYLOAD){
            when(data_fifo.io.out.fire){
                io.data_out.bits        <> data_fifo.io.out.bits
                io.data_out.valid       := 1.U
                when(data_fifo.io.out.bits.last === 1.U){
                    state               := sIDLE
                }                
            }
		}		
	}

    
}