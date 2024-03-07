package demo
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._




class infor_input()extends Bundle{
    val addr_read   = UInt(33.W)
    val len_read    = UInt(32.W)
    val addr_write  = UInt(33.W)
    val len_write   = UInt(32.W)
}






