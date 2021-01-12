/*-----------------------------------------------------------------
File name     : test_lib.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : Demo Test Library for Channel UVC for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015 
-----------------------------------------------------------------*/

//----------------------------------------------------------------
//
// TEST: demo_base_test - Base test
//
//----------------------------------------------------------------
class demo_base_test extends uvm_test;

  `uvm_component_utils(demo_base_test)

  demo_tb tb;

  function new(string name = "demo_base_test", 
    uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Enable transaction recording for everything
    uvm_config_int::set(this, "*", "recording_detail", UVM_FULL);
    // Create the testbench
    tb = demo_tb::type_id::create("tb", this);
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

endclass : demo_base_test

//----------------------------------------------------------------
//
// TEST: default_sequence_test - sets the default sequences 
//
//----------------------------------------------------------------
class default_sequence_test extends demo_base_test;

  `uvm_component_utils(default_sequence_test)

  function new(string name = "default_sequence_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    uvm_config_int::set(this, "tb.chan0", "channel_id", 0);
    // Set the default sequence for the rx 
    uvm_config_wrapper::set(this, "tb.chan0.rx_agent.sequencer.run_phase",
                            "default_sequence",
                            channel_rx_resp_seq::get_type());
    // Create the testbench
    super.build_phase(phase);
  endfunction : build_phase

endclass : default_sequence_test
