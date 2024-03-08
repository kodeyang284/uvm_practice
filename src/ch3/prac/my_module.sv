`ifndef MY_MODULE__SV
`define MY_MODULE__SV

class my_module extends uvm_component;

  uvm_blocking_get_port #(my_transaction) port;
  uvm_analysis_port #(my_transaction) ap;


  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);

  `uvm_component_utils(my_module)

endclass

function my_module::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void my_module::build_phase (uvm_phase phase);
  super.build_phase(phase);
  port = new("port", this);
  ap = new("ap",this);
endfunction

task my_module::main_phase (uvm_phase phase);
  my_transaction tr;
  my_transaction new_tr;
  super.main_phase(phase);
  while(1) begin
    port.get(tr);
    new_tr = new("new_tr");
    new_tr.copy(tr);
//    `uvm_info("my_module", "get one transaction, copy and print it:", UVM_LOW)
 //   new_tr.print();
    ap.write(new_tr);
  end
endtask

`endif
