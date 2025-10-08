
`uvm_analysis_imp_decl(_wr_scb)
`uvm_analysis_imp_decl(_rd_scb)

class asy_fifo_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(asy_fifo_scoreboard);

	uvm_analysis_imp_wr_scb#(seq_item, asy_fifo_scoreboard) scb_wr_item;
	uvm_analysis_imp_rd_scb#(seq_item, asy_fifo_scoreboard) scb_rd_item;

	int match, mismatch;
	seq_item exp;
	seq_item data_q[$];
//	int max_depth = 1<<`ASIZE;
//	int depth;

	function new(string name = "asy_fifo_scoreboard", uvm_component parent = null);
		super.new(name, parent);
		scb_wr_item = new("scb_wr_item", this);
		scb_rd_item = new("scb_rd_item", this);
		exp = seq_item::type_id::create("exp");
	endfunction: new

	function void write_wr_scb(seq_item wr);
		if(wr.winc && !wr.wfull) begin
			data_q.push_back(wr);
			//depth = data_q.size();
			`uvm_info("----SCB_WRITE_IN----", $sformatf(" wdata=%0d | full = %b | wreset = %b | ",wr.wdata, wr.wfull, wr.wrst_n), UVM_NONE)
			$display("");
		end
		if(wr.winc && wr.wfull) begin
			`uvm_info(get_type_name(), $sformatf("FIFO full wfull = %b | ", wr.wfull), UVM_NONE)
			//$display("%p", data_q);
			$display("");
		end
	endfunction: write_wr_scb

	function void write_rd_scb(seq_item rd);
		if(rd.rinc && !rd.rempty) begin
			if(data_q.size() != 0) begin
				exp = data_q.pop_front();
				//$display("----- INSIDE IF -------exp.rdata=%0d", exp.rdata);
				if(exp.wdata != rd.rdata) begin
					mismatch++;
					`uvm_info("---MISMATCH---", $sformatf(" EXP_DATA = %0d | ACT_DATA = %0d", exp.wdata, rd.rdata), UVM_NONE)
					$display("");
				end
				else begin
					match++;
					`uvm_info("---MATCH---", $sformatf(" EXP_DATA = %0d | ACT_DATA = %0d", exp.wdata, rd.rdata), UVM_NONE)
					$display("");
				end
			end
		end
	endfunction: write_rd_scb

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("REPORT", $sformatf("----- REPORT -----"), UVM_NONE)
		`uvm_info("REPORT", $sformatf("Total Transaction : %0d", match+mismatch ), UVM_NONE)
		`uvm_info("REPORT", $sformatf("Matched : %0d | Mismatch : %0d", match, mismatch ), UVM_NONE)
		
	endfunction: report_phase

endclass: asy_fifo_scoreboard
