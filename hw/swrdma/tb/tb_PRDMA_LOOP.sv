`timescale 1ns / 1ps

module tb_rdma_config_init(

    );

    reg[159:0]   rdma_config[0:127];
    reg[15:0]   qpn_nums = 1;
    reg[15:0]   rdma_cmd_nums = 4; 
    reg[15:0]   mem_block_nums = 1;
    reg[15:0]   check_mem_nums = 2;
    integer i;

    initial begin
        rdma_config[0] = {96'h0,check_mem_nums,mem_block_nums,rdma_cmd_nums,qpn_nums};
        rdma_config[1] = {32'd0,32'd3,32'h100000,32'd960,32'd1};//res,offset,length,start_addr,node_idx
        rdma_config[2] = {32'h1000,48'd0,48'd0,24'd1,2'd1,2'd0};//length, r_addr, l_vaddr, l_qpn, rdma_cmd: 0:read 1:writre, node_idx 

        rdma_config[3] = {32'h40,48'h0,48'd0,24'd2,2'd1,2'd0};
        rdma_config[4] = {32'h800,48'h0,48'd0,24'd2,2'd1,2'd1};
        rdma_config[5] = {32'h40,48'd0,48'd0,24'd1,2'd1,2'd1};
        
       

        rdma_config[6] = {32'd0,32'd3,32'h100000,32'd64,32'd0};


        rdma_config[7] = {32'd0,32'd3,32'h100000,32'h200000,32'd0};    
        $writememh("config_big_rd_wr.hex",rdma_config);
    end


endmodule

module tb_PRDMA_LOOP(

    );

reg                 clock                         =0;
reg                 reset                         =0;
wire                io_s_tx_meta_0_ready          ;
reg                 io_s_tx_meta_0_valid          =0;
reg       [1:0]     io_s_tx_meta_0_bits_rdma_cmd  =0;
reg       [31:0]    io_s_tx_meta_0_bits_qpn_num   =0;
reg       [31:0]    io_s_tx_meta_0_bits_msg_num_per_qpn=0;
reg       [47:0]    io_s_tx_meta_0_bits_local_vaddr=0;
reg       [47:0]    io_s_tx_meta_0_bits_remote_vaddr=0;
reg       [31:0]    io_s_tx_meta_0_bits_length    =0;
wire                io_s_tx_meta_1_ready          ;
reg                 io_s_tx_meta_1_valid          =0;
reg       [1:0]     io_s_tx_meta_1_bits_rdma_cmd  =0;
reg       [31:0]    io_s_tx_meta_1_bits_qpn_num   =0;
reg       [31:0]    io_s_tx_meta_1_bits_msg_num_per_qpn=0;
reg       [47:0]    io_s_tx_meta_1_bits_local_vaddr=0;
reg       [47:0]    io_s_tx_meta_1_bits_remote_vaddr=0;
reg       [31:0]    io_s_tx_meta_1_bits_length    =0;
reg                 io_m_mem_read_cmd_0_ready     =0;
wire                io_m_mem_read_cmd_0_valid     ;
wire      [63:0]    io_m_mem_read_cmd_0_bits_vaddr;
wire      [31:0]    io_m_mem_read_cmd_0_bits_length;
reg                 io_m_mem_read_cmd_1_ready     =0;
wire                io_m_mem_read_cmd_1_valid     ;
wire      [63:0]    io_m_mem_read_cmd_1_bits_vaddr;
wire      [31:0]    io_m_mem_read_cmd_1_bits_length;
wire                io_s_mem_read_data_0_ready    ;
reg                 io_s_mem_read_data_0_valid    =0;
reg                 io_s_mem_read_data_0_bits_last=0;
reg       [511:0]   io_s_mem_read_data_0_bits_data=0;
reg       [63:0]    io_s_mem_read_data_0_bits_keep=0;
wire                io_s_mem_read_data_1_ready    ;
reg                 io_s_mem_read_data_1_valid    =0;
reg                 io_s_mem_read_data_1_bits_last=0;
reg       [511:0]   io_s_mem_read_data_1_bits_data=0;
reg       [63:0]    io_s_mem_read_data_1_bits_keep=0;
reg                 io_m_mem_write_cmd_0_ready    =0;
wire                io_m_mem_write_cmd_0_valid    ;
wire      [63:0]    io_m_mem_write_cmd_0_bits_vaddr;
wire      [31:0]    io_m_mem_write_cmd_0_bits_length;
reg                 io_m_mem_write_cmd_1_ready    =0;
wire                io_m_mem_write_cmd_1_valid    ;
wire      [63:0]    io_m_mem_write_cmd_1_bits_vaddr;
wire      [31:0]    io_m_mem_write_cmd_1_bits_length;
reg                 io_m_mem_write_data_0_ready   =0;
wire                io_m_mem_write_data_0_valid   ;
wire                io_m_mem_write_data_0_bits_last;
wire      [511:0]   io_m_mem_write_data_0_bits_data;
wire      [63:0]    io_m_mem_write_data_0_bits_keep;
reg                 io_m_mem_write_data_1_ready   =0;
wire                io_m_mem_write_data_1_valid   ;
wire                io_m_mem_write_data_1_bits_last;
wire      [511:0]   io_m_mem_write_data_1_bits_data;
wire      [63:0]    io_m_mem_write_data_1_bits_keep;
wire                io_qp_init_0_ready            ;
reg                 io_qp_init_0_valid            =0;
reg       [23:0]    io_qp_init_0_bits_qpn         =0;
reg       [23:0]    io_qp_init_0_bits_conn_state_remote_qpn=0;
reg       [31:0]    io_qp_init_0_bits_conn_state_remote_ip=0;
reg       [15:0]    io_qp_init_0_bits_conn_state_remote_udp_port=0;
reg       [23:0]    io_qp_init_0_bits_conn_state_rx_epsn=0;
reg       [23:0]    io_qp_init_0_bits_conn_state_tx_npsn=0;
reg       [23:0]    io_qp_init_0_bits_conn_state_rx_old_unack=0;
wire                io_qp_init_1_ready            ;
reg                 io_qp_init_1_valid            =0;
reg       [23:0]    io_qp_init_1_bits_qpn         =0;
reg       [23:0]    io_qp_init_1_bits_conn_state_remote_qpn=0;
reg       [31:0]    io_qp_init_1_bits_conn_state_remote_ip=0;
reg       [15:0]    io_qp_init_1_bits_conn_state_remote_udp_port=0;
reg       [23:0]    io_qp_init_1_bits_conn_state_rx_epsn=0;
reg       [23:0]    io_qp_init_1_bits_conn_state_tx_npsn=0;
reg       [23:0]    io_qp_init_1_bits_conn_state_rx_old_unack=0;
wire                io_cc_init_0_ready            ;
reg                 io_cc_init_0_valid            =0;
reg       [23:0]    io_cc_init_0_bits_qpn         =0;
reg       [31:0]    io_cc_init_0_bits_cc_state_credit=0;
reg       [31:0]    io_cc_init_0_bits_cc_state_rate=0;
reg       [31:0]    io_cc_init_0_bits_cc_state_timer=0;
reg       [31:0]    io_cc_init_0_bits_cc_state_divide_rate=0;
reg       [351:0]   io_cc_init_0_bits_cc_state_user_define=0;
reg                 io_cc_init_0_bits_cc_state_lock=0;
wire                io_cc_init_1_ready            ;
reg                 io_cc_init_1_valid            =0;
reg       [23:0]    io_cc_init_1_bits_qpn         =0;
reg       [31:0]    io_cc_init_1_bits_cc_state_credit=0;
reg       [31:0]    io_cc_init_1_bits_cc_state_rate=0;
reg       [31:0]    io_cc_init_1_bits_cc_state_timer=0;
reg       [31:0]    io_cc_init_1_bits_cc_state_divide_rate=0;
reg       [351:0]   io_cc_init_1_bits_cc_state_user_define=0;
reg                 io_cc_init_1_bits_cc_state_lock=0;
reg       [31:0]    io_local_ip_address_0         =0;
reg       [31:0]    io_local_ip_address_1         =0;
wire                io_arp_req_0_ready            ;
reg                 io_arp_req_0_valid            =0;
reg       [31:0]    io_arp_req_0_bits             =0;
wire                io_arp_req_1_ready            ;
reg                 io_arp_req_1_valid            =0;
reg       [31:0]    io_arp_req_1_bits             =0;
wire                io_arpinsert_0_ready          ;
reg                 io_arpinsert_0_valid          =0;
reg       [80:0]    io_arpinsert_0_bits           =0;
wire                io_arpinsert_1_ready          ;
reg                 io_arpinsert_1_valid          =0;
reg       [80:0]    io_arpinsert_1_bits           =0;
reg                 io_arp_rsp_0_ready            =0;
wire                io_arp_rsp_0_valid            ;
wire      [47:0]    io_arp_rsp_0_bits_mac_addr    ;
wire                io_arp_rsp_0_bits_hit         ;
reg                 io_arp_rsp_1_ready            =0;
wire                io_arp_rsp_1_valid            ;
wire      [47:0]    io_arp_rsp_1_bits_mac_addr    ;
wire                io_arp_rsp_1_bits_hit         ;
wire                io_axi0_0_aw_ready            ;
wire                io_axi0_0_aw_valid            ;
wire      [32:0]    io_axi0_0_aw_bits_addr        ;
wire      [1:0]     io_axi0_0_aw_bits_burst       ;
wire      [3:0]     io_axi0_0_aw_bits_cache       ;
wire      [5:0]     io_axi0_0_aw_bits_id          ;
wire      [3:0]     io_axi0_0_aw_bits_len         ;
wire                io_axi0_0_aw_bits_lock        ;
wire      [2:0]     io_axi0_0_aw_bits_prot        ;
wire      [3:0]     io_axi0_0_aw_bits_qos         ;
wire      [3:0]     io_axi0_0_aw_bits_region      ;
wire      [2:0]     io_axi0_0_aw_bits_size        ;
wire                io_axi0_0_ar_ready            ;
wire                io_axi0_0_ar_valid            ;
wire      [32:0]    io_axi0_0_ar_bits_addr        ;
wire      [1:0]     io_axi0_0_ar_bits_burst       ;
wire      [3:0]     io_axi0_0_ar_bits_cache       ;
wire      [5:0]     io_axi0_0_ar_bits_id          ;
wire      [3:0]     io_axi0_0_ar_bits_len         ;
wire                io_axi0_0_ar_bits_lock        ;
wire      [2:0]     io_axi0_0_ar_bits_prot        ;
wire      [3:0]     io_axi0_0_ar_bits_qos         ;
wire      [3:0]     io_axi0_0_ar_bits_region      ;
wire      [2:0]     io_axi0_0_ar_bits_size        ;
wire                io_axi0_0_w_ready             ;
wire                io_axi0_0_w_valid             ;
wire      [255:0]   io_axi0_0_w_bits_data         ;
wire                io_axi0_0_w_bits_last         ;
wire      [31:0]    io_axi0_0_w_bits_strb         ;
wire                io_axi0_0_r_ready             ;
wire                 io_axi0_0_r_valid             ;
wire       [255:0]   io_axi0_0_r_bits_data         ;
wire                 io_axi0_0_r_bits_last         ;
wire       [1:0]     io_axi0_0_r_bits_resp         ;
wire       [5:0]     io_axi0_0_r_bits_id           ;
wire                io_axi0_0_b_ready             ;
wire                 io_axi0_0_b_valid             ;
wire       [5:0]     io_axi0_0_b_bits_id           ;
wire       [1:0]     io_axi0_0_b_bits_resp         ;
wire                 io_axi0_1_aw_ready            ;
wire                io_axi0_1_aw_valid            ;
wire      [32:0]    io_axi0_1_aw_bits_addr        ;
wire      [1:0]     io_axi0_1_aw_bits_burst       ;
wire      [3:0]     io_axi0_1_aw_bits_cache       ;
wire      [5:0]     io_axi0_1_aw_bits_id          ;
wire      [3:0]     io_axi0_1_aw_bits_len         ;
wire                io_axi0_1_aw_bits_lock        ;
wire      [2:0]     io_axi0_1_aw_bits_prot        ;
wire      [3:0]     io_axi0_1_aw_bits_qos         ;
wire      [3:0]     io_axi0_1_aw_bits_region      ;
wire      [2:0]     io_axi0_1_aw_bits_size        ;
wire                 io_axi0_1_ar_ready            ;
wire                io_axi0_1_ar_valid            ;
wire      [32:0]    io_axi0_1_ar_bits_addr        ;
wire      [1:0]     io_axi0_1_ar_bits_burst       ;
wire      [3:0]     io_axi0_1_ar_bits_cache       ;
wire      [5:0]     io_axi0_1_ar_bits_id          ;
wire      [3:0]     io_axi0_1_ar_bits_len         ;
wire                io_axi0_1_ar_bits_lock        ;
wire      [2:0]     io_axi0_1_ar_bits_prot        ;
wire      [3:0]     io_axi0_1_ar_bits_qos         ;
wire      [3:0]     io_axi0_1_ar_bits_region      ;
wire      [2:0]     io_axi0_1_ar_bits_size        ;
wire                 io_axi0_1_w_ready             ;
wire                io_axi0_1_w_valid             ;
wire      [255:0]   io_axi0_1_w_bits_data         ;
wire                io_axi0_1_w_bits_last         ;
wire      [31:0]    io_axi0_1_w_bits_strb         ;
wire                io_axi0_1_r_ready             ;
wire                 io_axi0_1_r_valid             ;
wire       [255:0]   io_axi0_1_r_bits_data         ;
wire                 io_axi0_1_r_bits_last         ;
wire       [1:0]     io_axi0_1_r_bits_resp         ;
wire       [5:0]     io_axi0_1_r_bits_id           ;
wire                io_axi0_1_b_ready             ;
wire                 io_axi0_1_b_valid             ;
wire       [5:0]     io_axi0_1_b_bits_id           ;
wire       [1:0]     io_axi0_1_b_bits_resp         ;
wire                 io_axi1_0_aw_ready            ;
wire                io_axi1_0_aw_valid            ;
wire      [32:0]    io_axi1_0_aw_bits_addr        ;
wire      [1:0]     io_axi1_0_aw_bits_burst       ;
wire      [3:0]     io_axi1_0_aw_bits_cache       ;
wire      [5:0]     io_axi1_0_aw_bits_id          ;
wire      [3:0]     io_axi1_0_aw_bits_len         ;
wire                io_axi1_0_aw_bits_lock        ;
wire      [2:0]     io_axi1_0_aw_bits_prot        ;
wire      [3:0]     io_axi1_0_aw_bits_qos         ;
wire      [3:0]     io_axi1_0_aw_bits_region      ;
wire      [2:0]     io_axi1_0_aw_bits_size        ;
wire                 io_axi1_0_ar_ready            ;
wire                io_axi1_0_ar_valid            ;
wire      [32:0]    io_axi1_0_ar_bits_addr        ;
wire      [1:0]     io_axi1_0_ar_bits_burst       ;
wire      [3:0]     io_axi1_0_ar_bits_cache       ;
wire      [5:0]     io_axi1_0_ar_bits_id          ;
wire      [3:0]     io_axi1_0_ar_bits_len         ;
wire                io_axi1_0_ar_bits_lock        ;
wire      [2:0]     io_axi1_0_ar_bits_prot        ;
wire      [3:0]     io_axi1_0_ar_bits_qos         ;
wire      [3:0]     io_axi1_0_ar_bits_region      ;
wire      [2:0]     io_axi1_0_ar_bits_size        ;
wire                 io_axi1_0_w_ready             ;
wire                io_axi1_0_w_valid             ;
wire      [255:0]   io_axi1_0_w_bits_data         ;
wire                io_axi1_0_w_bits_last         ;
wire      [31:0]    io_axi1_0_w_bits_strb         ;
wire                io_axi1_0_r_ready             ;
wire                 io_axi1_0_r_valid             ;
wire       [255:0]   io_axi1_0_r_bits_data         ;
wire                 io_axi1_0_r_bits_last         ;
wire       [1:0]     io_axi1_0_r_bits_resp         ;
wire       [5:0]     io_axi1_0_r_bits_id           ;
wire                io_axi1_0_b_ready             ;
wire                 io_axi1_0_b_valid             ;
wire       [5:0]     io_axi1_0_b_bits_id           ;
wire       [1:0]     io_axi1_0_b_bits_resp         ;
wire                 io_axi1_1_aw_ready            ;
wire                io_axi1_1_aw_valid            ;
wire      [32:0]    io_axi1_1_aw_bits_addr        ;
wire      [1:0]     io_axi1_1_aw_bits_burst       ;
wire      [3:0]     io_axi1_1_aw_bits_cache       ;
wire      [5:0]     io_axi1_1_aw_bits_id          ;
wire      [3:0]     io_axi1_1_aw_bits_len         ;
wire                io_axi1_1_aw_bits_lock        ;
wire      [2:0]     io_axi1_1_aw_bits_prot        ;
wire      [3:0]     io_axi1_1_aw_bits_qos         ;
wire      [3:0]     io_axi1_1_aw_bits_region      ;
wire      [2:0]     io_axi1_1_aw_bits_size        ;
wire                 io_axi1_1_ar_ready            ;
wire                io_axi1_1_ar_valid            ;
wire      [32:0]    io_axi1_1_ar_bits_addr        ;
wire      [1:0]     io_axi1_1_ar_bits_burst       ;
wire      [3:0]     io_axi1_1_ar_bits_cache       ;
wire      [5:0]     io_axi1_1_ar_bits_id          ;
wire      [3:0]     io_axi1_1_ar_bits_len         ;
wire                io_axi1_1_ar_bits_lock        ;
wire      [2:0]     io_axi1_1_ar_bits_prot        ;
wire      [3:0]     io_axi1_1_ar_bits_qos         ;
wire      [3:0]     io_axi1_1_ar_bits_region      ;
wire      [2:0]     io_axi1_1_ar_bits_size        ;
wire                 io_axi1_1_w_ready             ;
wire                io_axi1_1_w_valid             ;
wire      [255:0]   io_axi1_1_w_bits_data         ;
wire                io_axi1_1_w_bits_last         ;
wire      [31:0]    io_axi1_1_w_bits_strb         ;
wire                io_axi1_1_r_ready             ;
wire                 io_axi1_1_r_valid             ;
wire       [255:0]   io_axi1_1_r_bits_data         ;
wire                 io_axi1_1_r_bits_last         ;
wire       [1:0]     io_axi1_1_r_bits_resp         ;
wire       [5:0]     io_axi1_1_r_bits_id           ;
wire                io_axi1_1_b_ready             ;
wire                 io_axi1_1_b_valid             ;
wire       [5:0]     io_axi1_1_b_bits_id           ;
wire       [1:0]     io_axi1_1_b_bits_resp         ;
reg                 io_cpu_started_0              =0;
reg                 io_cpu_started_1              =0;
reg       [31:0]    io_pkg_num_0                  =0;
reg       [31:0]    io_pkg_num_1                  =0;
wire      [31:0]    io_status_0                   ;
wire      [31:0]    io_status_1                   ;
wire      [31:0]    io_status_2                   ;
wire      [31:0]    io_status_3                   ;
wire      [31:0]    io_status_4                   ;
wire      [31:0]    io_status_5                   ;
wire      [31:0]    io_status_6                   ;
wire      [31:0]    io_status_7                   ;
wire      [31:0]    io_status_8                   ;
wire      [31:0]    io_status_9                   ;
wire      [31:0]    io_status_10                  ;
wire      [31:0]    io_status_11                  ;
wire      [31:0]    io_status_12                  ;
wire      [31:0]    io_status_13                  ;
wire      [31:0]    io_status_14                  ;
wire      [31:0]    io_status_15                  ;
wire      [31:0]    io_status_16                  ;
wire      [31:0]    io_status_17                  ;
wire      [31:0]    io_status_18                  ;
wire      [31:0]    io_status_19                  ;
wire      [31:0]    io_status_20                  ;
wire      [31:0]    io_status_21                  ;
wire      [31:0]    io_status_22                  ;
wire      [31:0]    io_status_23                  ;
wire      [31:0]    io_status_24                  ;
wire      [31:0]    io_status_25                  ;
wire      [31:0]    io_status_26                  ;
wire      [31:0]    io_status_27                  ;
wire      [31:0]    io_status_28                  ;
wire      [31:0]    io_status_29                  ;
wire      [31:0]    io_status_30                  ;
wire      [31:0]    io_status_31                  ;
wire      [31:0]    io_status_32                  ;
wire      [31:0]    io_status_33                  ;
wire      [31:0]    io_status_34                  ;
wire      [31:0]    io_status_35                  ;
wire      [31:0]    io_status_36                  ;
wire      [31:0]    io_status_37                  ;
wire      [31:0]    io_status_38                  ;
wire      [31:0]    io_status_39                  ;
wire      [31:0]    io_status_40                  ;
wire      [31:0]    io_status_41                  ;
wire      [31:0]    io_status_42                  ;
wire      [31:0]    io_status_43                  ;
wire      [31:0]    io_status_44                  ;
wire      [31:0]    io_status_45                  ;
wire      [31:0]    io_status_46                  ;
wire      [31:0]    io_status_47                  ;
wire      [31:0]    io_status_48                  ;
wire      [31:0]    io_status_49                  ;
wire      [31:0]    io_status_50                  ;
wire      [31:0]    io_status_51                  ;
wire      [31:0]    io_status_52                  ;
wire      [31:0]    io_status_53                  ;
wire      [31:0]    io_status_54                  ;
wire      [31:0]    io_status_55                  ;
wire      [31:0]    io_status_56                  ;
wire      [31:0]    io_status_57                  ;
wire      [31:0]    io_status_58                  ;
wire      [31:0]    io_status_59                  ;
wire      [31:0]    io_status_60                  ;
wire      [31:0]    io_status_61                  ;
wire      [31:0]    io_status_62                  ;
wire      [31:0]    io_status_63                  ;
wire      [31:0]    io_status_64                  ;
wire      [31:0]    io_status_65                  ;
wire      [31:0]    io_status_66                  ;
wire      [31:0]    io_status_67                  ;
wire      [31:0]    io_status_68                  ;
wire      [31:0]    io_status_69                  ;
wire      [31:0]    io_status_70                  ;
wire      [31:0]    io_status_71                  ;
wire      [31:0]    io_status_72                  ;
wire      [31:0]    io_status_73                  ;
wire      [31:0]    io_status_74                  ;
wire      [31:0]    io_status_75                  ;
wire      [31:0]    io_status_76                  ;
wire      [31:0]    io_status_77                  ;
wire      [31:0]    io_status_78                  ;
wire      [31:0]    io_status_79                  ;
wire      [31:0]    io_status_80                  ;
wire      [31:0]    io_status_81                  ;
wire      [31:0]    io_status_82                  ;
wire      [31:0]    io_status_83                  ;
wire      [31:0]    io_status_84                  ;
wire      [31:0]    io_status_85                  ;
wire      [31:0]    io_status_86                  ;
wire      [31:0]    io_status_87                  ;
wire      [31:0]    io_status_88                  ;
wire      [31:0]    io_status_89                  ;
wire      [31:0]    io_status_90                  ;
wire      [31:0]    io_status_91                  ;
wire      [31:0]    io_status_92                  ;
wire      [31:0]    io_status_93                  ;
wire      [31:0]    io_status_94                  ;
wire      [31:0]    io_status_95                  ;
wire      [31:0]    io_status_96                  ;
wire      [31:0]    io_status_97                  ;
wire      [31:0]    io_status_98                  ;
wire      [31:0]    io_status_99                  ;
wire      [31:0]    io_status_100                 ;
wire      [31:0]    io_status_101                 ;
wire      [31:0]    io_status_102                 ;
wire      [31:0]    io_status_103                 ;
wire      [31:0]    io_status_104                 ;
wire      [31:0]    io_status_105                 ;
wire      [31:0]    io_status_106                 ;
wire      [31:0]    io_status_107                 ;
wire      [31:0]    io_status_108                 ;
wire      [31:0]    io_status_109                 ;
wire      [31:0]    io_status_110                 ;
wire      [31:0]    io_status_111                 ;
wire      [31:0]    io_status_112                 ;
wire      [31:0]    io_status_113                 ;
wire      [31:0]    io_status_114                 ;
wire      [31:0]    io_status_115                 ;
wire      [31:0]    io_status_116                 ;
wire      [31:0]    io_status_117                 ;
wire      [31:0]    io_status_118                 ;
wire      [31:0]    io_status_119                 ;
wire      [31:0]    io_status_120                 ;
wire      [31:0]    io_status_121                 ;
wire      [31:0]    io_status_122                 ;
wire      [31:0]    io_status_123                 ;
wire      [31:0]    io_status_124                 ;
wire      [31:0]    io_status_125                 ;
wire      [31:0]    io_status_126                 ;
wire      [31:0]    io_status_127                 ;
wire      [31:0]    io_status_128                 ;
wire      [31:0]    io_status_129                 ;
wire      [31:0]    io_status_130                 ;
wire      [31:0]    io_status_131                 ;
wire      [31:0]    io_status_132                 ;
wire      [31:0]    io_status_133                 ;
wire      [31:0]    io_status_134                 ;
wire      [31:0]    io_status_135                 ;
wire      [31:0]    io_status_136                 ;
wire      [31:0]    io_status_137                 ;
wire      [31:0]    io_status_138                 ;
wire      [31:0]    io_status_139                 ;
wire      [31:0]    io_status_140                 ;
wire      [31:0]    io_status_141                 ;
wire      [31:0]    io_status_142                 ;
wire      [31:0]    io_status_143                 ;
wire      [31:0]    io_status_144                 ;
wire      [31:0]    io_status_145                 ;
wire      [31:0]    io_status_146                 ;
wire      [31:0]    io_status_147                 ;
wire      [31:0]    io_status_148                 ;
wire      [31:0]    io_status_149                 ;
wire      [31:0]    io_status_150                 ;
wire      [31:0]    io_status_151                 ;
wire      [31:0]    io_status_152                 ;
wire      [31:0]    io_status_153                 ;
wire      [31:0]    io_status_154                 ;
wire      [31:0]    io_status_155                 ;
wire      [31:0]    io_status_156                 ;
wire      [31:0]    io_status_157                 ;
wire      [31:0]    io_status_158                 ;
wire      [31:0]    io_status_159                 ;
wire      [31:0]    io_status_160                 ;
wire      [31:0]    io_status_161                 ;
wire      [31:0]    io_status_162                 ;
wire      [31:0]    io_status_163                 ;
wire      [31:0]    io_status_164                 ;
wire      [31:0]    io_status_165                 ;
wire      [31:0]    io_status_166                 ;
wire      [31:0]    io_status_167                 ;
wire      [31:0]    io_status_168                 ;
wire      [31:0]    io_status_169                 ;
wire      [31:0]    io_status_170                 ;
wire      [31:0]    io_status_171                 ;
wire      [31:0]    io_status_172                 ;
wire      [31:0]    io_status_173                 ;
wire      [31:0]    io_status_174                 ;
wire      [31:0]    io_status_175                 ;
wire      [31:0]    io_status_176                 ;
wire      [31:0]    io_status_177                 ;
wire      [31:0]    io_status_178                 ;
wire      [31:0]    io_status_179                 ;
wire      [31:0]    io_status_180                 ;
wire      [31:0]    io_status_181                 ;
wire      [31:0]    io_status_182                 ;
wire      [31:0]    io_status_183                 ;
wire      [31:0]    io_status_184                 ;
wire      [31:0]    io_status_185                 ;
wire      [31:0]    io_status_186                 ;
wire      [31:0]    io_status_187                 ;
wire      [31:0]    io_status_188                 ;
wire      [31:0]    io_status_189                 ;
wire      [31:0]    io_status_190                 ;
wire      [31:0]    io_status_191                 ;
wire      [31:0]    io_status_192                 ;
wire      [31:0]    io_status_193                 ;
wire      [31:0]    io_status_194                 ;
wire      [31:0]    io_status_195                 ;
wire      [31:0]    io_status_196                 ;
wire      [31:0]    io_status_197                 ;
wire      [31:0]    io_status_198                 ;
wire      [31:0]    io_status_199                 ;
wire      [31:0]    io_status_200                 ;
wire      [31:0]    io_status_201                 ;
wire      [31:0]    io_status_202                 ;
wire      [31:0]    io_status_203                 ;
wire      [31:0]    io_status_204                 ;
wire      [31:0]    io_status_205                 ;
wire      [31:0]    io_status_206                 ;
wire      [31:0]    io_status_207                 ;
wire      [31:0]    io_status_208                 ;
wire      [31:0]    io_status_209                 ;
wire      [31:0]    io_status_210                 ;
wire      [31:0]    io_status_211                 ;
wire      [31:0]    io_status_212                 ;
wire      [31:0]    io_status_213                 ;
wire      [31:0]    io_status_214                 ;
wire      [31:0]    io_status_215                 ;
wire      [31:0]    io_status_216                 ;
wire      [31:0]    io_status_217                 ;
wire      [31:0]    io_status_218                 ;
wire      [31:0]    io_status_219                 ;
wire      [31:0]    io_status_220                 ;
wire      [31:0]    io_status_221                 ;
wire      [31:0]    io_status_222                 ;
wire      [31:0]    io_status_223                 ;
wire      [31:0]    io_status_224                 ;
wire      [31:0]    io_status_225                 ;
wire      [31:0]    io_status_226                 ;
wire      [31:0]    io_status_227                 ;
wire      [31:0]    io_status_228                 ;
wire      [31:0]    io_status_229                 ;
wire      [31:0]    io_status_230                 ;
wire      [31:0]    io_status_231                 ;
wire      [31:0]    io_status_232                 ;
wire      [31:0]    io_status_233                 ;
wire      [31:0]    io_status_234                 ;
wire      [31:0]    io_status_235                 ;
wire      [31:0]    io_status_236                 ;
wire      [31:0]    io_status_237                 ;
wire      [31:0]    io_status_238                 ;
wire      [31:0]    io_status_239                 ;
wire      [31:0]    io_status_240                 ;
wire      [31:0]    io_status_241                 ;
wire      [31:0]    io_status_242                 ;
wire      [31:0]    io_status_243                 ;
wire      [31:0]    io_status_244                 ;
wire      [31:0]    io_status_245                 ;
wire      [31:0]    io_status_246                 ;
wire      [31:0]    io_status_247                 ;
wire      [31:0]    io_status_248                 ;
wire      [31:0]    io_status_249                 ;
wire      [31:0]    io_status_250                 ;
wire      [31:0]    io_status_251                 ;
wire      [31:0]    io_status_252                 ;
wire      [31:0]    io_status_253                 ;
wire      [31:0]    io_status_254                 ;
wire      [31:0]    io_status_255                 ;
wire      [31:0]    io_status_256                 ;
wire      [31:0]    io_status_257                 ;
wire      [31:0]    io_status_258                 ;
wire      [31:0]    io_status_259                 ;
wire      [31:0]    io_status_260                 ;
wire      [31:0]    io_status_261                 ;
wire      [31:0]    io_status_262                 ;
wire      [31:0]    io_status_263                 ;
wire      [31:0]    io_status_264                 ;
wire      [31:0]    io_status_265                 ;
wire      [31:0]    io_status_266                 ;
wire      [31:0]    io_status_267                 ;
wire      [31:0]    io_status_268                 ;
wire      [31:0]    io_status_269                 ;
wire      [31:0]    io_status_270                 ;
wire      [31:0]    io_status_271                 ;
wire      [31:0]    io_status_272                 ;
wire      [31:0]    io_status_273                 ;
wire      [31:0]    io_status_274                 ;
wire      [31:0]    io_status_275                 ;
wire      [31:0]    io_status_276                 ;
wire      [31:0]    io_status_277                 ;
wire      [31:0]    io_status_278                 ;
wire      [31:0]    io_status_279                 ;
wire      [31:0]    io_status_280                 ;
wire      [31:0]    io_status_281                 ;
wire      [31:0]    io_status_282                 ;
wire      [31:0]    io_status_283                 ;
wire      [31:0]    io_status_284                 ;
wire      [31:0]    io_status_285                 ;
wire      [31:0]    io_status_286                 ;
wire      [31:0]    io_status_287                 ;
wire      [31:0]    io_status_288                 ;
wire      [31:0]    io_status_289                 ;
wire      [31:0]    io_status_290                 ;
wire      [31:0]    io_status_291                 ;
wire      [31:0]    io_status_292                 ;
wire      [31:0]    io_status_293                 ;
wire      [31:0]    io_status_294                 ;
wire      [31:0]    io_status_295                 ;
wire      [31:0]    io_status_296                 ;
wire      [31:0]    io_status_297                 ;
wire      [31:0]    io_status_298                 ;
wire      [31:0]    io_status_299                 ;
wire      [31:0]    io_status_300                 ;
wire      [31:0]    io_status_301                 ;
wire      [31:0]    io_status_302                 ;
wire      [31:0]    io_status_303                 ;
wire      [31:0]    io_status_304                 ;
wire      [31:0]    io_status_305                 ;
wire      [31:0]    io_status_306                 ;
wire      [31:0]    io_status_307                 ;
wire      [31:0]    io_status_308                 ;
wire      [31:0]    io_status_309                 ;
wire      [31:0]    io_status_310                 ;
wire      [31:0]    io_status_311                 ;
wire      [31:0]    io_status_312                 ;
wire      [31:0]    io_status_313                 ;
wire      [31:0]    io_status_314                 ;
wire      [31:0]    io_status_315                 ;
wire      [31:0]    io_status_316                 ;
wire      [31:0]    io_status_317                 ;
wire      [31:0]    io_status_318                 ;
wire      [31:0]    io_status_319                 ;
wire      [31:0]    io_status_320                 ;
wire      [31:0]    io_status_321                 ;
wire      [31:0]    io_status_322                 ;
wire      [31:0]    io_status_323                 ;
wire      [31:0]    io_status_324                 ;
wire      [31:0]    io_status_325                 ;
wire      [31:0]    io_status_326                 ;
wire      [31:0]    io_status_327                 ;
wire      [31:0]    io_status_328                 ;
wire      [31:0]    io_status_329                 ;
wire      [31:0]    io_status_330                 ;
wire      [31:0]    io_status_331                 ;
wire      [31:0]    io_status_332                 ;
wire      [31:0]    io_status_333                 ;
wire      [31:0]    io_status_334                 ;
wire      [31:0]    io_status_335                 ;
wire      [31:0]    io_status_336                 ;
wire      [31:0]    io_status_337                 ;
wire      [31:0]    io_status_338                 ;
wire      [31:0]    io_status_339                 ;
wire      [31:0]    io_status_340                 ;
wire      [31:0]    io_status_341                 ;
wire      [31:0]    io_status_342                 ;
wire      [31:0]    io_status_343                 ;
wire      [31:0]    io_status_344                 ;
wire      [31:0]    io_status_345                 ;
wire      [31:0]    io_status_346                 ;
wire      [31:0]    io_status_347                 ;
wire      [31:0]    io_status_348                 ;
wire      [31:0]    io_status_349                 ;
wire      [31:0]    io_status_350                 ;
wire      [31:0]    io_status_351                 ;
wire      [31:0]    io_status_352                 ;
wire      [31:0]    io_status_353                 ;
wire      [31:0]    io_status_354                 ;
wire      [31:0]    io_status_355                 ;
wire      [31:0]    io_status_356                 ;
wire      [31:0]    io_status_357                 ;
wire      [31:0]    io_status_358                 ;
wire      [31:0]    io_status_359                 ;
wire      [31:0]    io_status_360                 ;
wire      [31:0]    io_status_361                 ;
wire      [31:0]    io_status_362                 ;
wire      [31:0]    io_status_363                 ;
wire      [31:0]    io_status_364                 ;
wire      [31:0]    io_status_365                 ;
wire      [31:0]    io_status_366                 ;
wire      [31:0]    io_status_367                 ;
wire      [31:0]    io_status_368                 ;
wire      [31:0]    io_status_369                 ;
wire      [31:0]    io_status_370                 ;
wire      [31:0]    io_status_371                 ;
wire      [31:0]    io_status_372                 ;
wire      [31:0]    io_status_373                 ;
wire      [31:0]    io_status_374                 ;
wire      [31:0]    io_status_375                 ;
wire      [31:0]    io_status_376                 ;
wire      [31:0]    io_status_377                 ;
wire      [31:0]    io_status_378                 ;
wire      [31:0]    io_status_379                 ;
wire      [31:0]    io_status_380                 ;
wire      [31:0]    io_status_381                 ;
wire      [31:0]    io_status_382                 ;
wire      [31:0]    io_status_383                 ;
wire      [31:0]    io_status_384                 ;
wire      [31:0]    io_status_385                 ;
wire      [31:0]    io_status_386                 ;
wire      [31:0]    io_status_387                 ;
wire      [31:0]    io_status_388                 ;
wire      [31:0]    io_status_389                 ;
wire      [31:0]    io_status_390                 ;
wire      [31:0]    io_status_391                 ;
wire      [31:0]    io_status_392                 ;
wire      [31:0]    io_status_393                 ;
wire      [31:0]    io_status_394                 ;
wire      [31:0]    io_status_395                 ;
wire      [31:0]    io_status_396                 ;
wire      [31:0]    io_status_397                 ;
wire      [31:0]    io_status_398                 ;
wire      [31:0]    io_status_399                 ;
wire      [31:0]    io_status_400                 ;
wire      [31:0]    io_status_401                 ;
wire      [31:0]    io_status_402                 ;
wire      [31:0]    io_status_403                 ;
wire      [31:0]    io_status_404                 ;
wire      [31:0]    io_status_405                 ;
wire      [31:0]    io_status_406                 ;
wire      [31:0]    io_status_407                 ;
wire      [31:0]    io_status_408                 ;
wire      [31:0]    io_status_409                 ;
wire      [31:0]    io_status_410                 ;
wire      [31:0]    io_status_411                 ;
wire      [31:0]    io_status_412                 ;
wire      [31:0]    io_status_413                 ;
wire      [31:0]    io_status_414                 ;
wire      [31:0]    io_status_415                 ;
wire      [31:0]    io_status_416                 ;
wire      [31:0]    io_status_417                 ;
wire      [31:0]    io_status_418                 ;
wire      [31:0]    io_status_419                 ;
wire      [31:0]    io_status_420                 ;
wire      [31:0]    io_status_421                 ;
wire      [31:0]    io_status_422                 ;
wire      [31:0]    io_status_423                 ;
wire      [31:0]    io_status_424                 ;
wire      [31:0]    io_status_425                 ;
wire      [31:0]    io_status_426                 ;
wire      [31:0]    io_status_427                 ;
wire      [31:0]    io_status_428                 ;
wire      [31:0]    io_status_429                 ;
wire      [31:0]    io_status_430                 ;
wire      [31:0]    io_status_431                 ;
wire      [31:0]    io_status_432                 ;
wire      [31:0]    io_status_433                 ;
wire      [31:0]    io_status_434                 ;
wire      [31:0]    io_status_435                 ;
wire      [31:0]    io_status_436                 ;
wire      [31:0]    io_status_437                 ;
wire      [31:0]    io_status_438                 ;
wire      [31:0]    io_status_439                 ;
wire      [31:0]    io_status_440                 ;
wire      [31:0]    io_status_441                 ;
wire      [31:0]    io_status_442                 ;
wire      [31:0]    io_status_443                 ;
wire      [31:0]    io_status_444                 ;
wire      [31:0]    io_status_445                 ;
wire      [31:0]    io_status_446                 ;
wire      [31:0]    io_status_447                 ;
wire      [31:0]    io_status_448                 ;
wire      [31:0]    io_status_449                 ;
wire      [31:0]    io_status_450                 ;
wire      [31:0]    io_status_451                 ;
wire      [31:0]    io_status_452                 ;
wire      [31:0]    io_status_453                 ;
wire      [31:0]    io_status_454                 ;
wire      [31:0]    io_status_455                 ;
wire      [31:0]    io_status_456                 ;
wire      [31:0]    io_status_457                 ;
wire      [31:0]    io_status_458                 ;
wire      [31:0]    io_status_459                 ;
wire      [31:0]    io_status_460                 ;
wire      [31:0]    io_status_461                 ;
wire      [31:0]    io_status_462                 ;
wire      [31:0]    io_status_463                 ;
wire      [31:0]    io_status_464                 ;
wire      [31:0]    io_status_465                 ;
wire      [31:0]    io_status_466                 ;
wire      [31:0]    io_status_467                 ;
wire      [31:0]    io_status_468                 ;
wire      [31:0]    io_status_469                 ;
wire      [31:0]    io_status_470                 ;
wire      [31:0]    io_status_471                 ;
wire      [31:0]    io_status_472                 ;
wire      [31:0]    io_status_473                 ;
wire      [31:0]    io_status_474                 ;
wire      [31:0]    io_status_475                 ;
wire      [31:0]    io_status_476                 ;
wire      [31:0]    io_status_477                 ;
wire      [31:0]    io_status_478                 ;
wire      [31:0]    io_status_479                 ;
wire      [31:0]    io_status_480                 ;
wire      [31:0]    io_status_481                 ;
wire      [31:0]    io_status_482                 ;
wire      [31:0]    io_status_483                 ;
wire      [31:0]    io_status_484                 ;
wire      [31:0]    io_status_485                 ;
wire      [31:0]    io_status_486                 ;
wire      [31:0]    io_status_487                 ;
wire      [31:0]    io_status_488                 ;
wire      [31:0]    io_status_489                 ;
wire      [31:0]    io_status_490                 ;
wire      [31:0]    io_status_491                 ;
wire      [31:0]    io_status_492                 ;
wire      [31:0]    io_status_493                 ;
wire      [31:0]    io_status_494                 ;
wire      [31:0]    io_status_495                 ;
wire      [31:0]    io_status_496                 ;
wire      [31:0]    io_status_497                 ;
wire      [31:0]    io_status_498                 ;
wire      [31:0]    io_status_499                 ;
wire      [31:0]    io_status_500                 ;
wire      [31:0]    io_status_501                 ;
wire      [31:0]    io_status_502                 ;
wire      [31:0]    io_status_503                 ;
wire      [31:0]    io_status_504                 ;
wire      [31:0]    io_status_505                 ;
wire      [31:0]    io_status_506                 ;
wire      [31:0]    io_status_507                 ;
wire      [31:0]    io_status_508                 ;
wire      [31:0]    io_status_509                 ;
wire      [31:0]    io_status_510                 ;
wire      [31:0]    io_status_511                 ;

IN#(194)in_io_s_tx_meta_0(
        clock,
        reset,
        {io_s_tx_meta_0_bits_rdma_cmd,io_s_tx_meta_0_bits_qpn_num,io_s_tx_meta_0_bits_msg_num_per_qpn,io_s_tx_meta_0_bits_local_vaddr,io_s_tx_meta_0_bits_remote_vaddr,io_s_tx_meta_0_bits_length},
        io_s_tx_meta_0_valid,
        io_s_tx_meta_0_ready
);
// rdma_cmd, qpn_num, msg_num_per_qpn, local_vaddr, remote_vaddr, length
// 2'h0, 32'h0, 32'h0, 48'h0, 48'h0, 32'h0

IN#(194)in_io_s_tx_meta_1(
        clock,
        reset,
        {io_s_tx_meta_1_bits_rdma_cmd,io_s_tx_meta_1_bits_qpn_num,io_s_tx_meta_1_bits_msg_num_per_qpn,io_s_tx_meta_1_bits_local_vaddr,io_s_tx_meta_1_bits_remote_vaddr,io_s_tx_meta_1_bits_length},
        io_s_tx_meta_1_valid,
        io_s_tx_meta_1_ready
);
// rdma_cmd, qpn_num, msg_num_per_qpn, local_vaddr, remote_vaddr, length
// 2'h0, 32'h0, 32'h0, 48'h0, 48'h0, 32'h0

DMA #(512) qdma0(
    clock,
    reset,
    //DMA CMD streams
    io_m_mem_read_cmd_0_valid,
    io_m_mem_read_cmd_0_ready,
    io_m_mem_read_cmd_0_bits_vaddr,
    io_m_mem_read_cmd_0_bits_length,
    io_m_mem_write_cmd_0_valid,
    io_m_mem_write_cmd_0_ready,
    io_m_mem_write_cmd_0_bits_vaddr,
    io_m_mem_write_cmd_0_bits_length,        
    //DMA Data streams      
    io_s_mem_read_data_0_valid,
    io_s_mem_read_data_0_ready,
    io_s_mem_read_data_0_bits_data,
    io_s_mem_read_data_0_bits_keep,
    io_s_mem_read_data_0_bits_last,
    io_m_mem_write_data_0_valid,
    io_m_mem_write_data_0_ready,
    io_m_mem_write_data_0_bits_data,
    io_m_mem_write_data_0_bits_keep,
    io_m_mem_write_data_0_bits_last        
);


DMA #(512) qdma1(
    clock,
    reset,
    //DMA CMD streams
    io_m_mem_read_cmd_1_valid,
    io_m_mem_read_cmd_1_ready,
    io_m_mem_read_cmd_1_bits_vaddr,
    io_m_mem_read_cmd_1_bits_length,
    io_m_mem_write_cmd_1_valid,
    io_m_mem_write_cmd_1_ready,
    io_m_mem_write_cmd_1_bits_vaddr,
    io_m_mem_write_cmd_1_bits_length,        
    //DMA Data streams      
    io_s_mem_read_data_1_valid,
    io_s_mem_read_data_1_ready,
    io_s_mem_read_data_1_bits_data,
    io_s_mem_read_data_1_bits_keep,
    io_s_mem_read_data_1_bits_last,
    io_m_mem_write_data_1_valid,
    io_m_mem_write_data_1_ready,
    io_m_mem_write_data_1_bits_data,
    io_m_mem_write_data_1_bits_keep,
    io_m_mem_write_data_1_bits_last        
);

IN#(168)in_io_qp_init_0(
        clock,
        reset,
        {io_qp_init_0_bits_qpn,io_qp_init_0_bits_conn_state_remote_qpn,io_qp_init_0_bits_conn_state_remote_ip,io_qp_init_0_bits_conn_state_remote_udp_port,io_qp_init_0_bits_conn_state_rx_epsn,io_qp_init_0_bits_conn_state_tx_npsn,io_qp_init_0_bits_conn_state_rx_old_unack},
        io_qp_init_0_valid,
        io_qp_init_0_ready
);
// qpn, conn_state_remote_qpn, conn_state_remote_ip, conn_state_remote_udp_port, conn_state_rx_epsn, conn_state_tx_npsn, conn_state_rx_old_unack
// 24'h0, 24'h0, 32'h0, 16'h0, 24'h0, 24'h0, 24'h0

IN#(168)in_io_qp_init_1(
        clock,
        reset,
        {io_qp_init_1_bits_qpn,io_qp_init_1_bits_conn_state_remote_qpn,io_qp_init_1_bits_conn_state_remote_ip,io_qp_init_1_bits_conn_state_remote_udp_port,io_qp_init_1_bits_conn_state_rx_epsn,io_qp_init_1_bits_conn_state_tx_npsn,io_qp_init_1_bits_conn_state_rx_old_unack},
        io_qp_init_1_valid,
        io_qp_init_1_ready
);
// qpn, conn_state_remote_qpn, conn_state_remote_ip, conn_state_remote_udp_port, conn_state_rx_epsn, conn_state_tx_npsn, conn_state_rx_old_unack
// 24'h0, 24'h0, 32'h0, 16'h0, 24'h0, 24'h0, 24'h0

IN#(505)in_io_cc_init_0(
        clock,
        reset,
        {io_cc_init_0_bits_qpn,io_cc_init_0_bits_cc_state_credit,io_cc_init_0_bits_cc_state_rate,io_cc_init_0_bits_cc_state_timer,io_cc_init_0_bits_cc_state_divide_rate,io_cc_init_0_bits_cc_state_user_define,io_cc_init_0_bits_cc_state_lock},
        io_cc_init_0_valid,
        io_cc_init_0_ready
);
// qpn, cc_state_credit, cc_state_rate, cc_state_timer, cc_state_divide_rate, cc_state_user_define, cc_state_lock
// 24'h0, 32'h0, 32'h0, 32'h0, 32'h0, 352'h0, 1'h0

IN#(505)in_io_cc_init_1(
        clock,
        reset,
        {io_cc_init_1_bits_qpn,io_cc_init_1_bits_cc_state_credit,io_cc_init_1_bits_cc_state_rate,io_cc_init_1_bits_cc_state_timer,io_cc_init_1_bits_cc_state_divide_rate,io_cc_init_1_bits_cc_state_user_define,io_cc_init_1_bits_cc_state_lock},
        io_cc_init_1_valid,
        io_cc_init_1_ready
);
// qpn, cc_state_credit, cc_state_rate, cc_state_timer, cc_state_divide_rate, cc_state_user_define, cc_state_lock
// 24'h0, 32'h0, 32'h0, 32'h0, 32'h0, 352'h0, 1'h0


IN#(32)in_io_arp_req_0(
        clock,
        reset,
        {io_arp_req_0_bits},
        io_arp_req_0_valid,
        io_arp_req_0_ready
);
// 
// 32'h0

IN#(32)in_io_arp_req_1(
        clock,
        reset,
        {io_arp_req_1_bits},
        io_arp_req_1_valid,
        io_arp_req_1_ready
);
// 
// 32'h0

OUT#(49)out_io_arp_rsp_0(
        clock,
        reset,
        {io_arp_rsp_0_bits_mac_addr,io_arp_rsp_0_bits_hit},
        io_arp_rsp_0_valid,
        io_arp_rsp_0_ready
);
// mac_addr, hit
// 48'h0, 1'h0

OUT#(49)out_io_arp_rsp_1(
        clock,
        reset,
        {io_arp_rsp_1_bits_mac_addr,io_arp_rsp_1_bits_hit},
        io_arp_rsp_1_valid,
        io_arp_rsp_1_ready
);
// mac_addr, hit
// 48'h0, 1'h0

IN#(81)in_io_arpinsert_0(
        clock,
        reset,
        {io_arpinsert_0_bits},
        io_arpinsert_0_valid,
        io_arpinsert_0_ready
);
// 
// 81'h0

IN#(81)in_io_arpinsert_1(
        clock,
        reset,
        {io_arpinsert_1_bits},
        io_arpinsert_1_valid,
        io_arpinsert_1_ready
);
// 
// 81'h0

blk_mem_gen_0 inst_0_0 (
  .rsta_busy(),          // output wire rsta_busy
  .rstb_busy(),          // output wire rstb_busy
  .s_aclk(clock),                // input wire s_aclk
  .s_aresetn(!reset),          // input wire s_aresetn
  .s_axi_awid(io_axi0_0_aw_bits_id),        // input wire [3 : 0] s_axi_awid
  .s_axi_awaddr({20'b0,io_axi0_0_aw_bits_addr[11:0]}),    // input wire [31 : 0] s_axi_awaddr
  .s_axi_awlen(0),      // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize(io_axi0_0_aw_bits_size),    // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst(io_axi0_0_aw_bits_burst),  // input wire [1 : 0] s_axi_awburst
  .s_axi_awvalid(io_axi0_0_aw_valid),  // input wire s_axi_awvalid
  .s_axi_awready(io_axi0_0_aw_ready),  // output wire s_axi_awready
  .s_axi_wdata(0),      // input wire [255 : 0] s_axi_wdata
  .s_axi_wstrb(io_axi0_0_w_bits_strb),      // input wire [31 : 0] s_axi_wstrb
  .s_axi_wlast(io_axi0_0_w_bits_last),      // input wire s_axi_wlast
  .s_axi_wvalid(io_axi0_0_w_valid),    // input wire s_axi_wvalid
  .s_axi_wready(io_axi0_0_w_ready),    // output wire s_axi_wready
  .s_axi_bid(),          // output wire [3 : 0] s_axi_bid
  .s_axi_bresp(io_axi0_0_b_bits_resp),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(io_axi0_0_b_valid),    // output wire s_axi_bvalid
  .s_axi_bready(io_axi0_0_b_ready),    // input wire s_axi_bready
  .s_axi_arid(io_axi0_0_ar_bits_id),        // input wire [3 : 0] s_axi_arid
  .s_axi_araddr({19'b0,io_axi0_0_ar_bits_addr[12:0]}),    // input wire [31 : 0] s_axi_araddr
  .s_axi_arlen(0),      // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize(io_axi0_0_ar_bits_size),    // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst(io_axi0_0_ar_bits_burst),  // input wire [1 : 0] s_axi_arburst
  .s_axi_arvalid(io_axi0_0_ar_valid),  // input wire s_axi_arvalid
  .s_axi_arready(io_axi0_0_ar_ready),  // output wire s_axi_arready
  .s_axi_rid(),          // output wire [3 : 0] s_axi_rid
  .s_axi_rdata(io_axi0_0_r_bits_data),      // output wire [255 : 0] s_axi_rdata
  .s_axi_rresp(io_axi0_0_r_bits_resp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast(io_axi0_0_r_bits_last),      // output wire s_axi_rlast
  .s_axi_rvalid(io_axi0_0_r_valid),    // output wire s_axi_rvalid
  .s_axi_rready(io_axi0_0_r_ready)    // input wire s_axi_rready
);

blk_mem_gen_0 inst_0_1 (
  .rsta_busy(),          // output wire rsta_busy
  .rstb_busy(),          // output wire rstb_busy
  .s_aclk(clock),                // input wire s_aclk
  .s_aresetn(!reset),          // input wire s_aresetn
  .s_axi_awid(io_axi0_1_aw_bits_id),        // input wire [3 : 0] s_axi_awid
  .s_axi_awaddr({20'b0,io_axi0_1_aw_bits_addr[11:0]}),    // input wire [31 : 0] s_axi_awaddr
  .s_axi_awlen(0),      // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize(io_axi0_1_aw_bits_size),    // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst(io_axi0_1_aw_bits_burst),  // input wire [1 : 0] s_axi_awburst
  .s_axi_awvalid(io_axi0_1_aw_valid),  // input wire s_axi_awvalid
  .s_axi_awready(io_axi0_1_aw_ready),  // output wire s_axi_awready
  .s_axi_wdata(0),      // input wire [255 : 0] s_axi_wdata
  .s_axi_wstrb(io_axi0_1_w_bits_strb),      // input wire [31 : 0] s_axi_wstrb
  .s_axi_wlast(io_axi0_1_w_bits_last),      // input wire s_axi_wlast
  .s_axi_wvalid(io_axi0_1_w_valid),    // input wire s_axi_wvalid
  .s_axi_wready(io_axi0_1_w_ready),    // output wire s_axi_wready
  .s_axi_bid(),          // output wire [3 : 0] s_axi_bid
  .s_axi_bresp(io_axi0_1_b_bits_resp),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(io_axi0_1_b_valid),    // output wire s_axi_bvalid
  .s_axi_bready(io_axi0_1_b_ready),    // input wire s_axi_bready
  .s_axi_arid(io_axi0_1_ar_bits_id),        // input wire [3 : 0] s_axi_arid
  .s_axi_araddr({19'b0,io_axi0_1_ar_bits_addr[12:0]}),    // input wire [31 : 0] s_axi_araddr
  .s_axi_arlen(0),      // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize(io_axi0_1_ar_bits_size),    // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst(io_axi0_1_ar_bits_burst),  // input wire [1 : 0] s_axi_arburst
  .s_axi_arvalid(io_axi0_1_ar_valid),  // input wire s_axi_arvalid
  .s_axi_arready(io_axi0_1_ar_ready),  // output wire s_axi_arready
  .s_axi_rid(),          // output wire [3 : 0] s_axi_rid
  .s_axi_rdata(io_axi0_1_r_bits_data),      // output wire [255 : 0] s_axi_rdata
  .s_axi_rresp(io_axi0_1_r_bits_resp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast(io_axi0_1_r_bits_last),      // output wire s_axi_rlast
  .s_axi_rvalid(io_axi0_1_r_valid),    // output wire s_axi_rvalid
  .s_axi_rready(io_axi0_1_r_ready)    // input wire s_axi_rready
);

blk_mem_gen_0 inst_1_0 (
  .rsta_busy(),          // output wire rsta_busy
  .rstb_busy(),          // output wire rstb_busy
  .s_aclk(clock),                // input wire s_aclk
  .s_aresetn(!reset),          // input wire s_aresetn
  .s_axi_awid(io_axi1_0_aw_bits_id),        // input wire [3 : 0] s_axi_awid
  .s_axi_awaddr({20'b0,io_axi1_0_aw_bits_addr[11:0]}),    // input wire [31 : 0] s_axi_awaddr
  .s_axi_awlen(0),      // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize(io_axi1_0_aw_bits_size),    // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst(io_axi1_0_aw_bits_burst),  // input wire [1 : 0] s_axi_awburst
  .s_axi_awvalid(io_axi1_0_aw_valid),  // input wire s_axi_awvalid
  .s_axi_awready(io_axi1_0_aw_ready),  // output wire s_axi_awready
  .s_axi_wdata(0),      // input wire [255 : 0] s_axi_wdata
  .s_axi_wstrb(io_axi1_0_w_bits_strb),      // input wire [31 : 0] s_axi_wstrb
  .s_axi_wlast(io_axi1_0_w_bits_last),      // input wire s_axi_wlast
  .s_axi_wvalid(io_axi1_0_w_valid),    // input wire s_axi_wvalid
  .s_axi_wready(io_axi1_0_w_ready),    // output wire s_axi_wready
  .s_axi_bid(),          // output wire [3 : 0] s_axi_bid
  .s_axi_bresp(io_axi1_0_b_bits_resp),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(io_axi1_0_b_valid),    // output wire s_axi_bvalid
  .s_axi_bready(io_axi1_0_b_ready),    // input wire s_axi_bready
  .s_axi_arid(io_axi1_0_ar_bits_id),        // input wire [3 : 0] s_axi_arid
  .s_axi_araddr({19'b0,io_axi1_0_ar_bits_addr[12:0]}),    // input wire [31 : 0] s_axi_araddr
  .s_axi_arlen(0),      // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize(io_axi1_0_ar_bits_size),    // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst(io_axi1_0_ar_bits_burst),  // input wire [1 : 0] s_axi_arburst
  .s_axi_arvalid(io_axi1_0_ar_valid),  // input wire s_axi_arvalid
  .s_axi_arready(io_axi1_0_ar_ready),  // output wire s_axi_arready
  .s_axi_rid(),          // output wire [3 : 0] s_axi_rid
  .s_axi_rdata(io_axi1_0_r_bits_data),      // output wire [255 : 0] s_axi_rdata
  .s_axi_rresp(io_axi1_0_r_bits_resp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast(io_axi1_0_r_bits_last),      // output wire s_axi_rlast
  .s_axi_rvalid(io_axi1_0_r_valid),    // output wire s_axi_rvalid
  .s_axi_rready(io_axi1_0_r_ready)    // input wire s_axi_rready
);

blk_mem_gen_0 inst_1_1 (
  .rsta_busy(),          // output wire rsta_busy
  .rstb_busy(),          // output wire rstb_busy
  .s_aclk(clock),                // input wire s_aclk
  .s_aresetn(!reset),         // input wire s_aresetn
  .s_axi_awid(io_axi1_1_aw_bits_id),        // input wire [3 : 0] s_axi_awid
  .s_axi_awaddr({20'b0,io_axi1_1_aw_bits_addr[11:0]}),    // input wire [31 : 0] s_axi_awaddr
  .s_axi_awlen(0),      // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize(io_axi1_1_aw_bits_size),    // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst(io_axi1_1_aw_bits_burst),  // input wire [1 : 0] s_axi_awburst
  .s_axi_awvalid(io_axi1_1_aw_valid),  // input wire s_axi_awvalid
  .s_axi_awready(io_axi1_1_aw_ready),  // output wire s_axi_awready
  .s_axi_wdata(0),      // input wire [255 : 0] s_axi_wdata
  .s_axi_wstrb(io_axi1_1_w_bits_strb),      // input wire [31 : 0] s_axi_wstrb
  .s_axi_wlast(io_axi1_1_w_bits_last),      // input wire s_axi_wlast
  .s_axi_wvalid(io_axi1_1_w_valid),    // input wire s_axi_wvalid
  .s_axi_wready(io_axi1_1_w_ready),    // output wire s_axi_wready
  .s_axi_bid(),          // output wire [3 : 0] s_axi_bid
  .s_axi_bresp(io_axi1_1_b_bits_resp),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(io_axi1_1_b_valid),    // output wire s_axi_bvalid
  .s_axi_bready(io_axi1_1_b_ready),    // input wire s_axi_bready
  .s_axi_arid(io_axi1_1_ar_bits_id),        // input wire [3 : 0] s_axi_arid
  .s_axi_araddr({19'b0,io_axi1_1_ar_bits_addr[12:0]}),    // input wire [31 : 0] s_axi_araddr
  .s_axi_arlen(0),      // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize(io_axi1_1_ar_bits_size),    // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst(io_axi1_1_ar_bits_burst),  // input wire [1 : 0] s_axi_arburst
  .s_axi_arvalid(io_axi1_1_ar_valid),  // input wire s_axi_arvalid
  .s_axi_arready(io_axi1_1_ar_ready),  // output wire s_axi_arready
  .s_axi_rid(),          // output wire [3 : 0] s_axi_rid
  .s_axi_rdata(io_axi1_1_r_bits_data),      // output wire [255 : 0] s_axi_rdata
  .s_axi_rresp(io_axi1_1_r_bits_resp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast(io_axi1_1_r_bits_last),      // output wire s_axi_rlast
  .s_axi_rvalid(io_axi1_1_r_valid),    // output wire s_axi_rvalid
  .s_axi_rready(io_axi1_1_r_ready)    // input wire s_axi_rready
);


assign io_axi0_0_r_bits_id = 0;
assign io_axi0_0_b_bits_id = 0;
assign io_axi0_1_r_bits_id = 0;
assign io_axi0_1_b_bits_id = 0;
assign io_axi1_0_r_bits_id = 0;
assign io_axi1_0_b_bits_id = 0;
assign io_axi1_1_r_bits_id = 0;
assign io_axi1_1_b_bits_id = 0;

PRDMA_LOOP PRDMA_LOOP_inst(
        .*
);

tb_rdma_config_init tb_rdma_config_init();

reg[159:0]   rdma_config[0:1023];
reg[15:0]   qpn_nums, rdma_cmd_nums, mem_block_nums, check_mem_nums;
reg[31:0]   start_addr, length, offset;
integer i,j;
/*
rdma_cmd,qpn,local_vaddr,remote_vaddr,length
in_io_s_tx_meta_0.write({2'h0,24'h0,48'h0,48'h0,32'h0});

rdma_cmd,qpn,local_vaddr,remote_vaddr,length
in_io_s_tx_meta_1.write({2'h0,24'h0,48'h0,48'h0,32'h0});

last,data,keep
in_io_s_mem_read_data_0.write({1'h0,512'h0,64'h0});

last,data,keep
in_io_s_mem_read_data_1.write({1'h0,512'h0,64'h0});

qpn,conn_state_remote_qpn,conn_state_remote_ip,conn_state_remote_udp_port,conn_state_rx_epsn,conn_state_tx_npsn,conn_state_rx_old_unack
in_io_qp_init_0.write({24'h0,24'h0,32'h0,16'h0,24'h0,24'h0,24'h0});

qpn,conn_state_remote_qpn,conn_state_remote_ip,conn_state_remote_udp_port,conn_state_rx_epsn,conn_state_tx_npsn,conn_state_rx_old_unack
in_io_qp_init_1.write({24'h0,24'h0,32'h0,16'h0,24'h0,24'h0,24'h0});

qpn,cc_state_credit,cc_state_rate,cc_state_timer,cc_state_user_define
in_io_cc_init_0.write({24'h0,32'h0,32'h0,32'h0,352'h0});

qpn,cc_state_credit,cc_state_rate,cc_state_timer,cc_state_user_define
in_io_cc_init_1.write({24'h0,32'h0,32'h0,32'h0,352'h0});


in_io_arp_req_0.write({32'h0});


in_io_arp_req_1.write({32'h0});

*/

initial begin
        reset <= 1;
        clock = 1;
        io_local_ip_address_0         =32'h01bda8c0;
        io_local_ip_address_1         =32'h02bda8c0;   
        io_cpu_started_0              = 1'b1; 
        io_cpu_started_1              = 1'b1; 
        io_pkg_num_0                  = 32'h1000;
        io_pkg_num_1                  = 32'h1000;
        $readmemh("config_big_rd_wr.hex", rdma_config);
        #10000;
        reset <= 0;
        #1000
        io_cpu_started_0              = 1'b0; 
        io_cpu_started_1              = 1'b0;        
        #100;
        out_io_arp_rsp_0.start();
        out_io_arp_rsp_1.start();
        #100
        in_io_arpinsert_0.write(81'h1029d02350a0002bda8c0);
        in_io_arpinsert_1.write(81'h1019d02350a0001bda8c0);        
        // in_io_arp_req_0.write(32'h02bda8c0);
        // in_io_arp_req_1.write(32'h01bda8c0);
        #25000
        qpn_nums        = rdma_config[0][15:0];
        rdma_cmd_nums   = rdma_config[0][31:16];
        mem_block_nums  = rdma_config[0][47:32];
        check_mem_nums  = rdma_config[0][63:48];
        for(i=0;i<mem_block_nums;i=i+1)begin
            if(rdma_config[i+1][1:0])begin
                qdma1.init_incr(0);
            end
            else begin
                qdma0.init_incr(0);
            end
        end

    
        #200; 
        in_io_qp_init_0.write({24'h1,24'h1,32'h02bda8c0,16'h17,24'h4000,24'h1000,24'h1000});     // qpn, conn_state_remote_qpn, conn_state_remote_ip, conn_state_remote_udp_port, conn_state_rx_epsn, conn_state_tx_npsn, conn_state_rx_old_unack
        in_io_qp_init_1.write({24'h1,24'h1,32'h01bda8c0,16'h17,24'h1000,24'h4000,24'h4000});
        in_io_qp_init_0.write({24'h2,24'h2,32'h02bda8c0,16'h17,24'h10000,24'h40000,24'h40000});     // qpn, op_code, credit, psn// 24'h0, 8'h0, 16'h0, 24'h0
        in_io_qp_init_1.write({24'h2,24'h2,32'h01bda8c0,16'h17,24'h40000,24'h10000,24'h10000});
        // in_io_cc_init_0.write({24'h1,32'h0000,32'h2cec,32'h0,32'h164,352'h00010000_00002eec_00000000_00000000_00000000_00000000_00000164_00000000_00002cec,1'h0}); //qpn,cc_state_credit,cc_state_rate,cc_state_timer,cc_state_user_define
        // in_io_cc_init_0.write({24'h2,32'h0000,32'h2cec,32'h0,32'h164,352'h00010000_00002eec_00000000_00000000_00000000_00000000_00000164_00000000_00002cec,1'h0});
        // in_io_cc_init_1.write({24'h1,32'h0000,32'h2cec,32'h0,32'h164,352'h00010000_00002eec_00000000_00000000_00000000_00000000_00000164_00000000_00002cec,1'h0}); //qpn,cc_state_credit,cc_state_rate,cc_state_timer,cc_state_user_define
        // in_io_cc_init_1.write({24'h2,32'h0000,32'h2cec,32'h0,32'h164,352'h00010000_00002eec_00000000_00000000_00000000_00000000_00000164_00000000_00002cec,1'h0});   //qpn, cc_state_credit, cc_state_rate, cc_state_timer, cc_state_divide_rate, cc_state_user_define, cc_state_lock     
        in_io_cc_init_0.write({24'h1,32'h0000,32'h2cec,32'h0,32'h164,352'h00010000_00002eec_00000000_00000000_00000000_00000000_00000000_00000164_00000000_00002cec,1'h0}); //qpn,cc_state_credit,cc_state_rate,cc_state_timer,cc_state_user_define
        in_io_cc_init_0.write({24'h2,32'h0000,32'h2cec,32'h0,32'h164,352'h00010000_00002eec_00000000_00000000_00000000_00000000_00000000_00000164_00000000_00002cec,1'h0});
        in_io_cc_init_1.write({24'h1,32'h0000,32'h2cec,32'h0,32'h164,352'h00010000_00002eec_00000000_00000000_00000000_00000000_00000000_00000164_00000000_00002cec,1'h0}); //qpn,cc_state_credit,cc_state_rate,cc_state_timer,cc_state_user_define
        in_io_cc_init_1.write({24'h2,32'h0000,32'h2cec,32'h0,32'h164,352'h00010000_00002eec_00000000_00000000_00000000_00000000_00000000_00000164_00000000_00002cec,1'h0});   //qpn, cc_state_credit, cc_state_rate, cc_state_timer, cc_state_divide_rate, cc_state_user_define, cc_state_lock   
        // qpn, local_psn, remote_psn, remote_qpn, remote_ip, remote_udp_port, credit
    // 16'h0, 24'h0, 24'h0, 24'h0, 32'h0, 16'h0, 24'h0
    
        #2000

        in_io_s_tx_meta_1.write({2'b1,32'h1,32'h10000,48'h200,48'h0,32'h200});
// rdma_cmd, qpn_num, msg_num_per_qpn, local_vaddr, remote_vaddr, length
// 2'h0, 32'h0, 32'h0, 48'h0, 48'h0, 32'h0

        // for(i=0;i<rdma_cmd_nums;i=i+1)begin
        //     if(rdma_config[i+mem_block_nums+1][1:0])begin
        //         for(j=0;j<1024;j++)begin
        //             in_io_s_tx_meta_1.write({rdma_config[i+mem_block_nums+1][3:2],rdma_config[i+mem_block_nums+1][27:4],rdma_config[i+mem_block_nums+1][75:28],rdma_config[i+mem_block_nums+1][123:76],rdma_config[i+mem_block_nums+1][155:124]});// rdma_cmd, qpn, local_vaddr, remote_vaddr, length
        //             // if(rdma_config[i+mem_block_nums+1][3:2]==2)begin
        //             //     io_m_mem_read_cmd_3_valid       = 1;
        //             //     io_m_mem_read_cmd_3_bits_vaddr  = 0;
        //             //     io_m_mem_read_cmd_3_bits_length = (2048+64)*1024;                
        //             // end
        //         end
        //     end
        //     else begin
        //         for(j=0;j<1024;j++)begin
        //             // in_io_s_tx_meta_0.write({rdma_config[i+mem_block_nums+1][3:2],rdma_config[i+mem_block_nums+1][27:4],rdma_config[i+mem_block_nums+1][75:28],rdma_config[i+mem_block_nums+1][123:76],rdma_config[i+mem_block_nums+1][155:124]});
        //             // if(rdma_config[i+mem_block_nums+1][3:2]==2)begin
        //             //     io_m_mem_read_cmd_2_valid       = 1;
        //             //     io_m_mem_read_cmd_2_bits_vaddr  = 0;
        //             //     io_m_mem_read_cmd_2_bits_length = (4096+64)*1024;                
        //             // end            
        //         end
        //     end
        // end
    
        // #10
        // io_m_mem_read_cmd_2_valid       = 0;
        // #300000
    
    
    
        // for(i=0;i<check_mem_nums;i=i+1)begin
        //     if(rdma_config[i+mem_block_nums+rdma_cmd_nums+1][1:0])begin
        //         qdma1.check_mem(rdma_config[i+mem_block_nums+rdma_cmd_nums+1][63:32],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][95:64],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][127:96]);
        //     end
        //     else begin
        //         qdma0.check_mem(rdma_config[i+mem_block_nums+rdma_cmd_nums+1][63:32],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][95:64],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][127:96]);
        //     end
        // end
end

always #2 clock=~clock;
endmodule
