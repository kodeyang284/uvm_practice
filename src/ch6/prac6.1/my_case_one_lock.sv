`ifndef MY_CASE_ONE_LOCK__SV
`define MY_CASE_ONE_LOCK__SV

class sequence0 extends uvm_sequence #(my_transaction);
	`uvm_object_utils(sequence0)

	my_transaction m_trans;

	function new (string name = "sequence0");
		super.new(name);
	endfunction

	virtual task body();
		if(starting_phase != null)
			starting_phase.raise_objection(this);
		grab();
		repeat(5) begin
			`uvm_do(m_trans)
			`uvm_info("sequence0", "send one transaction", UVM_MEDIUM)
		end
		ungrab();
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
		repeat(3) begin
			`uvm_do_with(m_trans, {m_trans.pload.size < 500;})
			`uvm_info("sequence1", "send one transaction", UVM_MEDIUM)
		end
		lock();
		`uvm_info("my_case_one_lock", "locked the sequencer", UVM_MEDIUM)
		repeat(4) begin
			`uvm_do_with(m_trans, {m_trans.pload.size < 500;})
			`uvm_info("sequence1", "send one transaction", UVM_MEDIUM)
		end
		`uvm_info("my_case_one_lock", "unlocked the sequencer", UVM_MEDIUM)
		unlock();
		#100;
		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask
endclass

class my_case_one_lock extends base_test;
    `uvm_component_utils(my_case_one_lock)

    function new(string name = "my_case_one_lock", uvm_component parent = null);
        super.new(name,parent);
    endfunction 

    extern virtual task main_phase(uvm_phase phase); 
endclass

task my_case_one_lock::main_phase(uvm_phase phase);
	sequence0 seq0;
	sequence1 seq1;

	seq0 = new("seq0");
	seq1 = new("seq1");

	seq0.starting_phase = phase;
	seq1.starting_phase = phase;

	env.i_agt.sqr.set_arbitration(SEQ_ARB_STRICT_FIFO);
	fork
		seq0.start(env.i_agt.sqr, null, 100);
		seq1.start(env.i_agt.sqr, null, 200); //all priority is used in `uvm_do and other macros like that
	join
endtask

`endif
