`ifndef A__SV
`define A__SV

class A extends uvm_component;
  `uvm_component_utils(A)

  C C_inst;
  uvm_blocking_put_port#(my_transaction) A_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
endclass

function void A::build_phase(uvm_phase phase);
  super.build_phase(phase);
  A_port = new("A_port", this);
  C_inst = C::type_id::create("C_inst", this);
endfunction

function void A::connect_phase (uvm_phase phase);
  super.connect_phase(phase);
  C_inst.C_port.connect(this.A_port);
endfunction

task A::main_phase(uvm_phase phase);

endtask

`endif
