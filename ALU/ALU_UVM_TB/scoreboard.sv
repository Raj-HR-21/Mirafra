//scoreboard

class alu_scb extends uvm_scoreboard;

	`uvm_component_utils(alu_scb)
	uvm_analysis_imp#(alu_seq_item, alu_scb) item_collected_port;
	alu_seq_item qu[$];

	logic [`DATA_WIDTH : 0]temp_res;
	logic temp_err, temp_cout, temp_oflow, temp_e, temp_g, temp_l;
	bit result_match, err_match, cout_match, oflow_match, e_match, g_match, l_match;
	int match, mismatch, total_trxn;
	real pass_rate;

	function new(string name = "alu_scb", uvm_component parent = null);
		super.new(name, parent);
		item_collected_port = new("item_collected_port", this);
	endfunction

	function void write(alu_seq_item item);
		qu.push_back(item);
		total_trxn += 1;
		`uvm_info("scoreboard", $sformatf("DATA SENT TO QUEUE"), UVM_LOW)
		`uvm_info("SCB_M: ", $sformatf("CE = %b| MODE = %b| CMD = %0d| INP_VALID = %0d| OPA = %0d| OPB = %0d| CIN = %b", item.CE, item.MODE, item.CMD, item.INP_VALID, item.OPA, item.OPB, item.CIN), UVM_LOW)
		`uvm_info("SCB_M:", $sformatf("ERR = %b| COUT = %b| OFLOW = %b| E = %b| G = %b| L = %b| RES = %0d", item.ERR, item.COUT, item.OFLOW, item.E, item.G, item.L, item.RES), UVM_LOW)

	endfunction //write

	virtual task run_phase(uvm_phase phase);
		//super.run_phase(phase);
		alu_seq_item expt;
		alu_seq_item resp;
		
		forever begin
			wait(qu.size() > 0);
			resp = qu.pop_front();
			$cast(expt, resp.clone());
			
			ref_model(expt);
			`uvm_info("SCB_R: ", $sformatf("CE = %b| MODE = %b| CMD = %0d| INP_VALID = %0d| OPA = %0d| OPB = %0d| CIN = %b", expt.CE, expt.MODE, expt.CMD, expt.INP_VALID, expt.OPA, expt.OPB, expt.CIN), UVM_LOW)
			`uvm_info("SCB_R:", $sformatf("ERR = %b| COUT = %b| OFLOW = %b| E = %b| G = %b| L = %b| RES = %0d", expt.ERR, expt.COUT, expt.OFLOW, expt.E, expt.G, expt.L, expt.RES), UVM_LOW)
				
			compare(resp, expt);
		
		end //forever
		
	endtask // run_phase

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("REPORT", $sformatf("----- REPORT -----"), UVM_LOW)
		`uvm_info("REPORT", $sformatf("TOTAL TRANSACTIONS : %0d", total_trxn), UVM_LOW)
		`uvm_info("REPORT", $sformatf("TOTAL MATCHED : %0d", match), UVM_LOW)
		`uvm_info("REPORT", $sformatf("TOTAL MISMATCH : %0d", mismatch), UVM_LOW)
		pass_rate = (real'(match)/real'(total_trxn))*100;
		`uvm_info("REPORT", $sformatf("PASS RATE : %.4f", pass_rate), UVM_LOW)

	endfunction

	function void ref_model(alu_seq_item expt);
	
		localparam rotate_amt = $clog2(`DATA_WIDTH);
		reg [rotate_amt-1 : 0] OPB_REG;
		bit [5:0]wait_16 = 0;
		

		if(expt.RESET == 1) begin
			expt.RES = 'bz;
			expt.ERR = 'bz;	
			expt.COUT = 'bz;
			expt.OFLOW = 'bz;
			expt.E = 'bz;
			expt.G = 'bz;
			expt.L = 'bz;
		end
		else if(expt.CE == 0) begin
			expt.RES = temp_res;
			expt.ERR = temp_err;
			expt.COUT = temp_cout;
			expt.OFLOW = temp_oflow;
			expt.E = temp_e;
			expt.G = temp_g;
			expt.L = temp_l;
		end
		
		else if(expt.CE == 1 && expt.RESET == 0) begin
			expt.RES = {`DATA_WIDTH{1'bz}};
			expt.ERR = 'bz;	
			expt.COUT = 'bz;
			expt.OFLOW = 'bz;
			expt.E = 'bz;
			expt.G = 'bz;
			expt.L = 'bz;

			if(expt.MODE == 1) begin
				case(expt.CMD)
					0: begin
						expt.RES = expt.OPA + expt.OPB;
						expt.COUT = expt.RES[`DATA_WIDTH];
					end
					1: begin
						expt.RES = expt.OPA - expt.OPB;
						expt.OFLOW = (expt.OPA < expt.OPB);
					end
					2: begin
						expt.RES = expt.OPA + expt.OPB + expt.CIN;
						expt.COUT = expt.RES[`DATA_WIDTH];
					end
					3: begin
						expt.RES = expt.OPA - expt.OPB - expt.CIN;
						expt.OFLOW = (expt.OPA < expt.OPB);
					end
					4: begin
						expt.RES = expt.OPA + 1;
						expt.COUT = expt.RES[`DATA_WIDTH];
					end
					5: begin
						expt.RES = expt.OPA - 1;
						expt.OFLOW = (expt.OPA < 1) ? 1 : 0;
					end
					6: begin
						expt.RES = expt.OPB + 1;
						expt.COUT = expt.RES[`DATA_WIDTH];
					end
					7: begin
						expt.RES = expt.OPB - 1;
						expt.OFLOW = (expt.OPB < 1) ? 1 : 0;
					end
					8: begin
						expt.RES = {`DATA_WIDTH {1'bz}};
						expt.L = (expt.OPA < expt.OPB) ? 1 : 0;
						expt.G = (expt.OPA > expt.OPB) ? 1 : 0;
						expt.E = (expt.OPA == expt.OPB) ? 1 : 0;;
					end
					9: begin
						expt.RES = (expt.OPA+1) * (expt.OPB + 1);
					end
					10: begin
						expt.RES = (expt.OPA << 1) * expt.OPB;
					end
					default: begin
						expt.RES = `DATA_WIDTH'bz;
						expt.ERR = 1;
					end
				endcase
				temp_res = expt.RES;
				temp_err = expt.ERR;
				temp_cout = expt.COUT;
				temp_oflow = expt.OFLOW;
				temp_e = expt.E;
				temp_g = expt.G;
				temp_l = expt.L;
			end //mode = 1
			else begin //mode = 0
				case(expt.CMD)
					1: expt.RES = ~(expt.OPA & expt.OPB);
					2: expt.RES = expt.OPA | expt.OPB;
					0: expt.RES = expt.OPA & expt.OPB;
					3: expt.RES = ~(expt.OPA | expt.OPB);
					4: expt.RES = expt.OPA ^ expt.OPB;
					5: expt.RES = ~(expt.OPA ^ expt.OPB);
					6: expt.RES = ~(expt.OPA);
					7: expt.RES = ~(expt.OPB);
					8: expt.RES = (expt.OPA >> 1);
					9: expt.RES = (expt.OPA << 1);
					10:expt.RES = (expt.OPB >> 1);
					11:expt.RES = (expt.OPB << 1);
					12: begin
						OPB_REG = expt.OPB[rotate_amt-1 : 0];
						expt.RES[`DATA_WIDTH-1 :0] = {1'b0, (expt.OPA << OPB_REG) | (expt.OPA >>(`DATA_WIDTH-OPB_REG))};
						expt.ERR = (|(expt.OPB[`DATA_WIDTH-1 : rotate_amt]));
					end
					13: begin
						OPB_REG = expt.OPB[rotate_amt-1 : 0];
						expt.RES = {1'b0, (expt.OPA >> OPB_REG) | (expt.OPA<<(`DATA_WIDTH-OPB_REG))};
						expt.ERR = (|(expt.OPB[`DATA_WIDTH-1 : rotate_amt]));
					end
					default: begin
						expt.RES = {`DATA_WIDTH{1'bz}};;
						expt.ERR = 1;
					end
				endcase
				temp_res = expt.RES;
				temp_err = expt.ERR;
				temp_cout = expt.COUT;
				temp_oflow = expt.OFLOW;
				temp_e = expt.E;
				temp_g = expt.G;
				temp_l = expt.L;
			end //mode = 0
		end // CE=1, RESET=0
		
		endfunction : ref_model

		
		function void compare(alu_seq_item resp, alu_seq_item expt);

			result_match = (resp.RES === expt.RES);
			err_match	 = (resp.ERR === expt.ERR);
			cout_match	 = (resp.COUT === expt.COUT);
			oflow_match	 = (resp.OFLOW === expt.OFLOW);
			e_match		 = (resp.E === expt.E);
			g_match		 = (resp.G === expt.G);
			l_match		 = (resp.L === expt.L);
					
			if(result_match && err_match && cout_match && oflow_match && e_match && g_match && l_match) begin
		        match++;
			end
			else begin
		        mismatch++;
			end
			$display("MATCH = %0d | MISMATCH = %0d", match, mismatch);
			$display("");
		endfunction : compare

endclass

