/*-----------------------------------------------------------------
File name     : channel_if.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : Channel UVC interface for accelerated UVM
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training 
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015 
-----------------------------------------------------------------*/

interface channel_if (input clock, input reset );

  // Actual Signals
  logic              data_vld;
  logic              suspend;
  logic       [7:0]  data;
  
  // transaction start flag
  bit pktstart;

  task send_response(input int resp_delay);
    @(negedge clock iff data_vld===1'b1);
    repeat(resp_delay) begin
      // Raise suspend flag if it isn't already raised
      suspend  <= 1;
      @(negedge clock);
    end
    // Lower suspend flag
    suspend  <= 0;

    // Wait until the end of the packet to complete transaction
    @(negedge clock iff data_vld===1'b0);
    suspend <= 1'b1;
 
  endtask : send_response

  task collect_pkt(output bit [5:0]  length,
                         bit [1:0]  addr,
                         bit [7:0]  payload[],
                         bit [7:0]  parity);

      //Monitor looks at the bus on posedge (Driver uses negedge)
      @(posedge clock iff (data_vld && !suspend));
      pktstart = 1'b1;

      @(posedge clock iff (!suspend))
      // Collect Header {Length, Addr}
      { length, addr }  = data;
      payload = new[length]; // Allocate the payload
      // Collect the Payload
      for (int i=0; i< length; i++) begin
         @(posedge clock iff (!suspend))
         payload[i] = data;
      end

      // Collect Parity and Compute Parity Type
       @(posedge clock)
         parity = data;
      pktstart = 1'b0;
  endtask : collect_pkt

   
endinterface : channel_if

