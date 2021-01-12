/* Copyright Cadence Design Systems (c) 2015  */

package clock_and_reset_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  typedef uvm_config_db#(virtual clock_and_reset_if) clock_and_reset_vif_config;

  `include "clock_and_reset_config.sv"
  `include "clock_and_reset_sequence_item.sv"
  `include "clock_and_reset_sequencer.sv"
  `include "clock_and_reset_driver.sv"
  `include "clock_and_reset_agent.sv"
  `include "clock_and_reset_env.sv"
  `include "clock_and_reset_seq.sv"
  `include "clock_and_reset_count_clocks_seq.sv"

endpackage
