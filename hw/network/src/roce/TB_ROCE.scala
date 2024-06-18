package network.roce

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._

class TB_ROCE() extends Module{
	val io = IO(new Bundle{
        //MEM INTERFACE
        val m_mem_read_cmd      = (Decoupled(new MEM_CMD()))
        val s_mem_read_data	    = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val m_mem_write_cmd     = (Decoupled(new MEM_CMD()))
        val m_mem_write_data	= (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        //NETWORKER DATA
        val m_net_tx_data       = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val s_net_rx_data       = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        //QP INIT
        val control_reg         = Input(Vec(32,UInt(32.W)))
	})


    // val fifo_read_cmd       = XQueue(new MEM_CMD(),16)
    // val fifo_read_data      = XQueue(new AXIS(CONFIG.DATA_WIDTH),16)
    // val fifo_write_cmd      = XQueue(new MEM_CMD(),16)
    // val fifo_write_data     = XQueue(new AXIS(CONFIG.DATA_WIDTH),16)

    // val fifo_net_rx         = XQueue(new AXIS(CONFIG.DATA_WIDTH),16)
    // val fifo_net_tx         = XQueue(new AXIS(CONFIG.DATA_WIDTH),16)
    // val roce = Module(new ROCE_IP())


    // val ip_addr         = RegInit(0.U(32.W))
    // val local_qpn       = RegInit(0.U(24.W))
    // val remote_qpn      = RegInit(0.U(24.W))  
    // val remote_ip       = RegInit(0.U(32.W))
    // val local_psn       = RegInit(0.U(32.W))
    // val remote_psn      = RegInit(0.U(32.W))
    // val credit          = RegInit(0.U(32.W))
    // val conn_start      = RegInit(0.U(1.W))
    // val psn_start       = RegInit(0.U(1.W))
    // val fc_start        = RegInit(0.U(1.W))
    // val rdma_cmd        = RegInit(0.U(1.W))
    // val meta_qpn        = RegInit(0.U(24.W))
    // val length          = RegInit(0.U(32.W))
    // val word            = RegInit(0.U(32.W))
    // val local_addr      = RegInit(0.U(64.W))
    // val remote_addr     = RegInit(0.U(64.W))
    // val ops             = RegInit(0.U(32.W))
    // val max_length      = RegInit(0.U(32.W))
    // val rdma_start      = RegInit(0.U(1.W))
    // val outstanding_req = RegInit(0.U(32.W))
    // val c_local_addr    = RegInit(0.U(64.W))
    // val c_remote_addr   = RegInit(0.U(64.W))   
    // val op_cnt          = RegInit(0.U(32.W)) 
    // val acc_length      = RegInit(0.U(32.W))
    // val complete_req    = RegInit(0.U(32.W))
    // val data_cnt        = RegInit(0.U(32.W))
    

    // ip_addr             := io.control_reg(0)
    // local_qpn           := io.control_reg(1)
    // remote_qpn          := io.control_reg(2)
    // remote_ip           := io.control_reg(3)
    // local_psn           := io.control_reg(4)
    // remote_psn          := io.control_reg(5)
    // credit              := io.control_reg(6)
    // conn_start          := io.control_reg(7)(0)
    // psn_start           := io.control_reg(8)(0)
    // fc_start            := io.control_reg(9)(0)

    // rdma_cmd            := io.control_reg(10)(0)
    // meta_qpn            := io.control_reg(11)
    // length              := io.control_reg(12)
    // local_addr          := Cat(io.control_reg(14),io.control_reg(13))
    // remote_addr         := Cat(io.control_reg(16),io.control_reg(15))
    // ops                 := io.control_reg(17)
    // max_length          := io.control_reg(18)
    // rdma_start          := io.control_reg(19)(0)
    // outstanding_req     := io.control_reg(20)

    // roce.io.conn_init.valid              := RegNext(!RegNext(conn_start) & conn_start)
    // roce.io.conn_init.bits.qpn           := local_qpn
    // roce.io.conn_init.bits.remote_qpn    := remote_qpn
    // roce.io.conn_init.bits.remote_ip     := remote_ip
    // roce.io.conn_init.bits.remote_udp_port := 17.U

    // roce.io.psn_init.valid               := RegNext(!RegNext(psn_start) & psn_start)
    // roce.io.psn_init.bits.qpn            := local_qpn
    // roce.io.psn_init.bits.local_psn      := local_psn

    // roce.io.fc_init.valid                := RegNext(!RegNext(fc_start) & fc_start)
    // roce.io.fc_init.bits.qpn             := local_qpn
    // roce.io.fc_init.bits.op_code         := 0.U.asTypeOf(roce.io.fc_init.bits.op_code)
    // roce.io.fc_init.bits.credit          := credit


    // roce.io.msn_init.valid              := 0.U
    // roce.io.msn_init.bits               := 0.U.asTypeOf(roce.io.msn_init.bits)

    // roce.io.s_tx_meta.valid              := 0.U
    // roce.io.s_tx_meta.bits               := 0.U.asTypeOf(roce.io.s_tx_meta.bits)    

    // roce.io.m_mem_read_cmd              <> fifo_read_cmd.io.in
    // roce.io.s_mem_read_data	            <> fifo_read_data.io.out
    // roce.io.m_mem_write_cmd             <> fifo_write_cmd.io.in
    // roce.io.m_mem_write_data	        <> fifo_write_data.io.in 
    // fifo_read_cmd.io.out              <> io.m_mem_read_cmd 
    // fifo_read_data.io.in	            <> io.s_mem_read_data 
    // fifo_write_cmd.io.out             <> io.m_mem_write_cmd 
    // fifo_write_data.io.out	        <> io.m_mem_write_data 
    // // roce.io.m_mem_read_cmd              <> io.m_mem_read_cmd
    // // roce.io.s_mem_read_data	            <> io.s_mem_read_data
    // // roce.io.m_mem_write_cmd             <> io.m_mem_write_cmd
    // // roce.io.m_mem_write_data	        <> io.m_mem_write_data 

    // roce.io.m_net_tx_data               <> fifo_net_tx.io.in 
    // roce.io.s_net_rx_data               <> fifo_net_rx.io.out    
    // fifo_net_tx.io.out        <> io.m_net_tx_data 
    // fifo_net_rx.io.in        <> io.s_net_rx_data       
    // // roce.io.m_net_tx_data               <> io.m_net_tx_data 
    // // roce.io.s_net_rx_data               <> io.s_net_rx_data 

    // roce.io.local_ip_address            := ip_addr

	// //state machine
	// val sIDLE :: sSEND_CMD :: sDONE :: Nil = Enum(3)
	// val state			= RegInit(sIDLE)

	// switch(state){
	// 	is(sIDLE){
    //         when(RegNext(!RegNext(rdma_start) & rdma_start.asBool)){
    //             c_local_addr                    := local_addr 
    //             c_remote_addr                   := remote_addr
    //             acc_length                      := 0.U
    //             op_cnt                          := 0.U
    //             state                           := sSEND_CMD
    //         }
	// 	}
	// 	is(sSEND_CMD){
    //         when(roce.io.s_tx_meta.ready & (op_cnt <= outstanding_req + complete_req)){
    //             roce.io.s_tx_meta.valid             := 1.U
    //             roce.io.s_tx_meta.bits.rdma_cmd     := rdma_cmd.asTypeOf(roce.io.s_tx_meta.bits.rdma_cmd)
    //             roce.io.s_tx_meta.bits.qpn          := meta_qpn
    //             roce.io.s_tx_meta.bits.local_vaddr  := c_local_addr
    //             roce.io.s_tx_meta.bits.remote_vaddr := c_remote_addr
    //             roce.io.s_tx_meta.bits.length       := length
    //             op_cnt                              := op_cnt + 1.U
    //             when(acc_length >= max_length){
    //                 acc_length                      := 0.U
    //                 c_local_addr                    := local_addr
    //                 c_remote_addr                   := remote_addr
    //             }.otherwise{
    //                 acc_length                      := acc_length + length
    //                 c_local_addr                    := c_local_addr + length
    //                 c_remote_addr                   := c_remote_addr + length
    //             }
    //             when(op_cnt === (ops - 1.U)){
    //                 state                           := sIDLE
    //             }
    //         }
	// 	}
	// }    


    // word        := (length/64.U)-1.U;
    // when(rdma_cmd.asBool){
    //     when(io.s_mem_read_data.fire & (data_cnt === word)){
    //         data_cnt        := 0.U
    //         complete_req    := complete_req + 1.U
    //     }.elsewhen(io.s_mem_read_data.fire){
    //         data_cnt        := data_cnt + 1.U
    //     }
    // }.otherwise{
    //     when(io.m_mem_write_data.fire & (data_cnt === word)){
    //         data_cnt        := 0.U
    //         complete_req    := complete_req + 1.U
    //     }.elsewhen(io.m_mem_write_data.fire){
    //         data_cnt        := data_cnt + 1.U
    //     }        
    // }

    // val wr_time_cnt      =  RegInit(0.U(32.W))
    // val wr_time_en         = RegInit(false.B)
    // val rd_time_cnt      =  RegInit(0.U(32.W))
    // val rd_time_en         = RegInit(false.B)

    // val total_length    = RegInit(0.U(32.W))


    // total_length    := (length * ops) / 64.U
    // // when(RegNext(!RegNext(rdma_start) & rdma_start.asBool)){
    // //     rd_time_en             := true.B
    // // }.elsewhen(total_length === io.status_reg(4)){
    // //     rd_time_en             := false.B
    // // }.otherwise{
    // //     rd_time_en             := rd_time_en
    // // }

    // // when(RegNext(!RegNext(rdma_start) & rdma_start.asBool)){
    // //     rd_time_cnt             := 0.U
    // // }.elsewhen(rd_time_en){
    // //     rd_time_cnt             := rd_time_cnt + 1.U
    // // }.otherwise{
    // //     rd_time_cnt             := rd_time_cnt
    // // }

    // // when(RegNext(!RegNext(rdma_start) & rdma_start.asBool)){
    // //     wr_time_en             := true.B
    // // }.elsewhen(total_length === io.status_reg(2)){
    // //     wr_time_en             := false.B
    // // }.otherwise{
    // //     wr_time_en             := wr_time_en
    // // }

    // // when(RegNext(!RegNext(rdma_start) & rdma_start.asBool)){
    // //     wr_time_cnt             := 0.U
    // // }.elsewhen(wr_time_en){
    // //     wr_time_cnt             := wr_time_cnt + 1.U
    // // }.otherwise{
    // //     wr_time_cnt             := wr_time_cnt
    // // }


  	// // class ila_time_cnt(seq:Seq[Data]) extends BaseILA(seq)
  	// // val mod_time_cnt = Module(new ila_time_cnt(Seq(	
    // //     rd_time_en,
    // //     rd_time_cnt,
    // //     wr_time_en,
    // //     wr_time_cnt,        
    // //     io.status_reg(4),
    // //     io.status_reg(2),
    // //     length,
    // //     ops,
    // //     total_length
  	// // )))
  	// // mod_time_cnt.connect(clock)


    // val mem_read_data_data = Wire(UInt(32.W))
    // mem_read_data_data := io.s_mem_read_data.bits.data(31,0)
  	// class ila_mem_read(seq:Seq[Data]) extends BaseILA(seq)
  	// val mod_mem_read = Module(new ila_mem_read(Seq(	
	// 	io.m_mem_read_cmd.valid,
	//   	io.m_mem_read_cmd.ready,
    // 	io.m_mem_read_cmd.bits.vaddr,
    // 	io.m_mem_read_cmd.bits.length,
    //     io.s_mem_read_data.valid,
    //     io.s_mem_read_data.ready,
    //     // mem_read_data_data,
    //     io.s_mem_read_data.bits.last
  	// )))
  	// mod_mem_read.connect(clock)


    // // val mem_write_data_data = Wire(UInt(32.W))
    // // mem_write_data_data := io.m_mem_write_data.bits.data(31,0)
  	// // class ila_mem_write(seq:Seq[Data]) extends BaseILA(seq)
  	// // val mod_mem_write = Module(new ila_mem_write(Seq(	
	// // 	// io.m_mem_write_cmd.valid,
	// //   	// io.m_mem_write_cmd.ready,
    // // 	// io.m_mem_write_cmd.bits.vaddr,
    // // 	// io.m_mem_write_cmd.bits.length,
    // //     io.m_mem_write_data.valid,
    // //     io.m_mem_write_data.ready,
    // //     mem_write_data_data,
    // //     io.m_mem_write_data.bits.last
  	// // )))
  	// // mod_mem_write.connect(clock)

  	// // class ila_meta_data(seq:Seq[Data]) extends BaseILA(seq)
  	// // val mod_meta_data = Module(new ila_meta_data(Seq(	
	// // 	roce.io.conn_init.valid,
	// //   	roce.io.conn_init.ready,
    // // 	roce.io.conn_init.bits.qpn,
    // // 	roce.io.conn_init.bits.remote_qpn,
    // //     roce.io.conn_init.bits.remote_ip,
    // //     roce.io.psn_init.valid,
    // //     roce.io.psn_init.ready,
    // //     roce.io.psn_init.bits.psn,
    // //     roce.io.fc_init.valid,
    // //     roce.io.fc_init.ready,
    // //     roce.io.fc_init.bits.credit,
    // //     roce.io.s_tx_meta.valid,
    // //     roce.io.s_tx_meta.ready,
    // //     roce.io.s_tx_meta.bits.rdma_cmd,
    // //     roce.io.s_tx_meta.bits.local_vaddr,
    // //     roce.io.s_tx_meta.bits.remote_vaddr,
    // //     roce.io.s_tx_meta.bits.length

  	// // )))
  	// // mod_meta_data.connect(clock)

  	// // class ila_net_tx(seq:Seq[Data]) extends BaseILA(seq)
    // // val net_tx_data = Wire(UInt(32.W))
    // // net_tx_data := roce.io.m_net_tx_data.bits.data(31,0)      
  	// // val mod_net_tx = Module(new ila_net_tx(Seq(	
	// // 	roce.io.m_net_tx_data.valid,
	// //   	roce.io.m_net_tx_data.ready,
    // // 	net_tx_data,
    // //     roce.io.m_net_tx_data.bits.last

  	// // )))
  	// // mod_net_tx.connect(clock)

  	// // class ila_net_rx(seq:Seq[Data]) extends BaseILA(seq)
    // // val net_rx_data = Wire(UInt(32.W))
    // // net_rx_data := roce.io.s_net_rx_data.bits.data(31,0)       
  	// // val mod_net_rx = Module(new ila_net_rx(Seq(	
	// // 	roce.io.s_net_rx_data.valid,
	// //   	roce.io.s_net_rx_data.ready,
    // // 	net_rx_data,
    // //     roce.io.s_net_rx_data.bits.last
  	// // )))
  	// // mod_net_rx.connect(clock)



}