//sequence

class alu_sequence extends uvm_sequence#(alu_seq_item);
	`uvm_object_utils(alu_sequence)
	alu_seq_item req;
        int trxn;

	function new (string name = "alu_sequence");
		super.new(name);
	endfunction

	virtual task body;
		repeat(`no_trxn) begin
		req = alu_seq_item::type_id::create("req");
		wait_for_grant();
		if(req.randomize()) begin
			trxn += 1;
			$display("");
			`uvm_info("SEQ :", $sformatf("GENERATED TRXN : %0d", trxn),  UVM_LOW)
			`uvm_info("SEQ: ", $sformatf("CE = %b| MODE = %b| CMD = %0d| INP_VALID = %0d| OPA = %0d| OPB = %0d| CIN = %b", req.CE, req.MODE, req.CMD, req.INP_VALID, req.OPA, req.OPB, req.CIN), UVM_LOW)
		end
		else `uvm_info("SEQ: ", $sformatf("------ NO RANDOMIZATION----------"), UVM_NONE)

		send_request(req);
		wait_for_item_done();
		end
	endtask
	
endclass

class arith_both_op extends alu_sequence;
	`uvm_object_utils(arith_both_op)
	function new (string name = "arith_both_op");
		super.new(name);
	endfunction
	virtual task body;
		repeat(10) begin
		`uvm_do_with(req, {req.MODE==1; req.CMD inside {[0:3],[8:10]}; req.INP_VALID inside {0,3};})
		end
	endtask
endclass

class logical_both_op extends alu_sequence;
	`uvm_object_utils(logical_both_op)
	function new (string name = "logical_both_op");
		super.new(name);
	endfunction
	virtual task body;
		repeat(10) begin
		`uvm_do_with(req, {req.MODE==0; req.CMD inside {[0:5],[12:13]}; req.INP_VALID inside {0,3};})
		end
	endtask
endclass

class arith_opa extends alu_sequence;
	`uvm_object_utils(arith_opa)
	function new (string name = "arith_opa");
		super.new(name);
	endfunction
	virtual task body;
		repeat(5) begin
		`uvm_do_with(req, {req.MODE==1; req.CMD inside {4,5}; req.INP_VALID inside {0,1,3};})
		end
	endtask
endclass

class arith_opb extends alu_sequence;
	`uvm_object_utils(arith_opb)
	function new (string name = "arith_opb");
		super.new(name);
	endfunction
	virtual task body;
		repeat(5) begin
		`uvm_do_with(req, {req.MODE==1; req.CMD inside {6,7}; req.INP_VALID inside {0,2,3};})
		end
	endtask
endclass

class logical_opa extends alu_sequence;
	`uvm_object_utils(logical_opa)
	function new (string name = "logical_opa");
		super.new(name);
	endfunction
	virtual task body;
		repeat(5) begin
		`uvm_do_with(req, {req.MODE==0; req.CMD inside {6,8,9}; req.INP_VALID inside {0,1,3};})
		end
	endtask
endclass

class logical_opb extends alu_sequence;
	`uvm_object_utils(logical_opb)
	function new (string name = "logical_opb");
		super.new(name);
	endfunction
	virtual task body;
		repeat(5) begin
		`uvm_do_with(req, {req.MODE==0; req.CMD inside {7,10,11}; req.INP_VALID inside {0,2,3};})
		end
	endtask
endclass

class multiplication_op extends alu_sequence;
	`uvm_object_utils(multiplication_op)
	function new (string name = "multiplication_op");
		super.new(name);
        endfunction
	virtual task body;
		repeat(10) begin
		`uvm_do_with(req, {req.MODE==1; req.CMD inside {9,10}; req.INP_VALID inside {0,3};})
		end
	endtask
endclass

class rotate_op extends alu_sequence;
	`uvm_object_utils(rotate_op)
	function new (string name = "rotate_op");
		super.new(name);
	endfunction
	virtual task body;
		repeat(5) begin
		`uvm_do_with(req, {req.MODE==0;  req.CMD inside {12,13}; req.INP_VALID inside {0,3};});
		end
	endtask
endclass

class arith_both_op_min_max extends alu_sequence;
	`uvm_object_utils(arith_both_op_min_max)
	function new (string name = "arith_both_op_min_max");
		super.new(name);
	endfunction
	virtual task body;
		repeat(20) begin
		`uvm_do_with(req, {req.MODE==1; req.CMD inside {[0:3],[8:10]}; req.INP_VALID inside {0,3}; req.OPA inside {0, `DATA_WIDTH, 2*`DATA_WIDTH, 2**`DATA_WIDTH -1};})
		end
	endtask
endclass

class arith_opa_min_max extends alu_sequence;
	`uvm_object_utils(arith_opa_min_max)
	function new (string name = "arith_opa_min_max");
		super.new(name);
	endfunction
	virtual task body;
		repeat(5) begin
		`uvm_do_with(req, {req.MODE==1; req.CMD inside {4,5}; req.INP_VALID inside {0,1,3}; req.OPA inside {0, `DATA_WIDTH, 2*`DATA_WIDTH, 2**`DATA_WIDTH -1};})
		end
	endtask
endclass

class arith_opb_min_max extends alu_sequence;
	`uvm_object_utils(arith_opb_min_max)
	function new (string name = "arith_opb_min_max");
		super.new(name);
	endfunction
	virtual task body;
		repeat(5) begin
		`uvm_do_with(req, {req.MODE==1; req.CMD inside {6,7}; req.INP_VALID inside {0,2,3}; req.OPA inside {0, `DATA_WIDTH, 2*`DATA_WIDTH, 2**`DATA_WIDTH -1};})
		end
	endtask
endclass

class arith_op extends alu_sequence;
	`uvm_object_utils(arith_op)
	function new (string name = "arith_op");
		super.new(name);
	endfunction
	virtual task body;
		repeat(10) begin
		`uvm_do_with(req, {req.MODE==1; req.INP_VALID inside {[0:3]}; req.CMD inside {[0:15]}; })
		end
	endtask
endclass

class logical_op extends alu_sequence;
	`uvm_object_utils(logical_op)
	function new (string name = "logical_op");
		super.new(name);
	endfunction
	virtual task body;
		repeat(10) begin
		`uvm_do_with(req, {req.MODE==0; req.INP_VALID inside {[0:3]}; req.CMD inside {[0:15]}; })
		end
	endtask
endclass

class regression extends alu_sequence;
	arith_both_op arith_both;
	logical_both_op logical_both;
	arith_opa arith_a;
	arith_opb arith_b;
	logical_opa logical_a;
	logical_opb logical_b;
	multiplication_op multiplication;
	rotate_op rotate;
	arith_both_op_min_max arith_min_max;
	arith_opa_min_max arith_a_min_max;
	arith_opb_min_max arith_b_min_max;
	arith_op arith;
	logical_op logical;

	`uvm_object_utils(regression)
	function new (string name = "regression");
		super.new(name);
	endfunction
	virtual task body;
		repeat(10) begin
		`uvm_do(arith_both)
		`uvm_do(logical_both)
		`uvm_do(arith_a)
		`uvm_do(arith_b)
		`uvm_do(logical_a)
		`uvm_do(logical_b)
		`uvm_do(multiplication)
		`uvm_do(rotate)
		`uvm_do(arith_min_max)
		`uvm_do(arith_a_min_max)
		`uvm_do(arith_b_min_max)

		`uvm_do(arith)
		`uvm_do(logical)
		end
	endtask
endclass

