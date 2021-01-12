/*-----------------------------------------------------------------
File name     : lab03run.f
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab03_uvc simulator run file
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/
// 64 bit option required for AWS labs
-64

-uvmhome $UVMHOME

// incdir for include files
-incdir ../sv

// runtime options
+UVM_VERBOSITY=UVM_HIGH
//+UVM_TESTNAME=base_test
+UVM_TESTNAME=test2

// compile files
../sv/yapp_pkg.sv
top.sv

