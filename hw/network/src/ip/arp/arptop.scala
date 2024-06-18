package network.ip.arp
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import chisel3.experimental.{DataMirror, Direction, requireIsChiselType}
import network.ip.util._


class arp  extends Module{
    val io = IO(new Bundle{
        val net_rx          =   Flipped(Decoupled(new AXIS(512)))
        val net_tx          =   Decoupled(new AXIS(512))
        val arp_req1        =   Flipped(Decoupled(UInt(32.W)))
        val arp_req2        =   Flipped(Decoupled(UInt(32.W)))
        val arp_rsp1        =   Decoupled(new mac_out)
        val arp_rsp2        =   Decoupled(new mac_out)
        val mac_address     =   Input(UInt(48.W))
        val ip_address      =   Input(UInt(32.W))
	})
    val arp_table = Module(new arp_table)
    val generate_arp_pkg = Module(new generate_arp_pkg)
    val process_arp_pkg = Module(new process_arp_pkg)

    process_arp_pkg.io.data_in <> io.net_rx
    process_arp_pkg.io.mymac   := io.mac_address
    process_arp_pkg.io.myip    := io.ip_address

    generate_arp_pkg.io.replymeta   <> process_arp_pkg.io.replymeta
    generate_arp_pkg.io.requestmeta <> arp_table.io.requestmeta
    generate_arp_pkg.io.mymac       := io.mac_address
    generate_arp_pkg.io.myip        := io.ip_address
    generate_arp_pkg.io.data_out    <> io.net_tx

    arp_table.io.arpinsert          <> process_arp_pkg.io.arpinsert
    arp_table.io.arp_req1           <> io.arp_req1
    arp_table.io.arp_req2           <> io.arp_req2
    arp_table.io.mymac              := io.mac_address
    arp_table.io.myip               := io.ip_address
    
    io.arp_rsp1                     <> arp_table.io.arp_rsp1
    io.arp_rsp2                     <> arp_table.io.arp_rsp2 
    



}