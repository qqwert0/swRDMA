package network.udp

import chisel3._
import chisel3.util._
import common.axi.AXIS
import common.storage.XQueue
import network.roce.util.CONFIG
import network.roce.util.IP_HEADER
import network.roce.util.UDP_HEADER
import common.connection.Connection
import common.AddHeader
import common.SplitHeader
import common._
import network.cmac.XCMAC
import network.ip.IPTest
import network.roce.util.Util

class Udp extends RawModule{
	val io = IO(new Bundle{
		val cmacPin				= new CMACPin
		val netClk				= Output(Clock())
		val netRstn				= Output(Bool())

		val drpClk				= Input(Clock())
		val udpClk				= Input(Clock())
		val udpRstn				= Input(Bool())
		val sysReset			= Input(Bool())

		val arpReq         		= Flipped(Decoupled(UInt(32.W)))

		val sendMeta			= Flipped(Decoupled(new UdpMeta))
		val sendData			= Flipped(Decoupled(AXIS(512)))
		val recvMeta			= Decoupled(new UdpMeta)
		val recvData			= Decoupled(AXIS(512))

		val local_ip_address	= Input(UInt(32.W))
	})

	val cmac = Module(new XCMAC())
	cmac.getTCL()

	cmac.io.pin				<> io.cmacPin
	cmac.io.drp_clk         := io.drpClk
	cmac.io.user_clk	    := io.udpClk
	cmac.io.user_arstn	    := io.udpRstn
	cmac.io.sys_reset 		:= io.sysReset
	cmac.io.net_clk			<> io.netClk
	cmac.io.net_rstn		<> io.netRstn

	val ip					= withClockAndReset(io.udpClk, !io.udpRstn){Module(new IPTest())}
	val udpProcessing		= withClockAndReset(io.udpClk, !io.udpRstn){Module(new UdpProcessing())}
	
	ip.io.s_mac_rx			<> cmac.io.m_net_rx
	ip.io.m_mac_tx			<> cmac.io.s_net_tx

	ip.io.s_ip_tx			<> udpProcessing.io.netSend
	ip.io.m_udp_rx			<> udpProcessing.io.netRecv
	ip.io.m_tcp_rx.ready    := 1.U 
    ip.io.m_roce_rx.ready	:= 1.U
	ip.io.arp_req			<> io.arpReq
	ip.io.arp_rsp.ready		:= 1.U
	ip.io.ip_address		:= io.local_ip_address

	udpProcessing.io.sendMeta	<> io.sendMeta
	udpProcessing.io.sendData	<> io.sendData
	udpProcessing.io.recvMeta	<> io.recvMeta
	udpProcessing.io.recvData	<> io.recvData
}

class UdpMeta extends  Bundle{
	val dest_ip     = UInt(32.W)
	val src_ip      = UInt(32.W)
	val dest_port   = UInt(16.W)
	val src_port    = UInt(16.W)
	val length      = UInt(16.W)
}
class CompositeHeader extends Bundle{
	val udp = new UDP_HEADER
	val ip	= new IP_HEADER
}
class UdpProcessing extends Module{
	def TODO_16			= 16
	val io = IO(new Bundle{
		val sendMeta	= Flipped(Decoupled(new UdpMeta))
		val sendData	= Flipped(Decoupled(AXIS(512)))
		val recvMeta	= Decoupled(new UdpMeta)
		val recvData	= Decoupled(AXIS(512))

		val netRecv		= Flipped(Decoupled(AXIS(512)))
		val netSend		= Decoupled(AXIS(512))
	})

	val ip_header_len		= CONFIG.UDP_HEADER_LEN/8
	val	udp_header_len		= CONFIG.IP_HEADER_LEN/8

	def meta2Header(meta:UdpMeta) = {
		val header	= Wire(new CompositeHeader)
		header.ip.dst_ipaddr		:= Util.reverse(meta.dest_ip)
		header.ip.src_ipaddr		:= Util.reverse(meta.src_ip)
		header.ip.checksum			:= 0.U
		header.ip.protocol			:= CONFIG.UDP_PROTOCOL.U
		header.ip.ttl				:= "h40".U
		header.ip.fragment_offset	:= 0.U
		header.ip.flags				:= 0.U
		header.ip.idendification	:= 0.U
		header.ip.length			:= Util.reverse(meta.length+ip_header_len.U+udp_header_len.U)
		header.ip.ecn				:= 0.U
		header.ip.dscp				:= 0.U
		header.ip.version_IHL		:= "h45".U
		header.udp.checksum			:= 0.U
		header.udp.length			:= Util.reverse(meta.length+udp_header_len.U)
		header.udp.des_prot			:= Util.reverse(meta.dest_port)
		header.udp.src_prot			:= Util.reverse(meta.src_port)
		header
	}

	def header2Meta(header:CompositeHeader) = {
		val meta		= Wire(new UdpMeta)
		meta.dest_ip	:= Util.reverse(header.ip.dst_ipaddr)
		meta.src_ip		:= Util.reverse(header.ip.src_ipaddr)
		meta.dest_port	:= Util.reverse(header.udp.des_prot)
		meta.src_port	:= Util.reverse(header.udp.src_prot)
		meta.length		:= Util.reverse(header.udp.length)-udp_header_len.U
		meta
	}

	

	//send
	{
		val sendHeaderQ		= XQueue(new CompositeHeader,TODO_16)
		Connection.one2one(sendHeaderQ.io.in)(io.sendMeta)
		sendHeaderQ.io.in.bits	:= meta2Header(io.sendMeta.bits)
		val sendData			= XQueue(io.sendData,TODO_16)
		
		io.netSend				<> AddHeader(sendHeaderQ.io.out,sendData,ip_header_len+udp_header_len)
	}
	
	//recv
	{
		val recvData		= XQueue(io.netRecv,TODO_16)
		val headerQ			= XQueue(new CompositeHeader,TODO_16)
		val metaQ			= XQueue(new UdpMeta,TODO_16)
		Connection.one2one(headerQ.io.out)(metaQ.io.in)
		metaQ.io.in.bits	:= header2Meta(headerQ.io.out.bits)
		
		SplitHeader(recvData,headerQ.io.in,io.recvData,ip_header_len+udp_header_len)
	}

}