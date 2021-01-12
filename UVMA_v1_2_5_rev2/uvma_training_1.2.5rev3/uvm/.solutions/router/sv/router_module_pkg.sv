/*-----------------------------------------------------------------
File name     : router_module_pkg.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : router module UVC package for lab09_sbc
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

package router_module_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import yapp_pkg::*;
import channel_pkg::*;
import hbus_pkg::*;
`include "router_scoreboard.sv"
`include "router_reference.sv"
`include "router_module_env.sv"

endpackage
