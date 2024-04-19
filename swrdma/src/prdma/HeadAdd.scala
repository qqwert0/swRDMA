package swrdma

import common.storage._
import common.axi._
import common._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import common.Collector

class HeadAdd() extends Module{
	val io = IO(new Bundle{
		val meta_in	        = Flipped(Decoupled(new Event_meta()))
		val reth_data_in	    = Flipped(Decoupled(new AXIS(512)))
        val aeth_data_in	    = Flipped(Decoupled(new AXIS(512)))
        val raw_data_in	    = Flipped(Decoupled(new AXIS(512)))

		val conn_state	    = Flipped(Decoupled(new Conn_state()))
        val tx_data_out	   	= (Decoupled(new AXIS(512)))

		val local_ip_address= Input(UInt(32.W))

	})
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
	
	val meta_fifo = XQueue(new Event_meta(),64)
	meta_fifo.io.in <> io.meta_in
    
    val conn_fifo = XQueue(new Conn_state(),64)
    conn_fifo.io.in <> io.conn_state

    val s_meta :: s_head :: s_payload :: Nil = Enum(3)
	val state = RegInit(s_meta)
	switch(state){
		is(s_meta){
			when(meta_fifo.io.out.fire() && conn_fifo.io.out.fire()){
				state := s_head
			}.otherwise{
				state := s_meta
			}
		}
		is(s_head){
			when(io.tx_data_out.fire() && io.tx_data_out.bits.last =/= 1.U ){
				state := s_payload
			}.otherwise{
				state := s_meta
			}
		}
		is(s_payload){
			when(io.tx_data_out.fire()&& io.tx_data_out.bits.last === 1.U){
				state := s_meta
			}.otherwise{
				state := s_payload
			}
		}	
	}



	val empty_pack :: reth_pack:: aeth_pack :: raw_pack :: Nil = Enum(4)
	val pack_class = RegInit(empty_pack)
	when(state === s_meta ){  //todo need to be checked
		when(PKG_JUDGE.RETH_PKG(meta_fifo.io.out.bits.op_code)){  
			pack_class := reth_pack
		}.elsewhen(PKG_JUDGE.AETH_PKG(meta_fifo.io.out.bits.op_code)){
			pack_class := aeth_pack
		}.elsewhen(meta_fifo.io.out.bits.op_code =/= IB_OPCODE.reserve &&
					meta_fifo.io.out.bits.op_code =/= IB_OPCODE.reserve0){
			pack_class := raw_pack
		}.otherwise{
			pack_class := empty_pack
		}
	}

	val reth_fifo = XQueue(new AXIS(512),64)
    reth_fifo.io.in <> io.reth_data_in
	val aeth_fifo = XQueue(new AXIS(512),64)
	aeth_fifo.io.in <> io.aeth_data_in
	val raw_fifo = XQueue(new AXIS(512),64)
	raw_fifo.io.in <> io.raw_data_in
	



	val usr_defined_header_len = Reg(UInt(32.W))
	when(meta_fifo.io.out.bits.header_len === 0.U){
		usr_defined_header_len := 0.U
	}.elsewhen(meta_fifo.io.out.bits.header_len === 1.U){
		usr_defined_header_len := 4.U
	}.elsewhen(meta_fifo.io.out.bits.header_len === 2.U){
		usr_defined_header_len := 8.U
	}.elsewhen(meta_fifo.io.out.bits.header_len === 3.U){
		usr_defined_header_len := 16.U
	}.elsewhen(meta_fifo.io.out.bits.header_len === 4.U){
		usr_defined_header_len := 32.U
	}.elsewhen(meta_fifo.io.out.bits.header_len === 5.U){
		usr_defined_header_len := 42.U
	}.otherwise{
		usr_defined_header_len := 0.U
	}

    val ip_head = Wire(new IP_HEADER())
    ip_head       				    := 0.U.asTypeOf(ip_head)
    ip_head.version_IHL            	:= "h45".U
	when(pack_class===reth_pack){
			ip_head.length := meta_fifo.io.out.bits.pkg_length + (CONFIG.IP_HEADER_LEN/8).U + (CONFIG.UDP_HEADER_LEN/8).U + (CONFIG.IBH_HEADER_LEN/8).U + (CONFIG.RETH_HEADER_LEN/8).U + usr_defined_header_len
	}.elsewhen(pack_class===aeth_pack){
			ip_head.length := meta_fifo.io.out.bits.pkg_length + (CONFIG.IP_HEADER_LEN/8).U + (CONFIG.UDP_HEADER_LEN/8).U + (CONFIG.IBH_HEADER_LEN/8).U + (CONFIG.AETH_HEADER_LEN/8).U + usr_defined_header_len
	}.otherwise{
			ip_head.length := meta_fifo.io.out.bits.pkg_length + (CONFIG.IP_HEADER_LEN/8).U + (CONFIG.UDP_HEADER_LEN/8).U + (CONFIG.IBH_HEADER_LEN/8).U + usr_defined_header_len
	}
	
	

	ip_head.ttl            			:= "h40".U
	ip_head.protocol            	:= (CONFIG.UDP_PROTOCOL.U)
	ip_head.src_ipaddr            	:= (io.local_ip_address)
	ip_head.dst_ipaddr            	:= (conn_fifo.io.out.bits.remote_ip)
   

    val udp_head = Wire(new UDP_HEADER())
    udp_head                        := 0.U.asTypeOf(udp_head)
    udp_head.src_prot               := Util.reverse(CONFIG.RDMA_DEFAULT_PORT.U)
    udp_head.des_prot               := Util.reverse(conn_fifo.io.out.bits.remote_udp_port)
    udp_head.length                 := Util.reverse(ip_head.length - (CONFIG.IP_HEADER_LEN/8).U)

    val ibh_head = Wire(new IBH_HEADER())
    ibh_head       := 0.U.asTypeOf(ibh_head)	
    when(PKG_JUDGE.READ_RSP_PKG(meta_fifo.io.out.bits.op_code) | (meta_fifo.io.out.bits.op_code === IB_OPCODE.RC_ACK)){
        ibh_head.psn                    := Util.reverse(meta_fifo.io.out.bits.psn)
    }.otherwise{
        ibh_head.psn                    := Util.reverse(conn_fifo.io.out.bits.tx_npsn)
    }
    ibh_head.qpn                        := Util.reverse(conn_fifo.io.out.bits.remote_qpn)
   when(meta_fifo.io.out.bits.op_code ===IB_OPCODE.RC_ACK){
        ibh_head.ack                    := 1.U
    }.otherwise{
        ibh_head.ack                    := 0.U
    }   
    
    ibh_head.p_key                      := "hffff".U
    ibh_head.res2                       := 0.U  
    ibh_head.op_code                    := Util.reverse(meta_fifo.io.out.bits.op_code.asUInt())

	val reth_head = Wire(new RETH_HEADER())
	reth_head := 0.U.asTypeOf(reth_head)
	reth_head.length := Util.reverse(meta_fifo.io.out.bits.msg_length)
	reth_head.r_key := 0.U 
	reth_head.vaddr := Util.reverse(meta_fifo.io.out.bits.r_vaddr)

	val aeth_head = Wire(new AETH_HEADER())
	aeth_head := 0.U.asTypeOf(aeth_head)
	aeth_head.msn := 0.U
	aeth_head.iswr_ack := 0.U
	aeth_head.isNAK := 0.U
	when(meta_fifo.io.out.bits.op_code === IB_OPCODE.RC_ACK){
		aeth_head.credit                := 0.U//meta_fifo.io.out.bits.credit
	}.otherwise{
		aeth_head.credit                := 0.U
	}


 

    val two_valid = meta_fifo.io.out.valid & conn_fifo.io.out.valid
    meta_fifo.io.out.ready := (state === s_meta && two_valid )
    conn_fifo.io.out.ready := (state === s_meta && two_valid )
	
	//val reg_pkg_class = RegInit(empty_pack)
	val reg_ip_head = RegInit(0.U.asTypeOf(new IP_HEADER()))
	val reg_udp_head = RegInit(0.U.asTypeOf(new UDP_HEADER()))
	val reg_ibh_head = RegInit(0.U.asTypeOf(new IBH_HEADER()))
	val reg_reth_head = RegInit(0.U.asTypeOf(new RETH_HEADER()))
	val reg_aeth_head = RegInit(0.U.asTypeOf(new AETH_HEADER()))

	when(state === s_meta){
		//reg_pkg_class := pack_class
		reg_ip_head := ip_head
		reg_udp_head := udp_head
		reg_ibh_head := ibh_head
		reg_reth_head := reth_head
		reg_aeth_head := aeth_head
		aeth_fifo.io.out.ready := 0.U
		raw_fifo.io.out.ready := 0.U
		reth_fifo.io.out.ready := 0.U
		io.tx_data_out.bits.last := 0.U
		io.tx_data_out.bits.keep := 0.U
		io.tx_data_out.valid := 0.U
		io.tx_data_out.bits.data := 0.U
	}.elsewhen(state === s_head){
		// io.tx_data_out.bits.data(IP_HEADER_HIGH,IP_HEADER_LOW)      := reg_ip_head
	    // io.tx_data_out.bits.data(UDP_HEADER_HIGH,UDP_HEADER_LOW)  := reg_udp_head
	    // io.tx_data_out.bits.data(IBH_HEADER_HIGH,IBH_HEADER_LOW) := reg_ibh_head
	    when(pack_class===reth_pack){
				io.tx_data_out.bits.data := Cat(reth_fifo.io.out.bits.data(511,RETH_HEADER_HIGH+1),reg_reth_head.asUInt(),reg_ibh_head.asUInt(),reg_udp_head.asUInt(),reg_ip_head.asUInt())
				//io.tx_data_out.bits.data(RETH_HEADER_HIGH,RETH_HEADER_LOW):= reg_reth_head 
	    		//io.tx_data_out.bits.data(511,RETH_HEADER_HIGH+1) := reth_fifo.io.out.bits.data(511,RETH_HEADER_HIGH+1)
				io.tx_data_out.bits.last := reth_fifo.io.out.bits.last
				io.tx_data_out.bits.keep := reth_fifo.io.out.bits.keep
				io.tx_data_out.valid := reth_fifo.io.out.valid
				reth_fifo.io.out.ready := io.tx_data_out.ready
				aeth_fifo.io.out.ready := 0.U
				raw_fifo.io.out.ready := 0.U
			}.elsewhen(pack_class===aeth_pack){
				io.tx_data_out.bits.data := Cat(aeth_fifo.io.out.bits.data(511,AETH_HEADER_HIGH+1),reg_aeth_head.asUInt(),reg_ibh_head.asUInt(),reg_udp_head.asUInt(),reg_ip_head.asUInt())
				//io.tx_data_out.bits.data(AETH_HEADER_HIGH,AETH_HEADER_LOW):= reg_aeth_head
                //io.tx_data_out.bits.data(511,AETH_HEADER_HIGH+1) := aeth_fifo.io.out.bits.data(511,AETH_HEADER_HIGH+1)
				io.tx_data_out.bits.last := aeth_fifo.io.out.bits.last
				io.tx_data_out.bits.keep := aeth_fifo.io.out.bits.keep
				io.tx_data_out.valid := aeth_fifo.io.out.valid
				aeth_fifo.io.out.ready := io.tx_data_out.ready
				reth_fifo.io.out.ready := 0.U
				raw_fifo.io.out.ready := 0.U
			}.otherwise{
				io.tx_data_out.bits.data := Cat(raw_fifo.io.out.bits.data(511,IBH_HEADER_HIGH+1),reg_ibh_head.asUInt(),reg_udp_head.asUInt(),reg_ip_head.asUInt())
				//io.tx_data_out.bits.data(511,IBH_HEADER_HIGH+1) := raw_fifo.io.out.bits.data(511,IBH_HEADER_HIGH+1)
				io.tx_data_out.bits.last := raw_fifo.io.out.bits.last
				io.tx_data_out.bits.keep := raw_fifo.io.out.bits.keep
				io.tx_data_out.valid := raw_fifo.io.out.valid
				raw_fifo.io.out.ready := io.tx_data_out.ready
				reth_fifo.io.out.ready := 0.U
				aeth_fifo.io.out.ready := 0.U
			}
		
	}.otherwise{
		when(pack_class===reth_pack){
				io.tx_data_out <> reth_fifo.io.out
				aeth_fifo.io.out.ready := 0.U
				raw_fifo.io.out.ready := 0.U
			}.elsewhen(pack_class===aeth_pack){
				io.tx_data_out <> aeth_fifo.io.out
				reth_fifo.io.out.ready := 0.U
				raw_fifo.io.out.ready := 0.U
			}.otherwise{
				io.tx_data_out <> raw_fifo.io.out
				reth_fifo.io.out.ready := 0.U
				aeth_fifo.io.out.ready := 0.U
			}
		}
	
    
}