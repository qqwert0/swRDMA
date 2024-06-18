`timescale 1ns / 1ps

module pkgdelay_sim;
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
        #10 rst = 0; 
        io_data_in_valid = 0;
    end
  
    bit [511:0] pkg_enqueue_3;
    bit [511:0] pkg_enqueue_12;
    io_data_in_bits_keep = 64'h0000000000000000;
    assign pkg_enqueue_3 = 512'h00000001_00000011_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
    assign pkg_enqueue_12 = 512'h00000002_00001100_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
    always #5 clk = ~clk; // clk
  
   
    initial begin
        #15
        for (int i = 0; i < 15; i = i + 1) begin
            io_data_in_valid = 1; // 有效数据
            io_data_in_bits_last = 0;
            io_data_in_bits_data = pkg_enqueue_3+i;
            wait(io_data_in_ready&& io_data_in_valid); // 等待模块准备好
            @(posedge clk);
            io_data_in_valid = 1;
            io_data_in_bits_data = pkg_enqueue_12+i;
            io_data_in_bits_last = 1;
            wait(io_data_in_ready&& io_data_in_valid);
            @(posedge clk);
            io_data_in_valid = 0;
            @(posedge clk);
            
      
        end
    end



endmodule