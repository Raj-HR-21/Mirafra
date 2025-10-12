/*
//// Write
class wr_monitor extends uvm_monitor;
	`uvm_component_utils(wr_monitor)

	virtual asy_fifo_interface vif;
	seq_item wr_item;
	uvm_analysis_port#(seq_item) wr_port;
	int wc;

	function new(string name = "wr_monitor", uvm_component parent = null);
		super.new(name, parent);
		wr_port = new("wr_port", this);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual asy_fifo_interface)::get(this, "", "intf", vif);
	endfunction: build_phase

	task run_phase(uvm_phase phase);
	super.run_phase(phase);
	wr_item = seq_item::type_id::create("wr_item");
	forever begin
		repeat(1)@(vif.wr_mon_cb);
		wc++;
		wr_item.wrst_n = vif.wrst_n;
		wr_item.wdata = vif.wdata;
		wr_item.winc  = vif.winc;
		wr_item.wfull = vif.wfull;
		`uvm_info("WR_MON", $sformatf("WDATA = %0d | WFULL = %0b | WRESET = %b | WINC = %b", wr_item.wdata, wr_item.wfull, wr_item.wrst_n, wr_item.winc), UVM_NONE)
		wr_port.write(wr_item);
	end
	endtask: run_phase

endclass: wr_monitor

//// Read
class rd_monitor extends uvm_monitor;
	`uvm_component_utils(rd_monitor)

	virtual asy_fifo_interface vif;
	seq_item rd_item;
	uvm_analysis_port#(seq_item) rd_port;
	int rc;

	function new(string name = "rd_monitor", uvm_component parent = null);
		super.new(name, parent);
		rd_port = new("rd_port", this);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual asy_fifo_interface)::get(this, "", "intf", vif);
	endfunction: build_phase

	task run_phase(uvm_phase phase);
	super.run_phase(phase);
	repeat(1)@(vif.rd_mon_cb);
	rd_item = seq_item::type_id::create("rd_item");
	forever begin
		repeat(1)@(vif.rd_mon_cb);
			rc++;
			rd_item.rrst_n = vif.rrst_n;
			rd_item.rdata = vif.rdata;
			rd_item.rinc  = vif.rinc;
			rd_item.rempty= vif.rempty;
			`uvm_info("- RD_MON -", $sformatf("RDATA = %0d | REMPTY = %b | RRESET = %b | RINC = %b", rd_item.rdata, rd_item.rempty, rd_item.rrst_n, rd_item.rinc), UVM_NONE)
			rd_port.write(rd_item);
		//end
	//	repeat(1)@(vif.rd_mon_cb);
	end
	endtask: run_phase

endclass: rd_monitor
*/

//// Write Monitor
class wr_monitor extends uvm_monitor;
	`uvm_component_utils(wr_monitor)

	virtual asy_fifo_interface vif;
	seq_item wr_item;
	uvm_analysis_port#(seq_item) wr_port;
	int wc;

	function new(string name = "wr_monitor", uvm_component parent = null);
		super.new(name, parent);
		wr_item = new();  // Create once in constructor
		wr_port = new("wr_port", this);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual asy_fifo_interface)::get(this, "", "intf", vif))
		`uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".intf"})
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		repeat(2)@(vif.wr_mon_cb);  // Initial delay

		forever begin
			wr_item = seq_item::type_id::create("wr_item");
			wc++;
			wr_item.wrst_n = vif.wrst_n;
			wr_item.wdata  = vif.wdata;
			wr_item.winc   = vif.winc;
			wr_item.wfull  = vif.wfull;

			wr_port.write(wr_item);
			`uvm_info("W_MON", $sformatf("WDATA = %0d | WFULL = %0b | WRESET = %b | WINC = %b", wr_item.wdata, wr_item.wfull, wr_item.wrst_n, wr_item.winc), UVM_MEDIUM)
			repeat(1)@(vif.wr_mon_cb);

	end
	endtask: run_phase

endclass: wr_monitor

//// Read Monitor
class rd_monitor extends uvm_monitor;
	`uvm_component_utils(rd_monitor)

	virtual asy_fifo_interface vif;
	seq_item rd_item;
	uvm_analysis_port#(seq_item) rd_port;
	int rc;

	function new(string name = "rd_monitor", uvm_component parent = null);
		super.new(name, parent);
		rd_item = new();  // Create once in constructor
		rd_port = new("rd_port", this);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual asy_fifo_interface)::get(this, "", "intf", vif))
		`uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".intf"})
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		repeat(4)@(vif.rd_mon_cb);  // Initial delay

		forever begin
			rd_item = seq_item::type_id::create("rd_item");
			rc++;
			rd_item.rrst_n = vif.rrst_n;
			rd_item.rdata  = vif.rdata;
			rd_item.rinc   = vif.rinc;
			rd_item.rempty = vif.rempty;

			rd_port.write(rd_item);
			`uvm_info("- R_MON -", $sformatf("RDATA = %0d | REMPTY = %b | RRESET = %b | RINC = %b", rd_item.rdata, rd_item.rempty, rd_item.rrst_n, rd_item.rinc), UVM_MEDIUM)

			repeat(1)@(vif.rd_mon_cb);

	end
	endtask: run_phase

endclass: rd_monitor
