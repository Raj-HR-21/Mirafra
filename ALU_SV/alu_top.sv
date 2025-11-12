////---- TOP ----////
`include "defines.sv"
`include "alu_interface.sv"
`include "alu_pkg.sv"
`include "alu_16_clk.v"

module alu_top;
//Import all the class files from package
import alu_pkg::*;

bit CLK;
bit RESET;
parameter DW = 8;
parameter CW = 4;
//Clock generation
initial begin
CLK = 0;
forever #5 CLK = ~CLK;
end

//Reset (asynchronous active high) 
initial begin
RESET = 1;
#20;	RESET = 0;
#1000;	RESET = 1;
#50;	RESET = 0;
#50;	RESET = 1;
#50;	RESET = 0;
end

//Instantiate interface
alu_interface intrf(CLK, RESET);

//Instance DUV
 ALU_DESIGN #(DW , CW )
		dut(	.CLK(intrf.CLK), 
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

//Instantiate test
alu_test tb; 
test0 tb0;
test1 tb1;
test2 tb2;
test3 tb3;

test_regression tb_reg;
initial begin
	tb = new(intrf.DRIVER, intrf.MONITOR, intrf.REF_MODEL);
	tb0 = new(intrf.DRIVER, intrf.MONITOR, intrf.REF_MODEL);
	tb1 = new(intrf.DRIVER, intrf.MONITOR, intrf.REF_MODEL);
	tb2 = new(intrf.DRIVER, intrf.MONITOR, intrf.REF_MODEL);
	tb3 = new(intrf.DRIVER, intrf.MONITOR, intrf.REF_MODEL);
	tb_reg = new(intrf.DRIVER, intrf.MONITOR, intrf.REF_MODEL);
	tb_reg.run();
	tb0.run();
	tb1.run();
	tb2.run();
	tb3.run();
	tb.run();
	$finish;
end
endmodule
