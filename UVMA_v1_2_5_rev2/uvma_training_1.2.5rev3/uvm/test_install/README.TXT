Test the UVM installation: 

1) set environmental variable $UVMHOME to install path of uvm library, e.g.
setenv UVMHOME `ncroot`/tools/methodology/UVM/CDNS-1.1d

If `ncroot` dows not work, you can use "which xrun" to find the install path of
the Cadence simulator.

2) xrun -f run.f

3) Check for "UVM TEST INSTALL PASSED!" message 

