/*-----------------------------------------------------------------
File name     : lab01run.f
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab01_data simulator run file
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/
// 64 bit option required for AWS labs
-64

-uvmhome $UVMHOME
// include directories, starting with UVM src directory
-incdir ../sv

// compile files

../sv/yapp_pkg.sv // compile YAPP package
top.sv            // compile top level module
