////---- MONITOR ----////

class alu_monitor;
//Transaction class handle
alu_transaction mon_trxn;

//Mailbox to SCB
mailbox #(alu_transaction)mb_mon_scb;

//Virtual interface
virtual alu_interface.MONITOR vif;

//Functional coverage
covergroup mon_cg;
	result : coverpoint mon_trxn.RES { bins res_r = {[0: (2**(`DATA_WIDTH+1))]};
					   bins res_0 = {0};
					   bins res_m = {{(`DATA_WIDTH+1){1'b1}}};
						}
	error  : coverpoint mon_trxn.ERR { bins err[] = {0,1};}
	cout   : coverpoint mon_trxn.COUT{ bins carry[] = {0,1};}
	equal  : coverpoint mon_trxn.E { bins e[] = {0,1};}
	great  : coverpoint mon_trxn.G { bins g[] = {0,1};}
	less   : coverpoint mon_trxn.L { bins l[] = {0,1};} 
endgroup 

//Constructor to store mailbox handles and virtual interface
function new(	mailbox #(alu_transaction) mb_mon_scb,
		virtual alu_interface.MONITOR vif);

	this.mb_mon_scb = mb_mon_scb;
	this.vif = vif;
	mon_cg = new();
endfunction

//Task that captures data
task start();
	repeat(5)@(vif.monitor_cb);
	mon_trxn = new();
	for(int i = 0; i < `num_of_trx; i++) begin

		if((vif.monitor_cb.CMD == 'b1001 || vif.monitor_cb.CMD == 'b1010 ) && vif.monitor_cb.MODE == 'b1) begin
		repeat(2)@(vif.monitor_cb);  
		mon_trxn.RES  = vif.monitor_cb.RES;
		mon_trxn.ERR  = vif.monitor_cb.ERR;
		mon_trxn.COUT = vif.monitor_cb.COUT;
		mon_trxn.E    = vif.monitor_cb.E;
		mon_trxn.G    = vif.monitor_cb.G;
		mon_trxn.L    = vif.monitor_cb.L;
		end
		else  begin
		repeat(1)@(vif.monitor_cb); 

		mon_trxn.RES  = vif.monitor_cb.RES;
		mon_trxn.ERR  = vif.monitor_cb.ERR;
		mon_trxn.COUT = vif.monitor_cb.COUT;
		mon_trxn.E    = vif.monitor_cb.E;
		mon_trxn.G    = vif.monitor_cb.G;
		mon_trxn.L    = vif.monitor_cb.L;
		end
		//Display
		$display("%5t | MON_DATA: ERR = %b| COUT = %b| OFLOW = %b| E = %b| G = %b| L = %b| RES = %0d",$time, mon_trxn.ERR, mon_trxn.COUT, mon_trxn.OFLOW, mon_trxn.E, mon_trxn.G, mon_trxn.L, mon_trxn.RES); 
		mon_cg.sample();
		//Put to mailbox
		//@(vif.monitor_cb);
		mb_mon_scb.put(mon_trxn);
	if((vif.monitor_cb.CMD == 'b1001 || vif.monitor_cb.CMD == 'b1010 ) && vif.monitor_cb.MODE == 'b1) begin
		repeat(2)@(vif.monitor_cb); end
	else begin
		repeat(3)@(vif.monitor_cb); end

		//@(vif.monitor_cb);
		//@(vif.monitor_cb);
	end
endtask

endclass


