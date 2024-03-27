package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum

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


class Pkg_meta()extends Bundle{
    val op_code = IB_OP_CODE()
    val qpn = UInt(24.W)
	val psn = UInt(24.W)
    val ecn = Bool()
    val vaddr = UInt(64.W)
    val pkg_length = UInt(32.W)   //udp totol length - headers length
    val msg_length = UInt(32.W)   //reth  DMA length
    val user_define = UInt(336.W)
}

class Drop_meta()extends Bundle{
    val is_drop = Bool()
}

class CC_meta()extends Bundle{
    val op_code = IB_OP_CODE()
    val qpn = UInt(24.W)
    val ecn = Bool()
    val user_define = UInt(336.W)
}

class Dma_meta()extends Bundle{
    val op_code = IB_OP_CODE()
    val qpn = UInt(24.W)
    val vaddr = UInt(64.W)
    val length = UInt(32.W)
}


class Event_meta()extends Bundle{
    val op_code = IB_OP_CODE()
    val qpn = UInt(24.W)
	val psn = UInt(24.W)
    val ecn = Bool()
    val vaddr = UInt(64.W)
    val length = UInt(32.W)
    val user_define = UInt(336.W)
}



/////////////table//////////////////



class Vaddr_req()extends Bundle{
    val qpn = UInt(24.W)  
    val is_write = write = Bool()
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
    val conn_state      = CONN_STATE()          
}

class Conn_req()extends Bundle{
    val qpn             = UInt(24.W)
    val is_wr           = Bool()
    val conn_state      = CONN_STATE()
}

class Conn_rsp()extends Bundle{
    val qpn             = UInt(24.W)
    val conn_state      = CONN_STATE()
}

class Conn_state()extends Bundle{
    val remote_qpn      = UInt(24.W)
    val remote_ip       = UInt(32.W)
    val remote_udp_port = UInt(16.W)
	val rx_epsn         = UInt(24.W)   
    val tx_npsn         = UInt(24.W)
    val rx_old_unack    = UInt(24.W)
}



//