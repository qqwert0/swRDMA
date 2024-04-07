package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class RxDispatch() extends Module{
	val io = IO(new Bundle{

		val meta_in	        	= Flipped(Decoupled(new Pkg_meta()))
		val cc_pkg_type			= Input(UInt(256.W)) 

		val conn_req 			= (Decoupled(new Conn_req()))
		val conn_rsp 			= Flipped(Decoupled(new Conn_state()))

		val drop_meta_out	    = (Decoupled(new Drop_meta()))
		val cc_meta_out			= (Decoupled(new CC_meta()))
		val dma_meta_out		= (Decoupled(new Dma_meta()))
		val event_meta_out		= (Decoupled(new Event_meta()))
	})

	val meta_fifo = XQueue(new Pkg_meta(), entries=16)
	io.meta_in 		    <> meta_fifo.io.in

    val conn_rsp_fifo = XQueue(new Conn_rsp(), entries=16)
    io.conn_rsp                       <> conn_rsp_fifo.io.in

    val psn_err                 = RegInit(false.B)
    Collector.report(psn_err)		

	val meta_Reg = RegInit(0.U.asTypeOf(new Pkg_meta())) 
	val conn_Reg = RegInit(0.U.asTypeOf(new CONN_STATE()))
	val cc_pkg_type = RegNext(io.cc_pkg_type)

	meta_fifo.io.out.ready                    := io.conn_req.ready
    conn_rsp_fifo.io.out.ready                := io.drop_meta_out.ready & io.cc_meta_out.ready & io.dma_meta_out.ready & io.event_meta_out.ready


    ToZero(io.conn_req.valid)                 
    ToZero(io.conn_req.bits)                              
    ToZero(io.drop_meta_out.valid)                 
    ToZero(io.drop_meta_out.bits)
    ToZero(io.cc_meta_out.valid)                 
    ToZero(io.cc_meta_out.bits)	
    ToZero(io.dma_meta_out.valid)                 
    ToZero(io.dma_meta_out.bits)
    ToZero(io.event_meta_out.valid)                 
    ToZero(io.event_meta_out.bits)
    //cycle1


	switch(state){
		is(sIDLE){
			when(meta_fifo.io.out.fire()){
				meta_Reg						:= meta_fifo.io.out.bits
				io.conn_req.valid            	:= 1.U
				io.conn_req.bits.qpn         	:= meta_fifo.io.out.bits.qpn
				io.conn_req.bits.is_wr			:= false.B
				state							:= sDATA
			}
		is(sDATA){
			when(conn_rsp_fifo.io.out.fire()){
				when(PKG_JUDGE.HAVE_DATA(meta_Reg.op_code)){
					io.dma_meta_out.valid			:= 1.U
					io.dma_meta_out.bits.dma_gen(meta_Reg.op_code, meta_Reg.qpn, meta_Reg.vaddr, meta_Reg.pkg_length, meta_Reg.msg_length)    
					when(meta_Reg.psn === conn_rsp_fifo.io.out.bits.rx_epsn){                     
						io.drop_meta_out.valid          := 1.U
						io.drop_meta_out.bits.is_drop   := false.B                                
					}.elsewhen(meta_Reg.psn < conn_rsp_fifo.io.out.bits.state.rx_epsn){
						psn_err                         := true.B
						io.drop_meta_out.valid          := 1.U
						io.drop_meta_out.bits.is_drop   := true.B   
					}otherwise{          
						psn_err                         := true.B          
						io.drop_meta_out.valid          := 1.U
						io.drop_meta_out.bits.is_drop   := true.B 
					} 			
				}


				when(PKG_JUDGE.REQ_PKG(meta_Reg.opcode)){
					when(conn_rsp_fifo.io.out.bits.psn === conn_rsp_fifo.io.out.bits.state.rx_epsn){                     
						when(cc_pkg_type(meta_Reg.opcode.asUInt) === 1.U){
							io.cc_meta_out.valid		:= 1.U
							io.cc_meta_out.bits.cc_gen(meta_Reg.opcode, meta_Reg.qpn, meta_Reg.ecn, meta_Reg.user_define)
						}
						io.event_meta_out.valid			:= 1.U
						io.event_meta_out.bits.event_gen(meta_Reg.opcode, meta_Reg.qpn, meta_Reg.psn, meta_Reg.ecn, meta_Reg.vaddr, meta_Reg.msg_length, 0.U, meta_Reg.user_define)
						io.conn_req.valid            	:= 1.U
						io.conn_req.bits.qpn         	:= meta_fifo.io.out.bits.qpn
						io.conn_req.bits.is_wr			:= true.B
						io.conn_req.bits.conn_state		:= conn_rsp_fifo.io.out.bits
						when(meta_Reg.opcode === RC_READ_REQUEST){
							io.conn_req.bits.conn_state.rx_epsn	:= conn_rsp_fifo.io.out.bits.rx_epsn + ((meta_Reg.msg_length + CONFIG.MTU.U-1.U) / CONFIG.MTU.U)
						}.otherwise{
							io.conn_req.bits.conn_state.rx_epsn	:= conn_rsp_fifo.io.out.bits.rx_epsn + 1.U
						}
					}.elsewhen(conn_rsp_fifo.io.out.bits.psn < conn_rsp_fifo.io.out.bits.state.rx_epsn){
						psn_err                         := true.B
					}otherwise{          
						psn_err                         := true.B          
					} 					
				}.elsewhen(PKG_JUDGE.HAVE_DATA(meta_Reg.op_code)){
					when(conn_rsp_fifo.io.out.bits.psn === conn_rsp_fifo.io.out.bits.state.tx_old_unack){
						when(cc_pkg_type(meta_Reg.opcode.asUInt) === 1.U){
							io.cc_meta_out.valid		:= 1.U
							io.cc_meta_out.bits.cc_gen(meta_Reg.opcode, meta_Reg.qpn, meta_Reg.ecn, meta_Reg.user_define)
						}
						io.conn_req.valid            	:= 1.U
						io.conn_req.bits.qpn         	:= meta_fifo.io.out.bits.qpn
						io.conn_req.bits.is_wr			:= true.B
						io.conn_req.bits.conn_state		:= conn_rsp_fifo.io.out.bits
						io.conn_req.bits.conn_state.rx_old_unack	:= conn_rsp_fifo.io.out.bits.rx_old_unack + 1.U       
					}.otherwise{                    
						psn_err                         := true.B
					}  					
				}.elsewhen(meta_Reg.opcode === IB_OP_CODE.RC_ACK){
					when(cc_pkg_type(meta_Reg.opcode.asUInt) === 1.U){
						io.cc_meta_out.valid		:= 1.U
						io.cc_meta_out.bits.cc_gen(meta_Reg.opcode, meta_Reg.qpn, meta_Reg.ecn, meta_Reg.user_define)
					}
					io.conn_req.valid            	:= 1.U
					io.conn_req.bits.qpn         	:= meta_fifo.io.out.bits.qpn
					io.conn_req.bits.is_wr			:= true.B
					io.conn_req.bits.conn_state		:= conn_rsp_fifo.io.out.bits
					io.conn_req.bits.conn_state.rx_old_unack	:= meta_Reg.psn  					
				}.otherwise{
					when(cc_pkg_type(meta_Reg.opcode.asUInt) === 1.U){
						io.cc_meta_out.valid		:= 1.U
						io.cc_meta_out.bits.cc_gen(meta_Reg.opcode, meta_Reg.qpn, meta_Reg.ecn, meta_Reg.user_define)
					}
				}
			} 	
		}	
	}


    //cycle2




}