//// 
class environment extends uvm_env;
	`uvm_component_utils(environment)
	wr_agent wag;
	rd_agent rag;
	asy_fifo_func_cvg   cvg;
	asy_fifo_scoreboard scb;

	virtual_sequencer vsqr;

	function new(string name = "environment", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		wag = wr_agent::type_id::create("wag", this);
		rag = rd_agent::type_id::create("rag", this);
		cvg = asy_fifo_func_cvg::type_id::create("cvg", this);
		scb = asy_fifo_scoreboard::type_id::create("scb", this);

		vsqr = virtual_sequencer::type_id::create("vsqr", this);

	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		wag.wmonh.wr_port.connect(cvg.cov_wr_item);
		rag.rmonh.rd_port.connect(cvg.cov_rd_item);

		wag.wmonh.wr_port.connect(scb.scb_wr_item);
		rag.rmonh.rd_port.connect(scb.scb_rd_item);

		// connect virtual seqr
		vsqr.wr_sqr = wag.wsqrh;
		vsqr.rd_sqr = rag.rsqrh;
	endfunction:connect_phase

endclass: environment

