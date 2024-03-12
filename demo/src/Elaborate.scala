package demo
import chisel3._
import chisel3.util._
import common.storage._
import chisel3.stage.{ChiselGeneratorAnnotation, ChiselStage}
import firrtl.options.TargetDirAnnotation

object elaborate extends App {
	println("Generating a %s class".format(args(0)))
	val stage	= new chisel3.stage.ChiselStage
	val arr		= Array("-X", "sverilog", "--full-stacktrace")
	val dir 	= TargetDirAnnotation("Verilog")

	args(0) match{
		case "Foo" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new Foo()),dir))
		case "vector_add" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new vector_add()),dir))
		case "demo_top" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new demo_top()),dir))
		case _ => println("Module match failed!")
	}
}