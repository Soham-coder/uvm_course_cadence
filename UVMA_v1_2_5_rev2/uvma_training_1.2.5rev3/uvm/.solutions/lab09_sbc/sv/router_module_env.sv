/*-----------------------------------------------------------------
File name     : router_module_env.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab09_sbb router module UVC env
              : instanitates scoreboard and reference model
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------//
// CLASS: router_env
//
//------------------------------------------------------------------------------

class router_env extends uvm_env;

  // reference model connectors
  uvm_analysis_export  #(hbus_transaction) hbus_in;
  uvm_analysis_export  #(yapp_packet) yapp_in;

  // scoreboard connectors
  uvm_analysis_export #(channel_packet) sb_chan0;
  uvm_analysis_export #(channel_packet) sb_chan1;
  uvm_analysis_export #(channel_packet) sb_chan2;

  // Router Reference 
  router_reference reference;

  // Router Scoreboard
  router_scoreboard scoreboard;

  `uvm_component_utils_begin(router_env)
  `uvm_component_utils_end

  //UVM Constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name, parent);
    hbus_in  = new("hbus_in",  this);
    yapp_in  = new("yapp_in",  this);
    sb_chan0 = new("sb_chan0", this);
    sb_chan1 = new("sb_chan1", this);
    sb_chan2 = new("sb_chan2", this);
  endfunction : new

  // UVM build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scoreboard = router_scoreboard::type_id::create("scoreboard", this);
    reference = router_reference::type_id::create("reference", this);
  endfunction : build_phase

  // UVM connect_phase
  function void connect_phase(uvm_phase phase);
    hbus_in.connect(reference.hbus_in);
    yapp_in.connect(reference.yapp_in);
    sb_chan0.connect(scoreboard.sb_chan0);
    sb_chan1.connect(scoreboard.sb_chan1);
    sb_chan2.connect(scoreboard.sb_chan2);
    reference.sb_add_out.connect(scoreboard.sb_yapp_in);
  endfunction : connect_phase

endclass : router_env
