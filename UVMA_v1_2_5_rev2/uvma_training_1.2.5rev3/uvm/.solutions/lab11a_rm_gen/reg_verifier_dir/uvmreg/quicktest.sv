/* ------------------------------------------------------------
 To simlulate using INCISIVE use the Makefile generated
 -------------------------------------------------------------*/

package uvc_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	// a quick and dirty UVC (parameterized)
	class UVC#(type T=uvm_object) extends uvm_component;
		`uvm_component_param_utils(UVC#(T))

		class transaction extends uvm_sequence_item;
			`uvm_object_param_utils(transaction)
			T key;

			function new(string name = "transaction");
				super.new(name);
			endfunction
		endclass

		class driver extends uvm_driver#(transaction);
			`uvm_component_param_utils(driver)

			function new (string name, uvm_component parent);
				super.new(name, parent);
			endfunction

			virtual task run_phase(uvm_phase phase);
				forever begin
					`uvm_info("DRV","sending item",UVM_NONE)
					seq_item_port.get_next_item(req);
					#10;
					$display("data:%p",req.key);
					seq_item_port.item_done();
					`uvm_info("DRV","sending item complete",UVM_NONE)
					#5;
				end
			endtask
		endclass

		function new (string name, uvm_component parent);
			super.new(name, parent);
		endfunction

		uvm_sequencer#(transaction) sqr;
		driver drv;

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sqr = uvm_sequencer#(transaction)::type_id::create("sqr",this);
			drv = driver::type_id::create("drv",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			drv.seq_item_port.connect(sqr.seq_item_export);
		endfunction
	endclass
endpackage

package quicktest;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import cdns_uvm_addons::*;
	import uvc_pkg::*;
	import yapp_router_reg_pkg::*;

	class reg2simple_adapter extends uvm_reg_adapter;
		`uvm_object_utils(reg2simple_adapter)

		function new(string name = "reg2simple");
			super.new(name);
		endfunction

		virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
			UVC#(string)::transaction bus = UVC#(string)::transaction::type_id::create("rw");
			assert(bus.randomize());
			bus.key = $sformatf("%p",rw);
			return bus;
		endfunction

		virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
		endfunction
	endclass


// User register sequence
	class cdns_test_seq extends uvm_reg_sequence;
		uvm_reg r[$];
		rand uvm_reg_data_t data;

		virtual task body();
			uvm_status_e status;
			model.get_registers(r);
			//WRITE RANDOM VALUE ON ALL REGS
			foreach(r[idx]) begin
				void'(std::randomize(data));
				r[idx].write(status, data, .parent(this));
			end
			//READ RANDOM VALUE ON ALL REGS
			foreach(r[idx]) begin
				r[idx].read(status, data, .parent(this));
			end
		endtask

		`uvm_object_utils(cdns_test_seq)
		function new(string name="test_seq");
			super.new(name);
		endfunction
	endclass

	class qt_test extends uvm_test;
		yapp_router_regs_t model;
		UVC#(string) hi_uvc0 = new("HI0",null);

		virtual function void build();
			reg2simple_adapter adapter = new();
			uvm_reg::include_coverage("*", UVM_CVR_ALL);
			model=yapp_router_regs_t::type_id::create("model", this);
			model.build();
			model.set_hdl_path_root("top.dut");
			model.router.set_auto_predict(1);
			model.router.set_sequencer(hi_uvc0.sqr,adapter);
			model.lock_model();
			void'(model.set_coverage(UVM_CVR_ALL));
		endfunction

		task run_phase(uvm_phase phase);
			uvm_reg_sequence seq;
			int x;
			phase.raise_objection(this);
			seq = cdns_test_seq::type_id::create("test_seq",,get_full_name());
			seq.model = model;
			seq.start(null,null);
			model.reset();
			model.print();
			model.default_map.print();
			phase.drop_objection(this);
		endtask

		`uvm_component_utils(qt_test)
		function new(string name, uvm_component parent);
			super.new(name,parent);
		endfunction
	endclass

	class access_test extends uvm_test;
		yapp_router_regs_t model;

		virtual function void build();
			model=yapp_router_regs_t::type_id::create("model", this);
			model.build();
			model.set_hdl_path_root("top.dut");
			model.lock_model();
		endfunction

		task run_phase(uvm_phase phase);
			uvm_reg_sequence seq;
			phase.raise_objection(this);
			seq = uvm_reg_generate_access_file_seq::type_id::create("access_seq",,get_full_name());
			seq.model = model;
			seq.start(null,null);
			model.reset();
			phase.drop_objection(this);
		endtask

		`uvm_component_utils(access_test)
		function new(string name, uvm_component parent);
			super.new(name,parent);
		endfunction
	endclass
endpackage

module test();
        import uvm_pkg::*;
        `include "uvm_macros.svh"
        import quicktest::*;
        initial begin
		run_test();
	end
endmodule

