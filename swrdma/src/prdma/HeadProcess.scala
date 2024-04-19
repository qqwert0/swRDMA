package swrdma

import common.storage._
import common.axi._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector
import common.connection._

class HeadProcess() extends Module{
	val io = IO(new Bundle{
		val rx_data_in          = Flipped(Decoupled(new AXIS(512)))
		val meta_out	        = (Decoupled(new Pkg_meta()))
		val reth_data_out	    = (Decoupled(new AXIS(512)))
        val aeth_data_out	    = (Decoupled(new AXIS(512)))
        val raw_data_out	    = (Decoupled(new AXIS(512)))
	})

	val fixed_len = CONFIG.IP_HEADER_LEN + CONFIG.UDP_HEADER_LEN + CONFIG.IBH_HEADER_LEN + CONFIG.SWRDMA_HEADER_LEN1 
	val IP_HEADER_HIGH = CONFIG.IP_HEADER_LEN -1
	val UDP_HEADER_HIGH = CONFIG.IP_HEADER_LEN + CONFIG.UDP_HEADER_LEN -1
	val IBH_HEADER_HIGH = CONFIG.IP_HEADER_LEN + CONFIG.UDP_HEADER_LEN + CONFIG.IBH_HEADER_LEN -1
    val RETH_HEADER_HIGH = CONFIG.IP_HEADER_LEN + CONFIG.UDP_HEADER_LEN + CONFIG.IBH_HEADER_LEN + CONFIG.RETH_HEADER_LEN -1
	val AETH_HEADER_HIGH = CONFIG.IP_HEADER_LEN + CONFIG.UDP_HEADER_LEN + CONFIG.IBH_HEADER_LEN + CONFIG.AETH_HEADER_LEN -1
	val IP_HEADER_LOW = 0
	val UDP_HEADER_LOW = CONFIG.IP_HEADER_LEN
	val IBH_HEADER_LOW = CONFIG.IP_HEADER_LEN + CONFIG.UDP_HEADER_LEN
	val RETH_HEADER_LOW = CONFIG.IP_HEADER_LEN + CONFIG.UDP_HEADER_LEN + CONFIG.IBH_HEADER_LEN
	val AETH_HEADER_LOW = CONFIG.IP_HEADER_LEN + CONFIG.UDP_HEADER_LEN + CONFIG.IBH_HEADER_LEN 
	
	val ip_header = Wire(new IP_HEADER())
	val udp_header = Wire(new UDP_HEADER())
	val ibh_header = Wire(new IBH_HEADER())
	val reth_header = Wire(new RETH_HEADER())
	val aeth_header = Wire(new AETH_HEADER())
	val rx_data_fifo    = XQueue(new AXIS(512),64)
	rx_data_fifo.io.in <> io.rx_data_in

	val rx_data_out          = Wire(Decoupled(new AXIS(512)))
	val rx_data_out_router  = SimpleRouter(new AXIS(512),4)
	rx_data_out_router.io.in <> rx_data_out
	rx_data_out_router.io.out(0) <> DontCare
	rx_data_out_router.io.out(1) <> io.reth_data_out
	rx_data_out_router.io.out(2) <> io.aeth_data_out
	rx_data_out_router.io.out(3) <> io.raw_data_out
	
	val meta_wire    = Wire(new Pkg_meta())
	val s_head :: s_payload :: Nil = Enum(2)

	val state = RegInit(s_head)

	val empty_pack :: reth_pack:: aeth_pack :: raw_pack :: Nil = Enum(4)
	val pack_class = RegInit(empty_pack)
	val wire_class = Wire(UInt(2.W))
	when(state === s_head ){
		rx_data_out_router.io.idx :=  wire_class
	}.otherwise{
		rx_data_out_router.io.idx :=  pack_class
	}//rx_data_out_router.io.idx :=  pack_class  //todo to be checked

	switch(state){
		is(s_head){
			when(rx_data_fifo.io.out.fire() && rx_data_fifo.io.out.bits.last =/= 1.U ){
				state := s_payload
			}.otherwise{
				state := s_head
			}
		}
		is(s_payload){
			when(rx_data_fifo.io.out.fire()&& rx_data_fifo.io.out.bits.last === 1.U){
				state := s_head
			}.otherwise{
				state := s_payload
			}
		}	
	}
	io.meta_out.bits := meta_wire
	io.meta_out.valid := (state === s_head ) && rx_data_fifo.io.out.valid && rx_data_out.ready && io.meta_out.ready

	rx_data_out.bits := rx_data_fifo.io.out.bits
	rx_data_out.valid :=  rx_data_fifo.io.out.valid && ((state === s_payload )|| (state === s_head && rx_data_out.ready && io.meta_out.ready))
	rx_data_fifo.io.out.ready := (rx_data_out.ready && (state === s_payload ))|| ((state === s_head ) || (rx_data_out.ready && io.meta_out.ready))

	when(state === s_head ){  //todo need to be checked
		when(PKG_JUDGE.RETH_PKG(meta_wire.op_code)){  
			pack_class := reth_pack
		}.elsewhen(PKG_JUDGE.AETH_PKG(meta_wire.op_code)){
			pack_class := aeth_pack
		}.elsewhen(meta_wire.op_code =/= IB_OPCODE.reserve &&
					meta_wire.op_code =/= IB_OPCODE.reserve0){
			pack_class := raw_pack
		}.otherwise{
			pack_class := empty_pack
		}
	}

	when(state === s_head ){  //todo need to be checked
		when(PKG_JUDGE.RETH_PKG(meta_wire.op_code)){  
			wire_class := 1.U
		}.elsewhen(PKG_JUDGE.AETH_PKG(meta_wire.op_code)){
			wire_class := 2.U
		}.elsewhen(meta_wire.op_code =/= IB_OPCODE.reserve &&
					meta_wire.op_code =/= IB_OPCODE.reserve0){
			wire_class := 3.U
		}.otherwise{
			wire_class := 0.U
		}
	}.otherwise(
		wire_class := 0.U
	)
	
	
	ip_header                    := rx_data_fifo.io.out.bits.data(IP_HEADER_HIGH,IP_HEADER_LOW).asTypeOf(ip_header)
	udp_header                   := rx_data_fifo.io.out.bits.data(UDP_HEADER_HIGH,UDP_HEADER_LOW).asTypeOf(udp_header)
	ibh_header                   := rx_data_fifo.io.out.bits.data(IBH_HEADER_HIGH,IBH_HEADER_LOW).asTypeOf(ibh_header)
	reth_header                  := rx_data_fifo.io.out.bits.data(RETH_HEADER_HIGH,RETH_HEADER_LOW).asTypeOf(reth_header)
	aeth_header                  := rx_data_fifo.io.out.bits.data(AETH_HEADER_HIGH,AETH_HEADER_LOW).asTypeOf(aeth_header)
	
	meta_wire.op_code	  := ibh_header.op_code.asTypeOf(IB_OPCODE())
	meta_wire.qpn         := Util.reverse(ibh_header.qpn)
	meta_wire.psn         := Util.reverse(ibh_header.psn)
	meta_wire.ecn         := ip_header.ecn === 3.U
	meta_wire.vaddr       := Util.reverse(reth_header.vaddr)
	meta_wire.pkg_length  := Util.reverse(udp_header.length)
	meta_wire.msg_length  := 0.U(32.W)   //todo to be modified	
	meta_wire.user_define := 0.U(336.W)  //todo to be modified
	
}