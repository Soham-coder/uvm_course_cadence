/* Copyright Cadence Design Systems (c) 2015  */

class clock_and_reset_driver extends uvm_driver #(clock_and_reset_sequence_item);

  `uvm_component_utils(clock_and_reset_driver)

  // sequence_item handles
  clock_and_reset_sequence_item      item_to_queue;
  clock_and_reset_sequence_item      count_clocks_request_queue[$];

  // virtual interface
  virtual clock_and_reset_if  vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
  
    super.build_phase(phase);
  
  endfunction

  function void connect_phase(uvm_phase phase);
  
    if(!clock_and_reset_vif_config::get(this, "", "vif", vif))
        `uvm_error(get_type_name(), $sformatf("virtual interface must be set for: %s vif", get_full_name()))
  
  endfunction
  
  task run_phase(uvm_phase phase);
  
    fork
      issue_count_clocks_response();
    join_none;
  
    forever begin
      seq_item_port.get(req);
      if (req.clock_cycles_to_count == 0) begin
        if (req.clock_period < 2) begin
          `uvm_fatal(get_type_name(), $sformatf("clock_period must be greater than 1, clock_period = %0d",
                     req.clock_period))
        end
        vif.start_clock(req.clock_period, req.reset_delay, req.run_clock);
      end
      else begin
        queue_count_clock_requests(req);
      end
    end
  
  endtask
  
  // when a new count clocks req arrives calculate where it should fit in the
  // count_clocks_request_queue and calculate the value the timer should be set to
  task queue_count_clock_requests(
    input clock_and_reset_sequence_item clock_count_req);
  
    // first clone the item to ensure that the item isn't modified
    // when it is in the queue
    item_to_queue = clock_and_reset_sequence_item::type_id::create("item_to_queue");
    $cast(item_to_queue,clock_count_req.clone());
    item_to_queue.set_id_info(clock_count_req);
  
    // next calculate the cycles to count
  
    //1) At the exact expiration of each requested count we return a response
    //   item to the sequence
    //2) Incoming items will be inserted in a queue before the item that need
    //   more count than themselves
    //3) The sum of the counts before inserted item is subtracted from requested
    //   items count
    //4) The count inserted is then subtracted from the next count
  
    //For example:
    //Suppose the queue has scheduled counts of {10, 30, 1} (initial requests
    // were 10, 40, 41)
    //when we get new requests of 19 and 61
    //To make sure expiration of each request follows the rules #2-4, the queue
    // will transform as:
    //A) Insert of 20 gives a scheduled count queue of {10, 19-10, 30-9, 1}
    //   (initial requests were 10, 19, 40, 41)
    //B) Insert of 60 gives a scheduled count queue of {10, 9, 21, 1, 61-41}
    //   (initial requests were 10, 19, 40, 41, 61)
  
    if ( count_clocks_request_queue.size() == 0 ) begin
      // then this is the first delay request we are waiting on ....
      // queue up the first item and kick off the counter in the interface.....
      item_to_queue.clock_cycles_to_count = clock_count_req.clock_cycles_to_count;
      vif.count_clocks(item_to_queue.clock_cycles_to_count);
  
      `uvm_info(get_type_name(),
                $sformatf("New delay of %0d arrived, starting delay counter",
                          item_to_queue.clock_cycles_to_count), UVM_LOW)
  
      count_clocks_request_queue.push_front(item_to_queue);
    end
    else begin
      // insert request into queue
      int total_clock_cycles_to_count = 0;
      int current_cycle_count;
  
      //time before next expiration written to first queued item
      vif.get_current_cycle_count(current_cycle_count);
      count_clocks_request_queue[0].clock_cycles_to_count = current_cycle_count;
  
      if(item_to_queue.clock_cycles_to_count < current_cycle_count) begin
        //put shorter count item first in queue and configure interface counter
        count_clocks_request_queue.push_front(item_to_queue);
        count_clocks_request_queue[1].clock_cycles_to_count = current_cycle_count - item_to_queue.clock_cycles_to_count;
        vif.count_clocks(item_to_queue.clock_cycles_to_count);
  
        `uvm_info(get_type_name(),
                  $sformatf("New shorter than current count of %0d arrived, starting delay counter",
                             item_to_queue.clock_cycles_to_count), UVM_LOW)
      end else if(item_to_queue.clock_cycles_to_count == current_cycle_count) begin
        //insert redundant count first in queue
        item_to_queue.clock_cycles_to_count = 0;
        count_clocks_request_queue.push_front(item_to_queue);
      end else begin
        //insert item in queue
        for (int index=0; index<count_clocks_request_queue.size();index++) begin
          if (item_to_queue.clock_cycles_to_count >
                total_clock_cycles_to_count &&
                item_to_queue.clock_cycles_to_count <
                total_clock_cycles_to_count +
                count_clocks_request_queue[index].clock_cycles_to_count
             ) begin
            //subtract total count before this item, insert item and subtract
            //inserted count from next
            item_to_queue.clock_cycles_to_count -= total_clock_cycles_to_count;
            count_clocks_request_queue.insert(index, item_to_queue);
            count_clocks_request_queue[index+1].clock_cycles_to_count -=
                               item_to_queue.clock_cycles_to_count;
            break;
          end else if(index == count_clocks_request_queue.size()-1) begin
            //last item
            if(item_to_queue.clock_cycles_to_count < count_clocks_request_queue[$].clock_cycles_to_count) begin
              //insert smaller count in front of last item
              item_to_queue.clock_cycles_to_count -= total_clock_cycles_to_count;
              count_clocks_request_queue.insert(index,item_to_queue);
              count_clocks_request_queue[$].clock_cycles_to_count -= item_to_queue.clock_cycles_to_count;
            end else begin
              //insert larger count last in queue
              total_clock_cycles_to_count += count_clocks_request_queue[index].clock_cycles_to_count;
              item_to_queue.clock_cycles_to_count -= total_clock_cycles_to_count;
              count_clocks_request_queue.push_back(item_to_queue);
            end
            break;
          end
          total_clock_cycles_to_count += count_clocks_request_queue[index].clock_cycles_to_count;
        end
      end
    end
    for (int index=0; index<count_clocks_request_queue.size();index++) begin
      `uvm_info(get_type_name(),
                $sformatf("count_clocks_request_queue[%0d].clock_cycles_to_count = %0d", index,
                          count_clocks_request_queue[index].clock_cycles_to_count),
                UVM_HIGH)
    end
  
  endtask
  
  
  // when the clock_cycle_count_reached event arrives pop the response off the
  // count_clocks_request_queue queue that the timer was counting for and set the
  // counter for the next item in the queue
  task issue_count_clocks_response();
  
    clock_and_reset_sequence_item  rsp_item_to_return;
    forever begin
      //stall here until current interface count expires
      @(vif.clock_cycle_count_reached);
      `uvm_info(get_type_name(),
                "Delay counter reached 0 returning an item from the count_clocks_request_queue",UVM_HIGH)
  
      rsp_item_to_return = count_clocks_request_queue.pop_front();
      seq_item_port.put(rsp_item_to_return);
      if (count_clocks_request_queue.size() != 0) begin
        do begin
          if (count_clocks_request_queue[0].clock_cycles_to_count != 0) begin
            //schedule next count
            vif.count_clocks(count_clocks_request_queue[0].clock_cycles_to_count);
            `uvm_info(get_type_name(), $sformatf("Next queued delay of %0d, starting delay counter", count_clocks_request_queue[0].clock_cycles_to_count), UVM_HIGH)
          end
          else begin
            //pop item and send response since count is 0
            `uvm_info(get_type_name(), "Got a zero clock_cycles_to_count item from count_clocks_request_queue", UVM_HIGH)
            rsp_item_to_return = count_clocks_request_queue.pop_front();
            seq_item_port.put(rsp_item_to_return);
          end
        end while (count_clocks_request_queue.size() != 0 && rsp_item_to_return.clock_cycles_to_count == 0);
      end
    end
  endtask
  
  
  function void report_phase(uvm_phase phase);
  
    int number_of_must_happen_counts = 0;
    // if there are outstanding clock cycle counts at the end of simulation then note that
    if (count_clocks_request_queue.size() != 0) begin
      `uvm_info(get_type_name(), "count_clocks_request_queue wasn't empty - checking to see if any 'must happen' flags were set", UVM_LOW)
      // if there are any that have a "must happen" flag set then that is an error
      for (int item=0;item< count_clocks_request_queue.size();item++) begin
        if (count_clocks_request_queue[item].cycle_count_must_happen == 1) begin
          number_of_must_happen_counts++;
        end
      end
      if (number_of_must_happen_counts > 0) begin
        `uvm_error(get_type_name(), $sformatf("There were %0d clock counts with the 'must happen' flag set at the end of simulation", number_of_must_happen_counts))
      end
    end
  
  endfunction 

endclass

