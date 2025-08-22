//environment

class alu_env extends uvm_env;
	`uvm_component_utils(alu_env)
	alu_agent agnth;
	alu_scb	  scbh;
	alu_cvg	  cvgh;


	function new(string name = "alu_env", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agnth = alu_agent::type_id::create("agnth", this);
		scbh  = alu_scb::type_id::create("scbh", this);
		cvgh  = alu_cvg::type_id::create("cvgh", this);

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agnth.monh.mon_port.connect(scbh.item_collected_port);

		agnth.monh.mon_port.connect(cvgh.mon_imp_port);

	endfunction
endclass

