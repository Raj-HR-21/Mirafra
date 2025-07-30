////---- Scoreboard ----////

class alu_scb;
int match = 0, mismatch = 0;
//Transaction handle
alu_transaction ref_scb_trxn;
alu_transaction mon_scb_trxn;
//Mailbixes from ref_model and monitor
mailbox #(alu_transaction) mb_mon_scb;
mailbox #(alu_transaction) mb_ref_scb;

function new(	mailbox #(alu_transaction) mb_ref_scb,
		mailbox #(alu_transaction) mb_mon_scb );
	this.mb_mon_scb = mb_mon_scb;
	this.mb_ref_scb = mb_ref_scb;
endfunction

task compare();
        if((ref_scb_trxn.RES === mon_scb_trxn.RES) && (ref_scb_trxn.COUT === mon_scb_trxn.COUT) && (ref_scb_trxn.ERR === mon_scb_trxn.ERR) && (ref_scb_trxn.OFLOW === mon_scb_trxn.OFLOW) && (ref_scb_trxn.E === mon_scb_trxn.E) && (ref_scb_trxn.G === mon_scb_trxn.G) && (ref_scb_trxn.L === mon_scb_trxn.L) )
		begin match++; end
	else begin 
		mismatch++;
		end

endtask

task start();
for(int i = 0; i < `num_of_trx; i++) begin

	ref_scb_trxn = new;
	mon_scb_trxn = new;

	fork
	begin //get from monitor
		
		mb_mon_scb.get(mon_scb_trxn);
		$display("%5t | SCB_MON  :ERR = %b| COUT = %b| OFLOW = %b| E = %b| G = %b| L = %b| RES = %0d",$time, mon_scb_trxn.ERR, mon_scb_trxn.COUT, mon_scb_trxn.OFLOW, mon_scb_trxn.E, mon_scb_trxn.G, mon_scb_trxn.L, mon_scb_trxn.RES);
	end
	begin //get from ref model
		mb_ref_scb.get(ref_scb_trxn);
		$display("%5t | SCB_REF  :ERR = %b| COUT = %b| OFLOW = %b| E = %b| G = %b| L = %b| RES = %0d",$time, ref_scb_trxn.ERR, ref_scb_trxn.COUT, ref_scb_trxn.OFLOW, ref_scb_trxn.E, ref_scb_trxn.G, ref_scb_trxn.L, ref_scb_trxn.RES);
	end
	join
	compare(); //compare function call
end
$display("MATCHED : %0d", match); 
$display("MISMATCHED : %0d", mismatch);
endtask

endclass

