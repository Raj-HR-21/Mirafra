//test

class alu_test extends uvm_test;
	`uvm_component_utils(alu_test)
	alu_env envh;

	function new(string name = "alu_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		envh = alu_env::type_id::create("envh", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		alu_sequence seq;
		phase.raise_objection(this,"Raised Objection");
		//phase.phase_done.set_drain_time(this, 50ns);
		seq = alu_sequence::type_id::create("seq", this);
		//repeat(20) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this,"Objection dropped");
	endtask

	virtual function void end_of_elaboration();
		uvm_top.print_topology();
	endfunction

endclass

class arith_both_op_test extends alu_test;
       `uvm_component_utils(arith_both_op_test)
	function new(string name = "arith_both_op_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		arith_both_op seq;
		phase.raise_objection(this);
		seq = arith_both_op::type_id::create("seq");
		//repeat(10) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass	

class logical_both_op_test extends alu_test;
       `uvm_component_utils(logical_both_op_test)
	function new(string name = "logical_both_op_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		logical_both_op seq;
		phase.raise_objection(this);
		seq = logical_both_op::type_id::create("seq");
		//repeat(10) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass

class arith_opa_test extends alu_test;
       `uvm_component_utils(arith_opa_test)
	function new(string name = "arith_opa_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		arith_opa seq;
		phase.raise_objection(this);
		seq = arith_opa::type_id::create("seq");
		//repeat(2) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass

class arith_opb_test extends alu_test;
       `uvm_component_utils(arith_opb_test)
	function new(string name = "arith_opb_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		arith_opb seq;
		phase.raise_objection(this);
		seq = arith_opb::type_id::create("seq");
		//repeat(2) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass	

class logical_opa_test extends alu_test;
       `uvm_component_utils(logical_opa_test)
	function new(string name = "logical_opa_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		logical_opa seq;
		phase.raise_objection(this);
		seq = logical_opa::type_id::create("seq");
		//repeat(2) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass

class logical_opb_test extends alu_test;
       `uvm_component_utils(logical_opb_test)
	function new(string name = "logical_opb_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		logical_opb seq;
		phase.raise_objection(this);
		seq = logical_opb::type_id::create("seq");
		//repeat(2) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass

class multiplication_op_test extends alu_test;
       `uvm_component_utils(multiplication_op_test)
	function new(string name = "multiplication_op_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		multiplication_op seq;
		phase.raise_objection(this);
		seq = multiplication_op::type_id::create("seq");
		//repeat(2) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass

class rotate_op_test extends alu_test;
       `uvm_component_utils(rotate_op_test)
	function new(string name = "rotate_op_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		rotate_op seq;
		phase.raise_objection(this);
		seq = rotate_op::type_id::create("seq");
		//repeat(2) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass

class arith_both_op_min_max_test extends alu_test;
       `uvm_component_utils(arith_both_op_min_max_test)
	function new(string name = "arith_both_op_min_max_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		arith_both_op_min_max seq;
		phase.raise_objection(this);
		seq = arith_both_op_min_max::type_id::create("seq");
		//repeat(2) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass


class arith_opa_min_max_test extends alu_test;
       `uvm_component_utils(arith_opa_min_max_test)
	function new(string name = "arith_opa_min_max_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		arith_opa_min_max seq;
		phase.raise_objection(this);
		seq = arith_opa_min_max::type_id::create("seq");
		//repeat(2) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass

class arith_opb_min_max_test extends alu_test;
       `uvm_component_utils(arith_opb_min_max_test)
	function new(string name = "arith_opb_min_max_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		arith_opb_min_max seq;
		phase.raise_objection(this);
		seq = arith_opb_min_max::type_id::create("seq");
		//repeat(2) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass

class arith_op_test extends alu_test;
       `uvm_component_utils(arith_op_test)
	function new(string name = "arith_op_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		arith_op seq;
		phase.raise_objection(this);
		seq = arith_op::type_id::create("seq");
		//repeat(10) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass	

class logical_op_test extends alu_test;
       `uvm_component_utils(logical_op_test)
	function new(string name = "logical_op_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	virtual task run_phase(uvm_phase phase);
		logical_op seq;
		phase.raise_objection(this);
		seq = logical_op::type_id::create("seq");
		//repeat(10) begin
			seq.start(envh.agnth.sqrh);
		//end
		phase.drop_objection(this);
	endtask
endclass

class reg_test extends alu_test;
	`uvm_component_utils(reg_test)
	function new(string name = "reg_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		regression seq;
		phase.raise_objection(this,"Raised Objection");
		//phase.phase_done.set_drain_time(this, 10ns);
		seq = regression::type_id::create("seq", this);
		repeat(10) begin
			seq.start(envh.agnth.sqrh);
		end
		phase.drop_objection(this,"Objection dropped");
	endtask
endclass

