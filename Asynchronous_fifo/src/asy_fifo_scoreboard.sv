`uvm_analysis_imp_decl(_wr_scb)
`uvm_analysis_imp_decl(_rd_scb)

class asy_fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(asy_fifo_scoreboard)
    
    uvm_analysis_imp_wr_scb#(seq_item, asy_fifo_scoreboard) scb_wr_item;
    uvm_analysis_imp_rd_scb#(seq_item, asy_fifo_scoreboard) scb_rd_item;
    
    bit [`DSIZE-1:0] data_queue[$];
    
    int match = 0;
    int mismatch = 0;
    int total_writes = 0;
    int total_reads = 0;
    int full_pass = 0;
    int full_fail = 0;
    int empty_pass = 0;
    int empty_fail = 0;
    
    parameter FIFO_DEPTH = 1 << `ASIZE;
    
    function new(string name = "asy_fifo_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scb_wr_item = new("scb_wr_item", this);
        scb_rd_item = new("scb_rd_item", this);
    endfunction: build_phase
    
    //		Write
    function void write_wr_scb(seq_item wr);
        bit expected_full;
        
        expected_full = (data_queue.size() == FIFO_DEPTH);
        
        if (wr.wfull === expected_full) begin
            full_pass++;
            `uvm_info(get_type_name(), $sformatf("FULL FLAG PASS: wfull=%b, Queue size=%0d", 
                      wr.wfull, data_queue.size()), UVM_MEDIUM)
        end
        else begin
            full_fail++;
            `uvm_error(get_type_name(), $sformatf("FULL FLAG FAIL: Expected wfull=%b, Got wfull=%b, Queue size=%0d", 
                       expected_full, wr.wfull, data_queue.size()))
        end
        
        if (wr.winc && !wr.wfull) begin
            data_queue.push_back(wr.wdata);
            total_writes++;
            `uvm_info(get_type_name(), $sformatf("PUSH: wdata=%0d, Queue size=%0d", 
                      wr.wdata, data_queue.size()), UVM_MEDIUM)
            $display("");
        end
        else if (wr.winc && wr.wfull) begin
            `uvm_info(get_type_name(), $sformatf("WRITE BLOCKED: wfull=1, Queue size=%0d", 
                      data_queue.size()), UVM_MEDIUM)
            $display("");
        end
    endfunction: write_wr_scb
    
    //		Read 
    function void write_rd_scb(seq_item rd);
        bit [`DSIZE-1:0] expected_data;
        bit expected_empty;
        
        expected_empty = (data_queue.size() == 0);
        
        if (rd.rempty === expected_empty) begin
            empty_pass++;
            `uvm_info(get_type_name(), $sformatf("EMPTY FLAG PASS: rempty=%b, Queue size=%0d", 
                      rd.rempty, data_queue.size()), UVM_MEDIUM)
        end
        else begin
            empty_fail++;
            `uvm_error(get_type_name(), $sformatf("EMPTY FLAG FAIL: Expected rempty=%b, Got rempty=%b, Queue size=%0d", 
                       expected_empty, rd.rempty, data_queue.size()))
        end
        
        if (rd.rinc && !rd.rempty) begin
            total_reads++;
            
            if (data_queue.size() == 0) begin
                mismatch++;
                `uvm_error(get_type_name(), $sformatf("POP ERROR: Queue empty but read data=%0d", rd.rdata))
                $display("");
                return;
            end
            
            expected_data = data_queue.pop_front();
            
            if (rd.rdata === expected_data) begin
                match++;
                `uvm_info(get_type_name(), $sformatf("DATA MATCH: Expected=%0d, Got=%0d, Queue size=%0d", 
                          expected_data, rd.rdata, data_queue.size()), UVM_MEDIUM)
                $display("");
            end
            else begin
                mismatch++;
                `uvm_error(get_type_name(), $sformatf("DATA MISMATCH: Expected=%0d, Got=%0d", 
                           expected_data, rd.rdata))
                $display("");
            end
        end
        else if (rd.rinc && rd.rempty) begin
            `uvm_info(get_type_name(), $sformatf("READ BLOCKED: rempty=1, Queue size=%0d", 
                      data_queue.size()), UVM_MEDIUM)
            $display("");
        end
    endfunction: write_rd_scb
    
    //---------- Report Phase ----------//
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);


        `uvm_info(get_type_name(), "      SCOREBOARD REPORT", UVM_NONE)
        `uvm_info(get_type_name(), "========================================", UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("Total Writes          : %0d", total_writes), UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("Total Reads           : %0d", total_reads), UVM_NONE)
        `uvm_info(get_type_name(), "----------------------------------------", UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("Data Matches          : %0d", match), UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("Data Mismatches       : %0d", mismatch), UVM_NONE)
        `uvm_info(get_type_name(), "----------------------------------------", UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("Full Condition Pass   : %0d", full_pass), UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("Full Condition Fail   : %0d", full_fail), UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("Empty Condition Pass  : %0d", empty_pass), UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("Empty Condition Fail  : %0d", empty_fail), UVM_NONE)
        `uvm_info(get_type_name(), "----------------------------------------", UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("Queue Remaining       : %0d", data_queue.size()), UVM_NONE)
        

    endfunction: report_phase
    
endclass
