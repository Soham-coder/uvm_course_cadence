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
// CLASS: hbus_slave_driver
//
//------------------------------------------------------------------------------
 
class hbus_slave_driver extends uvm_driver #(hbus_transaction);

  // The virtual interface used to drive and view HDL signals.
  virtual hbus_if vif;

  bit [7:0] max_pktsize_reg = 8'h3F;
  bit [7:0] router_enable_reg = 1'b1;
  bit [7:0] hbus_memory [32];

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(hbus_slave_driver)
     `uvm_field_int(max_pktsize_reg, UVM_DEFAULT)
     `uvm_field_int(router_enable_reg, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!hbus_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction: build_phase

  // UVM run_phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
  endtask : run_phase

  // Continually gets responses from the sequencer
  // and passes them to the driver.
  virtual protected task get_and_drive();
    @(negedge vif.reset);
    `uvm_info(get_type_name(),"Reset Dropped", UVM_MEDIUM)
    forever begin
      // Get new item from the sequencer
      seq_item_port.get_next_item(rsp);

      fork
        // trigger transaction
        @(posedge vif.slavestart) void'(this.begin_tr(rsp, "HBUS_Slave_Response"));
        // Drive the response
        vif.slave_send_to_dut(rsp.haddr, rsp.hwr_rd, rsp.hdata, max_pktsize_reg, router_enable_reg);
      join

      `uvm_info(get_type_name(), $sformatf("Response Sent:\n%s",rsp.sprint()), UVM_MEDIUM)
      this.end_tr(rsp);
      // Communicate item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive

  // Reset all slave signals
  virtual protected task reset_signals();
    forever begin
      vif.slave_reset();
      max_pktsize_reg = 8'h3F;
      router_enable_reg = 1'b1;
    end
  endtask : reset_signals

endclass : hbus_slave_driver

