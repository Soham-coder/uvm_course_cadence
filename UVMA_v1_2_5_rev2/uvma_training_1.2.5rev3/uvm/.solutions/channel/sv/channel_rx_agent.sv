/*-----------------------------------------------------------------
File name     : channel_rx_agent.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : Channel UVC RX agent for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015 
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: channel_rx_agent
//
//------------------------------------------------------------------------------

class channel_rx_agent extends uvm_agent;
 
  // This field determines whether an agent is active or passive.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  channel_rx_monitor   monitor;    
  channel_rx_sequencer sequencer;
  channel_rx_driver    driver;
  
  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(channel_rx_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : channel_rx_agent

  // UVM build_phase
  function void channel_rx_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = channel_rx_monitor::type_id::create("monitor", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = channel_rx_sequencer::type_id::create("sequencer", this);
      driver = channel_rx_driver::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void channel_rx_agent::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds the driver to the sequencer using port interfaces
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

