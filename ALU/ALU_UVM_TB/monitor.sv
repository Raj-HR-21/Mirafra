//monitor

class alu_monitor extends uvm_monitor;
	`uvm_component_utils(alu_monitor)
	virtual alu_interface vif;

	uvm_analysis_port#(alu_seq_item) mon_port;
	alu_seq_item mon_item;
	int trxn;
	function new(string name = "alu_monitor", uvm_component parent = null);
		super.new(name, parent);
		mon_item = new();
		mon_port = new("mon_port", this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//mon_item = alu_seq_item::type_id::create("mon_item", this);
		if(!uvm_config_db#(virtual alu_interface)::get(this, "" , "vif", vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("NO VIF"))
		end
	endfunction

	function bit both_op();
		if(mon_item.MODE == 1)
			return (mon_item.CMD inside {0,1,2,3,8,9,10});
		else 
			return (mon_item.CMD inside {[0:5],12,13});
	endfunction : both_op

	function void capture_in();
		//Inputs
		mon_item.RESET  = vif.monitor_cb.RESET;
		mon_item.CE	= vif.monitor_cb.CE;
		mon_item.CMD	= vif.monitor_cb.CMD;
		mon_item.MODE	= vif.monitor_cb.MODE;
		mon_item.CIN	= vif.monitor_cb.CIN;
		mon_item.OPA	= vif.monitor_cb.OPA;
		mon_item.OPB	= vif.monitor_cb.OPB;
		mon_item.INP_VALID	= vif.monitor_cb.INP_VALID;
		`uvm_info("MON :", $sformatf("RESET = %b | CE = %b| MODE = %b| CMD = %0d| INP_VALID = %0d| OPA = %0d| OPB = %0d| CIN = %b", mon_item.RESET, mon_item.CE, mon_item.MODE, mon_item.CMD, mon_item.INP_VALID, mon_item.OPA, mon_item.OPB, mon_item.CIN), UVM_LOW)
	endfunction
	function void capture_out();
		//Outputs
		mon_item.RES	= vif.monitor_cb.RES;
		mon_item.ERR	= vif.monitor_cb.ERR;
		mon_item.COUT	= vif.monitor_cb.COUT;
		mon_item.OFLOW	= vif.monitor_cb.OFLOW;
		mon_item.E	= vif.monitor_cb.E;
		mon_item.G	= vif.monitor_cb.G;
		mon_item.L	= vif.monitor_cb.L;
		`uvm_info("MON :", $sformatf("ERR = %b| COUT = %b| OFLOW = %b| E = %b| G = %b| L = %b| RES = %0d", mon_item.ERR, mon_item.COUT, mon_item.OFLOW, mon_item.E, mon_item.G, mon_item.L, mon_item.RES), UVM_LOW)

	endfunction
	
	task run_phase(uvm_phase phase);
	forever begin
		repeat(2)@(vif.monitor_cb);
			//capture();
		if(both_op() &&(vif.monitor_cb.INP_VALID==2'b01 || vif.monitor_cb.INP_VALID==2'b10)) begin //both_op -01-10
			if(vif.monitor_cb.MODE==1 &&(vif.monitor_cb.CMD==9 || vif.monitor_cb.CMD==10)) begin
				repeat(2)@(vif.monitor_cb);
	//			$display("MON_MUL");
				capture_in();
				capture_out();
				//$display("\n\n IN WRITE MON 1 \n\n");
				//mon_port.write(mon_item);
			end
			else begin
				repeat(1)@(vif.monitor_cb);
	//			$display("MON others");
				capture_in();
				capture_out();
				//$display("\n\n IN WRITE MON 2 \n\n");
				//mon_port.write(mon_item);
			end
			for(int i=1; i<16; i++) begin 
				repeat(1) @(vif.monitor_cb);
				if(vif.monitor_cb.MODE==1 &&(vif.monitor_cb.CMD==9 || vif.monitor_cb.CMD==10)) begin
					repeat(1) @(vif.monitor_cb);
				end
			
				else repeat(0)@(vif.monitor_cb);

				if(vif.monitor_cb.INP_VALID!=2'b11) begin //not 11
					if(vif.monitor_cb.MODE==1 &&(vif.monitor_cb.CMD==9 || vif.monitor_cb.CMD==10)) begin repeat(2)@(vif.monitor_cb); end
					else begin repeat(1) @(vif.monitor_cb); end
					
					`uvm_info("MON :", $sformatf("INP_VALID is NOT 2'b11"), UVM_LOW)
					continue;
				end // not 11
				else begin // got 11
					if(vif.monitor_cb.MODE==1 &&(vif.monitor_cb.CMD==9 || vif.monitor_cb.CMD==10)) begin
						repeat(2)@(vif.monitor_cb);
			//			$display("MON_MUL");
						capture_in();
						capture_out();
						mon_port.write(mon_item);
					end
					else begin
						repeat(1)@(vif.monitor_cb);
			//			$display("MON others");
						capture_in();
						capture_out();
						mon_port.write(mon_item);
					end
						$display("\t HIT BREAK mon : other");
					repeat(1)@(vif.monitor_cb);
					break;	
				end  // got 11
			end //for
			
		end  //both_op -01-10
		
		else begin //other conditions
			if(vif.monitor_cb.MODE==1 &&(vif.monitor_cb.CMD==9 || vif.monitor_cb.CMD==10)) begin
				repeat(2)@(vif.monitor_cb);
	//			$display("MON_MUL");
				capture_in();
				capture_out();
				mon_port.write(mon_item);
			end
			else begin
				repeat(1)@(vif.monitor_cb);
	//			$display("MON others");
				capture_in();
				capture_out();
				mon_port.write(mon_item);
			end
		end // other conditions

	repeat(1)@(vif.monitor_cb); 
	end //forever
	endtask


endclass

