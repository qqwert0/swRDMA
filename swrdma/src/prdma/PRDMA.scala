package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum


class PRDMA() extends Module{
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
    
    ToZero(io.m_cmpt_meta.valid)
	ToZero(io.m_cmpt_meta.bits)	


    val head_process = Module(new HeadProcess())
    val reth_rshift = Module(new RSHIFT(56,CONFIG.DATA_WIDTH))
    val aeth_rshift = Module(new RSHIFT(44,CONFIG.DATA_WIDTH))
    val raw_rshift = Module(new RSHIFT(40,CONFIG.DATA_WIDTH))    

    val rdma_arbiter    = SerialArbiter(AXIS(512), 3)

    val cus_router      = SerialRouter(AXIS(512), 6)

    val rshift1 = Module(new RSHIFT(CONFIG.SWRDMA_HEADER_LEN1,CONFIG.DATA_WIDTH))
    val rshift2 = Module(new RSHIFT(CONFIG.SWRDMA_HEADER_LEN2,CONFIG.DATA_WIDTH))
    val rshift3 = Module(new RSHIFT(CONFIG.SWRDMA_HEADER_LEN3,CONFIG.DATA_WIDTH))  
    val rshift4 = Module(new RSHIFT(CONFIG.SWRDMA_HEADER_LEN4,CONFIG.DATA_WIDTH))
    val rshift5 = Module(new RSHIFT(CONFIG.SWRDMA_HEADER_LEN5,CONFIG.DATA_WIDTH))

    val rdma_arbiter      = SerialArbiter(AXIS(512), 6)

    val rx_dispatch = Module(new RxDispatch())
    val pkg_drop = Module(new PkgDrop())
    val data_writer = Module(new DataWriter())


    val handle_tx = Module(new HandleTx())

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

    
    //udpip


    

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


}