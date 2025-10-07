//// Write
class wr_sequencer extends uvm_sequencer#(seq_item);
	`uvm_component_utils(wr_sequencer)

	function new(string name = "wr_sequencer", uvm_component parent = null);
		super.new(name, parent);	
	endfunction: new

endclass: wr_sequencer
//// Read
class rd_sequencer extends uvm_sequencer#(seq_item);
	`uvm_component_utils(rd_sequencer)

	function new(string name = "rd_sequencer",uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

endclass: rd_sequencer
/////////////////////////////////

class virtual_sequencer extends uvm_sequencer;
	`uvm_component_utils(virtual_sequencer)
	wr_sequencer wr_sqr;
	rd_sequencer rd_sqr;
	function new(string name = "virtual_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

endclass: virtual_sequencer
