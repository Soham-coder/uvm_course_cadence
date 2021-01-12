/*-----------------------------------------------------------------
File name     : demo_tb.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : Demo testbench for the Channel UVC for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015 
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: demo_tb
//
//------------------------------------------------------------------------------

class demo_tb extends uvm_env;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(demo_tb)

  // channel environment
  channel_env chan0;

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);

endclass : demo_tb

  // UVM build_phase
  function void demo_tb::build_phase(uvm_phase phase);
    super.build_phase(phase);
    chan0 = channel_env::type_id::create("chan0", this);
  endfunction : build_phase

