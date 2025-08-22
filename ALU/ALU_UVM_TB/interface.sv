////---- INTERFACE ----////
interface alu_interface (input logic CLK, input logic RESET);
	//INPUTS
	
	logic CE;
	logic CIN;
	logic MODE;
	logic [1:0] INP_VALID;
	logic [`DATA_WIDTH-1 : 0] OPA, OPB;
	logic [`CMD_WIDTH -1 : 0] CMD;
	//OUTPUTS
	logic [`DATA_WIDTH+1:0] RES;
	logic ERR;
	logic COUT;
	logic OFLOW;
	logic E;
	logic G;
	logic L;

clocking driver_cb @(posedge CLK);
default input #0 output #0;
output CE, CIN, MODE, INP_VALID, OPA, OPB, CMD,RESET;
input RES, ERR, OFLOW, COUT, E, G, L;
endclocking

clocking monitor_cb @(posedge CLK);
default input #0 output #0;
input RES, ERR, OFLOW, COUT, E, G, L;
input CE, CIN, MODE, INP_VALID, OPA, OPB, CMD,RESET;
endclocking

modport DRIVER (clocking driver_cb);
modport MONITOR (clocking monitor_cb, input RESET);

property reset_check;
	@(posedge CLK) disable iff(!RESET)
		RESET|-> ( RES == 'bz && OFLOW == 'bz && COUT == 'bz && ERR == 'bz && G == 'bz && L == 'bz && E == 'bz);
endproperty
reset_check_asrt : assert property(reset_check)
	else $error("INCORRECT RESET");

property arith_invalid_cmd;
	@(posedge CLK) disable iff(!RESET)
		(MODE && (CMD>10)) |=> ERR == 1;
endproperty
arith_invalid_cmd_asrt: assert property(arith_invalid_cmd)
			else $error("ERR not raised");

property logical_invalid_cmd;
	@(posedge CLK) disable iff(!RESET)
		(!MODE && (CMD>13)) |=> ERR == 1;
endproperty
logical_invalid_cmd_asrt: assert property(logical_invalid_cmd)
			else $error("ERR not raised");

endinterface

