// Base Write Sequence
class wr_sequence extends uvm_sequence#(seq_item);
    `uvm_object_utils(wr_sequence)
    
    function new(string name = "wr_sequence");
        super.new(name);
    endfunction: new
    
    task body();
        repeat(`no_of_trxn) begin
            req = seq_item::type_id::create("req");
            wait_for_grant();
            assert(req.randomize());
            send_request(req);
            wait_for_item_done();
        end
    endtask: body
endclass: wr_sequence

// Base Read Sequence
class rd_sequence extends uvm_sequence#(seq_item);
    `uvm_object_utils(rd_sequence)
    
    function new(string name = "rd_sequence");
        super.new(name);
    endfunction: new
    
    task body();
        repeat(`no_of_trxn) begin
            req = seq_item::type_id::create("req");
            wait_for_grant();
            assert(req.randomize());
            send_request(req);
            wait_for_item_done();
        end
    endtask: body
endclass: rd_sequence

// Write Continuous Sequence 
class wr_continuous_seq extends wr_sequence;
    `uvm_object_utils(wr_continuous_seq)
    
    function new(string name = "wr_continuous_seq");
        super.new(name);
    endfunction
    
    task body();
        repeat(20) begin
            req = seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { winc == 1;});
            finish_item(req);
        end
        `uvm_info(get_type_name(), "Continuous Write Completed", UVM_MEDIUM)
    endtask
endclass: wr_continuous_seq

// Write Random Enable Sequence
class wr_random_enable_seq extends wr_sequence;
    `uvm_object_utils(wr_random_enable_seq)
    
    function new(string name = "wr_random_enable_seq");
        super.new(name);
    endfunction
    
    task body();
        repeat(`no_of_trxn) begin
            req = seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { winc dist {1 := 70, 0 := 30}; });
            finish_item(req);
        end
        `uvm_info(get_type_name(), "Random Write Enable Completed", UVM_MEDIUM)
    endtask
endclass

// Read Continuous Sequence 
class rd_continuous_seq extends rd_sequence;
    `uvm_object_utils(rd_continuous_seq)
    
    function new(string name = "rd_continuous_seq");
        super.new(name);
    endfunction
    
    task body();
        repeat(20) begin
            req = seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { rinc == 1; });
            finish_item(req);
        end
        `uvm_info(get_type_name(), "Continuous Read Completed", UVM_MEDIUM)
    endtask
endclass

// Read Random Enable Sequence
class rd_random_enable_seq extends rd_sequence;
    `uvm_object_utils(rd_random_enable_seq)
    
    function new(string name = "rd_random_enable_seq");
        super.new(name);
    endfunction
    
    task body();
        repeat(`no_of_trxn) begin
            req = seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { rinc dist {1 := 70, 0 := 30}; });
            finish_item(req);
        end
        `uvm_info(get_type_name(), "Random Read Enable Completed", UVM_MEDIUM)
    endtask
endclass

/////////////////////////////////////////////
/////////////////////////////////////////////
class rinc_0 extends rd_sequence;
    `uvm_object_utils(rinc_0)
    
    function new(string name = "rinc_0");
        super.new(name);
    endfunction
    
    task body();
        repeat(20) begin
            req = seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { rinc == 0;});
            finish_item(req);
        end
        `uvm_info(get_type_name(), "Continuous Write Completed", UVM_MEDIUM)
    endtask
endclass: rinc_0
class winc_0 extends wr_sequence;
    `uvm_object_utils(winc_0)
    
    function new(string name = "winc_0");
        super.new(name);
    endfunction
    
    task body();
        repeat(20) begin
            req = seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { winc == 0;});
            finish_item(req);
        end
        `uvm_info(get_type_name(), "Continuous Write Completed", UVM_MEDIUM)
    endtask
endclass: winc_0



//////////////////////////////////////////////
class virtual_sequence extends uvm_sequence;
	`uvm_object_utils(virtual_sequence)
	// sequence handles
	wr_sequence wr_seq;		//base write
	rd_sequence rd_seq;		//base read

	wr_continuous_seq 	wr_seq1;	//continuous write
	rd_continuous_seq 	rd_seq1;	//continuous read
	wr_random_enable_seq 	wr_seq2;	//random write
	rd_random_enable_seq 	rd_seq2;	//random read

	rinc_0 rh;
	winc_0 wh;
	// sequencer handles
	wr_sequencer wr_sqr;
	rd_sequencer rd_sqr;

	`uvm_declare_p_sequencer(virtual_sequencer)

	task body();
		wr_seq = wr_sequence::type_id::create("wr_seq");
		rd_seq = rd_sequence::type_id::create("rd_seq");

		wr_seq1 = wr_continuous_seq::type_id::create("wr_seq1");
		rd_seq1 = rd_continuous_seq::type_id::create("rd_seq1");

		wr_seq2 = wr_random_enable_seq::type_id::create("wr_seq2");
		rd_seq2 = rd_random_enable_seq::type_id::create("rd_seq2");

		wh = winc_0::type_id::create("wh");
		rh = rinc_0::type_id::create("rh");


		fork
		begin

			fork	//continuous write and read
				wr_seq1.start(p_sequencer.wr_sqr);
				rd_seq1.start(p_sequencer.rd_sqr);
			join

/*			fork	//random write and read enable
				wr_seq2.start(p_sequencer.wr_sqr);
				rd_seq2.start(p_sequencer.rd_sqr);
			join

			fork	//continuous write random read enable
				wr_seq1.start(p_sequencer.wr_sqr);
				rd_seq2.start(p_sequencer.rd_sqr);
			join

			fork	//continuous write only
				wr_seq1.start(p_sequencer.wr_sqr);
				rh.start(p_sequencer.rd_sqr);
			join

			fork	//write and read
				wr_seq.start(p_sequencer.wr_sqr);
				rd_seq.start(p_sequencer.rd_sqr);
			join

*/
		end
		join

	endtask: body

	function new(string name = "virtual_sequence");
		super.new(name);
	endfunction: new

endclass: virtual_sequence

