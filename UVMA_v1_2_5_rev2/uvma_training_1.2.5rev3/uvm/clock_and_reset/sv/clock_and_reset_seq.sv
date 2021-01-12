/* Copyright Cadence Design Systems (c) 2015  */

class clock_and_reset_sequence extends uvm_sequence #(clock_and_reset_sequence_item);

  `uvm_object_utils( clock_and_reset_sequence)

  int clock_period;
  int reset_delay;
  bit run_clock;

  REQ req;
  RSP rsp;

  function new(string name = "");
    super.new(name);
  endfunction

  task body();
  
    `uvm_info(get_type_name(), "starting body clock_and_reset_wait_seq", UVM_LOW)
  
    // send a single sequence item in so the interrupt sequence knows who to return responses to
    req = clock_and_reset_sequence_item::type_id::create("req");
    start_item(req);
    req.clock_period          = clock_period;
    req.reset_delay           = reset_delay;
    req.run_clock             = run_clock;
    req.clock_cycles_to_count = 0;
    finish_item(req);
  
  endtask
  
endclass 


class clk10_rst5_seq extends uvm_sequence #(clock_and_reset_sequence_item);

  `uvm_object_utils(clk10_rst5_seq)

  clock_and_reset_sequence cr;

  function new(string name="clk10_rst5_seq");
    super.new(name);
  endfunction : new

  task body();

    `uvm_info(get_type_name(), "Starting test_sequence sequence body", UVM_MEDIUM)

    cr = clock_and_reset_sequence::type_id::create("cr");
    cr.clock_period          = 10;
    cr.reset_delay           = 5;
    cr.run_clock             = 1;
    `uvm_send(cr)
    #300ns;
  endtask

endclass :clk10_rst5_seq
