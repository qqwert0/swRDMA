module DDR_DRIVER(
  input          io_ddriver_clk,
  output         io_ddrpin_act_n,
  output [16:0]  io_ddrpin_adr,
  output [1:0]   io_ddrpin_ba,
  output [1:0]   io_ddrpin_bg,
  output         io_ddrpin_cke,
  output         io_ddrpin_odt,
  output         io_ddrpin_cs_n,
  output         io_ddrpin_ck_t,
  output         io_ddrpin_ck_c,
  output         io_ddrpin_reset_n,
  output         io_ddrpin_parity,
  inout  [71:0]  io_ddrpin_dq,
  inout  [17:0]  io_ddrpin_dqs_t,
  inout  [17:0]  io_ddrpin_dqs_c,
  output         io_rst,
  output         io_axi_aw_ready,
  input          io_axi_aw_valid,
  input  [33:0]  io_axi_aw_bits_addr,
  input  [1:0]   io_axi_aw_bits_burst,
  input  [7:0]   io_axi_aw_bits_len,
  input  [2:0]   io_axi_aw_bits_size,
  output         io_axi_ar_ready,
  input          io_axi_ar_valid,
  input  [33:0]  io_axi_ar_bits_addr,
  input  [1:0]   io_axi_ar_bits_burst,
  input  [3:0]   io_axi_ar_bits_id,
  input  [7:0]   io_axi_ar_bits_len,
  input  [2:0]   io_axi_ar_bits_size,
  output         io_axi_w_ready,
  input          io_axi_w_valid,
  input  [511:0] io_axi_w_bits_data,
  input          io_axi_w_bits_last,
  input  [63:0]  io_axi_w_bits_strb,
  input          io_axi_r_ready,
  output         io_axi_r_valid,
  output [511:0] io_axi_r_bits_data,
  output         io_axi_r_bits_last,
  output [1:0]   io_axi_r_bits_resp,
  output [3:0]   io_axi_r_bits_id,
  output         io_axi_b_valid,
  output [3:0]   io_axi_b_bits_id,
  output [1:0]   io_axi_b_bits_resp
);
  wire  DDR0_sys_clk_pad_O; // @[Buf.scala 33:34]
  wire  DDR0_sys_clk_pad_I; // @[Buf.scala 33:34]
  wire  instDDR_sys_rst; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_sys_clk_i; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_init_calib_complete; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_act_n; // @[DDR_driver.scala 47:25]
  wire [16:0] instDDR_c0_ddr4_adr; // @[DDR_driver.scala 47:25]
  wire [1:0] instDDR_c0_ddr4_ba; // @[DDR_driver.scala 47:25]
  wire [1:0] instDDR_c0_ddr4_bg; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_cke; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_odt; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_cs_n; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_ck_t; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_ck_c; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_reset_n; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_parity; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_ui_clk; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_ui_clk_sync_rst; // @[DDR_driver.scala 47:25]
  wire  instDDR_addn_ui_clkout1; // @[DDR_driver.scala 47:25]
  wire  instDDR_dbg_clk; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_ctrl_awvalid; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_ctrl_awready; // @[DDR_driver.scala 47:25]
  wire [31:0] instDDR_c0_ddr4_s_axi_ctrl_awaddr; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_ctrl_wvalid; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_ctrl_wready; // @[DDR_driver.scala 47:25]
  wire [31:0] instDDR_c0_ddr4_s_axi_ctrl_wdata; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_ctrl_bvalid; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_ctrl_bready; // @[DDR_driver.scala 47:25]
  wire [1:0] instDDR_c0_ddr4_s_axi_ctrl_bresp; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_ctrl_arvalid; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_ctrl_arready; // @[DDR_driver.scala 47:25]
  wire [31:0] instDDR_c0_ddr4_s_axi_ctrl_araddr; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_ctrl_rvalid; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_ctrl_rready; // @[DDR_driver.scala 47:25]
  wire [31:0] instDDR_c0_ddr4_s_axi_ctrl_rdata; // @[DDR_driver.scala 47:25]
  wire [1:0] instDDR_c0_ddr4_s_axi_ctrl_rresp; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_interrupt; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_aresetn; // @[DDR_driver.scala 47:25]
  wire [3:0] instDDR_c0_ddr4_s_axi_awid; // @[DDR_driver.scala 47:25]
  wire [33:0] instDDR_c0_ddr4_s_axi_awaddr; // @[DDR_driver.scala 47:25]
  wire [7:0] instDDR_c0_ddr4_s_axi_awlen; // @[DDR_driver.scala 47:25]
  wire [2:0] instDDR_c0_ddr4_s_axi_awsize; // @[DDR_driver.scala 47:25]
  wire [1:0] instDDR_c0_ddr4_s_axi_awburst; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_awlock; // @[DDR_driver.scala 47:25]
  wire [3:0] instDDR_c0_ddr4_s_axi_awcache; // @[DDR_driver.scala 47:25]
  wire [2:0] instDDR_c0_ddr4_s_axi_awprot; // @[DDR_driver.scala 47:25]
  wire [3:0] instDDR_c0_ddr4_s_axi_awqos; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_awready; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_awvalid; // @[DDR_driver.scala 47:25]
  wire [511:0] instDDR_c0_ddr4_s_axi_wdata; // @[DDR_driver.scala 47:25]
  wire [63:0] instDDR_c0_ddr4_s_axi_wstrb; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_wlast; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_wvalid; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_wready; // @[DDR_driver.scala 47:25]
  wire [3:0] instDDR_c0_ddr4_s_axi_bid; // @[DDR_driver.scala 47:25]
  wire [1:0] instDDR_c0_ddr4_s_axi_bresp; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_bvalid; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_bready; // @[DDR_driver.scala 47:25]
  wire [3:0] instDDR_c0_ddr4_s_axi_arid; // @[DDR_driver.scala 47:25]
  wire [33:0] instDDR_c0_ddr4_s_axi_araddr; // @[DDR_driver.scala 47:25]
  wire [7:0] instDDR_c0_ddr4_s_axi_arlen; // @[DDR_driver.scala 47:25]
  wire [2:0] instDDR_c0_ddr4_s_axi_arsize; // @[DDR_driver.scala 47:25]
  wire [1:0] instDDR_c0_ddr4_s_axi_arburst; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_arlock; // @[DDR_driver.scala 47:25]
  wire [3:0] instDDR_c0_ddr4_s_axi_arcache; // @[DDR_driver.scala 47:25]
  wire [2:0] instDDR_c0_ddr4_s_axi_arprot; // @[DDR_driver.scala 47:25]
  wire [3:0] instDDR_c0_ddr4_s_axi_arqos; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_arready; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_arvalid; // @[DDR_driver.scala 47:25]
  wire [3:0] instDDR_c0_ddr4_s_axi_rid; // @[DDR_driver.scala 47:25]
  wire [511:0] instDDR_c0_ddr4_s_axi_rdata; // @[DDR_driver.scala 47:25]
  wire [1:0] instDDR_c0_ddr4_s_axi_rresp; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_rlast; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_rvalid; // @[DDR_driver.scala 47:25]
  wire  instDDR_c0_ddr4_s_axi_rready; // @[DDR_driver.scala 47:25]
  wire [511:0] instDDR_dbg_bus; // @[DDR_driver.scala 47:25]
  wire  init_complete = instDDR_c0_init_calib_complete; // @[DDR_driver.scala 28:31 DDR_driver.scala 51:29]
  BUFG DDR0_sys_clk_pad ( // @[Buf.scala 33:34]
    .O(DDR0_sys_clk_pad_O),
    .I(DDR0_sys_clk_pad_I)
  );
  DDR4_mig_blackbox instDDR ( // @[DDR_driver.scala 47:25]
    .sys_rst(instDDR_sys_rst),
    .c0_sys_clk_i(instDDR_c0_sys_clk_i),
    .c0_init_calib_complete(instDDR_c0_init_calib_complete),
    .c0_ddr4_act_n(instDDR_c0_ddr4_act_n),
    .c0_ddr4_adr(instDDR_c0_ddr4_adr),
    .c0_ddr4_ba(instDDR_c0_ddr4_ba),
    .c0_ddr4_bg(instDDR_c0_ddr4_bg),
    .c0_ddr4_cke(instDDR_c0_ddr4_cke),
    .c0_ddr4_odt(instDDR_c0_ddr4_odt),
    .c0_ddr4_cs_n(instDDR_c0_ddr4_cs_n),
    .c0_ddr4_ck_t(instDDR_c0_ddr4_ck_t),
    .c0_ddr4_ck_c(instDDR_c0_ddr4_ck_c),
    .c0_ddr4_reset_n(instDDR_c0_ddr4_reset_n),
    .c0_ddr4_parity(instDDR_c0_ddr4_parity),
    .c0_ddr4_dq(io_ddrpin_dq),
    .c0_ddr4_dqs_c(io_ddrpin_dqs_c),
    .c0_ddr4_dqs_t(io_ddrpin_dqs_t),
    .c0_ddr4_ui_clk(instDDR_c0_ddr4_ui_clk),
    .c0_ddr4_ui_clk_sync_rst(instDDR_c0_ddr4_ui_clk_sync_rst),
    .addn_ui_clkout1(instDDR_addn_ui_clkout1),
    .dbg_clk(instDDR_dbg_clk),
    .c0_ddr4_s_axi_ctrl_awvalid(instDDR_c0_ddr4_s_axi_ctrl_awvalid),
    .c0_ddr4_s_axi_ctrl_awready(instDDR_c0_ddr4_s_axi_ctrl_awready),
    .c0_ddr4_s_axi_ctrl_awaddr(instDDR_c0_ddr4_s_axi_ctrl_awaddr),
    .c0_ddr4_s_axi_ctrl_wvalid(instDDR_c0_ddr4_s_axi_ctrl_wvalid),
    .c0_ddr4_s_axi_ctrl_wready(instDDR_c0_ddr4_s_axi_ctrl_wready),
    .c0_ddr4_s_axi_ctrl_wdata(instDDR_c0_ddr4_s_axi_ctrl_wdata),
    .c0_ddr4_s_axi_ctrl_bvalid(instDDR_c0_ddr4_s_axi_ctrl_bvalid),
    .c0_ddr4_s_axi_ctrl_bready(instDDR_c0_ddr4_s_axi_ctrl_bready),
    .c0_ddr4_s_axi_ctrl_bresp(instDDR_c0_ddr4_s_axi_ctrl_bresp),
    .c0_ddr4_s_axi_ctrl_arvalid(instDDR_c0_ddr4_s_axi_ctrl_arvalid),
    .c0_ddr4_s_axi_ctrl_arready(instDDR_c0_ddr4_s_axi_ctrl_arready),
    .c0_ddr4_s_axi_ctrl_araddr(instDDR_c0_ddr4_s_axi_ctrl_araddr),
    .c0_ddr4_s_axi_ctrl_rvalid(instDDR_c0_ddr4_s_axi_ctrl_rvalid),
    .c0_ddr4_s_axi_ctrl_rready(instDDR_c0_ddr4_s_axi_ctrl_rready),
    .c0_ddr4_s_axi_ctrl_rdata(instDDR_c0_ddr4_s_axi_ctrl_rdata),
    .c0_ddr4_s_axi_ctrl_rresp(instDDR_c0_ddr4_s_axi_ctrl_rresp),
    .c0_ddr4_interrupt(instDDR_c0_ddr4_interrupt),
    .c0_ddr4_aresetn(instDDR_c0_ddr4_aresetn),
    .c0_ddr4_s_axi_awid(instDDR_c0_ddr4_s_axi_awid),
    .c0_ddr4_s_axi_awaddr(instDDR_c0_ddr4_s_axi_awaddr),
    .c0_ddr4_s_axi_awlen(instDDR_c0_ddr4_s_axi_awlen),
    .c0_ddr4_s_axi_awsize(instDDR_c0_ddr4_s_axi_awsize),
    .c0_ddr4_s_axi_awburst(instDDR_c0_ddr4_s_axi_awburst),
    .c0_ddr4_s_axi_awlock(instDDR_c0_ddr4_s_axi_awlock),
    .c0_ddr4_s_axi_awcache(instDDR_c0_ddr4_s_axi_awcache),
    .c0_ddr4_s_axi_awprot(instDDR_c0_ddr4_s_axi_awprot),
    .c0_ddr4_s_axi_awqos(instDDR_c0_ddr4_s_axi_awqos),
    .c0_ddr4_s_axi_awready(instDDR_c0_ddr4_s_axi_awready),
    .c0_ddr4_s_axi_awvalid(instDDR_c0_ddr4_s_axi_awvalid),
    .c0_ddr4_s_axi_wdata(instDDR_c0_ddr4_s_axi_wdata),
    .c0_ddr4_s_axi_wstrb(instDDR_c0_ddr4_s_axi_wstrb),
    .c0_ddr4_s_axi_wlast(instDDR_c0_ddr4_s_axi_wlast),
    .c0_ddr4_s_axi_wvalid(instDDR_c0_ddr4_s_axi_wvalid),
    .c0_ddr4_s_axi_wready(instDDR_c0_ddr4_s_axi_wready),
    .c0_ddr4_s_axi_bid(instDDR_c0_ddr4_s_axi_bid),
    .c0_ddr4_s_axi_bresp(instDDR_c0_ddr4_s_axi_bresp),
    .c0_ddr4_s_axi_bvalid(instDDR_c0_ddr4_s_axi_bvalid),
    .c0_ddr4_s_axi_bready(instDDR_c0_ddr4_s_axi_bready),
    .c0_ddr4_s_axi_arid(instDDR_c0_ddr4_s_axi_arid),
    .c0_ddr4_s_axi_araddr(instDDR_c0_ddr4_s_axi_araddr),
    .c0_ddr4_s_axi_arlen(instDDR_c0_ddr4_s_axi_arlen),
    .c0_ddr4_s_axi_arsize(instDDR_c0_ddr4_s_axi_arsize),
    .c0_ddr4_s_axi_arburst(instDDR_c0_ddr4_s_axi_arburst),
    .c0_ddr4_s_axi_arlock(instDDR_c0_ddr4_s_axi_arlock),
    .c0_ddr4_s_axi_arcache(instDDR_c0_ddr4_s_axi_arcache),
    .c0_ddr4_s_axi_arprot(instDDR_c0_ddr4_s_axi_arprot),
    .c0_ddr4_s_axi_arqos(instDDR_c0_ddr4_s_axi_arqos),
    .c0_ddr4_s_axi_arready(instDDR_c0_ddr4_s_axi_arready),
    .c0_ddr4_s_axi_arvalid(instDDR_c0_ddr4_s_axi_arvalid),
    .c0_ddr4_s_axi_rid(instDDR_c0_ddr4_s_axi_rid),
    .c0_ddr4_s_axi_rdata(instDDR_c0_ddr4_s_axi_rdata),
    .c0_ddr4_s_axi_rresp(instDDR_c0_ddr4_s_axi_rresp),
    .c0_ddr4_s_axi_rlast(instDDR_c0_ddr4_s_axi_rlast),
    .c0_ddr4_s_axi_rvalid(instDDR_c0_ddr4_s_axi_rvalid),
    .c0_ddr4_s_axi_rready(instDDR_c0_ddr4_s_axi_rready),
    .dbg_bus(instDDR_dbg_bus)
  );
  assign io_ddrpin_act_n = instDDR_c0_ddr4_act_n; // @[DDR_driver.scala 52:31]
  assign io_ddrpin_adr = instDDR_c0_ddr4_adr; // @[DDR_driver.scala 53:31]
  assign io_ddrpin_ba = instDDR_c0_ddr4_ba; // @[DDR_driver.scala 54:31]
  assign io_ddrpin_bg = instDDR_c0_ddr4_bg; // @[DDR_driver.scala 55:31]
  assign io_ddrpin_cke = instDDR_c0_ddr4_cke; // @[DDR_driver.scala 56:31]
  assign io_ddrpin_odt = instDDR_c0_ddr4_odt; // @[DDR_driver.scala 57:31]
  assign io_ddrpin_cs_n = instDDR_c0_ddr4_cs_n; // @[DDR_driver.scala 58:31]
  assign io_ddrpin_ck_t = instDDR_c0_ddr4_ck_t; // @[DDR_driver.scala 59:31]
  assign io_ddrpin_ck_c = instDDR_c0_ddr4_ck_c; // @[DDR_driver.scala 60:31]
  assign io_ddrpin_reset_n = instDDR_c0_ddr4_reset_n; // @[DDR_driver.scala 61:31]
  assign io_ddrpin_parity = instDDR_c0_ddr4_parity; // @[DDR_driver.scala 63:31]
  assign io_rst = instDDR_c0_ddr4_ui_clk_sync_rst | ~init_complete; // @[DDR_driver.scala 69:75]
  assign io_axi_aw_ready = instDDR_c0_ddr4_s_axi_awready; // @[DDR_driver.scala 108:52]
  assign io_axi_ar_ready = instDDR_c0_ddr4_s_axi_arready; // @[DDR_driver.scala 131:52]
  assign io_axi_w_ready = instDDR_c0_ddr4_s_axi_wready; // @[DDR_driver.scala 114:52]
  assign io_axi_r_valid = instDDR_c0_ddr4_s_axi_rvalid; // @[DDR_driver.scala 137:52]
  assign io_axi_r_bits_data = instDDR_c0_ddr4_s_axi_rdata; // @[DDR_driver.scala 134:52]
  assign io_axi_r_bits_last = instDDR_c0_ddr4_s_axi_rlast; // @[DDR_driver.scala 136:52]
  assign io_axi_r_bits_resp = instDDR_c0_ddr4_s_axi_rresp; // @[DDR_driver.scala 135:52]
  assign io_axi_r_bits_id = instDDR_c0_ddr4_s_axi_rid; // @[DDR_driver.scala 133:52]
  assign io_axi_b_valid = instDDR_c0_ddr4_s_axi_bvalid; // @[DDR_driver.scala 118:49]
  assign io_axi_b_bits_id = instDDR_c0_ddr4_s_axi_bid; // @[DDR_driver.scala 116:49]
  assign io_axi_b_bits_resp = instDDR_c0_ddr4_s_axi_bresp; // @[DDR_driver.scala 117:49]
  assign DDR0_sys_clk_pad_I = io_ddriver_clk; // @[Buf.scala 34:26]
  assign instDDR_sys_rst = 1'h0; // @[DDR_driver.scala 49:39]
  assign instDDR_c0_sys_clk_i = DDR0_sys_clk_pad_O; // @[DDR_driver.scala 50:39]
  assign instDDR_c0_ddr4_s_axi_ctrl_awvalid = 1'h0; // @[DDR_driver.scala 73:52]
  assign instDDR_c0_ddr4_s_axi_ctrl_awaddr = 32'h0; // @[DDR_driver.scala 75:52]
  assign instDDR_c0_ddr4_s_axi_ctrl_wvalid = 1'h0; // @[DDR_driver.scala 77:52]
  assign instDDR_c0_ddr4_s_axi_ctrl_wdata = 32'h0; // @[DDR_driver.scala 79:52]
  assign instDDR_c0_ddr4_s_axi_ctrl_bready = 1'h1; // @[DDR_driver.scala 82:52]
  assign instDDR_c0_ddr4_s_axi_ctrl_arvalid = 1'h0; // @[DDR_driver.scala 85:52]
  assign instDDR_c0_ddr4_s_axi_ctrl_araddr = 32'h0; // @[DDR_driver.scala 87:52]
  assign instDDR_c0_ddr4_s_axi_ctrl_rready = 1'h1; // @[DDR_driver.scala 90:52]
  assign instDDR_c0_ddr4_aresetn = ~io_rst; // @[DDR_driver.scala 96:62]
  assign instDDR_c0_ddr4_s_axi_awid = 4'h0; // @[DDR_driver.scala 98:52]
  assign instDDR_c0_ddr4_s_axi_awaddr = io_axi_aw_bits_addr; // @[DDR_driver.scala 99:52]
  assign instDDR_c0_ddr4_s_axi_awlen = io_axi_aw_bits_len; // @[DDR_driver.scala 100:52]
  assign instDDR_c0_ddr4_s_axi_awsize = io_axi_aw_bits_size; // @[DDR_driver.scala 101:52]
  assign instDDR_c0_ddr4_s_axi_awburst = io_axi_aw_bits_burst; // @[DDR_driver.scala 102:52]
  assign instDDR_c0_ddr4_s_axi_awlock = 1'h0; // @[DDR_driver.scala 103:52]
  assign instDDR_c0_ddr4_s_axi_awcache = 4'h0; // @[DDR_driver.scala 104:52]
  assign instDDR_c0_ddr4_s_axi_awprot = 3'h0; // @[DDR_driver.scala 105:52]
  assign instDDR_c0_ddr4_s_axi_awqos = 4'h0; // @[DDR_driver.scala 106:52]
  assign instDDR_c0_ddr4_s_axi_awvalid = io_axi_aw_valid; // @[DDR_driver.scala 107:52]
  assign instDDR_c0_ddr4_s_axi_wdata = io_axi_w_bits_data; // @[DDR_driver.scala 110:52]
  assign instDDR_c0_ddr4_s_axi_wstrb = io_axi_w_bits_strb; // @[DDR_driver.scala 111:52]
  assign instDDR_c0_ddr4_s_axi_wlast = io_axi_w_bits_last; // @[DDR_driver.scala 112:52]
  assign instDDR_c0_ddr4_s_axi_wvalid = io_axi_w_valid; // @[DDR_driver.scala 113:52]
  assign instDDR_c0_ddr4_s_axi_bready = 1'h1; // @[DDR_driver.scala 119:52]
  assign instDDR_c0_ddr4_s_axi_arid = io_axi_ar_bits_id; // @[DDR_driver.scala 121:52]
  assign instDDR_c0_ddr4_s_axi_araddr = io_axi_ar_bits_addr; // @[DDR_driver.scala 122:52]
  assign instDDR_c0_ddr4_s_axi_arlen = io_axi_ar_bits_len; // @[DDR_driver.scala 123:52]
  assign instDDR_c0_ddr4_s_axi_arsize = io_axi_ar_bits_size; // @[DDR_driver.scala 124:52]
  assign instDDR_c0_ddr4_s_axi_arburst = io_axi_ar_bits_burst; // @[DDR_driver.scala 125:52]
  assign instDDR_c0_ddr4_s_axi_arlock = 1'h0; // @[DDR_driver.scala 126:52]
  assign instDDR_c0_ddr4_s_axi_arcache = 4'h0; // @[DDR_driver.scala 127:52]
  assign instDDR_c0_ddr4_s_axi_arprot = 3'h0; // @[DDR_driver.scala 128:52]
  assign instDDR_c0_ddr4_s_axi_arqos = 4'h0; // @[DDR_driver.scala 129:52]
  assign instDDR_c0_ddr4_s_axi_arvalid = io_axi_ar_valid; // @[DDR_driver.scala 130:52]
  assign instDDR_c0_ddr4_s_axi_rready = io_axi_r_ready; // @[DDR_driver.scala 138:52]
endmodule
module DDRTOP(
  input         ddr0_sys_100M_p,
  input         ddr0_sys_100M_n,
  output        ddr_pin_act_n,
  output [16:0] ddr_pin_adr,
  output [1:0]  ddr_pin_ba,
  output [1:0]  ddr_pin_bg,
  output        ddr_pin_cke,
  output        ddr_pin_odt,
  output        ddr_pin_cs_n,
  output        ddr_pin_ck_t,
  output        ddr_pin_ck_c,
  output        ddr_pin_reset_n,
  output        ddr_pin_parity,
  inout  [71:0] ddr_pin_dq,
  inout  [17:0] ddr_pin_dqs_t,
  inout  [17:0] ddr_pin_dqs_c
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire  sysClk_pad_O; // @[Buf.scala 51:34]
  wire  sysClk_pad_I; // @[Buf.scala 51:34]
  wire  sysClk_pad_IB; // @[Buf.scala 51:34]
  wire  myclk_pad_O; // @[Buf.scala 33:34]
  wire  myclk_pad_I; // @[Buf.scala 33:34]
  wire  DDR0_io_ddriver_clk; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_ddrpin_act_n; // @[DDRTOP.scala 23:56]
  wire [16:0] DDR0_io_ddrpin_adr; // @[DDRTOP.scala 23:56]
  wire [1:0] DDR0_io_ddrpin_ba; // @[DDRTOP.scala 23:56]
  wire [1:0] DDR0_io_ddrpin_bg; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_ddrpin_cke; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_ddrpin_odt; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_ddrpin_cs_n; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_ddrpin_ck_t; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_ddrpin_ck_c; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_ddrpin_reset_n; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_ddrpin_parity; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_rst; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_axi_aw_ready; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_axi_aw_valid; // @[DDRTOP.scala 23:56]
  wire [33:0] DDR0_io_axi_aw_bits_addr; // @[DDRTOP.scala 23:56]
  wire [1:0] DDR0_io_axi_aw_bits_burst; // @[DDRTOP.scala 23:56]
  wire [7:0] DDR0_io_axi_aw_bits_len; // @[DDRTOP.scala 23:56]
  wire [2:0] DDR0_io_axi_aw_bits_size; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_axi_ar_ready; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_axi_ar_valid; // @[DDRTOP.scala 23:56]
  wire [33:0] DDR0_io_axi_ar_bits_addr; // @[DDRTOP.scala 23:56]
  wire [1:0] DDR0_io_axi_ar_bits_burst; // @[DDRTOP.scala 23:56]
  wire [3:0] DDR0_io_axi_ar_bits_id; // @[DDRTOP.scala 23:56]
  wire [7:0] DDR0_io_axi_ar_bits_len; // @[DDRTOP.scala 23:56]
  wire [2:0] DDR0_io_axi_ar_bits_size; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_axi_w_ready; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_axi_w_valid; // @[DDRTOP.scala 23:56]
  wire [511:0] DDR0_io_axi_w_bits_data; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_axi_w_bits_last; // @[DDRTOP.scala 23:56]
  wire [63:0] DDR0_io_axi_w_bits_strb; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_axi_r_ready; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_axi_r_valid; // @[DDRTOP.scala 23:56]
  wire [511:0] DDR0_io_axi_r_bits_data; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_axi_r_bits_last; // @[DDRTOP.scala 23:56]
  wire [1:0] DDR0_io_axi_r_bits_resp; // @[DDRTOP.scala 23:56]
  wire [3:0] DDR0_io_axi_r_bits_id; // @[DDRTOP.scala 23:56]
  wire  DDR0_io_axi_b_valid; // @[DDRTOP.scala 23:56]
  wire [3:0] DDR0_io_axi_b_bits_id; // @[DDRTOP.scala 23:56]
  wire [1:0] DDR0_io_axi_b_bits_resp; // @[DDRTOP.scala 23:56]
  wire  tx_clk; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_aw_ready; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_aw_valid; // @[DDRTOP.scala 161:24]
  wire [33:0] tx_data_0_aw_bits_addr; // @[DDRTOP.scala 161:24]
  wire [1:0] tx_data_0_aw_bits_burst; // @[DDRTOP.scala 161:24]
  wire [3:0] tx_data_0_aw_bits_cache; // @[DDRTOP.scala 161:24]
  wire [3:0] tx_data_0_aw_bits_id; // @[DDRTOP.scala 161:24]
  wire [7:0] tx_data_0_aw_bits_len; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_aw_bits_lock; // @[DDRTOP.scala 161:24]
  wire [2:0] tx_data_0_aw_bits_prot; // @[DDRTOP.scala 161:24]
  wire [3:0] tx_data_0_aw_bits_qos; // @[DDRTOP.scala 161:24]
  wire [3:0] tx_data_0_aw_bits_region; // @[DDRTOP.scala 161:24]
  wire [2:0] tx_data_0_aw_bits_size; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_ar_ready; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_ar_valid; // @[DDRTOP.scala 161:24]
  wire [33:0] tx_data_0_ar_bits_addr; // @[DDRTOP.scala 161:24]
  wire [1:0] tx_data_0_ar_bits_burst; // @[DDRTOP.scala 161:24]
  wire [3:0] tx_data_0_ar_bits_cache; // @[DDRTOP.scala 161:24]
  wire [3:0] tx_data_0_ar_bits_id; // @[DDRTOP.scala 161:24]
  wire [7:0] tx_data_0_ar_bits_len; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_ar_bits_lock; // @[DDRTOP.scala 161:24]
  wire [2:0] tx_data_0_ar_bits_prot; // @[DDRTOP.scala 161:24]
  wire [3:0] tx_data_0_ar_bits_qos; // @[DDRTOP.scala 161:24]
  wire [3:0] tx_data_0_ar_bits_region; // @[DDRTOP.scala 161:24]
  wire [2:0] tx_data_0_ar_bits_size; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_w_ready; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_w_valid; // @[DDRTOP.scala 161:24]
  wire [511:0] tx_data_0_w_bits_data; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_w_bits_last; // @[DDRTOP.scala 161:24]
  wire [63:0] tx_data_0_w_bits_strb; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_r_ready; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_r_valid; // @[DDRTOP.scala 161:24]
  wire [511:0] tx_data_0_r_bits_data; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_r_bits_last; // @[DDRTOP.scala 161:24]
  wire [1:0] tx_data_0_r_bits_resp; // @[DDRTOP.scala 161:24]
  wire [3:0] tx_data_0_r_bits_id; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_b_ready; // @[DDRTOP.scala 161:24]
  wire  tx_data_0_b_valid; // @[DDRTOP.scala 161:24]
  wire [3:0] tx_data_0_b_bits_id; // @[DDRTOP.scala 161:24]
  wire [1:0] tx_data_0_b_bits_resp; // @[DDRTOP.scala 161:24]
  reg [2:0] state; // @[DDRTOP.scala 67:22]
  reg [31:0] read_waite; // @[DDRTOP.scala 68:27]
  reg [31:0] write_waite; // @[DDRTOP.scala 69:28]
  reg [31:0] clock_count; // @[DDRTOP.scala 70:28]
  reg [31:0] cycle_count; // @[DDRTOP.scala 71:28]
  wire  _T = 3'h0 == state; // @[Conditional.scala 37:30]
  wire [31:0] _clock_count_T_1 = clock_count + 32'h1; // @[DDRTOP.scala 77:37]
  wire  axi_aw_ready = DDR0_io_axi_aw_ready; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  wire  axi_w_ready = DDR0_io_axi_w_ready; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  wire  _T_4 = 3'h1 == state; // @[Conditional.scala 37:30]
  wire [31:0] _write_waite_T_1 = write_waite + 32'h1; // @[DDRTOP.scala 94:37]
  wire  _T_5 = 3'h2 == state; // @[Conditional.scala 37:30]
  wire  _T_6 = write_waite == 32'h4; // @[DDRTOP.scala 107:29]
  wire  _T_7 = 3'h3 == state; // @[Conditional.scala 37:30]
  wire  axi_b_valid = DDR0_io_axi_b_valid; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  wire [2:0] _GEN_3 = axi_b_valid ? 3'h4 : 3'h3; // @[DDRTOP.scala 123:36 DDRTOP.scala 124:22 DDRTOP.scala 127:22]
  wire  _T_9 = 3'h4 == state; // @[Conditional.scala 37:30]
  wire [31:0] _read_waite_T_1 = read_waite + 32'h1; // @[DDRTOP.scala 132:35]
  wire [2:0] _GEN_4 = read_waite == 32'ha ? 3'h5 : state; // @[DDRTOP.scala 133:36 DDRTOP.scala 134:22 DDRTOP.scala 67:22]
  wire  _T_11 = 3'h5 == state; // @[Conditional.scala 37:30]
  wire  _T_12 = 3'h6 == state; // @[Conditional.scala 37:30]
  wire  axi_r_bits_last = DDR0_io_axi_r_bits_last; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  wire [31:0] _cycle_count_T_1 = cycle_count + 32'h1; // @[DDRTOP.scala 153:41]
  wire [31:0] _GEN_5 = axi_r_bits_last & clock_count <= 32'h3000f ? _cycle_count_T_1 : cycle_count; // @[DDRTOP.scala 152:64 DDRTOP.scala 153:28 DDRTOP.scala 71:28]
  wire [2:0] _GEN_6 = axi_r_bits_last & clock_count <= 32'h3000f ? 3'h0 : state; // @[DDRTOP.scala 152:64 DDRTOP.scala 154:22 DDRTOP.scala 67:22]
  wire [31:0] _GEN_7 = _T_12 ? _clock_count_T_1 : clock_count; // @[Conditional.scala 39:67 DDRTOP.scala 150:24 DDRTOP.scala 70:28]
  wire [31:0] _GEN_9 = _T_12 ? _GEN_5 : cycle_count; // @[Conditional.scala 39:67 DDRTOP.scala 71:28]
  wire [2:0] _GEN_10 = _T_12 ? _GEN_6 : state; // @[Conditional.scala 39:67 DDRTOP.scala 67:22]
  wire [31:0] _GEN_11 = _T_11 ? _clock_count_T_1 : _GEN_7; // @[Conditional.scala 39:67 DDRTOP.scala 138:22]
  wire [31:0] _GEN_12 = _T_11 ? 32'h0 : read_waite; // @[Conditional.scala 39:67 DDRTOP.scala 139:21 DDRTOP.scala 68:27]
  wire [33:0] _GEN_13 = _T_11 ? {{2'd0}, cycle_count} : 34'h0; // @[Conditional.scala 39:67 DDRTOP.scala 140:27 Util.scala 13:25]
  wire [7:0] _GEN_14 = _T_11 ? 8'h3 : 8'h0; // @[Conditional.scala 39:67 DDRTOP.scala 141:26 Util.scala 13:25]
  wire [2:0] _GEN_15 = _T_11 ? 3'h2 : 3'h0; // @[Conditional.scala 39:67 DDRTOP.scala 142:27 Util.scala 13:25]
  wire [1:0] _GEN_16 = _T_11 ? 2'h1 : 2'h0; // @[Conditional.scala 39:67 DDRTOP.scala 143:28 Util.scala 13:25]
  wire [31:0] _GEN_17 = _T_11 ? clock_count : 32'h0; // @[Conditional.scala 39:67 DDRTOP.scala 144:25 Util.scala 13:25]
  wire [2:0] _GEN_20 = _T_11 ? 3'h6 : _GEN_10; // @[Conditional.scala 39:67 DDRTOP.scala 147:16]
  wire [31:0] _GEN_21 = _T_11 ? cycle_count : _GEN_9; // @[Conditional.scala 39:67 DDRTOP.scala 71:28]
  wire [31:0] _GEN_22 = _T_9 ? _clock_count_T_1 : _GEN_11; // @[Conditional.scala 39:67 DDRTOP.scala 131:24]
  wire [31:0] _GEN_23 = _T_9 ? _read_waite_T_1 : _GEN_12; // @[Conditional.scala 39:67 DDRTOP.scala 132:23]
  wire [2:0] _GEN_24 = _T_9 ? _GEN_4 : _GEN_20; // @[Conditional.scala 39:67]
  wire [33:0] _GEN_25 = _T_9 ? 34'h0 : _GEN_13; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [7:0] _GEN_26 = _T_9 ? 8'h0 : _GEN_14; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [2:0] _GEN_27 = _T_9 ? 3'h0 : _GEN_15; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [1:0] _GEN_28 = _T_9 ? 2'h0 : _GEN_16; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [31:0] _GEN_29 = _T_9 ? 32'h0 : _GEN_17; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire  _GEN_30 = _T_9 ? 1'h0 : _T_11; // @[Conditional.scala 39:67 AXI.scala 149:49]
  wire [31:0] _GEN_32 = _T_9 ? cycle_count : _GEN_21; // @[Conditional.scala 39:67 DDRTOP.scala 71:28]
  wire [33:0] _GEN_39 = _T_7 ? 34'h0 : _GEN_25; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [7:0] _GEN_40 = _T_7 ? 8'h0 : _GEN_26; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [2:0] _GEN_41 = _T_7 ? 3'h0 : _GEN_27; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [1:0] _GEN_42 = _T_7 ? 2'h0 : _GEN_28; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [31:0] _GEN_43 = _T_7 ? 32'h0 : _GEN_29; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire  _GEN_44 = _T_7 ? 1'h0 : _GEN_30; // @[Conditional.scala 39:67 AXI.scala 149:49]
  wire [511:0] _GEN_49 = _T_5 ? 512'h1234 : 512'h0; // @[Conditional.scala 39:67 DDRTOP.scala 102:28 Util.scala 13:25]
  wire [63:0] _GEN_50 = _T_5 ? 64'hf : 64'h0; // @[Conditional.scala 39:67 DDRTOP.scala 103:28 Util.scala 13:25]
  wire [33:0] _GEN_56 = _T_5 ? 34'h0 : _GEN_39; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [7:0] _GEN_57 = _T_5 ? 8'h0 : _GEN_40; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [2:0] _GEN_58 = _T_5 ? 3'h0 : _GEN_41; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [1:0] _GEN_59 = _T_5 ? 2'h0 : _GEN_42; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [31:0] _GEN_60 = _T_5 ? 32'h0 : _GEN_43; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire  _GEN_61 = _T_5 ? 1'h0 : _GEN_44; // @[Conditional.scala 39:67 AXI.scala 149:49]
  wire [33:0] _GEN_65 = _T_4 ? {{2'd0}, cycle_count} : 34'h0; // @[Conditional.scala 39:67 DDRTOP.scala 84:29 Util.scala 13:25]
  wire [7:0] _GEN_66 = _T_4 ? 8'h3 : 8'h0; // @[Conditional.scala 39:67 DDRTOP.scala 85:28 Util.scala 13:25]
  wire [2:0] _GEN_67 = _T_4 ? 3'h2 : 3'h0; // @[Conditional.scala 39:67 DDRTOP.scala 86:29 Util.scala 13:25]
  wire [1:0] _GEN_68 = _T_4 ? 2'h1 : 2'h0; // @[Conditional.scala 39:67 DDRTOP.scala 87:30 Util.scala 13:25]
  wire  _GEN_69 = _T_4 | _T_5; // @[Conditional.scala 39:67 DDRTOP.scala 89:24]
  wire [511:0] _GEN_70 = _T_4 ? 512'h1234 : _GEN_49; // @[Conditional.scala 39:67 DDRTOP.scala 90:28]
  wire [63:0] _GEN_71 = _T_4 ? 64'hf : _GEN_50; // @[Conditional.scala 39:67 DDRTOP.scala 91:28]
  wire  _GEN_72 = _T_4 ? 1'h0 : _T_5 & _T_6; // @[Conditional.scala 39:67 DDRTOP.scala 92:28]
  wire [33:0] _GEN_77 = _T_4 ? 34'h0 : _GEN_56; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [7:0] _GEN_78 = _T_4 ? 8'h0 : _GEN_57; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [2:0] _GEN_79 = _T_4 ? 3'h0 : _GEN_58; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [1:0] _GEN_80 = _T_4 ? 2'h0 : _GEN_59; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire [31:0] _GEN_81 = _T_4 ? 32'h0 : _GEN_60; // @[Conditional.scala 39:67 Util.scala 13:25]
  wire  _GEN_82 = _T_4 ? 1'h0 : _GEN_61; // @[Conditional.scala 39:67 AXI.scala 149:49]
  wire [31:0] _GEN_103 = _T ? 32'h0 : _GEN_81; // @[Conditional.scala 40:58 Util.scala 13:25]
  IBUFDS sysClk_pad ( // @[Buf.scala 51:34]
    .O(sysClk_pad_O),
    .I(sysClk_pad_I),
    .IB(sysClk_pad_IB)
  );
  BUFG myclk_pad ( // @[Buf.scala 33:34]
    .O(myclk_pad_O),
    .I(myclk_pad_I)
  );
  DDR_DRIVER DDR0 ( // @[DDRTOP.scala 23:56]
    .io_ddriver_clk(DDR0_io_ddriver_clk),
    .io_ddrpin_act_n(DDR0_io_ddrpin_act_n),
    .io_ddrpin_adr(DDR0_io_ddrpin_adr),
    .io_ddrpin_ba(DDR0_io_ddrpin_ba),
    .io_ddrpin_bg(DDR0_io_ddrpin_bg),
    .io_ddrpin_cke(DDR0_io_ddrpin_cke),
    .io_ddrpin_odt(DDR0_io_ddrpin_odt),
    .io_ddrpin_cs_n(DDR0_io_ddrpin_cs_n),
    .io_ddrpin_ck_t(DDR0_io_ddrpin_ck_t),
    .io_ddrpin_ck_c(DDR0_io_ddrpin_ck_c),
    .io_ddrpin_reset_n(DDR0_io_ddrpin_reset_n),
    .io_ddrpin_parity(DDR0_io_ddrpin_parity),
    .io_ddrpin_dq(ddr_pin_dq),
    .io_ddrpin_dqs_t(ddr_pin_dqs_t),
    .io_ddrpin_dqs_c(ddr_pin_dqs_c),
    .io_rst(DDR0_io_rst),
    .io_axi_aw_ready(DDR0_io_axi_aw_ready),
    .io_axi_aw_valid(DDR0_io_axi_aw_valid),
    .io_axi_aw_bits_addr(DDR0_io_axi_aw_bits_addr),
    .io_axi_aw_bits_burst(DDR0_io_axi_aw_bits_burst),
    .io_axi_aw_bits_len(DDR0_io_axi_aw_bits_len),
    .io_axi_aw_bits_size(DDR0_io_axi_aw_bits_size),
    .io_axi_ar_ready(DDR0_io_axi_ar_ready),
    .io_axi_ar_valid(DDR0_io_axi_ar_valid),
    .io_axi_ar_bits_addr(DDR0_io_axi_ar_bits_addr),
    .io_axi_ar_bits_burst(DDR0_io_axi_ar_bits_burst),
    .io_axi_ar_bits_id(DDR0_io_axi_ar_bits_id),
    .io_axi_ar_bits_len(DDR0_io_axi_ar_bits_len),
    .io_axi_ar_bits_size(DDR0_io_axi_ar_bits_size),
    .io_axi_w_ready(DDR0_io_axi_w_ready),
    .io_axi_w_valid(DDR0_io_axi_w_valid),
    .io_axi_w_bits_data(DDR0_io_axi_w_bits_data),
    .io_axi_w_bits_last(DDR0_io_axi_w_bits_last),
    .io_axi_w_bits_strb(DDR0_io_axi_w_bits_strb),
    .io_axi_r_ready(DDR0_io_axi_r_ready),
    .io_axi_r_valid(DDR0_io_axi_r_valid),
    .io_axi_r_bits_data(DDR0_io_axi_r_bits_data),
    .io_axi_r_bits_last(DDR0_io_axi_r_bits_last),
    .io_axi_r_bits_resp(DDR0_io_axi_r_bits_resp),
    .io_axi_r_bits_id(DDR0_io_axi_r_bits_id),
    .io_axi_b_valid(DDR0_io_axi_b_valid),
    .io_axi_b_bits_id(DDR0_io_axi_b_bits_id),
    .io_axi_b_bits_resp(DDR0_io_axi_b_bits_resp)
  );
  ila_tx tx ( // @[DDRTOP.scala 161:24]
    .clk(tx_clk),
    .data_0_aw_ready(tx_data_0_aw_ready),
    .data_0_aw_valid(tx_data_0_aw_valid),
    .data_0_aw_bits_addr(tx_data_0_aw_bits_addr),
    .data_0_aw_bits_burst(tx_data_0_aw_bits_burst),
    .data_0_aw_bits_cache(tx_data_0_aw_bits_cache),
    .data_0_aw_bits_id(tx_data_0_aw_bits_id),
    .data_0_aw_bits_len(tx_data_0_aw_bits_len),
    .data_0_aw_bits_lock(tx_data_0_aw_bits_lock),
    .data_0_aw_bits_prot(tx_data_0_aw_bits_prot),
    .data_0_aw_bits_qos(tx_data_0_aw_bits_qos),
    .data_0_aw_bits_region(tx_data_0_aw_bits_region),
    .data_0_aw_bits_size(tx_data_0_aw_bits_size),
    .data_0_ar_ready(tx_data_0_ar_ready),
    .data_0_ar_valid(tx_data_0_ar_valid),
    .data_0_ar_bits_addr(tx_data_0_ar_bits_addr),
    .data_0_ar_bits_burst(tx_data_0_ar_bits_burst),
    .data_0_ar_bits_cache(tx_data_0_ar_bits_cache),
    .data_0_ar_bits_id(tx_data_0_ar_bits_id),
    .data_0_ar_bits_len(tx_data_0_ar_bits_len),
    .data_0_ar_bits_lock(tx_data_0_ar_bits_lock),
    .data_0_ar_bits_prot(tx_data_0_ar_bits_prot),
    .data_0_ar_bits_qos(tx_data_0_ar_bits_qos),
    .data_0_ar_bits_region(tx_data_0_ar_bits_region),
    .data_0_ar_bits_size(tx_data_0_ar_bits_size),
    .data_0_w_ready(tx_data_0_w_ready),
    .data_0_w_valid(tx_data_0_w_valid),
    .data_0_w_bits_data(tx_data_0_w_bits_data),
    .data_0_w_bits_last(tx_data_0_w_bits_last),
    .data_0_w_bits_strb(tx_data_0_w_bits_strb),
    .data_0_r_ready(tx_data_0_r_ready),
    .data_0_r_valid(tx_data_0_r_valid),
    .data_0_r_bits_data(tx_data_0_r_bits_data),
    .data_0_r_bits_last(tx_data_0_r_bits_last),
    .data_0_r_bits_resp(tx_data_0_r_bits_resp),
    .data_0_r_bits_id(tx_data_0_r_bits_id),
    .data_0_b_ready(tx_data_0_b_ready),
    .data_0_b_valid(tx_data_0_b_valid),
    .data_0_b_bits_id(tx_data_0_b_bits_id),
    .data_0_b_bits_resp(tx_data_0_b_bits_resp)
  );
  assign ddr_pin_act_n = DDR0_io_ddrpin_act_n; // @[DDRTOP.scala 58:19]
  assign ddr_pin_adr = DDR0_io_ddrpin_adr; // @[DDRTOP.scala 58:19]
  assign ddr_pin_ba = DDR0_io_ddrpin_ba; // @[DDRTOP.scala 58:19]
  assign ddr_pin_bg = DDR0_io_ddrpin_bg; // @[DDRTOP.scala 58:19]
  assign ddr_pin_cke = DDR0_io_ddrpin_cke; // @[DDRTOP.scala 58:19]
  assign ddr_pin_odt = DDR0_io_ddrpin_odt; // @[DDRTOP.scala 58:19]
  assign ddr_pin_cs_n = DDR0_io_ddrpin_cs_n; // @[DDRTOP.scala 58:19]
  assign ddr_pin_ck_t = DDR0_io_ddrpin_ck_t; // @[DDRTOP.scala 58:19]
  assign ddr_pin_ck_c = DDR0_io_ddrpin_ck_c; // @[DDRTOP.scala 58:19]
  assign ddr_pin_reset_n = DDR0_io_ddrpin_reset_n; // @[DDRTOP.scala 58:19]
  assign ddr_pin_parity = DDR0_io_ddrpin_parity; // @[DDRTOP.scala 58:19]
  assign sysClk_pad_I = ddr0_sys_100M_p; // @[Buf.scala 52:26]
  assign sysClk_pad_IB = ddr0_sys_100M_n; // @[Buf.scala 53:27]
  assign myclk_pad_I = sysClk_pad_O; // @[Buf.scala 34:26]
  assign DDR0_io_ddriver_clk = myclk_pad_O; // @[DDRTOP.scala 57:24]
  assign DDR0_io_axi_aw_valid = _T ? 1'h0 : _T_4; // @[Conditional.scala 40:58 DDRTOP.scala 74:25]
  assign DDR0_io_axi_aw_bits_addr = _T ? 34'h0 : _GEN_65; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign DDR0_io_axi_aw_bits_burst = _T ? 2'h0 : _GEN_68; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign DDR0_io_axi_aw_bits_len = _T ? 8'h0 : _GEN_66; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign DDR0_io_axi_aw_bits_size = _T ? 3'h0 : _GEN_67; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign DDR0_io_axi_ar_valid = _T ? 1'h0 : _GEN_82; // @[Conditional.scala 40:58 AXI.scala 146:49]
  assign DDR0_io_axi_ar_bits_addr = _T ? 34'h0 : _GEN_77; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign DDR0_io_axi_ar_bits_burst = _T ? 2'h0 : _GEN_80; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign DDR0_io_axi_ar_bits_id = _GEN_103[3:0]; // @[DDRTOP.scala 29:27]
  assign DDR0_io_axi_ar_bits_len = _T ? 8'h0 : _GEN_78; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign DDR0_io_axi_ar_bits_size = _T ? 3'h0 : _GEN_79; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign DDR0_io_axi_w_valid = _T ? 1'h0 : _GEN_69; // @[Conditional.scala 40:58 DDRTOP.scala 75:24]
  assign DDR0_io_axi_w_bits_data = _T ? 512'h0 : _GEN_70; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign DDR0_io_axi_w_bits_last = _T ? 1'h0 : _GEN_72; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign DDR0_io_axi_w_bits_strb = _T ? 64'h0 : _GEN_71; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign DDR0_io_axi_r_ready = _T ? 1'h0 : _GEN_82; // @[Conditional.scala 40:58 AXI.scala 149:49]
  assign tx_clk = myclk_pad_O; // @[ILA_VIO.scala 34:25]
  assign tx_data_0_aw_ready = DDR0_io_axi_aw_ready; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  assign tx_data_0_aw_valid = _T ? 1'h0 : _T_4; // @[Conditional.scala 40:58 DDRTOP.scala 74:25]
  assign tx_data_0_aw_bits_addr = _T ? 34'h0 : _GEN_65; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign tx_data_0_aw_bits_burst = _T ? 2'h0 : _GEN_68; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign tx_data_0_aw_bits_cache = 4'h0; // @[Util.scala 13:40 Util.scala 13:40]
  assign tx_data_0_aw_bits_id = 4'h0; // @[Util.scala 13:40 Util.scala 13:40]
  assign tx_data_0_aw_bits_len = _T ? 8'h0 : _GEN_66; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign tx_data_0_aw_bits_lock = 1'h0; // @[Util.scala 13:40 Util.scala 13:40]
  assign tx_data_0_aw_bits_prot = 3'h0; // @[Util.scala 13:40 Util.scala 13:40]
  assign tx_data_0_aw_bits_qos = 4'h0; // @[Util.scala 13:40 Util.scala 13:40]
  assign tx_data_0_aw_bits_region = 4'h0; // @[Util.scala 13:40 Util.scala 13:40]
  assign tx_data_0_aw_bits_size = _T ? 3'h0 : _GEN_67; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign tx_data_0_ar_ready = DDR0_io_axi_ar_ready; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  assign tx_data_0_ar_valid = _T ? 1'h0 : _GEN_82; // @[Conditional.scala 40:58 AXI.scala 146:49]
  assign tx_data_0_ar_bits_addr = _T ? 34'h0 : _GEN_77; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign tx_data_0_ar_bits_burst = _T ? 2'h0 : _GEN_80; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign tx_data_0_ar_bits_cache = 4'h0; // @[Util.scala 13:40 Util.scala 13:40]
  assign tx_data_0_ar_bits_id = _GEN_103[3:0]; // @[DDRTOP.scala 29:27]
  assign tx_data_0_ar_bits_len = _T ? 8'h0 : _GEN_78; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign tx_data_0_ar_bits_lock = 1'h0; // @[Util.scala 13:40 Util.scala 13:40]
  assign tx_data_0_ar_bits_prot = 3'h0; // @[Util.scala 13:40 Util.scala 13:40]
  assign tx_data_0_ar_bits_qos = 4'h0; // @[Util.scala 13:40 Util.scala 13:40]
  assign tx_data_0_ar_bits_region = 4'h0; // @[Util.scala 13:40 Util.scala 13:40]
  assign tx_data_0_ar_bits_size = _T ? 3'h0 : _GEN_79; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign tx_data_0_w_ready = DDR0_io_axi_w_ready; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  assign tx_data_0_w_valid = _T ? 1'h0 : _GEN_69; // @[Conditional.scala 40:58 DDRTOP.scala 75:24]
  assign tx_data_0_w_bits_data = _T ? 512'h0 : _GEN_70; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign tx_data_0_w_bits_last = _T ? 1'h0 : _GEN_72; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign tx_data_0_w_bits_strb = _T ? 64'h0 : _GEN_71; // @[Conditional.scala 40:58 Util.scala 13:25]
  assign tx_data_0_r_ready = _T ? 1'h0 : _GEN_82; // @[Conditional.scala 40:58 AXI.scala 149:49]
  assign tx_data_0_r_valid = DDR0_io_axi_r_valid; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  assign tx_data_0_r_bits_data = DDR0_io_axi_r_bits_data; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  assign tx_data_0_r_bits_last = DDR0_io_axi_r_bits_last; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  assign tx_data_0_r_bits_resp = DDR0_io_axi_r_bits_resp; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  assign tx_data_0_r_bits_id = DDR0_io_axi_r_bits_id; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  assign tx_data_0_b_ready = 1'h1; // @[Conditional.scala 40:58 DDRTOP.scala 76:24 AXI.scala 150:49]
  assign tx_data_0_b_valid = DDR0_io_axi_b_valid; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  assign tx_data_0_b_bits_id = DDR0_io_axi_b_bits_id; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  assign tx_data_0_b_bits_resp = DDR0_io_axi_b_bits_resp; // @[DDRTOP.scala 29:27 DDRTOP.scala 61:8]
  always @(posedge myclk_pad_O) begin
    if (_T) begin // @[Conditional.scala 40:58]
      if (axi_aw_ready & axi_w_ready) begin // @[DDRTOP.scala 78:56]
        state <= 3'h1; // @[DDRTOP.scala 79:22]
      end
    end else if (_T_4) begin // @[Conditional.scala 39:67]
      state <= 3'h2; // @[DDRTOP.scala 96:18]
    end else if (_T_5) begin // @[Conditional.scala 39:67]
      if (write_waite == 32'h4) begin // @[DDRTOP.scala 107:45]
        state <= 3'h3; // @[DDRTOP.scala 109:22]
      end else begin
        state <= 3'h2; // @[DDRTOP.scala 113:22]
      end
    end else if (_T_7) begin // @[Conditional.scala 39:67]
      state <= _GEN_3;
    end else begin
      state <= _GEN_24;
    end
    if (!(_T)) begin // @[Conditional.scala 40:58]
      if (!(_T_4)) begin // @[Conditional.scala 39:67]
        if (!(_T_5)) begin // @[Conditional.scala 39:67]
          if (!(_T_7)) begin // @[Conditional.scala 39:67]
            read_waite <= _GEN_23;
          end
        end
      end
    end
    if (!(_T)) begin // @[Conditional.scala 40:58]
      if (_T_4) begin // @[Conditional.scala 39:67]
        write_waite <= _write_waite_T_1; // @[DDRTOP.scala 94:24]
      end else if (_T_5) begin // @[Conditional.scala 39:67]
        write_waite <= _write_waite_T_1; // @[DDRTOP.scala 106:24]
      end else if (_T_7) begin // @[Conditional.scala 39:67]
        write_waite <= 32'h0; // @[DDRTOP.scala 120:24]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      clock_count <= _clock_count_T_1; // @[DDRTOP.scala 77:24]
    end else if (_T_4) begin // @[Conditional.scala 39:67]
      clock_count <= _clock_count_T_1; // @[DDRTOP.scala 93:24]
    end else if (_T_5) begin // @[Conditional.scala 39:67]
      clock_count <= _clock_count_T_1; // @[DDRTOP.scala 105:24]
    end else if (_T_7) begin // @[Conditional.scala 39:67]
      clock_count <= _clock_count_T_1; // @[DDRTOP.scala 121:24]
    end else begin
      clock_count <= _GEN_22;
    end
    if (!(_T)) begin // @[Conditional.scala 40:58]
      if (!(_T_4)) begin // @[Conditional.scala 39:67]
        if (!(_T_5)) begin // @[Conditional.scala 39:67]
          if (!(_T_7)) begin // @[Conditional.scala 39:67]
            cycle_count <= _GEN_32;
          end
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  read_waite = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  write_waite = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  clock_count = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  cycle_count = _RAND_4[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ila_tx(
input clk,
input [0:0] data_0_aw_ready,
input [0:0] data_0_aw_valid,
input [33:0] data_0_aw_bits_addr,
input [1:0] data_0_aw_bits_burst,
input [3:0] data_0_aw_bits_cache,
input [3:0] data_0_aw_bits_id,
input [7:0] data_0_aw_bits_len,
input [0:0] data_0_aw_bits_lock,
input [2:0] data_0_aw_bits_prot,
input [3:0] data_0_aw_bits_qos,
input [3:0] data_0_aw_bits_region,
input [2:0] data_0_aw_bits_size,
input [0:0] data_0_ar_ready,
input [0:0] data_0_ar_valid,
input [33:0] data_0_ar_bits_addr,
input [1:0] data_0_ar_bits_burst,
input [3:0] data_0_ar_bits_cache,
input [3:0] data_0_ar_bits_id,
input [7:0] data_0_ar_bits_len,
input [0:0] data_0_ar_bits_lock,
input [2:0] data_0_ar_bits_prot,
input [3:0] data_0_ar_bits_qos,
input [3:0] data_0_ar_bits_region,
input [2:0] data_0_ar_bits_size,
input [0:0] data_0_w_ready,
input [0:0] data_0_w_valid,
input [511:0] data_0_w_bits_data,
input [0:0] data_0_w_bits_last,
input [63:0] data_0_w_bits_strb,
input [0:0] data_0_r_ready,
input [0:0] data_0_r_valid,
input [511:0] data_0_r_bits_data,
input [0:0] data_0_r_bits_last,
input [1:0] data_0_r_bits_resp,
input [3:0] data_0_r_bits_id,
input [0:0] data_0_b_ready,
input [0:0] data_0_b_valid,
input [3:0] data_0_b_bits_id,
input [1:0] data_0_b_bits_resp);

wire [0:0] axi_aw_ready = data_0_aw_ready;
wire [0:0] axi_aw_valid = data_0_aw_valid;
wire [33:0] axi_aw_bits_addr = data_0_aw_bits_addr;
wire [1:0] axi_aw_bits_burst = data_0_aw_bits_burst;
wire [3:0] axi_aw_bits_cache = data_0_aw_bits_cache;
wire [3:0] axi_aw_bits_id = data_0_aw_bits_id;
wire [7:0] axi_aw_bits_len = data_0_aw_bits_len;
wire [0:0] axi_aw_bits_lock = data_0_aw_bits_lock;
wire [2:0] axi_aw_bits_prot = data_0_aw_bits_prot;
wire [3:0] axi_aw_bits_qos = data_0_aw_bits_qos;
wire [3:0] axi_aw_bits_region = data_0_aw_bits_region;
wire [2:0] axi_aw_bits_size = data_0_aw_bits_size;
wire [0:0] axi_ar_ready = data_0_ar_ready;
wire [0:0] axi_ar_valid = data_0_ar_valid;
wire [33:0] axi_ar_bits_addr = data_0_ar_bits_addr;
wire [1:0] axi_ar_bits_burst = data_0_ar_bits_burst;
wire [3:0] axi_ar_bits_cache = data_0_ar_bits_cache;
wire [3:0] axi_ar_bits_id = data_0_ar_bits_id;
wire [7:0] axi_ar_bits_len = data_0_ar_bits_len;
wire [0:0] axi_ar_bits_lock = data_0_ar_bits_lock;
wire [2:0] axi_ar_bits_prot = data_0_ar_bits_prot;
wire [3:0] axi_ar_bits_qos = data_0_ar_bits_qos;
wire [3:0] axi_ar_bits_region = data_0_ar_bits_region;
wire [2:0] axi_ar_bits_size = data_0_ar_bits_size;
wire [0:0] axi_w_ready = data_0_w_ready;
wire [0:0] axi_w_valid = data_0_w_valid;
wire [511:0] axi_w_bits_data = data_0_w_bits_data;
wire [0:0] axi_w_bits_last = data_0_w_bits_last;
wire [63:0] axi_w_bits_strb = data_0_w_bits_strb;
wire [0:0] axi_r_ready = data_0_r_ready;
wire [0:0] axi_r_valid = data_0_r_valid;
wire [511:0] axi_r_bits_data = data_0_r_bits_data;
wire [0:0] axi_r_bits_last = data_0_r_bits_last;
wire [1:0] axi_r_bits_resp = data_0_r_bits_resp;
wire [3:0] axi_r_bits_id = data_0_r_bits_id;
wire [0:0] axi_b_ready = data_0_b_ready;
wire [0:0] axi_b_valid = data_0_b_valid;
wire [3:0] axi_b_bits_id = data_0_b_bits_id;
wire [1:0] axi_b_bits_resp = data_0_b_bits_resp;

ila_tx_inner inst_ila_tx(
.clk(clk),
.probe0(axi_aw_ready), //[0:0]
.probe1(axi_aw_valid), //[0:0]
.probe2(axi_aw_bits_addr), //[33:0]
.probe3(axi_aw_bits_burst), //[1:0]
.probe4(axi_aw_bits_cache), //[3:0]
.probe5(axi_aw_bits_id), //[3:0]
.probe6(axi_aw_bits_len), //[7:0]
.probe7(axi_aw_bits_lock), //[0:0]
.probe8(axi_aw_bits_prot), //[2:0]
.probe9(axi_aw_bits_qos), //[3:0]
.probe10(axi_aw_bits_region), //[3:0]
.probe11(axi_aw_bits_size), //[2:0]
.probe12(axi_ar_ready), //[0:0]
.probe13(axi_ar_valid), //[0:0]
.probe14(axi_ar_bits_addr), //[33:0]
.probe15(axi_ar_bits_burst), //[1:0]
.probe16(axi_ar_bits_cache), //[3:0]
.probe17(axi_ar_bits_id), //[3:0]
.probe18(axi_ar_bits_len), //[7:0]
.probe19(axi_ar_bits_lock), //[0:0]
.probe20(axi_ar_bits_prot), //[2:0]
.probe21(axi_ar_bits_qos), //[3:0]
.probe22(axi_ar_bits_region), //[3:0]
.probe23(axi_ar_bits_size), //[2:0]
.probe24(axi_w_ready), //[0:0]
.probe25(axi_w_valid), //[0:0]
.probe26(axi_w_bits_data), //[511:0]
.probe27(axi_w_bits_last), //[0:0]
.probe28(axi_w_bits_strb), //[63:0]
.probe29(axi_r_ready), //[0:0]
.probe30(axi_r_valid), //[0:0]
.probe31(axi_r_bits_data), //[511:0]
.probe32(axi_r_bits_last), //[0:0]
.probe33(axi_r_bits_resp), //[1:0]
.probe34(axi_r_bits_id), //[3:0]
.probe35(axi_b_ready), //[0:0]
.probe36(axi_b_valid), //[0:0]
.probe37(axi_b_bits_id), //[3:0]
.probe38(axi_b_bits_resp)); //[1:0]
endmodule
/*
create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila_tx_inner
set_property -dict [list CONFIG.C_INPUT_PIPE_STAGES {0} CONFIG.C_PROBE0_WIDTH {1} CONFIG.C_PROBE1_WIDTH {1} CONFIG.C_PROBE2_WIDTH {34} CONFIG.C_PROBE3_WIDTH {2} CONFIG.C_PROBE4_WIDTH {4} CONFIG.C_PROBE5_WIDTH {4} CONFIG.C_PROBE6_WIDTH {8} CONFIG.C_PROBE7_WIDTH {1} CONFIG.C_PROBE8_WIDTH {3} CONFIG.C_PROBE9_WIDTH {4} CONFIG.C_PROBE10_WIDTH {4} CONFIG.C_PROBE11_WIDTH {3} CONFIG.C_PROBE12_WIDTH {1} CONFIG.C_PROBE13_WIDTH {1} CONFIG.C_PROBE14_WIDTH {34} CONFIG.C_PROBE15_WIDTH {2} CONFIG.C_PROBE16_WIDTH {4} CONFIG.C_PROBE17_WIDTH {4} CONFIG.C_PROBE18_WIDTH {8} CONFIG.C_PROBE19_WIDTH {1} CONFIG.C_PROBE20_WIDTH {3} CONFIG.C_PROBE21_WIDTH {4} CONFIG.C_PROBE22_WIDTH {4} CONFIG.C_PROBE23_WIDTH {3} CONFIG.C_PROBE24_WIDTH {1} CONFIG.C_PROBE25_WIDTH {1} CONFIG.C_PROBE26_WIDTH {512} CONFIG.C_PROBE27_WIDTH {1} CONFIG.C_PROBE28_WIDTH {64} CONFIG.C_PROBE29_WIDTH {1} CONFIG.C_PROBE30_WIDTH {1} CONFIG.C_PROBE31_WIDTH {512} CONFIG.C_PROBE32_WIDTH {1} CONFIG.C_PROBE33_WIDTH {2} CONFIG.C_PROBE34_WIDTH {4} CONFIG.C_PROBE35_WIDTH {1} CONFIG.C_PROBE36_WIDTH {1} CONFIG.C_PROBE37_WIDTH {4} CONFIG.C_PROBE38_WIDTH {2} CONFIG.C_DATA_DEPTH {1024} CONFIG.C_NUM_OF_PROBES {39} ] [get_ips ila_tx_inner]
*/
