/* Copyright Cadence Design Systems (c) 2015 */

class clock_and_reset_env extends uvm_env;

  `uvm_component_utils(clock_and_reset_env)

  clock_and_reset_agent                           agent;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = clock_and_reset_agent::type_id::create("agent", this);
  endfunction 
  
endclass
