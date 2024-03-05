`timescale 1ns / 1ps

module core_sim;
    reg clk, rst;
    wire io_start,io_data_out_ready,io_data_out_valid,io_data_out_bits_last;
    wire [31:0]  io_idle_cycle;
    wire [511:0] io_data_out_bits_data;
    wire [63:0]  io_data_out_bits_keep;

    PkgGen generator( 
        .clock(clk),
        .reset(rst),
        .io_start(io_start),
        .io_idle_cycle(io_idle_cycle),
        .io_data_out_ready(io_data_out_ready),
        .io_data_out_valid(io_data_out_valid),
        .io_data_out_bits_last(io_data_out_bits_last),
        .io_data_out_bits_data(io_data_out_bits_data),
        .io_data_out_bits_keep(io_data_out_bits_keep)
    );

    initial begin
        clk = 0;
        rst = 1;
        #2 rst = 0;
    end
    always #1 clk = ~clk;

   assign io_start = 1'b1;
   assign io_idle_cycle = 32'd10;
   assign io_data_out_ready = 1'b1;




endmodule