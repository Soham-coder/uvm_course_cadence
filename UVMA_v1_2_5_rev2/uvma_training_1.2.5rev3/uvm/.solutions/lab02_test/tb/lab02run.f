/*-----------------------------------------------------------------
File name     : lab02run.f
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab02_test simulator run file
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/
// 64 bit option required for AWS labs
-64

-uvmhome $UVMHOME

// include directories
-incdir ../sv

// options
+UVM_VERBOSITY=UVM_HIGH 
// (un)comment lines to select test
//+UVM_TESTNAME=base_test
+UVM_TESTNAME=test2

// compile files
../sv/yapp_pkg.sv
top.sv
