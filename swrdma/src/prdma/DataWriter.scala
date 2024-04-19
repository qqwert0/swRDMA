package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class DataWriter() extends Module{
	val io = IO(new Bundle{

		val meta_in	        	= Flipped(Decoupled(new Dma_meta()))

		val vaddr_req 			= (Decoupled(new Vaddr_req()))
		val vaddr_rsp 			= Flipped(Decoupled(new Vaddr_state()))
        
		val read_req_pop_req  	= (Decoupled(UInt(24.W)))
		val read_req_pop_rsp  	= Flipped(Decoupled(new MQ_POP_RSP(UInt(64.W))))

		val dma_out				= (Decoupled(new Dma()))
	})


    val meta_fifo = XQueue(new Dma_meta(), entries=16)
    val vaddr_fifo = XQueue(new Vaddr_state(), entries=16)
	val read_req_fifo = XQueue(new MQ_POP_RSP(UInt(64.W)), entries=16)

    io.meta_in                      	<> meta_fifo.io.in
    io.vaddr_rsp                      	<> vaddr_fifo.io.in
	io.read_req_pop_rsp                 <> read_req_fifo.io.in


	val meta_reg				= RegInit(0.U.asTypeOf(new Dma_meta()))
	val consume_read_addr		= RegInit(false.B)
	val sIDLE :: sDATA :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)


	meta_fifo.io.out.ready						:= (state === sIDLE) & io.vaddr_req.ready & io.read_req_pop_req.ready

	vaddr_fifo.io.out.ready						:= (state === sDATA) & ((~consume_read_addr) || (read_req_fifo.io.out.valid & consume_read_addr)) & io.vaddr_req.ready & io.dma_out.ready
	read_req_fifo.io.out.ready					:= (state === sDATA) & consume_read_addr & vaddr_fifo.io.out.valid & io.vaddr_req.ready & io.dma_out.ready

	ToZero(io.vaddr_req.valid)
	ToZero(io.vaddr_req.bits)
	ToZero(io.read_req_pop_req.valid)
	ToZero(io.read_req_pop_req.bits)
	ToZero(io.dma_out.valid)
	ToZero(io.dma_out.bits)	


	switch(state){
		is(sIDLE){
			when(meta_fifo.io.out.fire){
				meta_reg						:= meta_fifo.io.out.bits
				io.vaddr_req.valid             	:= 1.U
				io.vaddr_req.bits.qpn          	:= meta_fifo.io.out.bits.qpn   
				io.vaddr_req.bits.is_wr      := false.B         
				when(meta_fifo.io.out.bits.op_code === IB_OPCODE.RC_READ_RESP_FIRST | meta_fifo.io.out.bits.op_code === IB_OPCODE.RC_READ_RESP_ONLY){
					io.read_req_pop_req.valid 	:= 1.U
					io.read_req_pop_req.bits  	:= meta_fifo.io.out.bits.qpn
					consume_read_addr			:= true.B
				}
				state							:= sDATA
			}
		}
		is(sDATA){
			when(vaddr_fifo.io.out.fire & ((~consume_read_addr) || (read_req_fifo.io.out.fire&consume_read_addr))){
				state										:= sIDLE
				consume_read_addr							:= false.B
				when(meta_reg.op_code === IB_OPCODE.RC_WRITE_FIRST){
					io.vaddr_req.valid						:= 1.U
					io.vaddr_req.bits.qpn					:= meta_reg.qpn
					io.vaddr_req.bits.is_wr				:= true.B 
					io.vaddr_req.bits.msn_state.vaddr		:= meta_reg.vaddr + meta_reg.pkg_length
					io.vaddr_req.bits.msn_state.length		:= meta_reg.msg_length - meta_reg.pkg_length
					io.dma_out.valid						:= 1.U
					io.dma_out.bits.vaddr					:= meta_reg.vaddr
					io.dma_out.bits.length					:= meta_reg.pkg_length
				}.elsewhen(meta_reg.op_code === IB_OPCODE.RC_WRITE_ONLY){
					io.vaddr_req.valid						:= 1.U
					io.vaddr_req.bits.qpn					:= meta_reg.qpn
					io.vaddr_req.bits.is_wr				:= true.B 
					io.vaddr_req.bits.msn_state.vaddr		:= 0.U
					io.vaddr_req.bits.msn_state.length		:= 0.U
					io.dma_out.valid						:= 1.U
					io.dma_out.bits.vaddr					:= meta_reg.vaddr
					io.dma_out.bits.length					:= meta_reg.pkg_length
				}.elsewhen(meta_reg.op_code === IB_OPCODE.RC_WRITE_MIDDLE){
					io.vaddr_req.valid						:= 1.U
					io.vaddr_req.bits.qpn					:= meta_reg.qpn
					io.vaddr_req.bits.is_wr				:= true.B 
					io.vaddr_req.bits.msn_state.vaddr		:= vaddr_fifo.io.out.bits.vaddr + meta_reg.pkg_length
					io.vaddr_req.bits.msn_state.length		:= vaddr_fifo.io.out.bits.length - meta_reg.pkg_length
					io.dma_out.valid						:= 1.U
					io.dma_out.bits.vaddr					:= vaddr_fifo.io.out.bits.vaddr
					io.dma_out.bits.length					:= meta_reg.pkg_length
				}.elsewhen(meta_reg.op_code === IB_OPCODE.RC_WRITE_LAST){
					io.vaddr_req.valid						:= 1.U
					io.vaddr_req.bits.qpn					:= meta_reg.qpn
					io.vaddr_req.bits.is_wr				:= true.B 
					io.vaddr_req.bits.msn_state.vaddr		:= vaddr_fifo.io.out.bits.vaddr + meta_reg.pkg_length
					io.vaddr_req.bits.msn_state.length		:= vaddr_fifo.io.out.bits.length - meta_reg.pkg_length
					io.dma_out.valid						:= 1.U
					io.dma_out.bits.vaddr					:= vaddr_fifo.io.out.bits.vaddr
					io.dma_out.bits.length					:= meta_reg.pkg_length
				}.elsewhen(meta_reg.op_code === IB_OPCODE.RC_READ_RESP_ONLY){
					io.vaddr_req.valid						:= 1.U
					io.vaddr_req.bits.qpn					:= meta_reg.qpn
					io.vaddr_req.bits.is_wr				:= true.B 
					io.vaddr_req.bits.msn_state.vaddr		:= 0.U
					io.vaddr_req.bits.msn_state.length		:= 0.U
					io.dma_out.valid						:= 1.U
					io.dma_out.bits.vaddr					:= read_req_fifo.io.out.bits.data
					io.dma_out.bits.length					:= meta_reg.pkg_length
				}.elsewhen(meta_reg.op_code === IB_OPCODE.RC_READ_RESP_FIRST){
					io.vaddr_req.valid						:= 1.U
					io.vaddr_req.bits.qpn					:= meta_reg.qpn
					io.vaddr_req.bits.is_wr				:= true.B 
					io.vaddr_req.bits.msn_state.vaddr		:= read_req_fifo.io.out.bits.data + meta_reg.pkg_length
					io.vaddr_req.bits.msn_state.length		:= 0.U
					io.dma_out.valid						:= 1.U
					io.dma_out.bits.vaddr					:= read_req_fifo.io.out.bits.data
					io.dma_out.bits.length					:= meta_reg.pkg_length
				}.elsewhen(meta_reg.op_code === IB_OPCODE.RC_READ_RESP_MIDDLE){
					io.vaddr_req.valid						:= 1.U
					io.vaddr_req.bits.qpn					:= meta_reg.qpn
					io.vaddr_req.bits.is_wr				:= true.B 
					io.vaddr_req.bits.msn_state.vaddr		:= vaddr_fifo.io.out.bits.vaddr + meta_reg.pkg_length
					io.vaddr_req.bits.msn_state.length		:= 0.U
					io.dma_out.valid						:= 1.U
					io.dma_out.bits.vaddr					:= vaddr_fifo.io.out.bits.vaddr
					io.dma_out.bits.length					:= meta_reg.pkg_length
				}.elsewhen(meta_reg.op_code === IB_OPCODE.RC_READ_RESP_LAST){
					io.vaddr_req.valid						:= 1.U
					io.vaddr_req.bits.qpn					:= meta_reg.qpn
					io.vaddr_req.bits.is_wr				:= true.B 
					io.vaddr_req.bits.msn_state.vaddr		:= vaddr_fifo.io.out.bits.vaddr + meta_reg.pkg_length
					io.vaddr_req.bits.msn_state.length		:= 0.U
					io.dma_out.valid						:= 1.U
					io.dma_out.bits.vaddr					:= vaddr_fifo.io.out.bits.vaddr
					io.dma_out.bits.length					:= meta_reg.pkg_length
				}
			}
		}	
	}	

}
