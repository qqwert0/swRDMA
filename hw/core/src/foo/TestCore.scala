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

class TestCore extends Module {
    val io = IO(new Bundle {
        val cpu_started = Input(Bool())
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

    mini_core.io.pkg_type_to_cc := DontCare
    mini_core.io.user_header_len := DontCare
    mini_core.io.user_table_size := DontCare
    mini_core.io.has_event_wr <> DontCare
    mini_core.io.has_event_rd <> DontCare
    mini_core.io.event_recv_cnt <> DontCare
    mini_core.io.event_processed_cnt <> DontCare
    mini_core.io.event_type <> DontCare
    mini_core.io.user_csr_wr <> DontCare
    mini_core.io.user_csr_rd <> DontCare 

    mini_core.io.host := DontCare
    mini_core.io.nasti := DontCare
    mini_core.io.rdma_print_addr := DontCare
    mini_core.io.rdma_print_string_num := DontCare
    mini_core.io.rdma_print_string_len := DontCare
    mini_core.io.rdma_trap := DontCare


}