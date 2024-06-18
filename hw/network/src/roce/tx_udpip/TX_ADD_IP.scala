package network.roce.tx_udpip

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector




class TX_ADD_IP() extends Module{
	val io = IO(new Bundle{
		val ip_meta_in  	= Flipped(Decoupled(new IP_META()))
		val tx_data_in	    = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val tx_data_out	    = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val local_ip_address= Input(UInt(32.W))
	})


	val ip_meta_fifo = Module(new Queue(new IP_META(),16))
	val ip_data_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),16))
	io.ip_meta_in 		<> ip_meta_fifo.io.enq
	io.tx_data_in 	    <> ip_data_fifo.io.enq

    val ip_head = Wire(new IP_HEADER())
    ip_head       				:= 0.U.asTypeOf(ip_head)


	val sIDLE :: sPAYLOAD :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)	
	// Collector.report(state===sIDLE, "TX_ADD_IP===sIDLE")
	

	ip_meta_fifo.io.deq.ready      := (state === sIDLE) & io.tx_data_out.ready & ip_data_fifo.io.deq.valid
    ip_data_fifo.io.deq.ready      := ((state === sIDLE) & io.tx_data_out.ready & ip_meta_fifo.io.deq.valid) | ((state === sPAYLOAD) & io.tx_data_out.ready)


	io.tx_data_out.valid 			:= 0.U 
	io.tx_data_out.bits 		    := 0.U.asTypeOf(io.tx_data_out.bits)


	
	switch(state){
		is(sIDLE){
			when(ip_meta_fifo.io.deq.fire & ip_data_fifo.io.deq.fire){
                ip_head.version_IHL            	:= "h45".U
				ip_head.length            		:= Util.reverse(ip_meta_fifo.io.deq.bits.length + 20.U)
				ip_head.ttl            			:= "h40".U
				ip_head.protocol            	:= CONFIG.UDP_PROTOCOL.U
				ip_head.src_ipaddr            	:= io.local_ip_address
				ip_head.dst_ipaddr            	:= ip_meta_fifo.io.deq.bits.dest_ip

				io.tx_data_out.valid            := 1.U
                io.tx_data_out.bits.data        := Cat(ip_data_fifo.io.deq.bits.data(CONFIG.DATA_WIDTH-1,CONFIG.IP_HEADER_LEN),ip_head.asUInt)
                io.tx_data_out.bits.last        := ip_data_fifo.io.deq.bits.last
				io.tx_data_out.bits.keep        := ip_data_fifo.io.deq.bits.keep
				when(ip_data_fifo.io.deq.bits.last === 1.U){
                    state                       := sIDLE
                }.otherwise{
                    state                       := sPAYLOAD
                }
			}
		}
		is(sPAYLOAD){
			when(ip_data_fifo.io.deq.fire){
                io.tx_data_out.valid            := 1.U
                io.tx_data_out.bits             <> ip_data_fifo.io.deq.bits
				when(ip_data_fifo.io.deq.bits.last === 1.U){
                    state                       := sIDLE
                }
			}
		}
	}

}