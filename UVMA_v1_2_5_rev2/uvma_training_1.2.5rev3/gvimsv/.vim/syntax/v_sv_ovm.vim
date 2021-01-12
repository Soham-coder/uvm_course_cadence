" Vim syntax file
" Language:     Verilog/SystemVerilog HDL + OVM
" Author:       Amal Khailtash <akhailtash@rogers.com>
" Last Change:  Mon Sep 29 09:55:42 EDT 2008
" Version:      2.0
"
" Maintainer:
"
" Authors:
"   Amit Sethi     <amitrajsethi@yahoo.com>
"   Amal Khailtash <akhailtash@rogers.com>
"
" Credits:
"   Originally created by
"     Amit Sethi <amitrajsethi@yahoo.com>
"   OVM 2.0 Classes/Methods
"     Amal Khailtash <akhailtash@rogers.com>
"
" Revision Comments:
"     Amit Sethi <amitrajsethi@yahoo.com> - Thu Jul 27 12:54:08 IST 2006
"       Version 1.1
"     Amal Khailtash <akhailtash@rogers.com> - Mon Sep 29 09:55:42 EDT 2008
"       Version 2.0
"       Added OVM 2.0 Keyworks
"       Another option is the work by Anil Raj Gopalakrishnan <anilraj.gr@gmail.com>
"         http://verifideas.blogspot.com/2008/09/better-syntax-highlighting-in.html

" Extends Verilog syntax
" Requires $VIMRUNTIME/syntax/verilog.vim to exist

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif


" Read in Verilog syntax files
if version < 600
   so syntax/verilog.vim
else
   runtime! syntax/verilog.vim
endif


syn sync lines=1000

"##########################################################
"       SystemVerilog Syntax
"##########################################################

syn keyword verilogStatement   always_comb always_ff always_latch
syn keyword verilogStatement   class endclass
syn keyword verilogStatement   virtual local const protected
syn keyword verilogStatement   package endpackage
syn keyword verilogStatement   rand randc constraint randomize
syn keyword verilogStatement   with inside dist
syn keyword verilogStatement   randcase
syn keyword verilogStatement   sequence endsequence randsequence 
syn keyword verilogStatement   get_randstate set_randstate
syn keyword verilogStatement   srandom
syn keyword verilogStatement   logic bit byte time
syn keyword verilogStatement   int longint shortint
syn keyword verilogStatement   struct packed
syn keyword verilogStatement   final
syn keyword verilogStatement   import export
syn keyword verilogStatement   context pure
syn keyword verilogStatement   void shortreal chandle string
syn keyword verilogStatement   clocking endclocking
syn keyword verilogStatement   interface endinterface modport
syn keyword verilogStatement   cover covergroup coverpoint endgroup
syn keyword verilogStatement   property endproperty
syn keyword verilogStatement   program endprogram
syn keyword verilogStatement   bins binsof illegal_bins ignore_bins
syn keyword verilogStatement   alias matches solve static assert
syn keyword verilogStatement   assume super before expect bind
syn keyword verilogStatement   extends null tagged extern this
syn keyword verilogStatement   first_match throughout timeprecision
syn keyword verilogStatement   timeunit priority type union unique
syn keyword verilogStatement   uwire var cross ref wait_order intersect
syn keyword verilogStatement   wildcard within
syn keyword verilogStatement   semaphore triggered
syn keyword verilogStatement   std
syn keyword verilogStatement   new

syn keyword verilogTypeDef     typedef enum

syn keyword verilogConditional iff

syn keyword verilogRepeat      return break continue
syn keyword verilogRepeat      do while foreach

syn keyword verilogLabel       join_any join_none forkjoin

syn match   verilogGlobal      "`begin_\w\+"
syn match   verilogGlobal      "`end_\w\+"
syn match   verilogGlobal      "`remove_\w\+"
syn match   verilogGlobal      "`restore_\w\+"

syn match   verilogGlobal      "`[a-zA-Z0-9_]\+\>"

syn match   verilogNumber      "\<[0-9][0-9_\.]\=\([fpnum]\|\)s\>"
syn match   verilogNumber      "\<[0-9][0-9_\.]\=step\>"

syn match   verilogMethod      "\.atobin\>"
syn match   verilogMethod      "\.atohex\>"
syn match   verilogMethod      "\.atoi\>"
syn match   verilogMethod      "\.atooct\>"
syn match   verilogMethod      "\.atoreal\>"
syn match   verilogMethod      "\.await\>"
syn match   verilogMethod      "\.back\>"
syn match   verilogMethod      "\.bintoa\>"
syn match   verilogMethod      "\.clear\>"
syn match   verilogMethod      "\.compare\>"
syn match   verilogMethod      "\.data\>"
syn match   verilogMethod      "\.delete\>"
syn match   verilogMethod      "\.empty\>"
syn match   verilogMethod      "\.eq\>"
syn match   verilogMethod      "\.erase\>"
syn match   verilogMethod      "\.erase_range\>"
syn match   verilogMethod      "\.exists\>"
syn match   verilogMethod      "\.find\>"
syn match   verilogMethod      "\.find_first\>"
syn match   verilogMethod      "\.find_first_index\>"
syn match   verilogMethod      "\.find_index\>"
syn match   verilogMethod      "\.find_last\>"
syn match   verilogMethod      "\.find_last_index\>"
syn match   verilogMethod      "\.finish\>"
syn match   verilogMethod      "\.first\>"
syn match   verilogMethod      "\.front\>"
syn match   verilogMethod      "\.get\>"
syn match   verilogMethod      "\.getc\>"
syn match   verilogMethod      "\.hextoa\>"
syn match   verilogMethod      "\.icompare\>"
syn match   verilogMethod      "\.index\>"
syn match   verilogMethod      "\.insert\>"
syn match   verilogMethod      "\.insert_range\>"
syn match   verilogMethod      "\.itoa\>"
syn match   verilogMethod      "\.kill\>"
syn match   verilogMethod      "\.last\>"
syn match   verilogMethod      "\.len\>"
syn match   verilogMethod      "\.max\>"
syn match   verilogMethod      "\.min\>"
syn match   verilogMethod      "\.name\>"
syn match   verilogMethod      "\.neq\>"
syn match   verilogMethod      "\.new\>"
syn match   verilogMethod      "\.next\>"
syn match   verilogMethod      "\.num\>"
syn match   verilogMethod      "\.octtoa\>"
syn match   verilogMethod      "\.peek\>"
syn match   verilogMethod      "\.pop_back\>"
syn match   verilogMethod      "\.pop_front\>"
syn match   verilogMethod      "\.prev\>"
syn match   verilogMethod      "\.product\>"
syn match   verilogMethod      "\.purge\>"
syn match   verilogMethod      "\.push_back\>"
syn match   verilogMethod      "\.push_front\>"
syn match   verilogMethod      "\.put\>"
syn match   verilogMethod      "\.putc\>"
syn match   verilogMethod      "\.rand_mode\>"
syn match   verilogMethod      "\.realtoa\>"
syn match   verilogMethod      "\.resume\>"
syn match   verilogMethod      "\.reverse\>"
syn match   verilogMethod      "\.rsort\>"
syn match   verilogMethod      "\.self\>"
syn match   verilogMethod      "\.set\>"
syn match   verilogMethod      "\.shuffle\>"
syn match   verilogMethod      "\.size\>"
syn match   verilogMethod      "\.sort\>"
syn match   verilogMethod      "\.start\>"
syn match   verilogMethod      "\.status\>"
syn match   verilogMethod      "\.stop\>"
syn match   verilogMethod      "\.substr\>"
syn match   verilogMethod      "\.sum\>"
syn match   verilogMethod      "\.suspend\>"
syn match   verilogMethod      "\.swap\>"
syn match   verilogMethod      "\.tolower\>"
syn match   verilogMethod      "\.toupper\>"
syn match   verilogMethod      "\.try_get\>"
syn match   verilogMethod      "\.try_peek\>"
syn match   verilogMethod      "\.try_put\>"
syn match   verilogMethod      "\.unique\>"
syn match   verilogMethod      "\.unique_index\>"
syn match   verilogMethod      "\.xor\>"

syn match   verilogAssertion   "\<\w\+\>\s*:\s*\<assert\>\_.\{-});"

"-------------------------------------------------------------------------------
" OVM 2.0
"syn match   ovmClass           "\<ovm_\w\+\>"
"syn match   ovmClass           "\<tlm_\w\+\>"
"syn keyword ovmClass             
"syn keyword ovmMethod            
"syn keyword ovmMethodGlobal      
"syn keyword ovmDeprecatedMethod  

"-------------------------------------------------------------------------------
" ovm-2.0/src/base/
"-------------------------------------------------------------------------------
" ovm-2.0/src/base/ovm_component.svh
syn keyword ovmClass             ovm_component
syn keyword ovmMethod            accept_tr apply_config_settings begin_child_tr begin_tr build check clone
syn keyword ovmMethod            connect create create_component create_object do_accept_tr do_begin_tr do_end_tr
syn keyword ovmMethod            do_flush do_func_phase do_kill_all do_resolve_bindings do_task_phase end_of_elaboration
syn keyword ovmMethod            end_tr extract flush get_child get_config_int get_config_object get_config_string
syn keyword ovmMethod            get_first_child get_full_name get_next_child get_num_children get_parent has_child
syn keyword ovmMethod            kill lookup m_begin_tr print_config_settings print_override_info record_error_tr
syn keyword ovmMethod            record_event_tr report resolve_bindings restart resume run set_config_int set_config_object
syn keyword ovmMethod            set_config_string set_inst_override set_inst_override_by_type set_name
syn keyword ovmMethod            set_report_default_file_hier set_report_id_action_hier set_report_id_file_hier
syn keyword ovmMethod            set_report_severity_action_hier set_report_severity_file_hier
syn keyword ovmMethod            set_report_severity_id_action_hier set_report_severity_id_file_hier
syn keyword ovmMethod            set_report_verbosity_level_hier set_type_override set_type_override_by_type
syn keyword ovmMethod            start_of_simulation status stop suspend
syn keyword ovmDeprecatedMethod  configure export_connections find_component find_components get_component
syn keyword ovmDeprecatedMethod  get_num_components
"syn keyword ovmDeprecatedMethod  global_stop_request
syn keyword ovmDeprecatedMethod  import_connections post_new pre_run
syn keyword ovmDeprecatedClass   ovm_threaded_component

" ovm-2.0/src/base/ovm_config.svh
syn keyword ovmClass             ovm_config_setting
syn keyword ovmMethod            matches_string print_match type_string value_string
syn keyword ovmClass             ovm_int_config_setting
syn keyword ovmMethod            matches_string type_string value_string
syn keyword ovmClass             ovm_string_config_setting
syn keyword ovmMethod            matches_string type_string value_string
syn keyword ovmClass             ovm_object_config_setting
syn keyword ovmMethod            matches_string type_string value_string
syn keyword ovmMethodGlobal      set_config_int set_config_object set_config_string

" ovm-2.0/src/base/ovm_env.svh
syn keyword ovmClass             ovm_env
syn keyword ovmMethod            do_task_phase get_type_name run_test
syn keyword ovmDeprecatedMethod  do_test

" ovm-2.0/src/base/ovm_event.svh
syn keyword ovmClass             ovm_event_callback
syn keyword ovmMethod            create pre_trigger post_trigger
syn keyword ovmClass             ovm_event
syn keyword ovmMethod            add_callback cancel create delete_callback do_copy do_print get_num_waiters
syn keyword ovmMethod            get_trigger_data get_trigger_time get_type_name is_off is_on reset trigger
syn keyword ovmMethod            wait_off wait_on wait_ptrigger wait_ptrigger_data wait_trigger wait_trigger_data
syn keyword ovmClass             ovm_event_pool
syn keyword ovmMethod            create delete do_copy do_print exists first get get_global_pool get_type_name
syn keyword ovmMethod            last next num prev
syn keyword ovmClass             ovm_barrier
syn keyword ovmMethod            cancel create do_copy do_print get_num_waiters get_threshold get_type_name
syn keyword ovmMethod            reached_threshold reset set_auto_reset set_threshold wait_for
syn keyword ovmClass             ovm_barrier_pool
syn keyword ovmMethod            create delete do_copy do_print exists first get get_global_pool get_type_name
syn keyword ovmMethod            last next num prev

" ovm-2.0/src/base/ovm_report_server.svh
syn keyword ovmClass             ovm_report_server
syn keyword ovmMethod            compose_message copy_id_counts copy_severity_counts dump_server_state
syn keyword ovmMethod            f_display get_id_count get_max_quit_count get_quit_count get_severity_count
syn keyword ovmMethod            incr_id_count incr_quit_count incr_severity_count is_quit_count_reached
syn keyword ovmMethod            process_report report reset_quit_count reset_severity_counts set_id_count
syn keyword ovmMethod            set_max_quit_count set_quit_count set_severity_count summarize
syn keyword ovmClass             ovm_report_global_server
syn keyword ovmMethod            get_server set_server

" ovm-2.0/src/base/ovm_factory.svh
syn keyword ovmClass             ovm_object_wrapper
syn keyword ovmMethod            create_component create_object get_type_name
syn keyword ovmClass             ovm_factory_override
syn keyword ovmClass             ovm_factory
syn keyword ovmMethod            create_component_by_name create_component_by_type create_object_by_name
syn keyword ovmMethod            create_object_by_type debug_create_by_name debug_create_by_type
syn keyword ovmMethod            find_override_by_name find_override_by_type print register set_inst_override_by_name
syn keyword ovmMethod            set_inst_override_by_type set_type_override_by_name set_type_override_by_type
syn keyword ovmDeprecatedMethod  auto_register
"syn keyword ovmDeprecatedMethod  create_component create_object
syn keyword ovmDeprecatedMethod  print_all_overrides
"syn keyword ovmDeprecatedMethod  print_override_info set_inst_override set_type_override

" ovm-2.0/src/base/ovm_misc.svh
syn keyword ovmCompatibility     avm_virtual_class
syn keyword ovmClass             ovm_void
syn keyword ovmClass             ovm_scope_stack
syn keyword ovmMethod            current depth down down_element get get_arg in_hierarchy set
syn keyword ovmMethod            set_arg set_arg_element unset_arg up up_element
syn keyword ovmMethodGlobal      ovm_bits_to_string ovm_is_match ovm_string_to_bits ovm_wait_for_nba_region

" ovm-2.0/src/base/ovm_object.svh
syn keyword ovmClass             ovm_status_container
syn keyword ovmMethod            get_full_scope_arg init_scope
syn keyword ovmClass             ovm_object
syn keyword ovmMethod            clone compare copy create do_compare do_copy do_pack do_print do_record
syn keyword ovmMethod            do_sprint do_unpack get_full_name get_inst_count get_inst_id get_name
syn keyword ovmMethod            get_type get_type_name pack pack_bytes pack_ints print_field_match record
syn keyword ovmMethod            set_int_local set_name set_object_local set_string_local unpack unpack_bytes unpack_ints
syn keyword ovmClass             ovm_copy_map
syn keyword ovmMethod            clear delete get set
syn keyword ovmClass             ovm_comparer
syn keyword ovmMethod            compare_field compare_field_int compare_object compare_string init
syn keyword ovmMethod            print_msg print_msg_object print_rollup
syn keyword ovmClass             ovm_recorder
syn keyword ovmMethod            record_field record_generic record_object record_string record_time
syn keyword ovmClass             ovm_options_container
syn keyword ovmMethod            init

" ovm-2.0/src/base/ovm_object_globals.svh
syn keyword ovmTypeDef           ovm_bitstream_t ovm_radix_enum ovm_recursion_policy_enum

" ovm-2.0/src/base/ovm_packer
syn keyword ovmClass             ovm_packer
syn keyword ovmMethod            enough_bits get_bit get_bits get_byte get_bytes get_int get_ints get_packed_bits
syn keyword ovmMethod            get_packed_size index_error is_null pack_field pack_field_int pack_object
syn keyword ovmMethod            pack_real pack_string pack_time put_bits put_bytes put_ints reset set_packed_size
syn keyword ovmMethod            unpack_field unpack_field_int unpack_object unpack_object_ext unpack_real
syn keyword ovmMethod            unpack_string unpack_time

" ovm-2.0/src/base/ovm_port_base.svh
syn keyword ovmTypeDef           ovm_port_type_e ovm_port_list
syn keyword ovmClass             ovm_port_component_base
syn keyword ovmMethod            get_connected_to get_provided_to is_export is_imp is_port
syn keyword ovmClass             ovm_port_component
syn keyword ovmMethod            do_display get_connected_to get_port get_provided_to get_type_name is_port is_export
syn keyword ovmMethod            is_imp resolve_bindings
syn keyword ovmClass             ovm_port_base
syn keyword ovmMethod            connect debug_connected_to debug_provided_to get_comp get_connected_to get_full_name
syn keyword ovmMethod            get_if get_name get_parent get_provided_to get_type_name is_export is_imp is_port
syn keyword ovmMethod            is_unbounded max_size min_size resolve_bindings set_default_index set_if size
"syn keyword ovmDeprecatedMethod  do_display remove
syn keyword ovmDeprecatedMethod  check_min_connection_size check_phase lookup_indexed_if

" ovm-2.0/src/base/ovm_printer.svh
syn keyword ovmClass             ovm_printer_knobs
syn keyword ovmMethod            get_radix_str
syn keyword ovmClass             ovm_printer
syn keyword ovmMethod            indent index index_string istop print_array_footer print_array_header
syn keyword ovmMethod            print_array_range print_field print_footer print_generic print_header
syn keyword ovmMethod            print_id print_newline print_object print_object_header print_size
syn keyword ovmMethod            print_string print_time print_type_name print_value print_value_array
syn keyword ovmMethod            print_value_object print_value_string write_stream
syn keyword ovmClass             ovm_hier_printer_knobs
syn keyword ovmClass             ovm_table_printer_knobs
syn keyword ovmClass             ovm_table_printer
syn keyword ovmMethod            print_footer print_header print_id print_size print_type_name print_value
syn keyword ovmMethod            print_value_array print_value_object print_value_string
syn keyword ovmClass             ovm_tree_printer_knobs
syn keyword ovmClass             ovm_tree_printer
syn keyword ovmMethod            print_array_footer print_id print_object print_object_header print_scope_close
syn keyword ovmMethod            print_scope_open print_string print_type_name print_value_array print_value_object
syn keyword ovmClass             ovm_line_printer
syn keyword ovmMethod            print_newline

" ovm-2.0/src/base/ovm_registry.svh
syn keyword ovmClass             ovm_component_registry
syn keyword ovmMethod            create create_component get get_type_name set_inst_override set_type_override
syn keyword ovmClass             ovm_object_registry
syn keyword ovmMethod            create create_object get get_type_name set_type_override

" ovm-2.0/src/base/ovm_report_defines.svh
syn keyword ovmTypeDef           ovm_action ovm_action_type ovm_severity ovm_severity_type ovm_verbosity
syn keyword ovmTypeDef           id_actions_array id_file_array OVM_FILE s_default_action_array s_default_file_array

" ovm-2.0/src/base/ovm_report_global.svh
syn keyword ovmMethodGlobal      ovm_get_max_verbosity ovm_initialize_global_reporter ovm_report_error
syn keyword ovmMethodGlobal      ovm_report_fatal ovm_report_info ovm_report_warning

" ovm-2.0/src/base/ovm_report_handler.svh
syn keyword ovmClass             ovm_hash
syn keyword ovmMethod            exists fetch first get next set
syn keyword ovmClass             ovm_report_handler
syn keyword ovmMethod            dump_state format_action get_action get_file_handle get_server get_verbosity_level
syn keyword ovmMethod            initialize report report_header run_hooks set_default_file set_defaults
syn keyword ovmMethod            set_id_action set_id_file set_max_quit_count set_severity_action set_severity_file
syn keyword ovmMethod            set_severity_id_action set_severity_id_file set_verbosity_level summarize
syn keyword ovmClass             default_report_server
syn keyword ovmMethod            get_server

" ovm-2.0/src/base/ovm_report_object.svh
syn keyword ovmClass             ovm_report_object
syn keyword ovmMethod            die dump_report_state get_report_handler get_report_server ovm_get_max_verbosity
syn keyword ovmMethod            ovm_report_error ovm_report_fatal ovm_report_info ovm_report_warning
syn keyword ovmMethod            report_error_hook report_fatal_hook report_header report_hook report_info_hook
syn keyword ovmMethod            report_summarize report_warning_hook reset_report_handler set_report_default_file
syn keyword ovmMethod            set_report_handler set_report_id_action set_report_id_file set_report_max_quit_count
syn keyword ovmMethod            set_report_severity_action set_report_severity_file set_report_severity_id_action
syn keyword ovmMethod            set_report_severity_id_file set_report_verbosity_level
"syn keyword ovmDeprecatedMethod  avm_report_error avm_report_fatal avm_report_message avm_report_warning
syn keyword ovmClass             ovm_reporter
syn keyword ovmMethod            create get_type_name

" ovm-2.0/src/base/ovm_report_server.svh
syn keyword ovmClass             ovm_report_server
syn keyword ovmMethod            compose_message copy_id_counts copy_severity_counts dump_server_state
syn keyword ovmMethod            f_display get_id_count get_max_quit_count get_quit_count get_severity_count
syn keyword ovmMethod            incr_id_count incr_quit_count incr_severity_count is_quit_count_reached
syn keyword ovmMethod            process_report report reset_quit_count reset_severity_counts set_id_count
syn keyword ovmMethod            set_max_quit_count set_quit_count set_severity_count summarize
syn keyword ovmClass             ovm_report_global_server
syn keyword ovmMethod            get_server set_server

" ovm-2.0/src/base/ovm_root.svh
syn keyword ovmClass             ovm_root
syn keyword ovmMethod            find find_all get get_current_phase get_phase_by_name get_type_name
syn keyword ovmMethod            insert_phase run_global_phase run_test stop_request print_topology 
syn keyword ovmDeprecatedClass   ovm_test_top
syn keyword ovmDeprecatedMethod  print_unit print_unit_list print_units
syn keyword ovmMethodGlobal      global_stop_request ovm_find_component ovm_print_topology run_test
syn keyword ovmMethodGlobal      set_global_stop_timeout set_global_timeout

" ovm-2.0/src/base/ovm_transaction.svh
syn keyword ovmClass             ovm_transaction
syn keyword ovmMethod            accept_tr begin_child_tr begin_tr convert2string disable_recording
syn keyword ovmMethod            do_accept_tr do_begin_tr do_copy do_end_tr do_print do_record
syn keyword ovmMethod            enable_recording end_tr get_accept_time get_begin_time get_end_time
syn keyword ovmMethod            get_event_pool get_initiator get_tr_handle get_transaction_id is_active
syn keyword ovmMethod            is_recording_enabled m_begin_tr set_initiator set_transaction_id

" ovm-2.0/src/base/ovm_version.svh
syn keyword ovmMethodGlobal      ovm_revision_string

"-------------------------------------------------------------------------------
" ovm-2.0/src/base/compatibility/
"-------------------------------------------------------------------------------
" ovm-2.0/src/base/compatibility/avm_compatibility.svh
syn keyword ovmCompatibility     avm_env avm_named_component avm_report_client avm_report_handler
syn keyword ovmCompatibility     avm_report_server avm_reporter avm_threaded_component avm_transaction
syn keyword ovmCompatibility     action action_type severity
syn keyword ovmCompatibility     ovm_named_component ovm_report_client
syn keyword ovmCompatibility     avm_transport_port avm_transport_export avm_built_in_pair
syn keyword ovmCompatibility     avm_class_pair avm_in_order_comparator avm_in_order_class_comparator
syn keyword ovmCompatibility     avm_in_order_built_in_comparator avm_algorithmic_comparator
syn keyword ovmCompatibility     avm_report_error avm_report_fatal avm_report_message avm_report_warning
syn keyword ovmCompatibility     analysis_fifo avm_transport_imp avm_analysis_imp avm_port_base

" ovm-2.0/src/base/compatibility/base_compatibility.svh
"syn keyword ovmClass             
"syn keyword ovmMethod            

" ovm-2.0/src/base/compatibility/compatibility.svh
"syn keyword ovmClass             
"syn keyword ovmMethod            

" ovm-2.0/src/base/compatibility/urm.svh
"syn keyword ovmClass             
"syn keyword ovmMethod            

" ovm-2.0/src/base/compatibility/urm_compatibility.svh
"syn keyword ovmClass             
"syn keyword ovmMethod            

" ovm-2.0/src/base/compatibility/urm_macro_compatibility.svh
"syn keyword ovmClass             
"syn keyword ovmMethod            

" ovm-2.0/src/base/compatibility/urm_message.svh
"syn keyword ovmClass             
"syn keyword ovmMethod            

" ovm-2.0/src/base/compatibility/urm_message_compatibility.svh
"syn keyword ovmClass             
"syn keyword ovmMethod            

" ovm-2.0/src/base/compatibility/urm_message_defines.svh
"syn keyword ovmClass             
"syn keyword ovmMethod            

" ovm-2.0/src/base/compatibility/urm_meth_compatibility.svh
"syn keyword ovmClass             
"syn keyword ovmMethod            

" ovm-2.0/src/base/compatibility/urm_port_compatibility.svh
"syn keyword ovmClass             
"syn keyword ovmMethod            

" ovm-2.0/src/base/compatibility/urm_type_compatibility.svh
"syn keyword ovmClass             
"syn keyword ovmMethod            

"-------------------------------------------------------------------------------
" ovm-2.0/src/methodology/
"-------------------------------------------------------------------------------
" ovm-2.0/src/methodology/methodology.svh
syn keyword ovmTypeDef           ovm_default_driver_type ovm_default_sequence_type
syn keyword ovmTypeDef           ovm_default_sequencer_param_type ovm_default_sequencer_type

" ovm-2.0/src/methodology/methodology_noparm.svh

" ovm-2.0/src/methodology/ovm_agent.svh
syn keyword ovmClass             ovm_agent
syn keyword ovmMethod            run

" ovm-2.0/src/methodology/ovm_algorithmic_comparator.svh
syn keyword ovmClass             ovm_algorithmic_comparator
syn keyword ovmMethod            connect get_type_name write

" ovm-2.0/src/methodology/ovm_driver.svh
syn keyword ovmClass             ovm_driver
syn keyword ovmMethod            run

" ovm-2.0/src/methodology/ovm_in_order_comparator.svh
syn keyword ovmClass             ovm_in_order_comparator
syn keyword ovmMethod            connect flush get_type_name run
syn keyword ovmClass             ovm_in_order_built_in_comparator
syn keyword ovmMethod            get_type_name
syn keyword ovmClass             ovm_in_order_class_comparator
syn keyword ovmMethod            get_type_name

" ovm-2.0/src/methodology/ovm_meth_defines.svh
syn keyword ovmTypeDef           ovm_active_passive_enum

" ovm-2.0/src/methodology/ovm_monitor.svh
syn keyword ovmClass             ovm_monitor

" ovm-2.0/src/methodology/ovm_pair.svh
syn keyword ovmClass             ovm_class_pair
syn keyword ovmMethod            clone comp convert2string copy create get_type_name
syn keyword ovmClass             ovm_built_in_pair
syn keyword ovmMethod            clone comp convert2string copy create get_type_name

" ovm-2.0/src/methodology/ovm_policies.svh
syn keyword ovmClass             ovm_built_in_comp
syn keyword ovmMethod            comp
syn keyword ovmClass             ovm_built_in_converter
syn keyword ovmMethod            convert2string
syn keyword ovmClass             ovm_built_in_clone
syn keyword ovmMethod            clone
syn keyword ovmClass             ovm_class_comp
syn keyword ovmMethod            comp
syn keyword ovmClass             ovm_class_converter
syn keyword ovmMethod            convert2string
syn keyword ovmClass             ovm_class_clone
syn keyword ovmMethod            clone

" ovm-2.0/src/methodology/ovm_push_driver.svh
syn keyword ovmClass             ovm_push_driver
syn keyword ovmMethod            build check_port_connections end_of_elaboration

" ovm-2.0/src/methodology/ovm_random_stimulus.svh
syn keyword ovmClass             ovm_random_stimulus
syn keyword ovmMethod            generate_stimulus get_type_name stop_stimulus_generation

" ovm-2.0/src/methodology/ovm_scoreboard.svh
syn keyword ovmClass             ovm_scoreboard
syn keyword ovmMethod            run

" ovm-2.0/src/methodology/ovm_subscriber.svh
syn keyword ovmClass             ovm_subscriber
syn keyword ovmMethod            write

" ovm-2.0/src/methodology/ovm_test.svh
syn keyword ovmClass             ovm_test
syn keyword ovmMethod            run

"-------------------------------------------------------------------------------
" ovm-2.0/src/methodology/layered_stimulus/
"-------------------------------------------------------------------------------
" ovm-2.0/src/methodology/layered_stimulus/ovm_layered_stimulus.svh

" ovm-2.0/src/methodology/layered_stimulus/ovm_scenario.svh
syn keyword ovmClass             ovm_scenario
syn keyword ovmMethod            apply apply_request apply_send get_id get_scenario_path_name
syn keyword ovmMethod            mid_apply post_apply pre_apply pre_body start

" ovm-2.0/src/methodology/layered_stimulus/ovm_scenario_controller.svh
syn keyword ovmClass             ovm_scenario_controller
syn keyword ovmMethod            apply apply_request apply_send

" ovm-2.0/src/methodology/layered_stimulus/ovm_scenario_driver.svh
syn keyword ovmClass             ovm_scenario_driver
syn keyword ovmMethod            end_of_elaboration get_next_item run set_scenario_controller

"-------------------------------------------------------------------------------
" ovm-2.0/src/methodology/sequences/
"-------------------------------------------------------------------------------
" ovm-2.0/src/methodology/sequences/ovm_push_sequencer.svh
syn keyword ovmClass             ovm_push_sequencer
syn keyword ovmMethod            run

" ovm-2.0/src/methodology/sequences/ovm_req_rsp_sequence.svh
syn keyword ovmClass             ovm_req_rsp_sequence
syn keyword ovmMethod            apply

" ovm-2.0/src/methodology/sequences/ovm_req_rsp_sequence.svh
syn keyword ovmClass             ovm_sequence
syn keyword ovmMethod            do_print start send_request get_current_item get_response put_response
syn keyword ovmMethod            set_sequencer set_response_queue_error_report_disabled
syn keyword ovmMethod            get_response_queue_error_report_disabled set_response_queue_depth get_response_queue_depth

" ovm-2.0/src/methodology/sequences/ovm_sequence_base.svh
syn keyword ovmClass             ovm_sequence_base
syn keyword ovmTypeDef           ovm_sequence_state_enum
syn keyword ovmMethod            body create_and_start_sequence_by_name create_item do_sequence_kind get get_priority
syn keyword ovmMethod            get_seq_kind get_sequence get_sequence_by_name get_sequence_state get_sequencer
syn keyword ovmMethod            get_use_response_handler grab is_blocked is_item is_relevant kill m_finish_item
syn keyword ovmMethod            m_get_sqr_sequence_id m_start_item mid_do num_sequences post_body post_do pre_body pre_do
syn keyword ovmMethod            response_handler send_request set_priority set_sequencer stop ungrab unlock use_response_handler
syn keyword ovmMethod            wait_for_grant wait_for_item_done wait_for_relevant wait_for_sequence_state
"syn keyword ovmCompatibility     get_id pre_apply mid_apply post_apply
syn keyword ovmCompatibility     get_parent_scenario

" ovm-2.0/src/methodology/sequences/ovm_sequence_builtin.svh
syn keyword ovmClass              ovm_random_sequence
syn keyword ovmMethod             body do_copy do_compare do_print do_record create get_type_name
syn keyword ovmClass              ovm_exhaustive_sequence
syn keyword ovmMethod             body do_copy do_compare do_print do_record create get_type_name
syn keyword ovmClass              ovm_simple_sequence
syn keyword ovmMethod             body create get_type_name

" ovm-2.0/src/methodology/sequences/ovm_sequence_item.svh
syn keyword ovmClass             ovm_sequence_item
syn keyword ovmMethod            set_sequence_id get_sequence_id set_use_sequence_info get_use_sequence_info set_id_info set_sequencer
syn keyword ovmMethod            get_sequencer set_parent_sequence get_parent_sequence set_depth get_depth is_item start_item finish_item
syn keyword ovmMethod            m_start_item m_finish_item get_full_name get_root_sequence_name get_root_sequence get_sequence_path
syn keyword ovmMethod            do_print
"syn keyword ovmDeprecated        set_parent_seq get_parent_seq pre_do body mid_do post_do wait_for_grant send_request wait_for_item_done

" ovm-2.0/src/methodology/sequences/ovm_sequencer.svh
syn keyword ovmClass             ovm_sequencer
syn keyword ovmTypeDef           ovm_seq_item_prod_if
syn keyword ovmMethod            get_type_name connect build end_of_elaboration send_request get_next_item try_next_item item_done put get peek
syn keyword ovmMethod            m_add_builtin_seqs item_done_trigger item_done_get_trigger_data add_seq_cons_if
syn keyword ovmTypeDef           ovm_virtual_sequencer
syn keyword ovmDeprecatedClass   ovm_seq_prod_if

" ovm-2.0/src/methodology/sequences/ovm_sequencer_analysis_fifo.svh
syn keyword ovmClass              sequencer_analysis_fifo
syn keyword ovmMethod             write

" ovm-2.0/src/methodology/sequences/ovm_sequencer_base.svh
syn keyword ovmClass              seq_req_class
syn keyword ovmClass              ovm_sequencer_base
syn keyword ovmMethod             do_print user_priority_arbitration grant_queued_locks choose_next_request wait_for_available_sequence
syn keyword ovmMethod             get_seq_item_priority wait_for_arbitration_completed set_arbitration_completed is_child wait_for_grant
syn keyword ovmMethod             wait_for_item_done is_blocked is_locked lock_req unlock_req lock grab unlock ungrab remove_sequence_from_queues
syn keyword ovmMethod             stop_sequences sequence_exiting kill_sequence is_grabbed current_grabber has_do_available set_arbitration
syn keyword ovmMethod             analysis_write wait_for_sequences add_sequence remove_sequence set_sequences_queue get_seq_kind get_sequence
syn keyword ovmMethod             num_sequences send_request
syn keyword ovmDeprecated         start_sequence

" ovm-2.0/src/methodology/sequences/ovm_sequencer_param_base.svh
syn keyword ovmClass             ovm_sequencer_param_base
syn keyword ovmMethod            do_print connect build send_request get_current_item put_response analysis_write start_default_sequence run
syn keyword ovmMethod            get_num_reqs_sent get_num_rsps_received set_num_last_reqs get_num_last_reqs last_req set_num_last_rsps
syn keyword ovmMethod            get_num_last_rsps last_rsp execute_item
syn keyword ovmCompatibility     set_num_last_items
"syn keyword ovmCompatibility     last

"-------------------------------------------------------------------------------
" ovm-2.0/src/tlm
"-------------------------------------------------------------------------------
" ovm-2.0/src/tlm/ovm_exports.svh
syn keyword ovmClass             ovm_blocking_get_export ovm_blocking_get_peek_export ovm_blocking_master_export
syn keyword ovmClass             ovm_blocking_peek_export ovm_blocking_put_export ovm_blocking_slave_export
syn keyword ovmClass             ovm_blocking_transport_export ovm_get_export ovm_get_peek_export
syn keyword ovmClass             ovm_master_export ovm_nonblocking_get_export ovm_nonblocking_get_peek_export
syn keyword ovmClass             ovm_nonblocking_master_export ovm_nonblocking_peek_export
syn keyword ovmClass             ovm_nonblocking_put_export ovm_nonblocking_slave_export
syn keyword ovmClass             ovm_nonblocking_transport_export ovm_peek_export ovm_put_export
syn keyword ovmClass             ovm_slave_export ovm_transport_export
syn keyword ovmClass             ovm_analysis_export
syn keyword ovmMethod            get_type_name

" ovm-2.0/src/tlm/ovm_imps.svh
syn keyword ovmClass             ovm_blocking_get_imp ovm_blocking_get_peek_imp ovm_blocking_master_imp
syn keyword ovmClass             ovm_blocking_peek_imp ovm_blocking_put_imp ovm_blocking_slave_imp
syn keyword ovmClass             ovm_blocking_transport_imp ovm_get_imp ovm_get_peek_imp ovm_master_imp
syn keyword ovmClass             ovm_nonblocking_get_imp ovm_nonblocking_get_peek_imp
syn keyword ovmClass             ovm_nonblocking_master_imp ovm_nonblocking_peek_imp
syn keyword ovmClass             ovm_nonblocking_put_imp ovm_nonblocking_slave_imp ovm_nonblocking_transport_imp
syn keyword ovmClass             ovm_peek_imp ovm_put_imp ovm_slave_imp ovm_transport_imp
syn keyword ovmClass             ovm_analysis_imp
syn keyword ovmMethod            writw

" ovm-2.0/src/tlm/ovm_ports.svh
syn keyword ovmClass             ovm_analysis_port ovm_blocking_get_peek_port ovm_blocking_get_port
syn keyword ovmClass             ovm_blocking_master_port ovm_blocking_peek_port ovm_blocking_put_port
syn keyword ovmClass             ovm_blocking_slave_port ovm_blocking_transport_port ovm_get_peek_port
syn keyword ovmClass             ovm_get_port ovm_master_port ovm_nonblocking_get_peek_port ovm_nonblocking_get_port
syn keyword ovmClass             ovm_nonblocking_master_port ovm_nonblocking_peek_port ovm_nonblocking_put_port
syn keyword ovmClass             ovm_nonblocking_slave_port ovm_nonblocking_transport_port ovm_peek_port
syn keyword ovmClass             ovm_put_port ovm_slave_port ovm_transport_port
syn keyword ovmClass             ovm_analysis_port
syn keyword ovmMethod            get_type_name write

" ovm-2.0/src/tlm/sqr_connections.svh
syn keyword ovmClass             ovm_seq_item_pull_port
syn keyword ovmMethod            connect_if
syn keyword ovmMethod            get get_next_item has_do_available peek put put_response try_next_item
syn keyword ovmMethod            item_done wait_for_sequences
syn keyword ovmClass             ovm_seq_item_pull_export
syn keyword ovmMethod            get get_next_item has_do_available peek put put_response try_next_item
syn keyword ovmMethod            item_done wait_for_sequences
syn keyword ovmClass             ovm_seq_item_pull_imp
syn keyword ovmMethod            get get_next_item has_do_available peek put put_response try_next_item
syn keyword ovmMethod            item_done wait_for_sequences

" ovm-2.0/src/tlm/sqr_ifs.svh
syn keyword ovmClass             sqr_if_base
syn keyword ovmMethod            get get_next_item has_do_available item_done peek put put_response try_next_item wait_for_sequences

" ovm-2.0/src/tlm/tlm.svh

" ovm-2.0/src/tlm/tlm_fifo_base.svh
syn keyword ovmClass             tlm_event
syn keyword ovmClass             tlm_fifo_base
syn keyword ovmMethod            can_get can_peek can_put flush get is_empty ok_to_get ok_to_peek
syn keyword ovmMethod            ok_to_put peek put size try_get try_peek try_put used

" ovm-2.0/src/tlm/tlm_fifos.svh
syn keyword ovmClass             tlm_fifo
syn keyword ovmMethod            can_get can_peek can_put flush get get_type_name is_empty
syn keyword ovmMethod            is_full peek put size try_get try_peek try_put used
syn keyword ovmClass             tlm_analysis_fifo
syn keyword ovmMethod            get_type_name write

" ovm-2.0/src/tlm/tlm_ifs.svh
syn keyword ovmClass             tlm_if_base
syn keyword ovmMethod            can_get can_peek can_put get nb_transport peek put
syn keyword ovmMethod            transport try_get try_peek try_put write

" ovm-2.0/src/tlm/tlm_imps.svh

" ovm-2.0/src/tlm/tlm_req_rsp.svh
syn keyword ovmClass             tlm_req_rsp_channel
syn keyword ovmMethod            create create_aliased_exports connect get_type_name
syn keyword ovmClass             tlm_transport_channel
syn keyword ovmMethod            nb_transport transport

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_verilog_syn_inits")
   if version < 508
      let did_verilog_syn_inits = 1
      command -nargs=+ HiLink hi link <args>
   else
      command -nargs=+ HiLink hi def link <args>
   endif

   " The default highlighting.
   HiLink verilogMethod          Function
   HiLink verilogTypeDef         TypeDef
   HiLink verilogAssertion       Include

   HiLink ovmClass               Type
   HiLink ovmTypeDef             Type
   HiLink ovmMethod              Function
   HiLink ovmMethodGlobal        Function
   HiLink ovmDeprecated          Error
   HiLink ovmDeprecatedClass     Error
   HiLink ovmDeprecatedMethod    Error
   HiLink ovmCompatibility       Underlined

   delcommand HiLink
endif

let b:current_syntax = "verilog_systemverilog"

" vim: ts=8

