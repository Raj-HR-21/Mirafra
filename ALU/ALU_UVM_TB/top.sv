//top
`define DATA_WIDTH 8
`define CMD_WIDTH 4
`define no_trxn 20

`include "uvm_pkg.sv"
`include "uvm_macros.svh"

`include "design.v"
`include "interface.sv"
`include "pkg.sv"

module top;

	import uvm_pkg::*;
	import alu_pkg::*;

	bit CLK, RESET;
	parameter DW = 8;
	parameter CW = 4;

	alu_interface intrf(CLK, RESET);
	ALU_DESIGN #(DW,CW) dut(.CLK(intrf.CLK), 
				.CE(intrf.CE), 
				.RST(intrf.RESET), 
				.INP_VALID(intrf.INP_VALID), 
				.MODE(intrf.MODE), 
				.CMD(intrf.CMD), 
				.OPA(intrf.OPA), 
				.OPB(intrf.OPB), 
				.CIN(intrf.CIN), 
				.RES(intrf.RES), 
				.ERR(intrf.ERR), 
				.OFLOW(intrf.OFLOW), 
				.COUT(intrf.COUT), 
				.E(intrf.E), 
				.G(intrf.G), 
				.L(intrf.L));
	//CLOCK
	initial begin
		CLK = 0;
		forever #5 CLK = ~CLK;
	end
	initial begin
	//	RESET = 1;
	//	#30;
		RESET = 0;
	end
        initial begin
		uvm_config_db#(virtual alu_interface)::set(uvm_root::get(), "*" , "vif", intrf);
/*
		run_test("arith_both_op_test");
		run_test("logical_both_op_test");

		run_test("arith_opa_test");
		run_test("arith_opb_test");
		run_test("logical_opa_test");
		run_test("logical_opb_test");

		run_test("multiplication_op_test");
		run_test("rotate_op_test");
		run_test("arith_both_op_min_max_test");
		run_test("arith_opa_min_max_test");
		run_test("arith_opb_min_max_test");
	
		//run_test("arith_op_test");
		//run_test("logical_op_test");
	*/	
		run_test("alu_test");
		//run_test("reg_test");

	end

endmodule
