class seq_item extends uvm_sequence_item;
	rand logic [`DSIZE-1 : 0]wdata;
	rand logic winc;
	rand logic rinc;
	logic wrst_n, rrst_n; 
	logic rempty;
	logic [`DSIZE-1: 0]rdata;
	logic wfull;

	`uvm_object_utils_begin(seq_item)
		`uvm_field_int(wdata, UVM_ALL_ON)
		`uvm_field_int(winc, UVM_ALL_ON)
		`uvm_field_int(wfull, UVM_ALL_ON)
		`uvm_field_int(rdata, UVM_ALL_ON)
		`uvm_field_int(rinc, UVM_ALL_ON)
		`uvm_field_int(rempty, UVM_ALL_ON)
		`uvm_field_int(wrst_n, UVM_ALL_ON)
		`uvm_field_int(rrst_n, UVM_ALL_ON)
	`uvm_object_utils_end	

	function new(string name = "seq_item");
		super.new(name);
	endfunction: new


endclass: seq_item
