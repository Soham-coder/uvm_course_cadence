/*-----------------------------------------------------------------
File name     : clock_and_reset_demo_tb.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : Demo testbench for Clock&Reset UVC for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: clock_and_reset_demo_tb
//
//------------------------------------------------------------------------------

class clock_and_reset_demo_tb extends uvm_env;

  `uvm_component_utils(clock_and_reset_demo_tb)

  clock_and_reset_env clock_and_reset;

  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);

endclass : clock_and_reset_demo_tb

  function void clock_and_reset_demo_tb::build_phase(uvm_phase phase);
    super.build_phase(phase);
    clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);
  endfunction : build_phase

