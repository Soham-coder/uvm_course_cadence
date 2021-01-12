/*-----------------------------------------------------------------
File name     : yapp_if.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : yapp UVC interface from lab07_integ for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

interface yapp_if (input clock, input reset );
timeunit 1ns;
timeprecision 100ps;

import uvm_pkg::*;
`include "uvm_macros.svh"

import yapp_pkg::*;

  // Actual Signals
  logic              in_data_vld;
  logic              in_suspend;
  logic       [7:0]  in_data;

  // signal for transaction recording
  bit monstart, drvstart;

  // local storage for payload
  logic [7:0] payload_mem [0:63];
  
  task yapp_reset();
    @(posedge reset);
    in_data           <=  'hz;
    in_data_vld       <= 1'b0;
    disable send_to_dut;
  endtask
  
  // Gets a packet and drive it into the DUT
  task send_to_dut(input bit [5:0]  length,
                         bit [1:0]  addr,
                         bit [7:0]  parity,
                         int packet_delay);

    // Wait for packet delay
    repeat(packet_delay)
      @(negedge clock);

    // Start to send packet if not in_suspend signal
    @(negedge clock iff (!in_suspend));

    // trigger for transaction recording
    drvstart = 1'b1;
    // Enable start packet signal
    in_data_vld <= 1'b1;

    // Drive the Header {Length, Addr}
    in_data <= { length, addr };

    // Drive Payload
    //foreach (payload [i]) begin
    for(int i=0; i< length; i++) begin //each (payload [i]) begin
      @(negedge clock iff (!in_suspend))
      in_data <= payload_mem[i];
    end
    // Drive Parity and reset Valid
    @(negedge clock iff (!in_suspend))
    in_data_vld <= 1'b0;
    in_data  <= parity;

    @(negedge  clock)
      in_data  <= 8'bz;

    // reset trigger
    drvstart = 1'b0;
  endtask : send_to_dut

  // Collect Packets
  task collect_packet(output bit [5:0]  length,
                         bit [1:0]  addr,
                         bit [7:0]  payload[],
                         bit [7:0]  parity);
      //Monitor looks at the bus on posedge (Driver uses negedge)
      //@(posedge in_data_vld);

      @(posedge clock iff (!in_suspend & in_data_vld))
      // trigger for transaction recording
      monstart = 1'b1;

      `uvm_info("YAPP_IF", "collect packets", UVM_HIGH)
      // Collect Header {Length, Addr}
      { length, addr }  = in_data;
      payload = new[length]; // Allocate the payload
      // Collect the Payload
      foreach (payload [i]) begin
         @(posedge clock iff (!in_suspend))
         payload[i] = in_data;
      end

      // Collect Parity and Compute Parity Type
       @(posedge clock iff !in_suspend)
         parity = in_data;
      // reset trigger
      monstart = 1'b0;
  endtask : collect_packet


// If the channel suspend ports are incorrectly connected/driven
// the YAPP input will be suspended and the simulation could hang.
// This assertion checks for this and raises a (non-UVM) error message
  property yapp_suspended;
    @(posedge clock) !in_suspend ##1 in_suspend[*20] |=> !in_suspend;
  endproperty

  YAPP_SUSPENDED: assert property (yapp_suspended)
      else
      begin
        $display("\n**Assertion Error - YAPP interface is suspended: Check channel suspend ports!\n");
        $finish;
      end


endinterface : yapp_if

