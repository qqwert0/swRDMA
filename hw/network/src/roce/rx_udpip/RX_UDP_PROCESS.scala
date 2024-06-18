package network.roce.rx_udpip

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class RX_UDP_PROCESS() extends Module{
	val io = IO(new Bundle{
		val rx_data_in          = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val ip_meta_in          = Flipped(Decoupled(new IP_META()))
		val udpip_meta_out	    = (Decoupled(new UDPIP_META()))
		val rx_data_out	        = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
	})

	val udp_meta_fifo = Module(new Queue(new IP_META(),16))
	val udp_data_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),16))
	io.ip_meta_in 		<> udp_meta_fifo.io.enq
	io.rx_data_in 		<> udp_data_fifo.io.enq

	val udp_header_tmp = Wire(new UDP_HEADER())
    udp_header_tmp                  := 0.U.asTypeOf(udp_header_tmp)

	val sIDLE :: sPAYLOAD :: Nil = Enum(2)
	val state                       = RegInit(sIDLE)	
	// Collector.report(state===sIDLE, "RX_UDP_PROCESS===sIDLE")
	
	udp_data_fifo.io.deq.ready             := ((state === sIDLE) & udp_meta_fifo.io.deq.valid & io.udpip_meta_out.ready & io.rx_data_out.ready) | ((state === sPAYLOAD) & io.rx_data_out.ready) 

	udp_meta_fifo.io.deq.ready             := (state === sIDLE) & udp_data_fifo.io.deq.valid & io.udpip_meta_out.ready & io.rx_data_out.ready


	io.udpip_meta_out.valid 		:= 0.U 
	io.udpip_meta_out.bits 		    := 0.U.asTypeOf(io.udpip_meta_out.bits)
	io.rx_data_out.valid 		    := 0.U 
	io.rx_data_out.bits 		    := 0.U.asTypeOf(io.rx_data_out.bits)	


	
	switch(state){
		is(sIDLE){
			when(udp_data_fifo.io.deq.fire & udp_meta_fifo.io.deq.fire){
                io.rx_data_out.valid                := 1.U
                io.rx_data_out.bits                 <> udp_data_fifo.io.deq.bits
				udp_header_tmp                      := udp_data_fifo.io.deq.bits.data(CONFIG.UDP_HEADER_LEN-1,0).asTypeOf(udp_header_tmp)
                io.udpip_meta_out.valid             := 1.U
                io.udpip_meta_out.bits.dest_ip      := udp_meta_fifo.io.deq.bits.dest_ip   
                io.udpip_meta_out.bits.dest_port    := Util.reverse(udp_header_tmp.src_prot)
                io.udpip_meta_out.bits.udp_length   := Util.reverse(udp_header_tmp.length)
 
                when(udp_data_fifo.io.deq.bits.last =/= 1.U){
                    state               := sPAYLOAD
                }

			}
		}
		is(sPAYLOAD){
            when(udp_data_fifo.io.deq.fire){
                io.rx_data_out.bits     <> udp_data_fifo.io.deq.bits
                io.rx_data_out.valid    := 1.U
                when(udp_data_fifo.io.deq.bits.last === 1.U){
                    state               := sIDLE
                }                
            }
			

		}		
	}


}