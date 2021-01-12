/*-----------------------------------------------------------------
File name     : hbus_demo_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : Demo top module for HBUS UVC for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

`timescale 1ns/1ns

module demo_top;

  // UVM class library compiled in a package
  import uvm_pkg::*;

  // Bring in the rest of the library (macros and template classes)
  `include "uvm_macros.svh"

  import hbus_pkg::*;
  `include "hbus_demo_tb.sv"
  `include "hbus_test_lib.sv"
  
  bit reset, clock;

  hbus_if hif(clock, reset);
  
  initial begin
    hbus_vif_config::set(null,"*.tb.hbus.*","vif", hif);
    run_test();
  end

  initial begin
    reset <= 1'b0;
    clock <= 1'b1;
    #15 reset <= 1'b1;
    #51 reset = 1'b0;
  end

  //Generate Clock
  always
    #5 clock = ~clock;

endmodule
