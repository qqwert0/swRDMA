package hbm
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
		case "HBM_DRIVER" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new HBM_DRIVER()),dir))
		case "RAMA" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new RAMA()),dir))
		case "HBMTop" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new HBMTop()),dir))
		case _ => println("Module match failed!")
	}
}