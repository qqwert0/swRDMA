package network.roce

import common.storage._
import common.Delay
import common.connection._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import network.roce._
import network.ip.util._
import network.ip._
import common.Collector
import common.ToZero

class IP_LOOP() extends Module{
	val io = IO(new Bundle{

        val s_tx_meta  		    = Vec(2,Flipped(Decoupled(new TX_META())))

        val s_send_data         = Vec(2,Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH))))
        val m_recv_data         = Vec(2,(Decoupled(new AXIS(CONFIG.DATA_WIDTH))))
        val m_recv_meta         = Vec(2,(Decoupled(new RECV_META())))
        val m_cmpt_meta         = Vec(2,(Decoupled(new CMPT_META())))


        val m_mem_read_cmd      = Vec(2,(Decoupled(new MEM_CMD())))
        val s_mem_read_data	    = Vec(2,Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH))))
        val m_mem_write_cmd     = Vec(2,(Decoupled(new MEM_CMD())))
        val m_mem_write_data	= Vec(2,(Decoupled(new AXIS(CONFIG.DATA_WIDTH))))


        val qp_init	            = Vec(2,Flipped(Decoupled(new QP_INIT())))
        val local_ip_address    = Vec(2,Input(UInt(32.W)))

        val arp_req             =   Vec(2,Flipped(Decoupled(UInt(32.W))))
        val arp_rsp             =   Vec(2,Decoupled(new mac_out))        

        val status              = Output(Vec(512,UInt(32.W)))
	})


    val roce = Seq.fill(2)(Module(new ROCE_IP()))

    val q = XQueue(2)(new AXIS(CONFIG.DATA_WIDTH), 16)

    val ip = Seq.fill(2)(Module(new IPTest()))



    for(i<- 0 until 2){
        roce(i).io.m_net_tx_data        <> ip(i).io.s_ip_tx
        ip(i).io.m_mac_tx               <> q(i).io.in
        ip(i).io.m_tcp_rx.ready         := 1.U
        ip(i).io.m_udp_rx.ready         := 1.U   
        ip(i).io.arp_req                <> io.arp_req(i) 
        ip(i).io.arp_rsp                <> io.arp_rsp(i) 

        io.s_tx_meta(i)                 <> roce(i).io.s_tx_meta  	        
        io.qp_init(i)                   <> roce(i).io.qp_init
        io.local_ip_address(i)          <> roce(i).io.local_ip_address
        io.m_mem_read_cmd(i)            <> roce(i).io.m_mem_read_cmd 
        io.s_mem_read_data(i)           <> roce(i).io.s_mem_read_data 
        io.m_mem_write_cmd(i)           <> roce(i).io.m_mem_write_cmd 
        io.m_mem_write_data(i)          <> roce(i).io.m_mem_write_data    
        io.s_send_data(i)               <> roce(i).io.s_send_data     
        io.m_recv_data(i)               <> roce(i).io.m_recv_data   
        io.m_recv_meta(i)               <> roce(i).io.m_recv_meta   
        io.m_cmpt_meta(i)               <> roce(i).io.m_cmpt_meta   
    } 

    ip(0).io.s_mac_rx                       <> Delay(q(1).io.out,800)
    roce(0).io.s_net_rx_data                <> ip(0).io.m_roce_rx
    ip(1).io.s_mac_rx                       <> Delay(q(0).io.out,800)
    roce(1).io.s_net_rx_data                <> ip(1).io.m_roce_rx

    ip(0).io.ip_address                       := "h01bda8c0".U
    ip(1).io.ip_address                       := "h02bda8c0".U

    ToZero(io.status)

    Collector.connect_to_status_reg(io.status,0)
    
}