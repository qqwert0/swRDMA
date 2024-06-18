package network

import chisel3._
import chisel3.util._
import common._
import network.cmac._
import common.storage._
import common.axi._
import common.ToZero
import common.connection._
import network.ip.arp._
import network.ip.ip_handler._
import network.ip.mac_ip_encode._
import network.ip.util._
import network.ip._
import network.roce._
import network.roce.util._

class NetworkStack(PART_ID:Int = 0,IP_CORE_NAME: String="CMACBlackBox") extends RawModule{


    val io = IO(new Bundle{
		val pin				= 	new CMACPin
		//clock
		val net_clk 	    = Output(Clock())
		val net_rstn	    = Output(Bool())

        val drp_clk         = Input(Clock())
		val user_clk	    = Input(Clock())
		val user_arstn	    = Input(Bool())
        val sys_reset       = Input(Bool())		
		//arp req
        val arp_req         =   Flipped(Decoupled(UInt(32.W)))
        val arp_rsp         =   Decoupled(new mac_out)
		//
        //RDMA CMD
        val s_tx_meta  		    = Flipped(Decoupled(new TX_META()))
        //  RDMA SEND DATA
        val s_send_data         = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val m_recv_data         = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        //RDMA RECV META
        val m_recv_meta         = (Decoupled(new RECV_META()))
        //CQ
        val m_cmpt_meta         = (Decoupled(new CMPT_META()))
        //MEM INTERFACE
        val m_mem_read_cmd      = (Decoupled(new MEM_CMD()))
        val s_mem_read_data	    = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val m_mem_write_cmd     = (Decoupled(new MEM_CMD()))
        val m_mem_write_data	= (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        //QP INIT
        val qp_init	            = Flipped(Decoupled(new QP_INIT()))
		val ip_address			= 	Input(UInt(32.W))
		val sw_reset			= Input(Bool())
	})




	val cmac = Module(new XCMAC(PORT=PART_ID,IP_CORE_NAME=IP_CORE_NAME))
	cmac.getTCL()

	cmac.io.pin				<> io.pin
	cmac.io.drp_clk         := io.drp_clk
	cmac.io.user_clk	    := io.user_clk
	cmac.io.user_arstn	    := io.user_arstn
	cmac.io.sys_reset 		:= io.sys_reset
	cmac.io.net_clk			<> io.net_clk
	cmac.io.net_rstn		<> io.net_rstn

    val ip = withClockAndReset(io.user_clk, io.sw_reset || !io.user_arstn){Module(new IPTest())}

    val roce = withClockAndReset(io.user_clk, io.sw_reset || !io.user_arstn){Module(new ROCE_IP())}

    ip.io.s_mac_rx          <> withClockAndReset(io.user_clk, !io.user_arstn){RegSlice(2)(cmac.io.m_net_rx)}
	cmac.io.s_net_tx		<> withClockAndReset(io.user_clk, !io.user_arstn){RegSlice(2)(ip.io.m_mac_tx)}

    ip.io.s_ip_tx           <> withClockAndReset(io.user_clk, !io.user_arstn){RegSlice(2)(roce.io.m_net_tx_data)}
    roce.io.s_net_rx_data   <> withClockAndReset(io.user_clk, !io.user_arstn){RegSlice(2)(ip.io.m_roce_rx)}
	ip.io.arp_req			<> io.arp_req
	ip.io.arp_rsp			<> io.arp_rsp
	ip.io.ip_address		<> io.ip_address
    ip.io.m_tcp_rx.ready    := 1.U 
    ip.io.m_udp_rx.ready    := 1.U


    roce.io.m_mem_read_cmd			<>	io.m_mem_read_cmd
	roce.io.s_mem_read_data			<>	io.s_mem_read_data
    roce.io.m_mem_write_cmd			<>	io.m_mem_write_cmd
    roce.io.m_mem_write_data		<>	io.m_mem_write_data

    roce.io.s_tx_meta				<>	io.s_tx_meta
	roce.io.s_send_data				<>	io.s_send_data
	roce.io.m_recv_data				<>	io.m_recv_data
    roce.io.m_recv_meta				<>	io.m_recv_meta
    roce.io.m_cmpt_meta				<>	io.m_cmpt_meta
	roce.io.qp_init					<>	io.qp_init
	roce.io.local_ip_address		:= io.ip_address

	withClockAndReset(io.user_clk, !io.user_arstn){
		Collector.fire(ip.io.m_mac_tx)
		Collector.fire(ip.io.s_mac_rx)		
	}


		// class ila_net(seq:Seq[Data]) extends BaseILA(seq)
		// val instila_net = Module(new ila_net(Seq(	
		// 	ip.io.s_mac_rx,
		// 	ip.io.m_mac_tx

		// )))
		// instila_net.connect(io.user_clk)


}