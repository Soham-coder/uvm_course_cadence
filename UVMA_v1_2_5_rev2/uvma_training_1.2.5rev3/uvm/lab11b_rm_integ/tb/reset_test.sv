
/*-----------------------------------------------------------------
File name     : reset_test.sv
Developers    : Lisa Barbay, Brian Dickinson
Created       : 7/11/12
Description   : This file calls the built-in reset test
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2012 
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: uvm_reset_test
//-----------------------------------------------------------------------------

class  uvm_reset_test extends base_test;

    uvm_reg_hw_reset_seq reset_seq;

  // component macro
  `uvm_component_utils(uvm_reset_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     reset_seq.model = tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
     reset_seq.start(null);
     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
     
     
  endtask

endclass : uvm_reset_test

