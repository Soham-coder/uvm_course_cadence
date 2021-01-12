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
    uvm_config_int::set( this, "*", "recording_detail", 1);
    tb = router_tb::type_id::create("tb", this);
  endfunction : build_phase
  
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  // start_of_simulation added for lab03
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
  endfunction : start_of_simulation_phase

  function void check_phase(uvm_phase phase);
    // configuration checker
    check_config_usage();
  endfunction

endclass : base_test

class test2 extends base_test;

  // component macro
  `uvm_component_utils(test2)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : test2

class yapp5_test extends base_test;

  // component macro
  `uvm_component_utils(yapp5_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                                   "default_sequence",
                                   yapp_5_packets::get_type());
  endfunction : build_phase

endclass : yapp5_test

class short_packet_test extends base_test;

  // component macro
  `uvm_component_utils(short_packet_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); 
    super.build_phase(phase);
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                                   "default_sequence",
                                   yapp_5_packets::get_type());
  endfunction : build_phase

endclass : short_packet_test

class set_config_test extends base_test;

  // component macro
  `uvm_component_utils(set_config_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_config_int::set(this, "tb.yapp.tx_agent", "is_active", UVM_PASSIVE);
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                                   "default_sequence",
                                   yapp_5_packets::get_type());
    super.build_phase(phase);
  endfunction : build_phase

endclass : set_config_test

class incr_payload_test extends base_test;

  // component macro
  `uvm_component_utils(incr_payload_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
   yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); 
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                            "default_sequence",
                            yapp_incr_payload_seq::get_type());
   super.build_phase(phase);
  endfunction : build_phase

endclass : incr_payload_test

class exhaustive_seq_test extends base_test;

  // component macro
  `uvm_component_utils(exhaustive_seq_test)
  
  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
   yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); 
   uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                           "default_sequence",
                           yapp_exhaustive_seq::get_type());
   super.build_phase(phase);
  endfunction : build_phase

endclass : exhaustive_seq_test

class seq_from_test extends base_test;

  // component macro
  `uvm_component_utils(seq_from_test)

  yapp_tx_sequencer yapp_seqr;
  yapp_5_packets yapp5;

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
   yapp5 = yapp_5_packets::type_id::create("yapp5", this);

   yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); 
   super.build_phase(phase);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    yapp_seqr = tb.yapp.tx_agent.sequencer;
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this, "yapp_base_seq");
    yapp5.start(yapp_seqr); 
    phase.drop_objection(this, "yapp_base_seq");
  endtask : run_phase

endclass : seq_from_test

