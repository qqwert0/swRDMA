package network.roce.rx_udpip

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector

class RX_IP_PROCESS() extends Module{
	val io = IO(new Bundle{
		val rx_data_in          = Flipped(Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val ip_meta_out	        = (Decoupled(new IP_META()))
		val rx_data_out	        = (Decoupled(new AXIS(CONFIG.DATA_WIDTH)))
		val ip_addr 			= Input(UInt(32.W))
	})


	val ip_header_tmp = Wire(new IP_HEADER())
    ip_header_tmp                  := 0.U.asTypeOf(ip_header_tmp)

	val sIDLE :: sPAYLOAD :: Nil = Enum(2)
	val state                       = RegInit(sIDLE)	
	// Collector.report(state===sIDLE, "RX_IP_PROCESS===sIDLE")
	
	io.rx_data_in.ready         := ((state === sIDLE) & io.ip_meta_out.ready & io.rx_data_out.ready) | ((state === sPAYLOAD) & io.rx_data_out.ready) 


	io.ip_meta_out.valid 			:= 0.U 
	io.ip_meta_out.bits 		    := 0.U.asTypeOf(io.ip_meta_out.bits)
	io.rx_data_out.valid 		    := 0.U 
	io.rx_data_out.bits 		    := 0.U.asTypeOf(io.rx_data_out.bits)	


	
	switch(state){
		is(sIDLE){
			when(io.rx_data_in.fire){
                io.rx_data_out.valid        := 1.U
                io.rx_data_out.bits         <> io.rx_data_in.bits
				ip_header_tmp               := io.rx_data_in.bits.data(CONFIG.IP_HEADER_LEN-1,0).asTypeOf(ip_header_tmp)
                io.ip_meta_out.valid        := 1.U    
                io.ip_meta_out.bits.dest_ip := ip_header_tmp.src_ipaddr
                io.ip_meta_out.bits.length  := Util.reverse(ip_header_tmp.length)

				when(ip_header_tmp.dst_ipaddr =/= io.ip_addr){
					printf(p" ip_addr error, ture ip: ${io.ip_addr}, real ip: ${ip_header_tmp.dst_ipaddr} \n");
				}

                when(io.rx_data_in.bits.last =/= 1.U){
                    state               := sPAYLOAD
                }

			}
		}
		is(sPAYLOAD){
            when(io.rx_data_in.fire){
                io.rx_data_out.bits     <> io.rx_data_in.bits
                io.rx_data_out.valid    := 1.U
                when(io.rx_data_in.bits.last === 1.U){
                    state               := sIDLE
                }                
            }
		}		
	}


}