`ifndef MY_CASE0__SV
`define MY_CASE0__SV

class case0_sequence extends uvm_sequence #(my_transaction);
  `uvm_object_utils(case0_sequence)

  my_transaction m_trans;

  function new (string name = "case0_sequence");
    super.new(name);
  endfunction

  virtual task body();
    if(starting_phase != null)
      starting_phase.raise_objection(this);

    #10000;
    `uvm_info("case0_sequence", "raise_objection", UVM_LOW)

    if(starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
  
endclass

class my_case0 extends base_test;
  `uvm_component_utils(my_case0)

  function new(string name = "my_case0", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase); 
  extern virtual task post_main_phase(uvm_phase phase); 
  extern virtual function void final_phase(uvm_phase phase); 

endclass

function void my_case0::build_phase(uvm_phase phase);
  super.build_phase(phase);

  uvm_config_db#(uvm_object_wrapper)::set(this,
                                          "env.i_agt.sqr.main_phase",
                                          "default_sequence",
                                          case0_sequence::type_id::get());

endfunction

task my_case0::post_main_phase(uvm_phase phase);
  `uvm_info("my_case0", "enter post_main_phase", UVM_LOW)
endtask

function void my_case0::final_phase (uvm_phase phase);
  `uvm_info("my_case0", "enter final phase", UVM_LOW)
endfunction
  
`endif
