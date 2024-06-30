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

class swrdma10_top extends MultiIOModule {
	override val desiredName = "AlveoDynamicTop"
    val io = IO(Flipped(new AlveoStaticIO(
        VIVADO_VERSION = "202101", 
		QDMA_PCIE_WIDTH = 16, 
		QDMA_SLAVE_BRIDGE = true, 
		QDMA_AXI_BRIDGE = true,
		ENABLE_CMAC_1 = false,
		ENABLE_CMAC_2 = true,
		ENABLE_DDR_1=false,
		ENABLE_DDR_2=false
    )))

	val dbgBridgeInst = DebugBridge(IP_CORE_NAME="DebugBridge", clk=clock)
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
		

	// io.cmacPin.get		<> DontCare

	

	
	val netmodule = Module(new netmodule())
	// Connect CMAC's pins

    netmodule.io.dclk          <> io.cmacClk.get
    netmodule.io.user_clk      := userClk
    netmodule.io.sys_reset     := reset
    netmodule.io.aresetn       := userRstn
    netmodule.io.gt_refclk_p   <> io.cmacPin2.get.gt_clk_p
    netmodule.io.gt_refclk_n   <> io.cmacPin2.get.gt_clk_n
    netmodule.io.gt_rxp_in     <> io.cmacPin2.get.rx_p
    netmodule.io.gt_rxn_in     <> io.cmacPin2.get.rx_n
    netmodule.io.gt_txp_out    <> io.cmacPin2.get.tx_p
    netmodule.io.gt_txn_out    <> io.cmacPin2.get.tx_n




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

	
	val msg_send = withClockAndReset(userClk, ~userRstn.asBool) {Module(new MsgSend())}
	val roce = withClockAndReset(userClk, ~userRstn.asBool) {Module(new PRDMA())}
	val write_host = withClockAndReset(userClk, ~userRstn.asBool){(Module(new WriteHost()))}
	val read_host = withClockAndReset(userClk, ~userRstn.asBool){(Module(new ReadHost()))}
	val ip = withClockAndReset(userClk, ~userRstn.asBool) {Module(new IPTest())}
	val tx_fifo = withClockAndReset(userClk, ~userRstn.asBool) {XQueue(AXIS(512),entries=512)}
	val rx_fifo = withClockAndReset(userClk, ~userRstn.asBool) {XQueue(AXIS(512),entries=512)}

	withClockAndReset(userClk, ~userRstn.asBool) {	
	ip.io.s_ip_tx				<> tx_fifo.io.out
    roce.io.m_net_tx_data       <> tx_fifo.io.in

    roce.io.s_net_rx_data       <> rx_fifo.io.out
	ip.io.m_roce_rx				<> rx_fifo.io.in
	roce.io.s_tx_meta			<> msg_send.io.app_meta_out


    netmodule.io.m_axis_net_rx_valid <> ip.io.s_mac_rx.valid
    netmodule.io.m_axis_net_rx_ready <> ip.io.s_mac_rx.ready
    netmodule.io.m_axis_net_rx_data  <> ip.io.s_mac_rx.bits.data
    netmodule.io.m_axis_net_rx_keep  <> ip.io.s_mac_rx.bits.keep
    netmodule.io.m_axis_net_rx_last  <> ip.io.s_mac_rx.bits.last
    netmodule.io.s_axis_net_tx_valid <> ip.io.m_mac_tx.valid
    netmodule.io.s_axis_net_tx_ready <> ip.io.m_mac_tx.ready
    netmodule.io.s_axis_net_tx_data  <> ip.io.m_mac_tx.bits.data
    netmodule.io.s_axis_net_tx_keep  <> ip.io.m_mac_tx.bits.keep
    netmodule.io.s_axis_net_tx_last  <> ip.io.m_mac_tx.bits.last

    ip.io.m_tcp_rx.ready         := 1.U
    ip.io.m_udp_rx.ready         := 1.U   
    ip.io.arp_rsp.ready          := 1.U 	        

	write_host.io.m_mem_write_cmd			<> roce.io.m_mem_write_cmd
	write_host.io.m_mem_write_data			<> roce.io.m_mem_write_data
	write_host.io.address             		:= RegNext(Cat(control_reg(123),control_reg(124)))
	write_host.io.pkg_num             		:= RegNext(control_reg(125))
	write_host.io.cpuReq              		<> DataWriterInst.io.cpuReq
	write_host.io.memData             		<> DataWriterInst.io.memData

	read_host.io.m_mem_read_cmd				<> roce.io.m_mem_read_cmd
	read_host.io.s_mem_read_data			<> roce.io.s_mem_read_data
	read_host.io.cpuReq              		<> DataReaderInst.io.cpuReq
	read_host.io.memData             		<> DataReaderInst.io.memData

	// DataWriterInst.io.cpuReq.valid			<> roce.io.m_mem_write_cmd.valid
	// DataWriterInst.io.cpuReq.ready			<> roce.io.m_mem_write_cmd.ready
	// DataWriterInst.io.cpuReq.bits.addr		<> roce.io.m_mem_write_cmd.bits.vaddr
	// DataWriterInst.io.cpuReq.bits.size		<> roce.io.m_mem_write_cmd.bits.length
	// DataWriterInst.io.cpuReq.bits.callback	:= 0.U
	// DataWriterInst.io.memData				<> roce.io.m_mem_write_data

	// DataReaderInst.io.cpuReq.valid			<> roce.io.m_mem_read_cmd.valid
	// DataReaderInst.io.cpuReq.ready			<> roce.io.m_mem_read_cmd.ready
	// DataReaderInst.io.cpuReq.bits.addr		<> roce.io.m_mem_read_cmd.bits.vaddr
	// DataReaderInst.io.cpuReq.bits.size		<> roce.io.m_mem_read_cmd.bits.length
	// DataReaderInst.io.cpuReq.bits.callback	:= 0.U
	// DataReaderInst.io.memData				<> roce.io.s_mem_read_data

	
	
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
		}.elsewhen(ip.io.arpinsert.fire){
			valid_arp						:= 0.U
		}
		ip.io.arp_req.valid				:= 0.U
		ip.io.arp_req.bits				:= 0.U
		ip.io.arpinsert.valid			:= valid_arp
		ip.io.arpinsert.bits			:= RegNext(Cat("h1".U,control_reg(118)(15,0),control_reg(117),control_reg(116)))


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
		roce.io.cc_init.bits.cc_state.user_define:= RegNext(Cat("h0".U,control_reg(171),control_reg(170),control_reg(169),control_reg(168),control_reg(167),control_reg(166),control_reg(165),control_reg(164),control_reg(163),control_reg(162),control_reg(161),control_reg(160)))
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
	

	// cmacInst.io.s_net_tx <> DontCare
	// cmacInst.io.m_net_rx <> DontCare


	val hbmDriver = withClockAndReset(io.sysClk, false.B) {Module(new HBM_DRIVER(WITH_RAMA=false, IP_CORE_NAME="HBMBlackBox"))}
		hbmDriver.getTCL()

		for (i <- 0 until 32) {
			hbmDriver.io.axi_hbm(i).hbm_init()	// Read hbm_init function if you're not familiar with AXI.
		}

	val hbmClk 	    	= hbmDriver.io.hbm_clk
	val hbmRstn     	= withClockAndReset(hbmClk,false.B) {RegNext(hbmDriver.io.hbm_rstn.asBool)}


	hbmDriver.io.axi_hbm(8) <> withClockAndReset(hbmClk,!hbmRstn){ AXIRegSlice(2)(XAXIConverter(roce.io.axi(0), userClk, userRstn, hbmClk, hbmRstn))}
	hbmDriver.io.axi_hbm(9) <> withClockAndReset(hbmClk,!hbmRstn){ AXIRegSlice(2)(XAXIConverter(roce.io.axi(1), userClk, userRstn, hbmClk, hbmRstn))}


	withClockAndReset(userClk, ~userRstn.asBool) {

	val tx_timer = Timer(roce.io.s_tx_meta.fire,roce.io.m_net_tx_data.fire & roce.io.m_net_tx_data.bits.last )
	val tx_latency = tx_timer.latency
	val tx_start_cnt = tx_timer.cnt_start
	val tx_end_cnt = tx_timer.cnt_end
	val net_timer = Timer(roce.io.m_net_tx_data.fire & roce.io.m_net_tx_data.bits.last,roce.io.s_net_rx_data.fire & roce.io.s_net_rx_data.bits.last )
	val net_latency = net_timer.latency
	val net_start_cnt = net_timer.cnt_start
	val net_end_cnt = net_timer.cnt_end
	val rx_timer = Timer(roce.io.s_net_rx_data.fire & roce.io.s_net_rx_data.bits.last , roce.io.m_mem_write_cmd.fire)
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


		val timer_en = RegInit(false.B)
		val timer_end = RegInit(false.B)
		val done_en = RegInit(false.B)
		val timer_cnt = RegInit(UInt(32.W), 0.U)
		val data_cnt = RegInit(UInt(32.W), 1.U)
		val total_data = RegNext(control_reg(140))

		val time_cnt = RegInit(UInt(32.W), 0.U)

		when (roce.io.s_tx_meta.fire) {
			timer_en 	:= true.B
		}.otherwise{
			timer_en	:= timer_en
		}

		when (data_cnt === total_data) {
			timer_end 	:= true.B
		}.otherwise{
			timer_end	:= timer_end
		}

		when (timer_en & (~timer_end)) {
			timer_cnt 	:= timer_cnt + 1.U
		}otherwise{
			timer_cnt	:= timer_cnt
		}		

		time_cnt := time_cnt + 1.U

		when (roce.io.s_mem_read_data.fire) {
			data_cnt 	:= data_cnt + 1.U
		}.otherwise{
			data_cnt	:= data_cnt
		}

		status_reg(320)			:= data_cnt
		status_reg(321)			:= timer_en
		status_reg(322)			:= timer_cnt


		//delay
		val latency_bucket = Module{new LatencyBucket(BUCKET_SIZE=1024,LATENCY_STRIDE=32)}

		latency_bucket.io.enable		:= control_reg(150)
		latency_bucket.io.start			:= roce.io.s_tx_meta.fire
		latency_bucket.io.end			:= roce.io.s_net_rx_data.fire
		latency_bucket.io.bucketRdId	:= control_reg(151)
		latency_bucket.io.resetBucket	:= reset




		// Collector.report(latency_bucket.io.bucketValue, "REG_BUCKET_VALUE")
		status_reg(340)			:= latency_bucket.io.bucketValue

	Collector.connect_to_status_reg(status_reg, 400)

	}

	// val txdata = RegInit(0.U(96.W))
	// txdata	:= RegNext(RegNext(cmacInst2.io.s_net_tx.bits.data(511,416)))
	// val rxdata = RegInit(0.U(96.W))
	// rxdata	:= RegNext(RegNext(cmacInst2.io.m_net_rx.bits.data(511,416)))
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
	// 	rx_valid,
	// 	rx_ready,
	// 	rx_lst,
	// 	txdata,
	// 	tx_valid,
	// 	tx_ready,
	// 	tx_last,
	// 	rxdata,
	// 	// PkgProcInst.io.idle_cycle
  	// )))
  	// ila_net.connect(userClk)
}