////---- ENVIRONMENT ----////

class alu_env;

//Virtual interfaces of drv, mon, ref
virtual alu_interface drv_vif;
virtual alu_interface mon_vif;
virtual alu_interface ref_vif;

//Create mailboxex
//Generator to Driver
mailbox #(alu_transaction) mb_gen_drv;
//Driver to Ref_Model
mailbox #(alu_transaction) mb_drv_ref;
//Ref_Model to Scoreboard
mailbox #(alu_transaction) mb_ref_scb;
//Monitor to Scoreboard
mailbox #(alu_transaction) mb_mon_scb;

//Declare handles for gen, drv, ref, scb
alu_generator	gen;
alu_driver	drv;
alu_monitor	mon;
alu_ref_model	ref_mdl;
alu_scb		scb;

//Constructor to copy virtual interfaces
function new(   virtual alu_interface drv_vif,
                virtual alu_interface mon_vif,
                virtual alu_interface ref_vif);
	this.drv_vif = drv_vif;
	this.mon_vif = mon_vif;
	this.ref_vif = ref_vif;
endfunction

//Task to create objects for mailboxes
task build();
begin
	mb_gen_drv = new();
	mb_drv_ref = new();
	mb_ref_scb = new();
	mb_mon_scb = new();

	//Pass mailboxes to gen, drv, ref, scb
	gen 	= new(mb_gen_drv);
	drv 	= new(mb_gen_drv, mb_drv_ref, drv_vif);
	mon 	= new(mb_mon_scb, mon_vif);
	ref_mdl = new(mb_drv_ref, mb_ref_scb, ref_vif);
	scb	= new(mb_ref_scb, mb_mon_scb);
end
endtask

//Task to call all the start methods
//All starts together
task start();
fork
	gen.start();
	drv.start();
	mon.start();
	ref_mdl.start();
	scb.start();
	//task to compare report in scb
	scb.compare();
join

endtask


endclass
