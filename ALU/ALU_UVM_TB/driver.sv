//driver

class alu_driver extends uvm_driver#(alu_seq_item);
	`uvm_component_utils(alu_driver)
	virtual alu_interface vif;
	//Analysis port to send data to scb and coverage
	uvm_analysis_port#(alu_seq_item) drv_port;
        int trxn;

	function new(string name = "alu_driver", uvm_component parent = null);
		super.new(name,parent);
		drv_port = new("drv_port", this);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual alu_interface)::get(this, "" , "vif", vif) ) begin
			`uvm_fatal(get_type_name(), $sformatf("NO_VIF"));
		end
	endfunction

	function bit both_op();
		if(req.MODE == 1)
			return (req.CMD inside {0,1,2,3,8,9,10});
		else 
			return (req.CMD inside {[0:5],12,13});
	endfunction : both_op

	task drive_to_dut();
		//vif.driver_cb.RESET	<= req.RESET;
		vif.driver_cb.CE 	<= req.CE;
		vif.driver_cb.CMD	<= req.CMD;
		vif.driver_cb.MODE	<= req.MODE;
		vif.driver_cb.INP_VALID <= req.INP_VALID;
		vif.driver_cb.OPA	<= req.OPA;
		vif.driver_cb.OPB	<= req.OPB;
		vif.driver_cb.CIN	<= req.CIN;
	endtask : drive_to_dut

	virtual task run_phase(uvm_phase phase);
	forever begin
		//get
		seq_item_port.get_next_item(req);
		drive_task();
		seq_item_port.item_done();

	end //forever
	endtask

	task drive_task();
		repeat(1)@(vif.driver_cb);
		if(both_op() && (req.INP_VALID==2'b01 || req.INP_VALID==2'b10)) begin // 01-10
			drive_to_dut();
			`uvm_info("DRV_1 : ", $sformatf("RESET = %b | CE = %b| MODE = %b| CMD = %0d| INP_VALID = %0d| OPA = %0d| OPB = %0d| CIN = %b", vif.RESET, req.CE, req.MODE, req.CMD, req.INP_VALID, req.OPA, req.OPB, req.CIN), UVM_LOW);
			
			for(int i = 1; i < 16; i++) begin
				repeat(1)@(vif.driver_cb);
				
				req.CE.rand_mode(0);
				req.CMD.rand_mode(0);
				req.MODE.rand_mode(0);
				void'(req.randomize());
				if(req.INP_VALID!=2'b11) begin // not 11
					`uvm_info("DRV_10_10 : ", $sformatf("RESET = %b | CE = %0d| MODE = %b| CMD = %0d| INP_VALID = %0d| OPA = %0d| OPB = %0d| CIN = %b",vif.RESET, req.CE, req.MODE, req.CMD, req.INP_VALID, req.OPA, req.OPB, req.CIN), UVM_LOW);
					continue;
				end // not 11

				else begin  // got 11
					drive_to_dut();
					drv_port.write(req);
					`uvm_info("DRV_11 : ", $sformatf("RESET = %b | CE = %0d| MODE = %b| CMD = %0d| INP_VALID = %0d| OPA = %0d| OPB = %0d| CIN = %b", vif.RESET, req.CE, req.MODE, req.CMD, req.INP_VALID, req.OPA, req.OPB, req.CIN), UVM_LOW);
					req.CE.rand_mode(1);
					req.CMD.rand_mode(1);
					req.MODE.rand_mode(1);

					if(req.MODE==1 && (req.CMD inside {9,10})) begin
						$display("\t HIT BREAK drv : mul");
						repeat(4)@(vif.driver_cb); 
					end
					else begin
						$display("\t HIT BREAK drv : other");
						repeat(3)@(vif.driver_cb); 
					end

					break;
				end //got 11

			end // end for loop

		end //01-10

		else begin // 
			drive_to_dut();
			`uvm_info("DRV : ", $sformatf("RESET = %b | CE = %b| MODE = %b| CMD = %0d| INP_VALID = %0d| OPA = %0d| OPB = %0d| CIN = %b",vif.RESET, req.CE, req.MODE, req.CMD, req.INP_VALID, req.OPA, req.OPB, req.CIN), UVM_LOW);
			drv_port.write(req);
			//$display("\t\t got 11 out of 16 cycle");
			if(req.MODE==1 && (req.CMD inside {9,10})) begin
				//$display("drv : mul");				
				repeat(4)@(vif.driver_cb); 
				
			end
			else begin
				//$display("drv : other");
				repeat(3)@(vif.driver_cb); 
			end

		end //
	endtask : drive_task

endclass

