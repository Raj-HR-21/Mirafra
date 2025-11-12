`include "define_file.sv"
interface alu_if (input logic CLK, RESET);
//INPUTS
logic 						CE;
logic						CIN;
logic						MODE;
logic [1:0] 				INP_VALID;
logic [`DATA_WIDTH-1 : 0]	OPA, OPB;
logic [`CMD_WIDTH-1 : 0] 	CMD;
//OUTPUTS
logic [2*`DATA_WIDTH-1:0]	RES;
logic 						ERR;
logic						COUT;
logic						OFLOW;
logic						E;
logic						G;
logic						L;

clocking driver_cb @(posedge CLK or posedge RESET);
default input #2 output 2;
output CE, CIN, MODE, INP_VALID, OPA, OPB, CMD;
input RES, ERR, OFLOW, COUT, E, G, L;
endclocking

clocking monitor_cb @(posedge CLK or posedge RESET);
default input #2 output 2;
input RES, ERR, OFLOW, COUT, E, G, L, CMD, MODE, INP_VALID;
endclocking

clocking ref_cb @(posedge CLK or posedge RESET);
default input #2 output 2;
input CE, CIN, MODE, INP_VALID, OPA, OPB, CMD;
output RES, ERR, OFLOW, COUT, E, G, L;
endclocking

modport DRIVER (clocking driver_cb);
modport MONITOR (clocking monitor_cb);
modport REF_MODEL (clocking ref_cb);

endinterface
