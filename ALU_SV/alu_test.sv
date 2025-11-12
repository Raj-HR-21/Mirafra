////---- TEST ----////

class alu_test;

//Virtual interfaces of drv, mon, ref
virtual alu_interface drv_vif;
virtual alu_interface mon_vif;
virtual alu_interface ref_vif;

//Declare environment handle
alu_env env;

//function new constructor for  
function new(	virtual alu_interface drv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
this.drv_vif = drv_vif;
this.mon_vif = mon_vif;
this.ref_vif = ref_vif;
endfunction

//Tasks to build environment and call start methods
task run();
	env = new(drv_vif, mon_vif, ref_vif);
	env.build;
	env.start;
endtask

endclass

class test0 extends alu_test;
alu_transaction_0 trxn;
function new(	virtual alu_interface drv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
	super.new( drv_vif, mon_vif,ref_vif);
endfunction
task run();
	env = new(drv_vif, mon_vif, ref_vif);
	env.build;
	begin
		trxn = new();
		env.gen.blueprint = trxn;
	end
	env.start;
endtask
endclass

class test1 extends alu_test;
alu_transaction_1 trxn;
function new(	virtual alu_interface drv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
	super.new( drv_vif, mon_vif,ref_vif);
endfunction
task run();
	env = new(drv_vif, mon_vif, ref_vif);
	env.build;
	begin
		trxn = new();
		env.gen.blueprint = trxn;
	end
	env.start;
endtask
endclass
class test2 extends alu_test;
alu_transaction_2 trxn;
function new(	virtual alu_interface drv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
	super.new( drv_vif, mon_vif,ref_vif);
endfunction
task run();
	env = new(drv_vif, mon_vif, ref_vif);
	env.build;
	begin
		trxn = new();
		env.gen.blueprint = trxn;
	end
	env.start;
endtask
endclass

class test3 extends alu_test;
alu_transaction_3 trxn;
function new(	virtual alu_interface drv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
	super.new( drv_vif, mon_vif,ref_vif);
endfunction
task run();
	env = new(drv_vif, mon_vif, ref_vif);
	env.build;
	begin
		trxn = new();
		env.gen.blueprint = trxn;
	end
	env.start;
endtask
endclass

class test_regression extends alu_test;
alu_transaction_0 trxn0;
alu_transaction_1 trxn1;
alu_transaction_2 trxn2;
alu_transaction_3 trxn3;
function new(	virtual alu_interface drv_vif,
		virtual alu_interface mon_vif,
		virtual alu_interface ref_vif);
	super.new( drv_vif, mon_vif,ref_vif);
endfunction
task run();
	env = new(drv_vif, mon_vif, ref_vif);
	env.build;
	begin
		trxn0 = new();
		env.gen.blueprint = trxn0;
	end
	env.start;
	begin
		trxn1 = new();
		env.gen.blueprint = trxn1;
	end
	env.start;
	begin
		trxn2 = new();
		env.gen.blueprint = trxn2;
	end
	env.start;
	begin
		trxn3 = new();
		env.gen.blueprint = trxn3;
	end
	env.start;
endtask

endclass
