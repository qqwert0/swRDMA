package network.roce.tx_udpip

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector




class RX_ICRC_PROCESS() extends Module{
	val io = IO(new Bundle{
		val rx_data_in	    = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
        val rx_data_out	    = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
	})


	val ip_data_fifo = XQueue(new AXIS(CONFIG.DATA_WIDTH),16)
	io.rx_data_out 	    <> ip_data_fifo.io.out



	val sIDLE :: sPKG :: sLAST :: Nil = Enum(3)
	val state                   = RegInit(sIDLE)	
	val pre_word                = Reg(new AXIS(CONFIG.DATA_WIDTH))
	

    io.rx_data_in.ready      := !ip_data_fifo.io.almostfull



	ip_data_fifo.io.in.valid 			:= 0.U 
	ip_data_fifo.io.in.bits 		    := 0.U.asTypeOf(ip_data_fifo.io.in.bits)


	
	switch(state){
		is(sIDLE){
			when(io.rx_data_in.fire){
				pre_word			:= io.rx_data_in.bits
				when(io.rx_data_in.bits.last === 1.U){
					state			:= sLAST
				}.otherwise{
					state			:= sPKG
				}
			}.otherwise{
				state				:= sIDLE
			}
		}
		is(sPKG){
			when(io.rx_data_in.fire){
				pre_word			:= io.rx_data_in.bits
				when(io.rx_data_in.bits.last === 1.U){
					when(io.rx_data_in.bits.keep(4) === 0.U){
						ip_data_fifo.io.in.valid		:= 1.U
						ip_data_fifo.io.in.bits.data	:= pre_word.data
						ip_data_fifo.io.in.bits.keep	:= pre_word.keep
						ip_data_fifo.io.in.bits.last	:= 1.U
						state							:= sIDLE						
					}.otherwise{
						ip_data_fifo.io.in.valid		:= 1.U
						ip_data_fifo.io.in.bits.data	:= pre_word.data
						ip_data_fifo.io.in.bits.keep	:= pre_word.keep
						ip_data_fifo.io.in.bits.last	:= pre_word.last						
						state							:= sLAST
					}
				}.otherwise{
					ip_data_fifo.io.in.valid		:= 1.U
					ip_data_fifo.io.in.bits.data	:= pre_word.data
					ip_data_fifo.io.in.bits.keep	:= pre_word.keep
					ip_data_fifo.io.in.bits.last	:= pre_word.last					
					state			:= sPKG
				}
			}.otherwise{
				state				:= sPKG
				pre_word			:= pre_word
			}
		}
		is(sLAST){

			when(pre_word.keep === -1.S(8.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(4.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U							
			}.elsewhen(pre_word.keep === -1.S(12.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(8.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U							
			}.elsewhen(pre_word.keep === -1.S(16.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(12.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U							
			}.elsewhen(pre_word.keep === -1.S(20.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(16.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U
			}.elsewhen(pre_word.keep === -1.S(24.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(20.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U
			}.elsewhen(pre_word.keep === -1.S(28.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(24.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U
			}.elsewhen(pre_word.keep === -1.S(32.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(28.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U
			}.elsewhen(pre_word.keep === -1.S(36.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(32.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U
			}.elsewhen(pre_word.keep === -1.S(40.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(36.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U
			}.elsewhen(pre_word.keep === -1.S(44.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(40.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U
			}.elsewhen(pre_word.keep === -1.S(48.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(44.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U
			}.elsewhen(pre_word.keep === -1.S(52.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(48.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U
			}.elsewhen(pre_word.keep === -1.S(56.W).asTypeOf(UInt(64.W)) ){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(52.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U
			}.elsewhen(pre_word.keep === -1.S(60.W).asTypeOf(UInt(64.W))){
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(56.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U
			}.otherwise{
				ip_data_fifo.io.in.bits.last	:= 1.U
				ip_data_fifo.io.in.bits.keep	:= -1.S(60.W).asTypeOf(UInt(64.W)) 
				ip_data_fifo.io.in.bits.data	:= pre_word.data
				ip_data_fifo.io.in.valid	:= 1.U							
			}

			when(io.rx_data_in.fire){
				pre_word			:= io.rx_data_in.bits
				when(io.rx_data_in.bits.last === 1.U){
					state			:= sLAST
				}.otherwise{
					state			:= sPKG
				}
			}.otherwise{
				state				:= sIDLE
			}
		}
	}

}