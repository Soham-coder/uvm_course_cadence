//*************************************************************//
//   ** File Generated Automatically
//   ** Please donot edit manually
//*************************************************************//


package yapp_router_reg_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import cdns_uvmreg_utils_pkg::*;

  bit no_factory = 0; 

/////////////////////////////////////////////////////
//                addr0_cnt_reg
/////////////////////////////////////////////////////
class addr0_cnt_reg_c extends cdns_uvm_reg;

  `uvm_object_utils(addr0_cnt_reg_c)
  rand uvm_reg_field addr0_cnt_reg_fld;
  
  covergroup wr_fld_covg;
    addr0_cnt_reg_fld: coverpoint addr0_cnt_reg_fld.value[7:0];
  endgroup
  covergroup rd_fld_covg;
    addr0_cnt_reg_fld: coverpoint addr0_cnt_reg_fld.value[7:0];
  endgroup

  protected virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      if(!is_read) begin
          wr_fld_covg.sample();
      end
      if(is_read) begin
          rd_fld_covg.sample();
      end
    end
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg.sample();
      rd_fld_covg.sample();
    end
  endfunction

  virtual function void build();
    uvm_reg_field fld_set[$];
    uvm_reg_field_config_ta ta = get_field_config(getconfigUID());
    build_uvm_reg_fields(this, ta, fld_set);
    
    addr0_cnt_reg_fld = fld_set[0];
  endfunction

  function new(input string name="addr0_cnt_reg_c");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    if (has_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg = new();
      rd_fld_covg = new();
    end
  endfunction

endclass


/////////////////////////////////////////////////////
//                addr1_cnt_reg
/////////////////////////////////////////////////////
class addr1_cnt_reg_c extends cdns_uvm_reg;

  `uvm_object_utils(addr1_cnt_reg_c)
  rand uvm_reg_field addr1_cnt_reg_fld;
  
  covergroup wr_fld_covg;
    addr1_cnt_reg_fld: coverpoint addr1_cnt_reg_fld.value[7:0];
  endgroup
  covergroup rd_fld_covg;
    addr1_cnt_reg_fld: coverpoint addr1_cnt_reg_fld.value[7:0];
  endgroup

  protected virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      if(!is_read) begin
          wr_fld_covg.sample();
      end
      if(is_read) begin
          rd_fld_covg.sample();
      end
    end
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg.sample();
      rd_fld_covg.sample();
    end
  endfunction

  virtual function void build();
    uvm_reg_field fld_set[$];
    uvm_reg_field_config_ta ta = get_field_config(getconfigUID());
    build_uvm_reg_fields(this, ta, fld_set);
    
    addr1_cnt_reg_fld = fld_set[0];
  endfunction

  function new(input string name="addr1_cnt_reg_c");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    if (has_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg = new();
      rd_fld_covg = new();
    end
  endfunction

endclass


/////////////////////////////////////////////////////
//                addr2_cnt_reg
/////////////////////////////////////////////////////
class addr2_cnt_reg_c extends cdns_uvm_reg;

  `uvm_object_utils(addr2_cnt_reg_c)
  rand uvm_reg_field addr2_cnt_reg_fld;
  
  covergroup wr_fld_covg;
    addr2_cnt_reg_fld: coverpoint addr2_cnt_reg_fld.value[7:0];
  endgroup
  covergroup rd_fld_covg;
    addr2_cnt_reg_fld: coverpoint addr2_cnt_reg_fld.value[7:0];
  endgroup

  protected virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      if(!is_read) begin
          wr_fld_covg.sample();
      end
      if(is_read) begin
          rd_fld_covg.sample();
      end
    end
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg.sample();
      rd_fld_covg.sample();
    end
  endfunction

  virtual function void build();
    uvm_reg_field fld_set[$];
    uvm_reg_field_config_ta ta = get_field_config(getconfigUID());
    build_uvm_reg_fields(this, ta, fld_set);
    
    addr2_cnt_reg_fld = fld_set[0];
  endfunction

  function new(input string name="addr2_cnt_reg_c");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    if (has_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg = new();
      rd_fld_covg = new();
    end
  endfunction

endclass


/////////////////////////////////////////////////////
//                addr3_cnt_reg
/////////////////////////////////////////////////////
class illegal_addr_cnt_reg_c extends cdns_uvm_reg;

  `uvm_object_utils(illegal_addr_cnt_reg_c)
  rand uvm_reg_field addr3_cnt_reg_fld;
  
  covergroup wr_fld_covg;
    addr3_cnt_reg_fld: coverpoint addr3_cnt_reg_fld.value[7:0];
  endgroup
  covergroup rd_fld_covg;
    addr3_cnt_reg_fld: coverpoint addr3_cnt_reg_fld.value[7:0];
  endgroup

  protected virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      if(!is_read) begin
          wr_fld_covg.sample();
      end
      if(is_read) begin
          rd_fld_covg.sample();
      end
    end
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg.sample();
      rd_fld_covg.sample();
    end
  endfunction

  virtual function void build();
    uvm_reg_field fld_set[$];
    uvm_reg_field_config_ta ta = get_field_config(getconfigUID());
    build_uvm_reg_fields(this, ta, fld_set);
    
    addr3_cnt_reg_fld = fld_set[0];
  endfunction

  function new(input string name="illegal_addr_cnt_reg_c");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    if (has_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg = new();
      rd_fld_covg = new();
    end
  endfunction

endclass


/////////////////////////////////////////////////////
//                ctrl_reg
/////////////////////////////////////////////////////
class ctrl_reg_c extends cdns_uvm_reg;

  `uvm_object_utils(ctrl_reg_c)
  rand uvm_reg_field plen;
  rand uvm_reg_field rsvd_0;
  
  covergroup wr_fld_covg;
    plen: coverpoint plen.value[5:0];
    rsvd_0: coverpoint rsvd_0.value[7:6];
  endgroup
  covergroup rd_fld_covg;
    plen: coverpoint plen.value[5:0];
    rsvd_0: coverpoint rsvd_0.value[7:6];
  endgroup

  protected virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      if(!is_read) begin
          wr_fld_covg.sample();
      end
      if(is_read) begin
          rd_fld_covg.sample();
      end
    end
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg.sample();
      rd_fld_covg.sample();
    end
  endfunction

  virtual function void build();
    uvm_reg_field fld_set[$];
    uvm_reg_field_config_ta ta = get_field_config(getconfigUID());
    build_uvm_reg_fields(this, ta, fld_set);
    
    plen = fld_set[0];
    rsvd_0 = fld_set[1];
  endfunction

  function new(input string name="ctrl_reg_c");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    if (has_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg = new();
      rd_fld_covg = new();
    end
  endfunction

endclass


/////////////////////////////////////////////////////
//                en_reg
/////////////////////////////////////////////////////
class en_reg_c extends cdns_uvm_reg;

  `uvm_object_utils(en_reg_c)
  rand uvm_reg_field router_en;
  rand uvm_reg_field parity_err_cnt_en;
  rand uvm_reg_field oversized_pkt_cnt_en;
  rand uvm_reg_field rsvd_0;
  rand uvm_reg_field addr0_cnt_en;
  rand uvm_reg_field addr1_cnt_en;
  rand uvm_reg_field addr2_cnt_en;
  rand uvm_reg_field addr3_cnt_en;
  
  covergroup wr_fld_covg;
    router_en: coverpoint router_en.value[0:0];
    parity_err_cnt_en: coverpoint parity_err_cnt_en.value[1:1];
    oversized_pkt_cnt_en: coverpoint oversized_pkt_cnt_en.value[2:2];
    rsvd_0: coverpoint rsvd_0.value[3:3];
    addr0_cnt_en: coverpoint addr0_cnt_en.value[4:4];
    addr1_cnt_en: coverpoint addr1_cnt_en.value[5:5];
    addr2_cnt_en: coverpoint addr2_cnt_en.value[6:6];
    addr3_cnt_en: coverpoint addr3_cnt_en.value[7:7];
  endgroup
  covergroup rd_fld_covg;
    router_en: coverpoint router_en.value[0:0];
    parity_err_cnt_en: coverpoint parity_err_cnt_en.value[1:1];
    oversized_pkt_cnt_en: coverpoint oversized_pkt_cnt_en.value[2:2];
    rsvd_0: coverpoint rsvd_0.value[3:3];
    addr0_cnt_en: coverpoint addr0_cnt_en.value[4:4];
    addr1_cnt_en: coverpoint addr1_cnt_en.value[5:5];
    addr2_cnt_en: coverpoint addr2_cnt_en.value[6:6];
    addr3_cnt_en: coverpoint addr3_cnt_en.value[7:7];
  endgroup

  protected virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      if(!is_read) begin
          wr_fld_covg.sample();
      end
      if(is_read) begin
          rd_fld_covg.sample();
      end
    end
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg.sample();
      rd_fld_covg.sample();
    end
  endfunction

  virtual function void build();
    uvm_reg_field fld_set[$];
    uvm_reg_field_config_ta ta = get_field_config(getconfigUID());
    build_uvm_reg_fields(this, ta, fld_set);
    
    router_en = fld_set[0];
    parity_err_cnt_en = fld_set[1];
    oversized_pkt_cnt_en = fld_set[2];
    rsvd_0 = fld_set[3];
    addr0_cnt_en = fld_set[4];
    addr1_cnt_en = fld_set[5];
    addr2_cnt_en = fld_set[6];
    addr3_cnt_en = fld_set[7];
  endfunction

  function new(input string name="en_reg_c");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    if (has_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg = new();
      rd_fld_covg = new();
    end
  endfunction

endclass


/////////////////////////////////////////////////////
//                mem_size_reg
/////////////////////////////////////////////////////
class mem_size_reg_c extends cdns_uvm_reg;

  `uvm_object_utils(mem_size_reg_c)
  rand uvm_reg_field mem_size_reg_fld;
  
  covergroup wr_fld_covg;
    mem_size_reg_fld: coverpoint mem_size_reg_fld.value[7:0];
  endgroup
  covergroup rd_fld_covg;
    mem_size_reg_fld: coverpoint mem_size_reg_fld.value[7:0];
  endgroup

  protected virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      if(!is_read) begin
          wr_fld_covg.sample();
      end
      if(is_read) begin
          rd_fld_covg.sample();
      end
    end
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg.sample();
      rd_fld_covg.sample();
    end
  endfunction

  virtual function void build();
    uvm_reg_field fld_set[$];
    uvm_reg_field_config_ta ta = get_field_config(getconfigUID());
    build_uvm_reg_fields(this, ta, fld_set);
    
    mem_size_reg_fld = fld_set[0];
  endfunction

  function new(input string name="mem_size_reg_c");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    if (has_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg = new();
      rd_fld_covg = new();
    end
  endfunction

endclass


/////////////////////////////////////////////////////
//                oversized_pkt_cnt_reg
/////////////////////////////////////////////////////
class oversized_pkt_cnt_reg_c extends cdns_uvm_reg;

  `uvm_object_utils(oversized_pkt_cnt_reg_c)
  rand uvm_reg_field oversized_pkt_cnt_reg_fld;
  
  covergroup wr_fld_covg;
    oversized_pkt_cnt_reg_fld: coverpoint oversized_pkt_cnt_reg_fld.value[7:0];
  endgroup
  covergroup rd_fld_covg;
    oversized_pkt_cnt_reg_fld: coverpoint oversized_pkt_cnt_reg_fld.value[7:0];
  endgroup

  protected virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      if(!is_read) begin
          wr_fld_covg.sample();
      end
      if(is_read) begin
          rd_fld_covg.sample();
      end
    end
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg.sample();
      rd_fld_covg.sample();
    end
  endfunction

  virtual function void build();
    uvm_reg_field fld_set[$];
    uvm_reg_field_config_ta ta = get_field_config(getconfigUID());
    build_uvm_reg_fields(this, ta, fld_set);
    
    oversized_pkt_cnt_reg_fld = fld_set[0];
  endfunction

  function new(input string name="oversized_pkt_cnt_reg_c");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    if (has_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg = new();
      rd_fld_covg = new();
    end
  endfunction

endclass


/////////////////////////////////////////////////////
//                parity_err_cnt_reg
/////////////////////////////////////////////////////
class parity_err_cnt_reg_c extends cdns_uvm_reg;

  `uvm_object_utils(parity_err_cnt_reg_c)
  rand uvm_reg_field parity_err_cnt_reg_fld;
  
  covergroup wr_fld_covg;
    parity_err_cnt_reg_fld: coverpoint parity_err_cnt_reg_fld.value[7:0];
  endgroup
  covergroup rd_fld_covg;
    parity_err_cnt_reg_fld: coverpoint parity_err_cnt_reg_fld.value[7:0];
  endgroup

  protected virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      if(!is_read) begin
          wr_fld_covg.sample();
      end
      if(is_read) begin
          rd_fld_covg.sample();
      end
    end
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if (get_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg.sample();
      rd_fld_covg.sample();
    end
  endfunction

  virtual function void build();
    uvm_reg_field fld_set[$];
    uvm_reg_field_config_ta ta = get_field_config(getconfigUID());
    build_uvm_reg_fields(this, ta, fld_set);
    
    parity_err_cnt_reg_fld = fld_set[0];
  endfunction

  function new(input string name="parity_err_cnt_reg_c");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    if (has_coverage(UVM_CVR_FIELD_VALS)) begin
      wr_fld_covg = new();
      rd_fld_covg = new();
    end
  endfunction

endclass


//////////////////////////////////////////////////////
//              router_yapp_mem 
//////////////////////////////////////////////////////
class yapp_mem_c extends uvm_mem;

  `uvm_object_utils(yapp_mem_c) 

  function new(input string name="router_yapp_mem");
    super.new(name, 'h100, 8, "RW", UVM_NO_COVERAGE);
  endfunction

endclass



//////////////////////////////////////////////////////
//              router_yapp_pkt_mem 
//////////////////////////////////////////////////////
class yapp_pkt_mem_c extends uvm_mem;

  `uvm_object_utils(yapp_pkt_mem_c) 

  function new(input string name="router_yapp_pkt_mem");
    super.new(name, 'h40, 8, "RO", UVM_NO_COVERAGE);
  endfunction

endclass



/////////////////////////////////////////////////////
//                router_yapp_regs
/////////////////////////////////////////////////////
class yapp_regs_c extends cdns_uvm_reg_block;

  `uvm_object_utils(yapp_regs_c)
  rand addr0_cnt_reg_c addr0_cnt_reg;
  rand addr1_cnt_reg_c addr1_cnt_reg;
  rand addr2_cnt_reg_c addr2_cnt_reg;
  rand illegal_addr_cnt_reg_c addr3_cnt_reg;
  rand ctrl_reg_c ctrl_reg;
  rand en_reg_c en_reg;
  rand mem_size_reg_c mem_size_reg;
  rand oversized_pkt_cnt_reg_c oversized_pkt_cnt_reg;
  rand parity_err_cnt_reg_c parity_err_cnt_reg;

  virtual function void build();
    uvm_reg  reg_set[$];
    default_map = create_map(get_name(), `UVM_REG_ADDR_WIDTH'h1000, 1, UVM_LITTLE_ENDIAN, 1);
    begin
       uvm_reg_config_ta ta = get_reg_config("yapp_router_regs.router_yapp_regs");
       build_uvm_regs(default_map, this, null, ta, reg_set);
    end
    if(! $cast(addr0_cnt_reg, reg_set[0]))
      `uvm_error("UVM_REG", "addr0_cnt_reg register casting error")
    if(! $cast(addr1_cnt_reg, reg_set[1]))
      `uvm_error("UVM_REG", "addr1_cnt_reg register casting error")
    if(! $cast(addr2_cnt_reg, reg_set[2]))
      `uvm_error("UVM_REG", "addr2_cnt_reg register casting error")
    if(! $cast(addr3_cnt_reg, reg_set[3]))
      `uvm_error("UVM_REG", "addr3_cnt_reg register casting error")
    if(! $cast(ctrl_reg, reg_set[4]))
      `uvm_error("UVM_REG", "ctrl_reg register casting error")
    if(! $cast(en_reg, reg_set[5]))
      `uvm_error("UVM_REG", "en_reg register casting error")
    if(! $cast(mem_size_reg, reg_set[6]))
      `uvm_error("UVM_REG", "mem_size_reg register casting error")
    if(! $cast(oversized_pkt_cnt_reg, reg_set[7]))
      `uvm_error("UVM_REG", "oversized_pkt_cnt_reg register casting error")
    if(! $cast(parity_err_cnt_reg, reg_set[8]))
      `uvm_error("UVM_REG", "parity_err_cnt_reg register casting error")

  endfunction



  function new(input string name="router_yapp_regs");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass


/////////////////////////////////////////////////////
//                yapp_router_regs
/////////////////////////////////////////////////////
class yapp_router_regs_t extends cdns_uvm_reg_block;

  `uvm_object_utils(yapp_router_regs_t)

  uvm_reg_map default_map;
  uvm_reg_map router;
  rand yapp_regs_c router_yapp_regs;
  rand yapp_mem_c router_yapp_mem;
  rand yapp_pkt_mem_c router_yapp_pkt_mem;

  virtual function void build();
    router = create_map("router", `UVM_REG_ADDR_WIDTH'h0, 1, UVM_LITTLE_ENDIAN, 1);
    default_map = router;
    router_yapp_mem = yapp_mem_c::type_id::create("router_yapp_mem");
    router_yapp_mem = yapp_mem_c::type_id::create("router_yapp_mem");
    router_yapp_mem.configure(this, "router_yapp_mem");
    router_yapp_pkt_mem = yapp_pkt_mem_c::type_id::create("router_yapp_pkt_mem");
    router_yapp_pkt_mem = yapp_pkt_mem_c::type_id::create("router_yapp_pkt_mem");
    router_yapp_pkt_mem.configure(this, "router_yapp_pkt_mem");
    router_yapp_regs = yapp_regs_c::type_id::create("router_yapp_regs", , get_full_name());
    router_yapp_regs.configure(this);
    router_yapp_regs.build();

    //Mapping router map
    router_yapp_regs.default_map.add_parent_map(router,`UVM_REG_ADDR_WIDTH'h1000);
    router.set_submap_offset(router_yapp_regs.default_map, `UVM_REG_ADDR_WIDTH'h1000);
    router.add_mem(router_yapp_mem, `UVM_REG_ADDR_WIDTH'h1100);
    router.add_mem(router_yapp_pkt_mem, `UVM_REG_ADDR_WIDTH'h1010);
    //Apply hdl_paths
    apply_hdl_paths(this);

  endfunction



  function new(input string name="yapp_router_regs_t");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass


//*************************************************//
//Factory Methods
//*************************************************//
class reg_verifier_factory extends cdns_factory_base;
   virtual function uvm_object create(string typename, string pathname,string objectname);
      case(typename)
         "addr0_cnt_reg_c": begin addr0_cnt_reg_c addr0_cnt_reg = new(objectname); create = addr0_cnt_reg;  end
         "addr1_cnt_reg_c": begin addr1_cnt_reg_c addr1_cnt_reg = new(objectname); create = addr1_cnt_reg;  end
         "addr2_cnt_reg_c": begin addr2_cnt_reg_c addr2_cnt_reg = new(objectname); create = addr2_cnt_reg;  end
         "illegal_addr_cnt_reg_c": begin illegal_addr_cnt_reg_c addr3_cnt_reg = new(objectname); create = addr3_cnt_reg;  end
         "ctrl_reg_c": begin ctrl_reg_c ctrl_reg = new(objectname); create = ctrl_reg;  end
         "en_reg_c": begin en_reg_c en_reg = new(objectname); create = en_reg;  end
         "mem_size_reg_c": begin mem_size_reg_c mem_size_reg = new(objectname); create = mem_size_reg;  end
         "oversized_pkt_cnt_reg_c": begin oversized_pkt_cnt_reg_c oversized_pkt_cnt_reg = new(objectname); create = oversized_pkt_cnt_reg;  end
         "parity_err_cnt_reg_c": begin parity_err_cnt_reg_c parity_err_cnt_reg = new(objectname); create = parity_err_cnt_reg;  end

      endcase
   endfunction
endclass


//get_factory() function to select the factory
function automatic cdns_factory_base get_factory(bit no_factory);
   static cdns_factory_base factory;
   if(factory == null) begin
      if(no_factory == 1) begin
         reg_verifier_factory rv_factory = new;
         factory = rv_factory;
      end
      else begin
         uvm_factory_proxy rv_factory = new;
         factory = rv_factory;
      end
   end
   cdns_uvmreg_utils_pkg::factory=factory;


   return factory;
endfunction
cdns_factory_base factory = get_factory(no_factory);

endpackage



