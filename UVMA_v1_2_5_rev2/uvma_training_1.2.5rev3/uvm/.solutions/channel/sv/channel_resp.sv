/*-----------------------------------------------------------------
File name     : channel_resp.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : Channel UVC response sequnence item for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015 
-----------------------------------------------------------------*/

//----------------------------------------------------------------------
// CLASS: channel_resp
//----------------------------------------------------------------------
class channel_resp extends uvm_sequence_item;     
  rand int resp_delay; // #clocks to keep suspend raised

  constraint default_delay { resp_delay >= 0; resp_delay < 8; }

  // UVM macros for built-in automation - These declarations enable automation
  // of the data_item fields and implement create() and get_type_name()
  `uvm_object_utils_begin(channel_resp)
    `uvm_field_int(resp_delay, UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end

  // new - constructor
  function new (string name = "channel_resp");
    super.new(name);
  endfunction : new

endclass : channel_resp

