module MMCME4_ADV_Wrapper(
  input   io_CLKIN1,
  output  io_LOCKED,
  output  io_CLKOUT0
);
  wire  mmcm4_adv_CLKIN1; // @[Buf.scala 109:25]
  wire  mmcm4_adv_CLKIN2; // @[Buf.scala 109:25]
  wire  mmcm4_adv_RST; // @[Buf.scala 109:25]
  wire  mmcm4_adv_PWRDWN; // @[Buf.scala 109:25]
  wire  mmcm4_adv_CDDCREQ; // @[Buf.scala 109:25]
  wire  mmcm4_adv_CLKINSEL; // @[Buf.scala 109:25]
  wire [6:0] mmcm4_adv_DADDR; // @[Buf.scala 109:25]
  wire  mmcm4_adv_DEN; // @[Buf.scala 109:25]
  wire [15:0] mmcm4_adv_DI; // @[Buf.scala 109:25]
  wire  mmcm4_adv_DWE; // @[Buf.scala 109:25]
  wire  mmcm4_adv_PSCLK; // @[Buf.scala 109:25]
  wire  mmcm4_adv_PSEN; // @[Buf.scala 109:25]
  wire  mmcm4_adv_DCLK; // @[Buf.scala 109:25]
  wire  mmcm4_adv_PSINCDEC; // @[Buf.scala 109:25]
  wire  mmcm4_adv_LOCKED; // @[Buf.scala 109:25]
  wire  mmcm4_adv_CLKOUT0; // @[Buf.scala 109:25]
  wire  mmcm4_adv_CLKOUT1; // @[Buf.scala 109:25]
  wire  mmcm4_adv_CLKOUT2; // @[Buf.scala 109:25]
  wire  mmcm4_adv_CLKOUT3; // @[Buf.scala 109:25]
  wire  mmcm4_adv_CLKOUT4; // @[Buf.scala 109:25]
  wire  mmcm4_adv_CLKOUT5; // @[Buf.scala 109:25]
  wire  mmcm4_adv_CLKOUT6; // @[Buf.scala 109:25]
  MMCME4_ADV
    #(.CLKOUT5_DIVIDE(2.0), .CLKOUT3_DIVIDE(2.0), .CLKFBOUT_PHASE(0.0), .CLKIN1_PERIOD(10.0), .CLKOUT2_DIVIDE(2.0), .CLKOUT0_PHASE(0.0), .CLKFBOUT_MULT_F(11.875), .CLKOUT4_DIVIDE(2.0), .CLKOUT6_DIVIDE(2.0), .CLKOUT0_USE_FINE_PS("FALSE"), .COMPENSATION("INTERNAL"), .CLKOUT1_DIVIDE(2.0), .BANDWIDTH("OPTIMIZED"), .CLKFBOUT_USE_FINE_PS("FALSE"), .CLKOUT4_CASCADE("FALSE"), .CLKOUT0_DIVIDE_F(4.75), .CLKOUT0_DUTY_CYCLE(0.5), .REF_JITTER1(0.01), .DIVCLK_DIVIDE(1), .STARTUP_WAIT("FALSE"))
    mmcm4_adv ( // @[Buf.scala 109:25]
    .CLKIN1(mmcm4_adv_CLKIN1),
    .CLKIN2(mmcm4_adv_CLKIN2),
    .RST(mmcm4_adv_RST),
    .PWRDWN(mmcm4_adv_PWRDWN),
    .CDDCREQ(mmcm4_adv_CDDCREQ),
    .CLKINSEL(mmcm4_adv_CLKINSEL),
    .DADDR(mmcm4_adv_DADDR),
    .DEN(mmcm4_adv_DEN),
    .DI(mmcm4_adv_DI),
    .DWE(mmcm4_adv_DWE),
    .PSCLK(mmcm4_adv_PSCLK),
    .PSEN(mmcm4_adv_PSEN),
    .DCLK(mmcm4_adv_DCLK),
    .PSINCDEC(mmcm4_adv_PSINCDEC),
    .LOCKED(mmcm4_adv_LOCKED),
    .CLKOUT0(mmcm4_adv_CLKOUT0),
    .CLKOUT1(mmcm4_adv_CLKOUT1),
    .CLKOUT2(mmcm4_adv_CLKOUT2),
    .CLKOUT3(mmcm4_adv_CLKOUT3),
    .CLKOUT4(mmcm4_adv_CLKOUT4),
    .CLKOUT5(mmcm4_adv_CLKOUT5),
    .CLKOUT6(mmcm4_adv_CLKOUT6)
  );
  assign io_LOCKED = mmcm4_adv_LOCKED; // @[Buf.scala 123:25]
  assign io_CLKOUT0 = mmcm4_adv_CLKOUT0; // @[Buf.scala 124:26]
  assign mmcm4_adv_CLKIN1 = io_CLKIN1; // @[Buf.scala 121:25]
  assign mmcm4_adv_CLKIN2 = 1'h0; // @[Buf.scala 132:31]
  assign mmcm4_adv_RST = 1'h0; // @[Buf.scala 122:25]
  assign mmcm4_adv_PWRDWN = 1'h0; // @[Buf.scala 133:30]
  assign mmcm4_adv_CDDCREQ = 1'h0; // @[Buf.scala 134:32]
  assign mmcm4_adv_CLKINSEL = 1'h1; // @[Buf.scala 135:32]
  assign mmcm4_adv_DADDR = 7'h0; // @[Buf.scala 136:30]
  assign mmcm4_adv_DEN = 1'h0; // @[Buf.scala 137:28]
  assign mmcm4_adv_DI = 16'h0; // @[Buf.scala 138:26]
  assign mmcm4_adv_DWE = 1'h0; // @[Buf.scala 139:28]
  assign mmcm4_adv_PSCLK = 1'h0; // @[Buf.scala 140:30]
  assign mmcm4_adv_PSEN = 1'h0; // @[Buf.scala 141:28]
  assign mmcm4_adv_DCLK = 1'h0; // @[Buf.scala 142:28]
  assign mmcm4_adv_PSINCDEC = 1'h0; // @[Buf.scala 143:32]
endmodule
module StaticU280Top(
  input        sysClkP,
  input        sysClkN,
  output [7:0] qdmaPin_tx_p,
  output [7:0] qdmaPin_tx_n,
  input  [7:0] qdmaPin_rx_p,
  input  [7:0] qdmaPin_rx_n,
  input        qdmaPin_sys_clk_p,
  input        qdmaPin_sys_clk_n,
  input        qdmaPin_sys_rst_n,
  output [3:0] cmacPin_tx_p,
  output [3:0] cmacPin_tx_n,
  input  [3:0] cmacPin_rx_p,
  input  [3:0] cmacPin_rx_n,
  input        cmacPin_gt_clk_p,
  input        cmacPin_gt_clk_n,
  output       hbmCattrip
);
  wire  sysClk_pad_O; // @[Buf.scala 51:34]
  wire  sysClk_pad_I; // @[Buf.scala 51:34]
  wire  sysClk_pad_IB; // @[Buf.scala 51:34]
  wire  sysClk_pad_1_O; // @[Buf.scala 33:34]
  wire  sysClk_pad_1_I; // @[Buf.scala 33:34]
  wire  instQdma_sys_rst_n; // @[StaticU280Top.scala 37:30]
  wire  instQdma_sys_clk; // @[StaticU280Top.scala 37:30]
  wire  instQdma_sys_clk_gt; // @[StaticU280Top.scala 37:30]
  wire [15:0] instQdma_pci_exp_txn; // @[StaticU280Top.scala 37:30]
  wire [15:0] instQdma_pci_exp_txp; // @[StaticU280Top.scala 37:30]
  wire [15:0] instQdma_pci_exp_rxn; // @[StaticU280Top.scala 37:30]
  wire [15:0] instQdma_pci_exp_rxp; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_m_axib_awid; // @[StaticU280Top.scala 37:30]
  wire [63:0] instQdma_m_axib_awaddr; // @[StaticU280Top.scala 37:30]
  wire [7:0] instQdma_m_axib_awlen; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_m_axib_awsize; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_m_axib_awburst; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_m_axib_awprot; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_awlock; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_m_axib_awcache; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_awvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_awready; // @[StaticU280Top.scala 37:30]
  wire [511:0] instQdma_m_axib_wdata; // @[StaticU280Top.scala 37:30]
  wire [63:0] instQdma_m_axib_wstrb; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_wlast; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_wvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_wready; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_m_axib_bid; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_m_axib_bresp; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_bvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_bready; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_m_axib_arid; // @[StaticU280Top.scala 37:30]
  wire [63:0] instQdma_m_axib_araddr; // @[StaticU280Top.scala 37:30]
  wire [7:0] instQdma_m_axib_arlen; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_m_axib_arsize; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_m_axib_arburst; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_m_axib_arprot; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_arlock; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_m_axib_arcache; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_arvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_arready; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_m_axib_rid; // @[StaticU280Top.scala 37:30]
  wire [511:0] instQdma_m_axib_rdata; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_m_axib_rresp; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_rlast; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_rvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axib_rready; // @[StaticU280Top.scala 37:30]
  wire [31:0] instQdma_m_axil_awaddr; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axil_awvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axil_awready; // @[StaticU280Top.scala 37:30]
  wire [31:0] instQdma_m_axil_wdata; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_m_axil_wstrb; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axil_wvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axil_wready; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_m_axil_bresp; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axil_bvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axil_bready; // @[StaticU280Top.scala 37:30]
  wire [31:0] instQdma_m_axil_araddr; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axil_arvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axil_arready; // @[StaticU280Top.scala 37:30]
  wire [31:0] instQdma_m_axil_rdata; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_m_axil_rresp; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axil_rvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axil_rready; // @[StaticU280Top.scala 37:30]
  wire  instQdma_axi_aclk; // @[StaticU280Top.scala 37:30]
  wire  instQdma_axi_aresetn; // @[StaticU280Top.scala 37:30]
  wire  instQdma_soft_reset_n; // @[StaticU280Top.scala 37:30]
  wire [63:0] instQdma_h2c_byp_in_st_addr; // @[StaticU280Top.scala 37:30]
  wire [31:0] instQdma_h2c_byp_in_st_len; // @[StaticU280Top.scala 37:30]
  wire  instQdma_h2c_byp_in_st_eop; // @[StaticU280Top.scala 37:30]
  wire  instQdma_h2c_byp_in_st_sop; // @[StaticU280Top.scala 37:30]
  wire  instQdma_h2c_byp_in_st_mrkr_req; // @[StaticU280Top.scala 37:30]
  wire  instQdma_h2c_byp_in_st_sdi; // @[StaticU280Top.scala 37:30]
  wire [10:0] instQdma_h2c_byp_in_st_qid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_h2c_byp_in_st_error; // @[StaticU280Top.scala 37:30]
  wire [7:0] instQdma_h2c_byp_in_st_func; // @[StaticU280Top.scala 37:30]
  wire [15:0] instQdma_h2c_byp_in_st_cidx; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_h2c_byp_in_st_port_id; // @[StaticU280Top.scala 37:30]
  wire  instQdma_h2c_byp_in_st_no_dma; // @[StaticU280Top.scala 37:30]
  wire  instQdma_h2c_byp_in_st_vld; // @[StaticU280Top.scala 37:30]
  wire  instQdma_h2c_byp_in_st_rdy; // @[StaticU280Top.scala 37:30]
  wire [63:0] instQdma_c2h_byp_in_st_csh_addr; // @[StaticU280Top.scala 37:30]
  wire [10:0] instQdma_c2h_byp_in_st_csh_qid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_c2h_byp_in_st_csh_error; // @[StaticU280Top.scala 37:30]
  wire [7:0] instQdma_c2h_byp_in_st_csh_func; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_c2h_byp_in_st_csh_port_id; // @[StaticU280Top.scala 37:30]
  wire [6:0] instQdma_c2h_byp_in_st_csh_pfch_tag; // @[StaticU280Top.scala 37:30]
  wire  instQdma_c2h_byp_in_st_csh_vld; // @[StaticU280Top.scala 37:30]
  wire  instQdma_c2h_byp_in_st_csh_rdy; // @[StaticU280Top.scala 37:30]
  wire [511:0] instQdma_s_axis_c2h_tdata; // @[StaticU280Top.scala 37:30]
  wire [31:0] instQdma_s_axis_c2h_tcrc; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axis_c2h_ctrl_marker; // @[StaticU280Top.scala 37:30]
  wire [6:0] instQdma_s_axis_c2h_ctrl_ecc; // @[StaticU280Top.scala 37:30]
  wire [31:0] instQdma_s_axis_c2h_ctrl_len; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_s_axis_c2h_ctrl_port_id; // @[StaticU280Top.scala 37:30]
  wire [10:0] instQdma_s_axis_c2h_ctrl_qid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axis_c2h_ctrl_has_cmpt; // @[StaticU280Top.scala 37:30]
  wire [5:0] instQdma_s_axis_c2h_mty; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axis_c2h_tlast; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axis_c2h_tvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axis_c2h_tready; // @[StaticU280Top.scala 37:30]
  wire [511:0] instQdma_m_axis_h2c_tdata; // @[StaticU280Top.scala 37:30]
  wire [31:0] instQdma_m_axis_h2c_tcrc; // @[StaticU280Top.scala 37:30]
  wire [10:0] instQdma_m_axis_h2c_tuser_qid; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_m_axis_h2c_tuser_port_id; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axis_h2c_tuser_err; // @[StaticU280Top.scala 37:30]
  wire [31:0] instQdma_m_axis_h2c_tuser_mdata; // @[StaticU280Top.scala 37:30]
  wire [5:0] instQdma_m_axis_h2c_tuser_mty; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axis_h2c_tuser_zero_byte; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axis_h2c_tlast; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axis_h2c_tvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_m_axis_h2c_tready; // @[StaticU280Top.scala 37:30]
  wire  instQdma_axis_c2h_status_drop; // @[StaticU280Top.scala 37:30]
  wire  instQdma_axis_c2h_status_last; // @[StaticU280Top.scala 37:30]
  wire  instQdma_axis_c2h_status_cmp; // @[StaticU280Top.scala 37:30]
  wire  instQdma_axis_c2h_status_valid; // @[StaticU280Top.scala 37:30]
  wire [10:0] instQdma_axis_c2h_status_qid; // @[StaticU280Top.scala 37:30]
  wire [511:0] instQdma_s_axis_c2h_cmpt_tdata; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_s_axis_c2h_cmpt_size; // @[StaticU280Top.scala 37:30]
  wire [15:0] instQdma_s_axis_c2h_cmpt_dpar; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axis_c2h_cmpt_tvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axis_c2h_cmpt_tready; // @[StaticU280Top.scala 37:30]
  wire [10:0] instQdma_s_axis_c2h_cmpt_ctrl_qid; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_s_axis_c2h_cmpt_ctrl_cmpt_type; // @[StaticU280Top.scala 37:30]
  wire [15:0] instQdma_s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axis_c2h_cmpt_ctrl_no_wrb_marker; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_s_axis_c2h_cmpt_ctrl_port_id; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axis_c2h_cmpt_ctrl_marker; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axis_c2h_cmpt_ctrl_user_trig; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_s_axis_c2h_cmpt_ctrl_col_idx; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_s_axis_c2h_cmpt_ctrl_err_idx; // @[StaticU280Top.scala 37:30]
  wire  instQdma_h2c_byp_out_rdy; // @[StaticU280Top.scala 37:30]
  wire  instQdma_c2h_byp_out_rdy; // @[StaticU280Top.scala 37:30]
  wire  instQdma_tm_dsc_sts_rdy; // @[StaticU280Top.scala 37:30]
  wire  instQdma_dsc_crdt_in_vld; // @[StaticU280Top.scala 37:30]
  wire  instQdma_dsc_crdt_in_rdy; // @[StaticU280Top.scala 37:30]
  wire  instQdma_dsc_crdt_in_dir; // @[StaticU280Top.scala 37:30]
  wire  instQdma_dsc_crdt_in_fence; // @[StaticU280Top.scala 37:30]
  wire [10:0] instQdma_dsc_crdt_in_qid; // @[StaticU280Top.scala 37:30]
  wire [15:0] instQdma_dsc_crdt_in_crdt; // @[StaticU280Top.scala 37:30]
  wire  instQdma_qsts_out_rdy; // @[StaticU280Top.scala 37:30]
  wire  instQdma_usr_irq_in_vld; // @[StaticU280Top.scala 37:30]
  wire [10:0] instQdma_usr_irq_in_vec; // @[StaticU280Top.scala 37:30]
  wire [7:0] instQdma_usr_irq_in_fnc; // @[StaticU280Top.scala 37:30]
  wire  instQdma_usr_irq_out_ack; // @[StaticU280Top.scala 37:30]
  wire  instQdma_usr_irq_out_fail; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_s_axib_awid; // @[StaticU280Top.scala 37:30]
  wire [63:0] instQdma_s_axib_awaddr; // @[StaticU280Top.scala 37:30]
  wire [7:0] instQdma_s_axib_awlen; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_s_axib_awsize; // @[StaticU280Top.scala 37:30]
  wire [11:0] instQdma_s_axib_awuser; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_s_axib_awburst; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_s_axib_awregion; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_awvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_awready; // @[StaticU280Top.scala 37:30]
  wire [511:0] instQdma_s_axib_wdata; // @[StaticU280Top.scala 37:30]
  wire [63:0] instQdma_s_axib_wstrb; // @[StaticU280Top.scala 37:30]
  wire [63:0] instQdma_s_axib_wuser; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_wlast; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_wvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_wready; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_s_axib_bid; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_s_axib_bresp; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_bvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_bready; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_s_axib_arid; // @[StaticU280Top.scala 37:30]
  wire [63:0] instQdma_s_axib_araddr; // @[StaticU280Top.scala 37:30]
  wire [7:0] instQdma_s_axib_arlen; // @[StaticU280Top.scala 37:30]
  wire [2:0] instQdma_s_axib_arsize; // @[StaticU280Top.scala 37:30]
  wire [11:0] instQdma_s_axib_aruser; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_s_axib_arburst; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_s_axib_arregion; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_arvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_arready; // @[StaticU280Top.scala 37:30]
  wire [3:0] instQdma_s_axib_rid; // @[StaticU280Top.scala 37:30]
  wire [511:0] instQdma_s_axib_rdata; // @[StaticU280Top.scala 37:30]
  wire [1:0] instQdma_s_axib_rresp; // @[StaticU280Top.scala 37:30]
  wire [63:0] instQdma_s_axib_ruser; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_rlast; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_rvalid; // @[StaticU280Top.scala 37:30]
  wire  instQdma_s_axib_rready; // @[StaticU280Top.scala 37:30]
  wire [31:0] instQdma_st_rx_msg_data; // @[StaticU280Top.scala 37:30]
  wire  instQdma_st_rx_msg_last; // @[StaticU280Top.scala 37:30]
  wire  instQdma_st_rx_msg_rdy; // @[StaticU280Top.scala 37:30]
  wire  instQdma_st_rx_msg_valid; // @[StaticU280Top.scala 37:30]
  wire  ibufds_gte4_inst_O; // @[StaticU280Top.scala 44:38]
  wire  ibufds_gte4_inst_ODIV2; // @[StaticU280Top.scala 44:38]
  wire  ibufds_gte4_inst_CEB; // @[StaticU280Top.scala 44:38]
  wire  ibufds_gte4_inst_I; // @[StaticU280Top.scala 44:38]
  wire  ibufds_gte4_inst_IB; // @[StaticU280Top.scala 44:38]
  wire  instQdma_io_sys_rst_n_pad_O; // @[Buf.scala 17:34]
  wire  instQdma_io_sys_rst_n_pad_I; // @[Buf.scala 17:34]
  wire  mmcmUsrClk_io_CLKIN1; // @[StaticU280Top.scala 60:33]
  wire  mmcmUsrClk_io_LOCKED; // @[StaticU280Top.scala 60:33]
  wire  mmcmUsrClk_io_CLKOUT0; // @[StaticU280Top.scala 60:33]
  wire  core_clock; // @[StaticU280Top.scala 343:26]
  wire  core_reset; // @[StaticU280Top.scala 343:26]
  wire  core_io_sysClk; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_cmacPin_tx_p; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_cmacPin_tx_n; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_cmacPin_rx_p; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_cmacPin_rx_n; // @[StaticU280Top.scala 343:26]
  wire  core_io_cmacPin_gt_clk_p; // @[StaticU280Top.scala 343:26]
  wire  core_io_cmacPin_gt_clk_n; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_axi_aclk; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_axi_aresetn; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_m_axib_awid; // @[StaticU280Top.scala 343:26]
  wire [63:0] core_io_qdma_m_axib_awaddr; // @[StaticU280Top.scala 343:26]
  wire [7:0] core_io_qdma_m_axib_awlen; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_m_axib_awsize; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_m_axib_awburst; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_m_axib_awprot; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_awlock; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_m_axib_awcache; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_awvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_awready; // @[StaticU280Top.scala 343:26]
  wire [511:0] core_io_qdma_m_axib_wdata; // @[StaticU280Top.scala 343:26]
  wire [63:0] core_io_qdma_m_axib_wstrb; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_wlast; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_wvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_wready; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_m_axib_bid; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_m_axib_bresp; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_bvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_bready; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_m_axib_arid; // @[StaticU280Top.scala 343:26]
  wire [63:0] core_io_qdma_m_axib_araddr; // @[StaticU280Top.scala 343:26]
  wire [7:0] core_io_qdma_m_axib_arlen; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_m_axib_arsize; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_m_axib_arburst; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_m_axib_arprot; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_arlock; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_m_axib_arcache; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_arvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_arready; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_m_axib_rid; // @[StaticU280Top.scala 343:26]
  wire [511:0] core_io_qdma_m_axib_rdata; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_m_axib_rresp; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_rlast; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_rvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axib_rready; // @[StaticU280Top.scala 343:26]
  wire [31:0] core_io_qdma_m_axil_awaddr; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axil_awvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axil_awready; // @[StaticU280Top.scala 343:26]
  wire [31:0] core_io_qdma_m_axil_wdata; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_m_axil_wstrb; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axil_wvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axil_wready; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_m_axil_bresp; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axil_bvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axil_bready; // @[StaticU280Top.scala 343:26]
  wire [31:0] core_io_qdma_m_axil_araddr; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axil_arvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axil_arready; // @[StaticU280Top.scala 343:26]
  wire [31:0] core_io_qdma_m_axil_rdata; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_m_axil_rresp; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axil_rvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axil_rready; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_soft_reset_n; // @[StaticU280Top.scala 343:26]
  wire [63:0] core_io_qdma_h2c_byp_in_st_addr; // @[StaticU280Top.scala 343:26]
  wire [31:0] core_io_qdma_h2c_byp_in_st_len; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_h2c_byp_in_st_eop; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_h2c_byp_in_st_sop; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_h2c_byp_in_st_mrkr_req; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_h2c_byp_in_st_sdi; // @[StaticU280Top.scala 343:26]
  wire [10:0] core_io_qdma_h2c_byp_in_st_qid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_h2c_byp_in_st_error; // @[StaticU280Top.scala 343:26]
  wire [7:0] core_io_qdma_h2c_byp_in_st_func; // @[StaticU280Top.scala 343:26]
  wire [15:0] core_io_qdma_h2c_byp_in_st_cidx; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_h2c_byp_in_st_port_id; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_h2c_byp_in_st_no_dma; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_h2c_byp_in_st_vld; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_h2c_byp_in_st_rdy; // @[StaticU280Top.scala 343:26]
  wire [63:0] core_io_qdma_c2h_byp_in_st_csh_addr; // @[StaticU280Top.scala 343:26]
  wire [10:0] core_io_qdma_c2h_byp_in_st_csh_qid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_c2h_byp_in_st_csh_error; // @[StaticU280Top.scala 343:26]
  wire [7:0] core_io_qdma_c2h_byp_in_st_csh_func; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_c2h_byp_in_st_csh_port_id; // @[StaticU280Top.scala 343:26]
  wire [6:0] core_io_qdma_c2h_byp_in_st_csh_pfch_tag; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_c2h_byp_in_st_csh_vld; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_c2h_byp_in_st_csh_rdy; // @[StaticU280Top.scala 343:26]
  wire [511:0] core_io_qdma_s_axis_c2h_tdata; // @[StaticU280Top.scala 343:26]
  wire [31:0] core_io_qdma_s_axis_c2h_tcrc; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axis_c2h_ctrl_marker; // @[StaticU280Top.scala 343:26]
  wire [6:0] core_io_qdma_s_axis_c2h_ctrl_ecc; // @[StaticU280Top.scala 343:26]
  wire [31:0] core_io_qdma_s_axis_c2h_ctrl_len; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_s_axis_c2h_ctrl_port_id; // @[StaticU280Top.scala 343:26]
  wire [10:0] core_io_qdma_s_axis_c2h_ctrl_qid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axis_c2h_ctrl_has_cmpt; // @[StaticU280Top.scala 343:26]
  wire [5:0] core_io_qdma_s_axis_c2h_mty; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axis_c2h_tlast; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axis_c2h_tvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axis_c2h_tready; // @[StaticU280Top.scala 343:26]
  wire [511:0] core_io_qdma_m_axis_h2c_tdata; // @[StaticU280Top.scala 343:26]
  wire [31:0] core_io_qdma_m_axis_h2c_tcrc; // @[StaticU280Top.scala 343:26]
  wire [10:0] core_io_qdma_m_axis_h2c_tuser_qid; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_m_axis_h2c_tuser_port_id; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axis_h2c_tuser_err; // @[StaticU280Top.scala 343:26]
  wire [31:0] core_io_qdma_m_axis_h2c_tuser_mdata; // @[StaticU280Top.scala 343:26]
  wire [5:0] core_io_qdma_m_axis_h2c_tuser_mty; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axis_h2c_tuser_zero_byte; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axis_h2c_tlast; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axis_h2c_tvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_m_axis_h2c_tready; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_axis_c2h_status_drop; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_axis_c2h_status_last; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_axis_c2h_status_cmp; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_axis_c2h_status_valid; // @[StaticU280Top.scala 343:26]
  wire [10:0] core_io_qdma_axis_c2h_status_qid; // @[StaticU280Top.scala 343:26]
  wire [511:0] core_io_qdma_s_axis_c2h_cmpt_tdata; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_s_axis_c2h_cmpt_size; // @[StaticU280Top.scala 343:26]
  wire [15:0] core_io_qdma_s_axis_c2h_cmpt_dpar; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axis_c2h_cmpt_tvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axis_c2h_cmpt_tready; // @[StaticU280Top.scala 343:26]
  wire [10:0] core_io_qdma_s_axis_c2h_cmpt_ctrl_qid; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_s_axis_c2h_cmpt_ctrl_cmpt_type; // @[StaticU280Top.scala 343:26]
  wire [15:0] core_io_qdma_s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axis_c2h_cmpt_ctrl_no_wrb_marker; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_s_axis_c2h_cmpt_ctrl_port_id; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axis_c2h_cmpt_ctrl_marker; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axis_c2h_cmpt_ctrl_user_trig; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_s_axis_c2h_cmpt_ctrl_col_idx; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_s_axis_c2h_cmpt_ctrl_err_idx; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_h2c_byp_out_rdy; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_c2h_byp_out_rdy; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_tm_dsc_sts_rdy; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_dsc_crdt_in_vld; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_dsc_crdt_in_rdy; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_dsc_crdt_in_dir; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_dsc_crdt_in_fence; // @[StaticU280Top.scala 343:26]
  wire [10:0] core_io_qdma_dsc_crdt_in_qid; // @[StaticU280Top.scala 343:26]
  wire [15:0] core_io_qdma_dsc_crdt_in_crdt; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_qsts_out_rdy; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_usr_irq_in_vld; // @[StaticU280Top.scala 343:26]
  wire [10:0] core_io_qdma_usr_irq_in_vec; // @[StaticU280Top.scala 343:26]
  wire [7:0] core_io_qdma_usr_irq_in_fnc; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_usr_irq_out_ack; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_usr_irq_out_fail; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_s_axib_awid; // @[StaticU280Top.scala 343:26]
  wire [63:0] core_io_qdma_s_axib_awaddr; // @[StaticU280Top.scala 343:26]
  wire [7:0] core_io_qdma_s_axib_awlen; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_s_axib_awsize; // @[StaticU280Top.scala 343:26]
  wire [11:0] core_io_qdma_s_axib_awuser; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_s_axib_awburst; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_s_axib_awregion; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_awvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_awready; // @[StaticU280Top.scala 343:26]
  wire [511:0] core_io_qdma_s_axib_wdata; // @[StaticU280Top.scala 343:26]
  wire [63:0] core_io_qdma_s_axib_wstrb; // @[StaticU280Top.scala 343:26]
  wire [63:0] core_io_qdma_s_axib_wuser; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_wlast; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_wvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_wready; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_s_axib_bid; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_s_axib_bresp; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_bvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_bready; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_s_axib_arid; // @[StaticU280Top.scala 343:26]
  wire [63:0] core_io_qdma_s_axib_araddr; // @[StaticU280Top.scala 343:26]
  wire [7:0] core_io_qdma_s_axib_arlen; // @[StaticU280Top.scala 343:26]
  wire [2:0] core_io_qdma_s_axib_arsize; // @[StaticU280Top.scala 343:26]
  wire [11:0] core_io_qdma_s_axib_aruser; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_s_axib_arburst; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_s_axib_arregion; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_arvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_arready; // @[StaticU280Top.scala 343:26]
  wire [3:0] core_io_qdma_s_axib_rid; // @[StaticU280Top.scala 343:26]
  wire [511:0] core_io_qdma_s_axib_rdata; // @[StaticU280Top.scala 343:26]
  wire [1:0] core_io_qdma_s_axib_rresp; // @[StaticU280Top.scala 343:26]
  wire [63:0] core_io_qdma_s_axib_ruser; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_rlast; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_rvalid; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_s_axib_rready; // @[StaticU280Top.scala 343:26]
  wire [31:0] core_io_qdma_st_rx_msg_data; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_st_rx_msg_last; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_st_rx_msg_rdy; // @[StaticU280Top.scala 343:26]
  wire  core_io_qdma_st_rx_msg_valid; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_drck; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_shift; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_tdi; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_update; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_sel; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_tdo; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_tms; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_tck; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_runtest; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_reset; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_capture; // @[StaticU280Top.scala 343:26]
  wire  core_S_BSCAN_bscanid_en; // @[StaticU280Top.scala 343:26]
  wire  userRstn = mmcmUsrClk_io_LOCKED; // @[StaticU280Top.scala 70:49]
  IBUFDS sysClk_pad ( // @[Buf.scala 51:34]
    .O(sysClk_pad_O),
    .I(sysClk_pad_I),
    .IB(sysClk_pad_IB)
  );
  BUFG sysClk_pad_1 ( // @[Buf.scala 33:34]
    .O(sysClk_pad_1_O),
    .I(sysClk_pad_1_I)
  );
  QDMABlackBox instQdma ( // @[StaticU280Top.scala 37:30]
    .sys_rst_n(instQdma_sys_rst_n),
    .sys_clk(instQdma_sys_clk),
    .sys_clk_gt(instQdma_sys_clk_gt),
    .pci_exp_txn(instQdma_pci_exp_txn),
    .pci_exp_txp(instQdma_pci_exp_txp),
    .pci_exp_rxn(instQdma_pci_exp_rxn),
    .pci_exp_rxp(instQdma_pci_exp_rxp),
    .m_axib_awid(instQdma_m_axib_awid),
    .m_axib_awaddr(instQdma_m_axib_awaddr),
    .m_axib_awlen(instQdma_m_axib_awlen),
    .m_axib_awsize(instQdma_m_axib_awsize),
    .m_axib_awburst(instQdma_m_axib_awburst),
    .m_axib_awprot(instQdma_m_axib_awprot),
    .m_axib_awlock(instQdma_m_axib_awlock),
    .m_axib_awcache(instQdma_m_axib_awcache),
    .m_axib_awvalid(instQdma_m_axib_awvalid),
    .m_axib_awready(instQdma_m_axib_awready),
    .m_axib_wdata(instQdma_m_axib_wdata),
    .m_axib_wstrb(instQdma_m_axib_wstrb),
    .m_axib_wlast(instQdma_m_axib_wlast),
    .m_axib_wvalid(instQdma_m_axib_wvalid),
    .m_axib_wready(instQdma_m_axib_wready),
    .m_axib_bid(instQdma_m_axib_bid),
    .m_axib_bresp(instQdma_m_axib_bresp),
    .m_axib_bvalid(instQdma_m_axib_bvalid),
    .m_axib_bready(instQdma_m_axib_bready),
    .m_axib_arid(instQdma_m_axib_arid),
    .m_axib_araddr(instQdma_m_axib_araddr),
    .m_axib_arlen(instQdma_m_axib_arlen),
    .m_axib_arsize(instQdma_m_axib_arsize),
    .m_axib_arburst(instQdma_m_axib_arburst),
    .m_axib_arprot(instQdma_m_axib_arprot),
    .m_axib_arlock(instQdma_m_axib_arlock),
    .m_axib_arcache(instQdma_m_axib_arcache),
    .m_axib_arvalid(instQdma_m_axib_arvalid),
    .m_axib_arready(instQdma_m_axib_arready),
    .m_axib_rid(instQdma_m_axib_rid),
    .m_axib_rdata(instQdma_m_axib_rdata),
    .m_axib_rresp(instQdma_m_axib_rresp),
    .m_axib_rlast(instQdma_m_axib_rlast),
    .m_axib_rvalid(instQdma_m_axib_rvalid),
    .m_axib_rready(instQdma_m_axib_rready),
    .m_axil_awaddr(instQdma_m_axil_awaddr),
    .m_axil_awvalid(instQdma_m_axil_awvalid),
    .m_axil_awready(instQdma_m_axil_awready),
    .m_axil_wdata(instQdma_m_axil_wdata),
    .m_axil_wstrb(instQdma_m_axil_wstrb),
    .m_axil_wvalid(instQdma_m_axil_wvalid),
    .m_axil_wready(instQdma_m_axil_wready),
    .m_axil_bresp(instQdma_m_axil_bresp),
    .m_axil_bvalid(instQdma_m_axil_bvalid),
    .m_axil_bready(instQdma_m_axil_bready),
    .m_axil_araddr(instQdma_m_axil_araddr),
    .m_axil_arvalid(instQdma_m_axil_arvalid),
    .m_axil_arready(instQdma_m_axil_arready),
    .m_axil_rdata(instQdma_m_axil_rdata),
    .m_axil_rresp(instQdma_m_axil_rresp),
    .m_axil_rvalid(instQdma_m_axil_rvalid),
    .m_axil_rready(instQdma_m_axil_rready),
    .axi_aclk(instQdma_axi_aclk),
    .axi_aresetn(instQdma_axi_aresetn),
    .soft_reset_n(instQdma_soft_reset_n),
    .h2c_byp_in_st_addr(instQdma_h2c_byp_in_st_addr),
    .h2c_byp_in_st_len(instQdma_h2c_byp_in_st_len),
    .h2c_byp_in_st_eop(instQdma_h2c_byp_in_st_eop),
    .h2c_byp_in_st_sop(instQdma_h2c_byp_in_st_sop),
    .h2c_byp_in_st_mrkr_req(instQdma_h2c_byp_in_st_mrkr_req),
    .h2c_byp_in_st_sdi(instQdma_h2c_byp_in_st_sdi),
    .h2c_byp_in_st_qid(instQdma_h2c_byp_in_st_qid),
    .h2c_byp_in_st_error(instQdma_h2c_byp_in_st_error),
    .h2c_byp_in_st_func(instQdma_h2c_byp_in_st_func),
    .h2c_byp_in_st_cidx(instQdma_h2c_byp_in_st_cidx),
    .h2c_byp_in_st_port_id(instQdma_h2c_byp_in_st_port_id),
    .h2c_byp_in_st_no_dma(instQdma_h2c_byp_in_st_no_dma),
    .h2c_byp_in_st_vld(instQdma_h2c_byp_in_st_vld),
    .h2c_byp_in_st_rdy(instQdma_h2c_byp_in_st_rdy),
    .c2h_byp_in_st_csh_addr(instQdma_c2h_byp_in_st_csh_addr),
    .c2h_byp_in_st_csh_qid(instQdma_c2h_byp_in_st_csh_qid),
    .c2h_byp_in_st_csh_error(instQdma_c2h_byp_in_st_csh_error),
    .c2h_byp_in_st_csh_func(instQdma_c2h_byp_in_st_csh_func),
    .c2h_byp_in_st_csh_port_id(instQdma_c2h_byp_in_st_csh_port_id),
    .c2h_byp_in_st_csh_pfch_tag(instQdma_c2h_byp_in_st_csh_pfch_tag),
    .c2h_byp_in_st_csh_vld(instQdma_c2h_byp_in_st_csh_vld),
    .c2h_byp_in_st_csh_rdy(instQdma_c2h_byp_in_st_csh_rdy),
    .s_axis_c2h_tdata(instQdma_s_axis_c2h_tdata),
    .s_axis_c2h_tcrc(instQdma_s_axis_c2h_tcrc),
    .s_axis_c2h_ctrl_marker(instQdma_s_axis_c2h_ctrl_marker),
    .s_axis_c2h_ctrl_ecc(instQdma_s_axis_c2h_ctrl_ecc),
    .s_axis_c2h_ctrl_len(instQdma_s_axis_c2h_ctrl_len),
    .s_axis_c2h_ctrl_port_id(instQdma_s_axis_c2h_ctrl_port_id),
    .s_axis_c2h_ctrl_qid(instQdma_s_axis_c2h_ctrl_qid),
    .s_axis_c2h_ctrl_has_cmpt(instQdma_s_axis_c2h_ctrl_has_cmpt),
    .s_axis_c2h_mty(instQdma_s_axis_c2h_mty),
    .s_axis_c2h_tlast(instQdma_s_axis_c2h_tlast),
    .s_axis_c2h_tvalid(instQdma_s_axis_c2h_tvalid),
    .s_axis_c2h_tready(instQdma_s_axis_c2h_tready),
    .m_axis_h2c_tdata(instQdma_m_axis_h2c_tdata),
    .m_axis_h2c_tcrc(instQdma_m_axis_h2c_tcrc),
    .m_axis_h2c_tuser_qid(instQdma_m_axis_h2c_tuser_qid),
    .m_axis_h2c_tuser_port_id(instQdma_m_axis_h2c_tuser_port_id),
    .m_axis_h2c_tuser_err(instQdma_m_axis_h2c_tuser_err),
    .m_axis_h2c_tuser_mdata(instQdma_m_axis_h2c_tuser_mdata),
    .m_axis_h2c_tuser_mty(instQdma_m_axis_h2c_tuser_mty),
    .m_axis_h2c_tuser_zero_byte(instQdma_m_axis_h2c_tuser_zero_byte),
    .m_axis_h2c_tlast(instQdma_m_axis_h2c_tlast),
    .m_axis_h2c_tvalid(instQdma_m_axis_h2c_tvalid),
    .m_axis_h2c_tready(instQdma_m_axis_h2c_tready),
    .axis_c2h_status_drop(instQdma_axis_c2h_status_drop),
    .axis_c2h_status_last(instQdma_axis_c2h_status_last),
    .axis_c2h_status_cmp(instQdma_axis_c2h_status_cmp),
    .axis_c2h_status_valid(instQdma_axis_c2h_status_valid),
    .axis_c2h_status_qid(instQdma_axis_c2h_status_qid),
    .s_axis_c2h_cmpt_tdata(instQdma_s_axis_c2h_cmpt_tdata),
    .s_axis_c2h_cmpt_size(instQdma_s_axis_c2h_cmpt_size),
    .s_axis_c2h_cmpt_dpar(instQdma_s_axis_c2h_cmpt_dpar),
    .s_axis_c2h_cmpt_tvalid(instQdma_s_axis_c2h_cmpt_tvalid),
    .s_axis_c2h_cmpt_tready(instQdma_s_axis_c2h_cmpt_tready),
    .s_axis_c2h_cmpt_ctrl_qid(instQdma_s_axis_c2h_cmpt_ctrl_qid),
    .s_axis_c2h_cmpt_ctrl_cmpt_type(instQdma_s_axis_c2h_cmpt_ctrl_cmpt_type),
    .s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id(instQdma_s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id),
    .s_axis_c2h_cmpt_ctrl_no_wrb_marker(instQdma_s_axis_c2h_cmpt_ctrl_no_wrb_marker),
    .s_axis_c2h_cmpt_ctrl_port_id(instQdma_s_axis_c2h_cmpt_ctrl_port_id),
    .s_axis_c2h_cmpt_ctrl_marker(instQdma_s_axis_c2h_cmpt_ctrl_marker),
    .s_axis_c2h_cmpt_ctrl_user_trig(instQdma_s_axis_c2h_cmpt_ctrl_user_trig),
    .s_axis_c2h_cmpt_ctrl_col_idx(instQdma_s_axis_c2h_cmpt_ctrl_col_idx),
    .s_axis_c2h_cmpt_ctrl_err_idx(instQdma_s_axis_c2h_cmpt_ctrl_err_idx),
    .h2c_byp_out_rdy(instQdma_h2c_byp_out_rdy),
    .c2h_byp_out_rdy(instQdma_c2h_byp_out_rdy),
    .tm_dsc_sts_rdy(instQdma_tm_dsc_sts_rdy),
    .dsc_crdt_in_vld(instQdma_dsc_crdt_in_vld),
    .dsc_crdt_in_rdy(instQdma_dsc_crdt_in_rdy),
    .dsc_crdt_in_dir(instQdma_dsc_crdt_in_dir),
    .dsc_crdt_in_fence(instQdma_dsc_crdt_in_fence),
    .dsc_crdt_in_qid(instQdma_dsc_crdt_in_qid),
    .dsc_crdt_in_crdt(instQdma_dsc_crdt_in_crdt),
    .qsts_out_rdy(instQdma_qsts_out_rdy),
    .usr_irq_in_vld(instQdma_usr_irq_in_vld),
    .usr_irq_in_vec(instQdma_usr_irq_in_vec),
    .usr_irq_in_fnc(instQdma_usr_irq_in_fnc),
    .usr_irq_out_ack(instQdma_usr_irq_out_ack),
    .usr_irq_out_fail(instQdma_usr_irq_out_fail),
    .s_axib_awid(instQdma_s_axib_awid),
    .s_axib_awaddr(instQdma_s_axib_awaddr),
    .s_axib_awlen(instQdma_s_axib_awlen),
    .s_axib_awsize(instQdma_s_axib_awsize),
    .s_axib_awuser(instQdma_s_axib_awuser),
    .s_axib_awburst(instQdma_s_axib_awburst),
    .s_axib_awregion(instQdma_s_axib_awregion),
    .s_axib_awvalid(instQdma_s_axib_awvalid),
    .s_axib_awready(instQdma_s_axib_awready),
    .s_axib_wdata(instQdma_s_axib_wdata),
    .s_axib_wstrb(instQdma_s_axib_wstrb),
    .s_axib_wuser(instQdma_s_axib_wuser),
    .s_axib_wlast(instQdma_s_axib_wlast),
    .s_axib_wvalid(instQdma_s_axib_wvalid),
    .s_axib_wready(instQdma_s_axib_wready),
    .s_axib_bid(instQdma_s_axib_bid),
    .s_axib_bresp(instQdma_s_axib_bresp),
    .s_axib_bvalid(instQdma_s_axib_bvalid),
    .s_axib_bready(instQdma_s_axib_bready),
    .s_axib_arid(instQdma_s_axib_arid),
    .s_axib_araddr(instQdma_s_axib_araddr),
    .s_axib_arlen(instQdma_s_axib_arlen),
    .s_axib_arsize(instQdma_s_axib_arsize),
    .s_axib_aruser(instQdma_s_axib_aruser),
    .s_axib_arburst(instQdma_s_axib_arburst),
    .s_axib_arregion(instQdma_s_axib_arregion),
    .s_axib_arvalid(instQdma_s_axib_arvalid),
    .s_axib_arready(instQdma_s_axib_arready),
    .s_axib_rid(instQdma_s_axib_rid),
    .s_axib_rdata(instQdma_s_axib_rdata),
    .s_axib_rresp(instQdma_s_axib_rresp),
    .s_axib_ruser(instQdma_s_axib_ruser),
    .s_axib_rlast(instQdma_s_axib_rlast),
    .s_axib_rvalid(instQdma_s_axib_rvalid),
    .s_axib_rready(instQdma_s_axib_rready),
    .st_rx_msg_data(instQdma_st_rx_msg_data),
    .st_rx_msg_last(instQdma_st_rx_msg_last),
    .st_rx_msg_rdy(instQdma_st_rx_msg_rdy),
    .st_rx_msg_valid(instQdma_st_rx_msg_valid)
  );
  IBUFDS_GTE4 #(.REFCLK_EN_TX_PATH(0), .REFCLK_HROW_CK_SEL(0), .REFCLK_ICNTL_RX(0)) ibufds_gte4_inst ( // @[StaticU280Top.scala 44:38]
    .O(ibufds_gte4_inst_O),
    .ODIV2(ibufds_gte4_inst_ODIV2),
    .CEB(ibufds_gte4_inst_CEB),
    .I(ibufds_gte4_inst_I),
    .IB(ibufds_gte4_inst_IB)
  );
  IBUF instQdma_io_sys_rst_n_pad ( // @[Buf.scala 17:34]
    .O(instQdma_io_sys_rst_n_pad_O),
    .I(instQdma_io_sys_rst_n_pad_I)
  );
  MMCME4_ADV_Wrapper mmcmUsrClk ( // @[StaticU280Top.scala 60:33]
    .io_CLKIN1(mmcmUsrClk_io_CLKIN1),
    .io_LOCKED(mmcmUsrClk_io_LOCKED),
    .io_CLKOUT0(mmcmUsrClk_io_CLKOUT0)
  );
  AlveoDynamicTop core ( // @[StaticU280Top.scala 343:26]
    .clock(core_clock),
    .reset(core_reset),
    .io_sysClk(core_io_sysClk),
    .io_cmacPin_tx_p(core_io_cmacPin_tx_p),
    .io_cmacPin_tx_n(core_io_cmacPin_tx_n),
    .io_cmacPin_rx_p(core_io_cmacPin_rx_p),
    .io_cmacPin_rx_n(core_io_cmacPin_rx_n),
    .io_cmacPin_gt_clk_p(core_io_cmacPin_gt_clk_p),
    .io_cmacPin_gt_clk_n(core_io_cmacPin_gt_clk_n),
    .io_qdma_axi_aclk(core_io_qdma_axi_aclk),
    .io_qdma_axi_aresetn(core_io_qdma_axi_aresetn),
    .io_qdma_m_axib_awid(core_io_qdma_m_axib_awid),
    .io_qdma_m_axib_awaddr(core_io_qdma_m_axib_awaddr),
    .io_qdma_m_axib_awlen(core_io_qdma_m_axib_awlen),
    .io_qdma_m_axib_awsize(core_io_qdma_m_axib_awsize),
    .io_qdma_m_axib_awburst(core_io_qdma_m_axib_awburst),
    .io_qdma_m_axib_awprot(core_io_qdma_m_axib_awprot),
    .io_qdma_m_axib_awlock(core_io_qdma_m_axib_awlock),
    .io_qdma_m_axib_awcache(core_io_qdma_m_axib_awcache),
    .io_qdma_m_axib_awvalid(core_io_qdma_m_axib_awvalid),
    .io_qdma_m_axib_awready(core_io_qdma_m_axib_awready),
    .io_qdma_m_axib_wdata(core_io_qdma_m_axib_wdata),
    .io_qdma_m_axib_wstrb(core_io_qdma_m_axib_wstrb),
    .io_qdma_m_axib_wlast(core_io_qdma_m_axib_wlast),
    .io_qdma_m_axib_wvalid(core_io_qdma_m_axib_wvalid),
    .io_qdma_m_axib_wready(core_io_qdma_m_axib_wready),
    .io_qdma_m_axib_bid(core_io_qdma_m_axib_bid),
    .io_qdma_m_axib_bresp(core_io_qdma_m_axib_bresp),
    .io_qdma_m_axib_bvalid(core_io_qdma_m_axib_bvalid),
    .io_qdma_m_axib_bready(core_io_qdma_m_axib_bready),
    .io_qdma_m_axib_arid(core_io_qdma_m_axib_arid),
    .io_qdma_m_axib_araddr(core_io_qdma_m_axib_araddr),
    .io_qdma_m_axib_arlen(core_io_qdma_m_axib_arlen),
    .io_qdma_m_axib_arsize(core_io_qdma_m_axib_arsize),
    .io_qdma_m_axib_arburst(core_io_qdma_m_axib_arburst),
    .io_qdma_m_axib_arprot(core_io_qdma_m_axib_arprot),
    .io_qdma_m_axib_arlock(core_io_qdma_m_axib_arlock),
    .io_qdma_m_axib_arcache(core_io_qdma_m_axib_arcache),
    .io_qdma_m_axib_arvalid(core_io_qdma_m_axib_arvalid),
    .io_qdma_m_axib_arready(core_io_qdma_m_axib_arready),
    .io_qdma_m_axib_rid(core_io_qdma_m_axib_rid),
    .io_qdma_m_axib_rdata(core_io_qdma_m_axib_rdata),
    .io_qdma_m_axib_rresp(core_io_qdma_m_axib_rresp),
    .io_qdma_m_axib_rlast(core_io_qdma_m_axib_rlast),
    .io_qdma_m_axib_rvalid(core_io_qdma_m_axib_rvalid),
    .io_qdma_m_axib_rready(core_io_qdma_m_axib_rready),
    .io_qdma_m_axil_awaddr(core_io_qdma_m_axil_awaddr),
    .io_qdma_m_axil_awvalid(core_io_qdma_m_axil_awvalid),
    .io_qdma_m_axil_awready(core_io_qdma_m_axil_awready),
    .io_qdma_m_axil_wdata(core_io_qdma_m_axil_wdata),
    .io_qdma_m_axil_wstrb(core_io_qdma_m_axil_wstrb),
    .io_qdma_m_axil_wvalid(core_io_qdma_m_axil_wvalid),
    .io_qdma_m_axil_wready(core_io_qdma_m_axil_wready),
    .io_qdma_m_axil_bresp(core_io_qdma_m_axil_bresp),
    .io_qdma_m_axil_bvalid(core_io_qdma_m_axil_bvalid),
    .io_qdma_m_axil_bready(core_io_qdma_m_axil_bready),
    .io_qdma_m_axil_araddr(core_io_qdma_m_axil_araddr),
    .io_qdma_m_axil_arvalid(core_io_qdma_m_axil_arvalid),
    .io_qdma_m_axil_arready(core_io_qdma_m_axil_arready),
    .io_qdma_m_axil_rdata(core_io_qdma_m_axil_rdata),
    .io_qdma_m_axil_rresp(core_io_qdma_m_axil_rresp),
    .io_qdma_m_axil_rvalid(core_io_qdma_m_axil_rvalid),
    .io_qdma_m_axil_rready(core_io_qdma_m_axil_rready),
    .io_qdma_soft_reset_n(core_io_qdma_soft_reset_n),
    .io_qdma_h2c_byp_in_st_addr(core_io_qdma_h2c_byp_in_st_addr),
    .io_qdma_h2c_byp_in_st_len(core_io_qdma_h2c_byp_in_st_len),
    .io_qdma_h2c_byp_in_st_eop(core_io_qdma_h2c_byp_in_st_eop),
    .io_qdma_h2c_byp_in_st_sop(core_io_qdma_h2c_byp_in_st_sop),
    .io_qdma_h2c_byp_in_st_mrkr_req(core_io_qdma_h2c_byp_in_st_mrkr_req),
    .io_qdma_h2c_byp_in_st_sdi(core_io_qdma_h2c_byp_in_st_sdi),
    .io_qdma_h2c_byp_in_st_qid(core_io_qdma_h2c_byp_in_st_qid),
    .io_qdma_h2c_byp_in_st_error(core_io_qdma_h2c_byp_in_st_error),
    .io_qdma_h2c_byp_in_st_func(core_io_qdma_h2c_byp_in_st_func),
    .io_qdma_h2c_byp_in_st_cidx(core_io_qdma_h2c_byp_in_st_cidx),
    .io_qdma_h2c_byp_in_st_port_id(core_io_qdma_h2c_byp_in_st_port_id),
    .io_qdma_h2c_byp_in_st_no_dma(core_io_qdma_h2c_byp_in_st_no_dma),
    .io_qdma_h2c_byp_in_st_vld(core_io_qdma_h2c_byp_in_st_vld),
    .io_qdma_h2c_byp_in_st_rdy(core_io_qdma_h2c_byp_in_st_rdy),
    .io_qdma_c2h_byp_in_st_csh_addr(core_io_qdma_c2h_byp_in_st_csh_addr),
    .io_qdma_c2h_byp_in_st_csh_qid(core_io_qdma_c2h_byp_in_st_csh_qid),
    .io_qdma_c2h_byp_in_st_csh_error(core_io_qdma_c2h_byp_in_st_csh_error),
    .io_qdma_c2h_byp_in_st_csh_func(core_io_qdma_c2h_byp_in_st_csh_func),
    .io_qdma_c2h_byp_in_st_csh_port_id(core_io_qdma_c2h_byp_in_st_csh_port_id),
    .io_qdma_c2h_byp_in_st_csh_pfch_tag(core_io_qdma_c2h_byp_in_st_csh_pfch_tag),
    .io_qdma_c2h_byp_in_st_csh_vld(core_io_qdma_c2h_byp_in_st_csh_vld),
    .io_qdma_c2h_byp_in_st_csh_rdy(core_io_qdma_c2h_byp_in_st_csh_rdy),
    .io_qdma_s_axis_c2h_tdata(core_io_qdma_s_axis_c2h_tdata),
    .io_qdma_s_axis_c2h_tcrc(core_io_qdma_s_axis_c2h_tcrc),
    .io_qdma_s_axis_c2h_ctrl_marker(core_io_qdma_s_axis_c2h_ctrl_marker),
    .io_qdma_s_axis_c2h_ctrl_ecc(core_io_qdma_s_axis_c2h_ctrl_ecc),
    .io_qdma_s_axis_c2h_ctrl_len(core_io_qdma_s_axis_c2h_ctrl_len),
    .io_qdma_s_axis_c2h_ctrl_port_id(core_io_qdma_s_axis_c2h_ctrl_port_id),
    .io_qdma_s_axis_c2h_ctrl_qid(core_io_qdma_s_axis_c2h_ctrl_qid),
    .io_qdma_s_axis_c2h_ctrl_has_cmpt(core_io_qdma_s_axis_c2h_ctrl_has_cmpt),
    .io_qdma_s_axis_c2h_mty(core_io_qdma_s_axis_c2h_mty),
    .io_qdma_s_axis_c2h_tlast(core_io_qdma_s_axis_c2h_tlast),
    .io_qdma_s_axis_c2h_tvalid(core_io_qdma_s_axis_c2h_tvalid),
    .io_qdma_s_axis_c2h_tready(core_io_qdma_s_axis_c2h_tready),
    .io_qdma_m_axis_h2c_tdata(core_io_qdma_m_axis_h2c_tdata),
    .io_qdma_m_axis_h2c_tcrc(core_io_qdma_m_axis_h2c_tcrc),
    .io_qdma_m_axis_h2c_tuser_qid(core_io_qdma_m_axis_h2c_tuser_qid),
    .io_qdma_m_axis_h2c_tuser_port_id(core_io_qdma_m_axis_h2c_tuser_port_id),
    .io_qdma_m_axis_h2c_tuser_err(core_io_qdma_m_axis_h2c_tuser_err),
    .io_qdma_m_axis_h2c_tuser_mdata(core_io_qdma_m_axis_h2c_tuser_mdata),
    .io_qdma_m_axis_h2c_tuser_mty(core_io_qdma_m_axis_h2c_tuser_mty),
    .io_qdma_m_axis_h2c_tuser_zero_byte(core_io_qdma_m_axis_h2c_tuser_zero_byte),
    .io_qdma_m_axis_h2c_tlast(core_io_qdma_m_axis_h2c_tlast),
    .io_qdma_m_axis_h2c_tvalid(core_io_qdma_m_axis_h2c_tvalid),
    .io_qdma_m_axis_h2c_tready(core_io_qdma_m_axis_h2c_tready),
    .io_qdma_axis_c2h_status_drop(core_io_qdma_axis_c2h_status_drop),
    .io_qdma_axis_c2h_status_last(core_io_qdma_axis_c2h_status_last),
    .io_qdma_axis_c2h_status_cmp(core_io_qdma_axis_c2h_status_cmp),
    .io_qdma_axis_c2h_status_valid(core_io_qdma_axis_c2h_status_valid),
    .io_qdma_axis_c2h_status_qid(core_io_qdma_axis_c2h_status_qid),
    .io_qdma_s_axis_c2h_cmpt_tdata(core_io_qdma_s_axis_c2h_cmpt_tdata),
    .io_qdma_s_axis_c2h_cmpt_size(core_io_qdma_s_axis_c2h_cmpt_size),
    .io_qdma_s_axis_c2h_cmpt_dpar(core_io_qdma_s_axis_c2h_cmpt_dpar),
    .io_qdma_s_axis_c2h_cmpt_tvalid(core_io_qdma_s_axis_c2h_cmpt_tvalid),
    .io_qdma_s_axis_c2h_cmpt_tready(core_io_qdma_s_axis_c2h_cmpt_tready),
    .io_qdma_s_axis_c2h_cmpt_ctrl_qid(core_io_qdma_s_axis_c2h_cmpt_ctrl_qid),
    .io_qdma_s_axis_c2h_cmpt_ctrl_cmpt_type(core_io_qdma_s_axis_c2h_cmpt_ctrl_cmpt_type),
    .io_qdma_s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id(core_io_qdma_s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id),
    .io_qdma_s_axis_c2h_cmpt_ctrl_no_wrb_marker(core_io_qdma_s_axis_c2h_cmpt_ctrl_no_wrb_marker),
    .io_qdma_s_axis_c2h_cmpt_ctrl_port_id(core_io_qdma_s_axis_c2h_cmpt_ctrl_port_id),
    .io_qdma_s_axis_c2h_cmpt_ctrl_marker(core_io_qdma_s_axis_c2h_cmpt_ctrl_marker),
    .io_qdma_s_axis_c2h_cmpt_ctrl_user_trig(core_io_qdma_s_axis_c2h_cmpt_ctrl_user_trig),
    .io_qdma_s_axis_c2h_cmpt_ctrl_col_idx(core_io_qdma_s_axis_c2h_cmpt_ctrl_col_idx),
    .io_qdma_s_axis_c2h_cmpt_ctrl_err_idx(core_io_qdma_s_axis_c2h_cmpt_ctrl_err_idx),
    .io_qdma_h2c_byp_out_rdy(core_io_qdma_h2c_byp_out_rdy),
    .io_qdma_c2h_byp_out_rdy(core_io_qdma_c2h_byp_out_rdy),
    .io_qdma_tm_dsc_sts_rdy(core_io_qdma_tm_dsc_sts_rdy),
    .io_qdma_dsc_crdt_in_vld(core_io_qdma_dsc_crdt_in_vld),
    .io_qdma_dsc_crdt_in_rdy(core_io_qdma_dsc_crdt_in_rdy),
    .io_qdma_dsc_crdt_in_dir(core_io_qdma_dsc_crdt_in_dir),
    .io_qdma_dsc_crdt_in_fence(core_io_qdma_dsc_crdt_in_fence),
    .io_qdma_dsc_crdt_in_qid(core_io_qdma_dsc_crdt_in_qid),
    .io_qdma_dsc_crdt_in_crdt(core_io_qdma_dsc_crdt_in_crdt),
    .io_qdma_qsts_out_rdy(core_io_qdma_qsts_out_rdy),
    .io_qdma_usr_irq_in_vld(core_io_qdma_usr_irq_in_vld),
    .io_qdma_usr_irq_in_vec(core_io_qdma_usr_irq_in_vec),
    .io_qdma_usr_irq_in_fnc(core_io_qdma_usr_irq_in_fnc),
    .io_qdma_usr_irq_out_ack(core_io_qdma_usr_irq_out_ack),
    .io_qdma_usr_irq_out_fail(core_io_qdma_usr_irq_out_fail),
    .io_qdma_s_axib_awid(core_io_qdma_s_axib_awid),
    .io_qdma_s_axib_awaddr(core_io_qdma_s_axib_awaddr),
    .io_qdma_s_axib_awlen(core_io_qdma_s_axib_awlen),
    .io_qdma_s_axib_awsize(core_io_qdma_s_axib_awsize),
    .io_qdma_s_axib_awuser(core_io_qdma_s_axib_awuser),
    .io_qdma_s_axib_awburst(core_io_qdma_s_axib_awburst),
    .io_qdma_s_axib_awregion(core_io_qdma_s_axib_awregion),
    .io_qdma_s_axib_awvalid(core_io_qdma_s_axib_awvalid),
    .io_qdma_s_axib_awready(core_io_qdma_s_axib_awready),
    .io_qdma_s_axib_wdata(core_io_qdma_s_axib_wdata),
    .io_qdma_s_axib_wstrb(core_io_qdma_s_axib_wstrb),
    .io_qdma_s_axib_wuser(core_io_qdma_s_axib_wuser),
    .io_qdma_s_axib_wlast(core_io_qdma_s_axib_wlast),
    .io_qdma_s_axib_wvalid(core_io_qdma_s_axib_wvalid),
    .io_qdma_s_axib_wready(core_io_qdma_s_axib_wready),
    .io_qdma_s_axib_bid(core_io_qdma_s_axib_bid),
    .io_qdma_s_axib_bresp(core_io_qdma_s_axib_bresp),
    .io_qdma_s_axib_bvalid(core_io_qdma_s_axib_bvalid),
    .io_qdma_s_axib_bready(core_io_qdma_s_axib_bready),
    .io_qdma_s_axib_arid(core_io_qdma_s_axib_arid),
    .io_qdma_s_axib_araddr(core_io_qdma_s_axib_araddr),
    .io_qdma_s_axib_arlen(core_io_qdma_s_axib_arlen),
    .io_qdma_s_axib_arsize(core_io_qdma_s_axib_arsize),
    .io_qdma_s_axib_aruser(core_io_qdma_s_axib_aruser),
    .io_qdma_s_axib_arburst(core_io_qdma_s_axib_arburst),
    .io_qdma_s_axib_arregion(core_io_qdma_s_axib_arregion),
    .io_qdma_s_axib_arvalid(core_io_qdma_s_axib_arvalid),
    .io_qdma_s_axib_arready(core_io_qdma_s_axib_arready),
    .io_qdma_s_axib_rid(core_io_qdma_s_axib_rid),
    .io_qdma_s_axib_rdata(core_io_qdma_s_axib_rdata),
    .io_qdma_s_axib_rresp(core_io_qdma_s_axib_rresp),
    .io_qdma_s_axib_ruser(core_io_qdma_s_axib_ruser),
    .io_qdma_s_axib_rlast(core_io_qdma_s_axib_rlast),
    .io_qdma_s_axib_rvalid(core_io_qdma_s_axib_rvalid),
    .io_qdma_s_axib_rready(core_io_qdma_s_axib_rready),
    .io_qdma_st_rx_msg_data(core_io_qdma_st_rx_msg_data),
    .io_qdma_st_rx_msg_last(core_io_qdma_st_rx_msg_last),
    .io_qdma_st_rx_msg_rdy(core_io_qdma_st_rx_msg_rdy),
    .io_qdma_st_rx_msg_valid(core_io_qdma_st_rx_msg_valid),
    .S_BSCAN_drck(core_S_BSCAN_drck),
    .S_BSCAN_shift(core_S_BSCAN_shift),
    .S_BSCAN_tdi(core_S_BSCAN_tdi),
    .S_BSCAN_update(core_S_BSCAN_update),
    .S_BSCAN_sel(core_S_BSCAN_sel),
    .S_BSCAN_tdo(core_S_BSCAN_tdo),
    .S_BSCAN_tms(core_S_BSCAN_tms),
    .S_BSCAN_tck(core_S_BSCAN_tck),
    .S_BSCAN_runtest(core_S_BSCAN_runtest),
    .S_BSCAN_reset(core_S_BSCAN_reset),
    .S_BSCAN_capture(core_S_BSCAN_capture),
    .S_BSCAN_bscanid_en(core_S_BSCAN_bscanid_en)
  );
  assign qdmaPin_tx_p = instQdma_pci_exp_txp[7:0]; // @[StaticU280Top.scala 56:33]
  assign qdmaPin_tx_n = instQdma_pci_exp_txn[7:0]; // @[StaticU280Top.scala 55:33]
  assign cmacPin_tx_p = core_io_cmacPin_tx_p; // @[StaticU280Top.scala 349:41]
  assign cmacPin_tx_n = core_io_cmacPin_tx_n; // @[StaticU280Top.scala 350:41]
  assign hbmCattrip = 1'h0; // @[StaticU280Top.scala 32:25]
  assign sysClk_pad_I = sysClkP; // @[Buf.scala 52:26]
  assign sysClk_pad_IB = sysClkN; // @[Buf.scala 53:27]
  assign sysClk_pad_1_I = sysClk_pad_O; // @[Buf.scala 34:26]
  assign instQdma_sys_rst_n = instQdma_io_sys_rst_n_pad_O; // @[StaticU280Top.scala 51:33]
  assign instQdma_sys_clk = ibufds_gte4_inst_ODIV2; // @[StaticU280Top.scala 52:41]
  assign instQdma_sys_clk_gt = ibufds_gte4_inst_O; // @[StaticU280Top.scala 53:33]
  assign instQdma_pci_exp_rxn = {{8'd0}, qdmaPin_rx_n}; // @[StaticU280Top.scala 57:33]
  assign instQdma_pci_exp_rxp = {{8'd0}, qdmaPin_rx_p}; // @[StaticU280Top.scala 58:33]
  assign instQdma_m_axib_awready = core_io_qdma_m_axib_awready; // @[StaticU280Top.scala 368:70]
  assign instQdma_m_axib_wready = core_io_qdma_m_axib_wready; // @[StaticU280Top.scala 373:70]
  assign instQdma_m_axib_bid = core_io_qdma_m_axib_bid; // @[StaticU280Top.scala 374:70]
  assign instQdma_m_axib_bresp = core_io_qdma_m_axib_bresp; // @[StaticU280Top.scala 375:70]
  assign instQdma_m_axib_bvalid = core_io_qdma_m_axib_bvalid; // @[StaticU280Top.scala 376:70]
  assign instQdma_m_axib_arready = core_io_qdma_m_axib_arready; // @[StaticU280Top.scala 387:70]
  assign instQdma_m_axib_rid = core_io_qdma_m_axib_rid; // @[StaticU280Top.scala 388:70]
  assign instQdma_m_axib_rdata = core_io_qdma_m_axib_rdata; // @[StaticU280Top.scala 389:70]
  assign instQdma_m_axib_rresp = core_io_qdma_m_axib_rresp; // @[StaticU280Top.scala 390:70]
  assign instQdma_m_axib_rlast = core_io_qdma_m_axib_rlast; // @[StaticU280Top.scala 391:70]
  assign instQdma_m_axib_rvalid = core_io_qdma_m_axib_rvalid; // @[StaticU280Top.scala 392:70]
  assign instQdma_m_axil_awready = core_io_qdma_m_axil_awready; // @[StaticU280Top.scala 396:70]
  assign instQdma_m_axil_wready = core_io_qdma_m_axil_wready; // @[StaticU280Top.scala 400:70]
  assign instQdma_m_axil_bresp = core_io_qdma_m_axil_bresp; // @[StaticU280Top.scala 401:70]
  assign instQdma_m_axil_bvalid = core_io_qdma_m_axil_bvalid; // @[StaticU280Top.scala 402:70]
  assign instQdma_m_axil_arready = core_io_qdma_m_axil_arready; // @[StaticU280Top.scala 406:70]
  assign instQdma_m_axil_rdata = core_io_qdma_m_axil_rdata; // @[StaticU280Top.scala 407:70]
  assign instQdma_m_axil_rresp = core_io_qdma_m_axil_rresp; // @[StaticU280Top.scala 408:70]
  assign instQdma_m_axil_rvalid = core_io_qdma_m_axil_rvalid; // @[StaticU280Top.scala 409:70]
  assign instQdma_soft_reset_n = core_io_qdma_soft_reset_n; // @[StaticU280Top.scala 411:70]
  assign instQdma_h2c_byp_in_st_addr = core_io_qdma_h2c_byp_in_st_addr; // @[StaticU280Top.scala 412:70]
  assign instQdma_h2c_byp_in_st_len = core_io_qdma_h2c_byp_in_st_len; // @[StaticU280Top.scala 413:70]
  assign instQdma_h2c_byp_in_st_eop = core_io_qdma_h2c_byp_in_st_eop; // @[StaticU280Top.scala 414:70]
  assign instQdma_h2c_byp_in_st_sop = core_io_qdma_h2c_byp_in_st_sop; // @[StaticU280Top.scala 415:70]
  assign instQdma_h2c_byp_in_st_mrkr_req = core_io_qdma_h2c_byp_in_st_mrkr_req; // @[StaticU280Top.scala 416:70]
  assign instQdma_h2c_byp_in_st_sdi = core_io_qdma_h2c_byp_in_st_sdi; // @[StaticU280Top.scala 417:70]
  assign instQdma_h2c_byp_in_st_qid = core_io_qdma_h2c_byp_in_st_qid; // @[StaticU280Top.scala 418:70]
  assign instQdma_h2c_byp_in_st_error = core_io_qdma_h2c_byp_in_st_error; // @[StaticU280Top.scala 419:70]
  assign instQdma_h2c_byp_in_st_func = core_io_qdma_h2c_byp_in_st_func; // @[StaticU280Top.scala 420:70]
  assign instQdma_h2c_byp_in_st_cidx = core_io_qdma_h2c_byp_in_st_cidx; // @[StaticU280Top.scala 421:70]
  assign instQdma_h2c_byp_in_st_port_id = core_io_qdma_h2c_byp_in_st_port_id; // @[StaticU280Top.scala 422:70]
  assign instQdma_h2c_byp_in_st_no_dma = core_io_qdma_h2c_byp_in_st_no_dma; // @[StaticU280Top.scala 423:70]
  assign instQdma_h2c_byp_in_st_vld = core_io_qdma_h2c_byp_in_st_vld; // @[StaticU280Top.scala 424:70]
  assign instQdma_c2h_byp_in_st_csh_addr = core_io_qdma_c2h_byp_in_st_csh_addr; // @[StaticU280Top.scala 426:70]
  assign instQdma_c2h_byp_in_st_csh_qid = core_io_qdma_c2h_byp_in_st_csh_qid; // @[StaticU280Top.scala 427:70]
  assign instQdma_c2h_byp_in_st_csh_error = core_io_qdma_c2h_byp_in_st_csh_error; // @[StaticU280Top.scala 428:70]
  assign instQdma_c2h_byp_in_st_csh_func = core_io_qdma_c2h_byp_in_st_csh_func; // @[StaticU280Top.scala 429:70]
  assign instQdma_c2h_byp_in_st_csh_port_id = core_io_qdma_c2h_byp_in_st_csh_port_id; // @[StaticU280Top.scala 430:70]
  assign instQdma_c2h_byp_in_st_csh_pfch_tag = core_io_qdma_c2h_byp_in_st_csh_pfch_tag; // @[StaticU280Top.scala 431:70]
  assign instQdma_c2h_byp_in_st_csh_vld = core_io_qdma_c2h_byp_in_st_csh_vld; // @[StaticU280Top.scala 432:70]
  assign instQdma_s_axis_c2h_tdata = core_io_qdma_s_axis_c2h_tdata; // @[StaticU280Top.scala 434:70]
  assign instQdma_s_axis_c2h_tcrc = core_io_qdma_s_axis_c2h_tcrc; // @[StaticU280Top.scala 435:70]
  assign instQdma_s_axis_c2h_ctrl_marker = core_io_qdma_s_axis_c2h_ctrl_marker; // @[StaticU280Top.scala 436:70]
  assign instQdma_s_axis_c2h_ctrl_ecc = core_io_qdma_s_axis_c2h_ctrl_ecc; // @[StaticU280Top.scala 437:70]
  assign instQdma_s_axis_c2h_ctrl_len = core_io_qdma_s_axis_c2h_ctrl_len; // @[StaticU280Top.scala 438:70]
  assign instQdma_s_axis_c2h_ctrl_port_id = core_io_qdma_s_axis_c2h_ctrl_port_id; // @[StaticU280Top.scala 439:70]
  assign instQdma_s_axis_c2h_ctrl_qid = core_io_qdma_s_axis_c2h_ctrl_qid; // @[StaticU280Top.scala 440:70]
  assign instQdma_s_axis_c2h_ctrl_has_cmpt = core_io_qdma_s_axis_c2h_ctrl_has_cmpt; // @[StaticU280Top.scala 441:70]
  assign instQdma_s_axis_c2h_mty = core_io_qdma_s_axis_c2h_mty; // @[StaticU280Top.scala 442:70]
  assign instQdma_s_axis_c2h_tlast = core_io_qdma_s_axis_c2h_tlast; // @[StaticU280Top.scala 443:70]
  assign instQdma_s_axis_c2h_tvalid = core_io_qdma_s_axis_c2h_tvalid; // @[StaticU280Top.scala 444:70]
  assign instQdma_m_axis_h2c_tready = core_io_qdma_m_axis_h2c_tready; // @[StaticU280Top.scala 456:70]
  assign instQdma_s_axis_c2h_cmpt_tdata = core_io_qdma_s_axis_c2h_cmpt_tdata; // @[StaticU280Top.scala 462:70]
  assign instQdma_s_axis_c2h_cmpt_size = core_io_qdma_s_axis_c2h_cmpt_size; // @[StaticU280Top.scala 463:70]
  assign instQdma_s_axis_c2h_cmpt_dpar = core_io_qdma_s_axis_c2h_cmpt_dpar; // @[StaticU280Top.scala 464:70]
  assign instQdma_s_axis_c2h_cmpt_tvalid = core_io_qdma_s_axis_c2h_cmpt_tvalid; // @[StaticU280Top.scala 465:70]
  assign instQdma_s_axis_c2h_cmpt_ctrl_qid = core_io_qdma_s_axis_c2h_cmpt_ctrl_qid; // @[StaticU280Top.scala 467:70]
  assign instQdma_s_axis_c2h_cmpt_ctrl_cmpt_type = core_io_qdma_s_axis_c2h_cmpt_ctrl_cmpt_type; // @[StaticU280Top.scala 468:70]
  assign instQdma_s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id = core_io_qdma_s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id; // @[StaticU280Top.scala 469:70]
  assign instQdma_s_axis_c2h_cmpt_ctrl_no_wrb_marker = core_io_qdma_s_axis_c2h_cmpt_ctrl_no_wrb_marker; // @[StaticU280Top.scala 470:70]
  assign instQdma_s_axis_c2h_cmpt_ctrl_port_id = core_io_qdma_s_axis_c2h_cmpt_ctrl_port_id; // @[StaticU280Top.scala 471:70]
  assign instQdma_s_axis_c2h_cmpt_ctrl_marker = core_io_qdma_s_axis_c2h_cmpt_ctrl_marker; // @[StaticU280Top.scala 472:70]
  assign instQdma_s_axis_c2h_cmpt_ctrl_user_trig = core_io_qdma_s_axis_c2h_cmpt_ctrl_user_trig; // @[StaticU280Top.scala 473:70]
  assign instQdma_s_axis_c2h_cmpt_ctrl_col_idx = core_io_qdma_s_axis_c2h_cmpt_ctrl_col_idx; // @[StaticU280Top.scala 474:70]
  assign instQdma_s_axis_c2h_cmpt_ctrl_err_idx = core_io_qdma_s_axis_c2h_cmpt_ctrl_err_idx; // @[StaticU280Top.scala 475:70]
  assign instQdma_h2c_byp_out_rdy = core_io_qdma_h2c_byp_out_rdy; // @[StaticU280Top.scala 476:70]
  assign instQdma_c2h_byp_out_rdy = core_io_qdma_c2h_byp_out_rdy; // @[StaticU280Top.scala 477:70]
  assign instQdma_tm_dsc_sts_rdy = core_io_qdma_tm_dsc_sts_rdy; // @[StaticU280Top.scala 478:70]
  assign instQdma_dsc_crdt_in_vld = core_io_qdma_dsc_crdt_in_vld; // @[StaticU280Top.scala 479:70]
  assign instQdma_dsc_crdt_in_dir = core_io_qdma_dsc_crdt_in_dir; // @[StaticU280Top.scala 481:70]
  assign instQdma_dsc_crdt_in_fence = core_io_qdma_dsc_crdt_in_fence; // @[StaticU280Top.scala 482:70]
  assign instQdma_dsc_crdt_in_qid = core_io_qdma_dsc_crdt_in_qid; // @[StaticU280Top.scala 483:70]
  assign instQdma_dsc_crdt_in_crdt = core_io_qdma_dsc_crdt_in_crdt; // @[StaticU280Top.scala 484:70]
  assign instQdma_qsts_out_rdy = core_io_qdma_qsts_out_rdy; // @[StaticU280Top.scala 485:70]
  assign instQdma_usr_irq_in_vld = core_io_qdma_usr_irq_in_vld; // @[StaticU280Top.scala 486:70]
  assign instQdma_usr_irq_in_vec = core_io_qdma_usr_irq_in_vec; // @[StaticU280Top.scala 487:70]
  assign instQdma_usr_irq_in_fnc = core_io_qdma_usr_irq_in_fnc; // @[StaticU280Top.scala 488:70]
  assign instQdma_s_axib_awid = core_io_qdma_s_axib_awid; // @[StaticU280Top.scala 491:70]
  assign instQdma_s_axib_awaddr = core_io_qdma_s_axib_awaddr; // @[StaticU280Top.scala 492:70]
  assign instQdma_s_axib_awlen = core_io_qdma_s_axib_awlen; // @[StaticU280Top.scala 493:70]
  assign instQdma_s_axib_awsize = core_io_qdma_s_axib_awsize; // @[StaticU280Top.scala 494:70]
  assign instQdma_s_axib_awuser = core_io_qdma_s_axib_awuser; // @[StaticU280Top.scala 495:70]
  assign instQdma_s_axib_awburst = core_io_qdma_s_axib_awburst; // @[StaticU280Top.scala 496:70]
  assign instQdma_s_axib_awregion = core_io_qdma_s_axib_awregion; // @[StaticU280Top.scala 497:70]
  assign instQdma_s_axib_awvalid = core_io_qdma_s_axib_awvalid; // @[StaticU280Top.scala 498:70]
  assign instQdma_s_axib_wdata = core_io_qdma_s_axib_wdata; // @[StaticU280Top.scala 500:70]
  assign instQdma_s_axib_wstrb = core_io_qdma_s_axib_wstrb; // @[StaticU280Top.scala 501:70]
  assign instQdma_s_axib_wuser = core_io_qdma_s_axib_wuser; // @[StaticU280Top.scala 502:70]
  assign instQdma_s_axib_wlast = core_io_qdma_s_axib_wlast; // @[StaticU280Top.scala 503:70]
  assign instQdma_s_axib_wvalid = core_io_qdma_s_axib_wvalid; // @[StaticU280Top.scala 504:70]
  assign instQdma_s_axib_bready = core_io_qdma_s_axib_bready; // @[StaticU280Top.scala 509:70]
  assign instQdma_s_axib_arid = core_io_qdma_s_axib_arid; // @[StaticU280Top.scala 510:70]
  assign instQdma_s_axib_araddr = core_io_qdma_s_axib_araddr; // @[StaticU280Top.scala 511:70]
  assign instQdma_s_axib_arlen = core_io_qdma_s_axib_arlen; // @[StaticU280Top.scala 512:70]
  assign instQdma_s_axib_arsize = core_io_qdma_s_axib_arsize; // @[StaticU280Top.scala 513:70]
  assign instQdma_s_axib_aruser = core_io_qdma_s_axib_aruser; // @[StaticU280Top.scala 514:70]
  assign instQdma_s_axib_arburst = core_io_qdma_s_axib_arburst; // @[StaticU280Top.scala 515:70]
  assign instQdma_s_axib_arregion = core_io_qdma_s_axib_arregion; // @[StaticU280Top.scala 516:70]
  assign instQdma_s_axib_arvalid = core_io_qdma_s_axib_arvalid; // @[StaticU280Top.scala 517:70]
  assign instQdma_s_axib_rready = core_io_qdma_s_axib_rready; // @[StaticU280Top.scala 525:70]
  assign instQdma_st_rx_msg_rdy = core_io_qdma_st_rx_msg_rdy; // @[StaticU280Top.scala 528:70]
  assign ibufds_gte4_inst_CEB = 1'h0; // @[StaticU280Top.scala 47:41]
  assign ibufds_gte4_inst_I = qdmaPin_sys_clk_p; // @[StaticU280Top.scala 46:41]
  assign ibufds_gte4_inst_IB = qdmaPin_sys_clk_n; // @[StaticU280Top.scala 45:41]
  assign instQdma_io_sys_rst_n_pad_I = qdmaPin_sys_rst_n; // @[Buf.scala 18:26]
  assign mmcmUsrClk_io_CLKIN1 = sysClk_pad_1_O; // @[StaticU280Top.scala 67:33]
  assign core_clock = mmcmUsrClk_io_CLKOUT0; // @[StaticU280Top.scala 346:44]
  assign core_reset = ~userRstn; // @[StaticU280Top.scala 347:36]
  assign core_io_sysClk = sysClk_pad_1_O; // @[StaticU280Top.scala 348:67]
  assign core_io_cmacPin_rx_p = cmacPin_rx_p; // @[StaticU280Top.scala 351:41]
  assign core_io_cmacPin_rx_n = cmacPin_rx_n; // @[StaticU280Top.scala 352:41]
  assign core_io_cmacPin_gt_clk_p = cmacPin_gt_clk_p; // @[StaticU280Top.scala 353:61]
  assign core_io_cmacPin_gt_clk_n = cmacPin_gt_clk_n; // @[StaticU280Top.scala 354:61]
  assign core_io_qdma_axi_aclk = instQdma_axi_aclk; // @[StaticU280Top.scala 357:122]
  assign core_io_qdma_axi_aresetn = instQdma_axi_aresetn; // @[StaticU280Top.scala 358:98]
  assign core_io_qdma_m_axib_awid = instQdma_m_axib_awid; // @[StaticU280Top.scala 359:70]
  assign core_io_qdma_m_axib_awaddr = instQdma_m_axib_awaddr; // @[StaticU280Top.scala 360:70]
  assign core_io_qdma_m_axib_awlen = instQdma_m_axib_awlen; // @[StaticU280Top.scala 361:70]
  assign core_io_qdma_m_axib_awsize = instQdma_m_axib_awsize; // @[StaticU280Top.scala 362:70]
  assign core_io_qdma_m_axib_awburst = instQdma_m_axib_awburst; // @[StaticU280Top.scala 363:70]
  assign core_io_qdma_m_axib_awprot = instQdma_m_axib_awprot; // @[StaticU280Top.scala 364:70]
  assign core_io_qdma_m_axib_awlock = instQdma_m_axib_awlock; // @[StaticU280Top.scala 365:70]
  assign core_io_qdma_m_axib_awcache = instQdma_m_axib_awcache; // @[StaticU280Top.scala 366:70]
  assign core_io_qdma_m_axib_awvalid = instQdma_m_axib_awvalid; // @[StaticU280Top.scala 367:70]
  assign core_io_qdma_m_axib_wdata = instQdma_m_axib_wdata; // @[StaticU280Top.scala 369:70]
  assign core_io_qdma_m_axib_wstrb = instQdma_m_axib_wstrb; // @[StaticU280Top.scala 370:70]
  assign core_io_qdma_m_axib_wlast = instQdma_m_axib_wlast; // @[StaticU280Top.scala 371:70]
  assign core_io_qdma_m_axib_wvalid = instQdma_m_axib_wvalid; // @[StaticU280Top.scala 372:70]
  assign core_io_qdma_m_axib_bready = instQdma_m_axib_bready; // @[StaticU280Top.scala 377:70]
  assign core_io_qdma_m_axib_arid = instQdma_m_axib_arid; // @[StaticU280Top.scala 378:70]
  assign core_io_qdma_m_axib_araddr = instQdma_m_axib_araddr; // @[StaticU280Top.scala 379:70]
  assign core_io_qdma_m_axib_arlen = instQdma_m_axib_arlen; // @[StaticU280Top.scala 380:70]
  assign core_io_qdma_m_axib_arsize = instQdma_m_axib_arsize; // @[StaticU280Top.scala 381:70]
  assign core_io_qdma_m_axib_arburst = instQdma_m_axib_arburst; // @[StaticU280Top.scala 382:70]
  assign core_io_qdma_m_axib_arprot = instQdma_m_axib_arprot; // @[StaticU280Top.scala 383:70]
  assign core_io_qdma_m_axib_arlock = instQdma_m_axib_arlock; // @[StaticU280Top.scala 384:70]
  assign core_io_qdma_m_axib_arcache = instQdma_m_axib_arcache; // @[StaticU280Top.scala 385:70]
  assign core_io_qdma_m_axib_arvalid = instQdma_m_axib_arvalid; // @[StaticU280Top.scala 386:70]
  assign core_io_qdma_m_axib_rready = instQdma_m_axib_rready; // @[StaticU280Top.scala 393:70]
  assign core_io_qdma_m_axil_awaddr = instQdma_m_axil_awaddr; // @[StaticU280Top.scala 394:70]
  assign core_io_qdma_m_axil_awvalid = instQdma_m_axil_awvalid; // @[StaticU280Top.scala 395:70]
  assign core_io_qdma_m_axil_wdata = instQdma_m_axil_wdata; // @[StaticU280Top.scala 397:70]
  assign core_io_qdma_m_axil_wstrb = instQdma_m_axil_wstrb; // @[StaticU280Top.scala 398:70]
  assign core_io_qdma_m_axil_wvalid = instQdma_m_axil_wvalid; // @[StaticU280Top.scala 399:70]
  assign core_io_qdma_m_axil_bready = instQdma_m_axil_bready; // @[StaticU280Top.scala 403:70]
  assign core_io_qdma_m_axil_araddr = instQdma_m_axil_araddr; // @[StaticU280Top.scala 404:70]
  assign core_io_qdma_m_axil_arvalid = instQdma_m_axil_arvalid; // @[StaticU280Top.scala 405:70]
  assign core_io_qdma_m_axil_rready = instQdma_m_axil_rready; // @[StaticU280Top.scala 410:70]
  assign core_io_qdma_h2c_byp_in_st_rdy = instQdma_h2c_byp_in_st_rdy; // @[StaticU280Top.scala 425:70]
  assign core_io_qdma_c2h_byp_in_st_csh_rdy = instQdma_c2h_byp_in_st_csh_rdy; // @[StaticU280Top.scala 433:70]
  assign core_io_qdma_s_axis_c2h_tready = instQdma_s_axis_c2h_tready; // @[StaticU280Top.scala 445:70]
  assign core_io_qdma_m_axis_h2c_tdata = instQdma_m_axis_h2c_tdata; // @[StaticU280Top.scala 446:70]
  assign core_io_qdma_m_axis_h2c_tcrc = instQdma_m_axis_h2c_tcrc; // @[StaticU280Top.scala 447:70]
  assign core_io_qdma_m_axis_h2c_tuser_qid = instQdma_m_axis_h2c_tuser_qid; // @[StaticU280Top.scala 448:70]
  assign core_io_qdma_m_axis_h2c_tuser_port_id = instQdma_m_axis_h2c_tuser_port_id; // @[StaticU280Top.scala 449:70]
  assign core_io_qdma_m_axis_h2c_tuser_err = instQdma_m_axis_h2c_tuser_err; // @[StaticU280Top.scala 450:70]
  assign core_io_qdma_m_axis_h2c_tuser_mdata = instQdma_m_axis_h2c_tuser_mdata; // @[StaticU280Top.scala 451:70]
  assign core_io_qdma_m_axis_h2c_tuser_mty = instQdma_m_axis_h2c_tuser_mty; // @[StaticU280Top.scala 452:70]
  assign core_io_qdma_m_axis_h2c_tuser_zero_byte = instQdma_m_axis_h2c_tuser_zero_byte; // @[StaticU280Top.scala 453:70]
  assign core_io_qdma_m_axis_h2c_tlast = instQdma_m_axis_h2c_tlast; // @[StaticU280Top.scala 454:70]
  assign core_io_qdma_m_axis_h2c_tvalid = instQdma_m_axis_h2c_tvalid; // @[StaticU280Top.scala 455:70]
  assign core_io_qdma_axis_c2h_status_drop = instQdma_axis_c2h_status_drop; // @[StaticU280Top.scala 457:70]
  assign core_io_qdma_axis_c2h_status_last = instQdma_axis_c2h_status_last; // @[StaticU280Top.scala 458:70]
  assign core_io_qdma_axis_c2h_status_cmp = instQdma_axis_c2h_status_cmp; // @[StaticU280Top.scala 459:70]
  assign core_io_qdma_axis_c2h_status_valid = instQdma_axis_c2h_status_valid; // @[StaticU280Top.scala 460:70]
  assign core_io_qdma_axis_c2h_status_qid = instQdma_axis_c2h_status_qid; // @[StaticU280Top.scala 461:70]
  assign core_io_qdma_s_axis_c2h_cmpt_tready = instQdma_s_axis_c2h_cmpt_tready; // @[StaticU280Top.scala 466:70]
  assign core_io_qdma_dsc_crdt_in_rdy = instQdma_dsc_crdt_in_rdy; // @[StaticU280Top.scala 480:70]
  assign core_io_qdma_usr_irq_out_ack = instQdma_usr_irq_out_ack; // @[StaticU280Top.scala 489:70]
  assign core_io_qdma_usr_irq_out_fail = instQdma_usr_irq_out_fail; // @[StaticU280Top.scala 490:70]
  assign core_io_qdma_s_axib_awready = instQdma_s_axib_awready; // @[StaticU280Top.scala 499:70]
  assign core_io_qdma_s_axib_wready = instQdma_s_axib_wready; // @[StaticU280Top.scala 505:70]
  assign core_io_qdma_s_axib_bid = instQdma_s_axib_bid; // @[StaticU280Top.scala 506:70]
  assign core_io_qdma_s_axib_bresp = instQdma_s_axib_bresp; // @[StaticU280Top.scala 507:70]
  assign core_io_qdma_s_axib_bvalid = instQdma_s_axib_bvalid; // @[StaticU280Top.scala 508:70]
  assign core_io_qdma_s_axib_arready = instQdma_s_axib_arready; // @[StaticU280Top.scala 518:70]
  assign core_io_qdma_s_axib_rid = instQdma_s_axib_rid; // @[StaticU280Top.scala 519:70]
  assign core_io_qdma_s_axib_rdata = instQdma_s_axib_rdata; // @[StaticU280Top.scala 520:70]
  assign core_io_qdma_s_axib_rresp = instQdma_s_axib_rresp; // @[StaticU280Top.scala 521:70]
  assign core_io_qdma_s_axib_ruser = instQdma_s_axib_ruser; // @[StaticU280Top.scala 522:70]
  assign core_io_qdma_s_axib_rlast = instQdma_s_axib_rlast; // @[StaticU280Top.scala 523:70]
  assign core_io_qdma_s_axib_rvalid = instQdma_s_axib_rvalid; // @[StaticU280Top.scala 524:70]
  assign core_io_qdma_st_rx_msg_data = instQdma_st_rx_msg_data; // @[StaticU280Top.scala 526:70]
  assign core_io_qdma_st_rx_msg_last = instQdma_st_rx_msg_last; // @[StaticU280Top.scala 527:70]
  assign core_io_qdma_st_rx_msg_valid = instQdma_st_rx_msg_valid; // @[StaticU280Top.scala 529:70]
  assign core_S_BSCAN_drck = 1'h0;
  assign core_S_BSCAN_shift = 1'h0;
  assign core_S_BSCAN_tdi = 1'h0;
  assign core_S_BSCAN_update = 1'h0;
  assign core_S_BSCAN_sel = 1'h0;
  assign core_S_BSCAN_tms = 1'h0;
  assign core_S_BSCAN_tck = 1'h0;
  assign core_S_BSCAN_runtest = 1'h0;
  assign core_S_BSCAN_reset = 1'h0;
  assign core_S_BSCAN_capture = 1'h0;
  assign core_S_BSCAN_bscanid_en = 1'h0;
endmodule
