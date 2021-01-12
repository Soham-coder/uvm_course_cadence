/*-----------------------------------------------------------------
File name     : hbus_interface.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : HBUS UVC interface for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//  FILE : hbus_if.sv
//------------------------------------------------------------------------------

interface hbus_if (input clock, input reset);
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import hbus_pkg::*;

  // Actual Signals
  logic            hen;
  logic            hwr_rd;
  logic      [15:0] haddr;
  logic      [7:0] hdata;

  // For bi-directional bus on the DUT
  wire [7:0] hdata_w;

  assign hdata_w = hdata;

  // Control flags
  bit                has_checks = 1;
  bit                has_coverage = 1;

  // transaction triggers 
  bit monstart, masterstart, slavestart;

  task master_reset();
      @(posedge reset);
      `uvm_info("HBUS_IF","Master Observed Reset", UVM_MEDIUM)
      hen     <= 'b0;
      hdata   <= 'hz;
      haddr   <= 'hz;
      hwr_rd  <= 'b0;
      masterstart = 1'b0;
  endtask : master_reset

  task slave_reset();
      @(posedge reset);
      `uvm_info("HBUS_IF","Slave Observed Reset", UVM_MEDIUM)
      hdata      <= 'z;
      slavestart = 1'b0;
  endtask : slave_reset

  // Gets a transaction and drive it into the DUT
  task master_send_to_dut(input bit [15:0]           ha,
                                hbus_read_write_enum hrw,
                          inout bit [7:0]            hd,
                          input int unsigned         wait_between_cycle,
                                bit                  random_delay);

    // drive on negedge
    if (random_delay == 1 && wait_between_cycle > 0) begin
      repeat(wait_between_cycle) @(negedge clock);
    end
    else @(negedge clock);  // fixed delay of 1

    masterstart = 1'b1;
    hen   <= 1'b1;
    haddr <= ha;
    
    if (hrw == HBUS_WRITE) begin  // WRITE protocol
      `uvm_info("HBUS_IF",$sformatf("Master writes %h to %0h",hd,ha), UVM_MEDIUM)
      hwr_rd <= 1'b1; 
      hdata  <= hd;
      @(negedge clock);
      hwr_rd <= 1'b0; 
      hen   <= 1'b0;
      hdata  <= 'z;
    end 
    else begin  // READ protocol
      hwr_rd <= 1'b0; 
      //@(posedge clock);
      //#0 hdata  <= hdata_w;
      @(negedge clock);
      @(negedge clock);
      hd = hdata_w;
      `uvm_info("HBUS_IF",$sformatf("Master reads %h from %0h",hd,ha), UVM_MEDIUM)
      hen   <= 1'b0;
      //@(posedge clock);
    end 
    masterstart = 1'b0;
  endtask : master_send_to_dut

  task slave_send_to_dut(output bit [15:0]           ha,
                                hbus_read_write_enum hrw,
                         inout  bit [7:0]            hd,
                                bit [7:0]            max_pktsize_reg,
                                bit [7:0]            router_enable_reg);
    
      @(posedge clock iff hen)
      slavestart = 1'b1;
      
      if (hwr_rd == 0) begin  // READ
        ha = haddr;
        hrw = HBUS_READ;
        //@(posedge clock)
        case (haddr)
         16'h1000: hdata = max_pktsize_reg;
         16'h1001: hdata = router_enable_reg;
         default: begin
                  `uvm_info("HBUS_IF", "Slave Found Unmapped Register Read Address", UVM_MEDIUM)
                  //hdata = hbus_memory[haddr];
                  end 
        endcase
        hd = hdata;
        @(posedge clock iff !hen)
          hdata = 'z;
      end 
      else begin   // WRITE
        ha = haddr;
        hd = hdata;
        hrw = HBUS_WRITE;
        // Update contents of registers
        case (haddr)
         16'h1000: max_pktsize_reg = hdata;
         16'h1001: router_enable_reg = hdata;
         default: begin
                  `uvm_info("HBUS_IF", "Slave Found Unmapped Register Write Address", UVM_MEDIUM)
                  //hbus_memory[haddr] = hdata;
                  end 
        endcase
        @(posedge clock iff !hen);
      end
      slavestart = 1'b0;
  endtask : slave_send_to_dut

  task collect_packet(output bit [15:0]           ha,
                             hbus_read_write_enum hrw,
                             bit [7:0]            hd);

      @(posedge clock iff hen) 
      // trigger transaction
      monstart = 1'b1;
     
        if (hwr_rd == 1) begin //WRITE cycle
          `uvm_info("HBUS_IF", "Monitor Write Transaction", UVM_MEDIUM)
          ha = haddr;
          hd = hdata;
          hrw = HBUS_WRITE;
          @(posedge clock);
        end
        else if (hwr_rd == 0) begin //READ cycle
          `uvm_info("HBUS_IF", "Monitor Read Transaction", UVM_MEDIUM)
          ha = haddr;
          hrw = HBUS_READ;
          @(posedge clock);
          hd = hdata_w;
          @(posedge clock);
        end
        else
          `uvm_info("HBUS_IF", $sformatf("Monitor Bad hwr_rd: %b", hwr_rd), UVM_MEDIUM)

      // end transaction
      monstart = 1'b0;

    endtask: collect_packet 

  // Gets a transaction and drive it into the DUT
  // Coverage and assertions to be implemented here.

  /************************************************************************
   Add assertion checks as required. See assertion examples below.
   ************************************************************************/
/*
   
// SVA default clocking
wire uvm_assert_clk = clock & has_checks;
default clocking master_clk @(negedge uvm_assert_clk);
endclocking

// SVA default reset
default disable iff (reset);

  // Address must not be X or Z during Address Phase
  assertAddrUnknown:assert property (
     ($onehot(hen) |-> !$isunknown(haddr))) else
     `uvm_error("HBUS Interface","Address went to X or Z during Address Phase")
 
  // If write cycle, then enable must be 1
  input_write_then_enabled : assert property (
     (hwr_rd |-> hen)) else 
     `uvm_error("HBUS Interface","Write enable asserted when not enabled")

  // If read cycle, then enable must be two cycles long
  input_read_then_enable_2_cycles : assert property (
     ($rose(hen) && !hwr_rd |=> hen)) else
     `uvm_error("HBUS Interface","Enable not 2 cycles long for read")
  
  // If read cycle, then address must remain stable 1 clock cycle
  input_read_then_address_stable : assert property (
     ($rose(hen) && !hwr_rd |=> $stable(haddr))) else
     `uvm_error("HBUS Interface","Address not stable during read")
*/
endinterface : hbus_if


