package ddr
import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._
import common.ToZero
import common.axi

class DDR_DRIVER (ENABLE_AXI_CTRL		: Boolean=false,
                  BOARD: String="u280",
                  CHANNEL			: Int=0,
                  IP_CORE_NAME  : String="DDR4_mig_blackbox")
  extends RawModule {
   val io = IO(new Bundle {
   
    /////////ddr0 input clock
    //val ddr0_sys_100M_p=Input(Clock())                       
    //val ddr0_sys_100M_n=Input(Clock())      
    //val ddriver_clk=Input(Clock())                   
    ///////////ddr0 PHY interface
    val ddrpin		= new DDRPin()   
    ///////////ddr0 user interface
	  val user_clk  =Output(Clock())         
    val user_rst        =Output(UInt(1.W))        
     
    ///////////     AXI interface
    val axi         = Flipped(new AXI(34,512,4,0,8))
    val axi_ctrl         = if (ENABLE_AXI_CTRL) {Some(Flipped(new AXI(32,32,0,0,0)))} else None
  })
    def getTCL() = {
      val board_inf = (BOARD, CHANNEL) match {
            case ("u280", 0) => "yes"
            case ("u280", 1) => "yes"
            case default => require(false, "Invalid board and CHANNEL pair for DDR!")
        }
      val s1=f"\ncreate_ip -name ddr4 -vendor xilinx.com -library ip -version 2.2 -module_name ${IP_CORE_NAME}"
      val s2=f"\nset_property -dict [list CONFIG.C0_DDR4_BOARD_INTERFACE {ddr4_sdram_c${CHANNEL}} CONFIG.C0.DDR4_TimePeriod {833} CONFIG.C0.DDR4_InputClockPeriod {9996} CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} CONFIG.C0.DDR4_MemoryType {RDIMMs} CONFIG.C0.DDR4_MemoryPart {MTA18ASF2G72PZ-2G3} CONFIG.C0.DDR4_DataWidth {72} CONFIG.C0.DDR4_DataMask {NONE} CONFIG.C0.DDR4_Ecc {true} CONFIG.C0.DDR4_AxiSelection {true} CONFIG.C0.DDR4_AUTO_AP_COL_A3 {false} CONFIG.C0.DDR4_CasLatency {17} CONFIG.C0.DDR4_CasWriteLatency {12} CONFIG.C0.DDR4_AxiDataWidth {512} CONFIG.C0.DDR4_AxiAddressWidth {34} CONFIG.C0.DDR4_Mem_Add_Map {ROW_COLUMN_BANK} CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {100} CONFIG.System_Clock {No_Buffer} CONFIG.C0.CKE_WIDTH {1} CONFIG.C0.CS_WIDTH {1} CONFIG.C0.ODT_WIDTH {1}] [get_ips ${IP_CORE_NAME}] "
      println(s1+s2)
	  }
    io.axi.r.bits.user <>DontCare
    io.axi.b.bits.user <>DontCare
    val init_complete    =Wire(UInt(1.W))
    /*
    /  unused axi interface:
    /     axi.aw.user   axi.ar.user    axi.w.user  axi.r.user   (UInt(USER_WIDTH.W))
    /     
    */
    // ToZero(io.axi.b.bits.user)
    // ToZero(io.axi.r.bits.user)
    // ToZero(io.axi_ctrl.r.bits.id)
    // ToZero(io.axi_ctrl.b.bits.id)
    // ToZero(io.axi_ctrl.b.bits.user)
    // ToZero(io.axi_ctrl.r.bits.last)
    // ToZero(io.axi_ctrl.r.bits.user)
    val ddr0Sys100M = IBUFDS(io.ddrpin.ddr0_sys_100M_p,io.ddrpin.ddr0_sys_100M_n)
    
    val DDR0_sys_clk=BUFG(ddr0Sys100M)


   
    val instDDR = Module(new DDR4_mig_blackbox(IP_CORE_NAME = IP_CORE_NAME))
    ////////////DDR interface
    instDDR.io.sys_rst                <>0.U
    instDDR.io.c0_sys_clk_i           :=DDR0_sys_clk
    init_complete           :=instDDR.io.c0_init_calib_complete
    io.ddrpin.act_n           :=instDDR.io.c0_ddr4_act_n
    io.ddrpin.adr             :=instDDR.io.c0_ddr4_adr
    io.ddrpin.ba              :=instDDR.io.c0_ddr4_ba
    io.ddrpin.bg              :=instDDR.io.c0_ddr4_bg
    io.ddrpin.cke             :=instDDR.io.c0_ddr4_cke
    io.ddrpin.odt             :=instDDR.io.c0_ddr4_odt
    io.ddrpin.cs_n            :=instDDR.io.c0_ddr4_cs_n
    io.ddrpin.ck_t            :=instDDR.io.c0_ddr4_ck_t
    io.ddrpin.ck_c            :=instDDR.io.c0_ddr4_ck_c
    io.ddrpin.reset_n         :=instDDR.io.c0_ddr4_reset_n 

    io.ddrpin.parity          :=instDDR.io.c0_ddr4_parity
    io.ddrpin.dq              <>instDDR.io.c0_ddr4_dq
    io.ddrpin.dqs_c           <>instDDR.io.c0_ddr4_dqs_c
    io.ddrpin.dqs_t           <>instDDR.io.c0_ddr4_dqs_t

    io.user_clk                            :=instDDR.io.c0_ddr4_ui_clk
    io.user_rst                            :=instDDR.io.c0_ddr4_ui_clk_sync_rst|(~(init_complete))
    instDDR.io.addn_ui_clkout1        <> DontCare
    instDDR.io.dbg_clk                <> DontCare
    if(ENABLE_AXI_CTRL)
    {
      // AXI CTRL port
      instDDR.io.c0_ddr4_s_axi_ctrl_awvalid          :=io.axi_ctrl.get.aw.valid
      io.axi_ctrl.get.aw.ready                           :=instDDR.io.c0_ddr4_s_axi_ctrl_awready     
      instDDR.io.c0_ddr4_s_axi_ctrl_awaddr           :=io.axi_ctrl.get.aw.bits.addr 
       // Slave Interface Write Data Ports
      instDDR.io.c0_ddr4_s_axi_ctrl_wvalid           :=io.axi_ctrl.get.w.valid
      io.axi_ctrl.get.w.ready                            := instDDR.io.c0_ddr4_s_axi_ctrl_wready        
      instDDR.io.c0_ddr4_s_axi_ctrl_wdata            :=io.axi_ctrl.get.w.bits.data
       // Slave Interface Write Response Ports
      io.axi_ctrl.get.b.valid                         := instDDR.io.c0_ddr4_s_axi_ctrl_bvalid       
      instDDR.io.c0_ddr4_s_axi_ctrl_bready           :=io.axi_ctrl.get.b.ready
      io.axi_ctrl.get.b.bits.resp                     :=instDDR.io.c0_ddr4_s_axi_ctrl_bresp        
       // Slave Interface Read Address Ports
      instDDR.io.c0_ddr4_s_axi_ctrl_arvalid          :=io.axi_ctrl.get.ar.valid
      io.axi_ctrl.get.ar.ready                           := instDDR.io.c0_ddr4_s_axi_ctrl_arready       
      instDDR.io.c0_ddr4_s_axi_ctrl_araddr           :=io.axi_ctrl.get.ar.bits.addr
       // Slave Interface Read Data Ports
      io.axi_ctrl.get.r.valid                            :=   instDDR.io.c0_ddr4_s_axi_ctrl_rvalid        
      instDDR.io.c0_ddr4_s_axi_ctrl_rready           :=io.axi_ctrl.get.r.ready
      io.axi_ctrl.get.r.bits.data                        :=instDDR.io.c0_ddr4_s_axi_ctrl_rdata         
      io.axi_ctrl.get.r.bits.resp                        :=instDDR.io.c0_ddr4_s_axi_ctrl_rresp     
    }
    if(!ENABLE_AXI_CTRL)
    {
     instDDR.io.c0_ddr4_s_axi_ctrl_awvalid       :=0.U
     instDDR.io.c0_ddr4_s_axi_ctrl_awready       <>DontCare
     instDDR.io.c0_ddr4_s_axi_ctrl_awaddr        :=0.U
     instDDR.io.c0_ddr4_s_axi_ctrl_wvalid        :=0.U
     instDDR.io.c0_ddr4_s_axi_ctrl_wready        <>DontCare
     instDDR.io.c0_ddr4_s_axi_ctrl_wdata         :=0.U
     instDDR.io.c0_ddr4_s_axi_ctrl_bvalid        <>DontCare
     instDDR.io.c0_ddr4_s_axi_ctrl_bready        :=1.U
     instDDR.io.c0_ddr4_s_axi_ctrl_bresp         <>DontCare
     instDDR.io.c0_ddr4_s_axi_ctrl_arvalid       :=0.U
     instDDR.io.c0_ddr4_s_axi_ctrl_arready       <>DontCare
     instDDR.io.c0_ddr4_s_axi_ctrl_araddr        :=0.U
     instDDR.io.c0_ddr4_s_axi_ctrl_rvalid        <>DontCare
     instDDR.io.c0_ddr4_s_axi_ctrl_rready        :=1.U
     instDDR.io.c0_ddr4_s_axi_ctrl_rdata         <>DontCare
     instDDR.io.c0_ddr4_s_axi_ctrl_rresp         <>DontCare
    }
     // Interrupt output
    instDDR.io.c0_ddr4_interrupt                   <> DontCare
  // Slave Interface Write Address Ports
    instDDR.io.c0_ddr4_aresetn                          :=   ~ io.user_rst

    instDDR.io.c0_ddr4_s_axi_awid                  :=io.axi.aw.bits.id
    instDDR.io.c0_ddr4_s_axi_awaddr                :=io.axi.aw.bits.addr
    instDDR.io.c0_ddr4_s_axi_awlen                 :=io.axi.aw.bits.len
    instDDR.io.c0_ddr4_s_axi_awsize                :=io.axi.aw.bits.size
    instDDR.io.c0_ddr4_s_axi_awburst               :=io.axi.aw.bits.burst
    instDDR.io.c0_ddr4_s_axi_awlock                :=io.axi.aw.bits.lock
    instDDR.io.c0_ddr4_s_axi_awcache               :=io.axi.aw.bits.cache
    instDDR.io.c0_ddr4_s_axi_awprot                :=io.axi.aw.bits.prot
    instDDR.io.c0_ddr4_s_axi_awqos                 :=io.axi.aw.bits.qos
    instDDR.io.c0_ddr4_s_axi_awvalid               :=io.axi.aw.valid
    io.axi.aw.ready                                :=instDDR.io.c0_ddr4_s_axi_awready               
  // Slave Interface Write Data Ports
    instDDR.io.c0_ddr4_s_axi_wdata                 :=io.axi.w.bits.data
    instDDR.io.c0_ddr4_s_axi_wstrb                 :=io.axi.w.bits.strb
    instDDR.io.c0_ddr4_s_axi_wlast                 :=io.axi.w.bits.last
    instDDR.io.c0_ddr4_s_axi_wvalid                :=io.axi.w.valid
    io.axi.w.ready                                 :=instDDR.io.c0_ddr4_s_axi_wready                
  // Slave Interface Write Response Ports
    io.axi.b.bits.id                            :=instDDR.io.c0_ddr4_s_axi_bid                   
    io.axi.b.bits.resp                          :=instDDR.io.c0_ddr4_s_axi_bresp                 
    io.axi.b.valid                              :=instDDR.io.c0_ddr4_s_axi_bvalid                
    instDDR.io.c0_ddr4_s_axi_bready                :=io.axi.b.ready
  // Slave Interface Read Address Ports
    instDDR.io.c0_ddr4_s_axi_arid                  :=io.axi.ar.bits.id
    instDDR.io.c0_ddr4_s_axi_araddr                :=io.axi.ar.bits.addr
    instDDR.io.c0_ddr4_s_axi_arlen                 :=io.axi.ar.bits.len
    instDDR.io.c0_ddr4_s_axi_arsize                :=io.axi.ar.bits.size
    instDDR.io.c0_ddr4_s_axi_arburst               :=io.axi.ar.bits.burst
    instDDR.io.c0_ddr4_s_axi_arlock                :=io.axi.ar.bits.lock
    instDDR.io.c0_ddr4_s_axi_arcache               :=io.axi.ar.bits.cache
    instDDR.io.c0_ddr4_s_axi_arprot                :=io.axi.ar.bits.prot
    instDDR.io.c0_ddr4_s_axi_arqos                 :=io.axi.ar.bits.qos
    instDDR.io.c0_ddr4_s_axi_arvalid               :=io.axi.ar.valid
    io.axi.ar.ready                                :=instDDR.io.c0_ddr4_s_axi_arready               
  // Slave Interface Read Data Ports
    io.axi.r.bits.id                               :=instDDR.io.c0_ddr4_s_axi_rid                   
    io.axi.r.bits.data                             :=instDDR.io.c0_ddr4_s_axi_rdata                 
    io.axi.r.bits.resp                             :=instDDR.io.c0_ddr4_s_axi_rresp                 
    io.axi.r.bits.last                             :=instDDR.io.c0_ddr4_s_axi_rlast                 
    io.axi.r.valid                                 :=instDDR.io.c0_ddr4_s_axi_rvalid                
    instDDR.io.c0_ddr4_s_axi_rready                :=io.axi.r.ready
    instDDR.io.dbg_bus                             <> DontCare                                           
    ////////////

}