`timescale 1ns / 1ps


// module tb_rdma_config_init(

//     );

//     reg[159:0]   rdma_config[0:1023];
//     reg[15:0]   qpn_nums = 1;
//     reg[15:0]   rdma_cmd_nums = 74; 
//     reg[15:0]   mem_block_nums = 4;
//     reg[15:0]   check_mem_nums = rdma_cmd_nums;

//     reg[35:0]   length,offset;
//     reg[47:0]   r_vaddr,l_vaddr;
//     reg[1:0]    rdma_cmd,node_index,dest_index;
    
//     integer i;

//     /*    4 node: node0:A, node1:B, node2:C, node3:D

//     QP1:  A.1  B.3  
//     QP2:  A.2  C.7
//     QP3:  A.3  D.10
//     QP4:  B.4  C.8
//     QP5:  B.5  D.9
//     QP6:  C.6  D.6

//     */


//     initial begin
//         rdma_config[0] = {96'h0,check_mem_nums,mem_block_nums,rdma_cmd_nums,qpn_nums};
//         rdma_config[1] = {32'd0,32'd4,32'h200000,32'd0,32'd0}; //res,offset,length,start_addr,node_idx
//         rdma_config[2] = {32'd0,32'd5,32'h200000,32'd0,32'd1}; //res,offset,length,start_addr,node_idx
//         rdma_config[3] = {32'd0,32'd6,32'h200000,32'd0,32'd2}; //res,offset,length,start_addr,node_idx
//         rdma_config[4] = {32'd0,32'd7,32'h200000,32'd0,32'd3}; //res,offset,length,start_addr,node_idx

//         for(i=0;i<rdma_cmd_nums;i=i+1)begin
//             length = (({$random} % 16384)<<6) + 64;
//             rdma_cmd = ({$random} % 2);
//             node_index = ({$random} % 4);
//             dest_index = ({$random} % 3);
//             if(node_index == dest_index)begin
//                 dest_index = 3;
//             end
//             if(rdma_cmd)begin
//                 l_vaddr = ({$random} % 16384)<< 6 ;
//                 r_vaddr = (({$random} % 16384)<< 6) +32'h200000;
//             end 
//             else begin
//                 r_vaddr = ({$random} % 16384)<< 6 ; 
//                 l_vaddr = (({$random} % 16384)<< 6) +32'h200000;
//             end
//             if(node_index==0)begin
//                 if(dest_index==1)begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd1,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+4 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+5 ,l_vaddr,node_index};
//                 end else if(dest_index==2)begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd2,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+4 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+6 ,l_vaddr,node_index};                    
//                 end else begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd3,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+4 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+7 ,l_vaddr,node_index};
//                 end
                    
//             end 
//             else if(node_index==1)begin
//                 if(dest_index==0)begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd3,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+5 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+4 ,l_vaddr,node_index};
//                 end else if(dest_index==2)begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd4,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+5 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+6 ,l_vaddr,node_index};                    
//                 end else begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd5,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+5 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+7 ,l_vaddr,node_index};                    
//                 end
//             end 
//             else if(node_index==2)begin
//                 if(dest_index==0)begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd7,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+6 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+4 ,l_vaddr,node_index};
//                 end else if(dest_index==1)begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd8,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+6 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+5 ,l_vaddr,node_index};
//                 end else begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd6,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+6 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+7 ,l_vaddr,node_index};
//                 end
//             end
//             else begin
//                 if(dest_index==0)begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd10,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+7 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+4 ,l_vaddr,node_index};                    
//                 end else if(dest_index==1)begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd9,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+7 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+5 ,l_vaddr,node_index};
//                 end else begin
//                     rdma_config[i+5] = {length,r_vaddr,l_vaddr,24'd6,rdma_cmd,node_index};
//                     if(rdma_cmd)
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(l_vaddr>>6)+7 ,r_vaddr,dest_index};
//                     else
//                         rdma_config[i+5+rdma_cmd_nums] = {32'b0,length,(r_vaddr>>6)+6 ,l_vaddr,node_index};
//                 end
//             end
//         end
  
//         $writememh("config.hex",rdma_config);
//     end


// endmodule

// module tb_rdma_config_init(

//     );

//     reg[159:0]   rdma_config[0:199];
//     reg[15:0]   qpn_nums = 1;
//     reg[15:0]   rdma_cmd_nums = 74; 
//     reg[15:0]   mem_block_nums = 4;
//     reg[15:0]   check_mem_nums = 74;
//     integer i;

//     /*    4 node: node0:A, node1:B, node2:C, node3:D

//     QP1:  A.1  B.3  
//     QP2:  A.2  C.7
//     QP3:  A.3  D.10
//     QP4:  B.4  C.8
//     QP5:  B.5  D.9
//     QP6:  C.6  D.6

//     */


//     initial begin
//         rdma_config[0] = {96'h0,check_mem_nums,mem_block_nums,rdma_cmd_nums,qpn_nums};
//         rdma_config[1] = {32'd0,32'd4,32'h100000,32'd0,32'd0}; //res,offset,length,start_addr,node_idx
//         rdma_config[2] = {32'd0,32'd5,32'h100000,32'd0,32'd1}; //res,offset,length,start_addr,node_idx
//         rdma_config[3] = {32'd0,32'd6,32'h100000,32'd0,32'd2}; //res,offset,length,start_addr,node_idx
//         rdma_config[4] = {32'd0,32'd7,32'h100000,32'd0,32'd3}; //res,offset,length,start_addr,node_idx

//         rdma_config[5] = {32'h40,48'h40,48'h100000,24'd1,2'd0,2'd0};//length, r_addr, l_vaddr, l_qpn, rdma_cmd: 0:read 1:writre, node_idx 
//         rdma_config[6] = {32'h40,48'h40,48'h100080,24'd1,2'd0,2'd0};
//         rdma_config[7] = {32'h40,48'h40,48'h100100,24'd1,2'd0,2'd0};
//         rdma_config[8] = {32'h40,48'h40,48'h100180,24'd1,2'd0,2'd0};
//         rdma_config[9] = {32'h40,48'h40,48'h100200,24'd1,2'd0,2'd0};
//         rdma_config[10] = {32'h40,48'h40,48'h100280,24'd1,2'd0,2'd0};
//         rdma_config[11] = {32'h40,48'h100000,48'h40,24'd1,2'd1,2'd0};
//         rdma_config[12] = {32'h40,48'h100080,48'h40,24'd1,2'd1,2'd0};
//         rdma_config[13] = {32'h40,48'h100100,48'h40,24'd1,2'd1,2'd0};
//         rdma_config[14] = {32'h40,48'h100180,48'h40,24'd1,2'd1,2'd0};
//         rdma_config[15] = {32'h40,48'h100200,48'h40,24'd1,2'd1,2'd0};
//         rdma_config[16] = {32'h40,48'h100280,48'h40,24'd1,2'd1,2'd0};

//         rdma_config[17] = {32'h400,48'h80,48'h100800,24'd2,2'd0,2'd0};
//         rdma_config[18] = {32'h400,48'h80,48'h101000,24'd2,2'd0,2'd0};
//         rdma_config[19] = {32'h400,48'h80,48'h101800,24'd2,2'd0,2'd0};
//         rdma_config[20] = {32'h400,48'h80,48'h102000,24'd2,2'd0,2'd0};
//         rdma_config[21] = {32'h400,48'h80,48'h102800,24'd2,2'd0,2'd0};
//         rdma_config[22] = {32'h400,48'h100800,48'h100,24'd2,2'd1,2'd0};
//         rdma_config[23] = {32'h400,48'h101000,48'h100,24'd2,2'd1,2'd0};
//         rdma_config[24] = {32'h400,48'h101800,48'h100,24'd2,2'd1,2'd0};
//         rdma_config[25] = {32'h400,48'h102000,48'h100,24'd2,2'd1,2'd0};
//         rdma_config[26] = {32'h400,48'h102800,48'h100,24'd2,2'd1,2'd0};

//         rdma_config[27] = {32'h4000,48'h40,48'h108000,24'd3,2'd0,2'd0};
//         rdma_config[28] = {32'h4000,48'h40,48'h110000,24'd3,2'd0,2'd0};
//         rdma_config[29] = {32'h4000,48'h40,48'h118000,24'd3,2'd0,2'd0};
//         rdma_config[30] = {32'h4000,48'h40,48'h120000,24'd3,2'd0,2'd0};
//         rdma_config[31] = {32'h4000,48'h40,48'h128000,24'd3,2'd0,2'd0};
//         rdma_config[32] = {32'h4000,48'h108000,48'h40,24'd3,2'd1,2'd0};
//         rdma_config[33] = {32'h4000,48'h110000,48'h40,24'd3,2'd1,2'd0};
//         rdma_config[34] = {32'h4000,48'h118000,48'h40,24'd3,2'd1,2'd0};
//         rdma_config[35] = {32'h4000,48'h120000,48'h40,24'd3,2'd1,2'd0};
//         rdma_config[36] = {32'h4000,48'h128000,48'h40,24'd3,2'd1,2'd0};

//         rdma_config[37] = {32'h40,48'h40,48'h200000,24'd3,2'd0,2'd1};//length, r_addr, l_vaddr, l_qpn, rdma_cmd: 0:read 1:writre, node_idx 
//         rdma_config[38] = {32'h40,48'h40,48'h200080,24'd3,2'd0,2'd1};
//         rdma_config[39] = {32'h40,48'h40,48'h200100,24'd3,2'd0,2'd1};
//         rdma_config[40] = {32'h40,48'h40,48'h200180,24'd3,2'd0,2'd1};
//         rdma_config[41] = {32'h40,48'h40,48'h200200,24'd3,2'd0,2'd1};
//         rdma_config[42] = {32'h40,48'h40,48'h200280,24'd3,2'd0,2'd1};
//         rdma_config[43] = {32'h40,48'h200000,48'h40,24'd3,2'd1,2'd1};
//         rdma_config[44] = {32'h40,48'h200080,48'h40,24'd3,2'd1,2'd1};
//         rdma_config[45] = {32'h40,48'h200100,48'h40,24'd3,2'd1,2'd1};
//         rdma_config[46] = {32'h40,48'h200180,48'h40,24'd3,2'd1,2'd1};
//         rdma_config[47] = {32'h40,48'h200200,48'h40,24'd3,2'd1,2'd1};
//         rdma_config[48] = {32'h40,48'h200280,48'h40,24'd3,2'd1,2'd1};

//         rdma_config[49] = {32'h400,48'h80,48'h200800,24'd4,2'd0,2'd1};
//         rdma_config[50] = {32'h400,48'h80,48'h201000,24'd4,2'd0,2'd1};
//         rdma_config[51] = {32'h400,48'h80,48'h201800,24'd4,2'd0,2'd1};
//         rdma_config[52] = {32'h400,48'h80,48'h202000,24'd4,2'd0,2'd1};
//         rdma_config[53] = {32'h400,48'h80,48'h202800,24'd4,2'd0,2'd1};
//         rdma_config[54] = {32'h400,48'h200800,48'h100,24'd4,2'd1,2'd1};
//         rdma_config[55] = {32'h400,48'h201000,48'h100,24'd4,2'd1,2'd1};
//         rdma_config[56] = {32'h400,48'h201800,48'h100,24'd4,2'd1,2'd1};
//         rdma_config[57] = {32'h400,48'h202000,48'h100,24'd4,2'd1,2'd1};
//         rdma_config[58] = {32'h400,48'h202800,48'h100,24'd4,2'd1,2'd1};
//         rdma_config[59] = {32'h4000,48'h40,48'h208000,24'd5,2'd0,2'd1};
//         rdma_config[60] = {32'h4000,48'h40,48'h210000,24'd5,2'd0,2'd1};
//         rdma_config[61] = {32'h4000,48'h40,48'h218000,24'd5,2'd0,2'd1};
//         rdma_config[62] = {32'h4000,48'h40,48'h220000,24'd5,2'd0,2'd1};
//         rdma_config[63] = {32'h4000,48'h40,48'h228000,24'd5,2'd0,2'd1};
//         rdma_config[64] = {32'h4000,48'h208000,48'h40,24'd5,2'd1,2'd1};
//         rdma_config[65] = {32'h4000,48'h210000,48'h40,24'd5,2'd1,2'd1};
//         rdma_config[66] = {32'h4000,48'h218000,48'h40,24'd5,2'd1,2'd1};
//         rdma_config[67] = {32'h4000,48'h220000,48'h40,24'd5,2'd1,2'd1};
//         rdma_config[68] = {32'h4000,48'h228000,48'h40,24'd5,2'd1,2'd1};           
//         rdma_config[69] = {32'h4000,48'h40,48'h248000,24'd6,2'd0,2'd2};
//         rdma_config[70] = {32'h4000,48'h40,48'h250000,24'd6,2'd0,2'd2};
//         rdma_config[71] = {32'h4000,48'h40,48'h258000,24'd6,2'd0,2'd2};
//         rdma_config[72] = {32'h4000,48'h40,48'h260000,24'd6,2'd0,2'd2};
//         rdma_config[73] = {32'h4000,48'h40,48'h268000,24'd6,2'd0,2'd2};
//         rdma_config[74] = {32'h4000,48'h248000,48'h40,24'd6,2'd1,2'd2};
//         rdma_config[75] = {32'h4000,48'h250000,48'h40,24'd6,2'd1,2'd2};
//         rdma_config[76] = {32'h4000,48'h258000,48'h40,24'd6,2'd1,2'd2};
//         rdma_config[77] = {32'h4000,48'h260000,48'h40,24'd6,2'd1,2'd2};
//         rdma_config[78] = {32'h4000,48'h268000,48'h40,24'd6,2'd1,2'd2};

//         rdma_config[79] = {32'd0,32'd6,32'h40,32'h100000,32'd0};//res,offset,length,start_addr,node_idx
//         rdma_config[80] = {32'd0,32'd6,32'h40,32'h100080,32'd0};
//         rdma_config[81] = {32'd0,32'd6,32'h40,32'h100100,32'd0};
//         rdma_config[82] = {32'd0,32'd6,32'h40,32'h100180,32'd0};
//         rdma_config[83] = {32'd0,32'd6,32'h40,32'h100200,32'd0};
//         rdma_config[84] = {32'd0,32'd6,32'h40,32'h100280,32'd0};
//         rdma_config[85] = {32'd0,32'd5,32'h40,32'h100000,32'd1};//res,offset,length,start_addr,node_idx
//         rdma_config[86] = {32'd0,32'd5,32'h40,32'h100080,32'd1};
//         rdma_config[87] = {32'd0,32'd5,32'h40,32'h100100,32'd1};
//         rdma_config[88] = {32'd0,32'd5,32'h40,32'h100180,32'd1};
//         rdma_config[89] = {32'd0,32'd5,32'h40,32'h100200,32'd1};
//         rdma_config[90] = {32'd0,32'd5,32'h40,32'h100280,32'd1};
//         rdma_config[91] = {32'd0,32'd8,32'h400,32'h100800,32'd0};
//         rdma_config[92] = {32'd0,32'd8,32'h400,32'h101000,32'd0};
//         rdma_config[93] = {32'd0,32'd8,32'h400,32'h101800,32'd0};
//         rdma_config[94] = {32'd0,32'd8,32'h400,32'h102000,32'd0};
//         rdma_config[95] = {32'd0,32'd8,32'h400,32'h102800,32'd0};
//         rdma_config[96] = {32'd0,32'd8,32'h400,32'h100800,32'd2};
//         rdma_config[97] = {32'd0,32'd8,32'h400,32'h101000,32'd2};
//         rdma_config[98] = {32'd0,32'd8,32'h400,32'h101800,32'd2};
//         rdma_config[99] = {32'd0,32'd8,32'h400,32'h102000,32'd2};
//         rdma_config[100] = {32'd0,32'd8,32'h400,32'h102800,32'd2};
//         rdma_config[101] = {32'd0,32'd8,32'h4000,32'h108000,32'd0};
//         rdma_config[102] = {32'd0,32'd8,32'h4000,32'h110000,32'd0};
//         rdma_config[103] = {32'd0,32'd8,32'h4000,32'h118000,32'd0};
//         rdma_config[104] = {32'd0,32'd8,32'h4000,32'h120000,32'd0};
//         rdma_config[105] = {32'd0,32'd8,32'h4000,32'h128000,32'd0};
//         rdma_config[106] = {32'd0,32'd5,32'h4000,32'h108000,32'd3};
//         rdma_config[107] = {32'd0,32'd5,32'h4000,32'h110000,32'd3};
//         rdma_config[108] = {32'd0,32'd5,32'h4000,32'h118000,32'd3};
//         rdma_config[109] = {32'd0,32'd5,32'h4000,32'h120000,32'd3};
//         rdma_config[110] = {32'd0,32'd5,32'h4000,32'h128000,32'd3};
//         rdma_config[111] = {32'd0,32'd5,32'h40,32'h200000,32'd1};//res,offset,length,start_addr,node_idx
//         rdma_config[112] = {32'd0,32'd5,32'h40,32'h200080,32'd1};
//         rdma_config[113] = {32'd0,32'd5,32'h40,32'h200100,32'd1};
//         rdma_config[114] = {32'd0,32'd5,32'h40,32'h200180,32'd1};
//         rdma_config[115] = {32'd0,32'd5,32'h40,32'h200200,32'd1};
//         rdma_config[116] = {32'd0,32'd5,32'h40,32'h200280,32'd1};
//         rdma_config[117] = {32'd0,32'd6,32'h40,32'h200000,32'd0};//res,offset,length,start_addr,node_idx
//         rdma_config[118] = {32'd0,32'd6,32'h40,32'h200080,32'd0};
//         rdma_config[119] = {32'd0,32'd6,32'h40,32'h200100,32'd0};
//         rdma_config[120] = {32'd0,32'd6,32'h40,32'h200180,32'd0};
//         rdma_config[121] = {32'd0,32'd6,32'h40,32'h200200,32'd0};
//         rdma_config[122] = {32'd0,32'd6,32'h40,32'h200280,32'd0};
//         rdma_config[123] = {32'd0,32'd8,32'h400,32'h200800,32'd1};
//         rdma_config[124] = {32'd0,32'd8,32'h400,32'h201000,32'd1};
//         rdma_config[125] = {32'd0,32'd8,32'h400,32'h201800,32'd1};
//         rdma_config[126] = {32'd0,32'd8,32'h400,32'h202000,32'd1};
//         rdma_config[127] = {32'd0,32'd8,32'h400,32'h202800,32'd1};
//         rdma_config[128] = {32'd0,32'd9,32'h400,32'h200800,32'd2};
//         rdma_config[129] = {32'd0,32'd9,32'h400,32'h201000,32'd2};
//         rdma_config[130] = {32'd0,32'd9,32'h400,32'h201800,32'd2};
//         rdma_config[131] = {32'd0,32'd9,32'h400,32'h202000,32'd2};
//         rdma_config[132] = {32'd0,32'd9,32'h400,32'h202800,32'd2};
//         rdma_config[133] = {32'd0,32'd8,32'h4000,32'h208000,32'd1};
//         rdma_config[134] = {32'd0,32'd8,32'h4000,32'h210000,32'd1};
//         rdma_config[135] = {32'd0,32'd8,32'h4000,32'h218000,32'd1};
//         rdma_config[136] = {32'd0,32'd8,32'h4000,32'h220000,32'd1};
//         rdma_config[137] = {32'd0,32'd8,32'h4000,32'h228000,32'd1};
//         rdma_config[138] = {32'd0,32'd6,32'h4000,32'h208000,32'd3};
//         rdma_config[139] = {32'd0,32'd6,32'h4000,32'h210000,32'd3};
//         rdma_config[140] = {32'd0,32'd6,32'h4000,32'h218000,32'd3};
//         rdma_config[141] = {32'd0,32'd6,32'h4000,32'h220000,32'd3};
//         rdma_config[142] = {32'd0,32'd6,32'h4000,32'h228000,32'd3};        
//         rdma_config[143] = {32'd0,32'd8,32'h4000,32'h248000,32'd2};
//         rdma_config[144] = {32'd0,32'd8,32'h4000,32'h250000,32'd2};
//         rdma_config[145] = {32'd0,32'd8,32'h4000,32'h258000,32'd2};
//         rdma_config[146] = {32'd0,32'd8,32'h4000,32'h260000,32'd2};
//         rdma_config[147] = {32'd0,32'd8,32'h4000,32'h268000,32'd2};
//         rdma_config[148] = {32'd0,32'd7,32'h4000,32'h248000,32'd3};
//         rdma_config[149] = {32'd0,32'd7,32'h4000,32'h250000,32'd3};
//         rdma_config[150] = {32'd0,32'd7,32'h4000,32'h258000,32'd3};
//         rdma_config[151] = {32'd0,32'd7,32'h4000,32'h260000,32'd3};
//         rdma_config[152] = {32'd0,32'd7,32'h4000,32'h268000,32'd3};  

  
//         $writememh("config.hex",rdma_config);
//     end


// endmodule


// module tb_rdma_config_init(

//     );

//     reg[159:0]   rdma_config[0:127];
//     reg[15:0]   qpn_nums = 1;
//     reg[15:0]   rdma_cmd_nums = 22; 
//     reg[15:0]   mem_block_nums = 1;
//     reg[15:0]   check_mem_nums = 22;
//     integer i;

//     initial begin
//         rdma_config[0] = {96'h0,check_mem_nums,mem_block_nums,rdma_cmd_nums,qpn_nums};
//         rdma_config[1] = {32'd0,32'd3,32'd200000,32'd960,32'd1};
//         rdma_config[2] = {32'd64,48'd960,48'd64,24'd1,2'd0,1'd0};
//         rdma_config[3] = {32'd128,48'd960,48'd512,24'd1,2'd0,1'd0};
//         rdma_config[4] = {32'd1344,48'd1024,48'd1024,24'd1,2'd0,1'd0};
//         rdma_config[5] = {32'd1408,48'd1024,48'd8000,24'd1,2'd0,1'd0};
//         rdma_config[6] = {32'd1472,48'd1024,48'd16000,24'd1,2'd0,1'd0};
//         rdma_config[7] = {32'd2752,48'd1024,48'd24000,24'd1,2'd0,1'd0};
//         rdma_config[8] = {32'd2816,48'd1024,48'd32000,24'd1,2'd0,1'd0};
//         rdma_config[9] = {32'd2880,48'd1024,48'd40000,24'd1,2'd0,1'd0};
//         rdma_config[10] = {32'd4096,48'd1024,48'd48000,24'd1,2'd0,1'd0};
//         rdma_config[11] = {32'd4224,48'd1024,48'd56000,24'd1,2'd0,1'd0};
//         rdma_config[12] = {32'd40000,48'd1024,48'd64000,24'd1,2'd0,1'd0};

//         rdma_config[13] = {32'd64,48'd200000,48'd960,24'd1,2'd1,1'd1};
//         rdma_config[14] = {32'd128,48'd200128,48'd960,24'd1,2'd1,1'd1};
//         rdma_config[15] = {32'd1344,48'd201024,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[16] = {32'd1408,48'd208000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[17] = {32'd1472,48'd216000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[18] = {32'd2752,48'd224000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[19] = {32'd2816,48'd232000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[20] = {32'd2880,48'd240000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[21] = {32'd4096,48'd248000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[22] = {32'd4224,48'd256000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[23] = {32'd40000,48'd264000,48'd1024,24'd1,2'd1,1'd1};        

//         rdma_config[24] = {32'd0,32'd3,32'd64,32'd64,32'd0};
//         rdma_config[25] = {32'd0,32'd3,32'd128,32'd512,32'd0};
//         rdma_config[26] = {32'd0,32'd4,32'd1344,32'd1024,32'd0};
//         rdma_config[27] = {32'd0,32'd4,32'd1408,32'd8000,32'd0};
//         rdma_config[28] = {32'd0,32'd4,32'd1472,32'd16000,32'd0};
//         rdma_config[29] = {32'd0,32'd4,32'd2752,32'd24000,32'd0};
//         rdma_config[30] = {32'd0,32'd4,32'd2816,32'd32000,32'd0};
//         rdma_config[31] = {32'd0,32'd4,32'd2880,32'd40000,32'd0};
//         rdma_config[32] = {32'd0,32'd4,32'd4096,32'd48000,32'd0};
//         rdma_config[33] = {32'd0,32'd4,32'd4224,32'd56000,32'd0};
//         rdma_config[34] = {32'd0,32'd4,32'd40000,32'd64000,32'd0};

//         rdma_config[35] = {32'd0,32'd3,32'd64,32'd200000,32'd0};
//         rdma_config[36] = {32'd0,32'd3,32'd128,32'd200128,32'd0};
//         rdma_config[37] = {32'd0,32'd4,32'd1344,32'd201024,32'd0};
//         rdma_config[38] = {32'd0,32'd4,32'd1408,32'd208000,32'd0};
//         rdma_config[39] = {32'd0,32'd4,32'd1472,32'd216000,32'd0};
//         rdma_config[40] = {32'd0,32'd4,32'd2752,32'd224000,32'd0};
//         rdma_config[41] = {32'd0,32'd4,32'd2816,32'd232000,32'd0};
//         rdma_config[42] = {32'd0,32'd4,32'd2880,32'd240000,32'd0};
//         rdma_config[43] = {32'd0,32'd4,32'd4096,32'd248000,32'd0};
//         rdma_config[44] = {32'd0,32'd4,32'd4224,32'd256000,32'd0};
//         rdma_config[45] = {32'd0,32'd4,32'd40000,32'd264000,32'd0};        
//         $writememh("config.hex",rdma_config);
//     end


// endmodule

// module tb_rdma_config_init(

//     );

//     reg[159:0]   rdma_config[0:127];
//     reg[15:0]   qpn_nums = 1;
//     reg[15:0]   rdma_cmd_nums = 11; 
//     reg[15:0]   mem_block_nums = 1;
//     reg[15:0]   check_mem_nums = 11;
//     integer i;

//     initial begin
//         rdma_config[0] = {96'h0,check_mem_nums,mem_block_nums,rdma_cmd_nums,qpn_nums};
//         rdma_config[1] = {32'd0,32'd3,32'd200000,32'd960,32'd1};

//         rdma_config[2] = {32'd64,48'd200000,48'd960,24'd1,2'd1,1'd1};
//         rdma_config[3] = {32'd128,48'd200128,48'd960,24'd1,2'd1,1'd1};
//         rdma_config[4] = {32'd1344,48'd201024,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[5] = {32'd1408,48'd208000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[6] = {32'd1472,48'd216000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[7] = {32'd2752,48'd224000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[8] = {32'd2816,48'd232000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[9] = {32'd2880,48'd240000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[10] = {32'd4096,48'd248000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[11] = {32'd4224,48'd256000,48'd1024,24'd1,2'd1,1'd1};
//         rdma_config[12] = {32'd40000,48'd264000,48'd1024,24'd1,2'd1,1'd1};        

//         rdma_config[13] = {32'd0,32'd3,32'd64,32'd200000,32'd0};
//         rdma_config[14] = {32'd0,32'd3,32'd128,32'd200128,32'd0};
//         rdma_config[15] = {32'd0,32'd4,32'd1344,32'd201024,32'd0};
//         rdma_config[16] = {32'd0,32'd4,32'd1408,32'd208000,32'd0};
//         rdma_config[17] = {32'd0,32'd4,32'd1472,32'd216000,32'd0};
//         rdma_config[18] = {32'd0,32'd4,32'd2752,32'd224000,32'd0};
//         rdma_config[19] = {32'd0,32'd4,32'd2816,32'd232000,32'd0};
//         rdma_config[20] = {32'd0,32'd4,32'd2880,32'd240000,32'd0};
//         rdma_config[21] = {32'd0,32'd4,32'd4096,32'd248000,32'd0};
//         rdma_config[22] = {32'd0,32'd4,32'd4224,32'd256000,32'd0};
//         rdma_config[23] = {32'd0,32'd4,32'd40000,32'd264000,32'd0};        
//         $writememh("config_base_write.hex",rdma_config);
//     end


// endmodule


// module tb_rdma_config_init(

//     );

//     reg[159:0]   rdma_config[0:127];
//     reg[15:0]   qpn_nums = 1;
//     reg[15:0]   rdma_cmd_nums = 11; 
//     reg[15:0]   mem_block_nums = 1;
//     reg[15:0]   check_mem_nums = 11;
//     integer i;

//     initial begin
//         rdma_config[0] = {96'h0,check_mem_nums,mem_block_nums,rdma_cmd_nums,qpn_nums};
//         rdma_config[1] = {32'd0,32'd3,32'd200000,32'd960,32'd1};
//         rdma_config[2] = {32'd64,48'd960,48'd64,24'd1,2'd0,1'd0};
//         rdma_config[3] = {32'd128,48'd960,48'd512,24'd1,2'd0,1'd0};
//         rdma_config[4] = {32'd1344,48'd1024,48'd1024,24'd1,2'd0,1'd0};
//         rdma_config[5] = {32'd1408,48'd1024,48'd8000,24'd1,2'd0,1'd0};
//         rdma_config[6] = {32'd1472,48'd1024,48'd16000,24'd1,2'd0,1'd0};
//         rdma_config[7] = {32'd2752,48'd1024,48'd24000,24'd1,2'd0,1'd0};
//         rdma_config[8] = {32'd2816,48'd1024,48'd32000,24'd1,2'd0,1'd0};
//         rdma_config[9] = {32'd2880,48'd1024,48'd40000,24'd1,2'd0,1'd0};
//         rdma_config[10] = {32'd4096,48'd1024,48'd48000,24'd1,2'd0,1'd0};
//         rdma_config[11] = {32'd4224,48'd1024,48'd56000,24'd1,2'd0,1'd0};
//         rdma_config[12] = {32'd40000,48'd1024,48'd64000,24'd1,2'd0,1'd0};        

//         rdma_config[13] = {32'd0,32'd3,32'd64,32'd64,32'd0};
//         rdma_config[14] = {32'd0,32'd3,32'd128,32'd512,32'd0};
//         rdma_config[15] = {32'd0,32'd4,32'd1344,32'd1024,32'd0};
//         rdma_config[16] = {32'd0,32'd4,32'd1408,32'd8000,32'd0};
//         rdma_config[17] = {32'd0,32'd4,32'd1472,32'd16000,32'd0};
//         rdma_config[18] = {32'd0,32'd4,32'd2752,32'd24000,32'd0};
//         rdma_config[19] = {32'd0,32'd4,32'd2816,32'd32000,32'd0};
//         rdma_config[20] = {32'd0,32'd4,32'd2880,32'd40000,32'd0};
//         rdma_config[21] = {32'd0,32'd4,32'd4096,32'd48000,32'd0};
//         rdma_config[22] = {32'd0,32'd4,32'd4224,32'd56000,32'd0};
//         rdma_config[23] = {32'd0,32'd4,32'd40000,32'd64000,32'd0};      
//         $writememh("config_base_read.hex",rdma_config);
//     end


// endmodule


// module tb_rdma_config_init(

//     );

//     reg[159:0]   rdma_config[0:127];
//     reg[15:0]   qpn_nums = 1;
//     reg[15:0]   rdma_cmd_nums = 2; 
//     reg[15:0]   mem_block_nums = 1;
//     reg[15:0]   check_mem_nums = 2;
//     integer i;

//     initial begin
//         rdma_config[0] = {96'h0,check_mem_nums,mem_block_nums,rdma_cmd_nums,qpn_nums};
//         rdma_config[1] = {32'd0,32'd3,32'h100000,32'd960,32'd1};//res,offset,length,start_addr,node_idx
//         rdma_config[2] = {32'h100000,48'd960,48'd64,24'd1,2'd0,2'd0};//length, r_addr, l_vaddr, l_qpn, rdma_cmd: 0:read 1:writre, node_idx 


//         rdma_config[3] = {32'h100000,48'h200000,48'd960,24'd2,2'd1,2'd1};
       

//         rdma_config[4] = {32'd0,32'd3,32'h100000,32'd64,32'd0};


//         rdma_config[5] = {32'd0,32'd3,32'h100000,32'h200000,32'd0};    
//         $writememh("config_big_rd_wr.hex",rdma_config);
//     end


// endmodule


// module tb_rdma_config_init(

//     );

//     reg[159:0]   rdma_config[0:127];
//     reg[15:0]   qpn_nums = 1;
//     reg[15:0]   rdma_cmd_nums = 2; 
//     reg[15:0]   mem_block_nums = 1;
//     reg[15:0]   check_mem_nums = 2;
//     integer i;

//     initial begin
//         rdma_config[0] = {96'h0,check_mem_nums,mem_block_nums,rdma_cmd_nums,qpn_nums};
//         rdma_config[1] = {32'd0,32'd3,32'h100000,32'd960,32'd1};//res,offset,length,start_addr,node_idx
//         rdma_config[2] = {32'h100000,48'd960,48'd64,24'd1,2'd0,2'd0};//length, r_addr, l_vaddr, l_qpn, rdma_cmd: 0:read 1:writre, node_idx 


//         rdma_config[3] = {32'h100000,48'h200000,48'd960,24'd2,2'd2,2'd1};
       

//         rdma_config[4] = {32'd0,32'd3,32'h100000,32'd64,32'd0};


//         rdma_config[5] = {32'd0,32'd3,32'h100000,32'h200000,32'd0};    
//         $writememh("config_big_rd_wr.hex",rdma_config);
//     end


// endmodule

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
        rdma_config[2] = {32'h1000,48'd0,48'd0,24'd1,2'd2,2'd0};//length, r_addr, l_vaddr, l_qpn, rdma_cmd: 0:read 1:writre, node_idx 

        rdma_config[3] = {32'h40,48'h0,48'd0,24'd2,2'd2,2'd0};
        rdma_config[4] = {32'h800,48'h0,48'd0,24'd2,2'd2,2'd1};
        rdma_config[5] = {32'h40,48'd0,48'd0,24'd1,2'd2,2'd1};
        
       

        rdma_config[6] = {32'd0,32'd3,32'h100000,32'd64,32'd0};


        rdma_config[7] = {32'd0,32'd3,32'h100000,32'h200000,32'd0};    
        $writememh("config_big_rd_wr.hex",rdma_config);
    end


endmodule

module testbench_IP_LOOP(

    );

    reg                 clock                         =0;
    reg                 reset                         =0;
    wire                io_s_tx_meta_0_ready          ;
    reg                 io_s_tx_meta_0_valid          =0;
    reg       [1:0]     io_s_tx_meta_0_bits_rdma_cmd  =0;
    reg       [23:0]    io_s_tx_meta_0_bits_qpn       =0;
    reg       [47:0]    io_s_tx_meta_0_bits_local_vaddr=0;
    reg       [47:0]    io_s_tx_meta_0_bits_remote_vaddr=0;
    reg       [31:0]    io_s_tx_meta_0_bits_length    =0;
    wire                io_s_tx_meta_1_ready          ;
    reg                 io_s_tx_meta_1_valid          =0;
    reg       [1:0]     io_s_tx_meta_1_bits_rdma_cmd  =0;
    reg       [23:0]    io_s_tx_meta_1_bits_qpn       =0;
    reg       [47:0]    io_s_tx_meta_1_bits_local_vaddr=0;
    reg       [47:0]    io_s_tx_meta_1_bits_remote_vaddr=0;
    reg       [31:0]    io_s_tx_meta_1_bits_length    =0;
    wire                io_s_send_data_0_ready        ;
    reg                 io_s_send_data_0_valid        =0;
    reg                 io_s_send_data_0_bits_last    =0;
    reg       [511:0]   io_s_send_data_0_bits_data    =0;
    reg       [63:0]    io_s_send_data_0_bits_keep    =0;
    wire                io_s_send_data_1_ready        ;
    reg                 io_s_send_data_1_valid        =0;
    reg                 io_s_send_data_1_bits_last    =0;
    reg       [511:0]   io_s_send_data_1_bits_data    =0;
    reg       [63:0]    io_s_send_data_1_bits_keep    =0;
    reg                 io_m_recv_data_0_ready        =0;
    wire                io_m_recv_data_0_valid        ;
    wire                io_m_recv_data_0_bits_last    ;
    wire      [511:0]   io_m_recv_data_0_bits_data    ;
    wire      [63:0]    io_m_recv_data_0_bits_keep    ;
    reg                 io_m_recv_data_1_ready        =0;
    wire                io_m_recv_data_1_valid        ;
    wire                io_m_recv_data_1_bits_last    ;
    wire      [511:0]   io_m_recv_data_1_bits_data    ;
    wire      [63:0]    io_m_recv_data_1_bits_keep    ;
    reg                 io_m_recv_meta_0_ready        =0;
    wire                io_m_recv_meta_0_valid        ;
    wire      [15:0]    io_m_recv_meta_0_bits_qpn     ;
    wire      [23:0]    io_m_recv_meta_0_bits_msg_num ;
    wire      [20:0]    io_m_recv_meta_0_bits_pkg_num ;
    wire      [20:0]    io_m_recv_meta_0_bits_pkg_total;
    reg                 io_m_recv_meta_1_ready        =0;
    wire                io_m_recv_meta_1_valid        ;
    wire      [15:0]    io_m_recv_meta_1_bits_qpn     ;
    wire      [23:0]    io_m_recv_meta_1_bits_msg_num ;
    wire      [20:0]    io_m_recv_meta_1_bits_pkg_num ;
    wire      [20:0]    io_m_recv_meta_1_bits_pkg_total;
    reg                 io_m_cmpt_meta_0_ready        =0;
    wire                io_m_cmpt_meta_0_valid        ;
    wire      [15:0]    io_m_cmpt_meta_0_bits_qpn     ;
    wire      [23:0]    io_m_cmpt_meta_0_bits_msg_num ;
    wire      [1:0]     io_m_cmpt_meta_0_bits_msg_type;
    reg                 io_m_cmpt_meta_1_ready        =0;
    wire                io_m_cmpt_meta_1_valid        ;
    wire      [15:0]    io_m_cmpt_meta_1_bits_qpn     ;
    wire      [23:0]    io_m_cmpt_meta_1_bits_msg_num ;
    wire      [1:0]     io_m_cmpt_meta_1_bits_msg_type;
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
    reg       [15:0]    io_qp_init_0_bits_qpn         =0;
    reg       [23:0]    io_qp_init_0_bits_local_psn   =0;
    reg       [23:0]    io_qp_init_0_bits_remote_psn  =0;
    reg       [23:0]    io_qp_init_0_bits_remote_qpn  =0;
    reg       [31:0]    io_qp_init_0_bits_remote_ip   =0;
    reg       [15:0]    io_qp_init_0_bits_remote_udp_port=0;
    reg       [23:0]    io_qp_init_0_bits_credit      =0;
    wire                io_qp_init_1_ready            ;
    reg                 io_qp_init_1_valid            =0;
    reg       [15:0]    io_qp_init_1_bits_qpn         =0;
    reg       [23:0]    io_qp_init_1_bits_local_psn   =0;
    reg       [23:0]    io_qp_init_1_bits_remote_psn  =0;
    reg       [23:0]    io_qp_init_1_bits_remote_qpn  =0;
    reg       [31:0]    io_qp_init_1_bits_remote_ip   =0;
    reg       [15:0]    io_qp_init_1_bits_remote_udp_port=0;
    reg       [23:0]    io_qp_init_1_bits_credit      =0;
    reg       [31:0]    io_local_ip_address_0         =0;
    reg       [31:0]    io_local_ip_address_1         =0;
    wire                io_arp_req_0_ready            ;
    reg                 io_arp_req_0_valid            =0;
    reg       [31:0]    io_arp_req_0_bits             =0;
    wire                io_arp_req_1_ready            ;
    reg                 io_arp_req_1_valid            =0;
    reg       [31:0]    io_arp_req_1_bits             =0;
    reg                 io_arp_rsp_0_ready            =0;
    wire                io_arp_rsp_0_valid            ;
    wire      [47:0]    io_arp_rsp_0_bits_mac_addr    ;
    wire                io_arp_rsp_0_bits_hit         ;
    reg                 io_arp_rsp_1_ready            =0;
    wire                io_arp_rsp_1_valid            ;
    wire      [47:0]    io_arp_rsp_1_bits_mac_addr    ;
    wire                io_arp_rsp_1_bits_hit         ;
    wire      [31:0]    io_reports                    ;
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



IN#(154)in_io_s_tx_meta_0(
        clock,
        reset,
        {io_s_tx_meta_0_bits_rdma_cmd,io_s_tx_meta_0_bits_qpn,io_s_tx_meta_0_bits_local_vaddr,io_s_tx_meta_0_bits_remote_vaddr,io_s_tx_meta_0_bits_length},
        io_s_tx_meta_0_valid,
        io_s_tx_meta_0_ready
);
// rdma_cmd, qpn, local_vaddr, remote_vaddr, length
// 2'h0, 24'h0, 48'h0, 48'h0, 32'h0

IN#(154)in_io_s_tx_meta_1(
        clock,
        reset,
        {io_s_tx_meta_1_bits_rdma_cmd,io_s_tx_meta_1_bits_qpn,io_s_tx_meta_1_bits_local_vaddr,io_s_tx_meta_1_bits_remote_vaddr,io_s_tx_meta_1_bits_length},
        io_s_tx_meta_1_valid,
        io_s_tx_meta_1_ready
);
// rdma_cmd, qpn, local_vaddr, remote_vaddr, length
// 2'h0, 24'h0, 48'h0, 48'h0, 32'h0

// IN#(577)in_io_s_send_data_0(
//         clock,
//         reset,
//         {io_s_send_data_0_bits_last,io_s_send_data_0_bits_data,io_s_send_data_0_bits_keep},
//         io_s_send_data_0_valid,
//         io_s_send_data_0_ready
// );
// last, data, keep
// 1'h0, 512'h0, 64'h0

// IN#(577)in_io_s_send_data_1(
//         clock,
//         reset,
//         {io_s_send_data_1_bits_last,io_s_send_data_1_bits_data,io_s_send_data_1_bits_keep},
//         io_s_send_data_1_valid,
//         io_s_send_data_1_ready
// );
// last, data, keep
// 1'h0, 512'h0, 64'h0

OUT#(577)out_io_m_recv_data_0(
        clock,
        reset,
        {io_m_recv_data_0_bits_last,io_m_recv_data_0_bits_data,io_m_recv_data_0_bits_keep},
        io_m_recv_data_0_valid,
        io_m_recv_data_0_ready
);
// last, data, keep
// 1'h0, 512'h0, 64'h0

OUT#(577)out_io_m_recv_data_1(
        clock,
        reset,
        {io_m_recv_data_1_bits_last,io_m_recv_data_1_bits_data,io_m_recv_data_1_bits_keep},
        io_m_recv_data_1_valid,
        io_m_recv_data_1_ready
);
// last, data, keep
// 1'h0, 512'h0, 64'h0

OUT#(82)out_io_m_recv_meta_0(
        clock,
        reset,
        {io_m_recv_meta_0_bits_qpn,io_m_recv_meta_0_bits_msg_num,io_m_recv_meta_0_bits_pkg_num,io_m_recv_meta_0_bits_pkg_total},
        io_m_recv_meta_0_valid,
        io_m_recv_meta_0_ready
);
// qpn, msg_num, pkg_num, pkg_total
// 16'h0, 24'h0, 21'h0, 21'h0

OUT#(82)out_io_m_recv_meta_1(
        clock,
        reset,
        {io_m_recv_meta_1_bits_qpn,io_m_recv_meta_1_bits_msg_num,io_m_recv_meta_1_bits_pkg_num,io_m_recv_meta_1_bits_pkg_total},
        io_m_recv_meta_1_valid,
        io_m_recv_meta_1_ready
);
// qpn, msg_num, pkg_num, pkg_total
// 16'h0, 24'h0, 21'h0, 21'h0

OUT#(42)out_io_m_cmpt_meta_0(
        clock,
        reset,
        {io_m_cmpt_meta_0_bits_qpn,io_m_cmpt_meta_0_bits_msg_num,io_m_cmpt_meta_0_bits_msg_type},
        io_m_cmpt_meta_0_valid,
        io_m_cmpt_meta_0_ready
);
// qpn, msg_num, msg_type
// 16'h0, 24'h0, 2'h0

OUT#(42)out_io_m_cmpt_meta_1(
        clock,
        reset,
        {io_m_cmpt_meta_1_bits_qpn,io_m_cmpt_meta_1_bits_msg_num,io_m_cmpt_meta_1_bits_msg_type},
        io_m_cmpt_meta_1_valid,
        io_m_cmpt_meta_1_ready
);
// qpn, msg_num, msg_type
// 16'h0, 24'h0, 2'h0

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


reg                 io_m_mem_read_cmd_2_ready     ;
reg                io_m_mem_read_cmd_2_valid     =0;
reg      [63:0]    io_m_mem_read_cmd_2_bits_vaddr=0;
reg      [31:0]    io_m_mem_read_cmd_2_bits_length=0;
reg                 io_m_mem_write_cmd_2_ready    ;
wire                io_m_mem_write_cmd_2_valid    =0;
wire      [63:0]    io_m_mem_write_cmd_2_bits_vaddr=0;
wire      [31:0]    io_m_mem_write_cmd_2_bits_length=0;
reg                 io_m_mem_write_data_2_ready   ;
wire                io_m_mem_write_data_2_valid   =0;
wire                io_m_mem_write_data_2_bits_last=0;
wire      [511:0]   io_m_mem_write_data_2_bits_data=0;
wire      [63:0]    io_m_mem_write_data_2_bits_keep=0;



DMA #(512) qdma2(
    clock,
    reset,
    //DMA CMD streams
    io_m_mem_read_cmd_2_valid,
    io_m_mem_read_cmd_2_ready,
    io_m_mem_read_cmd_2_bits_vaddr,
    io_m_mem_read_cmd_2_bits_length,
    io_m_mem_write_cmd_2_valid,
    io_m_mem_write_cmd_2_ready,
    io_m_mem_write_cmd_2_bits_vaddr,
    io_m_mem_write_cmd_2_bits_length,        
    //DMA Data streams      
    io_s_send_data_0_valid,
    io_s_send_data_0_ready,
    io_s_send_data_0_bits_data,
    io_s_send_data_0_bits_keep,
    io_s_send_data_0_bits_last,
    io_m_mem_write_data_2_valid,
    io_m_mem_write_data_2_ready,
    io_m_mem_write_data_2_bits_data,
    io_m_mem_write_data_2_bits_keep,
    io_m_mem_write_data_2_bits_last        
);


reg                 io_m_mem_read_cmd_3_ready     ;
reg                 io_m_mem_read_cmd_3_valid     =0;
reg      [63:0]     io_m_mem_read_cmd_3_bits_vaddr=0;
reg      [31:0]     io_m_mem_read_cmd_3_bits_length=0;
reg                 io_m_mem_write_cmd_3_ready    ;
wire                io_m_mem_write_cmd_3_valid    =0;
wire      [63:0]    io_m_mem_write_cmd_3_bits_vaddr=0;
wire      [31:0]    io_m_mem_write_cmd_3_bits_length=0;
reg                 io_m_mem_write_data_3_ready   ;
wire                io_m_mem_write_data_3_valid   =0;
wire                io_m_mem_write_data_3_bits_last=0;
wire      [511:0]   io_m_mem_write_data_3_bits_data=0;
wire      [63:0]    io_m_mem_write_data_3_bits_keep=0;



DMA #(512) qdma3(
    clock,
    reset,
    //DMA CMD streams
    io_m_mem_read_cmd_3_valid,
    io_m_mem_read_cmd_3_ready,
    io_m_mem_read_cmd_3_bits_vaddr,
    io_m_mem_read_cmd_3_bits_length,
    io_m_mem_write_cmd_3_valid,
    io_m_mem_write_cmd_3_ready,
    io_m_mem_write_cmd_3_bits_vaddr,
    io_m_mem_write_cmd_3_bits_length,        
    //DMA Data streams      
    io_s_send_data_1_valid,
    io_s_send_data_1_ready,
    io_s_send_data_1_bits_data,
    io_s_send_data_1_bits_keep,
    io_s_send_data_1_bits_last,
    io_m_mem_write_data_3_valid,
    io_m_mem_write_data_3_ready,
    io_m_mem_write_data_3_bits_data,
    io_m_mem_write_data_3_bits_keep,
    io_m_mem_write_data_3_bits_last        
);


IN#(160)in_io_qp_init_0(
        clock,
        reset,
        {io_qp_init_0_bits_qpn,io_qp_init_0_bits_local_psn,io_qp_init_0_bits_remote_psn,io_qp_init_0_bits_remote_qpn,io_qp_init_0_bits_remote_ip,io_qp_init_0_bits_remote_udp_port,io_qp_init_0_bits_credit},
        io_qp_init_0_valid,
        io_qp_init_0_ready
);
// qpn, local_psn, remote_psn, remote_qpn, remote_ip, remote_udp_port, credit
// 16'h0, 24'h0, 24'h0, 24'h0, 32'h0, 16'h0, 24'h0

IN#(160)in_io_qp_init_1(
        clock,
        reset,
        {io_qp_init_1_bits_qpn,io_qp_init_1_bits_local_psn,io_qp_init_1_bits_remote_psn,io_qp_init_1_bits_remote_qpn,io_qp_init_1_bits_remote_ip,io_qp_init_1_bits_remote_udp_port,io_qp_init_1_bits_credit},
        io_qp_init_1_valid,
        io_qp_init_1_ready
);
// qpn, local_psn, remote_psn, remote_qpn, remote_ip, remote_udp_port, credit
// 16'h0, 24'h0, 24'h0, 24'h0, 32'h0, 16'h0, 24'h0
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

IP_LOOP IP_LOOP_inst(
        .*
);

tb_rdma_config_init tb_rdma_config_init();

reg[159:0]   rdma_config[0:1023];
reg[15:0]   qpn_nums, rdma_cmd_nums, mem_block_nums, check_mem_nums;
reg[31:0]   start_addr, length, offset;
integer i,j;


//test read write
// initial begin
//         reset <= 1;
//         clock = 1;
//         $readmemh("config_big_rd_wr.hex", rdma_config);
//         #1000;
//         reset <= 0;
//         #100;
//         out_io_m_recv_data_0.start();
//         out_io_m_recv_data_1.start();
//         out_io_m_recv_meta_0.start();
//         out_io_m_recv_meta_1.start();
//         out_io_m_cmpt_meta_0.start();
//         out_io_m_cmpt_meta_1.start();
//         #100
//         qpn_nums        = rdma_config[0][15:0];
//         rdma_cmd_nums   = rdma_config[0][31:16];
//         mem_block_nums  = rdma_config[0][47:32];
//         check_mem_nums  = rdma_config[0][63:48];
//         for(i=0;i<mem_block_nums;i=i+1)begin
//             if(rdma_config[i+1][1:0])begin
//                 qdma1.init_incr(rdma_config[i+1][63:32],rdma_config[i+1][95:64],rdma_config[i+1][127:96]);
//             end
//             else begin
//                 qdma0.init_incr(rdma_config[i+1][63:32],rdma_config[i+1][95:64],rdma_config[i+1][127:96]);
//             end
//         end


//         #200;
//         in_io_fc_init_0.write({24'd1,8'd0,16'd1600,24'd0,1'b0});     // qpn, op_code, credit, psn// 24'h0, 8'h0, 16'h0, 24'h0
//         in_io_fc_init_1.write({24'd2,8'd0,16'd1600,24'd0,1'b0});

//         in_io_conn_init_0.write({24'd1,24'd2,32'h01bda8c0,16'd17});//l_qpn,r_qpn,r_ip,r_udup_port
//         in_io_conn_init_1.write({24'd2,24'd1,32'h02bda8c0,16'd17});

//         in_io_psn_init_0.write({24'd1,24'd1000,24'd4000});// qpn, local_psn, remote_psn
//         in_io_psn_init_1.write({24'd2,24'd4000,24'd1000});// 24'h0, 24'h0, 24'h0

//         #2000
//         for(i=0;i<rdma_cmd_nums;i=i+1)begin
//             if(rdma_config[i+mem_block_nums+1][1:0])begin
//                 in_io_s_tx_meta_1.write({rdma_config[i+mem_block_nums+1][3:2],rdma_config[i+mem_block_nums+1][27:4],rdma_config[i+mem_block_nums+1][75:28],rdma_config[i+mem_block_nums+1][123:76],rdma_config[i+mem_block_nums+1][155:124]});
//             end
//             else begin
//                 in_io_s_tx_meta_0.write({rdma_config[i+mem_block_nums+1][3:2],rdma_config[i+mem_block_nums+1][27:4],rdma_config[i+mem_block_nums+1][75:28],rdma_config[i+mem_block_nums+1][123:76],rdma_config[i+mem_block_nums+1][155:124]});
//             end
//         end
//         #1000000
//         for(i=0;i<check_mem_nums;i=i+1)begin
//             if(rdma_config[i+mem_block_nums+rdma_cmd_nums+1][1:0])begin
//                 qdma1.check_mem(rdma_config[i+mem_block_nums+rdma_cmd_nums+1][63:32],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][95:64],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][127:96]);
//             end
//             else begin
//                 qdma0.check_mem(rdma_config[i+mem_block_nums+rdma_cmd_nums+1][63:32],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][95:64],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][127:96]);
//             end
//         end

// end

//test send



initial begin
    reset <= 1;
    clock = 1;
    io_local_ip_address_0         =32'h01bda8c0;
    io_local_ip_address_1         =32'h02bda8c0;    
    $readmemh("config_big_rd_wr.hex", rdma_config);
    #1000;
    reset <= 0;
    #100;
    out_io_m_recv_data_0.start();
    out_io_m_recv_data_1.start();
    out_io_m_recv_meta_0.start();
    out_io_m_recv_meta_1.start();
    out_io_m_cmpt_meta_0.start();
    out_io_m_cmpt_meta_1.start();
    out_io_arp_rsp_0.start();
    out_io_arp_rsp_1.start();
    #100
    in_io_arp_req_0.write(32'h02bda8c0);
    in_io_arp_req_1.write(32'h01bda8c0);
    #25000
    qpn_nums        = rdma_config[0][15:0];
    rdma_cmd_nums   = rdma_config[0][31:16];
    mem_block_nums  = rdma_config[0][47:32];
    check_mem_nums  = rdma_config[0][63:48];
    for(i=0;i<mem_block_nums;i=i+1)begin
        if(rdma_config[i+1][1:0])begin
            qdma1.init_incr(rdma_config[i+1][63:32],rdma_config[i+1][95:64],rdma_config[i+1][127:96]);
        end
        else begin
            qdma0.init_incr(rdma_config[i+1][63:32],rdma_config[i+1][95:64],rdma_config[i+1][127:96]);
        end
    end


    #200;
    in_io_qp_init_0.write({16'd1,24'd1000,24'd4000,24'd1,32'h02bda8c0,16'd17,24'd3200});     // qpn, op_code, credit, psn// 24'h0, 8'h0, 16'h0, 24'h0
    in_io_qp_init_1.write({16'd1,24'd4000,24'd1000,24'd1,32'h01bda8c0,16'd17,24'd3200});
    in_io_qp_init_0.write({16'd2,24'd10000,24'd40000,24'd2,32'h02bda8c0,16'd17,24'd3200});     // qpn, op_code, credit, psn// 24'h0, 8'h0, 16'h0, 24'h0
    in_io_qp_init_1.write({16'd2,24'd40000,24'd10000,24'd2,32'h01bda8c0,16'd17,24'd3200});
// qpn, local_psn, remote_psn, remote_qpn, remote_ip, remote_udp_port, credit
// 16'h0, 24'h0, 24'h0, 24'h0, 32'h0, 16'h0, 24'h0

    #2000
    for(i=0;i<rdma_cmd_nums;i=i+1)begin
        if(rdma_config[i+mem_block_nums+1][1:0])begin
            for(j=0;j<1024;j++)begin
                in_io_s_tx_meta_1.write({rdma_config[i+mem_block_nums+1][3:2],rdma_config[i+mem_block_nums+1][27:4],rdma_config[i+mem_block_nums+1][75:28],rdma_config[i+mem_block_nums+1][123:76],rdma_config[i+mem_block_nums+1][155:124]});// rdma_cmd, qpn, local_vaddr, remote_vaddr, length
                if(rdma_config[i+mem_block_nums+1][3:2]==2)begin
                    io_m_mem_read_cmd_3_valid       = 1;
                    io_m_mem_read_cmd_3_bits_vaddr  = 0;
                    io_m_mem_read_cmd_3_bits_length = (2048+64)*1024;                
                end
            end
        end
        else begin
            for(j=0;j<1024;j++)begin
                in_io_s_tx_meta_0.write({rdma_config[i+mem_block_nums+1][3:2],rdma_config[i+mem_block_nums+1][27:4],rdma_config[i+mem_block_nums+1][75:28],rdma_config[i+mem_block_nums+1][123:76],rdma_config[i+mem_block_nums+1][155:124]});
                if(rdma_config[i+mem_block_nums+1][3:2]==2)begin
                    io_m_mem_read_cmd_2_valid       = 1;
                    io_m_mem_read_cmd_2_bits_vaddr  = 0;
                    io_m_mem_read_cmd_2_bits_length = (4096+64)*1024;                
                end            
            end
        end
    end

    #10
    io_m_mem_read_cmd_2_valid       = 0;
    #3000000



    for(i=0;i<check_mem_nums;i=i+1)begin
        if(rdma_config[i+mem_block_nums+rdma_cmd_nums+1][1:0])begin
            qdma1.check_mem(rdma_config[i+mem_block_nums+rdma_cmd_nums+1][63:32],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][95:64],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][127:96]);
        end
        else begin
            qdma0.check_mem(rdma_config[i+mem_block_nums+rdma_cmd_nums+1][63:32],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][95:64],rdma_config[i+mem_block_nums+rdma_cmd_nums+1][127:96]);
        end
    end

end



always #5 clock=~clock;

endmodule