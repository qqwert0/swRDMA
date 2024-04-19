package ddr

import chisel3._
import chisel3.util._
import javax.swing.InputMap
import common._
import common.storage._
import common.axi._
import common.ToZero
import chisel3.experimental._
// import chisel3.experimental.{DataMirror, requireIsChiselType,Analog}
// import chisel3.experimental.{withClock, withReset, withClockAndReset}

class DDRTOP extends RawModule {
    /////////ddr0 input clock
    val ddr0_sys_100M_p=IO(Input(Clock()))   
    val ddr0_sys_100M_n=IO(Input(Clock()))                    
    val ddr_pin     = IO(new DDRPin())
    ///////////ddr0 PHY interface  
    // val clkp=BUFG(ddr0_sys_100M_p)
    // val clkn=BUFG(ddr0_sys_100M_n)
    val sysClk =  IBUFDS(ddr0_sys_100M_p,ddr0_sys_100M_n)
    val myclk=BUFG(sysClk)
    val ilaclock=BUFG(myclk)
    val DDR0 = Module(new DDR_DRIVER(ENABLE_AXI_CTRL		=false))
    DDR0.getTCL();
    //val testFSM = withClockAndReset(sysClk, false.B){Module(new(ddrFSM))}
    val rst=Wire(UInt(1.W))
    val clk=Wire(Clock())

    /*			DDR0 INTERFACE		*/
    val axi         = Wire(Flipped(new AXI(34,512,4,0,8)) )
    axi.init();
    //val axi_ctrl    = Wire(Flipped(new AXI(32,32,0,0,0)))
    //axi_ctrl.init();
    /// axi init
    ToZero(axi.aw.bits)
    ToZero(axi.w.bits)
    ToZero(axi.ar.bits)
    ToZero(axi.r.bits)
    ToZero(axi.b.bits)
    ////  axi_ctrl init
    // ToZero(axi_ctrl.aw.bits)
    // ToZero(axi_ctrl.w.bits)
    // ToZero(axi_ctrl.ar.bits)
    // ToZero(axi_ctrl.r.bits)
    // ToZero(axi_ctrl.b.bits)
    // axi_ctrl.aw.valid       :=0.U
    // axi_ctrl.w.valid             :=0.U
    // axi_ctrl.b.ready             :=1.U
    // axi_ctrl.ar.valid            :=0.U
    // axi_ctrl.r.ready             :=1.U

    /////   ILA


    ///
    // DDR0.io.ddr0_sys_100M_p           :=ddr0_sys_100M_p
    // DDR0.io.ddr0_sys_100M_n            :=ddr0_sys_100M_n
    //DDR0.io.ddriver_clk:=myclk
    DDR0.io.ddrpin<>ddr_pin
    clk:=DDR0.io.user_clk
    rst:=DDR0.io.user_rst
    axi<>DDR0.io.axi
    //axi_ctrl<>DDR0.io.axi_ctrl

///////////// write&read test  
//   withClockAndReset(myclk, false.B)
//   {
//     val write0 :: write1 :: write2 :: write3 ::read0 :: read1 :: read2:: Nil = Enum(7)
//     val state=RegInit(write0)
//     var read_waite=RegInit(0.U(32.W))
//     var write_waite=RegInit(0.U(32.W))
//     var clock_count=RegInit(0.U(32.W))
//     var cycle_count=RegInit(0.U(32.W))
//     switch(state){
//         is(write0){
//             axi.aw.valid:=0.U
//             axi.w.valid:=0.U
//             axi.b.ready:=1.U
//             axi.ar.valid:=0.U
//             clock_count:=clock_count+1.U
//             state:=write1
//         }
//         is(write1){
//             axi.aw.valid:=1.U
//             axi.aw.bits.addr:=(512.U)*cycle_count
//             axi.aw.bits.len:=3.U
//             axi.aw.bits.size:=6.U 
//             axi.aw.bits.burst:=1.U
//             axi.aw.bits.id:=cycle_count
//             axi.w.valid:=1.U
//             axi.w.bits.data:=0x00001234.U
//             axi.w.bits.strb:="hffffffffffffffff".U
//             axi.w.bits.last:=0.U
//             clock_count:=clock_count+1.U
//             write_waite:=3.U
//             when(axi.aw.ready&&axi.w.ready){
//                 state:=write2
//             }
//             .otherwise{
//                 state:=write1
//             }
//         }
//         is(write2){
//             axi.aw.valid:=1.U
//             axi.aw.bits.addr:=(512.U)*cycle_count
//             axi.aw.bits.len:=3.U
//             axi.aw.bits.size:=6.U 
//             axi.aw.bits.burst:=1.U
//             axi.aw.bits.id:=cycle_count
//             axi.w.valid:=1.U
//             axi.w.bits.data:=0x00001234.U
//             axi.w.bits.strb:="hffffffffffffffff".U
//             when(axi.w.ready){
//                 write_waite:=write_waite-1.U
//             }
//             clock_count:=clock_count+1.U
//             when(!write_waite){
                
//                 axi.w.bits.last:=1.U
//                 state:=write3
//             }
//             .otherwise{
//                 axi.w.bits.last:=0.U
//                 state:=write2
//             }
//         }
//         is(write3){
//             axi.aw.valid:=0.U
//             axi.w.valid:=0.U
//             //write_waite:=0.U
//             read_waite:=10.U
//             axi.w.bits.last:=0.U
//             state:=read0
            
//         }
//         is(read0){
//             axi.ar.valid:=0.U
//             axi.r.ready:=1.U
//             read_waite:=read_waite-1.U
//             when(!read_waite){
//                 state:=read1
//             }
//         }
//         is(read1){
//           clock_count:=clock_count+1.U
//           read_waite:=0.U
//           axi.ar.bits.addr:=cycle_count
//           axi.ar.bits.len:=3.U
//           axi.ar.bits.size:=6.U
//           axi.ar.bits.burst:=1.U
//           axi.ar.bits.id:=clock_count
//           axi.r.ready:=1.U
//           axi.ar.valid:=1.U
//           when(axi.ar.ready){
//                 state:=read2
//             } 
//             .otherwise{
//                 state:=read1
//             }
//         }
//         is(read2){
//             clock_count:=clock_count+1.U
//             axi.ar.valid:=1.U
//             axi.r.ready:=1.U
//             axi.ar.bits.addr:=cycle_count
//             axi.ar.bits.len:=3.U
//             axi.ar.bits.size:=6.U
//             axi.ar.bits.burst:=1.U
//             axi.ar.bits.id:=clock_count
//             when(!axi.r.valid){
//                 cycle_count:=cycle_count+1.U

//                 state:=write0
//             } 
//             .otherwise{
//                 state:=read2
//             }
//         }
//     }
//   }
///////////////////////
    // var enable=Wire(Bool())
    // //var start_addr=Wire(0.U(34.W))
    // var datasize=Wire(UInt(8.W))
    // // var reg1=withClockAndReset(myclk, false.B){RegInit(0.U(512.W))}
    // // var reg2=withClockAndReset(myclk, false.B){RegInit(0.U(512.W))}
    // // var write_start=Wire(0.U(1.W))
    // // var write_end=Wire(0.U(1.W))
    // withClockAndReset(clk,false.B)
    // {
    //     val write0 :: write1 :: write2 :: write3 ::read0 :: read1 :: read2:: Nil = Enum(7)
    //     val state=RegInit(write0)
    //     var read_waite=RegInit(0.U(32.W))
    //     var write_waite=RegInit(0.U(32.W))
    //     var awaddr_count=RegInit(0.U(32.W))
    //     var cycle_count=RegInit(0.U(32.W))
    //     switch(state){
    //         is(write0){
                
    //         axi.aw.valid:=0.U
    //         axi.w.valid:=0.U
    //         axi.b.ready:=1.U
    //         axi.ar.valid:=0.U
            
    //         when(enable)
    //         {
    //            // write_start:=1.U
    //             state:=write1
    //         }
    //         .otherwise{
    //             state:=write0
    //         }
            
    //     }
    //     is(write1){
    //         axi.aw.valid:=1.U
    //         axi.aw.bits.addr:=(512.U)*cycle_count
    //         awaddr_count:=0.U
    //         axi.aw.bits.len:=datasize
    //         axi.aw.bits.size:=6.U 
    //         axi.aw.bits.burst:=1.U
    //         axi.aw.bits.id:=cycle_count
    //         axi.w.valid:=1.U
    //         axi.w.bits.data:=0x00001234.U
    //         axi.w.bits.strb:="hffffffffffffffff".U
    //         axi.w.bits.last:=0.U
            
    //         write_waite:=datasize
    //         when(axi.aw.ready&&axi.w.ready){
    //             state:=write2
    //         }
    //         .otherwise{
    //             state:=write1
    //         }
    //     }
    //     is(write2){
    //         axi.aw.valid:=1.U
    //         awaddr_count:=awaddr_count+1.U
    //         axi.aw.bits.addr:=(512.U)*cycle_count+(64.U)*awaddr_count
    //         axi.aw.bits.len:=datasize
    //         axi.aw.bits.size:=6.U 
    //         axi.aw.bits.burst:=1.U
    //         axi.aw.bits.id:=cycle_count
    //         axi.w.valid:=1.U
    //         axi.w.bits.data:=0x00001234.U
    //         axi.w.bits.strb:="hffffffffffffffff".U
    //         when(axi.w.ready){
    //             write_waite:=write_waite-1.U
    //         }
    //         when(!write_waite){
                
    //             axi.w.bits.last:=1.U
    //             state:=write3
    //         }
    //         .otherwise{
    //             axi.w.bits.last:=0.U
    //             state:=write2
    //         }
    //     }
    //     is(write3){
    //         axi.aw.valid:=0.U
    //         axi.w.valid:=0.U
    //         //write_waite:=0.U
    //         read_waite:=10.U
    //         axi.w.bits.last:=0.U
    //         //write_end:=1.U
    //         //state:=read0
    //         //enable:=0.U
    //     }
    //     }
    
    // }

    // class vio_nx(seq:Seq[Data]) extends BaseVIO(seq)	  
  	// val nx = Module(new vio_nx(Seq(	
	// 	enable,datasize
  	// )))
  	// nx.connect(clk)

    
    // class ila_tx(seq:Seq[Data]) extends BaseILA(seq)	  
  	// val tx = Module(new ila_tx(Seq(	
	// 	axi
  	// )))
  	// tx.connect(clk)
} 