package network.roce.tx_udpip

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector


class TX_ADD_UDP() extends Module{
	val io = IO(new Bundle{
		val udpip_meta_in   = Flipped(Decoupled(new UDPIP_META()))
		val tx_data_in	    = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val dir_wq_req  	= (Decoupled(new CMPT_META()))
        val ip_meta_out	    = (Decoupled(new IP_META()))
        val tx_data_out	    = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
	})


	val udp_meta_fifo = Module(new Queue(new UDPIP_META(),16))
	val udp_data_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),16))
	io.udpip_meta_in 	<> udp_meta_fifo.io.enq
	io.tx_data_in 	    <> udp_data_fifo.io.enq

    val udp_head = Wire(new UDP_HEADER())
    udp_head       := 0.U.asTypeOf(udp_head)


	val sIDLE :: sPAYLOAD :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)	
	// Collector.report(state===sIDLE, "TX_ADD_UDP===sIDLE")
	

	udp_meta_fifo.io.deq.ready      := (state === sIDLE) & io.tx_data_out.ready & io.ip_meta_out.ready & udp_data_fifo.io.deq.valid
    udp_data_fifo.io.deq.ready      := ((state === sIDLE) & io.tx_data_out.ready & io.ip_meta_out.ready & udp_meta_fifo.io.deq.valid) | ((state === sPAYLOAD) & io.tx_data_out.ready)

	io.dir_wq_req.valid				:= 0.U
	io.dir_wq_req.bits				:= 0.U.asTypeOf(io.dir_wq_req.bits)
	io.ip_meta_out.valid 		    := 0.U 
	io.ip_meta_out.bits 		    := 0.U.asTypeOf(io.ip_meta_out.bits)
	io.tx_data_out.valid 			:= 0.U 
	io.tx_data_out.bits 		    := 0.U.asTypeOf(io.tx_data_out.bits)


	
	switch(state){
		is(sIDLE){
			when(udp_meta_fifo.io.deq.fire & udp_data_fifo.io.deq.fire){
                udp_head.src_prot               := Util.reverse(CONFIG.RDMA_DEFAULT_PORT.U)
                udp_head.des_prot               := Util.reverse(udp_meta_fifo.io.deq.bits.dest_port)
                udp_head.length                 := Util.reverse(udp_meta_fifo.io.deq.bits.udp_length)
				when((udp_meta_fifo.io.deq.bits.op_code === IB_OP_CODE.RC_WRITE_LAST)||(udp_meta_fifo.io.deq.bits.op_code === IB_OP_CODE.RC_WRITE_ONLY)){
					io.dir_wq_req.valid			:= 1.U
					io.dir_wq_req.bits.cmpt_meta_generate(udp_meta_fifo.io.deq.bits.qpn,0.U,1.U)
				}.elsewhen((udp_meta_fifo.io.deq.bits.op_code === IB_OP_CODE.RC_DIRECT_LAST)||(udp_meta_fifo.io.deq.bits.op_code === IB_OP_CODE.RC_DIRECT_ONLY)){
					io.dir_wq_req.valid			:= 1.U
					io.dir_wq_req.bits.cmpt_meta_generate(udp_meta_fifo.io.deq.bits.qpn,0.U,2.U)
				}				
                io.ip_meta_out.valid            := 1.U
                io.ip_meta_out.bits.dest_ip     := udp_meta_fifo.io.deq.bits.dest_ip
                io.ip_meta_out.bits.length      := udp_meta_fifo.io.deq.bits.udp_length
                io.tx_data_out.valid            := 1.U
                io.tx_data_out.bits.data        := Cat(udp_data_fifo.io.deq.bits.data(CONFIG.DATA_WIDTH-1,CONFIG.UDP_HEADER_LEN),udp_head.asUInt)
                io.tx_data_out.bits.last        := udp_data_fifo.io.deq.bits.last
				io.tx_data_out.bits.keep        := udp_data_fifo.io.deq.bits.keep
				when(udp_data_fifo.io.deq.bits.last === 1.U){
                    state                       := sIDLE
                }.otherwise{
                    state                       := sPAYLOAD
                }
			}
		}
		is(sPAYLOAD){
			when(udp_data_fifo.io.deq.fire){
                io.tx_data_out.valid            := 1.U
                io.tx_data_out.bits             <> udp_data_fifo.io.deq.bits
				when(udp_data_fifo.io.deq.bits.last === 1.U){
                    state                       := sIDLE
                }
			}
		}
	}

}