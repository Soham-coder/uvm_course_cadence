/*-----------------------------------------------------------------
File name     : router_mcseqs_lib.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab08_mcseq router virtual sequence library
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//----------------------------------------------------------------------------
// SEQUENCE: router_simple_mcseq
//----------------------------------------------------------------------------
class router_simple_mcseq extends uvm_sequence;
  
  `uvm_object_utils(router_simple_mcseq)
  `uvm_declare_p_sequencer(router_mcsequencer)

  // YAPP packets sequences
  six_yapp_seq six_yapp;
  yapp_012_seq yapp_012;

  // HBUS sequences
  hbus_small_packet_seq     hbus_small_pkt;
  hbus_read_max_pkt_seq     hbus_rd_maxpkt;     
  hbus_set_default_regs_seq hbus_large_pkt;

  function new(string name="router_simple_mcseq");
    super.new(name);
  endfunction
 
  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

  virtual task body();
    `uvm_info("router_simple_mcseq", "Executing router_simple_mcseq", UVM_LOW )
    // Configure for small packets
    `uvm_do_on(hbus_small_pkt, p_sequencer.hbus_seqr)
    // Read the YAPP MAXPKTSIZE register 
    `uvm_do_on(hbus_rd_maxpkt, p_sequencer.hbus_seqr)
    // sequence stores read value in property max_pkt_reg
    `uvm_info(get_type_name(), $sformatf("router MAXPKTSIZE register read: %0h", hbus_rd_maxpkt.max_pkt_reg), UVM_LOW)
    // send 6 consecutive packets to addresses 0,1,2, cycling the address
    `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
    `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
    // Configure for large packets (default)
    `uvm_do_on(hbus_large_pkt, p_sequencer.hbus_seqr)
    // Read the YAPP MAXPKTSIZE register (address 0)
    `uvm_do_on(hbus_rd_maxpkt, p_sequencer.hbus_seqr)
    // sequence stores read value in property max_pkt_reg
    `uvm_info(get_type_name(), $sformatf("router MAXPKTSIZE register read: %0h", hbus_rd_maxpkt.max_pkt_reg), UVM_LOW)
    // Send 6 random packets
    `uvm_do_on(six_yapp, p_sequencer.yapp_seqr)
  endtask

endclass : router_simple_mcseq

