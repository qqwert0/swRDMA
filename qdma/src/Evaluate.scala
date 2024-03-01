package qdma

import chisel3._
import chisel3.util._
import chisel3.experimental.{DataMirror, requireIsChiselType}
import common.axi._
import common.storage._


class C2HEvaluator extends Module{
	val io = IO(new Bundle{
        val cmd_in_valid    = Input(Bool())
        val cmd_in_ready    = Input(Bool())
        val cmd_in          = Input(new C2H_CMD)
        val data_in_valid   = Input(Bool())
        val data_in_ready   = Input(Bool())
        val data_in         = Input(new C2H_DATA)        
		val status_out      = Output(Vec(37,UInt(32.W)))
	})


	def record_signals(is_high:Bool)={
		val count = RegInit(UInt(32.W),0.U)
		when(is_high){
			count	:= count+1.U
		}
		count
	}


	val data_fifo = XQueue(new C2H_DATA(),512)
    val cmd_fifo  = XQueue(new C2H_CMD(),512)

    cmd_fifo.io.in.valid    := RegNext(io.cmd_in_valid & io.cmd_in_ready)
    cmd_fifo.io.in.bits     := RegNext(io.cmd_in)
    data_fifo.io.in.valid   := RegNext(io.data_in_valid & io.data_in_ready)
    data_fifo.io.in.bits    := RegNext(io.data_in)


    val cmd_addr            = RegInit(0.U(4.W))
    val vaddr_reg           = Reg(Vec(32,UInt(32.W)))

    cmd_fifo.io.out.ready   := 1.U
    data_fifo.io.out.ready   := 1.U
    when(cmd_fifo.io.out.ready & cmd_fifo.io.out.valid){
        cmd_addr                := cmd_addr + 1.U
        vaddr_reg(cmd_addr*2.U)   := cmd_fifo.io.out.bits.addr(31,0)
        vaddr_reg(cmd_addr*2.U+1.U) := cmd_fifo.io.out.bits.addr(63,32)
    }


	val sIDLE :: sREAD_DATA :: Nil 	= Enum(2)
	val state                   	= RegInit(sIDLE)

    val length              = RegInit(0.U(32.W))
    val length_tmp          = RegInit(0.U(32.W))

    val len_zero_err        = RegInit(false.B)
    val align_err           = RegInit(false.B)
    val last_err            = RegInit(false.B)
    val last_err_cnt        = RegInit(0.U(32.W))
    val data_cnt            = RegInit(0.U(32.W))

    data_cnt                := record_signals(data_fifo.io.out.fire())

	switch(state){
		is(sIDLE){
			when(data_fifo.io.out.fire()){
                length                  := data_fifo.io.out.bits.ctrl_len 
                
                
                when(data_fifo.io.out.bits.ctrl_len === 0.U){
                    len_zero_err        := true.B
                }.otherwise{
                    len_zero_err        := len_zero_err
                }                
                
                when(data_fifo.io.out.bits.ctrl_len(5,0) =/= 0.U){
                    align_err           := true.B
                }.otherwise{
                    align_err           := align_err
                }

                when(data_fifo.io.out.bits.ctrl_len === 64.U){
                    when(data_fifo.io.out.bits.last === false.B){
                        last_err        := true.B
                        last_err_cnt    := data_cnt
                    }.otherwise{
                        last_err        := last_err
                        last_err_cnt    := last_err_cnt
                    }
                    length_tmp          := 0.U
                    state               := sIDLE
                }.otherwise{
                    length_tmp          := length_tmp + 64.U
                    state               := sREAD_DATA
                }
			}
		}
		is(sREAD_DATA){
			when(data_fifo.io.out.fire()){
                length_tmp              := length_tmp + 64.U
                when((length_tmp + 64.U) === length){
                    length_tmp          := 0.U
                    when(data_fifo.io.out.bits.last === false.B){
                        last_err        := true.B
                        last_err_cnt    := data_cnt
                    }.otherwise{
                        last_err        := last_err
                        last_err_cnt    := last_err_cnt
                    }
                    state               := sIDLE                    
                }.otherwise{
                    when(data_fifo.io.out.bits.last === true.B){
                        last_err        := true.B
                        last_err_cnt    := data_cnt
                    }.otherwise{
                        last_err        := last_err
                        last_err_cnt    := last_err_cnt
                    }
                    state               := sREAD_DATA                     
                }
			}
		}
	}


    for(i <- 0 until 32){
        io.status_out(i)                     := vaddr_reg(i)
    }

    io.status_out(32)                      := len_zero_err.asUInt
    io.status_out(33)                      := align_err.asUInt
    io.status_out(34)                      := last_err.asUInt
    io.status_out(35)                      := last_err_cnt
    io.status_out(36)                      := data_cnt


}