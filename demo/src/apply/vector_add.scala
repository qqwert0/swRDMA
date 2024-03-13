package demo

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common._
import common.axi._
import chisel3.util.{switch, is}

class vector_add extends Module{
	val io = IO(new Bundle{
		val start  		= Input(UInt(1.W))
		val done 		= Output(UInt(1.W))
		val pargs 		= Input(UInt(64.W))
    	val pdata 		= Input(UInt(64.W))
		val pres 		= Input(UInt(64.W))
		val args_len 	= Input(UInt(32.W))
		val data_len 	= Input(UInt(32.W))
		val ap_return 	= Output(UInt(32.W))
		val mem_interface = new AXI(64, 256, 0, 0, 8)
		/* 
		val m_axi_gmem_AWADDR    = Output(UInt(64.W))
        val m_axi_gmem_AWLEN     = Output(UInt(8.W))
        val m_axi_gmem_AWSIZE    = Output(UInt(3.W))
        val m_axi_gmem_AWBURST   = Output(UInt(2.W))
        val m_axi_gmem_AWLOCK    = Output(UInt(2.W))
        val m_axi_gmem_AWREGION  = Output(UInt(4.W))
        val m_axi_gmem_AWCACHE   = Output(UInt(4.W))
        val m_axi_gmem_AWPROT    = Output(UInt(3.W))
        val m_axi_gmem_AWQOS     = Output(UInt(4.W))
        val m_axi_gmem_AWVALID   = Output(UInt(1.W))
        val m_axi_gmem_AWREADY   = Input(UInt(1.W))
        val m_axi_gmem_WDATA     = Output(UInt(256.W))
        val m_axi_gmem_WSTRB     = Output(UInt(32.W))
        val m_axi_gmem_WLAST     = Output(UInt(1.W))
        val m_axi_gmem_WVALID    = Output(UInt(1.W))
        val m_axi_gmem_WREADY    = Input(UInt(1.W))
        val m_axi_gmem_BRESP     = Input(UInt(2.W))
        val m_axi_gmem_BVALID    = Input(UInt(1.W))
        val m_axi_gmem_BREADY    = Output(UInt(1.W))
        val m_axi_gmem_ARADDR    = Output(UInt(64.W))
        val m_axi_gmem_ARLEN     = Output(UInt(8.W))
        val m_axi_gmem_ARSIZE    = Output(UInt(3.W))
        val m_axi_gmem_ARBURST   = Output(UInt(2.W))
        val m_axi_gmem_ARLOCK    = Output(UInt(2.W))
        val m_axi_gmem_ARREGION  = Output(UInt(4.W))
        val m_axi_gmem_ARCACHE   = Output(UInt(4.W))
        val m_axi_gmem_ARPROT    = Output(UInt(3.W))
        val m_axi_gmem_ARQOS     = Output(UInt(4.W))
        val m_axi_gmem_ARVALID   = Output(UInt(1.W))
        val m_axi_gmem_ARREADY   = Input(UInt(1.W))
        val m_axi_gmem_RDATA     = Input(UInt(256.W))
        val m_axi_gmem_RRESP     = Input(UInt(2.W))
        val m_axi_gmem_RLAST     = Input(UInt(1.W))
        val m_axi_gmem_RVALID    = Input(UInt(1.W))
        val m_axi_gmem_RREADY    = Output(UInt(1.W))
		 */
	})

	val startreg1 = RegInit(1.U(1.W))
	io.ap_return := 0.U
	startreg1 := io.start
	//* state machine 1: total control
	val s_waiting :: s_computing :: s_computing_done :: Nil = Enum(3)

	val state1 = RegInit(s_waiting)
	var compute_done = Wire(UInt(1.W))

	switch(state1){
		is(s_waiting){
			when(startreg1 === 0.U && io.start === 1.U){   // at start rising edge
				state1:=s_computing
			}
		}
		is(s_computing){
			when(compute_done=== 1.U ){
				state1:=s_computing_done
			}
		}
		is(s_computing_done){
			state1:=s_waiting
		}
	}
	
	when(state1 === s_waiting){
		io.done := 1.U
	}.otherwise{
		io.done := 0.U
	}

	

	//* state machine 2: computing
	val s1 :: s2 :: s3 :: s4  :: Nil = Enum(4)
	val state2 = RegInit(s1)
	val result = Wire(UInt(256.W))

	switch(state2){
		is(s1){
			when(state1 === s_computing && io.mem_interface.ar.fire()){
				state2:=s2
			}
		}
		is(s2){
			when(io.mem_interface.r.fire() && io.mem_interface.r.bits.last === 1.U){
				state2:=s3
			}
		}
		is(s3){
			when(io.mem_interface.aw.fire() && io.mem_interface.w.fire() ){
				state2:=s4
			}
		}
		is(s4){
			when(state1 === s_computing_done ){
				state2:=s1
			}
		}
	}

	
	when(state2 === s4){
		compute_done := 1.U
	}.otherwise{
		compute_done := 0.U
	}


	
	when(state2 === s1){
		io.mem_interface.aw.valid := 0.U
		io.mem_interface.w.valid := 0.U
		io.mem_interface.b.ready := 1.U
		io.mem_interface.ar.valid := state1 === s_computing 
		io.mem_interface.r.ready := 0.U
	}.elsewhen(state2 === s2){
		io.mem_interface.aw.valid := 0.U
		io.mem_interface.w.valid := 0.U
		io.mem_interface.b.ready := 1.U
		io.mem_interface.ar.valid := 0.U
		io.mem_interface.r.ready := 1.U
	}.elsewhen(state2 === s3){
		io.mem_interface.aw.valid := 1.U
		io.mem_interface.w.valid := 1.U
		io.mem_interface.b.ready := 1.U
		io.mem_interface.ar.valid := 0.U
		io.mem_interface.r.ready := 0.U
	}.otherwise{
		io.mem_interface.aw.valid := 0.U
		io.mem_interface.w.valid := 0.U
		io.mem_interface.b.ready := 1.U
		io.mem_interface.ar.valid := 0.U
		io.mem_interface.r.ready := 0.U
	}

	val len = Wire(UInt(32.W))
	len := io.args_len
	io.mem_interface.ar.bits.addr := io.pargs    //todo : length need to be checked
	io.mem_interface.ar.bits.burst := 1.U
	io.mem_interface.ar.bits.cache := 0.U
	io.mem_interface.ar.bits.id := 0.U
	io.mem_interface.ar.bits.len := len >>5.U -1.U 
	io.mem_interface.ar.bits.lock := 0.U
	io.mem_interface.ar.bits.size := 5.U
	io.mem_interface.ar.bits.prot := 0.U
	io.mem_interface.ar.bits.qos := 0.U
	io.mem_interface.ar.bits.region := 0.U
	io.mem_interface.ar.bits.user := 0.U

	io.mem_interface.aw.bits.addr := io.pres
	io.mem_interface.aw.bits.burst := 1.U
	io.mem_interface.aw.bits.cache := 0.U
	io.mem_interface.aw.bits.id := 0.U
	io.mem_interface.aw.bits.len := 0.U
	io.mem_interface.aw.bits.lock := 0.U
	io.mem_interface.aw.bits.size := 5.U
	io.mem_interface.aw.bits.prot := 0.U
	io.mem_interface.aw.bits.qos := 0.U
	io.mem_interface.aw.bits.region := 0.U
	io.mem_interface.aw.bits.user := 0.U

	io.mem_interface.w.bits.data := result
	io.mem_interface.w.bits.strb := "hffffffff".U(32.W)
	io.mem_interface.w.bits.last := 1.U
	io.mem_interface.w.bits.user := 0.U
	
	val vec_entry = RegInit(VecInit(Seq.fill(8)(0.U(32.W))))
	result := Cat(vec_entry(7),vec_entry(6),vec_entry(5),vec_entry(4),vec_entry(3),vec_entry(2),vec_entry(1),vec_entry(0))

	when((state2 === s2 )&& io.mem_interface.r.fire() ){
		vec_entry(0) := vec_entry(0)+io.mem_interface.r.bits.data(31,0)
		vec_entry(1) := vec_entry(1)+io.mem_interface.r.bits.data(63,32)
		vec_entry(2) := vec_entry(2)+io.mem_interface.r.bits.data(95,64)
		vec_entry(3) := vec_entry(3)+io.mem_interface.r.bits.data(127,96)
		vec_entry(4) := vec_entry(4)+io.mem_interface.r.bits.data(159,128)
		vec_entry(5) := vec_entry(5)+io.mem_interface.r.bits.data(191,160)
		vec_entry(6) := vec_entry(6)+io.mem_interface.r.bits.data(223,192)
		vec_entry(7) := vec_entry(7)+io.mem_interface.r.bits.data(255,224)
	}
	when(state2 === s1){
		vec_entry(0) := 0.U(32.W)
		vec_entry(1) := 0.U(32.W)
		vec_entry(2) := 0.U(32.W)
		vec_entry(3) := 0.U(32.W)
		vec_entry(4) := 0.U(32.W)
		vec_entry(5) := 0.U(32.W)
		vec_entry(6) := 0.U(32.W)
		vec_entry(7) := 0.U(32.W)
	}

	
}
