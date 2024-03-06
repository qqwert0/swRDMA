module PkgGen(
  input          clock,
  input          reset,
  input          io_start,
  input  [31:0]  io_idle_cycle,
  input          io_data_out_ready,
  output         io_data_out_valid,
  output         io_data_out_bits_last,
  output [511:0] io_data_out_bits_data,
  output [63:0]  io_data_out_bits_keep
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] state; // @[PkgGen.scala 50:22]
  reg [31:0] idle_cnt; // @[PkgGen.scala 52:31]
  reg [31:0] data_cnt; // @[PkgGen.scala 53:31]
  wire  _T = 3'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_5 = 3'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_7 = 3'h2 == state; // @[Conditional.scala 37:30]
  wire  _T_10 = io_data_out_ready & io_data_out_valid; // @[PkgGen.scala 77:53]
  wire [2:0] _GEN_3 = io_data_out_ready & io_data_out_valid ? 3'h3 : 3'h2; // @[PkgGen.scala 77:79 PkgGen.scala 78:38 PkgGen.scala 81:38]
  wire  _T_11 = 3'h3 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_4 = _T_10 & data_cnt == 32'he ? 3'h4 : 3'h3; // @[PkgGen.scala 85:102 PkgGen.scala 86:38 PkgGen.scala 89:38]
  wire  _T_17 = 3'h4 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_5 = _T_10 ? 3'h0 : 3'h4; // @[PkgGen.scala 93:79 PkgGen.scala 94:38 PkgGen.scala 97:38]
  wire [2:0] _GEN_6 = _T_17 ? _GEN_5 : state; // @[Conditional.scala 39:67 PkgGen.scala 50:22]
  wire [2:0] _GEN_7 = _T_11 ? _GEN_4 : _GEN_6; // @[Conditional.scala 39:67]
  wire [31:0] _idle_cnt_T_1 = idle_cnt + 32'h1; // @[PkgGen.scala 103:35]
  wire  _T_22 = state == 3'h2; // @[PkgGen.scala 106:20]
  wire  _T_23 = state == 3'h3; // @[PkgGen.scala 106:40]
  wire  _T_24 = state == 3'h2 | state == 3'h3; // @[PkgGen.scala 106:33]
  wire [31:0] _data_cnt_T_1 = data_cnt + 32'h1; // @[PkgGen.scala 107:35]
  wire  _T_29 = state == 3'h4; // @[PkgGen.scala 110:19]
  wire [511:0] _GEN_17 = 4'h1 == data_cnt[3:0] ? 512'h0 : 512'h3000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
    ; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_18 = 4'h2 == data_cnt[3:0] ? 512'h0 : _GEN_17; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_19 = 4'h3 == data_cnt[3:0] ? 512'h0 : _GEN_18; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_20 = 4'h4 == data_cnt[3:0] ? 512'h0 : _GEN_19; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_21 = 4'h5 == data_cnt[3:0] ? 512'h0 : _GEN_20; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_22 = 4'h6 == data_cnt[3:0] ? 512'h0 : _GEN_21; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_23 = 4'h7 == data_cnt[3:0] ? 512'h0 : _GEN_22; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_24 = 4'h8 == data_cnt[3:0] ? 512'h0 : _GEN_23; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_25 = 4'h9 == data_cnt[3:0] ? 512'h0 : _GEN_24; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_26 = 4'ha == data_cnt[3:0] ? 512'h0 : _GEN_25; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_27 = 4'hb == data_cnt[3:0] ? 512'h0 : _GEN_26; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_28 = 4'hc == data_cnt[3:0] ? 512'h0 : _GEN_27; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_29 = 4'hd == data_cnt[3:0] ? 512'h0 : _GEN_28; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_30 = 4'he == data_cnt[3:0] ? 512'h0 : _GEN_29; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_31 = 4'hf == data_cnt[3:0] ? 512'h0 : _GEN_30; // @[PkgGen.scala 124:38 PkgGen.scala 124:38]
  wire [511:0] _GEN_32 = _T_23 | _T_29 ? _GEN_31 : 512'h0; // @[PkgGen.scala 123:59 PkgGen.scala 124:38 PkgGen.scala 126:38]
  assign io_data_out_valid = _T_24 | _T_29; // @[PkgGen.scala 115:52]
  assign io_data_out_bits_last = state == 3'h4; // @[PkgGen.scala 130:19]
  assign io_data_out_bits_data = _T_22 ? 512'h3000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
     : _GEN_32; // @[PkgGen.scala 121:33 PkgGen.scala 122:38]
  assign io_data_out_bits_keep = 64'hffffffffffffffff; // @[PkgGen.scala 47:31]
  always @(posedge clock) begin
    if (reset) begin // @[PkgGen.scala 50:22]
      state <= 3'h0; // @[PkgGen.scala 50:22]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (io_start & idle_cnt == io_idle_cycle) begin // @[PkgGen.scala 59:71]
        state <= 3'h2; // @[PkgGen.scala 60:38]
      end else if (io_start) begin // @[PkgGen.scala 61:51]
        state <= 3'h0; // @[PkgGen.scala 62:38]
      end else begin
        state <= 3'h1; // @[PkgGen.scala 65:38]
      end
    end else if (_T_5) begin // @[Conditional.scala 39:67]
      if (io_start) begin // @[PkgGen.scala 69:45]
        state <= 3'h2; // @[PkgGen.scala 70:38]
      end else begin
        state <= 3'h1; // @[PkgGen.scala 73:38]
      end
    end else if (_T_7) begin // @[Conditional.scala 39:67]
      state <= _GEN_3;
    end else begin
      state <= _GEN_7;
    end
    if (reset) begin // @[PkgGen.scala 52:31]
      idle_cnt <= 32'h0; // @[PkgGen.scala 52:31]
    end else if (state == 3'h4) begin // @[PkgGen.scala 110:33]
      idle_cnt <= 32'h0; // @[PkgGen.scala 112:25]
    end else if (state == 3'h0) begin // @[PkgGen.scala 102:31]
      idle_cnt <= _idle_cnt_T_1; // @[PkgGen.scala 103:25]
    end
    if (reset) begin // @[PkgGen.scala 53:31]
      data_cnt <= 32'h0; // @[PkgGen.scala 53:31]
    end else if (state == 3'h4) begin // @[PkgGen.scala 110:33]
      data_cnt <= 32'h0; // @[PkgGen.scala 111:25]
    end else if ((state == 3'h2 | state == 3'h3) & io_data_out_ready & io_data_out_valid) begin // @[PkgGen.scala 106:105]
      data_cnt <= _data_cnt_T_1; // @[PkgGen.scala 107:25]
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
  idle_cnt = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  data_cnt = _RAND_2[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
