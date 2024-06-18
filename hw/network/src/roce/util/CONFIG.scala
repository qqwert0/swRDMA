package network.roce.util

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._

object Util{
    def has_overflow(data:DecoupledIO[Data])={
        val overflow = RegInit(false.B)
        when(data.valid && (!data.ready)){
            overflow    := true.B
        }.otherwise{
            overflow    := overflow
        }
        overflow
    }

    def reverse(data:UInt)={
        val width = data.getWidth
        val res =  WireInit(VecInit(Seq.fill(width)(0.U(1.W))))

        for(i<-0 until width/8){
            for(j<-0 until 8){
                res(i*8+j) := data(width-(i*8)+j-8)
            }
        }
        res.asUInt()
    }
}

object CONFIG{
    def DATA_WIDTH = 512
    def MTU = 4096
    def MTU_WORD = MTU/64
    def MAX_QPS = 1024
    def RDMA_DEFAULT_PORT = 4791
    def UDP_PROTOCOL = 17
    def IP_HEADER_LEN = 160
    def UDP_HEADER_LEN = 64
    def IBH_HEADER_LEN = 96
    def RETH_HEADER_LEN = 128
    def AETH_HEADER_LEN = 32
    def INIT_CREDIT = 800
    def RX_BUFFER_FULL = 4000
    def ACK_CREDIT = 1000
}

class IP_HEADER()extends Bundle{
    val dst_ipaddr = UInt(32.W)
    val src_ipaddr = UInt(32.W)
    val checksum = UInt(16.W)
    val protocol = UInt(8.W)
    val ttl = UInt(8.W)
    val fragment_offset = UInt(13.W)
    val flags = UInt(3.W)
    val idendification = UInt(16.W)
    val length = UInt(16.W)
    val ecn = UInt(2.W)
    val dscp = UInt(6.W)
    val version_IHL = UInt(8.W)
}

class UDP_HEADER()extends Bundle{
    val checksum = UInt(16.W)
    val length = UInt(16.W)
    val des_prot = UInt(16.W)
    val src_prot = UInt(16.W)
}


class IBH_HEADER()extends Bundle{
    val psn = UInt(24.W)
    val index_msb = UInt(7.W)
    val ack = UInt(1.W)
    val qpn = UInt(24.W)
    val index_lsb = UInt(8.W)
    val p_key = UInt(16.W)
    val res2 = UInt(8.W)
    val op_code = UInt(8.W)
}

class RETH_HEADER()extends Bundle{
    val length = UInt(32.W)
    val r_key = UInt(32.W)
    val vaddr = UInt(64.W)
}

class AETH_HEADER()extends Bundle{
    val msn = UInt(16.W)
    val iswr_ack = UInt(1.W)
	val isNAK = UInt(2.W)
    val credit = UInt(13.W)
}


object  IB_OP_CODE extends ChiselEnum{
    val	reserve0 = Value(0x0.U)
    val	RC_WRITE_FIRST = Value(0x06.U)
    val	RC_WRITE_MIDDLE = Value(0x07.U)
    val	RC_WRITE_LAST = Value(0x08.U)
    val	RC_WRITE_LAST_WITH_IMD = Value(0x09.U)
    val	RC_WRITE_ONLY = Value(0x0A.U)
    val	RC_WRITE_ONLY_WIT_IMD = Value(0x0B.U)
    val	RC_READ_REQUEST = Value(0x0C.U)
    val	RC_READ_RESP_FIRST = Value(0x0D.U)
    val	RC_READ_RESP_MIDDLE = Value(0x0E.U)
    val	RC_READ_RESP_LAST = Value(0x0F.U)
    val	RC_READ_RESP_ONLY = Value(0x10.U)
    val	RC_ACK = Value(0x11.U)
    val	RC_DIRECT_FIRST = Value(0x18.U)
    val	RC_DIRECT_MIDDLE = Value(0x19.U)
    val	RC_DIRECT_LAST = Value(0x1A.U)
    val	RC_DIRECT_ONLY = Value(0x1B.U)
    val	reserve = Value(0xFF.U)

}




object  PKG_JUDGE{

    def RETH_PKG(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_WRITE_FIRST) | (opcode === IB_OP_CODE.RC_WRITE_ONLY) | (opcode === IB_OP_CODE.RC_READ_REQUEST) | (opcode === IB_OP_CODE.RC_DIRECT_FIRST) | (opcode === IB_OP_CODE.RC_DIRECT_ONLY)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    }

    def AETH_PKG(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_READ_RESP_FIRST) | (opcode === IB_OP_CODE.RC_READ_RESP_LAST) | (opcode === IB_OP_CODE.RC_READ_RESP_ONLY) | (opcode === IB_OP_CODE.RC_ACK)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    }   




    def READ_MEM_PKG(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_READ_RESP_FIRST) | (opcode === IB_OP_CODE.RC_READ_RESP_LAST) | (opcode === IB_OP_CODE.RC_READ_RESP_ONLY) | (opcode === IB_OP_CODE.RC_READ_RESP_MIDDLE) |
            (opcode === IB_OP_CODE.RC_WRITE_FIRST) | (opcode === IB_OP_CODE.RC_WRITE_LAST) | (opcode === IB_OP_CODE.RC_WRITE_ONLY) | (opcode === IB_OP_CODE.RC_WRITE_MIDDLE)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    }     

    def HAVE_DATA(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_READ_RESP_FIRST) | (opcode === IB_OP_CODE.RC_READ_RESP_LAST) | (opcode === IB_OP_CODE.RC_READ_RESP_ONLY) | (opcode === IB_OP_CODE.RC_READ_RESP_MIDDLE) |
            (opcode === IB_OP_CODE.RC_WRITE_FIRST) | (opcode === IB_OP_CODE.RC_WRITE_LAST) | (opcode === IB_OP_CODE.RC_WRITE_ONLY) | (opcode === IB_OP_CODE.RC_WRITE_MIDDLE) |
            (opcode === IB_OP_CODE.RC_DIRECT_FIRST) | (opcode === IB_OP_CODE.RC_DIRECT_LAST) | (opcode === IB_OP_CODE.RC_DIRECT_ONLY) | (opcode === IB_OP_CODE.RC_DIRECT_MIDDLE)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    } 
    
def REQ_PKG(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_WRITE_FIRST) | (opcode === IB_OP_CODE.RC_WRITE_LAST) | (opcode === IB_OP_CODE.RC_WRITE_ONLY) | (opcode === IB_OP_CODE.RC_WRITE_MIDDLE) | (opcode === IB_OP_CODE.RC_READ_REQUEST) |
        (opcode === IB_OP_CODE.RC_DIRECT_FIRST) | (opcode === IB_OP_CODE.RC_DIRECT_LAST) | (opcode === IB_OP_CODE.RC_DIRECT_ONLY) | (opcode === IB_OP_CODE.RC_DIRECT_MIDDLE)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    } 

    def READ_RSP_PKG(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_READ_RESP_FIRST) | (opcode === IB_OP_CODE.RC_READ_RESP_LAST) | (opcode === IB_OP_CODE.RC_READ_RESP_ONLY) | (opcode === IB_OP_CODE.RC_READ_RESP_MIDDLE)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    }  
    
    def WRITE_PKG(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_WRITE_FIRST) | (opcode === IB_OP_CODE.RC_WRITE_LAST) | (opcode === IB_OP_CODE.RC_WRITE_ONLY) | (opcode === IB_OP_CODE.RC_WRITE_MIDDLE) |
        (opcode === IB_OP_CODE.RC_DIRECT_FIRST) | (opcode === IB_OP_CODE.RC_DIRECT_LAST) | (opcode === IB_OP_CODE.RC_DIRECT_ONLY) | (opcode === IB_OP_CODE.RC_DIRECT_MIDDLE)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    }

    def WR_MSG_NOT_LAST_PKG(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_WRITE_FIRST) | (opcode === IB_OP_CODE.RC_WRITE_MIDDLE) | (opcode === IB_OP_CODE.RC_DIRECT_FIRST) | (opcode === IB_OP_CODE.RC_DIRECT_MIDDLE)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    } 

    def WR_MSG_LAST_PKG(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_WRITE_LAST) | (opcode === IB_OP_CODE.RC_WRITE_ONLY) | (opcode === IB_OP_CODE.RC_DIRECT_LAST) | (opcode === IB_OP_CODE.RC_DIRECT_ONLY)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    }      

    def RD_MSG_FIRST_PKG(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_READ_RESP_FIRST) | (opcode === IB_OP_CODE.RC_READ_RESP_ONLY)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    }     
    def RD_MSG_LAST_PKG(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_READ_RESP_LAST) | (opcode === IB_OP_CODE.RC_READ_RESP_ONLY)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    }  

    def MSG_LAST_PKG(opcode:IB_OP_CODE.Type) = {
        val result = Wire(new Bool())
        when((opcode === IB_OP_CODE.RC_WRITE_LAST) | (opcode === IB_OP_CODE.RC_WRITE_ONLY) | 
        (opcode === IB_OP_CODE.RC_READ_RESP_LAST) | (opcode === IB_OP_CODE.RC_READ_RESP_ONLY) | (opcode === IB_OP_CODE.RC_READ_REQUEST)){
            result := true.B
        }.otherwise{
            result := false.B
        }
        result
    } 


}