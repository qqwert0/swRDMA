package network.roce

import chisel3.stage.{ChiselGeneratorAnnotation, ChiselStage}
import firrtl.options.TargetDirAnnotation
import chisel3._
import chisel3.util._


object elaborate extends App {
	println("Generating a %s class".format(args(0)))

	val stage	= new chisel3.stage.ChiselStage
	val arr		= Array("-X", "sverilog", "--full-stacktrace")
	val dir 	= TargetDirAnnotation("Verilog")

	args(0) match{
		// case "PKG_ROUTER" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new PKG_ROUTER()),dir))
		// case "MEM_CMD_MERGER" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new MEM_CMD_MERGER()),dir))
		// case "LSHIFT" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new LSHIFT(7,512)),dir))
		// case "RSHIFT" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new RSHIFT(7,512)),dir))
		// case "APPEND_PAYLOAD" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new APPEND_PAYLOAD()),dir))
		// case "LOCAL_CMD_HANDLER" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new LOCAL_CMD_HANDLER()),dir))
		// case "HANDLE_READ_REQ" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new HANDLE_READ_REQ()),dir))
		// case "RX_EXH_PROCESS" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new RX_EXH_PROCESS()),dir))
		// case "RX_EXH_ROUTER" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new RX_EXH_ROUTER()),dir))
		// case "MULTI_Q" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new MULTI_Q(UInt(32.W),512,2048)),dir))
		// case "MSN_TABLE" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new MSN_TABLE()),dir))
		// case "RX_EXH_FSM" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new RX_EXH_FSM()),dir))
		// case "ROCE_EXH" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new ROCE_EXH()),dir))
		// case "EXH_LOOP" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new EXH_LOOP()),dir))
		// case "TX_ADD_IBH" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new TX_ADD_IBH()),dir))
		// case "RX_IBH_PROCESS" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new RX_IBH_PROCESS()),dir))
		// case "TX_IBH_FSM" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new TX_IBH_FSM()),dir))
		// case "IP_LOOP" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new IP_LOOP()),dir))
		// case "IP_SWITCH" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new IP_SWITCH()),dir))
		// case "LEADING_ZERO_COUNTER" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new LEADING_ZERO_COUNTER(64)),dir))
        case "ROCE_IP" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new ROCE_IP()),dir))
		case "TB_ROCE" => stage.execute(arr,Seq(ChiselGeneratorAnnotation(() => new TB_ROCE()),dir))
		case _ => println("Module match failed!")
		
	}
	
}