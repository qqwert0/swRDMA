package network
import chisel3._
import chisel3.util._
import chisel3.stage.{ChiselGeneratorAnnotation, ChiselStage}
import firrtl.options.TargetDirAnnotation
import qdma._
import network.roce._
import network._
import network.ip._

object elaborate extends App {
	println("Generating a %s class".format(args(0)))
	val stage	= new chisel3.stage.ChiselStage
	val arr		= Array("-X", "sverilog", "--full-stacktrace")
	val dir 	= TargetDirAnnotation("Verilog")

	args(0) match{
		case "IP_LOOP" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new IP_LOOP()),dir))
		case "NetworkStackTop" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new NetworkStackTop()),dir))
		// case "FC_TABLE" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new FC_TABLE()),dir))
		case _ => println("Module match failed!")
	}
}


