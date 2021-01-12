/*-----------------------------------------------------------------
File name     : channel_rx_monitor.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : Channel UVC monitor for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015 
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: channel_rx_monitor
//
//------------------------------------------------------------------------------

class channel_rx_monitor extends uvm_monitor;

  // Virtual Interface for monitoring DUT signals
  virtual interface channel_if vif;

  // Collected Data
  channel_packet   packet_collected;

  // Count packets collected
  int num_pkt_col;

  // Instance ID for transaction recording
  int channel_id;
  string instance_id;
 
  // The following two bits are used to control whether checks and coverage are
  // done in the monitor
  bit checks_enable = 1;
  bit coverage_enable = 1;

  // TLM ports used to connect the monitor to the scoreboard
  uvm_analysis_port #(channel_packet) item_collected_port;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(channel_rx_monitor)
    `uvm_field_int(channel_id, UVM_ALL_ON)
    `uvm_field_int(checks_enable, UVM_ALL_ON)
    `uvm_field_int(coverage_enable, UVM_ALL_ON)
  `uvm_component_utils_end

  // packet collected covergroup
  //covergroup cover_packet @cov_packet;
  covergroup cover_packet;
    option.per_instance = 1;
    packet_length : coverpoint packet_collected.length { 
                     bins ONE =    { 1 };
                     bins SMALL =  { [2:10] };
                     bins MEDIUM = { [11:20] };
                     bins LARGE =  { [20:62] };
                     bins MAX =    { 63 };
                     bins illegal = default;
                    }
    packet_parity_type : coverpoint packet_collected.parity_type;
  endgroup : cover_packet

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create the covergroup if coverage is enabled

    if (!uvm_config_int::get(this,"","coverage_enable",coverage_enable))
      `uvm_info("NOCOV",{"Coverage not enabled for: ",get_full_name()}, UVM_MEDIUM)
    if (coverage_enable) begin
      cover_packet = new();
      cover_packet.set_inst_name({get_full_name(), ".cover_packet"});
    end
    // Create the TLM port
    item_collected_port = new("item_collected_port", this);
  endfunction : new
 
  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task collect_packet();
  extern function void perform_coverage();
  extern virtual function void report_phase(uvm_phase phase);

endclass : channel_rx_monitor

// UVM build_phase()
function void channel_rx_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  // convert channel id to Instance ID for transaction recording
  case (channel_id)
    0: instance_id = "Channel_0";
    1: instance_id = "Channel_1";
    2: instance_id = "Channel_2";
    default: instance_id = "Unknown_Channel";
  endcase

endfunction: build_phase

function void channel_rx_monitor::connect_phase(uvm_phase phase);
  // get virtual interface
  if (!channel_vif_config::get(this, get_full_name(),"vif", vif))
    `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
endfunction: connect_phase

// UVM run_phase() 
task channel_rx_monitor::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "Inside the run() phase", UVM_MEDIUM)

  // Look for packets after reset
  @(negedge vif.reset)
  `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin
      collect_packet();
      if (coverage_enable) perform_coverage();
    end
  endtask : run_phase

  // Collect channel_packets
  task channel_rx_monitor::collect_packet();

      // Create separate collected packet instance for every collected packet
      packet_collected = channel_packet::type_id::create("packet_collected", this);

      fork
        // collect packet
        vif.collect_pkt(packet_collected.length,
                        packet_collected.addr,
                        packet_collected.payload,
                        packet_collected.parity);

        // Begin transaction recording at start of packet
        @(posedge vif.pktstart) void'(this.begin_tr(packet_collected, {instance_id, "_Packet"}));
     join 

      if (packet_collected.addr != channel_id)
        `uvm_error("CHANNEL_ID", $sformatf("packet address %0d does not match Channel ID %0d", packet_collected.addr,channel_id))
      packet_collected.parity_type = (packet_collected.parity == packet_collected.calc_parity()) ? GOOD_PARITY : BAD_PARITY;

      // End transaction recording
      this.end_tr(packet_collected);

      `uvm_info(get_type_name(), $sformatf("%s Packet collected :\n%s", instance_id, packet_collected.sprint()), UVM_LOW)
      // Send packet to scoreboard via TLM write()
      item_collected_port.write(packet_collected);
      num_pkt_col++;
  endtask : collect_packet

  // Triggers coverage events
  function void channel_rx_monitor::perform_coverage();
    cover_packet.sample();
  endfunction : perform_coverage

  // UVM report_phase() phase
  function void channel_rx_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: %s Monitor Collected %0d Packets", instance_id, num_pkt_col), UVM_LOW)
  endfunction : report_phase

