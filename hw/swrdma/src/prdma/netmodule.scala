package swrdma

import common.storage._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector


class netmodule() extends BlackBox{
	val io = IO(new Bundle{
    val dclk          = Input(Clock())
    val user_clk      = Input(Clock())
    val net_clk       = Output(Clock())
    val sys_reset     = Input(Bool())
    val aresetn       = Input(Bool())
    val network_init_done = Output(Bool())
     
    val gt_refclk_p   = Input(Clock())
    val gt_refclk_n   = Input(Clock())
    val gt_rxp_in     = Input(UInt(1.W))
    val gt_rxn_in     = Input(UInt(1.W))
    val gt_txp_out    = Output(UInt(1.W))
    val gt_txn_out    = Output(UInt(1.W))
 
    val user_rx_reset = Output(UInt(1.W))
    val user_tx_reset = Output(UInt(1.W))
    val gtpowergood_out = Output(UInt(1.W))
   
   //Axi Stream Interface
    val m_axis_net_rx_valid = Output(UInt(1.W))
    val m_axis_net_rx_ready = Input(UInt(1.W))
    val m_axis_net_rx_data  = Output(UInt(512.W))
    val m_axis_net_rx_keep  = Output(UInt(64.W))
    val m_axis_net_rx_last  = Output(UInt(1.W))

    val s_axis_net_tx_valid = Input(UInt(1.W))
    val s_axis_net_tx_ready = Output(UInt(1.W))
    val s_axis_net_tx_data  = Input(UInt(512.W))
    val s_axis_net_tx_keep  = Input(UInt(64.W))
    val s_axis_net_tx_last  = Input(UInt(1.W))


	})

}