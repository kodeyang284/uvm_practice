`ifndef MY_CASE2__SV
`define MY_CASE2__SV

class sequence0 extends uvm_sequence #(my_transaction);
	`uvm_object_utils(sequence0)

	my_transaction m_trans;

	function new (string name = "sequence0");
		super.new(name);
	endfunction

	virtual task body();
		if(starting_phase != null)
			starting_phase.raise_objection(this);
		repeat(5) begin
			`uvm_do(m_trans)
			`uvm_info("sequence0", "send one transaction", UVM_MEDIUM)
		end
		#100;
		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask
endclass

class sequence1 extends uvm_sequence #(my_transaction);
	`uvm_object_utils(sequence0)

	my_transaction m_trans;

	function new (string name = "sequence0");
		super.new(name);
	endfunction

	virtual task body();
		if(starting_phase != null)
			starting_phase.raise_objection(this);
		repeat(5) begin
			`uvm_do_with(m_trans, {m_trans.pload.size < 500;})
			`uvm_info("sequence1", "send one transaction", UVM_MEDIUM)
		end
		#100;
		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask
endclass

class my_case2 extends base_test;
    `uvm_component_utils(my_case2)

    function new(string name = "my_case2", uvm_component parent = null);
        super.new(name,parent);
    endfunction 

    extern virtual task main_phase(uvm_phase phase); 
endclass


task my_case2::main_phase(uvm_phase phase);
	sequence0 seq0;
	sequence1 seq1;

	seq0 = new("seq0");
	seq1 = new("seq1");

	seq0.starting_phase = phase;
	seq1.starting_phase = phase;

	fork
		seq0.start(env.i_agt.sqr);
		seq1.start(env.i_agt.sqr);
	join
endtask

`endif
