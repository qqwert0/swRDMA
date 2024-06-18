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


class WriteHost() extends Module{
	val io = IO(new Bundle{
        //
        val m_mem_write_cmd     = Flipped(Decoupled(new Dma()))
        val m_mem_write_data	= Flipped(Decoupled(new AXIS(512)))

        val address             = Input(UInt(64.W))
        val pkg_num             = Input(UInt(32.W))
        val cpuReq              = (Decoupled(new PacketRequest))
        val memData             = (Decoupled(AXIS(512)))

	})



    ///////////////////////////////////riscv

	Collector.fire(io.m_mem_write_cmd)
	Collector.fire(io.m_mem_write_data)
	Collector.fire(io.cpuReq)
	Collector.fire(io.memData)


    /////////////////////////////////

    val data_fifo = XQueue(new AXIS(512), entries=32)

    io.m_mem_write_data                      <> data_fifo.io.in



    // val csr = Module(new CSR())

    val address = RegNext(io.address)
    val pkg_num = RegNext(io.pkg_num)
    val pkg_cnt = RegInit(0.U(32.W))
    val vaddr = RegInit(0.U(64.W))

	val sIDLE :: sCmd :: sHead :: sPayload :: Nil = Enum(4)
	val state                   = RegInit(sIDLE)

    data_fifo.io.out.ready               := ((state === sHead) || (state === sPayload))&io.memData.ready
    io.m_mem_write_cmd.ready              := ((state === sIDLE) || (state === sCmd))


    ToZero(io.cpuReq.valid)
    ToZero(io.cpuReq.bits)
    ToZero(io.memData.valid)
    ToZero(io.memData.bits)    


    switch(state){
        is(sIDLE){
            when(io.m_mem_write_cmd.fire){
                vaddr                           := io.m_mem_write_cmd.bits.vaddr
                pkg_cnt                         := 0.U
                io.cpuReq.valid                 := 1.U
                io.cpuReq.bits.addr             := address
                io.cpuReq.bits.size             := pkg_num << 6.U
                io.cpuReq.bits.callback         := 0.U
                state                           := sHead                    

            }                 
        }    
        is(sCmd){
            when(io.m_mem_write_cmd.fire){
                vaddr                           := io.m_mem_write_cmd.bits.vaddr
                state                           := sHead                    
            }             
        }
        is(sHead){
            when(data_fifo.io.out.fire){
                when(vaddr === 1.U){
                    pkg_cnt                         := pkg_cnt + 1.U
                    io.memData.valid                := 1.U
                    io.memData.bits                 := data_fifo.io.out.bits
                    when(pkg_cnt === (pkg_num - 1.U)){
                        io.memData.bits.last        := 1.U
                    }.otherwise{
                        io.memData.bits.last        := 0.U
                    }                    
                }
                when(data_fifo.io.out.bits.last === 1.U){    
                    state                           := sHead                
                }.otherwise{
                    state                           := sPayload
                }
            }                 
        }         
        is(sPayload){
            when(data_fifo.io.out.fire){
                when(data_fifo.io.out.bits.last === 1.U){    
                    state                           := sCmd                
                }.otherwise{
                    state                           := sPayload
                }
            }            
        }
    }

	// val txdata = WireInit(0.U(96.W))
	// txdata	:= data_fifo.io.out.bits.data(95,0)

    //     class ila_timely(seq:Seq[Data]) extends BaseILA(seq)
    //     val inst_ila_timely = Module(new ila_timely(Seq(
    //         state,
    //         txdata,
    //         data_fifo.io.out.valid,
    //         data_fifo.io.out.ready,
    //         io.memData.valid,
    //         io.memData.ready,
    //     )))

    //     inst_ila_timely.connect(clock)

}

