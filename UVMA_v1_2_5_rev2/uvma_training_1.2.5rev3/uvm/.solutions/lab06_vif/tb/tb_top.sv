/*-----------------------------------------------------------------
File name     : tb_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif UVM top module for acceleration
              : Instantiates UVM test environment
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;

  // import the UVM library
  import uvm_pkg::*;

  // include the UVM macros
  `include "uvm_macros.svh"

  // import the YAPP UVC package
  import yapp_pkg::*;

  // include the router testbench file
  `include "router_tb.sv"

  // include the test_lib.sv file
  `include "router_test_lib.sv"

  initial begin
    yapp_vif_config::set(null,"*.tb.yapp.tx_agent.*","vif", hw_top.in0);
    run_test();
  end

endmodule
