/* Copyright Cadence Design Systems (c) 2015  */

class clock_and_reset_agent extends uvm_agent;

  `uvm_component_utils(clock_and_reset_agent)

  clock_and_reset_driver     driver;
  clock_and_reset_sequencer  sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(get_is_active()==UVM_ACTIVE) begin
      driver = clock_and_reset_driver::type_id::create("driver", this);
      sequencer = clock_and_reset_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);

    if(get_is_active()==UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
  
endclass

