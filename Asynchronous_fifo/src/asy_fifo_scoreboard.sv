`uvm_analysis_imp_decl(_wr_scb)
`uvm_analysis_imp_decl(_rd_scb)

class asy_fifo_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(asy_fifo_scoreboard);

	uvm_analysis_imp_wr_scb#(seq_item, asy_fifo_scoreboard) scb_wr_item;
	uvm_analysis_imp_rd_scb#(seq_item, asy_fifo_scoreboard) scb_rd_item;

	seq_item write_item;
	seq_item read_item;
	seq_item wr_q[$];
	seq_item rd_q[$];
	bit [`DSIZE-1 :0] data_q[$];
	bit [`DSIZE-1 :0] exp;
	int match, mismatch;

	function new(string name = "asy_fifo_scoreboard", uvm_component parent = null);
		super.new(name, parent);
		scb_wr_item = new("scb_wr_item", this);
		scb_rd_item = new("scb_rd_item", this);
		write_item = new();
		read_item = new();
	endfunction: new

	function void write_wr_scb(seq_item wr);
		wr_q.push_back(wr);
		`uvm_info("----SCB_WRITE_ITEM----", $sformatf(" wdata=%0d | wfull = %b | wreset = %b | winc = %b",wr.wdata, wr.wfull, wr.wrst_n, wr.winc), UVM_NONE)
			//$display("");
	endfunction: write_wr_scb

	function void write_rd_scb(seq_item rd);
		rd_q.push_back(rd);
		`uvm_info("----SCB_READ_ITEM----", $sformatf(" rdata=%0d | rempty = %b | rreset = %b | rinc = %b",rd.rdata, rd.rempty, rd.rrst_n, rd.rinc), UVM_NONE)
			//$display("");
		
	endfunction: write_rd_scb
	
	task write_scb_task;
		wait(wr_q.size() > 0);
		write_item = wr_q.pop_front();
		`uvm_info("----SCB_WRITE_POP----", $sformatf("wdata = %0d | wfull = %b | wrst_n = %b | winc = %b", write_item.wdata, write_item.wfull, write_item.wrst_n, write_item.winc), UVM_NONE)
			$display("");
/*
		if(!write_item.wrst_n) begin
			data_q.delete();
			`uvm_info("SCB_WRITE_RESET", "Write reset - data_q cleared", UVM_LOW)
		end
*/
		if(write_item.winc && !write_item.wfull) begin
			data_q.push_back(write_item.wdata);
			`uvm_info("SCB_WRITE", $sformatf("wdata = %0d | wfull = %b | wrst_n = %b | winc = %b", write_item.wdata, write_item.wfull, write_item.wrst_n,write_item.winc) ,UVM_LOW)	
		end
		else if(write_item.winc && write_item.wfull) begin
			`uvm_info("SCB_FIFO_FULL", $sformatf("FFIO is full"), UVM_LOW)
			$display("");
		end
		
	endtask: write_scb_task
	
	task read_scb_task;
		wait(rd_q.size() > 0);
		read_item = rd_q.pop_front();
		`uvm_info("----SCB_READ_POP----", $sformatf("rdata = %0d | rempty = %b | rrst_n = %b | rinc = %b", read_item.rdata, read_item.rempty, read_item.rrst_n, read_item.rinc), UVM_NONE)
		$display("");
/*
		if (!read_item.rrst_n) begin
			`uvm_info("SCB_READ_RESET", "Read reset detected", UVM_LOW)
        	end
*/
		if(read_item.rinc && !read_item.rempty) begin
			if (data_q.size() != 0) begin
				exp = data_q.pop_front();
				
				if(exp != read_item.rdata) begin
					mismatch++;
					`uvm_info("---MISMATCH---", $sformatf(" EXP_DATA = %0d | ACT_DATA = %0d", exp, read_item.rdata), UVM_NONE)
				end
				else begin
					match++;
					`uvm_info("---MATCH---", $sformatf(" EXP_DATA = %0d | ACT_DATA = %0d", exp, read_item.rdata), UVM_NONE)
				end
			end
		end

	endtask: read_scb_task
	
	task run_phase(uvm_phase phase);
		forever begin
			write_scb_task();
			read_scb_task();
		end
	endtask: run_phase
	
	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("REPORT", $sformatf("----- REPORT -----"), UVM_NONE)
		`uvm_info("REPORT", $sformatf("Total Transaction : %0d", match+mismatch ), UVM_NONE)
		`uvm_info("REPORT", $sformatf("Matched : %0d | Mismatch : %0d", match, mismatch ), UVM_NONE)
		
	endfunction: report_phase

endclass: asy_fifo_scoreboard
