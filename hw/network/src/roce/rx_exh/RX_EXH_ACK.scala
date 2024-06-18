package network.roce.rx_exh

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.BaseILA
import common.Collector
import common.ToZero


class RX_EXH_ACK() extends Module{
	val io = IO(new Bundle{
		val meta_in             = Flipped(Decoupled(new IBH_META()))
        val rx2fc_req           = (Decoupled(new IBH_META()))
        val meta_out            = (Decoupled(new IBH_META()))
	})

    val meta_fifo = XQueue(new IBH_META(), 16)

    io.meta_in      <> meta_fifo.io.in


	meta_fifo.io.out.ready      := io.rx2fc_req.ready & io.meta_out.ready

    ToZero(io.rx2fc_req.valid)
    ToZero(io.rx2fc_req.bits)
    ToZero(io.meta_out.valid)
    ToZero(io.meta_out.bits)


    //cycle 0

	when(meta_fifo.io.out.fire){
        when(meta_fifo.io.out.bits.op_code === IB_OP_CODE.RC_ACK){
            io.rx2fc_req.valid              := 1.U
            io.rx2fc_req.bits               := meta_fifo.io.out.bits
        }.otherwise{
            io.meta_out.valid              := 1.U
            io.meta_out.bits               := meta_fifo.io.out.bits            
        }

	}
    
}
