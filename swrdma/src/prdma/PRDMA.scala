package swrdma

import common.storage._
import common.axi._
import common.connection._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum


class PRDMA() extends Module{
	val io = IO(new Bundle{
        //RDMA CMD
        val s_tx_meta  		    = Flipped(Decoupled(new App_meta()))
        // //  RDMA SEND DATA
        // val s_send_data         = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        // val m_recv_data         = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        // //RDMA RECV META
        // val m_recv_meta         = (Decoupled(new RECV_META()))
        // //CQ
        // val m_cmpt_meta         = (Decoupled(new CMPT_META()))
        //MEM INTERFACE
        val m_mem_read_cmd      = (Decoupled(new Dma()))
        val s_mem_read_data	    = Flipped(Decoupled(new AXIS(512)))
        val m_mem_write_cmd     = (Decoupled(new Dma()))
        val m_mem_write_data	= (Decoupled(new AXIS(512)))
        //NETWORKER DATA
        val m_net_tx_data       = (Decoupled(new AXIS(512)))
        val s_net_rx_data       = Flipped(Decoupled(new AXIS(512)))
        //QP INIT
        val qp_init	            = Flipped(Decoupled(new Conn_init()))
        val cc_init	            = Flipped(Decoupled(new CC_init()))

        val local_ip_address    = Input(UInt(32.W))
	})



	// Collector.fire(io.qp_init)
	// Collector.fire(io.s_tx_meta)
    // Collector.fire(io.s_send_data)
    // Collector.fire(io.m_recv_meta)
    // Collector.fire(io.m_recv_data)
	// Collector.fire(io.m_net_tx_data)
	// Collector.fire(io.s_net_rx_data)

    // Collector.report(io.s_tx_meta.ready)
    // Collector.report(io.s_tx_meta.valid)     
    // Collector.report(io.s_send_data.ready)
    // Collector.report(io.s_send_data.valid)    
    // Collector.report(io.m_recv_data.ready)
    // Collector.report(io.m_recv_data.valid)
    // Collector.report(io.m_recv_meta.ready)
    // Collector.report(io.m_recv_meta.valid)
    	


    val head_process = Module(new HeadProcess())
    val reth_rshift = Module(new RSHIFT(56,CONFIG.DATA_WIDTH))
    val aeth_rshift = Module(new RSHIFT(44,CONFIG.DATA_WIDTH))
    val raw_rshift = Module(new RSHIFT(40,CONFIG.DATA_WIDTH))    

    val rx_arbiter    = SerialArbiter(new AXIS(512), 3)
    val cus_head_proc = Module(new CusHeadProcess())


    val rx_cus_router      = SerialRouter(new AXIS(512), 6)
    val rshift1 = Module(new RSHIFT(CONFIG.SWRDMA_HEADER_LEN1/8,CONFIG.DATA_WIDTH))
    val rshift2 = Module(new RSHIFT(CONFIG.SWRDMA_HEADER_LEN2/8,CONFIG.DATA_WIDTH))
    val rshift3 = Module(new RSHIFT(CONFIG.SWRDMA_HEADER_LEN3/8,CONFIG.DATA_WIDTH))  
    val rshift4 = Module(new RSHIFT(CONFIG.SWRDMA_HEADER_LEN4/8,CONFIG.DATA_WIDTH))
    val rshift5 = Module(new RSHIFT(CONFIG.SWRDMA_HEADER_LEN5/8,CONFIG.DATA_WIDTH))
    val rx_cus_arbiter      = SerialArbiter(new AXIS(512), 6)

    val rx_dispatch = Module(new RxDispatch())
    val pkg_drop = Module(new PkgDrop())
    val data_writer = Module(new DataWriter())
    val rx_cc = Module(new RX_CC())
    val rx_cc_req_arbiter = XArbiter(new CC_req(), 2)

    val handle_tx = Module(new HandleTx())
    val schedule = Module(new Schedule())
    val tx_cc = Module(new TX_CC())
    val tx_cc_req_arbiter = XArbiter(new CC_req(), 2)

    val tx_event_arbiter = XArbiter(new Event_meta(),2)
    val tx_dispatch = Module(new TxDispatch())

    val tx_cus_router      = SerialRouter(new AXIS(512), 6)
    val lshift1 = Module(new LSHIFT(CONFIG.SWRDMA_HEADER_LEN1/8,CONFIG.DATA_WIDTH))
    val lshift2 = Module(new LSHIFT(CONFIG.SWRDMA_HEADER_LEN2/8,CONFIG.DATA_WIDTH))
    val lshift3 = Module(new LSHIFT(CONFIG.SWRDMA_HEADER_LEN3/8,CONFIG.DATA_WIDTH))  
    val lshift4 = Module(new LSHIFT(CONFIG.SWRDMA_HEADER_LEN4/8,CONFIG.DATA_WIDTH))
    val lshift5 = Module(new LSHIFT(CONFIG.SWRDMA_HEADER_LEN5/8,CONFIG.DATA_WIDTH))
    val tx_cus_arbiter      = SerialArbiter(new AXIS(512), 6)


    val reth_lshift = Module(new LSHIFT(56,CONFIG.DATA_WIDTH)) 
    val aeth_lshift = Module(new LSHIFT(44,CONFIG.DATA_WIDTH))
    val raw_lshift = Module(new LSHIFT(40,CONFIG.DATA_WIDTH))

    val user_add = Module(new UserAdd())
    val head_add = Module(new HeadAdd())



    ////////////TABLE///////////////////////

    val conn_table = Module(new CONN_TABLE())
    val local_vaddr_q = Module(new MULTI_Q(UInt(64.W),512,2048))
    val vaddr_table = Module(new VaddrTable())
    val cc_table = Module(new CCTable())

     /////////////////TX/////////////////////////////////////////


	head_process.io.rx_data_in              <> io.s_net_rx_data
	head_process.io.reth_data_out	        <> reth_rshift.io.in
    head_process.io.aeth_data_out	        <> aeth_rshift.io.in
    head_process.io.raw_data_out	        <> raw_rshift.io.in

	rx_arbiter.io.in(0)						<> reth_rshift.io.out
	rx_arbiter.io.in(1)						<> aeth_rshift.io.out
    rx_arbiter.io.in(2)                     <> raw_rshift.io.out
	rx_arbiter.io.out						<> cus_head_proc.io.rx_data_in

    

	cus_head_proc.io.meta_in	        	<> head_process.io.meta_out
	cus_head_proc.io.rx_data_out	    	<> rx_cus_router.io.in
	cus_head_proc.io.swrdma_head_choice     := 1.U


    rx_cus_router.io.idx                    := 1.U
    rx_cus_router.io.out(0)                 <> rx_cus_arbiter.io.in(0)
    rx_cus_router.io.out(1)                 <> rshift1.io.in
    rx_cus_router.io.out(2)                 <> rshift2.io.in
    rx_cus_router.io.out(3)                 <> rshift3.io.in
    rx_cus_router.io.out(4)                 <> rshift4.io.in
    rx_cus_router.io.out(5)                 <> rshift5.io.in
    rx_cus_arbiter.io.in(1)                 <> rshift1.io.out
    rx_cus_arbiter.io.in(2)                 <> rshift2.io.out
    rx_cus_arbiter.io.in(3)                 <> rshift3.io.out
    rx_cus_arbiter.io.in(4)                 <> rshift4.io.out
    rx_cus_arbiter.io.in(5)                 <> rshift5.io.out



	rx_dispatch.io.meta_in                  <> cus_head_proc.io.meta_out
	rx_dispatch.io.cc_pkg_type			    := 0.U
	rx_dispatch.io.conn_req 			    <> conn_table.io.rx2conn_req
	rx_dispatch.io.conn_rsp 			    <> conn_table.io.conn2rx_rsp
    rx_dispatch.io.cc_req 			        <> rx_cc_req_arbiter.io.in(0)
	rx_dispatch.io.cc_meta_out			    <> rx_cc.io.cc_meta_in 
	rx_dispatch.io.event_meta_out           <> handle_tx.io.pkg_meta_in

	pkg_drop.io.meta_in	        	        <> rx_dispatch.io.drop_meta_out
	pkg_drop.io.rx_data_in			        <> rx_cus_arbiter.io.out
	pkg_drop.io.rx_data_out			        <> io.m_mem_write_data

	data_writer.io.meta_in	                <> rx_dispatch.io.dma_meta_out 	
	data_writer.io.vaddr_req 			    <> vaddr_table.io.rx2vaddr_req
	data_writer.io.vaddr_rsp 			    <> vaddr_table.io.vaddr2rx_rsp
	data_writer.io.read_req_pop_req  	    <> local_vaddr_q.io.pop_req
	data_writer.io.read_req_pop_rsp  	    <> local_vaddr_q.io.pop_rsp
	data_writer.io.dma_out				    <> io.m_mem_write_cmd	        
    ToZero(local_vaddr_q.io.front.valid)    
    ToZero(local_vaddr_q.io.front.bits)   

    


    rx_cc.io.cc_state_in                    <> cc_table.io.cc2rx_rsp
    rx_cc.io.cc_req                         <> rx_cc_req_arbiter.io.in(1)
    rx_cc.io.cc_meta_out                    <> handle_tx.io.cc_meta_in


	handle_tx.io.app_meta_in                <> io.s_tx_meta	        				
	handle_tx.io.local_read_addr            <> local_vaddr_q.io.push		
	handle_tx.io.priori_meta_out		    <> tx_event_arbiter.io.in(0)
	handle_tx.io.event_meta_out             <> schedule.io.meta_in

    schedule.io.cc_req                      <> tx_cc_req_arbiter.io.in(0)
    schedule.io.event_meta_out              <> tx_cc.io.cc_meta_in

             
    tx_cc.io.cc_state_in                    <> cc_table.io.cc2tx_rsp
    tx_cc.io.cc_req                         <> tx_cc_req_arbiter.io.in(1)
    tx_cc.io.cc_meta_out                    <> tx_event_arbiter.io.in(1)

	tx_dispatch.io.meta_in	                <> tx_event_arbiter.io.out   	
	tx_dispatch.io.conn_req 			    <> conn_table.io.tx2conn_req	
	tx_dispatch.io.dma_meta_out	            <> io.m_mem_read_cmd        
	tx_dispatch.io.event_meta_out		    <> user_add.io.meta_in
	   
	conn_table.io.conn_init	                <> io.qp_init 
	conn_table.io.conn2tx_rsp	            <> head_add.io.conn_state

	cc_table.io.rx2cc_req                   <> rx_cc_req_arbiter.io.out
    cc_table.io.tx2cc_req                   <> tx_cc_req_arbiter.io.out
	cc_table.io.cc_init                     <> io.cc_init

    tx_cus_router.io.in                     <> io.s_mem_read_data
    tx_cus_router.io.idx                    := 1.U
    tx_cus_router.io.out(0)                 <> tx_cus_arbiter.io.in(0)
    tx_cus_router.io.out(1)                 <> lshift1.io.in
    tx_cus_router.io.out(2)                 <> lshift2.io.in
    tx_cus_router.io.out(3)                 <> lshift3.io.in
    tx_cus_router.io.out(4)                 <> lshift4.io.in
    tx_cus_router.io.out(5)                 <> lshift5.io.in
    tx_cus_arbiter.io.in(1)                 <> lshift1.io.out
    tx_cus_arbiter.io.in(2)                 <> lshift2.io.out
    tx_cus_arbiter.io.in(3)                 <> lshift3.io.out
    tx_cus_arbiter.io.in(4)                 <> lshift4.io.out
    tx_cus_arbiter.io.in(5)                 <> lshift5.io.out
    tx_cus_arbiter.io.out                   <> user_add.io.data_in
 
	user_add.io.meta_out                    <> head_add.io.meta_in
    user_add.io.reth_data_out               <> reth_lshift.io.in 
    user_add.io.aeth_data_out               <> aeth_lshift.io.in 
    user_add.io.raw_data_out	   	        <> raw_lshift.io.in
	user_add.io.pkg_len			            := 1.U

	head_add.io.reth_data_in                 <> reth_lshift.io.out
    head_add.io.aeth_data_in                 <> aeth_lshift.io.out
    head_add.io.raw_data_in                 <> raw_lshift.io.out
    head_add.io.tx_data_out	   	            <> io.m_net_tx_data
	head_add.io.local_ip_address            := io.local_ip_address


}





  

