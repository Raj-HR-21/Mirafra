////---- REFERENCE MODEL ----////
class alu_ref_model;
//Transaction handle
alu_transaction ref_trxn;
//Mailbox from driver
mailbox #(alu_transaction)mb_drv_ref;
//Mailbox from
mailbox #(alu_transaction)mb_ref_scb;
//Virtual interface
virtual alu_interface.REF_MODEL vif;

function new(   mailbox#(alu_transaction)mb_drv_ref,
                mailbox #(alu_transaction)mb_ref_scb,
                virtual alu_interface.REF_MODEL vif);

        this.mb_drv_ref = mb_drv_ref;
        this.mb_ref_scb = mb_ref_scb;
        this.vif = vif;
endfunction

localparam rotate_amt = $clog2(`DATA_WIDTH);
reg [rotate_amt-1 : 0] OPB_REG;
bit [5:0]wait_16 = 0;

function bit opa_only();
        if(ref_trxn.MODE == 1) begin
                return (ref_trxn.CMD inside{4,5}); end
        else begin
                return (ref_trxn.CMD inside{6,8,9}); end
endfunction
function bit opb_only();
        if(ref_trxn.MODE == 1) begin
                return (ref_trxn.CMD inside{6,7});end
        else begin
                return (ref_trxn.CMD inside{7,10,11}); end
endfunction
function bit both_oprnd();
        if(ref_trxn.MODE == 1) begin
                return (ref_trxn.CMD inside{0,1,2,3,8,9,10}); end
        else begin
                return (ref_trxn.CMD inside{0,1,2,3,4,5,12,13}); end
endfunction

task operations();
	ref_trxn.RES = 'bz;
	ref_trxn.ERR = 'bz;	
	ref_trxn.COUT = 'bz;
	ref_trxn.OFLOW = 'bz;
	ref_trxn.E = 'bz;
	ref_trxn.G = 'bz;
	ref_trxn.L = 'bz;
	repeat(1)@(vif.ref_cb);
	if(ref_trxn.MODE == 1) begin
			case(ref_trxn.CMD)
				0: begin
					ref_trxn.RES = ref_trxn.OPA + ref_trxn.OPB;
				    	ref_trxn.COUT = ref_trxn.RES[`DATA_WIDTH];
				   end
				1: begin
					ref_trxn.RES = ref_trxn.OPA - ref_trxn.OPB;
					ref_trxn.OFLOW = (ref_trxn.OPA < ref_trxn.OPB);
				    end
				2: begin
				    ref_trxn.RES = ref_trxn.OPA + ref_trxn.OPB + ref_trxn.CIN;
				    ref_trxn.COUT = ref_trxn.RES[`DATA_WIDTH];
				    end
				3: begin
				    ref_trxn.RES = ref_trxn.OPA - ref_trxn.OPB - ref_trxn.CIN;
				    ref_trxn.OFLOW = (ref_trxn.OPA < ref_trxn.OPB);
				    end
				4: begin
				    ref_trxn.RES = ref_trxn.OPA + 1;
				    ref_trxn.COUT = ref_trxn.RES[`DATA_WIDTH];
				    end
				5: begin
				    ref_trxn.RES = ref_trxn.OPA - 1;
				    ref_trxn.OFLOW = (ref_trxn.OPA < 1) ? 1 : 0;
				    end
				6: begin
				    ref_trxn.RES = ref_trxn.OPB + 1;
				    ref_trxn.COUT = ref_trxn.RES[`DATA_WIDTH];
				    end
				7: begin
				    ref_trxn.RES = ref_trxn.OPB - 1;
				    ref_trxn.OFLOW = (ref_trxn.OPB < 1) ? 1 : 0;
				    end
				8: begin
				    ref_trxn.RES = {`DATA_WIDTH {1'bz}};
				    ref_trxn.L = (ref_trxn.OPA < ref_trxn.OPB) ? 1 : 0;
				    ref_trxn.G = (ref_trxn.OPA > ref_trxn.OPB) ? 1 : 0;
				    ref_trxn.E = (ref_trxn.OPA == ref_trxn.OPB) ? 1 : 0;;
				    end
				9: begin
				    ref_trxn.RES = (ref_trxn.OPA+1) * (ref_trxn.OPB + 1);
				    repeat(1)@(vif.ref_cb);
				    end
				10: begin
				    ref_trxn.RES = (ref_trxn.OPA << 1) * ref_trxn.OPB;
				    repeat(1)@(vif.ref_cb);
				    end
				default: begin
				    ref_trxn.RES = `DATA_WIDTH'bz;
				    ref_trxn.ERR = 1;
				    end
                    endcase
		end
		else begin //mode = 0
		    case(ref_trxn.CMD)
				1: ref_trxn.RES = ~(ref_trxn.OPA & ref_trxn.OPB);
				2: ref_trxn.RES = ref_trxn.OPA | ref_trxn.OPB;
				0: ref_trxn.RES = ref_trxn.OPA & ref_trxn.OPB;
				3: ref_trxn.RES = ~(ref_trxn.OPA | ref_trxn.OPB);
				4: ref_trxn.RES = ref_trxn.OPA ^ ref_trxn.OPB;
				5: ref_trxn.RES = ~(ref_trxn.OPA ^ ref_trxn.OPB);
				6: ref_trxn.RES = ~(ref_trxn.OPA);
				7: ref_trxn.RES = ~(ref_trxn.OPB);
				8: ref_trxn.RES = (ref_trxn.OPA >> 1);
				9: ref_trxn.RES = (ref_trxn.OPA << 1);
				10:ref_trxn.RES = (ref_trxn.OPB >> 1);
				11:ref_trxn.RES = (ref_trxn.OPB << 1);
				12: begin
				OPB_REG = ref_trxn.OPB[rotate_amt-1 : 0];
				ref_trxn.RES[`DATA_WIDTH-1 :0] = {1'b0, (ref_trxn.OPA << OPB_REG) | (ref_trxn.OPA >>(`DATA_WIDTH-OPB_REG))};
				ref_trxn.ERR = (|(ref_trxn.OPB[`DATA_WIDTH-1 : rotate_amt]));
				end
				13: begin
				OPB_REG = ref_trxn.OPB[rotate_amt-1 : 0];
				ref_trxn.RES = {1'b0, (ref_trxn.OPA >> OPB_REG) | (ref_trxn.OPA<<(`DATA_WIDTH-OPB_REG))};
				ref_trxn.ERR = (|(ref_trxn.OPB[`DATA_WIDTH-1 : rotate_amt]));
				end
				default: begin
				ref_trxn.RES = `DATA_WIDTH'bz;
				ref_trxn.ERR = 1;
				end
            endcase
	end
	//return ref_trxn;
endtask

function void ref_disp();
        $display("%5t | REF_MODL : CE = %b| MODE = %b| CMD = %b| INP_VALID = %b| OPA = %0d| OPB = %0d| CIN = %b",$time, ref_trxn.CE, ref_trxn.MODE, ref_trxn.CMD, ref_trxn.INP_VALID, ref_trxn.OPA, ref_trxn.OPB, ref_trxn.CIN);
        $display("%5t | REF_MODL : ERR = %b| COUT = %b| OFLOW = %b| E = %b| G = %b| L = %b| RES = %0d",$time, ref_trxn.ERR, ref_trxn.COUT, ref_trxn.OFLOW, ref_trxn.E, ref_trxn.G, ref_trxn.L, ref_trxn.RES);
endfunction

//Start the task
task start();
	bit valid_a, valid_b;
	int wait_16 = 0;
	repeat(3)@(vif.ref_cb);
for(int i = 0; i < `num_of_trx; i++) begin
        ref_trxn = new;
        mb_drv_ref.get(ref_trxn); // Get data from driver
	repeat(1)@(vif.ref_cb);
	valid_a = ref_trxn.INP_VALID[0];
        valid_b = ref_trxn.INP_VALID[1];

	if(ref_trxn.CE) begin
        if(vif.RESET == 1) begin
                ref_trxn.RES = 'bz;
                ref_trxn.ERR = 'bz;
                ref_trxn.COUT = 'bz;
                ref_trxn.OFLOW = 'bz;
                ref_trxn.E = 'bz;
                ref_trxn.G = 'bz;
                ref_trxn.L = 'bz;
		//mb_ref_scb.put(ref_trxn);
		//ref_disp();
        end
        else begin //RESET = 0
		
		if(both_oprnd) begin //both_oprnd
			if(ref_trxn.INP_VALID == 2'b11) begin
				operations();
				//mb_ref_scb.put(ref_trxn);
				//ref_disp();
				
			end
			else if((valid_a && !valid_b) ||(!valid_a && valid_b)) begin 
				operations();
				ref_trxn.RES = 'bz; 
				ref_disp();
				for(int wait_16 = 1; ( wait_16 < 16); wait_16++) begin
					//repeat(1)@(vif.ref_cb); 
					mb_drv_ref.get(ref_trxn); // Get randomized INP_VALID and OPA-OPB data from driver
					//repeat(1)@(vif.ref_cb); 
					if(ref_trxn.INP_VALID == 2'b11) begin
						operations();
						wait_16 = 0;

						break;
						end
					
					else begin //10-01
						//operations();
						
						ref_trxn.RES = 'bz; 
						ref_disp();
						end
					if (wait_16 >= 16) begin
						ref_trxn.ERR = 'b1;
						if((ref_trxn.CMD == 'b1001 || ref_trxn.CMD == 'b1010 ) && ref_trxn.MODE == 'b1) begin
							repeat(2)@(vif.ref_cb); end
						else begin
							repeat(1)@(vif.ref_cb); end

						end
				end //end for loop

			end // end 01-10

		end //both_oprnd
		else if(opa_only()) begin
			if(ref_trxn.INP_VALID == 2'b01 || ref_trxn.INP_VALID == 2'b11) begin
				operations();
				
			end
			else begin
				ref_trxn.RES = `DATA_WIDTH'bz;
				ref_trxn.ERR = 1;
				repeat(1)@(vif.ref_cb);
				
			end
		end
		else if(opb_only() ) begin
			if(ref_trxn.INP_VALID == 2'b10 || ref_trxn.INP_VALID == 2'b11) begin
				operations();
				
			end
			else begin
				ref_trxn.RES = `DATA_WIDTH'bz;
				ref_trxn.ERR = 1;
				repeat(1)@(vif.ref_cb);
				
			end
		end
		else begin // 00
			ref_trxn.RES = `DATA_WIDTH'bz;
			ref_trxn.ERR = 1;
			if((ref_trxn.CMD == 'b1001 || ref_trxn.CMD == 'b1010 ) && ref_trxn.MODE == 'b1) begin
				repeat(2)@(vif.ref_cb); end
			else begin
				repeat(1)@(vif.ref_cb); end	
		end				
	end // RESET = 0
end // CE = 1
else begin //CE = 0
	ref_trxn.RES = ref_trxn.RES;
    	ref_trxn.ERR = ref_trxn.ERR;
	ref_trxn.COUT = ref_trxn.COUT;
	ref_trxn.OFLOW = ref_trxn.OFLOW;
	ref_trxn.E = ref_trxn.E;
	ref_trxn.G = ref_trxn.G;
	ref_trxn.L = ref_trxn.L;
	//@(vif.ref_cb);
	if((ref_trxn.CMD == 'b1001 || ref_trxn.CMD == 'b1010 ) && ref_trxn.MODE == 'b1) begin
		repeat(2)@(vif.ref_cb); end
	else begin
		repeat(1)@(vif.ref_cb); end
end // CE = 0		
//@(vif.ref_cb);
//@(vif.ref_cb);
mb_ref_scb.put(ref_trxn);
ref_disp();
end
endtask

endclass