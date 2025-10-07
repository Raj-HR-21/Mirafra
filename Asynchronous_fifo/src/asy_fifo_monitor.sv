//// Write
class wr_monitor extends uvm_monitor;
	`uvm_component_utils(wr_monitor)

	virtual wr_interface wvif;
	seq_item wr_item;
	uvm_analysis_port#(seq_item) wr_port;
	int wc;

	function new(string name = "wr_monitor", uvm_component parent = null);
		super.new(name, parent);
		wr_port = new("wr_port", this);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual wr_interface)::get(this, "", "wintf", wvif);
	endfunction: build_phase

	task run_phase(uvm_phase phase);
	repeat(1)@(wvif.wr_mon_cb);
//	wr_item = seq_item::type_id::create("wr_item");
	forever begin
		repeat(1)@(wvif.wr_mon_cb);
			wr_item = seq_item::type_id::create("wr_item");
		if(wvif.winc) begin
			wc++;
			wr_item.wrst_n = wvif.wrst_n;
			wr_item.wdata = wvif.wdata;
			wr_item.winc  = wvif.winc;
			wr_item.wfull = wvif.wfull;
			`uvm_info("WR_MON", $sformatf("WDATA = %0d | WFULL = %0b | WRESET = %b | WINC = %b", wr_item.wdata, wr_item.wfull, wr_item.wrst_n, wr_item.winc), UVM_NONE)
			wr_port.write(wr_item);
		end
	//	repeat(1)@(wvif.wr_mon_cb);
	end
	endtask: run_phase

endclass: wr_monitor

//// Read
class rd_monitor extends uvm_monitor;
	`uvm_component_utils(rd_monitor)

	virtual rd_interface rvif;
	seq_item rd_item;
	uvm_analysis_port#(seq_item) rd_port;
	int rc;

	function new(string name = "rd_monitor", uvm_component parent = null);
		super.new(name, parent);
		rd_port = new("rd_port", this);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual rd_interface)::get(this, "", "rintf", rvif);
	endfunction: build_phase

	task run_phase(uvm_phase phase);
	repeat(1)@(rvif.rd_mon_cb);
//	rd_item = seq_item::type_id::create("rd_item");
	forever begin
		repeat(1)@(rvif.rd_mon_cb);
		if(rvif.rinc) begin
			rd_item = seq_item::type_id::create("rd_item");
			rc++;
			rd_item.rrst_n = rvif.rrst_n;
			rd_item.rdata = rvif.rdata;
			rd_item.rinc  = rvif.rinc;
			rd_item.rempty= rvif.rempty;
			`uvm_info("- RD_MON -", $sformatf("RDATA = %0d | REMPTY = %b | RRESET = %b | RINC = %b", rd_item.rdata, rd_item.rempty, rd_item.rrst_n, rd_item.rinc), UVM_NONE)
			rd_port.write(rd_item);
		end
	//	repeat(1)@(rvif.rd_mon_cb);
	end
	endtask: run_phase

endclass: rd_monitor
