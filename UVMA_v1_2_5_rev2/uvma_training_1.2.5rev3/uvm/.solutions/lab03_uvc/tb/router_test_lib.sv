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
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                                   "default_sequence",
                                   yapp_5_packets::get_type());
    tb = new("tb", this);
  endfunction : build_phase
  
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase

endclass : base_test

class test2 extends base_test;

  // component macro
  `uvm_component_utils(test2)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : test2

