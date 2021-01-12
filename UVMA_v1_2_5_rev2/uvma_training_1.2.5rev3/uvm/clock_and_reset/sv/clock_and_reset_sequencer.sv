/* Copyright Cadence Design Systems (c) 2015 */

class clock_and_reset_sequencer extends uvm_sequencer #(clock_and_reset_sequence_item);

  `uvm_component_utils(clock_and_reset_sequencer)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : clock_and_reset_sequencer 


