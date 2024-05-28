package swrdma

import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._
import common.ToZero
import hbm._
import qdma._
import cmac._


class prdma_top extends RawModule {
	val qdma_pin		= IO(new QDMAPin())
	val cmac_pin		= IO(new CMACPin)
	val cmac_pin1		= IO(new CMACPin)
	// val cmac_pin2		= IO(new CMACPin)
	// val cmac_pin3		= IO(new CMACPin)
	val sysClkP			= IO(Input(Clock()))
	val sysClkN			= IO(Input(Clock()))
	val led		        = IO(Output(UInt(1.W)))

	led         		:= 0.U

	def TODO_32			= 32
	
	val mmcmTop	= Module(new MMCME4_ADV_Wrapper(
		CLKFBOUT_MULT_F 		= 12,
		MMCM_DIVCLK_DIVIDE		= 1,
		MMCM_CLKOUT0_DIVIDE_F	= 12,
		MMCM_CLKOUT1_DIVIDE_F	= 5,
		MMCM_CLKOUT2_DIVIDE_F	= 12,
		MMCM_CLKOUT3_DIVIDE_F	= 5,
		MMCM_CLKIN1_PERIOD 		= 10
	))

	mmcmTop.io.CLKIN1	:= IBUFDS(sysClkP,sysClkN)
	mmcmTop.io.RST		:= 0.U

	val clk_hbm_driver	= mmcmTop.io.CLKOUT0 //100M
	val userClk			= mmcmTop.io.CLKOUT1 //240M
	val cmacClk			= mmcmTop.io.CLKOUT2 //100M
	val netClk			= mmcmTop.io.CLKOUT3 //240M

	//HBM
    val hbmDriver 		= withClockAndReset(clk_hbm_driver, false.B) {Module(new HBM_DRIVER(WITH_RAMA=false))}
	hbmDriver.getTCL()
	val hbmClk 	    	= hbmDriver.io.hbm_clk
	val hbmRstn     	= withClockAndReset(hbmClk,false.B) {RegNext(hbmDriver.io.hbm_rstn.asBool)}
    
	// val userRstn		= withClockAndReset(userClk,false.B) {ShiftRegister(hbmRstn,4)}
	val netRstn			= withClockAndReset(userClk,false.B) {ShiftRegister(hbmRstn,4)}

	for (i <- 0 until 32) {
		hbmDriver.io.axi_hbm(i).hbm_init()	// Read hbm_init function if you're not familiar with AXI.
	}


	dontTouch(hbmClk)
	dontTouch(hbmRstn)
	//QDMA
    val qdma = Module(new QDMA(
		VIVADO_VERSION	="202101",
        PCIE_WIDTH			= 16,
		SLAVE_BRIDGE		= false,
		BRIDGE_BAR_SCALE	= "Megabytes",
		BRIDGE_BAR_SIZE 	= 4
	))
	qdma.getTCL()
	ToZero(qdma.io.reg_status)
	ToZero(qdma.io.c2h_data.bits)
	ToZero(qdma.io.h2c_cmd.bits)
	ToZero(qdma.io.c2h_cmd.bits)
	qdma.io.h2c_data.ready	:= 0.U
	qdma.io.c2h_data.valid	:= 0.U
	qdma.io.h2c_cmd.valid	:= 0.U
	qdma.io.c2h_cmd.valid	:= 0.U

	qdma.io.pin <> qdma_pin
	qdma.io.user_clk	:= userClk
	qdma.io.user_arstn	:= netRstn


		Init(qdma.io.axib.b)
		qdma.io.axib.b.valid		:= 1.U
		Init(qdma.io.axib.ar)
		Init(qdma.io.axib.r)
		Init(qdma.io.axib.aw)
		Init(qdma.io.axib.w)

	val control_reg = qdma.io.reg_control
	val status_reg = qdma.io.reg_status

	val sw_reset	= control_reg(100) === 1.U



	ToZero(status_reg)

	val userRstn	= withClockAndReset(userClk,false.B) {RegNext(((~netRstn.asBool & ~control_reg(0)(0)).asClock).asBool)}

	

    // not used cmac,but sould get it
		
	val cmacInst = Module(new XCMAC(BOARD="u280", PORT=0, IP_CORE_NAME="CMACBlackBox"))
	cmacInst.getTCL()
	// Connect CMAC's pins
	cmacInst.io.pin			<> cmac_pin
	cmacInst.io.drp_clk		:= cmacClk
	cmacInst.io.user_clk	:= userClk
	cmacInst.io.user_arstn	:= netRstn
	cmacInst.io.sys_reset	:= !netRstn
	

	
	val cmacInst2 = Module(new XCMAC(BOARD="u280", PORT=1, IP_CORE_NAME="CMACBlackBox2"))
	cmacInst2.getTCL()
	// Connect CMAC's pins
	cmacInst2.io.pin			<> cmac_pin1
	cmacInst2.io.drp_clk		:= cmacClk
	cmacInst2.io.user_clk		:= userClk
	cmacInst2.io.user_arstn		:= netRstn
	cmacInst2.io.sys_reset		:= !netRstn


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
        RegSlice(6)(DataWriterInst.io.c2hCmd)		<> qdma.io.c2h_cmd
        RegSlice(6)(DataWriterInst.io.c2hData)	    <> qdma.io.c2h_data
        RegSlice(6)(DataReaderInst.io.h2cCmd)		<> qdma.io.h2c_cmd
        (DataReaderInst.io.h2cData)	    <> RegSlice(6)(qdma.io.h2c_data)		
        // AXIRegSlice(2)(CallbackWriterInst.io.sAxib)      <> qdmaInst.io.s_axib.get
    }

	DataWriterInst.io.callback.ready		:= 1.U
	DataReaderInst.io.callback.ready		:= 1.U
	// CallbackWriterInst.io.callback <> DataWriterInst.io.callback

	val roce = withClockAndReset(userClk, ~userRstn.asBool){Module(new PRDMA())}
	val ip = withClockAndReset(userClk, ~userRstn.asBool){Module(new IPTest()) }   



    roce.io.m_net_tx_data        <> ip.io.s_ip_tx
    ip.io.m_mac_tx               <> cmacInst2.io.s_net_tx
    ip.io.s_mac_rx               <> cmacInst2.io.m_net_rx
    roce.io.s_net_rx_data        <> ip.io.m_roce_rx

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
		ip.io.arp_req.bits				:= RegNext(control_reg(121))

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
		roce.io.cc_init.bits.cc_state.timer	:= RegNext(control_reg(115))
		roce.io.cc_init.bits.cc_state.user_define:= 0.U
		roce.io.cc_init.bits.cc_state.lock	:= false.B

		val start_msg 						= RegNext(control_reg(130) === 1.U)
		val risingMsgInit					= start_msg && RegNext(!start_msg)
		val valid_msg						= RegInit(UInt(1.W),0.U)
		when(risingMsgInit === 1.U){
			valid_msg						:= 1.U
		}.elsewhen(roce.io.s_tx_meta.fire){
			valid_msg						:= 0.U
		}
		roce.io.s_tx_meta.valid				:= valid_msg
		roce.io.s_tx_meta.bits.qpn			:= RegNext(control_reg(131))
		roce.io.s_tx_meta.bits.rdma_cmd		:= RegNext(control_reg(132)(1,0).asTypeOf(roce.io.s_tx_meta.bits.rdma_cmd))
		roce.io.s_tx_meta.bits.local_vaddr	:= RegNext(control_reg(133))
		roce.io.s_tx_meta.bits.remote_vaddr	:= RegNext(control_reg(134))
		roce.io.s_tx_meta.bits.length		:= RegNext(control_reg(135))


		roce.io.local_ip_address			:= RegNext(control_reg(120))
		ip.io.ip_address					:= RegNext(control_reg(120))
		roce.io.cpu_started					:= RegNext(control_reg(121))


	}
	

	cmacInst.io.s_net_tx <> DontCare
	cmacInst.io.m_net_rx <> DontCare





	hbmDriver.io.axi_hbm(8) <> withClockAndReset(hbmClk,!hbmRstn){ AXIRegSlice(2)(XAXIConverter(roce.io.axi(0), userClk, userRstn, hbmClk, hbmRstn))}
	hbmDriver.io.axi_hbm(9) <> withClockAndReset(hbmClk,!hbmRstn){ AXIRegSlice(2)(XAXIConverter(roce.io.axi(1), userClk, userRstn, hbmClk, hbmRstn))}



	Collector.show_more()
	Collector.connect_to_status_reg(status_reg, 200)
}