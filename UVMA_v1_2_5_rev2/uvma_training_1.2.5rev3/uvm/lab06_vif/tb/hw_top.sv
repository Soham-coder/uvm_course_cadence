/*-----------------------------------------------------------------
File name     : hw_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif hardware top module for acceleration
              : Instantiates clock generator and YAPP interface only for testing - no DUT
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module hw_top;

  // Clock and reset signals
  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;

  // YAPP Interface to the DUT
  yapp_if in0(clock, reset);

  // CLKGEN module generates clock
  clkgen clkgen (
    .clock(clock),
    .run_clock(1'b1),
    .clock_period(32'd10)
  );

  initial begin
    reset <= 1'b0;
    in0.in_suspend <= 1'b0;
    @(negedge clock)
      #1 reset <= 1'b1;
    @(negedge clock)
      #1 reset <= 1'b0;
  end

endmodule
