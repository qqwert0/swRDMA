package swrdma

import chisel3.stage.{ChiselGeneratorAnnotation, ChiselStage, ChiselOutputFileAnnotation}
import firrtl.options.{TargetDirAnnotation, OutputAnnotationFileAnnotation}
import firrtl.stage.OutputFileAnnotation
import mini.foo._
import mini.core._
import mini.junctions._

object elaborate extends App {
  // val targetDirectory = "Verilog"
	println("Generating a %s class".format(args(0)))
	val stage	= new chisel3.stage.ChiselStage
	val arr		= Array("-X", "sverilog", "--full-stacktrace")
	val dir 	= TargetDirAnnotation("Verilog")
  val config = MiniConfig()
  args(0) match{
    case "test_csr" => (new ChiselStage()).emitSystemVerilog(
        new test_csr(),
        Array("--target-dir", "Verilog", "--full-stacktrace", "--output-annotation-file", "Foo.sv")
      )
		case "PRDMA_LOOP" => (new ChiselStage()).emitSystemVerilog(
        new PRDMA_LOOP(),
        Array("--target-dir", "Verilog", "--full-stacktrace", "--output-annotation-file", "Foo.sv")
      )
    case "prdma_top" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new prdma_top()),dir,OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
		case "U280DynamicGreyBox" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new U280DynamicGreyBox()),dir,OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
    case "swrdma_top" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new swrdma_top()),dir,OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
    case "swrdma10_top" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new swrdma10_top()),dir,OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
    // case "prdma_top" => (new ChiselStage()).emitSystemVerilog(
    //     new prdma_top(),
    //     Array("--target-dir", "Verilog", "--full-stacktrace", "--output-annotation-file", "Foo.sv")
    //   )
		case "sender_reconfigable2" => (new ChiselStage()).emitSystemVerilog(
        new sender_reconfigable2(),
        Array("--target-dir", "Verilog", "--full-stacktrace", "--output-annotation-file", "Foo.sv")
      )

		case "mini" => (new ChiselStage()).emitSystemVerilog(
        new Tile(
          coreParams = config.core,
          bramParams = config.bram,
          nastiParams = config.nasti,
          cacheParams = config.cache
        ),
        Array("--target-dir", "Verilog", "--full-stacktrace"),
      )
  }
}