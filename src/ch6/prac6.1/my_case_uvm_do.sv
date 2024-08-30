`ifndef MY_CASE_UVM_DO__SV
`define MY_CASE_UVM_DO__SV

class sequence_item extends uvm_sequence #(my_transaction);
	`uvm_object_utils(sequence_item)

	my_transaction m_trans;

	function new (string name = "sequence_item");
		super.new(name);
	endfunction
endclass

class sequence0 extends sequence_item;
	`uvm_object_utils(sequence0)

	int num;
	bit has_delayed;

	function new (string name = "sequence0");
		super.new(name);
		num = 0;
		has_delayed = 0;
	endfunction

	virtual function bit uvm_do();
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

class sequence1 extends sequence_item;
	`uvm_object_utils(sequence0)

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

class sequence3 extends sequence_item;
	`uvm_object_utils(sequence3)

	function new (string name = "sequence3");
		super.new(name);
	endfunction

	virtual task body();
		int num = 0;
		int p_sz;

		if(starting_phase != null)
			starting_phase.raise_objection(this);

		repeat(10) begin
			num ++;

			`uvm_info("my_case_uvm_do", "create a transaction", UVM_MEDIUM)
			`uvm_create(m_trans) /* equel to m_trans = new("m_trans"); */
			assert(m_trans.randomize());
			p_sz = m_trans.pload.size();
			{m_trans.pload[p_sz - 4],
			m_trans.pload[p_sz - 3],
			m_trans.pload[p_sz - 2],
			m_trans.pload[p_sz - 1]}
			= num;
			`uvm_send(m_trans)
			`uvm_info("my_case_uvm_do", "send a transaction", UVM_MEDIUM)
			
		end

		#100;

		if(starting_phase != null)
			starting_phase.drop_objection(this);

	endtask
endclass

class sequence_rand_send extends sequence_item;
	`uvm_object_utils(sequence_rand_send)

	function new (string name = "sequence_rand_send");
		super.new(name);
	endfunction

	virtual task body();
		if(starting_phase != null)
			starting_phase.raise_objection(this);

		repeat (10) begin;
			m_trans = new("m_trans");
			`uvm_rand_send(m_trans)
			`uvm_info("my_case_uvm_do", "send a randomized transaction", UVM_MEDIUM)
			//m_trans.print();
			//`uvm_rand_send_pri(m_trans, 200)
			//`uvm_rand_send_with(m_trans, {m_trans.pload.size == 100;})
			//`uvm_rand_send_pri_with(m_trans, 200, {m_trans.pload.size == 100;})
		end

		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask
endclass

class sequence_start_finish extends sequence_item;
	`uvm_object_utils(sequence_start_finish)

	function new (string name = "sequence_start_finish");
		super.new(name);
	endfunction

	virtual task body();
		if(starting_phase != null)
			starting_phase.raise_objection(this);

		repeat (10) begin
			m_trans = new("m_trans");
			assert(m_trans.randomize() with {m_trans.pload.size == 200;});
			start_item(m_trans);
			//assert(m_trans.randomize() with {tr.pload.size == 200;});
			finish_item(m_trans);
			`uvm_send(m_trans)
			`uvm_info("my_case_uvm_do", "send a randomized transaction", UVM_MEDIUM)
		end

		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask
endclass

class sequence_6_3_5 extends sequence_item;
	`uvm_object_utils(sequence_6_3_5)
	int num;

	function new (string name = "sequence_6_3_5");
		super.new(name);
	endfunction

	virtual task pre_do(bit is_item);
		#100;
		`uvm_info("my_case_uvm_do", "this is pre_do", UVM_MEDIUM)
	endtask

	virtual function void mid_do (uvm_sequence_item this_item);
		my_transaction tr;
		int p_sz;
		`uvm_info("my_case_uvm_do", "thiis is mid do", UVM_MEDIUM)
		void'($cast(tr, this_item));
		p_sz = tr.pload.size;
		{tr.pload[p_sz - 4],       
		tr.pload[p_sz - 3],       
		tr.pload[p_sz - 2],       
		tr.pload[p_sz - 1]} = num;
		tr.crc = tr.calc_crc();    
		tr.print();                
	endfunction

	virtual function void post_do (uvm_sequence_item this_item);
		`uvm_info("my_case_uvm_do", "this is post do", UVM_MEDIUM)
	endfunction

	virtual task body();
		if(starting_phase != null)
			starting_phase.raise_objection(this);

		repeat (10) begin
			`uvm_do(m_trans)
			`uvm_info("my_case_uvm_do", "send a randomized transaction", UVM_MEDIUM)
		end
		#100;
		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask
endclass

class crc_seq extends sequence_item;
	`uvm_object_utils(crc_seq)

	function new (string name = "crc_seq");
		super.new(name);
	endfunction

	virtual task body();
		my_transaction tr;
		`uvm_do_with(tr, {tr.crc_err ==1;tr.dmac == 48'h980F;})
					 
	endtask
endclass

class long_seq extends sequence_item;
	`uvm_object_utils(long_seq)
	rand bit [47:0] ldmac;

	function new (string name = "long_seq");
		super.new(name);
	endfunction

	virtual task body();
		my_transaction tr;
		`uvm_do_with(tr, {tr.crc_err == 0;
		             tr.pload.size() == 1500;
					 tr.dmac == ldmac;})
		tr.print();
	endtask
endclass

class sequence_6_4_1 extends sequence_item;
	`uvm_object_utils(sequence_6_4_1)
	function new (string name = "sequence_6_4_1");
		super.new(name);
	endfunction

	virtual task body();
		crc_seq cseq;
		long_seq lseq;

		if(starting_phase != null)
			starting_phase.raise_objection(this);

		repeat (10) begin
			//cseq = new("cseq");
			//cseq.start(m_sequencer);
			//lseq = new("lseq");
			//lseq.start(m_sequencer);
			`uvm_do(cseq)
			`uvm_do_with(lseq, {lseq.ldmac == 48'hFFFF;})
		end
		#100;
		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask
endclass

class sequence_6_4_4 extends sequence_item;
	`uvm_object_utils(sequence_6_4_4)
	`uvm_declare_p_sequencer(my_sequencer)

	function new (string name = "sequence_6_4_4");
		super.new(name);
	endfunction

	virtual task body();
		if (starting_phase != null) begin
			starting_phase.raise_objection(this);
		end

		repeat (10) begin
			`uvm_do_with(m_trans, {m_trans.dmac == p_sequencer.dmac;
			                       m_trans.smac == p_sequencer.smac;})
			m_trans.print();
		end

		#100;

		if (starting_phase != null) begin
			starting_phase.drop_objection(this);
		end
	endtask
endclass

class my_case_uvm_do extends base_test;
	`uvm_component_utils(my_case_uvm_do)

	function new(string name = "my_case_uvm_do", uvm_component parent = null);
		super.new(name,parent);
	endfunction 

	/*
	virtual task main_phase(uvm_phase phase);
		sequence_6_4_4 seq;
		seq = new("seq");
		seq.starting_phase = phase;
		seq.start(env.i_agt.sqr);
	endtask
	*/
	
	virtual function void build_phase (uvm_phase phase);
		super.build_phase(phase);

		uvm_config_db#(bit[47:0])::set(this, "env.i_agt.sqr", "dmac", 48'hF9765);
		uvm_config_db#(bit[47:0])::set(this, "env.i_agt.sqr", "smac", 48'h89F23);

		uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase", "default_sequence", sequence_6_4_4::type_id::get());
	endfunction
endclass

`endif
