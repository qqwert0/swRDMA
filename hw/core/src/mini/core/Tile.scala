// See LICENSE for license details.

package mini.core

import chisel3._
import chisel3.experimental.ChiselEnum
import chisel3.util._
import mini.junctions._
import common._
import common.storage._
import common.axi._

case class BramParameters( width : Int, staddr : String, edaddr : String, i_offset : String, d_offset : String, inst_entries : Int, data_entries : Int) {
    // require(entries >= 2, "BRAM must has at least 2 entries")
    // require(entries <= 1024*1024, "BRAM out of range")
    // require(width >= 0, "BRAM's width can't be less than 0")
    // require(width <= 1024, "BRAM's width can't be more than 1024")
    // require(staddr <= edaddr, "BRAM's start address can't be more than end address")
    // require(d_offset.U - i_offset.U === inst_entries * width / 8.U, "BRAM inst should match")  
    // require(edaddr.U - staddr.U === data_entries * width / 8.U, "BRAM data should match ")
    // todo
}

class MemArbiterIO(val xlen: Int, params: NastiBundleParameters) extends Bundle {
    val ibram = new CacheIO(xlen, xlen)
    val dbram = new CacheIO(xlen, xlen)
    val nasti = new NastiBundle(params)
}

class MemArbiter(val enable_hbm: Boolean, val xlen: Int, val nastiParams: NastiBundleParameters, val bramParams: BramParameters, val cacheParams: CacheConfig, val file: String) extends Module {
    val io = IO(new MemArbiterIO(xlen, nastiParams))

    val ibram = Module(new Bram(true, bramParams, nastiParams, xlen, file))
    val dbram = Module(new Bram(false, bramParams, nastiParams, xlen, "data.mem"))
    // val dbram2 = Module(new Bram(false, bramParams, nastiParams, xlen, "data2.mem"))
    ibram.io <> io.ibram
    dbram.io.req <> io.dbram.req
    if (enable_hbm) {
        val cache  = Module(new Cache(cacheParams, nastiParams, xlen))
        cache.io.cpu.req.valid := io.dbram.req.valid
        cache.io.cpu.req.bits.addr := io.dbram.req.bits.addr - bramParams.edaddr.U
        cache.io.cpu.req.bits.data := io.dbram.req.bits.data
        cache.io.cpu.req.bits.mask := io.dbram.req.bits.mask
        cache.io.cpu.abort := io.dbram.abort
        cache.io.nasti <> io.nasti

        val addr = io.dbram.req.bits.addr
        val range_check = addr >= bramParams.staddr.U && addr < bramParams.edaddr.U
        val range_reg = RegNext(range_check)
        dbram.io.abort := io.dbram.abort || !range_check

        io.dbram.resp <> Mux(range_reg, dbram.io.resp, cache.io.cpu.resp)
    }
    else {
        io.nasti <> DontCare
        io.dbram.resp <> dbram.io.resp
        dbram.io.abort := io.dbram.abort
    }

    // class ila_arb(seq:Seq[Data]) extends BaseILA(seq)
    //     val inst_ila_arb = Module(new ila_arb(Seq(				
    //     reset,
    //     debug_addr,
    //     io.ibram.abort,
    //     io.dbram.abort,
    //     range_check,
    //     range_reg,
    //     io.ibram.req.valid,
    //     io.ibram.req.bits.addr,
    //     io.ibram.resp.bits.data,
    //     io.dbram.req.bits.addr,
    //     io.dbram.req.valid,
    //     io.dbram.req.bits.data,
    //     io.dbram.req.bits.mask,
    //     io.dbram.resp.bits.data,
    //     io.dbram.resp.valid,

    //     dbram.io.resp.bits.data,
    //     dbram.io.resp.valid,
    //     cache.io.cpu.resp.bits.data,
    //     cache.io.cpu.resp.valid,

    //     io.nasti.ar.bits.addr,
    //     io.nasti.ar.valid,
    //     io.nasti.ar.ready,
    //     io.nasti.r.bits.data,
    //     io.nasti.r.valid,
    //     io.nasti.r.ready,
    //     io.nasti.aw.bits.addr,
    //     io.nasti.aw.valid,
    //     io.nasti.aw.ready,
    //     io.nasti.w.bits.data,
    //     io.nasti.w.valid,
    //     io.nasti.w.ready,
    //     io.nasti.b.bits.resp,
    //     io.nasti.b.valid,
    //     io.nasti.b.ready,

    //     )))
	//   inst_ila_arb.connect(clock)
}

class TileIO(xlen: Int, nastiParams: NastiBundleParameters) extends Bundle {
    val host = new HostIO(xlen)
    val nasti = new NastiBundle(nastiParams)
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

object Tile {
    def apply(config: Config): Tile = new Tile(config.enable_hbm, config.core, config.nasti, config.bram, config.cache)
}


class Tile(val enable_hbm: Boolean = false, val coreParams: CoreConfig, val nastiParams: NastiBundleParameters, val bramParams: BramParameters, val cacheParams: CacheConfig, val file: String="inst.mem")
    extends Module {
    val io = IO(new TileIO(coreParams.xlen, nastiParams))
    val core = Module(new Core(coreParams))
    val arb = Module(new MemArbiter(enable_hbm, coreParams.xlen, nastiParams, bramParams, cacheParams, file))

    io.host <> core.io.host
    arb.io.ibram <> core.io.icache
    arb.io.dbram <> core.io.dcache
    io.nasti <> arb.io.nasti            // for hbm
    io.rdma_print_addr := core.io.rdma_print_addr
    io.rdma_print_string_num := core.io.rdma_print_string_num
    io.rdma_print_string_len := core.io.rdma_print_string_len
    io.rdma_trap := core.io.rdma_trap
    io.pkg_type_to_cc  <> core.io.pkg_type_to_cc
    io.user_header_len <> core.io.user_header_len
    io.user_table_size <> core.io.user_table_size
    io.has_event_wr <> core.io.has_event_wr
    io.has_event_rd <> core.io.has_event_rd
    io.event_recv_cnt <> core.io.event_recv_cnt
    io.event_processed_cnt <> core.io.event_processed_cnt
    io.event_type <> core.io.event_type
    io.user_csr_wr <> core.io.user_csr_wr
    io.user_csr_rd <> core.io.user_csr_rd
}

// 处理 inst
class Bram(val InstBram: Boolean, val b: BramParameters, val nasti: NastiBundleParameters, val xlen: Int, val file: String) extends Module {
    val io = IO(new CacheIO(addrWidth = xlen, dataWidth = xlen))
    if (InstBram) {
        val bram = XRam(UInt(b.width.W), entries=b.inst_entries, memory_type="ultra", latency=1, use_musk=1, initFile=file)
        val i_addr = log2Ceil(b.inst_entries).U
        val offset = log2Ceil(b.width/8).U
        bram.io.addr_a := DontCare
        val offset_addr = io.req.bits.addr - b.i_offset.U(xlen.W)
        bram.io.addr_b := offset_addr >> offset
        bram.io.wr_en_a := DontCare
        bram.io.musk_a.get := DontCare    
        bram.io.data_in_a := DontCare
        io.resp.bits.data := bram.io.data_out_b
        io.resp.valid := true.B
    }
    else {
        val bram = XRam(UInt(b.width.W), entries=b.data_entries, memory_type="ultra", latency=1, use_musk=1, initFile=file)
        val d_addr = log2Ceil(b.data_entries).U
        val offset = log2Ceil(b.width/8).U
        val offset_addr = io.req.bits.addr - b.d_offset.U(xlen.W)
        bram.io.addr_a := offset_addr >> offset
        bram.io.addr_b := offset_addr >> offset
        bram.io.wr_en_a := io.req.valid && io.req.bits.mask.orR && !io.abort
        bram.io.musk_a.get := io.req.bits.mask.asUInt
        bram.io.data_in_a := io.req.bits.data
        io.resp.bits.data := bram.io.data_out_b
        io.resp.valid := true.B

        // class ila_bram(seq:Seq[Data]) extends BaseILA(seq)
        // val inst_ila_bram = Module(new ila_bram(Seq(
        //     reset,
        //     io.req.valid,
        //     io.req.bits.addr,
        //     io.req.bits.data,
        //     io.req.bits.mask,
        //     io.abort,
        //     bram.io.data_out_a,
        //     bram.io.addr_a,
        //     bram.io.data_in_a,
        //     bram.io.data_out_b,
        // )))

        // inst_ila_bram.connect(clock)
    }
}
