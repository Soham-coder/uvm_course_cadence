/*-----------------------------------------------------------------
File name     : router_test_lib.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab03_test YAPP test library
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: test_lib
//
//------------------------------------------------------------------------------

class base_test extends uvm_test;

  // component macro
  `uvm_component_utils(base_test)

  router_tb tb;

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase()
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tb = new("tb", this);
    `uvm_info("MSG","Test build phase executed",UVM_HIGH)
  endfunction : build_phase
  
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

endclass : base_test

class test2 extends base_test;

  // component macro
  `uvm_component_utils(test2)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : test2

