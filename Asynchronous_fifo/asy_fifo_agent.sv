//// Write
class wr_agent extends uvm_agent;
	`uvm_component_utils(wr_agent)
	wr_driver wdrvh;
	wr_monitor wmonh;
	wr_sequencer wsqrh;

	function new(string name = "wr_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		wmonh = wr_monitor::type_id::create("wmonh", this);
		if(get_is_active() ==  UVM_ACTIVE)begin
			wsqrh = wr_sequencer::type_id::create("wsqrh", this);
			wdrvh = wr_driver::type_id::create("wdrvh", this);
		end
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		if(get_is_active() ==  UVM_ACTIVE)begin
			wdrvh.seq_item_port.connect(wsqrh.seq_item_export);
		end
	endfunction: connect_phase

endclass: wr_agent

//// Read
class rd_agent extends uvm_agent;
	`uvm_component_utils(rd_agent)
	rd_driver rdrvh;
	rd_monitor rmonh;
	rd_sequencer rsqrh;

	function new(string name = "rd_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rmonh = rd_monitor::type_id::create("rmonh", this);
		if(get_is_active() ==  UVM_ACTIVE)begin
			rsqrh = rd_sequencer::type_id::create("rsqrh", this);
			rdrvh = rd_driver::type_id::create("rdrvh", this);
		end
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		if(get_is_active() ==  UVM_ACTIVE)begin
			rdrvh.seq_item_port.connect(rsqrh.seq_item_export);
		end
	endfunction: connect_phase

endclass: rd_agent

