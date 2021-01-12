/*-----------------------------------------------------------------
File name     : lab05run.f
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab05_seq simulator run file
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
+UVM_VERBOSITY=UVM_LOW 
// (un)comment lines to select test
//+UVM_TESTNAME=short_packet_test
//+UVM_TESTNAME=incr_payload_test
+UVM_TESTNAME=exhaustive_seq_test
+SVSEED=random 

// compile files
../sv/yapp_pkg.sv
top.sv

