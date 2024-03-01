package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._




class User_Header()extends Bundle{
    val queue   = UInt(32.W)
    val time    = UInt(32.W)
    val des_port = = UInt(32.W)
}




class IP_Header()extends Bundle{
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

class UDP_Header()extends Bundle{
    val checksum = UInt(16.W)
    val length = UInt(16.W)
    val des_prot = UInt(16.W)
    val src_prot = UInt(16.W)
}


class IBH_Header()extends Bundle{
    val psn = UInt(24.W)
    val index_msb = UInt(7.W)
    val ack = UInt(1.W)
    val qpn = UInt(24.W)
    val index_lsb = UInt(8.W)
    val p_key = UInt(16.W)
    val res2 = UInt(8.W)
    val op_code = UInt(8.W)
}

class RETH_Header()extends Bundle{
    val length = UInt(32.W)
    val r_key = UInt(32.W)
    val vaddr = UInt(64.W)
}

class AETH_Header()extends Bundle{
    val msn = UInt(16.W)
    val iswr_ack = UInt(1.W)
	val isNAK = UInt(2.W)
    val credit = UInt(13.W)
}

