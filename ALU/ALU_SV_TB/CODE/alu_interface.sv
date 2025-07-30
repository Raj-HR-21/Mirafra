////---- INTERFACE ----////
interface alu_interface (input logic CLK, RESET);
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
//default input #1step output #1step;
output CE, CIN, MODE, INP_VALID, OPA, OPB, CMD;
input RES, ERR, OFLOW, COUT, E, G, L;
endclocking

clocking monitor_cb @(posedge CLK);
default input #0 output #0;
input RES, ERR, OFLOW, COUT, E, G, L;
input CE, CIN, MODE, INP_VALID, OPA, OPB, CMD;
endclocking

clocking ref_cb @(posedge CLK);
default input #0 output #0;
//input CE, CIN, MODE, INP_VALID, OPA, OPB, CMD;
//output RES, ERR, OFLOW, COUT, E, G, L;
endclocking

modport DRIVER (clocking driver_cb, input RESET);
modport MONITOR (clocking monitor_cb);
modport REF_MODEL (clocking ref_cb,
			input CLK, RESET,
			input CE, CIN, MODE, INP_VALID, OPA, OPB, CMD,
			input RES, ERR, OFLOW, COUT, E, G, L );

property ppt_reset;
        @(posedge CLK) RESET |=> ##[1:5] (RES == 9'bzzzzzzzz && ERR == 1'bz && E == 1'bz && G == 1'bz && L == 1'bz && COUT == 1'bz && OFLOW == 1'bz)
  endproperty
  assert property(ppt_reset)
    $display("RST assertion PASSED at time %0t", $time);
  else
    $info("RST assertion FAILED @ time %0t", $time);
  assert property (@(posedge CLK) (MODE && CMD > 10) |=> ERR)
    else $info("CMD INVALID ERR NOT RAISED");
 
  assert property (@(posedge CLK) (!MODE && CMD > 13) |=> ERR)
  else $info("CMD INVALID ERR NOT RAISED");



endinterface
