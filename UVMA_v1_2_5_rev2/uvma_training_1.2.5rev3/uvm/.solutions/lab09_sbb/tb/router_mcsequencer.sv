/*-----------------------------------------------------------------
File name     : router_mcsequencer.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab08_mcseq virtual sequencer component
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: router_mcsequencer
//
//------------------------------------------------------------------------------

class router_mcsequencer extends uvm_sequencer;

   hbus_master_sequencer hbus_seqr;
   yapp_tx_sequencer     yapp_seqr;
   // handle for channel sequencer is optional as the
   // channel sequencer has only one sequence choice
   // handle for clock and reset sequencer is optional as the
   // simulation only uses one clockand reset sequence

  `uvm_component_utils(router_mcsequencer)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : router_mcsequencer

