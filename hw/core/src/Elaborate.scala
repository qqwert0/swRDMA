package mini

import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.stage.ChiselStage
import firrtl.options.TargetDirAnnotation
import mini.foo._
import mini.core._
import mini.junctions._

object elaborate extends App {
  val targetDirectory = "Verilog"
  val dir 	= TargetDirAnnotation("Verilog")
  val config = MiniConfig()
  args(0) match{
    case "test_csr" => (new ChiselStage()).emitSystemVerilog(new test_csr(), Array("--target-dir", "Verilog", "--full-stacktrace", "--output-annotation-file", "Foo.sv"))
		case "AlveoDynamicTop" => (new ChiselStage()).emitSystemVerilog(new Foo(), Array("--target-dir", "Verilog", "--full-stacktrace", "--output-annotation-file", "Foo.sv"))
		case "mini" => (new ChiselStage()).emitSystemVerilog(
        new Tile(
          enable_hbm = config.enable_hbm,
          coreParams = config.core,
          bramParams = config.bram,
          nastiParams = config.nasti,
          cacheParams = config.cache
        ),
        Array("--target-dir", "Verilog", "--full-stacktrace"),
      )
    case "test_core" => (new ChiselStage()).emitSystemVerilog(new TestCore(), Array("--target-dir", "Verilog", "--full-stacktrace"))
    case _ => println("Invalid argument")
  }
}
