package network.roce.cmd_ctrl

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class HANDLE_READ_REQ() extends Module{
	val io = IO(new Bundle{
		val remote_read_req     = Flipped(Decoupled(new RD_REQ()))


        val remote_read_event	= (Decoupled(new IBH_META()))
	})

    val r_read_req_fifo = Module(new Queue(new RD_REQ(), 64))
    io.remote_read_req                  <> r_read_req_fifo.io.enq


	val rdma_meta = RegInit(0.U.asTypeOf(new RD_REQ()))
    val vaddr = RegInit(0.U(48.W))
    val length = RegInit(0.U(32.W))
    val psn = RegInit(0.U(24.W))

	val sIDLE :: sGENERATE :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)	
    Collector.report(state===sIDLE, "HANDLE_READ_REQ===sIDLE")
	
	r_read_req_fifo.io.deq.ready    := (state === sIDLE) & io.remote_read_event.ready

    io.remote_read_event.bits 	:= 0.U.asTypeOf(io.remote_read_event.bits)
    io.remote_read_event.valid 	:= 0.U
	
	switch(state){
		is(sIDLE){
			when(r_read_req_fifo.io.deq.fire){
				rdma_meta	                    <> r_read_req_fifo.io.deq.bits
                when(r_read_req_fifo.io.deq.bits.length > CONFIG.MTU.U){
                    state	                    := sGENERATE
                    vaddr                       := r_read_req_fifo.io.deq.bits.vaddr + CONFIG.MTU.U
                    length                      := r_read_req_fifo.io.deq.bits.length - CONFIG.MTU.U  
                    psn                         := r_read_req_fifo.io.deq.bits.psn + 1.U
                    io.remote_read_event.bits.remote_event(IB_OP_CODE.RC_READ_RESP_FIRST, r_read_req_fifo.io.deq.bits.qpn, 0.U, r_read_req_fifo.io.deq.bits.vaddr, CONFIG.MTU.U, r_read_req_fifo.io.deq.bits.psn)
                }.otherwise{
                    state	                    := sIDLE
                    vaddr                       := r_read_req_fifo.io.deq.bits.vaddr
                    length                      := r_read_req_fifo.io.deq.bits.length
                    io.remote_read_event.bits.remote_event(IB_OP_CODE.RC_READ_RESP_ONLY, r_read_req_fifo.io.deq.bits.qpn, 0.U, r_read_req_fifo.io.deq.bits.vaddr, r_read_req_fifo.io.deq.bits.length, r_read_req_fifo.io.deq.bits.psn) 
                }
                io.remote_read_event.valid      := 1.U
			}
		}
		is(sGENERATE){
			when(io.remote_read_event.ready){
                when(length > CONFIG.MTU.U){
                    state	                    := sGENERATE
                    vaddr                       := vaddr + CONFIG.MTU.U
                    length                      := length - CONFIG.MTU.U  
                    psn                         := psn + 1.U 
                    io.remote_read_event.bits.remote_event(IB_OP_CODE.RC_READ_RESP_MIDDLE, rdma_meta.qpn, 0.U, vaddr, CONFIG.MTU.U, psn)                    
                }.otherwise{
                    state	                    := sIDLE
                    vaddr                       := 0.U
                    length                      := 0.U
                    psn                         := 0.U
                    io.remote_read_event.bits.remote_event(IB_OP_CODE.RC_READ_RESP_LAST, rdma_meta.qpn, 0.U, vaddr, length, psn)
                }  
                io.remote_read_event.valid      := 1.U
			}
		}        

	}
    

}