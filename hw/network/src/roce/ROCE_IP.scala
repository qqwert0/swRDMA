package network.roce

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import network.roce.table._
import network.roce.cmd_ctrl._
import network.roce.rx_exh._
import network.roce.rx_ibh._
import network.roce.rx_udpip._
import network.roce.tx_exh._
import network.roce.tx_ibh._
import network.roce.tx_udpip._



class ROCE_IP() extends Module{
	val io = IO(new Bundle{
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
        //NETWORKER DATA
        val m_net_tx_data       = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val s_net_rx_data       = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        //QP INIT
        val qp_init	            = Flipped(Decoupled(new QP_INIT()))

        val local_ip_address    = Input(UInt(32.W))
	})


	// class ila_rx_roce(seq:Seq[Data]) extends BaseILA(seq)
  	// val mod_rx_roce = Module(new ila_rx_roce(Seq(	
	// 	io.s_net_rx_data,
  	// )))
  	// mod_rx_roce.connect(clock)

	Collector.fire(io.qp_init)
	Collector.fire(io.s_tx_meta)
    Collector.fire(io.s_send_data)
    Collector.fire(io.m_recv_meta)
    Collector.fire(io.m_recv_data)
	Collector.fire(io.m_net_tx_data)
	Collector.fire(io.s_net_rx_data)

    Collector.report(io.s_tx_meta.ready)
    Collector.report(io.s_tx_meta.valid)     
    Collector.report(io.s_send_data.ready)
    Collector.report(io.s_send_data.valid)    
    Collector.report(io.m_recv_data.ready)
    Collector.report(io.m_recv_data.valid)
    Collector.report(io.m_recv_meta.ready)
    Collector.report(io.m_recv_meta.valid)
    
    ToZero(io.m_cmpt_meta.valid)
	ToZero(io.m_cmpt_meta.bits)	

    ////TX/////////////////////////////
    //reth
    val tx_pkg_route = Module(new TX_MEM_PAYLOAD())
    val reth_lshift = Module(new LSHIFT(16,CONFIG.DATA_WIDTH)) 
    val aeth_lshift = Module(new LSHIFT(4,CONFIG.DATA_WIDTH))
    val tx_append_exh = Module(new TX_ADD_EXH())

    val tx_exh_generate = Module(new TX_EXH_FSM())

    //ibh
    val ibh_lshift = Module(new LSHIFT(12,CONFIG.DATA_WIDTH))
    val tx_add_ibh = Module(new TX_ADD_IBH())

    val tx_ibh_fsm = Module(new TX_IBH_FSM())
    //udpip
    val udp_lshift = Module(new LSHIFT(8,CONFIG.DATA_WIDTH))
    val tx_add_udp = Module(new TX_ADD_UDP())
    val ip_lshift = Module(new LSHIFT(20,CONFIG.DATA_WIDTH))
    val tx_add_ip = Module(new TX_ADD_IP())
    val tx_add_crc = Module(new TX_ADD_ICRC())

    ///////RX///////////////////////////

    val rx_exh_payload = Module(new RX_EXH_PAYLOAD())
    val reth_rshift = Module(new RSHIFT(16,CONFIG.DATA_WIDTH))
    val aeth_rshift = Module(new RSHIFT(4,CONFIG.DATA_WIDTH))
	val rx_mem_payload = Module(new RX_MEM_PAYLOAD())

    val rx_data_buffer = XQueue(new AXIS(CONFIG.DATA_WIDTH),4096)

    Collector.report(rx_data_buffer.io.count > 4000.U, "rx_data_buffer_almost_full")

    val recv_data_buffer = XQueue(new AXIS(CONFIG.DATA_WIDTH),4096)

    Collector.report(recv_data_buffer.io.count > 4000.U, "recv_data_buffer_almost_full")

    val rx_exh_fsm = Module(new RX_EXH_FSM())
    val rx_exh_ack = Module(new RX_EXH_ACK())

    //ibh
    val rx_drop_pkg = Module(new RX_DROP_PKG())
    val rx_exh_process = Module(new RX_EXH_PROCESS())
    val ibh_rshift = Module(new RSHIFT(12,CONFIG.DATA_WIDTH))
    val rx_ibh_process = Module(new RX_IBH_PROCESS())

    val rx_ibh_fsm = Module(new RX_IBH_FSM())
    //udpip
    val udp_rshift = Module(new RSHIFT(8,CONFIG.DATA_WIDTH))
    val rx_udp_process = Module(new RX_UDP_PROCESS()) 
    val ip_rshift = Module(new RSHIFT(20,CONFIG.DATA_WIDTH))
    val rx_ip_process = Module(new RX_IP_PROCESS())
    val rx_crc_process = Module(new RX_ICRC_PROCESS())

    val rx_ip_buffer = XQueue(new AXIS(CONFIG.DATA_WIDTH),4096)
    Collector.trigger(rx_ip_buffer.io.almostfull.asBool(),"roce_rx_ip_buffer_almostfull")
    //////////EVENT_CTRL////////////////////

    val event_merge = Module(new EVENT_MERGE())
    val remote_read_handler = Module(new HANDLE_READ_REQ())
    val rdma_cmd_handler = Module(new LOCAL_CMD_HANDLER())
    val credit_judge = Module(new CREDIT_JUDGE())
    val qp_init = Module(new QP_INIT_ROUTER())

    ////////////TABLE///////////////////////

    val msn_table = Module(new MSN_TABLE())
    val local_read_vaddr_q = Module(new MULTI_Q(UInt(64.W),512,2048))
    val psn_table = Module(new PSN_TABLE())
    val conn_table = Module(new CONN_TABLE())
    val fc_table = Module(new FC_TABLE())
    val cq_table = Module(new CQ_TABLE())

     /////////////////TX/////////////////////////////////////////

	tx_pkg_route.io.pkg_info  		            <>  event_merge.io.pkg_info      
	tx_pkg_route.io.s_mem_read_data	            <>  io.s_mem_read_data
    tx_pkg_route.io.s_send_data                 <>  io.s_send_data
	reth_lshift.io.in	                        <>  tx_pkg_route.io.reth_data_out
	aeth_lshift.io.in	                        <>  tx_pkg_route.io.aeth_data_out
	tx_append_exh.io.raw_data_in	            <>  tx_pkg_route.io.raw_data_out

	tx_append_exh.io.pkg_info  		            <>  tx_exh_generate.io.pkg_type2exh
	tx_append_exh.io.header_data_in             <>  tx_exh_generate.io.head_data_out
	tx_append_exh.io.reth_data_in	            <>  reth_lshift.io.out
	tx_append_exh.io.aeth_data_in	            <>  aeth_lshift.io.out 

    tx_exh_generate.io.event_in                 <>  credit_judge.io.tx_exh_event
    tx_exh_generate.io.msn2tx_rsp               <>  msn_table.io.msn2tx_rsp 

    //ibh
    ibh_lshift.io.in                            <>  tx_append_exh.io.tx_data_out
    tx_add_ibh.io.ibh_header_in                 <>  tx_ibh_fsm.io.head_data_out  
    tx_add_ibh.io.exh_data_in	                <>  ibh_lshift.io.out

	tx_ibh_fsm.io.ibh_meta_in                   <>  tx_exh_generate.io.ibh_meta_out        
    tx_ibh_fsm.io.psn2tx_rsp                    <>  psn_table.io.psn2tx_rsp
    tx_ibh_fsm.io.conn2tx_rsp                   <>  conn_table.io.conn2tx_rsp 

    //udpip

    udp_lshift.io.in                            <>  tx_add_ibh.io.tx_data_out
	tx_add_udp.io.udpip_meta_in                 <>  tx_ibh_fsm.io.udpip_meta_out 
	tx_add_udp.io.tx_data_in                    <>  udp_lshift.io.out	   

    ip_lshift.io.in                             <>  tx_add_udp.io.tx_data_out
	tx_add_ip.io.ip_meta_in  	                <>  tx_add_udp.io.ip_meta_out
	tx_add_ip.io.tx_data_in                     <>  ip_lshift.io.out	  
    tx_add_crc.io.tx_data_in                    <>  tx_add_ip.io.tx_data_out
    io.m_net_tx_data                            <>  tx_add_crc.io.tx_data_out	    
	tx_add_ip.io.local_ip_address               <>  io.local_ip_address
    /////////////////RX/////////////////////////////////////////
    
    //udpip
    rx_ip_buffer.io.in                          <>  io.s_net_rx_data
    rx_ip_process.io.ip_addr                    <>  io.local_ip_address
    rx_crc_process.io.rx_data_in                <>  rx_ip_buffer.io.out   
    rx_ip_process.io.rx_data_in                 <>  rx_crc_process.io.rx_data_out  		        	        
    ip_rshift.io.in                             <>  rx_ip_process.io.rx_data_out
	rx_udp_process.io.rx_data_in                <>  ip_rshift.io.out         
    rx_udp_process.io.ip_meta_in                <>  rx_ip_process.io.ip_meta_out		          
	udp_rshift.io.in                            <>  rx_udp_process.io.rx_data_out	            
    //ibh
	rx_ibh_process.io.rx_ibh_data_in            <>  udp_rshift.io.out
    rx_ibh_process.io.udpip_meta_in             <>  rx_udp_process.io.udpip_meta_out
    ibh_rshift.io.in                            <>  rx_ibh_process.io.rx_ibh_data_out

	rx_exh_process.io.rx_exh_data_in            <>  ibh_rshift.io.out
    rx_exh_process.io.ibh_meta_in               <>  rx_ibh_process.io.ibh_meta_out
		    		    
	rx_ibh_fsm.io.ibh_meta_in                   <>  rx_exh_process.io.ibh_meta_out
    rx_ibh_fsm.io.psn2rx_rsp                    <>  psn_table.io.psn2rx_rsp

    rx_drop_pkg.io.drop_info  		            <>  rx_ibh_fsm.io.drop_info_out
    rx_drop_pkg.io.rx_meta_in		            <>  rx_ibh_fsm.io.ibh_meta_out
    rx_drop_pkg.io.rx_data_in		            <>  rx_exh_process.io.rx_exh_data_out
    //reth    
    rx_exh_payload.io.pkg_info  	            <>  rx_exh_fsm.io.pkg_type2exh	
    rx_exh_payload.io.rx_ibh_data_in            <>  rx_drop_pkg.io.rx_data_out

    reth_rshift.io.in                           <>  rx_exh_payload.io.reth_data_out
    aeth_rshift.io.in                           <>  rx_exh_payload.io.aeth_data_out


	rx_mem_payload.io.pkg_info  		        <>  rx_exh_fsm.io.pkg_type2mem
	rx_mem_payload.io.reth_data_in	            <>  reth_rshift.io.out
	rx_mem_payload.io.aeth_data_in              <>  aeth_rshift.io.out
	rx_mem_payload.io.raw_data_in	            <>  rx_exh_payload.io.raw_data_out
    rx_data_buffer.io.in                        <>  rx_mem_payload.io.m_mem_write_data
    io.m_mem_write_data	                        <>  rx_data_buffer.io.out
    recv_data_buffer.io.in                      <>  rx_mem_payload.io.m_recv_data
    io.m_recv_data                              <>  recv_data_buffer.io.out

	rx_exh_fsm.io.ibh_meta_in                   <>  rx_exh_ack.io.meta_out
    rx_exh_fsm.io.msn2rx_rsp                    <>  msn_table.io.msn2rx_rsp
    rx_exh_fsm.io.l_read_req_pop_rsp            <>  local_read_vaddr_q.io.pop_rsp
	rx_exh_fsm.io.m_mem_write_cmd               <>  io.m_mem_write_cmd
    rx_exh_fsm.io.m_recv_meta                   <>  io.m_recv_meta

    rx_exh_ack.io.meta_in                       <>  rx_drop_pkg.io.rx_meta_out
   
    ///////////////////////////EVENT CTRL///////////////////////    

    rdma_cmd_handler.io.s_tx_meta  		        <>  io.s_tx_meta
	
	io.m_mem_read_cmd                           <>	event_merge.io.m_mem_read_cmd

	remote_read_handler.io.remote_read_req      <>  rx_exh_fsm.io.r_read_req_req

	event_merge.io.rx_ack_event                 <>  rx_exh_fsm.io.ack_event
	event_merge.io.remote_read_event            <>	remote_read_handler.io.remote_read_event
	event_merge.io.tx_local_event	            <>  rdma_cmd_handler.io.tx_local_event  
    event_merge.io.credit_ack_event             <>  fc_table.io.ack_event

	credit_judge.io.exh_event                   <>  event_merge.io.tx_exh_event
    credit_judge.io.ack_event                   <>  event_merge.io.tx_ack_event         
    credit_judge.io.fc2tx_rsp                   <>  fc_table.io.fc2tx_rsp
    credit_judge.io.fc2ack_rsp                  <>  fc_table.io.fc2ack_rsp

    qp_init.io.qp_init                          <>  io.qp_init

    /////////////////////   TABLE   ////////////////////////

	msn_table.io.rx2msn_req                     <>  rx_exh_fsm.io.rx2msn_req
    msn_table.io.rx2msn_wr                      <>  rx_exh_fsm.io.rx2msn_wr
	msn_table.io.tx2msn_req	                    <>  tx_exh_generate.io.tx2msn_req
	msn_table.io.msn_init	                    <>  qp_init.io.msn_init
		
	local_read_vaddr_q.io.push                  <>  rdma_cmd_handler.io.local_read_addr
	local_read_vaddr_q.io.pop_req               <>  rx_exh_fsm.io.l_read_req_pop_req

	psn_table.io.rx2psn_req                     <>  rx_ibh_fsm.io.rx2psn_req	
	psn_table.io.tx2psn_req	                    <>  tx_ibh_fsm.io.tx2psn_req
	psn_table.io.psn_init	                    <>  qp_init.io.psn_init
		   
	fc_table.io.rx2fc_req                       <>  rx_exh_ack.io.rx2fc_req	
	fc_table.io.tx2fc_req	                    <>  credit_judge.io.tx2fc_req
    fc_table.io.tx2fc_ack	                    <>  credit_judge.io.tx2fc_ack
    fc_table.io.buffer_cnt	                    <>  recv_data_buffer.io.count
    fc_table.io.fc_init                         <>  qp_init.io.fc_init		  	

    conn_table.io.tx2conn_req	                <>  tx_ibh_fsm.io.tx2conn_req
	conn_table.io.conn_init	                    <>  qp_init.io.conn_init

    cq_table.io.dir_wq_req                      <>  tx_add_udp.io.dir_wq_req
	cq_table.io.rq_req                          <>  rx_exh_fsm.io.rq_req
    cq_table.io.cq_init_req                     <>  qp_init.io.cq_init
	cq_table.io.cmpt_meta                       <>  io.m_cmpt_meta

}