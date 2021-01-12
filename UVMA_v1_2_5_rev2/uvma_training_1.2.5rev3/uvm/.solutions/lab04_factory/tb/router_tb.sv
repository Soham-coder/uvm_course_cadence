/*-----------------------------------------------------------------
File name     : router_tb.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab07_integ router testbench
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: router_tb
//
//------------------------------------------------------------------------------

class router_tb extends uvm_env;

  // component macro
  `uvm_component_utils(router_tb)

  yapp_env yapp;

  // Constructor
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  // UVM build() phase
  function void build_phase(uvm_phase phase);
    `uvm_info("MSG","In the build phase",UVM_HIGH)
    super.build_phase(phase);
    yapp = yapp_env::type_id::create("yapp", this);

  endfunction : build_phase

endclass : router_tb
