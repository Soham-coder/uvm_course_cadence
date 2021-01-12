/*-----------------------------------------------------------------
File name     : hbus_demo_tb.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : Demo testbench for HBUS UVC for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: hbus_demo_tb
//
//------------------------------------------------------------------------------

class demo_tb extends uvm_env;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(demo_tb)

  // hbus environment
  hbus_env hbus;

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);

endclass : demo_tb

  // UVM build() phase
  function void demo_tb::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_int::set(this, "hbus", "num_masters", 1);
    uvm_config_int::set(this, "hbus", "num_slaves", 1);
    hbus = hbus_env::type_id::create("hbus", this);
  endfunction : build_phase

