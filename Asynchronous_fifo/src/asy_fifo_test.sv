class base_test extends uvm_test;
	`uvm_component_utils(base_test)
	environment envh;
	virtual_sequence vseq;

	function new(string name = "base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		envh = environment::type_id::create("envh", this);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseq = virtual_sequence::type_id::create("vseq");
		vseq.start(envh.vsqr);
		phase.drop_objection(this);

	endtask: run_phase

endclass: base_test

