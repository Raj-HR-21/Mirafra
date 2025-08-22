//coverage

class alu_cvg extends uvm_component;

`uvm_component_utils(alu_cvg)
uvm_analysis_imp#(alu_seq_item, alu_cvg) mon_imp_port;

alu_seq_item drv_item, mon_item;
real in, out;

covergroup inp_cg;
        clk_enb : coverpoint mon_item.CE { bins ce[] = {0,1};}
        mode    : coverpoint mon_item.MODE { bins md[] = {0,1};}
        inp_vld : coverpoint mon_item.INP_VALID { bins valid[] = {[0:3]};}
        cmd     : coverpoint mon_item.CMD { bins cmd1[] = {[0:13]} ;}
        inp_a   : coverpoint mon_item.OPA { bins aa[4] = {[1: ((2**`DATA_WIDTH)-2)]};
                                            bins a0 = {0};
                                            bins am = {{`DATA_WIDTH{1'b1}}};
                                                }

        inp_b   : coverpoint mon_item.OPB { bins bb[4] = {[1: ((2**`DATA_WIDTH)-2)]};
                                            bins b0 = {0};
                                            bins bm = {{`DATA_WIDTH{1'b1}}};
                                                }
        inp_c   : coverpoint mon_item.CIN { bins c[] = {0,1};}
        //Cross cvg
        mode_cmd : cross mode, cmd;

        mode_valid: cross mode, inp_vld;
        cmd_vld  : cross inp_vld, cmd;

endgroup	
covergroup out_cg;
	result : coverpoint mon_item.RES { bins res_r[4] = {[1: (2**(`DATA_WIDTH))]};
					   bins res_0 = {0};
					   bins res_m = {{(`DATA_WIDTH){1'b1}}};
						}
	error  : coverpoint mon_item.ERR { bins err[] = {0,1};}
	cout   : coverpoint mon_item.COUT{ bins carry[] = {0,1};}
	equal  : coverpoint mon_item.E { bins e[] = {0,1};}
	great  : coverpoint mon_item.G { bins g[] = {0,1};}
	less   : coverpoint mon_item.L { bins l[] = {0,1};} 
endgroup 

function new(string name="alu_cvg",uvm_component parent =null);
	super.new(name,parent);
	out_cg = new();
	inp_cg = new();
	mon_imp_port = new("mon_imp_port", this);
endfunction
/*
virtual function void write_drv(alu_seq_item item);
	drv_item = item;
	drv_cg.sample();
endfunction
*/
virtual function void write(alu_seq_item item);
	mon_item = item;
	inp_cg.sample();
	out_cg.sample();
endfunction

virtual function void extract_phase(uvm_phase phase);
	super.extract_phase(phase);
	in  = inp_cg.get_coverage();
	out = out_cg.get_coverage();
endfunction

function void report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("COVERAGE REPORT", $sformatf("----- COVERAGE REPORT -----"), UVM_LOW)
	`uvm_info(get_type_name(), $sformatf("[INP]: Coverage == %0.4f", in), UVM_MEDIUM);
	`uvm_info(get_type_name(), $sformatf("[OUT]: Coverage == %0.4f", out), UVM_MEDIUM);
endfunction

endclass

