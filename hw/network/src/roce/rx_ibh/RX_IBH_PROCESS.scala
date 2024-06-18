package network.roce.rx_ibh

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector



class RX_IBH_PROCESS() extends Module{
	val io = IO(new Bundle{
		val rx_ibh_data_in      = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val udpip_meta_in       = Flipped(Decoupled(new UDPIP_META()))
		val ibh_meta_out	    = (Decoupled(new IBH_META()))
		val rx_ibh_data_out	    = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
	})

	val ibh_meta_fifo = Module(new Queue(new UDPIP_META(),16))
	val ibh_data_fifo = Module(new Queue(new AXIS(CONFIG.DATA_WIDTH),16))
	io.udpip_meta_in 		<> ibh_meta_fifo.io.enq
	io.rx_ibh_data_in 		<> ibh_data_fifo.io.enq

	val ibh_header_tmp = Wire(new IBH_HEADER())
    ibh_header_tmp                  := 0.U.asTypeOf(ibh_header_tmp)

	val event_index = WireInit(0.U(15.W))


	val sIDLE :: sPAYLOAD :: Nil = Enum(2)
	val state                       = RegInit(sIDLE)	
	Collector.report(state===sIDLE, "RX_IBH_PROCESS===sIDLE")
	
	ibh_data_fifo.io.deq.ready         := ((state === sIDLE) & ibh_meta_fifo.io.deq.valid & io.ibh_meta_out.ready & io.rx_ibh_data_out.ready) | ((state === sPAYLOAD) & io.rx_ibh_data_out.ready) 

	ibh_meta_fifo.io.deq.ready          := (state === sIDLE) & ibh_data_fifo.io.deq.valid & io.ibh_meta_out.ready & io.rx_ibh_data_out.ready


	io.ibh_meta_out.valid 			:= 0.U 
	io.ibh_meta_out.bits 		    := 0.U.asTypeOf(io.ibh_meta_out.bits)
	io.rx_ibh_data_out.valid 		:= 0.U 
	io.rx_ibh_data_out.bits 		:= 0.U.asTypeOf(io.rx_ibh_data_out.bits)	


	
	switch(state){
		is(sIDLE){
			when(ibh_data_fifo.io.deq.fire & ibh_meta_fifo.io.deq.fire){
                io.rx_ibh_data_out.valid:= 1.U
                io.rx_ibh_data_out.bits <> ibh_data_fifo.io.deq.bits
				ibh_header_tmp          := ibh_data_fifo.io.deq.bits.data(CONFIG.IBH_HEADER_LEN-1,0).asTypeOf(ibh_header_tmp)
				event_index				:= Cat(ibh_header_tmp.index_msb,ibh_header_tmp.index_lsb)
                io.ibh_meta_out.valid   := 1.U    
                io.ibh_meta_out.bits.ibh_gene(IB_OP_CODE.safe(ibh_header_tmp.op_code)._1, Util.reverse(ibh_header_tmp.qpn), Util.reverse(ibh_header_tmp.psn), ibh_header_tmp.ack.asBool, ibh_meta_fifo.io.deq.bits.udp_length) 
                when(ibh_data_fifo.io.deq.bits.last =/= 1.U){
                    state               := sPAYLOAD
                }

			}
		}
		is(sPAYLOAD){
            when(ibh_data_fifo.io.deq.fire){
                io.rx_ibh_data_out.bits     <> ibh_data_fifo.io.deq.bits
                io.rx_ibh_data_out.valid    := 1.U
                when(ibh_data_fifo.io.deq.bits.last === 1.U){
                    state               := sIDLE
                }                
            }
			

		}		
	}


}