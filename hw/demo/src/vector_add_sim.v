`timescale 1ns / 1ps

module vec_add_sim;
    reg clk, rst;
    reg          io_start;
    wire         io_done;
    wire  [63:0]  io_pargs;
    wire  [63:0]  io_pdata;
    wire  [63:0]  io_pres;
    wire [31:0]  io_args_len;
    wire  [31:0]  io_data_len;
    wire [31:0]  io_ap_return;
    
    reg          io_mem_interface_aw_ready;
    wire         io_mem_interface_aw_valid;
    wire [32:0]  io_mem_interface_aw_bits_addr;
    wire [1:0]   io_mem_interface_aw_bits_burst;
    wire [3:0]   io_mem_interface_aw_bits_cache;
    wire [3:0]   io_mem_interface_aw_bits_len;
    wire         io_mem_interface_aw_bits_lock;
    wire [2:0]   io_mem_interface_aw_bits_prot;
    wire [3:0]   io_mem_interface_aw_bits_qos;
    wire [3:0]   io_mem_interface_aw_bits_region;
    wire [2:0]   io_mem_interface_aw_bits_size;
    reg         io_mem_interface_ar_ready;
    wire         io_mem_interface_ar_valid;
    wire [32:0]  io_mem_interface_ar_bits_addr;
    wire [1:0]   io_mem_interface_ar_bits_burst;
    wire [3:0]   io_mem_interface_ar_bits_cache;
    wire [3:0]   io_mem_interface_ar_bits_len;
    wire         io_mem_interface_ar_bits_lock;
    wire [2:0]   io_mem_interface_ar_bits_prot;
    wire [3:0]   io_mem_interface_ar_bits_qos;
    wire [3:0]   io_mem_interface_ar_bits_region;
    wire [2:0]   io_mem_interface_ar_bits_size;
    reg         io_mem_interface_w_ready;
    wire         io_mem_interface_w_valid;
    wire [255:0] io_mem_interface_w_bits_data;
    wire         io_mem_interface_w_bits_last;
    wire [31:0]  io_mem_interface_w_bits_strb;
    wire         io_mem_interface_r_ready;
    reg         io_mem_interface_r_valid;
    reg [255:0] io_mem_interface_r_bits_data;
    reg         io_mem_interface_r_bits_last;
    wire [1:0]   io_mem_interface_r_bits_resp;
    wire         io_mem_interface_b_ready;
    wire         io_mem_interface_b_valid;
    wire [1:0]   io_mem_interface_b_bits_resp;
  vector_add  vector_add(
  .clock(clk),
  .reset(rst),
  .io_start(io_start),
  .io_done(io_done),
  .io_pargs(io_pargs),
  .io_pdata(io_pdata),
  .io_pres(io_pres),
  .io_args_len(io_args_len),
  .io_data_len(io_data_len),
  .io_ap_return(io_ap_return),
  .io_m_axi_gmem_AWREADY(io_mem_interface_aw_ready),
  .io_m_axi_gmem_AWVALID(io_mem_interface_aw_valid),
  .io_m_axi_gmem_AWADDR(io_mem_interface_aw_bits_addr),
  .io_m_axi_gmem_AWBURST(io_mem_interface_aw_bits_burst),
  .io_m_axi_gmem_AWCACHE(io_mem_interface_aw_bits_cache),
  .io_m_axi_gmem_AWLEN(io_mem_interface_aw_bits_len),
  .io_m_axi_gmem_AWLOCK(io_mem_interface_aw_bits_lock),
  .io_m_axi_gmem_AWPROT(io_mem_interface_aw_bits_prot),
  .io_m_axi_gmem_AWQOS(io_mem_interface_aw_bits_qos),
  .io_m_axi_gmem_AWREGION(io_mem_interface_aw_bits_region),
  .io_m_axi_gmem_AWSIZE(io_mem_interface_aw_bits_size),
  .io_m_axi_gmem_ARREADY(io_mem_interface_ar_ready),
  .io_m_axi_gmem_ARVALID(io_mem_interface_ar_valid),
  .io_m_axi_gmem_ARADDR(io_mem_interface_ar_bits_addr),
  .io_m_axi_gmem_ARBURST(io_mem_interface_ar_bits_burst),
  .io_m_axi_gmem_ARCACHE(io_mem_interface_ar_bits_cache),
  .io_m_axi_gmem_ARLEN(io_mem_interface_ar_bits_len),
  .io_m_axi_gmem_ARLOCK(io_mem_interface_ar_bits_lock),
  .io_m_axi_gmem_ARPROT(io_mem_interface_ar_bits_prot),
  .io_m_axi_gmem_ARQOS(io_mem_interface_ar_bits_qos),
  .io_m_axi_gmem_ARREGION(io_mem_interface_ar_bits_region),
  .io_m_axi_gmem_ARSIZE(io_mem_interface_ar_bits_size),
  .io_m_axi_gmem_WREADY(io_mem_interface_w_ready),
  .io_m_axi_gmem_WVALID(io_mem_interface_w_valid),
  .io_m_axi_gmem_WDATA(io_mem_interface_w_bits_data),
  .io_m_axi_gmem_WLAST(io_mem_interface_w_bits_last),
  .io_m_axi_gmem_WSTRB(io_mem_interface_w_bits_strb),
  .io_m_axi_gmem_RREADY(io_mem_interface_r_ready),
  .io_m_axi_gmem_RVALID(io_mem_interface_r_valid),
  .io_m_axi_gmem_RDATA(io_mem_interface_r_bits_data),
  .io_m_axi_gmem_RLAST(io_mem_interface_r_bits_last),
  .io_m_axi_gmem_RRESP(io_mem_interface_r_bits_resp),
  .io_m_axi_gmem_BREADY(io_mem_interface_b_ready),
  .io_m_axi_gmem_BVALID(io_mem_interface_b_valid),
  .io_m_axi_gmem_BRESP(io_mem_interface_b_bits_resp)
);

    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0; 
        io_mem_interface_ar_ready =0;
	io_start =0;
	
    end
  
    assign io_pargs = 0;
    assign io_args_len = 32;
    assign io_pres = 256;
    assign io_data_len = 0;
    assign io_pdata =0;
    always #5 clk = ~clk; // clk
  
   
    initial begin
        #25
        for (int i = 0; i < 3; i = i + 1) begin
            io_start =1;
            wait(!io_done); 
	        @(posedge clk);
	        io_mem_interface_ar_ready = 1;
            wait(io_mem_interface_ar_ready && io_mem_interface_ar_valid)
            @(posedge clk);
            io_mem_interface_ar_ready = 0;
            io_mem_interface_r_valid =1;
            io_mem_interface_r_bits_data= 256'h0000001100000012000000130000001400000005000000060000000700000008;
            io_mem_interface_r_bits_last= 1'b1;
            wait(io_mem_interface_r_valid && io_mem_interface_r_ready);
            @(posedge clk);
            io_mem_interface_ar_ready = 1;
            io_mem_interface_r_valid =0;
	        wait(io_mem_interface_ar_ready && io_mem_interface_ar_valid)
            @(posedge clk);
            io_mem_interface_ar_ready = 0;
            io_mem_interface_r_valid =1;
            io_mem_interface_r_bits_data= 256'h0000000100000002000000030000000400000005000000060000000700000008;
            io_mem_interface_r_bits_last= 1'b0;
            wait(io_mem_interface_r_valid && io_mem_interface_r_valid);
            @(posedge clk);
            io_mem_interface_r_valid =1;
            io_mem_interface_r_bits_data= 256'h0000000100000002000000030000000400000005000000060000000700000008;
            io_mem_interface_r_bits_last= 1'b1;
            wait(io_mem_interface_r_valid && io_mem_interface_r_ready);
            @(posedge clk);
            io_mem_interface_r_valid =0;
            io_mem_interface_aw_ready =1;
            io_mem_interface_w_ready =1;
            wait(io_mem_interface_aw_valid && io_mem_interface_w_valid);
            @(posedge clk);
            io_mem_interface_aw_ready =0;
            io_mem_interface_w_ready =0;
      
        end
    end
    

    




endmodule