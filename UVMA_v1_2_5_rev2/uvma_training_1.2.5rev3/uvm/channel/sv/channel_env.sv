/*-----------------------------------------------------------------
File name     : channel_env.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : Channel UVC env for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015 
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: channel_env
//
//------------------------------------------------------------------------------

class channel_env extends uvm_env;

  // The following two bits are used to control whether checks and coverage are
  // done both in the bus monitor class and the interface.
  bit checks_enable = 1; 
  bit coverage_enable = 1;

  // Configuration properties
  int channel_id = 0;

  // Components of the environment
  channel_rx_agent rx_agent;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(channel_env)
    `uvm_field_int(channel_id, UVM_ALL_ON)
    `uvm_field_int(checks_enable, UVM_ALL_ON)
    `uvm_field_int(coverage_enable, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor - required syntax for UVM automation and utilities
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);

endclass : channel_env

  // UVM build_phase
  function void channel_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // set the channel_id into lower level components
    uvm_config_int::set(this, "*", "channel_id", channel_id); 
    // Build the rx agent
    rx_agent = channel_rx_agent::type_id::create("rx_agent", this);
  endfunction : build_phase

