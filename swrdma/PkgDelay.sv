module PkgDelay(
  input          clock,
  input          reset,
  input  [31:0]  io_delay_cycle,
  output         io_data_in_ready,
  input          io_data_in_valid,
  input          io_data_in_bits_last,
  input  [511:0] io_data_in_bits_data,
  input  [63:0]  io_data_in_bits_keep,
  input          io_data_out_ready,
  output         io_data_out_valid,
  output         io_data_out_bits_last,
  output [511:0] io_data_out_bits_data,
  output [63:0]  io_data_out_bits_keep
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [511:0] _RAND_2;
  reg [511:0] _RAND_3;
  reg [511:0] _RAND_4;
  reg [511:0] _RAND_5;
  reg [511:0] _RAND_6;
  reg [511:0] _RAND_7;
  reg [511:0] _RAND_8;
  reg [511:0] _RAND_9;
  reg [511:0] _RAND_10;
  reg [511:0] _RAND_11;
  reg [511:0] _RAND_12;
  reg [511:0] _RAND_13;
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
`endif // RANDOMIZE_REG_INIT
  wire [31:0] cursor_len = io_delay_cycle + 32'h1; // @[PkgDelay.scala 19:41]
  reg [31:0] cursor_head; // @[PkgDelay.scala 20:34]
  wire [31:0] _cursor_tail_T_1 = cursor_len - 32'h1; // @[PkgDelay.scala 21:46]
  reg [31:0] cursor_tail; // @[PkgDelay.scala 21:34]
  reg [511:0] data_queue_0; // @[PkgDelay.scala 22:33]
  reg [511:0] data_queue_1; // @[PkgDelay.scala 22:33]
  reg [511:0] data_queue_2; // @[PkgDelay.scala 22:33]
  reg [511:0] data_queue_3; // @[PkgDelay.scala 22:33]
  reg [511:0] data_queue_4; // @[PkgDelay.scala 22:33]
  reg [511:0] data_queue_5; // @[PkgDelay.scala 22:33]
  reg [511:0] data_queue_6; // @[PkgDelay.scala 22:33]
  reg [511:0] data_queue_7; // @[PkgDelay.scala 22:33]
  reg [511:0] data_queue_8; // @[PkgDelay.scala 22:33]
  reg [511:0] data_queue_9; // @[PkgDelay.scala 22:33]
  reg [511:0] data_queue_10; // @[PkgDelay.scala 22:33]
  reg [511:0] data_queue_11; // @[PkgDelay.scala 22:33]
  reg  data_queue_valid_0; // @[PkgDelay.scala 23:39]
  reg  data_queue_valid_1; // @[PkgDelay.scala 23:39]
  reg  data_queue_valid_2; // @[PkgDelay.scala 23:39]
  reg  data_queue_valid_3; // @[PkgDelay.scala 23:39]
  reg  data_queue_valid_4; // @[PkgDelay.scala 23:39]
  reg  data_queue_valid_5; // @[PkgDelay.scala 23:39]
  reg  data_queue_valid_6; // @[PkgDelay.scala 23:39]
  reg  data_queue_valid_7; // @[PkgDelay.scala 23:39]
  reg  data_queue_valid_8; // @[PkgDelay.scala 23:39]
  reg  data_queue_valid_9; // @[PkgDelay.scala 23:39]
  reg  data_queue_valid_10; // @[PkgDelay.scala 23:39]
  reg  data_queue_valid_11; // @[PkgDelay.scala 23:39]
  reg  state; // @[PkgDelay.scala 28:28]
  wire  _T = ~state; // @[Conditional.scala 37:30]
  wire  _T_3 = io_data_in_valid & io_data_in_ready; // @[PkgDelay.scala 31:52]
  wire  _T_5 = io_data_in_valid & io_data_in_ready & ~io_data_in_bits_last; // @[PkgDelay.scala 31:76]
  wire  _GEN_5 = 4'h1 == cursor_head[3:0] ? data_queue_valid_1 : data_queue_valid_0; // @[PkgDelay.scala 45:60 PkgDelay.scala 45:60]
  wire  _GEN_6 = 4'h2 == cursor_head[3:0] ? data_queue_valid_2 : _GEN_5; // @[PkgDelay.scala 45:60 PkgDelay.scala 45:60]
  wire  _GEN_7 = 4'h3 == cursor_head[3:0] ? data_queue_valid_3 : _GEN_6; // @[PkgDelay.scala 45:60 PkgDelay.scala 45:60]
  wire  _GEN_8 = 4'h4 == cursor_head[3:0] ? data_queue_valid_4 : _GEN_7; // @[PkgDelay.scala 45:60 PkgDelay.scala 45:60]
  wire  _GEN_9 = 4'h5 == cursor_head[3:0] ? data_queue_valid_5 : _GEN_8; // @[PkgDelay.scala 45:60 PkgDelay.scala 45:60]
  wire  _GEN_10 = 4'h6 == cursor_head[3:0] ? data_queue_valid_6 : _GEN_9; // @[PkgDelay.scala 45:60 PkgDelay.scala 45:60]
  wire  _GEN_11 = 4'h7 == cursor_head[3:0] ? data_queue_valid_7 : _GEN_10; // @[PkgDelay.scala 45:60 PkgDelay.scala 45:60]
  wire  _GEN_12 = 4'h8 == cursor_head[3:0] ? data_queue_valid_8 : _GEN_11; // @[PkgDelay.scala 45:60 PkgDelay.scala 45:60]
  wire  _GEN_13 = 4'h9 == cursor_head[3:0] ? data_queue_valid_9 : _GEN_12; // @[PkgDelay.scala 45:60 PkgDelay.scala 45:60]
  wire  _GEN_14 = 4'ha == cursor_head[3:0] ? data_queue_valid_10 : _GEN_13; // @[PkgDelay.scala 45:60 PkgDelay.scala 45:60]
  wire [511:0] _GEN_17 = 4'h1 == cursor_head[3:0] ? data_queue_1 : data_queue_0; // @[PkgDelay.scala 46:30 PkgDelay.scala 46:30]
  wire [511:0] _GEN_18 = 4'h2 == cursor_head[3:0] ? data_queue_2 : _GEN_17; // @[PkgDelay.scala 46:30 PkgDelay.scala 46:30]
  wire [511:0] _GEN_19 = 4'h3 == cursor_head[3:0] ? data_queue_3 : _GEN_18; // @[PkgDelay.scala 46:30 PkgDelay.scala 46:30]
  wire [511:0] _GEN_20 = 4'h4 == cursor_head[3:0] ? data_queue_4 : _GEN_19; // @[PkgDelay.scala 46:30 PkgDelay.scala 46:30]
  wire [511:0] _GEN_21 = 4'h5 == cursor_head[3:0] ? data_queue_5 : _GEN_20; // @[PkgDelay.scala 46:30 PkgDelay.scala 46:30]
  wire [511:0] _GEN_22 = 4'h6 == cursor_head[3:0] ? data_queue_6 : _GEN_21; // @[PkgDelay.scala 46:30 PkgDelay.scala 46:30]
  wire [511:0] _GEN_23 = 4'h7 == cursor_head[3:0] ? data_queue_7 : _GEN_22; // @[PkgDelay.scala 46:30 PkgDelay.scala 46:30]
  wire [511:0] _GEN_24 = 4'h8 == cursor_head[3:0] ? data_queue_8 : _GEN_23; // @[PkgDelay.scala 46:30 PkgDelay.scala 46:30]
  wire [511:0] _GEN_25 = 4'h9 == cursor_head[3:0] ? data_queue_9 : _GEN_24; // @[PkgDelay.scala 46:30 PkgDelay.scala 46:30]
  wire [511:0] _GEN_26 = 4'ha == cursor_head[3:0] ? data_queue_10 : _GEN_25; // @[PkgDelay.scala 46:30 PkgDelay.scala 46:30]
  wire  _GEN_28 = 4'h0 == cursor_head[3:0] ? 1'h0 : data_queue_valid_0; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire  _GEN_29 = 4'h1 == cursor_head[3:0] ? 1'h0 : data_queue_valid_1; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire  _GEN_30 = 4'h2 == cursor_head[3:0] ? 1'h0 : data_queue_valid_2; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire  _GEN_31 = 4'h3 == cursor_head[3:0] ? 1'h0 : data_queue_valid_3; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire  _GEN_32 = 4'h4 == cursor_head[3:0] ? 1'h0 : data_queue_valid_4; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire  _GEN_33 = 4'h5 == cursor_head[3:0] ? 1'h0 : data_queue_valid_5; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire  _GEN_34 = 4'h6 == cursor_head[3:0] ? 1'h0 : data_queue_valid_6; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire  _GEN_35 = 4'h7 == cursor_head[3:0] ? 1'h0 : data_queue_valid_7; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire  _GEN_36 = 4'h8 == cursor_head[3:0] ? 1'h0 : data_queue_valid_8; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire  _GEN_37 = 4'h9 == cursor_head[3:0] ? 1'h0 : data_queue_valid_9; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire  _GEN_38 = 4'ha == cursor_head[3:0] ? 1'h0 : data_queue_valid_10; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire  _GEN_39 = 4'hb == cursor_head[3:0] ? 1'h0 : data_queue_valid_11; // @[PkgDelay.scala 50:47 PkgDelay.scala 50:47 PkgDelay.scala 23:39]
  wire [31:0] _cursor_head_T_1 = cursor_head + 32'h1; // @[PkgDelay.scala 51:42]
  wire [31:0] _GEN_0 = _cursor_head_T_1 % cursor_len; // @[PkgDelay.scala 51:47]
  wire [31:0] _cursor_head_T_2 = _GEN_0[31:0]; // @[PkgDelay.scala 51:47]
  wire [31:0] _cursor_tail_T_3 = cursor_tail + 32'h1; // @[PkgDelay.scala 52:42]
  wire [31:0] _GEN_1 = _cursor_tail_T_3 % cursor_len; // @[PkgDelay.scala 52:47]
  wire [31:0] _cursor_tail_T_4 = _GEN_1[31:0]; // @[PkgDelay.scala 52:47]
  wire  _GEN_40 = io_data_out_ready ? _GEN_28 : data_queue_valid_0; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_41 = io_data_out_ready ? _GEN_29 : data_queue_valid_1; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_42 = io_data_out_ready ? _GEN_30 : data_queue_valid_2; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_43 = io_data_out_ready ? _GEN_31 : data_queue_valid_3; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_44 = io_data_out_ready ? _GEN_32 : data_queue_valid_4; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_45 = io_data_out_ready ? _GEN_33 : data_queue_valid_5; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_46 = io_data_out_ready ? _GEN_34 : data_queue_valid_6; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_47 = io_data_out_ready ? _GEN_35 : data_queue_valid_7; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_48 = io_data_out_ready ? _GEN_36 : data_queue_valid_8; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_49 = io_data_out_ready ? _GEN_37 : data_queue_valid_9; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_50 = io_data_out_ready ? _GEN_38 : data_queue_valid_10; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_51 = io_data_out_ready ? _GEN_39 : data_queue_valid_11; // @[PkgDelay.scala 49:38 PkgDelay.scala 23:39]
  wire  _GEN_54 = 4'h0 == cursor_tail[3:0] | _GEN_40; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  wire  _GEN_55 = 4'h1 == cursor_tail[3:0] | _GEN_41; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  wire  _GEN_56 = 4'h2 == cursor_tail[3:0] | _GEN_42; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  wire  _GEN_57 = 4'h3 == cursor_tail[3:0] | _GEN_43; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  wire  _GEN_58 = 4'h4 == cursor_tail[3:0] | _GEN_44; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  wire  _GEN_59 = 4'h5 == cursor_tail[3:0] | _GEN_45; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  wire  _GEN_60 = 4'h6 == cursor_tail[3:0] | _GEN_46; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  wire  _GEN_61 = 4'h7 == cursor_tail[3:0] | _GEN_47; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  wire  _GEN_62 = 4'h8 == cursor_tail[3:0] | _GEN_48; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  wire  _GEN_63 = 4'h9 == cursor_tail[3:0] | _GEN_49; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  wire  _GEN_64 = 4'ha == cursor_tail[3:0] | _GEN_50; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  wire  _GEN_65 = 4'hb == cursor_tail[3:0] | _GEN_51; // @[PkgDelay.scala 55:54 PkgDelay.scala 55:54]
  assign io_data_in_ready = io_data_out_ready; // @[PkgDelay.scala 17:25]
  assign io_data_out_valid = 4'hb == cursor_head[3:0] ? data_queue_valid_11 : _GEN_14; // @[PkgDelay.scala 45:60 PkgDelay.scala 45:60]
  assign io_data_out_bits_last = 1'h1; // @[PkgDelay.scala 47:30]
  assign io_data_out_bits_data = 4'hb == cursor_head[3:0] ? data_queue_11 : _GEN_26; // @[PkgDelay.scala 46:30 PkgDelay.scala 46:30]
  assign io_data_out_bits_keep = 64'hffffffffffffffff; // @[PkgDelay.scala 48:30]
  always @(posedge clock) begin
    if (reset) begin // @[PkgDelay.scala 20:34]
      cursor_head <= 32'h0; // @[PkgDelay.scala 20:34]
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      cursor_head <= _cursor_head_T_2; // @[PkgDelay.scala 51:28]
    end
    if (reset) begin // @[PkgDelay.scala 21:34]
      cursor_tail <= _cursor_tail_T_1; // @[PkgDelay.scala 21:34]
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      cursor_tail <= _cursor_tail_T_4; // @[PkgDelay.scala 52:28]
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_0 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'h0 == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_0 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_1 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'h1 == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_1 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_2 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'h2 == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_2 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_3 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'h3 == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_3 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_4 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'h4 == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_4 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_5 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'h5 == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_5 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_6 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'h6 == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_6 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_7 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'h7 == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_7 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_8 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'h8 == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_8 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_9 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'h9 == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_9 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_10 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'ha == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_10 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 22:33]
      data_queue_11 <= 512'h0; // @[PkgDelay.scala 22:33]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      if (4'hb == cursor_tail[3:0]) begin // @[PkgDelay.scala 56:48]
        data_queue_11 <= io_data_in_bits_data; // @[PkgDelay.scala 56:48]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_0 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_0 <= _GEN_54;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'h0 == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_0 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_1 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_1 <= _GEN_55;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'h1 == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_1 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_2 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_2 <= _GEN_56;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'h2 == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_2 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_3 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_3 <= _GEN_57;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'h3 == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_3 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_4 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_4 <= _GEN_58;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'h4 == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_4 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_5 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_5 <= _GEN_59;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'h5 == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_5 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_6 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_6 <= _GEN_60;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'h6 == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_6 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_7 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_7 <= _GEN_61;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'h7 == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_7 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_8 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_8 <= _GEN_62;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'h8 == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_8 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_9 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_9 <= _GEN_63;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'h9 == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_9 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_10 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_10 <= _GEN_64;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'ha == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_10 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 23:39]
      data_queue_valid_11 <= 1'h0; // @[PkgDelay.scala 23:39]
    end else if (_T & io_data_in_valid & io_data_in_ready) begin // @[PkgDelay.scala 54:76]
      data_queue_valid_11 <= _GEN_65;
    end else if (io_data_out_ready) begin // @[PkgDelay.scala 49:38]
      if (4'hb == cursor_head[3:0]) begin // @[PkgDelay.scala 50:47]
        data_queue_valid_11 <= 1'h0; // @[PkgDelay.scala 50:47]
      end
    end
    if (reset) begin // @[PkgDelay.scala 28:28]
      state <= 1'h0; // @[PkgDelay.scala 28:28]
    end else if (_T) begin // @[Conditional.scala 40:58]
      state <= _T_5;
    end else if (state) begin // @[Conditional.scala 39:67]
      if (_T_3 & io_data_in_bits_last) begin // @[PkgDelay.scala 38:105]
        state <= 1'h0; // @[PkgDelay.scala 39:38]
      end else begin
        state <= 1'h1; // @[PkgDelay.scala 41:38]
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
  cursor_head = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  cursor_tail = _RAND_1[31:0];
  _RAND_2 = {16{`RANDOM}};
  data_queue_0 = _RAND_2[511:0];
  _RAND_3 = {16{`RANDOM}};
  data_queue_1 = _RAND_3[511:0];
  _RAND_4 = {16{`RANDOM}};
  data_queue_2 = _RAND_4[511:0];
  _RAND_5 = {16{`RANDOM}};
  data_queue_3 = _RAND_5[511:0];
  _RAND_6 = {16{`RANDOM}};
  data_queue_4 = _RAND_6[511:0];
  _RAND_7 = {16{`RANDOM}};
  data_queue_5 = _RAND_7[511:0];
  _RAND_8 = {16{`RANDOM}};
  data_queue_6 = _RAND_8[511:0];
  _RAND_9 = {16{`RANDOM}};
  data_queue_7 = _RAND_9[511:0];
  _RAND_10 = {16{`RANDOM}};
  data_queue_8 = _RAND_10[511:0];
  _RAND_11 = {16{`RANDOM}};
  data_queue_9 = _RAND_11[511:0];
  _RAND_12 = {16{`RANDOM}};
  data_queue_10 = _RAND_12[511:0];
  _RAND_13 = {16{`RANDOM}};
  data_queue_11 = _RAND_13[511:0];
  _RAND_14 = {1{`RANDOM}};
  data_queue_valid_0 = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  data_queue_valid_1 = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  data_queue_valid_2 = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  data_queue_valid_3 = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  data_queue_valid_4 = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  data_queue_valid_5 = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  data_queue_valid_6 = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  data_queue_valid_7 = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  data_queue_valid_8 = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  data_queue_valid_9 = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  data_queue_valid_10 = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  data_queue_valid_11 = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  state = _RAND_26[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
