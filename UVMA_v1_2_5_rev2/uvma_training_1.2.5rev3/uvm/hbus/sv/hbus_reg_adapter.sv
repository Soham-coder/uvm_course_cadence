//----------------------------------------------------------------------
//  Copyright 2007-2011 Cadence Design Systems, Inc.
//  All Rights Reserved Worldwide
//
//  Licensed under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in
//  compliance with the License.  You may obtain a copy of
//  the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in
//  writing, software distributed under the License is
//  distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//  CONDITIONS OF ANY KIND, either express or implied.  See
//  the License for the specific language governing
//  permissions and limitations under the License.
//----------------------------------------------------------------------

`ifndef HBUS_REG_ADAPTER
`define HBUS_REG_ADAPTER


class hbus_reg_adapter extends uvm_reg_adapter;

    `uvm_object_utils(hbus_reg_adapter)

     function new(string name = "hbus_reg_adapter");
	super.new(name);
     endfunction 

    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);

      hbus_transaction tr = hbus_transaction::type_id::create("tr");
      tr.hwr_rd       = (rw.kind==UVM_WRITE)? hbus_pkg::HBUS_WRITE : hbus_pkg::HBUS_READ;
      tr.haddr       = rw.addr;
      tr.hdata       = rw.data;
      return tr;
    endfunction

    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
      hbus_transaction tr;
      if (!$cast(tr,bus_item)) begin 
        `uvm_fatal("HBUS_ADPTR","Provided bus_item not correct type")
        return;
      end
      rw.kind        = (tr.hwr_rd == hbus_pkg::HBUS_WRITE) ? UVM_WRITE : UVM_READ;
      rw.addr        = tr.haddr;
      rw.data        = tr.hdata;
      rw.status      = UVM_IS_OK;
    endfunction

   endclass : hbus_reg_adapter

`endif // HBUS_REG_ADAPTER
