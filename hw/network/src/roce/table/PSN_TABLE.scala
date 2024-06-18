package network.roce.table

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.BaseILA
import common.ToZero


class PSN_TABLE() extends Module{
	val io = IO(new Bundle{
		val rx2psn_req  	= Flipped(Decoupled(new PSN_RX_REQ()))

		val tx2psn_req	    = Flipped(Decoupled(new PSN_TX_REQ()))
		val psn_init	    = Flipped(Decoupled(new PSN_INIT()))
		val psn2rx_rsp	    = (Decoupled(new PSN_RSP()))
		val psn2tx_rsp	    = (Decoupled(new PSN_RSP()))
	})

    val psn_rx_fifo = Module(new Queue(new PSN_RX_REQ(), entries=16))
    val psn_tx_fifo = Module(new Queue(new PSN_TX_REQ(), entries=16))
    val psn_init_fifo = Module(new Queue(new PSN_INIT(), entries=16))
    val rx_rsp_fifo = XQueue(new PSN_RSP(), entries=16)
    val tx_rsp_fifo = XQueue(new PSN_RSP(), entries=16)   

    io.rx2psn_req                       <> psn_rx_fifo.io.enq
    io.tx2psn_req                       <> psn_tx_fifo.io.enq
    io.psn_init                         <> psn_init_fifo.io.enq
    io.psn2rx_rsp                       <> rx_rsp_fifo.io.out
    io.psn2tx_rsp                       <> tx_rsp_fifo.io.out
    

    val psn_table = XRam(new PSN_STATE(), CONFIG.MAX_QPS, latency = 1)	

    val psn_init_tmp = Reg(new PSN_INIT())
    val psn_tx_req = Reg(new PSN_TX_REQ())
    val psn_rx_req = Reg(new PSN_RX_REQ())

	val sIDLE :: sINIT :: sTXRSP :: sRXRSP  :: Nil = Enum(4)
	val state                   = RegInit(sIDLE)

    psn_table.io.addr_a                 := 0.U
    psn_table.io.addr_b                 := 0.U
    psn_table.io.wr_en_a                := 0.U
    psn_table.io.data_in_a              := 0.U.asTypeOf(psn_table.io.data_in_a)

    
    psn_init_fifo.io.deq.ready              := 1.U
    psn_rx_fifo.io.deq.ready                 := (!rx_rsp_fifo.io.almostfull) & (!psn_init_fifo.io.deq.valid.asBool)
    psn_tx_fifo.io.deq.ready                 := (!tx_rsp_fifo.io.almostfull) & (!psn_init_fifo.io.deq.valid.asBool) & (!psn_rx_fifo.io.deq.valid.asBool) 

    ToZero(rx_rsp_fifo.io.in.valid)
    ToZero(rx_rsp_fifo.io.in.bits)
    ToZero(tx_rsp_fifo.io.in.valid)
    ToZero(tx_rsp_fifo.io.in.bits)    
    

    //cycle1
    when(psn_init_fifo.io.deq.fire){
        psn_init_tmp                    := psn_init_fifo.io.deq.bits
        state                           := sINIT
    }.elsewhen(psn_rx_fifo.io.deq.fire){
        psn_table.io.addr_b             := psn_rx_fifo.io.deq.bits.meta.qpn
        psn_rx_req                      := psn_rx_fifo.io.deq.bits
        state                           := sRXRSP
    }.elsewhen(psn_tx_fifo.io.deq.fire){
        psn_table.io.addr_b             := psn_tx_fifo.io.deq.bits.meta.qpn
        psn_tx_req                      := psn_tx_fifo.io.deq.bits
        state                           := sTXRSP                    
    }.otherwise{
        state                           := sIDLE
    }

    //cycle2

    when(state===sINIT){
        psn_table.io.addr_a             := psn_init_tmp.qpn
        psn_table.io.wr_en_a            := 1.U
        psn_table.io.data_in_a.rsp_psn  := 0.U
        psn_table.io.data_in_a.rx_epsn  := psn_init_tmp.remote_psn
        psn_table.io.data_in_a.tx_npsn  := psn_init_tmp.local_psn
        psn_table.io.data_in_a.tx_old_unack  := psn_init_tmp.local_psn        
    }.elsewhen(state===sRXRSP){
		rx_rsp_fifo.io.in.valid 		    := 1.U 
		rx_rsp_fifo.io.in.bits.state 		<> psn_table.io.data_out_b
        rx_rsp_fifo.io.in.bits.meta 		<> psn_rx_req.meta
        psn_table.io.addr_a             := psn_rx_req.meta.qpn
        psn_table.io.wr_en_a            := 1.U
        psn_table.io.data_in_a.tx_npsn  := psn_table.io.data_out_b.tx_npsn
        psn_table.io.data_in_a.rsp_psn  := psn_table.io.data_out_b.rsp_psn
        when(psn_rx_req.meta.op_code === IB_OP_CODE.RC_ACK){
            when(psn_rx_req.is_nak){
                psn_table.io.data_in_a.rx_epsn  := psn_table.io.data_out_b.rx_epsn        
                psn_table.io.data_in_a.tx_old_unack  := psn_table.io.data_out_b.tx_old_unack
            }.otherwise{
                psn_table.io.data_in_a.rx_epsn  := psn_table.io.data_out_b.rx_epsn        
                psn_table.io.data_in_a.tx_old_unack  := psn_rx_req.meta.psn                         
            }                               
        }.elsewhen(PKG_JUDGE.REQ_PKG(psn_rx_req.meta.op_code)){
            when(psn_rx_req.meta.psn === psn_table.io.data_out_b.rx_epsn){
                psn_table.io.data_in_a.rx_epsn      := psn_table.io.data_out_b.rx_epsn + 1.U       
                psn_table.io.data_in_a.tx_old_unack := psn_table.io.data_out_b.tx_old_unack                                
            }.otherwise{
                psn_table.io.data_in_a.rx_epsn      := psn_table.io.data_out_b.rx_epsn        
                psn_table.io.data_in_a.tx_old_unack := psn_table.io.data_out_b.tx_old_unack
            }                              
        }.otherwise{
            when(psn_rx_req.meta.psn === psn_table.io.data_out_b.tx_old_unack){
                psn_table.io.data_in_a.rx_epsn      := psn_table.io.data_out_b.rx_epsn       
                psn_table.io.data_in_a.tx_old_unack := psn_table.io.data_out_b.tx_old_unack + 1.U
            }.otherwise{
                psn_table.io.data_in_a.rx_epsn      := psn_table.io.data_out_b.rx_epsn        
                psn_table.io.data_in_a.tx_old_unack := psn_table.io.data_out_b.tx_old_unack                        
            }
        }
    }.elsewhen(state===sTXRSP){
		tx_rsp_fifo.io.in.valid 		    := 1.U 
		tx_rsp_fifo.io.in.bits.state 		<> psn_table.io.data_out_b
        tx_rsp_fifo.io.in.bits.meta 		<> psn_tx_req.meta
        psn_table.io.addr_a             := psn_tx_req.meta.qpn
        psn_table.io.wr_en_a            := 1.U
        psn_table.io.data_in_a.rx_epsn  := psn_table.io.data_out_b.rx_epsn
        when(psn_tx_req.npsn_add === 0.U){
            psn_table.io.data_in_a.tx_npsn  := psn_table.io.data_out_b.tx_npsn
            psn_table.io.data_in_a.rsp_psn  := psn_tx_req.rsp_psn
        }.otherwise{
            psn_table.io.data_in_a.tx_npsn  := psn_table.io.data_out_b.tx_npsn + psn_tx_req.npsn_add
            psn_table.io.data_in_a.rsp_psn  := psn_table.io.data_out_b.rsp_psn
        }
        psn_table.io.data_in_a.tx_old_unack  := psn_table.io.data_out_b.tx_old_unack                
    }

}