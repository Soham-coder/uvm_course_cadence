/*-----------------------------------------------------------------
File name     : router_module_env.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : router module UVC env for lab09_sbc
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------//
// CLASS: router_env
//
//------------------------------------------------------------------------------

class router_env extends uvm_env;

  // Router Reference 
  router_reference reference;

  // Router Scoreboard
  router_scoreboard scoreboard;

   uvm_analysis_export #(yapp_packet) router_yapp;
   uvm_analysis_export #(hbus_transaction) router_hbus;
   
   uvm_analysis_export #(channel_packet) router_chan0;
   uvm_analysis_export #(channel_packet) router_chan1;
   uvm_analysis_export #(channel_packet) router_chan2;

  `uvm_component_utils_begin(router_env)
  `uvm_component_utils_end

  //UVM Constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name, parent);
    router_yapp = new("router_yapp", this);
    router_hbus = new("router_hbus", this);
    router_chan0 = new("router_chan0", this);
    router_chan1 = new("router_chan1", this);
    router_chan2 = new("router_chan2", this); 
  endfunction : new

  // UVM build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scoreboard = router_scoreboard::type_id::create("scoreboard", this);
    reference = router_reference::type_id::create("reference", this);
  endfunction : build_phase

  // UVM connect_phase
  function void connect_phase(uvm_phase phase);
    // hierarchy TLM connections for router module OVC
    router_hbus.connect(reference.hbus_in);
    router_yapp.connect(reference.yapp_in);
    router_chan0.connect(scoreboard.sb_chan0);
    router_chan1.connect(scoreboard.sb_chan1);
    router_chan2.connect(scoreboard.sb_chan2);
    // internal reference to scoreboard TLM connection   
    reference.sb_add_out.connect(scoreboard.sb_yapp_in);
  endfunction : connect_phase

endclass : router_env
