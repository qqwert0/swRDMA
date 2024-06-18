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


class ReadHost() extends Module{
	val io = IO(new Bundle{
        //
        val m_mem_read_cmd      = Flipped(Decoupled(new Dma()))
        val s_mem_read_data	    = (Decoupled(new AXIS(512)))

        val cpuReq              = (Decoupled(new PacketRequest))
        val memData             = Flipped(Decoupled(AXIS(512)))

	})



    ///////////////////////////////////riscv

	Collector.fire(io.m_mem_read_cmd)
	Collector.fire(io.s_mem_read_data)


    /////////////////////////////////

    val read_cmd = XQueue(new Dma(), entries=32)

    io.m_mem_read_cmd                      <> read_cmd.io.in



    // val csr = Module(new CSR())


    val pkg_cnt = RegInit(0.U(32.W))
    val pkg_length = RegInit(0.U(32.W))

	val sIDLE :: sPayload :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)

    read_cmd.io.out.ready           := (state === sIDLE)
    io.memData.ready                := 1.U


    ToZero(io.cpuReq.valid)
    ToZero(io.cpuReq.bits)
    ToZero(io.s_mem_read_data.valid)
    ToZero(io.s_mem_read_data.bits)    


    switch(state){
        is(sIDLE){
            when(read_cmd.io.out.fire){
                pkg_cnt                         := 0.U
                pkg_length                      := read_cmd.io.out.bits.length
                state                           := sPayload
            }                 
        }            
        is(sPayload){
            when(io.s_mem_read_data.ready){
                io.s_mem_read_data.valid        := 1.U
                io.s_mem_read_data.bits.keep    := "hffffffffffffffff".U
                io.s_mem_read_data.bits.data    := pkg_cnt + 1.U
                pkg_cnt                         := pkg_cnt + 64.U
                when(pkg_cnt >= (pkg_length-64.U)){    
                    io.s_mem_read_data.bits.last    := 1.U
                    state                           := sIDLE                
                }.otherwise{
                    io.s_mem_read_data.bits.last    := 0.U
                    state                           := sPayload
                }
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

