/*-----------------------------------------------------------------
File name     : top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab05_seq top module
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;
  
  // import the UVM library
  import uvm_pkg::*;

  // include the UVM macros
  `include "uvm_macros.svh"

  // import the YAPP package
  import yapp_pkg::*;

  // include the testbench and test library files
  `include "router_tb.sv"
  `include "router_test_lib.sv"

  initial
    run_test();

endmodule : top
