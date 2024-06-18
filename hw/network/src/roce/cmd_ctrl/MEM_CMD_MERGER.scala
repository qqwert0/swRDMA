package network.roce.cmd_ctrl

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._

class MEM_CMD_MERGER() extends Module{
	val io = IO(new Bundle{
		val remote_read_req	= Flipped(Decoupled(new MEM_CMD()))

		val local_read_req	= Flipped(Decoupled(new MEM_CMD()))
		val m_mem_read_cmd	= (Decoupled(new MEM_CMD()))
		val pkg_info	    = (Decoupled(new PKG_INFO()))
	})


    val fifo_pkg_info = XQueue(new PKG_INFO(), 64)
    io.pkg_info <>fifo_pkg_info.io.out
    val arbiter = Module(new Arbiter(new MEM_CMD(),2))
    arbiter.io.in(0)    <>  io.remote_read_req
    arbiter.io.in(1)    <>  io.local_read_req
    arbiter.io.out      <>  io.m_mem_read_cmd

    when(io.remote_read_req.fire){
        fifo_pkg_info.io.in.bits.pkg_type := PKG_TYPE.AETH
        fifo_pkg_info.io.in.valid := 1.U
        fifo_pkg_info.io.in.bits.pkg_length := io.remote_read_req.bits.length
    }.elsewhen(io.local_read_req.fire){
        fifo_pkg_info.io.in.bits.pkg_type := PKG_TYPE.RETH
        fifo_pkg_info.io.in.valid := 1.U
        fifo_pkg_info.io.in.bits.pkg_length := io.local_read_req.bits.length
    }.otherwise{
        fifo_pkg_info.io.in.bits.pkg_type := PKG_TYPE.reserve0
        fifo_pkg_info.io.in.valid := 0.U
        fifo_pkg_info.io.in.bits.pkg_length := 0.U        
    }
    


    arbiter.io.out.ready := io.m_mem_read_cmd.ready & (fifo_pkg_info.io.count < 60.U)
    

}