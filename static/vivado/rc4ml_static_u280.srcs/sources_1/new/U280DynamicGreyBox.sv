module SV_STREAM_FIFO(
  input          io_m_clk,
  input          io_s_clk,
  input          io_reset_n,
  input  [599:0] io_in_data,
  input          io_in_valid,
  output         io_in_ready,
  output         io_out_valid
);
  wire [599:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [74:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [599:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [74:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [74:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(600), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_in_ready = meta_s_axis_tready; // @[Meta.scala 34:41]
  assign io_out_valid = meta_m_axis_tvalid; // @[Meta.scala 32:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = 1'h1; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = io_in_data; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 75'h7ffffffffffffffffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 75'h7ffffffffffffffffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = io_in_valid; // @[Meta.scala 48:41]
endmodule
module XConverter(
  input          io__in_clk,
  input          io__out_clk,
  input          io__rstn,
  output         io__in_ready,
  input          io__in_valid,
  input  [511:0] io__in_bits_data,
  input  [31:0]  io__in_bits_tcrc,
  input  [10:0]  io__in_bits_tuser_qid,
  input  [2:0]   io__in_bits_tuser_port_id,
  input          io__in_bits_tuser_err,
  input  [31:0]  io__in_bits_tuser_mdata,
  input  [5:0]   io__in_bits_tuser_mty,
  input          io__in_bits_tuser_zero_byte,
  input          io__in_bits_last,
  output         io__out_valid,
  output         io_in_ready,
  output         io_in_valid
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [599:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire [598:0] _fifo_io_in_data_T = {io__in_bits_data,io__in_bits_tcrc,io__in_bits_tuser_qid,io__in_bits_tuser_port_id,
    io__in_bits_tuser_err,io__in_bits_tuser_mdata,io__in_bits_tuser_mty,io__in_bits_tuser_zero_byte,io__in_bits_last}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready),
    .io_out_valid(fifo_io_out_valid)
  );
  assign io__in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign io__out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io_in_ready = io__in_ready;
  assign io_in_valid = io__in_valid;
  assign fifo_io_m_clk = io__out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io__in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io__rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{1'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io__in_valid; // @[XConverter.scala 104:41]
endmodule
module RegSlice(
  input          clock,
  input          reset,
  output         io_upStream_ready,
  input          io_upStream_valid,
  input  [511:0] io_upStream_bits_data,
  input  [31:0]  io_upStream_bits_tcrc,
  input  [10:0]  io_upStream_bits_tuser_qid,
  input  [2:0]   io_upStream_bits_tuser_port_id,
  input          io_upStream_bits_tuser_err,
  input  [31:0]  io_upStream_bits_tuser_mdata,
  input  [5:0]   io_upStream_bits_tuser_mty,
  input          io_upStream_bits_tuser_zero_byte,
  input          io_upStream_bits_last,
  input          io_downStream_ready,
  output         io_downStream_valid,
  output [511:0] io_downStream_bits_data,
  output [31:0]  io_downStream_bits_tcrc,
  output [10:0]  io_downStream_bits_tuser_qid,
  output [2:0]   io_downStream_bits_tuser_port_id,
  output         io_downStream_bits_tuser_err,
  output [31:0]  io_downStream_bits_tuser_mdata,
  output [5:0]   io_downStream_bits_tuser_mty,
  output         io_downStream_bits_tuser_zero_byte,
  output         io_downStream_bits_last
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [511:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [511:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
`endif // RANDOMIZE_REG_INIT
  reg  fwd_valid; // @[RegSlices.scala 112:34]
  reg [511:0] fwd_data_data; // @[RegSlices.scala 113:30]
  reg [31:0] fwd_data_tcrc; // @[RegSlices.scala 113:30]
  reg [10:0] fwd_data_tuser_qid; // @[RegSlices.scala 113:30]
  reg [2:0] fwd_data_tuser_port_id; // @[RegSlices.scala 113:30]
  reg  fwd_data_tuser_err; // @[RegSlices.scala 113:30]
  reg [31:0] fwd_data_tuser_mdata; // @[RegSlices.scala 113:30]
  reg [5:0] fwd_data_tuser_mty; // @[RegSlices.scala 113:30]
  reg  fwd_data_tuser_zero_byte; // @[RegSlices.scala 113:30]
  reg  fwd_data_last; // @[RegSlices.scala 113:30]
  wire  fwd_ready_s = ~fwd_valid | io_downStream_ready; // @[RegSlices.scala 115:35]
  reg  bwd_ready; // @[RegSlices.scala 123:34]
  reg [511:0] bwd_data_data; // @[RegSlices.scala 124:30]
  reg [31:0] bwd_data_tcrc; // @[RegSlices.scala 124:30]
  reg [10:0] bwd_data_tuser_qid; // @[RegSlices.scala 124:30]
  reg [2:0] bwd_data_tuser_port_id; // @[RegSlices.scala 124:30]
  reg  bwd_data_tuser_err; // @[RegSlices.scala 124:30]
  reg [31:0] bwd_data_tuser_mdata; // @[RegSlices.scala 124:30]
  reg [5:0] bwd_data_tuser_mty; // @[RegSlices.scala 124:30]
  reg  bwd_data_tuser_zero_byte; // @[RegSlices.scala 124:30]
  reg  bwd_data_last; // @[RegSlices.scala 124:30]
  wire  _fwd_valid_T = io_downStream_ready ? 1'h0 : fwd_valid; // @[RegSlices.scala 121:53]
  wire  bwd_valid_s = ~bwd_ready | io_upStream_valid; // @[RegSlices.scala 126:39]
  wire  _bwd_ready_T = io_upStream_valid ? 1'h0 : bwd_ready; // @[RegSlices.scala 132:53]
  assign io_upStream_ready = bwd_ready; // @[RegSlices.scala 107:31 RegSlices.scala 128:25]
  assign io_downStream_valid = fwd_valid; // @[RegSlices.scala 109:31 RegSlices.scala 116:21]
  assign io_downStream_bits_data = fwd_data_data; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_tcrc = fwd_data_tcrc; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_tuser_qid = fwd_data_tuser_qid; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_tuser_port_id = fwd_data_tuser_port_id; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_tuser_err = fwd_data_tuser_err; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_tuser_mdata = fwd_data_tuser_mdata; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_tuser_mty = fwd_data_tuser_mty; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_tuser_zero_byte = fwd_data_tuser_zero_byte; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_last = fwd_data_last; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  always @(posedge clock) begin
    if (reset) begin // @[RegSlices.scala 112:34]
      fwd_valid <= 1'h0; // @[RegSlices.scala 112:34]
    end else begin
      fwd_valid <= bwd_valid_s | _fwd_valid_T; // @[RegSlices.scala 121:25]
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_data <= io_upStream_bits_data;
      end else begin
        fwd_data_data <= bwd_data_data;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_tcrc <= io_upStream_bits_tcrc;
      end else begin
        fwd_data_tcrc <= bwd_data_tcrc;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_tuser_qid <= io_upStream_bits_tuser_qid;
      end else begin
        fwd_data_tuser_qid <= bwd_data_tuser_qid;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_tuser_port_id <= io_upStream_bits_tuser_port_id;
      end else begin
        fwd_data_tuser_port_id <= bwd_data_tuser_port_id;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_tuser_err <= io_upStream_bits_tuser_err;
      end else begin
        fwd_data_tuser_err <= bwd_data_tuser_err;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_tuser_mdata <= io_upStream_bits_tuser_mdata;
      end else begin
        fwd_data_tuser_mdata <= bwd_data_tuser_mdata;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_tuser_mty <= io_upStream_bits_tuser_mty;
      end else begin
        fwd_data_tuser_mty <= bwd_data_tuser_mty;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_tuser_zero_byte <= io_upStream_bits_tuser_zero_byte;
      end else begin
        fwd_data_tuser_zero_byte <= bwd_data_tuser_zero_byte;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_last <= io_upStream_bits_last;
      end else begin
        fwd_data_last <= bwd_data_last;
      end
    end
    bwd_ready <= reset | (fwd_ready_s | _bwd_ready_T); // @[RegSlices.scala 123:34 RegSlices.scala 123:34 RegSlices.scala 132:25]
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_data <= io_upStream_bits_data;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_tcrc <= io_upStream_bits_tcrc;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_tuser_qid <= io_upStream_bits_tuser_qid;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_tuser_port_id <= io_upStream_bits_tuser_port_id;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_tuser_err <= io_upStream_bits_tuser_err;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_tuser_mdata <= io_upStream_bits_tuser_mdata;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_tuser_mty <= io_upStream_bits_tuser_mty;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_tuser_zero_byte <= io_upStream_bits_tuser_zero_byte;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_last <= io_upStream_bits_last;
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
  fwd_valid = _RAND_0[0:0];
  _RAND_1 = {16{`RANDOM}};
  fwd_data_data = _RAND_1[511:0];
  _RAND_2 = {1{`RANDOM}};
  fwd_data_tcrc = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  fwd_data_tuser_qid = _RAND_3[10:0];
  _RAND_4 = {1{`RANDOM}};
  fwd_data_tuser_port_id = _RAND_4[2:0];
  _RAND_5 = {1{`RANDOM}};
  fwd_data_tuser_err = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  fwd_data_tuser_mdata = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  fwd_data_tuser_mty = _RAND_7[5:0];
  _RAND_8 = {1{`RANDOM}};
  fwd_data_tuser_zero_byte = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  fwd_data_last = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  bwd_ready = _RAND_10[0:0];
  _RAND_11 = {16{`RANDOM}};
  bwd_data_data = _RAND_11[511:0];
  _RAND_12 = {1{`RANDOM}};
  bwd_data_tcrc = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  bwd_data_tuser_qid = _RAND_13[10:0];
  _RAND_14 = {1{`RANDOM}};
  bwd_data_tuser_port_id = _RAND_14[2:0];
  _RAND_15 = {1{`RANDOM}};
  bwd_data_tuser_err = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  bwd_data_tuser_mdata = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  bwd_data_tuser_mty = _RAND_17[5:0];
  _RAND_18 = {1{`RANDOM}};
  bwd_data_tuser_zero_byte = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  bwd_data_last = _RAND_19[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SV_STREAM_FIFO_1(
  input          io_m_clk,
  input          io_s_clk,
  input          io_reset_n,
  input  [607:0] io_in_data,
  input          io_in_valid,
  output         io_in_ready,
  output [607:0] io_out_data,
  output         io_out_valid,
  input          io_out_ready
);
  wire [607:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [75:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [607:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [75:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [75:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(608), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_in_ready = meta_s_axis_tready; // @[Meta.scala 34:41]
  assign io_out_data = meta_m_axis_tdata; // @[Meta.scala 31:41]
  assign io_out_valid = meta_m_axis_tvalid; // @[Meta.scala 32:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = io_out_ready; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = io_in_data; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 76'hfffffffffffffffffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 76'hfffffffffffffffffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = io_in_valid; // @[Meta.scala 48:41]
endmodule
module XConverter_1(
  input          io__in_clk,
  input          io__out_clk,
  input          io__rstn,
  output         io__in_ready,
  input          io__in_valid,
  input  [511:0] io__in_bits_data,
  input  [31:0]  io__in_bits_tcrc,
  input          io__in_bits_ctrl_marker,
  input  [6:0]   io__in_bits_ctrl_ecc,
  input  [31:0]  io__in_bits_ctrl_len,
  input  [2:0]   io__in_bits_ctrl_port_id,
  input  [10:0]  io__in_bits_ctrl_qid,
  input          io__in_bits_ctrl_has_cmpt,
  input          io__in_bits_last,
  input  [5:0]   io__in_bits_mty,
  input          io__out_ready,
  output         io__out_valid,
  output [511:0] io__out_bits_data,
  output [31:0]  io__out_bits_tcrc,
  output         io__out_bits_ctrl_marker,
  output [6:0]   io__out_bits_ctrl_ecc,
  output [31:0]  io__out_bits_ctrl_len,
  output [2:0]   io__out_bits_ctrl_port_id,
  output [10:0]  io__out_bits_ctrl_qid,
  output         io__out_bits_ctrl_has_cmpt,
  output         io__out_bits_last,
  output [5:0]   io__out_bits_mty,
  output         io_out_ready,
  output         io_out_valid_0
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [607:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire [607:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  wire [605:0] _fifo_io_in_data_T = {io__in_bits_data,io__in_bits_tcrc,io__in_bits_ctrl_marker,io__in_bits_ctrl_ecc,
    io__in_bits_ctrl_len,io__in_bits_ctrl_port_id,io__in_bits_ctrl_qid,io__in_bits_ctrl_has_cmpt,io__in_bits_last,
    io__in_bits_mty}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO_1 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io__in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign io__out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io__out_bits_data = fifo_io_out_data[605:94]; // @[XConverter.scala 107:77]
  assign io__out_bits_tcrc = fifo_io_out_data[93:62]; // @[XConverter.scala 107:77]
  assign io__out_bits_ctrl_marker = fifo_io_out_data[61]; // @[XConverter.scala 107:77]
  assign io__out_bits_ctrl_ecc = fifo_io_out_data[60:54]; // @[XConverter.scala 107:77]
  assign io__out_bits_ctrl_len = fifo_io_out_data[53:22]; // @[XConverter.scala 107:77]
  assign io__out_bits_ctrl_port_id = fifo_io_out_data[21:19]; // @[XConverter.scala 107:77]
  assign io__out_bits_ctrl_qid = fifo_io_out_data[18:8]; // @[XConverter.scala 107:77]
  assign io__out_bits_ctrl_has_cmpt = fifo_io_out_data[7]; // @[XConverter.scala 107:77]
  assign io__out_bits_last = fifo_io_out_data[6]; // @[XConverter.scala 107:77]
  assign io__out_bits_mty = fifo_io_out_data[5:0]; // @[XConverter.scala 107:77]
  assign io_out_ready = io__out_ready;
  assign io_out_valid_0 = io__out_valid;
  assign fifo_io_m_clk = io__out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io__in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io__rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{2'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io__in_valid; // @[XConverter.scala 104:41]
  assign fifo_io_out_ready = io__out_ready; // @[XConverter.scala 109:41]
endmodule
module RegSlice_1(
  input          clock,
  input          reset,
  output         io_upStream_ready,
  input          io_upStream_valid,
  input  [511:0] io_upStream_bits_data,
  input  [31:0]  io_upStream_bits_tcrc,
  input          io_upStream_bits_ctrl_marker,
  input  [6:0]   io_upStream_bits_ctrl_ecc,
  input  [31:0]  io_upStream_bits_ctrl_len,
  input  [2:0]   io_upStream_bits_ctrl_port_id,
  input  [10:0]  io_upStream_bits_ctrl_qid,
  input          io_upStream_bits_ctrl_has_cmpt,
  input          io_upStream_bits_last,
  input  [5:0]   io_upStream_bits_mty,
  input          io_downStream_ready,
  output         io_downStream_valid,
  output [511:0] io_downStream_bits_data,
  output [31:0]  io_downStream_bits_tcrc,
  output         io_downStream_bits_ctrl_marker,
  output [6:0]   io_downStream_bits_ctrl_ecc,
  output [31:0]  io_downStream_bits_ctrl_len,
  output [2:0]   io_downStream_bits_ctrl_port_id,
  output [10:0]  io_downStream_bits_ctrl_qid,
  output         io_downStream_bits_ctrl_has_cmpt,
  output         io_downStream_bits_last,
  output [5:0]   io_downStream_bits_mty
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [511:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [511:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
`endif // RANDOMIZE_REG_INIT
  reg  fwd_valid; // @[RegSlices.scala 112:34]
  reg [511:0] fwd_data_data; // @[RegSlices.scala 113:30]
  reg [31:0] fwd_data_tcrc; // @[RegSlices.scala 113:30]
  reg  fwd_data_ctrl_marker; // @[RegSlices.scala 113:30]
  reg [6:0] fwd_data_ctrl_ecc; // @[RegSlices.scala 113:30]
  reg [31:0] fwd_data_ctrl_len; // @[RegSlices.scala 113:30]
  reg [2:0] fwd_data_ctrl_port_id; // @[RegSlices.scala 113:30]
  reg [10:0] fwd_data_ctrl_qid; // @[RegSlices.scala 113:30]
  reg  fwd_data_ctrl_has_cmpt; // @[RegSlices.scala 113:30]
  reg  fwd_data_last; // @[RegSlices.scala 113:30]
  reg [5:0] fwd_data_mty; // @[RegSlices.scala 113:30]
  wire  fwd_ready_s = ~fwd_valid | io_downStream_ready; // @[RegSlices.scala 115:35]
  reg  bwd_ready; // @[RegSlices.scala 123:34]
  reg [511:0] bwd_data_data; // @[RegSlices.scala 124:30]
  reg [31:0] bwd_data_tcrc; // @[RegSlices.scala 124:30]
  reg  bwd_data_ctrl_marker; // @[RegSlices.scala 124:30]
  reg [6:0] bwd_data_ctrl_ecc; // @[RegSlices.scala 124:30]
  reg [31:0] bwd_data_ctrl_len; // @[RegSlices.scala 124:30]
  reg [2:0] bwd_data_ctrl_port_id; // @[RegSlices.scala 124:30]
  reg [10:0] bwd_data_ctrl_qid; // @[RegSlices.scala 124:30]
  reg  bwd_data_ctrl_has_cmpt; // @[RegSlices.scala 124:30]
  reg  bwd_data_last; // @[RegSlices.scala 124:30]
  reg [5:0] bwd_data_mty; // @[RegSlices.scala 124:30]
  wire  _fwd_valid_T = io_downStream_ready ? 1'h0 : fwd_valid; // @[RegSlices.scala 121:53]
  wire  bwd_valid_s = ~bwd_ready | io_upStream_valid; // @[RegSlices.scala 126:39]
  wire  _bwd_ready_T = io_upStream_valid ? 1'h0 : bwd_ready; // @[RegSlices.scala 132:53]
  assign io_upStream_ready = bwd_ready; // @[RegSlices.scala 107:31 RegSlices.scala 128:25]
  assign io_downStream_valid = fwd_valid; // @[RegSlices.scala 109:31 RegSlices.scala 116:21]
  assign io_downStream_bits_data = fwd_data_data; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_tcrc = fwd_data_tcrc; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_ctrl_marker = fwd_data_ctrl_marker; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_ctrl_ecc = fwd_data_ctrl_ecc; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_ctrl_len = fwd_data_ctrl_len; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_ctrl_port_id = fwd_data_ctrl_port_id; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_ctrl_qid = fwd_data_ctrl_qid; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_ctrl_has_cmpt = fwd_data_ctrl_has_cmpt; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_last = fwd_data_last; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_mty = fwd_data_mty; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  always @(posedge clock) begin
    if (reset) begin // @[RegSlices.scala 112:34]
      fwd_valid <= 1'h0; // @[RegSlices.scala 112:34]
    end else begin
      fwd_valid <= bwd_valid_s | _fwd_valid_T; // @[RegSlices.scala 121:25]
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_data <= io_upStream_bits_data;
      end else begin
        fwd_data_data <= bwd_data_data;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_tcrc <= io_upStream_bits_tcrc;
      end else begin
        fwd_data_tcrc <= bwd_data_tcrc;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_ctrl_marker <= io_upStream_bits_ctrl_marker;
      end else begin
        fwd_data_ctrl_marker <= bwd_data_ctrl_marker;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_ctrl_ecc <= io_upStream_bits_ctrl_ecc;
      end else begin
        fwd_data_ctrl_ecc <= bwd_data_ctrl_ecc;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_ctrl_len <= io_upStream_bits_ctrl_len;
      end else begin
        fwd_data_ctrl_len <= bwd_data_ctrl_len;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_ctrl_port_id <= io_upStream_bits_ctrl_port_id;
      end else begin
        fwd_data_ctrl_port_id <= bwd_data_ctrl_port_id;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_ctrl_qid <= io_upStream_bits_ctrl_qid;
      end else begin
        fwd_data_ctrl_qid <= bwd_data_ctrl_qid;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_ctrl_has_cmpt <= io_upStream_bits_ctrl_has_cmpt;
      end else begin
        fwd_data_ctrl_has_cmpt <= bwd_data_ctrl_has_cmpt;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_last <= io_upStream_bits_last;
      end else begin
        fwd_data_last <= bwd_data_last;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_mty <= io_upStream_bits_mty;
      end else begin
        fwd_data_mty <= bwd_data_mty;
      end
    end
    bwd_ready <= reset | (fwd_ready_s | _bwd_ready_T); // @[RegSlices.scala 123:34 RegSlices.scala 123:34 RegSlices.scala 132:25]
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_data <= io_upStream_bits_data;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_tcrc <= io_upStream_bits_tcrc;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_ctrl_marker <= io_upStream_bits_ctrl_marker;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_ctrl_ecc <= io_upStream_bits_ctrl_ecc;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_ctrl_len <= io_upStream_bits_ctrl_len;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_ctrl_port_id <= io_upStream_bits_ctrl_port_id;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_ctrl_qid <= io_upStream_bits_ctrl_qid;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_ctrl_has_cmpt <= io_upStream_bits_ctrl_has_cmpt;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_last <= io_upStream_bits_last;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_mty <= io_upStream_bits_mty;
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
  fwd_valid = _RAND_0[0:0];
  _RAND_1 = {16{`RANDOM}};
  fwd_data_data = _RAND_1[511:0];
  _RAND_2 = {1{`RANDOM}};
  fwd_data_tcrc = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  fwd_data_ctrl_marker = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  fwd_data_ctrl_ecc = _RAND_4[6:0];
  _RAND_5 = {1{`RANDOM}};
  fwd_data_ctrl_len = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  fwd_data_ctrl_port_id = _RAND_6[2:0];
  _RAND_7 = {1{`RANDOM}};
  fwd_data_ctrl_qid = _RAND_7[10:0];
  _RAND_8 = {1{`RANDOM}};
  fwd_data_ctrl_has_cmpt = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  fwd_data_last = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  fwd_data_mty = _RAND_10[5:0];
  _RAND_11 = {1{`RANDOM}};
  bwd_ready = _RAND_11[0:0];
  _RAND_12 = {16{`RANDOM}};
  bwd_data_data = _RAND_12[511:0];
  _RAND_13 = {1{`RANDOM}};
  bwd_data_tcrc = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  bwd_data_ctrl_marker = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  bwd_data_ctrl_ecc = _RAND_15[6:0];
  _RAND_16 = {1{`RANDOM}};
  bwd_data_ctrl_len = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  bwd_data_ctrl_port_id = _RAND_17[2:0];
  _RAND_18 = {1{`RANDOM}};
  bwd_data_ctrl_qid = _RAND_18[10:0];
  _RAND_19 = {1{`RANDOM}};
  bwd_data_ctrl_has_cmpt = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  bwd_data_last = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  bwd_data_mty = _RAND_21[5:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SV_STREAM_FIFO_2(
  input          io_m_clk,
  input          io_s_clk,
  input          io_reset_n,
  input  [143:0] io_in_data,
  input          io_in_valid,
  output         io_in_ready,
  output [143:0] io_out_data,
  output         io_out_valid,
  input          io_out_ready
);
  wire [143:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [17:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [143:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [17:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [17:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(144), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_in_ready = meta_s_axis_tready; // @[Meta.scala 34:41]
  assign io_out_data = meta_m_axis_tdata; // @[Meta.scala 31:41]
  assign io_out_valid = meta_m_axis_tvalid; // @[Meta.scala 32:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = io_out_ready; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = io_in_data; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 18'h3ffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 18'h3ffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = io_in_valid; // @[Meta.scala 48:41]
endmodule
module XConverter_2(
  input         io__in_clk,
  input         io__out_clk,
  input         io__rstn,
  output        io__in_ready,
  input         io__in_valid,
  input  [63:0] io__in_bits_addr,
  input  [31:0] io__in_bits_len,
  input         io__in_bits_eop,
  input         io__in_bits_sop,
  input         io__in_bits_mrkr_req,
  input         io__in_bits_sdi,
  input  [10:0] io__in_bits_qid,
  input         io__in_bits_error,
  input  [7:0]  io__in_bits_func,
  input  [15:0] io__in_bits_cidx,
  input  [2:0]  io__in_bits_port_id,
  input         io__in_bits_no_dma,
  input         io__out_ready,
  output        io__out_valid,
  output [63:0] io__out_bits_addr,
  output [31:0] io__out_bits_len,
  output        io__out_bits_eop,
  output        io__out_bits_sop,
  output        io__out_bits_mrkr_req,
  output        io__out_bits_sdi,
  output [10:0] io__out_bits_qid,
  output        io__out_bits_error,
  output [7:0]  io__out_bits_func,
  output [15:0] io__out_bits_cidx,
  output [2:0]  io__out_bits_port_id,
  output        io__out_bits_no_dma,
  output        io_out_valid,
  output        io_out_ready_1
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [143:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire [143:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  wire [39:0] fifo_io_in_data_lo = {io__in_bits_qid,io__in_bits_error,io__in_bits_func,io__in_bits_cidx,
    io__in_bits_port_id,io__in_bits_no_dma}; // @[XConverter.scala 103:63]
  wire [139:0] _fifo_io_in_data_T = {io__in_bits_addr,io__in_bits_len,io__in_bits_eop,io__in_bits_sop,
    io__in_bits_mrkr_req,io__in_bits_sdi,fifo_io_in_data_lo}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO_2 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io__in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign io__out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io__out_bits_addr = fifo_io_out_data[139:76]; // @[XConverter.scala 107:77]
  assign io__out_bits_len = fifo_io_out_data[75:44]; // @[XConverter.scala 107:77]
  assign io__out_bits_eop = fifo_io_out_data[43]; // @[XConverter.scala 107:77]
  assign io__out_bits_sop = fifo_io_out_data[42]; // @[XConverter.scala 107:77]
  assign io__out_bits_mrkr_req = fifo_io_out_data[41]; // @[XConverter.scala 107:77]
  assign io__out_bits_sdi = fifo_io_out_data[40]; // @[XConverter.scala 107:77]
  assign io__out_bits_qid = fifo_io_out_data[39:29]; // @[XConverter.scala 107:77]
  assign io__out_bits_error = fifo_io_out_data[28]; // @[XConverter.scala 107:77]
  assign io__out_bits_func = fifo_io_out_data[27:20]; // @[XConverter.scala 107:77]
  assign io__out_bits_cidx = fifo_io_out_data[19:4]; // @[XConverter.scala 107:77]
  assign io__out_bits_port_id = fifo_io_out_data[3:1]; // @[XConverter.scala 107:77]
  assign io__out_bits_no_dma = fifo_io_out_data[0]; // @[XConverter.scala 107:77]
  assign io_out_valid = io__out_valid;
  assign io_out_ready_1 = io__out_ready;
  assign fifo_io_m_clk = io__out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io__in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io__rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{4'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io__in_valid; // @[XConverter.scala 104:41]
  assign fifo_io_out_ready = io__out_ready; // @[XConverter.scala 109:41]
endmodule
module RegSlice_2(
  input         clock,
  input         reset,
  output        io_upStream_ready,
  input         io_upStream_valid,
  input  [63:0] io_upStream_bits_addr,
  input  [31:0] io_upStream_bits_len,
  input         io_upStream_bits_eop,
  input         io_upStream_bits_sop,
  input         io_upStream_bits_mrkr_req,
  input         io_upStream_bits_sdi,
  input  [10:0] io_upStream_bits_qid,
  input         io_upStream_bits_error,
  input  [7:0]  io_upStream_bits_func,
  input  [15:0] io_upStream_bits_cidx,
  input  [2:0]  io_upStream_bits_port_id,
  input         io_upStream_bits_no_dma,
  input         io_downStream_ready,
  output        io_downStream_valid,
  output [63:0] io_downStream_bits_addr,
  output [31:0] io_downStream_bits_len,
  output        io_downStream_bits_eop,
  output        io_downStream_bits_sop,
  output        io_downStream_bits_mrkr_req,
  output        io_downStream_bits_sdi,
  output [10:0] io_downStream_bits_qid,
  output        io_downStream_bits_error,
  output [7:0]  io_downStream_bits_func,
  output [15:0] io_downStream_bits_cidx,
  output [2:0]  io_downStream_bits_port_id,
  output        io_downStream_bits_no_dma
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [63:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
`endif // RANDOMIZE_REG_INIT
  reg  fwd_valid; // @[RegSlices.scala 112:34]
  reg [63:0] fwd_data_addr; // @[RegSlices.scala 113:30]
  reg [31:0] fwd_data_len; // @[RegSlices.scala 113:30]
  reg  fwd_data_eop; // @[RegSlices.scala 113:30]
  reg  fwd_data_sop; // @[RegSlices.scala 113:30]
  reg  fwd_data_mrkr_req; // @[RegSlices.scala 113:30]
  reg  fwd_data_sdi; // @[RegSlices.scala 113:30]
  reg [10:0] fwd_data_qid; // @[RegSlices.scala 113:30]
  reg  fwd_data_error; // @[RegSlices.scala 113:30]
  reg [7:0] fwd_data_func; // @[RegSlices.scala 113:30]
  reg [15:0] fwd_data_cidx; // @[RegSlices.scala 113:30]
  reg [2:0] fwd_data_port_id; // @[RegSlices.scala 113:30]
  reg  fwd_data_no_dma; // @[RegSlices.scala 113:30]
  wire  fwd_ready_s = ~fwd_valid | io_downStream_ready; // @[RegSlices.scala 115:35]
  reg  bwd_ready; // @[RegSlices.scala 123:34]
  reg [63:0] bwd_data_addr; // @[RegSlices.scala 124:30]
  reg [31:0] bwd_data_len; // @[RegSlices.scala 124:30]
  reg  bwd_data_eop; // @[RegSlices.scala 124:30]
  reg  bwd_data_sop; // @[RegSlices.scala 124:30]
  reg  bwd_data_mrkr_req; // @[RegSlices.scala 124:30]
  reg  bwd_data_sdi; // @[RegSlices.scala 124:30]
  reg [10:0] bwd_data_qid; // @[RegSlices.scala 124:30]
  reg  bwd_data_error; // @[RegSlices.scala 124:30]
  reg [7:0] bwd_data_func; // @[RegSlices.scala 124:30]
  reg [15:0] bwd_data_cidx; // @[RegSlices.scala 124:30]
  reg [2:0] bwd_data_port_id; // @[RegSlices.scala 124:30]
  reg  bwd_data_no_dma; // @[RegSlices.scala 124:30]
  wire  _fwd_valid_T = io_downStream_ready ? 1'h0 : fwd_valid; // @[RegSlices.scala 121:53]
  wire  bwd_valid_s = ~bwd_ready | io_upStream_valid; // @[RegSlices.scala 126:39]
  wire  _bwd_ready_T = io_upStream_valid ? 1'h0 : bwd_ready; // @[RegSlices.scala 132:53]
  assign io_upStream_ready = bwd_ready; // @[RegSlices.scala 107:31 RegSlices.scala 128:25]
  assign io_downStream_valid = fwd_valid; // @[RegSlices.scala 109:31 RegSlices.scala 116:21]
  assign io_downStream_bits_addr = fwd_data_addr; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_len = fwd_data_len; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_eop = fwd_data_eop; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_sop = fwd_data_sop; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_mrkr_req = fwd_data_mrkr_req; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_sdi = fwd_data_sdi; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_qid = fwd_data_qid; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_error = fwd_data_error; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_func = fwd_data_func; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_cidx = fwd_data_cidx; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_port_id = fwd_data_port_id; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_no_dma = fwd_data_no_dma; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  always @(posedge clock) begin
    if (reset) begin // @[RegSlices.scala 112:34]
      fwd_valid <= 1'h0; // @[RegSlices.scala 112:34]
    end else begin
      fwd_valid <= bwd_valid_s | _fwd_valid_T; // @[RegSlices.scala 121:25]
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_addr <= io_upStream_bits_addr;
      end else begin
        fwd_data_addr <= bwd_data_addr;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_len <= io_upStream_bits_len;
      end else begin
        fwd_data_len <= bwd_data_len;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_eop <= io_upStream_bits_eop;
      end else begin
        fwd_data_eop <= bwd_data_eop;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_sop <= io_upStream_bits_sop;
      end else begin
        fwd_data_sop <= bwd_data_sop;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_mrkr_req <= io_upStream_bits_mrkr_req;
      end else begin
        fwd_data_mrkr_req <= bwd_data_mrkr_req;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_sdi <= io_upStream_bits_sdi;
      end else begin
        fwd_data_sdi <= bwd_data_sdi;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_qid <= io_upStream_bits_qid;
      end else begin
        fwd_data_qid <= bwd_data_qid;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_error <= io_upStream_bits_error;
      end else begin
        fwd_data_error <= bwd_data_error;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_func <= io_upStream_bits_func;
      end else begin
        fwd_data_func <= bwd_data_func;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_cidx <= io_upStream_bits_cidx;
      end else begin
        fwd_data_cidx <= bwd_data_cidx;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_port_id <= io_upStream_bits_port_id;
      end else begin
        fwd_data_port_id <= bwd_data_port_id;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_no_dma <= io_upStream_bits_no_dma;
      end else begin
        fwd_data_no_dma <= bwd_data_no_dma;
      end
    end
    bwd_ready <= reset | (fwd_ready_s | _bwd_ready_T); // @[RegSlices.scala 123:34 RegSlices.scala 123:34 RegSlices.scala 132:25]
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_addr <= io_upStream_bits_addr;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_len <= io_upStream_bits_len;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_eop <= io_upStream_bits_eop;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_sop <= io_upStream_bits_sop;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_mrkr_req <= io_upStream_bits_mrkr_req;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_sdi <= io_upStream_bits_sdi;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_qid <= io_upStream_bits_qid;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_error <= io_upStream_bits_error;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_func <= io_upStream_bits_func;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_cidx <= io_upStream_bits_cidx;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_port_id <= io_upStream_bits_port_id;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_no_dma <= io_upStream_bits_no_dma;
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
  fwd_valid = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  fwd_data_addr = _RAND_1[63:0];
  _RAND_2 = {1{`RANDOM}};
  fwd_data_len = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  fwd_data_eop = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  fwd_data_sop = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  fwd_data_mrkr_req = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  fwd_data_sdi = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  fwd_data_qid = _RAND_7[10:0];
  _RAND_8 = {1{`RANDOM}};
  fwd_data_error = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  fwd_data_func = _RAND_9[7:0];
  _RAND_10 = {1{`RANDOM}};
  fwd_data_cidx = _RAND_10[15:0];
  _RAND_11 = {1{`RANDOM}};
  fwd_data_port_id = _RAND_11[2:0];
  _RAND_12 = {1{`RANDOM}};
  fwd_data_no_dma = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  bwd_ready = _RAND_13[0:0];
  _RAND_14 = {2{`RANDOM}};
  bwd_data_addr = _RAND_14[63:0];
  _RAND_15 = {1{`RANDOM}};
  bwd_data_len = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  bwd_data_eop = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  bwd_data_sop = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  bwd_data_mrkr_req = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  bwd_data_sdi = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  bwd_data_qid = _RAND_20[10:0];
  _RAND_21 = {1{`RANDOM}};
  bwd_data_error = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  bwd_data_func = _RAND_22[7:0];
  _RAND_23 = {1{`RANDOM}};
  bwd_data_cidx = _RAND_23[15:0];
  _RAND_24 = {1{`RANDOM}};
  bwd_data_port_id = _RAND_24[2:0];
  _RAND_25 = {1{`RANDOM}};
  bwd_data_no_dma = _RAND_25[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SV_STREAM_FIFO_3(
  input          io_m_clk,
  input          io_s_clk,
  input          io_reset_n,
  input  [127:0] io_in_data,
  input          io_in_valid,
  output         io_in_ready,
  output [127:0] io_out_data,
  output         io_out_valid,
  input          io_out_ready
);
  wire [127:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [15:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [127:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [15:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [15:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(128), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_in_ready = meta_s_axis_tready; // @[Meta.scala 34:41]
  assign io_out_data = meta_m_axis_tdata; // @[Meta.scala 31:41]
  assign io_out_valid = meta_m_axis_tvalid; // @[Meta.scala 32:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = io_out_ready; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = io_in_data; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 16'hffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 16'hffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = io_in_valid; // @[Meta.scala 48:41]
endmodule
module XConverter_3(
  input         io_in_clk,
  input         io_out_clk,
  input         io_rstn,
  output        io_in_ready,
  input         io_in_valid,
  input  [63:0] io_in_bits_addr,
  input  [10:0] io_in_bits_qid,
  input         io_in_bits_error,
  input  [7:0]  io_in_bits_func,
  input  [2:0]  io_in_bits_port_id,
  input  [6:0]  io_in_bits_pfch_tag,
  input  [31:0] io_in_bits_len,
  input         io_out_ready,
  output        io_out_valid,
  output [63:0] io_out_bits_addr,
  output [10:0] io_out_bits_qid,
  output        io_out_bits_error,
  output [7:0]  io_out_bits_func,
  output [2:0]  io_out_bits_port_id,
  output [6:0]  io_out_bits_pfch_tag,
  output [31:0] io_out_bits_len,
  output        io_out_ready_0,
  output        io_out_valid_1
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [127:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire [127:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  wire [125:0] _fifo_io_in_data_T = {io_in_bits_addr,io_in_bits_qid,io_in_bits_error,io_in_bits_func,io_in_bits_port_id,
    io_in_bits_pfch_tag,io_in_bits_len}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO_3 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign io_out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io_out_bits_addr = fifo_io_out_data[125:62]; // @[XConverter.scala 107:77]
  assign io_out_bits_qid = fifo_io_out_data[61:51]; // @[XConverter.scala 107:77]
  assign io_out_bits_error = fifo_io_out_data[50]; // @[XConverter.scala 107:77]
  assign io_out_bits_func = fifo_io_out_data[49:42]; // @[XConverter.scala 107:77]
  assign io_out_bits_port_id = fifo_io_out_data[41:39]; // @[XConverter.scala 107:77]
  assign io_out_bits_pfch_tag = fifo_io_out_data[38:32]; // @[XConverter.scala 107:77]
  assign io_out_bits_len = fifo_io_out_data[31:0]; // @[XConverter.scala 107:77]
  assign io_out_ready_0 = io_out_ready;
  assign io_out_valid_1 = io_out_valid;
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{2'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io_in_valid; // @[XConverter.scala 104:41]
  assign fifo_io_out_ready = io_out_ready; // @[XConverter.scala 109:41]
endmodule
module RegSlice_3(
  input         clock,
  input         reset,
  output        io_upStream_ready,
  input         io_upStream_valid,
  input  [63:0] io_upStream_bits_addr,
  input  [10:0] io_upStream_bits_qid,
  input         io_upStream_bits_error,
  input  [7:0]  io_upStream_bits_func,
  input  [2:0]  io_upStream_bits_port_id,
  input  [6:0]  io_upStream_bits_pfch_tag,
  input  [31:0] io_upStream_bits_len,
  input         io_downStream_ready,
  output        io_downStream_valid,
  output [63:0] io_downStream_bits_addr,
  output [10:0] io_downStream_bits_qid,
  output        io_downStream_bits_error,
  output [7:0]  io_downStream_bits_func,
  output [2:0]  io_downStream_bits_port_id,
  output [6:0]  io_downStream_bits_pfch_tag,
  output [31:0] io_downStream_bits_len
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [63:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
`endif // RANDOMIZE_REG_INIT
  reg  fwd_valid; // @[RegSlices.scala 112:34]
  reg [63:0] fwd_data_addr; // @[RegSlices.scala 113:30]
  reg [10:0] fwd_data_qid; // @[RegSlices.scala 113:30]
  reg  fwd_data_error; // @[RegSlices.scala 113:30]
  reg [7:0] fwd_data_func; // @[RegSlices.scala 113:30]
  reg [2:0] fwd_data_port_id; // @[RegSlices.scala 113:30]
  reg [6:0] fwd_data_pfch_tag; // @[RegSlices.scala 113:30]
  reg [31:0] fwd_data_len; // @[RegSlices.scala 113:30]
  wire  fwd_ready_s = ~fwd_valid | io_downStream_ready; // @[RegSlices.scala 115:35]
  reg  bwd_ready; // @[RegSlices.scala 123:34]
  reg [63:0] bwd_data_addr; // @[RegSlices.scala 124:30]
  reg [10:0] bwd_data_qid; // @[RegSlices.scala 124:30]
  reg  bwd_data_error; // @[RegSlices.scala 124:30]
  reg [7:0] bwd_data_func; // @[RegSlices.scala 124:30]
  reg [2:0] bwd_data_port_id; // @[RegSlices.scala 124:30]
  reg [6:0] bwd_data_pfch_tag; // @[RegSlices.scala 124:30]
  reg [31:0] bwd_data_len; // @[RegSlices.scala 124:30]
  wire  _fwd_valid_T = io_downStream_ready ? 1'h0 : fwd_valid; // @[RegSlices.scala 121:53]
  wire  bwd_valid_s = ~bwd_ready | io_upStream_valid; // @[RegSlices.scala 126:39]
  wire  _bwd_ready_T = io_upStream_valid ? 1'h0 : bwd_ready; // @[RegSlices.scala 132:53]
  assign io_upStream_ready = bwd_ready; // @[RegSlices.scala 107:31 RegSlices.scala 128:25]
  assign io_downStream_valid = fwd_valid; // @[RegSlices.scala 109:31 RegSlices.scala 116:21]
  assign io_downStream_bits_addr = fwd_data_addr; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_qid = fwd_data_qid; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_error = fwd_data_error; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_func = fwd_data_func; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_port_id = fwd_data_port_id; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_pfch_tag = fwd_data_pfch_tag; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_len = fwd_data_len; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  always @(posedge clock) begin
    if (reset) begin // @[RegSlices.scala 112:34]
      fwd_valid <= 1'h0; // @[RegSlices.scala 112:34]
    end else begin
      fwd_valid <= bwd_valid_s | _fwd_valid_T; // @[RegSlices.scala 121:25]
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_addr <= io_upStream_bits_addr;
      end else begin
        fwd_data_addr <= bwd_data_addr;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_qid <= io_upStream_bits_qid;
      end else begin
        fwd_data_qid <= bwd_data_qid;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_error <= io_upStream_bits_error;
      end else begin
        fwd_data_error <= bwd_data_error;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_func <= io_upStream_bits_func;
      end else begin
        fwd_data_func <= bwd_data_func;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_port_id <= io_upStream_bits_port_id;
      end else begin
        fwd_data_port_id <= bwd_data_port_id;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_pfch_tag <= io_upStream_bits_pfch_tag;
      end else begin
        fwd_data_pfch_tag <= bwd_data_pfch_tag;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_len <= io_upStream_bits_len;
      end else begin
        fwd_data_len <= bwd_data_len;
      end
    end
    bwd_ready <= reset | (fwd_ready_s | _bwd_ready_T); // @[RegSlices.scala 123:34 RegSlices.scala 123:34 RegSlices.scala 132:25]
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_addr <= io_upStream_bits_addr;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_qid <= io_upStream_bits_qid;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_error <= io_upStream_bits_error;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_func <= io_upStream_bits_func;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_port_id <= io_upStream_bits_port_id;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_pfch_tag <= io_upStream_bits_pfch_tag;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_len <= io_upStream_bits_len;
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
  fwd_valid = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  fwd_data_addr = _RAND_1[63:0];
  _RAND_2 = {1{`RANDOM}};
  fwd_data_qid = _RAND_2[10:0];
  _RAND_3 = {1{`RANDOM}};
  fwd_data_error = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  fwd_data_func = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  fwd_data_port_id = _RAND_5[2:0];
  _RAND_6 = {1{`RANDOM}};
  fwd_data_pfch_tag = _RAND_6[6:0];
  _RAND_7 = {1{`RANDOM}};
  fwd_data_len = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  bwd_ready = _RAND_8[0:0];
  _RAND_9 = {2{`RANDOM}};
  bwd_data_addr = _RAND_9[63:0];
  _RAND_10 = {1{`RANDOM}};
  bwd_data_qid = _RAND_10[10:0];
  _RAND_11 = {1{`RANDOM}};
  bwd_data_error = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  bwd_data_func = _RAND_12[7:0];
  _RAND_13 = {1{`RANDOM}};
  bwd_data_port_id = _RAND_13[2:0];
  _RAND_14 = {1{`RANDOM}};
  bwd_data_pfch_tag = _RAND_14[6:0];
  _RAND_15 = {1{`RANDOM}};
  bwd_data_len = _RAND_15[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CMDBoundaryCheck(
  input         clock,
  input         reset,
  output        io_in_ready,
  input         io_in_valid,
  input  [63:0] io_in_bits_addr,
  input  [10:0] io_in_bits_qid,
  input         io_in_bits_error,
  input  [7:0]  io_in_bits_func,
  input  [2:0]  io_in_bits_port_id,
  input  [6:0]  io_in_bits_pfch_tag,
  input  [31:0] io_in_bits_len,
  input         io_out_ready,
  output        io_out_valid,
  output [63:0] io_out_bits_addr,
  output [10:0] io_out_bits_qid,
  output        io_out_bits_error,
  output [7:0]  io_out_bits_func,
  output [2:0]  io_out_bits_port_id,
  output [6:0]  io_out_bits_pfch_tag,
  output [31:0] io_out_bits_len
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [63:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
`endif // RANDOMIZE_REG_INIT
  reg [23:0] offset_addr; // @[CheckSplit.scala 81:34]
  reg [23:0] new_length; // @[CheckSplit.scala 82:33]
  reg [63:0] cmd_addr; // @[CheckSplit.scala 83:31]
  reg [31:0] cmd_len; // @[CheckSplit.scala 84:30]
  reg [63:0] mini_addr; // @[CheckSplit.scala 85:32]
  reg [31:0] mini_len; // @[CheckSplit.scala 86:31]
  reg [10:0] cmd_temp_qid; // @[CheckSplit.scala 87:27]
  reg  cmd_temp_error; // @[CheckSplit.scala 87:27]
  reg [7:0] cmd_temp_func; // @[CheckSplit.scala 87:27]
  reg [2:0] cmd_temp_port_id; // @[CheckSplit.scala 87:27]
  reg [6:0] cmd_temp_pfch_tag; // @[CheckSplit.scala 87:27]
  reg [2:0] state; // @[CheckSplit.scala 90:50]
  wire  _T = 3'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_1 = io_in_ready & io_in_valid; // @[Decoupled.scala 40:37]
  wire [63:0] _offset_addr_T = io_in_bits_addr & 64'h1fffff; // @[CheckSplit.scala 103:92]
  wire [63:0] _new_length_T_2 = 64'h200000 - _offset_addr_T; // @[CheckSplit.scala 105:88]
  wire [63:0] _GEN_9 = _T_1 ? _offset_addr_T : {{40'd0}, offset_addr}; // @[CheckSplit.scala 99:43 CheckSplit.scala 103:73 CheckSplit.scala 81:34]
  wire [63:0] _GEN_11 = _T_1 ? _new_length_T_2 : {{40'd0}, new_length}; // @[CheckSplit.scala 99:43 CheckSplit.scala 105:73 CheckSplit.scala 82:33]
  wire  _T_2 = 3'h1 == state; // @[Conditional.scala 37:30]
  wire [31:0] _GEN_136 = {{8'd0}, offset_addr}; // @[CheckSplit.scala 109:43]
  wire [31:0] _T_4 = _GEN_136 + cmd_len; // @[CheckSplit.scala 109:43]
  wire [63:0] _GEN_137 = {{40'd0}, new_length}; // @[CheckSplit.scala 112:85]
  wire [63:0] _cmd_addr_T_1 = cmd_addr + _GEN_137; // @[CheckSplit.scala 112:85]
  wire [31:0] _GEN_138 = {{8'd0}, new_length}; // @[CheckSplit.scala 113:84]
  wire [31:0] _cmd_len_T_1 = cmd_len - _GEN_138; // @[CheckSplit.scala 113:84]
  wire  _T_6 = 3'h2 == state; // @[Conditional.scala 37:30]
  wire [63:0] _cmd_addr_T_3 = cmd_addr + 64'h200000; // @[CheckSplit.scala 125:85]
  wire [31:0] _cmd_len_T_3 = cmd_len - 32'h200000; // @[CheckSplit.scala 126:84]
  wire [31:0] _GEN_18 = cmd_len > 32'h200000 ? 32'h200000 : cmd_len; // @[CheckSplit.scala 122:52 CheckSplit.scala 124:73 CheckSplit.scala 130:73]
  wire [63:0] _GEN_19 = cmd_len > 32'h200000 ? _cmd_addr_T_3 : cmd_addr; // @[CheckSplit.scala 122:52 CheckSplit.scala 125:73 CheckSplit.scala 83:31]
  wire [31:0] _GEN_20 = cmd_len > 32'h200000 ? _cmd_len_T_3 : cmd_len; // @[CheckSplit.scala 122:52 CheckSplit.scala 126:73 CheckSplit.scala 84:30]
  wire [2:0] _GEN_21 = cmd_len > 32'h200000 ? 3'h3 : 3'h4; // @[CheckSplit.scala 122:52 CheckSplit.scala 127:57 CheckSplit.scala 131:57]
  wire  _T_8 = 3'h3 == state; // @[Conditional.scala 37:30]
  wire  _T_10 = mini_len > 32'h1000; // @[CheckSplit.scala 136:47]
  wire [63:0] _mini_addr_T_1 = mini_addr + 64'h1000; // @[CheckSplit.scala 137:94]
  wire [31:0] _mini_len_T_1 = mini_len - 32'h1000; // @[CheckSplit.scala 138:93]
  wire [63:0] _GEN_22 = mini_len > 32'h1000 ? _mini_addr_T_1 : mini_addr; // @[CheckSplit.scala 136:66 CheckSplit.scala 137:81 CheckSplit.scala 85:32]
  wire [31:0] _GEN_23 = mini_len > 32'h1000 ? _mini_len_T_1 : mini_len; // @[CheckSplit.scala 136:66 CheckSplit.scala 138:81 CheckSplit.scala 86:31]
  wire [31:0] _GEN_25 = mini_len > 32'h1000 ? 32'h1000 : mini_len; // @[CheckSplit.scala 136:66 CheckSplit.scala 141:73 CheckSplit.scala 146:73]
  wire [2:0] _GEN_32 = mini_len > 32'h1000 ? state : 3'h2; // @[CheckSplit.scala 136:66 CheckSplit.scala 90:50 CheckSplit.scala 148:81]
  wire [63:0] _GEN_33 = io_out_ready ? _GEN_22 : mini_addr; // @[CheckSplit.scala 135:51 CheckSplit.scala 85:32]
  wire [31:0] _GEN_34 = io_out_ready ? _GEN_23 : mini_len; // @[CheckSplit.scala 135:51 CheckSplit.scala 86:31]
  wire [31:0] _GEN_36 = io_out_ready ? _GEN_25 : 32'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [6:0] _GEN_37 = io_out_ready ? cmd_temp_pfch_tag : 7'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [2:0] _GEN_38 = io_out_ready ? cmd_temp_port_id : 3'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [7:0] _GEN_39 = io_out_ready ? cmd_temp_func : 8'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire  _GEN_40 = io_out_ready & cmd_temp_error; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [10:0] _GEN_41 = io_out_ready ? cmd_temp_qid : 11'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [63:0] _GEN_42 = io_out_ready ? mini_addr : 64'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [2:0] _GEN_43 = io_out_ready ? _GEN_32 : state; // @[CheckSplit.scala 135:51 CheckSplit.scala 90:50]
  wire  _T_11 = 3'h4 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_54 = _T_10 ? state : 3'h0; // @[CheckSplit.scala 154:66 CheckSplit.scala 90:50 CheckSplit.scala 166:81]
  wire [2:0] _GEN_65 = io_out_ready ? _GEN_54 : state; // @[CheckSplit.scala 153:51 CheckSplit.scala 90:50]
  wire [63:0] _GEN_66 = _T_11 ? _GEN_33 : mini_addr; // @[Conditional.scala 39:67 CheckSplit.scala 85:32]
  wire [31:0] _GEN_67 = _T_11 ? _GEN_34 : mini_len; // @[Conditional.scala 39:67 CheckSplit.scala 86:31]
  wire  _GEN_68 = _T_11 & io_out_ready; // @[Conditional.scala 39:67 CheckSplit.scala 94:57]
  wire [31:0] _GEN_69 = _T_11 ? _GEN_36 : 32'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [6:0] _GEN_70 = _T_11 ? _GEN_37 : 7'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [2:0] _GEN_71 = _T_11 ? _GEN_38 : 3'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [7:0] _GEN_72 = _T_11 ? _GEN_39 : 8'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_73 = _T_11 & _GEN_40; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [10:0] _GEN_74 = _T_11 ? _GEN_41 : 11'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [63:0] _GEN_75 = _T_11 ? _GEN_42 : 64'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [2:0] _GEN_76 = _T_11 ? _GEN_65 : state; // @[Conditional.scala 39:67 CheckSplit.scala 90:50]
  wire [63:0] _GEN_77 = _T_8 ? _GEN_33 : _GEN_66; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_78 = _T_8 ? _GEN_34 : _GEN_67; // @[Conditional.scala 39:67]
  wire  _GEN_79 = _T_8 ? io_out_ready : _GEN_68; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_80 = _T_8 ? _GEN_36 : _GEN_69; // @[Conditional.scala 39:67]
  wire [6:0] _GEN_81 = _T_8 ? _GEN_37 : _GEN_70; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_82 = _T_8 ? _GEN_38 : _GEN_71; // @[Conditional.scala 39:67]
  wire [7:0] _GEN_83 = _T_8 ? _GEN_39 : _GEN_72; // @[Conditional.scala 39:67]
  wire  _GEN_84 = _T_8 ? _GEN_40 : _GEN_73; // @[Conditional.scala 39:67]
  wire [10:0] _GEN_85 = _T_8 ? _GEN_41 : _GEN_74; // @[Conditional.scala 39:67]
  wire [63:0] _GEN_86 = _T_8 ? _GEN_42 : _GEN_75; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_87 = _T_8 ? _GEN_43 : _GEN_76; // @[Conditional.scala 39:67]
  wire  _GEN_93 = _T_6 ? 1'h0 : _GEN_79; // @[Conditional.scala 39:67 CheckSplit.scala 94:57]
  wire [31:0] _GEN_94 = _T_6 ? 32'h0 : _GEN_80; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [6:0] _GEN_95 = _T_6 ? 7'h0 : _GEN_81; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [2:0] _GEN_96 = _T_6 ? 3'h0 : _GEN_82; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [7:0] _GEN_97 = _T_6 ? 8'h0 : _GEN_83; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_98 = _T_6 ? 1'h0 : _GEN_84; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [10:0] _GEN_99 = _T_6 ? 11'h0 : _GEN_85; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [63:0] _GEN_100 = _T_6 ? 64'h0 : _GEN_86; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_106 = _T_2 ? 1'h0 : _GEN_93; // @[Conditional.scala 39:67 CheckSplit.scala 94:57]
  wire [31:0] _GEN_107 = _T_2 ? 32'h0 : _GEN_94; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [6:0] _GEN_108 = _T_2 ? 7'h0 : _GEN_95; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [2:0] _GEN_109 = _T_2 ? 3'h0 : _GEN_96; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [7:0] _GEN_110 = _T_2 ? 8'h0 : _GEN_97; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_111 = _T_2 ? 1'h0 : _GEN_98; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [10:0] _GEN_112 = _T_2 ? 11'h0 : _GEN_99; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [63:0] _GEN_113 = _T_2 ? 64'h0 : _GEN_100; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [63:0] _GEN_123 = _T ? _GEN_9 : {{40'd0}, offset_addr}; // @[Conditional.scala 40:58 CheckSplit.scala 81:34]
  wire [63:0] _GEN_125 = _T ? _GEN_11 : {{40'd0}, new_length}; // @[Conditional.scala 40:58 CheckSplit.scala 82:33]
  assign io_in_ready = state == 3'h0; // @[CheckSplit.scala 92:75]
  assign io_out_valid = _T ? 1'h0 : _GEN_106; // @[Conditional.scala 40:58 CheckSplit.scala 94:57]
  assign io_out_bits_addr = _T ? 64'h0 : _GEN_113; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_qid = _T ? 11'h0 : _GEN_112; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_error = _T ? 1'h0 : _GEN_111; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_func = _T ? 8'h0 : _GEN_110; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_port_id = _T ? 3'h0 : _GEN_109; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_pfch_tag = _T ? 7'h0 : _GEN_108; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_len = _T ? 32'h0 : _GEN_107; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  always @(posedge clock) begin
    if (reset) begin // @[CheckSplit.scala 81:34]
      offset_addr <= 24'h0; // @[CheckSplit.scala 81:34]
    end else begin
      offset_addr <= _GEN_123[23:0];
    end
    if (reset) begin // @[CheckSplit.scala 82:33]
      new_length <= 24'h0; // @[CheckSplit.scala 82:33]
    end else begin
      new_length <= _GEN_125[23:0];
    end
    if (reset) begin // @[CheckSplit.scala 83:31]
      cmd_addr <= 64'h0; // @[CheckSplit.scala 83:31]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_addr <= io_in_bits_addr; // @[CheckSplit.scala 100:73]
      end
    end else if (_T_2) begin // @[Conditional.scala 39:67]
      if (_T_4 > 32'h200000) begin // @[CheckSplit.scala 109:68]
        cmd_addr <= _cmd_addr_T_1; // @[CheckSplit.scala 112:73]
      end
    end else if (_T_6) begin // @[Conditional.scala 39:67]
      cmd_addr <= _GEN_19;
    end
    if (reset) begin // @[CheckSplit.scala 84:30]
      cmd_len <= 32'h0; // @[CheckSplit.scala 84:30]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_len <= io_in_bits_len; // @[CheckSplit.scala 101:73]
      end
    end else if (_T_2) begin // @[Conditional.scala 39:67]
      if (_T_4 > 32'h200000) begin // @[CheckSplit.scala 109:68]
        cmd_len <= _cmd_len_T_1; // @[CheckSplit.scala 113:73]
      end
    end else if (_T_6) begin // @[Conditional.scala 39:67]
      cmd_len <= _GEN_20;
    end
    if (reset) begin // @[CheckSplit.scala 85:32]
      mini_addr <= 64'h0; // @[CheckSplit.scala 85:32]
    end else if (!(_T)) begin // @[Conditional.scala 40:58]
      if (_T_2) begin // @[Conditional.scala 39:67]
        mini_addr <= cmd_addr;
      end else if (_T_6) begin // @[Conditional.scala 39:67]
        mini_addr <= cmd_addr;
      end else begin
        mini_addr <= _GEN_77;
      end
    end
    if (reset) begin // @[CheckSplit.scala 86:31]
      mini_len <= 32'h0; // @[CheckSplit.scala 86:31]
    end else if (!(_T)) begin // @[Conditional.scala 40:58]
      if (_T_2) begin // @[Conditional.scala 39:67]
        if (_T_4 > 32'h200000) begin // @[CheckSplit.scala 109:68]
          mini_len <= {{8'd0}, new_length}; // @[CheckSplit.scala 111:73]
        end else begin
          mini_len <= cmd_len; // @[CheckSplit.scala 117:73]
        end
      end else if (_T_6) begin // @[Conditional.scala 39:67]
        mini_len <= _GEN_18;
      end else begin
        mini_len <= _GEN_78;
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_qid <= io_in_bits_qid; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_error <= io_in_bits_error; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_func <= io_in_bits_func; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_port_id <= io_in_bits_port_id; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_pfch_tag <= io_in_bits_pfch_tag; // @[CheckSplit.scala 102:73]
      end
    end
    if (reset) begin // @[CheckSplit.scala 90:50]
      state <= 3'h0; // @[CheckSplit.scala 90:50]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        state <= 3'h1; // @[CheckSplit.scala 104:41]
      end
    end else if (_T_2) begin // @[Conditional.scala 39:67]
      if (_T_4 > 32'h200000) begin // @[CheckSplit.scala 109:68]
        state <= 3'h3; // @[CheckSplit.scala 114:57]
      end else begin
        state <= 3'h4; // @[CheckSplit.scala 118:57]
      end
    end else if (_T_6) begin // @[Conditional.scala 39:67]
      state <= _GEN_21;
    end else begin
      state <= _GEN_87;
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
  offset_addr = _RAND_0[23:0];
  _RAND_1 = {1{`RANDOM}};
  new_length = _RAND_1[23:0];
  _RAND_2 = {2{`RANDOM}};
  cmd_addr = _RAND_2[63:0];
  _RAND_3 = {1{`RANDOM}};
  cmd_len = _RAND_3[31:0];
  _RAND_4 = {2{`RANDOM}};
  mini_addr = _RAND_4[63:0];
  _RAND_5 = {1{`RANDOM}};
  mini_len = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  cmd_temp_qid = _RAND_6[10:0];
  _RAND_7 = {1{`RANDOM}};
  cmd_temp_error = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  cmd_temp_func = _RAND_8[7:0];
  _RAND_9 = {1{`RANDOM}};
  cmd_temp_port_id = _RAND_9[2:0];
  _RAND_10 = {1{`RANDOM}};
  cmd_temp_pfch_tag = _RAND_10[6:0];
  _RAND_11 = {1{`RANDOM}};
  state = _RAND_11[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CMDBoundaryCheck_1(
  input         clock,
  input         reset,
  output        io_in_ready,
  input         io_in_valid,
  input  [63:0] io_in_bits_addr,
  input  [31:0] io_in_bits_len,
  input         io_in_bits_eop,
  input         io_in_bits_sop,
  input         io_in_bits_mrkr_req,
  input         io_in_bits_sdi,
  input  [10:0] io_in_bits_qid,
  input         io_in_bits_error,
  input  [7:0]  io_in_bits_func,
  input  [15:0] io_in_bits_cidx,
  input  [2:0]  io_in_bits_port_id,
  input         io_in_bits_no_dma,
  input         io_out_ready,
  output        io_out_valid,
  output [63:0] io_out_bits_addr,
  output [31:0] io_out_bits_len,
  output        io_out_bits_eop,
  output        io_out_bits_sop,
  output        io_out_bits_mrkr_req,
  output        io_out_bits_sdi,
  output [10:0] io_out_bits_qid,
  output        io_out_bits_error,
  output [7:0]  io_out_bits_func,
  output [15:0] io_out_bits_cidx,
  output [2:0]  io_out_bits_port_id,
  output        io_out_bits_no_dma
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [63:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
`endif // RANDOMIZE_REG_INIT
  reg [23:0] offset_addr; // @[CheckSplit.scala 81:34]
  reg [23:0] new_length; // @[CheckSplit.scala 82:33]
  reg [63:0] cmd_addr; // @[CheckSplit.scala 83:31]
  reg [31:0] cmd_len; // @[CheckSplit.scala 84:30]
  reg [63:0] mini_addr; // @[CheckSplit.scala 85:32]
  reg [31:0] mini_len; // @[CheckSplit.scala 86:31]
  reg  cmd_temp_eop; // @[CheckSplit.scala 87:27]
  reg  cmd_temp_sop; // @[CheckSplit.scala 87:27]
  reg  cmd_temp_mrkr_req; // @[CheckSplit.scala 87:27]
  reg  cmd_temp_sdi; // @[CheckSplit.scala 87:27]
  reg [10:0] cmd_temp_qid; // @[CheckSplit.scala 87:27]
  reg  cmd_temp_error; // @[CheckSplit.scala 87:27]
  reg [7:0] cmd_temp_func; // @[CheckSplit.scala 87:27]
  reg [15:0] cmd_temp_cidx; // @[CheckSplit.scala 87:27]
  reg [2:0] cmd_temp_port_id; // @[CheckSplit.scala 87:27]
  reg  cmd_temp_no_dma; // @[CheckSplit.scala 87:27]
  reg [2:0] state; // @[CheckSplit.scala 90:50]
  wire  _T = 3'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_1 = io_in_ready & io_in_valid; // @[Decoupled.scala 40:37]
  wire [63:0] _offset_addr_T = io_in_bits_addr & 64'h1fffff; // @[CheckSplit.scala 103:92]
  wire [63:0] _new_length_T_2 = 64'h200000 - _offset_addr_T; // @[CheckSplit.scala 105:88]
  wire [63:0] _GEN_14 = _T_1 ? _offset_addr_T : {{40'd0}, offset_addr}; // @[CheckSplit.scala 99:43 CheckSplit.scala 103:73 CheckSplit.scala 81:34]
  wire [63:0] _GEN_16 = _T_1 ? _new_length_T_2 : {{40'd0}, new_length}; // @[CheckSplit.scala 99:43 CheckSplit.scala 105:73 CheckSplit.scala 82:33]
  wire  _T_2 = 3'h1 == state; // @[Conditional.scala 37:30]
  wire [31:0] _GEN_191 = {{8'd0}, offset_addr}; // @[CheckSplit.scala 109:43]
  wire [31:0] _T_4 = _GEN_191 + cmd_len; // @[CheckSplit.scala 109:43]
  wire [63:0] _GEN_192 = {{40'd0}, new_length}; // @[CheckSplit.scala 112:85]
  wire [63:0] _cmd_addr_T_1 = cmd_addr + _GEN_192; // @[CheckSplit.scala 112:85]
  wire [31:0] _GEN_193 = {{8'd0}, new_length}; // @[CheckSplit.scala 113:84]
  wire [31:0] _cmd_len_T_1 = cmd_len - _GEN_193; // @[CheckSplit.scala 113:84]
  wire  _T_6 = 3'h2 == state; // @[Conditional.scala 37:30]
  wire [63:0] _cmd_addr_T_3 = cmd_addr + 64'h200000; // @[CheckSplit.scala 125:85]
  wire [31:0] _cmd_len_T_3 = cmd_len - 32'h200000; // @[CheckSplit.scala 126:84]
  wire [31:0] _GEN_23 = cmd_len > 32'h200000 ? 32'h200000 : cmd_len; // @[CheckSplit.scala 122:52 CheckSplit.scala 124:73 CheckSplit.scala 130:73]
  wire [63:0] _GEN_24 = cmd_len > 32'h200000 ? _cmd_addr_T_3 : cmd_addr; // @[CheckSplit.scala 122:52 CheckSplit.scala 125:73 CheckSplit.scala 83:31]
  wire [31:0] _GEN_25 = cmd_len > 32'h200000 ? _cmd_len_T_3 : cmd_len; // @[CheckSplit.scala 122:52 CheckSplit.scala 126:73 CheckSplit.scala 84:30]
  wire [2:0] _GEN_26 = cmd_len > 32'h200000 ? 3'h3 : 3'h4; // @[CheckSplit.scala 122:52 CheckSplit.scala 127:57 CheckSplit.scala 131:57]
  wire  _T_8 = 3'h3 == state; // @[Conditional.scala 37:30]
  wire  _T_10 = mini_len > 32'h8000; // @[CheckSplit.scala 136:47]
  wire [63:0] _mini_addr_T_1 = mini_addr + 64'h8000; // @[CheckSplit.scala 137:94]
  wire [31:0] _mini_len_T_1 = mini_len - 32'h8000; // @[CheckSplit.scala 138:93]
  wire [63:0] _GEN_27 = mini_len > 32'h8000 ? _mini_addr_T_1 : mini_addr; // @[CheckSplit.scala 136:66 CheckSplit.scala 137:81 CheckSplit.scala 85:32]
  wire [31:0] _GEN_28 = mini_len > 32'h8000 ? _mini_len_T_1 : mini_len; // @[CheckSplit.scala 136:66 CheckSplit.scala 138:81 CheckSplit.scala 86:31]
  wire [31:0] _GEN_40 = mini_len > 32'h8000 ? 32'h8000 : mini_len; // @[CheckSplit.scala 136:66 CheckSplit.scala 141:73 CheckSplit.scala 146:73]
  wire [2:0] _GEN_42 = mini_len > 32'h8000 ? state : 3'h2; // @[CheckSplit.scala 136:66 CheckSplit.scala 90:50 CheckSplit.scala 148:81]
  wire [63:0] _GEN_43 = io_out_ready ? _GEN_27 : mini_addr; // @[CheckSplit.scala 135:51 CheckSplit.scala 85:32]
  wire [31:0] _GEN_44 = io_out_ready ? _GEN_28 : mini_len; // @[CheckSplit.scala 135:51 CheckSplit.scala 86:31]
  wire  _GEN_46 = io_out_ready & cmd_temp_no_dma; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [2:0] _GEN_47 = io_out_ready ? cmd_temp_port_id : 3'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [15:0] _GEN_48 = io_out_ready ? cmd_temp_cidx : 16'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [7:0] _GEN_49 = io_out_ready ? cmd_temp_func : 8'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire  _GEN_50 = io_out_ready & cmd_temp_error; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [10:0] _GEN_51 = io_out_ready ? cmd_temp_qid : 11'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire  _GEN_52 = io_out_ready & cmd_temp_sdi; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire  _GEN_53 = io_out_ready & cmd_temp_mrkr_req; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire  _GEN_54 = io_out_ready & cmd_temp_sop; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire  _GEN_55 = io_out_ready & cmd_temp_eop; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [31:0] _GEN_56 = io_out_ready ? _GEN_40 : 32'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [63:0] _GEN_57 = io_out_ready ? mini_addr : 64'h0; // @[CheckSplit.scala 135:51 CheckSplit.scala 95:65]
  wire [2:0] _GEN_58 = io_out_ready ? _GEN_42 : state; // @[CheckSplit.scala 135:51 CheckSplit.scala 90:50]
  wire  _T_11 = 3'h4 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_74 = _T_10 ? state : 3'h0; // @[CheckSplit.scala 154:66 CheckSplit.scala 90:50 CheckSplit.scala 166:81]
  wire [2:0] _GEN_90 = io_out_ready ? _GEN_74 : state; // @[CheckSplit.scala 153:51 CheckSplit.scala 90:50]
  wire [63:0] _GEN_91 = _T_11 ? _GEN_43 : mini_addr; // @[Conditional.scala 39:67 CheckSplit.scala 85:32]
  wire [31:0] _GEN_92 = _T_11 ? _GEN_44 : mini_len; // @[Conditional.scala 39:67 CheckSplit.scala 86:31]
  wire  _GEN_93 = _T_11 & io_out_ready; // @[Conditional.scala 39:67 CheckSplit.scala 94:57]
  wire  _GEN_94 = _T_11 & _GEN_46; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [2:0] _GEN_95 = _T_11 ? _GEN_47 : 3'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [15:0] _GEN_96 = _T_11 ? _GEN_48 : 16'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [7:0] _GEN_97 = _T_11 ? _GEN_49 : 8'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_98 = _T_11 & _GEN_50; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [10:0] _GEN_99 = _T_11 ? _GEN_51 : 11'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_100 = _T_11 & _GEN_52; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_101 = _T_11 & _GEN_53; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_102 = _T_11 & _GEN_54; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_103 = _T_11 & _GEN_55; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [31:0] _GEN_104 = _T_11 ? _GEN_56 : 32'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [63:0] _GEN_105 = _T_11 ? _GEN_57 : 64'h0; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [2:0] _GEN_106 = _T_11 ? _GEN_90 : state; // @[Conditional.scala 39:67 CheckSplit.scala 90:50]
  wire [63:0] _GEN_107 = _T_8 ? _GEN_43 : _GEN_91; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_108 = _T_8 ? _GEN_44 : _GEN_92; // @[Conditional.scala 39:67]
  wire  _GEN_109 = _T_8 ? io_out_ready : _GEN_93; // @[Conditional.scala 39:67]
  wire  _GEN_110 = _T_8 ? _GEN_46 : _GEN_94; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_111 = _T_8 ? _GEN_47 : _GEN_95; // @[Conditional.scala 39:67]
  wire [15:0] _GEN_112 = _T_8 ? _GEN_48 : _GEN_96; // @[Conditional.scala 39:67]
  wire [7:0] _GEN_113 = _T_8 ? _GEN_49 : _GEN_97; // @[Conditional.scala 39:67]
  wire  _GEN_114 = _T_8 ? _GEN_50 : _GEN_98; // @[Conditional.scala 39:67]
  wire [10:0] _GEN_115 = _T_8 ? _GEN_51 : _GEN_99; // @[Conditional.scala 39:67]
  wire  _GEN_116 = _T_8 ? _GEN_52 : _GEN_100; // @[Conditional.scala 39:67]
  wire  _GEN_117 = _T_8 ? _GEN_53 : _GEN_101; // @[Conditional.scala 39:67]
  wire  _GEN_118 = _T_8 ? _GEN_54 : _GEN_102; // @[Conditional.scala 39:67]
  wire  _GEN_119 = _T_8 ? _GEN_55 : _GEN_103; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_120 = _T_8 ? _GEN_56 : _GEN_104; // @[Conditional.scala 39:67]
  wire [63:0] _GEN_121 = _T_8 ? _GEN_57 : _GEN_105; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_122 = _T_8 ? _GEN_58 : _GEN_106; // @[Conditional.scala 39:67]
  wire  _GEN_128 = _T_6 ? 1'h0 : _GEN_109; // @[Conditional.scala 39:67 CheckSplit.scala 94:57]
  wire  _GEN_129 = _T_6 ? 1'h0 : _GEN_110; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [2:0] _GEN_130 = _T_6 ? 3'h0 : _GEN_111; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [15:0] _GEN_131 = _T_6 ? 16'h0 : _GEN_112; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [7:0] _GEN_132 = _T_6 ? 8'h0 : _GEN_113; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_133 = _T_6 ? 1'h0 : _GEN_114; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [10:0] _GEN_134 = _T_6 ? 11'h0 : _GEN_115; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_135 = _T_6 ? 1'h0 : _GEN_116; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_136 = _T_6 ? 1'h0 : _GEN_117; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_137 = _T_6 ? 1'h0 : _GEN_118; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_138 = _T_6 ? 1'h0 : _GEN_119; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [31:0] _GEN_139 = _T_6 ? 32'h0 : _GEN_120; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [63:0] _GEN_140 = _T_6 ? 64'h0 : _GEN_121; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_146 = _T_2 ? 1'h0 : _GEN_128; // @[Conditional.scala 39:67 CheckSplit.scala 94:57]
  wire  _GEN_147 = _T_2 ? 1'h0 : _GEN_129; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [2:0] _GEN_148 = _T_2 ? 3'h0 : _GEN_130; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [15:0] _GEN_149 = _T_2 ? 16'h0 : _GEN_131; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [7:0] _GEN_150 = _T_2 ? 8'h0 : _GEN_132; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_151 = _T_2 ? 1'h0 : _GEN_133; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [10:0] _GEN_152 = _T_2 ? 11'h0 : _GEN_134; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_153 = _T_2 ? 1'h0 : _GEN_135; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_154 = _T_2 ? 1'h0 : _GEN_136; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_155 = _T_2 ? 1'h0 : _GEN_137; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire  _GEN_156 = _T_2 ? 1'h0 : _GEN_138; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [31:0] _GEN_157 = _T_2 ? 32'h0 : _GEN_139; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [63:0] _GEN_158 = _T_2 ? 64'h0 : _GEN_140; // @[Conditional.scala 39:67 CheckSplit.scala 95:65]
  wire [63:0] _GEN_173 = _T ? _GEN_14 : {{40'd0}, offset_addr}; // @[Conditional.scala 40:58 CheckSplit.scala 81:34]
  wire [63:0] _GEN_175 = _T ? _GEN_16 : {{40'd0}, new_length}; // @[Conditional.scala 40:58 CheckSplit.scala 82:33]
  assign io_in_ready = state == 3'h0; // @[CheckSplit.scala 92:75]
  assign io_out_valid = _T ? 1'h0 : _GEN_146; // @[Conditional.scala 40:58 CheckSplit.scala 94:57]
  assign io_out_bits_addr = _T ? 64'h0 : _GEN_158; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_len = _T ? 32'h0 : _GEN_157; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_eop = _T ? 1'h0 : _GEN_156; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_sop = _T ? 1'h0 : _GEN_155; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_mrkr_req = _T ? 1'h0 : _GEN_154; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_sdi = _T ? 1'h0 : _GEN_153; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_qid = _T ? 11'h0 : _GEN_152; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_error = _T ? 1'h0 : _GEN_151; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_func = _T ? 8'h0 : _GEN_150; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_cidx = _T ? 16'h0 : _GEN_149; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_port_id = _T ? 3'h0 : _GEN_148; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  assign io_out_bits_no_dma = _T ? 1'h0 : _GEN_147; // @[Conditional.scala 40:58 CheckSplit.scala 95:65]
  always @(posedge clock) begin
    if (reset) begin // @[CheckSplit.scala 81:34]
      offset_addr <= 24'h0; // @[CheckSplit.scala 81:34]
    end else begin
      offset_addr <= _GEN_173[23:0];
    end
    if (reset) begin // @[CheckSplit.scala 82:33]
      new_length <= 24'h0; // @[CheckSplit.scala 82:33]
    end else begin
      new_length <= _GEN_175[23:0];
    end
    if (reset) begin // @[CheckSplit.scala 83:31]
      cmd_addr <= 64'h0; // @[CheckSplit.scala 83:31]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_addr <= io_in_bits_addr; // @[CheckSplit.scala 100:73]
      end
    end else if (_T_2) begin // @[Conditional.scala 39:67]
      if (_T_4 > 32'h200000) begin // @[CheckSplit.scala 109:68]
        cmd_addr <= _cmd_addr_T_1; // @[CheckSplit.scala 112:73]
      end
    end else if (_T_6) begin // @[Conditional.scala 39:67]
      cmd_addr <= _GEN_24;
    end
    if (reset) begin // @[CheckSplit.scala 84:30]
      cmd_len <= 32'h0; // @[CheckSplit.scala 84:30]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_len <= io_in_bits_len; // @[CheckSplit.scala 101:73]
      end
    end else if (_T_2) begin // @[Conditional.scala 39:67]
      if (_T_4 > 32'h200000) begin // @[CheckSplit.scala 109:68]
        cmd_len <= _cmd_len_T_1; // @[CheckSplit.scala 113:73]
      end
    end else if (_T_6) begin // @[Conditional.scala 39:67]
      cmd_len <= _GEN_25;
    end
    if (reset) begin // @[CheckSplit.scala 85:32]
      mini_addr <= 64'h0; // @[CheckSplit.scala 85:32]
    end else if (!(_T)) begin // @[Conditional.scala 40:58]
      if (_T_2) begin // @[Conditional.scala 39:67]
        mini_addr <= cmd_addr;
      end else if (_T_6) begin // @[Conditional.scala 39:67]
        mini_addr <= cmd_addr;
      end else begin
        mini_addr <= _GEN_107;
      end
    end
    if (reset) begin // @[CheckSplit.scala 86:31]
      mini_len <= 32'h0; // @[CheckSplit.scala 86:31]
    end else if (!(_T)) begin // @[Conditional.scala 40:58]
      if (_T_2) begin // @[Conditional.scala 39:67]
        if (_T_4 > 32'h200000) begin // @[CheckSplit.scala 109:68]
          mini_len <= {{8'd0}, new_length}; // @[CheckSplit.scala 111:73]
        end else begin
          mini_len <= cmd_len; // @[CheckSplit.scala 117:73]
        end
      end else if (_T_6) begin // @[Conditional.scala 39:67]
        mini_len <= _GEN_23;
      end else begin
        mini_len <= _GEN_108;
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_eop <= io_in_bits_eop; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_sop <= io_in_bits_sop; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_mrkr_req <= io_in_bits_mrkr_req; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_sdi <= io_in_bits_sdi; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_qid <= io_in_bits_qid; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_error <= io_in_bits_error; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_func <= io_in_bits_func; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_cidx <= io_in_bits_cidx; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_port_id <= io_in_bits_port_id; // @[CheckSplit.scala 102:73]
      end
    end
    if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        cmd_temp_no_dma <= io_in_bits_no_dma; // @[CheckSplit.scala 102:73]
      end
    end
    if (reset) begin // @[CheckSplit.scala 90:50]
      state <= 3'h0; // @[CheckSplit.scala 90:50]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[CheckSplit.scala 99:43]
        state <= 3'h1; // @[CheckSplit.scala 104:41]
      end
    end else if (_T_2) begin // @[Conditional.scala 39:67]
      if (_T_4 > 32'h200000) begin // @[CheckSplit.scala 109:68]
        state <= 3'h3; // @[CheckSplit.scala 114:57]
      end else begin
        state <= 3'h4; // @[CheckSplit.scala 118:57]
      end
    end else if (_T_6) begin // @[Conditional.scala 39:67]
      state <= _GEN_26;
    end else begin
      state <= _GEN_122;
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
  offset_addr = _RAND_0[23:0];
  _RAND_1 = {1{`RANDOM}};
  new_length = _RAND_1[23:0];
  _RAND_2 = {2{`RANDOM}};
  cmd_addr = _RAND_2[63:0];
  _RAND_3 = {1{`RANDOM}};
  cmd_len = _RAND_3[31:0];
  _RAND_4 = {2{`RANDOM}};
  mini_addr = _RAND_4[63:0];
  _RAND_5 = {1{`RANDOM}};
  mini_len = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  cmd_temp_eop = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  cmd_temp_sop = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  cmd_temp_mrkr_req = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  cmd_temp_sdi = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  cmd_temp_qid = _RAND_10[10:0];
  _RAND_11 = {1{`RANDOM}};
  cmd_temp_error = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  cmd_temp_func = _RAND_12[7:0];
  _RAND_13 = {1{`RANDOM}};
  cmd_temp_cidx = _RAND_13[15:0];
  _RAND_14 = {1{`RANDOM}};
  cmd_temp_port_id = _RAND_14[2:0];
  _RAND_15 = {1{`RANDOM}};
  cmd_temp_no_dma = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  state = _RAND_16[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module XRam(
  input         clock,
  input         reset,
  input  [12:0] io_addr_a,
  input  [12:0] io_addr_b,
  input         io_wr_en_a,
  input  [63:0] io_data_in_a,
  output [63:0] io_data_out_a,
  output [63:0] io_data_out_b
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [63:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [63:0] _RAND_16;
  reg [63:0] _RAND_17;
`endif // RANDOMIZE_REG_INIT
  wire [63:0] ram_douta; // @[XRam.scala 136:33]
  wire [63:0] ram_doutb; // @[XRam.scala 136:33]
  wire [12:0] ram_addra; // @[XRam.scala 136:33]
  wire [12:0] ram_addrb; // @[XRam.scala 136:33]
  wire  ram_clka; // @[XRam.scala 136:33]
  wire  ram_clkb; // @[XRam.scala 136:33]
  wire [63:0] ram_dina; // @[XRam.scala 136:33]
  wire [63:0] ram_dinb; // @[XRam.scala 136:33]
  wire  ram_ena; // @[XRam.scala 136:33]
  wire  ram_enb; // @[XRam.scala 136:33]
  wire  ram_injectdbiterra; // @[XRam.scala 136:33]
  wire  ram_injectdbiterrb; // @[XRam.scala 136:33]
  wire  ram_injectsbiterra; // @[XRam.scala 136:33]
  wire  ram_injectsbiterrb; // @[XRam.scala 136:33]
  wire  ram_regcea; // @[XRam.scala 136:33]
  wire  ram_regceb; // @[XRam.scala 136:33]
  wire  ram_rsta; // @[XRam.scala 136:33]
  wire  ram_rstb; // @[XRam.scala 136:33]
  wire  ram_sleep; // @[XRam.scala 136:33]
  wire [7:0] ram_wea; // @[XRam.scala 136:33]
  wire [7:0] ram_web; // @[XRam.scala 136:33]
  wire [7:0] wr_en_a = io_wr_en_a ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  reg  usr_rst_delay_r; // @[Reg.scala 15:16]
  reg  usr_rst_delay_r_1; // @[Reg.scala 15:16]
  reg  usr_rst_delay_r_2; // @[Reg.scala 15:16]
  reg  usr_rst_delay; // @[Reg.scala 15:16]
  reg [12:0] reset_addr; // @[XRam.scala 141:54]
  wire [12:0] _reset_addr_T_1 = reset_addr + 13'h1; // @[XRam.scala 144:70]
  reg [12:0] r; // @[Reg.scala 15:16]
  reg [12:0] r_1; // @[Reg.scala 15:16]
  reg [12:0] REG; // @[XRam.scala 165:74]
  reg  REG_1; // @[XRam.scala 165:95]
  reg [63:0] io_data_out_b_REG; // @[XRam.scala 166:75]
  reg [12:0] r_2; // @[Reg.scala 15:16]
  reg [12:0] r_3; // @[Reg.scala 15:16]
  reg [12:0] r_4; // @[Reg.scala 15:16]
  reg [12:0] r_5; // @[Reg.scala 15:16]
  reg  r_6; // @[Reg.scala 15:16]
  reg  r_7; // @[Reg.scala 15:16]
  reg [63:0] io_data_out_b_r; // @[Reg.scala 15:16]
  reg [63:0] io_data_out_b_r_1; // @[Reg.scala 15:16]
  wire [63:0] _io_data_out_b_WIRE = ram_doutb; // @[XRam.scala 170:89 XRam.scala 170:89]
  wire [63:0] _GEN_15 = r_3 == r_5 & r_7 ? io_data_out_b_r_1 : _io_data_out_b_WIRE; // @[XRam.scala 167:130 XRam.scala 168:65 XRam.scala 170:65]
  xpm_memory_tdpram
    #(.USE_EMBEDDED_CONSTRAINT(0), .CLOCKING_MODE("common_clock"), .WRITE_DATA_WIDTH_B(64), .READ_LATENCY_B(2), .ADDR_WIDTH_A(13), .READ_DATA_WIDTH_A(64), .RST_MODE_B("SYNC"), .WAKEUP_TIME("disable_sleep"), .MEMORY_INIT_FILE("none"), .READ_LATENCY_A(2), .RST_MODE_A("SYNC"), .WRITE_DATA_WIDTH_A(64), .AUTO_SLEEP_TIME(0), .WRITE_MODE_A("no_change"), .MEMORY_PRIMITIVE("auto"), .USE_MEM_INIT(1), .MEMORY_INIT_PARAM(""), .SIM_ASSERT_CHK(0), .ECC_MODE("no_ecc"), .READ_RESET_VALUE_A("0"), .BYTE_WRITE_WIDTH_A(8), .MEMORY_OPTIMIZATION("true"), .MESSAGE_CONTROL(0), .WRITE_MODE_B("no_change"), .READ_DATA_WIDTH_B(64), .ADDR_WIDTH_B(13), .CASCADE_HEIGHT(0), .READ_RESET_VALUE_B("0"), .BYTE_WRITE_WIDTH_B(8), .MEMORY_SIZE(524288))
    ram ( // @[XRam.scala 136:33]
    .douta(ram_douta),
    .doutb(ram_doutb),
    .addra(ram_addra),
    .addrb(ram_addrb),
    .clka(ram_clka),
    .clkb(ram_clkb),
    .dina(ram_dina),
    .dinb(ram_dinb),
    .ena(ram_ena),
    .enb(ram_enb),
    .injectdbiterra(ram_injectdbiterra),
    .injectdbiterrb(ram_injectdbiterrb),
    .injectsbiterra(ram_injectsbiterra),
    .injectsbiterrb(ram_injectsbiterrb),
    .regcea(ram_regcea),
    .regceb(ram_regceb),
    .rsta(ram_rsta),
    .rstb(ram_rstb),
    .sleep(ram_sleep),
    .wea(ram_wea),
    .web(ram_web)
  );
  assign io_data_out_a = ram_douta; // @[XRam.scala 175:73 XRam.scala 175:73]
  assign io_data_out_b = r_1 == REG & REG_1 ? io_data_out_b_REG : _GEN_15; // @[XRam.scala 165:108 XRam.scala 166:65]
  assign ram_addra = usr_rst_delay ? reset_addr : io_addr_a; // @[XRam.scala 178:55]
  assign ram_addrb = io_addr_b; // @[XRam.scala 179:49]
  assign ram_clka = clock; // @[XRam.scala 181:57]
  assign ram_clkb = clock; // @[XRam.scala 182:57]
  assign ram_dina = usr_rst_delay ? 64'h0 : io_data_in_a; // @[XRam.scala 184:63]
  assign ram_dinb = 64'h0; // @[XRam.scala 185:57]
  assign ram_ena = 1'h1; // @[XRam.scala 187:57]
  assign ram_enb = 1'h1; // @[XRam.scala 188:57]
  assign ram_injectdbiterra = 1'h0; // @[XRam.scala 190:41]
  assign ram_injectdbiterrb = 1'h0; // @[XRam.scala 191:41]
  assign ram_injectsbiterra = 1'h0; // @[XRam.scala 193:41]
  assign ram_injectsbiterrb = 1'h0; // @[XRam.scala 194:41]
  assign ram_regcea = 1'h1; // @[XRam.scala 196:49]
  assign ram_regceb = 1'h1; // @[XRam.scala 197:49]
  assign ram_rsta = 1'h0; // @[XRam.scala 199:57]
  assign ram_rstb = 1'h0; // @[XRam.scala 200:57]
  assign ram_sleep = 1'h0; // @[XRam.scala 202:49]
  assign ram_wea = usr_rst_delay ? 8'hff : wr_en_a; // @[XRam.scala 206:63]
  assign ram_web = 8'h0; // @[XRam.scala 208:57]
  always @(posedge clock) begin
    usr_rst_delay_r <= reset; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    usr_rst_delay_r_1 <= usr_rst_delay_r; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    usr_rst_delay_r_2 <= usr_rst_delay_r_1; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    usr_rst_delay <= usr_rst_delay_r_2; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    if (usr_rst_delay) begin // @[XRam.scala 143:45]
      reset_addr <= _reset_addr_T_1; // @[XRam.scala 144:57]
    end else begin
      reset_addr <= 13'h0; // @[XRam.scala 146:57]
    end
    r <= io_addr_b; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_1 <= r; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    REG <= io_addr_a; // @[XRam.scala 165:74]
    REG_1 <= io_wr_en_a; // @[XRam.scala 165:95]
    io_data_out_b_REG <= io_data_in_a; // @[XRam.scala 166:75]
    r_2 <= io_addr_b; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_3 <= r_2; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_4 <= io_addr_a; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_5 <= r_4; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_6 <= io_wr_en_a; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_7 <= r_6; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    io_data_out_b_r <= io_data_in_a; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    io_data_out_b_r_1 <= io_data_out_b_r; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
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
  usr_rst_delay_r = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  usr_rst_delay_r_1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  usr_rst_delay_r_2 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  usr_rst_delay = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  reset_addr = _RAND_4[12:0];
  _RAND_5 = {1{`RANDOM}};
  r = _RAND_5[12:0];
  _RAND_6 = {1{`RANDOM}};
  r_1 = _RAND_6[12:0];
  _RAND_7 = {1{`RANDOM}};
  REG = _RAND_7[12:0];
  _RAND_8 = {1{`RANDOM}};
  REG_1 = _RAND_8[0:0];
  _RAND_9 = {2{`RANDOM}};
  io_data_out_b_REG = _RAND_9[63:0];
  _RAND_10 = {1{`RANDOM}};
  r_2 = _RAND_10[12:0];
  _RAND_11 = {1{`RANDOM}};
  r_3 = _RAND_11[12:0];
  _RAND_12 = {1{`RANDOM}};
  r_4 = _RAND_12[12:0];
  _RAND_13 = {1{`RANDOM}};
  r_5 = _RAND_13[12:0];
  _RAND_14 = {1{`RANDOM}};
  r_6 = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  r_7 = _RAND_15[0:0];
  _RAND_16 = {2{`RANDOM}};
  io_data_out_b_r = _RAND_16[63:0];
  _RAND_17 = {2{`RANDOM}};
  io_data_out_b_r_1 = _RAND_17[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Queue(
  input         clock,
  input         reset,
  output        io_enq_ready,
  input         io_enq_valid,
  input  [63:0] io_enq_bits_addr,
  input  [31:0] io_enq_bits_len,
  input         io_enq_bits_eop,
  input         io_enq_bits_sop,
  input         io_enq_bits_mrkr_req,
  input         io_enq_bits_sdi,
  input  [10:0] io_enq_bits_qid,
  input         io_enq_bits_error,
  input  [7:0]  io_enq_bits_func,
  input  [15:0] io_enq_bits_cidx,
  input  [2:0]  io_enq_bits_port_id,
  input         io_enq_bits_no_dma,
  input         io_deq_ready,
  output        io_deq_valid,
  output [63:0] io_deq_bits_addr,
  output [31:0] io_deq_bits_len,
  output        io_deq_bits_eop,
  output        io_deq_bits_sop,
  output        io_deq_bits_mrkr_req,
  output        io_deq_bits_sdi,
  output [10:0] io_deq_bits_qid,
  output        io_deq_bits_error,
  output [7:0]  io_deq_bits_func,
  output [15:0] io_deq_bits_cidx,
  output [2:0]  io_deq_bits_port_id,
  output        io_deq_bits_no_dma,
  output [3:0]  io_count
);
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_23;
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  reg [63:0] _RAND_0;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_22;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] ram_addr [0:9]; // @[Decoupled.scala 218:16]
  wire [63:0] ram_addr_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_addr_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [63:0] ram_addr_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_addr_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_addr_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_addr_MPORT_en; // @[Decoupled.scala 218:16]
  reg [31:0] ram_len [0:9]; // @[Decoupled.scala 218:16]
  wire [31:0] ram_len_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_len_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [31:0] ram_len_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_len_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_len_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_len_MPORT_en; // @[Decoupled.scala 218:16]
  reg  ram_eop [0:9]; // @[Decoupled.scala 218:16]
  wire  ram_eop_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_eop_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_eop_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_eop_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_eop_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_eop_MPORT_en; // @[Decoupled.scala 218:16]
  reg  ram_sop [0:9]; // @[Decoupled.scala 218:16]
  wire  ram_sop_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_sop_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_sop_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_sop_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_sop_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_sop_MPORT_en; // @[Decoupled.scala 218:16]
  reg  ram_mrkr_req [0:9]; // @[Decoupled.scala 218:16]
  wire  ram_mrkr_req_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_mrkr_req_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_mrkr_req_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_mrkr_req_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_mrkr_req_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_mrkr_req_MPORT_en; // @[Decoupled.scala 218:16]
  reg  ram_sdi [0:9]; // @[Decoupled.scala 218:16]
  wire  ram_sdi_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_sdi_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_sdi_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_sdi_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_sdi_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_sdi_MPORT_en; // @[Decoupled.scala 218:16]
  reg [10:0] ram_qid [0:9]; // @[Decoupled.scala 218:16]
  wire [10:0] ram_qid_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_qid_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [10:0] ram_qid_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_qid_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_qid_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_qid_MPORT_en; // @[Decoupled.scala 218:16]
  reg  ram_error [0:9]; // @[Decoupled.scala 218:16]
  wire  ram_error_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_error_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_error_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_error_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_error_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_error_MPORT_en; // @[Decoupled.scala 218:16]
  reg [7:0] ram_func [0:9]; // @[Decoupled.scala 218:16]
  wire [7:0] ram_func_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_func_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [7:0] ram_func_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_func_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_func_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_func_MPORT_en; // @[Decoupled.scala 218:16]
  reg [15:0] ram_cidx [0:9]; // @[Decoupled.scala 218:16]
  wire [15:0] ram_cidx_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_cidx_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [15:0] ram_cidx_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_cidx_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_cidx_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_cidx_MPORT_en; // @[Decoupled.scala 218:16]
  reg [2:0] ram_port_id [0:9]; // @[Decoupled.scala 218:16]
  wire [2:0] ram_port_id_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_port_id_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [2:0] ram_port_id_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_port_id_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_port_id_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_port_id_MPORT_en; // @[Decoupled.scala 218:16]
  reg  ram_no_dma [0:9]; // @[Decoupled.scala 218:16]
  wire  ram_no_dma_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_no_dma_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_no_dma_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_no_dma_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_no_dma_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_no_dma_MPORT_en; // @[Decoupled.scala 218:16]
  reg [3:0] enq_ptr_value; // @[Counter.scala 60:40]
  reg [3:0] deq_ptr_value; // @[Counter.scala 60:40]
  reg  maybe_full; // @[Decoupled.scala 221:27]
  wire  ptr_match = enq_ptr_value == deq_ptr_value; // @[Decoupled.scala 223:33]
  wire  empty = ptr_match & ~maybe_full; // @[Decoupled.scala 224:25]
  wire  full = ptr_match & maybe_full; // @[Decoupled.scala 225:24]
  wire  do_enq = io_enq_ready & io_enq_valid; // @[Decoupled.scala 40:37]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[Decoupled.scala 40:37]
  wire  wrap = enq_ptr_value == 4'h9; // @[Counter.scala 72:24]
  wire [3:0] _value_T_1 = enq_ptr_value + 4'h1; // @[Counter.scala 76:24]
  wire  wrap_1 = deq_ptr_value == 4'h9; // @[Counter.scala 72:24]
  wire [3:0] _value_T_3 = deq_ptr_value + 4'h1; // @[Counter.scala 76:24]
  wire [3:0] ptr_diff = enq_ptr_value - deq_ptr_value; // @[Decoupled.scala 257:32]
  wire [3:0] _io_count_T = maybe_full ? 4'ha : 4'h0; // @[Decoupled.scala 262:24]
  wire [3:0] _io_count_T_3 = 4'ha + ptr_diff; // @[Decoupled.scala 265:38]
  wire [3:0] _io_count_T_4 = deq_ptr_value > enq_ptr_value ? _io_count_T_3 : ptr_diff; // @[Decoupled.scala 264:24]
  assign ram_addr_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_addr_io_deq_bits_MPORT_data = ram_addr[ram_addr_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_addr_io_deq_bits_MPORT_data = ram_addr_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_1[63:0] :
    ram_addr[ram_addr_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_addr_MPORT_data = io_enq_bits_addr;
  assign ram_addr_MPORT_addr = enq_ptr_value;
  assign ram_addr_MPORT_mask = 1'h1;
  assign ram_addr_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_len_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_len_io_deq_bits_MPORT_data = ram_len[ram_len_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_len_io_deq_bits_MPORT_data = ram_len_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_3[31:0] :
    ram_len[ram_len_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_len_MPORT_data = io_enq_bits_len;
  assign ram_len_MPORT_addr = enq_ptr_value;
  assign ram_len_MPORT_mask = 1'h1;
  assign ram_len_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_eop_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_eop_io_deq_bits_MPORT_data = ram_eop[ram_eop_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_eop_io_deq_bits_MPORT_data = ram_eop_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_5[0:0] :
    ram_eop[ram_eop_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_eop_MPORT_data = io_enq_bits_eop;
  assign ram_eop_MPORT_addr = enq_ptr_value;
  assign ram_eop_MPORT_mask = 1'h1;
  assign ram_eop_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_sop_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_sop_io_deq_bits_MPORT_data = ram_sop[ram_sop_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_sop_io_deq_bits_MPORT_data = ram_sop_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_7[0:0] :
    ram_sop[ram_sop_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_sop_MPORT_data = io_enq_bits_sop;
  assign ram_sop_MPORT_addr = enq_ptr_value;
  assign ram_sop_MPORT_mask = 1'h1;
  assign ram_sop_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_mrkr_req_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_mrkr_req_io_deq_bits_MPORT_data = ram_mrkr_req[ram_mrkr_req_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_mrkr_req_io_deq_bits_MPORT_data = ram_mrkr_req_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_9[0:0] :
    ram_mrkr_req[ram_mrkr_req_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_mrkr_req_MPORT_data = io_enq_bits_mrkr_req;
  assign ram_mrkr_req_MPORT_addr = enq_ptr_value;
  assign ram_mrkr_req_MPORT_mask = 1'h1;
  assign ram_mrkr_req_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_sdi_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_sdi_io_deq_bits_MPORT_data = ram_sdi[ram_sdi_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_sdi_io_deq_bits_MPORT_data = ram_sdi_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_11[0:0] :
    ram_sdi[ram_sdi_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_sdi_MPORT_data = io_enq_bits_sdi;
  assign ram_sdi_MPORT_addr = enq_ptr_value;
  assign ram_sdi_MPORT_mask = 1'h1;
  assign ram_sdi_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_qid_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_qid_io_deq_bits_MPORT_data = ram_qid[ram_qid_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_qid_io_deq_bits_MPORT_data = ram_qid_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_13[10:0] :
    ram_qid[ram_qid_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_qid_MPORT_data = io_enq_bits_qid;
  assign ram_qid_MPORT_addr = enq_ptr_value;
  assign ram_qid_MPORT_mask = 1'h1;
  assign ram_qid_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_error_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_error_io_deq_bits_MPORT_data = ram_error[ram_error_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_error_io_deq_bits_MPORT_data = ram_error_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_15[0:0] :
    ram_error[ram_error_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_error_MPORT_data = io_enq_bits_error;
  assign ram_error_MPORT_addr = enq_ptr_value;
  assign ram_error_MPORT_mask = 1'h1;
  assign ram_error_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_func_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_func_io_deq_bits_MPORT_data = ram_func[ram_func_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_func_io_deq_bits_MPORT_data = ram_func_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_17[7:0] :
    ram_func[ram_func_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_func_MPORT_data = io_enq_bits_func;
  assign ram_func_MPORT_addr = enq_ptr_value;
  assign ram_func_MPORT_mask = 1'h1;
  assign ram_func_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_cidx_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_cidx_io_deq_bits_MPORT_data = ram_cidx[ram_cidx_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_cidx_io_deq_bits_MPORT_data = ram_cidx_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_19[15:0] :
    ram_cidx[ram_cidx_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_cidx_MPORT_data = io_enq_bits_cidx;
  assign ram_cidx_MPORT_addr = enq_ptr_value;
  assign ram_cidx_MPORT_mask = 1'h1;
  assign ram_cidx_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_port_id_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_port_id_io_deq_bits_MPORT_data = ram_port_id[ram_port_id_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_port_id_io_deq_bits_MPORT_data = ram_port_id_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_21[2:0] :
    ram_port_id[ram_port_id_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_port_id_MPORT_data = io_enq_bits_port_id;
  assign ram_port_id_MPORT_addr = enq_ptr_value;
  assign ram_port_id_MPORT_mask = 1'h1;
  assign ram_port_id_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_no_dma_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_no_dma_io_deq_bits_MPORT_data = ram_no_dma[ram_no_dma_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_no_dma_io_deq_bits_MPORT_data = ram_no_dma_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_23[0:0] :
    ram_no_dma[ram_no_dma_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_no_dma_MPORT_data = io_enq_bits_no_dma;
  assign ram_no_dma_MPORT_addr = enq_ptr_value;
  assign ram_no_dma_MPORT_mask = 1'h1;
  assign ram_no_dma_MPORT_en = io_enq_ready & io_enq_valid;
  assign io_enq_ready = ~full; // @[Decoupled.scala 241:19]
  assign io_deq_valid = ~empty; // @[Decoupled.scala 240:19]
  assign io_deq_bits_addr = ram_addr_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_len = ram_len_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_eop = ram_eop_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_sop = ram_sop_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_mrkr_req = ram_mrkr_req_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_sdi = ram_sdi_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_qid = ram_qid_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_error = ram_error_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_func = ram_func_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_cidx = ram_cidx_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_port_id = ram_port_id_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_no_dma = ram_no_dma_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_count = ptr_match ? _io_count_T : _io_count_T_4; // @[Decoupled.scala 261:20]
  always @(posedge clock) begin
    if(ram_addr_MPORT_en & ram_addr_MPORT_mask) begin
      ram_addr[ram_addr_MPORT_addr] <= ram_addr_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_len_MPORT_en & ram_len_MPORT_mask) begin
      ram_len[ram_len_MPORT_addr] <= ram_len_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_eop_MPORT_en & ram_eop_MPORT_mask) begin
      ram_eop[ram_eop_MPORT_addr] <= ram_eop_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_sop_MPORT_en & ram_sop_MPORT_mask) begin
      ram_sop[ram_sop_MPORT_addr] <= ram_sop_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_mrkr_req_MPORT_en & ram_mrkr_req_MPORT_mask) begin
      ram_mrkr_req[ram_mrkr_req_MPORT_addr] <= ram_mrkr_req_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_sdi_MPORT_en & ram_sdi_MPORT_mask) begin
      ram_sdi[ram_sdi_MPORT_addr] <= ram_sdi_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_qid_MPORT_en & ram_qid_MPORT_mask) begin
      ram_qid[ram_qid_MPORT_addr] <= ram_qid_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_error_MPORT_en & ram_error_MPORT_mask) begin
      ram_error[ram_error_MPORT_addr] <= ram_error_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_func_MPORT_en & ram_func_MPORT_mask) begin
      ram_func[ram_func_MPORT_addr] <= ram_func_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_cidx_MPORT_en & ram_cidx_MPORT_mask) begin
      ram_cidx[ram_cidx_MPORT_addr] <= ram_cidx_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_port_id_MPORT_en & ram_port_id_MPORT_mask) begin
      ram_port_id[ram_port_id_MPORT_addr] <= ram_port_id_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_no_dma_MPORT_en & ram_no_dma_MPORT_mask) begin
      ram_no_dma[ram_no_dma_MPORT_addr] <= ram_no_dma_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if (reset) begin // @[Counter.scala 60:40]
      enq_ptr_value <= 4'h0; // @[Counter.scala 60:40]
    end else if (do_enq) begin // @[Decoupled.scala 229:17]
      if (wrap) begin // @[Counter.scala 86:20]
        enq_ptr_value <= 4'h0; // @[Counter.scala 86:28]
      end else begin
        enq_ptr_value <= _value_T_1; // @[Counter.scala 76:15]
      end
    end
    if (reset) begin // @[Counter.scala 60:40]
      deq_ptr_value <= 4'h0; // @[Counter.scala 60:40]
    end else if (do_deq) begin // @[Decoupled.scala 233:17]
      if (wrap_1) begin // @[Counter.scala 86:20]
        deq_ptr_value <= 4'h0; // @[Counter.scala 86:28]
      end else begin
        deq_ptr_value <= _value_T_3; // @[Counter.scala 76:15]
      end
    end
    if (reset) begin // @[Decoupled.scala 221:27]
      maybe_full <= 1'h0; // @[Decoupled.scala 221:27]
    end else if (do_enq != do_deq) begin // @[Decoupled.scala 236:28]
      maybe_full <= do_enq; // @[Decoupled.scala 237:16]
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
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  _RAND_1 = {2{`RANDOM}};
  _RAND_3 = {1{`RANDOM}};
  _RAND_5 = {1{`RANDOM}};
  _RAND_7 = {1{`RANDOM}};
  _RAND_9 = {1{`RANDOM}};
  _RAND_11 = {1{`RANDOM}};
  _RAND_13 = {1{`RANDOM}};
  _RAND_15 = {1{`RANDOM}};
  _RAND_17 = {1{`RANDOM}};
  _RAND_19 = {1{`RANDOM}};
  _RAND_21 = {1{`RANDOM}};
  _RAND_23 = {1{`RANDOM}};
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {2{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_addr[initvar] = _RAND_0[63:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_len[initvar] = _RAND_2[31:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_eop[initvar] = _RAND_4[0:0];
  _RAND_6 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_sop[initvar] = _RAND_6[0:0];
  _RAND_8 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_mrkr_req[initvar] = _RAND_8[0:0];
  _RAND_10 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_sdi[initvar] = _RAND_10[0:0];
  _RAND_12 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_qid[initvar] = _RAND_12[10:0];
  _RAND_14 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_error[initvar] = _RAND_14[0:0];
  _RAND_16 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_func[initvar] = _RAND_16[7:0];
  _RAND_18 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_cidx[initvar] = _RAND_18[15:0];
  _RAND_20 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_port_id[initvar] = _RAND_20[2:0];
  _RAND_22 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_no_dma[initvar] = _RAND_22[0:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {1{`RANDOM}};
  enq_ptr_value = _RAND_24[3:0];
  _RAND_25 = {1{`RANDOM}};
  deq_ptr_value = _RAND_25[3:0];
  _RAND_26 = {1{`RANDOM}};
  maybe_full = _RAND_26[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Queue_1(
  input         clock,
  input         reset,
  output        io_enq_ready,
  input         io_enq_valid,
  input  [63:0] io_enq_bits_addr,
  input  [10:0] io_enq_bits_qid,
  input         io_enq_bits_error,
  input  [7:0]  io_enq_bits_func,
  input  [2:0]  io_enq_bits_port_id,
  input  [6:0]  io_enq_bits_pfch_tag,
  input  [31:0] io_enq_bits_len,
  input         io_deq_ready,
  output        io_deq_valid,
  output [63:0] io_deq_bits_addr,
  output [10:0] io_deq_bits_qid,
  output        io_deq_bits_error,
  output [7:0]  io_deq_bits_func,
  output [2:0]  io_deq_bits_port_id,
  output [6:0]  io_deq_bits_pfch_tag,
  output [31:0] io_deq_bits_len,
  output [3:0]  io_count
);
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_13;
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  reg [63:0] _RAND_0;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_12;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] ram_addr [0:9]; // @[Decoupled.scala 218:16]
  wire [63:0] ram_addr_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_addr_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [63:0] ram_addr_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_addr_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_addr_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_addr_MPORT_en; // @[Decoupled.scala 218:16]
  reg [10:0] ram_qid [0:9]; // @[Decoupled.scala 218:16]
  wire [10:0] ram_qid_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_qid_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [10:0] ram_qid_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_qid_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_qid_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_qid_MPORT_en; // @[Decoupled.scala 218:16]
  reg  ram_error [0:9]; // @[Decoupled.scala 218:16]
  wire  ram_error_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_error_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_error_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_error_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_error_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_error_MPORT_en; // @[Decoupled.scala 218:16]
  reg [7:0] ram_func [0:9]; // @[Decoupled.scala 218:16]
  wire [7:0] ram_func_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_func_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [7:0] ram_func_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_func_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_func_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_func_MPORT_en; // @[Decoupled.scala 218:16]
  reg [2:0] ram_port_id [0:9]; // @[Decoupled.scala 218:16]
  wire [2:0] ram_port_id_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_port_id_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [2:0] ram_port_id_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_port_id_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_port_id_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_port_id_MPORT_en; // @[Decoupled.scala 218:16]
  reg [6:0] ram_pfch_tag [0:9]; // @[Decoupled.scala 218:16]
  wire [6:0] ram_pfch_tag_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_pfch_tag_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [6:0] ram_pfch_tag_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_pfch_tag_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_pfch_tag_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_pfch_tag_MPORT_en; // @[Decoupled.scala 218:16]
  reg [31:0] ram_len [0:9]; // @[Decoupled.scala 218:16]
  wire [31:0] ram_len_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_len_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [31:0] ram_len_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_len_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_len_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_len_MPORT_en; // @[Decoupled.scala 218:16]
  reg [3:0] enq_ptr_value; // @[Counter.scala 60:40]
  reg [3:0] deq_ptr_value; // @[Counter.scala 60:40]
  reg  maybe_full; // @[Decoupled.scala 221:27]
  wire  ptr_match = enq_ptr_value == deq_ptr_value; // @[Decoupled.scala 223:33]
  wire  empty = ptr_match & ~maybe_full; // @[Decoupled.scala 224:25]
  wire  full = ptr_match & maybe_full; // @[Decoupled.scala 225:24]
  wire  do_enq = io_enq_ready & io_enq_valid; // @[Decoupled.scala 40:37]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[Decoupled.scala 40:37]
  wire  wrap = enq_ptr_value == 4'h9; // @[Counter.scala 72:24]
  wire [3:0] _value_T_1 = enq_ptr_value + 4'h1; // @[Counter.scala 76:24]
  wire  wrap_1 = deq_ptr_value == 4'h9; // @[Counter.scala 72:24]
  wire [3:0] _value_T_3 = deq_ptr_value + 4'h1; // @[Counter.scala 76:24]
  wire [3:0] ptr_diff = enq_ptr_value - deq_ptr_value; // @[Decoupled.scala 257:32]
  wire [3:0] _io_count_T = maybe_full ? 4'ha : 4'h0; // @[Decoupled.scala 262:24]
  wire [3:0] _io_count_T_3 = 4'ha + ptr_diff; // @[Decoupled.scala 265:38]
  wire [3:0] _io_count_T_4 = deq_ptr_value > enq_ptr_value ? _io_count_T_3 : ptr_diff; // @[Decoupled.scala 264:24]
  assign ram_addr_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_addr_io_deq_bits_MPORT_data = ram_addr[ram_addr_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_addr_io_deq_bits_MPORT_data = ram_addr_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_1[63:0] :
    ram_addr[ram_addr_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_addr_MPORT_data = io_enq_bits_addr;
  assign ram_addr_MPORT_addr = enq_ptr_value;
  assign ram_addr_MPORT_mask = 1'h1;
  assign ram_addr_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_qid_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_qid_io_deq_bits_MPORT_data = ram_qid[ram_qid_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_qid_io_deq_bits_MPORT_data = ram_qid_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_3[10:0] :
    ram_qid[ram_qid_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_qid_MPORT_data = io_enq_bits_qid;
  assign ram_qid_MPORT_addr = enq_ptr_value;
  assign ram_qid_MPORT_mask = 1'h1;
  assign ram_qid_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_error_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_error_io_deq_bits_MPORT_data = ram_error[ram_error_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_error_io_deq_bits_MPORT_data = ram_error_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_5[0:0] :
    ram_error[ram_error_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_error_MPORT_data = io_enq_bits_error;
  assign ram_error_MPORT_addr = enq_ptr_value;
  assign ram_error_MPORT_mask = 1'h1;
  assign ram_error_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_func_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_func_io_deq_bits_MPORT_data = ram_func[ram_func_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_func_io_deq_bits_MPORT_data = ram_func_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_7[7:0] :
    ram_func[ram_func_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_func_MPORT_data = io_enq_bits_func;
  assign ram_func_MPORT_addr = enq_ptr_value;
  assign ram_func_MPORT_mask = 1'h1;
  assign ram_func_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_port_id_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_port_id_io_deq_bits_MPORT_data = ram_port_id[ram_port_id_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_port_id_io_deq_bits_MPORT_data = ram_port_id_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_9[2:0] :
    ram_port_id[ram_port_id_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_port_id_MPORT_data = io_enq_bits_port_id;
  assign ram_port_id_MPORT_addr = enq_ptr_value;
  assign ram_port_id_MPORT_mask = 1'h1;
  assign ram_port_id_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_pfch_tag_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_pfch_tag_io_deq_bits_MPORT_data = ram_pfch_tag[ram_pfch_tag_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_pfch_tag_io_deq_bits_MPORT_data = ram_pfch_tag_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_11[6:0] :
    ram_pfch_tag[ram_pfch_tag_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_pfch_tag_MPORT_data = io_enq_bits_pfch_tag;
  assign ram_pfch_tag_MPORT_addr = enq_ptr_value;
  assign ram_pfch_tag_MPORT_mask = 1'h1;
  assign ram_pfch_tag_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_len_io_deq_bits_MPORT_addr = deq_ptr_value;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_len_io_deq_bits_MPORT_data = ram_len[ram_len_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `else
  assign ram_len_io_deq_bits_MPORT_data = ram_len_io_deq_bits_MPORT_addr >= 4'ha ? _RAND_13[31:0] :
    ram_len[ram_len_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_len_MPORT_data = io_enq_bits_len;
  assign ram_len_MPORT_addr = enq_ptr_value;
  assign ram_len_MPORT_mask = 1'h1;
  assign ram_len_MPORT_en = io_enq_ready & io_enq_valid;
  assign io_enq_ready = ~full; // @[Decoupled.scala 241:19]
  assign io_deq_valid = ~empty; // @[Decoupled.scala 240:19]
  assign io_deq_bits_addr = ram_addr_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_qid = ram_qid_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_error = ram_error_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_func = ram_func_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_port_id = ram_port_id_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_pfch_tag = ram_pfch_tag_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_len = ram_len_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_count = ptr_match ? _io_count_T : _io_count_T_4; // @[Decoupled.scala 261:20]
  always @(posedge clock) begin
    if(ram_addr_MPORT_en & ram_addr_MPORT_mask) begin
      ram_addr[ram_addr_MPORT_addr] <= ram_addr_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_qid_MPORT_en & ram_qid_MPORT_mask) begin
      ram_qid[ram_qid_MPORT_addr] <= ram_qid_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_error_MPORT_en & ram_error_MPORT_mask) begin
      ram_error[ram_error_MPORT_addr] <= ram_error_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_func_MPORT_en & ram_func_MPORT_mask) begin
      ram_func[ram_func_MPORT_addr] <= ram_func_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_port_id_MPORT_en & ram_port_id_MPORT_mask) begin
      ram_port_id[ram_port_id_MPORT_addr] <= ram_port_id_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_pfch_tag_MPORT_en & ram_pfch_tag_MPORT_mask) begin
      ram_pfch_tag[ram_pfch_tag_MPORT_addr] <= ram_pfch_tag_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_len_MPORT_en & ram_len_MPORT_mask) begin
      ram_len[ram_len_MPORT_addr] <= ram_len_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if (reset) begin // @[Counter.scala 60:40]
      enq_ptr_value <= 4'h0; // @[Counter.scala 60:40]
    end else if (do_enq) begin // @[Decoupled.scala 229:17]
      if (wrap) begin // @[Counter.scala 86:20]
        enq_ptr_value <= 4'h0; // @[Counter.scala 86:28]
      end else begin
        enq_ptr_value <= _value_T_1; // @[Counter.scala 76:15]
      end
    end
    if (reset) begin // @[Counter.scala 60:40]
      deq_ptr_value <= 4'h0; // @[Counter.scala 60:40]
    end else if (do_deq) begin // @[Decoupled.scala 233:17]
      if (wrap_1) begin // @[Counter.scala 86:20]
        deq_ptr_value <= 4'h0; // @[Counter.scala 86:28]
      end else begin
        deq_ptr_value <= _value_T_3; // @[Counter.scala 76:15]
      end
    end
    if (reset) begin // @[Decoupled.scala 221:27]
      maybe_full <= 1'h0; // @[Decoupled.scala 221:27]
    end else if (do_enq != do_deq) begin // @[Decoupled.scala 236:28]
      maybe_full <= do_enq; // @[Decoupled.scala 237:16]
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
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  _RAND_1 = {2{`RANDOM}};
  _RAND_3 = {1{`RANDOM}};
  _RAND_5 = {1{`RANDOM}};
  _RAND_7 = {1{`RANDOM}};
  _RAND_9 = {1{`RANDOM}};
  _RAND_11 = {1{`RANDOM}};
  _RAND_13 = {1{`RANDOM}};
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {2{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_addr[initvar] = _RAND_0[63:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_qid[initvar] = _RAND_2[10:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_error[initvar] = _RAND_4[0:0];
  _RAND_6 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_func[initvar] = _RAND_6[7:0];
  _RAND_8 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_port_id[initvar] = _RAND_8[2:0];
  _RAND_10 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_pfch_tag[initvar] = _RAND_10[6:0];
  _RAND_12 = {1{`RANDOM}};
  for (initvar = 0; initvar < 10; initvar = initvar+1)
    ram_len[initvar] = _RAND_12[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{`RANDOM}};
  enq_ptr_value = _RAND_14[3:0];
  _RAND_15 = {1{`RANDOM}};
  deq_ptr_value = _RAND_15[3:0];
  _RAND_16 = {1{`RANDOM}};
  maybe_full = _RAND_16[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module TLB(
  input         clock,
  input         reset,
  output        io__wr_tlb_ready,
  input         io__wr_tlb_valid,
  input  [31:0] io__wr_tlb_bits_vaddr_high,
  input  [31:0] io__wr_tlb_bits_vaddr_low,
  input  [31:0] io__wr_tlb_bits_paddr_high,
  input  [31:0] io__wr_tlb_bits_paddr_low,
  input         io__wr_tlb_bits_is_base,
  output        io__h2c_in_ready,
  input         io__h2c_in_valid,
  input  [63:0] io__h2c_in_bits_addr,
  input  [31:0] io__h2c_in_bits_len,
  input         io__h2c_in_bits_eop,
  input         io__h2c_in_bits_sop,
  input         io__h2c_in_bits_mrkr_req,
  input         io__h2c_in_bits_sdi,
  input  [10:0] io__h2c_in_bits_qid,
  input         io__h2c_in_bits_error,
  input  [7:0]  io__h2c_in_bits_func,
  input  [15:0] io__h2c_in_bits_cidx,
  input  [2:0]  io__h2c_in_bits_port_id,
  input         io__h2c_in_bits_no_dma,
  output        io__c2h_in_ready,
  input         io__c2h_in_valid,
  input  [63:0] io__c2h_in_bits_addr,
  input  [10:0] io__c2h_in_bits_qid,
  input         io__c2h_in_bits_error,
  input  [7:0]  io__c2h_in_bits_func,
  input  [2:0]  io__c2h_in_bits_port_id,
  input  [6:0]  io__c2h_in_bits_pfch_tag,
  input  [31:0] io__c2h_in_bits_len,
  input         io__h2c_out_ready,
  output        io__h2c_out_valid,
  output [63:0] io__h2c_out_bits_addr,
  output [31:0] io__h2c_out_bits_len,
  output        io__h2c_out_bits_eop,
  output        io__h2c_out_bits_sop,
  output        io__h2c_out_bits_mrkr_req,
  output        io__h2c_out_bits_sdi,
  output [10:0] io__h2c_out_bits_qid,
  output        io__h2c_out_bits_error,
  output [7:0]  io__h2c_out_bits_func,
  output [15:0] io__h2c_out_bits_cidx,
  output [2:0]  io__h2c_out_bits_port_id,
  output        io__h2c_out_bits_no_dma,
  input         io__c2h_out_ready,
  output        io__c2h_out_valid,
  output [63:0] io__c2h_out_bits_addr,
  output [10:0] io__c2h_out_bits_qid,
  output        io__c2h_out_bits_error,
  output [7:0]  io__c2h_out_bits_func,
  output [2:0]  io__c2h_out_bits_port_id,
  output [6:0]  io__c2h_out_bits_pfch_tag,
  output [31:0] io__c2h_out_bits_len,
  output [31:0] io__tlb_miss_count,
  output [31:0] io_tlb_miss_count
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
  reg [31:0] _RAND_47;
  reg [31:0] _RAND_48;
  reg [31:0] _RAND_49;
  reg [31:0] _RAND_50;
  reg [31:0] _RAND_51;
  reg [31:0] _RAND_52;
`endif // RANDOMIZE_REG_INIT
  wire  tlb_table_clock; // @[XRam.scala 102:23]
  wire  tlb_table_reset; // @[XRam.scala 102:23]
  wire [12:0] tlb_table_io_addr_a; // @[XRam.scala 102:23]
  wire [12:0] tlb_table_io_addr_b; // @[XRam.scala 102:23]
  wire  tlb_table_io_wr_en_a; // @[XRam.scala 102:23]
  wire [63:0] tlb_table_io_data_in_a; // @[XRam.scala 102:23]
  wire [63:0] tlb_table_io_data_out_a; // @[XRam.scala 102:23]
  wire [63:0] tlb_table_io_data_out_b; // @[XRam.scala 102:23]
  wire  q_h2c_clock; // @[TLB.scala 74:57]
  wire  q_h2c_reset; // @[TLB.scala 74:57]
  wire  q_h2c_io_enq_ready; // @[TLB.scala 74:57]
  wire  q_h2c_io_enq_valid; // @[TLB.scala 74:57]
  wire [63:0] q_h2c_io_enq_bits_addr; // @[TLB.scala 74:57]
  wire [31:0] q_h2c_io_enq_bits_len; // @[TLB.scala 74:57]
  wire  q_h2c_io_enq_bits_eop; // @[TLB.scala 74:57]
  wire  q_h2c_io_enq_bits_sop; // @[TLB.scala 74:57]
  wire  q_h2c_io_enq_bits_mrkr_req; // @[TLB.scala 74:57]
  wire  q_h2c_io_enq_bits_sdi; // @[TLB.scala 74:57]
  wire [10:0] q_h2c_io_enq_bits_qid; // @[TLB.scala 74:57]
  wire  q_h2c_io_enq_bits_error; // @[TLB.scala 74:57]
  wire [7:0] q_h2c_io_enq_bits_func; // @[TLB.scala 74:57]
  wire [15:0] q_h2c_io_enq_bits_cidx; // @[TLB.scala 74:57]
  wire [2:0] q_h2c_io_enq_bits_port_id; // @[TLB.scala 74:57]
  wire  q_h2c_io_enq_bits_no_dma; // @[TLB.scala 74:57]
  wire  q_h2c_io_deq_ready; // @[TLB.scala 74:57]
  wire  q_h2c_io_deq_valid; // @[TLB.scala 74:57]
  wire [63:0] q_h2c_io_deq_bits_addr; // @[TLB.scala 74:57]
  wire [31:0] q_h2c_io_deq_bits_len; // @[TLB.scala 74:57]
  wire  q_h2c_io_deq_bits_eop; // @[TLB.scala 74:57]
  wire  q_h2c_io_deq_bits_sop; // @[TLB.scala 74:57]
  wire  q_h2c_io_deq_bits_mrkr_req; // @[TLB.scala 74:57]
  wire  q_h2c_io_deq_bits_sdi; // @[TLB.scala 74:57]
  wire [10:0] q_h2c_io_deq_bits_qid; // @[TLB.scala 74:57]
  wire  q_h2c_io_deq_bits_error; // @[TLB.scala 74:57]
  wire [7:0] q_h2c_io_deq_bits_func; // @[TLB.scala 74:57]
  wire [15:0] q_h2c_io_deq_bits_cidx; // @[TLB.scala 74:57]
  wire [2:0] q_h2c_io_deq_bits_port_id; // @[TLB.scala 74:57]
  wire  q_h2c_io_deq_bits_no_dma; // @[TLB.scala 74:57]
  wire [3:0] q_h2c_io_count; // @[TLB.scala 74:57]
  wire  q_c2h_clock; // @[TLB.scala 75:57]
  wire  q_c2h_reset; // @[TLB.scala 75:57]
  wire  q_c2h_io_enq_ready; // @[TLB.scala 75:57]
  wire  q_c2h_io_enq_valid; // @[TLB.scala 75:57]
  wire [63:0] q_c2h_io_enq_bits_addr; // @[TLB.scala 75:57]
  wire [10:0] q_c2h_io_enq_bits_qid; // @[TLB.scala 75:57]
  wire  q_c2h_io_enq_bits_error; // @[TLB.scala 75:57]
  wire [7:0] q_c2h_io_enq_bits_func; // @[TLB.scala 75:57]
  wire [2:0] q_c2h_io_enq_bits_port_id; // @[TLB.scala 75:57]
  wire [6:0] q_c2h_io_enq_bits_pfch_tag; // @[TLB.scala 75:57]
  wire [31:0] q_c2h_io_enq_bits_len; // @[TLB.scala 75:57]
  wire  q_c2h_io_deq_ready; // @[TLB.scala 75:57]
  wire  q_c2h_io_deq_valid; // @[TLB.scala 75:57]
  wire [63:0] q_c2h_io_deq_bits_addr; // @[TLB.scala 75:57]
  wire [10:0] q_c2h_io_deq_bits_qid; // @[TLB.scala 75:57]
  wire  q_c2h_io_deq_bits_error; // @[TLB.scala 75:57]
  wire [7:0] q_c2h_io_deq_bits_func; // @[TLB.scala 75:57]
  wire [2:0] q_c2h_io_deq_bits_port_id; // @[TLB.scala 75:57]
  wire [6:0] q_c2h_io_deq_bits_pfch_tag; // @[TLB.scala 75:57]
  wire [31:0] q_c2h_io_deq_bits_len; // @[TLB.scala 75:57]
  wire [3:0] q_c2h_io_count; // @[TLB.scala 75:57]
  reg [42:0] base_page; // @[TLB.scala 37:50]
  reg [31:0] tlb_miss_count; // @[TLB.scala 38:50]
  reg [13:0] wrtlb_index; // @[TLB.scala 40:50]
  wire [42:0] h2c_page = io__h2c_in_bits_addr[63:21]; // @[TLB.scala 41:62]
  wire [42:0] h2c_index = h2c_page - base_page; // @[TLB.scala 42:52]
  wire [42:0] _GEN_12 = {{29'd0}, wrtlb_index}; // @[TLB.scala 43:90]
  wire [42:0] _h2c_outrange_T_2 = base_page + _GEN_12; // @[TLB.scala 43:90]
  wire  h2c_outrange = h2c_page < base_page | h2c_page >= _h2c_outrange_T_2; // @[TLB.scala 43:66]
  wire [42:0] c2h_page = io__c2h_in_bits_addr[63:21]; // @[TLB.scala 44:62]
  wire [42:0] c2h_index = c2h_page - base_page; // @[TLB.scala 45:52]
  wire  c2h_outrange = c2h_page < base_page | c2h_page >= _h2c_outrange_T_2; // @[TLB.scala 46:66]
  wire  _tlb_table_io_wr_en_a_T = io__wr_tlb_ready & io__wr_tlb_valid; // @[Decoupled.scala 40:37]
  wire [13:0] _wrtlb_index_T_1 = wrtlb_index + 14'h1; // @[TLB.scala 56:72]
  wire [63:0] _base_page_T = {io__wr_tlb_bits_vaddr_high,io__wr_tlb_bits_vaddr_low}; // @[Cat.scala 30:58]
  wire [13:0] _GEN_1 = io__wr_tlb_bits_is_base ? 14'h0 : wrtlb_index; // @[TLB.scala 57:51 TLB.scala 59:49 TLB.scala 55:49]
  wire [42:0] _GEN_4 = _tlb_table_io_wr_en_a_T ? {{29'd0}, _GEN_1} : h2c_index; // @[TLB.scala 54:31 TLB.scala 64:41]
  reg [31:0] h2c_bits_delay_REG_len; // @[TLB.scala 70:59]
  reg  h2c_bits_delay_REG_eop; // @[TLB.scala 70:59]
  reg  h2c_bits_delay_REG_sop; // @[TLB.scala 70:59]
  reg  h2c_bits_delay_REG_mrkr_req; // @[TLB.scala 70:59]
  reg  h2c_bits_delay_REG_sdi; // @[TLB.scala 70:59]
  reg [10:0] h2c_bits_delay_REG_qid; // @[TLB.scala 70:59]
  reg  h2c_bits_delay_REG_error; // @[TLB.scala 70:59]
  reg [7:0] h2c_bits_delay_REG_func; // @[TLB.scala 70:59]
  reg [15:0] h2c_bits_delay_REG_cidx; // @[TLB.scala 70:59]
  reg [2:0] h2c_bits_delay_REG_port_id; // @[TLB.scala 70:59]
  reg  h2c_bits_delay_REG_no_dma; // @[TLB.scala 70:59]
  reg [31:0] h2c_bits_delay_REG_1_len; // @[TLB.scala 70:51]
  reg  h2c_bits_delay_REG_1_eop; // @[TLB.scala 70:51]
  reg  h2c_bits_delay_REG_1_sop; // @[TLB.scala 70:51]
  reg  h2c_bits_delay_REG_1_mrkr_req; // @[TLB.scala 70:51]
  reg  h2c_bits_delay_REG_1_sdi; // @[TLB.scala 70:51]
  reg [10:0] h2c_bits_delay_REG_1_qid; // @[TLB.scala 70:51]
  reg  h2c_bits_delay_REG_1_error; // @[TLB.scala 70:51]
  reg [7:0] h2c_bits_delay_REG_1_func; // @[TLB.scala 70:51]
  reg [15:0] h2c_bits_delay_REG_1_cidx; // @[TLB.scala 70:51]
  reg [2:0] h2c_bits_delay_REG_1_port_id; // @[TLB.scala 70:51]
  reg  h2c_bits_delay_REG_1_no_dma; // @[TLB.scala 70:51]
  reg [10:0] c2h_bits_delay_REG_qid; // @[TLB.scala 71:59]
  reg  c2h_bits_delay_REG_error; // @[TLB.scala 71:59]
  reg [7:0] c2h_bits_delay_REG_func; // @[TLB.scala 71:59]
  reg [2:0] c2h_bits_delay_REG_port_id; // @[TLB.scala 71:59]
  reg [6:0] c2h_bits_delay_REG_pfch_tag; // @[TLB.scala 71:59]
  reg [31:0] c2h_bits_delay_REG_len; // @[TLB.scala 71:59]
  reg [10:0] c2h_bits_delay_REG_1_qid; // @[TLB.scala 71:51]
  reg  c2h_bits_delay_REG_1_error; // @[TLB.scala 71:51]
  reg [7:0] c2h_bits_delay_REG_1_func; // @[TLB.scala 71:51]
  reg [2:0] c2h_bits_delay_REG_1_port_id; // @[TLB.scala 71:51]
  reg [6:0] c2h_bits_delay_REG_1_pfch_tag; // @[TLB.scala 71:51]
  reg [31:0] c2h_bits_delay_REG_1_len; // @[TLB.scala 71:51]
  reg [20:0] h2c_bits_delay_addr_REG; // @[TLB.scala 72:77]
  reg [20:0] h2c_bits_delay_addr_REG_1; // @[TLB.scala 72:69]
  wire [63:0] _GEN_14 = {{43'd0}, h2c_bits_delay_addr_REG_1}; // @[TLB.scala 72:60]
  reg [20:0] c2h_bits_delay_addr_REG; // @[TLB.scala 73:77]
  reg [20:0] c2h_bits_delay_addr_REG_1; // @[TLB.scala 73:69]
  wire [63:0] _GEN_15 = {{43'd0}, c2h_bits_delay_addr_REG_1}; // @[TLB.scala 73:60]
  reg  REG; // @[TLB.scala 80:29]
  reg  REG_1; // @[TLB.scala 80:21]
  reg  REG_2; // @[TLB.scala 80:66]
  reg  REG_3; // @[TLB.scala 80:58]
  reg  REG_4; // @[TLB.scala 80:104]
  reg  REG_5; // @[TLB.scala 80:96]
  reg  REG_6; // @[TLB.scala 86:29]
  reg  REG_7; // @[TLB.scala 86:21]
  reg  REG_8; // @[TLB.scala 86:66]
  reg  REG_9; // @[TLB.scala 86:58]
  reg  REG_10; // @[TLB.scala 86:104]
  reg  REG_11; // @[TLB.scala 86:96]
  wire  h2c_miss = h2c_outrange & io__h2c_in_valid & io__h2c_in_ready; // @[TLB.scala 92:58]
  wire  c2h_miss = c2h_outrange & io__c2h_in_valid & io__c2h_in_ready; // @[TLB.scala 93:58]
  wire [31:0] _tlb_miss_count_T_1 = tlb_miss_count + 32'h1; // @[TLB.scala 95:50]
  wire [31:0] _tlb_miss_count_T_3 = tlb_miss_count + 32'h2; // @[TLB.scala 97:58]
  XRam tlb_table ( // @[XRam.scala 102:23]
    .clock(tlb_table_clock),
    .reset(tlb_table_reset),
    .io_addr_a(tlb_table_io_addr_a),
    .io_addr_b(tlb_table_io_addr_b),
    .io_wr_en_a(tlb_table_io_wr_en_a),
    .io_data_in_a(tlb_table_io_data_in_a),
    .io_data_out_a(tlb_table_io_data_out_a),
    .io_data_out_b(tlb_table_io_data_out_b)
  );
  Queue q_h2c ( // @[TLB.scala 74:57]
    .clock(q_h2c_clock),
    .reset(q_h2c_reset),
    .io_enq_ready(q_h2c_io_enq_ready),
    .io_enq_valid(q_h2c_io_enq_valid),
    .io_enq_bits_addr(q_h2c_io_enq_bits_addr),
    .io_enq_bits_len(q_h2c_io_enq_bits_len),
    .io_enq_bits_eop(q_h2c_io_enq_bits_eop),
    .io_enq_bits_sop(q_h2c_io_enq_bits_sop),
    .io_enq_bits_mrkr_req(q_h2c_io_enq_bits_mrkr_req),
    .io_enq_bits_sdi(q_h2c_io_enq_bits_sdi),
    .io_enq_bits_qid(q_h2c_io_enq_bits_qid),
    .io_enq_bits_error(q_h2c_io_enq_bits_error),
    .io_enq_bits_func(q_h2c_io_enq_bits_func),
    .io_enq_bits_cidx(q_h2c_io_enq_bits_cidx),
    .io_enq_bits_port_id(q_h2c_io_enq_bits_port_id),
    .io_enq_bits_no_dma(q_h2c_io_enq_bits_no_dma),
    .io_deq_ready(q_h2c_io_deq_ready),
    .io_deq_valid(q_h2c_io_deq_valid),
    .io_deq_bits_addr(q_h2c_io_deq_bits_addr),
    .io_deq_bits_len(q_h2c_io_deq_bits_len),
    .io_deq_bits_eop(q_h2c_io_deq_bits_eop),
    .io_deq_bits_sop(q_h2c_io_deq_bits_sop),
    .io_deq_bits_mrkr_req(q_h2c_io_deq_bits_mrkr_req),
    .io_deq_bits_sdi(q_h2c_io_deq_bits_sdi),
    .io_deq_bits_qid(q_h2c_io_deq_bits_qid),
    .io_deq_bits_error(q_h2c_io_deq_bits_error),
    .io_deq_bits_func(q_h2c_io_deq_bits_func),
    .io_deq_bits_cidx(q_h2c_io_deq_bits_cidx),
    .io_deq_bits_port_id(q_h2c_io_deq_bits_port_id),
    .io_deq_bits_no_dma(q_h2c_io_deq_bits_no_dma),
    .io_count(q_h2c_io_count)
  );
  Queue_1 q_c2h ( // @[TLB.scala 75:57]
    .clock(q_c2h_clock),
    .reset(q_c2h_reset),
    .io_enq_ready(q_c2h_io_enq_ready),
    .io_enq_valid(q_c2h_io_enq_valid),
    .io_enq_bits_addr(q_c2h_io_enq_bits_addr),
    .io_enq_bits_qid(q_c2h_io_enq_bits_qid),
    .io_enq_bits_error(q_c2h_io_enq_bits_error),
    .io_enq_bits_func(q_c2h_io_enq_bits_func),
    .io_enq_bits_port_id(q_c2h_io_enq_bits_port_id),
    .io_enq_bits_pfch_tag(q_c2h_io_enq_bits_pfch_tag),
    .io_enq_bits_len(q_c2h_io_enq_bits_len),
    .io_deq_ready(q_c2h_io_deq_ready),
    .io_deq_valid(q_c2h_io_deq_valid),
    .io_deq_bits_addr(q_c2h_io_deq_bits_addr),
    .io_deq_bits_qid(q_c2h_io_deq_bits_qid),
    .io_deq_bits_error(q_c2h_io_deq_bits_error),
    .io_deq_bits_func(q_c2h_io_deq_bits_func),
    .io_deq_bits_port_id(q_c2h_io_deq_bits_port_id),
    .io_deq_bits_pfch_tag(q_c2h_io_deq_bits_pfch_tag),
    .io_deq_bits_len(q_c2h_io_deq_bits_len),
    .io_count(q_c2h_io_count)
  );
  assign io__wr_tlb_ready = 1'h1; // @[TLB.scala 50:41]
  assign io__h2c_in_ready = q_h2c_io_count < 4'h8; // @[TLB.scala 77:58]
  assign io__c2h_in_ready = q_c2h_io_count < 4'h8; // @[TLB.scala 78:59]
  assign io__h2c_out_valid = q_h2c_io_deq_valid; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_addr = q_h2c_io_deq_bits_addr; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_len = q_h2c_io_deq_bits_len; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_eop = q_h2c_io_deq_bits_eop; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_sop = q_h2c_io_deq_bits_sop; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_mrkr_req = q_h2c_io_deq_bits_mrkr_req; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_sdi = q_h2c_io_deq_bits_sdi; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_qid = q_h2c_io_deq_bits_qid; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_error = q_h2c_io_deq_bits_error; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_func = q_h2c_io_deq_bits_func; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_cidx = q_h2c_io_deq_bits_cidx; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_port_id = q_h2c_io_deq_bits_port_id; // @[TLB.scala 102:41]
  assign io__h2c_out_bits_no_dma = q_h2c_io_deq_bits_no_dma; // @[TLB.scala 102:41]
  assign io__c2h_out_valid = q_c2h_io_deq_valid; // @[TLB.scala 105:41]
  assign io__c2h_out_bits_addr = q_c2h_io_deq_bits_addr; // @[TLB.scala 105:41]
  assign io__c2h_out_bits_qid = q_c2h_io_deq_bits_qid; // @[TLB.scala 105:41]
  assign io__c2h_out_bits_error = q_c2h_io_deq_bits_error; // @[TLB.scala 105:41]
  assign io__c2h_out_bits_func = q_c2h_io_deq_bits_func; // @[TLB.scala 105:41]
  assign io__c2h_out_bits_port_id = q_c2h_io_deq_bits_port_id; // @[TLB.scala 105:41]
  assign io__c2h_out_bits_pfch_tag = q_c2h_io_deq_bits_pfch_tag; // @[TLB.scala 105:41]
  assign io__c2h_out_bits_len = q_c2h_io_deq_bits_len; // @[TLB.scala 105:41]
  assign io__tlb_miss_count = tlb_miss_count; // @[TLB.scala 107:33]
  assign io_tlb_miss_count = io__tlb_miss_count;
  assign tlb_table_clock = clock;
  assign tlb_table_reset = reset;
  assign tlb_table_io_addr_a = _GEN_4[12:0];
  assign tlb_table_io_addr_b = c2h_index[12:0]; // @[TLB.scala 66:41]
  assign tlb_table_io_wr_en_a = io__wr_tlb_ready & io__wr_tlb_valid; // @[Decoupled.scala 40:37]
  assign tlb_table_io_data_in_a = {io__wr_tlb_bits_paddr_high,io__wr_tlb_bits_paddr_low}; // @[Cat.scala 30:58]
  assign q_h2c_clock = clock;
  assign q_h2c_reset = reset;
  assign q_h2c_io_enq_valid = REG_1 & REG_3 & ~REG_5; // @[TLB.scala 80:85]
  assign q_h2c_io_enq_bits_addr = tlb_table_io_data_out_a + _GEN_14; // @[TLB.scala 72:60]
  assign q_h2c_io_enq_bits_len = h2c_bits_delay_REG_1_len; // @[TLB.scala 68:47 TLB.scala 70:41]
  assign q_h2c_io_enq_bits_eop = h2c_bits_delay_REG_1_eop; // @[TLB.scala 68:47 TLB.scala 70:41]
  assign q_h2c_io_enq_bits_sop = h2c_bits_delay_REG_1_sop; // @[TLB.scala 68:47 TLB.scala 70:41]
  assign q_h2c_io_enq_bits_mrkr_req = h2c_bits_delay_REG_1_mrkr_req; // @[TLB.scala 68:47 TLB.scala 70:41]
  assign q_h2c_io_enq_bits_sdi = h2c_bits_delay_REG_1_sdi; // @[TLB.scala 68:47 TLB.scala 70:41]
  assign q_h2c_io_enq_bits_qid = h2c_bits_delay_REG_1_qid; // @[TLB.scala 68:47 TLB.scala 70:41]
  assign q_h2c_io_enq_bits_error = h2c_bits_delay_REG_1_error; // @[TLB.scala 68:47 TLB.scala 70:41]
  assign q_h2c_io_enq_bits_func = h2c_bits_delay_REG_1_func; // @[TLB.scala 68:47 TLB.scala 70:41]
  assign q_h2c_io_enq_bits_cidx = h2c_bits_delay_REG_1_cidx; // @[TLB.scala 68:47 TLB.scala 70:41]
  assign q_h2c_io_enq_bits_port_id = h2c_bits_delay_REG_1_port_id; // @[TLB.scala 68:47 TLB.scala 70:41]
  assign q_h2c_io_enq_bits_no_dma = h2c_bits_delay_REG_1_no_dma; // @[TLB.scala 68:47 TLB.scala 70:41]
  assign q_h2c_io_deq_ready = io__h2c_out_ready; // @[TLB.scala 102:41]
  assign q_c2h_clock = clock;
  assign q_c2h_reset = reset;
  assign q_c2h_io_enq_valid = REG_7 & REG_9 & ~REG_11; // @[TLB.scala 86:85]
  assign q_c2h_io_enq_bits_addr = tlb_table_io_data_out_b + _GEN_15; // @[TLB.scala 73:60]
  assign q_c2h_io_enq_bits_qid = c2h_bits_delay_REG_1_qid; // @[TLB.scala 69:47 TLB.scala 71:41]
  assign q_c2h_io_enq_bits_error = c2h_bits_delay_REG_1_error; // @[TLB.scala 69:47 TLB.scala 71:41]
  assign q_c2h_io_enq_bits_func = c2h_bits_delay_REG_1_func; // @[TLB.scala 69:47 TLB.scala 71:41]
  assign q_c2h_io_enq_bits_port_id = c2h_bits_delay_REG_1_port_id; // @[TLB.scala 69:47 TLB.scala 71:41]
  assign q_c2h_io_enq_bits_pfch_tag = c2h_bits_delay_REG_1_pfch_tag; // @[TLB.scala 69:47 TLB.scala 71:41]
  assign q_c2h_io_enq_bits_len = c2h_bits_delay_REG_1_len; // @[TLB.scala 69:47 TLB.scala 71:41]
  assign q_c2h_io_deq_ready = io__c2h_out_ready; // @[TLB.scala 105:41]
  always @(posedge clock) begin
    if (reset) begin // @[TLB.scala 37:50]
      base_page <= 43'h0; // @[TLB.scala 37:50]
    end else if (_tlb_table_io_wr_en_a_T) begin // @[TLB.scala 54:31]
      if (io__wr_tlb_bits_is_base) begin // @[TLB.scala 57:51]
        base_page <= _base_page_T[63:21]; // @[TLB.scala 58:57]
      end
    end
    if (reset) begin // @[TLB.scala 38:50]
      tlb_miss_count <= 32'h0; // @[TLB.scala 38:50]
    end else if (h2c_miss | c2h_miss) begin // @[TLB.scala 94:34]
      if (h2c_miss & c2h_miss) begin // @[TLB.scala 96:42]
        tlb_miss_count <= _tlb_miss_count_T_3; // @[TLB.scala 97:41]
      end else begin
        tlb_miss_count <= _tlb_miss_count_T_1; // @[TLB.scala 95:33]
      end
    end else if (_tlb_table_io_wr_en_a_T) begin // @[TLB.scala 54:31]
      if (io__wr_tlb_bits_is_base) begin // @[TLB.scala 57:51]
        tlb_miss_count <= 32'h0; // @[TLB.scala 61:49]
      end
    end
    if (reset) begin // @[TLB.scala 40:50]
      wrtlb_index <= 14'h0; // @[TLB.scala 40:50]
    end else if (_tlb_table_io_wr_en_a_T) begin // @[TLB.scala 54:31]
      if (io__wr_tlb_bits_is_base) begin // @[TLB.scala 57:51]
        wrtlb_index <= 14'h1; // @[TLB.scala 60:57]
      end else begin
        wrtlb_index <= _wrtlb_index_T_1; // @[TLB.scala 56:57]
      end
    end
    h2c_bits_delay_REG_len <= io__h2c_in_bits_len; // @[TLB.scala 70:59]
    h2c_bits_delay_REG_eop <= io__h2c_in_bits_eop; // @[TLB.scala 70:59]
    h2c_bits_delay_REG_sop <= io__h2c_in_bits_sop; // @[TLB.scala 70:59]
    h2c_bits_delay_REG_mrkr_req <= io__h2c_in_bits_mrkr_req; // @[TLB.scala 70:59]
    h2c_bits_delay_REG_sdi <= io__h2c_in_bits_sdi; // @[TLB.scala 70:59]
    h2c_bits_delay_REG_qid <= io__h2c_in_bits_qid; // @[TLB.scala 70:59]
    h2c_bits_delay_REG_error <= io__h2c_in_bits_error; // @[TLB.scala 70:59]
    h2c_bits_delay_REG_func <= io__h2c_in_bits_func; // @[TLB.scala 70:59]
    h2c_bits_delay_REG_cidx <= io__h2c_in_bits_cidx; // @[TLB.scala 70:59]
    h2c_bits_delay_REG_port_id <= io__h2c_in_bits_port_id; // @[TLB.scala 70:59]
    h2c_bits_delay_REG_no_dma <= io__h2c_in_bits_no_dma; // @[TLB.scala 70:59]
    h2c_bits_delay_REG_1_len <= h2c_bits_delay_REG_len; // @[TLB.scala 70:51]
    h2c_bits_delay_REG_1_eop <= h2c_bits_delay_REG_eop; // @[TLB.scala 70:51]
    h2c_bits_delay_REG_1_sop <= h2c_bits_delay_REG_sop; // @[TLB.scala 70:51]
    h2c_bits_delay_REG_1_mrkr_req <= h2c_bits_delay_REG_mrkr_req; // @[TLB.scala 70:51]
    h2c_bits_delay_REG_1_sdi <= h2c_bits_delay_REG_sdi; // @[TLB.scala 70:51]
    h2c_bits_delay_REG_1_qid <= h2c_bits_delay_REG_qid; // @[TLB.scala 70:51]
    h2c_bits_delay_REG_1_error <= h2c_bits_delay_REG_error; // @[TLB.scala 70:51]
    h2c_bits_delay_REG_1_func <= h2c_bits_delay_REG_func; // @[TLB.scala 70:51]
    h2c_bits_delay_REG_1_cidx <= h2c_bits_delay_REG_cidx; // @[TLB.scala 70:51]
    h2c_bits_delay_REG_1_port_id <= h2c_bits_delay_REG_port_id; // @[TLB.scala 70:51]
    h2c_bits_delay_REG_1_no_dma <= h2c_bits_delay_REG_no_dma; // @[TLB.scala 70:51]
    c2h_bits_delay_REG_qid <= io__c2h_in_bits_qid; // @[TLB.scala 71:59]
    c2h_bits_delay_REG_error <= io__c2h_in_bits_error; // @[TLB.scala 71:59]
    c2h_bits_delay_REG_func <= io__c2h_in_bits_func; // @[TLB.scala 71:59]
    c2h_bits_delay_REG_port_id <= io__c2h_in_bits_port_id; // @[TLB.scala 71:59]
    c2h_bits_delay_REG_pfch_tag <= io__c2h_in_bits_pfch_tag; // @[TLB.scala 71:59]
    c2h_bits_delay_REG_len <= io__c2h_in_bits_len; // @[TLB.scala 71:59]
    c2h_bits_delay_REG_1_qid <= c2h_bits_delay_REG_qid; // @[TLB.scala 71:51]
    c2h_bits_delay_REG_1_error <= c2h_bits_delay_REG_error; // @[TLB.scala 71:51]
    c2h_bits_delay_REG_1_func <= c2h_bits_delay_REG_func; // @[TLB.scala 71:51]
    c2h_bits_delay_REG_1_port_id <= c2h_bits_delay_REG_port_id; // @[TLB.scala 71:51]
    c2h_bits_delay_REG_1_pfch_tag <= c2h_bits_delay_REG_pfch_tag; // @[TLB.scala 71:51]
    c2h_bits_delay_REG_1_len <= c2h_bits_delay_REG_len; // @[TLB.scala 71:51]
    h2c_bits_delay_addr_REG <= io__h2c_in_bits_addr[20:0]; // @[TLB.scala 72:97]
    h2c_bits_delay_addr_REG_1 <= h2c_bits_delay_addr_REG; // @[TLB.scala 72:69]
    c2h_bits_delay_addr_REG <= io__c2h_in_bits_addr[20:0]; // @[TLB.scala 73:97]
    c2h_bits_delay_addr_REG_1 <= c2h_bits_delay_addr_REG; // @[TLB.scala 73:69]
    REG <= io__h2c_in_valid; // @[TLB.scala 80:29]
    REG_1 <= REG; // @[TLB.scala 80:21]
    REG_2 <= io__h2c_in_ready; // @[TLB.scala 80:66]
    REG_3 <= REG_2; // @[TLB.scala 80:58]
    REG_4 <= h2c_page < base_page | h2c_page >= _h2c_outrange_T_2; // @[TLB.scala 43:66]
    REG_5 <= REG_4; // @[TLB.scala 80:96]
    REG_6 <= io__c2h_in_valid; // @[TLB.scala 86:29]
    REG_7 <= REG_6; // @[TLB.scala 86:21]
    REG_8 <= io__c2h_in_ready; // @[TLB.scala 86:66]
    REG_9 <= REG_8; // @[TLB.scala 86:58]
    REG_10 <= c2h_page < base_page | c2h_page >= _h2c_outrange_T_2; // @[TLB.scala 46:66]
    REG_11 <= REG_10; // @[TLB.scala 86:96]
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
  _RAND_0 = {2{`RANDOM}};
  base_page = _RAND_0[42:0];
  _RAND_1 = {1{`RANDOM}};
  tlb_miss_count = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  wrtlb_index = _RAND_2[13:0];
  _RAND_3 = {1{`RANDOM}};
  h2c_bits_delay_REG_len = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  h2c_bits_delay_REG_eop = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  h2c_bits_delay_REG_sop = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  h2c_bits_delay_REG_mrkr_req = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  h2c_bits_delay_REG_sdi = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  h2c_bits_delay_REG_qid = _RAND_8[10:0];
  _RAND_9 = {1{`RANDOM}};
  h2c_bits_delay_REG_error = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  h2c_bits_delay_REG_func = _RAND_10[7:0];
  _RAND_11 = {1{`RANDOM}};
  h2c_bits_delay_REG_cidx = _RAND_11[15:0];
  _RAND_12 = {1{`RANDOM}};
  h2c_bits_delay_REG_port_id = _RAND_12[2:0];
  _RAND_13 = {1{`RANDOM}};
  h2c_bits_delay_REG_no_dma = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  h2c_bits_delay_REG_1_len = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  h2c_bits_delay_REG_1_eop = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  h2c_bits_delay_REG_1_sop = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  h2c_bits_delay_REG_1_mrkr_req = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  h2c_bits_delay_REG_1_sdi = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  h2c_bits_delay_REG_1_qid = _RAND_19[10:0];
  _RAND_20 = {1{`RANDOM}};
  h2c_bits_delay_REG_1_error = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  h2c_bits_delay_REG_1_func = _RAND_21[7:0];
  _RAND_22 = {1{`RANDOM}};
  h2c_bits_delay_REG_1_cidx = _RAND_22[15:0];
  _RAND_23 = {1{`RANDOM}};
  h2c_bits_delay_REG_1_port_id = _RAND_23[2:0];
  _RAND_24 = {1{`RANDOM}};
  h2c_bits_delay_REG_1_no_dma = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  c2h_bits_delay_REG_qid = _RAND_25[10:0];
  _RAND_26 = {1{`RANDOM}};
  c2h_bits_delay_REG_error = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  c2h_bits_delay_REG_func = _RAND_27[7:0];
  _RAND_28 = {1{`RANDOM}};
  c2h_bits_delay_REG_port_id = _RAND_28[2:0];
  _RAND_29 = {1{`RANDOM}};
  c2h_bits_delay_REG_pfch_tag = _RAND_29[6:0];
  _RAND_30 = {1{`RANDOM}};
  c2h_bits_delay_REG_len = _RAND_30[31:0];
  _RAND_31 = {1{`RANDOM}};
  c2h_bits_delay_REG_1_qid = _RAND_31[10:0];
  _RAND_32 = {1{`RANDOM}};
  c2h_bits_delay_REG_1_error = _RAND_32[0:0];
  _RAND_33 = {1{`RANDOM}};
  c2h_bits_delay_REG_1_func = _RAND_33[7:0];
  _RAND_34 = {1{`RANDOM}};
  c2h_bits_delay_REG_1_port_id = _RAND_34[2:0];
  _RAND_35 = {1{`RANDOM}};
  c2h_bits_delay_REG_1_pfch_tag = _RAND_35[6:0];
  _RAND_36 = {1{`RANDOM}};
  c2h_bits_delay_REG_1_len = _RAND_36[31:0];
  _RAND_37 = {1{`RANDOM}};
  h2c_bits_delay_addr_REG = _RAND_37[20:0];
  _RAND_38 = {1{`RANDOM}};
  h2c_bits_delay_addr_REG_1 = _RAND_38[20:0];
  _RAND_39 = {1{`RANDOM}};
  c2h_bits_delay_addr_REG = _RAND_39[20:0];
  _RAND_40 = {1{`RANDOM}};
  c2h_bits_delay_addr_REG_1 = _RAND_40[20:0];
  _RAND_41 = {1{`RANDOM}};
  REG = _RAND_41[0:0];
  _RAND_42 = {1{`RANDOM}};
  REG_1 = _RAND_42[0:0];
  _RAND_43 = {1{`RANDOM}};
  REG_2 = _RAND_43[0:0];
  _RAND_44 = {1{`RANDOM}};
  REG_3 = _RAND_44[0:0];
  _RAND_45 = {1{`RANDOM}};
  REG_4 = _RAND_45[0:0];
  _RAND_46 = {1{`RANDOM}};
  REG_5 = _RAND_46[0:0];
  _RAND_47 = {1{`RANDOM}};
  REG_6 = _RAND_47[0:0];
  _RAND_48 = {1{`RANDOM}};
  REG_7 = _RAND_48[0:0];
  _RAND_49 = {1{`RANDOM}};
  REG_8 = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  REG_9 = _RAND_50[0:0];
  _RAND_51 = {1{`RANDOM}};
  REG_10 = _RAND_51[0:0];
  _RAND_52 = {1{`RANDOM}};
  REG_11 = _RAND_52[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module RegSlice_9(
  input         clock,
  input         reset,
  output        io_upStream_ready,
  input         io_upStream_valid,
  input  [31:0] io_upStream_bits_data,
  input         io_downStream_ready,
  output        io_downStream_valid,
  output [31:0] io_downStream_bits_data
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg  fwd_valid; // @[RegSlices.scala 112:34]
  reg [31:0] fwd_data_data; // @[RegSlices.scala 113:30]
  wire  fwd_ready_s = ~fwd_valid | io_downStream_ready; // @[RegSlices.scala 115:35]
  reg  bwd_ready; // @[RegSlices.scala 123:34]
  reg [31:0] bwd_data_data; // @[RegSlices.scala 124:30]
  wire  _fwd_valid_T = io_downStream_ready ? 1'h0 : fwd_valid; // @[RegSlices.scala 121:53]
  wire  bwd_valid_s = ~bwd_ready | io_upStream_valid; // @[RegSlices.scala 126:39]
  wire  _bwd_ready_T = io_upStream_valid ? 1'h0 : bwd_ready; // @[RegSlices.scala 132:53]
  assign io_upStream_ready = bwd_ready; // @[RegSlices.scala 107:31 RegSlices.scala 128:25]
  assign io_downStream_valid = fwd_valid; // @[RegSlices.scala 109:31 RegSlices.scala 116:21]
  assign io_downStream_bits_data = fwd_data_data; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  always @(posedge clock) begin
    if (reset) begin // @[RegSlices.scala 112:34]
      fwd_valid <= 1'h0; // @[RegSlices.scala 112:34]
    end else begin
      fwd_valid <= bwd_valid_s | _fwd_valid_T; // @[RegSlices.scala 121:25]
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_data <= io_upStream_bits_data;
      end else begin
        fwd_data_data <= bwd_data_data;
      end
    end
    bwd_ready <= reset | (fwd_ready_s | _bwd_ready_T); // @[RegSlices.scala 123:34 RegSlices.scala 123:34 RegSlices.scala 132:25]
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_data <= io_upStream_bits_data;
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
  fwd_valid = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  fwd_data_data = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  bwd_ready = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  bwd_data_data = _RAND_3[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module PoorAXIL2Reg(
  input         clock,
  input         reset,
  output        io_axi_aw_ready,
  input         io_axi_aw_valid,
  input  [31:0] io_axi_aw_bits_addr,
  output        io_axi_ar_ready,
  input         io_axi_ar_valid,
  input  [31:0] io_axi_ar_bits_addr,
  output        io_axi_w_ready,
  input         io_axi_w_valid,
  input  [31:0] io_axi_w_bits_data,
  input         io_axi_r_ready,
  output        io_axi_r_valid,
  output [31:0] io_axi_r_bits_data,
  output [31:0] io_reg_control_0,
  output [31:0] io_reg_control_8,
  output [31:0] io_reg_control_9,
  output [31:0] io_reg_control_10,
  output [31:0] io_reg_control_11,
  output [31:0] io_reg_control_12,
  output [31:0] io_reg_control_13,
  output [31:0] io_reg_control_14,
  input  [31:0] io_reg_status_400,
  input  [31:0] io_reg_status_401,
  input  [31:0] io_reg_status_402,
  input  [31:0] io_reg_status_403,
  input  [31:0] io_reg_status_404,
  input  [31:0] io_reg_status_405,
  input  [31:0] io_reg_status_406,
  input  [31:0] io_reg_status_407,
  input  [31:0] io_reg_status_408,
  input  [31:0] io_reg_status_409
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
`endif // RANDOMIZE_REG_INIT
  wire  r_delay_clock; // @[PoorAXIL2Reg.scala 38:33]
  wire  r_delay_reset; // @[PoorAXIL2Reg.scala 38:33]
  wire  r_delay_io_upStream_ready; // @[PoorAXIL2Reg.scala 38:33]
  wire  r_delay_io_upStream_valid; // @[PoorAXIL2Reg.scala 38:33]
  wire [31:0] r_delay_io_upStream_bits_data; // @[PoorAXIL2Reg.scala 38:33]
  wire  r_delay_io_downStream_ready; // @[PoorAXIL2Reg.scala 38:33]
  wire  r_delay_io_downStream_valid; // @[PoorAXIL2Reg.scala 38:33]
  wire [31:0] r_delay_io_downStream_bits_data; // @[PoorAXIL2Reg.scala 38:33]
  reg [31:0] reg_control_0; // @[PoorAXIL2Reg.scala 17:30]
  reg [31:0] reg_control_8; // @[PoorAXIL2Reg.scala 17:30]
  reg [31:0] reg_control_9; // @[PoorAXIL2Reg.scala 17:30]
  reg [31:0] reg_control_10; // @[PoorAXIL2Reg.scala 17:30]
  reg [31:0] reg_control_11; // @[PoorAXIL2Reg.scala 17:30]
  reg [31:0] reg_control_12; // @[PoorAXIL2Reg.scala 17:30]
  reg [31:0] reg_control_13; // @[PoorAXIL2Reg.scala 17:30]
  reg [31:0] reg_control_14; // @[PoorAXIL2Reg.scala 17:30]
  reg [31:0] reg_status_400; // @[PoorAXIL2Reg.scala 19:29]
  reg [31:0] reg_status_401; // @[PoorAXIL2Reg.scala 19:29]
  reg [31:0] reg_status_402; // @[PoorAXIL2Reg.scala 19:29]
  reg [31:0] reg_status_403; // @[PoorAXIL2Reg.scala 19:29]
  reg [31:0] reg_status_404; // @[PoorAXIL2Reg.scala 19:29]
  reg [31:0] reg_status_405; // @[PoorAXIL2Reg.scala 19:29]
  reg [31:0] reg_status_406; // @[PoorAXIL2Reg.scala 19:29]
  reg [31:0] reg_status_407; // @[PoorAXIL2Reg.scala 19:29]
  reg [31:0] reg_status_408; // @[PoorAXIL2Reg.scala 19:29]
  reg [31:0] reg_status_409; // @[PoorAXIL2Reg.scala 19:29]
  reg  s_rd; // @[PoorAXIL2Reg.scala 30:27]
  reg  s_wr; // @[PoorAXIL2Reg.scala 31:27]
  reg [31:0] r_addr; // @[PoorAXIL2Reg.scala 41:25]
  reg [31:0] w_addr; // @[PoorAXIL2Reg.scala 42:25]
  wire  _io_axi_ar_ready_T = ~s_rd; // @[PoorAXIL2Reg.scala 44:74]
  wire [31:0] _GEN_400 = 9'h190 == r_addr[8:0] ? reg_status_400 : 32'h0; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_401 = 9'h191 == r_addr[8:0] ? reg_status_401 : _GEN_400; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_402 = 9'h192 == r_addr[8:0] ? reg_status_402 : _GEN_401; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_403 = 9'h193 == r_addr[8:0] ? reg_status_403 : _GEN_402; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_404 = 9'h194 == r_addr[8:0] ? reg_status_404 : _GEN_403; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_405 = 9'h195 == r_addr[8:0] ? reg_status_405 : _GEN_404; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_406 = 9'h196 == r_addr[8:0] ? reg_status_406 : _GEN_405; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_407 = 9'h197 == r_addr[8:0] ? reg_status_407 : _GEN_406; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_408 = 9'h198 == r_addr[8:0] ? reg_status_408 : _GEN_407; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_409 = 9'h199 == r_addr[8:0] ? reg_status_409 : _GEN_408; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_410 = 9'h19a == r_addr[8:0] ? 32'h0 : _GEN_409; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_411 = 9'h19b == r_addr[8:0] ? 32'h0 : _GEN_410; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_412 = 9'h19c == r_addr[8:0] ? 32'h0 : _GEN_411; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_413 = 9'h19d == r_addr[8:0] ? 32'h0 : _GEN_412; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_414 = 9'h19e == r_addr[8:0] ? 32'h0 : _GEN_413; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_415 = 9'h19f == r_addr[8:0] ? 32'h0 : _GEN_414; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_416 = 9'h1a0 == r_addr[8:0] ? 32'h0 : _GEN_415; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_417 = 9'h1a1 == r_addr[8:0] ? 32'h0 : _GEN_416; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_418 = 9'h1a2 == r_addr[8:0] ? 32'h0 : _GEN_417; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_419 = 9'h1a3 == r_addr[8:0] ? 32'h0 : _GEN_418; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_420 = 9'h1a4 == r_addr[8:0] ? 32'h0 : _GEN_419; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_421 = 9'h1a5 == r_addr[8:0] ? 32'h0 : _GEN_420; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_422 = 9'h1a6 == r_addr[8:0] ? 32'h0 : _GEN_421; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_423 = 9'h1a7 == r_addr[8:0] ? 32'h0 : _GEN_422; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_424 = 9'h1a8 == r_addr[8:0] ? 32'h0 : _GEN_423; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_425 = 9'h1a9 == r_addr[8:0] ? 32'h0 : _GEN_424; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_426 = 9'h1aa == r_addr[8:0] ? 32'h0 : _GEN_425; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_427 = 9'h1ab == r_addr[8:0] ? 32'h0 : _GEN_426; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_428 = 9'h1ac == r_addr[8:0] ? 32'h0 : _GEN_427; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_429 = 9'h1ad == r_addr[8:0] ? 32'h0 : _GEN_428; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_430 = 9'h1ae == r_addr[8:0] ? 32'h0 : _GEN_429; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_431 = 9'h1af == r_addr[8:0] ? 32'h0 : _GEN_430; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_432 = 9'h1b0 == r_addr[8:0] ? 32'h0 : _GEN_431; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_433 = 9'h1b1 == r_addr[8:0] ? 32'h0 : _GEN_432; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_434 = 9'h1b2 == r_addr[8:0] ? 32'h0 : _GEN_433; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_435 = 9'h1b3 == r_addr[8:0] ? 32'h0 : _GEN_434; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_436 = 9'h1b4 == r_addr[8:0] ? 32'h0 : _GEN_435; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_437 = 9'h1b5 == r_addr[8:0] ? 32'h0 : _GEN_436; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_438 = 9'h1b6 == r_addr[8:0] ? 32'h0 : _GEN_437; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_439 = 9'h1b7 == r_addr[8:0] ? 32'h0 : _GEN_438; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_440 = 9'h1b8 == r_addr[8:0] ? 32'h0 : _GEN_439; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_441 = 9'h1b9 == r_addr[8:0] ? 32'h0 : _GEN_440; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_442 = 9'h1ba == r_addr[8:0] ? 32'h0 : _GEN_441; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_443 = 9'h1bb == r_addr[8:0] ? 32'h0 : _GEN_442; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_444 = 9'h1bc == r_addr[8:0] ? 32'h0 : _GEN_443; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_445 = 9'h1bd == r_addr[8:0] ? 32'h0 : _GEN_444; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_446 = 9'h1be == r_addr[8:0] ? 32'h0 : _GEN_445; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_447 = 9'h1bf == r_addr[8:0] ? 32'h0 : _GEN_446; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_448 = 9'h1c0 == r_addr[8:0] ? 32'h0 : _GEN_447; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_449 = 9'h1c1 == r_addr[8:0] ? 32'h0 : _GEN_448; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_450 = 9'h1c2 == r_addr[8:0] ? 32'h0 : _GEN_449; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_451 = 9'h1c3 == r_addr[8:0] ? 32'h0 : _GEN_450; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_452 = 9'h1c4 == r_addr[8:0] ? 32'h0 : _GEN_451; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_453 = 9'h1c5 == r_addr[8:0] ? 32'h0 : _GEN_452; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_454 = 9'h1c6 == r_addr[8:0] ? 32'h0 : _GEN_453; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_455 = 9'h1c7 == r_addr[8:0] ? 32'h0 : _GEN_454; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_456 = 9'h1c8 == r_addr[8:0] ? 32'h0 : _GEN_455; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_457 = 9'h1c9 == r_addr[8:0] ? 32'h0 : _GEN_456; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_458 = 9'h1ca == r_addr[8:0] ? 32'h0 : _GEN_457; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_459 = 9'h1cb == r_addr[8:0] ? 32'h0 : _GEN_458; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_460 = 9'h1cc == r_addr[8:0] ? 32'h0 : _GEN_459; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_461 = 9'h1cd == r_addr[8:0] ? 32'h0 : _GEN_460; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_462 = 9'h1ce == r_addr[8:0] ? 32'h0 : _GEN_461; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_463 = 9'h1cf == r_addr[8:0] ? 32'h0 : _GEN_462; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_464 = 9'h1d0 == r_addr[8:0] ? 32'h0 : _GEN_463; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_465 = 9'h1d1 == r_addr[8:0] ? 32'h0 : _GEN_464; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_466 = 9'h1d2 == r_addr[8:0] ? 32'h0 : _GEN_465; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_467 = 9'h1d3 == r_addr[8:0] ? 32'h0 : _GEN_466; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_468 = 9'h1d4 == r_addr[8:0] ? 32'h0 : _GEN_467; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_469 = 9'h1d5 == r_addr[8:0] ? 32'h0 : _GEN_468; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_470 = 9'h1d6 == r_addr[8:0] ? 32'h0 : _GEN_469; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_471 = 9'h1d7 == r_addr[8:0] ? 32'h0 : _GEN_470; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_472 = 9'h1d8 == r_addr[8:0] ? 32'h0 : _GEN_471; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_473 = 9'h1d9 == r_addr[8:0] ? 32'h0 : _GEN_472; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_474 = 9'h1da == r_addr[8:0] ? 32'h0 : _GEN_473; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_475 = 9'h1db == r_addr[8:0] ? 32'h0 : _GEN_474; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_476 = 9'h1dc == r_addr[8:0] ? 32'h0 : _GEN_475; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_477 = 9'h1dd == r_addr[8:0] ? 32'h0 : _GEN_476; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_478 = 9'h1de == r_addr[8:0] ? 32'h0 : _GEN_477; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_479 = 9'h1df == r_addr[8:0] ? 32'h0 : _GEN_478; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_480 = 9'h1e0 == r_addr[8:0] ? 32'h0 : _GEN_479; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_481 = 9'h1e1 == r_addr[8:0] ? 32'h0 : _GEN_480; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_482 = 9'h1e2 == r_addr[8:0] ? 32'h0 : _GEN_481; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_483 = 9'h1e3 == r_addr[8:0] ? 32'h0 : _GEN_482; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_484 = 9'h1e4 == r_addr[8:0] ? 32'h0 : _GEN_483; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_485 = 9'h1e5 == r_addr[8:0] ? 32'h0 : _GEN_484; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_486 = 9'h1e6 == r_addr[8:0] ? 32'h0 : _GEN_485; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_487 = 9'h1e7 == r_addr[8:0] ? 32'h0 : _GEN_486; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_488 = 9'h1e8 == r_addr[8:0] ? 32'h0 : _GEN_487; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_489 = 9'h1e9 == r_addr[8:0] ? 32'h0 : _GEN_488; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_490 = 9'h1ea == r_addr[8:0] ? 32'h0 : _GEN_489; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_491 = 9'h1eb == r_addr[8:0] ? 32'h0 : _GEN_490; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_492 = 9'h1ec == r_addr[8:0] ? 32'h0 : _GEN_491; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_493 = 9'h1ed == r_addr[8:0] ? 32'h0 : _GEN_492; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_494 = 9'h1ee == r_addr[8:0] ? 32'h0 : _GEN_493; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_495 = 9'h1ef == r_addr[8:0] ? 32'h0 : _GEN_494; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_496 = 9'h1f0 == r_addr[8:0] ? 32'h0 : _GEN_495; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_497 = 9'h1f1 == r_addr[8:0] ? 32'h0 : _GEN_496; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_498 = 9'h1f2 == r_addr[8:0] ? 32'h0 : _GEN_497; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_499 = 9'h1f3 == r_addr[8:0] ? 32'h0 : _GEN_498; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_500 = 9'h1f4 == r_addr[8:0] ? 32'h0 : _GEN_499; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_501 = 9'h1f5 == r_addr[8:0] ? 32'h0 : _GEN_500; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_502 = 9'h1f6 == r_addr[8:0] ? 32'h0 : _GEN_501; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_503 = 9'h1f7 == r_addr[8:0] ? 32'h0 : _GEN_502; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_504 = 9'h1f8 == r_addr[8:0] ? 32'h0 : _GEN_503; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_505 = 9'h1f9 == r_addr[8:0] ? 32'h0 : _GEN_504; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_506 = 9'h1fa == r_addr[8:0] ? 32'h0 : _GEN_505; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_507 = 9'h1fb == r_addr[8:0] ? 32'h0 : _GEN_506; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_508 = 9'h1fc == r_addr[8:0] ? 32'h0 : _GEN_507; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_509 = 9'h1fd == r_addr[8:0] ? 32'h0 : _GEN_508; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire [31:0] _GEN_510 = 9'h1fe == r_addr[8:0] ? 32'h0 : _GEN_509; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  wire  _T_1 = io_axi_ar_ready & io_axi_ar_valid; // @[Decoupled.scala 40:37]
  wire [31:0] _r_addr_T = {{2'd0}, io_axi_ar_bits_addr[31:2]}; // @[PoorAXIL2Reg.scala 51:73]
  wire  _GEN_513 = _T_1 | s_rd; // @[PoorAXIL2Reg.scala 50:40 PoorAXIL2Reg.scala 52:57 PoorAXIL2Reg.scala 30:27]
  wire  _T_3 = r_delay_io_upStream_ready & r_delay_io_upStream_valid; // @[Decoupled.scala 40:37]
  wire  _io_axi_aw_ready_T = ~s_wr; // @[PoorAXIL2Reg.scala 62:34]
  wire  _T_4 = io_axi_w_ready & io_axi_w_valid; // @[Decoupled.scala 40:37]
  wire  _T_7 = io_axi_aw_ready & io_axi_aw_valid; // @[Decoupled.scala 40:37]
  wire [31:0] _w_addr_T = {{2'd0}, io_axi_aw_bits_addr[31:2]}; // @[PoorAXIL2Reg.scala 70:73]
  wire  _GEN_1543 = _T_7 | s_wr; // @[PoorAXIL2Reg.scala 69:40 PoorAXIL2Reg.scala 71:57 PoorAXIL2Reg.scala 31:27]
  RegSlice_9 r_delay ( // @[PoorAXIL2Reg.scala 38:33]
    .clock(r_delay_clock),
    .reset(r_delay_reset),
    .io_upStream_ready(r_delay_io_upStream_ready),
    .io_upStream_valid(r_delay_io_upStream_valid),
    .io_upStream_bits_data(r_delay_io_upStream_bits_data),
    .io_downStream_ready(r_delay_io_downStream_ready),
    .io_downStream_valid(r_delay_io_downStream_valid),
    .io_downStream_bits_data(r_delay_io_downStream_bits_data)
  );
  assign io_axi_aw_ready = ~s_wr; // @[PoorAXIL2Reg.scala 62:34]
  assign io_axi_ar_ready = ~s_rd; // @[PoorAXIL2Reg.scala 44:74]
  assign io_axi_w_ready = s_wr; // @[PoorAXIL2Reg.scala 63:34]
  assign io_axi_r_valid = r_delay_io_downStream_valid; // @[PoorAXIL2Reg.scala 47:73]
  assign io_axi_r_bits_data = r_delay_io_downStream_bits_data; // @[PoorAXIL2Reg.scala 47:73]
  assign io_reg_control_0 = reg_control_0; // @[PoorAXIL2Reg.scala 23:57]
  assign io_reg_control_8 = reg_control_8; // @[PoorAXIL2Reg.scala 23:57]
  assign io_reg_control_9 = reg_control_9; // @[PoorAXIL2Reg.scala 23:57]
  assign io_reg_control_10 = reg_control_10; // @[PoorAXIL2Reg.scala 23:57]
  assign io_reg_control_11 = reg_control_11; // @[PoorAXIL2Reg.scala 23:57]
  assign io_reg_control_12 = reg_control_12; // @[PoorAXIL2Reg.scala 23:57]
  assign io_reg_control_13 = reg_control_13; // @[PoorAXIL2Reg.scala 23:57]
  assign io_reg_control_14 = reg_control_14; // @[PoorAXIL2Reg.scala 23:57]
  assign r_delay_clock = clock;
  assign r_delay_reset = reset;
  assign r_delay_io_upStream_valid = s_rd; // @[PoorAXIL2Reg.scala 45:58]
  assign r_delay_io_upStream_bits_data = 9'h1ff == r_addr[8:0] ? 32'h0 : _GEN_510; // @[PoorAXIL2Reg.scala 46:41 PoorAXIL2Reg.scala 46:41]
  assign r_delay_io_downStream_ready = io_axi_r_ready; // @[PoorAXIL2Reg.scala 47:73]
  always @(posedge clock) begin
    if (_T_4) begin // @[PoorAXIL2Reg.scala 64:23]
      if (9'h0 == w_addr[8:0]) begin // @[PoorAXIL2Reg.scala 65:41]
        reg_control_0 <= io_axi_w_bits_data; // @[PoorAXIL2Reg.scala 65:41]
      end
    end
    if (_T_4) begin // @[PoorAXIL2Reg.scala 64:23]
      if (9'h8 == w_addr[8:0]) begin // @[PoorAXIL2Reg.scala 65:41]
        reg_control_8 <= io_axi_w_bits_data; // @[PoorAXIL2Reg.scala 65:41]
      end
    end
    if (_T_4) begin // @[PoorAXIL2Reg.scala 64:23]
      if (9'h9 == w_addr[8:0]) begin // @[PoorAXIL2Reg.scala 65:41]
        reg_control_9 <= io_axi_w_bits_data; // @[PoorAXIL2Reg.scala 65:41]
      end
    end
    if (_T_4) begin // @[PoorAXIL2Reg.scala 64:23]
      if (9'ha == w_addr[8:0]) begin // @[PoorAXIL2Reg.scala 65:41]
        reg_control_10 <= io_axi_w_bits_data; // @[PoorAXIL2Reg.scala 65:41]
      end
    end
    if (_T_4) begin // @[PoorAXIL2Reg.scala 64:23]
      if (9'hb == w_addr[8:0]) begin // @[PoorAXIL2Reg.scala 65:41]
        reg_control_11 <= io_axi_w_bits_data; // @[PoorAXIL2Reg.scala 65:41]
      end
    end
    if (_T_4) begin // @[PoorAXIL2Reg.scala 64:23]
      if (9'hc == w_addr[8:0]) begin // @[PoorAXIL2Reg.scala 65:41]
        reg_control_12 <= io_axi_w_bits_data; // @[PoorAXIL2Reg.scala 65:41]
      end
    end
    if (_T_4) begin // @[PoorAXIL2Reg.scala 64:23]
      if (9'hd == w_addr[8:0]) begin // @[PoorAXIL2Reg.scala 65:41]
        reg_control_13 <= io_axi_w_bits_data; // @[PoorAXIL2Reg.scala 65:41]
      end
    end
    if (_T_4) begin // @[PoorAXIL2Reg.scala 64:23]
      if (9'he == w_addr[8:0]) begin // @[PoorAXIL2Reg.scala 65:41]
        reg_control_14 <= io_axi_w_bits_data; // @[PoorAXIL2Reg.scala 65:41]
      end
    end
    reg_status_400 <= io_reg_status_400; // @[PoorAXIL2Reg.scala 22:57]
    reg_status_401 <= io_reg_status_401; // @[PoorAXIL2Reg.scala 22:57]
    reg_status_402 <= io_reg_status_402; // @[PoorAXIL2Reg.scala 22:57]
    reg_status_403 <= io_reg_status_403; // @[PoorAXIL2Reg.scala 22:57]
    reg_status_404 <= io_reg_status_404; // @[PoorAXIL2Reg.scala 22:57]
    reg_status_405 <= io_reg_status_405; // @[PoorAXIL2Reg.scala 22:57]
    reg_status_406 <= io_reg_status_406; // @[PoorAXIL2Reg.scala 22:57]
    reg_status_407 <= io_reg_status_407; // @[PoorAXIL2Reg.scala 22:57]
    reg_status_408 <= io_reg_status_408; // @[PoorAXIL2Reg.scala 22:57]
    reg_status_409 <= io_reg_status_409; // @[PoorAXIL2Reg.scala 22:57]
    if (reset) begin // @[PoorAXIL2Reg.scala 30:27]
      s_rd <= 1'h0; // @[PoorAXIL2Reg.scala 30:27]
    end else if (_io_axi_ar_ready_T) begin // @[Conditional.scala 40:58]
      s_rd <= _GEN_513;
    end else if (s_rd) begin // @[Conditional.scala 39:67]
      if (_T_3) begin // @[PoorAXIL2Reg.scala 56:57]
        s_rd <= 1'h0; // @[PoorAXIL2Reg.scala 57:57]
      end
    end
    if (reset) begin // @[PoorAXIL2Reg.scala 31:27]
      s_wr <= 1'h0; // @[PoorAXIL2Reg.scala 31:27]
    end else if (_io_axi_aw_ready_T) begin // @[Conditional.scala 40:58]
      s_wr <= _GEN_1543;
    end else if (s_wr) begin // @[Conditional.scala 39:67]
      if (_T_4) begin // @[PoorAXIL2Reg.scala 75:39]
        s_wr <= 1'h0; // @[PoorAXIL2Reg.scala 76:57]
      end
    end
    if (_io_axi_ar_ready_T) begin // @[Conditional.scala 40:58]
      if (_T_1) begin // @[PoorAXIL2Reg.scala 50:40]
        r_addr <= _r_addr_T; // @[PoorAXIL2Reg.scala 51:57]
      end
    end
    if (_io_axi_aw_ready_T) begin // @[Conditional.scala 40:58]
      if (_T_7) begin // @[PoorAXIL2Reg.scala 69:40]
        w_addr <= _w_addr_T; // @[PoorAXIL2Reg.scala 70:57]
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
  reg_control_0 = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  reg_control_8 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  reg_control_9 = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  reg_control_10 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  reg_control_11 = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  reg_control_12 = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  reg_control_13 = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  reg_control_14 = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  reg_status_400 = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  reg_status_401 = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  reg_status_402 = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  reg_status_403 = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  reg_status_404 = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  reg_status_405 = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  reg_status_406 = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  reg_status_407 = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  reg_status_408 = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  reg_status_409 = _RAND_17[31:0];
  _RAND_18 = {1{`RANDOM}};
  s_rd = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  s_wr = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  r_addr = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  w_addr = _RAND_21[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SV_STREAM_FIFO_4(
  input          io_m_clk,
  input          io_s_clk,
  input          io_reset_n,
  input  [103:0] io_in_data,
  input          io_in_valid,
  output         io_in_ready
);
  wire [103:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [12:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [103:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [12:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [12:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(104), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_in_ready = meta_s_axis_tready; // @[Meta.scala 34:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = 1'h1; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = io_in_data; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 13'h1fff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 13'h1fff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = io_in_valid; // @[Meta.scala 48:41]
endmodule
module XConverter_4(
  input         io_in_clk,
  input         io_out_clk,
  input         io_rstn,
  output        io_in_ready,
  input         io_in_valid,
  input  [63:0] io_in_bits_addr,
  input  [1:0]  io_in_bits_burst,
  input  [3:0]  io_in_bits_cache,
  input  [3:0]  io_in_bits_id,
  input  [7:0]  io_in_bits_len,
  input         io_in_bits_lock,
  input  [2:0]  io_in_bits_prot,
  input  [2:0]  io_in_bits_size
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [103:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire [96:0] _fifo_io_in_data_T = {io_in_bits_addr,io_in_bits_burst,io_in_bits_cache,io_in_bits_id,io_in_bits_len,
    io_in_bits_lock,io_in_bits_prot,4'h0,4'h0,io_in_bits_size}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO_4 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready)
  );
  assign io_in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{7'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io_in_valid; // @[XConverter.scala 104:41]
endmodule
module SV_STREAM_FIFO_6(
  input          io_m_clk,
  input          io_s_clk,
  input          io_reset_n,
  input  [583:0] io_in_data,
  input          io_in_valid,
  output         io_in_ready,
  output [583:0] io_out_data,
  output         io_out_valid,
  input          io_out_ready
);
  wire [583:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [72:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [583:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [72:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [72:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(584), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_in_ready = meta_s_axis_tready; // @[Meta.scala 34:41]
  assign io_out_data = meta_m_axis_tdata; // @[Meta.scala 31:41]
  assign io_out_valid = meta_m_axis_tvalid; // @[Meta.scala 32:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = io_out_ready; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = io_in_data; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 73'h1ffffffffffffffffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 73'h1ffffffffffffffffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = io_in_valid; // @[Meta.scala 48:41]
endmodule
module XConverter_6(
  input          io_in_clk,
  input          io_out_clk,
  input          io_rstn,
  output         io_in_ready,
  input          io_in_valid,
  input  [511:0] io_in_bits_data,
  input          io_in_bits_last,
  input  [63:0]  io_in_bits_strb
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [583:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire [583:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  wire [576:0] _fifo_io_in_data_T = {io_in_bits_data,io_in_bits_last,io_in_bits_strb}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO_6 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{7'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io_in_valid; // @[XConverter.scala 104:41]
  assign fifo_io_out_ready = 1'h1; // @[XConverter.scala 109:41]
endmodule
module SV_STREAM_FIFO_7(
  input          io_m_clk,
  input          io_s_clk,
  input          io_reset_n,
  output [519:0] io_out_data,
  output         io_out_valid,
  input          io_out_ready
);
  wire [519:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [64:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [519:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [64:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [64:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(520), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_out_data = meta_m_axis_tdata; // @[Meta.scala 31:41]
  assign io_out_valid = meta_m_axis_tvalid; // @[Meta.scala 32:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = io_out_ready; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = 520'h0; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 65'h1ffffffffffffffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 65'h1ffffffffffffffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = 1'h1; // @[Meta.scala 48:41]
endmodule
module XConverter_7(
  input          io_in_clk,
  input          io_out_clk,
  input          io_rstn,
  input          io_out_ready,
  output         io_out_valid,
  output [511:0] io_out_bits_data,
  output         io_out_bits_last,
  output [1:0]   io_out_bits_resp,
  output [3:0]   io_out_bits_id
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [519:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  SV_STREAM_FIFO_7 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io_out_bits_data = fifo_io_out_data[518:7]; // @[XConverter.scala 107:77]
  assign io_out_bits_last = fifo_io_out_data[6]; // @[XConverter.scala 107:77]
  assign io_out_bits_resp = fifo_io_out_data[5:4]; // @[XConverter.scala 107:77]
  assign io_out_bits_id = fifo_io_out_data[3:0]; // @[XConverter.scala 107:77]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_out_ready = io_out_ready; // @[XConverter.scala 109:41]
endmodule
module SV_STREAM_FIFO_8(
  input        io_m_clk,
  input        io_s_clk,
  input        io_reset_n,
  output [7:0] io_out_data,
  output       io_out_valid,
  input        io_out_ready
);
  wire [7:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [7:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire  meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(8), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_out_data = meta_m_axis_tdata; // @[Meta.scala 31:41]
  assign io_out_valid = meta_m_axis_tvalid; // @[Meta.scala 32:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = io_out_ready; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = 8'h0; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 1'h1; // @[Meta.scala 44:41]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 1'h1; // @[Meta.scala 46:41]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = 1'h1; // @[Meta.scala 48:41]
endmodule
module XConverter_8(
  input        io_in_clk,
  input        io_out_clk,
  input        io_rstn,
  input        io_out_ready,
  output       io_out_valid,
  output [3:0] io_out_bits_id,
  output [1:0] io_out_bits_resp
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [7:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  SV_STREAM_FIFO_8 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io_out_bits_id = fifo_io_out_data[5:2]; // @[XConverter.scala 107:77]
  assign io_out_bits_resp = fifo_io_out_data[1:0]; // @[XConverter.scala 107:77]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_out_ready = io_out_ready; // @[XConverter.scala 109:41]
endmodule
module SV_STREAM_FIFO_9(
  input          io_m_clk,
  input          io_s_clk,
  input          io_reset_n,
  output [111:0] io_out_data,
  output         io_out_valid,
  input          io_out_ready
);
  wire [111:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [13:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [111:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [13:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [13:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(112), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_out_data = meta_m_axis_tdata; // @[Meta.scala 31:41]
  assign io_out_valid = meta_m_axis_tvalid; // @[Meta.scala 32:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = io_out_ready; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = 112'h0; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 14'h3fff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 14'h3fff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = 1'h0; // @[Meta.scala 48:41]
endmodule
module XConverter_9(
  input         io_in_clk,
  input         io_out_clk,
  input         io_rstn,
  input         io_out_ready,
  output        io_out_valid,
  output [63:0] io_out_bits_addr,
  output [1:0]  io_out_bits_burst,
  output [3:0]  io_out_bits_id,
  output [7:0]  io_out_bits_len,
  output [2:0]  io_out_bits_size
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [111:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  SV_STREAM_FIFO_9 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io_out_bits_addr = fifo_io_out_data[108:45]; // @[XConverter.scala 107:77]
  assign io_out_bits_burst = fifo_io_out_data[44:43]; // @[XConverter.scala 107:77]
  assign io_out_bits_id = fifo_io_out_data[38:35]; // @[XConverter.scala 107:77]
  assign io_out_bits_len = fifo_io_out_data[34:27]; // @[XConverter.scala 107:77]
  assign io_out_bits_size = fifo_io_out_data[14:12]; // @[XConverter.scala 107:77]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_out_ready = io_out_ready; // @[XConverter.scala 109:41]
endmodule
module SV_STREAM_FIFO_11(
  input          io_m_clk,
  input          io_s_clk,
  input          io_reset_n,
  output [647:0] io_out_data,
  output         io_out_valid,
  input          io_out_ready
);
  wire [647:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [80:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [647:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [80:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [80:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(648), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_out_data = meta_m_axis_tdata; // @[Meta.scala 31:41]
  assign io_out_valid = meta_m_axis_tvalid; // @[Meta.scala 32:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = io_out_ready; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = 648'h0; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 81'h1ffffffffffffffffffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 81'h1ffffffffffffffffffff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = 1'h0; // @[Meta.scala 48:41]
endmodule
module XConverter_11(
  input          io_in_clk,
  input          io_out_clk,
  input          io_rstn,
  input          io_out_ready,
  output         io_out_valid,
  output [511:0] io_out_bits_data,
  output         io_out_bits_last,
  output [63:0]  io_out_bits_strb
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [647:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  SV_STREAM_FIFO_11 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io_out_bits_data = fifo_io_out_data[640:129]; // @[XConverter.scala 107:77]
  assign io_out_bits_last = fifo_io_out_data[64]; // @[XConverter.scala 107:77]
  assign io_out_bits_strb = fifo_io_out_data[63:0]; // @[XConverter.scala 107:77]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_out_ready = io_out_ready; // @[XConverter.scala 109:41]
endmodule
module XConverter_12(
  input          io_in_clk,
  input          io_out_clk,
  input          io_rstn,
  output         io_in_ready,
  input          io_in_valid,
  input  [511:0] io_in_bits_data,
  input          io_in_bits_last,
  input  [1:0]   io_in_bits_resp,
  input  [3:0]   io_in_bits_id
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [583:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire [583:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  wire [582:0] _fifo_io_in_data_T = {io_in_bits_data,64'h0,io_in_bits_last,io_in_bits_resp,io_in_bits_id}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO_6 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{1'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io_in_valid; // @[XConverter.scala 104:41]
  assign fifo_io_out_ready = 1'h1; // @[XConverter.scala 109:41]
endmodule
module SV_STREAM_FIFO_13(
  input         io_m_clk,
  input         io_s_clk,
  input         io_reset_n,
  input  [71:0] io_in_data,
  input         io_in_valid,
  output        io_in_ready
);
  wire [71:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [8:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [71:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [8:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [8:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(72), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_in_ready = meta_s_axis_tready; // @[Meta.scala 34:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = 1'h1; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = io_in_data; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 9'h1ff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 9'h1ff; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = io_in_valid; // @[Meta.scala 48:41]
endmodule
module XConverter_13(
  input        io_in_clk,
  input        io_out_clk,
  input        io_rstn,
  output       io_in_ready,
  input        io_in_valid,
  input  [3:0] io_in_bits_id,
  input  [1:0] io_in_bits_resp
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [71:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire [69:0] _fifo_io_in_data_T = {io_in_bits_id,io_in_bits_resp,64'h0}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO_13 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready)
  );
  assign io_in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{2'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io_in_valid; // @[XConverter.scala 104:41]
endmodule
module SV_STREAM_FIFO_14(
  input         io_m_clk,
  input         io_s_clk,
  input         io_reset_n,
  input  [55:0] io_in_data,
  input         io_in_valid,
  output        io_in_ready,
  output [55:0] io_out_data,
  output        io_out_valid,
  input         io_out_ready
);
  wire [55:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [6:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [55:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [6:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [6:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(56), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_in_ready = meta_s_axis_tready; // @[Meta.scala 34:41]
  assign io_out_data = meta_m_axis_tdata; // @[Meta.scala 31:41]
  assign io_out_valid = meta_m_axis_tvalid; // @[Meta.scala 32:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = io_out_ready; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = io_in_data; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 7'h7f; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 7'h7f; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = io_in_valid; // @[Meta.scala 48:41]
endmodule
module XConverter_14(
  input         io_in_clk,
  input         io_out_clk,
  input         io_rstn,
  output        io_in_ready,
  input         io_in_valid,
  input  [31:0] io_in_bits_addr,
  input         io_out_ready,
  output        io_out_valid,
  output [31:0] io_out_bits_addr
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [55:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire [55:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  wire [52:0] _fifo_io_in_data_T = {io_in_bits_addr,2'h0,4'h0,1'h0,14'h0}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO_14 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign io_out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io_out_bits_addr = fifo_io_out_data[52:21]; // @[XConverter.scala 107:77]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{3'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io_in_valid; // @[XConverter.scala 104:41]
  assign fifo_io_out_ready = io_out_ready; // @[XConverter.scala 109:41]
endmodule
module SV_STREAM_FIFO_16(
  input         io_m_clk,
  input         io_s_clk,
  input         io_reset_n,
  input  [39:0] io_in_data,
  input         io_in_valid,
  output        io_in_ready,
  output [39:0] io_out_data,
  output        io_out_valid,
  input         io_out_ready
);
  wire [39:0] meta_m_axis_tdata; // @[Meta.scala 30:26]
  wire [4:0] meta_m_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_m_axis_tlast; // @[Meta.scala 30:26]
  wire  meta_m_axis_tvalid; // @[Meta.scala 30:26]
  wire [4:0] meta_rd_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_s_axis_tready; // @[Meta.scala 30:26]
  wire [4:0] meta_wr_data_count_axis; // @[Meta.scala 30:26]
  wire  meta_m_aclk; // @[Meta.scala 30:26]
  wire  meta_m_axis_tready; // @[Meta.scala 30:26]
  wire  meta_s_aclk; // @[Meta.scala 30:26]
  wire  meta_s_aresetn; // @[Meta.scala 30:26]
  wire [39:0] meta_s_axis_tdata; // @[Meta.scala 30:26]
  wire  meta_s_axis_tdest; // @[Meta.scala 30:26]
  wire  meta_s_axis_tid; // @[Meta.scala 30:26]
  wire [4:0] meta_s_axis_tkeep; // @[Meta.scala 30:26]
  wire  meta_s_axis_tlast; // @[Meta.scala 30:26]
  wire [4:0] meta_s_axis_tstrb; // @[Meta.scala 30:26]
  wire  meta_s_axis_tuser; // @[Meta.scala 30:26]
  wire  meta_s_axis_tvalid; // @[Meta.scala 30:26]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(5), .CLOCKING_MODE("independent_clock"), .PACKET_FIFO("false"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(16), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(5), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(40), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[Meta.scala 30:26]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_in_ready = meta_s_axis_tready; // @[Meta.scala 34:41]
  assign io_out_data = meta_m_axis_tdata; // @[Meta.scala 31:41]
  assign io_out_valid = meta_m_axis_tvalid; // @[Meta.scala 32:41]
  assign meta_m_aclk = io_m_clk; // @[Meta.scala 37:49]
  assign meta_m_axis_tready = io_out_ready; // @[Meta.scala 38:41]
  assign meta_s_aclk = io_s_clk; // @[Meta.scala 39:49]
  assign meta_s_aresetn = io_reset_n; // @[Meta.scala 40:49]
  assign meta_s_axis_tdata = io_in_data; // @[Meta.scala 41:41]
  assign meta_s_axis_tdest = 1'h0; // @[Meta.scala 42:41]
  assign meta_s_axis_tid = 1'h0; // @[Meta.scala 43:49]
  assign meta_s_axis_tkeep = 5'h1f; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tlast = 1'h1; // @[Meta.scala 45:41]
  assign meta_s_axis_tstrb = 5'h1f; // @[Bitwise.scala 72:12]
  assign meta_s_axis_tuser = 1'h0; // @[Meta.scala 47:41]
  assign meta_s_axis_tvalid = io_in_valid; // @[Meta.scala 48:41]
endmodule
module XConverter_16(
  input         io_in_clk,
  input         io_out_clk,
  input         io_rstn,
  output        io_in_ready,
  input         io_in_valid,
  input  [31:0] io_in_bits_data,
  input  [3:0]  io_in_bits_strb,
  input         io_out_ready,
  output        io_out_valid,
  output [31:0] io_out_bits_data
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [39:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire [39:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  wire [36:0] _fifo_io_in_data_T = {io_in_bits_data,1'h1,io_in_bits_strb}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO_16 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign io_out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io_out_bits_data = fifo_io_out_data[36:5]; // @[XConverter.scala 107:77]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{3'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io_in_valid; // @[XConverter.scala 104:41]
  assign fifo_io_out_ready = io_out_ready; // @[XConverter.scala 109:41]
endmodule
module XConverter_17(
  input         io_in_clk,
  input         io_out_clk,
  input         io_rstn,
  output        io_in_ready,
  input         io_in_valid,
  input  [31:0] io_in_bits_data,
  input         io_out_ready,
  output        io_out_valid,
  output [31:0] io_out_bits_data,
  output [1:0]  io_out_bits_resp
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [39:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire [39:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  wire [34:0] _fifo_io_in_data_T = {io_in_bits_data,1'h0,2'h0}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO_16 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign io_out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io_out_bits_data = fifo_io_out_data[34:3]; // @[XConverter.scala 107:77]
  assign io_out_bits_resp = fifo_io_out_data[1:0]; // @[XConverter.scala 107:77]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{5'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io_in_valid; // @[XConverter.scala 104:41]
  assign fifo_io_out_ready = io_out_ready; // @[XConverter.scala 109:41]
endmodule
module XConverter_18(
  input        io_in_clk,
  input        io_out_clk,
  input        io_rstn,
  input        io_out_ready,
  output       io_out_valid,
  output [1:0] io_out_bits_resp
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [7:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  SV_STREAM_FIFO_8 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io_out_bits_resp = fifo_io_out_data[1:0]; // @[XConverter.scala 107:77]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_out_ready = io_out_ready; // @[XConverter.scala 109:41]
endmodule
module Queue_2(
  input          clock,
  input          reset,
  input          io_deq_ready,
  output         io_deq_valid,
  output [511:0] io_deq_bits_data,
  output [31:0]  io_deq_bits_tcrc,
  output         io_deq_bits_ctrl_marker,
  output [6:0]   io_deq_bits_ctrl_ecc,
  output [31:0]  io_deq_bits_ctrl_len,
  output [2:0]   io_deq_bits_ctrl_port_id,
  output [10:0]  io_deq_bits_ctrl_qid,
  output         io_deq_bits_ctrl_has_cmpt,
  output         io_deq_bits_last,
  output [5:0]   io_deq_bits_mty
);
`ifdef RANDOMIZE_MEM_INIT
  reg [511:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_10;
`endif // RANDOMIZE_REG_INIT
  reg [511:0] ram_data [0:15]; // @[Decoupled.scala 218:16]
  wire [511:0] ram_data_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_data_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [511:0] ram_data_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_data_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_data_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_data_MPORT_en; // @[Decoupled.scala 218:16]
  reg [31:0] ram_tcrc [0:15]; // @[Decoupled.scala 218:16]
  wire [31:0] ram_tcrc_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_tcrc_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [31:0] ram_tcrc_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_tcrc_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_tcrc_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_tcrc_MPORT_en; // @[Decoupled.scala 218:16]
  reg  ram_ctrl_marker [0:15]; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_marker_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_marker_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_marker_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_marker_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_marker_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_marker_MPORT_en; // @[Decoupled.scala 218:16]
  reg [6:0] ram_ctrl_ecc [0:15]; // @[Decoupled.scala 218:16]
  wire [6:0] ram_ctrl_ecc_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_ecc_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [6:0] ram_ctrl_ecc_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_ecc_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_ecc_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_ecc_MPORT_en; // @[Decoupled.scala 218:16]
  reg [31:0] ram_ctrl_len [0:15]; // @[Decoupled.scala 218:16]
  wire [31:0] ram_ctrl_len_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_len_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [31:0] ram_ctrl_len_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_len_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_len_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_len_MPORT_en; // @[Decoupled.scala 218:16]
  reg [2:0] ram_ctrl_port_id [0:15]; // @[Decoupled.scala 218:16]
  wire [2:0] ram_ctrl_port_id_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_port_id_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [2:0] ram_ctrl_port_id_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_port_id_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_port_id_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_port_id_MPORT_en; // @[Decoupled.scala 218:16]
  reg [10:0] ram_ctrl_qid [0:15]; // @[Decoupled.scala 218:16]
  wire [10:0] ram_ctrl_qid_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_qid_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [10:0] ram_ctrl_qid_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_qid_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_qid_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_qid_MPORT_en; // @[Decoupled.scala 218:16]
  reg  ram_ctrl_has_cmpt [0:15]; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_has_cmpt_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_has_cmpt_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_has_cmpt_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_ctrl_has_cmpt_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_has_cmpt_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_ctrl_has_cmpt_MPORT_en; // @[Decoupled.scala 218:16]
  reg  ram_last [0:15]; // @[Decoupled.scala 218:16]
  wire  ram_last_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_last_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_last_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_last_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_last_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_last_MPORT_en; // @[Decoupled.scala 218:16]
  reg [5:0] ram_mty [0:15]; // @[Decoupled.scala 218:16]
  wire [5:0] ram_mty_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_mty_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [5:0] ram_mty_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_mty_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_mty_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_mty_MPORT_en; // @[Decoupled.scala 218:16]
  reg [3:0] deq_ptr_value; // @[Counter.scala 60:40]
  wire  ptr_match = 4'h0 == deq_ptr_value; // @[Decoupled.scala 223:33]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[Decoupled.scala 40:37]
  wire [3:0] _value_T_3 = deq_ptr_value + 4'h1; // @[Counter.scala 76:24]
  assign ram_data_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_data_io_deq_bits_MPORT_data = ram_data[ram_data_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_data_MPORT_data = 512'h0;
  assign ram_data_MPORT_addr = 4'h0;
  assign ram_data_MPORT_mask = 1'h1;
  assign ram_data_MPORT_en = 1'h0;
  assign ram_tcrc_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_tcrc_io_deq_bits_MPORT_data = ram_tcrc[ram_tcrc_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_tcrc_MPORT_data = 32'h0;
  assign ram_tcrc_MPORT_addr = 4'h0;
  assign ram_tcrc_MPORT_mask = 1'h1;
  assign ram_tcrc_MPORT_en = 1'h0;
  assign ram_ctrl_marker_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_ctrl_marker_io_deq_bits_MPORT_data = ram_ctrl_marker[ram_ctrl_marker_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_ctrl_marker_MPORT_data = 1'h0;
  assign ram_ctrl_marker_MPORT_addr = 4'h0;
  assign ram_ctrl_marker_MPORT_mask = 1'h1;
  assign ram_ctrl_marker_MPORT_en = 1'h0;
  assign ram_ctrl_ecc_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_ctrl_ecc_io_deq_bits_MPORT_data = ram_ctrl_ecc[ram_ctrl_ecc_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_ctrl_ecc_MPORT_data = 7'h0;
  assign ram_ctrl_ecc_MPORT_addr = 4'h0;
  assign ram_ctrl_ecc_MPORT_mask = 1'h1;
  assign ram_ctrl_ecc_MPORT_en = 1'h0;
  assign ram_ctrl_len_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_ctrl_len_io_deq_bits_MPORT_data = ram_ctrl_len[ram_ctrl_len_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_ctrl_len_MPORT_data = 32'h0;
  assign ram_ctrl_len_MPORT_addr = 4'h0;
  assign ram_ctrl_len_MPORT_mask = 1'h1;
  assign ram_ctrl_len_MPORT_en = 1'h0;
  assign ram_ctrl_port_id_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_ctrl_port_id_io_deq_bits_MPORT_data = ram_ctrl_port_id[ram_ctrl_port_id_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_ctrl_port_id_MPORT_data = 3'h0;
  assign ram_ctrl_port_id_MPORT_addr = 4'h0;
  assign ram_ctrl_port_id_MPORT_mask = 1'h1;
  assign ram_ctrl_port_id_MPORT_en = 1'h0;
  assign ram_ctrl_qid_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_ctrl_qid_io_deq_bits_MPORT_data = ram_ctrl_qid[ram_ctrl_qid_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_ctrl_qid_MPORT_data = 11'h0;
  assign ram_ctrl_qid_MPORT_addr = 4'h0;
  assign ram_ctrl_qid_MPORT_mask = 1'h1;
  assign ram_ctrl_qid_MPORT_en = 1'h0;
  assign ram_ctrl_has_cmpt_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_ctrl_has_cmpt_io_deq_bits_MPORT_data = ram_ctrl_has_cmpt[ram_ctrl_has_cmpt_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_ctrl_has_cmpt_MPORT_data = 1'h0;
  assign ram_ctrl_has_cmpt_MPORT_addr = 4'h0;
  assign ram_ctrl_has_cmpt_MPORT_mask = 1'h1;
  assign ram_ctrl_has_cmpt_MPORT_en = 1'h0;
  assign ram_last_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_last_io_deq_bits_MPORT_data = ram_last[ram_last_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_last_MPORT_data = 1'h0;
  assign ram_last_MPORT_addr = 4'h0;
  assign ram_last_MPORT_mask = 1'h1;
  assign ram_last_MPORT_en = 1'h0;
  assign ram_mty_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_mty_io_deq_bits_MPORT_data = ram_mty[ram_mty_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_mty_MPORT_data = 6'h0;
  assign ram_mty_MPORT_addr = 4'h0;
  assign ram_mty_MPORT_mask = 1'h1;
  assign ram_mty_MPORT_en = 1'h0;
  assign io_deq_valid = ~ptr_match; // @[Decoupled.scala 240:19]
  assign io_deq_bits_data = ram_data_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_tcrc = ram_tcrc_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_ctrl_marker = ram_ctrl_marker_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_ctrl_ecc = ram_ctrl_ecc_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_ctrl_len = ram_ctrl_len_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_ctrl_port_id = ram_ctrl_port_id_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_ctrl_qid = ram_ctrl_qid_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_ctrl_has_cmpt = ram_ctrl_has_cmpt_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_last = ram_last_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_mty = ram_mty_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  always @(posedge clock) begin
    if(ram_data_MPORT_en & ram_data_MPORT_mask) begin
      ram_data[ram_data_MPORT_addr] <= ram_data_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_tcrc_MPORT_en & ram_tcrc_MPORT_mask) begin
      ram_tcrc[ram_tcrc_MPORT_addr] <= ram_tcrc_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_ctrl_marker_MPORT_en & ram_ctrl_marker_MPORT_mask) begin
      ram_ctrl_marker[ram_ctrl_marker_MPORT_addr] <= ram_ctrl_marker_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_ctrl_ecc_MPORT_en & ram_ctrl_ecc_MPORT_mask) begin
      ram_ctrl_ecc[ram_ctrl_ecc_MPORT_addr] <= ram_ctrl_ecc_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_ctrl_len_MPORT_en & ram_ctrl_len_MPORT_mask) begin
      ram_ctrl_len[ram_ctrl_len_MPORT_addr] <= ram_ctrl_len_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_ctrl_port_id_MPORT_en & ram_ctrl_port_id_MPORT_mask) begin
      ram_ctrl_port_id[ram_ctrl_port_id_MPORT_addr] <= ram_ctrl_port_id_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_ctrl_qid_MPORT_en & ram_ctrl_qid_MPORT_mask) begin
      ram_ctrl_qid[ram_ctrl_qid_MPORT_addr] <= ram_ctrl_qid_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_ctrl_has_cmpt_MPORT_en & ram_ctrl_has_cmpt_MPORT_mask) begin
      ram_ctrl_has_cmpt[ram_ctrl_has_cmpt_MPORT_addr] <= ram_ctrl_has_cmpt_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_last_MPORT_en & ram_last_MPORT_mask) begin
      ram_last[ram_last_MPORT_addr] <= ram_last_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_mty_MPORT_en & ram_mty_MPORT_mask) begin
      ram_mty[ram_mty_MPORT_addr] <= ram_mty_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if (reset) begin // @[Counter.scala 60:40]
      deq_ptr_value <= 4'h0; // @[Counter.scala 60:40]
    end else if (do_deq) begin // @[Decoupled.scala 233:17]
      deq_ptr_value <= _value_T_3; // @[Counter.scala 76:15]
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
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {16{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_data[initvar] = _RAND_0[511:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_tcrc[initvar] = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_ctrl_marker[initvar] = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_ctrl_ecc[initvar] = _RAND_3[6:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_ctrl_len[initvar] = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_ctrl_port_id[initvar] = _RAND_5[2:0];
  _RAND_6 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_ctrl_qid[initvar] = _RAND_6[10:0];
  _RAND_7 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_ctrl_has_cmpt[initvar] = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_last[initvar] = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_mty[initvar] = _RAND_9[5:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  deq_ptr_value = _RAND_10[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module XQueue(
  input          clock,
  input          reset,
  input          io_out_ready,
  output         io_out_valid,
  output [511:0] io_out_bits_data,
  output [31:0]  io_out_bits_tcrc,
  output         io_out_bits_ctrl_marker,
  output [6:0]   io_out_bits_ctrl_ecc,
  output [31:0]  io_out_bits_ctrl_len,
  output [2:0]   io_out_bits_ctrl_port_id,
  output [10:0]  io_out_bits_ctrl_qid,
  output         io_out_bits_ctrl_has_cmpt,
  output         io_out_bits_last,
  output [5:0]   io_out_bits_mty
);
  wire  q_clock; // @[XQueue.scala 85:39]
  wire  q_reset; // @[XQueue.scala 85:39]
  wire  q_io_deq_ready; // @[XQueue.scala 85:39]
  wire  q_io_deq_valid; // @[XQueue.scala 85:39]
  wire [511:0] q_io_deq_bits_data; // @[XQueue.scala 85:39]
  wire [31:0] q_io_deq_bits_tcrc; // @[XQueue.scala 85:39]
  wire  q_io_deq_bits_ctrl_marker; // @[XQueue.scala 85:39]
  wire [6:0] q_io_deq_bits_ctrl_ecc; // @[XQueue.scala 85:39]
  wire [31:0] q_io_deq_bits_ctrl_len; // @[XQueue.scala 85:39]
  wire [2:0] q_io_deq_bits_ctrl_port_id; // @[XQueue.scala 85:39]
  wire [10:0] q_io_deq_bits_ctrl_qid; // @[XQueue.scala 85:39]
  wire  q_io_deq_bits_ctrl_has_cmpt; // @[XQueue.scala 85:39]
  wire  q_io_deq_bits_last; // @[XQueue.scala 85:39]
  wire [5:0] q_io_deq_bits_mty; // @[XQueue.scala 85:39]
  Queue_2 q ( // @[XQueue.scala 85:39]
    .clock(q_clock),
    .reset(q_reset),
    .io_deq_ready(q_io_deq_ready),
    .io_deq_valid(q_io_deq_valid),
    .io_deq_bits_data(q_io_deq_bits_data),
    .io_deq_bits_tcrc(q_io_deq_bits_tcrc),
    .io_deq_bits_ctrl_marker(q_io_deq_bits_ctrl_marker),
    .io_deq_bits_ctrl_ecc(q_io_deq_bits_ctrl_ecc),
    .io_deq_bits_ctrl_len(q_io_deq_bits_ctrl_len),
    .io_deq_bits_ctrl_port_id(q_io_deq_bits_ctrl_port_id),
    .io_deq_bits_ctrl_qid(q_io_deq_bits_ctrl_qid),
    .io_deq_bits_ctrl_has_cmpt(q_io_deq_bits_ctrl_has_cmpt),
    .io_deq_bits_last(q_io_deq_bits_last),
    .io_deq_bits_mty(q_io_deq_bits_mty)
  );
  assign io_out_valid = q_io_deq_valid; // @[XQueue.scala 88:34]
  assign io_out_bits_data = q_io_deq_bits_data; // @[XQueue.scala 88:34]
  assign io_out_bits_tcrc = q_io_deq_bits_tcrc; // @[XQueue.scala 88:34]
  assign io_out_bits_ctrl_marker = q_io_deq_bits_ctrl_marker; // @[XQueue.scala 88:34]
  assign io_out_bits_ctrl_ecc = q_io_deq_bits_ctrl_ecc; // @[XQueue.scala 88:34]
  assign io_out_bits_ctrl_len = q_io_deq_bits_ctrl_len; // @[XQueue.scala 88:34]
  assign io_out_bits_ctrl_port_id = q_io_deq_bits_ctrl_port_id; // @[XQueue.scala 88:34]
  assign io_out_bits_ctrl_qid = q_io_deq_bits_ctrl_qid; // @[XQueue.scala 88:34]
  assign io_out_bits_ctrl_has_cmpt = q_io_deq_bits_ctrl_has_cmpt; // @[XQueue.scala 88:34]
  assign io_out_bits_last = q_io_deq_bits_last; // @[XQueue.scala 88:34]
  assign io_out_bits_mty = q_io_deq_bits_mty; // @[XQueue.scala 88:34]
  assign q_clock = clock;
  assign q_reset = reset;
  assign q_io_deq_ready = io_out_ready; // @[XQueue.scala 88:34]
endmodule
module Queue_3(
  input         clock,
  input         reset,
  output        io_enq_ready,
  input         io_enq_valid,
  input  [63:0] io_enq_bits_addr,
  input  [10:0] io_enq_bits_qid,
  input         io_enq_bits_error,
  input  [7:0]  io_enq_bits_func,
  input  [2:0]  io_enq_bits_port_id,
  input  [6:0]  io_enq_bits_pfch_tag,
  input  [31:0] io_enq_bits_len,
  input         io_deq_ready,
  output        io_deq_valid,
  output [63:0] io_deq_bits_addr,
  output [10:0] io_deq_bits_qid,
  output        io_deq_bits_error,
  output [7:0]  io_deq_bits_func,
  output [2:0]  io_deq_bits_port_id,
  output [6:0]  io_deq_bits_pfch_tag,
  output [31:0] io_deq_bits_len
);
`ifdef RANDOMIZE_MEM_INIT
  reg [63:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] ram_addr [0:15]; // @[Decoupled.scala 218:16]
  wire [63:0] ram_addr_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_addr_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [63:0] ram_addr_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_addr_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_addr_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_addr_MPORT_en; // @[Decoupled.scala 218:16]
  reg [10:0] ram_qid [0:15]; // @[Decoupled.scala 218:16]
  wire [10:0] ram_qid_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_qid_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [10:0] ram_qid_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_qid_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_qid_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_qid_MPORT_en; // @[Decoupled.scala 218:16]
  reg  ram_error [0:15]; // @[Decoupled.scala 218:16]
  wire  ram_error_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_error_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_error_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_error_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_error_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_error_MPORT_en; // @[Decoupled.scala 218:16]
  reg [7:0] ram_func [0:15]; // @[Decoupled.scala 218:16]
  wire [7:0] ram_func_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_func_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [7:0] ram_func_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_func_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_func_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_func_MPORT_en; // @[Decoupled.scala 218:16]
  reg [2:0] ram_port_id [0:15]; // @[Decoupled.scala 218:16]
  wire [2:0] ram_port_id_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_port_id_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [2:0] ram_port_id_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_port_id_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_port_id_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_port_id_MPORT_en; // @[Decoupled.scala 218:16]
  reg [6:0] ram_pfch_tag [0:15]; // @[Decoupled.scala 218:16]
  wire [6:0] ram_pfch_tag_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_pfch_tag_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [6:0] ram_pfch_tag_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_pfch_tag_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_pfch_tag_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_pfch_tag_MPORT_en; // @[Decoupled.scala 218:16]
  reg [31:0] ram_len [0:15]; // @[Decoupled.scala 218:16]
  wire [31:0] ram_len_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_len_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [31:0] ram_len_MPORT_data; // @[Decoupled.scala 218:16]
  wire [3:0] ram_len_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_len_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_len_MPORT_en; // @[Decoupled.scala 218:16]
  reg [3:0] enq_ptr_value; // @[Counter.scala 60:40]
  reg [3:0] deq_ptr_value; // @[Counter.scala 60:40]
  reg  maybe_full; // @[Decoupled.scala 221:27]
  wire  ptr_match = enq_ptr_value == deq_ptr_value; // @[Decoupled.scala 223:33]
  wire  empty = ptr_match & ~maybe_full; // @[Decoupled.scala 224:25]
  wire  full = ptr_match & maybe_full; // @[Decoupled.scala 225:24]
  wire  do_enq = io_enq_ready & io_enq_valid; // @[Decoupled.scala 40:37]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[Decoupled.scala 40:37]
  wire [3:0] _value_T_1 = enq_ptr_value + 4'h1; // @[Counter.scala 76:24]
  wire [3:0] _value_T_3 = deq_ptr_value + 4'h1; // @[Counter.scala 76:24]
  assign ram_addr_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_addr_io_deq_bits_MPORT_data = ram_addr[ram_addr_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_addr_MPORT_data = io_enq_bits_addr;
  assign ram_addr_MPORT_addr = enq_ptr_value;
  assign ram_addr_MPORT_mask = 1'h1;
  assign ram_addr_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_qid_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_qid_io_deq_bits_MPORT_data = ram_qid[ram_qid_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_qid_MPORT_data = io_enq_bits_qid;
  assign ram_qid_MPORT_addr = enq_ptr_value;
  assign ram_qid_MPORT_mask = 1'h1;
  assign ram_qid_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_error_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_error_io_deq_bits_MPORT_data = ram_error[ram_error_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_error_MPORT_data = io_enq_bits_error;
  assign ram_error_MPORT_addr = enq_ptr_value;
  assign ram_error_MPORT_mask = 1'h1;
  assign ram_error_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_func_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_func_io_deq_bits_MPORT_data = ram_func[ram_func_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_func_MPORT_data = io_enq_bits_func;
  assign ram_func_MPORT_addr = enq_ptr_value;
  assign ram_func_MPORT_mask = 1'h1;
  assign ram_func_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_port_id_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_port_id_io_deq_bits_MPORT_data = ram_port_id[ram_port_id_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_port_id_MPORT_data = io_enq_bits_port_id;
  assign ram_port_id_MPORT_addr = enq_ptr_value;
  assign ram_port_id_MPORT_mask = 1'h1;
  assign ram_port_id_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_pfch_tag_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_pfch_tag_io_deq_bits_MPORT_data = ram_pfch_tag[ram_pfch_tag_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_pfch_tag_MPORT_data = io_enq_bits_pfch_tag;
  assign ram_pfch_tag_MPORT_addr = enq_ptr_value;
  assign ram_pfch_tag_MPORT_mask = 1'h1;
  assign ram_pfch_tag_MPORT_en = io_enq_ready & io_enq_valid;
  assign ram_len_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_len_io_deq_bits_MPORT_data = ram_len[ram_len_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_len_MPORT_data = io_enq_bits_len;
  assign ram_len_MPORT_addr = enq_ptr_value;
  assign ram_len_MPORT_mask = 1'h1;
  assign ram_len_MPORT_en = io_enq_ready & io_enq_valid;
  assign io_enq_ready = ~full; // @[Decoupled.scala 241:19]
  assign io_deq_valid = ~empty; // @[Decoupled.scala 240:19]
  assign io_deq_bits_addr = ram_addr_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_qid = ram_qid_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_error = ram_error_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_func = ram_func_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_port_id = ram_port_id_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_pfch_tag = ram_pfch_tag_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  assign io_deq_bits_len = ram_len_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  always @(posedge clock) begin
    if(ram_addr_MPORT_en & ram_addr_MPORT_mask) begin
      ram_addr[ram_addr_MPORT_addr] <= ram_addr_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_qid_MPORT_en & ram_qid_MPORT_mask) begin
      ram_qid[ram_qid_MPORT_addr] <= ram_qid_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_error_MPORT_en & ram_error_MPORT_mask) begin
      ram_error[ram_error_MPORT_addr] <= ram_error_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_func_MPORT_en & ram_func_MPORT_mask) begin
      ram_func[ram_func_MPORT_addr] <= ram_func_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_port_id_MPORT_en & ram_port_id_MPORT_mask) begin
      ram_port_id[ram_port_id_MPORT_addr] <= ram_port_id_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_pfch_tag_MPORT_en & ram_pfch_tag_MPORT_mask) begin
      ram_pfch_tag[ram_pfch_tag_MPORT_addr] <= ram_pfch_tag_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if(ram_len_MPORT_en & ram_len_MPORT_mask) begin
      ram_len[ram_len_MPORT_addr] <= ram_len_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if (reset) begin // @[Counter.scala 60:40]
      enq_ptr_value <= 4'h0; // @[Counter.scala 60:40]
    end else if (do_enq) begin // @[Decoupled.scala 229:17]
      enq_ptr_value <= _value_T_1; // @[Counter.scala 76:15]
    end
    if (reset) begin // @[Counter.scala 60:40]
      deq_ptr_value <= 4'h0; // @[Counter.scala 60:40]
    end else if (do_deq) begin // @[Decoupled.scala 233:17]
      deq_ptr_value <= _value_T_3; // @[Counter.scala 76:15]
    end
    if (reset) begin // @[Decoupled.scala 221:27]
      maybe_full <= 1'h0; // @[Decoupled.scala 221:27]
    end else if (do_enq != do_deq) begin // @[Decoupled.scala 236:28]
      maybe_full <= do_enq; // @[Decoupled.scala 237:16]
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
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {2{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_addr[initvar] = _RAND_0[63:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_qid[initvar] = _RAND_1[10:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_error[initvar] = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_func[initvar] = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_port_id[initvar] = _RAND_4[2:0];
  _RAND_5 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_pfch_tag[initvar] = _RAND_5[6:0];
  _RAND_6 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram_len[initvar] = _RAND_6[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  enq_ptr_value = _RAND_7[3:0];
  _RAND_8 = {1{`RANDOM}};
  deq_ptr_value = _RAND_8[3:0];
  _RAND_9 = {1{`RANDOM}};
  maybe_full = _RAND_9[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module XQueue_1(
  input         clock,
  input         reset,
  output        io_in_ready,
  input         io_in_valid,
  input  [63:0] io_in_bits_addr,
  input  [10:0] io_in_bits_qid,
  input         io_in_bits_error,
  input  [7:0]  io_in_bits_func,
  input  [2:0]  io_in_bits_port_id,
  input  [6:0]  io_in_bits_pfch_tag,
  input  [31:0] io_in_bits_len,
  input         io_out_ready,
  output        io_out_valid,
  output [63:0] io_out_bits_addr,
  output [10:0] io_out_bits_qid,
  output        io_out_bits_error,
  output [7:0]  io_out_bits_func,
  output [2:0]  io_out_bits_port_id,
  output [6:0]  io_out_bits_pfch_tag,
  output [31:0] io_out_bits_len
);
  wire  q_clock; // @[XQueue.scala 85:39]
  wire  q_reset; // @[XQueue.scala 85:39]
  wire  q_io_enq_ready; // @[XQueue.scala 85:39]
  wire  q_io_enq_valid; // @[XQueue.scala 85:39]
  wire [63:0] q_io_enq_bits_addr; // @[XQueue.scala 85:39]
  wire [10:0] q_io_enq_bits_qid; // @[XQueue.scala 85:39]
  wire  q_io_enq_bits_error; // @[XQueue.scala 85:39]
  wire [7:0] q_io_enq_bits_func; // @[XQueue.scala 85:39]
  wire [2:0] q_io_enq_bits_port_id; // @[XQueue.scala 85:39]
  wire [6:0] q_io_enq_bits_pfch_tag; // @[XQueue.scala 85:39]
  wire [31:0] q_io_enq_bits_len; // @[XQueue.scala 85:39]
  wire  q_io_deq_ready; // @[XQueue.scala 85:39]
  wire  q_io_deq_valid; // @[XQueue.scala 85:39]
  wire [63:0] q_io_deq_bits_addr; // @[XQueue.scala 85:39]
  wire [10:0] q_io_deq_bits_qid; // @[XQueue.scala 85:39]
  wire  q_io_deq_bits_error; // @[XQueue.scala 85:39]
  wire [7:0] q_io_deq_bits_func; // @[XQueue.scala 85:39]
  wire [2:0] q_io_deq_bits_port_id; // @[XQueue.scala 85:39]
  wire [6:0] q_io_deq_bits_pfch_tag; // @[XQueue.scala 85:39]
  wire [31:0] q_io_deq_bits_len; // @[XQueue.scala 85:39]
  Queue_3 q ( // @[XQueue.scala 85:39]
    .clock(q_clock),
    .reset(q_reset),
    .io_enq_ready(q_io_enq_ready),
    .io_enq_valid(q_io_enq_valid),
    .io_enq_bits_addr(q_io_enq_bits_addr),
    .io_enq_bits_qid(q_io_enq_bits_qid),
    .io_enq_bits_error(q_io_enq_bits_error),
    .io_enq_bits_func(q_io_enq_bits_func),
    .io_enq_bits_port_id(q_io_enq_bits_port_id),
    .io_enq_bits_pfch_tag(q_io_enq_bits_pfch_tag),
    .io_enq_bits_len(q_io_enq_bits_len),
    .io_deq_ready(q_io_deq_ready),
    .io_deq_valid(q_io_deq_valid),
    .io_deq_bits_addr(q_io_deq_bits_addr),
    .io_deq_bits_qid(q_io_deq_bits_qid),
    .io_deq_bits_error(q_io_deq_bits_error),
    .io_deq_bits_func(q_io_deq_bits_func),
    .io_deq_bits_port_id(q_io_deq_bits_port_id),
    .io_deq_bits_pfch_tag(q_io_deq_bits_pfch_tag),
    .io_deq_bits_len(q_io_deq_bits_len)
  );
  assign io_in_ready = q_io_enq_ready; // @[XQueue.scala 87:34]
  assign io_out_valid = q_io_deq_valid; // @[XQueue.scala 88:34]
  assign io_out_bits_addr = q_io_deq_bits_addr; // @[XQueue.scala 88:34]
  assign io_out_bits_qid = q_io_deq_bits_qid; // @[XQueue.scala 88:34]
  assign io_out_bits_error = q_io_deq_bits_error; // @[XQueue.scala 88:34]
  assign io_out_bits_func = q_io_deq_bits_func; // @[XQueue.scala 88:34]
  assign io_out_bits_port_id = q_io_deq_bits_port_id; // @[XQueue.scala 88:34]
  assign io_out_bits_pfch_tag = q_io_deq_bits_pfch_tag; // @[XQueue.scala 88:34]
  assign io_out_bits_len = q_io_deq_bits_len; // @[XQueue.scala 88:34]
  assign q_clock = clock;
  assign q_reset = reset;
  assign q_io_enq_valid = io_in_valid; // @[XQueue.scala 87:34]
  assign q_io_enq_bits_addr = io_in_bits_addr; // @[XQueue.scala 87:34]
  assign q_io_enq_bits_qid = io_in_bits_qid; // @[XQueue.scala 87:34]
  assign q_io_enq_bits_error = io_in_bits_error; // @[XQueue.scala 87:34]
  assign q_io_enq_bits_func = io_in_bits_func; // @[XQueue.scala 87:34]
  assign q_io_enq_bits_port_id = io_in_bits_port_id; // @[XQueue.scala 87:34]
  assign q_io_enq_bits_pfch_tag = io_in_bits_pfch_tag; // @[XQueue.scala 87:34]
  assign q_io_enq_bits_len = io_in_bits_len; // @[XQueue.scala 87:34]
  assign q_io_deq_ready = io_out_ready; // @[XQueue.scala 88:34]
endmodule
module DataBoundarySplit(
  input          clock,
  input          reset,
  output         io_cmd_in_ready,
  input          io_cmd_in_valid,
  input  [63:0]  io_cmd_in_bits_addr,
  input  [10:0]  io_cmd_in_bits_qid,
  input          io_cmd_in_bits_error,
  input  [7:0]   io_cmd_in_bits_func,
  input  [2:0]   io_cmd_in_bits_port_id,
  input  [6:0]   io_cmd_in_bits_pfch_tag,
  input  [31:0]  io_cmd_in_bits_len,
  input          io_data_out_ready,
  output         io_data_out_valid,
  output [511:0] io_data_out_bits_data,
  output [31:0]  io_data_out_bits_tcrc,
  output         io_data_out_bits_ctrl_marker,
  output [6:0]   io_data_out_bits_ctrl_ecc,
  output [31:0]  io_data_out_bits_ctrl_len,
  output [2:0]   io_data_out_bits_ctrl_port_id,
  output [10:0]  io_data_out_bits_ctrl_qid,
  output         io_data_out_bits_ctrl_has_cmpt,
  output         io_data_out_bits_last,
  output [5:0]   io_data_out_bits_mty,
  input          io_cmd_out_ready,
  output         io_cmd_out_valid,
  output [63:0]  io_cmd_out_bits_addr,
  output [10:0]  io_cmd_out_bits_qid,
  output         io_cmd_out_bits_error,
  output [7:0]   io_cmd_out_bits_func,
  output [2:0]   io_cmd_out_bits_port_id,
  output [6:0]   io_cmd_out_bits_pfch_tag,
  output [31:0]  io_cmd_out_bits_len
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire  data_fifo_clock; // @[XQueue.scala 35:23]
  wire  data_fifo_reset; // @[XQueue.scala 35:23]
  wire  data_fifo_io_out_ready; // @[XQueue.scala 35:23]
  wire  data_fifo_io_out_valid; // @[XQueue.scala 35:23]
  wire [511:0] data_fifo_io_out_bits_data; // @[XQueue.scala 35:23]
  wire [31:0] data_fifo_io_out_bits_tcrc; // @[XQueue.scala 35:23]
  wire  data_fifo_io_out_bits_ctrl_marker; // @[XQueue.scala 35:23]
  wire [6:0] data_fifo_io_out_bits_ctrl_ecc; // @[XQueue.scala 35:23]
  wire [31:0] data_fifo_io_out_bits_ctrl_len; // @[XQueue.scala 35:23]
  wire [2:0] data_fifo_io_out_bits_ctrl_port_id; // @[XQueue.scala 35:23]
  wire [10:0] data_fifo_io_out_bits_ctrl_qid; // @[XQueue.scala 35:23]
  wire  data_fifo_io_out_bits_ctrl_has_cmpt; // @[XQueue.scala 35:23]
  wire  data_fifo_io_out_bits_last; // @[XQueue.scala 35:23]
  wire [5:0] data_fifo_io_out_bits_mty; // @[XQueue.scala 35:23]
  wire  cmd_fifo_clock; // @[XQueue.scala 35:23]
  wire  cmd_fifo_reset; // @[XQueue.scala 35:23]
  wire  cmd_fifo_io_in_ready; // @[XQueue.scala 35:23]
  wire  cmd_fifo_io_in_valid; // @[XQueue.scala 35:23]
  wire [63:0] cmd_fifo_io_in_bits_addr; // @[XQueue.scala 35:23]
  wire [10:0] cmd_fifo_io_in_bits_qid; // @[XQueue.scala 35:23]
  wire  cmd_fifo_io_in_bits_error; // @[XQueue.scala 35:23]
  wire [7:0] cmd_fifo_io_in_bits_func; // @[XQueue.scala 35:23]
  wire [2:0] cmd_fifo_io_in_bits_port_id; // @[XQueue.scala 35:23]
  wire [6:0] cmd_fifo_io_in_bits_pfch_tag; // @[XQueue.scala 35:23]
  wire [31:0] cmd_fifo_io_in_bits_len; // @[XQueue.scala 35:23]
  wire  cmd_fifo_io_out_ready; // @[XQueue.scala 35:23]
  wire  cmd_fifo_io_out_valid; // @[XQueue.scala 35:23]
  wire [63:0] cmd_fifo_io_out_bits_addr; // @[XQueue.scala 35:23]
  wire [10:0] cmd_fifo_io_out_bits_qid; // @[XQueue.scala 35:23]
  wire  cmd_fifo_io_out_bits_error; // @[XQueue.scala 35:23]
  wire [7:0] cmd_fifo_io_out_bits_func; // @[XQueue.scala 35:23]
  wire [2:0] cmd_fifo_io_out_bits_port_id; // @[XQueue.scala 35:23]
  wire [6:0] cmd_fifo_io_out_bits_pfch_tag; // @[XQueue.scala 35:23]
  wire [31:0] cmd_fifo_io_out_bits_len; // @[XQueue.scala 35:23]
  reg  state; // @[CheckSplit.scala 27:50]
  wire  _io_cmd_in_ready_T = ~state; // @[CheckSplit.scala 29:67]
  wire  _T_1 = io_cmd_in_ready & io_cmd_in_valid; // @[Decoupled.scala 40:37]
  wire  _GEN_7 = _T_1 | state; // @[CheckSplit.scala 39:47 CheckSplit.scala 41:41 CheckSplit.scala 27:50]
  wire [31:0] _GEN_9 = _T_1 ? io_cmd_in_bits_len : 32'h0; // @[CheckSplit.scala 39:47 CheckSplit.scala 43:65 CheckSplit.scala 35:65]
  wire [6:0] _GEN_10 = _T_1 ? io_cmd_in_bits_pfch_tag : 7'h0; // @[CheckSplit.scala 39:47 CheckSplit.scala 43:65 CheckSplit.scala 35:65]
  wire [2:0] _GEN_11 = _T_1 ? io_cmd_in_bits_port_id : 3'h0; // @[CheckSplit.scala 39:47 CheckSplit.scala 43:65 CheckSplit.scala 35:65]
  wire [7:0] _GEN_12 = _T_1 ? io_cmd_in_bits_func : 8'h0; // @[CheckSplit.scala 39:47 CheckSplit.scala 43:65 CheckSplit.scala 35:65]
  wire  _GEN_13 = _T_1 & io_cmd_in_bits_error; // @[CheckSplit.scala 39:47 CheckSplit.scala 43:65 CheckSplit.scala 35:65]
  wire [10:0] _GEN_14 = _T_1 ? io_cmd_in_bits_qid : 11'h0; // @[CheckSplit.scala 39:47 CheckSplit.scala 43:65 CheckSplit.scala 35:65]
  wire [63:0] _GEN_15 = _T_1 ? io_cmd_in_bits_addr : 64'h0; // @[CheckSplit.scala 39:47 CheckSplit.scala 43:65 CheckSplit.scala 35:65]
  XQueue data_fifo ( // @[XQueue.scala 35:23]
    .clock(data_fifo_clock),
    .reset(data_fifo_reset),
    .io_out_ready(data_fifo_io_out_ready),
    .io_out_valid(data_fifo_io_out_valid),
    .io_out_bits_data(data_fifo_io_out_bits_data),
    .io_out_bits_tcrc(data_fifo_io_out_bits_tcrc),
    .io_out_bits_ctrl_marker(data_fifo_io_out_bits_ctrl_marker),
    .io_out_bits_ctrl_ecc(data_fifo_io_out_bits_ctrl_ecc),
    .io_out_bits_ctrl_len(data_fifo_io_out_bits_ctrl_len),
    .io_out_bits_ctrl_port_id(data_fifo_io_out_bits_ctrl_port_id),
    .io_out_bits_ctrl_qid(data_fifo_io_out_bits_ctrl_qid),
    .io_out_bits_ctrl_has_cmpt(data_fifo_io_out_bits_ctrl_has_cmpt),
    .io_out_bits_last(data_fifo_io_out_bits_last),
    .io_out_bits_mty(data_fifo_io_out_bits_mty)
  );
  XQueue_1 cmd_fifo ( // @[XQueue.scala 35:23]
    .clock(cmd_fifo_clock),
    .reset(cmd_fifo_reset),
    .io_in_ready(cmd_fifo_io_in_ready),
    .io_in_valid(cmd_fifo_io_in_valid),
    .io_in_bits_addr(cmd_fifo_io_in_bits_addr),
    .io_in_bits_qid(cmd_fifo_io_in_bits_qid),
    .io_in_bits_error(cmd_fifo_io_in_bits_error),
    .io_in_bits_func(cmd_fifo_io_in_bits_func),
    .io_in_bits_port_id(cmd_fifo_io_in_bits_port_id),
    .io_in_bits_pfch_tag(cmd_fifo_io_in_bits_pfch_tag),
    .io_in_bits_len(cmd_fifo_io_in_bits_len),
    .io_out_ready(cmd_fifo_io_out_ready),
    .io_out_valid(cmd_fifo_io_out_valid),
    .io_out_bits_addr(cmd_fifo_io_out_bits_addr),
    .io_out_bits_qid(cmd_fifo_io_out_bits_qid),
    .io_out_bits_error(cmd_fifo_io_out_bits_error),
    .io_out_bits_func(cmd_fifo_io_out_bits_func),
    .io_out_bits_port_id(cmd_fifo_io_out_bits_port_id),
    .io_out_bits_pfch_tag(cmd_fifo_io_out_bits_pfch_tag),
    .io_out_bits_len(cmd_fifo_io_out_bits_len)
  );
  assign io_cmd_in_ready = ~state & cmd_fifo_io_in_ready; // @[CheckSplit.scala 29:78]
  assign io_data_out_valid = data_fifo_io_out_valid; // @[CheckSplit.scala 23:25]
  assign io_data_out_bits_data = data_fifo_io_out_bits_data; // @[CheckSplit.scala 23:25]
  assign io_data_out_bits_tcrc = data_fifo_io_out_bits_tcrc; // @[CheckSplit.scala 23:25]
  assign io_data_out_bits_ctrl_marker = data_fifo_io_out_bits_ctrl_marker; // @[CheckSplit.scala 23:25]
  assign io_data_out_bits_ctrl_ecc = data_fifo_io_out_bits_ctrl_ecc; // @[CheckSplit.scala 23:25]
  assign io_data_out_bits_ctrl_len = data_fifo_io_out_bits_ctrl_len; // @[CheckSplit.scala 23:25]
  assign io_data_out_bits_ctrl_port_id = data_fifo_io_out_bits_ctrl_port_id; // @[CheckSplit.scala 23:25]
  assign io_data_out_bits_ctrl_qid = data_fifo_io_out_bits_ctrl_qid; // @[CheckSplit.scala 23:25]
  assign io_data_out_bits_ctrl_has_cmpt = data_fifo_io_out_bits_ctrl_has_cmpt; // @[CheckSplit.scala 23:25]
  assign io_data_out_bits_last = data_fifo_io_out_bits_last; // @[CheckSplit.scala 23:25]
  assign io_data_out_bits_mty = data_fifo_io_out_bits_mty; // @[CheckSplit.scala 23:25]
  assign io_cmd_out_valid = cmd_fifo_io_out_valid; // @[CheckSplit.scala 24:25]
  assign io_cmd_out_bits_addr = cmd_fifo_io_out_bits_addr; // @[CheckSplit.scala 24:25]
  assign io_cmd_out_bits_qid = cmd_fifo_io_out_bits_qid; // @[CheckSplit.scala 24:25]
  assign io_cmd_out_bits_error = cmd_fifo_io_out_bits_error; // @[CheckSplit.scala 24:25]
  assign io_cmd_out_bits_func = cmd_fifo_io_out_bits_func; // @[CheckSplit.scala 24:25]
  assign io_cmd_out_bits_port_id = cmd_fifo_io_out_bits_port_id; // @[CheckSplit.scala 24:25]
  assign io_cmd_out_bits_pfch_tag = cmd_fifo_io_out_bits_pfch_tag; // @[CheckSplit.scala 24:25]
  assign io_cmd_out_bits_len = cmd_fifo_io_out_bits_len; // @[CheckSplit.scala 24:25]
  assign data_fifo_clock = clock;
  assign data_fifo_reset = reset;
  assign data_fifo_io_out_ready = io_data_out_ready; // @[CheckSplit.scala 23:25]
  assign cmd_fifo_clock = clock;
  assign cmd_fifo_reset = reset;
  assign cmd_fifo_io_in_valid = _io_cmd_in_ready_T & _T_1; // @[Conditional.scala 40:58 CheckSplit.scala 34:57]
  assign cmd_fifo_io_in_bits_addr = _io_cmd_in_ready_T ? _GEN_15 : 64'h0; // @[Conditional.scala 40:58 CheckSplit.scala 35:65]
  assign cmd_fifo_io_in_bits_qid = _io_cmd_in_ready_T ? _GEN_14 : 11'h0; // @[Conditional.scala 40:58 CheckSplit.scala 35:65]
  assign cmd_fifo_io_in_bits_error = _io_cmd_in_ready_T & _GEN_13; // @[Conditional.scala 40:58 CheckSplit.scala 35:65]
  assign cmd_fifo_io_in_bits_func = _io_cmd_in_ready_T ? _GEN_12 : 8'h0; // @[Conditional.scala 40:58 CheckSplit.scala 35:65]
  assign cmd_fifo_io_in_bits_port_id = _io_cmd_in_ready_T ? _GEN_11 : 3'h0; // @[Conditional.scala 40:58 CheckSplit.scala 35:65]
  assign cmd_fifo_io_in_bits_pfch_tag = _io_cmd_in_ready_T ? _GEN_10 : 7'h0; // @[Conditional.scala 40:58 CheckSplit.scala 35:65]
  assign cmd_fifo_io_in_bits_len = _io_cmd_in_ready_T ? _GEN_9 : 32'h0; // @[Conditional.scala 40:58 CheckSplit.scala 35:65]
  assign cmd_fifo_io_out_ready = io_cmd_out_ready; // @[CheckSplit.scala 24:25]
  always @(posedge clock) begin
    if (reset) begin // @[CheckSplit.scala 27:50]
      state <= 1'h0; // @[CheckSplit.scala 27:50]
    end else if (_io_cmd_in_ready_T) begin // @[Conditional.scala 40:58]
      state <= _GEN_7;
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
  state = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module QDMADynamic(
  input          io_qdma_port_axi_aclk,
  input          io_qdma_port_axi_aresetn,
  input  [3:0]   io_qdma_port_m_axib_awid,
  input  [63:0]  io_qdma_port_m_axib_awaddr,
  input  [7:0]   io_qdma_port_m_axib_awlen,
  input  [2:0]   io_qdma_port_m_axib_awsize,
  input  [1:0]   io_qdma_port_m_axib_awburst,
  input  [2:0]   io_qdma_port_m_axib_awprot,
  input          io_qdma_port_m_axib_awlock,
  input  [3:0]   io_qdma_port_m_axib_awcache,
  input          io_qdma_port_m_axib_awvalid,
  output         io_qdma_port_m_axib_awready,
  input  [511:0] io_qdma_port_m_axib_wdata,
  input  [63:0]  io_qdma_port_m_axib_wstrb,
  input          io_qdma_port_m_axib_wlast,
  input          io_qdma_port_m_axib_wvalid,
  output         io_qdma_port_m_axib_wready,
  output [3:0]   io_qdma_port_m_axib_bid,
  output [1:0]   io_qdma_port_m_axib_bresp,
  output         io_qdma_port_m_axib_bvalid,
  input          io_qdma_port_m_axib_bready,
  input  [3:0]   io_qdma_port_m_axib_arid,
  input  [63:0]  io_qdma_port_m_axib_araddr,
  input  [7:0]   io_qdma_port_m_axib_arlen,
  input  [2:0]   io_qdma_port_m_axib_arsize,
  input  [1:0]   io_qdma_port_m_axib_arburst,
  input  [2:0]   io_qdma_port_m_axib_arprot,
  input          io_qdma_port_m_axib_arlock,
  input  [3:0]   io_qdma_port_m_axib_arcache,
  input          io_qdma_port_m_axib_arvalid,
  output         io_qdma_port_m_axib_arready,
  output [3:0]   io_qdma_port_m_axib_rid,
  output [511:0] io_qdma_port_m_axib_rdata,
  output [1:0]   io_qdma_port_m_axib_rresp,
  output         io_qdma_port_m_axib_rlast,
  output         io_qdma_port_m_axib_rvalid,
  input          io_qdma_port_m_axib_rready,
  input  [31:0]  io_qdma_port_m_axil_awaddr,
  input          io_qdma_port_m_axil_awvalid,
  output         io_qdma_port_m_axil_awready,
  input  [31:0]  io_qdma_port_m_axil_wdata,
  input  [3:0]   io_qdma_port_m_axil_wstrb,
  input          io_qdma_port_m_axil_wvalid,
  output         io_qdma_port_m_axil_wready,
  output [1:0]   io_qdma_port_m_axil_bresp,
  output         io_qdma_port_m_axil_bvalid,
  input          io_qdma_port_m_axil_bready,
  input  [31:0]  io_qdma_port_m_axil_araddr,
  input          io_qdma_port_m_axil_arvalid,
  output         io_qdma_port_m_axil_arready,
  output [31:0]  io_qdma_port_m_axil_rdata,
  output [1:0]   io_qdma_port_m_axil_rresp,
  output         io_qdma_port_m_axil_rvalid,
  input          io_qdma_port_m_axil_rready,
  output [63:0]  io_qdma_port_h2c_byp_in_st_addr,
  output [31:0]  io_qdma_port_h2c_byp_in_st_len,
  output         io_qdma_port_h2c_byp_in_st_eop,
  output         io_qdma_port_h2c_byp_in_st_sop,
  output         io_qdma_port_h2c_byp_in_st_mrkr_req,
  output         io_qdma_port_h2c_byp_in_st_sdi,
  output [10:0]  io_qdma_port_h2c_byp_in_st_qid,
  output         io_qdma_port_h2c_byp_in_st_error,
  output [7:0]   io_qdma_port_h2c_byp_in_st_func,
  output [15:0]  io_qdma_port_h2c_byp_in_st_cidx,
  output [2:0]   io_qdma_port_h2c_byp_in_st_port_id,
  output         io_qdma_port_h2c_byp_in_st_no_dma,
  output         io_qdma_port_h2c_byp_in_st_vld,
  input          io_qdma_port_h2c_byp_in_st_rdy,
  output [63:0]  io_qdma_port_c2h_byp_in_st_csh_addr,
  output [10:0]  io_qdma_port_c2h_byp_in_st_csh_qid,
  output         io_qdma_port_c2h_byp_in_st_csh_error,
  output [7:0]   io_qdma_port_c2h_byp_in_st_csh_func,
  output [2:0]   io_qdma_port_c2h_byp_in_st_csh_port_id,
  output [6:0]   io_qdma_port_c2h_byp_in_st_csh_pfch_tag,
  output         io_qdma_port_c2h_byp_in_st_csh_vld,
  input          io_qdma_port_c2h_byp_in_st_csh_rdy,
  output [511:0] io_qdma_port_s_axis_c2h_tdata,
  output [31:0]  io_qdma_port_s_axis_c2h_tcrc,
  output         io_qdma_port_s_axis_c2h_ctrl_marker,
  output [6:0]   io_qdma_port_s_axis_c2h_ctrl_ecc,
  output [31:0]  io_qdma_port_s_axis_c2h_ctrl_len,
  output [2:0]   io_qdma_port_s_axis_c2h_ctrl_port_id,
  output [10:0]  io_qdma_port_s_axis_c2h_ctrl_qid,
  output         io_qdma_port_s_axis_c2h_ctrl_has_cmpt,
  output [5:0]   io_qdma_port_s_axis_c2h_mty,
  output         io_qdma_port_s_axis_c2h_tlast,
  output         io_qdma_port_s_axis_c2h_tvalid,
  input          io_qdma_port_s_axis_c2h_tready,
  input  [511:0] io_qdma_port_m_axis_h2c_tdata,
  input  [31:0]  io_qdma_port_m_axis_h2c_tcrc,
  input  [10:0]  io_qdma_port_m_axis_h2c_tuser_qid,
  input  [2:0]   io_qdma_port_m_axis_h2c_tuser_port_id,
  input          io_qdma_port_m_axis_h2c_tuser_err,
  input  [31:0]  io_qdma_port_m_axis_h2c_tuser_mdata,
  input  [5:0]   io_qdma_port_m_axis_h2c_tuser_mty,
  input          io_qdma_port_m_axis_h2c_tuser_zero_byte,
  input          io_qdma_port_m_axis_h2c_tlast,
  input          io_qdma_port_m_axis_h2c_tvalid,
  output         io_qdma_port_m_axis_h2c_tready,
  output [3:0]   io_qdma_port_s_axib_awid,
  output [63:0]  io_qdma_port_s_axib_awaddr,
  output [7:0]   io_qdma_port_s_axib_awlen,
  output [2:0]   io_qdma_port_s_axib_awsize,
  output [1:0]   io_qdma_port_s_axib_awburst,
  output         io_qdma_port_s_axib_awvalid,
  input          io_qdma_port_s_axib_awready,
  output [511:0] io_qdma_port_s_axib_wdata,
  output [63:0]  io_qdma_port_s_axib_wstrb,
  output         io_qdma_port_s_axib_wlast,
  output         io_qdma_port_s_axib_wvalid,
  input          io_qdma_port_s_axib_wready,
  input  [3:0]   io_qdma_port_s_axib_bid,
  input  [1:0]   io_qdma_port_s_axib_bresp,
  input          io_qdma_port_s_axib_bvalid,
  output         io_qdma_port_s_axib_bready,
  output [3:0]   io_qdma_port_s_axib_arid,
  output [63:0]  io_qdma_port_s_axib_araddr,
  output [7:0]   io_qdma_port_s_axib_arlen,
  output [2:0]   io_qdma_port_s_axib_arsize,
  output [1:0]   io_qdma_port_s_axib_arburst,
  output         io_qdma_port_s_axib_arvalid,
  input          io_qdma_port_s_axib_arready,
  input  [3:0]   io_qdma_port_s_axib_rid,
  input  [511:0] io_qdma_port_s_axib_rdata,
  input  [1:0]   io_qdma_port_s_axib_rresp,
  input          io_qdma_port_s_axib_rlast,
  input          io_qdma_port_s_axib_rvalid,
  output         io_qdma_port_s_axib_rready,
  input          io_user_clk,
  input          io_user_arstn,
  output         io_h2c_data_valid,
  output [31:0]  io_reg_control_0,
  output [31:0]  io_reg_control_8,
  output [31:0]  io_reg_control_9,
  output [31:0]  io_reg_control_10,
  output [31:0]  io_reg_control_11,
  output [31:0]  io_reg_control_12,
  output [31:0]  io_reg_control_13,
  output [31:0]  io_reg_control_14,
  input  [31:0]  io_reg_status_400,
  input  [31:0]  io_reg_status_401,
  input  [31:0]  io_reg_status_402,
  input  [31:0]  io_reg_status_403,
  input  [31:0]  io_reg_status_404,
  input  [31:0]  io_reg_status_405,
  input  [31:0]  io_reg_status_406,
  input  [31:0]  io_reg_status_407,
  input  [31:0]  io_reg_status_408,
  input  [31:0]  io_reg_status_409,
  output         io_out_valid,
  output [31:0]  counter_4_0,
  output         io_out_ready,
  output [31:0]  counter_7_0,
  output [31:0]  counter_1_0,
  output         io_in_ready,
  output         io_out_ready_0,
  output [31:0]  counter_3_0,
  output         io_out_valid_0,
  output [31:0]  counter_6_0,
  output [31:0]  counter_0,
  output         io_in_valid,
  output [31:0]  io_tlb_miss_count,
  output         io_out_valid_1,
  output [31:0]  counter_2_0,
  output         io_out_ready_1,
  output [31:0]  counter_5_0
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_REG_INIT
  wire  sw_reset_pad_O; // @[Buf.scala 33:34]
  wire  sw_reset_pad_I; // @[Buf.scala 33:34]
  wire  fifo_h2c_data_io__in_clk; // @[XConverter.scala 61:33]
  wire  fifo_h2c_data_io__out_clk; // @[XConverter.scala 61:33]
  wire  fifo_h2c_data_io__rstn; // @[XConverter.scala 61:33]
  wire  fifo_h2c_data_io__in_ready; // @[XConverter.scala 61:33]
  wire  fifo_h2c_data_io__in_valid; // @[XConverter.scala 61:33]
  wire [511:0] fifo_h2c_data_io__in_bits_data; // @[XConverter.scala 61:33]
  wire [31:0] fifo_h2c_data_io__in_bits_tcrc; // @[XConverter.scala 61:33]
  wire [10:0] fifo_h2c_data_io__in_bits_tuser_qid; // @[XConverter.scala 61:33]
  wire [2:0] fifo_h2c_data_io__in_bits_tuser_port_id; // @[XConverter.scala 61:33]
  wire  fifo_h2c_data_io__in_bits_tuser_err; // @[XConverter.scala 61:33]
  wire [31:0] fifo_h2c_data_io__in_bits_tuser_mdata; // @[XConverter.scala 61:33]
  wire [5:0] fifo_h2c_data_io__in_bits_tuser_mty; // @[XConverter.scala 61:33]
  wire  fifo_h2c_data_io__in_bits_tuser_zero_byte; // @[XConverter.scala 61:33]
  wire  fifo_h2c_data_io__in_bits_last; // @[XConverter.scala 61:33]
  wire  fifo_h2c_data_io__out_valid; // @[XConverter.scala 61:33]
  wire  fifo_h2c_data_io_in_ready; // @[XConverter.scala 61:33]
  wire  fifo_h2c_data_io_in_valid; // @[XConverter.scala 61:33]
  wire  fifo_h2c_data_io_in_queue_clock; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_data_io_in_queue_reset; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_data_io_in_queue_io_upStream_ready; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_data_io_in_queue_io_upStream_valid; // @[RegSlices.scala 64:35]
  wire [511:0] fifo_h2c_data_io_in_queue_io_upStream_bits_data; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_h2c_data_io_in_queue_io_upStream_bits_tcrc; // @[RegSlices.scala 64:35]
  wire [10:0] fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_qid; // @[RegSlices.scala 64:35]
  wire [2:0] fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_port_id; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_err; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_mdata; // @[RegSlices.scala 64:35]
  wire [5:0] fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_mty; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_zero_byte; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_data_io_in_queue_io_upStream_bits_last; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_data_io_in_queue_io_downStream_ready; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_data_io_in_queue_io_downStream_valid; // @[RegSlices.scala 64:35]
  wire [511:0] fifo_h2c_data_io_in_queue_io_downStream_bits_data; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_h2c_data_io_in_queue_io_downStream_bits_tcrc; // @[RegSlices.scala 64:35]
  wire [10:0] fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_qid; // @[RegSlices.scala 64:35]
  wire [2:0] fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_port_id; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_err; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_mdata; // @[RegSlices.scala 64:35]
  wire [5:0] fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_mty; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_zero_byte; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_data_io_in_queue_io_downStream_bits_last; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_io__in_clk; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__out_clk; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__rstn; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__in_ready; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__in_valid; // @[XConverter.scala 61:33]
  wire [511:0] fifo_c2h_data_io__in_bits_data; // @[XConverter.scala 61:33]
  wire [31:0] fifo_c2h_data_io__in_bits_tcrc; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__in_bits_ctrl_marker; // @[XConverter.scala 61:33]
  wire [6:0] fifo_c2h_data_io__in_bits_ctrl_ecc; // @[XConverter.scala 61:33]
  wire [31:0] fifo_c2h_data_io__in_bits_ctrl_len; // @[XConverter.scala 61:33]
  wire [2:0] fifo_c2h_data_io__in_bits_ctrl_port_id; // @[XConverter.scala 61:33]
  wire [10:0] fifo_c2h_data_io__in_bits_ctrl_qid; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__in_bits_ctrl_has_cmpt; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__in_bits_last; // @[XConverter.scala 61:33]
  wire [5:0] fifo_c2h_data_io__in_bits_mty; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__out_ready; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__out_valid; // @[XConverter.scala 61:33]
  wire [511:0] fifo_c2h_data_io__out_bits_data; // @[XConverter.scala 61:33]
  wire [31:0] fifo_c2h_data_io__out_bits_tcrc; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__out_bits_ctrl_marker; // @[XConverter.scala 61:33]
  wire [6:0] fifo_c2h_data_io__out_bits_ctrl_ecc; // @[XConverter.scala 61:33]
  wire [31:0] fifo_c2h_data_io__out_bits_ctrl_len; // @[XConverter.scala 61:33]
  wire [2:0] fifo_c2h_data_io__out_bits_ctrl_port_id; // @[XConverter.scala 61:33]
  wire [10:0] fifo_c2h_data_io__out_bits_ctrl_qid; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__out_bits_ctrl_has_cmpt; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io__out_bits_last; // @[XConverter.scala 61:33]
  wire [5:0] fifo_c2h_data_io__out_bits_mty; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io_out_ready; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_io_out_valid_0; // @[XConverter.scala 61:33]
  wire  fifo_c2h_data_out_queue_clock; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_out_queue_reset; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_out_queue_io_upStream_ready; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_out_queue_io_upStream_valid; // @[RegSlices.scala 64:35]
  wire [511:0] fifo_c2h_data_out_queue_io_upStream_bits_data; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_c2h_data_out_queue_io_upStream_bits_tcrc; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_out_queue_io_upStream_bits_ctrl_marker; // @[RegSlices.scala 64:35]
  wire [6:0] fifo_c2h_data_out_queue_io_upStream_bits_ctrl_ecc; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_c2h_data_out_queue_io_upStream_bits_ctrl_len; // @[RegSlices.scala 64:35]
  wire [2:0] fifo_c2h_data_out_queue_io_upStream_bits_ctrl_port_id; // @[RegSlices.scala 64:35]
  wire [10:0] fifo_c2h_data_out_queue_io_upStream_bits_ctrl_qid; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_out_queue_io_upStream_bits_ctrl_has_cmpt; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_out_queue_io_upStream_bits_last; // @[RegSlices.scala 64:35]
  wire [5:0] fifo_c2h_data_out_queue_io_upStream_bits_mty; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_out_queue_io_downStream_ready; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_out_queue_io_downStream_valid; // @[RegSlices.scala 64:35]
  wire [511:0] fifo_c2h_data_out_queue_io_downStream_bits_data; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_c2h_data_out_queue_io_downStream_bits_tcrc; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_out_queue_io_downStream_bits_ctrl_marker; // @[RegSlices.scala 64:35]
  wire [6:0] fifo_c2h_data_out_queue_io_downStream_bits_ctrl_ecc; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_c2h_data_out_queue_io_downStream_bits_ctrl_len; // @[RegSlices.scala 64:35]
  wire [2:0] fifo_c2h_data_out_queue_io_downStream_bits_ctrl_port_id; // @[RegSlices.scala 64:35]
  wire [10:0] fifo_c2h_data_out_queue_io_downStream_bits_ctrl_qid; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_out_queue_io_downStream_bits_ctrl_has_cmpt; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_data_out_queue_io_downStream_bits_last; // @[RegSlices.scala 64:35]
  wire [5:0] fifo_c2h_data_out_queue_io_downStream_bits_mty; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io__in_clk; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__out_clk; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__rstn; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__in_ready; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__in_valid; // @[XConverter.scala 61:33]
  wire [63:0] fifo_h2c_cmd_io__in_bits_addr; // @[XConverter.scala 61:33]
  wire [31:0] fifo_h2c_cmd_io__in_bits_len; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__in_bits_eop; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__in_bits_sop; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__in_bits_mrkr_req; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__in_bits_sdi; // @[XConverter.scala 61:33]
  wire [10:0] fifo_h2c_cmd_io__in_bits_qid; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__in_bits_error; // @[XConverter.scala 61:33]
  wire [7:0] fifo_h2c_cmd_io__in_bits_func; // @[XConverter.scala 61:33]
  wire [15:0] fifo_h2c_cmd_io__in_bits_cidx; // @[XConverter.scala 61:33]
  wire [2:0] fifo_h2c_cmd_io__in_bits_port_id; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__in_bits_no_dma; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__out_ready; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__out_valid; // @[XConverter.scala 61:33]
  wire [63:0] fifo_h2c_cmd_io__out_bits_addr; // @[XConverter.scala 61:33]
  wire [31:0] fifo_h2c_cmd_io__out_bits_len; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__out_bits_eop; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__out_bits_sop; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__out_bits_mrkr_req; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__out_bits_sdi; // @[XConverter.scala 61:33]
  wire [10:0] fifo_h2c_cmd_io__out_bits_qid; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__out_bits_error; // @[XConverter.scala 61:33]
  wire [7:0] fifo_h2c_cmd_io__out_bits_func; // @[XConverter.scala 61:33]
  wire [15:0] fifo_h2c_cmd_io__out_bits_cidx; // @[XConverter.scala 61:33]
  wire [2:0] fifo_h2c_cmd_io__out_bits_port_id; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io__out_bits_no_dma; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io_out_valid; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_io_out_ready_1; // @[XConverter.scala 61:33]
  wire  fifo_h2c_cmd_out_queue_clock; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_reset; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_upStream_ready; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_upStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] fifo_h2c_cmd_out_queue_io_upStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_h2c_cmd_out_queue_io_upStream_bits_len; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_upStream_bits_eop; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_upStream_bits_sop; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_upStream_bits_mrkr_req; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_upStream_bits_sdi; // @[RegSlices.scala 64:35]
  wire [10:0] fifo_h2c_cmd_out_queue_io_upStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_upStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] fifo_h2c_cmd_out_queue_io_upStream_bits_func; // @[RegSlices.scala 64:35]
  wire [15:0] fifo_h2c_cmd_out_queue_io_upStream_bits_cidx; // @[RegSlices.scala 64:35]
  wire [2:0] fifo_h2c_cmd_out_queue_io_upStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_upStream_bits_no_dma; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_downStream_ready; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_downStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] fifo_h2c_cmd_out_queue_io_downStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_h2c_cmd_out_queue_io_downStream_bits_len; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_downStream_bits_eop; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_downStream_bits_sop; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_downStream_bits_mrkr_req; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_downStream_bits_sdi; // @[RegSlices.scala 64:35]
  wire [10:0] fifo_h2c_cmd_out_queue_io_downStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_downStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] fifo_h2c_cmd_out_queue_io_downStream_bits_func; // @[RegSlices.scala 64:35]
  wire [15:0] fifo_h2c_cmd_out_queue_io_downStream_bits_cidx; // @[RegSlices.scala 64:35]
  wire [2:0] fifo_h2c_cmd_out_queue_io_downStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_out_queue_io_downStream_bits_no_dma; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_cmd_io_in_clk; // @[XConverter.scala 61:33]
  wire  fifo_c2h_cmd_io_out_clk; // @[XConverter.scala 61:33]
  wire  fifo_c2h_cmd_io_rstn; // @[XConverter.scala 61:33]
  wire  fifo_c2h_cmd_io_in_ready; // @[XConverter.scala 61:33]
  wire  fifo_c2h_cmd_io_in_valid; // @[XConverter.scala 61:33]
  wire [63:0] fifo_c2h_cmd_io_in_bits_addr; // @[XConverter.scala 61:33]
  wire [10:0] fifo_c2h_cmd_io_in_bits_qid; // @[XConverter.scala 61:33]
  wire  fifo_c2h_cmd_io_in_bits_error; // @[XConverter.scala 61:33]
  wire [7:0] fifo_c2h_cmd_io_in_bits_func; // @[XConverter.scala 61:33]
  wire [2:0] fifo_c2h_cmd_io_in_bits_port_id; // @[XConverter.scala 61:33]
  wire [6:0] fifo_c2h_cmd_io_in_bits_pfch_tag; // @[XConverter.scala 61:33]
  wire [31:0] fifo_c2h_cmd_io_in_bits_len; // @[XConverter.scala 61:33]
  wire  fifo_c2h_cmd_io_out_ready; // @[XConverter.scala 61:33]
  wire  fifo_c2h_cmd_io_out_valid; // @[XConverter.scala 61:33]
  wire [63:0] fifo_c2h_cmd_io_out_bits_addr; // @[XConverter.scala 61:33]
  wire [10:0] fifo_c2h_cmd_io_out_bits_qid; // @[XConverter.scala 61:33]
  wire  fifo_c2h_cmd_io_out_bits_error; // @[XConverter.scala 61:33]
  wire [7:0] fifo_c2h_cmd_io_out_bits_func; // @[XConverter.scala 61:33]
  wire [2:0] fifo_c2h_cmd_io_out_bits_port_id; // @[XConverter.scala 61:33]
  wire [6:0] fifo_c2h_cmd_io_out_bits_pfch_tag; // @[XConverter.scala 61:33]
  wire [31:0] fifo_c2h_cmd_io_out_bits_len; // @[XConverter.scala 61:33]
  wire  fifo_c2h_cmd_io_out_ready_0; // @[XConverter.scala 61:33]
  wire  fifo_c2h_cmd_io_out_valid_1; // @[XConverter.scala 61:33]
  wire  fifo_c2h_cmd_out_queue_clock; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_cmd_out_queue_reset; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_cmd_out_queue_io_upStream_ready; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_cmd_out_queue_io_upStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] fifo_c2h_cmd_out_queue_io_upStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [10:0] fifo_c2h_cmd_out_queue_io_upStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_cmd_out_queue_io_upStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] fifo_c2h_cmd_out_queue_io_upStream_bits_func; // @[RegSlices.scala 64:35]
  wire [2:0] fifo_c2h_cmd_out_queue_io_upStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire [6:0] fifo_c2h_cmd_out_queue_io_upStream_bits_pfch_tag; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_c2h_cmd_out_queue_io_upStream_bits_len; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_cmd_out_queue_io_downStream_ready; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_cmd_out_queue_io_downStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] fifo_c2h_cmd_out_queue_io_downStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [10:0] fifo_c2h_cmd_out_queue_io_downStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  fifo_c2h_cmd_out_queue_io_downStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] fifo_c2h_cmd_out_queue_io_downStream_bits_func; // @[RegSlices.scala 64:35]
  wire [2:0] fifo_c2h_cmd_out_queue_io_downStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire [6:0] fifo_c2h_cmd_out_queue_io_downStream_bits_pfch_tag; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_c2h_cmd_out_queue_io_downStream_bits_len; // @[RegSlices.scala 64:35]
  wire  check_c2h_clock; // @[QDMADynamic.scala 62:95]
  wire  check_c2h_reset; // @[QDMADynamic.scala 62:95]
  wire  check_c2h_io_in_ready; // @[QDMADynamic.scala 62:95]
  wire  check_c2h_io_in_valid; // @[QDMADynamic.scala 62:95]
  wire [63:0] check_c2h_io_in_bits_addr; // @[QDMADynamic.scala 62:95]
  wire [10:0] check_c2h_io_in_bits_qid; // @[QDMADynamic.scala 62:95]
  wire  check_c2h_io_in_bits_error; // @[QDMADynamic.scala 62:95]
  wire [7:0] check_c2h_io_in_bits_func; // @[QDMADynamic.scala 62:95]
  wire [2:0] check_c2h_io_in_bits_port_id; // @[QDMADynamic.scala 62:95]
  wire [6:0] check_c2h_io_in_bits_pfch_tag; // @[QDMADynamic.scala 62:95]
  wire [31:0] check_c2h_io_in_bits_len; // @[QDMADynamic.scala 62:95]
  wire  check_c2h_io_out_ready; // @[QDMADynamic.scala 62:95]
  wire  check_c2h_io_out_valid; // @[QDMADynamic.scala 62:95]
  wire [63:0] check_c2h_io_out_bits_addr; // @[QDMADynamic.scala 62:95]
  wire [10:0] check_c2h_io_out_bits_qid; // @[QDMADynamic.scala 62:95]
  wire  check_c2h_io_out_bits_error; // @[QDMADynamic.scala 62:95]
  wire [7:0] check_c2h_io_out_bits_func; // @[QDMADynamic.scala 62:95]
  wire [2:0] check_c2h_io_out_bits_port_id; // @[QDMADynamic.scala 62:95]
  wire [6:0] check_c2h_io_out_bits_pfch_tag; // @[QDMADynamic.scala 62:95]
  wire [31:0] check_c2h_io_out_bits_len; // @[QDMADynamic.scala 62:95]
  wire  check_c2h_io_in_queue_clock; // @[RegSlices.scala 64:35]
  wire  check_c2h_io_in_queue_reset; // @[RegSlices.scala 64:35]
  wire  check_c2h_io_in_queue_io_upStream_ready; // @[RegSlices.scala 64:35]
  wire  check_c2h_io_in_queue_io_upStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] check_c2h_io_in_queue_io_upStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [10:0] check_c2h_io_in_queue_io_upStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  check_c2h_io_in_queue_io_upStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] check_c2h_io_in_queue_io_upStream_bits_func; // @[RegSlices.scala 64:35]
  wire [2:0] check_c2h_io_in_queue_io_upStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire [6:0] check_c2h_io_in_queue_io_upStream_bits_pfch_tag; // @[RegSlices.scala 64:35]
  wire [31:0] check_c2h_io_in_queue_io_upStream_bits_len; // @[RegSlices.scala 64:35]
  wire  check_c2h_io_in_queue_io_downStream_ready; // @[RegSlices.scala 64:35]
  wire  check_c2h_io_in_queue_io_downStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] check_c2h_io_in_queue_io_downStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [10:0] check_c2h_io_in_queue_io_downStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  check_c2h_io_in_queue_io_downStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] check_c2h_io_in_queue_io_downStream_bits_func; // @[RegSlices.scala 64:35]
  wire [2:0] check_c2h_io_in_queue_io_downStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire [6:0] check_c2h_io_in_queue_io_downStream_bits_pfch_tag; // @[RegSlices.scala 64:35]
  wire [31:0] check_c2h_io_in_queue_io_downStream_bits_len; // @[RegSlices.scala 64:35]
  wire  check_h2c_clock; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_reset; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_in_ready; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_in_valid; // @[QDMADynamic.scala 64:95]
  wire [63:0] check_h2c_io_in_bits_addr; // @[QDMADynamic.scala 64:95]
  wire [31:0] check_h2c_io_in_bits_len; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_in_bits_eop; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_in_bits_sop; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_in_bits_mrkr_req; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_in_bits_sdi; // @[QDMADynamic.scala 64:95]
  wire [10:0] check_h2c_io_in_bits_qid; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_in_bits_error; // @[QDMADynamic.scala 64:95]
  wire [7:0] check_h2c_io_in_bits_func; // @[QDMADynamic.scala 64:95]
  wire [15:0] check_h2c_io_in_bits_cidx; // @[QDMADynamic.scala 64:95]
  wire [2:0] check_h2c_io_in_bits_port_id; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_in_bits_no_dma; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_out_ready; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_out_valid; // @[QDMADynamic.scala 64:95]
  wire [63:0] check_h2c_io_out_bits_addr; // @[QDMADynamic.scala 64:95]
  wire [31:0] check_h2c_io_out_bits_len; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_out_bits_eop; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_out_bits_sop; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_out_bits_mrkr_req; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_out_bits_sdi; // @[QDMADynamic.scala 64:95]
  wire [10:0] check_h2c_io_out_bits_qid; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_out_bits_error; // @[QDMADynamic.scala 64:95]
  wire [7:0] check_h2c_io_out_bits_func; // @[QDMADynamic.scala 64:95]
  wire [15:0] check_h2c_io_out_bits_cidx; // @[QDMADynamic.scala 64:95]
  wire [2:0] check_h2c_io_out_bits_port_id; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_out_bits_no_dma; // @[QDMADynamic.scala 64:95]
  wire  check_h2c_io_in_queue_clock; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_reset; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_upStream_ready; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_upStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] check_h2c_io_in_queue_io_upStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [31:0] check_h2c_io_in_queue_io_upStream_bits_len; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_upStream_bits_eop; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_upStream_bits_sop; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_upStream_bits_mrkr_req; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_upStream_bits_sdi; // @[RegSlices.scala 64:35]
  wire [10:0] check_h2c_io_in_queue_io_upStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_upStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] check_h2c_io_in_queue_io_upStream_bits_func; // @[RegSlices.scala 64:35]
  wire [15:0] check_h2c_io_in_queue_io_upStream_bits_cidx; // @[RegSlices.scala 64:35]
  wire [2:0] check_h2c_io_in_queue_io_upStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_upStream_bits_no_dma; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_downStream_ready; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_downStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] check_h2c_io_in_queue_io_downStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [31:0] check_h2c_io_in_queue_io_downStream_bits_len; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_downStream_bits_eop; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_downStream_bits_sop; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_downStream_bits_mrkr_req; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_downStream_bits_sdi; // @[RegSlices.scala 64:35]
  wire [10:0] check_h2c_io_in_queue_io_downStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_downStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] check_h2c_io_in_queue_io_downStream_bits_func; // @[RegSlices.scala 64:35]
  wire [15:0] check_h2c_io_in_queue_io_downStream_bits_cidx; // @[RegSlices.scala 64:35]
  wire [2:0] check_h2c_io_in_queue_io_downStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire  check_h2c_io_in_queue_io_downStream_bits_no_dma; // @[RegSlices.scala 64:35]
  wire  tlb_clock; // @[QDMADynamic.scala 67:71]
  wire  tlb_reset; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__wr_tlb_ready; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__wr_tlb_valid; // @[QDMADynamic.scala 67:71]
  wire [31:0] tlb_io__wr_tlb_bits_vaddr_high; // @[QDMADynamic.scala 67:71]
  wire [31:0] tlb_io__wr_tlb_bits_vaddr_low; // @[QDMADynamic.scala 67:71]
  wire [31:0] tlb_io__wr_tlb_bits_paddr_high; // @[QDMADynamic.scala 67:71]
  wire [31:0] tlb_io__wr_tlb_bits_paddr_low; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__wr_tlb_bits_is_base; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_in_ready; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_in_valid; // @[QDMADynamic.scala 67:71]
  wire [63:0] tlb_io__h2c_in_bits_addr; // @[QDMADynamic.scala 67:71]
  wire [31:0] tlb_io__h2c_in_bits_len; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_in_bits_eop; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_in_bits_sop; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_in_bits_mrkr_req; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_in_bits_sdi; // @[QDMADynamic.scala 67:71]
  wire [10:0] tlb_io__h2c_in_bits_qid; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_in_bits_error; // @[QDMADynamic.scala 67:71]
  wire [7:0] tlb_io__h2c_in_bits_func; // @[QDMADynamic.scala 67:71]
  wire [15:0] tlb_io__h2c_in_bits_cidx; // @[QDMADynamic.scala 67:71]
  wire [2:0] tlb_io__h2c_in_bits_port_id; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_in_bits_no_dma; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__c2h_in_ready; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__c2h_in_valid; // @[QDMADynamic.scala 67:71]
  wire [63:0] tlb_io__c2h_in_bits_addr; // @[QDMADynamic.scala 67:71]
  wire [10:0] tlb_io__c2h_in_bits_qid; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__c2h_in_bits_error; // @[QDMADynamic.scala 67:71]
  wire [7:0] tlb_io__c2h_in_bits_func; // @[QDMADynamic.scala 67:71]
  wire [2:0] tlb_io__c2h_in_bits_port_id; // @[QDMADynamic.scala 67:71]
  wire [6:0] tlb_io__c2h_in_bits_pfch_tag; // @[QDMADynamic.scala 67:71]
  wire [31:0] tlb_io__c2h_in_bits_len; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_out_ready; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_out_valid; // @[QDMADynamic.scala 67:71]
  wire [63:0] tlb_io__h2c_out_bits_addr; // @[QDMADynamic.scala 67:71]
  wire [31:0] tlb_io__h2c_out_bits_len; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_out_bits_eop; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_out_bits_sop; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_out_bits_mrkr_req; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_out_bits_sdi; // @[QDMADynamic.scala 67:71]
  wire [10:0] tlb_io__h2c_out_bits_qid; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_out_bits_error; // @[QDMADynamic.scala 67:71]
  wire [7:0] tlb_io__h2c_out_bits_func; // @[QDMADynamic.scala 67:71]
  wire [15:0] tlb_io__h2c_out_bits_cidx; // @[QDMADynamic.scala 67:71]
  wire [2:0] tlb_io__h2c_out_bits_port_id; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__h2c_out_bits_no_dma; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__c2h_out_ready; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__c2h_out_valid; // @[QDMADynamic.scala 67:71]
  wire [63:0] tlb_io__c2h_out_bits_addr; // @[QDMADynamic.scala 67:71]
  wire [10:0] tlb_io__c2h_out_bits_qid; // @[QDMADynamic.scala 67:71]
  wire  tlb_io__c2h_out_bits_error; // @[QDMADynamic.scala 67:71]
  wire [7:0] tlb_io__c2h_out_bits_func; // @[QDMADynamic.scala 67:71]
  wire [2:0] tlb_io__c2h_out_bits_port_id; // @[QDMADynamic.scala 67:71]
  wire [6:0] tlb_io__c2h_out_bits_pfch_tag; // @[QDMADynamic.scala 67:71]
  wire [31:0] tlb_io__c2h_out_bits_len; // @[QDMADynamic.scala 67:71]
  wire [31:0] tlb_io__tlb_miss_count; // @[QDMADynamic.scala 67:71]
  wire [31:0] tlb_io_tlb_miss_count; // @[QDMADynamic.scala 67:71]
  wire  tlb_io_h2c_in_queue_clock; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_reset; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_upStream_ready; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_upStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] tlb_io_h2c_in_queue_io_upStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [31:0] tlb_io_h2c_in_queue_io_upStream_bits_len; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_upStream_bits_eop; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_upStream_bits_sop; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_upStream_bits_mrkr_req; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_upStream_bits_sdi; // @[RegSlices.scala 64:35]
  wire [10:0] tlb_io_h2c_in_queue_io_upStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_upStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] tlb_io_h2c_in_queue_io_upStream_bits_func; // @[RegSlices.scala 64:35]
  wire [15:0] tlb_io_h2c_in_queue_io_upStream_bits_cidx; // @[RegSlices.scala 64:35]
  wire [2:0] tlb_io_h2c_in_queue_io_upStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_upStream_bits_no_dma; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_downStream_ready; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_downStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] tlb_io_h2c_in_queue_io_downStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [31:0] tlb_io_h2c_in_queue_io_downStream_bits_len; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_downStream_bits_eop; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_downStream_bits_sop; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_downStream_bits_mrkr_req; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_downStream_bits_sdi; // @[RegSlices.scala 64:35]
  wire [10:0] tlb_io_h2c_in_queue_io_downStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_downStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] tlb_io_h2c_in_queue_io_downStream_bits_func; // @[RegSlices.scala 64:35]
  wire [15:0] tlb_io_h2c_in_queue_io_downStream_bits_cidx; // @[RegSlices.scala 64:35]
  wire [2:0] tlb_io_h2c_in_queue_io_downStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire  tlb_io_h2c_in_queue_io_downStream_bits_no_dma; // @[RegSlices.scala 64:35]
  wire  tlb_io_c2h_in_queue_clock; // @[RegSlices.scala 64:35]
  wire  tlb_io_c2h_in_queue_reset; // @[RegSlices.scala 64:35]
  wire  tlb_io_c2h_in_queue_io_upStream_ready; // @[RegSlices.scala 64:35]
  wire  tlb_io_c2h_in_queue_io_upStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] tlb_io_c2h_in_queue_io_upStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [10:0] tlb_io_c2h_in_queue_io_upStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  tlb_io_c2h_in_queue_io_upStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] tlb_io_c2h_in_queue_io_upStream_bits_func; // @[RegSlices.scala 64:35]
  wire [2:0] tlb_io_c2h_in_queue_io_upStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire [6:0] tlb_io_c2h_in_queue_io_upStream_bits_pfch_tag; // @[RegSlices.scala 64:35]
  wire [31:0] tlb_io_c2h_in_queue_io_upStream_bits_len; // @[RegSlices.scala 64:35]
  wire  tlb_io_c2h_in_queue_io_downStream_ready; // @[RegSlices.scala 64:35]
  wire  tlb_io_c2h_in_queue_io_downStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] tlb_io_c2h_in_queue_io_downStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [10:0] tlb_io_c2h_in_queue_io_downStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  tlb_io_c2h_in_queue_io_downStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] tlb_io_c2h_in_queue_io_downStream_bits_func; // @[RegSlices.scala 64:35]
  wire [2:0] tlb_io_c2h_in_queue_io_downStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire [6:0] tlb_io_c2h_in_queue_io_downStream_bits_pfch_tag; // @[RegSlices.scala 64:35]
  wire [31:0] tlb_io_c2h_in_queue_io_downStream_bits_len; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_clock; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_reset; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_upStream_ready; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_upStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] fifo_h2c_cmd_io_in_queue_io_upStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_h2c_cmd_io_in_queue_io_upStream_bits_len; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_upStream_bits_eop; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_upStream_bits_sop; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_upStream_bits_mrkr_req; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_upStream_bits_sdi; // @[RegSlices.scala 64:35]
  wire [10:0] fifo_h2c_cmd_io_in_queue_io_upStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_upStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] fifo_h2c_cmd_io_in_queue_io_upStream_bits_func; // @[RegSlices.scala 64:35]
  wire [15:0] fifo_h2c_cmd_io_in_queue_io_upStream_bits_cidx; // @[RegSlices.scala 64:35]
  wire [2:0] fifo_h2c_cmd_io_in_queue_io_upStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_upStream_bits_no_dma; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_downStream_ready; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_downStream_valid; // @[RegSlices.scala 64:35]
  wire [63:0] fifo_h2c_cmd_io_in_queue_io_downStream_bits_addr; // @[RegSlices.scala 64:35]
  wire [31:0] fifo_h2c_cmd_io_in_queue_io_downStream_bits_len; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_downStream_bits_eop; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_downStream_bits_sop; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_downStream_bits_mrkr_req; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_downStream_bits_sdi; // @[RegSlices.scala 64:35]
  wire [10:0] fifo_h2c_cmd_io_in_queue_io_downStream_bits_qid; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_downStream_bits_error; // @[RegSlices.scala 64:35]
  wire [7:0] fifo_h2c_cmd_io_in_queue_io_downStream_bits_func; // @[RegSlices.scala 64:35]
  wire [15:0] fifo_h2c_cmd_io_in_queue_io_downStream_bits_cidx; // @[RegSlices.scala 64:35]
  wire [2:0] fifo_h2c_cmd_io_in_queue_io_downStream_bits_port_id; // @[RegSlices.scala 64:35]
  wire  fifo_h2c_cmd_io_in_queue_io_downStream_bits_no_dma; // @[RegSlices.scala 64:35]
  wire  axil2reg_clock; // @[QDMADynamic.scala 86:76]
  wire  axil2reg_reset; // @[QDMADynamic.scala 86:76]
  wire  axil2reg_io_axi_aw_ready; // @[QDMADynamic.scala 86:76]
  wire  axil2reg_io_axi_aw_valid; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_axi_aw_bits_addr; // @[QDMADynamic.scala 86:76]
  wire  axil2reg_io_axi_ar_ready; // @[QDMADynamic.scala 86:76]
  wire  axil2reg_io_axi_ar_valid; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_axi_ar_bits_addr; // @[QDMADynamic.scala 86:76]
  wire  axil2reg_io_axi_w_ready; // @[QDMADynamic.scala 86:76]
  wire  axil2reg_io_axi_w_valid; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_axi_w_bits_data; // @[QDMADynamic.scala 86:76]
  wire  axil2reg_io_axi_r_ready; // @[QDMADynamic.scala 86:76]
  wire  axil2reg_io_axi_r_valid; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_axi_r_bits_data; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_control_0; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_control_8; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_control_9; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_control_10; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_control_11; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_control_12; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_control_13; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_control_14; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_status_400; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_status_401; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_status_402; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_status_403; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_status_404; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_status_405; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_status_406; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_status_407; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_status_408; // @[QDMADynamic.scala 86:76]
  wire [31:0] axil2reg_io_reg_status_409; // @[QDMADynamic.scala 86:76]
  wire  io_axib_cvt_aw_io_in_clk; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_aw_io_out_clk; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_aw_io_rstn; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_aw_io_in_ready; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_aw_io_in_valid; // @[XConverter.scala 61:33]
  wire [63:0] io_axib_cvt_aw_io_in_bits_addr; // @[XConverter.scala 61:33]
  wire [1:0] io_axib_cvt_aw_io_in_bits_burst; // @[XConverter.scala 61:33]
  wire [3:0] io_axib_cvt_aw_io_in_bits_cache; // @[XConverter.scala 61:33]
  wire [3:0] io_axib_cvt_aw_io_in_bits_id; // @[XConverter.scala 61:33]
  wire [7:0] io_axib_cvt_aw_io_in_bits_len; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_aw_io_in_bits_lock; // @[XConverter.scala 61:33]
  wire [2:0] io_axib_cvt_aw_io_in_bits_prot; // @[XConverter.scala 61:33]
  wire [2:0] io_axib_cvt_aw_io_in_bits_size; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_ar_io_in_clk; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_ar_io_out_clk; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_ar_io_rstn; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_ar_io_in_ready; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_ar_io_in_valid; // @[XConverter.scala 61:33]
  wire [63:0] io_axib_cvt_ar_io_in_bits_addr; // @[XConverter.scala 61:33]
  wire [1:0] io_axib_cvt_ar_io_in_bits_burst; // @[XConverter.scala 61:33]
  wire [3:0] io_axib_cvt_ar_io_in_bits_cache; // @[XConverter.scala 61:33]
  wire [3:0] io_axib_cvt_ar_io_in_bits_id; // @[XConverter.scala 61:33]
  wire [7:0] io_axib_cvt_ar_io_in_bits_len; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_ar_io_in_bits_lock; // @[XConverter.scala 61:33]
  wire [2:0] io_axib_cvt_ar_io_in_bits_prot; // @[XConverter.scala 61:33]
  wire [2:0] io_axib_cvt_ar_io_in_bits_size; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_w_io_in_clk; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_w_io_out_clk; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_w_io_rstn; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_w_io_in_ready; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_w_io_in_valid; // @[XConverter.scala 61:33]
  wire [511:0] io_axib_cvt_w_io_in_bits_data; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_w_io_in_bits_last; // @[XConverter.scala 61:33]
  wire [63:0] io_axib_cvt_w_io_in_bits_strb; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_r_io_in_clk; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_r_io_out_clk; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_r_io_rstn; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_r_io_out_ready; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_r_io_out_valid; // @[XConverter.scala 61:33]
  wire [511:0] io_axib_cvt_r_io_out_bits_data; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_r_io_out_bits_last; // @[XConverter.scala 61:33]
  wire [1:0] io_axib_cvt_r_io_out_bits_resp; // @[XConverter.scala 61:33]
  wire [3:0] io_axib_cvt_r_io_out_bits_id; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_b_io_in_clk; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_b_io_out_clk; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_b_io_rstn; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_b_io_out_ready; // @[XConverter.scala 61:33]
  wire  io_axib_cvt_b_io_out_valid; // @[XConverter.scala 61:33]
  wire [3:0] io_axib_cvt_b_io_out_bits_id; // @[XConverter.scala 61:33]
  wire [1:0] io_axib_cvt_b_io_out_bits_resp; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_aw_io_in_clk; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_aw_io_out_clk; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_aw_io_rstn; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_aw_io_out_ready; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_aw_io_out_valid; // @[XConverter.scala 61:33]
  wire [63:0] s_axib_cvt_aw_io_out_bits_addr; // @[XConverter.scala 61:33]
  wire [1:0] s_axib_cvt_aw_io_out_bits_burst; // @[XConverter.scala 61:33]
  wire [3:0] s_axib_cvt_aw_io_out_bits_id; // @[XConverter.scala 61:33]
  wire [7:0] s_axib_cvt_aw_io_out_bits_len; // @[XConverter.scala 61:33]
  wire [2:0] s_axib_cvt_aw_io_out_bits_size; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_ar_io_in_clk; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_ar_io_out_clk; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_ar_io_rstn; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_ar_io_out_ready; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_ar_io_out_valid; // @[XConverter.scala 61:33]
  wire [63:0] s_axib_cvt_ar_io_out_bits_addr; // @[XConverter.scala 61:33]
  wire [1:0] s_axib_cvt_ar_io_out_bits_burst; // @[XConverter.scala 61:33]
  wire [3:0] s_axib_cvt_ar_io_out_bits_id; // @[XConverter.scala 61:33]
  wire [7:0] s_axib_cvt_ar_io_out_bits_len; // @[XConverter.scala 61:33]
  wire [2:0] s_axib_cvt_ar_io_out_bits_size; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_w_io_in_clk; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_w_io_out_clk; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_w_io_rstn; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_w_io_out_ready; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_w_io_out_valid; // @[XConverter.scala 61:33]
  wire [511:0] s_axib_cvt_w_io_out_bits_data; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_w_io_out_bits_last; // @[XConverter.scala 61:33]
  wire [63:0] s_axib_cvt_w_io_out_bits_strb; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_r_io_in_clk; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_r_io_out_clk; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_r_io_rstn; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_r_io_in_ready; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_r_io_in_valid; // @[XConverter.scala 61:33]
  wire [511:0] s_axib_cvt_r_io_in_bits_data; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_r_io_in_bits_last; // @[XConverter.scala 61:33]
  wire [1:0] s_axib_cvt_r_io_in_bits_resp; // @[XConverter.scala 61:33]
  wire [3:0] s_axib_cvt_r_io_in_bits_id; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_b_io_in_clk; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_b_io_out_clk; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_b_io_rstn; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_b_io_in_ready; // @[XConverter.scala 61:33]
  wire  s_axib_cvt_b_io_in_valid; // @[XConverter.scala 61:33]
  wire [3:0] s_axib_cvt_b_io_in_bits_id; // @[XConverter.scala 61:33]
  wire [1:0] s_axib_cvt_b_io_in_bits_resp; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_aw_io_in_clk; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_aw_io_out_clk; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_aw_io_rstn; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_aw_io_in_ready; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_aw_io_in_valid; // @[XConverter.scala 61:33]
  wire [31:0] axil2reg_io_axi_cvt_aw_io_in_bits_addr; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_aw_io_out_ready; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_aw_io_out_valid; // @[XConverter.scala 61:33]
  wire [31:0] axil2reg_io_axi_cvt_aw_io_out_bits_addr; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_ar_io_in_clk; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_ar_io_out_clk; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_ar_io_rstn; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_ar_io_in_ready; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_ar_io_in_valid; // @[XConverter.scala 61:33]
  wire [31:0] axil2reg_io_axi_cvt_ar_io_in_bits_addr; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_ar_io_out_ready; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_ar_io_out_valid; // @[XConverter.scala 61:33]
  wire [31:0] axil2reg_io_axi_cvt_ar_io_out_bits_addr; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_w_io_in_clk; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_w_io_out_clk; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_w_io_rstn; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_w_io_in_ready; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_w_io_in_valid; // @[XConverter.scala 61:33]
  wire [31:0] axil2reg_io_axi_cvt_w_io_in_bits_data; // @[XConverter.scala 61:33]
  wire [3:0] axil2reg_io_axi_cvt_w_io_in_bits_strb; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_w_io_out_ready; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_w_io_out_valid; // @[XConverter.scala 61:33]
  wire [31:0] axil2reg_io_axi_cvt_w_io_out_bits_data; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_r_io_in_clk; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_r_io_out_clk; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_r_io_rstn; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_r_io_in_ready; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_r_io_in_valid; // @[XConverter.scala 61:33]
  wire [31:0] axil2reg_io_axi_cvt_r_io_in_bits_data; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_r_io_out_ready; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_r_io_out_valid; // @[XConverter.scala 61:33]
  wire [31:0] axil2reg_io_axi_cvt_r_io_out_bits_data; // @[XConverter.scala 61:33]
  wire [1:0] axil2reg_io_axi_cvt_r_io_out_bits_resp; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_b_io_in_clk; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_b_io_out_clk; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_b_io_rstn; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_b_io_out_ready; // @[XConverter.scala 61:33]
  wire  axil2reg_io_axi_cvt_b_io_out_valid; // @[XConverter.scala 61:33]
  wire [1:0] axil2reg_io_axi_cvt_b_io_out_bits_resp; // @[XConverter.scala 61:33]
  wire  boundary_split_clock; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_reset; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_io_cmd_in_ready; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_io_cmd_in_valid; // @[QDMADynamic.scala 116:82]
  wire [63:0] boundary_split_io_cmd_in_bits_addr; // @[QDMADynamic.scala 116:82]
  wire [10:0] boundary_split_io_cmd_in_bits_qid; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_io_cmd_in_bits_error; // @[QDMADynamic.scala 116:82]
  wire [7:0] boundary_split_io_cmd_in_bits_func; // @[QDMADynamic.scala 116:82]
  wire [2:0] boundary_split_io_cmd_in_bits_port_id; // @[QDMADynamic.scala 116:82]
  wire [6:0] boundary_split_io_cmd_in_bits_pfch_tag; // @[QDMADynamic.scala 116:82]
  wire [31:0] boundary_split_io_cmd_in_bits_len; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_io_data_out_ready; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_io_data_out_valid; // @[QDMADynamic.scala 116:82]
  wire [511:0] boundary_split_io_data_out_bits_data; // @[QDMADynamic.scala 116:82]
  wire [31:0] boundary_split_io_data_out_bits_tcrc; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_io_data_out_bits_ctrl_marker; // @[QDMADynamic.scala 116:82]
  wire [6:0] boundary_split_io_data_out_bits_ctrl_ecc; // @[QDMADynamic.scala 116:82]
  wire [31:0] boundary_split_io_data_out_bits_ctrl_len; // @[QDMADynamic.scala 116:82]
  wire [2:0] boundary_split_io_data_out_bits_ctrl_port_id; // @[QDMADynamic.scala 116:82]
  wire [10:0] boundary_split_io_data_out_bits_ctrl_qid; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_io_data_out_bits_ctrl_has_cmpt; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_io_data_out_bits_last; // @[QDMADynamic.scala 116:82]
  wire [5:0] boundary_split_io_data_out_bits_mty; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_io_cmd_out_ready; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_io_cmd_out_valid; // @[QDMADynamic.scala 116:82]
  wire [63:0] boundary_split_io_cmd_out_bits_addr; // @[QDMADynamic.scala 116:82]
  wire [10:0] boundary_split_io_cmd_out_bits_qid; // @[QDMADynamic.scala 116:82]
  wire  boundary_split_io_cmd_out_bits_error; // @[QDMADynamic.scala 116:82]
  wire [7:0] boundary_split_io_cmd_out_bits_func; // @[QDMADynamic.scala 116:82]
  wire [2:0] boundary_split_io_cmd_out_bits_port_id; // @[QDMADynamic.scala 116:82]
  wire [6:0] boundary_split_io_cmd_out_bits_pfch_tag; // @[QDMADynamic.scala 116:82]
  wire [31:0] boundary_split_io_cmd_out_bits_len; // @[QDMADynamic.scala 116:82]
  wire  _fifo_h2c_data_io_in_T = ~io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 52:73]
  wire  _T = ~io_user_arstn; // @[QDMADynamic.scala 62:73]
  reg  wr_tlb_valid_REG; // @[QDMADynamic.scala 81:99]
  reg  wr_tlb_valid_REG_1; // @[QDMADynamic.scala 81:90]
  wire  _T_6 = _T | sw_reset_pad_O; // @[QDMADynamic.scala 122:55]
  reg [31:0] counter; // @[Collector.scala 169:42]
  reg [31:0] counter_1; // @[Collector.scala 169:42]
  reg [31:0] counter_2; // @[Collector.scala 169:42]
  reg [31:0] counter_3; // @[Collector.scala 169:42]
  wire [31:0] _counter_T_7 = counter_3 + 32'h1; // @[Collector.scala 171:51]
  wire  _T_12 = _fifo_h2c_data_io_in_T | sw_reset_pad_O; // @[QDMADynamic.scala 129:49]
  reg [31:0] counter_4; // @[Collector.scala 169:42]
  wire  _T_13 = fifo_c2h_cmd_io_out_ready & fifo_c2h_cmd_io_out_valid; // @[Decoupled.scala 40:37]
  wire [31:0] _counter_T_9 = counter_4 + 32'h1; // @[Collector.scala 171:51]
  reg [31:0] counter_5; // @[Collector.scala 169:42]
  wire  _T_14 = fifo_h2c_cmd_io__out_ready & fifo_h2c_cmd_io__out_valid; // @[Decoupled.scala 40:37]
  wire [31:0] _counter_T_11 = counter_5 + 32'h1; // @[Collector.scala 171:51]
  reg [31:0] counter_6; // @[Collector.scala 169:42]
  wire  _T_15 = fifo_c2h_data_io__out_ready & fifo_c2h_data_io__out_valid; // @[Decoupled.scala 40:37]
  wire [31:0] _counter_T_13 = counter_6 + 32'h1; // @[Collector.scala 171:51]
  reg [31:0] counter_7; // @[Collector.scala 169:42]
  wire  _T_16 = fifo_h2c_data_io__in_ready & fifo_h2c_data_io__in_valid; // @[Decoupled.scala 40:37]
  wire [31:0] _counter_T_15 = counter_7 + 32'h1; // @[Collector.scala 171:51]
  BUFG sw_reset_pad ( // @[Buf.scala 33:34]
    .O(sw_reset_pad_O),
    .I(sw_reset_pad_I)
  );
  XConverter fifo_h2c_data ( // @[XConverter.scala 61:33]
    .io__in_clk(fifo_h2c_data_io__in_clk),
    .io__out_clk(fifo_h2c_data_io__out_clk),
    .io__rstn(fifo_h2c_data_io__rstn),
    .io__in_ready(fifo_h2c_data_io__in_ready),
    .io__in_valid(fifo_h2c_data_io__in_valid),
    .io__in_bits_data(fifo_h2c_data_io__in_bits_data),
    .io__in_bits_tcrc(fifo_h2c_data_io__in_bits_tcrc),
    .io__in_bits_tuser_qid(fifo_h2c_data_io__in_bits_tuser_qid),
    .io__in_bits_tuser_port_id(fifo_h2c_data_io__in_bits_tuser_port_id),
    .io__in_bits_tuser_err(fifo_h2c_data_io__in_bits_tuser_err),
    .io__in_bits_tuser_mdata(fifo_h2c_data_io__in_bits_tuser_mdata),
    .io__in_bits_tuser_mty(fifo_h2c_data_io__in_bits_tuser_mty),
    .io__in_bits_tuser_zero_byte(fifo_h2c_data_io__in_bits_tuser_zero_byte),
    .io__in_bits_last(fifo_h2c_data_io__in_bits_last),
    .io__out_valid(fifo_h2c_data_io__out_valid),
    .io_in_ready(fifo_h2c_data_io_in_ready),
    .io_in_valid(fifo_h2c_data_io_in_valid)
  );
  RegSlice fifo_h2c_data_io_in_queue ( // @[RegSlices.scala 64:35]
    .clock(fifo_h2c_data_io_in_queue_clock),
    .reset(fifo_h2c_data_io_in_queue_reset),
    .io_upStream_ready(fifo_h2c_data_io_in_queue_io_upStream_ready),
    .io_upStream_valid(fifo_h2c_data_io_in_queue_io_upStream_valid),
    .io_upStream_bits_data(fifo_h2c_data_io_in_queue_io_upStream_bits_data),
    .io_upStream_bits_tcrc(fifo_h2c_data_io_in_queue_io_upStream_bits_tcrc),
    .io_upStream_bits_tuser_qid(fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_qid),
    .io_upStream_bits_tuser_port_id(fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_port_id),
    .io_upStream_bits_tuser_err(fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_err),
    .io_upStream_bits_tuser_mdata(fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_mdata),
    .io_upStream_bits_tuser_mty(fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_mty),
    .io_upStream_bits_tuser_zero_byte(fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_zero_byte),
    .io_upStream_bits_last(fifo_h2c_data_io_in_queue_io_upStream_bits_last),
    .io_downStream_ready(fifo_h2c_data_io_in_queue_io_downStream_ready),
    .io_downStream_valid(fifo_h2c_data_io_in_queue_io_downStream_valid),
    .io_downStream_bits_data(fifo_h2c_data_io_in_queue_io_downStream_bits_data),
    .io_downStream_bits_tcrc(fifo_h2c_data_io_in_queue_io_downStream_bits_tcrc),
    .io_downStream_bits_tuser_qid(fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_qid),
    .io_downStream_bits_tuser_port_id(fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_port_id),
    .io_downStream_bits_tuser_err(fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_err),
    .io_downStream_bits_tuser_mdata(fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_mdata),
    .io_downStream_bits_tuser_mty(fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_mty),
    .io_downStream_bits_tuser_zero_byte(fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_zero_byte),
    .io_downStream_bits_last(fifo_h2c_data_io_in_queue_io_downStream_bits_last)
  );
  XConverter_1 fifo_c2h_data ( // @[XConverter.scala 61:33]
    .io__in_clk(fifo_c2h_data_io__in_clk),
    .io__out_clk(fifo_c2h_data_io__out_clk),
    .io__rstn(fifo_c2h_data_io__rstn),
    .io__in_ready(fifo_c2h_data_io__in_ready),
    .io__in_valid(fifo_c2h_data_io__in_valid),
    .io__in_bits_data(fifo_c2h_data_io__in_bits_data),
    .io__in_bits_tcrc(fifo_c2h_data_io__in_bits_tcrc),
    .io__in_bits_ctrl_marker(fifo_c2h_data_io__in_bits_ctrl_marker),
    .io__in_bits_ctrl_ecc(fifo_c2h_data_io__in_bits_ctrl_ecc),
    .io__in_bits_ctrl_len(fifo_c2h_data_io__in_bits_ctrl_len),
    .io__in_bits_ctrl_port_id(fifo_c2h_data_io__in_bits_ctrl_port_id),
    .io__in_bits_ctrl_qid(fifo_c2h_data_io__in_bits_ctrl_qid),
    .io__in_bits_ctrl_has_cmpt(fifo_c2h_data_io__in_bits_ctrl_has_cmpt),
    .io__in_bits_last(fifo_c2h_data_io__in_bits_last),
    .io__in_bits_mty(fifo_c2h_data_io__in_bits_mty),
    .io__out_ready(fifo_c2h_data_io__out_ready),
    .io__out_valid(fifo_c2h_data_io__out_valid),
    .io__out_bits_data(fifo_c2h_data_io__out_bits_data),
    .io__out_bits_tcrc(fifo_c2h_data_io__out_bits_tcrc),
    .io__out_bits_ctrl_marker(fifo_c2h_data_io__out_bits_ctrl_marker),
    .io__out_bits_ctrl_ecc(fifo_c2h_data_io__out_bits_ctrl_ecc),
    .io__out_bits_ctrl_len(fifo_c2h_data_io__out_bits_ctrl_len),
    .io__out_bits_ctrl_port_id(fifo_c2h_data_io__out_bits_ctrl_port_id),
    .io__out_bits_ctrl_qid(fifo_c2h_data_io__out_bits_ctrl_qid),
    .io__out_bits_ctrl_has_cmpt(fifo_c2h_data_io__out_bits_ctrl_has_cmpt),
    .io__out_bits_last(fifo_c2h_data_io__out_bits_last),
    .io__out_bits_mty(fifo_c2h_data_io__out_bits_mty),
    .io_out_ready(fifo_c2h_data_io_out_ready),
    .io_out_valid_0(fifo_c2h_data_io_out_valid_0)
  );
  RegSlice_1 fifo_c2h_data_out_queue ( // @[RegSlices.scala 64:35]
    .clock(fifo_c2h_data_out_queue_clock),
    .reset(fifo_c2h_data_out_queue_reset),
    .io_upStream_ready(fifo_c2h_data_out_queue_io_upStream_ready),
    .io_upStream_valid(fifo_c2h_data_out_queue_io_upStream_valid),
    .io_upStream_bits_data(fifo_c2h_data_out_queue_io_upStream_bits_data),
    .io_upStream_bits_tcrc(fifo_c2h_data_out_queue_io_upStream_bits_tcrc),
    .io_upStream_bits_ctrl_marker(fifo_c2h_data_out_queue_io_upStream_bits_ctrl_marker),
    .io_upStream_bits_ctrl_ecc(fifo_c2h_data_out_queue_io_upStream_bits_ctrl_ecc),
    .io_upStream_bits_ctrl_len(fifo_c2h_data_out_queue_io_upStream_bits_ctrl_len),
    .io_upStream_bits_ctrl_port_id(fifo_c2h_data_out_queue_io_upStream_bits_ctrl_port_id),
    .io_upStream_bits_ctrl_qid(fifo_c2h_data_out_queue_io_upStream_bits_ctrl_qid),
    .io_upStream_bits_ctrl_has_cmpt(fifo_c2h_data_out_queue_io_upStream_bits_ctrl_has_cmpt),
    .io_upStream_bits_last(fifo_c2h_data_out_queue_io_upStream_bits_last),
    .io_upStream_bits_mty(fifo_c2h_data_out_queue_io_upStream_bits_mty),
    .io_downStream_ready(fifo_c2h_data_out_queue_io_downStream_ready),
    .io_downStream_valid(fifo_c2h_data_out_queue_io_downStream_valid),
    .io_downStream_bits_data(fifo_c2h_data_out_queue_io_downStream_bits_data),
    .io_downStream_bits_tcrc(fifo_c2h_data_out_queue_io_downStream_bits_tcrc),
    .io_downStream_bits_ctrl_marker(fifo_c2h_data_out_queue_io_downStream_bits_ctrl_marker),
    .io_downStream_bits_ctrl_ecc(fifo_c2h_data_out_queue_io_downStream_bits_ctrl_ecc),
    .io_downStream_bits_ctrl_len(fifo_c2h_data_out_queue_io_downStream_bits_ctrl_len),
    .io_downStream_bits_ctrl_port_id(fifo_c2h_data_out_queue_io_downStream_bits_ctrl_port_id),
    .io_downStream_bits_ctrl_qid(fifo_c2h_data_out_queue_io_downStream_bits_ctrl_qid),
    .io_downStream_bits_ctrl_has_cmpt(fifo_c2h_data_out_queue_io_downStream_bits_ctrl_has_cmpt),
    .io_downStream_bits_last(fifo_c2h_data_out_queue_io_downStream_bits_last),
    .io_downStream_bits_mty(fifo_c2h_data_out_queue_io_downStream_bits_mty)
  );
  XConverter_2 fifo_h2c_cmd ( // @[XConverter.scala 61:33]
    .io__in_clk(fifo_h2c_cmd_io__in_clk),
    .io__out_clk(fifo_h2c_cmd_io__out_clk),
    .io__rstn(fifo_h2c_cmd_io__rstn),
    .io__in_ready(fifo_h2c_cmd_io__in_ready),
    .io__in_valid(fifo_h2c_cmd_io__in_valid),
    .io__in_bits_addr(fifo_h2c_cmd_io__in_bits_addr),
    .io__in_bits_len(fifo_h2c_cmd_io__in_bits_len),
    .io__in_bits_eop(fifo_h2c_cmd_io__in_bits_eop),
    .io__in_bits_sop(fifo_h2c_cmd_io__in_bits_sop),
    .io__in_bits_mrkr_req(fifo_h2c_cmd_io__in_bits_mrkr_req),
    .io__in_bits_sdi(fifo_h2c_cmd_io__in_bits_sdi),
    .io__in_bits_qid(fifo_h2c_cmd_io__in_bits_qid),
    .io__in_bits_error(fifo_h2c_cmd_io__in_bits_error),
    .io__in_bits_func(fifo_h2c_cmd_io__in_bits_func),
    .io__in_bits_cidx(fifo_h2c_cmd_io__in_bits_cidx),
    .io__in_bits_port_id(fifo_h2c_cmd_io__in_bits_port_id),
    .io__in_bits_no_dma(fifo_h2c_cmd_io__in_bits_no_dma),
    .io__out_ready(fifo_h2c_cmd_io__out_ready),
    .io__out_valid(fifo_h2c_cmd_io__out_valid),
    .io__out_bits_addr(fifo_h2c_cmd_io__out_bits_addr),
    .io__out_bits_len(fifo_h2c_cmd_io__out_bits_len),
    .io__out_bits_eop(fifo_h2c_cmd_io__out_bits_eop),
    .io__out_bits_sop(fifo_h2c_cmd_io__out_bits_sop),
    .io__out_bits_mrkr_req(fifo_h2c_cmd_io__out_bits_mrkr_req),
    .io__out_bits_sdi(fifo_h2c_cmd_io__out_bits_sdi),
    .io__out_bits_qid(fifo_h2c_cmd_io__out_bits_qid),
    .io__out_bits_error(fifo_h2c_cmd_io__out_bits_error),
    .io__out_bits_func(fifo_h2c_cmd_io__out_bits_func),
    .io__out_bits_cidx(fifo_h2c_cmd_io__out_bits_cidx),
    .io__out_bits_port_id(fifo_h2c_cmd_io__out_bits_port_id),
    .io__out_bits_no_dma(fifo_h2c_cmd_io__out_bits_no_dma),
    .io_out_valid(fifo_h2c_cmd_io_out_valid),
    .io_out_ready_1(fifo_h2c_cmd_io_out_ready_1)
  );
  RegSlice_2 fifo_h2c_cmd_out_queue ( // @[RegSlices.scala 64:35]
    .clock(fifo_h2c_cmd_out_queue_clock),
    .reset(fifo_h2c_cmd_out_queue_reset),
    .io_upStream_ready(fifo_h2c_cmd_out_queue_io_upStream_ready),
    .io_upStream_valid(fifo_h2c_cmd_out_queue_io_upStream_valid),
    .io_upStream_bits_addr(fifo_h2c_cmd_out_queue_io_upStream_bits_addr),
    .io_upStream_bits_len(fifo_h2c_cmd_out_queue_io_upStream_bits_len),
    .io_upStream_bits_eop(fifo_h2c_cmd_out_queue_io_upStream_bits_eop),
    .io_upStream_bits_sop(fifo_h2c_cmd_out_queue_io_upStream_bits_sop),
    .io_upStream_bits_mrkr_req(fifo_h2c_cmd_out_queue_io_upStream_bits_mrkr_req),
    .io_upStream_bits_sdi(fifo_h2c_cmd_out_queue_io_upStream_bits_sdi),
    .io_upStream_bits_qid(fifo_h2c_cmd_out_queue_io_upStream_bits_qid),
    .io_upStream_bits_error(fifo_h2c_cmd_out_queue_io_upStream_bits_error),
    .io_upStream_bits_func(fifo_h2c_cmd_out_queue_io_upStream_bits_func),
    .io_upStream_bits_cidx(fifo_h2c_cmd_out_queue_io_upStream_bits_cidx),
    .io_upStream_bits_port_id(fifo_h2c_cmd_out_queue_io_upStream_bits_port_id),
    .io_upStream_bits_no_dma(fifo_h2c_cmd_out_queue_io_upStream_bits_no_dma),
    .io_downStream_ready(fifo_h2c_cmd_out_queue_io_downStream_ready),
    .io_downStream_valid(fifo_h2c_cmd_out_queue_io_downStream_valid),
    .io_downStream_bits_addr(fifo_h2c_cmd_out_queue_io_downStream_bits_addr),
    .io_downStream_bits_len(fifo_h2c_cmd_out_queue_io_downStream_bits_len),
    .io_downStream_bits_eop(fifo_h2c_cmd_out_queue_io_downStream_bits_eop),
    .io_downStream_bits_sop(fifo_h2c_cmd_out_queue_io_downStream_bits_sop),
    .io_downStream_bits_mrkr_req(fifo_h2c_cmd_out_queue_io_downStream_bits_mrkr_req),
    .io_downStream_bits_sdi(fifo_h2c_cmd_out_queue_io_downStream_bits_sdi),
    .io_downStream_bits_qid(fifo_h2c_cmd_out_queue_io_downStream_bits_qid),
    .io_downStream_bits_error(fifo_h2c_cmd_out_queue_io_downStream_bits_error),
    .io_downStream_bits_func(fifo_h2c_cmd_out_queue_io_downStream_bits_func),
    .io_downStream_bits_cidx(fifo_h2c_cmd_out_queue_io_downStream_bits_cidx),
    .io_downStream_bits_port_id(fifo_h2c_cmd_out_queue_io_downStream_bits_port_id),
    .io_downStream_bits_no_dma(fifo_h2c_cmd_out_queue_io_downStream_bits_no_dma)
  );
  XConverter_3 fifo_c2h_cmd ( // @[XConverter.scala 61:33]
    .io_in_clk(fifo_c2h_cmd_io_in_clk),
    .io_out_clk(fifo_c2h_cmd_io_out_clk),
    .io_rstn(fifo_c2h_cmd_io_rstn),
    .io_in_ready(fifo_c2h_cmd_io_in_ready),
    .io_in_valid(fifo_c2h_cmd_io_in_valid),
    .io_in_bits_addr(fifo_c2h_cmd_io_in_bits_addr),
    .io_in_bits_qid(fifo_c2h_cmd_io_in_bits_qid),
    .io_in_bits_error(fifo_c2h_cmd_io_in_bits_error),
    .io_in_bits_func(fifo_c2h_cmd_io_in_bits_func),
    .io_in_bits_port_id(fifo_c2h_cmd_io_in_bits_port_id),
    .io_in_bits_pfch_tag(fifo_c2h_cmd_io_in_bits_pfch_tag),
    .io_in_bits_len(fifo_c2h_cmd_io_in_bits_len),
    .io_out_ready(fifo_c2h_cmd_io_out_ready),
    .io_out_valid(fifo_c2h_cmd_io_out_valid),
    .io_out_bits_addr(fifo_c2h_cmd_io_out_bits_addr),
    .io_out_bits_qid(fifo_c2h_cmd_io_out_bits_qid),
    .io_out_bits_error(fifo_c2h_cmd_io_out_bits_error),
    .io_out_bits_func(fifo_c2h_cmd_io_out_bits_func),
    .io_out_bits_port_id(fifo_c2h_cmd_io_out_bits_port_id),
    .io_out_bits_pfch_tag(fifo_c2h_cmd_io_out_bits_pfch_tag),
    .io_out_bits_len(fifo_c2h_cmd_io_out_bits_len),
    .io_out_ready_0(fifo_c2h_cmd_io_out_ready_0),
    .io_out_valid_1(fifo_c2h_cmd_io_out_valid_1)
  );
  RegSlice_3 fifo_c2h_cmd_out_queue ( // @[RegSlices.scala 64:35]
    .clock(fifo_c2h_cmd_out_queue_clock),
    .reset(fifo_c2h_cmd_out_queue_reset),
    .io_upStream_ready(fifo_c2h_cmd_out_queue_io_upStream_ready),
    .io_upStream_valid(fifo_c2h_cmd_out_queue_io_upStream_valid),
    .io_upStream_bits_addr(fifo_c2h_cmd_out_queue_io_upStream_bits_addr),
    .io_upStream_bits_qid(fifo_c2h_cmd_out_queue_io_upStream_bits_qid),
    .io_upStream_bits_error(fifo_c2h_cmd_out_queue_io_upStream_bits_error),
    .io_upStream_bits_func(fifo_c2h_cmd_out_queue_io_upStream_bits_func),
    .io_upStream_bits_port_id(fifo_c2h_cmd_out_queue_io_upStream_bits_port_id),
    .io_upStream_bits_pfch_tag(fifo_c2h_cmd_out_queue_io_upStream_bits_pfch_tag),
    .io_upStream_bits_len(fifo_c2h_cmd_out_queue_io_upStream_bits_len),
    .io_downStream_ready(fifo_c2h_cmd_out_queue_io_downStream_ready),
    .io_downStream_valid(fifo_c2h_cmd_out_queue_io_downStream_valid),
    .io_downStream_bits_addr(fifo_c2h_cmd_out_queue_io_downStream_bits_addr),
    .io_downStream_bits_qid(fifo_c2h_cmd_out_queue_io_downStream_bits_qid),
    .io_downStream_bits_error(fifo_c2h_cmd_out_queue_io_downStream_bits_error),
    .io_downStream_bits_func(fifo_c2h_cmd_out_queue_io_downStream_bits_func),
    .io_downStream_bits_port_id(fifo_c2h_cmd_out_queue_io_downStream_bits_port_id),
    .io_downStream_bits_pfch_tag(fifo_c2h_cmd_out_queue_io_downStream_bits_pfch_tag),
    .io_downStream_bits_len(fifo_c2h_cmd_out_queue_io_downStream_bits_len)
  );
  CMDBoundaryCheck check_c2h ( // @[QDMADynamic.scala 62:95]
    .clock(check_c2h_clock),
    .reset(check_c2h_reset),
    .io_in_ready(check_c2h_io_in_ready),
    .io_in_valid(check_c2h_io_in_valid),
    .io_in_bits_addr(check_c2h_io_in_bits_addr),
    .io_in_bits_qid(check_c2h_io_in_bits_qid),
    .io_in_bits_error(check_c2h_io_in_bits_error),
    .io_in_bits_func(check_c2h_io_in_bits_func),
    .io_in_bits_port_id(check_c2h_io_in_bits_port_id),
    .io_in_bits_pfch_tag(check_c2h_io_in_bits_pfch_tag),
    .io_in_bits_len(check_c2h_io_in_bits_len),
    .io_out_ready(check_c2h_io_out_ready),
    .io_out_valid(check_c2h_io_out_valid),
    .io_out_bits_addr(check_c2h_io_out_bits_addr),
    .io_out_bits_qid(check_c2h_io_out_bits_qid),
    .io_out_bits_error(check_c2h_io_out_bits_error),
    .io_out_bits_func(check_c2h_io_out_bits_func),
    .io_out_bits_port_id(check_c2h_io_out_bits_port_id),
    .io_out_bits_pfch_tag(check_c2h_io_out_bits_pfch_tag),
    .io_out_bits_len(check_c2h_io_out_bits_len)
  );
  RegSlice_3 check_c2h_io_in_queue ( // @[RegSlices.scala 64:35]
    .clock(check_c2h_io_in_queue_clock),
    .reset(check_c2h_io_in_queue_reset),
    .io_upStream_ready(check_c2h_io_in_queue_io_upStream_ready),
    .io_upStream_valid(check_c2h_io_in_queue_io_upStream_valid),
    .io_upStream_bits_addr(check_c2h_io_in_queue_io_upStream_bits_addr),
    .io_upStream_bits_qid(check_c2h_io_in_queue_io_upStream_bits_qid),
    .io_upStream_bits_error(check_c2h_io_in_queue_io_upStream_bits_error),
    .io_upStream_bits_func(check_c2h_io_in_queue_io_upStream_bits_func),
    .io_upStream_bits_port_id(check_c2h_io_in_queue_io_upStream_bits_port_id),
    .io_upStream_bits_pfch_tag(check_c2h_io_in_queue_io_upStream_bits_pfch_tag),
    .io_upStream_bits_len(check_c2h_io_in_queue_io_upStream_bits_len),
    .io_downStream_ready(check_c2h_io_in_queue_io_downStream_ready),
    .io_downStream_valid(check_c2h_io_in_queue_io_downStream_valid),
    .io_downStream_bits_addr(check_c2h_io_in_queue_io_downStream_bits_addr),
    .io_downStream_bits_qid(check_c2h_io_in_queue_io_downStream_bits_qid),
    .io_downStream_bits_error(check_c2h_io_in_queue_io_downStream_bits_error),
    .io_downStream_bits_func(check_c2h_io_in_queue_io_downStream_bits_func),
    .io_downStream_bits_port_id(check_c2h_io_in_queue_io_downStream_bits_port_id),
    .io_downStream_bits_pfch_tag(check_c2h_io_in_queue_io_downStream_bits_pfch_tag),
    .io_downStream_bits_len(check_c2h_io_in_queue_io_downStream_bits_len)
  );
  CMDBoundaryCheck_1 check_h2c ( // @[QDMADynamic.scala 64:95]
    .clock(check_h2c_clock),
    .reset(check_h2c_reset),
    .io_in_ready(check_h2c_io_in_ready),
    .io_in_valid(check_h2c_io_in_valid),
    .io_in_bits_addr(check_h2c_io_in_bits_addr),
    .io_in_bits_len(check_h2c_io_in_bits_len),
    .io_in_bits_eop(check_h2c_io_in_bits_eop),
    .io_in_bits_sop(check_h2c_io_in_bits_sop),
    .io_in_bits_mrkr_req(check_h2c_io_in_bits_mrkr_req),
    .io_in_bits_sdi(check_h2c_io_in_bits_sdi),
    .io_in_bits_qid(check_h2c_io_in_bits_qid),
    .io_in_bits_error(check_h2c_io_in_bits_error),
    .io_in_bits_func(check_h2c_io_in_bits_func),
    .io_in_bits_cidx(check_h2c_io_in_bits_cidx),
    .io_in_bits_port_id(check_h2c_io_in_bits_port_id),
    .io_in_bits_no_dma(check_h2c_io_in_bits_no_dma),
    .io_out_ready(check_h2c_io_out_ready),
    .io_out_valid(check_h2c_io_out_valid),
    .io_out_bits_addr(check_h2c_io_out_bits_addr),
    .io_out_bits_len(check_h2c_io_out_bits_len),
    .io_out_bits_eop(check_h2c_io_out_bits_eop),
    .io_out_bits_sop(check_h2c_io_out_bits_sop),
    .io_out_bits_mrkr_req(check_h2c_io_out_bits_mrkr_req),
    .io_out_bits_sdi(check_h2c_io_out_bits_sdi),
    .io_out_bits_qid(check_h2c_io_out_bits_qid),
    .io_out_bits_error(check_h2c_io_out_bits_error),
    .io_out_bits_func(check_h2c_io_out_bits_func),
    .io_out_bits_cidx(check_h2c_io_out_bits_cidx),
    .io_out_bits_port_id(check_h2c_io_out_bits_port_id),
    .io_out_bits_no_dma(check_h2c_io_out_bits_no_dma)
  );
  RegSlice_2 check_h2c_io_in_queue ( // @[RegSlices.scala 64:35]
    .clock(check_h2c_io_in_queue_clock),
    .reset(check_h2c_io_in_queue_reset),
    .io_upStream_ready(check_h2c_io_in_queue_io_upStream_ready),
    .io_upStream_valid(check_h2c_io_in_queue_io_upStream_valid),
    .io_upStream_bits_addr(check_h2c_io_in_queue_io_upStream_bits_addr),
    .io_upStream_bits_len(check_h2c_io_in_queue_io_upStream_bits_len),
    .io_upStream_bits_eop(check_h2c_io_in_queue_io_upStream_bits_eop),
    .io_upStream_bits_sop(check_h2c_io_in_queue_io_upStream_bits_sop),
    .io_upStream_bits_mrkr_req(check_h2c_io_in_queue_io_upStream_bits_mrkr_req),
    .io_upStream_bits_sdi(check_h2c_io_in_queue_io_upStream_bits_sdi),
    .io_upStream_bits_qid(check_h2c_io_in_queue_io_upStream_bits_qid),
    .io_upStream_bits_error(check_h2c_io_in_queue_io_upStream_bits_error),
    .io_upStream_bits_func(check_h2c_io_in_queue_io_upStream_bits_func),
    .io_upStream_bits_cidx(check_h2c_io_in_queue_io_upStream_bits_cidx),
    .io_upStream_bits_port_id(check_h2c_io_in_queue_io_upStream_bits_port_id),
    .io_upStream_bits_no_dma(check_h2c_io_in_queue_io_upStream_bits_no_dma),
    .io_downStream_ready(check_h2c_io_in_queue_io_downStream_ready),
    .io_downStream_valid(check_h2c_io_in_queue_io_downStream_valid),
    .io_downStream_bits_addr(check_h2c_io_in_queue_io_downStream_bits_addr),
    .io_downStream_bits_len(check_h2c_io_in_queue_io_downStream_bits_len),
    .io_downStream_bits_eop(check_h2c_io_in_queue_io_downStream_bits_eop),
    .io_downStream_bits_sop(check_h2c_io_in_queue_io_downStream_bits_sop),
    .io_downStream_bits_mrkr_req(check_h2c_io_in_queue_io_downStream_bits_mrkr_req),
    .io_downStream_bits_sdi(check_h2c_io_in_queue_io_downStream_bits_sdi),
    .io_downStream_bits_qid(check_h2c_io_in_queue_io_downStream_bits_qid),
    .io_downStream_bits_error(check_h2c_io_in_queue_io_downStream_bits_error),
    .io_downStream_bits_func(check_h2c_io_in_queue_io_downStream_bits_func),
    .io_downStream_bits_cidx(check_h2c_io_in_queue_io_downStream_bits_cidx),
    .io_downStream_bits_port_id(check_h2c_io_in_queue_io_downStream_bits_port_id),
    .io_downStream_bits_no_dma(check_h2c_io_in_queue_io_downStream_bits_no_dma)
  );
  TLB tlb ( // @[QDMADynamic.scala 67:71]
    .clock(tlb_clock),
    .reset(tlb_reset),
    .io__wr_tlb_ready(tlb_io__wr_tlb_ready),
    .io__wr_tlb_valid(tlb_io__wr_tlb_valid),
    .io__wr_tlb_bits_vaddr_high(tlb_io__wr_tlb_bits_vaddr_high),
    .io__wr_tlb_bits_vaddr_low(tlb_io__wr_tlb_bits_vaddr_low),
    .io__wr_tlb_bits_paddr_high(tlb_io__wr_tlb_bits_paddr_high),
    .io__wr_tlb_bits_paddr_low(tlb_io__wr_tlb_bits_paddr_low),
    .io__wr_tlb_bits_is_base(tlb_io__wr_tlb_bits_is_base),
    .io__h2c_in_ready(tlb_io__h2c_in_ready),
    .io__h2c_in_valid(tlb_io__h2c_in_valid),
    .io__h2c_in_bits_addr(tlb_io__h2c_in_bits_addr),
    .io__h2c_in_bits_len(tlb_io__h2c_in_bits_len),
    .io__h2c_in_bits_eop(tlb_io__h2c_in_bits_eop),
    .io__h2c_in_bits_sop(tlb_io__h2c_in_bits_sop),
    .io__h2c_in_bits_mrkr_req(tlb_io__h2c_in_bits_mrkr_req),
    .io__h2c_in_bits_sdi(tlb_io__h2c_in_bits_sdi),
    .io__h2c_in_bits_qid(tlb_io__h2c_in_bits_qid),
    .io__h2c_in_bits_error(tlb_io__h2c_in_bits_error),
    .io__h2c_in_bits_func(tlb_io__h2c_in_bits_func),
    .io__h2c_in_bits_cidx(tlb_io__h2c_in_bits_cidx),
    .io__h2c_in_bits_port_id(tlb_io__h2c_in_bits_port_id),
    .io__h2c_in_bits_no_dma(tlb_io__h2c_in_bits_no_dma),
    .io__c2h_in_ready(tlb_io__c2h_in_ready),
    .io__c2h_in_valid(tlb_io__c2h_in_valid),
    .io__c2h_in_bits_addr(tlb_io__c2h_in_bits_addr),
    .io__c2h_in_bits_qid(tlb_io__c2h_in_bits_qid),
    .io__c2h_in_bits_error(tlb_io__c2h_in_bits_error),
    .io__c2h_in_bits_func(tlb_io__c2h_in_bits_func),
    .io__c2h_in_bits_port_id(tlb_io__c2h_in_bits_port_id),
    .io__c2h_in_bits_pfch_tag(tlb_io__c2h_in_bits_pfch_tag),
    .io__c2h_in_bits_len(tlb_io__c2h_in_bits_len),
    .io__h2c_out_ready(tlb_io__h2c_out_ready),
    .io__h2c_out_valid(tlb_io__h2c_out_valid),
    .io__h2c_out_bits_addr(tlb_io__h2c_out_bits_addr),
    .io__h2c_out_bits_len(tlb_io__h2c_out_bits_len),
    .io__h2c_out_bits_eop(tlb_io__h2c_out_bits_eop),
    .io__h2c_out_bits_sop(tlb_io__h2c_out_bits_sop),
    .io__h2c_out_bits_mrkr_req(tlb_io__h2c_out_bits_mrkr_req),
    .io__h2c_out_bits_sdi(tlb_io__h2c_out_bits_sdi),
    .io__h2c_out_bits_qid(tlb_io__h2c_out_bits_qid),
    .io__h2c_out_bits_error(tlb_io__h2c_out_bits_error),
    .io__h2c_out_bits_func(tlb_io__h2c_out_bits_func),
    .io__h2c_out_bits_cidx(tlb_io__h2c_out_bits_cidx),
    .io__h2c_out_bits_port_id(tlb_io__h2c_out_bits_port_id),
    .io__h2c_out_bits_no_dma(tlb_io__h2c_out_bits_no_dma),
    .io__c2h_out_ready(tlb_io__c2h_out_ready),
    .io__c2h_out_valid(tlb_io__c2h_out_valid),
    .io__c2h_out_bits_addr(tlb_io__c2h_out_bits_addr),
    .io__c2h_out_bits_qid(tlb_io__c2h_out_bits_qid),
    .io__c2h_out_bits_error(tlb_io__c2h_out_bits_error),
    .io__c2h_out_bits_func(tlb_io__c2h_out_bits_func),
    .io__c2h_out_bits_port_id(tlb_io__c2h_out_bits_port_id),
    .io__c2h_out_bits_pfch_tag(tlb_io__c2h_out_bits_pfch_tag),
    .io__c2h_out_bits_len(tlb_io__c2h_out_bits_len),
    .io__tlb_miss_count(tlb_io__tlb_miss_count),
    .io_tlb_miss_count(tlb_io_tlb_miss_count)
  );
  RegSlice_2 tlb_io_h2c_in_queue ( // @[RegSlices.scala 64:35]
    .clock(tlb_io_h2c_in_queue_clock),
    .reset(tlb_io_h2c_in_queue_reset),
    .io_upStream_ready(tlb_io_h2c_in_queue_io_upStream_ready),
    .io_upStream_valid(tlb_io_h2c_in_queue_io_upStream_valid),
    .io_upStream_bits_addr(tlb_io_h2c_in_queue_io_upStream_bits_addr),
    .io_upStream_bits_len(tlb_io_h2c_in_queue_io_upStream_bits_len),
    .io_upStream_bits_eop(tlb_io_h2c_in_queue_io_upStream_bits_eop),
    .io_upStream_bits_sop(tlb_io_h2c_in_queue_io_upStream_bits_sop),
    .io_upStream_bits_mrkr_req(tlb_io_h2c_in_queue_io_upStream_bits_mrkr_req),
    .io_upStream_bits_sdi(tlb_io_h2c_in_queue_io_upStream_bits_sdi),
    .io_upStream_bits_qid(tlb_io_h2c_in_queue_io_upStream_bits_qid),
    .io_upStream_bits_error(tlb_io_h2c_in_queue_io_upStream_bits_error),
    .io_upStream_bits_func(tlb_io_h2c_in_queue_io_upStream_bits_func),
    .io_upStream_bits_cidx(tlb_io_h2c_in_queue_io_upStream_bits_cidx),
    .io_upStream_bits_port_id(tlb_io_h2c_in_queue_io_upStream_bits_port_id),
    .io_upStream_bits_no_dma(tlb_io_h2c_in_queue_io_upStream_bits_no_dma),
    .io_downStream_ready(tlb_io_h2c_in_queue_io_downStream_ready),
    .io_downStream_valid(tlb_io_h2c_in_queue_io_downStream_valid),
    .io_downStream_bits_addr(tlb_io_h2c_in_queue_io_downStream_bits_addr),
    .io_downStream_bits_len(tlb_io_h2c_in_queue_io_downStream_bits_len),
    .io_downStream_bits_eop(tlb_io_h2c_in_queue_io_downStream_bits_eop),
    .io_downStream_bits_sop(tlb_io_h2c_in_queue_io_downStream_bits_sop),
    .io_downStream_bits_mrkr_req(tlb_io_h2c_in_queue_io_downStream_bits_mrkr_req),
    .io_downStream_bits_sdi(tlb_io_h2c_in_queue_io_downStream_bits_sdi),
    .io_downStream_bits_qid(tlb_io_h2c_in_queue_io_downStream_bits_qid),
    .io_downStream_bits_error(tlb_io_h2c_in_queue_io_downStream_bits_error),
    .io_downStream_bits_func(tlb_io_h2c_in_queue_io_downStream_bits_func),
    .io_downStream_bits_cidx(tlb_io_h2c_in_queue_io_downStream_bits_cidx),
    .io_downStream_bits_port_id(tlb_io_h2c_in_queue_io_downStream_bits_port_id),
    .io_downStream_bits_no_dma(tlb_io_h2c_in_queue_io_downStream_bits_no_dma)
  );
  RegSlice_3 tlb_io_c2h_in_queue ( // @[RegSlices.scala 64:35]
    .clock(tlb_io_c2h_in_queue_clock),
    .reset(tlb_io_c2h_in_queue_reset),
    .io_upStream_ready(tlb_io_c2h_in_queue_io_upStream_ready),
    .io_upStream_valid(tlb_io_c2h_in_queue_io_upStream_valid),
    .io_upStream_bits_addr(tlb_io_c2h_in_queue_io_upStream_bits_addr),
    .io_upStream_bits_qid(tlb_io_c2h_in_queue_io_upStream_bits_qid),
    .io_upStream_bits_error(tlb_io_c2h_in_queue_io_upStream_bits_error),
    .io_upStream_bits_func(tlb_io_c2h_in_queue_io_upStream_bits_func),
    .io_upStream_bits_port_id(tlb_io_c2h_in_queue_io_upStream_bits_port_id),
    .io_upStream_bits_pfch_tag(tlb_io_c2h_in_queue_io_upStream_bits_pfch_tag),
    .io_upStream_bits_len(tlb_io_c2h_in_queue_io_upStream_bits_len),
    .io_downStream_ready(tlb_io_c2h_in_queue_io_downStream_ready),
    .io_downStream_valid(tlb_io_c2h_in_queue_io_downStream_valid),
    .io_downStream_bits_addr(tlb_io_c2h_in_queue_io_downStream_bits_addr),
    .io_downStream_bits_qid(tlb_io_c2h_in_queue_io_downStream_bits_qid),
    .io_downStream_bits_error(tlb_io_c2h_in_queue_io_downStream_bits_error),
    .io_downStream_bits_func(tlb_io_c2h_in_queue_io_downStream_bits_func),
    .io_downStream_bits_port_id(tlb_io_c2h_in_queue_io_downStream_bits_port_id),
    .io_downStream_bits_pfch_tag(tlb_io_c2h_in_queue_io_downStream_bits_pfch_tag),
    .io_downStream_bits_len(tlb_io_c2h_in_queue_io_downStream_bits_len)
  );
  RegSlice_2 fifo_h2c_cmd_io_in_queue ( // @[RegSlices.scala 64:35]
    .clock(fifo_h2c_cmd_io_in_queue_clock),
    .reset(fifo_h2c_cmd_io_in_queue_reset),
    .io_upStream_ready(fifo_h2c_cmd_io_in_queue_io_upStream_ready),
    .io_upStream_valid(fifo_h2c_cmd_io_in_queue_io_upStream_valid),
    .io_upStream_bits_addr(fifo_h2c_cmd_io_in_queue_io_upStream_bits_addr),
    .io_upStream_bits_len(fifo_h2c_cmd_io_in_queue_io_upStream_bits_len),
    .io_upStream_bits_eop(fifo_h2c_cmd_io_in_queue_io_upStream_bits_eop),
    .io_upStream_bits_sop(fifo_h2c_cmd_io_in_queue_io_upStream_bits_sop),
    .io_upStream_bits_mrkr_req(fifo_h2c_cmd_io_in_queue_io_upStream_bits_mrkr_req),
    .io_upStream_bits_sdi(fifo_h2c_cmd_io_in_queue_io_upStream_bits_sdi),
    .io_upStream_bits_qid(fifo_h2c_cmd_io_in_queue_io_upStream_bits_qid),
    .io_upStream_bits_error(fifo_h2c_cmd_io_in_queue_io_upStream_bits_error),
    .io_upStream_bits_func(fifo_h2c_cmd_io_in_queue_io_upStream_bits_func),
    .io_upStream_bits_cidx(fifo_h2c_cmd_io_in_queue_io_upStream_bits_cidx),
    .io_upStream_bits_port_id(fifo_h2c_cmd_io_in_queue_io_upStream_bits_port_id),
    .io_upStream_bits_no_dma(fifo_h2c_cmd_io_in_queue_io_upStream_bits_no_dma),
    .io_downStream_ready(fifo_h2c_cmd_io_in_queue_io_downStream_ready),
    .io_downStream_valid(fifo_h2c_cmd_io_in_queue_io_downStream_valid),
    .io_downStream_bits_addr(fifo_h2c_cmd_io_in_queue_io_downStream_bits_addr),
    .io_downStream_bits_len(fifo_h2c_cmd_io_in_queue_io_downStream_bits_len),
    .io_downStream_bits_eop(fifo_h2c_cmd_io_in_queue_io_downStream_bits_eop),
    .io_downStream_bits_sop(fifo_h2c_cmd_io_in_queue_io_downStream_bits_sop),
    .io_downStream_bits_mrkr_req(fifo_h2c_cmd_io_in_queue_io_downStream_bits_mrkr_req),
    .io_downStream_bits_sdi(fifo_h2c_cmd_io_in_queue_io_downStream_bits_sdi),
    .io_downStream_bits_qid(fifo_h2c_cmd_io_in_queue_io_downStream_bits_qid),
    .io_downStream_bits_error(fifo_h2c_cmd_io_in_queue_io_downStream_bits_error),
    .io_downStream_bits_func(fifo_h2c_cmd_io_in_queue_io_downStream_bits_func),
    .io_downStream_bits_cidx(fifo_h2c_cmd_io_in_queue_io_downStream_bits_cidx),
    .io_downStream_bits_port_id(fifo_h2c_cmd_io_in_queue_io_downStream_bits_port_id),
    .io_downStream_bits_no_dma(fifo_h2c_cmd_io_in_queue_io_downStream_bits_no_dma)
  );
  PoorAXIL2Reg axil2reg ( // @[QDMADynamic.scala 86:76]
    .clock(axil2reg_clock),
    .reset(axil2reg_reset),
    .io_axi_aw_ready(axil2reg_io_axi_aw_ready),
    .io_axi_aw_valid(axil2reg_io_axi_aw_valid),
    .io_axi_aw_bits_addr(axil2reg_io_axi_aw_bits_addr),
    .io_axi_ar_ready(axil2reg_io_axi_ar_ready),
    .io_axi_ar_valid(axil2reg_io_axi_ar_valid),
    .io_axi_ar_bits_addr(axil2reg_io_axi_ar_bits_addr),
    .io_axi_w_ready(axil2reg_io_axi_w_ready),
    .io_axi_w_valid(axil2reg_io_axi_w_valid),
    .io_axi_w_bits_data(axil2reg_io_axi_w_bits_data),
    .io_axi_r_ready(axil2reg_io_axi_r_ready),
    .io_axi_r_valid(axil2reg_io_axi_r_valid),
    .io_axi_r_bits_data(axil2reg_io_axi_r_bits_data),
    .io_reg_control_0(axil2reg_io_reg_control_0),
    .io_reg_control_8(axil2reg_io_reg_control_8),
    .io_reg_control_9(axil2reg_io_reg_control_9),
    .io_reg_control_10(axil2reg_io_reg_control_10),
    .io_reg_control_11(axil2reg_io_reg_control_11),
    .io_reg_control_12(axil2reg_io_reg_control_12),
    .io_reg_control_13(axil2reg_io_reg_control_13),
    .io_reg_control_14(axil2reg_io_reg_control_14),
    .io_reg_status_400(axil2reg_io_reg_status_400),
    .io_reg_status_401(axil2reg_io_reg_status_401),
    .io_reg_status_402(axil2reg_io_reg_status_402),
    .io_reg_status_403(axil2reg_io_reg_status_403),
    .io_reg_status_404(axil2reg_io_reg_status_404),
    .io_reg_status_405(axil2reg_io_reg_status_405),
    .io_reg_status_406(axil2reg_io_reg_status_406),
    .io_reg_status_407(axil2reg_io_reg_status_407),
    .io_reg_status_408(axil2reg_io_reg_status_408),
    .io_reg_status_409(axil2reg_io_reg_status_409)
  );
  XConverter_4 io_axib_cvt_aw ( // @[XConverter.scala 61:33]
    .io_in_clk(io_axib_cvt_aw_io_in_clk),
    .io_out_clk(io_axib_cvt_aw_io_out_clk),
    .io_rstn(io_axib_cvt_aw_io_rstn),
    .io_in_ready(io_axib_cvt_aw_io_in_ready),
    .io_in_valid(io_axib_cvt_aw_io_in_valid),
    .io_in_bits_addr(io_axib_cvt_aw_io_in_bits_addr),
    .io_in_bits_burst(io_axib_cvt_aw_io_in_bits_burst),
    .io_in_bits_cache(io_axib_cvt_aw_io_in_bits_cache),
    .io_in_bits_id(io_axib_cvt_aw_io_in_bits_id),
    .io_in_bits_len(io_axib_cvt_aw_io_in_bits_len),
    .io_in_bits_lock(io_axib_cvt_aw_io_in_bits_lock),
    .io_in_bits_prot(io_axib_cvt_aw_io_in_bits_prot),
    .io_in_bits_size(io_axib_cvt_aw_io_in_bits_size)
  );
  XConverter_4 io_axib_cvt_ar ( // @[XConverter.scala 61:33]
    .io_in_clk(io_axib_cvt_ar_io_in_clk),
    .io_out_clk(io_axib_cvt_ar_io_out_clk),
    .io_rstn(io_axib_cvt_ar_io_rstn),
    .io_in_ready(io_axib_cvt_ar_io_in_ready),
    .io_in_valid(io_axib_cvt_ar_io_in_valid),
    .io_in_bits_addr(io_axib_cvt_ar_io_in_bits_addr),
    .io_in_bits_burst(io_axib_cvt_ar_io_in_bits_burst),
    .io_in_bits_cache(io_axib_cvt_ar_io_in_bits_cache),
    .io_in_bits_id(io_axib_cvt_ar_io_in_bits_id),
    .io_in_bits_len(io_axib_cvt_ar_io_in_bits_len),
    .io_in_bits_lock(io_axib_cvt_ar_io_in_bits_lock),
    .io_in_bits_prot(io_axib_cvt_ar_io_in_bits_prot),
    .io_in_bits_size(io_axib_cvt_ar_io_in_bits_size)
  );
  XConverter_6 io_axib_cvt_w ( // @[XConverter.scala 61:33]
    .io_in_clk(io_axib_cvt_w_io_in_clk),
    .io_out_clk(io_axib_cvt_w_io_out_clk),
    .io_rstn(io_axib_cvt_w_io_rstn),
    .io_in_ready(io_axib_cvt_w_io_in_ready),
    .io_in_valid(io_axib_cvt_w_io_in_valid),
    .io_in_bits_data(io_axib_cvt_w_io_in_bits_data),
    .io_in_bits_last(io_axib_cvt_w_io_in_bits_last),
    .io_in_bits_strb(io_axib_cvt_w_io_in_bits_strb)
  );
  XConverter_7 io_axib_cvt_r ( // @[XConverter.scala 61:33]
    .io_in_clk(io_axib_cvt_r_io_in_clk),
    .io_out_clk(io_axib_cvt_r_io_out_clk),
    .io_rstn(io_axib_cvt_r_io_rstn),
    .io_out_ready(io_axib_cvt_r_io_out_ready),
    .io_out_valid(io_axib_cvt_r_io_out_valid),
    .io_out_bits_data(io_axib_cvt_r_io_out_bits_data),
    .io_out_bits_last(io_axib_cvt_r_io_out_bits_last),
    .io_out_bits_resp(io_axib_cvt_r_io_out_bits_resp),
    .io_out_bits_id(io_axib_cvt_r_io_out_bits_id)
  );
  XConverter_8 io_axib_cvt_b ( // @[XConverter.scala 61:33]
    .io_in_clk(io_axib_cvt_b_io_in_clk),
    .io_out_clk(io_axib_cvt_b_io_out_clk),
    .io_rstn(io_axib_cvt_b_io_rstn),
    .io_out_ready(io_axib_cvt_b_io_out_ready),
    .io_out_valid(io_axib_cvt_b_io_out_valid),
    .io_out_bits_id(io_axib_cvt_b_io_out_bits_id),
    .io_out_bits_resp(io_axib_cvt_b_io_out_bits_resp)
  );
  XConverter_9 s_axib_cvt_aw ( // @[XConverter.scala 61:33]
    .io_in_clk(s_axib_cvt_aw_io_in_clk),
    .io_out_clk(s_axib_cvt_aw_io_out_clk),
    .io_rstn(s_axib_cvt_aw_io_rstn),
    .io_out_ready(s_axib_cvt_aw_io_out_ready),
    .io_out_valid(s_axib_cvt_aw_io_out_valid),
    .io_out_bits_addr(s_axib_cvt_aw_io_out_bits_addr),
    .io_out_bits_burst(s_axib_cvt_aw_io_out_bits_burst),
    .io_out_bits_id(s_axib_cvt_aw_io_out_bits_id),
    .io_out_bits_len(s_axib_cvt_aw_io_out_bits_len),
    .io_out_bits_size(s_axib_cvt_aw_io_out_bits_size)
  );
  XConverter_9 s_axib_cvt_ar ( // @[XConverter.scala 61:33]
    .io_in_clk(s_axib_cvt_ar_io_in_clk),
    .io_out_clk(s_axib_cvt_ar_io_out_clk),
    .io_rstn(s_axib_cvt_ar_io_rstn),
    .io_out_ready(s_axib_cvt_ar_io_out_ready),
    .io_out_valid(s_axib_cvt_ar_io_out_valid),
    .io_out_bits_addr(s_axib_cvt_ar_io_out_bits_addr),
    .io_out_bits_burst(s_axib_cvt_ar_io_out_bits_burst),
    .io_out_bits_id(s_axib_cvt_ar_io_out_bits_id),
    .io_out_bits_len(s_axib_cvt_ar_io_out_bits_len),
    .io_out_bits_size(s_axib_cvt_ar_io_out_bits_size)
  );
  XConverter_11 s_axib_cvt_w ( // @[XConverter.scala 61:33]
    .io_in_clk(s_axib_cvt_w_io_in_clk),
    .io_out_clk(s_axib_cvt_w_io_out_clk),
    .io_rstn(s_axib_cvt_w_io_rstn),
    .io_out_ready(s_axib_cvt_w_io_out_ready),
    .io_out_valid(s_axib_cvt_w_io_out_valid),
    .io_out_bits_data(s_axib_cvt_w_io_out_bits_data),
    .io_out_bits_last(s_axib_cvt_w_io_out_bits_last),
    .io_out_bits_strb(s_axib_cvt_w_io_out_bits_strb)
  );
  XConverter_12 s_axib_cvt_r ( // @[XConverter.scala 61:33]
    .io_in_clk(s_axib_cvt_r_io_in_clk),
    .io_out_clk(s_axib_cvt_r_io_out_clk),
    .io_rstn(s_axib_cvt_r_io_rstn),
    .io_in_ready(s_axib_cvt_r_io_in_ready),
    .io_in_valid(s_axib_cvt_r_io_in_valid),
    .io_in_bits_data(s_axib_cvt_r_io_in_bits_data),
    .io_in_bits_last(s_axib_cvt_r_io_in_bits_last),
    .io_in_bits_resp(s_axib_cvt_r_io_in_bits_resp),
    .io_in_bits_id(s_axib_cvt_r_io_in_bits_id)
  );
  XConverter_13 s_axib_cvt_b ( // @[XConverter.scala 61:33]
    .io_in_clk(s_axib_cvt_b_io_in_clk),
    .io_out_clk(s_axib_cvt_b_io_out_clk),
    .io_rstn(s_axib_cvt_b_io_rstn),
    .io_in_ready(s_axib_cvt_b_io_in_ready),
    .io_in_valid(s_axib_cvt_b_io_in_valid),
    .io_in_bits_id(s_axib_cvt_b_io_in_bits_id),
    .io_in_bits_resp(s_axib_cvt_b_io_in_bits_resp)
  );
  XConverter_14 axil2reg_io_axi_cvt_aw ( // @[XConverter.scala 61:33]
    .io_in_clk(axil2reg_io_axi_cvt_aw_io_in_clk),
    .io_out_clk(axil2reg_io_axi_cvt_aw_io_out_clk),
    .io_rstn(axil2reg_io_axi_cvt_aw_io_rstn),
    .io_in_ready(axil2reg_io_axi_cvt_aw_io_in_ready),
    .io_in_valid(axil2reg_io_axi_cvt_aw_io_in_valid),
    .io_in_bits_addr(axil2reg_io_axi_cvt_aw_io_in_bits_addr),
    .io_out_ready(axil2reg_io_axi_cvt_aw_io_out_ready),
    .io_out_valid(axil2reg_io_axi_cvt_aw_io_out_valid),
    .io_out_bits_addr(axil2reg_io_axi_cvt_aw_io_out_bits_addr)
  );
  XConverter_14 axil2reg_io_axi_cvt_ar ( // @[XConverter.scala 61:33]
    .io_in_clk(axil2reg_io_axi_cvt_ar_io_in_clk),
    .io_out_clk(axil2reg_io_axi_cvt_ar_io_out_clk),
    .io_rstn(axil2reg_io_axi_cvt_ar_io_rstn),
    .io_in_ready(axil2reg_io_axi_cvt_ar_io_in_ready),
    .io_in_valid(axil2reg_io_axi_cvt_ar_io_in_valid),
    .io_in_bits_addr(axil2reg_io_axi_cvt_ar_io_in_bits_addr),
    .io_out_ready(axil2reg_io_axi_cvt_ar_io_out_ready),
    .io_out_valid(axil2reg_io_axi_cvt_ar_io_out_valid),
    .io_out_bits_addr(axil2reg_io_axi_cvt_ar_io_out_bits_addr)
  );
  XConverter_16 axil2reg_io_axi_cvt_w ( // @[XConverter.scala 61:33]
    .io_in_clk(axil2reg_io_axi_cvt_w_io_in_clk),
    .io_out_clk(axil2reg_io_axi_cvt_w_io_out_clk),
    .io_rstn(axil2reg_io_axi_cvt_w_io_rstn),
    .io_in_ready(axil2reg_io_axi_cvt_w_io_in_ready),
    .io_in_valid(axil2reg_io_axi_cvt_w_io_in_valid),
    .io_in_bits_data(axil2reg_io_axi_cvt_w_io_in_bits_data),
    .io_in_bits_strb(axil2reg_io_axi_cvt_w_io_in_bits_strb),
    .io_out_ready(axil2reg_io_axi_cvt_w_io_out_ready),
    .io_out_valid(axil2reg_io_axi_cvt_w_io_out_valid),
    .io_out_bits_data(axil2reg_io_axi_cvt_w_io_out_bits_data)
  );
  XConverter_17 axil2reg_io_axi_cvt_r ( // @[XConverter.scala 61:33]
    .io_in_clk(axil2reg_io_axi_cvt_r_io_in_clk),
    .io_out_clk(axil2reg_io_axi_cvt_r_io_out_clk),
    .io_rstn(axil2reg_io_axi_cvt_r_io_rstn),
    .io_in_ready(axil2reg_io_axi_cvt_r_io_in_ready),
    .io_in_valid(axil2reg_io_axi_cvt_r_io_in_valid),
    .io_in_bits_data(axil2reg_io_axi_cvt_r_io_in_bits_data),
    .io_out_ready(axil2reg_io_axi_cvt_r_io_out_ready),
    .io_out_valid(axil2reg_io_axi_cvt_r_io_out_valid),
    .io_out_bits_data(axil2reg_io_axi_cvt_r_io_out_bits_data),
    .io_out_bits_resp(axil2reg_io_axi_cvt_r_io_out_bits_resp)
  );
  XConverter_18 axil2reg_io_axi_cvt_b ( // @[XConverter.scala 61:33]
    .io_in_clk(axil2reg_io_axi_cvt_b_io_in_clk),
    .io_out_clk(axil2reg_io_axi_cvt_b_io_out_clk),
    .io_rstn(axil2reg_io_axi_cvt_b_io_rstn),
    .io_out_ready(axil2reg_io_axi_cvt_b_io_out_ready),
    .io_out_valid(axil2reg_io_axi_cvt_b_io_out_valid),
    .io_out_bits_resp(axil2reg_io_axi_cvt_b_io_out_bits_resp)
  );
  DataBoundarySplit boundary_split ( // @[QDMADynamic.scala 116:82]
    .clock(boundary_split_clock),
    .reset(boundary_split_reset),
    .io_cmd_in_ready(boundary_split_io_cmd_in_ready),
    .io_cmd_in_valid(boundary_split_io_cmd_in_valid),
    .io_cmd_in_bits_addr(boundary_split_io_cmd_in_bits_addr),
    .io_cmd_in_bits_qid(boundary_split_io_cmd_in_bits_qid),
    .io_cmd_in_bits_error(boundary_split_io_cmd_in_bits_error),
    .io_cmd_in_bits_func(boundary_split_io_cmd_in_bits_func),
    .io_cmd_in_bits_port_id(boundary_split_io_cmd_in_bits_port_id),
    .io_cmd_in_bits_pfch_tag(boundary_split_io_cmd_in_bits_pfch_tag),
    .io_cmd_in_bits_len(boundary_split_io_cmd_in_bits_len),
    .io_data_out_ready(boundary_split_io_data_out_ready),
    .io_data_out_valid(boundary_split_io_data_out_valid),
    .io_data_out_bits_data(boundary_split_io_data_out_bits_data),
    .io_data_out_bits_tcrc(boundary_split_io_data_out_bits_tcrc),
    .io_data_out_bits_ctrl_marker(boundary_split_io_data_out_bits_ctrl_marker),
    .io_data_out_bits_ctrl_ecc(boundary_split_io_data_out_bits_ctrl_ecc),
    .io_data_out_bits_ctrl_len(boundary_split_io_data_out_bits_ctrl_len),
    .io_data_out_bits_ctrl_port_id(boundary_split_io_data_out_bits_ctrl_port_id),
    .io_data_out_bits_ctrl_qid(boundary_split_io_data_out_bits_ctrl_qid),
    .io_data_out_bits_ctrl_has_cmpt(boundary_split_io_data_out_bits_ctrl_has_cmpt),
    .io_data_out_bits_last(boundary_split_io_data_out_bits_last),
    .io_data_out_bits_mty(boundary_split_io_data_out_bits_mty),
    .io_cmd_out_ready(boundary_split_io_cmd_out_ready),
    .io_cmd_out_valid(boundary_split_io_cmd_out_valid),
    .io_cmd_out_bits_addr(boundary_split_io_cmd_out_bits_addr),
    .io_cmd_out_bits_qid(boundary_split_io_cmd_out_bits_qid),
    .io_cmd_out_bits_error(boundary_split_io_cmd_out_bits_error),
    .io_cmd_out_bits_func(boundary_split_io_cmd_out_bits_func),
    .io_cmd_out_bits_port_id(boundary_split_io_cmd_out_bits_port_id),
    .io_cmd_out_bits_pfch_tag(boundary_split_io_cmd_out_bits_pfch_tag),
    .io_cmd_out_bits_len(boundary_split_io_cmd_out_bits_len)
  );
  assign io_qdma_port_m_axib_awready = io_axib_cvt_aw_io_in_ready; // @[QDMADynamic.scala 92:24 XConverter.scala 35:33]
  assign io_qdma_port_m_axib_wready = io_axib_cvt_w_io_in_ready; // @[QDMADynamic.scala 92:24 XConverter.scala 37:33]
  assign io_qdma_port_m_axib_bid = io_axib_cvt_b_io_out_bits_id; // @[QDMADynamic.scala 92:24 XConverter.scala 39:33]
  assign io_qdma_port_m_axib_bresp = io_axib_cvt_b_io_out_bits_resp; // @[QDMADynamic.scala 92:24 XConverter.scala 39:33]
  assign io_qdma_port_m_axib_bvalid = io_axib_cvt_b_io_out_valid; // @[QDMADynamic.scala 92:24 XConverter.scala 39:33]
  assign io_qdma_port_m_axib_arready = io_axib_cvt_ar_io_in_ready; // @[QDMADynamic.scala 92:24 XConverter.scala 36:33]
  assign io_qdma_port_m_axib_rid = io_axib_cvt_r_io_out_bits_id; // @[QDMADynamic.scala 92:24 XConverter.scala 38:33]
  assign io_qdma_port_m_axib_rdata = io_axib_cvt_r_io_out_bits_data; // @[QDMADynamic.scala 92:24 XConverter.scala 38:33]
  assign io_qdma_port_m_axib_rresp = io_axib_cvt_r_io_out_bits_resp; // @[QDMADynamic.scala 92:24 XConverter.scala 38:33]
  assign io_qdma_port_m_axib_rlast = io_axib_cvt_r_io_out_bits_last; // @[QDMADynamic.scala 92:24 XConverter.scala 38:33]
  assign io_qdma_port_m_axib_rvalid = io_axib_cvt_r_io_out_valid; // @[QDMADynamic.scala 92:24 XConverter.scala 38:33]
  assign io_qdma_port_m_axil_awready = axil2reg_io_axi_cvt_aw_io_in_ready; // @[QDMADynamic.scala 107:24 XConverter.scala 35:33]
  assign io_qdma_port_m_axil_wready = axil2reg_io_axi_cvt_w_io_in_ready; // @[QDMADynamic.scala 107:24 XConverter.scala 37:33]
  assign io_qdma_port_m_axil_bresp = axil2reg_io_axi_cvt_b_io_out_bits_resp; // @[QDMADynamic.scala 107:24 XConverter.scala 39:33]
  assign io_qdma_port_m_axil_bvalid = axil2reg_io_axi_cvt_b_io_out_valid; // @[QDMADynamic.scala 107:24 XConverter.scala 39:33]
  assign io_qdma_port_m_axil_arready = axil2reg_io_axi_cvt_ar_io_in_ready; // @[QDMADynamic.scala 107:24 XConverter.scala 36:33]
  assign io_qdma_port_m_axil_rdata = axil2reg_io_axi_cvt_r_io_out_bits_data; // @[QDMADynamic.scala 107:24 XConverter.scala 38:33]
  assign io_qdma_port_m_axil_rresp = axil2reg_io_axi_cvt_r_io_out_bits_resp; // @[QDMADynamic.scala 107:24 XConverter.scala 38:33]
  assign io_qdma_port_m_axil_rvalid = axil2reg_io_axi_cvt_r_io_out_valid; // @[QDMADynamic.scala 107:24 XConverter.scala 38:33]
  assign io_qdma_port_h2c_byp_in_st_addr = fifo_h2c_cmd_out_queue_io_downStream_bits_addr; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_len = fifo_h2c_cmd_out_queue_io_downStream_bits_len; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_eop = fifo_h2c_cmd_out_queue_io_downStream_bits_eop; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_sop = fifo_h2c_cmd_out_queue_io_downStream_bits_sop; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_mrkr_req = fifo_h2c_cmd_out_queue_io_downStream_bits_mrkr_req; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_sdi = fifo_h2c_cmd_out_queue_io_downStream_bits_sdi; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_qid = fifo_h2c_cmd_out_queue_io_downStream_bits_qid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_error = fifo_h2c_cmd_out_queue_io_downStream_bits_error; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_func = fifo_h2c_cmd_out_queue_io_downStream_bits_func; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_cidx = fifo_h2c_cmd_out_queue_io_downStream_bits_cidx; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_port_id = fifo_h2c_cmd_out_queue_io_downStream_bits_port_id; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_no_dma = fifo_h2c_cmd_out_queue_io_downStream_bits_no_dma; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_h2c_byp_in_st_vld = fifo_h2c_cmd_out_queue_io_downStream_valid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_c2h_byp_in_st_csh_addr = fifo_c2h_cmd_out_queue_io_downStream_bits_addr; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_c2h_byp_in_st_csh_qid = fifo_c2h_cmd_out_queue_io_downStream_bits_qid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_c2h_byp_in_st_csh_error = fifo_c2h_cmd_out_queue_io_downStream_bits_error; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_c2h_byp_in_st_csh_func = fifo_c2h_cmd_out_queue_io_downStream_bits_func; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_c2h_byp_in_st_csh_port_id = fifo_c2h_cmd_out_queue_io_downStream_bits_port_id; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_c2h_byp_in_st_csh_pfch_tag = fifo_c2h_cmd_out_queue_io_downStream_bits_pfch_tag; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_c2h_byp_in_st_csh_vld = fifo_c2h_cmd_out_queue_io_downStream_valid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_s_axis_c2h_tdata = fifo_c2h_data_out_queue_io_downStream_bits_data; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_s_axis_c2h_tcrc = fifo_c2h_data_out_queue_io_downStream_bits_tcrc; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_s_axis_c2h_ctrl_marker = fifo_c2h_data_out_queue_io_downStream_bits_ctrl_marker; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_s_axis_c2h_ctrl_ecc = fifo_c2h_data_out_queue_io_downStream_bits_ctrl_ecc; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_s_axis_c2h_ctrl_len = fifo_c2h_data_out_queue_io_downStream_bits_ctrl_len; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_s_axis_c2h_ctrl_port_id = fifo_c2h_data_out_queue_io_downStream_bits_ctrl_port_id; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_s_axis_c2h_ctrl_qid = fifo_c2h_data_out_queue_io_downStream_bits_ctrl_qid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_s_axis_c2h_ctrl_has_cmpt = fifo_c2h_data_out_queue_io_downStream_bits_ctrl_has_cmpt; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_s_axis_c2h_mty = fifo_c2h_data_out_queue_io_downStream_bits_mty; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_s_axis_c2h_tlast = fifo_c2h_data_out_queue_io_downStream_bits_last; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_s_axis_c2h_tvalid = fifo_c2h_data_out_queue_io_downStream_valid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign io_qdma_port_m_axis_h2c_tready = fifo_h2c_data_io_in_queue_io_upStream_ready; // @[QDMADynamic.scala 50:39 RegSlices.scala 65:41]
  assign io_qdma_port_s_axib_awid = s_axib_cvt_aw_io_out_bits_id; // @[XConverter.scala 22:39 XConverter.scala 41:33]
  assign io_qdma_port_s_axib_awaddr = s_axib_cvt_aw_io_out_bits_addr; // @[XConverter.scala 22:39 XConverter.scala 41:33]
  assign io_qdma_port_s_axib_awlen = s_axib_cvt_aw_io_out_bits_len; // @[XConverter.scala 22:39 XConverter.scala 41:33]
  assign io_qdma_port_s_axib_awsize = s_axib_cvt_aw_io_out_bits_size; // @[XConverter.scala 22:39 XConverter.scala 41:33]
  assign io_qdma_port_s_axib_awburst = s_axib_cvt_aw_io_out_bits_burst; // @[XConverter.scala 22:39 XConverter.scala 41:33]
  assign io_qdma_port_s_axib_awvalid = s_axib_cvt_aw_io_out_valid; // @[XConverter.scala 22:39 XConverter.scala 41:33]
  assign io_qdma_port_s_axib_wdata = s_axib_cvt_w_io_out_bits_data; // @[XConverter.scala 22:39 XConverter.scala 43:33]
  assign io_qdma_port_s_axib_wstrb = s_axib_cvt_w_io_out_bits_strb; // @[XConverter.scala 22:39 XConverter.scala 43:33]
  assign io_qdma_port_s_axib_wlast = s_axib_cvt_w_io_out_bits_last; // @[XConverter.scala 22:39 XConverter.scala 43:33]
  assign io_qdma_port_s_axib_wvalid = s_axib_cvt_w_io_out_valid; // @[XConverter.scala 22:39 XConverter.scala 43:33]
  assign io_qdma_port_s_axib_bready = s_axib_cvt_b_io_in_ready; // @[XConverter.scala 22:39 XConverter.scala 45:41]
  assign io_qdma_port_s_axib_arid = s_axib_cvt_ar_io_out_bits_id; // @[XConverter.scala 22:39 XConverter.scala 42:33]
  assign io_qdma_port_s_axib_araddr = s_axib_cvt_ar_io_out_bits_addr; // @[XConverter.scala 22:39 XConverter.scala 42:33]
  assign io_qdma_port_s_axib_arlen = s_axib_cvt_ar_io_out_bits_len; // @[XConverter.scala 22:39 XConverter.scala 42:33]
  assign io_qdma_port_s_axib_arsize = s_axib_cvt_ar_io_out_bits_size; // @[XConverter.scala 22:39 XConverter.scala 42:33]
  assign io_qdma_port_s_axib_arburst = s_axib_cvt_ar_io_out_bits_burst; // @[XConverter.scala 22:39 XConverter.scala 42:33]
  assign io_qdma_port_s_axib_arvalid = s_axib_cvt_ar_io_out_valid; // @[XConverter.scala 22:39 XConverter.scala 42:33]
  assign io_qdma_port_s_axib_rready = s_axib_cvt_r_io_in_ready; // @[XConverter.scala 22:39 XConverter.scala 44:41]
  assign io_h2c_data_valid = fifo_h2c_data_io__out_valid; // @[QDMADynamic.scala 53:33]
  assign io_reg_control_0 = axil2reg_io_reg_control_0; // @[QDMADynamic.scala 89:33]
  assign io_reg_control_8 = axil2reg_io_reg_control_8; // @[QDMADynamic.scala 89:33]
  assign io_reg_control_9 = axil2reg_io_reg_control_9; // @[QDMADynamic.scala 89:33]
  assign io_reg_control_10 = axil2reg_io_reg_control_10; // @[QDMADynamic.scala 89:33]
  assign io_reg_control_11 = axil2reg_io_reg_control_11; // @[QDMADynamic.scala 89:33]
  assign io_reg_control_12 = axil2reg_io_reg_control_12; // @[QDMADynamic.scala 89:33]
  assign io_reg_control_13 = axil2reg_io_reg_control_13; // @[QDMADynamic.scala 89:33]
  assign io_reg_control_14 = axil2reg_io_reg_control_14; // @[QDMADynamic.scala 89:33]
  assign io_out_valid = fifo_h2c_cmd_io_out_valid;
  assign counter_4_0 = counter_4;
  assign io_out_ready = fifo_c2h_data_io_out_ready;
  assign counter_7_0 = counter_7;
  assign counter_1_0 = counter_1;
  assign io_in_ready = fifo_h2c_data_io_in_ready;
  assign io_out_ready_0 = fifo_c2h_cmd_io_out_ready_0;
  assign counter_3_0 = counter_3;
  assign io_out_valid_0 = fifo_c2h_data_io_out_valid_0;
  assign counter_6_0 = counter_6;
  assign counter_0 = counter;
  assign io_in_valid = fifo_h2c_data_io_in_valid;
  assign io_tlb_miss_count = tlb_io_tlb_miss_count;
  assign io_out_valid_1 = fifo_c2h_cmd_io_out_valid_1;
  assign counter_2_0 = counter_2;
  assign io_out_ready_1 = fifo_h2c_cmd_io_out_ready_1;
  assign counter_5_0 = counter_5;
  assign sw_reset_pad_I = io_reg_control_14[0]; // @[QDMADynamic.scala 45:51]
  assign fifo_h2c_data_io__in_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign fifo_h2c_data_io__out_clk = io_user_clk; // @[XConverter.scala 63:33]
  assign fifo_h2c_data_io__rstn = io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 48:51]
  assign fifo_h2c_data_io__in_valid = fifo_h2c_data_io_in_queue_io_downStream_valid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_data_io__in_bits_data = fifo_h2c_data_io_in_queue_io_downStream_bits_data; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_data_io__in_bits_tcrc = fifo_h2c_data_io_in_queue_io_downStream_bits_tcrc; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_data_io__in_bits_tuser_qid = fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_qid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_data_io__in_bits_tuser_port_id = fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_port_id; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_data_io__in_bits_tuser_err = fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_err; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_data_io__in_bits_tuser_mdata = fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_mdata; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_data_io__in_bits_tuser_mty = fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_mty; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_data_io__in_bits_tuser_zero_byte = fifo_h2c_data_io_in_queue_io_downStream_bits_tuser_zero_byte; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_data_io__in_bits_last = fifo_h2c_data_io_in_queue_io_downStream_bits_last; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_data_io_in_queue_clock = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign fifo_h2c_data_io_in_queue_reset = ~io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 52:73]
  assign fifo_h2c_data_io_in_queue_io_upStream_valid = io_qdma_port_m_axis_h2c_tvalid; // @[QDMADynamic.scala 50:39 QDMADynamic.scala 201:57]
  assign fifo_h2c_data_io_in_queue_io_upStream_bits_data = io_qdma_port_m_axis_h2c_tdata; // @[QDMADynamic.scala 50:39 QDMADynamic.scala 192:57]
  assign fifo_h2c_data_io_in_queue_io_upStream_bits_tcrc = io_qdma_port_m_axis_h2c_tcrc; // @[QDMADynamic.scala 50:39 QDMADynamic.scala 193:57]
  assign fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_qid = io_qdma_port_m_axis_h2c_tuser_qid; // @[QDMADynamic.scala 50:39 QDMADynamic.scala 194:57]
  assign fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_port_id = io_qdma_port_m_axis_h2c_tuser_port_id; // @[QDMADynamic.scala 50:39 QDMADynamic.scala 195:49]
  assign fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_err = io_qdma_port_m_axis_h2c_tuser_err; // @[QDMADynamic.scala 50:39 QDMADynamic.scala 196:57]
  assign fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_mdata = io_qdma_port_m_axis_h2c_tuser_mdata; // @[QDMADynamic.scala 50:39 QDMADynamic.scala 197:57]
  assign fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_mty = io_qdma_port_m_axis_h2c_tuser_mty; // @[QDMADynamic.scala 50:39 QDMADynamic.scala 198:57]
  assign fifo_h2c_data_io_in_queue_io_upStream_bits_tuser_zero_byte = io_qdma_port_m_axis_h2c_tuser_zero_byte; // @[QDMADynamic.scala 50:39 QDMADynamic.scala 199:49]
  assign fifo_h2c_data_io_in_queue_io_upStream_bits_last = io_qdma_port_m_axis_h2c_tlast; // @[QDMADynamic.scala 50:39 QDMADynamic.scala 200:57]
  assign fifo_h2c_data_io_in_queue_io_downStream_ready = fifo_h2c_data_io__in_ready; // @[RegSlices.scala 63:38 QDMADynamic.scala 52:41]
  assign fifo_c2h_data_io__in_clk = io_user_clk; // @[XConverter.scala 62:33]
  assign fifo_c2h_data_io__out_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign fifo_c2h_data_io__rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign fifo_c2h_data_io__in_valid = boundary_split_io_data_out_valid; // @[QDMADynamic.scala 120:41]
  assign fifo_c2h_data_io__in_bits_data = boundary_split_io_data_out_bits_data; // @[QDMADynamic.scala 120:41]
  assign fifo_c2h_data_io__in_bits_tcrc = boundary_split_io_data_out_bits_tcrc; // @[QDMADynamic.scala 120:41]
  assign fifo_c2h_data_io__in_bits_ctrl_marker = boundary_split_io_data_out_bits_ctrl_marker; // @[QDMADynamic.scala 120:41]
  assign fifo_c2h_data_io__in_bits_ctrl_ecc = boundary_split_io_data_out_bits_ctrl_ecc; // @[QDMADynamic.scala 120:41]
  assign fifo_c2h_data_io__in_bits_ctrl_len = boundary_split_io_data_out_bits_ctrl_len; // @[QDMADynamic.scala 120:41]
  assign fifo_c2h_data_io__in_bits_ctrl_port_id = boundary_split_io_data_out_bits_ctrl_port_id; // @[QDMADynamic.scala 120:41]
  assign fifo_c2h_data_io__in_bits_ctrl_qid = boundary_split_io_data_out_bits_ctrl_qid; // @[QDMADynamic.scala 120:41]
  assign fifo_c2h_data_io__in_bits_ctrl_has_cmpt = boundary_split_io_data_out_bits_ctrl_has_cmpt; // @[QDMADynamic.scala 120:41]
  assign fifo_c2h_data_io__in_bits_last = boundary_split_io_data_out_bits_last; // @[QDMADynamic.scala 120:41]
  assign fifo_c2h_data_io__in_bits_mty = boundary_split_io_data_out_bits_mty; // @[QDMADynamic.scala 120:41]
  assign fifo_c2h_data_io__out_ready = fifo_c2h_data_out_queue_io_upStream_ready; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_clock = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign fifo_c2h_data_out_queue_reset = ~io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 56:64]
  assign fifo_c2h_data_out_queue_io_upStream_valid = fifo_c2h_data_io__out_valid; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_io_upStream_bits_data = fifo_c2h_data_io__out_bits_data; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_io_upStream_bits_tcrc = fifo_c2h_data_io__out_bits_tcrc; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_io_upStream_bits_ctrl_marker = fifo_c2h_data_io__out_bits_ctrl_marker; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_io_upStream_bits_ctrl_ecc = fifo_c2h_data_io__out_bits_ctrl_ecc; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_io_upStream_bits_ctrl_len = fifo_c2h_data_io__out_bits_ctrl_len; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_io_upStream_bits_ctrl_port_id = fifo_c2h_data_io__out_bits_ctrl_port_id; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_io_upStream_bits_ctrl_qid = fifo_c2h_data_io__out_bits_ctrl_qid; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_io_upStream_bits_ctrl_has_cmpt = fifo_c2h_data_io__out_bits_ctrl_has_cmpt; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_io_upStream_bits_last = fifo_c2h_data_io__out_bits_last; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_io_upStream_bits_mty = fifo_c2h_data_io__out_bits_mty; // @[RegSlices.scala 65:41]
  assign fifo_c2h_data_out_queue_io_downStream_ready = io_qdma_port_s_axis_c2h_tready; // @[RegSlices.scala 63:38 QDMADynamic.scala 189:57]
  assign fifo_h2c_cmd_io__in_clk = io_user_clk; // @[XConverter.scala 62:33]
  assign fifo_h2c_cmd_io__out_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign fifo_h2c_cmd_io__rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign fifo_h2c_cmd_io__in_valid = fifo_h2c_cmd_io_in_queue_io_downStream_valid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_addr = fifo_h2c_cmd_io_in_queue_io_downStream_bits_addr; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_len = fifo_h2c_cmd_io_in_queue_io_downStream_bits_len; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_eop = fifo_h2c_cmd_io_in_queue_io_downStream_bits_eop; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_sop = fifo_h2c_cmd_io_in_queue_io_downStream_bits_sop; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_mrkr_req = fifo_h2c_cmd_io_in_queue_io_downStream_bits_mrkr_req; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_sdi = fifo_h2c_cmd_io_in_queue_io_downStream_bits_sdi; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_qid = fifo_h2c_cmd_io_in_queue_io_downStream_bits_qid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_error = fifo_h2c_cmd_io_in_queue_io_downStream_bits_error; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_func = fifo_h2c_cmd_io_in_queue_io_downStream_bits_func; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_cidx = fifo_h2c_cmd_io_in_queue_io_downStream_bits_cidx; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_port_id = fifo_h2c_cmd_io_in_queue_io_downStream_bits_port_id; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__in_bits_no_dma = fifo_h2c_cmd_io_in_queue_io_downStream_bits_no_dma; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign fifo_h2c_cmd_io__out_ready = fifo_h2c_cmd_out_queue_io_upStream_ready; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_clock = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign fifo_h2c_cmd_out_queue_reset = ~io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 58:64]
  assign fifo_h2c_cmd_out_queue_io_upStream_valid = fifo_h2c_cmd_io__out_valid; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_addr = fifo_h2c_cmd_io__out_bits_addr; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_len = fifo_h2c_cmd_io__out_bits_len; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_eop = fifo_h2c_cmd_io__out_bits_eop; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_sop = fifo_h2c_cmd_io__out_bits_sop; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_mrkr_req = fifo_h2c_cmd_io__out_bits_mrkr_req; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_sdi = fifo_h2c_cmd_io__out_bits_sdi; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_qid = fifo_h2c_cmd_io__out_bits_qid; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_error = fifo_h2c_cmd_io__out_bits_error; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_func = fifo_h2c_cmd_io__out_bits_func; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_cidx = fifo_h2c_cmd_io__out_bits_cidx; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_port_id = fifo_h2c_cmd_io__out_bits_port_id; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_upStream_bits_no_dma = fifo_h2c_cmd_io__out_bits_no_dma; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_out_queue_io_downStream_ready = io_qdma_port_h2c_byp_in_st_rdy; // @[RegSlices.scala 63:38 QDMADynamic.scala 165:49]
  assign fifo_c2h_cmd_io_in_clk = io_user_clk; // @[XConverter.scala 62:33]
  assign fifo_c2h_cmd_io_out_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign fifo_c2h_cmd_io_rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign fifo_c2h_cmd_io_in_valid = boundary_split_io_cmd_out_valid; // @[QDMADynamic.scala 119:41]
  assign fifo_c2h_cmd_io_in_bits_addr = boundary_split_io_cmd_out_bits_addr; // @[QDMADynamic.scala 119:41]
  assign fifo_c2h_cmd_io_in_bits_qid = boundary_split_io_cmd_out_bits_qid; // @[QDMADynamic.scala 119:41]
  assign fifo_c2h_cmd_io_in_bits_error = boundary_split_io_cmd_out_bits_error; // @[QDMADynamic.scala 119:41]
  assign fifo_c2h_cmd_io_in_bits_func = boundary_split_io_cmd_out_bits_func; // @[QDMADynamic.scala 119:41]
  assign fifo_c2h_cmd_io_in_bits_port_id = boundary_split_io_cmd_out_bits_port_id; // @[QDMADynamic.scala 119:41]
  assign fifo_c2h_cmd_io_in_bits_pfch_tag = boundary_split_io_cmd_out_bits_pfch_tag; // @[QDMADynamic.scala 119:41]
  assign fifo_c2h_cmd_io_in_bits_len = boundary_split_io_cmd_out_bits_len; // @[QDMADynamic.scala 119:41]
  assign fifo_c2h_cmd_io_out_ready = fifo_c2h_cmd_out_queue_io_upStream_ready; // @[RegSlices.scala 65:41]
  assign fifo_c2h_cmd_out_queue_clock = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign fifo_c2h_cmd_out_queue_reset = ~io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 60:64]
  assign fifo_c2h_cmd_out_queue_io_upStream_valid = fifo_c2h_cmd_io_out_valid; // @[RegSlices.scala 65:41]
  assign fifo_c2h_cmd_out_queue_io_upStream_bits_addr = fifo_c2h_cmd_io_out_bits_addr; // @[RegSlices.scala 65:41]
  assign fifo_c2h_cmd_out_queue_io_upStream_bits_qid = fifo_c2h_cmd_io_out_bits_qid; // @[RegSlices.scala 65:41]
  assign fifo_c2h_cmd_out_queue_io_upStream_bits_error = fifo_c2h_cmd_io_out_bits_error; // @[RegSlices.scala 65:41]
  assign fifo_c2h_cmd_out_queue_io_upStream_bits_func = fifo_c2h_cmd_io_out_bits_func; // @[RegSlices.scala 65:41]
  assign fifo_c2h_cmd_out_queue_io_upStream_bits_port_id = fifo_c2h_cmd_io_out_bits_port_id; // @[RegSlices.scala 65:41]
  assign fifo_c2h_cmd_out_queue_io_upStream_bits_pfch_tag = fifo_c2h_cmd_io_out_bits_pfch_tag; // @[RegSlices.scala 65:41]
  assign fifo_c2h_cmd_out_queue_io_upStream_bits_len = fifo_c2h_cmd_io_out_bits_len; // @[RegSlices.scala 65:41]
  assign fifo_c2h_cmd_out_queue_io_downStream_ready = io_qdma_port_c2h_byp_in_st_csh_rdy; // @[RegSlices.scala 63:38 QDMADynamic.scala 175:57]
  assign check_c2h_clock = io_user_clk;
  assign check_c2h_reset = ~io_user_arstn; // @[QDMADynamic.scala 62:73]
  assign check_c2h_io_in_valid = check_c2h_io_in_queue_io_downStream_valid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_c2h_io_in_bits_addr = check_c2h_io_in_queue_io_downStream_bits_addr; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_c2h_io_in_bits_qid = check_c2h_io_in_queue_io_downStream_bits_qid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_c2h_io_in_bits_error = check_c2h_io_in_queue_io_downStream_bits_error; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_c2h_io_in_bits_func = check_c2h_io_in_queue_io_downStream_bits_func; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_c2h_io_in_bits_port_id = check_c2h_io_in_queue_io_downStream_bits_port_id; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_c2h_io_in_bits_pfch_tag = check_c2h_io_in_queue_io_downStream_bits_pfch_tag; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_c2h_io_in_bits_len = check_c2h_io_in_queue_io_downStream_bits_len; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_c2h_io_out_ready = tlb_io_c2h_in_queue_io_upStream_ready; // @[RegSlices.scala 65:41]
  assign check_c2h_io_in_queue_clock = io_user_clk;
  assign check_c2h_io_in_queue_reset = ~io_user_arstn; // @[QDMADynamic.scala 63:76]
  assign check_c2h_io_in_queue_io_upStream_valid = 1'h0; // @[RegSlices.scala 65:41]
  assign check_c2h_io_in_queue_io_upStream_bits_addr = 64'h0; // @[RegSlices.scala 65:41]
  assign check_c2h_io_in_queue_io_upStream_bits_qid = 11'h0; // @[RegSlices.scala 65:41]
  assign check_c2h_io_in_queue_io_upStream_bits_error = 1'h0; // @[RegSlices.scala 65:41]
  assign check_c2h_io_in_queue_io_upStream_bits_func = 8'h0; // @[RegSlices.scala 65:41]
  assign check_c2h_io_in_queue_io_upStream_bits_port_id = 3'h0; // @[RegSlices.scala 65:41]
  assign check_c2h_io_in_queue_io_upStream_bits_pfch_tag = 7'h0; // @[RegSlices.scala 65:41]
  assign check_c2h_io_in_queue_io_upStream_bits_len = 32'h0; // @[RegSlices.scala 65:41]
  assign check_c2h_io_in_queue_io_downStream_ready = check_c2h_io_in_ready; // @[RegSlices.scala 63:38 QDMADynamic.scala 63:41]
  assign check_h2c_clock = io_user_clk;
  assign check_h2c_reset = ~io_user_arstn; // @[QDMADynamic.scala 64:73]
  assign check_h2c_io_in_valid = check_h2c_io_in_queue_io_downStream_valid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_addr = check_h2c_io_in_queue_io_downStream_bits_addr; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_len = check_h2c_io_in_queue_io_downStream_bits_len; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_eop = check_h2c_io_in_queue_io_downStream_bits_eop; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_sop = check_h2c_io_in_queue_io_downStream_bits_sop; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_mrkr_req = check_h2c_io_in_queue_io_downStream_bits_mrkr_req; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_sdi = check_h2c_io_in_queue_io_downStream_bits_sdi; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_qid = check_h2c_io_in_queue_io_downStream_bits_qid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_error = check_h2c_io_in_queue_io_downStream_bits_error; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_func = check_h2c_io_in_queue_io_downStream_bits_func; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_cidx = check_h2c_io_in_queue_io_downStream_bits_cidx; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_port_id = check_h2c_io_in_queue_io_downStream_bits_port_id; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_in_bits_no_dma = check_h2c_io_in_queue_io_downStream_bits_no_dma; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign check_h2c_io_out_ready = tlb_io_h2c_in_queue_io_upStream_ready; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_clock = io_user_clk;
  assign check_h2c_io_in_queue_reset = ~io_user_arstn; // @[QDMADynamic.scala 65:76]
  assign check_h2c_io_in_queue_io_upStream_valid = 1'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_addr = 64'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_len = 32'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_eop = 1'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_sop = 1'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_mrkr_req = 1'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_sdi = 1'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_qid = 11'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_error = 1'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_func = 8'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_cidx = 16'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_port_id = 3'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_upStream_bits_no_dma = 1'h0; // @[RegSlices.scala 65:41]
  assign check_h2c_io_in_queue_io_downStream_ready = check_h2c_io_in_ready; // @[RegSlices.scala 63:38 QDMADynamic.scala 65:41]
  assign tlb_clock = io_user_clk;
  assign tlb_reset = ~io_user_arstn; // @[QDMADynamic.scala 67:49]
  assign tlb_io__wr_tlb_valid = wr_tlb_valid_REG_1; // @[QDMADynamic.scala 74:39 QDMADynamic.scala 81:33]
  assign tlb_io__wr_tlb_bits_vaddr_high = io_reg_control_9; // @[QDMADynamic.scala 74:39 QDMADynamic.scala 78:33]
  assign tlb_io__wr_tlb_bits_vaddr_low = io_reg_control_8; // @[QDMADynamic.scala 74:39 QDMADynamic.scala 79:33]
  assign tlb_io__wr_tlb_bits_paddr_high = io_reg_control_11; // @[QDMADynamic.scala 74:39 QDMADynamic.scala 76:33]
  assign tlb_io__wr_tlb_bits_paddr_low = io_reg_control_10; // @[QDMADynamic.scala 74:39 QDMADynamic.scala 77:33]
  assign tlb_io__wr_tlb_bits_is_base = io_reg_control_12[0]; // @[QDMADynamic.scala 75:62]
  assign tlb_io__h2c_in_valid = tlb_io_h2c_in_queue_io_downStream_valid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_addr = tlb_io_h2c_in_queue_io_downStream_bits_addr; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_len = tlb_io_h2c_in_queue_io_downStream_bits_len; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_eop = tlb_io_h2c_in_queue_io_downStream_bits_eop; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_sop = tlb_io_h2c_in_queue_io_downStream_bits_sop; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_mrkr_req = tlb_io_h2c_in_queue_io_downStream_bits_mrkr_req; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_sdi = tlb_io_h2c_in_queue_io_downStream_bits_sdi; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_qid = tlb_io_h2c_in_queue_io_downStream_bits_qid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_error = tlb_io_h2c_in_queue_io_downStream_bits_error; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_func = tlb_io_h2c_in_queue_io_downStream_bits_func; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_cidx = tlb_io_h2c_in_queue_io_downStream_bits_cidx; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_port_id = tlb_io_h2c_in_queue_io_downStream_bits_port_id; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_in_bits_no_dma = tlb_io_h2c_in_queue_io_downStream_bits_no_dma; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__c2h_in_valid = tlb_io_c2h_in_queue_io_downStream_valid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__c2h_in_bits_addr = tlb_io_c2h_in_queue_io_downStream_bits_addr; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__c2h_in_bits_qid = tlb_io_c2h_in_queue_io_downStream_bits_qid; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__c2h_in_bits_error = tlb_io_c2h_in_queue_io_downStream_bits_error; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__c2h_in_bits_func = tlb_io_c2h_in_queue_io_downStream_bits_func; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__c2h_in_bits_port_id = tlb_io_c2h_in_queue_io_downStream_bits_port_id; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__c2h_in_bits_pfch_tag = tlb_io_c2h_in_queue_io_downStream_bits_pfch_tag; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__c2h_in_bits_len = tlb_io_c2h_in_queue_io_downStream_bits_len; // @[RegSlices.scala 63:38 RegSlices.scala 66:41]
  assign tlb_io__h2c_out_ready = fifo_h2c_cmd_io_in_queue_io_upStream_ready; // @[RegSlices.scala 65:41]
  assign tlb_io__c2h_out_ready = boundary_split_io_cmd_in_ready; // @[QDMADynamic.scala 117:34]
  assign tlb_io_h2c_in_queue_clock = io_user_clk;
  assign tlb_io_h2c_in_queue_reset = ~io_user_arstn; // @[QDMADynamic.scala 69:68]
  assign tlb_io_h2c_in_queue_io_upStream_valid = check_h2c_io_out_valid; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_addr = check_h2c_io_out_bits_addr; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_len = check_h2c_io_out_bits_len; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_eop = check_h2c_io_out_bits_eop; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_sop = check_h2c_io_out_bits_sop; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_mrkr_req = check_h2c_io_out_bits_mrkr_req; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_sdi = check_h2c_io_out_bits_sdi; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_qid = check_h2c_io_out_bits_qid; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_error = check_h2c_io_out_bits_error; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_func = check_h2c_io_out_bits_func; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_cidx = check_h2c_io_out_bits_cidx; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_port_id = check_h2c_io_out_bits_port_id; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_upStream_bits_no_dma = check_h2c_io_out_bits_no_dma; // @[RegSlices.scala 65:41]
  assign tlb_io_h2c_in_queue_io_downStream_ready = tlb_io__h2c_in_ready; // @[RegSlices.scala 63:38 QDMADynamic.scala 69:33]
  assign tlb_io_c2h_in_queue_clock = io_user_clk;
  assign tlb_io_c2h_in_queue_reset = ~io_user_arstn; // @[QDMADynamic.scala 70:68]
  assign tlb_io_c2h_in_queue_io_upStream_valid = check_c2h_io_out_valid; // @[RegSlices.scala 65:41]
  assign tlb_io_c2h_in_queue_io_upStream_bits_addr = check_c2h_io_out_bits_addr; // @[RegSlices.scala 65:41]
  assign tlb_io_c2h_in_queue_io_upStream_bits_qid = check_c2h_io_out_bits_qid; // @[RegSlices.scala 65:41]
  assign tlb_io_c2h_in_queue_io_upStream_bits_error = check_c2h_io_out_bits_error; // @[RegSlices.scala 65:41]
  assign tlb_io_c2h_in_queue_io_upStream_bits_func = check_c2h_io_out_bits_func; // @[RegSlices.scala 65:41]
  assign tlb_io_c2h_in_queue_io_upStream_bits_port_id = check_c2h_io_out_bits_port_id; // @[RegSlices.scala 65:41]
  assign tlb_io_c2h_in_queue_io_upStream_bits_pfch_tag = check_c2h_io_out_bits_pfch_tag; // @[RegSlices.scala 65:41]
  assign tlb_io_c2h_in_queue_io_upStream_bits_len = check_c2h_io_out_bits_len; // @[RegSlices.scala 65:41]
  assign tlb_io_c2h_in_queue_io_downStream_ready = tlb_io__c2h_in_ready; // @[RegSlices.scala 63:38 QDMADynamic.scala 70:33]
  assign fifo_h2c_cmd_io_in_queue_clock = io_user_clk;
  assign fifo_h2c_cmd_io_in_queue_reset = ~io_user_arstn; // @[QDMADynamic.scala 71:68]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_valid = tlb_io__h2c_out_valid; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_addr = tlb_io__h2c_out_bits_addr; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_len = tlb_io__h2c_out_bits_len; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_eop = tlb_io__h2c_out_bits_eop; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_sop = tlb_io__h2c_out_bits_sop; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_mrkr_req = tlb_io__h2c_out_bits_mrkr_req; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_sdi = tlb_io__h2c_out_bits_sdi; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_qid = tlb_io__h2c_out_bits_qid; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_error = tlb_io__h2c_out_bits_error; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_func = tlb_io__h2c_out_bits_func; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_cidx = tlb_io__h2c_out_bits_cidx; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_port_id = tlb_io__h2c_out_bits_port_id; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_upStream_bits_no_dma = tlb_io__h2c_out_bits_no_dma; // @[RegSlices.scala 65:41]
  assign fifo_h2c_cmd_io_in_queue_io_downStream_ready = fifo_h2c_cmd_io__in_ready; // @[RegSlices.scala 63:38 QDMADynamic.scala 71:33]
  assign axil2reg_clock = io_user_clk;
  assign axil2reg_reset = ~io_user_arstn; // @[QDMADynamic.scala 86:54]
  assign axil2reg_io_axi_aw_valid = axil2reg_io_axi_cvt_aw_io_out_valid; // @[XConverter.scala 22:39 XConverter.scala 41:33]
  assign axil2reg_io_axi_aw_bits_addr = axil2reg_io_axi_cvt_aw_io_out_bits_addr; // @[XConverter.scala 22:39 XConverter.scala 41:33]
  assign axil2reg_io_axi_ar_valid = axil2reg_io_axi_cvt_ar_io_out_valid; // @[XConverter.scala 22:39 XConverter.scala 42:33]
  assign axil2reg_io_axi_ar_bits_addr = axil2reg_io_axi_cvt_ar_io_out_bits_addr; // @[XConverter.scala 22:39 XConverter.scala 42:33]
  assign axil2reg_io_axi_w_valid = axil2reg_io_axi_cvt_w_io_out_valid; // @[XConverter.scala 22:39 XConverter.scala 43:33]
  assign axil2reg_io_axi_w_bits_data = axil2reg_io_axi_cvt_w_io_out_bits_data; // @[XConverter.scala 22:39 XConverter.scala 43:33]
  assign axil2reg_io_axi_r_ready = axil2reg_io_axi_cvt_r_io_in_ready; // @[XConverter.scala 22:39 XConverter.scala 44:41]
  assign axil2reg_io_reg_status_400 = io_reg_status_400; // @[QDMADynamic.scala 88:33]
  assign axil2reg_io_reg_status_401 = io_reg_status_401; // @[QDMADynamic.scala 88:33]
  assign axil2reg_io_reg_status_402 = io_reg_status_402; // @[QDMADynamic.scala 88:33]
  assign axil2reg_io_reg_status_403 = io_reg_status_403; // @[QDMADynamic.scala 88:33]
  assign axil2reg_io_reg_status_404 = io_reg_status_404; // @[QDMADynamic.scala 88:33]
  assign axil2reg_io_reg_status_405 = io_reg_status_405; // @[QDMADynamic.scala 88:33]
  assign axil2reg_io_reg_status_406 = io_reg_status_406; // @[QDMADynamic.scala 88:33]
  assign axil2reg_io_reg_status_407 = io_reg_status_407; // @[QDMADynamic.scala 88:33]
  assign axil2reg_io_reg_status_408 = io_reg_status_408; // @[QDMADynamic.scala 88:33]
  assign axil2reg_io_reg_status_409 = io_reg_status_409; // @[QDMADynamic.scala 88:33]
  assign io_axib_cvt_aw_io_in_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign io_axib_cvt_aw_io_out_clk = io_user_clk; // @[XConverter.scala 63:33]
  assign io_axib_cvt_aw_io_rstn = io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 48:51]
  assign io_axib_cvt_aw_io_in_valid = io_qdma_port_m_axib_awvalid; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 212:65]
  assign io_axib_cvt_aw_io_in_bits_addr = io_qdma_port_m_axib_awaddr; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 205:65]
  assign io_axib_cvt_aw_io_in_bits_burst = io_qdma_port_m_axib_awburst; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 208:65]
  assign io_axib_cvt_aw_io_in_bits_cache = io_qdma_port_m_axib_awcache; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 211:65]
  assign io_axib_cvt_aw_io_in_bits_id = io_qdma_port_m_axib_awid; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 204:65]
  assign io_axib_cvt_aw_io_in_bits_len = io_qdma_port_m_axib_awlen; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 206:65]
  assign io_axib_cvt_aw_io_in_bits_lock = io_qdma_port_m_axib_awlock; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 210:65]
  assign io_axib_cvt_aw_io_in_bits_prot = io_qdma_port_m_axib_awprot; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 209:65]
  assign io_axib_cvt_aw_io_in_bits_size = io_qdma_port_m_axib_awsize; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 207:65]
  assign io_axib_cvt_ar_io_in_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign io_axib_cvt_ar_io_out_clk = io_user_clk; // @[XConverter.scala 63:33]
  assign io_axib_cvt_ar_io_rstn = io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 48:51]
  assign io_axib_cvt_ar_io_in_valid = io_qdma_port_m_axib_arvalid; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 234:65]
  assign io_axib_cvt_ar_io_in_bits_addr = io_qdma_port_m_axib_araddr; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 227:65]
  assign io_axib_cvt_ar_io_in_bits_burst = io_qdma_port_m_axib_arburst; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 230:65]
  assign io_axib_cvt_ar_io_in_bits_cache = io_qdma_port_m_axib_arcache; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 233:65]
  assign io_axib_cvt_ar_io_in_bits_id = io_qdma_port_m_axib_arid; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 226:65]
  assign io_axib_cvt_ar_io_in_bits_len = io_qdma_port_m_axib_arlen; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 228:65]
  assign io_axib_cvt_ar_io_in_bits_lock = io_qdma_port_m_axib_arlock; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 232:65]
  assign io_axib_cvt_ar_io_in_bits_prot = io_qdma_port_m_axib_arprot; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 231:65]
  assign io_axib_cvt_ar_io_in_bits_size = io_qdma_port_m_axib_arsize; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 229:65]
  assign io_axib_cvt_w_io_in_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign io_axib_cvt_w_io_out_clk = io_user_clk; // @[XConverter.scala 63:33]
  assign io_axib_cvt_w_io_rstn = io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 48:51]
  assign io_axib_cvt_w_io_in_valid = io_qdma_port_m_axib_wvalid; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 218:65]
  assign io_axib_cvt_w_io_in_bits_data = io_qdma_port_m_axib_wdata; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 215:65]
  assign io_axib_cvt_w_io_in_bits_last = io_qdma_port_m_axib_wlast; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 217:65]
  assign io_axib_cvt_w_io_in_bits_strb = io_qdma_port_m_axib_wstrb; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 216:65]
  assign io_axib_cvt_r_io_in_clk = io_user_clk; // @[XConverter.scala 62:33]
  assign io_axib_cvt_r_io_out_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign io_axib_cvt_r_io_rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign io_axib_cvt_r_io_out_ready = io_qdma_port_m_axib_rready; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 242:65]
  assign io_axib_cvt_b_io_in_clk = io_user_clk; // @[XConverter.scala 62:33]
  assign io_axib_cvt_b_io_out_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign io_axib_cvt_b_io_rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign io_axib_cvt_b_io_out_ready = io_qdma_port_m_axib_bready; // @[QDMADynamic.scala 92:24 QDMADynamic.scala 224:65]
  assign s_axib_cvt_aw_io_in_clk = io_user_clk; // @[XConverter.scala 62:33]
  assign s_axib_cvt_aw_io_out_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign s_axib_cvt_aw_io_rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign s_axib_cvt_aw_io_out_ready = io_qdma_port_s_axib_awready; // @[XConverter.scala 22:39 QDMADynamic.scala 308:65]
  assign s_axib_cvt_ar_io_in_clk = io_user_clk; // @[XConverter.scala 62:33]
  assign s_axib_cvt_ar_io_out_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign s_axib_cvt_ar_io_rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign s_axib_cvt_ar_io_out_ready = io_qdma_port_s_axib_arready; // @[XConverter.scala 22:39 QDMADynamic.scala 327:65]
  assign s_axib_cvt_w_io_in_clk = io_user_clk; // @[XConverter.scala 62:33]
  assign s_axib_cvt_w_io_out_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign s_axib_cvt_w_io_rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign s_axib_cvt_w_io_out_ready = io_qdma_port_s_axib_wready; // @[XConverter.scala 22:39 QDMADynamic.scala 314:65]
  assign s_axib_cvt_r_io_in_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign s_axib_cvt_r_io_out_clk = io_user_clk; // @[XConverter.scala 63:33]
  assign s_axib_cvt_r_io_rstn = io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 48:51]
  assign s_axib_cvt_r_io_in_valid = io_qdma_port_s_axib_rvalid; // @[XConverter.scala 22:39 QDMADynamic.scala 333:65]
  assign s_axib_cvt_r_io_in_bits_data = io_qdma_port_s_axib_rdata; // @[XConverter.scala 22:39 QDMADynamic.scala 330:65]
  assign s_axib_cvt_r_io_in_bits_last = io_qdma_port_s_axib_rlast; // @[XConverter.scala 22:39 QDMADynamic.scala 332:65]
  assign s_axib_cvt_r_io_in_bits_resp = io_qdma_port_s_axib_rresp; // @[XConverter.scala 22:39 QDMADynamic.scala 331:65]
  assign s_axib_cvt_r_io_in_bits_id = io_qdma_port_s_axib_rid; // @[XConverter.scala 22:39 QDMADynamic.scala 329:73]
  assign s_axib_cvt_b_io_in_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign s_axib_cvt_b_io_out_clk = io_user_clk; // @[XConverter.scala 63:33]
  assign s_axib_cvt_b_io_rstn = io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 48:51]
  assign s_axib_cvt_b_io_in_valid = io_qdma_port_s_axib_bvalid; // @[XConverter.scala 22:39 QDMADynamic.scala 318:65]
  assign s_axib_cvt_b_io_in_bits_id = io_qdma_port_s_axib_bid; // @[XConverter.scala 22:39 QDMADynamic.scala 316:73]
  assign s_axib_cvt_b_io_in_bits_resp = io_qdma_port_s_axib_bresp; // @[XConverter.scala 22:39 QDMADynamic.scala 317:65]
  assign axil2reg_io_axi_cvt_aw_io_in_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign axil2reg_io_axi_cvt_aw_io_out_clk = io_user_clk; // @[XConverter.scala 63:33]
  assign axil2reg_io_axi_cvt_aw_io_rstn = io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 48:51]
  assign axil2reg_io_axi_cvt_aw_io_in_valid = io_qdma_port_m_axil_awvalid; // @[QDMADynamic.scala 107:24 QDMADynamic.scala 245:65]
  assign axil2reg_io_axi_cvt_aw_io_in_bits_addr = io_qdma_port_m_axil_awaddr; // @[QDMADynamic.scala 107:24 QDMADynamic.scala 244:65]
  assign axil2reg_io_axi_cvt_aw_io_out_ready = axil2reg_io_axi_aw_ready; // @[XConverter.scala 22:39 QDMADynamic.scala 113:25]
  assign axil2reg_io_axi_cvt_ar_io_in_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign axil2reg_io_axi_cvt_ar_io_out_clk = io_user_clk; // @[XConverter.scala 63:33]
  assign axil2reg_io_axi_cvt_ar_io_rstn = io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 48:51]
  assign axil2reg_io_axi_cvt_ar_io_in_valid = io_qdma_port_m_axil_arvalid; // @[QDMADynamic.scala 107:24 QDMADynamic.scala 258:65]
  assign axil2reg_io_axi_cvt_ar_io_in_bits_addr = io_qdma_port_m_axil_araddr; // @[QDMADynamic.scala 107:24 QDMADynamic.scala 257:65]
  assign axil2reg_io_axi_cvt_ar_io_out_ready = axil2reg_io_axi_ar_ready; // @[XConverter.scala 22:39 QDMADynamic.scala 113:25]
  assign axil2reg_io_axi_cvt_w_io_in_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign axil2reg_io_axi_cvt_w_io_out_clk = io_user_clk; // @[XConverter.scala 63:33]
  assign axil2reg_io_axi_cvt_w_io_rstn = io_qdma_port_axi_aresetn; // @[QDMADynamic.scala 48:51]
  assign axil2reg_io_axi_cvt_w_io_in_valid = io_qdma_port_m_axil_wvalid; // @[QDMADynamic.scala 107:24 QDMADynamic.scala 250:65]
  assign axil2reg_io_axi_cvt_w_io_in_bits_data = io_qdma_port_m_axil_wdata; // @[QDMADynamic.scala 107:24 QDMADynamic.scala 248:65]
  assign axil2reg_io_axi_cvt_w_io_in_bits_strb = io_qdma_port_m_axil_wstrb; // @[QDMADynamic.scala 107:24 QDMADynamic.scala 249:65]
  assign axil2reg_io_axi_cvt_w_io_out_ready = axil2reg_io_axi_w_ready; // @[XConverter.scala 22:39 QDMADynamic.scala 113:25]
  assign axil2reg_io_axi_cvt_r_io_in_clk = io_user_clk; // @[XConverter.scala 62:33]
  assign axil2reg_io_axi_cvt_r_io_out_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign axil2reg_io_axi_cvt_r_io_rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign axil2reg_io_axi_cvt_r_io_in_valid = axil2reg_io_axi_r_valid; // @[XConverter.scala 22:39 QDMADynamic.scala 113:25]
  assign axil2reg_io_axi_cvt_r_io_in_bits_data = axil2reg_io_axi_r_bits_data; // @[XConverter.scala 22:39 QDMADynamic.scala 113:25]
  assign axil2reg_io_axi_cvt_r_io_out_ready = io_qdma_port_m_axil_rready; // @[QDMADynamic.scala 107:24 QDMADynamic.scala 264:65]
  assign axil2reg_io_axi_cvt_b_io_in_clk = io_user_clk; // @[XConverter.scala 62:33]
  assign axil2reg_io_axi_cvt_b_io_out_clk = io_qdma_port_axi_aclk; // @[QDMADynamic.scala 47:53]
  assign axil2reg_io_axi_cvt_b_io_rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign axil2reg_io_axi_cvt_b_io_out_ready = io_qdma_port_m_axil_bready; // @[QDMADynamic.scala 107:24 QDMADynamic.scala 255:65]
  assign boundary_split_clock = io_user_clk;
  assign boundary_split_reset = ~io_user_arstn; // @[QDMADynamic.scala 116:60]
  assign boundary_split_io_cmd_in_valid = tlb_io__c2h_out_valid; // @[QDMADynamic.scala 117:34]
  assign boundary_split_io_cmd_in_bits_addr = tlb_io__c2h_out_bits_addr; // @[QDMADynamic.scala 117:34]
  assign boundary_split_io_cmd_in_bits_qid = tlb_io__c2h_out_bits_qid; // @[QDMADynamic.scala 117:34]
  assign boundary_split_io_cmd_in_bits_error = tlb_io__c2h_out_bits_error; // @[QDMADynamic.scala 117:34]
  assign boundary_split_io_cmd_in_bits_func = tlb_io__c2h_out_bits_func; // @[QDMADynamic.scala 117:34]
  assign boundary_split_io_cmd_in_bits_port_id = tlb_io__c2h_out_bits_port_id; // @[QDMADynamic.scala 117:34]
  assign boundary_split_io_cmd_in_bits_pfch_tag = tlb_io__c2h_out_bits_pfch_tag; // @[QDMADynamic.scala 117:34]
  assign boundary_split_io_cmd_in_bits_len = tlb_io__c2h_out_bits_len; // @[QDMADynamic.scala 117:34]
  assign boundary_split_io_data_out_ready = fifo_c2h_data_io__in_ready; // @[QDMADynamic.scala 120:41]
  assign boundary_split_io_cmd_out_ready = fifo_c2h_cmd_io_in_ready; // @[QDMADynamic.scala 119:41]
  always @(posedge io_user_clk) begin
    wr_tlb_valid_REG <= io_reg_control_13[0]; // @[QDMADynamic.scala 81:118]
    wr_tlb_valid_REG_1 <= ~wr_tlb_valid_REG & io_reg_control_13[0]; // @[QDMADynamic.scala 81:123]
    if (_T_6) begin // @[Collector.scala 169:42]
      counter <= 32'h0; // @[Collector.scala 169:42]
    end
    if (_T_6) begin // @[Collector.scala 169:42]
      counter_1 <= 32'h0; // @[Collector.scala 169:42]
    end
    if (_T_6) begin // @[Collector.scala 169:42]
      counter_2 <= 32'h0; // @[Collector.scala 169:42]
    end
    if (_T_6) begin // @[Collector.scala 169:42]
      counter_3 <= 32'h0; // @[Collector.scala 169:42]
    end else if (io_h2c_data_valid) begin // @[Collector.scala 170:34]
      counter_3 <= _counter_T_7; // @[Collector.scala 171:41]
    end
  end
  always @(posedge io_qdma_port_axi_aclk) begin
    if (_T_12) begin // @[Collector.scala 169:42]
      counter_4 <= 32'h0; // @[Collector.scala 169:42]
    end else if (_T_13) begin // @[Collector.scala 170:34]
      counter_4 <= _counter_T_9; // @[Collector.scala 171:41]
    end
    if (_T_12) begin // @[Collector.scala 169:42]
      counter_5 <= 32'h0; // @[Collector.scala 169:42]
    end else if (_T_14) begin // @[Collector.scala 170:34]
      counter_5 <= _counter_T_11; // @[Collector.scala 171:41]
    end
    if (_T_12) begin // @[Collector.scala 169:42]
      counter_6 <= 32'h0; // @[Collector.scala 169:42]
    end else if (_T_15) begin // @[Collector.scala 170:34]
      counter_6 <= _counter_T_13; // @[Collector.scala 171:41]
    end
    if (_T_12) begin // @[Collector.scala 169:42]
      counter_7 <= 32'h0; // @[Collector.scala 169:42]
    end else if (_T_16) begin // @[Collector.scala 170:34]
      counter_7 <= _counter_T_15; // @[Collector.scala 171:41]
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
  wr_tlb_valid_REG = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  wr_tlb_valid_REG_1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  counter = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  counter_1 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  counter_2 = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  counter_3 = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  counter_4 = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  counter_5 = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  counter_6 = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  counter_7 = _RAND_9[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module XConverter_19(
  input          io_in_clk,
  input          io_out_clk,
  input          io_rstn,
  output         io_in_ready,
  input          io_in_valid,
  input          io_in_bits_last,
  input  [511:0] io_in_bits_data,
  input  [63:0]  io_in_bits_keep,
  input          io_out_ready,
  output         io_out_valid,
  output         io_out_bits_last,
  output [511:0] io_out_bits_data,
  output [63:0]  io_out_bits_keep
);
  wire  fifo_io_m_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_s_clk; // @[XConverter.scala 97:34]
  wire  fifo_io_reset_n; // @[XConverter.scala 97:34]
  wire [583:0] fifo_io_in_data; // @[XConverter.scala 97:34]
  wire  fifo_io_in_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_in_ready; // @[XConverter.scala 97:34]
  wire [583:0] fifo_io_out_data; // @[XConverter.scala 97:34]
  wire  fifo_io_out_valid; // @[XConverter.scala 97:34]
  wire  fifo_io_out_ready; // @[XConverter.scala 97:34]
  wire [576:0] _fifo_io_in_data_T = {io_in_bits_last,io_in_bits_data,io_in_bits_keep}; // @[XConverter.scala 103:63]
  SV_STREAM_FIFO_6 fifo ( // @[XConverter.scala 97:34]
    .io_m_clk(fifo_io_m_clk),
    .io_s_clk(fifo_io_s_clk),
    .io_reset_n(fifo_io_reset_n),
    .io_in_data(fifo_io_in_data),
    .io_in_valid(fifo_io_in_valid),
    .io_in_ready(fifo_io_in_ready),
    .io_out_data(fifo_io_out_data),
    .io_out_valid(fifo_io_out_valid),
    .io_out_ready(fifo_io_out_ready)
  );
  assign io_in_ready = fifo_io_in_ready; // @[XConverter.scala 105:41]
  assign io_out_valid = fifo_io_out_valid; // @[XConverter.scala 108:41]
  assign io_out_bits_last = fifo_io_out_data[576]; // @[XConverter.scala 107:77]
  assign io_out_bits_data = fifo_io_out_data[575:64]; // @[XConverter.scala 107:77]
  assign io_out_bits_keep = fifo_io_out_data[63:0]; // @[XConverter.scala 107:77]
  assign fifo_io_m_clk = io_out_clk; // @[XConverter.scala 100:41]
  assign fifo_io_s_clk = io_in_clk; // @[XConverter.scala 99:41]
  assign fifo_io_reset_n = io_rstn; // @[XConverter.scala 101:41]
  assign fifo_io_in_data = {{7'd0}, _fifo_io_in_data_T}; // @[XConverter.scala 103:63]
  assign fifo_io_in_valid = io_in_valid; // @[XConverter.scala 104:41]
  assign fifo_io_out_ready = io_out_ready; // @[XConverter.scala 109:41]
endmodule
module XPacketQueue(
  input          clock,
  input          reset,
  output         io_in_ready,
  input          io_in_valid,
  input          io_in_bits_last,
  input  [511:0] io_in_bits_data,
  input  [63:0]  io_in_bits_keep,
  input          io_out_ready,
  output         io_out_valid,
  output         io_out_bits_last,
  output [511:0] io_out_bits_data,
  output [63:0]  io_out_bits_keep
);
  wire [511:0] meta_m_axis_tdata; // @[XPacketQueue.scala 26:34]
  wire [63:0] meta_m_axis_tkeep; // @[XPacketQueue.scala 26:34]
  wire  meta_m_axis_tlast; // @[XPacketQueue.scala 26:34]
  wire  meta_m_axis_tvalid; // @[XPacketQueue.scala 26:34]
  wire [8:0] meta_rd_data_count_axis; // @[XPacketQueue.scala 26:34]
  wire  meta_s_axis_tready; // @[XPacketQueue.scala 26:34]
  wire [8:0] meta_wr_data_count_axis; // @[XPacketQueue.scala 26:34]
  wire  meta_m_aclk; // @[XPacketQueue.scala 26:34]
  wire  meta_m_axis_tready; // @[XPacketQueue.scala 26:34]
  wire  meta_s_aclk; // @[XPacketQueue.scala 26:34]
  wire  meta_s_aresetn; // @[XPacketQueue.scala 26:34]
  wire [511:0] meta_s_axis_tdata; // @[XPacketQueue.scala 26:34]
  wire  meta_s_axis_tdest; // @[XPacketQueue.scala 26:34]
  wire  meta_s_axis_tid; // @[XPacketQueue.scala 26:34]
  wire [63:0] meta_s_axis_tkeep; // @[XPacketQueue.scala 26:34]
  wire  meta_s_axis_tlast; // @[XPacketQueue.scala 26:34]
  wire [63:0] meta_s_axis_tstrb; // @[XPacketQueue.scala 26:34]
  wire  meta_s_axis_tuser; // @[XPacketQueue.scala 26:34]
  wire  meta_s_axis_tvalid; // @[XPacketQueue.scala 26:34]
  xpm_fifo_axis
    #(.RD_DATA_COUNT_WIDTH(9), .CLOCKING_MODE("common_clock"), .PACKET_FIFO("true"), .USE_ADV_FEATURES("0404"), .TID_WIDTH(1), .TDEST_WIDTH(1), .PROG_EMPTY_THRESH(10), .TUSER_WIDTH(1), .FIFO_DEPTH(256), .SIM_ASSERT_CHK(0), .WR_DATA_COUNT_WIDTH(9), .ECC_MODE("no_ecc"), .FIFO_MEMORY_TYPE("auto"), .PROG_FULL_THRESH(10), .TDATA_WIDTH(512), .RELATED_CLOCKS(0), .CASCADE_HEIGHT(0), .CDC_SYNC_STAGES(2))
    meta ( // @[XPacketQueue.scala 26:34]
    .m_axis_tdata(meta_m_axis_tdata),
    .m_axis_tkeep(meta_m_axis_tkeep),
    .m_axis_tlast(meta_m_axis_tlast),
    .m_axis_tvalid(meta_m_axis_tvalid),
    .rd_data_count_axis(meta_rd_data_count_axis),
    .s_axis_tready(meta_s_axis_tready),
    .wr_data_count_axis(meta_wr_data_count_axis),
    .m_aclk(meta_m_aclk),
    .m_axis_tready(meta_m_axis_tready),
    .s_aclk(meta_s_aclk),
    .s_aresetn(meta_s_aresetn),
    .s_axis_tdata(meta_s_axis_tdata),
    .s_axis_tdest(meta_s_axis_tdest),
    .s_axis_tid(meta_s_axis_tid),
    .s_axis_tkeep(meta_s_axis_tkeep),
    .s_axis_tlast(meta_s_axis_tlast),
    .s_axis_tstrb(meta_s_axis_tstrb),
    .s_axis_tuser(meta_s_axis_tuser),
    .s_axis_tvalid(meta_s_axis_tvalid)
  );
  assign io_in_ready = meta_s_axis_tready; // @[XPacketQueue.scala 35:49]
  assign io_out_valid = meta_m_axis_tvalid; // @[XPacketQueue.scala 33:49]
  assign io_out_bits_last = meta_m_axis_tlast; // @[XPacketQueue.scala 32:49]
  assign io_out_bits_data = meta_m_axis_tdata; // @[XPacketQueue.scala 30:49]
  assign io_out_bits_keep = meta_m_axis_tkeep; // @[XPacketQueue.scala 31:49]
  assign meta_m_aclk = clock; // @[XPacketQueue.scala 37:57]
  assign meta_m_axis_tready = io_out_ready; // @[XPacketQueue.scala 38:49]
  assign meta_s_aclk = clock; // @[XPacketQueue.scala 39:57]
  assign meta_s_aresetn = ~reset; // @[XPacketQueue.scala 40:61]
  assign meta_s_axis_tdata = io_in_bits_data; // @[XPacketQueue.scala 41:49]
  assign meta_s_axis_tdest = 1'h0; // @[XPacketQueue.scala 42:49]
  assign meta_s_axis_tid = 1'h0; // @[XPacketQueue.scala 43:57]
  assign meta_s_axis_tkeep = io_in_bits_keep; // @[XPacketQueue.scala 44:49]
  assign meta_s_axis_tlast = io_in_bits_last; // @[XPacketQueue.scala 45:49]
  assign meta_s_axis_tstrb = io_in_bits_keep; // @[XPacketQueue.scala 46:49]
  assign meta_s_axis_tuser = 1'h0; // @[XPacketQueue.scala 47:49]
  assign meta_s_axis_tvalid = io_in_valid; // @[XPacketQueue.scala 48:49]
endmodule
module RegSlice_10(
  input          clock,
  input          reset,
  output         io_upStream_ready,
  input          io_upStream_valid,
  input          io_upStream_bits_last,
  input  [511:0] io_upStream_bits_data,
  input  [63:0]  io_upStream_bits_keep,
  input          io_downStream_ready,
  output         io_downStream_valid,
  output         io_downStream_bits_last,
  output [511:0] io_downStream_bits_data,
  output [63:0]  io_downStream_bits_keep
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [511:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [511:0] _RAND_6;
  reg [63:0] _RAND_7;
`endif // RANDOMIZE_REG_INIT
  reg  fwd_valid; // @[RegSlices.scala 112:34]
  reg  fwd_data_last; // @[RegSlices.scala 113:30]
  reg [511:0] fwd_data_data; // @[RegSlices.scala 113:30]
  reg [63:0] fwd_data_keep; // @[RegSlices.scala 113:30]
  wire  fwd_ready_s = ~fwd_valid | io_downStream_ready; // @[RegSlices.scala 115:35]
  reg  bwd_ready; // @[RegSlices.scala 123:34]
  reg  bwd_data_last; // @[RegSlices.scala 124:30]
  reg [511:0] bwd_data_data; // @[RegSlices.scala 124:30]
  reg [63:0] bwd_data_keep; // @[RegSlices.scala 124:30]
  wire  _fwd_valid_T = io_downStream_ready ? 1'h0 : fwd_valid; // @[RegSlices.scala 121:53]
  wire  bwd_valid_s = ~bwd_ready | io_upStream_valid; // @[RegSlices.scala 126:39]
  wire  _bwd_ready_T = io_upStream_valid ? 1'h0 : bwd_ready; // @[RegSlices.scala 132:53]
  assign io_upStream_ready = bwd_ready; // @[RegSlices.scala 107:31 RegSlices.scala 128:25]
  assign io_downStream_valid = fwd_valid; // @[RegSlices.scala 109:31 RegSlices.scala 116:21]
  assign io_downStream_bits_last = fwd_data_last; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_data = fwd_data_data; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  assign io_downStream_bits_keep = fwd_data_keep; // @[RegSlices.scala 108:31 RegSlices.scala 117:25]
  always @(posedge clock) begin
    if (reset) begin // @[RegSlices.scala 112:34]
      fwd_valid <= 1'h0; // @[RegSlices.scala 112:34]
    end else begin
      fwd_valid <= bwd_valid_s | _fwd_valid_T; // @[RegSlices.scala 121:25]
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_last <= io_upStream_bits_last;
      end else begin
        fwd_data_last <= bwd_data_last;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_data <= io_upStream_bits_data;
      end else begin
        fwd_data_data <= bwd_data_data;
      end
    end
    if (fwd_ready_s) begin // @[RegSlices.scala 119:31]
      if (bwd_ready) begin // @[RegSlices.scala 127:31]
        fwd_data_keep <= io_upStream_bits_keep;
      end else begin
        fwd_data_keep <= bwd_data_keep;
      end
    end
    bwd_ready <= reset | (fwd_ready_s | _bwd_ready_T); // @[RegSlices.scala 123:34 RegSlices.scala 123:34 RegSlices.scala 132:25]
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_last <= io_upStream_bits_last;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_data <= io_upStream_bits_data;
    end
    if (bwd_ready) begin // @[RegSlices.scala 130:31]
      bwd_data_keep <= io_upStream_bits_keep;
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
  fwd_valid = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  fwd_data_last = _RAND_1[0:0];
  _RAND_2 = {16{`RANDOM}};
  fwd_data_data = _RAND_2[511:0];
  _RAND_3 = {2{`RANDOM}};
  fwd_data_keep = _RAND_3[63:0];
  _RAND_4 = {1{`RANDOM}};
  bwd_ready = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  bwd_data_last = _RAND_5[0:0];
  _RAND_6 = {16{`RANDOM}};
  bwd_data_data = _RAND_6[511:0];
  _RAND_7 = {2{`RANDOM}};
  bwd_data_keep = _RAND_7[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module XCMAC(
  output [3:0] io_pin_tx_p,
  output [3:0] io_pin_tx_n,
  input  [3:0] io_pin_rx_p,
  input  [3:0] io_pin_rx_n,
  input        io_pin_gt_clk_p,
  input        io_pin_gt_clk_n,
  output       io_net_clk,
  input        io_drp_clk,
  input        io_user_clk,
  input        io_user_arstn,
  input        io_sys_reset
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  wire  fifo_tx_data_io_in_clk; // @[XConverter.scala 61:33]
  wire  fifo_tx_data_io_out_clk; // @[XConverter.scala 61:33]
  wire  fifo_tx_data_io_rstn; // @[XConverter.scala 61:33]
  wire  fifo_tx_data_io_in_ready; // @[XConverter.scala 61:33]
  wire  fifo_tx_data_io_in_valid; // @[XConverter.scala 61:33]
  wire  fifo_tx_data_io_in_bits_last; // @[XConverter.scala 61:33]
  wire [511:0] fifo_tx_data_io_in_bits_data; // @[XConverter.scala 61:33]
  wire [63:0] fifo_tx_data_io_in_bits_keep; // @[XConverter.scala 61:33]
  wire  fifo_tx_data_io_out_ready; // @[XConverter.scala 61:33]
  wire  fifo_tx_data_io_out_valid; // @[XConverter.scala 61:33]
  wire  fifo_tx_data_io_out_bits_last; // @[XConverter.scala 61:33]
  wire [511:0] fifo_tx_data_io_out_bits_data; // @[XConverter.scala 61:33]
  wire [63:0] fifo_tx_data_io_out_bits_keep; // @[XConverter.scala 61:33]
  wire  fifo_rx_data_io_in_clk; // @[XConverter.scala 61:33]
  wire  fifo_rx_data_io_out_clk; // @[XConverter.scala 61:33]
  wire  fifo_rx_data_io_rstn; // @[XConverter.scala 61:33]
  wire  fifo_rx_data_io_in_ready; // @[XConverter.scala 61:33]
  wire  fifo_rx_data_io_in_valid; // @[XConverter.scala 61:33]
  wire  fifo_rx_data_io_in_bits_last; // @[XConverter.scala 61:33]
  wire [511:0] fifo_rx_data_io_in_bits_data; // @[XConverter.scala 61:33]
  wire [63:0] fifo_rx_data_io_in_bits_keep; // @[XConverter.scala 61:33]
  wire  fifo_rx_data_io_out_ready; // @[XConverter.scala 61:33]
  wire  fifo_rx_data_io_out_valid; // @[XConverter.scala 61:33]
  wire  fifo_rx_data_io_out_bits_last; // @[XConverter.scala 61:33]
  wire [511:0] fifo_rx_data_io_out_bits_data; // @[XConverter.scala 61:33]
  wire [63:0] fifo_rx_data_io_out_bits_keep; // @[XConverter.scala 61:33]
  wire  fifo_tx_pkg_clock; // @[XPacketQueue.scala 11:23]
  wire  fifo_tx_pkg_reset; // @[XPacketQueue.scala 11:23]
  wire  fifo_tx_pkg_io_in_ready; // @[XPacketQueue.scala 11:23]
  wire  fifo_tx_pkg_io_in_valid; // @[XPacketQueue.scala 11:23]
  wire  fifo_tx_pkg_io_in_bits_last; // @[XPacketQueue.scala 11:23]
  wire [511:0] fifo_tx_pkg_io_in_bits_data; // @[XPacketQueue.scala 11:23]
  wire [63:0] fifo_tx_pkg_io_in_bits_keep; // @[XPacketQueue.scala 11:23]
  wire  fifo_tx_pkg_io_out_ready; // @[XPacketQueue.scala 11:23]
  wire  fifo_tx_pkg_io_out_valid; // @[XPacketQueue.scala 11:23]
  wire  fifo_tx_pkg_io_out_bits_last; // @[XPacketQueue.scala 11:23]
  wire [511:0] fifo_tx_pkg_io_out_bits_data; // @[XPacketQueue.scala 11:23]
  wire [63:0] fifo_tx_pkg_io_out_bits_keep; // @[XPacketQueue.scala 11:23]
  wire  fifo_tx_data_io_in_queue_0_clock; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_0_reset; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_0_io_upStream_ready; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_0_io_upStream_valid; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_0_io_upStream_bits_last; // @[RegSlices.scala 73:51]
  wire [511:0] fifo_tx_data_io_in_queue_0_io_upStream_bits_data; // @[RegSlices.scala 73:51]
  wire [63:0] fifo_tx_data_io_in_queue_0_io_upStream_bits_keep; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_0_io_downStream_ready; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_0_io_downStream_valid; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_0_io_downStream_bits_last; // @[RegSlices.scala 73:51]
  wire [511:0] fifo_tx_data_io_in_queue_0_io_downStream_bits_data; // @[RegSlices.scala 73:51]
  wire [63:0] fifo_tx_data_io_in_queue_0_io_downStream_bits_keep; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_1_clock; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_1_reset; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_1_io_upStream_ready; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_1_io_upStream_valid; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_1_io_upStream_bits_last; // @[RegSlices.scala 73:51]
  wire [511:0] fifo_tx_data_io_in_queue_1_io_upStream_bits_data; // @[RegSlices.scala 73:51]
  wire [63:0] fifo_tx_data_io_in_queue_1_io_upStream_bits_keep; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_1_io_downStream_ready; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_1_io_downStream_valid; // @[RegSlices.scala 73:51]
  wire  fifo_tx_data_io_in_queue_1_io_downStream_bits_last; // @[RegSlices.scala 73:51]
  wire [511:0] fifo_tx_data_io_in_queue_1_io_downStream_bits_data; // @[RegSlices.scala 73:51]
  wire [63:0] fifo_tx_data_io_in_queue_1_io_downStream_bits_keep; // @[RegSlices.scala 73:51]
  wire  tx_regdelay_queue_0_clock; // @[RegSlices.scala 73:51]
  wire  tx_regdelay_queue_0_reset; // @[RegSlices.scala 73:51]
  wire  tx_regdelay_queue_0_io_upStream_ready; // @[RegSlices.scala 73:51]
  wire  tx_regdelay_queue_0_io_upStream_valid; // @[RegSlices.scala 73:51]
  wire  tx_regdelay_queue_0_io_upStream_bits_last; // @[RegSlices.scala 73:51]
  wire [511:0] tx_regdelay_queue_0_io_upStream_bits_data; // @[RegSlices.scala 73:51]
  wire [63:0] tx_regdelay_queue_0_io_upStream_bits_keep; // @[RegSlices.scala 73:51]
  wire  tx_regdelay_queue_0_io_downStream_ready; // @[RegSlices.scala 73:51]
  wire  tx_regdelay_queue_0_io_downStream_valid; // @[RegSlices.scala 73:51]
  wire  tx_regdelay_queue_0_io_downStream_bits_last; // @[RegSlices.scala 73:51]
  wire [511:0] tx_regdelay_queue_0_io_downStream_bits_data; // @[RegSlices.scala 73:51]
  wire [63:0] tx_regdelay_queue_0_io_downStream_bits_keep; // @[RegSlices.scala 73:51]
  wire  cmac_inst_sys_reset; // @[CMAC.scala 67:27]
  wire  cmac_inst_gt_ref_clk_p; // @[CMAC.scala 67:27]
  wire  cmac_inst_gt_ref_clk_n; // @[CMAC.scala 67:27]
  wire  cmac_inst_init_clk; // @[CMAC.scala 67:27]
  wire [3:0] cmac_inst_gt_txp_out; // @[CMAC.scala 67:27]
  wire [3:0] cmac_inst_gt_txn_out; // @[CMAC.scala 67:27]
  wire [3:0] cmac_inst_gt_rxp_in; // @[CMAC.scala 67:27]
  wire [3:0] cmac_inst_gt_rxn_in; // @[CMAC.scala 67:27]
  wire  cmac_inst_gt_txusrclk2; // @[CMAC.scala 67:27]
  wire  cmac_inst_usr_rx_reset; // @[CMAC.scala 67:27]
  wire  cmac_inst_gt_rxusrclk2; // @[CMAC.scala 67:27]
  wire  cmac_inst_rx_clk; // @[CMAC.scala 67:27]
  wire [11:0] cmac_inst_gt_loopback_in; // @[CMAC.scala 67:27]
  wire  cmac_inst_gtwiz_reset_tx_datapath; // @[CMAC.scala 67:27]
  wire  cmac_inst_gtwiz_reset_rx_datapath; // @[CMAC.scala 67:27]
  wire  cmac_inst_rx_axis_tvalid; // @[CMAC.scala 67:27]
  wire [511:0] cmac_inst_rx_axis_tdata; // @[CMAC.scala 67:27]
  wire  cmac_inst_rx_axis_tlast; // @[CMAC.scala 67:27]
  wire [63:0] cmac_inst_rx_axis_tkeep; // @[CMAC.scala 67:27]
  wire  cmac_inst_tx_axis_tready; // @[CMAC.scala 67:27]
  wire  cmac_inst_tx_axis_tvalid; // @[CMAC.scala 67:27]
  wire [511:0] cmac_inst_tx_axis_tdata; // @[CMAC.scala 67:27]
  wire  cmac_inst_tx_axis_tlast; // @[CMAC.scala 67:27]
  wire [63:0] cmac_inst_tx_axis_tkeep; // @[CMAC.scala 67:27]
  wire  cmac_inst_tx_axis_tuser; // @[CMAC.scala 67:27]
  wire  cmac_inst_ctl_rx_enable; // @[CMAC.scala 67:27]
  wire  cmac_inst_ctl_rx_force_resync; // @[CMAC.scala 67:27]
  wire  cmac_inst_ctl_rx_test_pattern; // @[CMAC.scala 67:27]
  wire  cmac_inst_core_rx_reset; // @[CMAC.scala 67:27]
  wire  cmac_inst_ctl_tx_enable; // @[CMAC.scala 67:27]
  wire  cmac_inst_ctl_tx_send_idle; // @[CMAC.scala 67:27]
  wire  cmac_inst_ctl_tx_send_rfi; // @[CMAC.scala 67:27]
  wire  cmac_inst_ctl_tx_send_lfi; // @[CMAC.scala 67:27]
  wire  cmac_inst_ctl_tx_test_pattern; // @[CMAC.scala 67:27]
  wire  cmac_inst_core_tx_reset; // @[CMAC.scala 67:27]
  wire [55:0] cmac_inst_tx_preamblein; // @[CMAC.scala 67:27]
  wire  cmac_inst_stat_rx_aligned; // @[CMAC.scala 67:27]
  wire  cmac_inst_usr_tx_reset; // @[CMAC.scala 67:27]
  wire  cmac_inst_core_drp_reset; // @[CMAC.scala 67:27]
  wire  cmac_inst_drp_clk; // @[CMAC.scala 67:27]
  wire [9:0] cmac_inst_drp_addr; // @[CMAC.scala 67:27]
  wire [15:0] cmac_inst_drp_di; // @[CMAC.scala 67:27]
  wire  cmac_inst_drp_en; // @[CMAC.scala 67:27]
  wire  cmac_inst_drp_we; // @[CMAC.scala 67:27]
  wire  rx_rst = cmac_inst_usr_rx_reset; // @[CMAC.scala 69:43 CMAC.scala 155:41]
  wire  tx_rst = cmac_inst_usr_tx_reset; // @[CMAC.scala 70:43 CMAC.scala 156:41]
  wire  _T_2 = rx_rst | tx_rst; // @[CMAC.scala 77:38]
  wire  tx_clk = cmac_inst_gt_txusrclk2; // @[CMAC.scala 72:43 CMAC.scala 154:41]
  reg [1:0] rx_state; // @[CMAC.scala 83:46]
  reg  ctl_rx_enable_r; // @[CMAC.scala 84:46]
  reg  stat_rx_aligned_1d; // @[CMAC.scala 85:46]
  wire  _T_3 = 2'h0 == rx_state; // @[Conditional.scala 37:30]
  wire  _T_4 = 2'h1 == rx_state; // @[Conditional.scala 37:30]
  wire  _T_5 = 2'h2 == rx_state; // @[Conditional.scala 37:30]
  wire [1:0] _GEN_0 = stat_rx_aligned_1d ? 2'h3 : rx_state; // @[CMAC.scala 96:49 CMAC.scala 97:37 CMAC.scala 83:46]
  wire  _T_7 = 2'h3 == rx_state; // @[Conditional.scala 37:30]
  wire  _T_8 = ~stat_rx_aligned_1d; // @[CMAC.scala 101:41]
  wire [1:0] _GEN_1 = ~stat_rx_aligned_1d ? 2'h0 : rx_state; // @[CMAC.scala 101:49 CMAC.scala 102:37 CMAC.scala 83:46]
  wire [1:0] _GEN_2 = _T_7 ? _GEN_1 : rx_state; // @[Conditional.scala 39:67 CMAC.scala 83:46]
  wire [1:0] _GEN_3 = _T_5 ? _GEN_0 : _GEN_2; // @[Conditional.scala 39:67]
  wire  _GEN_4 = _T_4 | ctl_rx_enable_r; // @[Conditional.scala 39:67 CMAC.scala 92:37 CMAC.scala 84:46]
  wire [1:0] _GEN_5 = _T_4 ? 2'h2 : _GEN_3; // @[Conditional.scala 39:67 CMAC.scala 93:37]
  wire [1:0] _GEN_6 = _T_3 ? 2'h1 : _GEN_5; // @[Conditional.scala 40:58 CMAC.scala 89:33]
  reg [1:0] tx_state; // @[CMAC.scala 106:46]
  reg  ctl_tx_enable_r; // @[CMAC.scala 107:46]
  reg  ctl_tx_send_rfi_r; // @[CMAC.scala 108:46]
  wire  _T_9 = 2'h0 == tx_state; // @[Conditional.scala 37:30]
  wire  _T_10 = 2'h1 == tx_state; // @[Conditional.scala 37:30]
  wire  _T_11 = 2'h2 == tx_state; // @[Conditional.scala 37:30]
  wire [1:0] _GEN_8 = stat_rx_aligned_1d ? 2'h3 : tx_state; // @[CMAC.scala 120:49 CMAC.scala 121:37 CMAC.scala 106:46]
  wire  _T_13 = 2'h3 == tx_state; // @[Conditional.scala 37:30]
  wire [1:0] _GEN_9 = _T_8 ? 2'h0 : _GEN_6; // @[CMAC.scala 127:49 CMAC.scala 128:37]
  wire  _GEN_10 = _T_13 ? 1'h0 : ctl_tx_send_rfi_r; // @[Conditional.scala 39:67 CMAC.scala 125:37 CMAC.scala 108:46]
  wire  _GEN_11 = _T_13 | ctl_tx_enable_r; // @[Conditional.scala 39:67 CMAC.scala 126:37 CMAC.scala 107:46]
  wire [1:0] _GEN_12 = _T_13 ? _GEN_9 : _GEN_6; // @[Conditional.scala 39:67]
  wire  _GEN_14 = _T_11 ? ctl_tx_send_rfi_r : _GEN_10; // @[Conditional.scala 39:67 CMAC.scala 108:46]
  wire  _GEN_17 = _T_10 | _GEN_14; // @[Conditional.scala 39:67 CMAC.scala 116:37]
  XConverter_19 fifo_tx_data ( // @[XConverter.scala 61:33]
    .io_in_clk(fifo_tx_data_io_in_clk),
    .io_out_clk(fifo_tx_data_io_out_clk),
    .io_rstn(fifo_tx_data_io_rstn),
    .io_in_ready(fifo_tx_data_io_in_ready),
    .io_in_valid(fifo_tx_data_io_in_valid),
    .io_in_bits_last(fifo_tx_data_io_in_bits_last),
    .io_in_bits_data(fifo_tx_data_io_in_bits_data),
    .io_in_bits_keep(fifo_tx_data_io_in_bits_keep),
    .io_out_ready(fifo_tx_data_io_out_ready),
    .io_out_valid(fifo_tx_data_io_out_valid),
    .io_out_bits_last(fifo_tx_data_io_out_bits_last),
    .io_out_bits_data(fifo_tx_data_io_out_bits_data),
    .io_out_bits_keep(fifo_tx_data_io_out_bits_keep)
  );
  XConverter_19 fifo_rx_data ( // @[XConverter.scala 61:33]
    .io_in_clk(fifo_rx_data_io_in_clk),
    .io_out_clk(fifo_rx_data_io_out_clk),
    .io_rstn(fifo_rx_data_io_rstn),
    .io_in_ready(fifo_rx_data_io_in_ready),
    .io_in_valid(fifo_rx_data_io_in_valid),
    .io_in_bits_last(fifo_rx_data_io_in_bits_last),
    .io_in_bits_data(fifo_rx_data_io_in_bits_data),
    .io_in_bits_keep(fifo_rx_data_io_in_bits_keep),
    .io_out_ready(fifo_rx_data_io_out_ready),
    .io_out_valid(fifo_rx_data_io_out_valid),
    .io_out_bits_last(fifo_rx_data_io_out_bits_last),
    .io_out_bits_data(fifo_rx_data_io_out_bits_data),
    .io_out_bits_keep(fifo_rx_data_io_out_bits_keep)
  );
  XPacketQueue fifo_tx_pkg ( // @[XPacketQueue.scala 11:23]
    .clock(fifo_tx_pkg_clock),
    .reset(fifo_tx_pkg_reset),
    .io_in_ready(fifo_tx_pkg_io_in_ready),
    .io_in_valid(fifo_tx_pkg_io_in_valid),
    .io_in_bits_last(fifo_tx_pkg_io_in_bits_last),
    .io_in_bits_data(fifo_tx_pkg_io_in_bits_data),
    .io_in_bits_keep(fifo_tx_pkg_io_in_bits_keep),
    .io_out_ready(fifo_tx_pkg_io_out_ready),
    .io_out_valid(fifo_tx_pkg_io_out_valid),
    .io_out_bits_last(fifo_tx_pkg_io_out_bits_last),
    .io_out_bits_data(fifo_tx_pkg_io_out_bits_data),
    .io_out_bits_keep(fifo_tx_pkg_io_out_bits_keep)
  );
  RegSlice_10 fifo_tx_data_io_in_queue_0 ( // @[RegSlices.scala 73:51]
    .clock(fifo_tx_data_io_in_queue_0_clock),
    .reset(fifo_tx_data_io_in_queue_0_reset),
    .io_upStream_ready(fifo_tx_data_io_in_queue_0_io_upStream_ready),
    .io_upStream_valid(fifo_tx_data_io_in_queue_0_io_upStream_valid),
    .io_upStream_bits_last(fifo_tx_data_io_in_queue_0_io_upStream_bits_last),
    .io_upStream_bits_data(fifo_tx_data_io_in_queue_0_io_upStream_bits_data),
    .io_upStream_bits_keep(fifo_tx_data_io_in_queue_0_io_upStream_bits_keep),
    .io_downStream_ready(fifo_tx_data_io_in_queue_0_io_downStream_ready),
    .io_downStream_valid(fifo_tx_data_io_in_queue_0_io_downStream_valid),
    .io_downStream_bits_last(fifo_tx_data_io_in_queue_0_io_downStream_bits_last),
    .io_downStream_bits_data(fifo_tx_data_io_in_queue_0_io_downStream_bits_data),
    .io_downStream_bits_keep(fifo_tx_data_io_in_queue_0_io_downStream_bits_keep)
  );
  RegSlice_10 fifo_tx_data_io_in_queue_1 ( // @[RegSlices.scala 73:51]
    .clock(fifo_tx_data_io_in_queue_1_clock),
    .reset(fifo_tx_data_io_in_queue_1_reset),
    .io_upStream_ready(fifo_tx_data_io_in_queue_1_io_upStream_ready),
    .io_upStream_valid(fifo_tx_data_io_in_queue_1_io_upStream_valid),
    .io_upStream_bits_last(fifo_tx_data_io_in_queue_1_io_upStream_bits_last),
    .io_upStream_bits_data(fifo_tx_data_io_in_queue_1_io_upStream_bits_data),
    .io_upStream_bits_keep(fifo_tx_data_io_in_queue_1_io_upStream_bits_keep),
    .io_downStream_ready(fifo_tx_data_io_in_queue_1_io_downStream_ready),
    .io_downStream_valid(fifo_tx_data_io_in_queue_1_io_downStream_valid),
    .io_downStream_bits_last(fifo_tx_data_io_in_queue_1_io_downStream_bits_last),
    .io_downStream_bits_data(fifo_tx_data_io_in_queue_1_io_downStream_bits_data),
    .io_downStream_bits_keep(fifo_tx_data_io_in_queue_1_io_downStream_bits_keep)
  );
  RegSlice_10 tx_regdelay_queue_0 ( // @[RegSlices.scala 73:51]
    .clock(tx_regdelay_queue_0_clock),
    .reset(tx_regdelay_queue_0_reset),
    .io_upStream_ready(tx_regdelay_queue_0_io_upStream_ready),
    .io_upStream_valid(tx_regdelay_queue_0_io_upStream_valid),
    .io_upStream_bits_last(tx_regdelay_queue_0_io_upStream_bits_last),
    .io_upStream_bits_data(tx_regdelay_queue_0_io_upStream_bits_data),
    .io_upStream_bits_keep(tx_regdelay_queue_0_io_upStream_bits_keep),
    .io_downStream_ready(tx_regdelay_queue_0_io_downStream_ready),
    .io_downStream_valid(tx_regdelay_queue_0_io_downStream_valid),
    .io_downStream_bits_last(tx_regdelay_queue_0_io_downStream_bits_last),
    .io_downStream_bits_data(tx_regdelay_queue_0_io_downStream_bits_data),
    .io_downStream_bits_keep(tx_regdelay_queue_0_io_downStream_bits_keep)
  );
  CMACBlackBoxBase cmac_inst ( // @[CMAC.scala 67:27]
    .sys_reset(cmac_inst_sys_reset),
    .gt_ref_clk_p(cmac_inst_gt_ref_clk_p),
    .gt_ref_clk_n(cmac_inst_gt_ref_clk_n),
    .init_clk(cmac_inst_init_clk),
    .gt_txp_out(cmac_inst_gt_txp_out),
    .gt_txn_out(cmac_inst_gt_txn_out),
    .gt_rxp_in(cmac_inst_gt_rxp_in),
    .gt_rxn_in(cmac_inst_gt_rxn_in),
    .gt_txusrclk2(cmac_inst_gt_txusrclk2),
    .usr_rx_reset(cmac_inst_usr_rx_reset),
    .gt_rxusrclk2(cmac_inst_gt_rxusrclk2),
    .rx_clk(cmac_inst_rx_clk),
    .gt_loopback_in(cmac_inst_gt_loopback_in),
    .gtwiz_reset_tx_datapath(cmac_inst_gtwiz_reset_tx_datapath),
    .gtwiz_reset_rx_datapath(cmac_inst_gtwiz_reset_rx_datapath),
    .rx_axis_tvalid(cmac_inst_rx_axis_tvalid),
    .rx_axis_tdata(cmac_inst_rx_axis_tdata),
    .rx_axis_tlast(cmac_inst_rx_axis_tlast),
    .rx_axis_tkeep(cmac_inst_rx_axis_tkeep),
    .tx_axis_tready(cmac_inst_tx_axis_tready),
    .tx_axis_tvalid(cmac_inst_tx_axis_tvalid),
    .tx_axis_tdata(cmac_inst_tx_axis_tdata),
    .tx_axis_tlast(cmac_inst_tx_axis_tlast),
    .tx_axis_tkeep(cmac_inst_tx_axis_tkeep),
    .tx_axis_tuser(cmac_inst_tx_axis_tuser),
    .ctl_rx_enable(cmac_inst_ctl_rx_enable),
    .ctl_rx_force_resync(cmac_inst_ctl_rx_force_resync),
    .ctl_rx_test_pattern(cmac_inst_ctl_rx_test_pattern),
    .core_rx_reset(cmac_inst_core_rx_reset),
    .ctl_tx_enable(cmac_inst_ctl_tx_enable),
    .ctl_tx_send_idle(cmac_inst_ctl_tx_send_idle),
    .ctl_tx_send_rfi(cmac_inst_ctl_tx_send_rfi),
    .ctl_tx_send_lfi(cmac_inst_ctl_tx_send_lfi),
    .ctl_tx_test_pattern(cmac_inst_ctl_tx_test_pattern),
    .core_tx_reset(cmac_inst_core_tx_reset),
    .tx_preamblein(cmac_inst_tx_preamblein),
    .stat_rx_aligned(cmac_inst_stat_rx_aligned),
    .usr_tx_reset(cmac_inst_usr_tx_reset),
    .core_drp_reset(cmac_inst_core_drp_reset),
    .drp_clk(cmac_inst_drp_clk),
    .drp_addr(cmac_inst_drp_addr),
    .drp_di(cmac_inst_drp_di),
    .drp_en(cmac_inst_drp_en),
    .drp_we(cmac_inst_drp_we)
  );
  assign io_pin_tx_p = cmac_inst_gt_txp_out; // @[CMAC.scala 148:57]
  assign io_pin_tx_n = cmac_inst_gt_txn_out; // @[CMAC.scala 149:57]
  assign io_net_clk = cmac_inst_gt_txusrclk2; // @[CMAC.scala 72:43 CMAC.scala 154:41]
  assign fifo_tx_data_io_in_clk = io_user_clk; // @[XConverter.scala 62:33]
  assign fifo_tx_data_io_out_clk = io_net_clk; // @[XConverter.scala 63:33]
  assign fifo_tx_data_io_rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign fifo_tx_data_io_in_valid = fifo_tx_data_io_in_queue_1_io_downStream_valid; // @[RegSlices.scala 72:38 RegSlices.scala 75:49]
  assign fifo_tx_data_io_in_bits_last = fifo_tx_data_io_in_queue_1_io_downStream_bits_last; // @[RegSlices.scala 72:38 RegSlices.scala 75:49]
  assign fifo_tx_data_io_in_bits_data = fifo_tx_data_io_in_queue_1_io_downStream_bits_data; // @[RegSlices.scala 72:38 RegSlices.scala 75:49]
  assign fifo_tx_data_io_in_bits_keep = fifo_tx_data_io_in_queue_1_io_downStream_bits_keep; // @[RegSlices.scala 72:38 RegSlices.scala 75:49]
  assign fifo_tx_data_io_out_ready = fifo_tx_pkg_io_in_ready; // @[CMAC.scala 60:41]
  assign fifo_rx_data_io_in_clk = io_net_clk; // @[XConverter.scala 62:33]
  assign fifo_rx_data_io_out_clk = io_user_clk; // @[XConverter.scala 63:33]
  assign fifo_rx_data_io_rstn = io_user_arstn; // @[XConverter.scala 64:41]
  assign fifo_rx_data_io_in_valid = cmac_inst_rx_axis_tvalid; // @[CMAC.scala 166:41]
  assign fifo_rx_data_io_in_bits_last = cmac_inst_rx_axis_tlast; // @[CMAC.scala 168:41]
  assign fifo_rx_data_io_in_bits_data = cmac_inst_rx_axis_tdata; // @[CMAC.scala 167:41]
  assign fifo_rx_data_io_in_bits_keep = cmac_inst_rx_axis_tkeep; // @[CMAC.scala 169:41]
  assign fifo_rx_data_io_out_ready = 1'h1; // @[CMAC.scala 64:37]
  assign fifo_tx_pkg_clock = io_net_clk;
  assign fifo_tx_pkg_reset = ~io_user_arstn; // @[CMAC.scala 54:60]
  assign fifo_tx_pkg_io_in_valid = fifo_tx_data_io_out_valid; // @[CMAC.scala 60:41]
  assign fifo_tx_pkg_io_in_bits_last = fifo_tx_data_io_out_bits_last; // @[CMAC.scala 60:41]
  assign fifo_tx_pkg_io_in_bits_data = fifo_tx_data_io_out_bits_data; // @[CMAC.scala 60:41]
  assign fifo_tx_pkg_io_in_bits_keep = fifo_tx_data_io_out_bits_keep; // @[CMAC.scala 60:41]
  assign fifo_tx_pkg_io_out_ready = tx_regdelay_queue_0_io_upStream_ready; // @[RegSlices.scala 74:57]
  assign fifo_tx_data_io_in_queue_0_clock = io_user_clk;
  assign fifo_tx_data_io_in_queue_0_reset = ~io_user_arstn; // @[CMAC.scala 59:74]
  assign fifo_tx_data_io_in_queue_0_io_upStream_valid = 1'h0; // @[RegSlices.scala 74:57]
  assign fifo_tx_data_io_in_queue_0_io_upStream_bits_last = 1'h0; // @[RegSlices.scala 74:57]
  assign fifo_tx_data_io_in_queue_0_io_upStream_bits_data = 512'h0; // @[RegSlices.scala 74:57]
  assign fifo_tx_data_io_in_queue_0_io_upStream_bits_keep = 64'h0; // @[RegSlices.scala 74:57]
  assign fifo_tx_data_io_in_queue_0_io_downStream_ready = fifo_tx_data_io_in_queue_1_io_upStream_ready; // @[RegSlices.scala 79:49]
  assign fifo_tx_data_io_in_queue_1_clock = io_user_clk;
  assign fifo_tx_data_io_in_queue_1_reset = ~io_user_arstn; // @[CMAC.scala 59:74]
  assign fifo_tx_data_io_in_queue_1_io_upStream_valid = fifo_tx_data_io_in_queue_0_io_downStream_valid; // @[RegSlices.scala 79:49]
  assign fifo_tx_data_io_in_queue_1_io_upStream_bits_last = fifo_tx_data_io_in_queue_0_io_downStream_bits_last; // @[RegSlices.scala 79:49]
  assign fifo_tx_data_io_in_queue_1_io_upStream_bits_data = fifo_tx_data_io_in_queue_0_io_downStream_bits_data; // @[RegSlices.scala 79:49]
  assign fifo_tx_data_io_in_queue_1_io_upStream_bits_keep = fifo_tx_data_io_in_queue_0_io_downStream_bits_keep; // @[RegSlices.scala 79:49]
  assign fifo_tx_data_io_in_queue_1_io_downStream_ready = fifo_tx_data_io_in_ready; // @[RegSlices.scala 72:38 CMAC.scala 59:41]
  assign tx_regdelay_queue_0_clock = io_net_clk;
  assign tx_regdelay_queue_0_reset = ~io_user_arstn; // @[CMAC.scala 62:88]
  assign tx_regdelay_queue_0_io_upStream_valid = fifo_tx_pkg_io_out_valid; // @[RegSlices.scala 74:57]
  assign tx_regdelay_queue_0_io_upStream_bits_last = fifo_tx_pkg_io_out_bits_last; // @[RegSlices.scala 74:57]
  assign tx_regdelay_queue_0_io_upStream_bits_data = fifo_tx_pkg_io_out_bits_data; // @[RegSlices.scala 74:57]
  assign tx_regdelay_queue_0_io_upStream_bits_keep = fifo_tx_pkg_io_out_bits_keep; // @[RegSlices.scala 74:57]
  assign tx_regdelay_queue_0_io_downStream_ready = cmac_inst_tx_axis_tready; // @[RegSlices.scala 72:38 CMAC.scala 172:46]
  assign cmac_inst_sys_reset = io_sys_reset; // @[CMAC.scala 144:57]
  assign cmac_inst_gt_ref_clk_p = io_pin_gt_clk_p; // @[CMAC.scala 145:57]
  assign cmac_inst_gt_ref_clk_n = io_pin_gt_clk_n; // @[CMAC.scala 146:57]
  assign cmac_inst_init_clk = io_drp_clk; // @[CMAC.scala 147:41]
  assign cmac_inst_gt_rxp_in = io_pin_rx_p; // @[CMAC.scala 150:57]
  assign cmac_inst_gt_rxn_in = io_pin_rx_n; // @[CMAC.scala 151:57]
  assign cmac_inst_rx_clk = cmac_inst_gt_txusrclk2; // @[CMAC.scala 158:41]
  assign cmac_inst_gt_loopback_in = 12'h0; // @[CMAC.scala 161:46]
  assign cmac_inst_gtwiz_reset_tx_datapath = 1'h0; // @[CMAC.scala 162:46]
  assign cmac_inst_gtwiz_reset_rx_datapath = 1'h0; // @[CMAC.scala 163:46]
  assign cmac_inst_tx_axis_tvalid = tx_regdelay_queue_0_io_downStream_valid; // @[RegSlices.scala 72:38 RegSlices.scala 75:49]
  assign cmac_inst_tx_axis_tdata = tx_regdelay_queue_0_io_downStream_bits_data; // @[RegSlices.scala 72:38 RegSlices.scala 75:49]
  assign cmac_inst_tx_axis_tlast = tx_regdelay_queue_0_io_downStream_bits_last; // @[RegSlices.scala 72:38 RegSlices.scala 75:49]
  assign cmac_inst_tx_axis_tkeep = tx_regdelay_queue_0_io_downStream_bits_keep; // @[RegSlices.scala 72:38 RegSlices.scala 75:49]
  assign cmac_inst_tx_axis_tuser = 1'h0; // @[CMAC.scala 176:46]
  assign cmac_inst_ctl_rx_enable = ctl_rx_enable_r; // @[CMAC.scala 132:42]
  assign cmac_inst_ctl_rx_force_resync = 1'h0; // @[CMAC.scala 179:46]
  assign cmac_inst_ctl_rx_test_pattern = 1'h0; // @[CMAC.scala 180:46]
  assign cmac_inst_core_rx_reset = 1'h0; // @[CMAC.scala 181:46]
  assign cmac_inst_ctl_tx_enable = ctl_tx_enable_r; // @[CMAC.scala 133:42]
  assign cmac_inst_ctl_tx_send_idle = 1'h0; // @[CMAC.scala 182:46]
  assign cmac_inst_ctl_tx_send_rfi = ctl_tx_send_rfi_r; // @[CMAC.scala 134:42]
  assign cmac_inst_ctl_tx_send_lfi = 1'h0; // @[CMAC.scala 183:46]
  assign cmac_inst_ctl_tx_test_pattern = 1'h0; // @[CMAC.scala 184:46]
  assign cmac_inst_core_tx_reset = 1'h0; // @[CMAC.scala 185:46]
  assign cmac_inst_tx_preamblein = 56'h0; // @[CMAC.scala 188:46]
  assign cmac_inst_core_drp_reset = 1'h0; // @[CMAC.scala 193:46]
  assign cmac_inst_drp_clk = 1'h0; // @[CMAC.scala 194:46]
  assign cmac_inst_drp_addr = 10'h0; // @[CMAC.scala 195:46]
  assign cmac_inst_drp_di = 16'h0; // @[CMAC.scala 196:46]
  assign cmac_inst_drp_en = 1'h0; // @[CMAC.scala 197:46]
  assign cmac_inst_drp_we = 1'h0; // @[CMAC.scala 200:46]
  always @(posedge tx_clk) begin
    if (_T_2) begin // @[CMAC.scala 83:46]
      rx_state <= 2'h0; // @[CMAC.scala 83:46]
    end else if (_T_9) begin // @[Conditional.scala 40:58]
      rx_state <= _GEN_6;
    end else if (_T_10) begin // @[Conditional.scala 39:67]
      rx_state <= _GEN_6;
    end else if (_T_11) begin // @[Conditional.scala 39:67]
      rx_state <= _GEN_6;
    end else begin
      rx_state <= _GEN_12;
    end
    if (_T_2) begin // @[CMAC.scala 84:46]
      ctl_rx_enable_r <= 1'h0; // @[CMAC.scala 84:46]
    end else if (!(_T_3)) begin // @[Conditional.scala 40:58]
      ctl_rx_enable_r <= _GEN_4;
    end
    stat_rx_aligned_1d <= cmac_inst_stat_rx_aligned; // @[CMAC.scala 85:46]
    if (_T_2) begin // @[CMAC.scala 106:46]
      tx_state <= 2'h0; // @[CMAC.scala 106:46]
    end else if (_T_9) begin // @[Conditional.scala 40:58]
      tx_state <= 2'h1; // @[CMAC.scala 113:33]
    end else if (_T_10) begin // @[Conditional.scala 39:67]
      tx_state <= 2'h2; // @[CMAC.scala 117:37]
    end else if (_T_11) begin // @[Conditional.scala 39:67]
      tx_state <= _GEN_8;
    end
    if (_T_2) begin // @[CMAC.scala 107:46]
      ctl_tx_enable_r <= 1'h0; // @[CMAC.scala 107:46]
    end else if (_T_9) begin // @[Conditional.scala 40:58]
      ctl_tx_enable_r <= 1'h0; // @[CMAC.scala 111:37]
    end else if (!(_T_10)) begin // @[Conditional.scala 39:67]
      if (!(_T_11)) begin // @[Conditional.scala 39:67]
        ctl_tx_enable_r <= _GEN_11;
      end
    end
    if (_T_2) begin // @[CMAC.scala 108:46]
      ctl_tx_send_rfi_r <= 1'h0; // @[CMAC.scala 108:46]
    end else if (_T_9) begin // @[Conditional.scala 40:58]
      ctl_tx_send_rfi_r <= 1'h0; // @[CMAC.scala 112:37]
    end else begin
      ctl_tx_send_rfi_r <= _GEN_17;
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
  rx_state = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  ctl_rx_enable_r = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  stat_rx_aligned_1d = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  tx_state = _RAND_3[1:0];
  _RAND_4 = {1{`RANDOM}};
  ctl_tx_enable_r = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  ctl_tx_send_rfi_r = _RAND_5[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module MMCME4_ADV_Wrapper(
  input   io_CLKIN1,
  output  io_LOCKED,
  output  io_CLKOUT0,
  output  io_CLKOUT1,
  output  io_CLKOUT2,
  output  io_CLKOUT3,
  output  io_CLKOUT4,
  output  io_CLKOUT5
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
    #(.CLKOUT5_DIVIDE(12.0), .CLKOUT3_DIVIDE(12.0), .CLKFBOUT_PHASE(0.0), .CLKIN1_PERIOD(10.0), .CLKOUT2_DIVIDE(12.0), .CLKOUT0_PHASE(0.0), .CLKFBOUT_MULT_F(12.0), .CLKOUT4_DIVIDE(12.0), .CLKOUT6_DIVIDE(2.0), .CLKOUT0_USE_FINE_PS("FALSE"), .COMPENSATION("INTERNAL"), .CLKOUT1_DIVIDE(12.0), .BANDWIDTH("OPTIMIZED"), .CLKFBOUT_USE_FINE_PS("FALSE"), .CLKOUT4_CASCADE("FALSE"), .CLKOUT0_DIVIDE_F(12.0), .CLKOUT0_DUTY_CYCLE(0.5), .REF_JITTER1(0.01), .DIVCLK_DIVIDE(1), .STARTUP_WAIT("FALSE"))
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
  assign io_CLKOUT1 = mmcm4_adv_CLKOUT1; // @[Buf.scala 125:26]
  assign io_CLKOUT2 = mmcm4_adv_CLKOUT2; // @[Buf.scala 126:26]
  assign io_CLKOUT3 = mmcm4_adv_CLKOUT3; // @[Buf.scala 127:26]
  assign io_CLKOUT4 = mmcm4_adv_CLKOUT4; // @[Buf.scala 128:26]
  assign io_CLKOUT5 = mmcm4_adv_CLKOUT5; // @[Buf.scala 129:26]
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
module MMCME4_ADV_Wrapper_1(
  input   io_CLKIN1,
  input   io_RST,
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
    #(.CLKOUT5_DIVIDE(2.0), .CLKOUT3_DIVIDE(2.0), .CLKFBOUT_PHASE(0.0), .CLKIN1_PERIOD(10.0), .CLKOUT2_DIVIDE(2.0), .CLKOUT0_PHASE(0.0), .CLKFBOUT_MULT_F(18.0), .CLKOUT4_DIVIDE(2.0), .CLKOUT6_DIVIDE(2.0), .CLKOUT0_USE_FINE_PS("FALSE"), .COMPENSATION("INTERNAL"), .CLKOUT1_DIVIDE(2.0), .BANDWIDTH("OPTIMIZED"), .CLKFBOUT_USE_FINE_PS("FALSE"), .CLKOUT4_CASCADE("FALSE"), .CLKOUT0_DIVIDE_F(2.0), .CLKOUT0_DUTY_CYCLE(0.5), .REF_JITTER1(0.01), .DIVCLK_DIVIDE(2), .STARTUP_WAIT("FALSE"))
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
  assign mmcm4_adv_RST = io_RST; // @[Buf.scala 122:25]
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
module HBM_DRIVER(
  input   clock
);
  wire  mmcmGlbl_io_CLKIN1; // @[HBMDriver.scala 48:30]
  wire  mmcmGlbl_io_LOCKED; // @[HBMDriver.scala 48:30]
  wire  mmcmGlbl_io_CLKOUT0; // @[HBMDriver.scala 48:30]
  wire  mmcmGlbl_io_CLKOUT1; // @[HBMDriver.scala 48:30]
  wire  mmcmGlbl_io_CLKOUT2; // @[HBMDriver.scala 48:30]
  wire  mmcmGlbl_io_CLKOUT3; // @[HBMDriver.scala 48:30]
  wire  mmcmGlbl_io_CLKOUT4; // @[HBMDriver.scala 48:30]
  wire  mmcmGlbl_io_CLKOUT5; // @[HBMDriver.scala 48:30]
  wire  apb0Pclk_pad_O; // @[Buf.scala 33:34]
  wire  apb0Pclk_pad_I; // @[Buf.scala 33:34]
  wire  apb0Pclk_pad_1_O; // @[Buf.scala 17:34]
  wire  apb0Pclk_pad_1_I; // @[Buf.scala 17:34]
  wire  apb0Pclk_pad_2_O; // @[Buf.scala 33:34]
  wire  apb0Pclk_pad_2_I; // @[Buf.scala 33:34]
  wire  axiAclkIn0_pad_O; // @[Buf.scala 33:34]
  wire  axiAclkIn0_pad_I; // @[Buf.scala 33:34]
  wire  hbmRefClk0_pad_O; // @[Buf.scala 33:34]
  wire  hbmRefClk0_pad_I; // @[Buf.scala 33:34]
  wire  apb1Pclk_pad_O; // @[Buf.scala 33:34]
  wire  apb1Pclk_pad_I; // @[Buf.scala 33:34]
  wire  apb1Pclk_pad_1_O; // @[Buf.scala 17:34]
  wire  apb1Pclk_pad_1_I; // @[Buf.scala 17:34]
  wire  apb1Pclk_pad_2_O; // @[Buf.scala 33:34]
  wire  apb1Pclk_pad_2_I; // @[Buf.scala 33:34]
  wire  axiAclkIn1_pad_O; // @[Buf.scala 33:34]
  wire  axiAclkIn1_pad_I; // @[Buf.scala 33:34]
  wire  hbmRefClk1_pad_O; // @[Buf.scala 33:34]
  wire  hbmRefClk1_pad_I; // @[Buf.scala 33:34]
  wire  mmcmAxi_io_CLKIN1; // @[HBMDriver.scala 71:29]
  wire  mmcmAxi_io_RST; // @[HBMDriver.scala 71:29]
  wire  mmcmAxi_io_LOCKED; // @[HBMDriver.scala 71:29]
  wire  mmcmAxi_io_CLKOUT0; // @[HBMDriver.scala 71:29]
  wire  axiAclk_pad_O; // @[Buf.scala 33:34]
  wire  axiAclk_pad_I; // @[Buf.scala 33:34]
  wire  instHbm_HBM_REF_CLK_0; // @[HBMDriver.scala 92:29]
  wire  instHbm_HBM_REF_CLK_1; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_00_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_00_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_00_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_00_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_00_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_00_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_00_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_00_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_00_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_00_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_00_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_00_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_00_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_00_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_00_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_00_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_00_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_00_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_00_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_00_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_01_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_01_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_01_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_01_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_01_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_01_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_01_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_01_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_01_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_01_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_01_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_01_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_01_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_01_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_01_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_01_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_01_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_01_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_01_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_01_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_02_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_02_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_02_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_02_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_02_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_02_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_02_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_02_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_02_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_02_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_02_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_02_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_02_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_02_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_02_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_02_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_02_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_02_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_02_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_02_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_03_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_03_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_03_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_03_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_03_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_03_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_03_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_03_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_03_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_03_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_03_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_03_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_03_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_03_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_03_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_03_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_03_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_03_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_03_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_03_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_04_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_04_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_04_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_04_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_04_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_04_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_04_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_04_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_04_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_04_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_04_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_04_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_04_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_04_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_04_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_04_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_04_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_04_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_04_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_04_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_05_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_05_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_05_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_05_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_05_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_05_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_05_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_05_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_05_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_05_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_05_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_05_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_05_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_05_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_05_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_05_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_05_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_05_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_05_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_05_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_06_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_06_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_06_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_06_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_06_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_06_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_06_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_06_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_06_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_06_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_06_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_06_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_06_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_06_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_06_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_06_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_06_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_06_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_06_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_06_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_07_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_07_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_07_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_07_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_07_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_07_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_07_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_07_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_07_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_07_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_07_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_07_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_07_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_07_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_07_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_07_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_07_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_07_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_07_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_07_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_08_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_08_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_08_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_08_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_08_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_08_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_08_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_08_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_08_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_08_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_08_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_08_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_08_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_08_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_08_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_08_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_08_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_08_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_08_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_08_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_09_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_09_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_09_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_09_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_09_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_09_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_09_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_09_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_09_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_09_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_09_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_09_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_09_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_09_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_09_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_09_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_09_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_09_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_09_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_09_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_10_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_10_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_10_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_10_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_10_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_10_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_10_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_10_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_10_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_10_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_10_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_10_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_10_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_10_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_10_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_10_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_10_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_10_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_10_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_10_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_11_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_11_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_11_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_11_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_11_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_11_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_11_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_11_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_11_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_11_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_11_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_11_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_11_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_11_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_11_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_11_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_11_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_11_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_11_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_11_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_12_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_12_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_12_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_12_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_12_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_12_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_12_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_12_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_12_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_12_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_12_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_12_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_12_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_12_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_12_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_12_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_12_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_12_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_12_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_12_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_13_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_13_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_13_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_13_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_13_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_13_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_13_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_13_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_13_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_13_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_13_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_13_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_13_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_13_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_13_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_13_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_13_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_13_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_13_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_13_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_14_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_14_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_14_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_14_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_14_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_14_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_14_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_14_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_14_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_14_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_14_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_14_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_14_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_14_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_14_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_14_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_14_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_14_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_14_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_14_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_15_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_15_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_15_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_15_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_15_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_15_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_15_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_15_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_15_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_15_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_15_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_15_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_15_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_15_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_15_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_15_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_15_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_15_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_15_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_15_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_16_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_16_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_16_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_16_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_16_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_16_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_16_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_16_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_16_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_16_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_16_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_16_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_16_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_16_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_16_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_16_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_16_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_16_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_16_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_16_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_17_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_17_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_17_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_17_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_17_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_17_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_17_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_17_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_17_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_17_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_17_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_17_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_17_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_17_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_17_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_17_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_17_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_17_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_17_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_17_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_18_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_18_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_18_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_18_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_18_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_18_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_18_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_18_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_18_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_18_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_18_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_18_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_18_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_18_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_18_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_18_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_18_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_18_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_18_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_18_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_19_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_19_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_19_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_19_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_19_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_19_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_19_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_19_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_19_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_19_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_19_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_19_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_19_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_19_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_19_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_19_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_19_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_19_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_19_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_19_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_20_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_20_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_20_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_20_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_20_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_20_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_20_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_20_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_20_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_20_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_20_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_20_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_20_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_20_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_20_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_20_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_20_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_20_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_20_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_20_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_21_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_21_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_21_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_21_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_21_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_21_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_21_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_21_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_21_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_21_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_21_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_21_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_21_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_21_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_21_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_21_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_21_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_21_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_21_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_21_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_22_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_22_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_22_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_22_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_22_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_22_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_22_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_22_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_22_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_22_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_22_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_22_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_22_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_22_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_22_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_22_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_22_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_22_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_22_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_22_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_23_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_23_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_23_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_23_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_23_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_23_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_23_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_23_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_23_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_23_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_23_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_23_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_23_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_23_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_23_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_23_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_23_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_23_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_23_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_23_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_24_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_24_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_24_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_24_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_24_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_24_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_24_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_24_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_24_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_24_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_24_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_24_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_24_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_24_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_24_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_24_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_24_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_24_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_24_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_24_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_25_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_25_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_25_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_25_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_25_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_25_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_25_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_25_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_25_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_25_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_25_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_25_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_25_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_25_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_25_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_25_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_25_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_25_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_25_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_25_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_26_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_26_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_26_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_26_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_26_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_26_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_26_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_26_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_26_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_26_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_26_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_26_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_26_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_26_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_26_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_26_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_26_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_26_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_26_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_26_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_27_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_27_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_27_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_27_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_27_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_27_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_27_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_27_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_27_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_27_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_27_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_27_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_27_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_27_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_27_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_27_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_27_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_27_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_27_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_27_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_28_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_28_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_28_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_28_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_28_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_28_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_28_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_28_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_28_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_28_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_28_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_28_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_28_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_28_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_28_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_28_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_28_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_28_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_28_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_28_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_29_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_29_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_29_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_29_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_29_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_29_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_29_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_29_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_29_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_29_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_29_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_29_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_29_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_29_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_29_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_29_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_29_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_29_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_29_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_29_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_30_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_30_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_30_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_30_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_30_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_30_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_30_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_30_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_30_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_30_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_30_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_30_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_30_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_30_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_30_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_30_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_30_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_30_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_30_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_30_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_ACLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_ARESET_N; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_31_ARADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_31_ARBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_31_ARID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_31_ARLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_31_ARSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_ARVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_ARREADY; // @[HBMDriver.scala 92:29]
  wire [32:0] instHbm_AXI_31_AWADDR; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_31_AWBURST; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_31_AWID; // @[HBMDriver.scala 92:29]
  wire [3:0] instHbm_AXI_31_AWLEN; // @[HBMDriver.scala 92:29]
  wire [2:0] instHbm_AXI_31_AWSIZE; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_AWVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_AWREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_31_WDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_WLAST; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_31_WSTRB; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_WVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_WREADY; // @[HBMDriver.scala 92:29]
  wire [255:0] instHbm_AXI_31_RDATA; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_31_RID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_RLAST; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_31_RRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_RVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_RREADY; // @[HBMDriver.scala 92:29]
  wire [5:0] instHbm_AXI_31_BID; // @[HBMDriver.scala 92:29]
  wire [1:0] instHbm_AXI_31_BRESP; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_BVALID; // @[HBMDriver.scala 92:29]
  wire  instHbm_AXI_31_BREADY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_31_WDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_AXI_31_RDATA_PARITY; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_APB_0_PWDATA; // @[HBMDriver.scala 92:29]
  wire [21:0] instHbm_APB_0_PADDR; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_0_PCLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_0_PENABLE; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_0_PRESET_N; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_0_PSEL; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_0_PWRITE; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_APB_0_PRDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_0_PREADY; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_0_PSLVERR; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_APB_1_PWDATA; // @[HBMDriver.scala 92:29]
  wire [21:0] instHbm_APB_1_PADDR; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_1_PCLK; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_1_PENABLE; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_1_PRESET_N; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_1_PSEL; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_1_PWRITE; // @[HBMDriver.scala 92:29]
  wire [31:0] instHbm_APB_1_PRDATA; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_1_PREADY; // @[HBMDriver.scala 92:29]
  wire  instHbm_APB_1_PSLVERR; // @[HBMDriver.scala 92:29]
  wire  instHbm_DRAM_0_STAT_CATTRIP; // @[HBMDriver.scala 92:29]
  wire [6:0] instHbm_DRAM_0_STAT_TEMP; // @[HBMDriver.scala 92:29]
  wire  instHbm_DRAM_1_STAT_CATTRIP; // @[HBMDriver.scala 92:29]
  wire [6:0] instHbm_DRAM_1_STAT_TEMP; // @[HBMDriver.scala 92:29]
  wire  instHbm_apb_complete_0; // @[HBMDriver.scala 92:29]
  wire  instHbm_apb_complete_1; // @[HBMDriver.scala 92:29]
  MMCME4_ADV_Wrapper mmcmGlbl ( // @[HBMDriver.scala 48:30]
    .io_CLKIN1(mmcmGlbl_io_CLKIN1),
    .io_LOCKED(mmcmGlbl_io_LOCKED),
    .io_CLKOUT0(mmcmGlbl_io_CLKOUT0),
    .io_CLKOUT1(mmcmGlbl_io_CLKOUT1),
    .io_CLKOUT2(mmcmGlbl_io_CLKOUT2),
    .io_CLKOUT3(mmcmGlbl_io_CLKOUT3),
    .io_CLKOUT4(mmcmGlbl_io_CLKOUT4),
    .io_CLKOUT5(mmcmGlbl_io_CLKOUT5)
  );
  BUFG apb0Pclk_pad ( // @[Buf.scala 33:34]
    .O(apb0Pclk_pad_O),
    .I(apb0Pclk_pad_I)
  );
  IBUF apb0Pclk_pad_1 ( // @[Buf.scala 17:34]
    .O(apb0Pclk_pad_1_O),
    .I(apb0Pclk_pad_1_I)
  );
  BUFG apb0Pclk_pad_2 ( // @[Buf.scala 33:34]
    .O(apb0Pclk_pad_2_O),
    .I(apb0Pclk_pad_2_I)
  );
  BUFG axiAclkIn0_pad ( // @[Buf.scala 33:34]
    .O(axiAclkIn0_pad_O),
    .I(axiAclkIn0_pad_I)
  );
  BUFG hbmRefClk0_pad ( // @[Buf.scala 33:34]
    .O(hbmRefClk0_pad_O),
    .I(hbmRefClk0_pad_I)
  );
  BUFG apb1Pclk_pad ( // @[Buf.scala 33:34]
    .O(apb1Pclk_pad_O),
    .I(apb1Pclk_pad_I)
  );
  IBUF apb1Pclk_pad_1 ( // @[Buf.scala 17:34]
    .O(apb1Pclk_pad_1_O),
    .I(apb1Pclk_pad_1_I)
  );
  BUFG apb1Pclk_pad_2 ( // @[Buf.scala 33:34]
    .O(apb1Pclk_pad_2_O),
    .I(apb1Pclk_pad_2_I)
  );
  BUFG axiAclkIn1_pad ( // @[Buf.scala 33:34]
    .O(axiAclkIn1_pad_O),
    .I(axiAclkIn1_pad_I)
  );
  BUFG hbmRefClk1_pad ( // @[Buf.scala 33:34]
    .O(hbmRefClk1_pad_O),
    .I(hbmRefClk1_pad_I)
  );
  MMCME4_ADV_Wrapper_1 mmcmAxi ( // @[HBMDriver.scala 71:29]
    .io_CLKIN1(mmcmAxi_io_CLKIN1),
    .io_RST(mmcmAxi_io_RST),
    .io_LOCKED(mmcmAxi_io_LOCKED),
    .io_CLKOUT0(mmcmAxi_io_CLKOUT0)
  );
  BUFG axiAclk_pad ( // @[Buf.scala 33:34]
    .O(axiAclk_pad_O),
    .I(axiAclk_pad_I)
  );
  HBMBlackBoxBase instHbm ( // @[HBMDriver.scala 92:29]
    .HBM_REF_CLK_0(instHbm_HBM_REF_CLK_0),
    .HBM_REF_CLK_1(instHbm_HBM_REF_CLK_1),
    .AXI_00_ACLK(instHbm_AXI_00_ACLK),
    .AXI_00_ARESET_N(instHbm_AXI_00_ARESET_N),
    .AXI_00_ARADDR(instHbm_AXI_00_ARADDR),
    .AXI_00_ARBURST(instHbm_AXI_00_ARBURST),
    .AXI_00_ARID(instHbm_AXI_00_ARID),
    .AXI_00_ARLEN(instHbm_AXI_00_ARLEN),
    .AXI_00_ARSIZE(instHbm_AXI_00_ARSIZE),
    .AXI_00_ARVALID(instHbm_AXI_00_ARVALID),
    .AXI_00_ARREADY(instHbm_AXI_00_ARREADY),
    .AXI_00_AWADDR(instHbm_AXI_00_AWADDR),
    .AXI_00_AWBURST(instHbm_AXI_00_AWBURST),
    .AXI_00_AWID(instHbm_AXI_00_AWID),
    .AXI_00_AWLEN(instHbm_AXI_00_AWLEN),
    .AXI_00_AWSIZE(instHbm_AXI_00_AWSIZE),
    .AXI_00_AWVALID(instHbm_AXI_00_AWVALID),
    .AXI_00_AWREADY(instHbm_AXI_00_AWREADY),
    .AXI_00_WDATA(instHbm_AXI_00_WDATA),
    .AXI_00_WLAST(instHbm_AXI_00_WLAST),
    .AXI_00_WSTRB(instHbm_AXI_00_WSTRB),
    .AXI_00_WVALID(instHbm_AXI_00_WVALID),
    .AXI_00_WREADY(instHbm_AXI_00_WREADY),
    .AXI_00_RDATA(instHbm_AXI_00_RDATA),
    .AXI_00_RID(instHbm_AXI_00_RID),
    .AXI_00_RLAST(instHbm_AXI_00_RLAST),
    .AXI_00_RRESP(instHbm_AXI_00_RRESP),
    .AXI_00_RVALID(instHbm_AXI_00_RVALID),
    .AXI_00_RREADY(instHbm_AXI_00_RREADY),
    .AXI_00_BID(instHbm_AXI_00_BID),
    .AXI_00_BRESP(instHbm_AXI_00_BRESP),
    .AXI_00_BVALID(instHbm_AXI_00_BVALID),
    .AXI_00_BREADY(instHbm_AXI_00_BREADY),
    .AXI_00_WDATA_PARITY(instHbm_AXI_00_WDATA_PARITY),
    .AXI_00_RDATA_PARITY(instHbm_AXI_00_RDATA_PARITY),
    .AXI_01_ACLK(instHbm_AXI_01_ACLK),
    .AXI_01_ARESET_N(instHbm_AXI_01_ARESET_N),
    .AXI_01_ARADDR(instHbm_AXI_01_ARADDR),
    .AXI_01_ARBURST(instHbm_AXI_01_ARBURST),
    .AXI_01_ARID(instHbm_AXI_01_ARID),
    .AXI_01_ARLEN(instHbm_AXI_01_ARLEN),
    .AXI_01_ARSIZE(instHbm_AXI_01_ARSIZE),
    .AXI_01_ARVALID(instHbm_AXI_01_ARVALID),
    .AXI_01_ARREADY(instHbm_AXI_01_ARREADY),
    .AXI_01_AWADDR(instHbm_AXI_01_AWADDR),
    .AXI_01_AWBURST(instHbm_AXI_01_AWBURST),
    .AXI_01_AWID(instHbm_AXI_01_AWID),
    .AXI_01_AWLEN(instHbm_AXI_01_AWLEN),
    .AXI_01_AWSIZE(instHbm_AXI_01_AWSIZE),
    .AXI_01_AWVALID(instHbm_AXI_01_AWVALID),
    .AXI_01_AWREADY(instHbm_AXI_01_AWREADY),
    .AXI_01_WDATA(instHbm_AXI_01_WDATA),
    .AXI_01_WLAST(instHbm_AXI_01_WLAST),
    .AXI_01_WSTRB(instHbm_AXI_01_WSTRB),
    .AXI_01_WVALID(instHbm_AXI_01_WVALID),
    .AXI_01_WREADY(instHbm_AXI_01_WREADY),
    .AXI_01_RDATA(instHbm_AXI_01_RDATA),
    .AXI_01_RID(instHbm_AXI_01_RID),
    .AXI_01_RLAST(instHbm_AXI_01_RLAST),
    .AXI_01_RRESP(instHbm_AXI_01_RRESP),
    .AXI_01_RVALID(instHbm_AXI_01_RVALID),
    .AXI_01_RREADY(instHbm_AXI_01_RREADY),
    .AXI_01_BID(instHbm_AXI_01_BID),
    .AXI_01_BRESP(instHbm_AXI_01_BRESP),
    .AXI_01_BVALID(instHbm_AXI_01_BVALID),
    .AXI_01_BREADY(instHbm_AXI_01_BREADY),
    .AXI_01_WDATA_PARITY(instHbm_AXI_01_WDATA_PARITY),
    .AXI_01_RDATA_PARITY(instHbm_AXI_01_RDATA_PARITY),
    .AXI_02_ACLK(instHbm_AXI_02_ACLK),
    .AXI_02_ARESET_N(instHbm_AXI_02_ARESET_N),
    .AXI_02_ARADDR(instHbm_AXI_02_ARADDR),
    .AXI_02_ARBURST(instHbm_AXI_02_ARBURST),
    .AXI_02_ARID(instHbm_AXI_02_ARID),
    .AXI_02_ARLEN(instHbm_AXI_02_ARLEN),
    .AXI_02_ARSIZE(instHbm_AXI_02_ARSIZE),
    .AXI_02_ARVALID(instHbm_AXI_02_ARVALID),
    .AXI_02_ARREADY(instHbm_AXI_02_ARREADY),
    .AXI_02_AWADDR(instHbm_AXI_02_AWADDR),
    .AXI_02_AWBURST(instHbm_AXI_02_AWBURST),
    .AXI_02_AWID(instHbm_AXI_02_AWID),
    .AXI_02_AWLEN(instHbm_AXI_02_AWLEN),
    .AXI_02_AWSIZE(instHbm_AXI_02_AWSIZE),
    .AXI_02_AWVALID(instHbm_AXI_02_AWVALID),
    .AXI_02_AWREADY(instHbm_AXI_02_AWREADY),
    .AXI_02_WDATA(instHbm_AXI_02_WDATA),
    .AXI_02_WLAST(instHbm_AXI_02_WLAST),
    .AXI_02_WSTRB(instHbm_AXI_02_WSTRB),
    .AXI_02_WVALID(instHbm_AXI_02_WVALID),
    .AXI_02_WREADY(instHbm_AXI_02_WREADY),
    .AXI_02_RDATA(instHbm_AXI_02_RDATA),
    .AXI_02_RID(instHbm_AXI_02_RID),
    .AXI_02_RLAST(instHbm_AXI_02_RLAST),
    .AXI_02_RRESP(instHbm_AXI_02_RRESP),
    .AXI_02_RVALID(instHbm_AXI_02_RVALID),
    .AXI_02_RREADY(instHbm_AXI_02_RREADY),
    .AXI_02_BID(instHbm_AXI_02_BID),
    .AXI_02_BRESP(instHbm_AXI_02_BRESP),
    .AXI_02_BVALID(instHbm_AXI_02_BVALID),
    .AXI_02_BREADY(instHbm_AXI_02_BREADY),
    .AXI_02_WDATA_PARITY(instHbm_AXI_02_WDATA_PARITY),
    .AXI_02_RDATA_PARITY(instHbm_AXI_02_RDATA_PARITY),
    .AXI_03_ACLK(instHbm_AXI_03_ACLK),
    .AXI_03_ARESET_N(instHbm_AXI_03_ARESET_N),
    .AXI_03_ARADDR(instHbm_AXI_03_ARADDR),
    .AXI_03_ARBURST(instHbm_AXI_03_ARBURST),
    .AXI_03_ARID(instHbm_AXI_03_ARID),
    .AXI_03_ARLEN(instHbm_AXI_03_ARLEN),
    .AXI_03_ARSIZE(instHbm_AXI_03_ARSIZE),
    .AXI_03_ARVALID(instHbm_AXI_03_ARVALID),
    .AXI_03_ARREADY(instHbm_AXI_03_ARREADY),
    .AXI_03_AWADDR(instHbm_AXI_03_AWADDR),
    .AXI_03_AWBURST(instHbm_AXI_03_AWBURST),
    .AXI_03_AWID(instHbm_AXI_03_AWID),
    .AXI_03_AWLEN(instHbm_AXI_03_AWLEN),
    .AXI_03_AWSIZE(instHbm_AXI_03_AWSIZE),
    .AXI_03_AWVALID(instHbm_AXI_03_AWVALID),
    .AXI_03_AWREADY(instHbm_AXI_03_AWREADY),
    .AXI_03_WDATA(instHbm_AXI_03_WDATA),
    .AXI_03_WLAST(instHbm_AXI_03_WLAST),
    .AXI_03_WSTRB(instHbm_AXI_03_WSTRB),
    .AXI_03_WVALID(instHbm_AXI_03_WVALID),
    .AXI_03_WREADY(instHbm_AXI_03_WREADY),
    .AXI_03_RDATA(instHbm_AXI_03_RDATA),
    .AXI_03_RID(instHbm_AXI_03_RID),
    .AXI_03_RLAST(instHbm_AXI_03_RLAST),
    .AXI_03_RRESP(instHbm_AXI_03_RRESP),
    .AXI_03_RVALID(instHbm_AXI_03_RVALID),
    .AXI_03_RREADY(instHbm_AXI_03_RREADY),
    .AXI_03_BID(instHbm_AXI_03_BID),
    .AXI_03_BRESP(instHbm_AXI_03_BRESP),
    .AXI_03_BVALID(instHbm_AXI_03_BVALID),
    .AXI_03_BREADY(instHbm_AXI_03_BREADY),
    .AXI_03_WDATA_PARITY(instHbm_AXI_03_WDATA_PARITY),
    .AXI_03_RDATA_PARITY(instHbm_AXI_03_RDATA_PARITY),
    .AXI_04_ACLK(instHbm_AXI_04_ACLK),
    .AXI_04_ARESET_N(instHbm_AXI_04_ARESET_N),
    .AXI_04_ARADDR(instHbm_AXI_04_ARADDR),
    .AXI_04_ARBURST(instHbm_AXI_04_ARBURST),
    .AXI_04_ARID(instHbm_AXI_04_ARID),
    .AXI_04_ARLEN(instHbm_AXI_04_ARLEN),
    .AXI_04_ARSIZE(instHbm_AXI_04_ARSIZE),
    .AXI_04_ARVALID(instHbm_AXI_04_ARVALID),
    .AXI_04_ARREADY(instHbm_AXI_04_ARREADY),
    .AXI_04_AWADDR(instHbm_AXI_04_AWADDR),
    .AXI_04_AWBURST(instHbm_AXI_04_AWBURST),
    .AXI_04_AWID(instHbm_AXI_04_AWID),
    .AXI_04_AWLEN(instHbm_AXI_04_AWLEN),
    .AXI_04_AWSIZE(instHbm_AXI_04_AWSIZE),
    .AXI_04_AWVALID(instHbm_AXI_04_AWVALID),
    .AXI_04_AWREADY(instHbm_AXI_04_AWREADY),
    .AXI_04_WDATA(instHbm_AXI_04_WDATA),
    .AXI_04_WLAST(instHbm_AXI_04_WLAST),
    .AXI_04_WSTRB(instHbm_AXI_04_WSTRB),
    .AXI_04_WVALID(instHbm_AXI_04_WVALID),
    .AXI_04_WREADY(instHbm_AXI_04_WREADY),
    .AXI_04_RDATA(instHbm_AXI_04_RDATA),
    .AXI_04_RID(instHbm_AXI_04_RID),
    .AXI_04_RLAST(instHbm_AXI_04_RLAST),
    .AXI_04_RRESP(instHbm_AXI_04_RRESP),
    .AXI_04_RVALID(instHbm_AXI_04_RVALID),
    .AXI_04_RREADY(instHbm_AXI_04_RREADY),
    .AXI_04_BID(instHbm_AXI_04_BID),
    .AXI_04_BRESP(instHbm_AXI_04_BRESP),
    .AXI_04_BVALID(instHbm_AXI_04_BVALID),
    .AXI_04_BREADY(instHbm_AXI_04_BREADY),
    .AXI_04_WDATA_PARITY(instHbm_AXI_04_WDATA_PARITY),
    .AXI_04_RDATA_PARITY(instHbm_AXI_04_RDATA_PARITY),
    .AXI_05_ACLK(instHbm_AXI_05_ACLK),
    .AXI_05_ARESET_N(instHbm_AXI_05_ARESET_N),
    .AXI_05_ARADDR(instHbm_AXI_05_ARADDR),
    .AXI_05_ARBURST(instHbm_AXI_05_ARBURST),
    .AXI_05_ARID(instHbm_AXI_05_ARID),
    .AXI_05_ARLEN(instHbm_AXI_05_ARLEN),
    .AXI_05_ARSIZE(instHbm_AXI_05_ARSIZE),
    .AXI_05_ARVALID(instHbm_AXI_05_ARVALID),
    .AXI_05_ARREADY(instHbm_AXI_05_ARREADY),
    .AXI_05_AWADDR(instHbm_AXI_05_AWADDR),
    .AXI_05_AWBURST(instHbm_AXI_05_AWBURST),
    .AXI_05_AWID(instHbm_AXI_05_AWID),
    .AXI_05_AWLEN(instHbm_AXI_05_AWLEN),
    .AXI_05_AWSIZE(instHbm_AXI_05_AWSIZE),
    .AXI_05_AWVALID(instHbm_AXI_05_AWVALID),
    .AXI_05_AWREADY(instHbm_AXI_05_AWREADY),
    .AXI_05_WDATA(instHbm_AXI_05_WDATA),
    .AXI_05_WLAST(instHbm_AXI_05_WLAST),
    .AXI_05_WSTRB(instHbm_AXI_05_WSTRB),
    .AXI_05_WVALID(instHbm_AXI_05_WVALID),
    .AXI_05_WREADY(instHbm_AXI_05_WREADY),
    .AXI_05_RDATA(instHbm_AXI_05_RDATA),
    .AXI_05_RID(instHbm_AXI_05_RID),
    .AXI_05_RLAST(instHbm_AXI_05_RLAST),
    .AXI_05_RRESP(instHbm_AXI_05_RRESP),
    .AXI_05_RVALID(instHbm_AXI_05_RVALID),
    .AXI_05_RREADY(instHbm_AXI_05_RREADY),
    .AXI_05_BID(instHbm_AXI_05_BID),
    .AXI_05_BRESP(instHbm_AXI_05_BRESP),
    .AXI_05_BVALID(instHbm_AXI_05_BVALID),
    .AXI_05_BREADY(instHbm_AXI_05_BREADY),
    .AXI_05_WDATA_PARITY(instHbm_AXI_05_WDATA_PARITY),
    .AXI_05_RDATA_PARITY(instHbm_AXI_05_RDATA_PARITY),
    .AXI_06_ACLK(instHbm_AXI_06_ACLK),
    .AXI_06_ARESET_N(instHbm_AXI_06_ARESET_N),
    .AXI_06_ARADDR(instHbm_AXI_06_ARADDR),
    .AXI_06_ARBURST(instHbm_AXI_06_ARBURST),
    .AXI_06_ARID(instHbm_AXI_06_ARID),
    .AXI_06_ARLEN(instHbm_AXI_06_ARLEN),
    .AXI_06_ARSIZE(instHbm_AXI_06_ARSIZE),
    .AXI_06_ARVALID(instHbm_AXI_06_ARVALID),
    .AXI_06_ARREADY(instHbm_AXI_06_ARREADY),
    .AXI_06_AWADDR(instHbm_AXI_06_AWADDR),
    .AXI_06_AWBURST(instHbm_AXI_06_AWBURST),
    .AXI_06_AWID(instHbm_AXI_06_AWID),
    .AXI_06_AWLEN(instHbm_AXI_06_AWLEN),
    .AXI_06_AWSIZE(instHbm_AXI_06_AWSIZE),
    .AXI_06_AWVALID(instHbm_AXI_06_AWVALID),
    .AXI_06_AWREADY(instHbm_AXI_06_AWREADY),
    .AXI_06_WDATA(instHbm_AXI_06_WDATA),
    .AXI_06_WLAST(instHbm_AXI_06_WLAST),
    .AXI_06_WSTRB(instHbm_AXI_06_WSTRB),
    .AXI_06_WVALID(instHbm_AXI_06_WVALID),
    .AXI_06_WREADY(instHbm_AXI_06_WREADY),
    .AXI_06_RDATA(instHbm_AXI_06_RDATA),
    .AXI_06_RID(instHbm_AXI_06_RID),
    .AXI_06_RLAST(instHbm_AXI_06_RLAST),
    .AXI_06_RRESP(instHbm_AXI_06_RRESP),
    .AXI_06_RVALID(instHbm_AXI_06_RVALID),
    .AXI_06_RREADY(instHbm_AXI_06_RREADY),
    .AXI_06_BID(instHbm_AXI_06_BID),
    .AXI_06_BRESP(instHbm_AXI_06_BRESP),
    .AXI_06_BVALID(instHbm_AXI_06_BVALID),
    .AXI_06_BREADY(instHbm_AXI_06_BREADY),
    .AXI_06_WDATA_PARITY(instHbm_AXI_06_WDATA_PARITY),
    .AXI_06_RDATA_PARITY(instHbm_AXI_06_RDATA_PARITY),
    .AXI_07_ACLK(instHbm_AXI_07_ACLK),
    .AXI_07_ARESET_N(instHbm_AXI_07_ARESET_N),
    .AXI_07_ARADDR(instHbm_AXI_07_ARADDR),
    .AXI_07_ARBURST(instHbm_AXI_07_ARBURST),
    .AXI_07_ARID(instHbm_AXI_07_ARID),
    .AXI_07_ARLEN(instHbm_AXI_07_ARLEN),
    .AXI_07_ARSIZE(instHbm_AXI_07_ARSIZE),
    .AXI_07_ARVALID(instHbm_AXI_07_ARVALID),
    .AXI_07_ARREADY(instHbm_AXI_07_ARREADY),
    .AXI_07_AWADDR(instHbm_AXI_07_AWADDR),
    .AXI_07_AWBURST(instHbm_AXI_07_AWBURST),
    .AXI_07_AWID(instHbm_AXI_07_AWID),
    .AXI_07_AWLEN(instHbm_AXI_07_AWLEN),
    .AXI_07_AWSIZE(instHbm_AXI_07_AWSIZE),
    .AXI_07_AWVALID(instHbm_AXI_07_AWVALID),
    .AXI_07_AWREADY(instHbm_AXI_07_AWREADY),
    .AXI_07_WDATA(instHbm_AXI_07_WDATA),
    .AXI_07_WLAST(instHbm_AXI_07_WLAST),
    .AXI_07_WSTRB(instHbm_AXI_07_WSTRB),
    .AXI_07_WVALID(instHbm_AXI_07_WVALID),
    .AXI_07_WREADY(instHbm_AXI_07_WREADY),
    .AXI_07_RDATA(instHbm_AXI_07_RDATA),
    .AXI_07_RID(instHbm_AXI_07_RID),
    .AXI_07_RLAST(instHbm_AXI_07_RLAST),
    .AXI_07_RRESP(instHbm_AXI_07_RRESP),
    .AXI_07_RVALID(instHbm_AXI_07_RVALID),
    .AXI_07_RREADY(instHbm_AXI_07_RREADY),
    .AXI_07_BID(instHbm_AXI_07_BID),
    .AXI_07_BRESP(instHbm_AXI_07_BRESP),
    .AXI_07_BVALID(instHbm_AXI_07_BVALID),
    .AXI_07_BREADY(instHbm_AXI_07_BREADY),
    .AXI_07_WDATA_PARITY(instHbm_AXI_07_WDATA_PARITY),
    .AXI_07_RDATA_PARITY(instHbm_AXI_07_RDATA_PARITY),
    .AXI_08_ACLK(instHbm_AXI_08_ACLK),
    .AXI_08_ARESET_N(instHbm_AXI_08_ARESET_N),
    .AXI_08_ARADDR(instHbm_AXI_08_ARADDR),
    .AXI_08_ARBURST(instHbm_AXI_08_ARBURST),
    .AXI_08_ARID(instHbm_AXI_08_ARID),
    .AXI_08_ARLEN(instHbm_AXI_08_ARLEN),
    .AXI_08_ARSIZE(instHbm_AXI_08_ARSIZE),
    .AXI_08_ARVALID(instHbm_AXI_08_ARVALID),
    .AXI_08_ARREADY(instHbm_AXI_08_ARREADY),
    .AXI_08_AWADDR(instHbm_AXI_08_AWADDR),
    .AXI_08_AWBURST(instHbm_AXI_08_AWBURST),
    .AXI_08_AWID(instHbm_AXI_08_AWID),
    .AXI_08_AWLEN(instHbm_AXI_08_AWLEN),
    .AXI_08_AWSIZE(instHbm_AXI_08_AWSIZE),
    .AXI_08_AWVALID(instHbm_AXI_08_AWVALID),
    .AXI_08_AWREADY(instHbm_AXI_08_AWREADY),
    .AXI_08_WDATA(instHbm_AXI_08_WDATA),
    .AXI_08_WLAST(instHbm_AXI_08_WLAST),
    .AXI_08_WSTRB(instHbm_AXI_08_WSTRB),
    .AXI_08_WVALID(instHbm_AXI_08_WVALID),
    .AXI_08_WREADY(instHbm_AXI_08_WREADY),
    .AXI_08_RDATA(instHbm_AXI_08_RDATA),
    .AXI_08_RID(instHbm_AXI_08_RID),
    .AXI_08_RLAST(instHbm_AXI_08_RLAST),
    .AXI_08_RRESP(instHbm_AXI_08_RRESP),
    .AXI_08_RVALID(instHbm_AXI_08_RVALID),
    .AXI_08_RREADY(instHbm_AXI_08_RREADY),
    .AXI_08_BID(instHbm_AXI_08_BID),
    .AXI_08_BRESP(instHbm_AXI_08_BRESP),
    .AXI_08_BVALID(instHbm_AXI_08_BVALID),
    .AXI_08_BREADY(instHbm_AXI_08_BREADY),
    .AXI_08_WDATA_PARITY(instHbm_AXI_08_WDATA_PARITY),
    .AXI_08_RDATA_PARITY(instHbm_AXI_08_RDATA_PARITY),
    .AXI_09_ACLK(instHbm_AXI_09_ACLK),
    .AXI_09_ARESET_N(instHbm_AXI_09_ARESET_N),
    .AXI_09_ARADDR(instHbm_AXI_09_ARADDR),
    .AXI_09_ARBURST(instHbm_AXI_09_ARBURST),
    .AXI_09_ARID(instHbm_AXI_09_ARID),
    .AXI_09_ARLEN(instHbm_AXI_09_ARLEN),
    .AXI_09_ARSIZE(instHbm_AXI_09_ARSIZE),
    .AXI_09_ARVALID(instHbm_AXI_09_ARVALID),
    .AXI_09_ARREADY(instHbm_AXI_09_ARREADY),
    .AXI_09_AWADDR(instHbm_AXI_09_AWADDR),
    .AXI_09_AWBURST(instHbm_AXI_09_AWBURST),
    .AXI_09_AWID(instHbm_AXI_09_AWID),
    .AXI_09_AWLEN(instHbm_AXI_09_AWLEN),
    .AXI_09_AWSIZE(instHbm_AXI_09_AWSIZE),
    .AXI_09_AWVALID(instHbm_AXI_09_AWVALID),
    .AXI_09_AWREADY(instHbm_AXI_09_AWREADY),
    .AXI_09_WDATA(instHbm_AXI_09_WDATA),
    .AXI_09_WLAST(instHbm_AXI_09_WLAST),
    .AXI_09_WSTRB(instHbm_AXI_09_WSTRB),
    .AXI_09_WVALID(instHbm_AXI_09_WVALID),
    .AXI_09_WREADY(instHbm_AXI_09_WREADY),
    .AXI_09_RDATA(instHbm_AXI_09_RDATA),
    .AXI_09_RID(instHbm_AXI_09_RID),
    .AXI_09_RLAST(instHbm_AXI_09_RLAST),
    .AXI_09_RRESP(instHbm_AXI_09_RRESP),
    .AXI_09_RVALID(instHbm_AXI_09_RVALID),
    .AXI_09_RREADY(instHbm_AXI_09_RREADY),
    .AXI_09_BID(instHbm_AXI_09_BID),
    .AXI_09_BRESP(instHbm_AXI_09_BRESP),
    .AXI_09_BVALID(instHbm_AXI_09_BVALID),
    .AXI_09_BREADY(instHbm_AXI_09_BREADY),
    .AXI_09_WDATA_PARITY(instHbm_AXI_09_WDATA_PARITY),
    .AXI_09_RDATA_PARITY(instHbm_AXI_09_RDATA_PARITY),
    .AXI_10_ACLK(instHbm_AXI_10_ACLK),
    .AXI_10_ARESET_N(instHbm_AXI_10_ARESET_N),
    .AXI_10_ARADDR(instHbm_AXI_10_ARADDR),
    .AXI_10_ARBURST(instHbm_AXI_10_ARBURST),
    .AXI_10_ARID(instHbm_AXI_10_ARID),
    .AXI_10_ARLEN(instHbm_AXI_10_ARLEN),
    .AXI_10_ARSIZE(instHbm_AXI_10_ARSIZE),
    .AXI_10_ARVALID(instHbm_AXI_10_ARVALID),
    .AXI_10_ARREADY(instHbm_AXI_10_ARREADY),
    .AXI_10_AWADDR(instHbm_AXI_10_AWADDR),
    .AXI_10_AWBURST(instHbm_AXI_10_AWBURST),
    .AXI_10_AWID(instHbm_AXI_10_AWID),
    .AXI_10_AWLEN(instHbm_AXI_10_AWLEN),
    .AXI_10_AWSIZE(instHbm_AXI_10_AWSIZE),
    .AXI_10_AWVALID(instHbm_AXI_10_AWVALID),
    .AXI_10_AWREADY(instHbm_AXI_10_AWREADY),
    .AXI_10_WDATA(instHbm_AXI_10_WDATA),
    .AXI_10_WLAST(instHbm_AXI_10_WLAST),
    .AXI_10_WSTRB(instHbm_AXI_10_WSTRB),
    .AXI_10_WVALID(instHbm_AXI_10_WVALID),
    .AXI_10_WREADY(instHbm_AXI_10_WREADY),
    .AXI_10_RDATA(instHbm_AXI_10_RDATA),
    .AXI_10_RID(instHbm_AXI_10_RID),
    .AXI_10_RLAST(instHbm_AXI_10_RLAST),
    .AXI_10_RRESP(instHbm_AXI_10_RRESP),
    .AXI_10_RVALID(instHbm_AXI_10_RVALID),
    .AXI_10_RREADY(instHbm_AXI_10_RREADY),
    .AXI_10_BID(instHbm_AXI_10_BID),
    .AXI_10_BRESP(instHbm_AXI_10_BRESP),
    .AXI_10_BVALID(instHbm_AXI_10_BVALID),
    .AXI_10_BREADY(instHbm_AXI_10_BREADY),
    .AXI_10_WDATA_PARITY(instHbm_AXI_10_WDATA_PARITY),
    .AXI_10_RDATA_PARITY(instHbm_AXI_10_RDATA_PARITY),
    .AXI_11_ACLK(instHbm_AXI_11_ACLK),
    .AXI_11_ARESET_N(instHbm_AXI_11_ARESET_N),
    .AXI_11_ARADDR(instHbm_AXI_11_ARADDR),
    .AXI_11_ARBURST(instHbm_AXI_11_ARBURST),
    .AXI_11_ARID(instHbm_AXI_11_ARID),
    .AXI_11_ARLEN(instHbm_AXI_11_ARLEN),
    .AXI_11_ARSIZE(instHbm_AXI_11_ARSIZE),
    .AXI_11_ARVALID(instHbm_AXI_11_ARVALID),
    .AXI_11_ARREADY(instHbm_AXI_11_ARREADY),
    .AXI_11_AWADDR(instHbm_AXI_11_AWADDR),
    .AXI_11_AWBURST(instHbm_AXI_11_AWBURST),
    .AXI_11_AWID(instHbm_AXI_11_AWID),
    .AXI_11_AWLEN(instHbm_AXI_11_AWLEN),
    .AXI_11_AWSIZE(instHbm_AXI_11_AWSIZE),
    .AXI_11_AWVALID(instHbm_AXI_11_AWVALID),
    .AXI_11_AWREADY(instHbm_AXI_11_AWREADY),
    .AXI_11_WDATA(instHbm_AXI_11_WDATA),
    .AXI_11_WLAST(instHbm_AXI_11_WLAST),
    .AXI_11_WSTRB(instHbm_AXI_11_WSTRB),
    .AXI_11_WVALID(instHbm_AXI_11_WVALID),
    .AXI_11_WREADY(instHbm_AXI_11_WREADY),
    .AXI_11_RDATA(instHbm_AXI_11_RDATA),
    .AXI_11_RID(instHbm_AXI_11_RID),
    .AXI_11_RLAST(instHbm_AXI_11_RLAST),
    .AXI_11_RRESP(instHbm_AXI_11_RRESP),
    .AXI_11_RVALID(instHbm_AXI_11_RVALID),
    .AXI_11_RREADY(instHbm_AXI_11_RREADY),
    .AXI_11_BID(instHbm_AXI_11_BID),
    .AXI_11_BRESP(instHbm_AXI_11_BRESP),
    .AXI_11_BVALID(instHbm_AXI_11_BVALID),
    .AXI_11_BREADY(instHbm_AXI_11_BREADY),
    .AXI_11_WDATA_PARITY(instHbm_AXI_11_WDATA_PARITY),
    .AXI_11_RDATA_PARITY(instHbm_AXI_11_RDATA_PARITY),
    .AXI_12_ACLK(instHbm_AXI_12_ACLK),
    .AXI_12_ARESET_N(instHbm_AXI_12_ARESET_N),
    .AXI_12_ARADDR(instHbm_AXI_12_ARADDR),
    .AXI_12_ARBURST(instHbm_AXI_12_ARBURST),
    .AXI_12_ARID(instHbm_AXI_12_ARID),
    .AXI_12_ARLEN(instHbm_AXI_12_ARLEN),
    .AXI_12_ARSIZE(instHbm_AXI_12_ARSIZE),
    .AXI_12_ARVALID(instHbm_AXI_12_ARVALID),
    .AXI_12_ARREADY(instHbm_AXI_12_ARREADY),
    .AXI_12_AWADDR(instHbm_AXI_12_AWADDR),
    .AXI_12_AWBURST(instHbm_AXI_12_AWBURST),
    .AXI_12_AWID(instHbm_AXI_12_AWID),
    .AXI_12_AWLEN(instHbm_AXI_12_AWLEN),
    .AXI_12_AWSIZE(instHbm_AXI_12_AWSIZE),
    .AXI_12_AWVALID(instHbm_AXI_12_AWVALID),
    .AXI_12_AWREADY(instHbm_AXI_12_AWREADY),
    .AXI_12_WDATA(instHbm_AXI_12_WDATA),
    .AXI_12_WLAST(instHbm_AXI_12_WLAST),
    .AXI_12_WSTRB(instHbm_AXI_12_WSTRB),
    .AXI_12_WVALID(instHbm_AXI_12_WVALID),
    .AXI_12_WREADY(instHbm_AXI_12_WREADY),
    .AXI_12_RDATA(instHbm_AXI_12_RDATA),
    .AXI_12_RID(instHbm_AXI_12_RID),
    .AXI_12_RLAST(instHbm_AXI_12_RLAST),
    .AXI_12_RRESP(instHbm_AXI_12_RRESP),
    .AXI_12_RVALID(instHbm_AXI_12_RVALID),
    .AXI_12_RREADY(instHbm_AXI_12_RREADY),
    .AXI_12_BID(instHbm_AXI_12_BID),
    .AXI_12_BRESP(instHbm_AXI_12_BRESP),
    .AXI_12_BVALID(instHbm_AXI_12_BVALID),
    .AXI_12_BREADY(instHbm_AXI_12_BREADY),
    .AXI_12_WDATA_PARITY(instHbm_AXI_12_WDATA_PARITY),
    .AXI_12_RDATA_PARITY(instHbm_AXI_12_RDATA_PARITY),
    .AXI_13_ACLK(instHbm_AXI_13_ACLK),
    .AXI_13_ARESET_N(instHbm_AXI_13_ARESET_N),
    .AXI_13_ARADDR(instHbm_AXI_13_ARADDR),
    .AXI_13_ARBURST(instHbm_AXI_13_ARBURST),
    .AXI_13_ARID(instHbm_AXI_13_ARID),
    .AXI_13_ARLEN(instHbm_AXI_13_ARLEN),
    .AXI_13_ARSIZE(instHbm_AXI_13_ARSIZE),
    .AXI_13_ARVALID(instHbm_AXI_13_ARVALID),
    .AXI_13_ARREADY(instHbm_AXI_13_ARREADY),
    .AXI_13_AWADDR(instHbm_AXI_13_AWADDR),
    .AXI_13_AWBURST(instHbm_AXI_13_AWBURST),
    .AXI_13_AWID(instHbm_AXI_13_AWID),
    .AXI_13_AWLEN(instHbm_AXI_13_AWLEN),
    .AXI_13_AWSIZE(instHbm_AXI_13_AWSIZE),
    .AXI_13_AWVALID(instHbm_AXI_13_AWVALID),
    .AXI_13_AWREADY(instHbm_AXI_13_AWREADY),
    .AXI_13_WDATA(instHbm_AXI_13_WDATA),
    .AXI_13_WLAST(instHbm_AXI_13_WLAST),
    .AXI_13_WSTRB(instHbm_AXI_13_WSTRB),
    .AXI_13_WVALID(instHbm_AXI_13_WVALID),
    .AXI_13_WREADY(instHbm_AXI_13_WREADY),
    .AXI_13_RDATA(instHbm_AXI_13_RDATA),
    .AXI_13_RID(instHbm_AXI_13_RID),
    .AXI_13_RLAST(instHbm_AXI_13_RLAST),
    .AXI_13_RRESP(instHbm_AXI_13_RRESP),
    .AXI_13_RVALID(instHbm_AXI_13_RVALID),
    .AXI_13_RREADY(instHbm_AXI_13_RREADY),
    .AXI_13_BID(instHbm_AXI_13_BID),
    .AXI_13_BRESP(instHbm_AXI_13_BRESP),
    .AXI_13_BVALID(instHbm_AXI_13_BVALID),
    .AXI_13_BREADY(instHbm_AXI_13_BREADY),
    .AXI_13_WDATA_PARITY(instHbm_AXI_13_WDATA_PARITY),
    .AXI_13_RDATA_PARITY(instHbm_AXI_13_RDATA_PARITY),
    .AXI_14_ACLK(instHbm_AXI_14_ACLK),
    .AXI_14_ARESET_N(instHbm_AXI_14_ARESET_N),
    .AXI_14_ARADDR(instHbm_AXI_14_ARADDR),
    .AXI_14_ARBURST(instHbm_AXI_14_ARBURST),
    .AXI_14_ARID(instHbm_AXI_14_ARID),
    .AXI_14_ARLEN(instHbm_AXI_14_ARLEN),
    .AXI_14_ARSIZE(instHbm_AXI_14_ARSIZE),
    .AXI_14_ARVALID(instHbm_AXI_14_ARVALID),
    .AXI_14_ARREADY(instHbm_AXI_14_ARREADY),
    .AXI_14_AWADDR(instHbm_AXI_14_AWADDR),
    .AXI_14_AWBURST(instHbm_AXI_14_AWBURST),
    .AXI_14_AWID(instHbm_AXI_14_AWID),
    .AXI_14_AWLEN(instHbm_AXI_14_AWLEN),
    .AXI_14_AWSIZE(instHbm_AXI_14_AWSIZE),
    .AXI_14_AWVALID(instHbm_AXI_14_AWVALID),
    .AXI_14_AWREADY(instHbm_AXI_14_AWREADY),
    .AXI_14_WDATA(instHbm_AXI_14_WDATA),
    .AXI_14_WLAST(instHbm_AXI_14_WLAST),
    .AXI_14_WSTRB(instHbm_AXI_14_WSTRB),
    .AXI_14_WVALID(instHbm_AXI_14_WVALID),
    .AXI_14_WREADY(instHbm_AXI_14_WREADY),
    .AXI_14_RDATA(instHbm_AXI_14_RDATA),
    .AXI_14_RID(instHbm_AXI_14_RID),
    .AXI_14_RLAST(instHbm_AXI_14_RLAST),
    .AXI_14_RRESP(instHbm_AXI_14_RRESP),
    .AXI_14_RVALID(instHbm_AXI_14_RVALID),
    .AXI_14_RREADY(instHbm_AXI_14_RREADY),
    .AXI_14_BID(instHbm_AXI_14_BID),
    .AXI_14_BRESP(instHbm_AXI_14_BRESP),
    .AXI_14_BVALID(instHbm_AXI_14_BVALID),
    .AXI_14_BREADY(instHbm_AXI_14_BREADY),
    .AXI_14_WDATA_PARITY(instHbm_AXI_14_WDATA_PARITY),
    .AXI_14_RDATA_PARITY(instHbm_AXI_14_RDATA_PARITY),
    .AXI_15_ACLK(instHbm_AXI_15_ACLK),
    .AXI_15_ARESET_N(instHbm_AXI_15_ARESET_N),
    .AXI_15_ARADDR(instHbm_AXI_15_ARADDR),
    .AXI_15_ARBURST(instHbm_AXI_15_ARBURST),
    .AXI_15_ARID(instHbm_AXI_15_ARID),
    .AXI_15_ARLEN(instHbm_AXI_15_ARLEN),
    .AXI_15_ARSIZE(instHbm_AXI_15_ARSIZE),
    .AXI_15_ARVALID(instHbm_AXI_15_ARVALID),
    .AXI_15_ARREADY(instHbm_AXI_15_ARREADY),
    .AXI_15_AWADDR(instHbm_AXI_15_AWADDR),
    .AXI_15_AWBURST(instHbm_AXI_15_AWBURST),
    .AXI_15_AWID(instHbm_AXI_15_AWID),
    .AXI_15_AWLEN(instHbm_AXI_15_AWLEN),
    .AXI_15_AWSIZE(instHbm_AXI_15_AWSIZE),
    .AXI_15_AWVALID(instHbm_AXI_15_AWVALID),
    .AXI_15_AWREADY(instHbm_AXI_15_AWREADY),
    .AXI_15_WDATA(instHbm_AXI_15_WDATA),
    .AXI_15_WLAST(instHbm_AXI_15_WLAST),
    .AXI_15_WSTRB(instHbm_AXI_15_WSTRB),
    .AXI_15_WVALID(instHbm_AXI_15_WVALID),
    .AXI_15_WREADY(instHbm_AXI_15_WREADY),
    .AXI_15_RDATA(instHbm_AXI_15_RDATA),
    .AXI_15_RID(instHbm_AXI_15_RID),
    .AXI_15_RLAST(instHbm_AXI_15_RLAST),
    .AXI_15_RRESP(instHbm_AXI_15_RRESP),
    .AXI_15_RVALID(instHbm_AXI_15_RVALID),
    .AXI_15_RREADY(instHbm_AXI_15_RREADY),
    .AXI_15_BID(instHbm_AXI_15_BID),
    .AXI_15_BRESP(instHbm_AXI_15_BRESP),
    .AXI_15_BVALID(instHbm_AXI_15_BVALID),
    .AXI_15_BREADY(instHbm_AXI_15_BREADY),
    .AXI_15_WDATA_PARITY(instHbm_AXI_15_WDATA_PARITY),
    .AXI_15_RDATA_PARITY(instHbm_AXI_15_RDATA_PARITY),
    .AXI_16_ACLK(instHbm_AXI_16_ACLK),
    .AXI_16_ARESET_N(instHbm_AXI_16_ARESET_N),
    .AXI_16_ARADDR(instHbm_AXI_16_ARADDR),
    .AXI_16_ARBURST(instHbm_AXI_16_ARBURST),
    .AXI_16_ARID(instHbm_AXI_16_ARID),
    .AXI_16_ARLEN(instHbm_AXI_16_ARLEN),
    .AXI_16_ARSIZE(instHbm_AXI_16_ARSIZE),
    .AXI_16_ARVALID(instHbm_AXI_16_ARVALID),
    .AXI_16_ARREADY(instHbm_AXI_16_ARREADY),
    .AXI_16_AWADDR(instHbm_AXI_16_AWADDR),
    .AXI_16_AWBURST(instHbm_AXI_16_AWBURST),
    .AXI_16_AWID(instHbm_AXI_16_AWID),
    .AXI_16_AWLEN(instHbm_AXI_16_AWLEN),
    .AXI_16_AWSIZE(instHbm_AXI_16_AWSIZE),
    .AXI_16_AWVALID(instHbm_AXI_16_AWVALID),
    .AXI_16_AWREADY(instHbm_AXI_16_AWREADY),
    .AXI_16_WDATA(instHbm_AXI_16_WDATA),
    .AXI_16_WLAST(instHbm_AXI_16_WLAST),
    .AXI_16_WSTRB(instHbm_AXI_16_WSTRB),
    .AXI_16_WVALID(instHbm_AXI_16_WVALID),
    .AXI_16_WREADY(instHbm_AXI_16_WREADY),
    .AXI_16_RDATA(instHbm_AXI_16_RDATA),
    .AXI_16_RID(instHbm_AXI_16_RID),
    .AXI_16_RLAST(instHbm_AXI_16_RLAST),
    .AXI_16_RRESP(instHbm_AXI_16_RRESP),
    .AXI_16_RVALID(instHbm_AXI_16_RVALID),
    .AXI_16_RREADY(instHbm_AXI_16_RREADY),
    .AXI_16_BID(instHbm_AXI_16_BID),
    .AXI_16_BRESP(instHbm_AXI_16_BRESP),
    .AXI_16_BVALID(instHbm_AXI_16_BVALID),
    .AXI_16_BREADY(instHbm_AXI_16_BREADY),
    .AXI_16_WDATA_PARITY(instHbm_AXI_16_WDATA_PARITY),
    .AXI_16_RDATA_PARITY(instHbm_AXI_16_RDATA_PARITY),
    .AXI_17_ACLK(instHbm_AXI_17_ACLK),
    .AXI_17_ARESET_N(instHbm_AXI_17_ARESET_N),
    .AXI_17_ARADDR(instHbm_AXI_17_ARADDR),
    .AXI_17_ARBURST(instHbm_AXI_17_ARBURST),
    .AXI_17_ARID(instHbm_AXI_17_ARID),
    .AXI_17_ARLEN(instHbm_AXI_17_ARLEN),
    .AXI_17_ARSIZE(instHbm_AXI_17_ARSIZE),
    .AXI_17_ARVALID(instHbm_AXI_17_ARVALID),
    .AXI_17_ARREADY(instHbm_AXI_17_ARREADY),
    .AXI_17_AWADDR(instHbm_AXI_17_AWADDR),
    .AXI_17_AWBURST(instHbm_AXI_17_AWBURST),
    .AXI_17_AWID(instHbm_AXI_17_AWID),
    .AXI_17_AWLEN(instHbm_AXI_17_AWLEN),
    .AXI_17_AWSIZE(instHbm_AXI_17_AWSIZE),
    .AXI_17_AWVALID(instHbm_AXI_17_AWVALID),
    .AXI_17_AWREADY(instHbm_AXI_17_AWREADY),
    .AXI_17_WDATA(instHbm_AXI_17_WDATA),
    .AXI_17_WLAST(instHbm_AXI_17_WLAST),
    .AXI_17_WSTRB(instHbm_AXI_17_WSTRB),
    .AXI_17_WVALID(instHbm_AXI_17_WVALID),
    .AXI_17_WREADY(instHbm_AXI_17_WREADY),
    .AXI_17_RDATA(instHbm_AXI_17_RDATA),
    .AXI_17_RID(instHbm_AXI_17_RID),
    .AXI_17_RLAST(instHbm_AXI_17_RLAST),
    .AXI_17_RRESP(instHbm_AXI_17_RRESP),
    .AXI_17_RVALID(instHbm_AXI_17_RVALID),
    .AXI_17_RREADY(instHbm_AXI_17_RREADY),
    .AXI_17_BID(instHbm_AXI_17_BID),
    .AXI_17_BRESP(instHbm_AXI_17_BRESP),
    .AXI_17_BVALID(instHbm_AXI_17_BVALID),
    .AXI_17_BREADY(instHbm_AXI_17_BREADY),
    .AXI_17_WDATA_PARITY(instHbm_AXI_17_WDATA_PARITY),
    .AXI_17_RDATA_PARITY(instHbm_AXI_17_RDATA_PARITY),
    .AXI_18_ACLK(instHbm_AXI_18_ACLK),
    .AXI_18_ARESET_N(instHbm_AXI_18_ARESET_N),
    .AXI_18_ARADDR(instHbm_AXI_18_ARADDR),
    .AXI_18_ARBURST(instHbm_AXI_18_ARBURST),
    .AXI_18_ARID(instHbm_AXI_18_ARID),
    .AXI_18_ARLEN(instHbm_AXI_18_ARLEN),
    .AXI_18_ARSIZE(instHbm_AXI_18_ARSIZE),
    .AXI_18_ARVALID(instHbm_AXI_18_ARVALID),
    .AXI_18_ARREADY(instHbm_AXI_18_ARREADY),
    .AXI_18_AWADDR(instHbm_AXI_18_AWADDR),
    .AXI_18_AWBURST(instHbm_AXI_18_AWBURST),
    .AXI_18_AWID(instHbm_AXI_18_AWID),
    .AXI_18_AWLEN(instHbm_AXI_18_AWLEN),
    .AXI_18_AWSIZE(instHbm_AXI_18_AWSIZE),
    .AXI_18_AWVALID(instHbm_AXI_18_AWVALID),
    .AXI_18_AWREADY(instHbm_AXI_18_AWREADY),
    .AXI_18_WDATA(instHbm_AXI_18_WDATA),
    .AXI_18_WLAST(instHbm_AXI_18_WLAST),
    .AXI_18_WSTRB(instHbm_AXI_18_WSTRB),
    .AXI_18_WVALID(instHbm_AXI_18_WVALID),
    .AXI_18_WREADY(instHbm_AXI_18_WREADY),
    .AXI_18_RDATA(instHbm_AXI_18_RDATA),
    .AXI_18_RID(instHbm_AXI_18_RID),
    .AXI_18_RLAST(instHbm_AXI_18_RLAST),
    .AXI_18_RRESP(instHbm_AXI_18_RRESP),
    .AXI_18_RVALID(instHbm_AXI_18_RVALID),
    .AXI_18_RREADY(instHbm_AXI_18_RREADY),
    .AXI_18_BID(instHbm_AXI_18_BID),
    .AXI_18_BRESP(instHbm_AXI_18_BRESP),
    .AXI_18_BVALID(instHbm_AXI_18_BVALID),
    .AXI_18_BREADY(instHbm_AXI_18_BREADY),
    .AXI_18_WDATA_PARITY(instHbm_AXI_18_WDATA_PARITY),
    .AXI_18_RDATA_PARITY(instHbm_AXI_18_RDATA_PARITY),
    .AXI_19_ACLK(instHbm_AXI_19_ACLK),
    .AXI_19_ARESET_N(instHbm_AXI_19_ARESET_N),
    .AXI_19_ARADDR(instHbm_AXI_19_ARADDR),
    .AXI_19_ARBURST(instHbm_AXI_19_ARBURST),
    .AXI_19_ARID(instHbm_AXI_19_ARID),
    .AXI_19_ARLEN(instHbm_AXI_19_ARLEN),
    .AXI_19_ARSIZE(instHbm_AXI_19_ARSIZE),
    .AXI_19_ARVALID(instHbm_AXI_19_ARVALID),
    .AXI_19_ARREADY(instHbm_AXI_19_ARREADY),
    .AXI_19_AWADDR(instHbm_AXI_19_AWADDR),
    .AXI_19_AWBURST(instHbm_AXI_19_AWBURST),
    .AXI_19_AWID(instHbm_AXI_19_AWID),
    .AXI_19_AWLEN(instHbm_AXI_19_AWLEN),
    .AXI_19_AWSIZE(instHbm_AXI_19_AWSIZE),
    .AXI_19_AWVALID(instHbm_AXI_19_AWVALID),
    .AXI_19_AWREADY(instHbm_AXI_19_AWREADY),
    .AXI_19_WDATA(instHbm_AXI_19_WDATA),
    .AXI_19_WLAST(instHbm_AXI_19_WLAST),
    .AXI_19_WSTRB(instHbm_AXI_19_WSTRB),
    .AXI_19_WVALID(instHbm_AXI_19_WVALID),
    .AXI_19_WREADY(instHbm_AXI_19_WREADY),
    .AXI_19_RDATA(instHbm_AXI_19_RDATA),
    .AXI_19_RID(instHbm_AXI_19_RID),
    .AXI_19_RLAST(instHbm_AXI_19_RLAST),
    .AXI_19_RRESP(instHbm_AXI_19_RRESP),
    .AXI_19_RVALID(instHbm_AXI_19_RVALID),
    .AXI_19_RREADY(instHbm_AXI_19_RREADY),
    .AXI_19_BID(instHbm_AXI_19_BID),
    .AXI_19_BRESP(instHbm_AXI_19_BRESP),
    .AXI_19_BVALID(instHbm_AXI_19_BVALID),
    .AXI_19_BREADY(instHbm_AXI_19_BREADY),
    .AXI_19_WDATA_PARITY(instHbm_AXI_19_WDATA_PARITY),
    .AXI_19_RDATA_PARITY(instHbm_AXI_19_RDATA_PARITY),
    .AXI_20_ACLK(instHbm_AXI_20_ACLK),
    .AXI_20_ARESET_N(instHbm_AXI_20_ARESET_N),
    .AXI_20_ARADDR(instHbm_AXI_20_ARADDR),
    .AXI_20_ARBURST(instHbm_AXI_20_ARBURST),
    .AXI_20_ARID(instHbm_AXI_20_ARID),
    .AXI_20_ARLEN(instHbm_AXI_20_ARLEN),
    .AXI_20_ARSIZE(instHbm_AXI_20_ARSIZE),
    .AXI_20_ARVALID(instHbm_AXI_20_ARVALID),
    .AXI_20_ARREADY(instHbm_AXI_20_ARREADY),
    .AXI_20_AWADDR(instHbm_AXI_20_AWADDR),
    .AXI_20_AWBURST(instHbm_AXI_20_AWBURST),
    .AXI_20_AWID(instHbm_AXI_20_AWID),
    .AXI_20_AWLEN(instHbm_AXI_20_AWLEN),
    .AXI_20_AWSIZE(instHbm_AXI_20_AWSIZE),
    .AXI_20_AWVALID(instHbm_AXI_20_AWVALID),
    .AXI_20_AWREADY(instHbm_AXI_20_AWREADY),
    .AXI_20_WDATA(instHbm_AXI_20_WDATA),
    .AXI_20_WLAST(instHbm_AXI_20_WLAST),
    .AXI_20_WSTRB(instHbm_AXI_20_WSTRB),
    .AXI_20_WVALID(instHbm_AXI_20_WVALID),
    .AXI_20_WREADY(instHbm_AXI_20_WREADY),
    .AXI_20_RDATA(instHbm_AXI_20_RDATA),
    .AXI_20_RID(instHbm_AXI_20_RID),
    .AXI_20_RLAST(instHbm_AXI_20_RLAST),
    .AXI_20_RRESP(instHbm_AXI_20_RRESP),
    .AXI_20_RVALID(instHbm_AXI_20_RVALID),
    .AXI_20_RREADY(instHbm_AXI_20_RREADY),
    .AXI_20_BID(instHbm_AXI_20_BID),
    .AXI_20_BRESP(instHbm_AXI_20_BRESP),
    .AXI_20_BVALID(instHbm_AXI_20_BVALID),
    .AXI_20_BREADY(instHbm_AXI_20_BREADY),
    .AXI_20_WDATA_PARITY(instHbm_AXI_20_WDATA_PARITY),
    .AXI_20_RDATA_PARITY(instHbm_AXI_20_RDATA_PARITY),
    .AXI_21_ACLK(instHbm_AXI_21_ACLK),
    .AXI_21_ARESET_N(instHbm_AXI_21_ARESET_N),
    .AXI_21_ARADDR(instHbm_AXI_21_ARADDR),
    .AXI_21_ARBURST(instHbm_AXI_21_ARBURST),
    .AXI_21_ARID(instHbm_AXI_21_ARID),
    .AXI_21_ARLEN(instHbm_AXI_21_ARLEN),
    .AXI_21_ARSIZE(instHbm_AXI_21_ARSIZE),
    .AXI_21_ARVALID(instHbm_AXI_21_ARVALID),
    .AXI_21_ARREADY(instHbm_AXI_21_ARREADY),
    .AXI_21_AWADDR(instHbm_AXI_21_AWADDR),
    .AXI_21_AWBURST(instHbm_AXI_21_AWBURST),
    .AXI_21_AWID(instHbm_AXI_21_AWID),
    .AXI_21_AWLEN(instHbm_AXI_21_AWLEN),
    .AXI_21_AWSIZE(instHbm_AXI_21_AWSIZE),
    .AXI_21_AWVALID(instHbm_AXI_21_AWVALID),
    .AXI_21_AWREADY(instHbm_AXI_21_AWREADY),
    .AXI_21_WDATA(instHbm_AXI_21_WDATA),
    .AXI_21_WLAST(instHbm_AXI_21_WLAST),
    .AXI_21_WSTRB(instHbm_AXI_21_WSTRB),
    .AXI_21_WVALID(instHbm_AXI_21_WVALID),
    .AXI_21_WREADY(instHbm_AXI_21_WREADY),
    .AXI_21_RDATA(instHbm_AXI_21_RDATA),
    .AXI_21_RID(instHbm_AXI_21_RID),
    .AXI_21_RLAST(instHbm_AXI_21_RLAST),
    .AXI_21_RRESP(instHbm_AXI_21_RRESP),
    .AXI_21_RVALID(instHbm_AXI_21_RVALID),
    .AXI_21_RREADY(instHbm_AXI_21_RREADY),
    .AXI_21_BID(instHbm_AXI_21_BID),
    .AXI_21_BRESP(instHbm_AXI_21_BRESP),
    .AXI_21_BVALID(instHbm_AXI_21_BVALID),
    .AXI_21_BREADY(instHbm_AXI_21_BREADY),
    .AXI_21_WDATA_PARITY(instHbm_AXI_21_WDATA_PARITY),
    .AXI_21_RDATA_PARITY(instHbm_AXI_21_RDATA_PARITY),
    .AXI_22_ACLK(instHbm_AXI_22_ACLK),
    .AXI_22_ARESET_N(instHbm_AXI_22_ARESET_N),
    .AXI_22_ARADDR(instHbm_AXI_22_ARADDR),
    .AXI_22_ARBURST(instHbm_AXI_22_ARBURST),
    .AXI_22_ARID(instHbm_AXI_22_ARID),
    .AXI_22_ARLEN(instHbm_AXI_22_ARLEN),
    .AXI_22_ARSIZE(instHbm_AXI_22_ARSIZE),
    .AXI_22_ARVALID(instHbm_AXI_22_ARVALID),
    .AXI_22_ARREADY(instHbm_AXI_22_ARREADY),
    .AXI_22_AWADDR(instHbm_AXI_22_AWADDR),
    .AXI_22_AWBURST(instHbm_AXI_22_AWBURST),
    .AXI_22_AWID(instHbm_AXI_22_AWID),
    .AXI_22_AWLEN(instHbm_AXI_22_AWLEN),
    .AXI_22_AWSIZE(instHbm_AXI_22_AWSIZE),
    .AXI_22_AWVALID(instHbm_AXI_22_AWVALID),
    .AXI_22_AWREADY(instHbm_AXI_22_AWREADY),
    .AXI_22_WDATA(instHbm_AXI_22_WDATA),
    .AXI_22_WLAST(instHbm_AXI_22_WLAST),
    .AXI_22_WSTRB(instHbm_AXI_22_WSTRB),
    .AXI_22_WVALID(instHbm_AXI_22_WVALID),
    .AXI_22_WREADY(instHbm_AXI_22_WREADY),
    .AXI_22_RDATA(instHbm_AXI_22_RDATA),
    .AXI_22_RID(instHbm_AXI_22_RID),
    .AXI_22_RLAST(instHbm_AXI_22_RLAST),
    .AXI_22_RRESP(instHbm_AXI_22_RRESP),
    .AXI_22_RVALID(instHbm_AXI_22_RVALID),
    .AXI_22_RREADY(instHbm_AXI_22_RREADY),
    .AXI_22_BID(instHbm_AXI_22_BID),
    .AXI_22_BRESP(instHbm_AXI_22_BRESP),
    .AXI_22_BVALID(instHbm_AXI_22_BVALID),
    .AXI_22_BREADY(instHbm_AXI_22_BREADY),
    .AXI_22_WDATA_PARITY(instHbm_AXI_22_WDATA_PARITY),
    .AXI_22_RDATA_PARITY(instHbm_AXI_22_RDATA_PARITY),
    .AXI_23_ACLK(instHbm_AXI_23_ACLK),
    .AXI_23_ARESET_N(instHbm_AXI_23_ARESET_N),
    .AXI_23_ARADDR(instHbm_AXI_23_ARADDR),
    .AXI_23_ARBURST(instHbm_AXI_23_ARBURST),
    .AXI_23_ARID(instHbm_AXI_23_ARID),
    .AXI_23_ARLEN(instHbm_AXI_23_ARLEN),
    .AXI_23_ARSIZE(instHbm_AXI_23_ARSIZE),
    .AXI_23_ARVALID(instHbm_AXI_23_ARVALID),
    .AXI_23_ARREADY(instHbm_AXI_23_ARREADY),
    .AXI_23_AWADDR(instHbm_AXI_23_AWADDR),
    .AXI_23_AWBURST(instHbm_AXI_23_AWBURST),
    .AXI_23_AWID(instHbm_AXI_23_AWID),
    .AXI_23_AWLEN(instHbm_AXI_23_AWLEN),
    .AXI_23_AWSIZE(instHbm_AXI_23_AWSIZE),
    .AXI_23_AWVALID(instHbm_AXI_23_AWVALID),
    .AXI_23_AWREADY(instHbm_AXI_23_AWREADY),
    .AXI_23_WDATA(instHbm_AXI_23_WDATA),
    .AXI_23_WLAST(instHbm_AXI_23_WLAST),
    .AXI_23_WSTRB(instHbm_AXI_23_WSTRB),
    .AXI_23_WVALID(instHbm_AXI_23_WVALID),
    .AXI_23_WREADY(instHbm_AXI_23_WREADY),
    .AXI_23_RDATA(instHbm_AXI_23_RDATA),
    .AXI_23_RID(instHbm_AXI_23_RID),
    .AXI_23_RLAST(instHbm_AXI_23_RLAST),
    .AXI_23_RRESP(instHbm_AXI_23_RRESP),
    .AXI_23_RVALID(instHbm_AXI_23_RVALID),
    .AXI_23_RREADY(instHbm_AXI_23_RREADY),
    .AXI_23_BID(instHbm_AXI_23_BID),
    .AXI_23_BRESP(instHbm_AXI_23_BRESP),
    .AXI_23_BVALID(instHbm_AXI_23_BVALID),
    .AXI_23_BREADY(instHbm_AXI_23_BREADY),
    .AXI_23_WDATA_PARITY(instHbm_AXI_23_WDATA_PARITY),
    .AXI_23_RDATA_PARITY(instHbm_AXI_23_RDATA_PARITY),
    .AXI_24_ACLK(instHbm_AXI_24_ACLK),
    .AXI_24_ARESET_N(instHbm_AXI_24_ARESET_N),
    .AXI_24_ARADDR(instHbm_AXI_24_ARADDR),
    .AXI_24_ARBURST(instHbm_AXI_24_ARBURST),
    .AXI_24_ARID(instHbm_AXI_24_ARID),
    .AXI_24_ARLEN(instHbm_AXI_24_ARLEN),
    .AXI_24_ARSIZE(instHbm_AXI_24_ARSIZE),
    .AXI_24_ARVALID(instHbm_AXI_24_ARVALID),
    .AXI_24_ARREADY(instHbm_AXI_24_ARREADY),
    .AXI_24_AWADDR(instHbm_AXI_24_AWADDR),
    .AXI_24_AWBURST(instHbm_AXI_24_AWBURST),
    .AXI_24_AWID(instHbm_AXI_24_AWID),
    .AXI_24_AWLEN(instHbm_AXI_24_AWLEN),
    .AXI_24_AWSIZE(instHbm_AXI_24_AWSIZE),
    .AXI_24_AWVALID(instHbm_AXI_24_AWVALID),
    .AXI_24_AWREADY(instHbm_AXI_24_AWREADY),
    .AXI_24_WDATA(instHbm_AXI_24_WDATA),
    .AXI_24_WLAST(instHbm_AXI_24_WLAST),
    .AXI_24_WSTRB(instHbm_AXI_24_WSTRB),
    .AXI_24_WVALID(instHbm_AXI_24_WVALID),
    .AXI_24_WREADY(instHbm_AXI_24_WREADY),
    .AXI_24_RDATA(instHbm_AXI_24_RDATA),
    .AXI_24_RID(instHbm_AXI_24_RID),
    .AXI_24_RLAST(instHbm_AXI_24_RLAST),
    .AXI_24_RRESP(instHbm_AXI_24_RRESP),
    .AXI_24_RVALID(instHbm_AXI_24_RVALID),
    .AXI_24_RREADY(instHbm_AXI_24_RREADY),
    .AXI_24_BID(instHbm_AXI_24_BID),
    .AXI_24_BRESP(instHbm_AXI_24_BRESP),
    .AXI_24_BVALID(instHbm_AXI_24_BVALID),
    .AXI_24_BREADY(instHbm_AXI_24_BREADY),
    .AXI_24_WDATA_PARITY(instHbm_AXI_24_WDATA_PARITY),
    .AXI_24_RDATA_PARITY(instHbm_AXI_24_RDATA_PARITY),
    .AXI_25_ACLK(instHbm_AXI_25_ACLK),
    .AXI_25_ARESET_N(instHbm_AXI_25_ARESET_N),
    .AXI_25_ARADDR(instHbm_AXI_25_ARADDR),
    .AXI_25_ARBURST(instHbm_AXI_25_ARBURST),
    .AXI_25_ARID(instHbm_AXI_25_ARID),
    .AXI_25_ARLEN(instHbm_AXI_25_ARLEN),
    .AXI_25_ARSIZE(instHbm_AXI_25_ARSIZE),
    .AXI_25_ARVALID(instHbm_AXI_25_ARVALID),
    .AXI_25_ARREADY(instHbm_AXI_25_ARREADY),
    .AXI_25_AWADDR(instHbm_AXI_25_AWADDR),
    .AXI_25_AWBURST(instHbm_AXI_25_AWBURST),
    .AXI_25_AWID(instHbm_AXI_25_AWID),
    .AXI_25_AWLEN(instHbm_AXI_25_AWLEN),
    .AXI_25_AWSIZE(instHbm_AXI_25_AWSIZE),
    .AXI_25_AWVALID(instHbm_AXI_25_AWVALID),
    .AXI_25_AWREADY(instHbm_AXI_25_AWREADY),
    .AXI_25_WDATA(instHbm_AXI_25_WDATA),
    .AXI_25_WLAST(instHbm_AXI_25_WLAST),
    .AXI_25_WSTRB(instHbm_AXI_25_WSTRB),
    .AXI_25_WVALID(instHbm_AXI_25_WVALID),
    .AXI_25_WREADY(instHbm_AXI_25_WREADY),
    .AXI_25_RDATA(instHbm_AXI_25_RDATA),
    .AXI_25_RID(instHbm_AXI_25_RID),
    .AXI_25_RLAST(instHbm_AXI_25_RLAST),
    .AXI_25_RRESP(instHbm_AXI_25_RRESP),
    .AXI_25_RVALID(instHbm_AXI_25_RVALID),
    .AXI_25_RREADY(instHbm_AXI_25_RREADY),
    .AXI_25_BID(instHbm_AXI_25_BID),
    .AXI_25_BRESP(instHbm_AXI_25_BRESP),
    .AXI_25_BVALID(instHbm_AXI_25_BVALID),
    .AXI_25_BREADY(instHbm_AXI_25_BREADY),
    .AXI_25_WDATA_PARITY(instHbm_AXI_25_WDATA_PARITY),
    .AXI_25_RDATA_PARITY(instHbm_AXI_25_RDATA_PARITY),
    .AXI_26_ACLK(instHbm_AXI_26_ACLK),
    .AXI_26_ARESET_N(instHbm_AXI_26_ARESET_N),
    .AXI_26_ARADDR(instHbm_AXI_26_ARADDR),
    .AXI_26_ARBURST(instHbm_AXI_26_ARBURST),
    .AXI_26_ARID(instHbm_AXI_26_ARID),
    .AXI_26_ARLEN(instHbm_AXI_26_ARLEN),
    .AXI_26_ARSIZE(instHbm_AXI_26_ARSIZE),
    .AXI_26_ARVALID(instHbm_AXI_26_ARVALID),
    .AXI_26_ARREADY(instHbm_AXI_26_ARREADY),
    .AXI_26_AWADDR(instHbm_AXI_26_AWADDR),
    .AXI_26_AWBURST(instHbm_AXI_26_AWBURST),
    .AXI_26_AWID(instHbm_AXI_26_AWID),
    .AXI_26_AWLEN(instHbm_AXI_26_AWLEN),
    .AXI_26_AWSIZE(instHbm_AXI_26_AWSIZE),
    .AXI_26_AWVALID(instHbm_AXI_26_AWVALID),
    .AXI_26_AWREADY(instHbm_AXI_26_AWREADY),
    .AXI_26_WDATA(instHbm_AXI_26_WDATA),
    .AXI_26_WLAST(instHbm_AXI_26_WLAST),
    .AXI_26_WSTRB(instHbm_AXI_26_WSTRB),
    .AXI_26_WVALID(instHbm_AXI_26_WVALID),
    .AXI_26_WREADY(instHbm_AXI_26_WREADY),
    .AXI_26_RDATA(instHbm_AXI_26_RDATA),
    .AXI_26_RID(instHbm_AXI_26_RID),
    .AXI_26_RLAST(instHbm_AXI_26_RLAST),
    .AXI_26_RRESP(instHbm_AXI_26_RRESP),
    .AXI_26_RVALID(instHbm_AXI_26_RVALID),
    .AXI_26_RREADY(instHbm_AXI_26_RREADY),
    .AXI_26_BID(instHbm_AXI_26_BID),
    .AXI_26_BRESP(instHbm_AXI_26_BRESP),
    .AXI_26_BVALID(instHbm_AXI_26_BVALID),
    .AXI_26_BREADY(instHbm_AXI_26_BREADY),
    .AXI_26_WDATA_PARITY(instHbm_AXI_26_WDATA_PARITY),
    .AXI_26_RDATA_PARITY(instHbm_AXI_26_RDATA_PARITY),
    .AXI_27_ACLK(instHbm_AXI_27_ACLK),
    .AXI_27_ARESET_N(instHbm_AXI_27_ARESET_N),
    .AXI_27_ARADDR(instHbm_AXI_27_ARADDR),
    .AXI_27_ARBURST(instHbm_AXI_27_ARBURST),
    .AXI_27_ARID(instHbm_AXI_27_ARID),
    .AXI_27_ARLEN(instHbm_AXI_27_ARLEN),
    .AXI_27_ARSIZE(instHbm_AXI_27_ARSIZE),
    .AXI_27_ARVALID(instHbm_AXI_27_ARVALID),
    .AXI_27_ARREADY(instHbm_AXI_27_ARREADY),
    .AXI_27_AWADDR(instHbm_AXI_27_AWADDR),
    .AXI_27_AWBURST(instHbm_AXI_27_AWBURST),
    .AXI_27_AWID(instHbm_AXI_27_AWID),
    .AXI_27_AWLEN(instHbm_AXI_27_AWLEN),
    .AXI_27_AWSIZE(instHbm_AXI_27_AWSIZE),
    .AXI_27_AWVALID(instHbm_AXI_27_AWVALID),
    .AXI_27_AWREADY(instHbm_AXI_27_AWREADY),
    .AXI_27_WDATA(instHbm_AXI_27_WDATA),
    .AXI_27_WLAST(instHbm_AXI_27_WLAST),
    .AXI_27_WSTRB(instHbm_AXI_27_WSTRB),
    .AXI_27_WVALID(instHbm_AXI_27_WVALID),
    .AXI_27_WREADY(instHbm_AXI_27_WREADY),
    .AXI_27_RDATA(instHbm_AXI_27_RDATA),
    .AXI_27_RID(instHbm_AXI_27_RID),
    .AXI_27_RLAST(instHbm_AXI_27_RLAST),
    .AXI_27_RRESP(instHbm_AXI_27_RRESP),
    .AXI_27_RVALID(instHbm_AXI_27_RVALID),
    .AXI_27_RREADY(instHbm_AXI_27_RREADY),
    .AXI_27_BID(instHbm_AXI_27_BID),
    .AXI_27_BRESP(instHbm_AXI_27_BRESP),
    .AXI_27_BVALID(instHbm_AXI_27_BVALID),
    .AXI_27_BREADY(instHbm_AXI_27_BREADY),
    .AXI_27_WDATA_PARITY(instHbm_AXI_27_WDATA_PARITY),
    .AXI_27_RDATA_PARITY(instHbm_AXI_27_RDATA_PARITY),
    .AXI_28_ACLK(instHbm_AXI_28_ACLK),
    .AXI_28_ARESET_N(instHbm_AXI_28_ARESET_N),
    .AXI_28_ARADDR(instHbm_AXI_28_ARADDR),
    .AXI_28_ARBURST(instHbm_AXI_28_ARBURST),
    .AXI_28_ARID(instHbm_AXI_28_ARID),
    .AXI_28_ARLEN(instHbm_AXI_28_ARLEN),
    .AXI_28_ARSIZE(instHbm_AXI_28_ARSIZE),
    .AXI_28_ARVALID(instHbm_AXI_28_ARVALID),
    .AXI_28_ARREADY(instHbm_AXI_28_ARREADY),
    .AXI_28_AWADDR(instHbm_AXI_28_AWADDR),
    .AXI_28_AWBURST(instHbm_AXI_28_AWBURST),
    .AXI_28_AWID(instHbm_AXI_28_AWID),
    .AXI_28_AWLEN(instHbm_AXI_28_AWLEN),
    .AXI_28_AWSIZE(instHbm_AXI_28_AWSIZE),
    .AXI_28_AWVALID(instHbm_AXI_28_AWVALID),
    .AXI_28_AWREADY(instHbm_AXI_28_AWREADY),
    .AXI_28_WDATA(instHbm_AXI_28_WDATA),
    .AXI_28_WLAST(instHbm_AXI_28_WLAST),
    .AXI_28_WSTRB(instHbm_AXI_28_WSTRB),
    .AXI_28_WVALID(instHbm_AXI_28_WVALID),
    .AXI_28_WREADY(instHbm_AXI_28_WREADY),
    .AXI_28_RDATA(instHbm_AXI_28_RDATA),
    .AXI_28_RID(instHbm_AXI_28_RID),
    .AXI_28_RLAST(instHbm_AXI_28_RLAST),
    .AXI_28_RRESP(instHbm_AXI_28_RRESP),
    .AXI_28_RVALID(instHbm_AXI_28_RVALID),
    .AXI_28_RREADY(instHbm_AXI_28_RREADY),
    .AXI_28_BID(instHbm_AXI_28_BID),
    .AXI_28_BRESP(instHbm_AXI_28_BRESP),
    .AXI_28_BVALID(instHbm_AXI_28_BVALID),
    .AXI_28_BREADY(instHbm_AXI_28_BREADY),
    .AXI_28_WDATA_PARITY(instHbm_AXI_28_WDATA_PARITY),
    .AXI_28_RDATA_PARITY(instHbm_AXI_28_RDATA_PARITY),
    .AXI_29_ACLK(instHbm_AXI_29_ACLK),
    .AXI_29_ARESET_N(instHbm_AXI_29_ARESET_N),
    .AXI_29_ARADDR(instHbm_AXI_29_ARADDR),
    .AXI_29_ARBURST(instHbm_AXI_29_ARBURST),
    .AXI_29_ARID(instHbm_AXI_29_ARID),
    .AXI_29_ARLEN(instHbm_AXI_29_ARLEN),
    .AXI_29_ARSIZE(instHbm_AXI_29_ARSIZE),
    .AXI_29_ARVALID(instHbm_AXI_29_ARVALID),
    .AXI_29_ARREADY(instHbm_AXI_29_ARREADY),
    .AXI_29_AWADDR(instHbm_AXI_29_AWADDR),
    .AXI_29_AWBURST(instHbm_AXI_29_AWBURST),
    .AXI_29_AWID(instHbm_AXI_29_AWID),
    .AXI_29_AWLEN(instHbm_AXI_29_AWLEN),
    .AXI_29_AWSIZE(instHbm_AXI_29_AWSIZE),
    .AXI_29_AWVALID(instHbm_AXI_29_AWVALID),
    .AXI_29_AWREADY(instHbm_AXI_29_AWREADY),
    .AXI_29_WDATA(instHbm_AXI_29_WDATA),
    .AXI_29_WLAST(instHbm_AXI_29_WLAST),
    .AXI_29_WSTRB(instHbm_AXI_29_WSTRB),
    .AXI_29_WVALID(instHbm_AXI_29_WVALID),
    .AXI_29_WREADY(instHbm_AXI_29_WREADY),
    .AXI_29_RDATA(instHbm_AXI_29_RDATA),
    .AXI_29_RID(instHbm_AXI_29_RID),
    .AXI_29_RLAST(instHbm_AXI_29_RLAST),
    .AXI_29_RRESP(instHbm_AXI_29_RRESP),
    .AXI_29_RVALID(instHbm_AXI_29_RVALID),
    .AXI_29_RREADY(instHbm_AXI_29_RREADY),
    .AXI_29_BID(instHbm_AXI_29_BID),
    .AXI_29_BRESP(instHbm_AXI_29_BRESP),
    .AXI_29_BVALID(instHbm_AXI_29_BVALID),
    .AXI_29_BREADY(instHbm_AXI_29_BREADY),
    .AXI_29_WDATA_PARITY(instHbm_AXI_29_WDATA_PARITY),
    .AXI_29_RDATA_PARITY(instHbm_AXI_29_RDATA_PARITY),
    .AXI_30_ACLK(instHbm_AXI_30_ACLK),
    .AXI_30_ARESET_N(instHbm_AXI_30_ARESET_N),
    .AXI_30_ARADDR(instHbm_AXI_30_ARADDR),
    .AXI_30_ARBURST(instHbm_AXI_30_ARBURST),
    .AXI_30_ARID(instHbm_AXI_30_ARID),
    .AXI_30_ARLEN(instHbm_AXI_30_ARLEN),
    .AXI_30_ARSIZE(instHbm_AXI_30_ARSIZE),
    .AXI_30_ARVALID(instHbm_AXI_30_ARVALID),
    .AXI_30_ARREADY(instHbm_AXI_30_ARREADY),
    .AXI_30_AWADDR(instHbm_AXI_30_AWADDR),
    .AXI_30_AWBURST(instHbm_AXI_30_AWBURST),
    .AXI_30_AWID(instHbm_AXI_30_AWID),
    .AXI_30_AWLEN(instHbm_AXI_30_AWLEN),
    .AXI_30_AWSIZE(instHbm_AXI_30_AWSIZE),
    .AXI_30_AWVALID(instHbm_AXI_30_AWVALID),
    .AXI_30_AWREADY(instHbm_AXI_30_AWREADY),
    .AXI_30_WDATA(instHbm_AXI_30_WDATA),
    .AXI_30_WLAST(instHbm_AXI_30_WLAST),
    .AXI_30_WSTRB(instHbm_AXI_30_WSTRB),
    .AXI_30_WVALID(instHbm_AXI_30_WVALID),
    .AXI_30_WREADY(instHbm_AXI_30_WREADY),
    .AXI_30_RDATA(instHbm_AXI_30_RDATA),
    .AXI_30_RID(instHbm_AXI_30_RID),
    .AXI_30_RLAST(instHbm_AXI_30_RLAST),
    .AXI_30_RRESP(instHbm_AXI_30_RRESP),
    .AXI_30_RVALID(instHbm_AXI_30_RVALID),
    .AXI_30_RREADY(instHbm_AXI_30_RREADY),
    .AXI_30_BID(instHbm_AXI_30_BID),
    .AXI_30_BRESP(instHbm_AXI_30_BRESP),
    .AXI_30_BVALID(instHbm_AXI_30_BVALID),
    .AXI_30_BREADY(instHbm_AXI_30_BREADY),
    .AXI_30_WDATA_PARITY(instHbm_AXI_30_WDATA_PARITY),
    .AXI_30_RDATA_PARITY(instHbm_AXI_30_RDATA_PARITY),
    .AXI_31_ACLK(instHbm_AXI_31_ACLK),
    .AXI_31_ARESET_N(instHbm_AXI_31_ARESET_N),
    .AXI_31_ARADDR(instHbm_AXI_31_ARADDR),
    .AXI_31_ARBURST(instHbm_AXI_31_ARBURST),
    .AXI_31_ARID(instHbm_AXI_31_ARID),
    .AXI_31_ARLEN(instHbm_AXI_31_ARLEN),
    .AXI_31_ARSIZE(instHbm_AXI_31_ARSIZE),
    .AXI_31_ARVALID(instHbm_AXI_31_ARVALID),
    .AXI_31_ARREADY(instHbm_AXI_31_ARREADY),
    .AXI_31_AWADDR(instHbm_AXI_31_AWADDR),
    .AXI_31_AWBURST(instHbm_AXI_31_AWBURST),
    .AXI_31_AWID(instHbm_AXI_31_AWID),
    .AXI_31_AWLEN(instHbm_AXI_31_AWLEN),
    .AXI_31_AWSIZE(instHbm_AXI_31_AWSIZE),
    .AXI_31_AWVALID(instHbm_AXI_31_AWVALID),
    .AXI_31_AWREADY(instHbm_AXI_31_AWREADY),
    .AXI_31_WDATA(instHbm_AXI_31_WDATA),
    .AXI_31_WLAST(instHbm_AXI_31_WLAST),
    .AXI_31_WSTRB(instHbm_AXI_31_WSTRB),
    .AXI_31_WVALID(instHbm_AXI_31_WVALID),
    .AXI_31_WREADY(instHbm_AXI_31_WREADY),
    .AXI_31_RDATA(instHbm_AXI_31_RDATA),
    .AXI_31_RID(instHbm_AXI_31_RID),
    .AXI_31_RLAST(instHbm_AXI_31_RLAST),
    .AXI_31_RRESP(instHbm_AXI_31_RRESP),
    .AXI_31_RVALID(instHbm_AXI_31_RVALID),
    .AXI_31_RREADY(instHbm_AXI_31_RREADY),
    .AXI_31_BID(instHbm_AXI_31_BID),
    .AXI_31_BRESP(instHbm_AXI_31_BRESP),
    .AXI_31_BVALID(instHbm_AXI_31_BVALID),
    .AXI_31_BREADY(instHbm_AXI_31_BREADY),
    .AXI_31_WDATA_PARITY(instHbm_AXI_31_WDATA_PARITY),
    .AXI_31_RDATA_PARITY(instHbm_AXI_31_RDATA_PARITY),
    .APB_0_PWDATA(instHbm_APB_0_PWDATA),
    .APB_0_PADDR(instHbm_APB_0_PADDR),
    .APB_0_PCLK(instHbm_APB_0_PCLK),
    .APB_0_PENABLE(instHbm_APB_0_PENABLE),
    .APB_0_PRESET_N(instHbm_APB_0_PRESET_N),
    .APB_0_PSEL(instHbm_APB_0_PSEL),
    .APB_0_PWRITE(instHbm_APB_0_PWRITE),
    .APB_0_PRDATA(instHbm_APB_0_PRDATA),
    .APB_0_PREADY(instHbm_APB_0_PREADY),
    .APB_0_PSLVERR(instHbm_APB_0_PSLVERR),
    .APB_1_PWDATA(instHbm_APB_1_PWDATA),
    .APB_1_PADDR(instHbm_APB_1_PADDR),
    .APB_1_PCLK(instHbm_APB_1_PCLK),
    .APB_1_PENABLE(instHbm_APB_1_PENABLE),
    .APB_1_PRESET_N(instHbm_APB_1_PRESET_N),
    .APB_1_PSEL(instHbm_APB_1_PSEL),
    .APB_1_PWRITE(instHbm_APB_1_PWRITE),
    .APB_1_PRDATA(instHbm_APB_1_PRDATA),
    .APB_1_PREADY(instHbm_APB_1_PREADY),
    .APB_1_PSLVERR(instHbm_APB_1_PSLVERR),
    .DRAM_0_STAT_CATTRIP(instHbm_DRAM_0_STAT_CATTRIP),
    .DRAM_0_STAT_TEMP(instHbm_DRAM_0_STAT_TEMP),
    .DRAM_1_STAT_CATTRIP(instHbm_DRAM_1_STAT_CATTRIP),
    .DRAM_1_STAT_TEMP(instHbm_DRAM_1_STAT_TEMP),
    .apb_complete_0(instHbm_apb_complete_0),
    .apb_complete_1(instHbm_apb_complete_1)
  );
  assign mmcmGlbl_io_CLKIN1 = clock; // @[HBMDriver.scala 60:33]
  assign apb0Pclk_pad_I = mmcmGlbl_io_CLKOUT0; // @[Buf.scala 34:26]
  assign apb0Pclk_pad_1_I = apb0Pclk_pad_O; // @[HBMDriver.scala 63:63]
  assign apb0Pclk_pad_2_I = apb0Pclk_pad_1_O; // @[HBMDriver.scala 63:71]
  assign axiAclkIn0_pad_I = mmcmGlbl_io_CLKOUT1; // @[Buf.scala 34:26]
  assign hbmRefClk0_pad_I = mmcmGlbl_io_CLKOUT2; // @[Buf.scala 34:26]
  assign apb1Pclk_pad_I = mmcmGlbl_io_CLKOUT3; // @[Buf.scala 34:26]
  assign apb1Pclk_pad_1_I = apb1Pclk_pad_O; // @[HBMDriver.scala 66:63]
  assign apb1Pclk_pad_2_I = apb1Pclk_pad_1_O; // @[HBMDriver.scala 66:71]
  assign axiAclkIn1_pad_I = mmcmGlbl_io_CLKOUT4; // @[Buf.scala 34:26]
  assign hbmRefClk1_pad_I = mmcmGlbl_io_CLKOUT5; // @[Buf.scala 34:26]
  assign mmcmAxi_io_CLKIN1 = axiAclkIn0_pad_O; // @[HBMDriver.scala 84:33]
  assign mmcmAxi_io_RST = ~mmcmGlbl_io_LOCKED; // @[HBMDriver.scala 85:36]
  assign axiAclk_pad_I = mmcmAxi_io_CLKOUT0; // @[Buf.scala 34:26]
  assign instHbm_HBM_REF_CLK_0 = hbmRefClk0_pad_O; // @[HBMDriver.scala 103:41]
  assign instHbm_HBM_REF_CLK_1 = hbmRefClk1_pad_O; // @[HBMDriver.scala 104:41]
  assign instHbm_AXI_00_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 115:49]
  assign instHbm_AXI_00_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 116:49]
  assign instHbm_AXI_00_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_00_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 146:49]
  assign instHbm_AXI_01_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 149:49]
  assign instHbm_AXI_01_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 150:49]
  assign instHbm_AXI_01_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_01_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 180:49]
  assign instHbm_AXI_02_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 183:49]
  assign instHbm_AXI_02_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 184:49]
  assign instHbm_AXI_02_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_02_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 214:49]
  assign instHbm_AXI_03_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 217:49]
  assign instHbm_AXI_03_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 218:49]
  assign instHbm_AXI_03_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_03_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 248:49]
  assign instHbm_AXI_04_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 251:49]
  assign instHbm_AXI_04_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 252:49]
  assign instHbm_AXI_04_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_04_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 282:49]
  assign instHbm_AXI_05_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 285:49]
  assign instHbm_AXI_05_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 286:49]
  assign instHbm_AXI_05_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_05_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 316:49]
  assign instHbm_AXI_06_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 319:49]
  assign instHbm_AXI_06_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 320:49]
  assign instHbm_AXI_06_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_06_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 350:49]
  assign instHbm_AXI_07_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 353:49]
  assign instHbm_AXI_07_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 354:49]
  assign instHbm_AXI_07_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_07_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 384:49]
  assign instHbm_AXI_08_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 387:49]
  assign instHbm_AXI_08_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 388:49]
  assign instHbm_AXI_08_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_08_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 418:49]
  assign instHbm_AXI_09_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 421:49]
  assign instHbm_AXI_09_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 422:49]
  assign instHbm_AXI_09_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_09_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 452:49]
  assign instHbm_AXI_10_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 455:49]
  assign instHbm_AXI_10_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 456:49]
  assign instHbm_AXI_10_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_10_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 486:49]
  assign instHbm_AXI_11_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 489:49]
  assign instHbm_AXI_11_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 490:49]
  assign instHbm_AXI_11_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_11_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 520:49]
  assign instHbm_AXI_12_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 523:49]
  assign instHbm_AXI_12_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 524:49]
  assign instHbm_AXI_12_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_12_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 554:49]
  assign instHbm_AXI_13_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 557:49]
  assign instHbm_AXI_13_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 558:49]
  assign instHbm_AXI_13_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_13_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 588:49]
  assign instHbm_AXI_14_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 591:49]
  assign instHbm_AXI_14_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 592:49]
  assign instHbm_AXI_14_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_14_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 622:49]
  assign instHbm_AXI_15_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 625:49]
  assign instHbm_AXI_15_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 626:49]
  assign instHbm_AXI_15_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_15_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 656:49]
  assign instHbm_AXI_16_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 667:49]
  assign instHbm_AXI_16_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 668:49]
  assign instHbm_AXI_16_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_16_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 698:49]
  assign instHbm_AXI_17_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 701:49]
  assign instHbm_AXI_17_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 702:49]
  assign instHbm_AXI_17_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_17_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 732:49]
  assign instHbm_AXI_18_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 735:49]
  assign instHbm_AXI_18_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 736:49]
  assign instHbm_AXI_18_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_18_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 766:49]
  assign instHbm_AXI_19_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 769:49]
  assign instHbm_AXI_19_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 770:49]
  assign instHbm_AXI_19_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_19_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 800:49]
  assign instHbm_AXI_20_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 803:49]
  assign instHbm_AXI_20_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 804:49]
  assign instHbm_AXI_20_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_20_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 834:49]
  assign instHbm_AXI_21_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 837:49]
  assign instHbm_AXI_21_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 838:49]
  assign instHbm_AXI_21_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_21_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 868:49]
  assign instHbm_AXI_22_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 871:49]
  assign instHbm_AXI_22_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 872:49]
  assign instHbm_AXI_22_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_22_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 902:49]
  assign instHbm_AXI_23_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 905:49]
  assign instHbm_AXI_23_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 906:49]
  assign instHbm_AXI_23_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_23_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 936:49]
  assign instHbm_AXI_24_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 939:49]
  assign instHbm_AXI_24_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 940:49]
  assign instHbm_AXI_24_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_24_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 970:49]
  assign instHbm_AXI_25_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 973:49]
  assign instHbm_AXI_25_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 974:49]
  assign instHbm_AXI_25_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_25_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 1004:49]
  assign instHbm_AXI_26_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 1007:49]
  assign instHbm_AXI_26_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 1008:49]
  assign instHbm_AXI_26_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_26_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 1038:49]
  assign instHbm_AXI_27_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 1041:49]
  assign instHbm_AXI_27_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 1042:49]
  assign instHbm_AXI_27_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_27_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 1072:49]
  assign instHbm_AXI_28_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 1075:49]
  assign instHbm_AXI_28_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 1076:49]
  assign instHbm_AXI_28_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_28_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 1106:49]
  assign instHbm_AXI_29_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 1109:49]
  assign instHbm_AXI_29_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 1110:49]
  assign instHbm_AXI_29_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_29_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 1140:49]
  assign instHbm_AXI_30_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 1143:49]
  assign instHbm_AXI_30_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 1144:49]
  assign instHbm_AXI_30_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_30_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 1174:49]
  assign instHbm_AXI_31_ACLK = axiAclk_pad_O; // @[HBMDriver.scala 1177:49]
  assign instHbm_AXI_31_ARESET_N = mmcmAxi_io_LOCKED; // @[HBMDriver.scala 1178:49]
  assign instHbm_AXI_31_ARADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_ARBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_ARID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_ARLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_ARSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_ARVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_AWADDR = 33'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_AWBURST = 2'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_AWID = 6'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_AWLEN = 4'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_AWSIZE = 3'h5; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_AWVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_WDATA = 256'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_WLAST = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_WSTRB = 32'hffffffff; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_WVALID = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_RREADY = 1'h0; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_BREADY = 1'h1; // @[HBMDriver.scala 32:32 HBMDriver.scala 42:39]
  assign instHbm_AXI_31_WDATA_PARITY = 32'h0; // @[HBMDriver.scala 1208:49]
  assign instHbm_APB_0_PWDATA = 32'h0; // @[HBMDriver.scala 1214:36]
  assign instHbm_APB_0_PADDR = 22'h0; // @[HBMDriver.scala 1215:36]
  assign instHbm_APB_0_PCLK = apb0Pclk_pad_2_O; // @[HBMDriver.scala 1216:36]
  assign instHbm_APB_0_PENABLE = 1'h0; // @[HBMDriver.scala 1217:36]
  assign instHbm_APB_0_PRESET_N = mmcmGlbl_io_LOCKED; // @[HBMDriver.scala 1218:36]
  assign instHbm_APB_0_PSEL = 1'h0; // @[HBMDriver.scala 1219:36]
  assign instHbm_APB_0_PWRITE = 1'h0; // @[HBMDriver.scala 1220:36]
  assign instHbm_APB_1_PWDATA = 32'h0; // @[HBMDriver.scala 1225:36]
  assign instHbm_APB_1_PADDR = 22'h0; // @[HBMDriver.scala 1226:36]
  assign instHbm_APB_1_PCLK = apb1Pclk_pad_2_O; // @[HBMDriver.scala 1227:36]
  assign instHbm_APB_1_PENABLE = 1'h0; // @[HBMDriver.scala 1228:36]
  assign instHbm_APB_1_PRESET_N = mmcmGlbl_io_LOCKED; // @[HBMDriver.scala 1229:36]
  assign instHbm_APB_1_PSEL = 1'h0; // @[HBMDriver.scala 1230:36]
  assign instHbm_APB_1_PWRITE = 1'h0; // @[HBMDriver.scala 1231:36]
endmodule
module AlveoDynamicTop(
  input          clock,
  input          reset,
  input          io_sysClk,
  output [3:0]   io_cmacPin_tx_p,
  output [3:0]   io_cmacPin_tx_n,
  input  [3:0]   io_cmacPin_rx_p,
  input  [3:0]   io_cmacPin_rx_n,
  input          io_cmacPin_gt_clk_p,
  input          io_cmacPin_gt_clk_n,
  input          io_qdma_axi_aclk,
  input          io_qdma_axi_aresetn,
  input  [3:0]   io_qdma_m_axib_awid,
  input  [63:0]  io_qdma_m_axib_awaddr,
  input  [7:0]   io_qdma_m_axib_awlen,
  input  [2:0]   io_qdma_m_axib_awsize,
  input  [1:0]   io_qdma_m_axib_awburst,
  input  [2:0]   io_qdma_m_axib_awprot,
  input          io_qdma_m_axib_awlock,
  input  [3:0]   io_qdma_m_axib_awcache,
  input          io_qdma_m_axib_awvalid,
  output         io_qdma_m_axib_awready,
  input  [511:0] io_qdma_m_axib_wdata,
  input  [63:0]  io_qdma_m_axib_wstrb,
  input          io_qdma_m_axib_wlast,
  input          io_qdma_m_axib_wvalid,
  output         io_qdma_m_axib_wready,
  output [3:0]   io_qdma_m_axib_bid,
  output [1:0]   io_qdma_m_axib_bresp,
  output         io_qdma_m_axib_bvalid,
  input          io_qdma_m_axib_bready,
  input  [3:0]   io_qdma_m_axib_arid,
  input  [63:0]  io_qdma_m_axib_araddr,
  input  [7:0]   io_qdma_m_axib_arlen,
  input  [2:0]   io_qdma_m_axib_arsize,
  input  [1:0]   io_qdma_m_axib_arburst,
  input  [2:0]   io_qdma_m_axib_arprot,
  input          io_qdma_m_axib_arlock,
  input  [3:0]   io_qdma_m_axib_arcache,
  input          io_qdma_m_axib_arvalid,
  output         io_qdma_m_axib_arready,
  output [3:0]   io_qdma_m_axib_rid,
  output [511:0] io_qdma_m_axib_rdata,
  output [1:0]   io_qdma_m_axib_rresp,
  output         io_qdma_m_axib_rlast,
  output         io_qdma_m_axib_rvalid,
  input          io_qdma_m_axib_rready,
  input  [31:0]  io_qdma_m_axil_awaddr,
  input          io_qdma_m_axil_awvalid,
  output         io_qdma_m_axil_awready,
  input  [31:0]  io_qdma_m_axil_wdata,
  input  [3:0]   io_qdma_m_axil_wstrb,
  input          io_qdma_m_axil_wvalid,
  output         io_qdma_m_axil_wready,
  output [1:0]   io_qdma_m_axil_bresp,
  output         io_qdma_m_axil_bvalid,
  input          io_qdma_m_axil_bready,
  input  [31:0]  io_qdma_m_axil_araddr,
  input          io_qdma_m_axil_arvalid,
  output         io_qdma_m_axil_arready,
  output [31:0]  io_qdma_m_axil_rdata,
  output [1:0]   io_qdma_m_axil_rresp,
  output         io_qdma_m_axil_rvalid,
  input          io_qdma_m_axil_rready,
  output         io_qdma_soft_reset_n,
  output [63:0]  io_qdma_h2c_byp_in_st_addr,
  output [31:0]  io_qdma_h2c_byp_in_st_len,
  output         io_qdma_h2c_byp_in_st_eop,
  output         io_qdma_h2c_byp_in_st_sop,
  output         io_qdma_h2c_byp_in_st_mrkr_req,
  output         io_qdma_h2c_byp_in_st_sdi,
  output [10:0]  io_qdma_h2c_byp_in_st_qid,
  output         io_qdma_h2c_byp_in_st_error,
  output [7:0]   io_qdma_h2c_byp_in_st_func,
  output [15:0]  io_qdma_h2c_byp_in_st_cidx,
  output [2:0]   io_qdma_h2c_byp_in_st_port_id,
  output         io_qdma_h2c_byp_in_st_no_dma,
  output         io_qdma_h2c_byp_in_st_vld,
  input          io_qdma_h2c_byp_in_st_rdy,
  output [63:0]  io_qdma_c2h_byp_in_st_csh_addr,
  output [10:0]  io_qdma_c2h_byp_in_st_csh_qid,
  output         io_qdma_c2h_byp_in_st_csh_error,
  output [7:0]   io_qdma_c2h_byp_in_st_csh_func,
  output [2:0]   io_qdma_c2h_byp_in_st_csh_port_id,
  output [6:0]   io_qdma_c2h_byp_in_st_csh_pfch_tag,
  output         io_qdma_c2h_byp_in_st_csh_vld,
  input          io_qdma_c2h_byp_in_st_csh_rdy,
  output [511:0] io_qdma_s_axis_c2h_tdata,
  output [31:0]  io_qdma_s_axis_c2h_tcrc,
  output         io_qdma_s_axis_c2h_ctrl_marker,
  output [6:0]   io_qdma_s_axis_c2h_ctrl_ecc,
  output [31:0]  io_qdma_s_axis_c2h_ctrl_len,
  output [2:0]   io_qdma_s_axis_c2h_ctrl_port_id,
  output [10:0]  io_qdma_s_axis_c2h_ctrl_qid,
  output         io_qdma_s_axis_c2h_ctrl_has_cmpt,
  output [5:0]   io_qdma_s_axis_c2h_mty,
  output         io_qdma_s_axis_c2h_tlast,
  output         io_qdma_s_axis_c2h_tvalid,
  input          io_qdma_s_axis_c2h_tready,
  input  [511:0] io_qdma_m_axis_h2c_tdata,
  input  [31:0]  io_qdma_m_axis_h2c_tcrc,
  input  [10:0]  io_qdma_m_axis_h2c_tuser_qid,
  input  [2:0]   io_qdma_m_axis_h2c_tuser_port_id,
  input          io_qdma_m_axis_h2c_tuser_err,
  input  [31:0]  io_qdma_m_axis_h2c_tuser_mdata,
  input  [5:0]   io_qdma_m_axis_h2c_tuser_mty,
  input          io_qdma_m_axis_h2c_tuser_zero_byte,
  input          io_qdma_m_axis_h2c_tlast,
  input          io_qdma_m_axis_h2c_tvalid,
  output         io_qdma_m_axis_h2c_tready,
  input          io_qdma_axis_c2h_status_drop,
  input          io_qdma_axis_c2h_status_last,
  input          io_qdma_axis_c2h_status_cmp,
  input          io_qdma_axis_c2h_status_valid,
  input  [10:0]  io_qdma_axis_c2h_status_qid,
  output [511:0] io_qdma_s_axis_c2h_cmpt_tdata,
  output [1:0]   io_qdma_s_axis_c2h_cmpt_size,
  output [15:0]  io_qdma_s_axis_c2h_cmpt_dpar,
  output         io_qdma_s_axis_c2h_cmpt_tvalid,
  input          io_qdma_s_axis_c2h_cmpt_tready,
  output [10:0]  io_qdma_s_axis_c2h_cmpt_ctrl_qid,
  output [1:0]   io_qdma_s_axis_c2h_cmpt_ctrl_cmpt_type,
  output [15:0]  io_qdma_s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id,
  output         io_qdma_s_axis_c2h_cmpt_ctrl_no_wrb_marker,
  output [2:0]   io_qdma_s_axis_c2h_cmpt_ctrl_port_id,
  output         io_qdma_s_axis_c2h_cmpt_ctrl_marker,
  output         io_qdma_s_axis_c2h_cmpt_ctrl_user_trig,
  output [2:0]   io_qdma_s_axis_c2h_cmpt_ctrl_col_idx,
  output [2:0]   io_qdma_s_axis_c2h_cmpt_ctrl_err_idx,
  output         io_qdma_h2c_byp_out_rdy,
  output         io_qdma_c2h_byp_out_rdy,
  output         io_qdma_tm_dsc_sts_rdy,
  output         io_qdma_dsc_crdt_in_vld,
  input          io_qdma_dsc_crdt_in_rdy,
  output         io_qdma_dsc_crdt_in_dir,
  output         io_qdma_dsc_crdt_in_fence,
  output [10:0]  io_qdma_dsc_crdt_in_qid,
  output [15:0]  io_qdma_dsc_crdt_in_crdt,
  output         io_qdma_qsts_out_rdy,
  output         io_qdma_usr_irq_in_vld,
  output [10:0]  io_qdma_usr_irq_in_vec,
  output [7:0]   io_qdma_usr_irq_in_fnc,
  input          io_qdma_usr_irq_out_ack,
  input          io_qdma_usr_irq_out_fail,
  output [3:0]   io_qdma_s_axib_awid,
  output [63:0]  io_qdma_s_axib_awaddr,
  output [7:0]   io_qdma_s_axib_awlen,
  output [2:0]   io_qdma_s_axib_awsize,
  output [11:0]  io_qdma_s_axib_awuser,
  output [1:0]   io_qdma_s_axib_awburst,
  output [3:0]   io_qdma_s_axib_awregion,
  output         io_qdma_s_axib_awvalid,
  input          io_qdma_s_axib_awready,
  output [511:0] io_qdma_s_axib_wdata,
  output [63:0]  io_qdma_s_axib_wstrb,
  output [63:0]  io_qdma_s_axib_wuser,
  output         io_qdma_s_axib_wlast,
  output         io_qdma_s_axib_wvalid,
  input          io_qdma_s_axib_wready,
  input  [3:0]   io_qdma_s_axib_bid,
  input  [1:0]   io_qdma_s_axib_bresp,
  input          io_qdma_s_axib_bvalid,
  output         io_qdma_s_axib_bready,
  output [3:0]   io_qdma_s_axib_arid,
  output [63:0]  io_qdma_s_axib_araddr,
  output [7:0]   io_qdma_s_axib_arlen,
  output [2:0]   io_qdma_s_axib_arsize,
  output [11:0]  io_qdma_s_axib_aruser,
  output [1:0]   io_qdma_s_axib_arburst,
  output [3:0]   io_qdma_s_axib_arregion,
  output         io_qdma_s_axib_arvalid,
  input          io_qdma_s_axib_arready,
  input  [3:0]   io_qdma_s_axib_rid,
  input  [511:0] io_qdma_s_axib_rdata,
  input  [1:0]   io_qdma_s_axib_rresp,
  input  [63:0]  io_qdma_s_axib_ruser,
  input          io_qdma_s_axib_rlast,
  input          io_qdma_s_axib_rvalid,
  output         io_qdma_s_axib_rready,
  input  [31:0]  io_qdma_st_rx_msg_data,
  input          io_qdma_st_rx_msg_last,
  output         io_qdma_st_rx_msg_rdy,
  input          io_qdma_st_rx_msg_valid,
  input          S_BSCAN_drck,
  input          S_BSCAN_shift,
  input          S_BSCAN_tdi,
  input          S_BSCAN_update,
  input          S_BSCAN_sel,
  output         S_BSCAN_tdo,
  input          S_BSCAN_tms,
  input          S_BSCAN_tck,
  input          S_BSCAN_runtest,
  input          S_BSCAN_reset,
  input          S_BSCAN_capture,
  input          S_BSCAN_bscanid_en
);
  wire  dbgBridge_clk; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_drck; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_shift; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_tdi; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_update; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_sel; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_tdo; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_tms; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_tck; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_runtest; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_reset; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_capture; // @[U280DynamicGrayBox.scala 42:33]
  wire  dbgBridge_S_BSCAN_bscanid_en; // @[U280DynamicGrayBox.scala 42:33]
  wire  qdmaInst_io_qdma_port_axi_aclk; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_axi_aresetn; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] qdmaInst_io_qdma_port_m_axib_awid; // @[U280DynamicGrayBox.scala 67:30]
  wire [63:0] qdmaInst_io_qdma_port_m_axib_awaddr; // @[U280DynamicGrayBox.scala 67:30]
  wire [7:0] qdmaInst_io_qdma_port_m_axib_awlen; // @[U280DynamicGrayBox.scala 67:30]
  wire [2:0] qdmaInst_io_qdma_port_m_axib_awsize; // @[U280DynamicGrayBox.scala 67:30]
  wire [1:0] qdmaInst_io_qdma_port_m_axib_awburst; // @[U280DynamicGrayBox.scala 67:30]
  wire [2:0] qdmaInst_io_qdma_port_m_axib_awprot; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_awlock; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] qdmaInst_io_qdma_port_m_axib_awcache; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_awvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_awready; // @[U280DynamicGrayBox.scala 67:30]
  wire [511:0] qdmaInst_io_qdma_port_m_axib_wdata; // @[U280DynamicGrayBox.scala 67:30]
  wire [63:0] qdmaInst_io_qdma_port_m_axib_wstrb; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_wlast; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_wvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_wready; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] qdmaInst_io_qdma_port_m_axib_bid; // @[U280DynamicGrayBox.scala 67:30]
  wire [1:0] qdmaInst_io_qdma_port_m_axib_bresp; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_bvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_bready; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] qdmaInst_io_qdma_port_m_axib_arid; // @[U280DynamicGrayBox.scala 67:30]
  wire [63:0] qdmaInst_io_qdma_port_m_axib_araddr; // @[U280DynamicGrayBox.scala 67:30]
  wire [7:0] qdmaInst_io_qdma_port_m_axib_arlen; // @[U280DynamicGrayBox.scala 67:30]
  wire [2:0] qdmaInst_io_qdma_port_m_axib_arsize; // @[U280DynamicGrayBox.scala 67:30]
  wire [1:0] qdmaInst_io_qdma_port_m_axib_arburst; // @[U280DynamicGrayBox.scala 67:30]
  wire [2:0] qdmaInst_io_qdma_port_m_axib_arprot; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_arlock; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] qdmaInst_io_qdma_port_m_axib_arcache; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_arvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_arready; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] qdmaInst_io_qdma_port_m_axib_rid; // @[U280DynamicGrayBox.scala 67:30]
  wire [511:0] qdmaInst_io_qdma_port_m_axib_rdata; // @[U280DynamicGrayBox.scala 67:30]
  wire [1:0] qdmaInst_io_qdma_port_m_axib_rresp; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_rlast; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_rvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axib_rready; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_qdma_port_m_axil_awaddr; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axil_awvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axil_awready; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_qdma_port_m_axil_wdata; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] qdmaInst_io_qdma_port_m_axil_wstrb; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axil_wvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axil_wready; // @[U280DynamicGrayBox.scala 67:30]
  wire [1:0] qdmaInst_io_qdma_port_m_axil_bresp; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axil_bvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axil_bready; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_qdma_port_m_axil_araddr; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axil_arvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axil_arready; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_qdma_port_m_axil_rdata; // @[U280DynamicGrayBox.scala 67:30]
  wire [1:0] qdmaInst_io_qdma_port_m_axil_rresp; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axil_rvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axil_rready; // @[U280DynamicGrayBox.scala 67:30]
  wire [63:0] qdmaInst_io_qdma_port_h2c_byp_in_st_addr; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_qdma_port_h2c_byp_in_st_len; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_h2c_byp_in_st_eop; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_h2c_byp_in_st_sop; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_h2c_byp_in_st_mrkr_req; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_h2c_byp_in_st_sdi; // @[U280DynamicGrayBox.scala 67:30]
  wire [10:0] qdmaInst_io_qdma_port_h2c_byp_in_st_qid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_h2c_byp_in_st_error; // @[U280DynamicGrayBox.scala 67:30]
  wire [7:0] qdmaInst_io_qdma_port_h2c_byp_in_st_func; // @[U280DynamicGrayBox.scala 67:30]
  wire [15:0] qdmaInst_io_qdma_port_h2c_byp_in_st_cidx; // @[U280DynamicGrayBox.scala 67:30]
  wire [2:0] qdmaInst_io_qdma_port_h2c_byp_in_st_port_id; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_h2c_byp_in_st_no_dma; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_h2c_byp_in_st_vld; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_h2c_byp_in_st_rdy; // @[U280DynamicGrayBox.scala 67:30]
  wire [63:0] qdmaInst_io_qdma_port_c2h_byp_in_st_csh_addr; // @[U280DynamicGrayBox.scala 67:30]
  wire [10:0] qdmaInst_io_qdma_port_c2h_byp_in_st_csh_qid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_c2h_byp_in_st_csh_error; // @[U280DynamicGrayBox.scala 67:30]
  wire [7:0] qdmaInst_io_qdma_port_c2h_byp_in_st_csh_func; // @[U280DynamicGrayBox.scala 67:30]
  wire [2:0] qdmaInst_io_qdma_port_c2h_byp_in_st_csh_port_id; // @[U280DynamicGrayBox.scala 67:30]
  wire [6:0] qdmaInst_io_qdma_port_c2h_byp_in_st_csh_pfch_tag; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_c2h_byp_in_st_csh_vld; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_c2h_byp_in_st_csh_rdy; // @[U280DynamicGrayBox.scala 67:30]
  wire [511:0] qdmaInst_io_qdma_port_s_axis_c2h_tdata; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_qdma_port_s_axis_c2h_tcrc; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axis_c2h_ctrl_marker; // @[U280DynamicGrayBox.scala 67:30]
  wire [6:0] qdmaInst_io_qdma_port_s_axis_c2h_ctrl_ecc; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_qdma_port_s_axis_c2h_ctrl_len; // @[U280DynamicGrayBox.scala 67:30]
  wire [2:0] qdmaInst_io_qdma_port_s_axis_c2h_ctrl_port_id; // @[U280DynamicGrayBox.scala 67:30]
  wire [10:0] qdmaInst_io_qdma_port_s_axis_c2h_ctrl_qid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axis_c2h_ctrl_has_cmpt; // @[U280DynamicGrayBox.scala 67:30]
  wire [5:0] qdmaInst_io_qdma_port_s_axis_c2h_mty; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axis_c2h_tlast; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axis_c2h_tvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axis_c2h_tready; // @[U280DynamicGrayBox.scala 67:30]
  wire [511:0] qdmaInst_io_qdma_port_m_axis_h2c_tdata; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_qdma_port_m_axis_h2c_tcrc; // @[U280DynamicGrayBox.scala 67:30]
  wire [10:0] qdmaInst_io_qdma_port_m_axis_h2c_tuser_qid; // @[U280DynamicGrayBox.scala 67:30]
  wire [2:0] qdmaInst_io_qdma_port_m_axis_h2c_tuser_port_id; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axis_h2c_tuser_err; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_qdma_port_m_axis_h2c_tuser_mdata; // @[U280DynamicGrayBox.scala 67:30]
  wire [5:0] qdmaInst_io_qdma_port_m_axis_h2c_tuser_mty; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axis_h2c_tuser_zero_byte; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axis_h2c_tlast; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axis_h2c_tvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_m_axis_h2c_tready; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] qdmaInst_io_qdma_port_s_axib_awid; // @[U280DynamicGrayBox.scala 67:30]
  wire [63:0] qdmaInst_io_qdma_port_s_axib_awaddr; // @[U280DynamicGrayBox.scala 67:30]
  wire [7:0] qdmaInst_io_qdma_port_s_axib_awlen; // @[U280DynamicGrayBox.scala 67:30]
  wire [2:0] qdmaInst_io_qdma_port_s_axib_awsize; // @[U280DynamicGrayBox.scala 67:30]
  wire [1:0] qdmaInst_io_qdma_port_s_axib_awburst; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_awvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_awready; // @[U280DynamicGrayBox.scala 67:30]
  wire [511:0] qdmaInst_io_qdma_port_s_axib_wdata; // @[U280DynamicGrayBox.scala 67:30]
  wire [63:0] qdmaInst_io_qdma_port_s_axib_wstrb; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_wlast; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_wvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_wready; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] qdmaInst_io_qdma_port_s_axib_bid; // @[U280DynamicGrayBox.scala 67:30]
  wire [1:0] qdmaInst_io_qdma_port_s_axib_bresp; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_bvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_bready; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] qdmaInst_io_qdma_port_s_axib_arid; // @[U280DynamicGrayBox.scala 67:30]
  wire [63:0] qdmaInst_io_qdma_port_s_axib_araddr; // @[U280DynamicGrayBox.scala 67:30]
  wire [7:0] qdmaInst_io_qdma_port_s_axib_arlen; // @[U280DynamicGrayBox.scala 67:30]
  wire [2:0] qdmaInst_io_qdma_port_s_axib_arsize; // @[U280DynamicGrayBox.scala 67:30]
  wire [1:0] qdmaInst_io_qdma_port_s_axib_arburst; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_arvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_arready; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] qdmaInst_io_qdma_port_s_axib_rid; // @[U280DynamicGrayBox.scala 67:30]
  wire [511:0] qdmaInst_io_qdma_port_s_axib_rdata; // @[U280DynamicGrayBox.scala 67:30]
  wire [1:0] qdmaInst_io_qdma_port_s_axib_rresp; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_rlast; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_rvalid; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_qdma_port_s_axib_rready; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_user_clk; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_user_arstn; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_h2c_data_valid; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_control_0; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_control_8; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_control_9; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_control_10; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_control_11; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_control_12; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_control_13; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_control_14; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_status_400; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_status_401; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_status_402; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_status_403; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_status_404; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_status_405; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_status_406; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_status_407; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_status_408; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_reg_status_409; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_out_valid; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_counter_4_0; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_out_ready; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_counter_7_0; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_counter_1_0; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_in_ready; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_out_ready_0; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_counter_3_0; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_out_valid_0; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_counter_6_0; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_counter_0; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_in_valid; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_io_tlb_miss_count; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_out_valid_1; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_counter_2_0; // @[U280DynamicGrayBox.scala 67:30]
  wire  qdmaInst_io_out_ready_1; // @[U280DynamicGrayBox.scala 67:30]
  wire [31:0] qdmaInst_counter_5_0; // @[U280DynamicGrayBox.scala 67:30]
  wire [3:0] cmacInst_io_pin_tx_p; // @[U280DynamicGrayBox.scala 113:30]
  wire [3:0] cmacInst_io_pin_tx_n; // @[U280DynamicGrayBox.scala 113:30]
  wire [3:0] cmacInst_io_pin_rx_p; // @[U280DynamicGrayBox.scala 113:30]
  wire [3:0] cmacInst_io_pin_rx_n; // @[U280DynamicGrayBox.scala 113:30]
  wire  cmacInst_io_pin_gt_clk_p; // @[U280DynamicGrayBox.scala 113:30]
  wire  cmacInst_io_pin_gt_clk_n; // @[U280DynamicGrayBox.scala 113:30]
  wire  cmacInst_io_net_clk; // @[U280DynamicGrayBox.scala 113:30]
  wire  cmacInst_io_drp_clk; // @[U280DynamicGrayBox.scala 113:30]
  wire  cmacInst_io_user_clk; // @[U280DynamicGrayBox.scala 113:30]
  wire  cmacInst_io_user_arstn; // @[U280DynamicGrayBox.scala 113:30]
  wire  cmacInst_io_sys_reset; // @[U280DynamicGrayBox.scala 113:30]
  wire  hbmDriver_clock; // @[U280DynamicGrayBox.scala 127:70]
  wire  report_w1_1 = qdmaInst_io_out_ready_0;
  wire  report_w1_0 = qdmaInst_io_out_valid_1;
  wire  report_w1_3 = qdmaInst_io_out_ready_1;
  wire  report_w1_2 = qdmaInst_io_out_valid;
  wire  report_w1_5 = qdmaInst_io_out_ready;
  wire  report_w1_4 = qdmaInst_io_out_valid_0;
  wire  report_w1_7 = qdmaInst_io_in_ready;
  wire  report_w1_6 = qdmaInst_io_in_valid;
  wire [15:0] qdmaInst_io_reg_status_409_lo = {8'h0,report_w1_7,report_w1_6,report_w1_5,report_w1_4,report_w1_3,
    report_w1_2,report_w1_1,report_w1_0}; // @[Collector.scala 237:73]
  DebugBridgeBase dbgBridge ( // @[U280DynamicGrayBox.scala 42:33]
    .clk(dbgBridge_clk),
    .S_BSCAN_drck(dbgBridge_S_BSCAN_drck),
    .S_BSCAN_shift(dbgBridge_S_BSCAN_shift),
    .S_BSCAN_tdi(dbgBridge_S_BSCAN_tdi),
    .S_BSCAN_update(dbgBridge_S_BSCAN_update),
    .S_BSCAN_sel(dbgBridge_S_BSCAN_sel),
    .S_BSCAN_tdo(dbgBridge_S_BSCAN_tdo),
    .S_BSCAN_tms(dbgBridge_S_BSCAN_tms),
    .S_BSCAN_tck(dbgBridge_S_BSCAN_tck),
    .S_BSCAN_runtest(dbgBridge_S_BSCAN_runtest),
    .S_BSCAN_reset(dbgBridge_S_BSCAN_reset),
    .S_BSCAN_capture(dbgBridge_S_BSCAN_capture),
    .S_BSCAN_bscanid_en(dbgBridge_S_BSCAN_bscanid_en)
  );
  QDMADynamic qdmaInst ( // @[U280DynamicGrayBox.scala 67:30]
    .io_qdma_port_axi_aclk(qdmaInst_io_qdma_port_axi_aclk),
    .io_qdma_port_axi_aresetn(qdmaInst_io_qdma_port_axi_aresetn),
    .io_qdma_port_m_axib_awid(qdmaInst_io_qdma_port_m_axib_awid),
    .io_qdma_port_m_axib_awaddr(qdmaInst_io_qdma_port_m_axib_awaddr),
    .io_qdma_port_m_axib_awlen(qdmaInst_io_qdma_port_m_axib_awlen),
    .io_qdma_port_m_axib_awsize(qdmaInst_io_qdma_port_m_axib_awsize),
    .io_qdma_port_m_axib_awburst(qdmaInst_io_qdma_port_m_axib_awburst),
    .io_qdma_port_m_axib_awprot(qdmaInst_io_qdma_port_m_axib_awprot),
    .io_qdma_port_m_axib_awlock(qdmaInst_io_qdma_port_m_axib_awlock),
    .io_qdma_port_m_axib_awcache(qdmaInst_io_qdma_port_m_axib_awcache),
    .io_qdma_port_m_axib_awvalid(qdmaInst_io_qdma_port_m_axib_awvalid),
    .io_qdma_port_m_axib_awready(qdmaInst_io_qdma_port_m_axib_awready),
    .io_qdma_port_m_axib_wdata(qdmaInst_io_qdma_port_m_axib_wdata),
    .io_qdma_port_m_axib_wstrb(qdmaInst_io_qdma_port_m_axib_wstrb),
    .io_qdma_port_m_axib_wlast(qdmaInst_io_qdma_port_m_axib_wlast),
    .io_qdma_port_m_axib_wvalid(qdmaInst_io_qdma_port_m_axib_wvalid),
    .io_qdma_port_m_axib_wready(qdmaInst_io_qdma_port_m_axib_wready),
    .io_qdma_port_m_axib_bid(qdmaInst_io_qdma_port_m_axib_bid),
    .io_qdma_port_m_axib_bresp(qdmaInst_io_qdma_port_m_axib_bresp),
    .io_qdma_port_m_axib_bvalid(qdmaInst_io_qdma_port_m_axib_bvalid),
    .io_qdma_port_m_axib_bready(qdmaInst_io_qdma_port_m_axib_bready),
    .io_qdma_port_m_axib_arid(qdmaInst_io_qdma_port_m_axib_arid),
    .io_qdma_port_m_axib_araddr(qdmaInst_io_qdma_port_m_axib_araddr),
    .io_qdma_port_m_axib_arlen(qdmaInst_io_qdma_port_m_axib_arlen),
    .io_qdma_port_m_axib_arsize(qdmaInst_io_qdma_port_m_axib_arsize),
    .io_qdma_port_m_axib_arburst(qdmaInst_io_qdma_port_m_axib_arburst),
    .io_qdma_port_m_axib_arprot(qdmaInst_io_qdma_port_m_axib_arprot),
    .io_qdma_port_m_axib_arlock(qdmaInst_io_qdma_port_m_axib_arlock),
    .io_qdma_port_m_axib_arcache(qdmaInst_io_qdma_port_m_axib_arcache),
    .io_qdma_port_m_axib_arvalid(qdmaInst_io_qdma_port_m_axib_arvalid),
    .io_qdma_port_m_axib_arready(qdmaInst_io_qdma_port_m_axib_arready),
    .io_qdma_port_m_axib_rid(qdmaInst_io_qdma_port_m_axib_rid),
    .io_qdma_port_m_axib_rdata(qdmaInst_io_qdma_port_m_axib_rdata),
    .io_qdma_port_m_axib_rresp(qdmaInst_io_qdma_port_m_axib_rresp),
    .io_qdma_port_m_axib_rlast(qdmaInst_io_qdma_port_m_axib_rlast),
    .io_qdma_port_m_axib_rvalid(qdmaInst_io_qdma_port_m_axib_rvalid),
    .io_qdma_port_m_axib_rready(qdmaInst_io_qdma_port_m_axib_rready),
    .io_qdma_port_m_axil_awaddr(qdmaInst_io_qdma_port_m_axil_awaddr),
    .io_qdma_port_m_axil_awvalid(qdmaInst_io_qdma_port_m_axil_awvalid),
    .io_qdma_port_m_axil_awready(qdmaInst_io_qdma_port_m_axil_awready),
    .io_qdma_port_m_axil_wdata(qdmaInst_io_qdma_port_m_axil_wdata),
    .io_qdma_port_m_axil_wstrb(qdmaInst_io_qdma_port_m_axil_wstrb),
    .io_qdma_port_m_axil_wvalid(qdmaInst_io_qdma_port_m_axil_wvalid),
    .io_qdma_port_m_axil_wready(qdmaInst_io_qdma_port_m_axil_wready),
    .io_qdma_port_m_axil_bresp(qdmaInst_io_qdma_port_m_axil_bresp),
    .io_qdma_port_m_axil_bvalid(qdmaInst_io_qdma_port_m_axil_bvalid),
    .io_qdma_port_m_axil_bready(qdmaInst_io_qdma_port_m_axil_bready),
    .io_qdma_port_m_axil_araddr(qdmaInst_io_qdma_port_m_axil_araddr),
    .io_qdma_port_m_axil_arvalid(qdmaInst_io_qdma_port_m_axil_arvalid),
    .io_qdma_port_m_axil_arready(qdmaInst_io_qdma_port_m_axil_arready),
    .io_qdma_port_m_axil_rdata(qdmaInst_io_qdma_port_m_axil_rdata),
    .io_qdma_port_m_axil_rresp(qdmaInst_io_qdma_port_m_axil_rresp),
    .io_qdma_port_m_axil_rvalid(qdmaInst_io_qdma_port_m_axil_rvalid),
    .io_qdma_port_m_axil_rready(qdmaInst_io_qdma_port_m_axil_rready),
    .io_qdma_port_h2c_byp_in_st_addr(qdmaInst_io_qdma_port_h2c_byp_in_st_addr),
    .io_qdma_port_h2c_byp_in_st_len(qdmaInst_io_qdma_port_h2c_byp_in_st_len),
    .io_qdma_port_h2c_byp_in_st_eop(qdmaInst_io_qdma_port_h2c_byp_in_st_eop),
    .io_qdma_port_h2c_byp_in_st_sop(qdmaInst_io_qdma_port_h2c_byp_in_st_sop),
    .io_qdma_port_h2c_byp_in_st_mrkr_req(qdmaInst_io_qdma_port_h2c_byp_in_st_mrkr_req),
    .io_qdma_port_h2c_byp_in_st_sdi(qdmaInst_io_qdma_port_h2c_byp_in_st_sdi),
    .io_qdma_port_h2c_byp_in_st_qid(qdmaInst_io_qdma_port_h2c_byp_in_st_qid),
    .io_qdma_port_h2c_byp_in_st_error(qdmaInst_io_qdma_port_h2c_byp_in_st_error),
    .io_qdma_port_h2c_byp_in_st_func(qdmaInst_io_qdma_port_h2c_byp_in_st_func),
    .io_qdma_port_h2c_byp_in_st_cidx(qdmaInst_io_qdma_port_h2c_byp_in_st_cidx),
    .io_qdma_port_h2c_byp_in_st_port_id(qdmaInst_io_qdma_port_h2c_byp_in_st_port_id),
    .io_qdma_port_h2c_byp_in_st_no_dma(qdmaInst_io_qdma_port_h2c_byp_in_st_no_dma),
    .io_qdma_port_h2c_byp_in_st_vld(qdmaInst_io_qdma_port_h2c_byp_in_st_vld),
    .io_qdma_port_h2c_byp_in_st_rdy(qdmaInst_io_qdma_port_h2c_byp_in_st_rdy),
    .io_qdma_port_c2h_byp_in_st_csh_addr(qdmaInst_io_qdma_port_c2h_byp_in_st_csh_addr),
    .io_qdma_port_c2h_byp_in_st_csh_qid(qdmaInst_io_qdma_port_c2h_byp_in_st_csh_qid),
    .io_qdma_port_c2h_byp_in_st_csh_error(qdmaInst_io_qdma_port_c2h_byp_in_st_csh_error),
    .io_qdma_port_c2h_byp_in_st_csh_func(qdmaInst_io_qdma_port_c2h_byp_in_st_csh_func),
    .io_qdma_port_c2h_byp_in_st_csh_port_id(qdmaInst_io_qdma_port_c2h_byp_in_st_csh_port_id),
    .io_qdma_port_c2h_byp_in_st_csh_pfch_tag(qdmaInst_io_qdma_port_c2h_byp_in_st_csh_pfch_tag),
    .io_qdma_port_c2h_byp_in_st_csh_vld(qdmaInst_io_qdma_port_c2h_byp_in_st_csh_vld),
    .io_qdma_port_c2h_byp_in_st_csh_rdy(qdmaInst_io_qdma_port_c2h_byp_in_st_csh_rdy),
    .io_qdma_port_s_axis_c2h_tdata(qdmaInst_io_qdma_port_s_axis_c2h_tdata),
    .io_qdma_port_s_axis_c2h_tcrc(qdmaInst_io_qdma_port_s_axis_c2h_tcrc),
    .io_qdma_port_s_axis_c2h_ctrl_marker(qdmaInst_io_qdma_port_s_axis_c2h_ctrl_marker),
    .io_qdma_port_s_axis_c2h_ctrl_ecc(qdmaInst_io_qdma_port_s_axis_c2h_ctrl_ecc),
    .io_qdma_port_s_axis_c2h_ctrl_len(qdmaInst_io_qdma_port_s_axis_c2h_ctrl_len),
    .io_qdma_port_s_axis_c2h_ctrl_port_id(qdmaInst_io_qdma_port_s_axis_c2h_ctrl_port_id),
    .io_qdma_port_s_axis_c2h_ctrl_qid(qdmaInst_io_qdma_port_s_axis_c2h_ctrl_qid),
    .io_qdma_port_s_axis_c2h_ctrl_has_cmpt(qdmaInst_io_qdma_port_s_axis_c2h_ctrl_has_cmpt),
    .io_qdma_port_s_axis_c2h_mty(qdmaInst_io_qdma_port_s_axis_c2h_mty),
    .io_qdma_port_s_axis_c2h_tlast(qdmaInst_io_qdma_port_s_axis_c2h_tlast),
    .io_qdma_port_s_axis_c2h_tvalid(qdmaInst_io_qdma_port_s_axis_c2h_tvalid),
    .io_qdma_port_s_axis_c2h_tready(qdmaInst_io_qdma_port_s_axis_c2h_tready),
    .io_qdma_port_m_axis_h2c_tdata(qdmaInst_io_qdma_port_m_axis_h2c_tdata),
    .io_qdma_port_m_axis_h2c_tcrc(qdmaInst_io_qdma_port_m_axis_h2c_tcrc),
    .io_qdma_port_m_axis_h2c_tuser_qid(qdmaInst_io_qdma_port_m_axis_h2c_tuser_qid),
    .io_qdma_port_m_axis_h2c_tuser_port_id(qdmaInst_io_qdma_port_m_axis_h2c_tuser_port_id),
    .io_qdma_port_m_axis_h2c_tuser_err(qdmaInst_io_qdma_port_m_axis_h2c_tuser_err),
    .io_qdma_port_m_axis_h2c_tuser_mdata(qdmaInst_io_qdma_port_m_axis_h2c_tuser_mdata),
    .io_qdma_port_m_axis_h2c_tuser_mty(qdmaInst_io_qdma_port_m_axis_h2c_tuser_mty),
    .io_qdma_port_m_axis_h2c_tuser_zero_byte(qdmaInst_io_qdma_port_m_axis_h2c_tuser_zero_byte),
    .io_qdma_port_m_axis_h2c_tlast(qdmaInst_io_qdma_port_m_axis_h2c_tlast),
    .io_qdma_port_m_axis_h2c_tvalid(qdmaInst_io_qdma_port_m_axis_h2c_tvalid),
    .io_qdma_port_m_axis_h2c_tready(qdmaInst_io_qdma_port_m_axis_h2c_tready),
    .io_qdma_port_s_axib_awid(qdmaInst_io_qdma_port_s_axib_awid),
    .io_qdma_port_s_axib_awaddr(qdmaInst_io_qdma_port_s_axib_awaddr),
    .io_qdma_port_s_axib_awlen(qdmaInst_io_qdma_port_s_axib_awlen),
    .io_qdma_port_s_axib_awsize(qdmaInst_io_qdma_port_s_axib_awsize),
    .io_qdma_port_s_axib_awburst(qdmaInst_io_qdma_port_s_axib_awburst),
    .io_qdma_port_s_axib_awvalid(qdmaInst_io_qdma_port_s_axib_awvalid),
    .io_qdma_port_s_axib_awready(qdmaInst_io_qdma_port_s_axib_awready),
    .io_qdma_port_s_axib_wdata(qdmaInst_io_qdma_port_s_axib_wdata),
    .io_qdma_port_s_axib_wstrb(qdmaInst_io_qdma_port_s_axib_wstrb),
    .io_qdma_port_s_axib_wlast(qdmaInst_io_qdma_port_s_axib_wlast),
    .io_qdma_port_s_axib_wvalid(qdmaInst_io_qdma_port_s_axib_wvalid),
    .io_qdma_port_s_axib_wready(qdmaInst_io_qdma_port_s_axib_wready),
    .io_qdma_port_s_axib_bid(qdmaInst_io_qdma_port_s_axib_bid),
    .io_qdma_port_s_axib_bresp(qdmaInst_io_qdma_port_s_axib_bresp),
    .io_qdma_port_s_axib_bvalid(qdmaInst_io_qdma_port_s_axib_bvalid),
    .io_qdma_port_s_axib_bready(qdmaInst_io_qdma_port_s_axib_bready),
    .io_qdma_port_s_axib_arid(qdmaInst_io_qdma_port_s_axib_arid),
    .io_qdma_port_s_axib_araddr(qdmaInst_io_qdma_port_s_axib_araddr),
    .io_qdma_port_s_axib_arlen(qdmaInst_io_qdma_port_s_axib_arlen),
    .io_qdma_port_s_axib_arsize(qdmaInst_io_qdma_port_s_axib_arsize),
    .io_qdma_port_s_axib_arburst(qdmaInst_io_qdma_port_s_axib_arburst),
    .io_qdma_port_s_axib_arvalid(qdmaInst_io_qdma_port_s_axib_arvalid),
    .io_qdma_port_s_axib_arready(qdmaInst_io_qdma_port_s_axib_arready),
    .io_qdma_port_s_axib_rid(qdmaInst_io_qdma_port_s_axib_rid),
    .io_qdma_port_s_axib_rdata(qdmaInst_io_qdma_port_s_axib_rdata),
    .io_qdma_port_s_axib_rresp(qdmaInst_io_qdma_port_s_axib_rresp),
    .io_qdma_port_s_axib_rlast(qdmaInst_io_qdma_port_s_axib_rlast),
    .io_qdma_port_s_axib_rvalid(qdmaInst_io_qdma_port_s_axib_rvalid),
    .io_qdma_port_s_axib_rready(qdmaInst_io_qdma_port_s_axib_rready),
    .io_user_clk(qdmaInst_io_user_clk),
    .io_user_arstn(qdmaInst_io_user_arstn),
    .io_h2c_data_valid(qdmaInst_io_h2c_data_valid),
    .io_reg_control_0(qdmaInst_io_reg_control_0),
    .io_reg_control_8(qdmaInst_io_reg_control_8),
    .io_reg_control_9(qdmaInst_io_reg_control_9),
    .io_reg_control_10(qdmaInst_io_reg_control_10),
    .io_reg_control_11(qdmaInst_io_reg_control_11),
    .io_reg_control_12(qdmaInst_io_reg_control_12),
    .io_reg_control_13(qdmaInst_io_reg_control_13),
    .io_reg_control_14(qdmaInst_io_reg_control_14),
    .io_reg_status_400(qdmaInst_io_reg_status_400),
    .io_reg_status_401(qdmaInst_io_reg_status_401),
    .io_reg_status_402(qdmaInst_io_reg_status_402),
    .io_reg_status_403(qdmaInst_io_reg_status_403),
    .io_reg_status_404(qdmaInst_io_reg_status_404),
    .io_reg_status_405(qdmaInst_io_reg_status_405),
    .io_reg_status_406(qdmaInst_io_reg_status_406),
    .io_reg_status_407(qdmaInst_io_reg_status_407),
    .io_reg_status_408(qdmaInst_io_reg_status_408),
    .io_reg_status_409(qdmaInst_io_reg_status_409),
    .io_out_valid(qdmaInst_io_out_valid),
    .counter_4_0(qdmaInst_counter_4_0),
    .io_out_ready(qdmaInst_io_out_ready),
    .counter_7_0(qdmaInst_counter_7_0),
    .counter_1_0(qdmaInst_counter_1_0),
    .io_in_ready(qdmaInst_io_in_ready),
    .io_out_ready_0(qdmaInst_io_out_ready_0),
    .counter_3_0(qdmaInst_counter_3_0),
    .io_out_valid_0(qdmaInst_io_out_valid_0),
    .counter_6_0(qdmaInst_counter_6_0),
    .counter_0(qdmaInst_counter_0),
    .io_in_valid(qdmaInst_io_in_valid),
    .io_tlb_miss_count(qdmaInst_io_tlb_miss_count),
    .io_out_valid_1(qdmaInst_io_out_valid_1),
    .counter_2_0(qdmaInst_counter_2_0),
    .io_out_ready_1(qdmaInst_io_out_ready_1),
    .counter_5_0(qdmaInst_counter_5_0)
  );
  XCMAC cmacInst ( // @[U280DynamicGrayBox.scala 113:30]
    .io_pin_tx_p(cmacInst_io_pin_tx_p),
    .io_pin_tx_n(cmacInst_io_pin_tx_n),
    .io_pin_rx_p(cmacInst_io_pin_rx_p),
    .io_pin_rx_n(cmacInst_io_pin_rx_n),
    .io_pin_gt_clk_p(cmacInst_io_pin_gt_clk_p),
    .io_pin_gt_clk_n(cmacInst_io_pin_gt_clk_n),
    .io_net_clk(cmacInst_io_net_clk),
    .io_drp_clk(cmacInst_io_drp_clk),
    .io_user_clk(cmacInst_io_user_clk),
    .io_user_arstn(cmacInst_io_user_arstn),
    .io_sys_reset(cmacInst_io_sys_reset)
  );
  HBM_DRIVER hbmDriver ( // @[U280DynamicGrayBox.scala 127:70]
    .clock(hbmDriver_clock)
  );
  assign io_cmacPin_tx_p = cmacInst_io_pin_tx_p; // @[U280DynamicGrayBox.scala 117:41]
  assign io_cmacPin_tx_n = cmacInst_io_pin_tx_n; // @[U280DynamicGrayBox.scala 117:41]
  assign io_qdma_m_axib_awready = qdmaInst_io_qdma_port_m_axib_awready; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axib_wready = qdmaInst_io_qdma_port_m_axib_wready; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axib_bid = qdmaInst_io_qdma_port_m_axib_bid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axib_bresp = qdmaInst_io_qdma_port_m_axib_bresp; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axib_bvalid = qdmaInst_io_qdma_port_m_axib_bvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axib_arready = qdmaInst_io_qdma_port_m_axib_arready; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axib_rid = qdmaInst_io_qdma_port_m_axib_rid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axib_rdata = qdmaInst_io_qdma_port_m_axib_rdata; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axib_rresp = qdmaInst_io_qdma_port_m_axib_rresp; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axib_rlast = qdmaInst_io_qdma_port_m_axib_rlast; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axib_rvalid = qdmaInst_io_qdma_port_m_axib_rvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axil_awready = qdmaInst_io_qdma_port_m_axil_awready; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axil_wready = qdmaInst_io_qdma_port_m_axil_wready; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axil_bresp = qdmaInst_io_qdma_port_m_axil_bresp; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axil_bvalid = qdmaInst_io_qdma_port_m_axil_bvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axil_arready = qdmaInst_io_qdma_port_m_axil_arready; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axil_rdata = qdmaInst_io_qdma_port_m_axil_rdata; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axil_rresp = qdmaInst_io_qdma_port_m_axil_rresp; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axil_rvalid = qdmaInst_io_qdma_port_m_axil_rvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_soft_reset_n = 1'h1; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_addr = qdmaInst_io_qdma_port_h2c_byp_in_st_addr; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_len = qdmaInst_io_qdma_port_h2c_byp_in_st_len; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_eop = qdmaInst_io_qdma_port_h2c_byp_in_st_eop; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_sop = qdmaInst_io_qdma_port_h2c_byp_in_st_sop; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_mrkr_req = qdmaInst_io_qdma_port_h2c_byp_in_st_mrkr_req; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_sdi = qdmaInst_io_qdma_port_h2c_byp_in_st_sdi; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_qid = qdmaInst_io_qdma_port_h2c_byp_in_st_qid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_error = qdmaInst_io_qdma_port_h2c_byp_in_st_error; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_func = qdmaInst_io_qdma_port_h2c_byp_in_st_func; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_cidx = qdmaInst_io_qdma_port_h2c_byp_in_st_cidx; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_port_id = qdmaInst_io_qdma_port_h2c_byp_in_st_port_id; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_no_dma = qdmaInst_io_qdma_port_h2c_byp_in_st_no_dma; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_in_st_vld = qdmaInst_io_qdma_port_h2c_byp_in_st_vld; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_c2h_byp_in_st_csh_addr = qdmaInst_io_qdma_port_c2h_byp_in_st_csh_addr; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_c2h_byp_in_st_csh_qid = qdmaInst_io_qdma_port_c2h_byp_in_st_csh_qid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_c2h_byp_in_st_csh_error = qdmaInst_io_qdma_port_c2h_byp_in_st_csh_error; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_c2h_byp_in_st_csh_func = qdmaInst_io_qdma_port_c2h_byp_in_st_csh_func; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_c2h_byp_in_st_csh_port_id = qdmaInst_io_qdma_port_c2h_byp_in_st_csh_port_id; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_c2h_byp_in_st_csh_pfch_tag = qdmaInst_io_qdma_port_c2h_byp_in_st_csh_pfch_tag; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_c2h_byp_in_st_csh_vld = qdmaInst_io_qdma_port_c2h_byp_in_st_csh_vld; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_tdata = qdmaInst_io_qdma_port_s_axis_c2h_tdata; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_tcrc = qdmaInst_io_qdma_port_s_axis_c2h_tcrc; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_ctrl_marker = qdmaInst_io_qdma_port_s_axis_c2h_ctrl_marker; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_ctrl_ecc = qdmaInst_io_qdma_port_s_axis_c2h_ctrl_ecc; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_ctrl_len = qdmaInst_io_qdma_port_s_axis_c2h_ctrl_len; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_ctrl_port_id = qdmaInst_io_qdma_port_s_axis_c2h_ctrl_port_id; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_ctrl_qid = qdmaInst_io_qdma_port_s_axis_c2h_ctrl_qid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_ctrl_has_cmpt = qdmaInst_io_qdma_port_s_axis_c2h_ctrl_has_cmpt; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_mty = qdmaInst_io_qdma_port_s_axis_c2h_mty; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_tlast = qdmaInst_io_qdma_port_s_axis_c2h_tlast; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_tvalid = qdmaInst_io_qdma_port_s_axis_c2h_tvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_m_axis_h2c_tready = qdmaInst_io_qdma_port_m_axis_h2c_tready; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_tdata = 512'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_size = 2'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_dpar = 16'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_tvalid = 1'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_ctrl_qid = 11'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_ctrl_cmpt_type = 2'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id = 16'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_ctrl_no_wrb_marker = 1'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_ctrl_port_id = 3'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_ctrl_marker = 1'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_ctrl_user_trig = 1'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_ctrl_col_idx = 3'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axis_c2h_cmpt_ctrl_err_idx = 3'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_h2c_byp_out_rdy = 1'h1; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_c2h_byp_out_rdy = 1'h1; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_tm_dsc_sts_rdy = 1'h1; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_dsc_crdt_in_vld = 1'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_dsc_crdt_in_dir = 1'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_dsc_crdt_in_fence = 1'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_dsc_crdt_in_qid = 11'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_dsc_crdt_in_crdt = 16'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_qsts_out_rdy = 1'h1; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_usr_irq_in_vld = 1'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_usr_irq_in_vec = 11'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_usr_irq_in_fnc = 8'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_awid = qdmaInst_io_qdma_port_s_axib_awid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_awaddr = qdmaInst_io_qdma_port_s_axib_awaddr; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_awlen = qdmaInst_io_qdma_port_s_axib_awlen; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_awsize = qdmaInst_io_qdma_port_s_axib_awsize; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_awuser = 12'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_awburst = qdmaInst_io_qdma_port_s_axib_awburst; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_awregion = 4'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_awvalid = qdmaInst_io_qdma_port_s_axib_awvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_wdata = qdmaInst_io_qdma_port_s_axib_wdata; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_wstrb = qdmaInst_io_qdma_port_s_axib_wstrb; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_wuser = 64'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_wlast = qdmaInst_io_qdma_port_s_axib_wlast; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_wvalid = qdmaInst_io_qdma_port_s_axib_wvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_bready = qdmaInst_io_qdma_port_s_axib_bready; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_arid = qdmaInst_io_qdma_port_s_axib_arid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_araddr = qdmaInst_io_qdma_port_s_axib_araddr; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_arlen = qdmaInst_io_qdma_port_s_axib_arlen; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_arsize = qdmaInst_io_qdma_port_s_axib_arsize; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_aruser = 12'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_arburst = qdmaInst_io_qdma_port_s_axib_arburst; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_arregion = 4'h0; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_arvalid = qdmaInst_io_qdma_port_s_axib_arvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_s_axib_rready = qdmaInst_io_qdma_port_s_axib_rready; // @[U280DynamicGrayBox.scala 76:33]
  assign io_qdma_st_rx_msg_rdy = 1'h1; // @[U280DynamicGrayBox.scala 76:33]
  assign S_BSCAN_tdo = dbgBridge_S_BSCAN_tdo; // @[U280DynamicGrayBox.scala 49:49]
  assign dbgBridge_clk = clock; // @[U280DynamicGrayBox.scala 43:33]
  assign dbgBridge_S_BSCAN_drck = S_BSCAN_drck; // @[U280DynamicGrayBox.scala 44:49]
  assign dbgBridge_S_BSCAN_shift = S_BSCAN_shift; // @[U280DynamicGrayBox.scala 45:49]
  assign dbgBridge_S_BSCAN_tdi = S_BSCAN_tdi; // @[U280DynamicGrayBox.scala 46:49]
  assign dbgBridge_S_BSCAN_update = S_BSCAN_update; // @[U280DynamicGrayBox.scala 47:49]
  assign dbgBridge_S_BSCAN_sel = S_BSCAN_sel; // @[U280DynamicGrayBox.scala 48:49]
  assign dbgBridge_S_BSCAN_tms = S_BSCAN_tms; // @[U280DynamicGrayBox.scala 50:49]
  assign dbgBridge_S_BSCAN_tck = S_BSCAN_tck; // @[U280DynamicGrayBox.scala 51:49]
  assign dbgBridge_S_BSCAN_runtest = S_BSCAN_runtest; // @[U280DynamicGrayBox.scala 52:41]
  assign dbgBridge_S_BSCAN_reset = S_BSCAN_reset; // @[U280DynamicGrayBox.scala 53:49]
  assign dbgBridge_S_BSCAN_capture = S_BSCAN_capture; // @[U280DynamicGrayBox.scala 54:41]
  assign dbgBridge_S_BSCAN_bscanid_en = S_BSCAN_bscanid_en; // @[U280DynamicGrayBox.scala 55:41]
  assign qdmaInst_io_qdma_port_axi_aclk = io_qdma_axi_aclk; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_axi_aresetn = io_qdma_axi_aresetn; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_awid = io_qdma_m_axib_awid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_awaddr = io_qdma_m_axib_awaddr; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_awlen = io_qdma_m_axib_awlen; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_awsize = io_qdma_m_axib_awsize; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_awburst = io_qdma_m_axib_awburst; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_awprot = io_qdma_m_axib_awprot; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_awlock = io_qdma_m_axib_awlock; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_awcache = io_qdma_m_axib_awcache; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_awvalid = io_qdma_m_axib_awvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_wdata = io_qdma_m_axib_wdata; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_wstrb = io_qdma_m_axib_wstrb; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_wlast = io_qdma_m_axib_wlast; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_wvalid = io_qdma_m_axib_wvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_bready = io_qdma_m_axib_bready; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_arid = io_qdma_m_axib_arid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_araddr = io_qdma_m_axib_araddr; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_arlen = io_qdma_m_axib_arlen; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_arsize = io_qdma_m_axib_arsize; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_arburst = io_qdma_m_axib_arburst; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_arprot = io_qdma_m_axib_arprot; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_arlock = io_qdma_m_axib_arlock; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_arcache = io_qdma_m_axib_arcache; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_arvalid = io_qdma_m_axib_arvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axib_rready = io_qdma_m_axib_rready; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axil_awaddr = io_qdma_m_axil_awaddr; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axil_awvalid = io_qdma_m_axil_awvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axil_wdata = io_qdma_m_axil_wdata; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axil_wstrb = io_qdma_m_axil_wstrb; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axil_wvalid = io_qdma_m_axil_wvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axil_bready = io_qdma_m_axil_bready; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axil_araddr = io_qdma_m_axil_araddr; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axil_arvalid = io_qdma_m_axil_arvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axil_rready = io_qdma_m_axil_rready; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_h2c_byp_in_st_rdy = io_qdma_h2c_byp_in_st_rdy; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_c2h_byp_in_st_csh_rdy = io_qdma_c2h_byp_in_st_csh_rdy; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axis_c2h_tready = io_qdma_s_axis_c2h_tready; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axis_h2c_tdata = io_qdma_m_axis_h2c_tdata; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axis_h2c_tcrc = io_qdma_m_axis_h2c_tcrc; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axis_h2c_tuser_qid = io_qdma_m_axis_h2c_tuser_qid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axis_h2c_tuser_port_id = io_qdma_m_axis_h2c_tuser_port_id; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axis_h2c_tuser_err = io_qdma_m_axis_h2c_tuser_err; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axis_h2c_tuser_mdata = io_qdma_m_axis_h2c_tuser_mdata; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axis_h2c_tuser_mty = io_qdma_m_axis_h2c_tuser_mty; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axis_h2c_tuser_zero_byte = io_qdma_m_axis_h2c_tuser_zero_byte; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axis_h2c_tlast = io_qdma_m_axis_h2c_tlast; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_m_axis_h2c_tvalid = io_qdma_m_axis_h2c_tvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axib_awready = io_qdma_s_axib_awready; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axib_wready = io_qdma_s_axib_wready; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axib_bid = io_qdma_s_axib_bid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axib_bresp = io_qdma_s_axib_bresp; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axib_bvalid = io_qdma_s_axib_bvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axib_arready = io_qdma_s_axib_arready; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axib_rid = io_qdma_s_axib_rid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axib_rdata = io_qdma_s_axib_rdata; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axib_rresp = io_qdma_s_axib_rresp; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axib_rlast = io_qdma_s_axib_rlast; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_qdma_port_s_axib_rvalid = io_qdma_s_axib_rvalid; // @[U280DynamicGrayBox.scala 76:33]
  assign qdmaInst_io_user_clk = clock; // @[U280DynamicGrayBox.scala 64:31 U280DynamicGrayBox.scala 85:25]
  assign qdmaInst_io_user_arstn = ~reset & ~qdmaInst_io_reg_control_0[0]; // @[U280DynamicGrayBox.scala 86:74]
  assign qdmaInst_io_reg_status_400 = qdmaInst_io_tlb_miss_count; // @[Collector.scala 211:35]
  assign qdmaInst_io_reg_status_401 = qdmaInst_counter_0; // @[Collector.scala 211:35]
  assign qdmaInst_io_reg_status_402 = qdmaInst_counter_1_0; // @[Collector.scala 211:35]
  assign qdmaInst_io_reg_status_403 = qdmaInst_counter_2_0; // @[Collector.scala 211:35]
  assign qdmaInst_io_reg_status_404 = qdmaInst_counter_3_0; // @[Collector.scala 211:35]
  assign qdmaInst_io_reg_status_405 = qdmaInst_counter_4_0; // @[Collector.scala 211:35]
  assign qdmaInst_io_reg_status_406 = qdmaInst_counter_5_0; // @[Collector.scala 211:35]
  assign qdmaInst_io_reg_status_407 = qdmaInst_counter_6_0; // @[Collector.scala 211:35]
  assign qdmaInst_io_reg_status_408 = qdmaInst_counter_7_0; // @[Collector.scala 211:35]
  assign qdmaInst_io_reg_status_409 = {16'h0,qdmaInst_io_reg_status_409_lo}; // @[Collector.scala 237:73]
  assign cmacInst_io_pin_rx_p = io_cmacPin_rx_p; // @[U280DynamicGrayBox.scala 117:41]
  assign cmacInst_io_pin_rx_n = io_cmacPin_rx_n; // @[U280DynamicGrayBox.scala 117:41]
  assign cmacInst_io_pin_gt_clk_p = io_cmacPin_gt_clk_p; // @[U280DynamicGrayBox.scala 117:41]
  assign cmacInst_io_pin_gt_clk_n = io_cmacPin_gt_clk_n; // @[U280DynamicGrayBox.scala 117:41]
  assign cmacInst_io_drp_clk = io_sysClk; // @[U280DynamicGrayBox.scala 118:41]
  assign cmacInst_io_user_clk = clock; // @[U280DynamicGrayBox.scala 64:31 U280DynamicGrayBox.scala 85:25]
  assign cmacInst_io_user_arstn = ~reset & ~qdmaInst_io_reg_control_0[0]; // @[U280DynamicGrayBox.scala 86:74]
  assign cmacInst_io_sys_reset = reset; // @[U280DynamicGrayBox.scala 121:33]
  assign hbmDriver_clock = io_sysClk;
endmodule
