/*-----------------------------------------------------------------
File name     : router_module_pkg.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab09_sbb router module UVC package
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

package router_module_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

// import YAPP package for visibility of YAPP data item
import yapp_pkg::*;
// import Channel package for visibility of Channel data item
import channel_pkg::*;
// import HBUS package for visibility of HBUS data item
import hbus_pkg::*;
`include "router_scoreboard.sv"
`include "router_reference.sv"
`include "router_module_env.sv"

endpackage
