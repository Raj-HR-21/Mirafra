////---- GENERATOR ----////

class alu_generator;
//Transaction handle
alu_transaction blueprint;

//mailbox from GEN to DRV
mailbox #(alu_transaction) mb_gen_drv;

//mailbox of GEN to DRV
function new(mailbox #(alu_transaction) mb_gen_drv);
this.mb_gen_drv = mb_gen_drv;
blueprint = new();
endfunction

//Initiate a task to generate randomized data
task start();
	for(int i = 0; i < `num_of_trx; i++) begin
		if(blueprint.randomize()) begin
			//Put data to mailbox
			mb_gen_drv.put(blueprint.copy());
                        $display("--------------------------------------------------");
			$display("%5t | GEN_DATA : CE = %b| MODE = %b| CMD = %b| INP_VALID = %b| OPA = %0d| OPB = %0d| CIN = %b", $time, blueprint.CE, blueprint.MODE, blueprint.CMD, blueprint.INP_VALID, blueprint.OPA, blueprint.OPB, blueprint.CIN);	
		end
		end
		//else $display("NO RANDOMIZATION");
endtask

endclass
