/*-----------------------------------------------------------------
File name     : hbus_test_lib.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : Demo test library for HBUS UVC for accelerated UVM
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
    uvm_config_int::set(this,"*", "recording_detail", UVM_FULL);
    // Create the tb
    tb = demo_tb::type_id::create("tb", this);
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction

endclass : demo_base_test

//----------------------------------------------------------------
// TEST: hbus_write_read_test
//----------------------------------------------------------------
class hbus_write_read_test extends demo_base_test;

  `uvm_component_utils(hbus_write_read_test)

  function new(string name = "hbus_write_read_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase

  virtual function void build_phase(uvm_phase phase);
    // Set the default sequence for the master and slave
    uvm_config_wrapper::set(this, "tb.hbus.masters[0].sequencer.main_phase",
                            "default_sequence",
                            hbus_set_get_regs_seq::get_type());

    uvm_config_wrapper::set(this, "tb.hbus.slaves[0].sequencer.main_phase",
                            "default_sequence",
                            hbus_slave_response_seq::get_type());
    // Create the tb
    super.build_phase(phase);
  endfunction : build_phase

endclass : hbus_write_read_test

//----------------------------------------------------------------
// TEST: hbus_master_topology
//----------------------------------------------------------------
class hbus_master_topology extends demo_base_test;

  `uvm_component_utils(hbus_master_topology)

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    // Set configuration for single Master agent
    // This overwrites configuration from testbench    
    uvm_config_int::set(this,"tb.hbus", "num_masters", 1);
    uvm_config_int::set(this,"tb.hbus", "num_slaves", 0);
    // Create the tb
    super.build_phase(phase);
  endfunction : build_phase

endclass : hbus_master_topology

