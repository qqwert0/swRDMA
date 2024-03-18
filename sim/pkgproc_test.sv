`timescale 1ns / 1ps

module core_sim;
    reg clk, rst;
    wire         io_data_in_ready;
    reg          io_data_in_valid;
    reg          io_data_in_bits_last;
    reg  [511:0] io_data_in_bits_data;
    wire  [63:0]  io_data_in_bits_keep;
    wire  [31:0]  io_upload_length;
    wire  [63:0]  io_upload_vaddr;
    wire [31:0]  io_idle_cycle;
    wire         io_q_time_out_ready;
    wire         io_q_time_out_valid;
    wire [511:0] io_q_time_out_bits;


    assign io_upload_length = 32'h5;
    assign io_upload_vaddr = 64'b0;
    assign io_data_in_bits_keep = 64'hffffffffffffffff;
    PkgProc proc_module(
        .clock(clk),
        .reset(rst),
        .io_data_in_ready(io_data_in_ready),
        .io_data_in_valid(io_data_in_valid),
        .io_data_in_bits_last(io_data_in_bits_last),
        .io_data_in_bits_data(io_data_in_bits_data),
        .io_data_in_bits_keep(io_data_in_bits_keep),
        .io_upload_length(io_upload_length),
        .io_upload_vaddr(io_upload_vaddr),
        .io_idle_cycle(io_idle_cycle),
        .io_q_time_out_ready(io_q_time_out_ready),
        .io_q_time_out_valid(io_q_time_out_valid),
        .io_q_time_out_bits(io_q_time_out_bits)
    );

    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0; 
        io_data_in_valid = 0;
    end
  
    bit [511:0] pkg_enqueue_3;
    bit [511:0] pkg_enqueue_12;
    pkg_enqueue_3 = 512'h00000000_00000011_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
    pkg_enqueue_3 = 512'h00000000_00001100_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
    always #5 clk = ~clk; // clk
  
   
    initial begin
        #15
        for (int i = 0; i < 15; i = i + 1) begin
            wait(io_data_in_ready); // 等待模块准备好
            @(posedge clk);
            io_data_in_valid = 1; // 有效数据
            io_data_in_bits_last = 1;
            if(i <=3) begin
                io_data_in_bits_data = pkg_enqueue_3+i;
            end
            else if(i <= 6)begin
                io_data_in_bits_data = pkg_enqueue_12+i;
            end
            else begin
                io_data_in_bits_data = pkg_enqueue_3+i;
            end
      
            #10;
            io_data_in_valid = 0;
      
            
        end
    end




endmodule