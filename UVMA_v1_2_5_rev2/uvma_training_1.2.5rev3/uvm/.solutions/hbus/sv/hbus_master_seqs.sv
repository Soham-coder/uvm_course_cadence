/*-----------------------------------------------------------------
File name     : hbus_master_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 26/01/15
Description   : HBUS UVC master sequences for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// SEQUENCE: base hbus sequence - base sequence with objections from which
// all sequences can be derived
//
//------------------------------------------------------------------------------
class hbus_base_seq extends uvm_sequence #(hbus_transaction);

  // Required macro for sequences automation
  `uvm_object_utils(hbus_base_seq)

  string phase_name;
  uvm_phase phaseh;

  // Constructor
  function new(string name="hbus_base_seq");
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

endclass : hbus_base_seq

//------------------------------------------------------------------------------
// SEQUENCE: hbus_write_seq - specify address, data
//------------------------------------------------------------------------------
class hbus_write_seq extends hbus_base_seq;

  function new(string name="hbus_write_seq");
    super.new(name);
  endfunction

  rand bit [15:0] address;
  rand bit [7:0] data;

  hbus_transaction transaction;

  `uvm_object_utils(hbus_write_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    `uvm_do_with(transaction, 
        { transaction.haddr == address;
          transaction.hdata == data;
          transaction.hwr_rd == HBUS_WRITE; })
    `uvm_info(get_type_name(), $sformatf("HBUS WRITE ADDRESS:%0d  DATA:%h", address, data), UVM_MEDIUM)
  endtask : body
endclass : hbus_write_seq

//------------------------------------------------------------------------------
// SEQUENCE: hbus_read_seq - specify address
//------------------------------------------------------------------------------
class hbus_read_seq extends hbus_base_seq;

  function new(string name="hbus_read_seq");
    super.new(name);
  endfunction

  rand bit [15:0] address;
  bit [7:0] data;

  hbus_transaction transaction;

  `uvm_object_utils(hbus_read_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    `uvm_do_with(transaction, 
        { transaction.haddr == address;
          transaction.hdata == 'h00;
          transaction.hwr_rd == HBUS_READ; })
    data = transaction.hdata;
    `uvm_info(get_type_name(), $sformatf("HBUS READ ADDRESS:%0d  DATA:%h", address, data), UVM_MEDIUM)
  endtask : body
endclass : hbus_read_seq

//------------------------------------------------------------------------------
// SEQUENCE: hbus_set_yapp_regs_seq - specify max_pkt_reg, enable_reg values
//------------------------------------------------------------------------------
class hbus_set_yapp_regs_seq extends hbus_base_seq;

  function new(string name="hbus_set_yapp_regs_seq");
    super.new(name);
  endfunction

  rand bit [7:0] max_pkt_reg;
  rand bit [7:0] enable_reg;

  hbus_transaction transaction;

  constraint c_max_pkg { max_pkt_reg inside {[1:63]}; }
  constraint c_enable  { enable_reg inside {[0:1]}; }
  
  `uvm_object_utils(hbus_set_yapp_regs_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    //Set Packet Size: hbus address 1000
    `uvm_do_with(transaction, 
      { transaction.haddr == 16'h1000;
        transaction.hdata == max_pkt_reg;
        transaction.hwr_rd == HBUS_WRITE; })
    `uvm_info(get_type_name(), $sformatf("WRITE YAPP MAX_PKT_REG:%h", max_pkt_reg), UVM_HIGH)
    //Enable YAPP Router: hbus address 1001
    `uvm_do_with(transaction, 
      { transaction.haddr == 16'h1001;
        transaction.hdata == enable_reg;
        transaction.hwr_rd == HBUS_WRITE; })
    `uvm_info(get_type_name(), $sformatf("WRITE YAPP ENABLE_REG:%h", enable_reg), UVM_HIGH)
  endtask : body
endclass : hbus_set_yapp_regs_seq

//------------------------------------------------------------------------------
// SEQUENCE: hbus_get_yapp_regs_seq - reads the max_pkt_reg and enable_reg
//------------------------------------------------------------------------------
class hbus_get_yapp_regs_seq extends hbus_base_seq;

  function new(string name="hbus_get_yapp_regs_seq");
    super.new(name);
  endfunction

  bit [7:0] max_pkt_reg;
  bit [7:0] enable_reg;

  hbus_transaction transaction;

  `uvm_object_utils(hbus_get_yapp_regs_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    //Set Packet Size: hbus address 1000
    `uvm_do_with(transaction, 
      { transaction.haddr == 16'h1000;
        transaction.hwr_rd == HBUS_READ; })
    max_pkt_reg = transaction.hdata;
    `uvm_info(get_type_name(), $sformatf("READ YAPP MAX_PKT_REG:%h", max_pkt_reg), UVM_HIGH)
    //Enable YAPP Router: hbus address 1001
    `uvm_do_with(transaction, 
      { transaction.haddr == 16'h1001;
        transaction.hwr_rd == HBUS_READ; })
    enable_reg = transaction.hdata;
    `uvm_info(get_type_name(), $sformatf("READ YAPP ENABLE_REG:%h", enable_reg), UVM_HIGH)
  endtask : body
endclass : hbus_get_yapp_regs_seq

//------------------------------------------------------------------------------
// SEQUENCE: hbus_small_packet_seq - max_pkt_reg = 20, enable_reg = 1
//------------------------------------------------------------------------------
class hbus_small_packet_seq extends hbus_base_seq;

  function new(string name="hbus_small_packet_seq");
    super.new(name);
  endfunction

  hbus_set_yapp_regs_seq hbus_seq;
  
  `uvm_object_utils(hbus_small_packet_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    `uvm_do_with(hbus_seq, { hbus_seq.max_pkt_reg == 20; hbus_seq.enable_reg == 1; })
  endtask : body
endclass : hbus_small_packet_seq

//------------------------------------------------------------------------------
// SEQUENCE: hbus_set_default_regs_seq - max_pkt_reg = 63, enable_reg = 1
//------------------------------------------------------------------------------
class hbus_set_default_regs_seq extends hbus_base_seq;

  function new(string name="hbus_set_default_regs_seq");
    super.new(name);
  endfunction

  hbus_set_yapp_regs_seq hbus_seq;
  
  `uvm_object_utils(hbus_set_default_regs_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    `uvm_do_with(hbus_seq, { hbus_seq.max_pkt_reg == 63; hbus_seq.enable_reg == 1; })
  endtask : body
endclass : hbus_set_default_regs_seq

//------------------------------------------------------------------------------
// SEQUENCE: hbus_read_max_pkt_seq - reads max_pkt_reg
//------------------------------------------------------------------------------
class hbus_read_max_pkt_seq extends hbus_base_seq;

  function new(string name="hbus_read_max_pkt_seq");
    super.new(name);
  endfunction

  bit [7:0] max_pkt_reg;

  hbus_transaction transaction;

  `uvm_object_utils(hbus_read_max_pkt_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    //Max Packet Size: Address 0
    `uvm_do_with(transaction, 
      { transaction.haddr == 16'h1000;
        transaction.hwr_rd == HBUS_READ; })
    max_pkt_reg = transaction.hdata;
    `uvm_info(get_type_name(), $sformatf("READ YAPP MAX_PKT_REG:%h", max_pkt_reg), UVM_HIGH)
  endtask : body
endclass : hbus_read_max_pkt_seq

//------------------------------------------------------------------------------
// SEQUENCE: hbus_read_enable_seq - reads enable_reg
//------------------------------------------------------------------------------
class hbus_read_enable_seq extends hbus_base_seq;

  function new(string name="hbus_read_enable_seq");
    super.new(name);
  endfunction

  bit [7:0] enable_reg;

  hbus_transaction transaction;

  `uvm_object_utils(hbus_read_enable_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    //Enable Register: Address 1
    `uvm_do_with(transaction, 
      { transaction.haddr == 16'h1001;
        transaction.hwr_rd == HBUS_READ; })
    enable_reg = transaction.hdata;
    `uvm_info(get_type_name(), $sformatf("READ YAPP ENABLE_REG:%h", enable_reg), UVM_HIGH)
  endtask : body
endclass : hbus_read_enable_seq

//------------------------------------------------------------------------------
// SEQUENCE: hbus_set_get_regs_seq - write default values and read them back
//------------------------------------------------------------------------------
class hbus_set_get_regs_seq extends hbus_base_seq;

  function new(string name="hbus_set_get_regs_seq");
    super.new(name);
  endfunction

  hbus_set_default_regs_seq  set_seq;
  hbus_read_max_pkt_seq      read_max_seq;
  hbus_read_enable_seq       read_en_seq;
  
  `uvm_object_utils(hbus_set_get_regs_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    `uvm_do(set_seq)
    `uvm_do(read_max_seq)
    `uvm_do(read_en_seq)
  endtask : body
endclass : hbus_set_get_regs_seq

