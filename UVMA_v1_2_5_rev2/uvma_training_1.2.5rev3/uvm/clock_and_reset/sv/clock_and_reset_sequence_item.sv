/* Copyright Cadence Design Systems (c) 2015  */

class clock_and_reset_sequence_item extends uvm_sequence_item;

  int clock_period;
  int reset_delay;
  int clock_cycles_to_count;
  bit cycle_count_must_happen;
  bit run_clock;

  `uvm_object_utils_begin(clock_and_reset_sequence_item)
    `uvm_field_int    (clock_period           , UVM_DEFAULT)
    `uvm_field_int    (reset_delay            , UVM_DEFAULT)
    `uvm_field_int    (clock_cycles_to_count  , UVM_DEFAULT)
    `uvm_field_int    (cycle_count_must_happen, UVM_DEFAULT)
    `uvm_field_int    (run_clock              , UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name="");
    super.new(name);
  endfunction

endclass

