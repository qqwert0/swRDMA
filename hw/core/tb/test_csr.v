// To test CSR Module
module test_tb;

    reg clk;
    reg rst;
    wire io_has_event_rd;
    wire [31:0] io_event_recv_cnt;
    wire [31:0] io_event_processed_cnt;
    wire [31:0] io_event_type;
    wire  io_has_event_wr;
    reg  [31:0] io_user_csr_wr_0;
    reg  [31:0] io_user_csr_wr_1;
    reg  [31:0] io_user_csr_wr_31;

    wire [31:0] io_user_csr_rd_0;
    wire [31:0] io_user_csr_rd_1;
    wire [31:0] io_user_csr_rd_31;

    test_csr u0(
      .clock(clk),
      .reset(rst),
      .io_has_event_wr(io_has_event_wr),
      .io_has_event_rd(io_has_event_rd),
      .io_event_recv_cnt(io_event_recv_cnt),
      .io_event_processed_cnt(io_event_processed_cnt),
      .io_event_type(io_event_type),
      .io_user_csr_wr_0(io_user_csr_wr_0),
      .io_user_csr_wr_1(io_user_csr_wr_1),
      .io_user_csr_wr_31(io_user_csr_wr_31),
      .io_user_csr_rd_0(io_user_csr_rd_0),
      .io_user_csr_rd_1(io_user_csr_rd_1),
      .io_user_csr_rd_31(io_user_csr_rd_31)
    );

    assign io_has_event_wr = (io_has_event_rd == 0) && (io_event_recv_cnt == io_event_processed_cnt);

    initial begin
        clk = 0;
        rst = 1;
        io_user_csr_wr_0 = 1;
        io_user_csr_wr_1 = 2;
        io_user_csr_wr_31 = 3;
        #20;
        rst = 0;
        #130;io_user_csr_wr_31 = 5; 
        
    end
    
    always #5 clk = ~clk;
    
endmodule

/*
To test CSR module


test:
    add zero, zero, zero
    addi x10, x0, 0xF
    csrrw x10, 0x093, x10
    csrrw x1, 0x090, zero
    nop
    csrrs x2, 0x091, zero
    csrrs x3, 0x092, zero
    csrrw x1, 0x090, zero
    csrrw zero, 0x092, x2
    csrrs x4, 0x050, zero
    csrrw x5, 0x06F, zero   
    addi x7, zero, 5
    csrrw x6, 0x080, x7
    csrrs x7, 0x080, zero
    csrrw x6, 0x080, zero 
    addi x7, zero, 4
    csrrw x6, 0x081, x7
    csrrs x7, 0x081, zero
    csrrw x6, 0x081, zero 
    addi x7, zero, 3
    csrrw x6, 0x082, x7
    csrrs x7, 0x082, zero
    csrrw x6, 0x082, zero 
loop: jal loop
    nop
*/