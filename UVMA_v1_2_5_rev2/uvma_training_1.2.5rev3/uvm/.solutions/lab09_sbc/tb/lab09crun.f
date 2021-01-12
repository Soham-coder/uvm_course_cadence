/*-----------------------------------------------------------------
File name     : lab09crun.f
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab09_sbc simulator run file
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/
// 64 bit option required for AWS labs
-64

-uvmhome $UVMHOME

// options
//+UVM_VERBOSITY=UVM_LOW 
+UVM_TESTNAME=test_mc 

// default timescale
-timescale 1ns/100ps 

// include directories
-incdir ../sv
-incdir ../../yapp/sv 
-incdir ../../channel/sv
-incdir  ../../hbus/sv 
-incdir ../../clock_and_reset/sv
-incdir ../../router/sv

// compile files

// YAPP UVC package and interface
../../yapp/sv/yapp_pkg.sv
../../yapp/sv/yapp_if.sv 

// Channel UVC package and interface
../../channel/sv/channel_pkg.sv 
../../channel/sv/channel_if.sv 

// HBUS UVC package and interface
../../hbus/sv/hbus_pkg.sv 
../../hbus/sv/hbus_if.sv 

// clock and reset UVC package
../../clock_and_reset/sv/clock_and_reset_pkg.sv 
../../clock_and_reset/sv/clock_and_reset_if.sv 

// router module package
../../router/sv/router_module_pkg.sv

// router DUT
../../router_rtl/yapp_router.sv 

// clock generator module
clkgen.sv
// top module for UVM test environment
tb_top.sv
// accelerated top module for interface instance
hw_top.sv

