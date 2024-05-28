package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector
import mini.foo._
import mini.core._
import mini.junctions._


class MsgSend() extends Module{
	val io = IO(new Bundle{
        val app_meta_in    = Flipped(Decoupled(new Total_meta()))
        //
        val app_meta_out	= (Decoupled(new App_meta()))

	})


    /////////////////////////////////

    val meta_in_fifo = XQueue(new Total_meta(), entries=16)

    io.app_meta_in                      <> meta_in_fifo.io.in

    val meta_reg = RegInit(0.U.asTypeOf(new Total_meta()))
    val c_qpn = RegInit(0.U(32.W))
    val msg_cnt = RegInit(0.U(32.W))

	val sIDLE :: sSEND :: sJUDGE :: Nil = Enum(3)
	val state                   = RegInit(sIDLE)

    meta_in_fifo.io.out.ready               := (state === sIDLE)


    ToZero(io.app_meta_out.valid)
    ToZero(io.app_meta_out.bits)   



    switch(state){
        is(sIDLE){
            when(meta_in_fifo.io.out.fire){
                meta_reg                        := meta_in_fifo.io.out.bits
                c_qpn                           := 1.U
                msg_cnt                         := 1.U
                state                           := sSEND
            }                 
        }    
        is(sSEND){
            when(io.app_meta_out.ready){
                io.app_meta_out.valid           := 1.U
                io.app_meta_out.bits.rdma_cmd   := meta_reg.rdma_cmd
                io.app_meta_out.bits.qpn        := c_qpn
                io.app_meta_out.bits.local_vaddr:= meta_reg.local_vaddr
                io.app_meta_out.bits.remote_vaddr   := meta_reg.remote_vaddr
                io.app_meta_out.bits.length     := 2048.U
                state                           := sJUDGE
            }                 
        }         
        is(sJUDGE){
            when((c_qpn === meta_reg.qpn_num)&&(msg_cnt===meta_reg.msg_num_per_qpn)){
                state                           := sIDLE  
            }.elsewhen(c_qpn === meta_reg.qpn_num){
                c_qpn                           := 1.U
                msg_cnt                         := msg_cnt + 1.U
                state                           := sSEND 
            }.otherwise{
                c_qpn                           := c_qpn + 1.U
                state                           := sSEND 
            }          
        }
    }

       /* class ila_timely(seq:Seq[Data]) extends BaseILA(seq)
        val inst_ila_timely = Module(new ila_timely(Seq(
            state,
            new_rtt,
            rc_reg
        )))

        inst_ila_timely.connect(clock)
*/
}

