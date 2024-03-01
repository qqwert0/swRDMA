package cmac

import chisel3._
import chisel3.util._

class CMACBlackBox(IP_CORE_NAME: String="CMACBlackBox") extends BlackBox{
    override val desiredName = IP_CORE_NAME
	val io = IO(new Bundle{
        
		val sys_reset 					= Input(Bool())
		val gt_ref_clk_p 			    = Input(Clock())
		val gt_ref_clk_n 				= Input(Clock())
        val init_clk                    = Input(Clock())

		val gt_txp_out					= Output(UInt(4.W))
		val gt_txn_out					= Output(UInt(4.W))
		val gt_rxp_in					= Input(UInt(4.W))
		val gt_rxn_in					= Input(UInt(4.W))

        //user clks
        val gt_txusrclk2                = Output(Clock())
        val usr_rx_reset                = Output(Bool())
        val gt_rxusrclk2                = Output(Clock())
        val rx_clk                      = Input(Clock())


        val gt_loopback_in              = Input(UInt(12.W))
        val gtwiz_reset_tx_datapath     = Input(UInt(1.W))
        val gtwiz_reset_rx_datapath     = Input(UInt(1.W))

        //data stream
        val rx_axis_tvalid              = Output(UInt(1.W))
        val rx_axis_tdata               = Output(UInt(512.W))
        val rx_axis_tlast               = Output(UInt(1.W))
        val rx_axis_tkeep               = Output(UInt(64.W))

        val tx_axis_tready              = Output(UInt(1.W))
        val tx_axis_tvalid              = Input(UInt(1.W))
        val tx_axis_tdata               = Input(UInt(512.W))
        val tx_axis_tlast               = Input(UInt(1.W))
        val tx_axis_tkeep               = Input(UInt(64.W))
        val tx_axis_tuser               = Input(UInt(1.W))

        //ctrl interface
        val ctl_rx_enable               = Input(UInt(1.W))
        val ctl_rx_force_resync         = Input(UInt(1.W))
        val ctl_rx_test_pattern         = Input(UInt(1.W))
        val core_rx_reset               = Input(UInt(1.W))

        val ctl_tx_enable               = Input(UInt(1.W))
        val ctl_tx_send_idle            = Input(UInt(1.W))
        val ctl_tx_send_rfi             = Input(UInt(1.W))
        val ctl_tx_send_lfi             = Input(UInt(1.W))
        val ctl_tx_test_pattern         = Input(UInt(1.W))
        val core_tx_reset               = Input(UInt(1.W))

        // val tx_ovfout                   = Output(UInt(1.W))
        // val tx_unfout                   = Output(UInt(1.W))
        val tx_preamblein               = Input(UInt(56.W))

        // //state interface
        val stat_rx_aligned             = Output(UInt(1.W))
        // val stat_rx_aligned_err         = Output(UInt(1.W))
        // val stat_rx_bad_code            = Output(UInt(3.W))
        // val stat_rx_bad_fcs             = Output(UInt(3.W))
        // val stat_rx_bad_preamble        = Output(UInt(1.W))
        // val stat_rx_bad_sfd             = Output(UInt(1.W))

        //drp interface
        val usr_tx_reset                = Output(Bool())
        val core_drp_reset              = Input(UInt(1.W))
        val drp_clk                     = Input(UInt(1.W))
        val drp_addr                    = Input(UInt(10.W))
        val drp_di                      = Input(UInt(16.W))
        val drp_en                      = Input(UInt(1.W))
        // val drp_do                      = Output(UInt(16.W))
        // val drp_rdy                     = Output(UInt(1.W))
        val drp_we                      = Input(UInt(1.W))


	})
}