`ifndef MY_VSQR__SV
`define MY_VSQR__SV

class my_vsqr extends uvm_sequencer;
	`uvm_component_utils(my_vsqr)
	my_sequencer p_sqr0;
	my_sequencer p_sqr1;
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
endclass

`endif
