/*-----------------------------------------------------------------
File name     : yapp_tx_monitor.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : YAPP UVC TX Monitor for acceleration
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: yapp_tx_monitor
//
//------------------------------------------------------------------------------

// enum to control coverage
typedef enum bit {COV_ENABLE, COV_DISABLE} cover_e;

class yapp_tx_monitor extends uvm_monitor;

  // Collected Data handle
  yapp_packet pkt;

  // Count packets collected
  int num_pkt_col;

  // analysis port for lab09*
  uvm_analysis_port#(yapp_packet) item_collected_port;

  // Config property for coverage enable lab10
  cover_e coverage_control = COV_ENABLE;

  virtual interface yapp_if vif;

  // component macro
  `uvm_component_utils_begin(yapp_tx_monitor)
    `uvm_field_int(num_pkt_col, UVM_ALL_ON)
    `uvm_field_enum(cover_e, coverage_control, UVM_ALL_ON)
  `uvm_component_utils_end

  // coverage model
  covergroup collected_pkts_cg;
    option.per_instance=1;

    // coverpoint for length
    REQ1_length: coverpoint pkt.length {
      bins MIN = {1};
      bins SMALL = {[2:10]};
      bins MEDIUM = {[11:40]};
      bins LARGE = {[41:62]}; 
      bins MAX = {63}; 
    }

    // coverpoint for address
    REQ2_addr : coverpoint pkt.addr {
      bins addr[] = {[0:2]};
      bins illegal = {3};
    }

    // coverpoint for bad parity
    bad_parity: coverpoint pkt.parity_type {
      bins bad = {BAD_PARITY};
      bins good = default;
    }

    // cross length and address
    REQ3_cross_addr_length: cross REQ1_length, REQ2_addr;
  
    // cross address and parity
    REQ3_cross_addr_bad_parity: cross  REQ2_addr, bad_parity;

  endgroup: collected_pkts_cg 

  // component constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port",this);
    if (coverage_control == COV_ENABLE) begin
     `uvm_info(get_type_name(),"YAPP MONITOR COVERAGE CREATED" , UVM_LOW)
      collected_pkts_cg = new();
      collected_pkts_cg.set_inst_name({get_full_name(), ".monitor_pkt"});
    end
  endfunction : new

  function void connect_phase(uvm_phase phase);
    if (!yapp_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction: connect_phase

  // UVM run() phase
  task run_phase(uvm_phase phase);
    // Look for packets after reset
    @(posedge vif.reset)
    @(negedge vif.reset)
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin 
      // Create collected packet instance
      pkt = yapp_packet::type_id::create("pkt", this);

      fork
        // collect packet
        vif.collect_packet(pkt.length, pkt.addr, pkt.payload, pkt.parity);
        // trigger transaction at start of packet
        @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
      join

      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      // End transaction recording
      end_tr(pkt);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_NONE)
      item_collected_port.write(pkt);
      // trigger coverage
      if (coverage_control == COV_ENABLE) begin
        `uvm_info(get_type_name(),"YAPP MONITOR COVERAGE SAMPLE" , UVM_NONE)
        collected_pkts_cg.sample();
      end
      num_pkt_col++;
    end
  endtask : run_phase

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase

endclass : yapp_tx_monitor
