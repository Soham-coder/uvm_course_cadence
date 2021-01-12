/*-----------------------------------------------------------------
File name     : hbus_slave_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : HBUS UVC slave sequences for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// SEQUENCE: hbus_slave_response_seq
// DO NOT raise objections for slave sequences
//------------------------------------------------------------------------------
class hbus_slave_response_seq extends uvm_sequence #(hbus_transaction);

  function new(string name="hbus_slave_response_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(hbus_slave_response_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    forever begin
     // dummy transaction
    `uvm_do(req)
    end
  endtask : body
endclass : hbus_slave_response_seq

