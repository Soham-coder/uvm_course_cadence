/*-----------------------------------------------------------------
File name     : clock_and_reset_test_lib.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : Demo test library for clock_and_reset UVC for accelerated UVM
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

  clock_and_reset_demo_tb tb;

  function new(string name = "demo_base_test", 
    uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Enable transaction recording for everything
    uvm_config_int::set(this,"*", "recording_detail", UVM_FULL);
    tb = clock_and_reset_demo_tb::type_id::create("tb", this);
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction

endclass : demo_base_test

//----------------------------------------------------------------
// TEST: clock_reset_test
//----------------------------------------------------------------
class clock_reset_test extends demo_base_test;

  `uvm_component_utils(clock_reset_test)

  function new(string name = "clock_reset_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  clock_and_reset_sequencer cr_seqr;
  clk10_rst5_seq cr_seq;

  function void build_phase(uvm_phase phase);
    // Set the default sequence for the master and slave
    //uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
    //                        "default_sequence",
    cr_seq = clk10_rst5_seq::type_id::create("cr_seq", this);
    super.build_phase(phase);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    cr_seqr = tb.clock_and_reset.agent.sequencer;
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this, "clock_reset_test");
    cr_seq.start(cr_seqr); 
    phase.drop_objection(this, "clock_reset_test");
  endtask : run_phase

endclass : clock_reset_test

