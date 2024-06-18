package network.ip

import chisel3._
import chisel3.util._
import common._
import network.cmac._
import network.ip.arp._
import network.ip.mac_ip_encode._
import network.ip.ip_handler._
import common.storage._
import common.axi._
import common.ToZero
import common.connection._
import network.ip._
import network.ip.util._

class IPTest extends Module{
    val io = IO(new Bundle{
		//user_interface
        val s_ip_tx         =   Flipped(Decoupled(new AXIS(512)))
		val m_tcp_rx		= 	(Decoupled(new AXIS(512)))
		val m_udp_rx		= 	(Decoupled(new AXIS(512)))
		val m_roce_rx		= 	(Decoupled(new AXIS(512)))
		//mac interface
        val s_mac_rx       	=   Flipped(Decoupled(new AXIS(512)))
        val m_mac_tx        =   Decoupled(new AXIS(512))
		//arp req
        val arp_req         =   Flipped(Decoupled(UInt(32.W)))
        val arp_rsp         =   Decoupled(new mac_out)
		//
		val ip_address		= 	Input(UInt(32.W))
	})

		val mac_address 	= RegInit(0.U(48.W))
		val ip_address 		= RegInit(0.U(32.W))

		mac_address			:= Cat(ip_address(31,24),"h9D02350A00".U)
		ip_address			:= io.ip_address

		val mac_ip_encode = Module(new mac_ip_encode())
		val ip_handler = Module(new ip_handler())
		val arp = Module(new arp())
		val rx_buffer = XQueue(new AXIS(512),512)
		Collector.trigger(rx_buffer.io.almostfull.asBool(),"iptest_rx_buffer_almostfull")


		//arp
		arp.io.net_rx						 <> ip_handler.io.arp_out
		arp.io.arp_req1						 <> mac_ip_encode.io.arp_tableout
		mac_ip_encode.io.arp_tablein		 <> arp.io.arp_rsp1
		val arbiter							= SerialArbiter(AXIS(512), 2)
		arbiter.io.in(0)						<> mac_ip_encode.io.data_out
		arbiter.io.in(1)						<> arp.io.net_tx
		arbiter.io.out							<> io.m_mac_tx
   
        arp.io.arp_req2                         <> io.arp_req
        arp.io.arp_rsp2                         <> io.arp_rsp
		arp.io.mac_address						:= mac_address
		arp.io.ip_address						:= ip_address

		//encode
        mac_ip_encode.io.data_in                <> io.s_ip_tx
		mac_ip_encode.io.mac_address			<> mac_address

		//handler
        rx_buffer.io.in                   		<> io.s_mac_rx
		ip_handler.io.data_in                   <> rx_buffer.io.out

		ip_handler.io.icmp_out.ready 		 := 1.U
		ip_handler.io.tcp_out					<> io.m_tcp_rx
		ip_handler.io.udp_out					<> io.m_udp_rx
		ip_handler.io.roce_out					<> io.m_roce_rx
		ip_handler.io.ip_address				:= ip_address
		

		mac_ip_encode.io.regdefaultgateway := Cat("h01".U,ip_address(23,0))
		mac_ip_encode.io.regsubnetmask	   := "h00ffffff".U

}

