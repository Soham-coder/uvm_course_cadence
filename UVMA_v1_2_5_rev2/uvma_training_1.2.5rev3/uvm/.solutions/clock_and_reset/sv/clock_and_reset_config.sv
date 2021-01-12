/* Copyright Cadence Design Systems (c) 2015 */

class clock_and_reset_config extends uvm_object;

  string agent_names[$];

  `uvm_object_utils_begin(clock_and_reset_config)
    `uvm_field_queue_string(agent_names, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "clock_and_reset_config");
    super.new(name);
  endfunction

endclass 