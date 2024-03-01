package ddr

import chisel3._
import chisel3.util._
import chisel3.experimental.{DataMirror, requireIsChiselType,Analog}

class DDR4_mig_blackbox(IP_CORE_NAME : String = "DDR4_mig_blackbox") extends BlackBox{
      override val desiredName = IP_CORE_NAME
    val io = IO(new Bundle{
        val sys_rst                          =Input(UInt(1.W))
        val c0_sys_clk_i                     =Input(Clock())     
        val c0_init_calib_complete           =Output(UInt(1.W))
        val c0_ddr4_act_n                    =Output(UInt(1.W))
        val c0_ddr4_adr                      =Output(UInt(17.W))
        val c0_ddr4_ba                       =Output(UInt(2.W))
        val c0_ddr4_bg                       =Output(UInt(2.W))
        val c0_ddr4_cke                      =Output(UInt(1.W))
        val c0_ddr4_odt                      =Output(UInt(1.W))
        val c0_ddr4_cs_n                     =Output(UInt(1.W))
        val c0_ddr4_ck_t                     =Output(UInt(1.W))
        val c0_ddr4_ck_c                     =Output(UInt(1.W))
        val c0_ddr4_reset_n                  =Output(UInt(1.W))
        val c0_ddr4_parity                   =Output(UInt(1.W))
        val c0_ddr4_dq                       =Analog(72.W)
        val c0_ddr4_dqs_c                    =Analog(18.W)
        val c0_ddr4_dqs_t                    =Analog(18.W)
        val c0_ddr4_ui_clk                   =Output(Clock())
        val c0_ddr4_ui_clk_sync_rst          =Output(UInt(1.W))
        val addn_ui_clkout1                  =Output(UInt(1.W))
        val dbg_clk                          =Output(UInt(1.W))
     // AXI CTRL port
        val c0_ddr4_s_axi_ctrl_awvalid       =Input(UInt(1.W))  
        val c0_ddr4_s_axi_ctrl_awready       =Output(UInt(1.W))  
        val c0_ddr4_s_axi_ctrl_awaddr        =Input(UInt(32.W))  
     // Slave Interface Write Data Ports
        val c0_ddr4_s_axi_ctrl_wvalid        =Input(UInt(1.W))  
        val c0_ddr4_s_axi_ctrl_wready        =Output(UInt(1.W))  
        val c0_ddr4_s_axi_ctrl_wdata         =Input(UInt(32.W))  
     // Slave Interface Write Response Ports
        val c0_ddr4_s_axi_ctrl_bvalid        =Output(UInt(1.W))  
        val c0_ddr4_s_axi_ctrl_bready        =Input(UInt(1.W))  
        val c0_ddr4_s_axi_ctrl_bresp         =Output(UInt(2.W))  
     // Slave Interface Read Address Ports
        val c0_ddr4_s_axi_ctrl_arvalid       =Input(UInt(1.W))  
        val c0_ddr4_s_axi_ctrl_arready       =Output(UInt(1.W))  
        val c0_ddr4_s_axi_ctrl_araddr        =Input(UInt(32.W))    
     // Slave Interface Read Data Ports
        val c0_ddr4_s_axi_ctrl_rvalid        =Output(UInt(1.W))  
        val c0_ddr4_s_axi_ctrl_rready        =Input(UInt(1.W))  
        val c0_ddr4_s_axi_ctrl_rdata         =Output(UInt(32.W))  
        val c0_ddr4_s_axi_ctrl_rresp         =Output(UInt(2.W))  
     // Interrupt output
        val c0_ddr4_interrupt                   =Output(UInt(1.W))
  // Slave Interface Write Address Ports
        val c0_ddr4_aresetn                     =Input(UInt(1.W))
        val c0_ddr4_s_axi_awid                  =Input(UInt(4.W))  //aw
        val c0_ddr4_s_axi_awaddr                =Input(UInt(34.W)) //aw
        val c0_ddr4_s_axi_awlen                 =Input(UInt(8.W))  //aw
        val c0_ddr4_s_axi_awsize                =Input(UInt(3.W))  //aw
        val c0_ddr4_s_axi_awburst               =Input(UInt(2.W))  //aw
        val c0_ddr4_s_axi_awlock                =Input(UInt(1.W))  //aw
        val c0_ddr4_s_axi_awcache               =Input(UInt(4.W))  //aw
        val c0_ddr4_s_axi_awprot                =Input(UInt(3.W))  //aw
        val c0_ddr4_s_axi_awqos                 =Input(UInt(4.W))  //aw
        val c0_ddr4_s_axi_awready               =Output(UInt(1.W)) //aw
        val c0_ddr4_s_axi_awvalid               =Input(UInt(1.W))   //aw   
  // Slave Interface Write Data Ports
        val c0_ddr4_s_axi_wdata                 =Input(UInt(512.W))  // w
        val c0_ddr4_s_axi_wstrb                 =Input(UInt(64.W))  // w
        val c0_ddr4_s_axi_wlast                 =Input(UInt(1.W))  // w
        val c0_ddr4_s_axi_wvalid                =Input(UInt(1.W))  //w
        val c0_ddr4_s_axi_wready                =Output(UInt(1.W))  //w
  // Slave Interface Write Response Ports
        val c0_ddr4_s_axi_bid                   =Output(UInt(4.W))  //b
        val c0_ddr4_s_axi_bresp                 =Output(UInt(2.W))  //b
        val c0_ddr4_s_axi_bvalid                =Output(UInt(1.W))  //b
        val c0_ddr4_s_axi_bready                =Input(UInt(1.W))  //b
  // Slave Interface Read Address Ports                           
        val c0_ddr4_s_axi_arid                  =Input(UInt(4.W))  //ar
        val c0_ddr4_s_axi_araddr                =Input(UInt(34.W)) //ar
        val c0_ddr4_s_axi_arlen                 =Input(UInt(8.W))  //ar
        val c0_ddr4_s_axi_arsize                =Input(UInt(3.W))  //ar
        val c0_ddr4_s_axi_arburst               =Input(UInt(2.W))  //ar
        val c0_ddr4_s_axi_arlock                =Input(UInt(1.W))  //ar
        val c0_ddr4_s_axi_arcache               =Input(UInt(4.W))  //ar
        val c0_ddr4_s_axi_arprot                =Input(UInt(3.W))  //ar
        val c0_ddr4_s_axi_arqos                 =Input(UInt(4.W))  //ar    
        val c0_ddr4_s_axi_arready               =Output(UInt(1.W)) //ar
        val c0_ddr4_s_axi_arvalid               =Input(UInt(1.W))  //ar    
  // Slave Interface Read Data Ports
        val c0_ddr4_s_axi_rid                   =Output(UInt(4.W))     //r
        val c0_ddr4_s_axi_rdata                 =Output(UInt(512.W))  //r
        val c0_ddr4_s_axi_rresp                 =Output(UInt(2.W))  //r
        val c0_ddr4_s_axi_rlast                 =Output(UInt(1.W))  //r
        val c0_ddr4_s_axi_rvalid                =Output(UInt(1.W))  //r
        val c0_ddr4_s_axi_rready                =Input(UInt(1.W))    //r
  // Debug Port
        val dbg_bus                             =Output(UInt(512.W))                                           

    })


}
