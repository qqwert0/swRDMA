package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum

class mac_out extends Bundle{
    val mac_addr            = UInt(48.W)
    val hit               = UInt(1.W)
}

 class arp_in extends Bundle {
    val Tar_protocol_addr     = Wire(UInt(32.W))
    val Tar_hardware_addr     = Wire(UInt(48.W))
    val Send_protocol_addr    = Wire(UInt(32.W))
    val Send_hardware_addr    = Wire(UInt(48.W))
    val operation             = Wire(UInt(16.W))
    val Protocol_len          = Wire(UInt(8.W))
    val Hardware_len          = Wire(UInt(8.W))
    val Protocol_type         = Wire(UInt(16.W))
    val Hardware_type         = Wire(UInt(16.W))
    val Tehernet_type         = Wire(UInt(16.W))
    val mac_source            = Wire(UInt(48.W))
    val mac_destination       = Wire(UInt(48.W))
}