package swrdma

import common.storage._
import common.Delay
import common.connection._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector
import common.ToZero

class PRDMA_LOOP() extends Module{
	val io = IO(new Bundle{

        val s_tx_meta  		    = Vec(2,Flipped(Decoupled(new Total_meta())))

        // val s_send_data         = Vec(2,Flipped(Decoupled(new AXIS(512))))
        // val m_recv_data         = Vec(2,(Decoupled(new AXIS(512))))
        // val m_recv_meta         = Vec(2,(Decoupled(new RECV_META())))
        // val m_cmpt_meta         = Vec(2,(Decoupled(new CMPT_META())))


        val m_mem_read_cmd      = Vec(2,(Decoupled(new Dma())))
        val s_mem_read_data	    = Vec(2,Flipped(Decoupled(new AXIS(512))))
        val m_mem_write_cmd     = Vec(2,(Decoupled(new Dma())))
        val m_mem_write_data	= Vec(2,(Decoupled(new AXIS(512))))


        val qp_init	            = Vec(2,Flipped(Decoupled(new Conn_init())))
        val cc_init	            = Vec(2,Flipped(Decoupled(new CC_init())))
        val local_ip_address    = Vec(2,Input(UInt(32.W)))

        val arp_req             =   Vec(2,Flipped(Decoupled(UInt(32.W))))
        val arpinsert           =   Vec(2,Flipped(Decoupled(UInt(81.W))))
        val arp_rsp             =   Vec(2,Decoupled(new mac_out))

        val axi0                = Vec(2,(new AXI(33, 256, 6, 0, 4)))
        val axi1                = Vec(2,(new AXI(33, 256, 6, 0, 4)))        

        val cpu_started         = Vec(2,Input(Bool()))   
        val pkg_num             = Vec(2,Input(UInt(32.W)))   
        val status              = Output(Vec(512,UInt(32.W)))
	})


    val roce = Seq.fill(2)(Module(new PRDMA()))

    val msg_send = Seq.fill(2)(Module(new MsgSend()))

    val write_host = Seq.fill(2)(Module(new WriteHost()))
    val read_host = Seq.fill(2)(Module(new ReadHost()))

    val q = XQueue(2)(new AXIS(512), 16)

    val ip = Seq.fill(2)(Module(new IPTest()))



    for(i<- 0 until 2){
        roce(i).io.m_net_tx_data        <> ip(i).io.s_ip_tx
        ip(i).io.m_mac_tx               <> q(i).io.in
        ip(i).io.m_tcp_rx.ready         := 1.U
        ip(i).io.m_udp_rx.ready         := 1.U   
        ip(i).io.arp_req                <> io.arp_req(i) 
        ip(i).io.arpinsert              <> io.arpinsert(i)
        ip(i).io.arp_rsp                <> io.arp_rsp(i) 

        roce(i).io.s_tx_meta			<> msg_send(i).io.app_meta_out
        io.s_tx_meta(i)                 <> msg_send(i).io.app_meta_in  	        
        io.qp_init(i)                   <> roce(i).io.qp_init
        io.cc_init(i)                   <> roce(i).io.cc_init
        io.local_ip_address(i)          <> roce(i).io.local_ip_address
        io.s_mem_read_data(i)           <> read_host(i).io.memData 

        read_host(i).io.m_mem_read_cmd            <> roce(i).io.m_mem_read_cmd 
        read_host(i).io.s_mem_read_data           <> roce(i).io.s_mem_read_data

	    read_host(i).io.cpuReq.valid		<> io.m_mem_read_cmd(i).valid
	    read_host(i).io.cpuReq.ready		<> io.m_mem_read_cmd(i).ready
	    read_host(i).io.cpuReq.bits.addr	<> io.m_mem_read_cmd(i).bits.vaddr
	    read_host(i).io.cpuReq.bits.size	<> io.m_mem_read_cmd(i).bits.length

        

        write_host(i).io.m_mem_write_cmd    <> roce(i).io.m_mem_write_cmd
        write_host(i).io.m_mem_write_data   <> roce(i).io.m_mem_write_data
        write_host(i).io.address            <> 10000.U
        write_host(i).io.pkg_num            <> io.pkg_num(i)
	    write_host(i).io.cpuReq.valid		<> io.m_mem_write_cmd(i).valid
	    write_host(i).io.cpuReq.ready		<> io.m_mem_write_cmd(i).ready
	    write_host(i).io.cpuReq.bits.addr	<> io.m_mem_write_cmd(i).bits.vaddr
	    write_host(i).io.cpuReq.bits.size	<> io.m_mem_write_cmd(i).bits.length
        io.m_mem_write_data(i)          <> write_host(i).io.memData
        roce(i).io.cpu_started          := io.cpu_started(i)
        roce(i).io.tx_delay             := 1.U


        // roce(i).io.axi(0).ar.ready      := 1.U
        // roce(i).io.axi(0).aw.ready      := 1.U
        // roce(i).io.axi(0).w.ready       := 1.U
        // ToZero(roce(i).io.axi(0).r.valid)
        // ToZero(roce(i).io.axi(0).r.bits)
        // roce(i).io.axi(0).b.valid       := 1.U
        // ToZero(roce(i).io.axi(0).b.bits)        

        // roce(i).io.axi(1).ar.ready      := 1.U
        // roce(i).io.axi(1).aw.ready      := 1.U
        // roce(i).io.axi(1).w.ready       := 1.U
        // ToZero(roce(i).io.axi(1).r.valid)
        // ToZero(roce(i).io.axi(1).r.bits)
        // roce(i).io.axi(1).b.valid       := 1.U
        // ToZero(roce(i).io.axi(1).b.bits) 
        // io.s_send_data(i)               <> roce(i).io.s_send_data     
        // io.m_recv_data(i)               <> roce(i).io.m_recv_data   
        // io.m_recv_meta(i)               <> roce(i).io.m_recv_meta   
        // io.m_cmpt_meta(i)               <> roce(i).io.m_cmpt_meta   
    } 

    ip(0).io.s_mac_rx                       <> Delay(q(1).io.out,200)
    roce(0).io.s_net_rx_data                <> ip(0).io.m_roce_rx
    ip(1).io.s_mac_rx                       <> Delay(q(0).io.out,200)
    roce(1).io.s_net_rx_data                <> ip(1).io.m_roce_rx

    ip(0).io.ip_address                       := "h01bda8c0".U
    ip(1).io.ip_address                       := "h02bda8c0".U

    roce(0).io.axi                      <> io.axi0
    roce(1).io.axi                      <> io.axi1

    ToZero(io.status)

    Collector.connect_to_status_reg(io.status,0)
    
}