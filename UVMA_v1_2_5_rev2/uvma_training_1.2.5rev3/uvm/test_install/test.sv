/*-----------------------------------------------------------------
File name     : test.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : UVM test class for verifying UVM installation and setup
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;
  // import the UVM library
  import uvm_pkg::*;

  // include the UVM macros
  `include "uvm_macros.svh"

class mytest extends uvm_test;

  `uvm_component_utils(mytest)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction  

  task run();
    `uvm_info(get_type_name(), "UVM TEST INSTALL PASSED!", UVM_NONE)
  endtask

endclass

initial
  begin
    run_test("mytest");
  end

endmodule : top
