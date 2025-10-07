////// Write
class wr_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(wr_sequence)

	function new(string name = "wr_sequence");
		super.new(name);
	endfunction: new

	task body();
		repeat(`no_of_trxn) begin
			req = seq_item::type_id::create("req");
			wait_for_grant();
			assert(req.randomize() with { req.winc == 1; req.rinc == 0; });
			send_request(req);
			wait_for_item_done();
		end
		`uvm_do_with(req, {winc == 1;})

	endtask: body

endclass: wr_sequence

class wr_sequence1 extends wr_sequence;
	`uvm_object_utils(wr_sequence1)

	function new(string name = "wr_sequence1");
		super.new(name);
	endfunction: new

	task body();
		repeat(5) begin
			repeat(4) begin
				`uvm_do_with(req, {winc == 0;rinc == 0; })
			end
			repeat(3) begin
				`uvm_do_with(req, {winc == 1; rinc == 0; })
			end
		end
	endtask: body
endclass: wr_sequence1



/////Read
class rd_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(rd_sequence)

	function new(string name = "rd_sequence");
		super.new(name);
	endfunction: new

	task body();
		repeat(`no_of_trxn+5) begin
			req = seq_item::type_id::create("req");
			wait_for_grant();
			assert(req.randomize() with { req.rinc == 1; req.winc == 0; });
			send_request(req);
			wait_for_item_done();
		end
		`uvm_do_with(req, {rinc == 0;})
	endtask: body
endclass: rd_sequence

class rd_sequence1 extends rd_sequence;
	`uvm_object_utils(rd_sequence1)

	function new(string name = "rd_sequence1");
		super.new(name);
	endfunction: new

	task body();
		repeat(5) begin
			repeat(2) begin
				`uvm_do_with(req, {rinc == 0; winc == 0; })
			end
			repeat(3) begin
				`uvm_do_with(req, {rinc == 1; winc == 0; })
			end
		end
	endtask: body
endclass: rd_sequence1

//////////////////////////////////////////////
class virtual_sequence extends uvm_sequence;
	`uvm_object_utils(virtual_sequence)
	// sequence handles
	wr_sequence wr_seq;
	rd_sequence rd_seq;
	
	wr_sequence1 wr_seq1;
	rd_sequence1 rd_seq1;
	
	// sequencer handles
	wr_sequencer wr_sqr;
	rd_sequencer rd_sqr;

	`uvm_declare_p_sequencer(virtual_sequencer)

	task body();
		wr_seq = wr_sequence::type_id::create("wr_seq");
		rd_seq = rd_sequence::type_id::create("rd_seq");

		wr_seq1 = wr_sequence1::type_id::create("wr_seq1");
		rd_seq1 = rd_sequence1::type_id::create("rd_seq1");
		fork
		begin
			
			fork
				wr_seq.start(p_sequencer.wr_sqr);
				rd_seq.start(p_sequencer.rd_sqr);
			join

			fork
				wr_seq1.start(p_sequencer.wr_sqr);
				rd_seq1.start(p_sequencer.rd_sqr);
			join

		end
		join

	endtask: body

	function new(string name = "rd_sequence");
		super.new(name);
	endfunction: new

endclass: virtual_sequence
