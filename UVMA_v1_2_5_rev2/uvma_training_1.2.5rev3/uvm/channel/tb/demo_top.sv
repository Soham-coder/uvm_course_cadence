/*-----------------------------------------------------------------
File name     : demo_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : Demo top module for Channel UVC for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015 
-----------------------------------------------------------------*/

module demo_top;

  // UVM class library compiled in a package
  import uvm_pkg::*;

  // Bring in the rest of the library (macros and template classes)
  `include "uvm_macros.svh"

  // CHANNEL OVC Files
  import channel_pkg::*;

  `include "demo_tb.sv"
  `include "test_lib.sv"

  // clock, reset are generated here for this DUT
  reg reset;
  reg clock; 

  // channel Interface to the DUT
  channel_if ch0(clock, reset);

  initial begin
    channel_vif_config::set(null,"*.tb.chan0.*","vif", ch0);
    run_test();
  end

  initial begin
    reset <= 1'b1;
    clock <= 1'b1;
    #51 reset = 1'b0;
  end

  //Generate Clock
  always
    #50 clock = ~clock;

endmodule
