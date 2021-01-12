/*-----------------------------------------------------------------
File name     : hbus_slave_sequencer.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : HBUS UVC slave sequencer for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: hbus_slave_sequencer
//
//------------------------------------------------------------------------------

class hbus_slave_sequencer extends uvm_sequencer #(hbus_transaction);

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(hbus_slave_sequencer)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : hbus_slave_sequencer

