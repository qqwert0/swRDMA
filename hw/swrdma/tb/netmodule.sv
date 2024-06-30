/*
 * Copyright (c) 2019, Systems Group, ETH Zurich
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holder nor the names of its contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 `timescale 1ns / 1ps
 `default_nettype none
 
 module netmodule
 (
     input wire          dclk,
     input wire          user_clk,
     output wire         net_clk,
     input wire          sys_reset,
     input wire          aresetn,
     output wire         network_init_done,
     
     input wire          gt_refclk_p,
     input wire          gt_refclk_n,
     
   input  wire 			gt_rxp_in,
   input  wire 			gt_rxn_in,
   output wire 			gt_txp_out,
   output wire 			gt_txn_out,
 
   output wire 			user_rx_reset,
   output wire 			user_tx_reset,
   output wire        gtpowergood_out,
   
   //Axi Stream Interface
    output wire             m_axis_net_rx_valid,
    input  wire             m_axis_net_rx_ready,
    output wire [511:0]      m_axis_net_rx_data,
    output wire [63:0]       m_axis_net_rx_keep,
    output wire             m_axis_net_rx_last,

    input  wire             s_axis_net_tx_valid,
    output wire             s_axis_net_tx_ready,
    input  wire [511:0]      s_axis_net_tx_data,
    input  wire [63:0]       s_axis_net_tx_keep,
    input  wire             s_axis_net_tx_last
   

 );
 
 reg core_reset_tmp;
 reg core_reset;
 wire rx_core_clk;
 wire rx_clk_out;
 wire tx_clk_out;
 assign rx_core_clk = tx_clk_out;

 assign net_clk = tx_clk_out;
 
 wire  gtpowergood;
 wire [2:0] gt_loopback_in ;
 assign gt_loopback_in = 2'h00;

 
 always @(posedge sys_reset or posedge net_clk) begin 
    if (sys_reset) begin
       core_reset_tmp <= 1'b1;
       core_reset <= 1'b1;
    end
    else begin
       //Hold core in reset until everything is ready
       core_reset_tmp <= sys_reset | user_tx_reset | user_rx_reset;// | user_tx_reset[1] | user_rx_reset[1] | user_tx_reset[2] | user_rx_reset[2] | user_tx_reset[3] | user_rx_reset[3];
       core_reset <= core_reset_tmp;
    end
 end
 assign network_init_done = ~core_reset;
 
 assign gtpowergood_out = gtpowergood;// & gtpowergood[1] & gtpowergood[2] & gtpowergood[3];
 
 /*
  * RX
  */
 wire   		axis_rxif_to_fifo_tvalid;
 wire   		axis_rxif_to_fifo_tready;
 wire [63:0] 	axis_rxif_to_fifo_tdata;
 wire [7:0]  	axis_rxif_to_fifo_tkeep;
 wire   		axis_rxif_to_fifo_tlast;
 wire   		axis_rxif_to_fifo_tuser;
 
 //// RX_0 User Interface Signals
 wire   		rx_axis_tvalid;
 wire [63:0] 	rx_axis_tdata;
 wire [7:0]  	rx_axis_tkeep;
 wire   		rx_axis_tlast;
 wire   		rx_axis_tuser;
 wire [55:0] 	rx_preambleout;
 
 
 // RX  Control Signals
 wire ctl_rx_test_pattern;
 wire ctl_rx_test_pattern_enable;
 wire ctl_rx_data_pattern_select;
 wire ctl_rx_enable;
 wire ctl_rx_delete_fcs;
 wire ctl_rx_ignore_fcs;
 wire [14:0] ctl_rx_max_packet_len;
 wire [7:0] ctl_rx_min_packet_len;
 wire ctl_rx_custom_preamble_enable;
 wire ctl_rx_check_sfd;
 wire ctl_rx_check_preamble;
 wire ctl_rx_process_lfi;
 wire ctl_rx_force_resync;
 
 assign ctl_rx_enable              = 1'b1;
 assign ctl_rx_check_preamble      = 1'b1;
 assign ctl_rx_check_sfd           = 1'b1;
 assign ctl_rx_force_resync        = 1'b0;
 assign ctl_rx_delete_fcs          = 1'b1;
 assign ctl_rx_ignore_fcs          = 1'b0;
 assign ctl_rx_process_lfi         = 1'b0;
 assign ctl_rx_test_pattern        = 1'b0;
 assign ctl_rx_test_pattern_enable = 1'b0;
 assign ctl_rx_data_pattern_select = 1'b0;
 assign ctl_rx_max_packet_len      = 15'd8192;
 assign ctl_rx_min_packet_len      = 15'd42;
 assign ctl_rx_custom_preamble_enable = 1'b0;
 
 /*
  * TX
  */
 wire     		axis_tx_fifo_to_txif_tready;
 wire   		axis_tx_fifo_to_txif_tvalid;
 wire [63:0] 	axis_tx_fifo_to_txif_tdata;
 wire [7:0]  	axis_tx_fifo_to_txif_tkeep;
 wire   		axis_tx_fifo_to_txif_tlast;
 wire   		axis_tx_fifo_to_txif_tuser;
 
 
 wire   		axis_tx_padding_to_fifo_tvalid;
 wire   		axis_tx_padding_to_fifo_tready;
 wire [63:0] 	axis_tx_padding_to_fifo_tdata;
 wire [7:0]  	axis_tx_padding_to_fifo_tkeep;
 wire   		axis_tx_padding_to_fifo_tlast;
 
 wire   		axis_rx_convert_tvalid;
 wire   		axis_rx_convert_tready;
 wire [63:0] 	axis_rx_convert_tdata;
 wire [7:0]  	axis_rx_convert_tkeep;
 wire   		axis_rx_convert_tlast;

 //// TX Data Signals
 wire   		tx_axis_tvalid;
 wire   		tx_axis_tready;
 wire [63:0] 	tx_axis_tdata;
 wire [7:0]  	tx_axis_tkeep;
 wire   		tx_axis_tlast;
 wire   		tx_axis_tuser;
 

 
 
 //// TX_0 Control Signals
 wire ctl_tx_test_pattern;
 wire ctl_tx_test_pattern_enable;
 wire ctl_tx_test_pattern_select;
 wire ctl_tx_data_pattern_select;
 wire [57:0] ctl_tx_test_pattern_seed_a;
 wire [57:0] ctl_tx_test_pattern_seed_b;
 wire ctl_tx_enable;
 wire ctl_tx_fcs_ins_enable;
 wire [3:0] ctl_tx_ipg_value;
 wire ctl_tx_send_lfi;
 wire ctl_tx_send_rfi;
 wire ctl_tx_send_idle;
 wire ctl_tx_custom_preamble_enable;
 wire ctl_tx_ignore_fcs;
 
 assign ctl_tx_enable              = 1'b1;
 assign ctl_tx_send_rfi            = 1'b0;
 assign ctl_tx_send_lfi            = 1'b0;
 assign ctl_tx_send_idle           = 1'b0;
 assign ctl_tx_fcs_ins_enable      = 1'b1;
 assign ctl_tx_ignore_fcs          = 1'b0;
 assign ctl_tx_test_pattern        = 1'b0;
 assign ctl_tx_test_pattern_enable = 1'b0;
 assign ctl_tx_data_pattern_select = 1'b0;
 assign ctl_tx_test_pattern_select = 1'b0;
 assign ctl_tx_test_pattern_seed_a = 58'h0;
 assign ctl_tx_test_pattern_seed_b = 58'h0;
 assign ctl_tx_custom_preamble_enable = 1'b0;
 assign ctl_tx_ipg_value           = 4'd12;
 
 wire [2:0] txoutclksel_in;
 wire [2:0] rxoutclksel_in;
 
 assign txoutclksel_in = 3'b101;    // this value should not be changed as per gtwizard 
 assign rxoutclksel_in = 3'b101;    // this value should not be changed as per gtwizard
 
 wire  gt_refclk_out;
 
 
 
 ethernet1_ip ethernet_inst
 (
     .gt_refclk_p (gt_refclk_p),
     .gt_refclk_n (gt_refclk_n),
     .gt_refclk_out (gt_refclk_out),
     .sys_reset (sys_reset),
     .dclk (dclk),
 
 
     .gt_rxp_in(gt_rxp_in),
     .gt_rxn_in(gt_rxn_in),
     .gt_txp_out(gt_txp_out),
     .gt_txn_out(gt_txn_out),
     
     .tx_clk_out_0(tx_clk_out),
     .rx_core_clk_0(rx_core_clk),
     .rx_clk_out_0 (rx_clk_out),
     .gt_loopback_in_0 (gt_loopback_in),
     .rx_reset_0 (1'b0),
     .user_rx_reset_0 (user_rx_reset),
     .rxrecclkout_0 (),
     .tx_reset_0 (1'b0),
     .user_tx_reset_0 (user_tx_reset),
     .gtwiz_reset_tx_datapath_0 (1'b0),
     .gtwiz_reset_rx_datapath_0 (1'b0),
     .gtpowergood_out_0 (gtpowergood),
     .txoutclksel_in_0 (txoutclksel_in),
     .rxoutclksel_in_0 (rxoutclksel_in),
     .qpllreset_in_0 (0),
     
     

 
 
     // RX Data Signals
     .rx_axis_tvalid_0 (rx_axis_tvalid),
     .rx_axis_tdata_0 (rx_axis_tdata),
     .rx_axis_tlast_0 (rx_axis_tlast),
     .rx_axis_tkeep_0 (rx_axis_tkeep),
     .rx_axis_tuser_0 (rx_axis_tuser),
     .rx_preambleout_0 (rx_preambleout),
     

     
     // TX Data Signals
     .tx_axis_tready_0 (tx_axis_tready),
     .tx_axis_tvalid_0 (tx_axis_tvalid),
     .tx_axis_tdata_0 (tx_axis_tdata),
     .tx_axis_tlast_0 (tx_axis_tlast),
     .tx_axis_tkeep_0 (tx_axis_tkeep),
     .tx_axis_tuser_0 (tx_axis_tuser),
     .tx_unfout_0 (),
     .tx_preamblein_0 (0),
     

 
 
     //RX Control Signals
     .ctl_rx_test_pattern_0 (ctl_rx_test_pattern),
     .ctl_rx_test_pattern_enable_0 (ctl_rx_test_pattern_enable),
     .ctl_rx_data_pattern_select_0 (ctl_rx_data_pattern_select),
     .ctl_rx_enable_0 (ctl_rx_enable),
     .ctl_rx_delete_fcs_0 (ctl_rx_delete_fcs),
     .ctl_rx_ignore_fcs_0 (ctl_rx_ignore_fcs),
     .ctl_rx_max_packet_len_0 (ctl_rx_max_packet_len),
     .ctl_rx_min_packet_len_0 (ctl_rx_min_packet_len),
     .ctl_rx_custom_preamble_enable_0 (ctl_rx_custom_preamble_enable),
     .ctl_rx_check_sfd_0 (ctl_rx_check_sfd),
     .ctl_rx_check_preamble_0 (ctl_rx_check_preamble),
     .ctl_rx_process_lfi_0 (ctl_rx_process_lfi),
     .ctl_rx_force_resync_0 (ctl_rx_force_resync),
 
 
 
     //RX Stats Signals
     .stat_rx_block_lock_0 (),
     .stat_rx_framing_err_valid_0 (),
     .stat_rx_framing_err_0 (),
     .stat_rx_hi_ber_0 (),
     .stat_rx_valid_ctrl_code_0 (),
     .stat_rx_bad_code_0 (),
     .stat_rx_total_packets_0 (),
     .stat_rx_total_good_packets_0 (),
     .stat_rx_total_bytes_0 (),
     .stat_rx_total_good_bytes_0 (),
     .stat_rx_packet_small_0 (),
     .stat_rx_jabber_0 (),
     .stat_rx_packet_large_0 (),
     .stat_rx_oversize_0 (),
     .stat_rx_undersize_0 (),
     .stat_rx_toolong_0 (),
     .stat_rx_fragment_0 (),
     .stat_rx_packet_64_bytes_0 (),
     .stat_rx_packet_65_127_bytes_0 (),
     .stat_rx_packet_128_255_bytes_0 (),
     .stat_rx_packet_256_511_bytes_0 (),
     .stat_rx_packet_512_1023_bytes_0 (),
     .stat_rx_packet_1024_1518_bytes_0 (),
     .stat_rx_packet_1519_1522_bytes_0 (),
     .stat_rx_packet_1523_1548_bytes_0 (),
     .stat_rx_bad_fcs_0 (),
     .stat_rx_packet_bad_fcs_0 (),
     .stat_rx_stomped_fcs_0 (),
     .stat_rx_packet_1549_2047_bytes_0 (),
     .stat_rx_packet_2048_4095_bytes_0 (),
     .stat_rx_packet_4096_8191_bytes_0 (),
     .stat_rx_packet_8192_9215_bytes_0 (),
     .stat_rx_bad_preamble_0 (),
     .stat_rx_bad_sfd_0 (),
     .stat_rx_got_signal_os_0 (),
     .stat_rx_test_pattern_mismatch_0 (),
     .stat_rx_truncated_0 (),
     .stat_rx_local_fault_0 (),
     .stat_rx_remote_fault_0 (),
     .stat_rx_internal_local_fault_0 (),
     .stat_rx_received_local_fault_0 (),
     .stat_rx_status_0 (),
     
 
 
     // TX Control Signals
     .ctl_tx_test_pattern_0 (ctl_tx_test_pattern),
     .ctl_tx_test_pattern_enable_0 (ctl_tx_test_pattern_enable),
     .ctl_tx_test_pattern_select_0 (ctl_tx_test_pattern_select),
     .ctl_tx_data_pattern_select_0 (ctl_tx_data_pattern_select),
     .ctl_tx_test_pattern_seed_a_0 (ctl_tx_test_pattern_seed_a),
     .ctl_tx_test_pattern_seed_b_0 (ctl_tx_test_pattern_seed_b),
     .ctl_tx_enable_0 (ctl_tx_enable),
     .ctl_tx_fcs_ins_enable_0 (ctl_tx_fcs_ins_enable),
     .ctl_tx_ipg_value_0 (ctl_tx_ipg_value),
     .ctl_tx_send_lfi_0 (ctl_tx_send_lfi),
     .ctl_tx_send_rfi_0 (ctl_tx_send_rfi),
     .ctl_tx_send_idle_0 (ctl_tx_send_idle),
     .ctl_tx_custom_preamble_enable_0 (ctl_tx_custom_preamble_enable),
     .ctl_tx_ignore_fcs_0 (ctl_tx_ignore_fcs),
     

 
 
     // TX Stats Signals
     .stat_tx_total_packets_0 (),
     .stat_tx_total_bytes_0 (),
     .stat_tx_total_good_packets_0 (),
     .stat_tx_total_good_bytes_0 (),
     .stat_tx_packet_64_bytes_0 (),
     .stat_tx_packet_65_127_bytes_0 (),
     .stat_tx_packet_128_255_bytes_0 (),
     .stat_tx_packet_256_511_bytes_0 (),
     .stat_tx_packet_512_1023_bytes_0 (),
     .stat_tx_packet_1024_1518_bytes_0 (),
     .stat_tx_packet_1519_1522_bytes_0 (),
     .stat_tx_packet_1523_1548_bytes_0 (),
     .stat_tx_packet_small_0 (),
     .stat_tx_packet_large_0 (),
     .stat_tx_packet_1549_2047_bytes_0 (),
     .stat_tx_packet_2048_4095_bytes_0 (),
     .stat_tx_packet_4096_8191_bytes_0 (),
     .stat_tx_packet_8192_9215_bytes_0 (),
     .stat_tx_bad_fcs_0 (),
     .stat_tx_frame_error_0 (),
     .stat_tx_local_fault_0 ()
     

 
 );
 
 

 
 
 //wire[3:0] rx_axis_tready;
 
 //assign rx_axis_tready_cross[idx] = 1'b1; // the rx_interface does not assert backpressure!
 
 rx_interface rx_if    
 (
     .axi_str_tvalid_from_xgmac(rx_axis_tvalid),
     .axi_str_tdata_from_xgmac(rx_axis_tdata),
     .axi_str_tkeep_from_xgmac(rx_axis_tkeep),
     .axi_str_tlast_from_xgmac(rx_axis_tlast),
     .axi_str_tuser_from_xgmac(rx_axis_tuser),
 
     .axi_str_tready_from_fifo(axis_rxif_to_fifo_tready),
     .axi_str_tdata_to_fifo(axis_rxif_to_fifo_tdata),   
     .axi_str_tkeep_to_fifo(axis_rxif_to_fifo_tkeep),   
     .axi_str_tvalid_to_fifo(axis_rxif_to_fifo_tvalid),
     .axi_str_tlast_to_fifo(axis_rxif_to_fifo_tlast),
     .rd_pkt_len(),
     .rx_fifo_overflow(),
     
     .rx_statistics_vector(),
     .rx_statistics_valid(),
 
     .rd_data_count(),
 
     .user_clk(rx_core_clk),
     .reset(sys_reset | user_rx_reset)
 
 );
 
 axis_data_fifo_64_cc rx_crossing (
   .s_axis_aresetn(~(sys_reset | user_rx_reset)),          // input wire s_axis_aresetn
   .s_axis_aclk(rx_core_clk),                // input wire s_axis_aclk
   .s_axis_tvalid(axis_rxif_to_fifo_tvalid),            // input wire s_axis_tvalid
   .s_axis_tready(axis_rxif_to_fifo_tready),            // output wire s_axis_tready
   .s_axis_tdata(axis_rxif_to_fifo_tdata),              // input wire [63 : 0] s_axis_tdata
   .s_axis_tkeep(axis_rxif_to_fifo_tkeep),              // input wire [7 : 0] s_axis_tkeep
   .s_axis_tlast(axis_rxif_to_fifo_tlast),              // input wire s_axis_tlast
   .m_axis_aclk(user_clk),                // input wire m_axis_aclk
   .m_axis_tvalid(axis_rx_convert_tvalid),            // output wire m_axis_tvalid
   .m_axis_tready(axis_rx_convert_tready),            // input wire m_axis_tready
   .m_axis_tdata(axis_rx_convert_tdata),              // output wire [63 : 0] m_axis_tdata
   .m_axis_tkeep(axis_rx_convert_tkeep),              // output wire [7 : 0] m_axis_tkeep
   .m_axis_tlast(axis_rx_convert_tlast)              // output wire m_axis_tlast
 );

 axis_dwidth_converter_64_512 rx_converter (
    .aclk(user_clk),                    // input wire aclk
    .aresetn(aresetn),              // input wire aresetn
    .s_axis_tvalid(axis_rx_convert_tvalid),  // input wire s_axis_tvalid
    .s_axis_tready(axis_rx_convert_tready),  // output wire s_axis_tready
    .s_axis_tdata(axis_rx_convert_tdata),    // input wire [63 : 0] s_axis_tdata
    .s_axis_tkeep(axis_rx_convert_tkeep),    // input wire [7 : 0] s_axis_tkeep
    .s_axis_tlast(axis_rx_convert_tlast),    // input wire s_axis_tlast
    .m_axis_tvalid(m_axis_net_rx_valid),  // output wire m_axis_tvalid
    .m_axis_tready(m_axis_net_rx_ready),  // input wire m_axis_tready
    .m_axis_tdata(m_axis_net_rx_data),    // output wire [511 : 0] m_axis_tdata
    .m_axis_tkeep(m_axis_net_rx_keep),    // output wire [63 : 0] m_axis_tkeep
    .m_axis_tlast(m_axis_net_rx_last)    // output wire m_axis_tlast
  ); 
 
 
 //genvar idx;
 
 tx_interface tx_inf
 (
     .axi_str_tdata_to_xgmac(tx_axis_tdata),
     .axi_str_tkeep_to_xgmac(tx_axis_tkeep),
     .axi_str_tvalid_to_xgmac(tx_axis_tvalid),
     .axi_str_tlast_to_xgmac(tx_axis_tlast),
     .axi_str_tuser_to_xgmac(tx_axis_tuser),
     .axi_str_tready_from_xgmac(tx_axis_tready),
     
     .axi_str_tvalid_from_fifo(axis_tx_fifo_to_txif_tvalid),
     .axi_str_tready_to_fifo(axis_tx_fifo_to_txif_tready),
     .axi_str_tdata_from_fifo(axis_tx_fifo_to_txif_tdata),   
     .axi_str_tkeep_from_fifo(axis_tx_fifo_to_txif_tkeep),   
     .axi_str_tlast_from_fifo(axis_tx_fifo_to_txif_tlast),
 
     .user_clk(tx_clk_out),
     .reset(sys_reset | user_tx_reset)
 
 );
 
 axis_data_fifo_64_cc tx_crossing (
   .s_axis_aresetn(aresetn),          // input wire s_axis_aresetn
   .s_axis_aclk(user_clk),                // input wire s_axis_aclk
   .s_axis_tvalid(axis_tx_padding_to_fifo_tvalid),            // input wire s_axis_tvalid
   .s_axis_tready(axis_tx_padding_to_fifo_tready),            // output wire s_axis_tready
   .s_axis_tdata(axis_tx_padding_to_fifo_tdata),              // input wire [63 : 0] s_axis_tdata
   .s_axis_tkeep(axis_tx_padding_to_fifo_tkeep),              // input wire [7 : 0] s_axis_tkeep
   .s_axis_tlast(axis_tx_padding_to_fifo_tlast),              // input wire s_axis_tlast
   .m_axis_aclk(tx_clk_out),                // input wire m_axis_aclk
   .m_axis_tvalid(axis_tx_fifo_to_txif_tvalid),            // output wire m_axis_tvalid
   .m_axis_tready(axis_tx_fifo_to_txif_tready),            // input wire m_axis_tready
   .m_axis_tdata(axis_tx_fifo_to_txif_tdata),              // output wire [63 : 0] m_axis_tdata
   .m_axis_tkeep(axis_tx_fifo_to_txif_tkeep),              // output wire [7 : 0] m_axis_tkeep
   .m_axis_tlast(axis_tx_fifo_to_txif_tlast)              // output wire m_axis_tlast
 );

 axis_dwidth_converter_512_64 tx_converter (
    .aclk(user_clk),                    // input wire aclk
    .aresetn(aresetn),              // input wire aresetn
    .s_axis_tvalid(s_axis_net_tx_valid),  // input wire s_axis_tvalid
    .s_axis_tready(s_axis_net_tx_ready),  // output wire s_axis_tready
    .s_axis_tdata(s_axis_net_tx_data),    // input wire [511 : 0] s_axis_tdata
    .s_axis_tkeep(s_axis_net_tx_keep),    // input wire [63 : 0] s_axis_tkeep
    .s_axis_tlast(s_axis_net_tx_last),    // input wire s_axis_tlast
    .m_axis_tvalid(axis_tx_padding_to_fifo_tvalid),  // output wire m_axis_tvalid
    .m_axis_tready(axis_tx_padding_to_fifo_tready),  // input wire m_axis_tready
    .m_axis_tdata(axis_tx_padding_to_fifo_tdata),    // output wire [63 : 0] m_axis_tdata
    .m_axis_tkeep(axis_tx_padding_to_fifo_tkeep),    // output wire [7 : 0] m_axis_tkeep
    .m_axis_tlast(axis_tx_padding_to_fifo_tlast)    // output wire m_axis_tlast
  );


  ila_netmodule inst_tx_ila (
	.clk(user_clk), // input wire clk


	.probe0(s_axis_net_tx_valid), // input wire [0:0]  probe0  
	.probe1(s_axis_net_tx_ready), // input wire [0:0]  probe1 
	.probe2(s_axis_net_tx_last), // input wire [0:0]  probe2 
	.probe3(s_axis_net_tx_data), // input wire [63:0]  probe3 
	.probe4(s_axis_net_tx_keep), // input wire [7:0]  probe4 
	.probe5(1) // input wire [0:0]  probe5 
);


 endmodule
 
 `default_nettype wire
 