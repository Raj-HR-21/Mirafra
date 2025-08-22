// sequence item
class alu_seq_item extends uvm_sequence_item;
	rand logic [`DATA_WIDTH-1:0] OPA, OPB;
	rand logic [`CMD_WIDTH -1:0] CMD;
	rand logic [1:0] INP_VALID;
	rand logic CIN;
	rand logic MODE;
	rand logic CE;
	logic CLK;
	logic RESET;

	//Outputs
	logic [`DATA_WIDTH:0] RES;
	logic ERR;
	logic COUT;
	logic OFLOW;
	logic E;
	logic G;
	logic L;
	`uvm_object_utils_begin(alu_seq_item)
		`uvm_field_int(CLK, UVM_ALL_ON)
		`uvm_field_int(RESET ,UVM_ALL_ON)
		`uvm_field_int(CE,UVM_ALL_ON)
		`uvm_field_int(INP_VALID,UVM_ALL_ON)
		`uvm_field_int(MODE,UVM_ALL_ON)
		`uvm_field_int(CMD,UVM_ALL_ON)
		`uvm_field_int(OPA,UVM_ALL_ON)
		`uvm_field_int(OPB,UVM_ALL_ON)
		`uvm_field_int(CIN,UVM_ALL_ON)
		`uvm_field_int(RES,UVM_ALL_ON)
		`uvm_field_int(COUT,UVM_ALL_ON)
		`uvm_field_int(ERR,UVM_ALL_ON)
		`uvm_field_int(OFLOW,UVM_ALL_ON)
		`uvm_field_int(E,UVM_ALL_ON)
		`uvm_field_int(G,UVM_ALL_ON)
		`uvm_field_int(L,UVM_ALL_ON)
	`uvm_object_utils_end
	
	//Write constraints
	constraint clk_en { CE dist {1:=85, 0:=20};}
	constraint mode_10{ MODE dist {1:=50, 0:=50};}
	constraint input_valid { INP_VALID dist {0:=10, [1:2]:=20, 3:=70} ;}
	constraint oprtn_cmd {	if(MODE == 1) CMD inside {[0:15]};
				else CMD inside {[0:15]};}

	constraint carry_in { CIN dist {1:= 50, 0:=50};}
	constraint a { OPA inside {[0:255]};}
	constraint b { OPB inside {[0:255]};}
	
	function new(string name = "alu_seq_item");
		super.new(name);
	endfunction
	
endclass

