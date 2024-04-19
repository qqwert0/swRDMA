package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._

object APP_OP_CODE extends ChiselEnum{
  val APP_READ    = Value
  val APP_WRITE  = Value
  val APP_SEND  = Value
  val reserve1  = Value//note that each state must be declared, otherwise the cast will warn you
}


class App_meta()extends Bundle{
	val rdma_cmd = APP_OP_CODE()
	val qpn = UInt(24.W)
    val local_vaddr = UInt(48.W)
    val remote_vaddr = UInt(48.W)
    val length = UInt(32.W)
}




class Drop_meta()extends Bundle{
    val is_drop = Bool()
}

class CC_meta()extends Bundle{
    val op_code = IB_OPCODE()
    val qpn = UInt(24.W)
    val pkg_length = UInt(32.W)
    val user_define = UInt(352.W)
    def cc_gen(cmd_i:IB_OPCODE.Type, qpn_i:UInt, pkg_length_i:UInt, user_define_i:UInt)={
        op_code     := cmd_i
        qpn         := qpn_i
        pkg_length  := pkg_length_i
        user_define := user_define_i
    }
}

class Dma_meta()extends Bundle{
    val op_code = IB_OPCODE()
    val qpn = UInt(24.W)
    val vaddr = UInt(64.W)
    val pkg_length = UInt(32.W)
    val msg_length = UInt(32.W)
    def dma_gen(cmd_i:IB_OPCODE.Type, qpn_i:UInt, vaddr_i:UInt, pkg_length_i:UInt, msg_length_i:UInt)={
        op_code     := cmd_i
        qpn         := qpn_i
        vaddr       := vaddr_i
        pkg_length  := pkg_length_i
        msg_length  := msg_length_i
    }


}


class Pkg_meta()extends Bundle{
    val op_code = IB_OPCODE()
    val qpn = UInt(24.W)
	val psn = UInt(24.W)
    val ecn = Bool()
    val vaddr = UInt(64.W)         //RDMA message vaddr
    val pkg_length = UInt(32.W)   //packet length (udp totol length - UDP & IBH & RETH/AETH & userdefine headers length)
    val msg_length = UInt(32.W)   //RDMA message length 
    val user_define = UInt(352.W)
}


class Event_meta()extends Bundle{
    val op_code = IB_OPCODE()
    val qpn = UInt(24.W)
	val psn = UInt(24.W)
    val ecn = Bool()
    val l_vaddr = UInt(64.W)    //local vaddr
    val r_vaddr = UInt(64.W)    //remote vaddr
    val msg_length = UInt(32.W)  
    val pkg_length = UInt(32.W)
    val header_len = UInt(4.W)  //0:0B, 1:4B, 2:8B, 3:16B, 4:32B, 5:44B
    val user_define = UInt(352.W)
    def event_gen(cmd_i:IB_OPCODE.Type, qpn_i:UInt, psn_i:UInt, ecn_i:Bool, vaddr_i:UInt, msg_length_i:UInt, pkg_length_i:UInt, user_define_i:UInt)={
        op_code     := cmd_i
        qpn         := qpn_i
        psn         := psn_i
        ecn         := ecn_i
        l_vaddr     := vaddr_i
        r_vaddr     := vaddr_i
        msg_length  := msg_length_i
        pkg_length  := pkg_length_i
        header_len  := 0.U
        user_define := user_define_i
    }
    def ack_gen(qpn_i:UInt, psn_i:UInt, user_define_i:UInt)={
        op_code     := IB_OPCODE.RC_ACK
        qpn         := qpn_i
        psn         := psn_i
        ecn         := false.B
        l_vaddr     := 0.U
        r_vaddr     := 0.U
        msg_length  := 0.U
        pkg_length  := 0.U
        header_len  := 0.U
        user_define := user_define_i
    }
    def ecn_gen(qpn_i:UInt, user_define_i:UInt)={
        op_code     := IB_OPCODE.RC_ACK //fix
        qpn         := qpn_i
        psn         := 0.U
        ecn         := true.B
        l_vaddr     := 0.U
        r_vaddr     := 0.U
        msg_length  := 0.U
        pkg_length  := 0.U
        header_len  := 0.U
        user_define := user_define_i
    }
    def remote_event(cmd_i:IB_OPCODE.Type, qpn_i:UInt, psn_i:UInt, l_vaddr_i:UInt, length_i:UInt)={
        op_code     := cmd_i
        qpn         := qpn_i
        psn         := psn_i
        ecn         := false.B
        l_vaddr     := l_vaddr_i
        r_vaddr     := 0.U
        msg_length  := 0.U
        pkg_length  := length_i
        user_define := 0.U
    }
    def local_event(cmd_i:IB_OPCODE.Type, qpn_i:UInt, l_vaddr_i:UInt, vaddr_i:UInt, msg_length_i:UInt, pkg_length_i:UInt)={
        op_code     := cmd_i
        qpn         := qpn_i
        psn         := 0.U
        ecn         := false.B
        l_vaddr     := l_vaddr_i
        r_vaddr     := vaddr_i
        msg_length  := msg_length_i
        pkg_length  := pkg_length_i
        user_define := 0.U
    }
}



/////////////table//////////////////



class Vaddr_req()extends Bundle{
    val qpn = UInt(24.W)  
    val is_wr = Bool()
    val msn_state = new Vaddr_state() 
}

class Vaddr_rsp()extends Bundle{
    val qpn = UInt(24.W)  
    val msn_state = new Vaddr_state() 
}

class Vaddr_state()extends Bundle{
	val vaddr = UInt(64.W)
    val length = UInt(32.W)  
}


class Dma()extends Bundle{
	val vaddr = UInt(64.W)
    val length = UInt(32.W)  
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



class Conn_init()extends Bundle{
    val qpn             = UInt(24.W)
    val conn_state      = new Conn_state()          
}

class Conn_req()extends Bundle{
    val qpn             = UInt(24.W)
    val is_wr           = Bool()
    val conn_state      = new Conn_state()   
}

class Conn_rsp()extends Bundle{
    val qpn             = UInt(24.W)
    val conn_state      = new Conn_state()
}

class Conn_state()extends Bundle{
    val remote_qpn      = UInt(24.W)
    val remote_ip       = UInt(32.W)
    val remote_udp_port = UInt(16.W)
	val rx_epsn         = UInt(24.W)   
    val tx_npsn         = UInt(24.W)
    val rx_old_unack    = UInt(24.W)
    def conn_gen(remote_qpn_i:UInt, remote_ip_i:UInt, remote_udp_port_i:UInt, rx_epsn_i:Bool, tx_npsn_i:UInt, rx_old_unack_i:UInt)={
        remote_qpn          := remote_qpn_i
        remote_ip           := remote_ip_i
        remote_udp_port     := remote_udp_port_i
        rx_epsn             := rx_epsn_i
        tx_npsn             := tx_npsn_i
        rx_old_unack        := rx_old_unack_i
    }
}



//

class CC_init()extends Bundle{
    val qpn             = UInt(24.W)
    val cc_state      = new CC_state()          
}

class CC_req()extends Bundle{
    val qpn             = UInt(24.W)
    val is_wr           = Bool()
    val lock            = Bool()
    val cc_state        = new CC_state()   
}

class CC_state()extends Bundle{
    val credit          = UInt(32.W)  
    val rate            = UInt(32.W)  
    val timer           = UInt(32.W)  //上次发送数据时的时间，用于计算数据包是否能否发送
	val user_define      = UInt(352.W)   
}