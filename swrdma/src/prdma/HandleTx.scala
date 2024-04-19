package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class HandleTx() extends Module{
	val io = IO(new Bundle{

		val app_meta_in	        = Flipped(Decoupled(new App_meta()))
		val pkg_meta_in			= Flipped(Decoupled(new Pkg_meta()))
		val cc_meta_in			= Flipped(Decoupled(new Pkg_meta()))   //fix

		val local_read_addr		= (Decoupled(new MQ_POP_REQ(UInt(64.W))))

		val priori_meta_out		= (Decoupled(new Event_meta()))
		val event_meta_out		= (Decoupled(new Event_meta()))
	})

	val app_fifo = XQueue(new App_meta(), entries=16)
	val pkg_fifo = XQueue(new Pkg_meta(), entries=16)
	val cc_fifo = XQueue(new Pkg_meta(), entries=16)   //fix
	io.app_meta_in 		    <> app_fifo.io.in
	io.pkg_meta_in 		    <> pkg_fifo.io.in
	io.cc_meta_in			<> cc_fifo.io.in


	val app_meta = RegInit(0.U.asTypeOf(new App_meta()))
	val pkg_meta = RegInit(0.U.asTypeOf(new Pkg_meta()))
    val laddr = RegInit(0.U(48.W))
    val raddr = RegInit(0.U(48.W))
    val length = RegInit(0.U(32.W))
    val vaddr = RegInit(0.U(48.W))
    val psn = RegInit(0.U(24.W))



	val sIDLE :: sGENERATE :: sWRITE :: sSEND :: Nil = Enum(4)
	val state                   = RegInit(sIDLE)	


	cc_fifo.io.out.ready					:= (state === sIDLE) & io.priori_meta_out.ready
	pkg_fifo.io.out.ready					:= (state === sIDLE) & (!cc_fifo.io.out.valid) & io.priori_meta_out.ready & io.event_meta_out.ready
	app_fifo.io.out.ready					:= (state === sIDLE) & (!cc_fifo.io.out.valid) & (!pkg_fifo.io.out.valid) & io.event_meta_out.ready


	ToZero(io.local_read_addr.valid)
	ToZero(io.local_read_addr.bits)
	ToZero(io.priori_meta_out.valid)
	ToZero(io.priori_meta_out.bits)
	ToZero(io.event_meta_out.valid)
	ToZero(io.event_meta_out.bits)


	switch(state){
		is(sIDLE){
			when(cc_fifo.io.out.fire()){
				when(PKG_JUDGE.INFER_PKG(pkg_fifo.io.out.bits.op_code)){
					io.event_meta_out.valid			:= 1.U
					io.event_meta_out.bits.event_gen(cc_fifo.io.out.bits.op_code, cc_fifo.io.out.bits.qpn, cc_fifo.io.out.bits.psn, cc_fifo.io.out.bits.ecn, cc_fifo.io.out.bits.vaddr, cc_fifo.io.out.bits.msg_length, cc_fifo.io.out.bits.pkg_length, cc_fifo.io.out.bits.user_define)
				}.otherwise{
					io.priori_meta_out.valid			:= 1.U
					io.priori_meta_out.bits.event_gen(cc_fifo.io.out.bits.op_code, cc_fifo.io.out.bits.qpn, cc_fifo.io.out.bits.psn, cc_fifo.io.out.bits.ecn, cc_fifo.io.out.bits.vaddr, cc_fifo.io.out.bits.msg_length, cc_fifo.io.out.bits.pkg_length, cc_fifo.io.out.bits.user_define)
				}
			}.elsewhen(pkg_fifo.io.out.fire()){
				pkg_meta							:= pkg_fifo.io.out.bits
				when(PKG_JUDGE.WRITE_PKG(pkg_fifo.io.out.bits.op_code)){
					io.priori_meta_out.valid		:= 1.U
					io.priori_meta_out.bits.ack_gen(pkg_fifo.io.out.bits.qpn, pkg_fifo.io.out.bits.psn, pkg_fifo.io.out.bits.user_define)				
				}.elsewhen(pkg_fifo.io.out.bits.op_code === IB_OPCODE.RC_READ_REQUEST){
					io.event_meta_out.valid			:= 1.U
					when(pkg_fifo.io.out.bits.msg_length > CONFIG.MTU.U){
						state	                    := sGENERATE
						vaddr                       := pkg_fifo.io.out.bits.vaddr + CONFIG.MTU.U
						length                      := pkg_fifo.io.out.bits.msg_length - CONFIG.MTU.U  
						psn                         := pkg_fifo.io.out.bits.psn + 1.U
						io.event_meta_out.bits.remote_event(IB_OPCODE.RC_READ_RESP_FIRST, pkg_fifo.io.out.bits.qpn, pkg_fifo.io.out.bits.psn, pkg_fifo.io.out.bits.vaddr, CONFIG.MTU.U)
					}.otherwise{
						state	                    := sIDLE
						vaddr                       := pkg_fifo.io.out.bits.vaddr
						length                      := pkg_fifo.io.out.bits.msg_length
						io.event_meta_out.bits.remote_event(IB_OPCODE.RC_READ_RESP_ONLY, pkg_fifo.io.out.bits.qpn, pkg_fifo.io.out.bits.psn, pkg_fifo.io.out.bits.vaddr, pkg_fifo.io.out.bits.msg_length) 
					}					
				}
			}.elsewhen(app_fifo.io.out.fire()){
				app_meta	                        <> app_fifo.io.out.bits
				when(app_fifo.io.out.bits.rdma_cmd === APP_OP_CODE.APP_READ){
                    state	                        := sIDLE
					io.local_read_addr.valid        := 1.U
                    io.local_read_addr.bits.q_index := app_fifo.io.out.bits.qpn
                    io.local_read_addr.bits.data    := app_fifo.io.out.bits.local_vaddr
                    io.event_meta_out.valid         := 1.U
                    io.event_meta_out.bits.local_event(IB_OPCODE.RC_READ_REQUEST, app_fifo.io.out.bits.qpn, app_fifo.io.out.bits.local_vaddr, app_fifo.io.out.bits.remote_vaddr, app_fifo.io.out.bits.length, 0.U)                  
				}.elsewhen(app_fifo.io.out.bits.rdma_cmd === APP_OP_CODE.APP_WRITE){
                    when(app_fifo.io.out.bits.length > CONFIG.MTU.U){
                        state	                    := sWRITE
                        laddr                       := app_fifo.io.out.bits.local_vaddr + CONFIG.MTU.U
                        raddr                       := app_fifo.io.out.bits.remote_vaddr + CONFIG.MTU.U
                        length                      := app_fifo.io.out.bits.length - CONFIG.MTU.U  
                        io.event_meta_out.bits.local_event(IB_OPCODE.RC_WRITE_FIRST, app_fifo.io.out.bits.qpn, app_fifo.io.out.bits.local_vaddr, app_fifo.io.out.bits.remote_vaddr, app_fifo.io.out.bits.length, CONFIG.MTU.U )                       
                    }.otherwise{
                        state	                    := sIDLE
                        laddr                       := app_fifo.io.out.bits.local_vaddr
                        raddr                       := app_fifo.io.out.bits.remote_vaddr
                        length                      := app_fifo.io.out.bits.length
                        io.event_meta_out.bits.local_event(IB_OPCODE.RC_WRITE_ONLY, app_fifo.io.out.bits.qpn, app_fifo.io.out.bits.local_vaddr, app_fifo.io.out.bits.remote_vaddr, app_fifo.io.out.bits.length, app_fifo.io.out.bits.length) 
                    }
                    io.event_meta_out.valid         := 1.U
                }
			}
		}
		is(sGENERATE){
			when(io.event_meta_out.ready){
                when(length > CONFIG.MTU.U){
                    state	                    := sGENERATE
                    vaddr                       := vaddr + CONFIG.MTU.U
                    length                      := length - CONFIG.MTU.U  
                    psn                         := psn + 1.U 
                    io.event_meta_out.bits.remote_event(IB_OPCODE.RC_READ_RESP_MIDDLE, app_meta.qpn, psn, vaddr, CONFIG.MTU.U)                    
                }.otherwise{
                    state	                    := sIDLE
                    vaddr                       := 0.U
                    length                      := 0.U
                    psn                         := 0.U
                    io.event_meta_out.bits.remote_event(IB_OPCODE.RC_READ_RESP_LAST, app_meta.qpn, psn, vaddr, length)
                }  
                io.event_meta_out.valid      := 1.U
			}
		} 
		is(sWRITE){
			when(io.event_meta_out.ready){
                when(length > CONFIG.MTU.U){
                    state	                    := sWRITE
                    laddr                       := laddr + CONFIG.MTU.U
                    raddr                       := raddr + CONFIG.MTU.U
                    length                      := length - CONFIG.MTU.U   
                    io.event_meta_out.bits.local_event(IB_OPCODE.RC_WRITE_MIDDLE, app_meta.qpn, laddr, raddr, length, CONFIG.MTU.U)                     
                }.otherwise{
                    state	                    := sIDLE
                    laddr                       := 0.U
                    raddr                       := 0.U
                    length                      := 0.U
                    io.event_meta_out.bits.local_event(IB_OPCODE.RC_WRITE_LAST, app_meta.qpn, laddr, raddr, length, length)
                }
                io.event_meta_out.valid         := 1.U  
			}
		}        
		// is(sSEND){
		// 	when(io.event_meta_out.ready){
        //         when(length > CONFIG.MTU.U){
        //             state	                    := sSEND
        //             length                      := length - CONFIG.MTU.U   
        //             io.event_meta_out.bits.local_event(IB_OPCODE.RC_DIRECT_MIDDLE, app_meta.qpn, 0.U, 0.U, CONFIG.MTU.U)                     
        //         }.otherwise{
        //             state	                    := sIDLE
        //             length                      := 0.U
        //             io.event_meta_out.bits.local_event(IB_OPCODE.RC_DIRECT_LAST, app_meta.qpn, 0.U, 0.U, length)
        //         }
        //         io.event_meta_out.valid         := 1.U  
		// 	}
		// } 
	}


}