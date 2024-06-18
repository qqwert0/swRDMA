package network.roce.table

import common.storage._
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import network.roce.util._
import common.Collector






class MULTI_Q[T<:Data](val gen:T, val queue_num:Int, val entries:Int) extends Module{
	val io = IO(new Bundle{
        // val push_idx    = Input(UInt(log2Up(queue_num).W))
		val push        = Flipped(Decoupled(new MQ_POP_REQ(gen)))

		val pop_req     = Flipped(Decoupled(UInt(log2Up(queue_num).W)))
        val pop_rsp	    = (Decoupled(new MQ_POP_RSP(gen)))
	})

    val q_table = XRam(new MULTI_Q_ENTRY(gen), entries, latency=1)

    val point_table = XRam(new MQ_POINT_ENTRY(), queue_num, latency=1)

    val freelist_index = RegInit(1.U(16.W))
    // val write_freelist = Wire(Bool())
    val free_list = XQueue(UInt(16.W), entries)
    val push_fifo = Module(new Queue(new MQ_POP_REQ(gen), 16))

    io.push                     <> push_fifo.io.enq

     

	val sIDLE :: sPUSH0 :: sPUSH1 :: sPUSH2 :: sPOP0 :: sPOP1 :: sPOP2 :: Nil = Enum(7)
	val state                   = RegInit(sIDLE)
    Collector.report(state===sIDLE, "MULTI_Q===sIDLE")  
    val new_entry_index	        = RegInit(0.U(16.W))
    val q_push_temp             = RegInit(0.U.asTypeOf(new MQ_POP_REQ(gen)))
    val q_pop_index             = RegInit(0.U(16.W))
    val point_temp              = RegInit(0.U.asTypeOf(new MQ_POINT_ENTRY()))
    val q_table_temp            = RegInit(0.U.asTypeOf(new MULTI_Q_ENTRY(gen)))

    when(((state === sPOP2) & (q_table_temp.isValid) & (q_table_temp.isValid)))  {//((state === sPOP1) & (io.pop_rsp.ready === 1.U) & (q_table.io.data_out_b.isValid)) ||
        free_list.io.in.valid   := 1.U
        free_list.io.in.bits    := point_temp.head     
        freelist_index          := freelist_index   
    }.elsewhen((freelist_index < entries.U) & (!free_list.io.almostfull) & (!reset.asBool) & free_list.io.in.ready){
        free_list.io.in.valid   := 1.U
        free_list.io.in.bits    := freelist_index
        freelist_index          := freelist_index + 1.U
    }.otherwise{
        free_list.io.in.valid   := 0.U
        free_list.io.in.bits    := 0.U
        freelist_index          := freelist_index
    }


    

    q_table.io.addr_a              := 0.U
    q_table.io.addr_b              := 0.U
    q_table.io.wr_en_a             := 0.U
    q_table.io.data_in_a           := 0.U.asTypeOf(q_table.io.data_in_a)

    point_table.io.addr_a              := 0.U
    point_table.io.addr_b              := 0.U
    point_table.io.wr_en_a             := 0.U
    point_table.io.data_in_a           := 0.U.asTypeOf(point_table.io.data_in_a)



    push_fifo.io.deq.ready               := (state === sIDLE) & free_list.io.out.valid & push_fifo.io.deq.valid
    free_list.io.out.ready      := (state === sIDLE) & free_list.io.out.valid & push_fifo.io.deq.valid

    io.pop_req.ready            := (state === sIDLE) & !(push_fifo.io.deq.fire & free_list.io.out.fire)

    io.pop_rsp.valid            := 0.U
    io.pop_rsp.bits             := 0.U.asTypeOf(io.pop_rsp.bits)
	
	switch(state){
		is(sIDLE){
			when(push_fifo.io.deq.fire & free_list.io.out.fire){
                new_entry_index             := free_list.io.out.bits
                q_push_temp                 <> push_fifo.io.deq.bits

                // q_table.io.addr_a                := free_list.io.out.bits
                // q_table.io.wr_en_a               := 1.U
                // q_table.io.data_in_a.data       := push_fifo.io.deq.bits.data
                // q_table.io.data_in_a.isValid      := true.B
                // q_table.io.data_in_a.isTail     := true.B                

                point_table.io.addr_b       := push_fifo.io.deq.bits.q_index
                state                       := sPUSH0
			}.elsewhen(io.pop_req.fire){
                point_table.io.addr_b       := io.pop_req.bits
                q_pop_index                 <> io.pop_req.bits
                state                       := sPOP0
            }
		}
		is(sPUSH0){
            q_table.io.addr_b                   := point_table.io.data_out_b.tail
            point_temp                          <> point_table.io.data_out_b
            state                               := sPUSH1
		}  
        is(sPUSH1){
            when(q_table.io.data_out_b.isValid){
                q_table.io.addr_a                   := point_temp.tail
                q_table.io.wr_en_a                  := 1.U
                q_table.io.data_in_a.data           := q_table.io.data_out_b.data
                q_table.io.data_in_a.next           := new_entry_index
                q_table.io.data_in_a.isValid          := true.B
                q_table.io.data_in_a.isTail         := false.B 
                point_table.io.addr_a                := q_push_temp.q_index
                point_table.io.wr_en_a               := 1.U
                point_table.io.data_in_a.head   := point_temp.head
                point_table.io.data_in_a.tail   := new_entry_index

            }.otherwise{
                point_table.io.addr_a                := q_push_temp.q_index
                point_table.io.wr_en_a               := 1.U
                point_table.io.data_in_a.head   := new_entry_index
                point_table.io.data_in_a.tail   := new_entry_index
            }  
            state                               := sPUSH2
        }
        is(sPUSH2){
            q_table.io.addr_a                := new_entry_index
            q_table.io.wr_en_a               := 1.U
            q_table.io.data_in_a.data       := q_push_temp.data
            q_table.io.data_in_a.isValid      := true.B
            q_table.io.data_in_a.isTail     := true.B  
            state                               := sIDLE
        }
        is(sPOP0){
            point_temp                          <> point_table.io.data_out_b
            q_table.io.addr_b                   := point_table.io.data_out_b.head
            state                               := sPOP1
        }     
        is(sPOP1){
            // when(io.pop_rsp.ready === 1.U){
            //     when(q_table.io.data_out_b.isValid){
            //         q_table.io.addr_a                    := point_temp.head
            //         q_table.io.wr_en_a                   := 1.U
            //         q_table.io.data_in_a.data           := 0.U
            //         q_table.io.data_in_a.next           := 0.U
            //         q_table.io.data_in_a.isValid          := false.B
            //         q_table.io.data_in_a.isTail         := false.B 



            //         point_table.io.addr_a                := q_pop_index
            //         point_table.io.wr_en_a               := 1.U
            //         point_table.io.data_in_a.head   := q_table.io.data_out_b.next
            //         point_table.io.data_in_a.tail   := point_table.io.data_out_b.tail                    

            //         io.pop_rsp.valid                        := 1.U
            //         io.pop_rsp.bits.isValid                   := true.B
            //         io.pop_rsp.bits.data                    := q_table.io.data_out_b.data
            //     }.otherwise{
            //         io.pop_rsp.valid                        := 1.U
            //         io.pop_rsp.bits.isValid                   := false.B
            //     }
            //     state                               := sIDLE
            // }.otherwise{
                q_table_temp                    <> q_table.io.data_out_b
                state                           := sPOP2
            // }
                
        } 
        is(sPOP2){
            when(io.pop_rsp.ready === 1.U){
                when(q_table_temp.isValid){
                    q_table.io.addr_a                    := point_temp.head
                    q_table.io.wr_en_a                   := 1.U
                    q_table.io.data_in_a.isValid      := false.B

                    // write_freelist                          := true.B

                    point_table.io.addr_a                := q_pop_index
                    point_table.io.wr_en_a               := 1.U
                    point_table.io.data_in_a.head   := q_table_temp.next
                    point_table.io.data_in_a.tail   := point_temp.tail                    

                    io.pop_rsp.valid                        := 1.U
                    io.pop_rsp.bits.isValid                   := true.B
                    io.pop_rsp.bits.data                    := q_table_temp.data
                    state                                   := sIDLE
                }.otherwise{
                    io.pop_rsp.valid                        := 1.U
                    io.pop_rsp.bits.isValid                   := false.B
                }   
                state                               := sIDLE             
            }.otherwise{
                state                           := sPOP2
            }
        }


	}
    

}
