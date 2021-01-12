/*-----------------------------------------------------------------
File name     : hbus_master_sequencer.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : HBUS UVC master sequencer for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: hbus_master_sequencer
//
//------------------------------------------------------------------------------

class hbus_master_sequencer extends uvm_sequencer #(hbus_transaction);

  // Master Id
  int master_id;

  `uvm_component_utils(hbus_master_sequencer)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : hbus_master_sequencer


