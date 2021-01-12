/*-----------------------------------------------------------------
File name     : yapp_pkg.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab01_data yapp UVC package for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

package yapp_pkg;

  // import the UVM library
  import uvm_pkg::*;

  // include the UVM macros
  `include "uvm_macros.svh"

  // include the YAPP packet definition
  `include "yapp_packet.sv" 

endpackage : yapp_pkg
