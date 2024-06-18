package demo

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import chisel3.util.{switch, is}


/* 
description :
	vector : 8*32bit,could be 16*32bit
	this module reduce the vector to 8*32bit
pargs:
| vector address(64bit) | vector length(32bit) |

ags_len: 64 byte
such as:
vaector address: 0x0000000000000000
vector length: 64 (bytes)
vector: 
256'h0000000100000002000000030000000400000005000000060000000700000008;
256'h0000000100000002000000030000000400000005000000060000000700000008;

reduce result:
256'h000000020000000400000006000000080000000a0000000c0000000e00000010;	            


 */
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
		 
	})

	val startreg1 = RegInit(1.U(1.W))
	val reduce_addr = Reg(UInt(64.W))
	val reduce_len = Reg(UInt(32.W))
	io.ap_return := 0.U
	startreg1 := io.start
	//state machine 1: total control
	//val s_waiting :: s_computing :: s_computing_done :: Nil = Enum(3)
	val s1_0 :: s1_1 :: s1_2 :: s1_3 :: Nil = Enum(4)

	val state1 = RegInit(s1_0)
	var compute_done = Wire(UInt(1.W))

	switch(state1){
		is(s1_0){
			when(startreg1 === 0.U && io.start === 1.U){   // at start rising edge
				state1:=s1_1
			}
		}
		is(s1_1){
			when(io.m_axi_gmem_ARVALID ===1.U && io.m_axi_gmem_ARREADY === 1.U ){
				state1:=s1_2
			}
		}
		is(s1_2){
			when(io.m_axi_gmem_RVALID ===1.U && io.m_axi_gmem_RREADY === 1.U && io.m_axi_gmem_RLAST === 1.U){
				state1:=s1_3
			}
		}
		is(s1_3){
			when(compute_done=== 1.U ){
				state1:=s1_0
			}
		}
	}
	
	when(state1 === s1_0){
		io.done := 1.U
	}.otherwise{
		io.done := 0.U
	}

	

	// state machine 2: computing
	val s1 :: s2 :: s3 :: s4  :: Nil = Enum(4)
	val state2 = RegInit(s1)
	val result = Wire(UInt(256.W))

	switch(state2){
		is(s1){
			when(state1 === s1_3 && io.m_axi_gmem_ARVALID === 1.U && io.m_axi_gmem_ARREADY === 1.U){ 
				state2:=s2
			}
		}
		is(s2){
			when(io. m_axi_gmem_RVALID === 1.U && io. m_axi_gmem_RREADY  === 1.U && io.m_axi_gmem_RLAST === 1.U){
				state2:=s3
			}
		}
		is(s3){
			when(io.m_axi_gmem_AWREADY === 1.U && io.m_axi_gmem_AWVALID === 1.U && io.m_axi_gmem_WVALID === 1.U && io.m_axi_gmem_WREADY === 1.U){
				state2:=s4
			}
		}
		is(s4){
			when(state1 === s1_1 ){
				state2:=s1
			}
		}
	}

	
	when(state2 === s4){
		compute_done := 1.U
	}.otherwise{
		compute_done := 0.U
	}

	io.m_axi_gmem_BREADY := 1.U
	
	when(state1 === s1_1 || state2 === s1){
		io.m_axi_gmem_ARVALID := 1.U
	}.otherwise{
		io.m_axi_gmem_ARVALID := 0.U
	}

	when(state1 === s1_2 || state2 === s2){
		io.m_axi_gmem_RREADY := 1.U
	}.otherwise{
		io.m_axi_gmem_RREADY := 0.U
	}
	
	when(state2 === s3){
		io.m_axi_gmem_AWVALID := 1.U
		io.m_axi_gmem_WVALID := 1.U
	}.otherwise{
		io.m_axi_gmem_AWVALID := 0.U
		io.m_axi_gmem_WVALID := 0.U
	}



	val arglen = Wire(UInt(32.W))
	arglen := io.args_len
	io.m_axi_gmem_ARADDR := Mux((state1 === s1_3),reduce_addr,io.pargs)  //io.pargs    //todo : length need to be checked
	io.m_axi_gmem_ARBURST := 1.U
	io.m_axi_gmem_ARCACHE := 0.U
	io.m_axi_gmem_ARLEN  := Mux((state1 === s1_3),((reduce_len >>5.U) -1.U ),((arglen >>5.U) -1.U) )
	io.m_axi_gmem_ARLOCK := 0.U
	io.m_axi_gmem_ARSIZE := 5.U
	io.m_axi_gmem_ARPROT := 0.U
	io.m_axi_gmem_ARQOS := 0.U
	io.m_axi_gmem_ARREGION := 0.U

	io.m_axi_gmem_AWADDR := io.pres
	io.m_axi_gmem_AWBURST := 1.U
	io.m_axi_gmem_AWCACHE := 0.U
	io.m_axi_gmem_AWLEN := 0.U
	io.m_axi_gmem_AWLOCK := 0.U
	io.m_axi_gmem_AWSIZE := 5.U
	io.m_axi_gmem_AWPROT := 0.U
	io.m_axi_gmem_AWQOS := 0.U
	io.m_axi_gmem_AWREGION := 0.U

	io.m_axi_gmem_WDATA  := result
	io.m_axi_gmem_WSTRB := "hffffffff".U(32.W)
	io.m_axi_gmem_WLAST  := 1.U
	
	val vec_entry = RegInit(VecInit(Seq.fill(8)(0.U(32.W))))
	result := Cat(vec_entry(7),vec_entry(6),vec_entry(5),vec_entry(4),vec_entry(3),vec_entry(2),vec_entry(1),vec_entry(0))

	when((state2 === s2 )&& io.m_axi_gmem_RREADY === 1.U && io.m_axi_gmem_RVALID === 1.U){
		vec_entry(0) := vec_entry(0)+io.m_axi_gmem_RDATA(31,0)
		vec_entry(1) := vec_entry(1)+io.m_axi_gmem_RDATA(63,32)
		vec_entry(2) := vec_entry(2)+io.m_axi_gmem_RDATA(95,64)
		vec_entry(3) := vec_entry(3)+io.m_axi_gmem_RDATA(127,96)
		vec_entry(4) := vec_entry(4)+io.m_axi_gmem_RDATA(159,128)
		vec_entry(5) := vec_entry(5)+io.m_axi_gmem_RDATA(191,160)
		vec_entry(6) := vec_entry(6)+io.m_axi_gmem_RDATA(223,192)
		vec_entry(7) := vec_entry(7)+io.m_axi_gmem_RDATA(255,224)
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

	when((state1 === s1_2 )&& io.m_axi_gmem_RREADY === 1.U && io.m_axi_gmem_RVALID === 1.U){
		reduce_addr := io.m_axi_gmem_RDATA(63,0)
		reduce_len := io.m_axi_gmem_RDATA(95,64)
	}

}

