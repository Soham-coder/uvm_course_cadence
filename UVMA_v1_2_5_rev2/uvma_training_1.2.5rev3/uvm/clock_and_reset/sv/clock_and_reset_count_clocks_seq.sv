/* Copyright Cadence Design Systems (c) 2015  */

class clock_and_reset_count_clocks_sequence extends uvm_sequence #(clock_and_reset_sequence_item);

  `uvm_object_utils( clock_and_reset_count_clocks_sequence)

  int clock_cycles_to_count;
  bit error_if_reached;

  REQ req;
  RSP rsp;

  function new(string name = "");
    super.new(name);
  endfunction

  task body();
  
    `uvm_info(get_type_name(), "starting body clock_and_reset_count_clocks_seq", UVM_LOW)
  
    // send a single sequence item in so the interrupt sequence knows who to return responses to
    if (clock_cycles_to_count > 0) begin
      req = clock_and_reset_sequence_item::type_id::create("req");
      start_item(req);
      req.clock_period          = 0;
      req.reset_delay           = 0;
      req.run_clock             = 0;
      req.clock_cycles_to_count = clock_cycles_to_count;
      finish_item(req);
  
      // wait for the interrupt monitor response
      `uvm_info(get_type_name(), $sformatf("Waiting for %0d clock cycles", clock_cycles_to_count), UVM_LOW)
  
      get_response(rsp);
      `uvm_info(get_type_name(), $sformatf("finished counting %0d clocks", rsp.clock_cycles_to_count), UVM_LOW)
  
      if (error_if_reached == 1'b1) begin
        `uvm_error(get_type_name(), "Finished counting clocks and the error_if_reached was set,timeout hit!")
      end
    end
    else begin
      `uvm_warning(get_type_name(), "you asked to wait for 0 clock cycles: instant return")
    end
    
  endtask
  
endclass
