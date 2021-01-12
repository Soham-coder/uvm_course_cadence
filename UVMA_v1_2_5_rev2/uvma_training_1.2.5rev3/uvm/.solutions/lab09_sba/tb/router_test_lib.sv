/*-----------------------------------------------------------------
File name     : router_test_lib.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab09_sba router test library with multichannel sequences
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: base_test
//
//------------------------------------------------------------------------------

class base_test extends uvm_test;

  // component macro
  `uvm_component_utils(base_test)

  // Testbench handle
  router_tb tb;

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase() phase
  function void build_phase(uvm_phase phase);
    uvm_config_int::set( this, "*", "recording_detail", 1);
    super.build_phase(phase);
    tb = router_tb::type_id::create("tb", this);
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  // start_of_simulation added for lab03
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
  endfunction : start_of_simulation_phase

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 2000ns);
  endtask : run_phase

  function void check_phase(uvm_phase phase);
    // configuration checker
    check_config_usage();
  endfunction

endclass : base_test

//------------------------------------------------------------------------------
//
// CLASS: simple_test
// simple integration test for lab07_integ
//
//------------------------------------------------------------------------------

class simple_test extends base_test;

  // component macro
  `uvm_component_utils(simple_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                            "default_sequence",
                            yapp_012_seq::get_type());
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                            "default_sequence",
                            channel_rx_resp_seq::get_type());
   super.build_phase(phase);
  endfunction : build_phase

endclass : simple_test

//------------------------------------------------------------------------------
//
// CLASS: test_uvc_integration
// optional integration test for lab07_integ
//
//------------------------------------------------------------------------------

class test_uvc_integration extends base_test;

  // component macro
  `uvm_component_utils(test_uvc_integration)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
   yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
    uvm_config_wrapper::set(this, "tb.hbus.masters[0].sequencer.run_phase",
                            "default_sequence",
                            hbus_small_packet_seq::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                            "default_sequence",
                            test_uvc_seq::get_type());
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                            "default_sequence",
                            channel_rx_resp_seq::get_type());
    super.build_phase(phase);
  endfunction: build_phase

endclass : test_uvc_integration

//------------------------------------------------------------------------------
//
// CLASS: test_mc
// Multichannel sequencer test for lab08_mcseq
//
//------------------------------------------------------------------------------

class test_mc extends base_test;

  // component macro
  `uvm_component_utils(test_mc)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
   //yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
    uvm_config_wrapper::set(this, "tb.mcsequencer.run_phase",
                            "default_sequence",
                            router_simple_mcseq::get_type());
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                            "default_sequence",
                            channel_rx_resp_seq::get_type());

   super.build_phase(phase);
  endfunction : build_phase

endclass : test_mc

