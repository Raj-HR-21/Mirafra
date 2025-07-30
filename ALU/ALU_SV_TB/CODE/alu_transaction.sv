////---- TRANSACTION ----////
`include "defines.sv"
class alu_transaction;
//Inputs
rand logic [`DATA_WIDTH-1:0] OPA, OPB;
rand logic [`CMD_WIDTH -1:0] CMD;
rand logic [1:0] INP_VALID;
rand logic CIN;
rand logic MODE;
rand logic CE;


//Outputs
logic [`DATA_WIDTH+1:0] RES;
logic ERR;
logic COUT;
logic OFLOW;
logic E;
logic G;
logic L;

//Write constraints
constraint clk_en { CE dist {1:=85, 0:=15};}
constraint mode_10{ MODE dist {1:=50, 0:=50};}
constraint input_valid { INP_VALID dist {0:= 10, [1:2]:=30, 3:=60} ;}
constraint oprtn_cmd {	if(MODE == 1) CMD inside {[0:13]};
			else CMD inside {[0:15]};}

constraint carry_in { CIN dist {1:= 50, 0:=50};}
constraint a { OPA inside {[0:255]};}
constraint b { OPB inside {[0:255]};}


//Deep copy function
virtual function alu_transaction copy;
	copy = new();
	copy.CE		= this.CE;
	copy.OPA	= this.OPA;
	copy.OPB	= this.OPB;
	copy.CIN	= this.CIN;
	copy.CMD	= this.CMD;
	copy.MODE	= this.MODE;
	copy.INP_VALID	= this.INP_VALID;
	copy.RES	= this.RES;
	copy.COUT	= this.COUT;
	copy.ERR	= this.ERR;
	copy.OFLOW	= this.OFLOW;
	copy.E		= this.E;
	copy.G		= this.G;
	copy.L		= this.L;
	return copy;
	
endfunction

endclass


class alu_transaction_0 extends alu_transaction; 
constraint input_valid { INP_VALID dist {0:= 20, [1:2]:=80, 3:=50} ;}
constraint oprtn_cmd {	if(MODE == 1) CMD inside {4,5,6,7};
			else CMD inside {6,7,8,9,10,11};}
virtual function alu_transaction copy0;
	copy0 = new();
	copy0.CE	= this.CE;
	copy0.OPA	= this.OPA;
	copy0.OPB	= this.OPB;
	copy0.CIN	= this.CIN;
	copy0.CMD	= this.CMD;
	copy0.MODE	= this.MODE;
	copy0.INP_VALID	= this.INP_VALID;
	copy0.RES	= this.RES;
	copy0.COUT	= this.COUT;
	copy0.ERR	= this.ERR;
	copy0.OFLOW	= this.OFLOW;
	copy0.E		= this.E;
	copy0.G		= this.G;
	copy0.L		= this.L;
	return copy0;
	
endfunction
endclass

class alu_transaction_1 extends alu_transaction; 
constraint input_valid { INP_VALID dist {0:= 10, 3:=50} ;}
constraint oprtn_cmd {	if(MODE == 1) CMD inside {9,10};
			else CMD inside {12,13};}
virtual function alu_transaction copy1;
	copy1 = new();
	copy1.CE	= this.CE;
	copy1.OPA	= this.OPA;
	copy1.OPB	= this.OPB;
	copy1.CIN	= this.CIN;
	copy1.CMD	= this.CMD;
	copy1.MODE	= this.MODE;
	copy1.INP_VALID	= this.INP_VALID;
	copy1.RES	= this.RES;
	copy1.COUT	= this.COUT;
	copy1.ERR	= this.ERR;
	copy1.OFLOW	= this.OFLOW;
	copy1.E		= this.E;
	copy1.G		= this.G;
	copy1.L		= this.L;
	return copy1;
	
endfunction
endclass

class alu_transaction_2 extends alu_transaction; 
constraint input_valid { INP_VALID dist {0:= 10, 3:=50} ;}
constraint oprtn_cmd {	if(MODE == 1) CMD inside {[0:3]};
			else CMD inside {[0:5]};}
virtual function alu_transaction copy2;
	copy2 = new();
	copy2.CE	= this.CE;
	copy2.OPA	= this.OPA;
	copy2.OPB	= this.OPB;
	copy2.CIN	= this.CIN;
	copy2.CMD	= this.CMD;
	copy2.MODE	= this.MODE;
	copy2.INP_VALID	= this.INP_VALID;
	copy2.RES	= this.RES;
	copy2.COUT	= this.COUT;
	copy2.ERR	= this.ERR;
	copy2.OFLOW	= this.OFLOW;
	copy2.E		= this.E;
	copy2.G		= this.G;
	copy2.L		= this.L;
	return copy2;
	
endfunction
endclass

class alu_transaction_3 extends alu_transaction; 
constraint a { OPA inside {0,255};}
constraint b { OPB inside {0,255};}
constraint input_valid { INP_VALID dist {0:= 10, 3:=50} ;}
constraint oprtn_cmd {	if(MODE == 1) CMD inside {[0:10]};
			else CMD inside {[0:13]};}
virtual function alu_transaction copy3;
	copy3 = new();
	copy3.CE	= this.CE;
	copy3.OPA	= this.OPA;
	copy3.OPB	= this.OPB;
	copy3.CIN	= this.CIN;
	copy3.CMD	= this.CMD;
	copy3.MODE	= this.MODE;
	copy3.INP_VALID	= this.INP_VALID;
	copy3.RES	= this.RES;
	copy3.COUT	= this.COUT;
	copy3.ERR	= this.ERR;
	copy3.OFLOW	= this.OFLOW;
	copy3.E		= this.E;
	copy3.G		= this.G;
	copy3.L		= this.L;
	return copy3;
	
endfunction
endclass
