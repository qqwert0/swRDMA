package network.roce.cmd_ctrl

import common.storage._
import common.ToZero
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._

class QP_INIT_ROUTER() extends Module{
	val io = IO(new Bundle{
        val qp_init             = Flipped(Decoupled(new QP_INIT()))

        val msn_init	        = (Decoupled(new MSN_INIT()))
        val psn_init            = (Decoupled(new PSN_INIT()))
        val conn_init           = (Decoupled(new CONN_REQ()))
        val fc_init             = (Decoupled(new FC_REQ()))
        val cq_init             = (Decoupled(new CQ_INIT()))
	})

    val qp_init_fifo = XQueue(new QP_INIT(), 4)
    io.qp_init                      <>  qp_init_fifo.io.in


    ToZero(io.msn_init.valid)
    ToZero(io.msn_init.bits)
    ToZero(io.psn_init.valid)
    ToZero(io.psn_init.bits)
    ToZero(io.conn_init.valid)
    ToZero(io.conn_init.bits)    
    ToZero(io.fc_init.valid)
    ToZero(io.fc_init.bits)
    ToZero(io.cq_init.valid)
    ToZero(io.cq_init.bits)

    qp_init_fifo.io.out.ready        := io.msn_init.ready & io.psn_init.ready & io.conn_init.ready & io.fc_init.ready & io.cq_init.ready 

    when(qp_init_fifo.io.out.fire){
        io.psn_init.valid           := 1.U
        io.psn_init.bits.qpn        := qp_init_fifo.io.out.bits.qpn
        io.psn_init.bits.local_psn  := qp_init_fifo.io.out.bits.local_psn
        io.psn_init.bits.remote_psn := qp_init_fifo.io.out.bits.remote_psn
        io.conn_init.valid          := 1.U
        io.conn_init.bits.conn_req_generate(qp_init_fifo.io.out.bits.qpn, qp_init_fifo.io.out.bits.remote_qpn, qp_init_fifo.io.out.bits.remote_ip, qp_init_fifo.io.out.bits.remote_udp_port)
        io.fc_init.valid            := 1.U
        io.fc_init.bits.fc_req_generate(qp_init_fifo.io.out.bits.qpn, IB_OP_CODE.reserve0, qp_init_fifo.io.out.bits.credit, 0.U, false.B)
        io.cq_init.valid            := 1.U
        io.cq_init.bits.qpn         := qp_init_fifo.io.out.bits.qpn
    }

}