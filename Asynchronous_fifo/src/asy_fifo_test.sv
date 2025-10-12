
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

class wr_test extends uvm_test;
	`uvm_component_utils(wr_test)
	environment envh;
	wr_sequence wr_seq_h;

	function new(string name = "wr_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		envh = environment::type_id::create("envh", this);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		wr_seq_h = wr_sequence::type_id::create("wr_seq_h");
		wr_seq_h.start(envh.wag.wsqrh);
		phase.drop_objection(this);

	endtask: run_phase

endclass: wr_test

class rd_test extends uvm_test;
	`uvm_component_utils(rd_test)
	environment envh;
	rd_sequence rd_seq_h;

	function new(string name = "rd_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		envh = environment::type_id::create("envh", this);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		rd_seq_h = rd_sequence::type_id::create("rd_seq_h");
		rd_seq_h.start(envh.rag.rsqrh);
		phase.drop_objection(this);

	endtask: run_phase

endclass: rd_test

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

class wr_test1 extends uvm_test;
	`uvm_component_utils(wr_test1)
	environment envh;
	wr_continuous_seq wr_seq_h;

	function new(string name = "wr_test1", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		envh = environment::type_id::create("envh", this);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		wr_seq_h = wr_continuous_seq::type_id::create("wr_seq_h");
		wr_seq_h.start(envh.wag.wsqrh);
		phase.drop_objection(this);
	endtask: run_phase

endclass: wr_test1


class rd_test1 extends uvm_test;
	`uvm_component_utils(rd_test1)
	environment envh;
	rd_continuous_seq rd_seq_h;

	function new(string name = "rd_test1", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		envh = environment::type_id::create("envh", this);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		rd_seq_h = rd_continuous_seq::type_id::create("rd_seq_h");
		rd_seq_h.start(envh.rag.rsqrh);
		phase.drop_objection(this);

	endtask: run_phase

endclass: rd_test1


class wr_test2 extends uvm_test;
	`uvm_component_utils(wr_test2)
	environment envh;
	wr_random_enable_seq wr_seq_h;

	function new(string name = "wr_test2", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		envh = environment::type_id::create("envh", this);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		wr_seq_h = wr_random_enable_seq::type_id::create("wr_seq_h");
		wr_seq_h.start(envh.wag.wsqrh);
		phase.drop_objection(this);
	endtask: run_phase

endclass: wr_test2


class rd_test2 extends uvm_test;
	`uvm_component_utils(rd_test2)
	environment envh;
	rd_random_enable_seq rd_seq_h;

	function new(string name = "rd_test2", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		envh = environment::type_id::create("envh", this);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		rd_seq_h = rd_random_enable_seq::type_id::create("rd_seq_h");
		rd_seq_h.start(envh.rag.rsqrh);
		phase.drop_objection(this);

	endtask: run_phase

endclass: rd_test2


class continuous_write_then_read extends uvm_test;
	`uvm_component_utils(continuous_write_then_read)
	environment envh;

	wr_continuous_seq 	wr_seq_1;	//continuous write
	rd_continuous_seq 	rd_seq_1;	//continuous read

	rinc_0 r0_h;
	winc_0 w0_h;

	function new(string name = "continuous_write_then_read", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		envh = environment::type_id::create("envh", this);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);

		wr_seq_1 = wr_continuous_seq::type_id::create("wr_seq_1");
		r0_h = rinc_0::type_id::create("r0_h");

		//begin
			fork
				wr_seq_1.start(envh.wag.wsqrh);
				r0_h.start(envh.rag.rsqrh);
			join

		rd_seq_1 = rd_continuous_seq::type_id::create("rd_seq_1");
		w0_h = winc_0::type_id::create("w0_h");
			fork
				rd_seq_1.start(envh.rag.rsqrh);
				w0_h.start(envh.wag.wsqrh);
			join
		//end

		phase.drop_objection(this);

	endtask: run_phase

endclass: continuous_write_then_read

class random_winc_rinc extends uvm_test;
	`uvm_component_utils(random_winc_rinc)
	environment envh;

	wr_random_enable_seq 	wr_seq_2;	//random write
	rd_random_enable_seq 	rd_seq_2;	//random read


	function new(string name = "random_winc_rinc", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		envh = environment::type_id::create("envh", this);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);

		wr_seq_2 = wr_random_enable_seq::type_id::create("wr_seq_2");
		rd_seq_2 = rd_random_enable_seq::type_id::create("rd_seq_2");

		fork
			wr_seq_2.start(envh.wag.wsqrh);
			rd_seq_2.start(envh.rag.rsqrh);
		join

		phase.drop_objection(this);

	endtask: run_phase

endclass: random_winc_rinc

