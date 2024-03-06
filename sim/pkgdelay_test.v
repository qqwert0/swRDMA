`timescale 1ns / 1ps

module core_sim;
    reg clk, rst;
    wire [31:0]  delay_cycle;
    wire io_data_in_ready,io_data_in_valid,io_data_in_bits_last;
    wire [511:0] io_data_in_bits_data;
    wire [63:0]  io_data_in_bits_keep;
    wire io_data_out_ready,io_data_out_valid,io_data_out_bits_last;
    wire [511:0] io_data_out_bits_data;
    wire [63:0]  io_data_out_bits_keep;

    PkgDelay delay_module(
        .clock(clk),
        .reset(rst),
        .io_delay_cycle(delay_cycle),
        .io_data_out_ready(io_data_out_ready),
        .io_data_out_valid(io_data_out_valid),
        .io_data_out_bits_last(io_data_out_bits_last),
        .io_data_out_bits_data(io_data_out_bits_data),
        .io_data_out_bits_keep(io_data_out_bits_keep),
        .io_data_in_ready(io_data_in_ready),
        .io_data_in_valid(io_data_in_valid),
        .io_data_in_bits_last(io_data_in_bits_last),
        .io_data_in_bits_data(io_data_in_bits_data),
        .io_data_in_bits_keep(io_data_in_bits_keep)
	)

    initial begin
        clk = 0;
        rst = 1;
        #2 rst = 0;
        #1 
        io_data_in_valid = 1'b1;
        io_data_in_bits_last = 1'b1;
        io_data_in_bits_data = 512'h1;
        io_data_in_bits_keep = 64'hffffffffffffffff;
        #1
        io_data_in_valid = 1'b1;
        io_data_in_bits_last = 1'b0;
        io_data_in_bits_data = 512'h2;
        io_data_in_bits_keep = 64'hffffffffffffffff;
        #1
        io_data_in_valid = 1'b0;
        #1
        io_data_in_valid = 1'b1;
        io_data_in_bits_last = 1'b1;
        io_data_in_bits_data = 512'h3;
        io_data_in_bits_keep = 64'hffffffffffffffff;
        #1
        io_data_in_valid = 1'b0;

    end
    always #1 clk = ~clk;

   assign delay_cycle = 32'd10;
   assign io_data_out_ready = 1'b1;






endmodule