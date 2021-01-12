/*-----------------------------------------------------------------
File name     : yapp_pkg.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif YAPP UVC package
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

package yapp_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

typedef uvm_config_db#(virtual yapp_if) yapp_vif_config;
`include "yapp_packet.sv"
`include "yapp_tx_monitor.sv"
`include "yapp_tx_sequencer.sv"
`include "yapp_tx_seqs.sv"
`include "yapp_tx_driver.sv"
`include "yapp_tx_agent.sv"
`include "yapp_env.sv"

endpackage
