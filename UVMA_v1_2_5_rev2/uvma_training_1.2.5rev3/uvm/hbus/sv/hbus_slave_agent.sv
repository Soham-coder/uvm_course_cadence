/*-----------------------------------------------------------------
File name     : hbus_slave_agent.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : HBUS UVC slave agent for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: hbus_slave_agent
//
//------------------------------------------------------------------------------

class hbus_slave_agent extends uvm_agent;
 
  // This field determines whether an agent is active or passive.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  hbus_monitor         monitor;
  hbus_slave_driver    driver;
  hbus_slave_sequencer sequencer;
 
  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(hbus_slave_agent)
    `uvm_field_object(monitor, UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //monitor = hbus_monitor::type_id::create("monitor", this);
    if(is_active == UVM_ACTIVE) begin
      driver = hbus_slave_driver::type_id::create("driver", this);
      sequencer = hbus_slave_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase
 
  // UVM connect_phase
  virtual function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds the driver to the sequencer using consumer-producer interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
     end
  endfunction : connect_phase

endclass : hbus_slave_agent

