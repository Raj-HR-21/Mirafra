//agent

class alu_agent extends uvm_agent;
	`uvm_component_utils(alu_agent)
	alu_driver 	drvh;
	alu_monitor	monh;
	alu_sequencer	sqrh;

	function new(string name = "alu_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		monh = alu_monitor::type_id::create("monh", this);
		if(get_is_active() == UVM_ACTIVE) begin
			drvh = alu_driver::type_id::create("drvh", this);
			sqrh = alu_sequencer::type_id::create("sqrh", this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(get_is_active() == UVM_ACTIVE) begin
			drvh.seq_item_port.connect(sqrh.seq_item_export);
		end
	endfunction

endclass

