package qdma
import chisel3._
import chisel3.util._
import common.storage._
import qdma.examples._
import chisel3.stage.{ChiselGeneratorAnnotation, ChiselStage, ChiselOutputFileAnnotation}
import firrtl.options.{TargetDirAnnotation, OutputAnnotationFileAnnotation}
import firrtl.stage.OutputFileAnnotation
import firrtl.options.TargetDirAnnotation

object elaborate extends App {
	println("Generating a %s class".format(args(0)))
	val stage	= new chisel3.stage.ChiselStage
	val arr		= Array("-X", "sverilog", "--full-stacktrace")
	val dir 	= TargetDirAnnotation("Verilog")

	class TestXQueue extends Module(){
		val io = IO(new Bundle{
			val in = Flipped(Decoupled(UInt(32.W)))
			val out = (Decoupled(UInt(32.W)))
		})
		val q = XQueue(UInt(32.W),64)
		q.io.in		<> io.in
		q.io.out	<> io.out
	}
	class TestXConverter extends Module(){
		val io = IO(new Bundle{
			val out_clk = Input(Clock())
			val req = Flipped(Decoupled(UInt(32.W)))
			val res = Decoupled(UInt(32.W))
		})
		val converter = XConverter(UInt(32.W),clock,true.B,io.out_clk)
		converter.io.in <> io.req
		converter.io.out <> io.res
	}
	args(0) match{
		case "QDMATop" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new QDMATop()),dir))
		case "TLB" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new TLB()),dir))
		case "DataBoundarySplit" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new DataBoundarySplit()),dir))
		case "TestXQueue" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new TestXQueue()),dir))
		case "TestXConverter" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new TestXConverter()),dir))
		case "AXILBenchmarkTop" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new AXILBenchmarkTop()),dir))
		case "H2CRandom" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new H2CRandom()),dir))
		case "C2HRandom" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new C2HRandom()),dir))
		case "QDMARandomTop" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new QDMARandomTop()),dir))
		case "H2CLatency" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new H2CLatency()),dir))
		case "C2HLatency" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new C2HLatency()),dir))
		case "QDMALatencyTop" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new QDMALatencyTop()),dir))
		case "QDMAThroughputCPUTop" => stage.execute(arr, Seq(ChiselGeneratorAnnotation(() => new QDMAThroughputCPUTop()), dir, OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
		case "QDMAThroughputGPUTop" => stage.execute(arr, Seq(ChiselGeneratorAnnotation(() => new QDMAThroughputGPUTop()), dir, OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
		case "QDMARandomCPUTop" => stage.execute(arr, Seq(ChiselGeneratorAnnotation(() => new QDMARandomCPUTop()), dir, OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
		case "QDMALatencyCPUTop" => stage.execute(arr, Seq(ChiselGeneratorAnnotation(() => new QDMALatencyCPUTop()), dir, OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
		case "QDMAAXILBenchmarkTop" => stage.execute(arr, Seq(ChiselGeneratorAnnotation(() => new QDMAAXILBenchmarkTop()), dir, OutputFileAnnotation(args(0)), OutputAnnotationFileAnnotation(args(0)), ChiselOutputFileAnnotation(args(0))))
		case _ => println("Module match failed!")
	}
}