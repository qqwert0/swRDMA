package swrdma

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._
import common.storage._
import common.axi._
import common.ToZero
import common.partialReconfig.AlveoStaticIO
import qdma._
import cmac._
import hbm._

class U280DynamicGreyBox extends MultiIOModule {
	override val desiredName = "AlveoDynamicTop"
    val io = IO(Flipped(new AlveoStaticIO(
        VIVADO_VERSION = "202101", 
		QDMA_PCIE_WIDTH = 16, 
		QDMA_SLAVE_BRIDGE = true, 
		QDMA_AXI_BRIDGE = true,
		ENABLE_CMAC_1 = true,
		ENABLE_CMAC_2 = true,
		ENABLE_DDR_1=false,
		ENABLE_DDR_2=false
    )))

	val dbgBridgeInst = DebugBridge(IP_CORE_NAME="DebugBridgeBase", clk=clock)
	dbgBridgeInst.getTCL()

	dontTouch(io)

    //* io.cmacPin.get <> DontCare

	val userClk  	= Wire(Clock())
	val userRstn 	= Wire(Bool())
    


	val qdmaInst = Module(new QDMADynamic(
		VIVADO_VERSION		= "202101",
		PCIE_WIDTH			= 16,
		SLAVE_BRIDGE		= true,
		BRIDGE_BAR_SCALE	= "Megabytes",
		BRIDGE_BAR_SIZE 	= 4
	))

    qdmaInst.io.s_axib.get  <> DontCare



	// ToZero(qdmaInst.io.reg_status)

    qdmaInst.io.qdma_port	<> io.qdma
	qdmaInst.io.user_clk	:= userClk
	qdmaInst.io.user_arstn	:= ~reset.asBool 

    // Init values
    qdmaInst.io.axib.ar.ready	:= 1.U
    qdmaInst.io.axib.aw.ready	:= 1.U
    qdmaInst.io.axib.w.ready	:= 1.U
    qdmaInst.io.axib.r.valid	:= 1.U
    ToZero(qdmaInst.io.axib.r.bits)
    qdmaInst.io.axib.b.valid	:= 1.U
    ToZero(qdmaInst.io.axib.b.bits)


	qdmaInst.io.h2c_data.ready	:= 0.U
	qdmaInst.io.c2h_data.valid	:= 0.U
	qdmaInst.io.c2h_data.bits	:= 0.U.asTypeOf(new C2H_DATA)

	qdmaInst.io.h2c_cmd.valid	:= 0.U
	qdmaInst.io.h2c_cmd.bits	:= 0.U.asTypeOf(new H2C_CMD)
	qdmaInst.io.c2h_cmd.valid	:= 0.U
	qdmaInst.io.c2h_cmd.bits	:= 0.U.asTypeOf(new C2H_CMD)
	
	
	
	val status_reg = qdmaInst.io.reg_status
	ToZero(status_reg)
	
	val control_reg = qdmaInst.io.reg_control

 	userClk		:= clock
	userRstn	:= ((~reset.asBool & ~control_reg(0)(0)).asClock).asBool

    // not used cmac,but sould get it
		
	val cmacInst = Module(new XCMAC(BOARD="u280", PORT=0, IP_CORE_NAME="CMACBlackBoxBase"))
	cmacInst.getTCL()
	// Connect CMAC's pins
	cmacInst.io.pin			<> io.cmacPin.get
	cmacInst.io.drp_clk		:= io.cmacClk.get
	cmacInst.io.user_clk	:= userClk
	cmacInst.io.user_arstn	:= userRstn
	cmacInst.io.sys_reset	:= reset
	

	
	val cmacInst2 = Module(new XCMAC(BOARD="u280", PORT=1, IP_CORE_NAME="CMACBlackBoxBase2"))
	cmacInst2.getTCL()
	// Connect CMAC's pins
	cmacInst2.io.pin			<> io.cmacPin2.get
	cmacInst2.io.drp_clk		:= io.cmacClk.get
	cmacInst2.io.user_clk		:= userClk
	cmacInst2.io.user_arstn		:= userRstn
	cmacInst2.io.sys_reset		:= reset


    // //? DDR port
    // io.ddrPort2.get.axi<> DontCare

	
	// val ddr_rst=Wire(Bool())
    // val ddr_clk=Wire(Clock())

    // ddr_clk:=io.ddrPort2.get.clk
    // ddr_rst:=io.ddrPort2.get.rst
	// io.ddrPort2.get.axi.qdma_init()
	// io.ddrPort2.get.axi <> DontCare



	val DataWriterInst = withClockAndReset(userClk, ~userRstn.asBool){Module(new MemoryDataWriter())}
	val DataReaderInst = withClockAndReset(userClk, ~userRstn.asBool){Module(new MemoryDataReader())}
	// val CallbackWriterInst = withClockAndReset(userClk, ~userRstn.asBool){Module(new MemoryCallbackWriter())}

    withClockAndReset(userClk, ~userRstn.asBool) {
        RegSlice(6)(DataWriterInst.io.c2hCmd)		<> qdmaInst.io.c2h_cmd
        RegSlice(6)(DataWriterInst.io.c2hData)	    <> qdmaInst.io.c2h_data
        RegSlice(6)(DataReaderInst.io.h2cCmd)		<> qdmaInst.io.h2c_cmd
        (DataReaderInst.io.h2cData)	    <> RegSlice(6)(qdmaInst.io.h2c_data)		
        // AXIRegSlice(2)(CallbackWriterInst.io.sAxib)      <> qdmaInst.io.s_axib.get
    }

	DataWriterInst.io.callback.ready		:= 1.U
	DataReaderInst.io.callback.ready		:= 1.U
	// CallbackWriterInst.io.callback <> DataWriterInst.io.callback

	val msg_send = Module(new MsgSend())
	val roce = Module(new PRDMA())
	val ip = Module(new IPTest())   
	val tx_fifo = XQueue(AXIS(512),entries=512)
	val rx_fifo = XQueue(AXIS(512),entries=512)


	ip.io.s_ip_tx				<> tx_fifo.io.out
    roce.io.m_net_tx_data       <> tx_fifo.io.in
    ip.io.m_mac_tx              <> cmacInst2.io.s_net_tx
    ip.io.s_mac_rx              <> cmacInst2.io.m_net_rx
    roce.io.s_net_rx_data       <> rx_fifo.io.out
	ip.io.m_roce_rx				<> rx_fifo.io.in
	roce.io.s_tx_meta			<> msg_send.io.app_meta_out

    ip.io.m_tcp_rx.ready         := 1.U
    ip.io.m_udp_rx.ready         := 1.U   
    ip.io.arp_rsp.ready          := 1.U 	        


	DataWriterInst.io.cpuReq.valid			<> roce.io.m_mem_write_cmd.valid
	DataWriterInst.io.cpuReq.ready			<> roce.io.m_mem_write_cmd.ready
	DataWriterInst.io.cpuReq.bits.addr		<> roce.io.m_mem_write_cmd.bits.vaddr
	DataWriterInst.io.cpuReq.bits.size		<> roce.io.m_mem_write_cmd.bits.length
	DataWriterInst.io.cpuReq.bits.callback	:= 0.U
	DataWriterInst.io.memData				<> roce.io.m_mem_write_data

	DataReaderInst.io.cpuReq.valid			<> roce.io.m_mem_read_cmd.valid
	DataReaderInst.io.cpuReq.ready			<> roce.io.m_mem_read_cmd.ready
	DataReaderInst.io.cpuReq.bits.addr		<> roce.io.m_mem_read_cmd.bits.vaddr
	DataReaderInst.io.cpuReq.bits.size		<> roce.io.m_mem_read_cmd.bits.length
	DataReaderInst.io.cpuReq.bits.callback	:= 0.U
	DataReaderInst.io.memData				<> roce.io.s_mem_read_data

	
	withClockAndReset(userClk, ~userRstn.asBool) {
		val start 							= RegNext(control_reg(101) === 1.U)
		val risingStartInit					= start && RegNext(!start)
		val valid 							= RegInit(UInt(1.W),0.U)
		when(risingStartInit === 1.U){
			valid							:= 1.U
		}.elsewhen(roce.io.qp_init.fire){
			valid							:= 0.U
		}

		roce.io.qp_init.valid					:= valid 
		roce.io.qp_init.bits.qpn					:= RegNext(control_reg(110))
		roce.io.qp_init.bits.conn_state.remote_qpn	:= RegNext(control_reg(111))
		roce.io.qp_init.bits.conn_state.remote_ip	:= RegNext(control_reg(112))
		roce.io.qp_init.bits.conn_state.remote_udp_port	:= 17.U
		roce.io.qp_init.bits.conn_state.rx_epsn			:= 1000.U
		roce.io.qp_init.bits.conn_state.tx_npsn			:= 1000.U
		roce.io.qp_init.bits.conn_state.rx_old_unack	:= 1000.U

		val valid_arp						= RegInit(UInt(1.W),0.U)
		when(risingStartInit === 1.U){
			valid_arp						:= 1.U
		}.elsewhen(ip.io.arp_req.fire){
			valid_arp						:= 0.U
		}
		ip.io.arp_req.valid				:= valid_arp
		ip.io.arp_req.bits				:= RegNext(control_reg(116))

		val valid_cc						= RegInit(UInt(1.W),0.U)
		when(risingStartInit === 1.U){
			valid_cc						:= 1.U
		}.elsewhen(roce.io.cc_init.fire){
			valid_cc						:= 0.U
		}
		roce.io.cc_init.valid				:= valid_cc
		roce.io.cc_init.bits.qpn			:= RegNext(control_reg(110))
		roce.io.cc_init.bits.cc_state.credit:= RegNext(control_reg(113))
		roce.io.cc_init.bits.cc_state.rate	:= RegNext(control_reg(114))
		roce.io.cc_init.bits.cc_state.timer	:= 0.U
		roce.io.cc_init.bits.cc_state.divide_rate	:= RegNext(control_reg(115))
		roce.io.cc_init.bits.cc_state.user_define:= RegNext(Cat("h0".U,control_reg(115),"h0".U(32.W),control_reg(114)))
		roce.io.cc_init.bits.cc_state.lock	:= false.B

		val start_msg 						= RegNext(control_reg(130) === 1.U)
		val risingMsgInit					= start_msg && RegNext(!start_msg)
		val valid_msg						= RegInit(UInt(1.W),0.U)
		when(risingMsgInit === 1.U){
			valid_msg						:= 1.U
		}.elsewhen(msg_send.io.app_meta_in.fire){
			valid_msg						:= 0.U
		}


		msg_send.io.app_meta_in.valid				:= valid_msg
		msg_send.io.app_meta_in.bits.qpn_num		:= RegNext(control_reg(131))
		msg_send.io.app_meta_in.bits.rdma_cmd		:= RegNext(control_reg(132)(1,0).asTypeOf(roce.io.s_tx_meta.bits.rdma_cmd))
		msg_send.io.app_meta_in.bits.local_vaddr	:= RegNext(Cat(control_reg(133),control_reg(134)))
		msg_send.io.app_meta_in.bits.remote_vaddr	:= RegNext(Cat(control_reg(135),control_reg(136)))
		msg_send.io.app_meta_in.bits.length			:= RegNext(control_reg(137))
		msg_send.io.app_meta_in.bits.msg_num_per_qpn:= RegNext(control_reg(138))


		roce.io.local_ip_address			:= RegNext(control_reg(120))
		ip.io.ip_address					:= RegNext(control_reg(120))
		roce.io.cpu_started					:= RegNext(control_reg(121))
		roce.io.tx_delay             		:= RegNext(control_reg(122))


	}
	

	cmacInst.io.s_net_tx <> DontCare
	cmacInst.io.m_net_rx <> DontCare


	val hbmDriver = withClockAndReset(io.sysClk, false.B) {Module(new HBM_DRIVER(WITH_RAMA=false, IP_CORE_NAME="HBMBlackBoxBase"))}
		hbmDriver.getTCL()

		for (i <- 0 until 32) {
			hbmDriver.io.axi_hbm(i).hbm_init()	// Read hbm_init function if you're not familiar with AXI.
		}

	val hbmClk 	    	= hbmDriver.io.hbm_clk
	val hbmRstn     	= withClockAndReset(hbmClk,false.B) {RegNext(hbmDriver.io.hbm_rstn.asBool)}


	hbmDriver.io.axi_hbm(8) <> withClockAndReset(hbmClk,!hbmRstn){ AXIRegSlice(2)(XAXIConverter(roce.io.axi(0), userClk, userRstn, hbmClk, hbmRstn))}
	hbmDriver.io.axi_hbm(9) <> withClockAndReset(hbmClk,!hbmRstn){ AXIRegSlice(2)(XAXIConverter(roce.io.axi(1), userClk, userRstn, hbmClk, hbmRstn))}


	Collector.connect_to_status_reg(status_reg, 200)

	val tx_timer = Timer(roce.io.s_tx_meta.fire,roce.io.m_net_tx_data.fire & roce.io.m_net_tx_data.bits.last )
	val tx_latency = tx_timer.latency
	val tx_start_cnt = tx_timer.cnt_start
	val tx_end_cnt = tx_timer.cnt_end
	val net_timer = Timer(roce.io.m_net_tx_data.fire & roce.io.s_net_rx_data.bits.last,roce.io.s_net_rx_data.fire & roce.io.m_net_tx_data.bits.last )
	val net_latency = net_timer.latency
	val net_start_cnt = net_timer.cnt_start
	val net_end_cnt = net_timer.cnt_end
	val rx_timer = Timer(roce.io.s_net_rx_data.fire & roce.io.m_net_tx_data.bits.last , roce.io.m_mem_write_cmd.fire)
	val rx_latency = rx_timer.latency
	val rx_start_cnt = rx_timer.cnt_start
	val rx_end_cnt = rx_timer.cnt_end

	status_reg(300) := tx_latency
	status_reg(301) := tx_start_cnt
	status_reg(302) := tx_end_cnt
	status_reg(303) := net_latency
	status_reg(304) := net_start_cnt
	status_reg(305) := net_end_cnt
	status_reg(306) := rx_latency
	status_reg(307) := rx_start_cnt
	status_reg(308) := rx_end_cnt

	// val txdata = RegInit(0.U(96.W))
	// txdata	:= RegNext(RegNext(cmacInst2.io.s_net_tx.bits.data(95,0)))
	// val rxdata = RegInit(0.U(96.W))
	// rxdata	:= RegNext(RegNext(cmacInst2.io.m_net_rx.bits.data(95,0)))
	// val rx_valid = RegInit(0.U(1.W))
	// rx_valid	:= RegNext(RegNext(cmacInst2.io.m_net_rx.valid))
	// val rx_ready = RegInit(0.U(1.W))
	// rx_ready	:= RegNext(RegNext(cmacInst2.io.m_net_rx.ready))
	// val rx_lst = RegInit(0.U(1.W))
	// rx_lst	:= RegNext(RegNext(cmacInst2.io.m_net_rx.bits.last))
	// val tx_valid = RegInit(0.U(1.W))
	// tx_valid	:= RegNext(RegNext(cmacInst2.io.s_net_tx.valid))
	// val tx_ready = RegInit(0.U(1.W))
	// tx_ready	:= RegNext(RegNext(cmacInst2.io.s_net_tx.ready))
	// val tx_last = RegInit(0.U(1.W))
	// tx_last	:= RegNext(RegNext(cmacInst2.io.s_net_tx.bits.last))	
	// class ila_net(seq:Seq[Data]) extends BaseILA(seq)	  
  	// val ila_net = Module(new ila_net(Seq(	
	// 	cmacInst.io.m_net_rx.valid,
	// 	cmacInst.io.m_net_rx.ready,
	// 	cmacInst.io.m_net_rx.bits.last,
	// 	// txdata,
	// 	cmacInst.io.s_net_tx.valid,
	// 	cmacInst.io.s_net_tx.ready,
	// 	cmacInst.io.s_net_tx.bits.last,
	// 	rxdata,
	// 	// PkgProcInst.io.idle_cycle
  	// )))
  	// ila_net.connect(userClk)
}