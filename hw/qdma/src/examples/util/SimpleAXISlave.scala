package qdma.examples
import chisel3._
import chisel3.util._
import chisel3.experimental.{DataMirror, requireIsChiselType}
import common._
import common.storage._
import common.ToZero
import common.axi.AXI

class SimpleAXISlave[T<:AXI](private val gen:T)extends Module{
	val genType = if (compileOptions.declaredTypeMustBeUnbound) {
		requireIsChiselType(gen)
		gen
	} else {
		if (DataMirror.internal.isSynthesizable(gen)) {
			chiselTypeOf(gen)
		}else {
			gen
		}
	}
	val io = IO(new Bundle{
		val axi = Flipped(genType)
	})

	//b
	ToZero(io.axi.b.bits)
	io.axi.b.valid := 1.U

	//w and aw
	val w = io.axi.w
	val aw = io.axi.aw

	aw.ready := 1.U
	w.ready	 := 1.U

	//r and ar
	val r = io.axi.r
	val ar = io.axi.ar
	ToZero(r.bits)
	r.bits.last	:= 1.U

	val cur_data = RegInit(0.U(32.W))
	when(r.fire){
		cur_data := cur_data + 1.U
	}

	ar.ready := 1.U

	r.valid		:= 1.U
	r.bits.data	:= cur_data
}