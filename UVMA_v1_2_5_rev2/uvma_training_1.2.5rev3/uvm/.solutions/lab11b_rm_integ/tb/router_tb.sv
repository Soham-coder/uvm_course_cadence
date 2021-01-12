/*-----------------------------------------------------------------
File name     : router_tb.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab11b_integ router testbench
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: router_tb
//
//------------------------------------------------------------------------------

class router_tb extends uvm_env;

  // Register model and HBUS adapter handles
  yapp_router_regs_t  yapp_rm;
  hbus_reg_adapter    reg2hbus;

  // component macro
  `uvm_component_utils_begin(router_tb)
    `uvm_field_object(yapp_rm, UVM_ALL_ON)
  `uvm_component_utils_end

  // clock and reset UVC
  clock_and_reset_env clock_and_reset;

  // yapp environment
  yapp_env yapp;

  //Channel environmnent UVCs
  channel_env chan0;
  channel_env chan1;
  channel_env chan2;

  // HBUS UVC
  hbus_env hbus;

  // Virtual Sequencer
  router_mcsequencer mcsequencer;

  // Router module UVC
  router_env router_mod;

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // clock and reset UVC
    clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);

    // YAPP UVC
    yapp = yapp_env::type_id::create("yapp", this);

    // Channel UVC - RX ONLY
    uvm_config_int::set(this, "chan0", "channel_id", 0);
    uvm_config_int::set(this, "chan1", "channel_id", 1);
    uvm_config_int::set(this, "chan2", "channel_id", 2);
    chan0 = channel_env::type_id::create("chan0", this);
    chan1 = channel_env::type_id::create("chan1", this);
    chan2 = channel_env::type_id::create("chan2", this);

    // HBUS UVC - 1 Master and 1 Slave
    uvm_config_int::set(this, "hbus", "num_masters", 1);
    uvm_config_int::set(this, "hbus", "num_slaves", 0);
    hbus = hbus_env::type_id::create("hbus", this);

    // virtual sequencer
    mcsequencer = router_mcsequencer::type_id::create("mcsequencer", this);

     // router module UVC
    router_mod = router_env::type_id::create("router_mod", this);

    // register model
    yapp_rm = yapp_router_regs_t::type_id::create("yapp_rm",this);
    yapp_rm.build();
    yapp_rm.lock_model();
    yapp_rm.set_hdl_path_root("hw_top.dut");

    // This is implicit prediction, so make sure auto_predict is turned on.
    //  Default is to have an explicit predictor and auto_predict disabled
    yapp_rm.default_map.set_auto_predict(1);

    // Create the adapter 
    reg2hbus= hbus_reg_adapter::type_id::create("reg2bus",this);

  endfunction : build_phase

  // UVM connect_phase
  function void connect_phase(uvm_phase phase);

    // Virtual Sequencer Connections
    mcsequencer.hbus_seqr = hbus.masters[0].sequencer;
    mcsequencer.yapp_seqr = yapp.tx_agent.sequencer;

    // Connect the TLM ports from the YAPP and Channel UVCs to the scoreboard
    yapp.tx_agent.monitor.item_collected_port.connect(router_mod.reference.yapp_in);
    hbus.masters[0].monitor.item_collected_port.connect(router_mod.reference.hbus_in);
    chan0.rx_agent.monitor.item_collected_port.connect(router_mod.scoreboard.sb_chan0);
    chan1.rx_agent.monitor.item_collected_port.connect(router_mod.scoreboard.sb_chan1);
    chan2.rx_agent.monitor.item_collected_port.connect(router_mod.scoreboard.sb_chan2);

    // set sequencer and adapter of register model
    yapp_rm.default_map.set_sequencer(hbus.masters[0].sequencer, reg2hbus);

  endfunction : connect_phase

endclass : router_tb
