//// Write
class wr_driver extends uvm_driver#(seq_item);
	`uvm_component_utils(wr_driver)
	virtual wr_interface wvif;

	function new(string name = "wr_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual wr_interface)::get(this, "", "wintf", wvif); 
	endfunction: build_phase

	task run_phase(uvm_phase phase);
	forever begin
		seq_item_port.get_next_item(req);
		drive_wr();
		seq_item_port.item_done();
	end
	endtask: run_phase

	task drive_wr();
		repeat(1)@(wvif.wr_drv_cb);
		 wvif.wdata <= req.wdata ;
		 wvif.winc  <= req.winc;
		$display("");
		`uvm_info("W_DRV", $sformatf("WDATA = %0d | WINC = %0d", req.wdata, req.winc), UVM_NONE)
		//repeat(1)@(wvif.wr_drv_cb);

	endtask: drive_wr

endclass: wr_driver
//// Read
class rd_driver extends uvm_driver#(seq_item);
	`uvm_component_utils(rd_driver)
	virtual rd_interface rvif;

	function new(string name = "rd_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual rd_interface)::get(this, "", "rintf", rvif);
	endfunction: build_phase

	task run_phase(uvm_phase phase);
	forever begin
		seq_item_port.get_next_item(req);
		drive_rd();
		seq_item_port.item_done();
	end
	endtask: run_phase

	task drive_rd();
		repeat(1)@(rvif.rd_drv_cb);
		rvif.rinc <= req.rinc;
		//$display("\n");
		`uvm_info("R_DRV", $sformatf("RINC = %0d", req.rinc), UVM_NONE)
		//repeat(1)@(rvif.rd_drv_cb);
	endtask: drive_rd

endclass: rd_driver


