`ifndef MY_CASE_IS_RELEVANT__SV
`define MY_CASE_IS_RELEVANT__SV

class sequence0 extends uvm_sequence #(my_transaction);
	`uvm_object_utils(sequence0)

	my_transaction m_trans;
	int num;
	bit has_delayed;

	function new (string name = "sequence0");
		super.new(name);
		num = 0;
		has_delayed = 0;
	endfunction

	virtual function bit is_relevant();
		if((num >= 3) && (!has_delayed))
			return 0;
		else
			return 1;
	endfunction

	virtual task wait_for_relevant();
		#10000
		has_delayed = 1;
	endtask

	virtual task body();
		if(starting_phase != null)
			starting_phase.raise_objection(this);

		repeat(10) begin
			num ++;
			`uvm_do(m_trans)
			`uvm_info("sequence0", "send one transaction", UVM_MEDIUM)
		end

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

		repeat(10) begin
			`uvm_do_with(m_trans, {m_trans.pload.size < 500;})
			`uvm_info("sequence1", "send one transaction", UVM_MEDIUM)
		end

		#100;

		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask
endclass

class my_case_is_relevant extends base_test;
    `uvm_component_utils(my_case_is_relevant)

    function new(string name = "my_case_is_relevant", uvm_component parent = null);
        super.new(name,parent);
    endfunction 

    extern virtual task main_phase(uvm_phase phase); 
endclass

task my_case_is_relevant::main_phase(uvm_phase phase);
	sequence0 seq0;
	sequence1 seq1;

	seq0 = new("seq0");
	seq1 = new("seq1");

	seq0.starting_phase = phase;
	seq1.starting_phase = phase;

	//env.i_agt.sqr.set_arbitration(SEQ_ARB_STRICT_FIFO);
	fork
		seq0.start(env.i_agt.sqr);
		seq1.start(env.i_agt.sqr); //all priority is used in `uvm_do and other macros like that
	join
endtask

`endif
