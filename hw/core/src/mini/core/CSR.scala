// See LICENSE for license details.

package mini.core

import chisel3._
import chisel3.util._
import common._
import common.storage._
import common.axi._

object CSR {
  val N = 0.U(3.W)
  val W = 1.U(3.W)
  val S = 2.U(3.W)
  val C = 3.U(3.W)
  val P = 4.U(3.W)

  // Supports machine & user modes
  val PRV_U = 0x0.U(2.W)
  val PRV_M = 0x3.U(2.W)

  // User-level CSR addrs
  val cycle = 0xc00.U(12.W)
  val time = 0xc01.U(12.W)
  val instret = 0xc02.U(12.W)
  val cycleh = 0xc80.U(12.W)
  val timeh = 0xc81.U(12.W)
  val instreth = 0xc82.U(12.W)

  // Supervisor-level CSR addrs
  val cyclew = 0x900.U(12.W)
  val timew = 0x901.U(12.W)
  val instretw = 0x902.U(12.W)
  val cyclehw = 0x980.U(12.W)
  val timehw = 0x981.U(12.W)
  val instrethw = 0x982.U(12.W)

  // Machine-level CSR addrs
  // Machine Information Registers
  val mcpuid = 0xf00.U(12.W)
  val mimpid = 0xf01.U(12.W)
  val mhartid = 0xf10.U(12.W)
  // Machine Trap Setup
  val mstatus = 0x300.U(12.W)
  val mtvec = 0x301.U(12.W)
  val mtdeleg = 0x302.U(12.W)
  val mie = 0x304.U(12.W)
  val mtimecmp = 0x321.U(12.W)
  // Machine Timers and Counters
  val mtime = 0x701.U(12.W)
  val mtimeh = 0x741.U(12.W)
  // Machine Trap Handling
  val mscratch = 0x340.U(12.W)
  val mepc = 0x341.U(12.W)
  val mcause = 0x342.U(12.W)
  val mbadaddr = 0x343.U(12.W)
  val mip = 0x344.U(12.W)
  // Machine HITF
  val mtohost = 0x780.U(12.W)
  val mfromhost = 0x781.U(12.W)
  // RDMA CSR
  val rdma_print_addr = 0xF0.U(12.W)
  val rdma_print_string_num = 0xF1.U(12.W)
  val rdma_print_string_len = 0xF2.U(12.W)
  val rdma_trap = 0xF3.U(12.W)
  
  // 0x050-0x6F
  // val meta_csr = "b000001??????".U(12.W)
  val user_table_size = 0x080.U(12.W)
  val user_header_len = 0x081.U(12.W)
  val pkg_type_to_cc = 0x082.U(12.W)
  val has_event = 0x090.U(12.W)
  val event_recv_cnt = 0x091.U(12.W)
  val event_processed_cnt = 0x092.U(12.W)
  val event_type = 0x093.U(12.W)

  val regs = List(
    cycle,
    time,
    instret,
    cycleh,
    timeh,
    instreth,
    cyclew,
    timew,
    instretw,
    cyclehw,
    timehw,
    instrethw,
    mcpuid,
    mimpid,
    mhartid,
    mtvec,
    mtdeleg,
    mie,
    mtimecmp,
    mtime,
    mtimeh,
    mscratch,
    mepc,
    mcause,
    mbadaddr,
    mip,
    mtohost,
    mfromhost,
    mstatus,
    // RDMA CSR
    rdma_print_addr,
    rdma_print_string_num,
    rdma_print_string_len,
    rdma_trap,
    // RDMA Hardware
    // meta_csr,
    pkg_type_to_cc,
    user_table_size,
    user_header_len,
    has_event,
    event_recv_cnt,
    event_processed_cnt,
    event_type

  )
}

object Cause {
  val InstAddrMisaligned = 0x0.U
  val IllegalInst = 0x2.U
  val Breakpoint = 0x3.U
  val LoadAddrMisaligned = 0x4.U
  val StoreAddrMisaligned = 0x6.U
  val Ecall = 0x8.U
}

class CSRIO(xlen: Int) extends Bundle {
  val stall = Input(Bool())
  val cmd = Input(UInt(3.W))
  val in = Input(UInt(xlen.W))
  val out = Output(UInt(xlen.W))
  // Excpetion
  val pc = Input(UInt(xlen.W))
  val addr = Input(UInt(xlen.W))
  val inst = Input(UInt(xlen.W))
  val illegal = Input(Bool())
  val st_type = Input(UInt(2.W))
  val ld_type = Input(UInt(3.W))
  val pc_check = Input(Bool())
  val expt = Output(Bool())
  val evec = Output(UInt(xlen.W))
  val epc = Output(UInt(xlen.W))
  // HTIF
  val host = new HostIO(xlen)
  // RDMA CSR (for debug)
  val rdma_print_addr = Output(UInt(xlen.W))
  val rdma_print_string_num = Output(UInt(xlen.W))
  val rdma_print_string_len = Output(UInt(xlen.W))
  val rdma_trap = Output(UInt(xlen.W))
  // interface between CSR & Hardware
  val pkg_type_to_cc    = Output(UInt(xlen.W))
  val user_table_size   = Output(UInt(xlen.W))
  val user_header_len   = Output(UInt(xlen.W))
  val has_event_wr	    = Input(Bool())   
  val has_event_rd	    = Output(Bool())  
  val event_recv_cnt	    = Output(UInt(xlen.W))
  val event_processed_cnt	= Output(UInt(xlen.W))
  val event_type	        = Output(UInt(xlen.W))
  val user_csr_wr	    = Input(Vec(16,UInt(xlen.W)))
	val user_csr_rd	    = Output(Vec(16,UInt(xlen.W)))
}

class CSR(val xlen: Int) extends Module {
  val io = IO(new CSRIO(xlen))

  val csr_addr = io.inst(31, 20)
  val rs1_addr = io.inst(19, 15)

  // user counters
  val time = RegInit(0.U(xlen.W))
  val timeh = RegInit(0.U(xlen.W))
  val cycle = RegInit(0.U(xlen.W))
  val cycleh = RegInit(0.U(xlen.W))
  val instret = RegInit(0.U(xlen.W))
  val instreth = RegInit(0.U(xlen.W))
  // RDMA CSR
  val rdma_print_addr = RegInit(0.U(xlen.W))
  val rdma_print_string_num = RegInit(0.U(xlen.W))
  val rdma_print_string_len = RegInit(0.U(xlen.W))
  val rdma_trap = RegInit(0.U(xlen.W))
  // RDMA Hardware
  val meta_csr = RegInit(VecInit(Seq.fill(16)(0.U(xlen.W))))
  val pkg_type_to_cc  = RegInit(0.U(xlen.W))
  val user_table_size = RegInit(0.U(xlen.W))
  val user_header_len = RegInit(0.U(xlen.W))
  val has_event = RegInit(false.B)
  val event_recv_cnt = RegInit(0.U(xlen.W))
  val event_processed_cnt = RegInit(0.U(xlen.W))
  val event_type = RegInit(0.U(xlen.W))
  val meta_offset = csr_addr(3, 0)

  io.rdma_print_addr := rdma_print_addr
  io.rdma_print_string_num := rdma_print_string_num
  io.rdma_print_string_len := rdma_print_string_len
  io.rdma_trap := rdma_trap

  io.has_event_rd := has_event
  io.event_recv_cnt := event_recv_cnt
  io.event_processed_cnt := event_processed_cnt
  io.event_type := event_type
  io.user_csr_rd := meta_csr
  io.user_header_len := user_header_len
  io.user_table_size := user_table_size
  io.pkg_type_to_cc  := pkg_type_to_cc



  val mcpuid = Cat(
    0.U(2.W) /* RV32I */,
    0.U((xlen - 28).W),
    (1 << ('I' - 'A') /* Base ISA */ |
      1 << ('U' - 'A') /* User Mode */ ).U(26.W)
  )
  val mimpid = 0.U(xlen.W) // not implemented
  val mhartid = 0.U(xlen.W) // only one hart

  // interrupt enable stack
  val PRV = RegInit(CSR.PRV_M)
  val PRV1 = RegInit(CSR.PRV_M)
  val PRV2 = 0.U(2.W)
  val PRV3 = 0.U(2.W)
  val IE = RegInit(false.B)
  val IE1 = RegInit(false.B)
  val IE2 = false.B
  val IE3 = false.B
  // virtualization management field
  val VM = 0.U(5.W)
  // memory privilege
  val MPRV = false.B
  // extention context status
  val XS = 0.U(2.W)
  val FS = 0.U(2.W)
  val SD = 0.U(1.W)
  val mstatus = Cat(SD, 0.U((xlen - 23).W), VM, MPRV, XS, FS, PRV3, IE3, PRV2, IE2, PRV1, IE1, PRV, IE)
  val mtvec = Const.PC_EVEC.U(xlen.W)
  val mtdeleg = 0x0.U(xlen.W)

  // interrupt registers
  val MTIP = RegInit(false.B)
  val HTIP = false.B
  val STIP = false.B
  val MTIE = RegInit(false.B)
  val HTIE = false.B
  val STIE = false.B
  val MSIP = RegInit(false.B)
  val HSIP = false.B
  val SSIP = false.B
  val MSIE = RegInit(false.B)
  val HSIE = false.B
  val SSIE = false.B
  val mip = Cat(0.U((xlen - 8).W), MTIP, HTIP, STIP, false.B, MSIP, HSIP, SSIP, false.B)
  val mie = Cat(0.U((xlen - 8).W), MTIE, HTIE, STIE, false.B, MSIE, HSIE, SSIE, false.B)

  val mtimecmp = Reg(UInt(xlen.W))

  val mscratch = Reg(UInt(xlen.W))

  val mepc = Reg(UInt(xlen.W))
  val mcause = Reg(UInt(xlen.W))
  val mbadaddr = Reg(UInt(xlen.W))

  val mtohost = RegInit(0.U(xlen.W))
  val mfromhost = Reg(UInt(xlen.W))
  io.host.tohost := mtohost
  when(io.host.fromhost.valid) {
    mfromhost := io.host.fromhost.bits
  }

  val csrFile = Seq(
    BitPat(CSR.cycle) -> cycle,
    BitPat(CSR.time) -> time,
    BitPat(CSR.instret) -> instret,
    BitPat(CSR.cycleh) -> cycleh,
    BitPat(CSR.timeh) -> timeh,
    BitPat(CSR.instreth) -> instreth,
    BitPat(CSR.cyclew) -> cycle,
    BitPat(CSR.timew) -> time,
    BitPat(CSR.instretw) -> instret,
    BitPat(CSR.cyclehw) -> cycleh,
    BitPat(CSR.timehw) -> timeh,
    BitPat(CSR.instrethw) -> instreth,
    BitPat(CSR.mcpuid) -> mcpuid,
    BitPat(CSR.mimpid) -> mimpid,
    BitPat(CSR.mhartid) -> mhartid,
    BitPat(CSR.mtvec) -> mtvec,
    BitPat(CSR.mtdeleg) -> mtdeleg,
    BitPat(CSR.mie) -> mie,
    BitPat(CSR.mtimecmp) -> mtimecmp,
    BitPat(CSR.mtime) -> time,
    BitPat(CSR.mtimeh) -> timeh,
    BitPat(CSR.mscratch) -> mscratch,
    BitPat(CSR.mepc) -> mepc,
    BitPat(CSR.mcause) -> mcause,
    BitPat(CSR.mbadaddr) -> mbadaddr,
    BitPat(CSR.mip) -> mip,
    BitPat(CSR.mtohost) -> mtohost,
    BitPat(CSR.mfromhost) -> mfromhost,
    BitPat(CSR.mstatus) -> mstatus,
    // RDMA CSR
    BitPat(CSR.rdma_print_addr) -> rdma_print_addr,
    BitPat(CSR.rdma_print_string_num) -> rdma_print_string_num,
    BitPat(CSR.rdma_print_string_len) -> rdma_print_string_len,
    BitPat(CSR.rdma_trap) -> rdma_trap,
    // RDMA Hardware
    BitPat(CSR.pkg_type_to_cc) -> pkg_type_to_cc,
    BitPat(CSR.user_table_size) -> user_table_size,
    BitPat(CSR.user_header_len) -> user_header_len,
    BitPat(CSR.has_event) -> has_event,
    BitPat(CSR.event_recv_cnt) -> event_recv_cnt,
    BitPat(CSR.event_processed_cnt) -> event_processed_cnt,
    BitPat(CSR.event_type) -> event_type,
    // 0x050-0x6F
    BitPat("b00000101????") -> meta_csr(Cat(0.U(1.W), meta_offset))
    // BitPat("b00000110????") -> meta_csr(Cat(1.U(1.W), meta_offset))
  )

  io.out := Lookup(csr_addr, 0.U, csrFile).asUInt

  val privValid = csr_addr(9, 8) <= PRV
  val privInst = io.cmd === CSR.P
  val isEcall = privInst && !csr_addr(0) && !csr_addr(8)
  val isEbreak = privInst && csr_addr(0) && !csr_addr(8)
  val isEret = privInst && !csr_addr(0) && csr_addr(8)
  val csrValid = csrFile.map(_._1 === csr_addr).reduce(_ || _)
  val csrRO = csr_addr(11, 10).andR || csr_addr === CSR.mtvec || csr_addr === CSR.mtdeleg
  val wen = io.cmd === CSR.W || io.cmd(1) && rs1_addr.orR
  val wdata = MuxLookup(
    io.cmd,
    0.U,
    Seq(
      CSR.W -> io.in,
      CSR.S -> (io.out | io.in),
      CSR.C -> (io.out & ~io.in)
    )
  )
  val iaddrInvalid = io.pc_check && io.addr(1)
  val laddrInvalid = MuxLookup(
    io.ld_type,
    false.B,
    Seq(Control.LD_LW -> io.addr(1, 0).orR, Control.LD_LH -> io.addr(0), Control.LD_LHU -> io.addr(0))
  )
  val saddrInvalid =
    MuxLookup(io.st_type, false.B, Seq(Control.ST_SW -> io.addr(1, 0).orR, Control.ST_SH -> io.addr(0)))
  io.expt := io.illegal || iaddrInvalid || laddrInvalid || saddrInvalid ||
    io.cmd(1, 0).orR && (!csrValid || !privValid) || wen && csrRO ||
    (privInst && !privValid) || isEcall || isEbreak
  io.evec := mtvec + (PRV << 6)
  // io.evec := mtvec
  io.epc := mepc

  // Counters
  time := time + 1.U
  when(time.andR) { timeh := timeh + 1.U }
  cycle := cycle + 1.U
  when(cycle.andR) { cycleh := cycleh + 1.U }
  val isInstRet = io.inst =/= Instructions.NOP && (!io.expt || isEcall || isEbreak) && !io.stall
  when(isInstRet) { instret := instret + 1.U }
  when(isInstRet && instret.andR) { instreth := instreth + 1.U }

  when(!io.stall) {
    when(io.expt) {
      mepc := io.pc >> 2 << 2
      mcause := Mux(
        iaddrInvalid,
        Cause.InstAddrMisaligned,
        Mux(
          laddrInvalid,
          Cause.LoadAddrMisaligned,
          Mux(
            saddrInvalid,
            Cause.StoreAddrMisaligned,
            Mux(isEcall, Cause.Ecall + PRV, Mux(isEbreak, Cause.Breakpoint, Cause.IllegalInst))
          )
        )
      )
      PRV := CSR.PRV_M
      IE := false.B
      PRV1 := PRV
      IE1 := IE
      when(iaddrInvalid || laddrInvalid || saddrInvalid) { mbadaddr := io.addr }
    }.elsewhen(isEret) {
      PRV := PRV1
      IE := IE1
      PRV1 := CSR.PRV_U
      IE1 := true.B
    }.elsewhen(wen) {
      when(csr_addr === CSR.mstatus) {
        PRV1 := wdata(5, 4)
        IE1 := wdata(3)
        PRV := wdata(2, 1)
        IE := wdata(0)
      }
        .elsewhen(csr_addr === CSR.mip) {
          MTIP := wdata(7)
          MSIP := wdata(3)
        }
        .elsewhen(csr_addr === CSR.mie) {
          MTIE := wdata(7)
          MSIE := wdata(3)
        }
        .elsewhen(csr_addr === CSR.mtime) { time := wdata }
        .elsewhen(csr_addr === CSR.mtimeh) { timeh := wdata }
        .elsewhen(csr_addr === CSR.mtimecmp) { mtimecmp := wdata }
        .elsewhen(csr_addr === CSR.mscratch) { mscratch := wdata }
        .elsewhen(csr_addr === CSR.mepc) { mepc := wdata >> 2.U << 2.U }
        .elsewhen(csr_addr === CSR.mcause) { mcause := wdata & (BigInt(1) << (xlen - 1) | 0xf).U }
        .elsewhen(csr_addr === CSR.mbadaddr) { mbadaddr := wdata }
        .elsewhen(csr_addr === CSR.mtohost) { mtohost := wdata }
        .elsewhen(csr_addr === CSR.mfromhost) { mfromhost := wdata }
        .elsewhen(csr_addr === CSR.cyclew) { cycle := wdata }
        .elsewhen(csr_addr === CSR.timew) { time := wdata }
        .elsewhen(csr_addr === CSR.instretw) { instret := wdata }
        .elsewhen(csr_addr === CSR.cyclehw) { cycleh := wdata }
        .elsewhen(csr_addr === CSR.timehw) { timeh := wdata }
        .elsewhen(csr_addr === CSR.instrethw) { instreth := wdata }
        .elsewhen(csr_addr === CSR.rdma_print_addr) { rdma_print_addr := wdata }
        .elsewhen(csr_addr === CSR.rdma_print_string_num) { rdma_print_string_num := wdata }
        .elsewhen(csr_addr === CSR.rdma_print_string_len) { rdma_print_string_len := wdata }
        .elsewhen(csr_addr === CSR.rdma_trap) { rdma_trap := wdata }
        .elsewhen(csr_addr === CSR.pkg_type_to_cc) { pkg_type_to_cc := wdata }
        .elsewhen(csr_addr === CSR.user_header_len) { user_header_len := wdata }
        .elsewhen(csr_addr === CSR.user_table_size) { user_table_size := wdata }
        .elsewhen(csr_addr === CSR.has_event) { has_event := wdata }
        .elsewhen(csr_addr === CSR.event_recv_cnt) { event_recv_cnt := wdata }
        .elsewhen(csr_addr === CSR.event_processed_cnt) { event_processed_cnt := wdata }
        .elsewhen(csr_addr === CSR.event_type) { event_type := wdata }
        .elsewhen(csr_addr === BitPat("b00000101????")) { meta_csr(Cat(0.U(1.W), meta_offset)) := wdata }
        // .elsewhen(csr_addr === BitPat("b00000110????")) { meta_csr(Cat(1.U(1.W), meta_offset)) := wdata }
    }
  }
  
  // 判断是否和 Core 这边冲突
  when(io.has_event_wr) {
    has_event := true.B
    event_recv_cnt := event_recv_cnt + 1.U
    event_processed_cnt := 0.U
    meta_csr := io.user_csr_wr
  }


  // class ila_csr(seq:Seq[Data]) extends BaseILA(seq)
  //   val inst_ila_csr = Module(new ila_csr(Seq(				
  //     io.stall,
  //     io.cmd,
  //     io.in,
  //     io.out,
  //     io.pc,
  //     io.addr,
  //     io.inst,
  //     io.illegal,
  //     io.st_type,
  //     io.ld_type,
  //     io.pc_check,
  //     io.expt,
  //     io.evec,
  //     io.epc,
  //     mepc,
  //     mcause,
  //     mstatus,

  //     rdma_print_addr,
  //     rdma_print_string_num,
  //     rdma_print_string_len,
  //     rdma_trap,
  //   )))
  //   inst_ila_csr.connect(clock)
}
