/*-----------------------------------------------------------------
File name     : channel_rx_driver.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : Channel UVC RX Driver for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015 
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: channel_rx_driver
//
//------------------------------------------------------------------------------

class channel_rx_driver extends uvm_driver #(channel_resp);

  // The virtual interface used to drive and view HDL signals.
  virtual interface channel_if vif;
    
  // Count packet_responses sent
  int num_sent;

  // Channel ID for transaction recording
  int channel_id;
  string instance_id;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(channel_rx_driver)
    `uvm_field_int(channel_id, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive();
  extern virtual protected task reset_signals();
  extern virtual function void report_phase(uvm_phase phase);

endclass : channel_rx_driver

  function void channel_rx_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!channel_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
    // Instance ID for transaction recording
    case (channel_id)
      0: instance_id = "Channel_0";
      1: instance_id = "Channel_1";
      2: instance_id = "Channel_2";
      default: instance_id = "Unknown_Channel";
    endcase
  endfunction: build_phase

  // UVM run_phase
  task channel_rx_driver::run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
  endtask : run_phase

  // Continually detects transfers
  task channel_rx_driver::get_and_drive();
    @(negedge vif.reset);
    `uvm_info(get_type_name(), "Reset Dropped", UVM_MEDIUM)
    forever begin
      // Get new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive the response
      vif.send_response(rsp.resp_delay);
      // Communicate item done to the sequencer
      seq_item_port.item_done();
      num_sent++;
    end
  endtask : get_and_drive

  // Reset all signals
  task channel_rx_driver::reset_signals();
    forever begin
      @(posedge vif.reset);
      vif.suspend      <= 1'b1;
    end
  endtask : reset_signals

  // UVM report_phase
  function void channel_rx_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: %s RX Driver Sent %0d Responses",instance_id, num_sent), UVM_LOW)
  endfunction : report_phase

