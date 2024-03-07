`timescale 1ns / 1ps

module core_sim;
    reg clk, rst;
    wire         io_infor_in_ready,
    wire         io_infor_in_valid,
    wire [32:0]  io_infor_in_bits_addr_read,
    wire [31:0]  io_infor_in_bits_len_read,
    wire [32:0]  io_infor_in_bits_addr_write,
    wire [31:0]  io_infor_in_bits_len_write,
    wire         io_mem_interface_aw_ready,
    wire         io_mem_interface_aw_valid,
    wire [32:0]  io_mem_interface_aw_bits_addr, 
    wire [1:0]   io_mem_interface_aw_bits_burst,
    wire [3:0]   io_mem_interface_aw_bits_cache,
    wire [5:0]   io_mem_interface_aw_bits_id,
    wire [3:0]   io_mem_interface_aw_bits_len,
    wire         io_mem_interface_aw_bits_lock,
    wire [2:0]   io_mem_interface_aw_bits_prot,
    wire [3:0]   io_mem_interface_aw_bits_qos,
    wire [3:0]   io_mem_interface_aw_bits_region,
    wire [2:0]   io_mem_interface_aw_bits_size,
    wire         io_mem_interface_ar_ready,
    wire         io_mem_interface_ar_valid,
    wire [32:0]  io_mem_interface_ar_bits_addr,
    wire [1:0]   io_mem_interface_ar_bits_burst,
    wire [3:0]   io_mem_interface_ar_bits_cache,
    wire [5:0]   io_mem_interface_ar_bits_id,
    wire [3:0]   io_mem_interface_ar_bits_len,
    wire         io_mem_interface_ar_bits_lock,
    wire [2:0]   io_mem_interface_ar_bits_prot,
    wire [3:0]   io_mem_interface_ar_bits_qos,
    wire [3:0]   io_mem_interface_ar_bits_region,
    wire [2:0]   io_mem_interface_ar_bits_size,
    wire         io_mem_interface_w_ready,
    wire         io_mem_interface_w_valid,
    wire [255:0] io_mem_interface_w_bits_data,
    wire         io_mem_interface_w_bits_last,
    wire [31:0]  io_mem_interface_w_bits_strb,
    wire         io_mem_interface_r_ready,
    wire         io_mem_interface_r_valid,
    wire [255:0] io_mem_interface_r_bits_data,
    wire         io_mem_interface_r_bits_last,
    wire [1:0]   io_mem_interface_r_bits_resp,
    wire [5:0]   io_mem_interface_r_bits_id,
    wire         io_mem_interface_b_ready,
    wire         io_mem_interface_b_valid,
    wire [5:0]   io_mem_interface_b_bits_id,
    wire [1:0]   io_mem_interface_b_bits_resp,
    wire         io_infor_out_ready,
    wire         io_infor_out_valid,
    wire         io_infor_out_bits,
  
  vector_add  vector_add(
  .clock(clk),
  .reset(rst),
  .io_infor_in_ready(io_infor_in_ready),
  .io_infor_in_valid(io_infor_in_valid),
  .io_infor_in_bits_addr_read(io_infor_in_bits_addr_read),
  .io_infor_in_bits_len_read(io_infor_in_bits_len_read),
  .io_infor_in_bits_addr_write(io_infor_in_bits_addr_write),
  .io_infor_in_bits_len_write(io_infor_in_bits_len_write),
  .io_mem_interface_aw_ready(io_mem_interface_aw_ready),
  .io_mem_interface_aw_valid(io_mem_interface_aw_valid),
  .io_mem_interface_aw_bits_addr(io_mem_interface_aw_bits_addr),
  .io_mem_interface_aw_bits_burst(io_mem_interface_aw_bits_burst),
  .io_mem_interface_aw_bits_cache(io_mem_interface_aw_bits_cache),
  .io_mem_interface_aw_bits_id(io_mem_interface_aw_bits_id),
  .io_mem_interface_aw_bits_len(io_mem_interface_aw_bits_len),
  .io_mem_interface_aw_bits_lock(io_mem_interface_aw_bits_lock),
  .io_mem_interface_aw_bits_prot(io_mem_interface_aw_bits_prot),
  .io_mem_interface_aw_bits_qos(io_mem_interface_aw_bits_qos),
  .io_mem_interface_aw_bits_region(io_mem_interface_aw_bits_region),
  .io_mem_interface_aw_bits_size(io_mem_interface_aw_bits_size),
  .io_mem_interface_ar_ready(io_mem_interface_ar_ready),
  .io_mem_interface_ar_valid(io_mem_interface_ar_valid),
  .io_mem_interface_ar_bits_addr(io_mem_interface_ar_bits_addr),
  .io_mem_interface_ar_bits_burst(io_mem_interface_ar_bits_burst),
  .io_mem_interface_ar_bits_cache(io_mem_interface_ar_bits_cache),
  .io_mem_interface_ar_bits_id(io_mem_interface_ar_bits_id),
  .io_mem_interface_ar_bits_len(io_mem_interface_ar_bits_len),
  .io_mem_interface_ar_bits_lock(io_mem_interface_ar_bits_lock),
  .io_mem_interface_ar_bits_prot(io_mem_interface_ar_bits_prot),
  .io_mem_interface_ar_bits_qos(io_mem_interface_ar_bits_qos),
  .io_mem_interface_ar_bits_region(io_mem_interface_ar_bits_region),
  .io_mem_interface_ar_bits_size(io_mem_interface_ar_bits_size),
  .io_mem_interface_w_ready(io_mem_interface_w_ready),
  .io_mem_interface_w_valid(io_mem_interface_w_valid),
  .io_mem_interface_w_bits_data(io_mem_interface_w_bits_data),
  .io_mem_interface_w_bits_last(io_mem_interface_w_bits_last),
  .io_mem_interface_w_bits_strb(io_mem_interface_w_bits_strb),
  .io_mem_interface_r_ready(io_mem_interface_r_ready),
  .io_mem_interface_r_valid(io_mem_interface_r_valid),
  .io_mem_interface_r_bits_data(io_mem_interface_r_bits_data),
  .io_mem_interface_r_bits_last(io_mem_interface_r_bits_last),
  .io_mem_interface_r_bits_resp(io_mem_interface_r_bits_resp),
  .io_mem_interface_r_bits_id(io_mem_interface_r_bits_id),
  .io_mem_interface_b_ready(io_mem_interface_b_ready),
  .io_mem_interface_b_valid(io_mem_interface_b_valid),
  .io_mem_interface_b_bits_id(io_mem_interface_b_bits_id),
  .io_mem_interface_b_bits_resp(io_mem_interface_b_bits_resp),
  .io_infor_out_ready(io_infor_out_ready),
  .io_infor_out_valid(io_infor_out_valid),
  .io_infor_out_bit(io_infor_out_bit)
);

    initial begin
        clk = 0;
        rst = 1;
        #2 rst = 0;
        #2
        io_infor_in_valid = 1;
        io_infor_out_bits_addr_read = 0;
        io_infor_out_bits_len_read = 64;
        io_infor_out_bits_addr_write = 256;
        io_infor_out_bits_len_write = 64;
        #2
        io_mem_interface_ar_ready = 1;
        #2
        io_mem_interface_r_valid = 1;
        io_mem_interface_r_bits_data = 256'h0000000100000002000000030000000400000005000000060000000700000008;
        io_mem_interface_r_bits_last = 0;
        #2
        io_mem_interface_r_valid = 1;
        io_mem_interface_r_bits_data = 256'h0000000100000002000000030000000400000005000000060000000700000008;
        io_mem_interface_r_bits_last = 1; 
        #2
        io_mem_interface_w_ready = 1;
        io_mem_interface_aw_ready = 1;   
        #2
        io_infor_out_ready = 1;  


    end
    always #1 clk = ~clk;

    




endmodule