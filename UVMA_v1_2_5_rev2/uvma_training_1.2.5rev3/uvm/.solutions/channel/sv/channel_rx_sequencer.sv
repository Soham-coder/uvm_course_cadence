/*-----------------------------------------------------------------
File name     : channel_rx_sequencer.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : Channel UVC RX sequencer for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015 
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: channel_rx_sequencer
//
//------------------------------------------------------------------------------

class channel_rx_sequencer extends uvm_sequencer #(channel_resp);

   virtual interface channel_if vif;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(channel_rx_sequencer)

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase()
  function void build_phase(uvm_phase phase);
    if (!channel_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction: build_phase

endclass : channel_rx_sequencer


