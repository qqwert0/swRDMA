package static
import chisel3._
import chisel3.util._
import chisel3.stage.{ChiselGeneratorAnnotation, ChiselStage, ChiselOutputFileAnnotation}
import firrtl.options.{TargetDirAnnotation, OutputAnnotationFileAnnotation}
import firrtl.stage.OutputFileAnnotation

object elaborate extends App {
	println("Generating a %s class".format(args(0)))
	val stage	= new chisel3.stage.ChiselStage
	val arr		= Array("-X", "sverilog", "--full-stacktrace")
	val dir 	= TargetDirAnnotation("Verilog")

	args(0) match{
		case "StaticU50Top" => {
			import u50.StaticU50Top
			stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new StaticU50Top()),dir))
		}
		case "U50DynamicGreyBox" => {
			import u50.U50DynamicGreyBox
			stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new U50DynamicGreyBox()),dir, OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
		}
		case "StaticU280Top" => {
			import u280.StaticU280Top
			stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new StaticU280Top()),dir))
		}
		case "U280DynamicGreyBox" => {
			import u280.U280DynamicGreyBox
			stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new U280DynamicGreyBox()),dir, OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
		}
		case _ => println("Module match failed!")
	}
}