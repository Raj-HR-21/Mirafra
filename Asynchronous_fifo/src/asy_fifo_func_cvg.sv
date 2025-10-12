`uvm_analysis_imp_decl(_write_item)
`uvm_analysis_imp_decl(_read_item)

class asy_fifo_func_cvg extends uvm_component;
	`uvm_component_utils(asy_fifo_func_cvg)
	uvm_analysis_imp_write_item#(seq_item, asy_fifo_func_cvg) cov_wr_item;
	uvm_analysis_imp_read_item#(seq_item, asy_fifo_func_cvg)  cov_rd_item;

	seq_item wr_seq;
	seq_item rd_seq;
	real wr_cov, rd_cov;

	covergroup write_cvg;
		wr_reset : coverpoint wr_seq.wrst_n{bins wrst[] = {0,1};}
		wr_data  : coverpoint wr_seq.wdata {bins dataw[5]  = {[0:2**`DSIZE-1]};}
		wr_full  : coverpoint wr_seq.wfull {bins full[] = {0,1};}
		wr_winc  : coverpoint wr_seq.winc {bins incw[]  = {0,1};}
		wr_winc1 : coverpoint wr_seq.winc {bins winc1  = {0,1};}
		c1: cross wr_winc1, wr_full;
	endgroup: write_cvg

	covergroup read_cvg;
		rd_reset : coverpoint rd_seq.rrst_n{bins rrst[] = {0,1};}
		rd_data  : coverpoint rd_seq.rdata {bins datar[5]  = {[0:2**`DSIZE-1]};}
		rd_empty : coverpoint rd_seq.rempty{bins empty[]  = {0,1};}
		rd_rinc  : coverpoint rd_seq.rinc  {bins incr[]  = {0,1};}
		rd_rinc1 : coverpoint rd_seq.rinc  {bins rinc1  = {0,1};}
		c2: cross rd_rinc1, rd_empty;
	endgroup: read_cvg

	function new(string name = "asy_fifo_func_cvg", uvm_component parent = null);
		super.new(name, parent);
		cov_wr_item = new("cov_wr_item", this);
		cov_rd_item = new("cov_rd_item", this);
		write_cvg = new();
		read_cvg  = new();
	endfunction: new

	function void write_write_item(seq_item wr);
		wr_seq = wr;
		write_cvg.sample();
	endfunction: write_write_item

	function void write_read_item(seq_item rd);
		rd_seq = rd;
		read_cvg.sample();
	endfunction: write_read_item

	function void extract_phase(uvm_phase phase);
		wr_cov = write_cvg.get_coverage();
		rd_cov = read_cvg.get_coverage();
	endfunction: extract_phase

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("COV", $sformatf("WR_CVG = %.4f", wr_cov), UVM_NONE )
		`uvm_info("COV", $sformatf("RD_CVG = %.4f", rd_cov), UVM_NONE)
	endfunction: report_phase

endclass: asy_fifo_func_cvg
