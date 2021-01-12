/*-----------------------------------------------------------------
File name     : lab06run.f
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif simulator run file
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/
// 64 bit option required for AWS labs
-64

-uvmhome $UVMHOME

// include directories, starting with UVM src directory
-incdir ../sv

// options
//+UVM_VERBOSITY=UVM_HIGH 
//+UVM_TESTNAME=base_test
//+UVM_TESTNAME=short_yapp_012
//+UVM_TESTNAME=incr_payload_test
//+UVM_TESTNAME=short_packet_test
+UVM_TESTNAME=exhaustive_seq_test
//+SVSEED=random 

// uncomment for gui
//-gui
//+access+rwc

// default timescale
-timescale 1ns/1ns

// compile files
// UVC package
../sv/yapp_pkg.sv

// UVC interfaces
../sv/yapp_if.sv 

// clock generator module
clkgen.sv
// top module for UVM test environment
tb_top.sv
// accelerated top module for interface instance
//hw_top_no_dut.sv
hw_top_dut.sv
// router RTL
../../router_rtl/yapp_router.sv
