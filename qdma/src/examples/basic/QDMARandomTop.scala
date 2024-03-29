package qdma.examples

import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._
import common.ToZero
import qdma._

class QDMARandomTop extends RawModule{
	val qdma_pin		= IO(new QDMAPin())
	val led 			= IO(Output(UInt(1.W)))
	val sys_100M_0_p	= IO(Input(Clock()))
  	val sys_100M_0_n	= IO(Input(Clock()))

	led := 0.U

	val mmcm = Module(new MMCME4_ADV_Wrapper(
		CLKFBOUT_MULT_F 		= 20,
		MMCM_DIVCLK_DIVIDE		= 2,
		MMCM_CLKOUT0_DIVIDE_F	= 4,
		MMCM_CLKOUT1_DIVIDE_F	= 10,
		
		MMCM_CLKIN1_PERIOD 		= 10
	))

	//your VIVADO version and path to your project's IP location
	val qdma = Module(new QDMA("202101"))//edit me
	qdma.getTCL()

	mmcm.io.CLKIN1	:= IBUFDS(sys_100M_0_p, sys_100M_0_n)
	mmcm.io.RST		:= 0.U

	val dbg_clk 	= BUFG(mmcm.io.CLKOUT1)
	dontTouch(dbg_clk)

	val user_clk = BUFG(mmcm.io.CLKOUT0)
	val user_rstn = mmcm.io.LOCKED


	ToZero(qdma.io.reg_status)
	qdma.io.pin <> qdma_pin

	qdma.io.user_clk	:= user_clk
	qdma.io.user_arstn	:= user_rstn

	qdma.io.h2c_data.ready	:= 0.U
	qdma.io.c2h_data.valid	:= 0.U
	qdma.io.c2h_data.bits	:= 0.U.asTypeOf(new C2H_DATA)

	qdma.io.h2c_cmd.valid	:= 0.U
	qdma.io.h2c_cmd.bits	:= 0.U.asTypeOf(new H2C_CMD)
	qdma.io.c2h_cmd.valid	:= 0.U
	qdma.io.c2h_cmd.bits	:= 0.U.asTypeOf(new C2H_CMD)

	val axi_slave = withClockAndReset(user_clk,!user_rstn){Module(new SimpleAXISlave(new AXIB))}//withClockAndReset(qdma.io.pcie_clk,!qdma.io.pcie_arstn)
	axi_slave.io.axi	<> qdma.io.axib

	val r_data = axi_slave.io.axi.r.bits.data(31,0)

	//count
	withClockAndReset(user_clk,!user_rstn){
		val count_w_fire = RegInit(0.U(32.W))
		when(qdma.io.axib.w.fire()){
			count_w_fire	:= count_w_fire+1.U
		}
		qdma.io.reg_status(0)	:= count_w_fire
	}
	
	//h2c
	val control_reg = qdma.io.reg_control
	val status_reg = qdma.io.reg_status
	val h2c =  withClockAndReset(qdma.io.user_clk,!qdma.io.user_arstn){Module(new H2CRandom())}

	h2c.io.start_addr			:= Cat(control_reg(100), control_reg(101))
	h2c.io.burst_length			:= control_reg(102)
	h2c.io.busrt_length_shift	:= control_reg(103)
	h2c.io.start				:= control_reg(104)
	h2c.io.total_words			:= control_reg(105)
	h2c.io.total_qs				:= control_reg(106)
	h2c.io.total_cmds			:= control_reg(107)
	
	for(i <- 0 until 16){
		h2c.io.count_words(i*32+31,i*32)	<> status_reg(105+i)
	}
	h2c.io.count_err_data		<> status_reg(100)
	h2c.io.count_right_data		<> status_reg(101)
	h2c.io.count_total_words	<> status_reg(102)
	h2c.io.count_send_cmd		<> status_reg(103)
	h2c.io.count_time			<> status_reg(104)
	h2c.io.h2c_cmd		<> qdma.io.h2c_cmd
	h2c.io.h2c_data		<> qdma.io.h2c_data

	//c2h
	val c2h = withClockAndReset(qdma.io.user_clk,!qdma.io.user_arstn){Module(new C2HRandom())}

	c2h.io.start_addr			:= Cat(control_reg(200), control_reg(201))
	c2h.io.burst_length			:= control_reg(202)
	c2h.io.busrt_length_shift	:= control_reg(203)
	c2h.io.start				:= control_reg(204)
	c2h.io.total_words			:= control_reg(205)
	c2h.io.total_qs				:= control_reg(206)
	c2h.io.total_cmds			:= control_reg(207)
	c2h.io.pfch_tag				:= control_reg(209)
	c2h.io.tag_index			:= control_reg(210)
	
	c2h.io.count_send_cmds		<> status_reg(200)
	c2h.io.count_send_words		<> status_reg(201)
	c2h.io.count_time			<> status_reg(202)
	c2h.io.c2h_cmd			<> qdma.io.c2h_cmd
	c2h.io.c2h_data			<> qdma.io.c2h_data

	Collector.connect_to_status_reg(status_reg,300)

}