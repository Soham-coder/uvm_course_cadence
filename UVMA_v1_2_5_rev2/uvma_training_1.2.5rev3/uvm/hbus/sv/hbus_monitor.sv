/*-----------------------------------------------------------------
File name     : hbus_monitor.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : HBUS UVC monitor for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: hbus_monitor
//
//------------------------------------------------------------------------------

class hbus_monitor extends uvm_monitor;

  // This property is the virtual interfaced needed for this component to drive 
  // and view HDL signals. 
  virtual hbus_if vif;

  // The following two bits are used to control whether checks and coverage are
  // done both in the monitor class and the interface.
  bit checks_enable = 1;
  bit coverage_enable = 1;

  // This port is used to connect the monitor to the scoreboard
  uvm_analysis_port #(hbus_transaction) item_collected_port;

  //  Current monitored transaction  
  protected hbus_transaction tr_collect;

  // Count Reads/Writes for summary report at end of simulation
  int num_read_trans, num_write_trans;

  // Events needed to trigger covergroups
  //CHANGE TO .sample(): event cov_transaction;

  // transaction collected covergroup
  //covergroup cover_transaction @cov_transaction;
  covergroup cover_transaction;
    option.per_instance = 0;
    address : coverpoint tr_collect.haddr {
          bins max_pkt_reg = {0};
          bins enable_reg  = {1};
          bins other_regs  = {[2:31]}; 
          //bins ignore    = {[32:$]}; }
          bins ignore    = default; }
    direction : coverpoint tr_collect.hwr_rd;
    addressXdirection : cross address, direction;
  endgroup : cover_transaction
  
  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(hbus_monitor)
    `uvm_field_int(checks_enable, UVM_ALL_ON)
    `uvm_field_int(coverage_enable, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
    void'(get_config_int("coverage_enable", coverage_enable));
    if (coverage_enable) begin
      cover_transaction = new();
      cover_transaction.set_inst_name({get_full_name(), ".cover_transaction"});
    end
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!hbus_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction: build_phase

  // run_phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions();
    join
  endtask : run_phase

  // Collect transactions
  virtual protected task collect_transactions();
   // Create Transaction
   tr_collect = hbus_transaction::type_id::create("tr_collect", this);
   forever begin 
    fork  
    begin
       @(posedge vif.reset)  // Wait on Reset active
          `uvm_info(get_type_name(), "Reset Active", UVM_MEDIUM)
       @(negedge vif.reset)  // Wait on Reset deactive
       `uvm_info(get_type_name(), "Reset Deasserted", UVM_MEDIUM)
    end
    begin
      fork
        // collect transaction
        vif.collect_packet(tr_collect.haddr, tr_collect.hwr_rd, tr_collect.hdata);
        begin
          @(posedge vif.monstart) void'(this.begin_tr(tr_collect, "HBUS_Monitor_Transaction"));
          `uvm_info(get_type_name(), "Collecting Transaction", UVM_LOW)
        end
      join
      if (tr_collect.hwr_rd == HBUS_WRITE)
        num_write_trans++;
      else  
        num_read_trans++;
      void'(this.end_tr(tr_collect));
      `uvm_info(get_type_name(), $sformatf("transaction collected :\n%s",tr_collect.sprint()), UVM_LOW)
      if (checks_enable) perform_checks();
      if (coverage_enable) perform_coverage();
      // Broadcast transaction to the rest of the environment
      item_collected_port.write(tr_collect);
    end
   join_any
   disable fork;
  end
  endtask : collect_transactions

  // Performs transaction checks
  virtual protected function void perform_checks();
  endfunction : perform_checks

  // Triggers coverage events and fill cover fields
  virtual protected function void perform_coverage();
     //-> cov_transaction;
     cover_transaction.sample();
  endfunction : perform_coverage

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: HBUS Monitor Collected %0d WRITE and %0d READ Transactions", num_write_trans, num_read_trans), UVM_LOW)
  endfunction : report_phase

endclass : hbus_monitor

