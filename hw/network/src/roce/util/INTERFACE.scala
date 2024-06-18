package network.roce.util

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum

object APP_OP_CODE extends ChiselEnum{
  val APP_READ    = Value
  val APP_WRITE  = Value
  val APP_SEND  = Value
  val reserve1  = Value//note that each state must be declared, otherwise the cast will warn you
}

class RoceMsg()extends Bundle{
    val addr        = UInt(34.W) 
    val length      = UInt(32.W) 
}

class TX_META()extends Bundle{
	val rdma_cmd = APP_OP_CODE()
	val qpn = UInt(24.W)
    val local_vaddr = UInt(48.W)
    val remote_vaddr = UInt(48.W)
    val length = UInt(32.W)
}

class MEM_CMD()extends Bundle{
	val vaddr = UInt(64.W)
    val length = UInt(32.W)
}

object PKG_TYPE extends ChiselEnum{
  val RETH    = Value
  val AETH  = Value
  val RAW  = Value
  val reserve0  = Value//note that each state must be declared, otherwise the cast will warn you
}

class PKG_INFO()extends Bundle{
	val pkg_type = PKG_TYPE()
    val data_from_mem = Bool() // true: data from mem_read_data; false: data from send_data
	val pkg_length = UInt(32.W)
}


class RD_REQ()extends Bundle{
    val qpn = UInt(24.W)
	val vaddr = UInt(64.W)
    val length = UInt(32.W)
    val psn = UInt(24.W)
}

class IBH_META()extends Bundle{
    val op_code = IB_OP_CODE()
    val qpn = UInt(24.W)
	val psn = UInt(24.W)
    val isACK = Bool()
    val vaddr = UInt(64.W)
    val l_vaddr = UInt(64.W)
    val r_key = UInt(32.W)
    val length = UInt(32.W)
    val msn = UInt(16.W)
    val isNAK = Bool()
    val credit = UInt(16.W)
    val udp_length = UInt(16.W)
    val num_pkg = UInt(16.W)
    val is_wr_ack = Bool()
    val valid_event = Bool()
    def ibh_gene(cmd_i:IB_OP_CODE.Type, qpn_i:UInt, psn_i:UInt, isACK_i:Bool, udp_length_i:UInt)={
        op_code     := cmd_i
        qpn         := qpn_i
        psn         := psn_i
        isACK       := isACK_i
        vaddr       := 0.U
        l_vaddr     := 0.U
        r_key       := 0.U
        length      := 0.U
        msn         := 0.U
        isNAK       := false.B
        credit      := 0.U
        udp_length  := udp_length_i   
        num_pkg     := 0.U
        is_wr_ack   := false.B
        valid_event  := false.B
    }
    def exh_gene(cmd_i:IB_OP_CODE.Type, qpn_i:UInt, psn_i:UInt, isACK_i:Bool, vaddr_i:UInt, length_i:UInt, credit_i:UInt, udp_length_i:UInt)={
        op_code     := cmd_i
        qpn         := qpn_i
        psn         := psn_i
        isACK       := isACK_i
        vaddr       := vaddr_i
        l_vaddr     := 0.U
        r_key       := 0.U
        length      := length_i
        msn         := 0.U
        isNAK       := false.B
        credit      := credit_i
        udp_length  := udp_length_i  
        num_pkg     := 0.U
        is_wr_ack   := false.B
        valid_event  := false.B
    }

    def local_event(cmd_i:IB_OP_CODE.Type, qpn_i:UInt, l_vaddr_i:UInt, vaddr_i:UInt, length_i:UInt)={
        op_code     := cmd_i
        qpn         := qpn_i
        psn         := 0.U
        isACK       := false.B
        l_vaddr     := l_vaddr_i
        vaddr       := vaddr_i
        r_key       := 0.U
        length      := length_i
        msn         := 0.U  
        isNAK       := false.B 
        credit      := 0.U 
        udp_length  := 0.U   
        num_pkg     := 0.U
        is_wr_ack   := false.B
        valid_event  := false.B
    }
    def remote_event(cmd_i:IB_OP_CODE.Type, qpn_i:UInt, l_vaddr_i:UInt, vaddr_i:UInt, length_i:UInt, psn_i:UInt)={
        op_code     := cmd_i
        qpn         := qpn_i
        psn         := psn_i
        isACK       := false.B
        l_vaddr     := l_vaddr_i
        vaddr       := vaddr_i
        r_key       := 0.U
        length      := length_i
        msn         := 0.U  
        isNAK       := false.B 
        credit      := 0.U 
        udp_length  := 0.U   
        num_pkg     := 0.U
        is_wr_ack   := false.B
        valid_event  := false.B
    }

    def ack_event(qpn_i:UInt, psn_i:UInt, credit_i:UInt, is_wr_ack_i:Bool)={
        op_code     := IB_OP_CODE.RC_ACK
        qpn         := qpn_i
        psn         := psn_i
        isACK       := false.B
        l_vaddr     := 0.U
        vaddr       := 0.U
        r_key       := 0.U
        length      := 0.U
        msn         := 0.U
        isNAK       := false.B 
        credit      := credit_i
        udp_length  := 0.U       
        num_pkg     := 0.U
        is_wr_ack   := is_wr_ack_i
        valid_event  := false.B
    }    
    def nak_event(qpn_i:UInt, psn_i:UInt, is_wr_ack_i:Bool)={
        op_code     := IB_OP_CODE.RC_ACK
        qpn         := qpn_i
        psn         := psn_i
        isACK       := false.B
        l_vaddr     := 0.U
        vaddr       := 0.U
        r_key       := 0.U
        length      := 0.U
        msn         := 0.U
        isNAK       := true.B 
        credit      := 0.U
        udp_length  := 0.U     
        num_pkg     := 0.U
        is_wr_ack   := is_wr_ack_i
        valid_event  := false.B
    } 
}

class RX_PKG_INFO()extends Bundle{
	val pkg_type = PKG_TYPE()
    val data_to_mem = Bool() // true: data to mem_write_data; false: data to recv_data
    val length  = UInt(16.W)
}

class UDPIP_META()extends Bundle{
    val qpn         = UInt(24.W)
    val op_code     = IB_OP_CODE()
    val dest_ip     = UInt(32.W) 
    val dest_port   = UInt(16.W) 
    val udp_length  = UInt(16.W)

}

class TX_PKG_INFO()extends Bundle{
	val isAETH = Bool()
	val hasHeader = Bool()
    val hasPayload = Bool()
}

class IP_META()extends Bundle{
    val dest_ip     = UInt(32.W) 
	val length 		= UInt(16.W) 
}

/////////////table//////////////////

class CONN_REQ()extends Bundle{
    val qpn             = UInt(24.W)
    val remote_qpn      = UInt(24.W)
    val remote_ip       = UInt(32.W)
    val remote_udp_port = UInt(16.W)  
    def conn_req_generate(qpn_i:UInt, remote_qpn_i:UInt, remote_ip_i:UInt, remote_udp_port_i:UInt)={
        qpn             := qpn_i
        remote_qpn      := remote_qpn_i
        remote_ip       := remote_ip_i    
        remote_udp_port := remote_udp_port_i
    }      
}


class CONN_STATE()extends Bundle{
    val remote_qpn      = UInt(24.W)
    val remote_ip       = UInt(32.W)
    val remote_udp_port = UInt(16.W)
}


//
class FC_REQ()extends Bundle{
    val qpn = UInt(24.W)
	val op_code = IB_OP_CODE()
    val credit = UInt(16.W)
    val psn = UInt(24.W)
    val is_wr_ack = Bool()
    def fc_req_generate(qpn_i:UInt, op_code_i:IB_OP_CODE.Type, credit_i:UInt, psn_i:UInt, is_wr_ack_i:Bool)={
        qpn         := qpn_i
        op_code     := op_code_i
        credit      := credit_i    
        psn         := psn_i
        is_wr_ack   := is_wr_ack_i
    }
}

class FC_RSP()extends Bundle{
    val valid_event = Bool()
}


class FC_STATE()extends Bundle{
	val credit = UInt(24.W)
    val acc_credit = UInt(13.W)
}

//

class MSN_INIT()extends Bundle{
    val qpn = UInt(24.W)
	val msn = UInt(24.W)
	val vaddr = UInt(64.W)
    val length = UInt(32.W)
    val r_key = UInt(32.W)    
    val write = Bool()
}


class MSN_REQ()extends Bundle{
    val qpn = UInt(24.W)
	val msn = UInt(24.W)
	val vaddr = UInt(64.W)
    val length = UInt(32.W)
    val r_key = UInt(32.W)
    val pkg_num     = UInt(21.W) // mtu minimum 1k，2G/1K=2M=21bits 
    val pkg_total   = UInt(21.W) //1 based    
    val meta        = new IBH_META()
    val write = Bool()
    def msn_req_generate(qpn_i:UInt, msn_i:UInt, vaddr_i:UInt, length_i:UInt, r_key_i:UInt, write_i:Bool)={
        qpn         := qpn_i
        msn         := msn_i
        vaddr       := vaddr_i
        length      := length_i      
        r_key       := r_key_i
        write       := write_i
    }    
}

class MSN_RSP()extends Bundle{
    val msn_state = new MSN_STATE()
    val meta = new IBH_META()    
}

class MSN_STATE()extends Bundle{
	val msn = UInt(24.W)
	val vaddr = UInt(64.W)
    val length = UInt(32.W)  
    val r_key = UInt(32.W)
    val pkg_num     = UInt(21.W) // mtu minimum 1k，2G/1K=2M=21bits 
    val pkg_total   = UInt(21.W) //1 based
}

//

class MULTI_Q_ENTRY[T<:Data](private val gen:T)extends Bundle{
    val data = gen
	val next = UInt(16.W)
    val isValid = Bool()
    val isTail = Bool()
}

class MQ_POINT_ENTRY()extends Bundle{
    val head = UInt(16.W)
	val tail = UInt(16.W)
}

class MQ_POP_REQ[T<:Data](private val gen:T)extends Bundle{
    val data =  gen
	val q_index = UInt(16.W)
}

class MQ_POP_RSP[T<:Data](private val gen:T)extends Bundle{
    val data =  gen
	val isValid = Bool()
}

//

class PSN_RX_REQ()extends Bundle{
    val is_nak = Bool()
    val meta = new IBH_META()
}

class PSN_TX_REQ()extends Bundle{
    val meta = new IBH_META()
    val npsn_add = UInt(24.W)
    val rsp_psn = UInt(24.W)
}


class PSN_INIT()extends Bundle{
    val qpn = UInt(24.W)
	val local_psn = UInt(24.W)
    val remote_psn = UInt(24.W)
}


class PSN_STATE()extends Bundle{
	val rx_epsn = UInt(24.W)   
    val rsp_psn = UInt(24.W)
    val tx_npsn = UInt(24.W)
    val tx_old_unack = UInt(24.W)
}

class PSN_RSP()extends Bundle{
	val state = new PSN_STATE()  
    val meta = new IBH_META()
}


//
class INSERT_RETRANS()extends Bundle{
    val event     = new IBH_META()
    val index   = UInt(15.W) 

}

class RECV_META()extends Bundle{
    val qpn         = UInt(16.W)
    val msg_num     = UInt(24.W) 
    val pkg_num     = UInt(21.W) // mtu minimum 1k，2G/1K=2M=21bits 
    val pkg_total   = UInt(21.W) //1 based
    val length      = UInt(16.W)
    def recv_meta_generate(qpn_i:UInt, msg_num_i:UInt, pkg_num_i:UInt, pkg_total_i:UInt, length_i:UInt)={
        qpn         := qpn_i
        msg_num     := msg_num_i
        pkg_num     := pkg_num_i
        pkg_total   := pkg_total_i      
        length      := length_i
    }  
}

class CQ_INIT()extends Bundle{
    val qpn         = UInt(16.W)
    val wq_num      = UInt(24.W)  
    val rq_num      = UInt(24.W)
    val di_num      = UInt(24.W) //direct queue number  
}

class CQ_STATE()extends Bundle{
    val wq_num      = UInt(24.W)  
    val rq_num      = UInt(24.W)
    val di_num      = UInt(24.W) //direct queue number
}

class CMPT_META()extends Bundle{
    val qpn         = UInt(16.W)
    val msg_num     = UInt(24.W) 
    val msg_type    = UInt(2.W) //0:read 1:write 2:direct
    def cmpt_meta_generate(qpn_i:UInt, msg_num_i:UInt, msg_type_i:UInt)={
        qpn         := qpn_i
        msg_num     := msg_num_i
        msg_type    := msg_type_i     
    }     
}


class QP_INIT()extends Bundle{
    val qpn             = UInt(16.W)
	val local_psn       = UInt(24.W)
    val remote_psn      = UInt(24.W)
    val remote_qpn      = UInt(24.W)
    val remote_ip       = UInt(32.W)
    val remote_udp_port = UInt(16.W)    
    val credit          = UInt(24.W)
}