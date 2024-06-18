package qdma.examples

import chisel3._
import chisel3.util._
import qdma._
import common._
import common.storage._
import common.axi._


class AXILBenchmarkTop() extends RawModule {
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
		when(qdma.io.axib.w.fire){
			count_w_fire	:= count_w_fire+1.U
		}
		qdma.io.reg_status(0)	:= count_w_fire
	}
	
	//h2c
	val control_reg = qdma.io.reg_control
	val status_reg = qdma.io.reg_status
	val h2c =  withClockAndReset(qdma.io.user_clk,!qdma.io.user_arstn){Module(new H2C_AXIL())}

	h2c.io.startAddress	    := Cat(control_reg(100), control_reg(101))
	h2c.io.length		    := control_reg(102)
	h2c.io.sop			    := control_reg(103)
	h2c.io.eop			    := control_reg(104)
	h2c.io.totalWords	    := control_reg(105)
	h2c.io.totalCommands    := control_reg(106)
    h2c.io.start		    := control_reg(110)
    
	h2c.io.countError	    <> status_reg(100)
	h2c.io.countTime	    <> status_reg(101)
    h2c.io.countWords       <> status_reg(102)
	h2c.io.h2cCommand	    <> qdma.io.h2c_cmd
	h2c.io.h2cData		    <> qdma.io.h2c_data

	//c2h
	val c2h = withClockAndReset(qdma.io.user_clk,!qdma.io.user_arstn){Module(new C2H_AXIL())}

	
	c2h.io.startAddress		:= Cat(control_reg(120), control_reg(121))
	c2h.io.length			:= control_reg(122)
	c2h.io.totalWords		:= control_reg(123)
	c2h.io.totalCommands	:= control_reg(124)
	c2h.io.pfchTag			:= control_reg(125)
    c2h.io.tagIndex         := control_reg(126)
    c2h.io.start			:= control_reg(130)
	
	c2h.io.countCommand		<> status_reg(110)
    c2h.io.countTime		<> status_reg(111)
	c2h.io.countWords		<> status_reg(112)
	c2h.io.c2hCommand		<> qdma.io.c2h_cmd
	c2h.io.c2hData			<> qdma.io.c2h_data

}
