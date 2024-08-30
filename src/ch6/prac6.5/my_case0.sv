`ifndef MY_CASE0__SV
`define MY_CASE0__SV

class read_file_seq extends uvm_sequence #(my_transaction);
   my_transaction m_trans;
   string file_name;
   `uvm_object_utils(read_file_seq)

   function  new(string name= "read_file_seq");
      super.new(name);
   endfunction 
   
   virtual task body();
      `uvm_info("read_file_seq", $sformatf("file name is %0s", file_name), UVM_MEDIUM)
      repeat (10) begin
         `uvm_do(m_trans)
         `uvm_info("read_file_seq", "send one transaction", UVM_MEDIUM)
      end
   endtask
endclass

class drv0_seq extends uvm_sequence #(my_transaction);
	my_transaction m_trans;
	`uvm_object_utils(drv0_seq)
	function new (string name = "drv0_seq");
		super.new(name);
	endfunction

	virtual task body();
		repeat(10) begin
			`uvm_do(m_trans)
			`uvm_info("drv0_seq", "send one transaction", UVM_MEDIUM)
		end
	endtask
endclass

class drv1_seq extends uvm_sequence #(my_transaction);
	my_transaction m_trans;
	`uvm_object_utils(drv1_seq)
	function new (string name = "drv1_seq");
		super.new(name);
	endfunction

	virtual task body();
		repeat(10) begin
			`uvm_do(m_trans)
			`uvm_info("drv1_seq", "send one transaction", UVM_MEDIUM)
		end

	endtask
endclass

class case0_vseq extends uvm_sequence;
	`uvm_object_utils(case0_vseq)
	`uvm_declare_p_sequencer(my_vsqr)

	function new(string name = "case0_vseq");
		super.new(name);
	endfunction

	virtual task body();
		my_transaction tr;
		drv0_seq seq0;
		drv1_seq seq1;

		if(starting_phase != null)
			starting_phase.raise_objection(this);

		`uvm_do_on_with(tr, p_sequencer.p_sqr0, {tr.pload.size == 1500;})
		`uvm_info("vsqe", "send a longest package on p_sewquencer.p_sqr0", UVM_MEDIUM)

		fork
			`uvm_do_on(seq0, p_sequencer.p_sqr0);
			`uvm_do_on(seq1, p_sequencer.p_sqr1);
		join
		
		#100;

		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask
endclass

class my_case0 extends base_test;
	`uvm_component_utils(my_case0)

	function new (string name = "my_case0", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(uvm_object_wrapper)::set(this, "v_sqr.main_phase", "default_sequence", case0_vseq::type_id::get());
	endfunction
endclass

`endif
