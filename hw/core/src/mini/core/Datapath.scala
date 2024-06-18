// See LICENSE for license details.

package mini.core

import chisel3._
import chisel3.util._
import chisel3.experimental.BundleLiterals._
import common._
import common.storage._
import common.axi._

object Const {
  val PC_START = "x80000000"
  val PC_EVEC = 0x100
}

class DatapathIO(xlen: Int) extends Bundle {
  val host = new HostIO(xlen)
  val icache = Flipped(new CacheIO(xlen, xlen))
  val dcache = Flipped(new CacheIO(xlen, xlen))
  val ctrl = Flipped(new ControlSignals)
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

class FetchExecutePipelineRegister(xlen: Int) extends Bundle {
  val inst = chiselTypeOf(Instructions.NOP)
  val pc = UInt(xlen.W)
}

class ExecuteMemoryPipelineRegister(xlen: Int) extends Bundle {
  val inst = chiselTypeOf(Instructions.NOP)
  val pc = UInt(xlen.W)
  val alu = UInt(xlen.W)
  val sum = UInt(xlen.W)
  val csr_in = UInt(xlen.W)
  // val st_type = UInt(2.W)   // todo: parameterized
  val ld_type = UInt(3.W)
  val rs2 = UInt(xlen.W)
  val wb_en = Bool()
  val wb_sel = UInt(2.W)
}

class MemoryWritebackPipelineRegister(xlen: Int) extends Bundle {
  val inst = chiselTypeOf(Instructions.NOP)
  val pc = UInt(xlen.W)
  val alu = UInt(xlen.W)
  // val load = UInt(xlen.W)
  val csr_out = UInt(xlen.W)
  // val csr_in = UInt(xlen.W)
}

// class ExecuteWritebackPipelineRegister(xlen: Int) extends Bundle {
//   val inst = chiselTypeOf(Instructions.NOP)
//   val pc = UInt(xlen.W)
//   val alu = UInt(xlen.W)
//   val csr_in = UInt(xlen.W)
// }

class Datapath(val conf: CoreConfig) extends Module {
  val io = IO(new DatapathIO(conf.xlen))
  val csr = Module(new CSR(conf.xlen))
  val regFile = Module(new RegFile(conf.xlen))
  val alu = Module(conf.makeAlu(conf.xlen))
  val immGen = Module(conf.makeImmGen(conf.xlen))
  val brCond = Module(conf.makeBrCond(conf.xlen))

  import Control._

  io.rdma_print_addr := csr.io.rdma_print_addr
  io.rdma_print_string_num := csr.io.rdma_print_string_num
  io.rdma_print_string_len := csr.io.rdma_print_string_len
  io.rdma_trap := csr.io.rdma_trap
  io.pkg_type_to_cc  <> csr.io.pkg_type_to_cc
  io.user_header_len <> csr.io.user_header_len
  io.user_table_size <> csr.io.user_table_size
  io.has_event_wr <> csr.io.has_event_wr
  io.has_event_rd <> csr.io.has_event_rd
  io.event_recv_cnt <> csr.io.event_recv_cnt
  io.event_processed_cnt <> csr.io.event_processed_cnt
  io.event_type <> csr.io.event_type
  io.user_csr_wr <> csr.io.user_csr_wr
  io.user_csr_rd <> csr.io.user_csr_rd

  /** Pipeline State Registers * */

  /** *** Fetch / Execute Registers ****
    */
  val fe_reg = RegInit(
    (new FetchExecutePipelineRegister(conf.xlen)).Lit(
      _.inst -> Instructions.NOP,
      _.pc -> 0.U
    )
  )

  /** *** Execute / Memory Registers ****
    */
  val em_reg = RegInit(
    (new ExecuteMemoryPipelineRegister(conf.xlen)).Lit(
      _.inst -> Instructions.NOP,
      _.pc -> 0.U,
      _.alu -> 0.U,
      _.sum -> 0.U,
      _.csr_in -> 0.U,
      // _.st_type -> 0.U,
      _.ld_type -> 0.U,
      _.rs2 -> 0.U,
      _.wb_en -> false.B,
      _.wb_sel -> 0.U
    )
  )

  /** *** Memory / Writeback Registers ****
    */
  val mw_reg = RegInit(
    (new MemoryWritebackPipelineRegister(conf.xlen)).Lit(
      _.inst -> Instructions.NOP,
      _.pc -> 0.U,
      _.alu -> 0.U,
      // _.load -> 0.U,
      _.csr_out -> 0.U
    )
  )
  

  /** **** Control signals ****
    */
  val st_type = Reg(io.ctrl.st_type.cloneType)
  val ld_type = Reg(io.ctrl.ld_type.cloneType)
  val wb_sel = RegInit(io.ctrl.wb_sel.cloneType, false.B)
  val wb_en = RegInit(Bool(), false.B)
  val csr_cmd = Reg(io.ctrl.csr_cmd.cloneType)
  val illegal = Reg(Bool())
  val pc_check = Reg(Bool())
  val is_wfi = RegInit(Bool(), false.B)
  val is_load = RegInit(Bool(), false.B)
  
  when(fe_reg.inst === Instructions.WFI) {
    is_wfi := true.B
  }.otherwise {
    is_wfi := is_wfi
  }

  val load_use_hazard = Wire(Bool())
  /** **** Fetch ****
    */
  val started = RegNext(reset.asBool)
  val stall = !io.icache.resp.valid || !io.dcache.resp.valid || load_use_hazard
  val pc = RegInit(Const.PC_START.U(conf.xlen.W) - 4.U(conf.xlen.W))
  // Next Program Counter
  val next_pc = MuxCase(
    pc + 4.U,
    IndexedSeq(
      stall -> pc,
      csr.io.expt -> csr.io.evec,
      (io.ctrl.pc_sel === PC_EPC) -> csr.io.epc,
      ((io.ctrl.pc_sel === PC_ALU) || (brCond.io.taken)) -> (alu.io.sum >> 1.U << 1.U),
      (io.ctrl.pc_sel === PC_0) -> pc
    )
  )
  val inst =
    Mux(started || io.ctrl.inst_kill || brCond.io.taken || csr.io.expt || is_wfi, Instructions.NOP, io.icache.resp.bits.data)
  pc := next_pc
  io.icache.req.bits.addr := next_pc
  io.icache.req.bits.data := 0.U
  io.icache.req.bits.mask := 0.U
  io.icache.req.valid := !stall
  io.icache.abort := false.B

  // Pipelining
  when(!stall) {
    fe_reg.pc := pc
    fe_reg.inst := inst
  }

  /** **** Execute ****
    */
  io.ctrl.inst := fe_reg.inst

  // regFile read
  val rd_addr = Reg(UInt(5.W))
  val rs1_addr = Reg(UInt(5.W))
  val rs2_addr = Reg(UInt(5.W))
  when(!stall) {
    rd_addr := inst(11, 7)
    rs1_addr := inst(19, 15)
    rs2_addr := inst(24, 20)
  }
  regFile.io.raddr1 := rs1_addr
  regFile.io.raddr2 := rs2_addr

  // gen immdeates
  immGen.io.inst := fe_reg.inst
  immGen.io.sel := io.ctrl.imm_sel

  // bypass
  // MEM => CSR or ALU res
  // WB  => Load or ALU res
  

  val wb_rd_addr = mw_reg.inst(11, 7)
  val wb_rd_addr_mem = em_reg.inst(11, 7)
  val rs1hazard_wb = wb_en && rs1_addr.orR && (rs1_addr === wb_rd_addr)
  val rs2hazard_wb = wb_en && rs2_addr.orR && (rs2_addr === wb_rd_addr)

  val rs1hazard_mem = em_reg.wb_en && rs1_addr.orR && (rs1_addr === wb_rd_addr_mem)
  val rs2hazard_mem = em_reg.wb_en && rs2_addr.orR && (rs2_addr === wb_rd_addr_mem)

  // or wb_mem?
  // 这里的 load 已经进行了 lb lh lbu lhu
  // 需要根据 wb_sel 判断 bypass
  val load_tmp = Wire(UInt(32.W))
  val rs1_mem = Mux(em_reg.wb_sel === WB_ALU, em_reg.alu, csr.io.out)
  val rs2_mem = Mux(em_reg.wb_sel === WB_ALU, em_reg.alu, csr.io.out)

  val rs1_wb  = Mux(wb_sel === WB_MEM, load_tmp, Mux(wb_sel === WB_CSR, mw_reg.csr_out, mw_reg.alu))
  val rs2_wb  = Mux(wb_sel === WB_MEM, load_tmp, Mux(wb_sel === WB_CSR, mw_reg.csr_out, mw_reg.alu))
  // val rs1_alu = Mux(wb_sel === WB_ALU && rs1hazard, mw_reg.alu, regFile.io.rdata1)
  // val rs2_alu = Mux(wb_sel === WB_ALU && rs2hazard, mw_reg.alu, regFile.io.rdata2)
  // val rs1 = Mux(wb_sel === WB_CSR && rs1hazard, csr.io.out, rs1_alu)
  // val rs2 = Mux(wb_sel === WB_CSR && rs2hazard, csr.io.out, rs2_alu)

  load_use_hazard := wb_sel === WB_MEM && (rs1_addr === wb_rd_addr || rs2_addr === wb_rd_addr) && wb_en && is_load

  val rs1 = Mux(
      rs1hazard_mem, rs1_mem, Mux(rs1hazard_wb, rs1_wb, regFile.io.rdata1)
  )
  val rs2 = Mux(
      rs2hazard_mem, rs2_mem, Mux(rs2hazard_wb, rs2_wb, regFile.io.rdata2)
  )

  // ALU operations
  alu.io.A := Mux(io.ctrl.A_sel === A_RS1, rs1, fe_reg.pc)
  alu.io.B := Mux(io.ctrl.B_sel === B_RS2, rs2, immGen.io.out)
  alu.io.alu_op := io.ctrl.alu_op

  // Branch condition calc
  brCond.io.rs1 := rs1
  brCond.io.rs2 := rs2
  brCond.io.br_type := io.ctrl.br_type

  /** **** Memory ****
    */

  // D$ access
  // val daddr = Mux(stall, ew_reg.alu, em_reg.sum) >> 2.U << 2.U
  val daddr = em_reg.sum
  val woffset = (em_reg.sum(1) << 4.U).asUInt | (em_reg.sum(0) << 3.U).asUInt
  io.dcache.req.valid := !stall && (st_type.orR || em_reg.ld_type.orR)
  io.dcache.req.bits.addr := daddr
  io.dcache.req.bits.data := em_reg.rs2 << woffset
  io.dcache.req.bits.mask := MuxLookup(
    // em_reg.st_type,
    st_type,
    // Mux(stall, st_type, em_reg.st_type),   why?
    "b0000".U,
    Seq(ST_SW -> "b1111".U, ST_SH -> ("b11".U << em_reg.sum(1, 0)), ST_SB -> ("b1".U << em_reg.sum(1, 0)))
  )

  // Pipelining
  // 发生异常了该怎么办
  when(reset.asBool || !stall && csr.io.expt) {
    st_type := 0.U
    // ld_type := 0.U
    // wb_en := false.B
    csr_cmd := 0.U
    illegal := false.B
    pc_check := false.B
    em_reg.ld_type := 0.U
  }.elsewhen(!stall && !csr.io.expt) {
    em_reg.pc := fe_reg.pc
    em_reg.inst := fe_reg.inst
    em_reg.alu := alu.io.out
    em_reg.csr_in := Mux(io.ctrl.imm_sel === IMM_Z, immGen.io.out, rs1)
    // em_reg.st_type := io.ctrl.st_type
    // st_type := em_reg.st_type   // for csr
    st_type := io.ctrl.st_type
    em_reg.ld_type := io.ctrl.ld_type
    // ld_type := em_reg.ld_type   // for csr
    em_reg.rs2 := rs2
    em_reg.wb_sel := io.ctrl.wb_sel
    em_reg.wb_en := io.ctrl.wb_en
    em_reg.sum  := alu.io.sum

    csr_cmd := io.ctrl.csr_cmd
    illegal := io.ctrl.illegal  // for csr
    pc_check := io.ctrl.pc_sel === PC_ALU   // for csr
  }

  // Load (WB)
  // WB
  val loffset = (mw_reg.alu(1) << 4.U).asUInt | (mw_reg.alu(0) << 3.U).asUInt
  val lshift = Reg(UInt(conf.xlen.W))
  val dcache_resp = Reg(SInt((conf.xlen+1).W))
  lshift  := io.dcache.resp.bits.data >> loffset
  dcache_resp := io.dcache.resp.bits.data.zext
  val load = MuxLookup(
    ld_type,    
    dcache_resp,
    Seq(
      LD_LH -> lshift(15, 0).asSInt,
      LD_LB -> lshift(7, 0).asSInt,
      LD_LHU -> lshift(15, 0).zext,
      LD_LBU -> lshift(7, 0).zext
    )
  )
  load_tmp := load.asUInt
  
  // CSR access
  csr.io.stall := stall
  csr.io.in := em_reg.csr_in
  csr.io.cmd := csr_cmd
  csr.io.inst := em_reg.inst
  csr.io.pc := em_reg.pc
  csr.io.addr := em_reg.alu
  csr.io.illegal := illegal
  csr.io.pc_check := pc_check
  csr.io.ld_type := em_reg.ld_type
  csr.io.st_type := st_type
  io.host <> csr.io.host

  /** **** Write Back ****
    */

  // Regfile Write
  val regWrite =
    MuxLookup(
      wb_sel,
      mw_reg.alu.zext,
      Seq(WB_MEM -> load, WB_PC4 -> (mw_reg.pc + 4.U).zext, WB_CSR -> mw_reg.csr_out.zext)
    ).asUInt

  regFile.io.wen := wb_en && !stall // && !csr.io.expt
  regFile.io.waddr := wb_rd_addr
  regFile.io.wdata := regWrite

  // Abort store when there's an excpetion
  io.dcache.abort := csr.io.expt

  // Pipelining

  when(reset.asBool || !stall && csr.io.expt) {
    mw_reg.pc := 0.U
    mw_reg.inst := Instructions.NOP
    mw_reg.alu := 0.U
    // mw_reg.load := 0.U
    ld_type := 0.U
    mw_reg.csr_out := 0.U
    wb_sel := WB_MEM
    wb_en := false.B
    is_load := false.B
  }.elsewhen(!stall && !csr.io.expt && !is_load) {
    mw_reg.pc := em_reg.pc
    mw_reg.inst := em_reg.inst
    mw_reg.alu := em_reg.alu
    // mw_reg.load := load.asUInt
    ld_type := em_reg.ld_type
    mw_reg.csr_out := csr.io.out
    wb_sel := em_reg.wb_sel
    wb_en := em_reg.wb_en
    is_load := em_reg.ld_type.orR.asBool
  }.elsewhen(!csr.io.expt && is_load) {
    is_load := false.B
  }



  // class ila_core(seq:Seq[Data]) extends BaseILA(seq)
  //   val inst_ila_core = Module(new ila_core(Seq(				
  //     started,
  //     pc,
  //     inst,
  //     is_wfi,
  //     fe_reg.pc,
  //     fe_reg.inst,
  //     io.dcache.req.bits.addr,
  //     io.dcache.req.bits.data,
  //     io.dcache.req.bits.mask,
  //     io.dcache.req.valid,
  //     io.dcache.resp.bits.data,
  //     io.dcache.resp.valid,

  //     io.icache.req.bits.addr,
  //     io.icache.req.valid,
  //     io.icache.resp.bits.data,
  //     io.icache.resp.valid,

  //     stall,
  //     regFile.io.waddr,
  //     regFile.io.wdata,
  //     regFile.io.wen,

  //     ew_reg.pc,
  //     ew_reg.inst,

  //   )))
  //   inst_ila_core.connect(clock)
}
