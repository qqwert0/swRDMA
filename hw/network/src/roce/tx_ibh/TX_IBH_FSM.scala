package network.roce.tx_ibh

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class TX_IBH_FSM() extends Module{
	val io = IO(new Bundle{
		val ibh_meta_in         = Flipped(Decoupled(new IBH_META()))

        val psn2tx_rsp          = Flipped(Decoupled(new PSN_RSP()))
        val conn2tx_rsp         = Flipped(Decoupled(new CONN_STATE()))

        val tx2psn_req          = (Decoupled(new PSN_TX_REQ()))
        val tx2conn_req         = (Decoupled(UInt(24.W)))

        val udpip_meta_out	    = (Decoupled(new UDPIP_META()))

        val head_data_out       = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))


	})

    Collector.fire(io.ibh_meta_in)

    // Collector.count(io.ibh_meta_in.fire & io.ibh_meta_in.bits.qpn === 1.U & io.ibh_meta_in.bits.op_code === IB_OP_CODE.RC_DIRECT_ONLY, "QPN1 PKG")
    // Collector.count(io.ibh_meta_in.fire & io.ibh_meta_in.bits.qpn === 1.U & io.ibh_meta_in.bits.op_code === IB_OP_CODE.RC_ACK, "QPN1 ACK")
    // Collector.count(io.ibh_meta_in.fire & io.ibh_meta_in.bits.qpn === 2.U & io.ibh_meta_in.bits.op_code === IB_OP_CODE.RC_DIRECT_ONLY, "QPN2 PKG")
    // Collector.count(io.ibh_meta_in.fire & io.ibh_meta_in.bits.qpn === 2.U & io.ibh_meta_in.bits.op_code === IB_OP_CODE.RC_ACK, "QPN2 ACK")


    val psn_tx_fifo = Module(new Queue(new PSN_RSP(), 16))
    val conn_tx_fifo = XQueue(UInt(24.W), 16)
    io.psn2tx_rsp                       <> psn_tx_fifo.io.enq
    io.tx2conn_req                      <> conn_tx_fifo.io.out

    val ibh_head = Wire(new IBH_HEADER())

    ibh_head       := 0.U.asTypeOf(ibh_head)	
	
	io.ibh_meta_in.ready                    := io.tx2psn_req.ready & conn_tx_fifo.io.in.ready
    psn_tx_fifo.io.deq.ready                := io.conn2tx_rsp.valid & io.udpip_meta_out.ready & io.head_data_out.ready
    io.conn2tx_rsp.ready                    := psn_tx_fifo.io.deq.valid & io.udpip_meta_out.ready & io.head_data_out.ready


    io.tx2psn_req.valid             := 0.U
    io.tx2psn_req.bits              := 0.U.asTypeOf(io.tx2psn_req.bits)
    conn_tx_fifo.io.in.valid        := 0.U
    conn_tx_fifo.io.in.bits         := 0.U.asTypeOf(conn_tx_fifo.io.in.bits)
    io.udpip_meta_out.valid         := 0.U
    io.udpip_meta_out.bits          := 0.U.asTypeOf(io.udpip_meta_out.bits)
    io.head_data_out.valid          := 0.U
    io.head_data_out.bits           := 0.U.asTypeOf(io.head_data_out.bits)

	//cycle1
	when(io.ibh_meta_in.fire){
        io.tx2psn_req.valid             := 1.U
        io.tx2psn_req.bits.meta          := io.ibh_meta_in.bits
        when(io.ibh_meta_in.bits.op_code === IB_OP_CODE.RC_READ_REQUEST){
            io.tx2psn_req.bits.npsn_add := io.ibh_meta_in.bits.num_pkg
        }.elsewhen(PKG_JUDGE.WRITE_PKG(io.ibh_meta_in.bits.op_code)){
            io.tx2psn_req.bits.npsn_add := 1.U
        }.elsewhen(PKG_JUDGE.READ_RSP_PKG(io.ibh_meta_in.bits.op_code)){
            io.tx2psn_req.bits.rsp_psn  := io.ibh_meta_in.bits.psn
        }                
        conn_tx_fifo.io.in.valid        := 1.U
        conn_tx_fifo.io.in.bits         := io.ibh_meta_in.bits.qpn
	}

    //cycle2

    when(psn_tx_fifo.io.deq.fire & io.conn2tx_rsp.fire){
        when(PKG_JUDGE.READ_RSP_PKG(psn_tx_fifo.io.deq.bits.meta.op_code) | (psn_tx_fifo.io.deq.bits.meta.op_code === IB_OP_CODE.RC_ACK)){
            ibh_head.psn                    := Util.reverse(psn_tx_fifo.io.deq.bits.meta.psn)
        }.otherwise{
            ibh_head.psn                    := Util.reverse(psn_tx_fifo.io.deq.bits.state.tx_npsn)
        }
        ibh_head.qpn                        := Util.reverse(io.conn2tx_rsp.bits.remote_qpn)
        ibh_head.p_key                      := "hffff".U
        ibh_head.op_code                    := psn_tx_fifo.io.deq.bits.meta.op_code.asUInt
        when(psn_tx_fifo.io.deq.bits.meta.op_code===IB_OP_CODE.RC_ACK){
            ibh_head.ack                    := 1.U
        }.otherwise{
            ibh_head.ack                    := 0.U
        }                         
        io.head_data_out.valid              := 1.U
        io.head_data_out.bits.data          := ibh_head.asTypeOf(io.head_data_out.bits.data)
        io.head_data_out.bits.keep          := "hffffffffffffffff".U
        io.head_data_out.bits.last          := 1.U
        io.udpip_meta_out.valid             := 1.U
        io.udpip_meta_out.bits.qpn          := psn_tx_fifo.io.deq.bits.meta.qpn
        io.udpip_meta_out.bits.op_code      := psn_tx_fifo.io.deq.bits.meta.op_code
        io.udpip_meta_out.bits.dest_ip      := io.conn2tx_rsp.bits.remote_ip
        io.udpip_meta_out.bits.dest_port    := io.conn2tx_rsp.bits.remote_udp_port
        io.udpip_meta_out.bits.udp_length   := psn_tx_fifo.io.deq.bits.meta.udp_length

    }



}