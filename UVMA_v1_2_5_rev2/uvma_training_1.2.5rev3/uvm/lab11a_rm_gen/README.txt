Model Generation Lab

This lab uses Cadence's reg_verifier tool to convert an IP-XACT XML register
specification into a UVM register model.

Use the following command to generate the register model:

reg_verifier -domain uvmreg -top yapp_router_regs.xml -dut_name yapp_router_regs -out_file yapp_router_regs -cov -quicktest -pkg yapp_router_reg_pkg

where:
-domain uvmreg creates a UVM register model
-top yapp_router_regs.xml is the input IP-XACT register definition file
-dut_name is yapp_router, the name of the top level component in the IP-XACT file
-out_file yapp_router_regs is the name of the output file containing the UVM register model
-cov enables coverage
-quicktest creates the quicktest testbench
-pkg creates a package named yapp_router_reg_pkg for the register model

The output file is created in the directory reg_verifier_dir/uvmreg. To
run the quicktest, change to this directory and execute:

> make run_test

Check the printed register hierarchy matches your expectations.


