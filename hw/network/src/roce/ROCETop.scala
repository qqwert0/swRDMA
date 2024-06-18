// package network.roce

// import chisel3._
// import chisel3.util._
// import common._
// import common.storage._
// import common.axi._
// import common.ToZero
// import qdma._
// import network.cmac._
// import network.roce._
// import network.roce.util._

// class ROCETop extends RawModule{
// 	val cmac_pin		= IO(new CMACPin())
//     val qdma_pin		= IO(new QDMAPin())
// 	val led 			= IO(Output(UInt(1.W)))
// 	val sys_100M_0_p	= IO(Input(Clock()))
//   	val sys_100M_0_n	= IO(Input(Clock()))

// 	led := 0.U

// 	val mmcm = Module(new MMCME4_ADV_Wrapper(
// 		CLKFBOUT_MULT_F 		= 20,
// 		MMCM_DIVCLK_DIVIDE		= 2,
// 		MMCM_CLKOUT0_DIVIDE_F	= 4,
// 		MMCM_CLKOUT1_DIVIDE_F	= 10,
		
// 		MMCM_CLKIN1_PERIOD 		= 10
// 	))


// 	mmcm.io.CLKIN1	:= IBUFDS(sys_100M_0_p, sys_100M_0_n)
// 	mmcm.io.RST		:= 0.U

// 	val dbg_clk 	= BUFG(mmcm.io.CLKOUT1)
// 	dontTouch(dbg_clk)

// 	val user_clk = BUFG(mmcm.io.CLKOUT0)
// 	val user_rstn = mmcm.io.LOCKED


// 	val cmac = Module(new XCMAC())
//     cmac_pin		        <> cmac.io.pin
//     cmac.io.sys_reset       := !user_rstn
//     cmac.io.drp_clk         := dbg_clk
// 	cmac.io.user_clk	    := user_clk
// 	cmac.io.user_arstn	    := user_rstn
	
    

// 	val qdma = Module(new QDMA("2021"))
//     qdma.io.pin         <> qdma_pin
// 	qdma.io.user_clk	:= user_clk
// 	qdma.io.user_arstn	:= user_rstn
// 	val axi_slave = withClockAndReset(qdma.io.pcie_clk,!qdma.io.pcie_arstn){Module(new SimpleAXISlave(new AXIB))}
// 	axi_slave.io.axi	<> qdma.io.axib

// 	val control_reg = qdma.io.reg_control
// 	val status_reg = qdma.io.reg_status
//     ToZero(qdma.io.reg_status)
//     val soft_reset = Wire(Bool())
//     withClockAndReset(user_clk,false.B){
//         val soft_reset_reg = RegInit(true.B)
//         soft_reset_reg      := (!user_rstn) | control_reg(99)(0)  
//         soft_reset      := soft_reset_reg      
//     }




//     withClockAndReset(user_clk,soft_reset){
//         val roce = Module(new ROCE_IP())

//         roce.io.m_net_tx_data           <> cmac.io.s_net_tx
//         roce.io.s_net_rx_data           <> cmac.io.m_net_rx

//         qdma.io.h2c_cmd.valid                       <> roce.io.m_mem_read_cmd.valid
//         qdma.io.h2c_cmd.ready                       <> roce.io.m_mem_read_cmd.ready
//         qdma.io.h2c_cmd.bits.addr                   <> roce.io.m_mem_read_cmd.bits.vaddr		
//         qdma.io.h2c_cmd.bits.len 		            <> roce.io.m_mem_read_cmd.bits.length
//         qdma.io.h2c_cmd.bits.eop					:= 1.U
//         qdma.io.h2c_cmd.bits.sop					:= 1.U
//         qdma.io.h2c_cmd.bits.mrkr_req			    := 0.U
//         qdma.io.h2c_cmd.bits.sdi					:= 0.U
//         qdma.io.h2c_cmd.bits.qid					:= 0.U
//         qdma.io.h2c_cmd.bits.error				    := 0.U
//         qdma.io.h2c_cmd.bits.func				    := 0.U
//         qdma.io.h2c_cmd.bits.cidx				    := 0.U
//         qdma.io.h2c_cmd.bits.port_id				:= 0.U
//         qdma.io.h2c_cmd.bits.no_dma				    := 0.U

//         qdma.io.h2c_data.valid                      <> roce.io.s_mem_read_data.valid
//         qdma.io.h2c_data.ready                      <> roce.io.s_mem_read_data.ready
//         qdma.io.h2c_data.bits.data				    <> roce.io.s_mem_read_data.bits.data
//         qdma.io.h2c_data.bits.last				    <> roce.io.s_mem_read_data.bits.last
//         roce.io.s_mem_read_data.bits.keep           := "hffffffffffffffff".U  

//         qdma.io.c2h_cmd.valid                       <> roce.io.m_mem_write_cmd.valid
//         qdma.io.c2h_cmd.ready                       <> roce.io.m_mem_write_cmd.ready
//         qdma.io.c2h_cmd.bits.addr 		            <> roce.io.m_mem_write_cmd.bits.vaddr
//         qdma.io.c2h_cmd.bits.len 		            <> roce.io.m_mem_write_cmd.bits.length
//         qdma.io.c2h_cmd.bits.qid 				    := 0.U
//         qdma.io.c2h_cmd.bits.error 				    := 0.U
//         qdma.io.c2h_cmd.bits.func 				    := 0.U
//         qdma.io.c2h_cmd.bits.port_id 			    := 0.U
//         qdma.io.c2h_cmd.bits.pfch_tag 			    := 0.U
        
//         qdma.io.c2h_data.valid                      <> roce.io.m_mem_write_data.valid
//         qdma.io.c2h_data.ready                      <> roce.io.m_mem_write_data.ready
//         qdma.io.c2h_data.bits.data			        <> roce.io.m_mem_write_data.bits.data
//         qdma.io.c2h_data.bits.last			        <> roce.io.m_mem_write_data.bits.last
//         qdma.io.c2h_data.bits.tcrc			        := 0.U 
//         qdma.io.c2h_data.bits.ctrl_marker		    := 0.U 
//         qdma.io.c2h_data.bits.ctrl_ecc		        := 0.U 
//         qdma.io.c2h_data.bits.ctrl_len		        := 0.U 
//         qdma.io.c2h_data.bits.ctrl_port_id	        := 0.U 
//         qdma.io.c2h_data.bits.ctrl_qid		        := 0.U 
//         qdma.io.c2h_data.bits.ctrl_has_cmpt	        := 0.U 
//         qdma.io.c2h_data.bits.mty				    := 0.U 


//         roce.io.local_ip_address                    := "h00000a01".U
//     }
// }