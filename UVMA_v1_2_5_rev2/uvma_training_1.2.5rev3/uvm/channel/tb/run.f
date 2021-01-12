/*-----------------------------------------------
 run file for channel UVC test
------------------------------------------------*/
-uvmhome $UVMHOME

// include directories, starting with UVM src directory
-incdir ../sv

// uncomment for gui
//-gui
//+access+rwc

// default timescale
-timescale 1ns/100ps

// options
+UVM_VERBOSITY=UVM_MEDIUM
//+UVM_TESTNAME=demo_base_test
+UVM_TESTNAME=default_sequence_test

// compile files
../sv/channel_pkg.sv
../sv/channel_if.sv 
demo_top.sv
