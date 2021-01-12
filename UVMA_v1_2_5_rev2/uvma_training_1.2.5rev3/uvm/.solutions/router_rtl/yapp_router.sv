/*----------------------------------------------------------------------
File name     : yapp_router.v
Developers    : Kathleen Meade, Brian Dickinson, Lisa Barbay
Created       : 23 Jun 2009
Description   : YAPP Router RTL model
Notes         : New version properly drops packets with extra debug reporting
Updates       : LKB 10/17/2011 Added new registers to work with a register 
              : Model:
              - Router_Enable for 8 enables
              - Packet register that is 6 bits not 8
              - Count Registers for Illegal Packet Addr, Max Packet Addr
              - Addr Counts, and Parity Errors
              - Works on interface level, no tests available for functionality
	      - Interrupt IEN
	      - Interrupt Status

	      - Don't use: has not been tested in a long time
              - Reset Register (Include indiviual channenl resets, parity,
		and a full router reset)
              - Works but do not use in class -- needs more debugging
      
	      - Last packet received RAM
              - Ram for the Last Packet Received (doesn't include parity)

2 known bugs:
  1- The last bit in the reset register (MSB) will not work correctly -- Added
     special rst_prot_err_fld -- which isn't being implemented, so the real
     cases will work correctly.
  2- The parity is not being updated in the last_pkt_mem memory.
v 2.0 LKB  1/22/2014  Added ifdef INT_SUPPORT for interrupt pin assignments.  This way it
will work with the Fundamentals class.
  2.0 LKB  3/22/2014 Added more parameters to easily move the YAPP registers
and memories around
3. The registers are not part of the output instantiantion.  The plus side is
that does not reflect the top.dut instantiation.  Some of the host_ctrl is
intermixed with functionality -- this should be revisited.


   Change this parameter:
   
    YAPP_OFFSET 16'h10000 -- all other address blocks will readjust.


Currently:
12 registers are implemented with a parameterized offset
1 256 byte memory at offset 0x100 of YAPP_OFFSET
1 65 Byte memory that is the last packet received (header + payload) at offset
0x010
- Bug, parity is not updated in last packet memory

YAPP_OFFSET  0x1000
each register is accessible xxx_reg (DPI) and host bus offset + YAPP_OFFSET
field are accessible via DPI xxx_fld


Memories (used off of YAPP_OFFSET)
YAPP_MEM_RO_ADJ 
last_pkt_size_reg = The last packet size (header + packet length)
last_pkt_mem [RO] = last packet received (header + packet). Maximum 65 bytes

 Only overwrites
the current packet received.  Read the last_pkt_size_reg to read only the
current packet contents

YAPP_MEM_RW_OFFSET
memory-[256]  
RW memory -- to have an additonal memory.  This shows how update can be used.

   

----------------------------------------------------------------------
Copyright Cadence Design Systems (c)2014
----------------------------------------------------------------------*/

//****                                                                ****
//****                         waveforms                              ****
//****                                                                ****
//
//                _   _   _   _   _   _   _   _   _   _   _   _   _   _   
//clock ...... : | |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_ 
//               :   :   :   :   :   :   :   :   :   :   :   :   :   :   :
//                ___________________             _______________
//in_data_vld  : /                   \___________/               \___________
//               :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   
//                                        ___                         ___
//error....... : ________________________/   \_______________________/   \___
//               :   :   :   :   :   :   :   :   :   :   :   :   :   :   :
//                ___ ___ __...__ ___ ___         ___ ___ __...__ ___
//in_data .... : X_H_X_D_X__...__X_D_X_P_>_______<_H_X_D_X__...__X_P_>_______
//               :   :   :   :   :   :   :   :   :   :   :   :   :   :   :
//                _______________________         ___________________
//packet ..... : <______packet_0_________>-------<______packet_1_____>-------
//               :   :   :   :   :   :   :   :   :   :   :   :   :   :   :
//
//H = Header
//D = Data
//P = Parity
// 
// the router assert data_vld_x  when valid data appears in channel queue x
// assert input read_enb_x to read packets from the queue.
// receiver must keep track of packet extent and size.
// error is asserted if parity error is detected at the end of packet reception 
//
//****************************************************************************/
`timescale 1ns/100ps 
  
typedef struct packed {
//typedef struct packed {
     logic illegal_addr_cnt_en_fld;     //Enable or Disable Illegal Address Counter
     logic addr2_cnt_en_fld;            //Enable or Disable Address 2 Counter
     logic addr1_cnt_en_fld;            //Enable or Disable Address 1 Counter
     logic addr0_cnt_en_fld;            //Enable or Disable Address 0 Counter 
     logic unimp;                       // protocol_err_en_en_fld;      //Not implemented
     logic len_err_cnt_en_fld;          //Enable or Disable the max packet illegal error counter
     logic parity_err_cnt_en_fld;       //Enable or Disable the parity error counter
     logic router_en_fld; 		//Enable or Disable the entire router
  }en_reg_t;


module host_ctl
             ( 
              input clock,
              input reset,
              input wr_rd,
              input en,
              input [15:0] addr,
              inout [7:0] data,
              input [7:0] parity_err_cnt,
              input [7:0] len_err_cnt,
              input [7:0] ill_addr_cnt,
              input [7:0] addr0_cnt,
              input [7:0] addr1_cnt,
              input [7:0] addr2_cnt,
              input [3:0] int_stat,
              input [6:0] pkt_addr,
              input [7:0] pkt_data,
              input [7:0] parity,
              input [5:0] last_pkt_size,
              input       parity_done,
              input       pkt_start,
              output[3:0] int_ien_reg,
              output[3:0] int_clr,
              output[4:0] rst_reg,
              output en_reg_t en_reg, //LKB_3_10
              //output[7:0] en_reg,  //LKB_3_10
              output[5:0] max_pkt_len); 

   // Reset values for control and enable registers
   parameter   RST_MAX_PKT = 8'h3F;
   parameter   en_reg_t RST_EN_REG = 8'h01;
   //--------------------------------------------------------------------------------------
   // Parameters that can be adjusted
   // -------------------------------------------------------------------------------------
   parameter   YAPP_OFFSET       = 16'h1000; // Offset of yapp_am container of the yapp_rdb.sv
   parameter   YAPP_MEM_RO_ADJ     = 8'h10;    // For decoding the memory based on an offset
   parameter  YAPP_MEM_RW_OFFSET  =   16'h100;   // Offset of memory from YAPP OFFSET
   parameter  YAPP_RANGE          = YAPP_OFFSET + 16'h1FFF;
  

  // Individual register offsets
   parameter   YCTRL_REG_OFF     = 8'h00;    // Offset of ctrl_reg, use the bit fields to define
   parameter   YEN_REG_OFF       = 8'h01;    // Offset of en_reg, use the bit fields to define
   parameter   YIEN_REG_OFF      = 8'h02;    // Offset of en_reg, use the bit fields to define
   parameter   YINT_REG_OFF      = 8'h03;    // Offset of the int_stat_reg, use bits to define
   parameter   YPAR_ERR_CNT_OFF  = 8'h04;    // Offset ot the parity err cnt reg, use reg to define
   parameter   YMAX_PKT_CNT_OFF  = 8'h05;    // Offset of max packet count reg
   parameter   YILL_ADDR_CNT_OFF = 8'h06;    // Offset of the illegal address count reg
   parameter   YADDR0_CNT_OFF    = 8'h09;    // Offset of addresss 0 count reg
   parameter   YADDR1_CNT_OFF    = 8'h0a;    // Offset of addresss 0 count reg
   parameter   YADDR2_CNT_OFF    = 8'h0b;    // Offset of addresss 0 count reg
   parameter   YRESET_REG_OFF    = 8'h0c;    // Offset of the reset register
   parameter   YLST_PKT_SIZE_OFF = 8'h0d;    // Offset of the last_pkt_size reg 
   parameter   YPARITY_RCVD_OFF  = 8'h0e;     // Offset of the parity rcvd (the packet parity - not the calc_parity (not working)


   //THESE ARE AUTOCALCULATED 

   parameter   YAPP_MEM_RO_ADDR    = YAPP_OFFSET+YAPP_MEM_RO_ADJ; // Address  of the last packet ram



   // ---------------------------------------------------------------------------------------
//  Simple RW memory @ YAPP_MEM_RW
//  ----------------------
   parameter  YAPP_MEM_RW_SIZE    =   16'h100;    // 256B memory
   parameter  YAPP_MEM_RW_END     =   YAPP_MEM_RW_SIZE -1;
   parameter  YAPP_MEM_RW_START   = YAPP_OFFSET + YAPP_MEM_RW_OFFSET;

/* // This is for the RO last_pkt_in memory -- does not do well with the
 built-in memory tests */
 
   parameter   YAPP_MEM_RO_SIZE     = 8'h41;
  parameter     RST_MEM_BIT_OFF	 = 4;         // Bit offset of rst_mem_fld 
   parameter  YAPP_MEM_RO_RANGE   = YAPP_OFFSET + YAPP_MEM_RO_ADJ + YAPP_MEM_RO_SIZE;
   
   //parameter   DEF_EN = 1'b0;   //KAM - For Training
   
   //reset register made of bit fields

   reg [7:0] reset_reg;
   reg rst_yapp_fld;
   reg rst_err_cnts_fld;
   reg rst_addr_cnts_fld;
   reg rst_ien_stat_fld;
   reg rst_ram_fld;
   reg rst_prot_err_fld;  // this isn't being used. Place holder

   //ctrl_reg @ Offset 00
   reg [7:0] ctrl_reg;
   reg [5:0] pkt_len_fld;

   //router_en_reg @ offset 01
   //LKB_3_10 not real reg [7:0] en_reg;
   reg router_en_fld ;
   reg parity_err_cnt_en_fld ;
   reg len_err_cnt_en_fld;
   //reg protocol_err_cnt_en_fld; LKB_3_10
   reg addr0_cnt_en_fld ;
   reg addr1_cnt_en_fld;
   reg addr2_cnt_en_fld  ;
   reg illegal_addr_cnt_en_fld;

   //interrupt enable reg - ien_reg @ offset 02
   reg [2:0]ien_reg;
   reg illegal_pkt_addr_ien_fld;
   reg ovrsized_pkt_ien_fld;
   reg parity_ien_fld;

   //interrupt status reg - int_stat_reg @ offset 3
   reg [2:0] int_reg; 
   reg illegal_pkt_addr_int_fld;
   reg ovrsized_pkt_int_fld;
   reg parity_int_fld;

   // parity error count reg - RO, no bit fields definition
   reg [7:0] parity_err_cnt_reg;
   reg [7:0] max_pkt_len_err_cnt_reg;
   reg [7:0] illegal_addr_cnt_reg;
   reg [7:0] addr0_cnt_reg;
   reg [7:0] addr1_cnt_reg;
   reg [7:0] addr2_cnt_reg;
   

   reg [7:0] memory [0:YAPP_MEM_RW_END];
 
   // RO memory of the last packet - do not put this in the built in tests
   reg [7:0] last_pkt_size_reg;
   reg [7:0] last_pkt_mem[0:64];   // Straight R0 memory of the last packet recieved

           
   //internal data buses
   reg [7:0]   int_data;
   reg [7:0]   int_en_reg;
   reg [3:0]   int_clr_int;
   reg [6:0]   pkt_addr_int;
   reg [7:0]   pkt_data_int;
   //reg [7:0]   parity_int;
   //
   genvar imem;
  
   //continuous assignments for of internals to nets to other modules
   //LKB_3_10 added int_en_reg back - bug because protocol error is not legal
   //(bit 3 -- writing the single bit will fail a bit bash test -- not sure
   //how to code for this in RTL.
   //assign en_reg = { illegal_addr_cnt_en_fld, addr2_cnt_en_fld, addr1_cnt_en_fld, addr0_cnt_en_fld, 1'b0, len_err_cnt_en_fld, parity_err_cnt_en_fld, router_en_fld};
  // assign en_reg = { illegal_addr_cnt_en_fld, addr2_cnt_en_fld, addr1_cnt_en_fld, addr0_cnt_en_fld, 1'b0, len_err_cnt_en_fld, parity_err_cnt_en_fld, router_en_fld};
   
 assign max_pkt_len = pkt_len_fld;
   assign rst_reg =  {rst_ram_fld, rst_ien_stat_fld, rst_addr_cnts_fld, rst_err_cnts_fld, rst_yapp_fld};
   assign int_ien_reg = { illegal_pkt_addr_ien_fld, ovrsized_pkt_ien_fld, parity_ien_fld};
   assign int_clr = int_clr_int;
   assign data = int_data;
   assign en_reg = { illegal_addr_cnt_en_fld, addr2_cnt_en_fld, addr1_cnt_en_fld, addr0_cnt_en_fld, 1'b0, len_err_cnt_en_fld, parity_err_cnt_en_fld, router_en_fld};

   
     
  
   // assignments from other modules: counts, resets, and integers
   always @(negedge clock or posedge reset) begin
	if ((parity_err_cnt_en_fld) && (parity_err_cnt_reg < parity_err_cnt)) begin
 	   parity_err_cnt_reg <= parity_err_cnt;
        end
        if ((len_err_cnt_en_fld) && (max_pkt_len_err_cnt_reg < len_err_cnt)) begin
	   max_pkt_len_err_cnt_reg  <= len_err_cnt;
        end
          if ((illegal_addr_cnt_en_fld) && (illegal_addr_cnt_reg < ill_addr_cnt)) begin
	  illegal_addr_cnt_reg  <= ill_addr_cnt;
        end
	if ((addr0_cnt_en_fld ) && (addr0_cnt_reg < addr0_cnt)) begin
		addr0_cnt_reg <= addr0_cnt;
        end
	if ((addr1_cnt_en_fld ) && (addr1_cnt_reg < addr1_cnt)) begin
		addr1_cnt_reg <= addr1_cnt;
        end
	if ((addr2_cnt_en_fld ) && (addr2_cnt_reg < addr2_cnt)) begin
		addr2_cnt_reg <= addr2_cnt;
       end
        // assign the interrupt status from the fsm_core to the fields
        illegal_pkt_addr_int_fld <= int_stat[2];
        ovrsized_pkt_int_fld <= int_stat[1];
        parity_int_fld <= int_stat[0];
        if (pkt_start == 1'b1 )begin
           last_pkt_mem[pkt_addr] <= pkt_data;
           //$display("<<<DBG_ROUTER last_pkt_mem[%x] = %x>>>>", pkt_addr, pkt_data);
        end
        //assign the parity as the last register in the packet, this doesn't
        //work
        if (parity_done == 1'b1) begin
           //last_pkt_mem[last_pkt_size+1] <= parity;
        end
        last_pkt_size_reg <= last_pkt_size;
        reset_reg <= {rst_ram_fld, rst_ien_stat_fld, rst_addr_cnts_fld, rst_err_cnts_fld, rst_yapp_fld};

        pkt_len_fld <= ctrl_reg[5:0];
        
     end// always
    

   always @(negedge clock or posedge reset) begin
     if ((reset) || (rst_yapp_fld)) begin
       int_data <= 8'h00;
       // ctrl_reg
       pkt_len_fld <= RST_MAX_PKT;
       ctrl_reg <= RST_MAX_PKT;
       //en_reg <= 8'hf7;
       router_en_fld <= RST_EN_REG.router_en_fld;
       parity_err_cnt_en_fld  <= RST_EN_REG.parity_err_cnt_en_fld;
       //LKB_3_10_protocol_err_cnt_en_fld <= 1'b0;
       len_err_cnt_en_fld <= RST_EN_REG.len_err_cnt_en_fld;
       addr0_cnt_en_fld   <= RST_EN_REG.addr0_cnt_en_fld;
       addr1_cnt_en_fld <= RST_EN_REG.addr1_cnt_en_fld;
       addr2_cnt_en_fld  <= RST_EN_REG.addr2_cnt_en_fld;
       illegal_addr_cnt_en_fld  <= RST_EN_REG.illegal_addr_cnt_en_fld;
       //ien_reg default to all ien  to be 0
       ien_reg <= 4'b0000;
       illegal_pkt_addr_ien_fld <= 1'b0;
       ovrsized_pkt_ien_fld <= 1'b0;
       parity_ien_fld <= 1'b0;
       //int_stat_reg (R/W 1 to Clear)
       illegal_pkt_addr_int_fld <= 1'b0;
       ovrsized_pkt_int_fld <= 1'b0;
       parity_int_fld <= 1'b0;
       int_clr_int <= 4'b0000;
       
       // Error Count registers (RO)
       parity_err_cnt_reg <= 8'h00;
       max_pkt_len_err_cnt_reg <= 8'h00;
       illegal_addr_cnt_reg <= 8'h00;

       // channel count reg (RO)
       addr0_cnt_reg <= 8'h00;
       addr1_cnt_reg <= 8'h00;
       addr2_cnt_reg <= 8'h00;

      // Reset Register (RW)
       rst_ram_fld <= 1'b0;
       rst_ien_stat_fld <= 1'b0;
       rst_addr_cnts_fld <= 1'b0; 
       rst_err_cnts_fld <= 1'b0;
       rst_prot_err_fld <= 1'b0;


       reset_mem;

     end // always reset

     if ((reset) && (!rst_yapp_fld))
        rst_yapp_fld <= 1'b0;
     if (rst_err_cnts_fld) begin
        parity_err_cnt_reg <= 8'h00;
        max_pkt_len_err_cnt_reg <= 8'h00;
        illegal_addr_cnt_reg <= 8'h00;
     end

     if (rst_addr_cnts_fld) begin
       addr0_cnt_reg <= 8'h00;
       addr1_cnt_reg <= 8'h00;
       addr2_cnt_reg <= 8'h00;
     end
     if (rst_ram_fld) begin
       reset_mem;
     end

     if (rst_ien_stat_fld) begin
       //int_stat
       illegal_pkt_addr_int_fld <= 1'b0;
       ovrsized_pkt_int_fld <= 1'b0;
       parity_int_fld <= 1'b0;
       // ien flds
       illegal_pkt_addr_ien_fld <= 1'b0;
       ovrsized_pkt_ien_fld <= 1'b0;
       parity_ien_fld <= 1'b0;
     end
     if (rst_prot_err_fld) begin
	// this isn't  being used
	//protocol_err_int_fld <= 1'b0;
        //protocol_err_ien_fld <= 1'b0;
     end
     else if (!en)   
         int_data = 8'hZZ;
         
     else if (en ) begin
       int_clr_int = 4'b0000;
       //YAPP HBUS registers Registers BASE  and RO Packet
       if ((addr >= YAPP_OFFSET) && (addr <= YAPP_RANGE)) begin
          // First see if this is a read and a memory packet -- don't let it
          // be part of the case -- it's too hard to range check This is a
          // hack from a long time ago.  should do it like the memory.
          if ((addr >= YAPP_MEM_RO_ADDR) && (addr < YAPP_MEM_RO_RANGE) && (wr_rd == 1'b0)) begin
             int_data = last_pkt_mem[addr[7:0]-  YAPP_MEM_RO_ADJ  ];
             //$display("LKB First of packets %x %x %x", last_pkt_mem[0], last_pkt_mem[1], last_pkt_mem[2]);
             //$display("LKB ------ Memory at %d = %x-----", addr[7:0]-8'h10, int_data);

          end
          else begin
          if (addr[15:8] == (YAPP_OFFSET >> 8)) begin 
           case (wr_rd) 
           0 : begin //read
               
                 case (addr[7:0]) 
                  YCTRL_REG_OFF: begin 
                     int_data = {2'b00,pkt_len_fld};
                    
                  end
                  YEN_REG_OFF: begin
                    // and fail the bit test.  
                    // en_reg is being continously assigned as 
                     int_data = { illegal_addr_cnt_en_fld, addr2_cnt_en_fld, addr1_cnt_en_fld, addr0_cnt_en_fld, 1'b0, len_err_cnt_en_fld, parity_err_cnt_en_fld, router_en_fld}; 
                     //LKB_3_10 en_reg = int_data;
                     int_en_reg = { illegal_addr_cnt_en_fld, addr2_cnt_en_fld, addr1_cnt_en_fld, addr0_cnt_en_fld, 1'b0, len_err_cnt_en_fld, parity_err_cnt_en_fld, router_en_fld};  
;
                  //$display("<<<LKB DBG Reading Enable register int_data = %h, int_en_reg = %h>>", int_data, int_en_reg);

                  end
        
                  YIEN_REG_OFF:begin
                     int_data = {5'h00, illegal_pkt_addr_ien_fld, ovrsized_pkt_ien_fld, parity_ien_fld};
                     ien_reg = {5'h00, illegal_pkt_addr_ien_fld, ovrsized_pkt_ien_fld, parity_ien_fld}; ;
                 end

                  // R/W1 C
	          YINT_REG_OFF: begin
                     int_data = {5'h00, illegal_pkt_addr_int_fld, ovrsized_pkt_int_fld, parity_int_fld};
                     int_reg =  {illegal_pkt_addr_int_fld, ovrsized_pkt_int_fld, parity_int_fld};

                  end
                  // RO
                  YPAR_ERR_CNT_OFF: begin
                     int_data = parity_err_cnt_reg;
                  end

	          YMAX_PKT_CNT_OFF: int_data = max_pkt_len_err_cnt_reg;
                  YILL_ADDR_CNT_OFF : int_data = illegal_addr_cnt_reg;
                  YADDR0_CNT_OFF:     int_data = addr0_cnt_reg;
                  YADDR1_CNT_OFF:     int_data = addr1_cnt_reg;
                  YADDR2_CNT_OFF:     int_data = addr2_cnt_reg;
                  YRESET_REG_OFF: begin
                     int_data = {3'b000 , rst_ram_fld, rst_ien_stat_fld, rst_addr_cnts_fld, rst_err_cnts_fld, rst_yapp_fld};
                  end
                 YLST_PKT_SIZE_OFF: int_data = { 2'h0,last_pkt_size_reg};
                                             // read out of memory 
               default: int_data = 8'hZZ;
              endcase
                          
            end //read 
             1 : begin //write

                 case (addr[7:0]) 
                  YCTRL_REG_OFF: begin 
                       pkt_len_fld = data;
                       ctrl_reg = {2'b00, pkt_len_fld};
                      
                  end
                  YEN_REG_OFF: begin
                    //{ illegal_addr_cnt_en_fld, addr2_cnt_en_fld, addr1_cnt_en_fld, addr0_cnt_en_fld,1'b0 , len_err_cnt_en_fld, parity_err_cnt_en_fld, router_en_fld} = data;
                     int_en_reg = data[7:4] & 1'b0 & data[2:0];
                     
                         {illegal_addr_cnt_en_fld, addr2_cnt_en_fld, addr1_cnt_en_fld, addr0_cnt_en_fld} = data[7:4];
			{len_err_cnt_en_fld, parity_err_cnt_en_fld, router_en_fld} = data[2:0];
                    // $display("<<<LKB DEBUG Writing EN_REG = data %h int_en_reg", data,int_en_reg);
                   
                  end // en write
               	  YIEN_REG_OFF: begin
                     { illegal_pkt_addr_ien_fld, ovrsized_pkt_ien_fld, parity_ien_fld} = data;
                     ien_reg = { 5'h0,illegal_pkt_addr_ien_fld, ovrsized_pkt_ien_fld, parity_ien_fld} ;
                  end
                  YINT_REG_OFF : begin
               
                      if ((parity_ien_fld) && (data[0] == 1'b1) && (int_stat[0]) ) begin
                          parity_int_fld = 0;
                          int_clr_int[0] = 1;
                      end
                      if ((ovrsized_pkt_ien_fld) && (data[1] == 1'b1) && (int_stat[1]))begin 
                         ovrsized_pkt_int_fld = 0;
                         int_clr_int[1] = 1;
                      end
                      if ((illegal_pkt_addr_ien_fld) && (data[2] == 1'b1) && (int_stat[2])) begin
                         illegal_pkt_addr_int_fld = 0;
                         int_clr_int[2] = 1;
                      end
                      int_reg = {parity_int_fld, ovrsized_pkt_int_fld,illegal_pkt_addr_int_fld};
                  end //int status
           
                  YRESET_REG_OFF: begin
                    {rst_ram_fld, rst_ien_stat_fld, rst_addr_cnts_fld, rst_err_cnts_fld, rst_yapp_fld}
                       = data;            
                     reset_reg = data;
                    end // rst_reg
                 endcase
              end // write 
           endcase // case(wr_rd)
          end // of the Register decodes
         // Now check for the rw memory
         if (addr[15:8] == (YAPP_MEM_RW_START  >> 8)) begin 
         
            case (wr_rd) 
             0 : begin //read
               
                 int_data = memory[addr[7:0]];

                  

             end //read
             1: begin //write
                `ifdef INJECT_ERROR
                   if (addr[7:0] == 'h0f)
                     memory[addr[7:0]] <= ~data;
                   else
                `endif
                memory[addr[7:0]] = data;
             end
            
           endcase
         end // memory rd/write decode

         end // the else for base registers -- not a RO mem read
       end // addr range check -- okay go into decode.
      end // if (en)
   end // always @ (posedge clock)

   task reset_mem ();
     integer i;
     begin
       i = 0;
       while (i <  YAPP_MEM_RO_SIZE+1) begin
         last_pkt_mem[i] = 0;
         i = i+ 1;
        end
     end
    endtask
endmodule // host_ctl
   
module fifo (input clock,   
             input reset,
             input write_enb, 
             input read_enb,  
             input [7:0] in_data, 
             input [4:0] resets, 
             output reg [7:0] data_out,  
             output empty,   
             output almost_empty,   
             output full);

// Internal Signals
   reg [7:0] ram[0:15];   // FIFO Memory
   reg       tmp_empty;
   reg       tmp_full;
   reg [3:0] write_ptr; 
   reg [3:0] read_ptr; 

// Continuous assignments
   assign empty = tmp_empty;
   assign almost_empty = (write_ptr == read_ptr + 4'b1) && !write_enb;
   assign full  = tmp_full;
//   assign data_out = ram[read_ptr];

always @(posedge clock) begin
   data_out <= ram[read_ptr];
end

// Processes 

   always @(negedge clock or posedge reset )
   if ((reset || resets[0])) begin
      write_ptr <= 0; 
      tmp_full <= 1'b0;
      tmp_empty <= 1'b1;
      write_ptr <= 4'b0;
      read_ptr <= 4'b0;
   end
   else begin : fifo_core
     // Read and Write at the same time when empty
     if ((read_enb == 1'b1) && (write_enb == 1'b1) && (tmp_empty == 1'b1)) begin
       ram[write_ptr] <= in_data;
       write_ptr <= (write_ptr + 4'b1);
       tmp_empty <= 0;
     end
     // Read and Write at the same time when not empty
     else if ((read_enb == 1'b1) && (write_enb == 1'b1) && (tmp_empty == 1'b0)) begin
       ram[write_ptr] <= in_data;
       read_ptr <= (read_ptr + 4'b1);
       write_ptr <= (write_ptr + 4'b1);
     end
     // Write
     else if (write_enb == 1'b1) begin
       tmp_empty <= 1'b0;
       if (tmp_full == 1'b0) begin
         ram[write_ptr] <= in_data;
         write_ptr <= (write_ptr + 4'b1);
       end
       if ((read_ptr == write_ptr + 4'b1) && (read_enb == 1'b0)) begin
         tmp_full <= 1'b1;
       end
     end
     // Read
     else if (read_enb == 1'b1) begin
       if (tmp_empty == 1'b0) begin
         read_ptr <= (read_ptr + 4'b1);
       end
       if ((tmp_full == 1'b1) && (write_enb == 1'b0)) begin
         tmp_full <= 1'b0;
       end
       if ((write_ptr == read_ptr + 4'b1) && (write_enb == 1'b0)) begin
         tmp_empty <= 1'b1;
       end
     end
   end

endmodule //fifo

//****************************************************************************/

`define HEADER_WAIT  2'b00
`define DATA_LOAD    2'b01
`define DUMP_PKT     2'b10

module port_fsm (//FSM Control Signals
                 input clock,       
                 input reset,
                 input hold,        
                 input fifo_empty,    
                 output reg   error,

                 // Host Interface Registers
                 input [4:0] resets,		//get reset values
                 input en_reg_t router_enable,	//get router_enables
                 input [5:0] max_pkt_size,	//get max_pkt_size to fsm_core
                 input [3:0] intr_clr,		//get the clr bits of the current W1 of the int reg
                 input [5:0] last_pkt_size,     //send the last pkt received size 
                 input [7:0] parity_err_cnt,	//send the parity error counts
                 input [7:0] len_err_cnt,	//send the length pkt exceed counts
                 input [7:0] ill_addr_cnt,	//send the illegal address counts
                 input [3:0] intr_stat,  	//send the current interrupt status
                 input [3:0] intr_ien,		//get the current interrupt enables
                 // Host Channel Counts Registers
                 input [7:0] addr0_cnt,		//get the addr0 packet counts
                 input [7:0] addr1_cnt,		//get the addr1 packet counts
                 input [7:0] addr2_cnt,		//get the addr2 packet counts
                 input [6:0] pkt_addr,          // packet address pointer in last packet
                 input [7:0] pkt_data,          // contents of data at curr pkt_addr
                 input [7:0] parity_out,        // send the parity back to the host
                 input parity_done,             // send that the parity has been calculated
                 input pkt_start, 		// start of pkt -held high while pkt is valid
                 // Input Port Data
                 input  [7:0] in_data,      
                 input  in_data_vld,    
                 output in_suspend, 
`ifdef INT_SUPPORT
                 output parity_intr,
                 output ovrsized_pkt_intr,
                 output illegal_pkt_addr_intr,
`endif
                 // Output Port Data
                 output     [1:0] addr,
                 output     [7:0] chan_data,
                 output     [2:0] write_enb);     
                
// Internal Signals
reg    [2:0] write_enb_r;
reg          fsm_write_enb;
reg    [1:0] state_r, state;
reg    [7:0] parity;
reg          sus_data_in;
reg    [1:0] dest_chan_r;
reg    [7:0] parity_err_cnt_int;
reg    [7:0] len_err_cnt_int;
reg    [7:0] ill_addr_cnt_int;
reg    [7:0] addr0_cnt_int;
reg    [7:0] addr1_cnt_int;
reg    [7:0] addr2_cnt_int;
reg    [3:0] intr_stat_int;
reg    [6:0] pkt_addr_int;
reg    [7:0] pkt_data_int;
reg          parity_done_int;
reg    [7:0] parity_out_int;
reg          pkt_start_int;
reg          illegal_addr_int;
reg    [7:0] last_pkt_size_int;
reg          parity_intr_int;
reg          illegal_pkt_addr_intr_int;
reg          ovrsized_pkt_intr_int;

//Continuous Assignments
  assign ill_addr_cnt = ill_addr_cnt_int;
  assign len_err_cnt = len_err_cnt_int;
  assign parity_err_cnt = parity_err_cnt_int;
  assign addr0_cnt = addr0_cnt_int;
  assign addr1_cnt = addr1_cnt_int;
  assign addr2_cnt = addr2_cnt_int;
  assign intr_stat = intr_stat_int;
  assign pkt_addr = pkt_addr_int;
  assign pkt_data = pkt_data_int;
  assign in_suspend = sus_data_in;
  assign parity_done = parity_done_int;
  assign parity_out = parity_out_int;
  assign last_pkt_size = last_pkt_size_int;
  assign pkt_start = pkt_start_int;
`ifdef INT_SUPPORT
  assign parity_intr = parity_intr_int;
  assign ovrsized_pkt_intr = ovrsized_pkt_intr_int;
  assign illegal_pkt_addr_intr = illegal_pkt_addr_intr_int; 
`endif

  wire [1:0] dest_chan = ((state_r == `HEADER_WAIT) && (in_data_vld == 1'b1)) ? in_data : dest_chan_r;

  assign addr = dest_chan;

  wire chan0 = dest_chan == 2'b00 ? 1'b1 : 1'b0;
  wire chan1 = dest_chan == 2'b01 ? 1'b1 : 1'b0;
  wire chan2 = dest_chan == 2'b10 ? 1'b1 : 1'b0;

  assign chan_data = in_data;
  assign write_enb[0] = chan0 & fsm_write_enb;
  assign write_enb[1] = chan1 & fsm_write_enb;
  assign write_enb[2] = chan2 & fsm_write_enb;

  wire header_valid = (state_r == `HEADER_WAIT) && (in_data_vld == 1'b1);

 
  always @(negedge clock or posedge reset) 
  begin : fsm_state
    if ((reset) || (resets[0])) begin 
      state_r <= `HEADER_WAIT;
      dest_chan_r <= 2'b00;
      addr0_cnt_int <= 8'h00;
      addr1_cnt_int <= 8'h00;
      addr2_cnt_int <= 8'h00;
      len_err_cnt_int <= 8'h00;
      ill_addr_cnt_int <= 8'h00;
      parity_err_cnt_int <= 8'h00;
      intr_stat_int <= 8'h00;
      pkt_addr_int <= 8'h00;
      pkt_data_int <= 8'h00;
      illegal_addr_int <= 1'b0;
      last_pkt_size_int <= 6'h00;
      parity_intr_int <= 1'b0;
      illegal_pkt_addr_intr_int <= 1'b0;
      ovrsized_pkt_intr_int <= 1'b0;

    end
    else begin
      // check for error count resets
      if (resets[1]) begin
        len_err_cnt_int <= 8'h00;
        ill_addr_cnt_int <= 8'h00;
        parity_err_cnt_int <= 8'h00;
        illegal_addr_int <= 1'b0;
      end
      if (resets[2]) begin
        addr0_cnt_int <= 8'h00;
        addr1_cnt_int <= 8'h00;
        addr2_cnt_int <= 8'h00;
      end
      if (resets[3]) begin
        intr_stat_int <= 8'h00;
        parity_intr_int <= 1'b0;
        illegal_pkt_addr_intr_int <= 1'b0;
        ovrsized_pkt_intr_int <= 1'b0;


      end
      if (intr_clr[0]) begin
         intr_stat_int[0] <= 0;
         parity_intr_int <= 0;
      end
      if (intr_clr[1]) begin
         intr_stat_int[1] <= 0;
         ovrsized_pkt_intr_int <= 0;
      end
      if (intr_clr[2]) begin 
         intr_stat_int[2] <= 0;
         illegal_pkt_addr_intr_int <= 0;
      end

      if (resets[4]) begin
         pkt_addr_int <= 8'h00;
         pkt_data_int <= 8'h00;
      end


      state_r <= state;
      if ((state_r == `HEADER_WAIT) && (in_data_vld == 1'b1))
        dest_chan_r <= in_data[1:0];
    end
  end //fsm_state;

  always @(state_r or in_data_vld or in_data or max_pkt_size or fifo_empty or hold) 
  begin
      state = state_r;   //Default state assignment
      sus_data_in = 1'b0;
      fsm_write_enb = 1'b0;
    
      //$display(" <<<LKB Waiting for packet router_en = %h>>>", router_enable); 
      case (state_r) 
      `HEADER_WAIT : begin
                      sus_data_in = !fifo_empty && in_data_vld;
                      pkt_start_int <= 1'b0;
                      parity_done_int <= 1'b0;
                      illegal_addr_int <= 1'b0;
                      if (in_data_vld == 1'b0) 
                        state = `HEADER_WAIT;      // stay in state if data not valid

                      // LKB 3/13: For some reason I no longer cannot get a
                      // max packet error, instead I always get a illegal
                      // address error, so I moved the oversized packet above
                      // the illegal address error -- doesn't make sense
                      // both errors happen and the router drops packet
                      else if  (in_data[1:0] == 2'b11) begin		// error length  
                        state = `DUMP_PKT;      // invalid length or illegal address
                        $display("ROUTER DROPS PACKET - ADDRESS is %0d",in_data[1:0]);
                        if (router_enable.illegal_addr_cnt_en_fld && !resets[1]) begin
                        //if (router_enable[7] && !resets[1]) begin
                            illegal_addr_int <= 1;
                            ill_addr_cnt_int <= ill_addr_cnt_int + 1; 
                             if (intr_ien[2]) begin
                 		intr_stat_int[2] <= 'b1;
 				illegal_pkt_addr_intr_int <= 1'b1;
                             end
                        end
                      end
                      else if ((in_data[7:2] > max_pkt_size[5:0]) || (in_data[7:2] < 1)) begin	
                        state = `DUMP_PKT;      // invalid length or illegal address
                        $display("ROUTER DROPS PACKET - LENGTH is %0d, MAX is %0d",in_data[7:2],max_pkt_size[5:0]);
                        // Update the max packet error if it is in the router ctr bit
                        if (router_enable.len_err_cnt_en_fld && !resets[1])begin
                           //$display("LKB DBG Counter will be incremented - LENGTH is %0d, MAX is %0d",in_data[7:2],max_pkt_size[5:0]);

                           len_err_cnt_int <= len_err_cnt_int + 1;  
                           if (intr_ien[1]) begin
                 	      intr_stat_int[1] <= 1'b1;
                              ovrsized_pkt_intr_int <= 1'b1;

                           end
                        end
                        else if (router_enable.router_en_fld == 1'b0) begin
                           state = `DUMP_PKT;
                           $display("ROUTER DISABLED -- DROPPING PACKET");
                        end

                      end
                      else if (fifo_empty == 1'b1) begin
                          //$display("<<<LKB  Good packet counting Router_en =%h  in_data = %h  resets[2]%h ", 
                           //    router_enable, in_data[1:0],resets[2]                               );
                        // update the address count registers 0, 1, &2
                        if ((router_enable[4])&& (in_data[1:0] == 2'b00) && (!resets[2]))begin
                         // $display("<<<LKB updating addr0 ");
                           addr0_cnt_int <= addr0_cnt_int + 1;
                        end
                        if ((router_enable.addr1_cnt_en_fld) && (in_data[1:0] == 2'b01) && (!resets[2])) begin
                            //$display("<<<LKB updating addr1 ");

                           addr1_cnt_int <= addr1_cnt_int + 1;
                        end
                        if ((router_enable.addr2_cnt_en_fld) && (in_data[1:0] == 2'b10) && (!resets[2])) begin
                           // $display("<<<LKB updating addr2 ");

                           addr2_cnt_int <= addr2_cnt_int + 1;
                        end
                        state = `DATA_LOAD;     // load good packet
                        fsm_write_enb = 1'b1;
                        end
                      else
                        state = `HEADER_WAIT;  // input suspended, fifo not empty - stay in state
                    end // case: HEADER_WAIT
             
        `DUMP_PKT  : begin
                       if (in_data_vld == 1'b0)
                           state = `HEADER_WAIT;
                     end
        `DATA_LOAD : begin
                       sus_data_in = hold;
//                       sus_data_in = hold && in_data_vld;
                       if (in_data_vld == 1'b0) begin
                         state = `HEADER_WAIT;
                         fsm_write_enb = 1'b1;
                       end
                       else begin
                         fsm_write_enb = !hold;
                       end
                     end // case: DATA_LOAD
         default: state = `HEADER_WAIT;
  
       endcase
  end //fsm_core

  always @(negedge clock or posedge reset)
  begin
    if ((reset || resets[0]) ) begin : parity_calc
       parity <= 8'b0000_0000;
       parity_done_int <= 0;
                           
       // parity error for this packet set to 0
       error <=1'b0;
       illegal_addr_int <= 0;
    end // if reset
    else begin  // out of reset
      // valid data coming in -- but don't accept data if illegal address
      if ((in_data_vld == 1'b1) && (sus_data_in == 1'b0))  begin
         error <= 1'b0;
         parity <= parity ^ in_data;
     
        pkt_data_int <= in_data;
        parity_out_int <= parity;
        //LKB Added this back into support last_pkt_mem
        if ((pkt_start_int == 1'b0) && !(resets[4])) begin
               pkt_addr_int <= 8'h00;
               last_pkt_size_int <= in_data[7:2];
               pkt_start_int <= 1'b1;
        end
        else if ((pkt_start_int == 1'b1) && !(resets[4]) &&  (pkt_addr_int < last_pkt_size_int + 1) ) begin
               pkt_addr_int <= pkt_addr_int + 1;
        end
       end // else in_data_vld = 1
       else if (in_data_vld == 1'b0) begin
          if ((state_r == `DATA_LOAD) && (parity != in_data)) begin
             error <= 1'b1;
             $display("*** ROUTER (DUT) Parity Error Identified: Expected:%h Computed:%h ***", in_data, parity);
             pkt_data_int <= in_data;
             if (router_enable.parity_err_cnt_en_fld && !resets[1]) begin
                parity_err_cnt_int <= parity_err_cnt_int + 1;
             if (intr_ien[0]) begin
               intr_stat_int[0] <= 1'b1;
               parity_intr_int <= 1'b1;
            end  // intr_ien
            parity_done_int <= 1'b1;
          end // state
          parity <= 8'b0000_0000; 
        end //in_data_vld == 0
        else begin
           error <= 1'b0;
           parity <= 8'b0000_0000;
           pkt_addr_int <= 8'h00;
           pkt_data_int <= 8'h00;
           parity_done_int <= 1'b0;
           pkt_start_int <= 0;
           illegal_addr_int <= 1'b0;
        end // else
      end// not in reset
 end //parity_calc
`ifdef NO_WORK
        //added code for ram and interrupts
        if ((pkt_start_int == 1'b0) && !(resets[4]) ) begin
            pkt_addr_int <= 8'h00;
            last_pkt_size_int <= in_data[7:2];
            pkt_start_int <= 1'b1;
        end // pkt_start_int and reset
        else if ((pkt_start_int == 1'b1) &&  !(resets[4]) && (pkt_addr_int < last_pkt_size_int + 1)) begin
             pkt_addr_int <= pkt_addr_int + 1;
        end // increase pkt address for the ram
        parity_out_int <= in_data;
        parity_done_int <= 1'b1;
        pkt_data_int <= in_data;
      end // in_data valid =0
      else begin 
          error <= 1'b0;
          parity <= 8'b0000_0000;
          pkt_addr_int <= 8'h00;
          pkt_data_int <= 8'h00;
          parity_done_int <= 1'b1;
          pkt_start <= 0;
          illegal_addr_int <= 1'b0;
      end
   end //else begin
`endif
`ifdef NOT_WORKING
        // deal with start of packet for memory --which isn't being used in
        // the fundamental class
        if ((pkt_start_int == 1'b0) && !(resets[4]) ) begin
            pkt_addr_int <= 8'h00;
            last_pkt_size_int <= in_data[7:2];
            pkt_start_int <= 1'b1;
        end // pkt_start_int and reset
        else if ((pkt_start_int == 1'b1) &&  !(resets[4]) && (pkt_addr_int < last_pkt_size_int + 1)) begin
             pkt_addr_int <= pkt_addr_int + 1;
         end // increase pkt address for the ram
         //update the host_ctrl parrity error count reg, if the parity error
     //count  is enabled and the reset error count is not high
      
     if (router_enable[1] && !resets[1]) begin
        parity_err_cnt_int <= parity_err_cnt_int + 1;
        if (intr_ien[0]) begin
              intr_stat_int[0] <= 1'b1;
         end  // intr_ien
      end // router_en
      parity_out_int <= in_data;
      parity_done_int <= 1'b1;
      pkt_data_int <= in_data;
        
      error <= 1'b0;
      parity <= 8'b0000_0000;
      pkt_addr_int <= 8'h00;
      pkt_data_int <= 8'h00;
      parity_done_int <= 1'b1;
      pkt_start_int <= 0;
      illegal_addr_int <= 1'b0;
     end //in_data_vld
   
    end //else begin
`endif
  end //parity_calc;

endmodule //port_fsm

//****************************************************************************/

module yapp_router (input clock,                              
                    input reset,                            
                    output error,

                    // Input channel
                    input [7:0] in_data,                           
                    input in_data_vld,                     
                    output in_suspend,
`ifdef INT_SUPPORT
                    output parity_intr,
                    output ovrsized_pkt_intr,
                    output illegal_pkt_addr_intr,
`endif
                    // Output Channels
                    output [7:0] data_0,  //Channel 0
                    output reg data_vld_0, 
                    input suspend_0, 
                    output [7:0] data_1,  //Channel 1
                    output reg data_vld_1, 
                    input suspend_1, 
                    output [7:0] data_2,  //Channel 2
                    output reg data_vld_2,
                    input suspend_2,
     
                    // Host Interface Signals
                    input [15:0] haddr,
                    inout [7:0] hdata,
                    input hen,
                    input hwr_rd);                            

// Internal Signals
wire     full_0;
wire     full_1;
wire     full_2;
wire     empty_0;
wire     empty_1;
wire     empty_2;
wire     almost_empty_0;
wire     almost_empty_1;
wire     almost_empty_2;
wire     fifo_empty;
wire     fifo_empty0;
wire     fifo_empty1;
wire     fifo_empty2;
wire     hold_0;
wire     hold_1;
wire     hold_2;
wire     hold;
wire   [2:0] write_enb;
wire   [1:0] addr;
wire   [7:0] router_enable;
wire [5:0]   max_pkt_size;
wire [7:0] chan_data;
wire [7:0] parity_err_cnt;
wire [7:0] len_err_cnt;
wire [7:0] ill_addr_cnt;
wire [7:0] addr0_cnt;
wire [7:0] addr1_cnt;
wire [7:0] addr2_cnt;
wire [4:0] resets;
wire [3:0] intr_stat;
wire [3:0] intr_ien;
wire [3:0] intr_clr;
wire [6:0] pkt_addr;
wire [7:0] pkt_data;
wire [7:0] parity_out;
wire       parity_done;
wire       pkt_start;
wire [5:0] last_pkt_size;

// Continuous Assignments
always @(posedge clock or posedge reset) begin
  if ((reset) || resets[0]) begin
    data_vld_0 <= 1'b0;
    data_vld_1 <= 1'b0;
    data_vld_2 <= 1'b0;
    //LKB move internal count reset here
  end
  else begin
    data_vld_0 <= !empty_0 && !almost_empty_0;
    data_vld_1 <= !empty_1 && !almost_empty_1;
    data_vld_2 <= !empty_2 && !almost_empty_2;
  end
end
  
  assign fifo_empty0 = (empty_0 | ( addr[1] |  addr[0]));     //addr!=00
  assign fifo_empty1 = (empty_1 | ( addr[1] | !addr[0]));     //addr!=01
  assign fifo_empty2 = (empty_2 | (!addr[1] |  addr[0]));     //addr!=10

  assign fifo_empty  = fifo_empty0 & fifo_empty1 & fifo_empty2;

  assign hold_0 = (full_0 & (!addr[1] & !addr[0]));   //addr=00
  assign hold_1 = (full_1 & (!addr[1] &  addr[0]));   //addr=01
  assign hold_2 = (full_2 & ( addr[1] & !addr[0]));   //addr=10
        
  assign hold   = hold_0 | hold_1 | hold_2;

  host_ctl reg_file (.clock (clock),
                  .reset (reset),
                  .addr  (haddr),
                  .data  (hdata),
                  .en    (hen),
                  .wr_rd (hwr_rd),
                  .parity_err_cnt (parity_err_cnt),
                  .len_err_cnt (len_err_cnt),
                  .ill_addr_cnt (ill_addr_cnt),
		  .addr0_cnt (addr0_cnt),
		  .addr1_cnt (addr1_cnt),
		  .addr2_cnt (addr2_cnt),
                  .int_stat  (intr_stat),
                  .int_clr   (intr_clr),
                  .pkt_addr  (pkt_addr),
                  .pkt_data  (pkt_data),
                  .last_pkt_size (last_pkt_size),
                  .parity_done (parity_done),
                  .pkt_start (pkt_start),
                  .parity    (parity_out),
                  .int_ien_reg (intr_ien),
                  .rst_reg (resets),
                  .en_reg (router_enable),
                  .max_pkt_len (max_pkt_size));
        
//Input Port FSM
  port_fsm in_port (.clock         (clock),          
                    .reset         (reset),
                    .in_suspend    (in_suspend),
`ifdef INT_SUPPORT
                    .parity_intr   (parity_intr),
                    .ovrsized_pkt_intr (ovrsized_pkt_intr),
		    .illegal_pkt_addr_intr (illegal_pkt_addr_intr),
`endif
                    .error         (error),            
                    .write_enb     (write_enb),      
                    .fifo_empty    (fifo_empty),     
                    .hold          (hold),           
                    .in_data_vld   (in_data_vld),   
                    .in_data       (in_data),        
                    .addr          (addr),
                    .parity_err_cnt (parity_err_cnt),
                    .last_pkt_size  (last_pkt_size),
                    .len_err_cnt   (len_err_cnt),
                    .ill_addr_cnt  (ill_addr_cnt),
		    .addr0_cnt     (addr0_cnt),
		    .addr1_cnt     (addr1_cnt),
		    .addr2_cnt     (addr2_cnt),
                    .intr_stat     (intr_stat),
                    .chan_data     (chan_data),
                    .intr_ien      (intr_ien),
                    .intr_clr      (intr_clr),
                    .pkt_addr      (pkt_addr),
                    .pkt_data      (pkt_data),
                    .parity_done   (parity_done),
                    .pkt_start     (pkt_start),
                    .parity_out    (parity_out),
                    .resets        (resets),
                    .router_enable (router_enable),
                    .max_pkt_size  (max_pkt_size));
  
// Output Channels: 0, 1, 2
  fifo queue_0 (.clock     (clock),
                .reset     (reset),
                .write_enb (write_enb[0]),
                .read_enb  (!suspend_0),
                .in_data   (chan_data),
                .resets    (resets),
                .data_out  (data_0),
                .empty     (empty_0),
                .almost_empty (almost_empty_0),
                .full      (full_0));

  fifo queue_1 (.clock     (clock),
                .reset     (reset),
                .write_enb (write_enb[1]),
                .read_enb  (!suspend_1),
                .in_data   (chan_data),
                .resets   (resets),
                .data_out  (data_1),
                .empty     (empty_1),
                .almost_empty (almost_empty_1),
                .full      (full_1));

  fifo queue_2 (.clock     (clock),
                .reset     (reset),
                .write_enb (write_enb[2]),
                .read_enb  (!suspend_2),
                .in_data   (chan_data),
                .resets   (resets),
                .data_out  (data_2),
                .empty     (empty_2),
                .almost_empty (almost_empty_2),
                .full      (full_2));

endmodule //yapp_router
