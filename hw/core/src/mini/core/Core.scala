// See LICENSE for license details.

package mini.core

import chisel3._
import chisel3.util.Valid

case class CoreConfig(
  xlen:       Int,
  makeAlu:    Int => Alu = new AluSimple(_),
  makeBrCond: Int => BrCond = new BrCondSimple(_),
  makeImmGen: Int => ImmGen = new ImmGenWire(_))

class HostIO(xlen: Int) extends Bundle {
  val fromhost = Flipped(Valid(UInt(xlen.W)))
  val tohost = Output(UInt(xlen.W))
}

class CoreIO(xlen: Int) extends Bundle {
  val host = new HostIO(xlen)
  val icache = Flipped(new CacheIO(xlen, xlen))
  val dcache = Flipped(new CacheIO(xlen, xlen))
  // RDMA CSR
  val rdma_print_addr = Output(UInt(xlen.W))
  val rdma_print_string_num = Output(UInt(xlen.W))
  val rdma_print_string_len = Output(UInt(xlen.W))
  val rdma_trap = Output(UInt(xlen.W))
  // RDMA Hardware
  val pkg_type_to_cc    = Output(UInt(xlen.W))
  val user_header_len   = Output(UInt(xlen.W))
  val user_table_size   = Output(UInt(xlen.W))
  val has_event_wr	    = Input(Bool())   
  val has_event_rd	    = Output(Bool())  
  val event_recv_cnt	    = Output(UInt(xlen.W))
  val event_processed_cnt	= Output(UInt(xlen.W))
  val event_type	        = Output(UInt(xlen.W))
  val user_csr_wr	    = Input(Vec(16,UInt(xlen.W)))
	val user_csr_rd	    = Output(Vec(16,UInt(xlen.W)))
}

class Core(val conf: CoreConfig) extends Module {
  val io = IO(new CoreIO(conf.xlen))
  val dpath = Module(new Datapath(conf))
  val ctrl = Module(new Control)

  io.host <> dpath.io.host
  dpath.io.icache <> io.icache
  dpath.io.dcache <> io.dcache
  dpath.io.ctrl <> ctrl.io
  io.rdma_print_addr := dpath.io.rdma_print_addr
  io.rdma_print_string_num := dpath.io.rdma_print_string_num
  io.rdma_print_string_len := dpath.io.rdma_print_string_len
  io.rdma_trap := dpath.io.rdma_trap

  io.pkg_type_to_cc  <> dpath.io.pkg_type_to_cc
  io.user_header_len <> dpath.io.user_header_len
  io.user_table_size <> dpath.io.user_table_size
  io.has_event_wr <> dpath.io.has_event_wr
  io.has_event_rd <> dpath.io.has_event_rd
  io.event_recv_cnt <> dpath.io.event_recv_cnt
  io.event_processed_cnt <> dpath.io.event_processed_cnt
  io.event_type <> dpath.io.event_type
  io.user_csr_wr <> dpath.io.user_csr_wr
  io.user_csr_rd <> dpath.io.user_csr_rd
}
