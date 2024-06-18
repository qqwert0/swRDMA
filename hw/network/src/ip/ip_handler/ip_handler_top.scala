// package ip
package network.ip.ip_handler
import common.Math
import chisel3._
import chisel3.util._
import common.axi._
import common.storage._
import common._
import network.ip.util._


class ip_handler extends Module{
    val io = IO(new Bundle{
        val data_in          =   Flipped(Decoupled(new AXIS(512)))
        val arp_out          =   Decoupled(new AXIS(512))
        val tcp_out          =   Decoupled(new AXIS(512))
        val udp_out          =   Decoupled(new AXIS(512))
        val icmp_out         =   Decoupled(new AXIS(512))
        val roce_out         =   Decoupled(new AXIS(512))
        val ip_address      =   Input(UInt(32.W))
	})
    


    val count               = RegInit(UInt(2.W), 0.U)
    
    val detect_eth_protocol1 = Module(new detect_eth_protocol)
    val route_by_eth1       = Module(new route_by_eth)
    val extract_ip_meta1    = Module(new extract_ip_meta)
    val compute_checksum1   = Module(new compute_checksum)
    val ip_invalid_dropper1 = Module(new ip_invalid_dropper)
    val cut_length1         = Module(new cut_length)
    val detect_ipv4_protocol1 = Module(new detect_ipv4_protocol)
    val rshift              = Module(new RSHIFT(14,512))
    val shift_last          = RegInit(UInt(1.W), 1.U)
    io.data_in                          <> detect_eth_protocol1.io.data_in

    detect_eth_protocol1.io.data_out    <> route_by_eth1.io.data_in
    route_by_eth1.io.ipv4_out           <> rshift.io.in
    route_by_eth1.io.etherType          := detect_eth_protocol1.io.eth_protocol
    route_by_eth1.io.ARP_out            <> io.arp_out
    rshift.io.out                       <> extract_ip_meta1.io.data_in
    extract_ip_meta1.io.myip            := io.ip_address
    extract_ip_meta1.io.data_out        <> compute_checksum1.io.data_in
    compute_checksum1.io.data_out       <> ip_invalid_dropper1.io.data_in
    ip_invalid_dropper1.io.validchecksum := compute_checksum1.io.checksumvalid
    ip_invalid_dropper1.io.validipaddress:= extract_ip_meta1.io.validipaddr
    ip_invalid_dropper1.io.data_out     <> cut_length1.io.data_in
    cut_length1.io.data_out             <> detect_ipv4_protocol1.io.data_in 
    detect_ipv4_protocol1.io.type1      := extract_ip_meta1.io.ipv4Type
    detect_ipv4_protocol1.io.tcp_out    <> io.tcp_out
    detect_ipv4_protocol1.io.udp_out    <> io.udp_out
    detect_ipv4_protocol1.io.icmp_out   <> io.icmp_out
    detect_ipv4_protocol1.io.roce_out   <> io.roce_out

}