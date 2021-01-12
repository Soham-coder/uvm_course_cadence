/*-----------------------------------------------------------------
File name     : hbus_master_driver.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : HBUS UVC master driver for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: hbus_master_driver
//
//------------------------------------------------------------------------------

class hbus_master_driver extends uvm_driver #(hbus_transaction);

  // The virtual interface used to drive and view HDL signals.
  virtual hbus_if vif;

  // Master Id
  int master_id;

  // Control signal for the hbus driver
  //      if==0, delay between cycle is fixed to 1
  //      if==1, delay is based on value of wait_between_cycle
  bit random_delay = 0;

  // Provide implmentations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(hbus_master_driver)
    `uvm_field_int(random_delay, UVM_DEFAULT)
    `uvm_field_int(master_id, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!hbus_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction: build_phase

  // run_phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
  endtask : run_phase

  // Gets transaction from the sequencer and passes it to the driver.  
  virtual protected task get_and_drive();
    @(negedge vif.reset);
    `uvm_info(get_type_name(),"Reset Dropped", UVM_MEDIUM)
    forever begin
      // Get new item from the sequencer
      seq_item_port.get_next_item(req);

      // Drive the data item
      fork
        vif.master_send_to_dut(req.haddr, req.hwr_rd, req.hdata, req.wait_between_cycle, random_delay);
        begin
          @(posedge vif.masterstart) void'(this.begin_tr(req, "HBUS_Master_Transaction"));
          `uvm_info(get_type_name(), $sformatf("Driving transaction :\n%s",req.sprint()), UVM_MEDIUM)
        end
      join

      this.end_tr(req);

      // Communicate item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive

  // Reset all master signals
  task reset_signals();
    forever
      vif.master_reset();
  endtask : reset_signals

endclass : hbus_master_driver


