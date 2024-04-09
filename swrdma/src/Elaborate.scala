package swrdma
import chisel3._
import chisel3.util._
import common.storage._
import chisel3.stage.{ChiselGeneratorAnnotation, ChiselStage, ChiselOutputFileAnnotation}
import firrtl.options.{TargetDirAnnotation, OutputAnnotationFileAnnotation}
import firrtl.stage.OutputFileAnnotation

object elaborate extends App {
	println("Generating a %s class".format(args(0)))
	val stage	= new chisel3.stage.ChiselStage
	val arr		= Array("-X", "sverilog", "--full-stacktrace")
	val dir 	= TargetDirAnnotation("Verilog")

	args(0) match{
		//case "PkgGen" => stage.execute(arr, Seq(ChiselGeneratorAnnotation(() => new PkgGen()), dir, OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
		case "Foo" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new Foo()),dir))
		case "PkgGen" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new PkgGen()),dir))
		case "PkgDelay" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new PkgDelay()),dir))
		case "PkgProc" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new PkgProc()),dir))
		case "PRDMA" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new PRDMA()),dir))
		case "RxDispatch" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new RxDispatch()),dir))
		case "microbenchmark_recv" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new microbenchmark_recv()),dir))
		case "microbenchmark_sender" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new microbenchmark_sender()),dir))
		case "sender_reconfigable" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new sender_reconfigable()),dir, OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
		case _ => println("Module match failed!")
	}
}