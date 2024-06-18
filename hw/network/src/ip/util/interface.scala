package network.ip.util

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum

class mac_out extends Bundle{
    val mac_addr            = UInt(48.W)
    val hit               = UInt(1.W)
}

 class arp_in extends Bundle {
    val Tar_protocol_addr     = (UInt(32.W))
    val Tar_hardware_addr     = (UInt(48.W))
    val Send_protocol_addr    = (UInt(32.W))
    val Send_hardware_addr    = (UInt(48.W))
    val operation             = (UInt(16.W))
    val Protocol_len          = (UInt(8.W))
    val Hardware_len          = (UInt(8.W))
    val Protocol_type         = (UInt(16.W))
    val Hardware_type         = (UInt(16.W))
    val Tehernet_type         = (UInt(16.W))
    val mac_source            = (UInt(48.W))
    val mac_destination       = (UInt(48.W))
}