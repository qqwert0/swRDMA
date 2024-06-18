`timescale 1ns / 1ns
module tb_add_process_sim(

    );

reg                 clock                         =0;
reg                 reset                         =0;
wire                io_meta_in_ready              ;
reg                 io_meta_in_valid              =0;
reg       [7:0]     io_meta_in_bits_op_code       =0;
reg       [23:0]    io_meta_in_bits_qpn           =0;
reg       [23:0]    io_meta_in_bits_psn           =0;
reg                 io_meta_in_bits_ecn           =0;
reg       [63:0]    io_meta_in_bits_l_vaddr       =0;
reg       [63:0]    io_meta_in_bits_r_vaddr       =0;
reg       [31:0]    io_meta_in_bits_msg_length    =0;
reg       [31:0]    io_meta_in_bits_pkg_length    =0;
reg       [3:0]     io_meta_in_bits_header_len    =0;
reg       [351:0]   io_meta_in_bits_user_define   =0;
wire                io_reth_data_in_ready         ;
reg                 io_reth_data_in_valid         =0;
reg                 io_reth_data_in_bits_last     =0;
reg       [511:0]   io_reth_data_in_bits_data     =0;
reg       [63:0]    io_reth_data_in_bits_keep     =0;
wire                io_aeth_data_in_ready         ;
reg                 io_aeth_data_in_valid         =0;
reg                 io_aeth_data_in_bits_last     =0;
reg       [511:0]   io_aeth_data_in_bits_data     =0;
reg       [63:0]    io_aeth_data_in_bits_keep     =0;
wire                io_raw_data_in_ready          ;
reg                 io_raw_data_in_valid          =0;
reg                 io_raw_data_in_bits_last      =0;
reg       [511:0]   io_raw_data_in_bits_data      =0;
reg       [63:0]    io_raw_data_in_bits_keep      =0;
wire                io_conn_state_ready           ;
reg                 io_conn_state_valid           =0;
reg       [23:0]    io_conn_state_bits_remote_qpn =0;
reg       [31:0]    io_conn_state_bits_remote_ip  =0;
reg       [15:0]    io_conn_state_bits_remote_udp_port=0;
reg       [23:0]    io_conn_state_bits_rx_epsn    =0;
reg       [23:0]    io_conn_state_bits_tx_npsn    =0;
reg       [23:0]    io_conn_state_bits_rx_old_unack=0;
reg       [31:0]    io_local_ip_address           =0;
reg                 io_meta_out_ready             =0;
wire                io_meta_out_valid             ;
wire      [7:0]     io_meta_out_bits_op_code      ;
wire      [23:0]    io_meta_out_bits_qpn          ;
wire      [23:0]    io_meta_out_bits_psn          ;
wire                io_meta_out_bits_ecn          ;
wire      [63:0]    io_meta_out_bits_vaddr        ;
wire      [31:0]    io_meta_out_bits_pkg_length   ;
wire      [31:0]    io_meta_out_bits_msg_length   ;
wire      [351:0]   io_meta_out_bits_user_define  ;
reg                 io_reth_data_out_ready        =0;
wire                io_reth_data_out_valid        ;
wire                io_reth_data_out_bits_last    ;
wire      [511:0]   io_reth_data_out_bits_data    ;
wire      [63:0]    io_reth_data_out_bits_keep    ;
reg                 io_aeth_data_out_ready        =0;
wire                io_aeth_data_out_valid        ;
wire                io_aeth_data_out_bits_last    ;
wire      [511:0]   io_aeth_data_out_bits_data    ;
wire      [63:0]    io_aeth_data_out_bits_keep    ;
reg                 io_raw_data_out_ready         =0;
wire                io_raw_data_out_valid         ;
wire                io_raw_data_out_bits_last     ;
wire      [511:0]   io_raw_data_out_bits_data     ;
wire      [63:0]    io_raw_data_out_bits_keep     ;

IN#(605)in_io_meta_in(
        clock,
        reset,
        {io_meta_in_bits_op_code,io_meta_in_bits_qpn,io_meta_in_bits_psn,io_meta_in_bits_ecn,io_meta_in_bits_l_vaddr,io_meta_in_bits_r_vaddr,io_meta_in_bits_msg_length,io_meta_in_bits_pkg_length,io_meta_in_bits_header_len,io_meta_in_bits_user_define},
        io_meta_in_valid,
        io_meta_in_ready
);
// op_code, qpn, psn, ecn, l_vaddr, r_vaddr, msg_length, pkg_length, header_len, user_define
// 8'h0, 24'h0, 24'h0, 1'h0, 64'h0, 64'h0, 32'h0, 32'h0, 4'h0, 352'h0

IN#(577)in_io_reth_data_in(
        clock,
        reset,
        {io_reth_data_in_bits_last,io_reth_data_in_bits_data,io_reth_data_in_bits_keep},
        io_reth_data_in_valid,
        io_reth_data_in_ready
);
// last, data, keep
// 1'h0, 512'h0, 64'h0

IN#(577)in_io_aeth_data_in(
        clock,
        reset,
        {io_aeth_data_in_bits_last,io_aeth_data_in_bits_data,io_aeth_data_in_bits_keep},
        io_aeth_data_in_valid,
        io_aeth_data_in_ready
);
// last, data, keep
// 1'h0, 512'h0, 64'h0

IN#(577)in_io_raw_data_in(
        clock,
        reset,
        {io_raw_data_in_bits_last,io_raw_data_in_bits_data,io_raw_data_in_bits_keep},
        io_raw_data_in_valid,
        io_raw_data_in_ready
);
// last, data, keep
// 1'h0, 512'h0, 64'h0

IN#(144)in_io_conn_state(
        clock,
        reset,
        {io_conn_state_bits_remote_qpn,io_conn_state_bits_remote_ip,io_conn_state_bits_remote_udp_port,io_conn_state_bits_rx_epsn,io_conn_state_bits_tx_npsn,io_conn_state_bits_rx_old_unack},
        io_conn_state_valid,
        io_conn_state_ready
);
// remote_qpn, remote_ip, remote_udp_port, rx_epsn, tx_npsn, rx_old_unack
// 24'h0, 32'h0, 16'h0, 24'h0, 24'h0, 24'h0

OUT#(537)out_io_meta_out(
        clock,
        reset,
        {io_meta_out_bits_op_code,io_meta_out_bits_qpn,io_meta_out_bits_psn,io_meta_out_bits_ecn,io_meta_out_bits_vaddr,io_meta_out_bits_pkg_length,io_meta_out_bits_msg_length,io_meta_out_bits_user_define},
        io_meta_out_valid,
        io_meta_out_ready
);
// op_code, qpn, psn, ecn, vaddr, pkg_length, msg_length, user_define
// 8'h0, 24'h0, 24'h0, 1'h0, 64'h0, 32'h0, 32'h0, 352'h0

OUT#(577)out_io_reth_data_out(
        clock,
        reset,
        {io_reth_data_out_bits_last,io_reth_data_out_bits_data,io_reth_data_out_bits_keep},
        io_reth_data_out_valid,
        io_reth_data_out_ready
);
// last, data, keep
// 1'h0, 512'h0, 64'h0

OUT#(577)out_io_aeth_data_out(
        clock,
        reset,
        {io_aeth_data_out_bits_last,io_aeth_data_out_bits_data,io_aeth_data_out_bits_keep},
        io_aeth_data_out_valid,
        io_aeth_data_out_ready
);
// last, data, keep
// 1'h0, 512'h0, 64'h0

OUT#(577)out_io_raw_data_out(
        clock,
        reset,
        {io_raw_data_out_bits_last,io_raw_data_out_bits_data,io_raw_data_out_bits_keep},
        io_raw_data_out_valid,
        io_raw_data_out_ready
);
// last, data, keep
// 1'h0, 512'h0, 64'h0


add_process_sim add_process_sim_inst(
        .*
);

/*
op_code,qpn,psn,ecn,l_vaddr,r_vaddr,msg_length,pkg_length,header_len,user_define
in_io_meta_in.write({8'h0,24'h0,24'h0,1'h0,64'h0,64'h0,32'h0,32'h0,4'h0,352'h0});

last,data,keep
in_io_reth_data_in.write({1'h0,512'h0,64'h0});

last,data,keep
in_io_aeth_data_in.write({1'h0,512'h0,64'h0});

last,data,keep
in_io_raw_data_in.write({1'h0,512'h0,64'h0});

remote_qpn,remote_ip,remote_udp_port,rx_epsn,tx_npsn,rx_old_unack
in_io_conn_state.write({24'h0,32'h0,16'h0,24'h0,24'h0,24'h0});

*/

initial begin
        reset <= 1;
        clock = 1;
        #1000;
        reset <= 0;
        #100;
        out_io_meta_out.start();
        out_io_reth_data_out.start();
        out_io_aeth_data_out.start();
        out_io_raw_data_out.start();
        #50;
        //op_code,qpn,psn,ecn,l_vaddr,r_vaddr,msg_length,pkg_length,header_len,user_define
        in_io_meta_in.write({8'h0a,24'h01,24'h02,1'h0,64'h0,64'h3,32'h0,32'h0,4'h0,352'h0});
        //remote_qpn,remote_ip,remote_udp_port,rx_epsn,tx_npsn,rx_old_unack
        in_io_conn_state.write({24'h0,32'h0,16'h0,24'h0,24'h0,24'h0});
        // last,data,keep
//        in_io_reth_data_in.write({1'h0,512'h0,64'h0});
//        #200
        in_io_reth_data_in.write({1'h1,512'h0,64'h0});
        #200 
        //op_code,qpn,psn,ecn,l_vaddr,r_vaddr,msg_length,pkg_length,header_len,user_define
        in_io_meta_in.write({8'h0f,24'h4,24'h5,1'h0,64'h0,64'h6,32'h0,32'h0,4'h0,352'h0});
        //remote_qpn,remote_ip,remote_udp_port,rx_epsn,tx_npsn,rx_old_unack
        in_io_conn_state.write({24'h0,32'h0,16'h0,24'h0,24'h0,24'h0});
        //last,data,keep
//        in_io_aeth_data_in.write({1'h0,512'h0,64'h0});
//        #200
        in_io_aeth_data_in.write({1'h1,512'h0,64'h0});
        #200 
        //op_code,qpn,psn,ecn,l_vaddr,r_vaddr,msg_length,pkg_length,header_len,user_define
        in_io_meta_in.write({8'h07,24'h7,24'h8,1'h0,64'h0,64'h9,32'h0,32'h0,4'h0,352'h0});
        //remote_qpn,remote_ip,remote_udp_port,rx_epsn,tx_npsn,rx_old_unack
        in_io_conn_state.write({24'h0,32'h0,16'h0,24'h0,24'h0,24'h0});
        //last,data,keep
//        in_io_raw_data_in.write({1'h0,512'h0,64'h0});
//        #200
        in_io_raw_data_in.write({1'h1,512'h0,64'h0});
end

always #5 clock=~clock;
endmodule



