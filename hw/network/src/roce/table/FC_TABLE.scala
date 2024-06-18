package network.roce.table

import common.storage._
import common._
import common.ToZero
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._

class FC_TABLE() extends Module{
	val io = IO(new Bundle{
		val rx2fc_req  	= Flipped(Decoupled(new IBH_META()))

		val tx2fc_req	= Flipped(Decoupled(new IBH_META()))
        val tx2fc_ack	= Flipped(Decoupled(new IBH_META()))
		val fc_init	    = Flipped(Decoupled(new FC_REQ()))
        val buffer_cnt	= Input(UInt(16.W))
        val ack_event   = (Decoupled(new IBH_META()))
        val fc2ack_rsp  = (Decoupled(new IBH_META()))
		val fc2tx_rsp	= (Decoupled(new IBH_META()))
	})

    val ack_event_fifo = XQueue(new IBH_META(), entries=16)
    val tx_rsp_fifo = XQueue(new IBH_META(), entries=16)
    val ack_rsp_fifo = XQueue(new IBH_META(), entries=16)
    

    io.ack_event                        <> ack_event_fifo.io.out
    io.fc2ack_rsp                       <> ack_rsp_fifo.io.out
    io.fc2tx_rsp                        <> tx_rsp_fifo.io.out


       

    val fc_table = XRam(new FC_STATE(), CONFIG.MAX_QPS, latency = 1)	

// RegInit(VecInit(Seq.fill(MAX_Q)(0.U(7.W))))


    val fc_request = Reg(Vec(2,(new IBH_META())))

    val tmq_req = Reg(Vec(4,(new IBH_META())))
    val tmp_bitmap = RegInit(0.U(4.W))
    val c_tmp_id = RegInit(0.U(2.W))
    val n_tmp_id = RegInit(0.U(2.W))
    val tx_wait = RegInit(0.U(2.W))


    // val rx_fc_request = RegInit(0.U.asTypeOf(new FC_REQ()))
    // val rx_tmp_credit = RegInit(0.U.asTypeOf(new FC_STATE()))
    val tmp_credit = RegInit(0.U.asTypeOf(new FC_STATE()))
    val tmp_request = RegInit(0.U.asTypeOf(new IBH_META()))
    val tx_forward = Wire(Bool())
    tx_forward := false.B
    val tx_event_lock = RegInit(0.B)


	val sIDLE :: sINIT :: sTXACK :: sTXRSP0 :: sTXRSP1 :: sTXRSP2 :: sRXRSP :: Nil = Enum(7)
	val state0                  = RegInit(sIDLE)
    val state1                  = RegInit(sIDLE)
    val state2                  = RegInit(sIDLE)
    // Collector.report(state0===sIDLE, "FC_TABLE===sIDLE") 
    Collector.fire(ack_event_fifo.io.in)
    Collector.trigger(c_tmp_id === n_tmp_id,"no_wait_event")

    fc_table.io.addr_a                 := 0.U
    fc_table.io.addr_b                 := 0.U
    fc_table.io.wr_en_a                := 0.U
    fc_table.io.data_in_a              := 0.U.asTypeOf(fc_table.io.data_in_a)

    
    io.fc_init.ready                    := 1.U
    io.rx2fc_req.ready                  := (!io.fc_init.valid.asBool)
    io.tx2fc_ack.ready                  := (!ack_event_fifo.io.almostfull) & (!ack_rsp_fifo.io.almostfull) & (!io.fc_init.valid.asBool) & (!io.rx2fc_req.valid.asBool)
    io.tx2fc_req.ready                  := (!tx_rsp_fifo.io.almostfull) & (!io.fc_init.valid.asBool) & (!io.rx2fc_req.valid.asBool) & (!io.tx2fc_ack.valid.asBool) & (c_tmp_id === n_tmp_id)

 
    ToZero(ack_event_fifo.io.in.valid)
    ToZero(ack_event_fifo.io.in.bits)
    ToZero(ack_rsp_fifo.io.in.valid)
    ToZero(ack_rsp_fifo.io.in.bits)
    ToZero(tx_rsp_fifo.io.in.valid)
    ToZero(tx_rsp_fifo.io.in.bits)



    //cycle 1
    when(io.fc_init.fire){
        fc_request(0).qpn                   := io.fc_init.bits.qpn
        fc_request(0).credit                := io.fc_init.bits.credit
        state0                              := sINIT
    }.elsewhen(io.rx2fc_req.fire){
        fc_request(0)                       := io.rx2fc_req.bits
        fc_table.io.addr_b                  := io.rx2fc_req.bits.qpn
        state0                              := sRXRSP                      
    }.elsewhen(io.tx2fc_ack.fire){
        fc_request(0)                       := io.tx2fc_ack.bits
        fc_table.io.addr_b                  := io.tx2fc_ack.bits.qpn
        state0                              := sTXACK
    }.elsewhen(c_tmp_id =/= n_tmp_id){
        fc_request(0)                       := tmq_req(c_tmp_id)
        fc_table.io.addr_b                  := tmq_req(c_tmp_id).qpn
        when(tx_wait === 0.U){
            state0                              := sTXRSP2
        }.otherwise{
            state0                              := sIDLE
        }
        tx_wait                                := tx_wait + 1.U
    }.elsewhen(io.tx2fc_req.fire){
        fc_request(0)                       <> io.tx2fc_req.bits
        fc_table.io.addr_b                  := io.tx2fc_req.bits.qpn
        when(PKG_JUDGE.HAVE_DATA(io.tx2fc_req.bits.op_code)){
            state0                          := sTXRSP1
        }.otherwise{
            state0                          := sTXRSP0
        }
    }.otherwise{
        state0                              := sIDLE
    }

    //cycle 2

    when(state0 === sINIT){
        fc_request(1)                   := fc_request(0)
        state1                          := sINIT
    }.otherwise{
        fc_request(1)                   := fc_request(0)
        tmp_credit                      := fc_table.io.data_out_b
        when(fc_request(1).qpn === fc_request(0).qpn){  
            when((fc_request(1).op_code === IB_OP_CODE.RC_ACK)&(state1 === sRXRSP)){
                tmp_credit.credit       := tmp_credit.credit + fc_request(1).credit
            }.elsewhen((state1 === sTXACK)){
                when(tmp_credit.acc_credit > CONFIG.ACK_CREDIT.U){
                    when(io.buffer_cnt < CONFIG.RX_BUFFER_FULL.U){
                        tmp_credit.acc_credit   := 0.U
                    }.otherwise{
                        tmp_credit.acc_credit   := tmp_credit.acc_credit
                    }
                }.otherwise{
                    tmp_credit.acc_credit   := tmp_credit.acc_credit + fc_request(1).credit
                }                
            }.elsewhen(tx_forward){
                when((fc_request(1).op_code === IB_OP_CODE.RC_WRITE_FIRST) || (fc_request(1).op_code === IB_OP_CODE.RC_DIRECT_FIRST)){
                    tmp_credit.credit       := tmp_credit.credit + CONFIG.MTU_WORD.U
                }.otherwise{
                    tmp_credit.credit       := tmp_credit.credit - fc_request(1).credit
                }
            }.otherwise{
                tmp_credit              := fc_table.io.data_out_b
            }
        }.otherwise{
            tmp_credit                  := fc_table.io.data_out_b
        }
        state1                          := state0
    }

    

    //cycle 3

    when(state1 === sINIT){
        fc_table.io.addr_a              := fc_request(1).qpn
        fc_table.io.wr_en_a             := 1.U
        fc_table.io.data_in_a.credit    := fc_request(1).credit
        fc_table.io.data_in_a.acc_credit:= 0.U
    }.elsewhen(state1 === sRXRSP){
        when(fc_request(1).op_code === IB_OP_CODE.RC_ACK){
            fc_table.io.addr_a              := fc_request(1).qpn
            fc_table.io.wr_en_a             := 1.U
            fc_table.io.data_in_a.credit    := tmp_credit.credit + fc_request(1).credit
            fc_table.io.data_in_a.acc_credit:= tmp_credit.acc_credit
        }
    }.elsewhen(state1 === sTXACK){
        when(tmp_credit.acc_credit > CONFIG.ACK_CREDIT.U){
            when(io.buffer_cnt < CONFIG.RX_BUFFER_FULL.U){
                ack_rsp_fifo.io.in.valid             := 1.U
                ack_rsp_fifo.io.in.bits              := fc_request(1)
                ack_rsp_fifo.io.in.bits.credit       := tmp_credit.acc_credit + fc_request(1).credit
                ack_rsp_fifo.io.in.bits.valid_event  := true.B
                fc_table.io.addr_a              := fc_request(1).qpn
                fc_table.io.wr_en_a             := 1.U
                fc_table.io.data_in_a.credit    := tmp_credit.credit
                fc_table.io.data_in_a.acc_credit:= 0.U
            }.otherwise{
                ack_event_fifo.io.in.valid 		        := 1.U 
                ack_event_fifo.io.in.bits.ack_event(fc_request(1).qpn, fc_request(1).credit, fc_request(1).psn, fc_request(1).is_wr_ack)
            }
        }.otherwise{
            fc_table.io.addr_a              := fc_request(1).qpn
            fc_table.io.wr_en_a             := 1.U
            fc_table.io.data_in_a.credit    := tmp_credit.credit
            fc_table.io.data_in_a.acc_credit:= tmp_credit.acc_credit + fc_request(1).credit           
        }

    }.elsewhen(state1 === sTXRSP0){
        tx_rsp_fifo.io.in.valid             := 1.U
        tx_rsp_fifo.io.in.bits              := fc_request(1)
        tx_rsp_fifo.io.in.bits.valid_event  := true.B
    }.elsewhen(state1 === sTXRSP1){
        when(c_tmp_id =/= n_tmp_id){
            tmq_req(n_tmp_id)               := fc_request(1)
            n_tmp_id                        := n_tmp_id + 1.U            
        }.elsewhen(tmp_credit.credit >= fc_request(1).credit){
			tx_rsp_fifo.io.in.valid 		        := 1.U 
            tx_rsp_fifo.io.in.bits              := fc_request(1)
            tx_rsp_fifo.io.in.bits.valid_event 	:= true.B 
            tx_forward                      := true.B
            when((fc_request(1).op_code === IB_OP_CODE.RC_WRITE_FIRST) || (fc_request(1).op_code === IB_OP_CODE.RC_DIRECT_FIRST)){
                fc_table.io.addr_a              := fc_request(1).qpn
                fc_table.io.wr_en_a             := 1.U
                fc_table.io.data_in_a.credit    := tmp_credit.credit - CONFIG.MTU_WORD.U
                fc_table.io.data_in_a.acc_credit:= tmp_credit.acc_credit                      
            }.otherwise{
                fc_table.io.addr_a              := fc_request(1).qpn
                fc_table.io.wr_en_a             := 1.U
                fc_table.io.data_in_a.credit    := tmp_credit.credit  - fc_request(1).credit
                fc_table.io.data_in_a.acc_credit:= tmp_credit.acc_credit                     
            }
        }.otherwise{
            tmq_req(n_tmp_id)               := fc_request(1)
            n_tmp_id                        := n_tmp_id + 1.U
        }
    }.elsewhen(state1 === sTXRSP2){
        when(tmp_credit.credit >= fc_request(1).credit){
			tx_rsp_fifo.io.in.valid 		        := 1.U 
            tx_rsp_fifo.io.in.bits              := fc_request(1)
            tx_rsp_fifo.io.in.bits.valid_event 	:= true.B 
            tx_forward                      := true.B
            c_tmp_id                        := c_tmp_id + 1.U
            when(fc_request(1).op_code === IB_OP_CODE.RC_WRITE_FIRST){
                fc_table.io.addr_a              := fc_request(1).qpn
                fc_table.io.wr_en_a             := 1.U
                fc_table.io.data_in_a.credit    := tmp_credit.credit - CONFIG.MTU_WORD.U
                fc_table.io.data_in_a.acc_credit:= tmp_credit.acc_credit                      
            }.otherwise{
                fc_table.io.addr_a              := fc_request(1).qpn
                fc_table.io.wr_en_a             := 1.U
                fc_table.io.data_in_a.credit    := tmp_credit.credit  - fc_request(1).credit
                fc_table.io.data_in_a.acc_credit:= tmp_credit.acc_credit                     
            }
        }
    }





}