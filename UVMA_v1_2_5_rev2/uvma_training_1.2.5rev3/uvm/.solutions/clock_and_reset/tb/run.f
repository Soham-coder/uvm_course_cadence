
-uvmhome $UVMHOME

-incdir ../sv

// uncomment for gui
//-gui
//+access+rwc

// default timescale
-timescale 1ns/100ps

// options
//+UVM_VERBOSITY=UVM_LOW
+UVM_VERBOSITY=UVM_MEDIUM

//+UVM_TESTNAME=demo_base_test
+UVM_TESTNAME=clock_reset_test

// compile files
../sv/clock_and_reset_pkg.sv
../sv/clock_and_reset_if.sv 

clkgen.sv
clock_and_reset_demo_top.sv

