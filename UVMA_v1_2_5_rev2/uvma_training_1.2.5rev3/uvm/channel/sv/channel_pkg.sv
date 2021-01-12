/*-----------------------------------------------------------------
File name     : channel_pkg.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : Channel UVC package for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015 
-----------------------------------------------------------------*/

package channel_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"


typedef uvm_config_db#(virtual channel_if) channel_vif_config;

//import yapp_pkt_pkg::*;
`include "channel_packet.sv"
`include "channel_resp.sv"

`include "channel_rx_monitor.sv"
`include "channel_rx_sequencer.sv"
`include "channel_rx_driver.sv"
`include "channel_rx_agent.sv"
`include "channel_rx_seqs.sv"

`include "channel_env.sv"

endpackage : channel_pkg
