/*-----------------------------------------------------------------
File name     : router_test_lib.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab09_sbb router test library with multichannel sequences
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: base_test
//
//------------------------------------------------------------------------------

class base_test extends uvm_test;

  // component macro
  `uvm_component_utils(base_test)

  // Testbench handle
  router_tb tb;

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase() phase
  function void build_phase(uvm_phase phase);
    uvm_config_int::set( this, "*", "recording_detail", 1);
    super.build_phase(phase);
    tb = router_tb::type_id::create("tb", this);
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  // start_of_simulation added for lab03
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
  endfunction : start_of_simulation_phase

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 2000ns);
  endtask : run_phase

  function void check_phase(uvm_phase phase);
    // configuration checker
    check_config_usage();
  endfunction

endclass : base_test

//------------------------------------------------------------------------------
//
// CLASS: simple_test
// simple integration test for lab07_integ
//
//------------------------------------------------------------------------------

class simple_test extends base_test;

  // component macro
  `uvm_component_utils(simple_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                            "default_sequence",
                            yapp_012_seq::get_type());
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                            "default_sequence",
                            channel_rx_resp_seq::get_type());
   super.build_phase(phase);
  endfunction : build_phase

endclass : simple_test

//------------------------------------------------------------------------------
//
// CLASS: test_uvc_integration
// optional integration test for lab07_integ
//
//------------------------------------------------------------------------------

class test_uvc_integration extends base_test;

  // component macro
  `uvm_component_utils(test_uvc_integration)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
   yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
    uvm_config_wrapper::set(this, "tb.hbus.masters[0].sequencer.run_phase",
                            "default_sequence",
                            hbus_small_packet_seq::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                            "default_sequence",
                            test_uvc_seq::get_type());
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                            "default_sequence",
                            channel_rx_resp_seq::get_type());
    super.build_phase(phase);
  endfunction: build_phase

endclass : test_uvc_integration

//------------------------------------------------------------------------------
//
// CLASS: test_mc
// Multichannel sequencer test for lab08_mcseq
//
//------------------------------------------------------------------------------

class test_mc extends base_test;

  // component macro
  `uvm_component_utils(test_mc)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
   yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
    uvm_config_wrapper::set(this, "tb.mcsequencer.run_phase",
                            "default_sequence",
                            router_simple_mcseq::get_type());
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                            "default_sequence",
                            channel_rx_resp_seq::get_type());

   super.build_phase(phase);
  endfunction : build_phase

endclass : test_mc


/*-----------------------------------------------------------------
File name     : uvm_reset_test.sv
Developers    : Lisa Barbay, Brian Dickinson
Created       : 7/11/12
Description   : This file calls the built-in reset test
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2012 
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: uvm_reset_test
//-----------------------------------------------------------------------------

class  uvm_reset_test extends base_test;

    uvm_reg_hw_reset_seq reset_seq;

  // component macro
  `uvm_component_utils(uvm_reset_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     reset_seq.model = tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
     reset_seq.start(null);
     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
     
  endtask

endclass : uvm_reset_test


//------------------------------------------------------------------------------
//
// CLASS: uvm_mem_walk_test
//-----------------------------------------------------------------------------

class  uvm_mem_walk_test extends base_test;

    uvm_mem_walk_seq mem_walk_seq;

  // component macro
  `uvm_component_utils(uvm_mem_walk_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      mem_walk_seq = uvm_mem_walk_seq::type_id::create("mem_walk_seq");
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     mem_walk_seq.model = tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
     mem_walk_seq.start(null);
     phase.drop_objection(this,{"Raising Objection ",get_type_name()});
     
  endtask

endclass : uvm_mem_walk_test

//--------------------------------------
//
// CLASS: reg_access_test
//-----------------------------------------------------------------------------

class  reg_access_test extends base_test;

  // component macro
  `uvm_component_utils(reg_access_test)

  yapp_regs_c yapp_regs;
  
  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      super.build_phase(phase);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    yapp_regs = tb.yapp_rm.router_yapp_regs;
  endfunction

  virtual task run_phase (uvm_phase phase);
     int rdata, wrdata;
     uvm_status_e status;
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     
     // read/write access check - en_reg
// Front-door write a unique value.
// Peek and check the DUT value matches.
// Poke a new value.
// Front-door read this new value.
    `uvm_info("ACCESS_TEST", "RW test FDwr/peek/poke/FDrd en_reg", UVM_NONE)
    wrdata = 8'hA5;
    yapp_regs.en_reg.write(status, wrdata);
    `uvm_info("API_TEST", $sformatf("WROTE FD en_reg:0x%0h", wrdata), UVM_NONE)
    yapp_regs.en_reg.peek(status, rdata);
    `uvm_info("API_TEST", $sformatf("PEEK en_reg:0x%0h",rdata), UVM_NONE)
    yapp_regs.en_reg.poke(status, ~wrdata);
    `uvm_info("API_TEST", $sformatf("POKE en_reg:0x%0h", ~wrdata), UVM_NONE)
    yapp_regs.en_reg.read(status, rdata, UVM_FRONTDOOR);
    `uvm_info("API_TEST", $sformatf("READ FD en_reg:0x%0h",rdata), UVM_NONE)

    `uvm_info("ACCESS_TEST", "RO test poke/FDrd/FDwr/peek addr0_cnt_reg", UVM_NONE)
    yapp_regs.addr0_cnt_reg.poke(status, wrdata);
    `uvm_info("API_TEST", $sformatf("POKE addr0_cnt_reg:0x%0h", wrdata), UVM_NONE)
    yapp_regs.addr0_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
    `uvm_info("API_TEST", $sformatf("READ FD addr0_cnt_reg:0x%0h", rdata), UVM_NONE)
    yapp_regs.addr0_cnt_reg.write(status, ~wrdata, UVM_FRONTDOOR);
    `uvm_info("API_TEST", $sformatf("WROTE FD addr0_cnt_reg:0x%0h", ~wrdata), UVM_NONE)  
    yapp_regs.addr0_cnt_reg.peek(status, rdata);
    `uvm_info("API_TEST", $sformatf("PEEK addr0_cnt_reg:0x%0h", rdata), UVM_NONE)

     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
     
  endtask

endclass : reg_access_test

//------------------------------------------------------------------------------
//
// CLASS: reg_function_test
//-----------------------------------------------------------------------------

class  reg_function_test extends base_test;

  // component macro
  `uvm_component_utils(reg_function_test)

  yapp_regs_c yapp_regs;
  yapp_tx_sequencer yapp_seqr;
  
  yapp_012_seq yapp012;

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                            "default_sequence",
                            channel_rx_resp_seq::get_type());
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      yapp012 = yapp_012_seq::type_id::create("yapp012", this); 
      super.build_phase(phase);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    yapp_regs = tb.yapp_rm.router_yapp_regs;
    yapp_seqr = tb.yapp.tx_agent.sequencer;
  endfunction

  virtual task run_phase (uvm_phase phase);
     int rdata;
     uvm_status_e status;
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     // enable automatic checking on read
     tb.yapp_rm.default_map.set_check_on_read(0);
     
     // Set router enable bit only (default)
    yapp_regs.en_reg.write(status, 8'h01);
    `uvm_info("REG_SEQ", "Wrote 8'h01 to en_reg", UVM_NONE )
    // Read en_reg
    yapp_regs.en_reg.read(status, rdata);
    assert (rdata == 8'h01)
      `uvm_info("REG_SEQ", $sformatf("Read %h from en_reg", rdata), UVM_NONE )
    else
      `uvm_error("REG_SEQ", $sformatf("Read %h from en_reg - expected 8'h01", rdata))

    // send 3 consecutive packets to addresses 0,1,2,
    yapp012.start(yapp_seqr);

    // Read addr0 packet counter
    yapp_regs.addr0_cnt_reg.read(status, rdata);
    assert (rdata == 8'h00)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr0_cnt_reg", rdata), UVM_NONE )
    else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr0_cnt_reg - expected 8'h00", rdata))
    // Read addr1 packet counter
    yapp_regs.addr1_cnt_reg.read(status, rdata);
    assert (rdata == 8'h00)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr1_cnt_reg", rdata), UVM_NONE )
    else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr1_cnt_reg - expected 8'h00", rdata))
    // Read addr2 packet counter
    yapp_regs.addr2_cnt_reg.read(status, rdata);
    assert (rdata == 8'h00)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr2_cnt_reg", rdata), UVM_NONE )
    else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr2_cnt_reg - expected 8'h00", rdata))
    // Read illegal (addr3) packet counter
    yapp_regs.addr3_cnt_reg.read(status, rdata);
    assert (rdata == 8'h00)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr3_cnt_reg", rdata), UVM_NONE )
    else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr3_cnt_reg - expected 8'h00", rdata))

     // enable router and all counters - 'hff ignoring reserved bit
    yapp_regs.en_reg.write(status, 8'hff);
    `uvm_info("REG_SEQ", "Wrote 8'hff to en_reg", UVM_NONE )
     
    // send 6 consecutive packets to addresses 0,1,2, cycling the address
    yapp012.start(yapp_seqr);
    yapp012.start(yapp_seqr);

    // Read addr0 packet counter
    yapp_regs.addr0_cnt_reg.read(status, rdata);
    assert (rdata == 8'h02)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr0_cnt_reg", rdata), UVM_NONE )
    else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr0_cnt_reg - expected 8'h02", rdata))
    // Read addr1 packet counter
    yapp_regs.addr1_cnt_reg.read(status, rdata);
    assert (rdata == 8'h02)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr1_cnt_reg", rdata), UVM_NONE )
    else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr1_cnt_reg - expected 8'h02", rdata))
    // Read addr2 packet counter
    yapp_regs.addr2_cnt_reg.read(status, rdata);
    assert (rdata == 8'h02)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr2_cnt_reg", rdata), UVM_NONE )
    else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr2_cnt_reg - expected 8'h02", rdata))
    // Read illegal (addr3) packet counter
    yapp_regs.addr3_cnt_reg.read(status, rdata);
    assert (rdata == 8'h00)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr3_cnt_reg", rdata), UVM_NONE )
    else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr3_cnt_reg - expected 8'h00", rdata))

    // Read parity error counter 
    yapp_regs.parity_err_cnt_reg.read(status, rdata);
    `uvm_info("REG_SEQ", $sformatf("Read %h from parity_err_cnt_reg", rdata), UVM_NONE )
    // Read oversized (dropped) packet counter 
    yapp_regs.oversized_pkt_cnt_reg.read(status, rdata);
    `uvm_info("REG_SEQ", $sformatf("Read %h from oversized_pkt_cnt_reg", rdata), UVM_NONE )
    yapp_regs.mem_size_reg.read(status, rdata);
    `uvm_info("REG_SEQ", $sformatf("Read %h from mem_size_reg", rdata), UVM_NONE )

     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
     
  endtask

endclass : reg_function_test

//------------------------------------------------------------------------------
//
// CLASS: check_on_read_test
//-----------------------------------------------------------------------------

class  check_on_read_test extends base_test;

  // component macro
  `uvm_component_utils(check_on_read_test)

  yapp_regs_c yapp_regs;
  yapp_tx_sequencer yapp_seqr;
  
  yapp_012_seq yapp012;

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                            "default_sequence",
                            channel_rx_resp_seq::get_type());
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      yapp012 = yapp_012_seq::type_id::create("yapp012", this); 
      super.build_phase(phase);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    yapp_regs = tb.yapp_rm.router_yapp_regs;
    yapp_seqr = tb.yapp.tx_agent.sequencer;
  endfunction

  virtual task run_phase (uvm_phase phase);
     int rdata;
     uvm_status_e status;
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     // enable automatic checking on read
     tb.yapp_rm.default_map.set_check_on_read(0);
     
     // Set router enable bit only (default)
    yapp_regs.en_reg.write(status, 8'h01);
    `uvm_info("REG_SEQ", "Wrote 8'h01 to en_reg", UVM_NONE )
    // Read en_reg
    yapp_regs.en_reg.read(status, rdata);
    // checking now automatic

    // send 3 consecutive packets to addresses 0,1,2,
    yapp012.start(yapp_seqr);

    // Read addr0 packet counter
    yapp_regs.addr0_cnt_reg.mirror(status, UVM_CHECK);
    // Read addr1 packet counter
    yapp_regs.addr1_cnt_reg.mirror(status, UVM_CHECK);
    // Read addr2 packet counter
    yapp_regs.addr2_cnt_reg.mirror(status, UVM_CHECK);
    // Read illegal (addr3) packet counter
    yapp_regs.addr3_cnt_reg.mirror(status, UVM_CHECK);

     // enable router and all counters - 'hff ignoring reserved bit
    yapp_regs.en_reg.write(status, 8'hff);
    `uvm_info("REG_SEQ", "Wrote 8'hff to en_reg", UVM_NONE )
     
    // send 6 consecutive packets to addresses 0,1,2, cycling the address
    yapp012.start(yapp_seqr);
    yapp012.start(yapp_seqr);

    // Read addr0 packet counter
    yapp_regs.addr0_cnt_reg.predict(2);
    yapp_regs.addr0_cnt_reg.mirror(status, UVM_CHECK);
    // Read addr1 packet counter
    yapp_regs.addr1_cnt_reg.predict(2);
    yapp_regs.addr1_cnt_reg.mirror(status, UVM_CHECK);
    // Read addr2 packet counter
    yapp_regs.addr2_cnt_reg.predict(2);
    yapp_regs.addr2_cnt_reg.mirror(status, UVM_CHECK);
    // Read illegal (addr3) packet counter
    yapp_regs.addr3_cnt_reg.predict(0);
    yapp_regs.addr3_cnt_reg.mirror(status, UVM_CHECK);

    // Read parity error counter 
    yapp_regs.parity_err_cnt_reg.read(status, rdata);
    `uvm_info("REG_SEQ", $sformatf("Read %h from parity_err_cnt_reg", rdata), UVM_NONE )
    // Read oversized (dropped) packet counter 
    yapp_regs.oversized_pkt_cnt_reg.read(status, rdata);
    `uvm_info("REG_SEQ", $sformatf("Read %h from oversized_pkt_cnt_reg", rdata), UVM_NONE )
    yapp_regs.mem_size_reg.read(status, rdata);
    `uvm_info("REG_SEQ", $sformatf("Read %h from mem_size_reg", rdata), UVM_NONE )

     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
     
  endtask

endclass : check_on_read_test

//--------------------------------------
//
// CLASS: introspect_test
//-----------------------------------------------------------------------------

class  introspect_test extends base_test;

  // component macro
  `uvm_component_utils(introspect_test)

  yapp_regs_c yapp_regs;
  
  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     int rdata, wrdata, ok;
     uvm_status_e status;
     uvm_reg qreg[$], rwregs[$], roregs[$];
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     
     yapp_regs.get_registers(qreg);
     foreach (qreg[i])
       `uvm_info("ALLREG",$sformatf("%s",qreg[i].get_name()),UVM_NONE)
     
     foreach (qreg[i])
       if (qreg[i].get_rights() == "RO")
         roregs.push_back(qreg[i]);
     foreach (roregs[i])
       `uvm_info("ROREG",$sformatf("%s",roregs[i].get_name()),UVM_NONE)

     rwregs = qreg.find(i) with (i.get_rights() == "RW");
     foreach (rwregs[i])
       `uvm_info("RWREG",$sformatf("%s",rwregs[i].get_name()),UVM_NONE)


     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
     
  endtask

endclass : introspect_test

