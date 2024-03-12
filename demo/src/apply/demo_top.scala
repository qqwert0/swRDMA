package demo

import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._
import common.ToZero
import qdma._
import hbm._

class demo_top extends RawModule{
	val sysClkP			= IO(Input(Clock()))
	val sysClkN			= IO(Input(Clock()))
	val led		        = IO(Output(UInt(1.W)))

	val sysClk = Wire(Clock())
	
	val ibufdsInst = Module(new IBUFDS)
	ibufdsInst.io.I		:= sysClkP
	ibufdsInst.io.IB	:= sysClkN
	sysClk := ibufdsInst.io.O

    val hbmDriver = withClockAndReset(sysClk, false.B) {Module(new HBM_DRIVER)}
	hbmDriver.getTCL()
	val hbmClk 	= Wire(Clock())
	val hbmRstn = Wire(UInt(1.W))

	hbmClk 	    := hbmDriver.io.hbm_clk
	hbmRstn     := hbmDriver.io.hbm_rstn
    led         := 0.U

	for (i <- 0 until 32) {
		hbmDriver.io.axi_hbm(i).hbm_init()	// Read hbm_init function if you're not familiar with AXI.
	}
    
	// dontTouch(hbmClk)
	// dontTouch(hbmRstn)


    val vector_add = withClockAndReset(hbmClk, false.B) {Module(new vector_add())}
    vector_add.io.mem_interface <> hbmDriver.io.axi_hbm(0)


    class vio_nx(seq:Seq[Data]) extends BaseVIO(seq)	  
  	val nx = Module(new vio_nx(Seq(	
		vector_add.io.infor_in.bits.addr_read,
        vector_add.io.infor_in.bits.len_read,
        vector_add.io.infor_in.bits.addr_write,
        vector_add.io.infor_in.bits.len_write,
        vector_add.io.infor_in.valid,
        vector_add.io.infor_out.ready
  	)))
  	nx.connect(hbmClk)

    class ila_tx(seq:Seq[Data]) extends BaseILA(seq)	  
  	val tx = Module(new ila_tx(Seq(	
		vector_add.io.mem_interface,
        vector_add.io.infor_in,
        vector_add.io.infor_out
  	)))
  	tx.connect(hbmClk)




}