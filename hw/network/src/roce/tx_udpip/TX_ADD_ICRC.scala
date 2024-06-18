package network.roce.tx_udpip

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector




class TX_ADD_ICRC() extends Module{
	val io = IO(new Bundle{
		val tx_data_in	    = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val tx_data_out	    = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
	})


	val ip_data_fifo = XQueue(new AXIS(CONFIG.DATA_WIDTH),16)
	io.tx_data_in 	    <> ip_data_fifo.io.in



	val sIDLE :: sPOST :: Nil = Enum(2)
	val state                   = RegInit(sIDLE)	
	val crc                   = RegInit("hdeadbeef".U(32.W))
	

    ip_data_fifo.io.out.ready      := io.tx_data_out.ready


	io.tx_data_out.valid 			:= 0.U 
	io.tx_data_out.bits 		    := 0.U.asTypeOf(io.tx_data_out.bits)


	
	switch(state){
		is(sIDLE){
			when(ip_data_fifo.io.out.fire){
				when(ip_data_fifo.io.out.bits.last === 1.U){
					when(ip_data_fifo.io.out.bits.keep(63) === 1.U){
						state						:= sPOST
						io.tx_data_out.bits.last	:= 0.U
						io.tx_data_out.bits.keep	:= ip_data_fifo.io.out.bits.keep
						io.tx_data_out.bits.data	:= ip_data_fifo.io.out.bits.data
						io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
					}.otherwise{
						when(ip_data_fifo.io.out.bits.keep === -1.S(4.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(8.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(31,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid							
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(8.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(12.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(63,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid							
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(12.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(16.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(95,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid							
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(16.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(20.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(127,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid							
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(20.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(24.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(159,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(24.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(28.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(191,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(28.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(32.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(223,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(32.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(36.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(255,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(36.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(40.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(287,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(40.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(44.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(319,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(44.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(48.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(351,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(48.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(52.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(383,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(52.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(56.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(415,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(56.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(60.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(0.U,crc,ip_data_fifo.io.out.bits.data(447,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
						}.elsewhen(ip_data_fifo.io.out.bits.keep === -1.S(60.W).asTypeOf(UInt(64.W)) ){
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(64.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= Cat(crc,ip_data_fifo.io.out.bits.data(479,0))
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid
						}.otherwise{
							io.tx_data_out.bits.last	:= 1.U
							io.tx_data_out.bits.keep	:= -1.S(64.W).asTypeOf(UInt(64.W)) 
							io.tx_data_out.bits.data	:= ip_data_fifo.io.out.bits.data
							io.tx_data_out.valid	:= ip_data_fifo.io.out.valid							
						}
					}
				}.otherwise{
					io.tx_data_out.bits.last	:= ip_data_fifo.io.out.bits.last
					io.tx_data_out.bits.keep	:= ip_data_fifo.io.out.bits.keep
					io.tx_data_out.bits.data	:= ip_data_fifo.io.out.bits.data
					io.tx_data_out.valid	:= ip_data_fifo.io.out.valid						
				}
			}
		}
		is(sPOST){
			when(io.tx_data_out.ready){
				io.tx_data_out.bits.last	:= 1.U
				io.tx_data_out.bits.keep	:= 0xF.U
				io.tx_data_out.bits.data	:= crc
				io.tx_data_out.valid	:= 1.U
				state						:= sIDLE
			}
		}
	}

}