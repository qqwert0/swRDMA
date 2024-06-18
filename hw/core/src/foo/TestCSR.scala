package mini.foo

import chisel3._
import chisel3.util._
import qdma._
import hbm._
import common._
import common.storage._
import common.axi._
import qdma.examples._
import common.partialReconfig.AlveoStaticIO
import mini.foo._
import mini.core._
import mini.junctions._

class test_csr extends Module {
    val io = IO(new Bundle {
        val cpu_started = Input(Bool())
        val pkg_type_to_cc    = Output(UInt(32.W))
        val user_header_len   = Output(UInt(32.W))
        val user_table_size   = Output(UInt(32.W))
        val has_event_wr	    = Input(Bool())   //write pkg_meta & cc_state
        val has_event_rd	    = Output(Bool())  // has_event_rd ==0 &  event_recv_cnt == event_processed_cnt
        val event_recv_cnt	    = Output(UInt(32.W))
        val event_processed_cnt	= Output(UInt(32.W))
        val event_type	        = Output(UInt(32.W))
        val user_csr_wr	    = Input(Vec(32,UInt(32.W)))
		val user_csr_rd	    = Output(Vec(32,UInt(32.W)))
    })

    val config = MiniConfig()
	val mini_core =  { 
		Module(new Tile(
        enable_hbm = config.enable_hbm,
		coreParams = config.core, 
		bramParams = config.bram,
		nastiParams = config.nasti, 
		cacheParams = config.cache
		))
	}

    io.pkg_type_to_cc  <> mini_core.io.pkg_type_to_cc
    io.user_header_len <> mini_core.io.user_header_len
    io.user_table_size <> mini_core.io.user_table_size
    mini_core.io.has_event_wr <> io.has_event_wr
    mini_core.io.has_event_rd <> io.has_event_rd
    mini_core.io.event_recv_cnt <> io.event_recv_cnt
    mini_core.io.event_processed_cnt <> io.event_processed_cnt
    mini_core.io.event_type <> io.event_type
    mini_core.io.user_csr_wr <> io.user_csr_wr
    io.user_csr_rd <> mini_core.io.user_csr_rd

    mini_core.io.host := DontCare
    mini_core.io.nasti := DontCare
    mini_core.io.rdma_print_addr := DontCare
    mini_core.io.rdma_print_string_num := DontCare
    mini_core.io.rdma_print_string_len := DontCare
    mini_core.io.rdma_trap := DontCare


}