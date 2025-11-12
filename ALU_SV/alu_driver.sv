////---- DRIVER ----////

class alu_driver;

//Transaction handle
alu_transaction drv_trxn;

//Mailbox from GEN
mailbox #(alu_transaction) mb_gen_drv;
//Mailbox to ref
mailbox #(alu_transaction) mb_drv_ref;

//Virtual interface of driver for communication between DRV and DUV
virtual alu_interface.DRIVER vif;
 
//Functional coverage
covergroup drv_cg ;
	clk_enb	: coverpoint drv_trxn.CE { bins ce[] = {0,1};} 
	mode   	: coverpoint drv_trxn.MODE { bins md[] = {0,1};}
	inp_vld	: coverpoint drv_trxn.INP_VALID { bins valid[] = {[0:3]};}
	cmd  	: coverpoint drv_trxn.CMD { bins cmd1[] = {[0:13]} ;}
	inp_a  	: coverpoint drv_trxn.OPA { bins aa = {[0: ((2**`DATA_WIDTH)-1)]};
					    bins a0 = {0};
					    bins am = {{`DATA_WIDTH{1'b1}}};
						}

    	inp_b  	: coverpoint drv_trxn.OPB { bins bb = {[0: ((2**`DATA_WIDTH)-1)]};
					    bins b0 = {0};
					    bins bm = {{`DATA_WIDTH{1'b1}}};
						}
	inp_c  	: coverpoint drv_trxn.CIN { bins c[] = {0,1};}
	//Cross cvg

        mode_cmd : cross mode, cmd;

	mode_valid: cross mode, inp_vld;
	cmd_vld  : cross inp_vld, cmd;


endgroup

//Constructor to store mailbox handles for communication
//Constructor for virtual interface
function new(	mailbox #(alu_transaction) mb_gen_drv,
		mailbox #(alu_transaction) mb_drv_ref,
		virtual alu_interface.DRIVER vif);
	this.mb_gen_drv = mb_gen_drv;
	this.mb_drv_ref = mb_drv_ref;
	this.vif = vif;

	//Create covergroup object
	drv_cg = new();
endfunction

function bit both_oprnd();
        if(drv_trxn.MODE == 1) begin
                return (drv_trxn.CMD inside{0,1,2,3,8,9,10}); end
        else begin
                return (drv_trxn.CMD inside{0,1,2,3,4,5,12,13}); end
endfunction

function void disp_driver();
	$display("");
	$display("%5t | DRV_DATA : CE = %b| MODE = %b| CMD = %b| INP_VALID = %b| OPA = %0d| OPB = %0d| CIN = %b", $time, drv_trxn.CE, drv_trxn.MODE, drv_trxn.CMD, drv_trxn.INP_VALID, drv_trxn.OPA, drv_trxn.OPB, drv_trxn.CIN);
endfunction
//Task to start driver or driving the stimuli
task start();
	bit valid_a;
	bit valid_b;

	repeat(3) @(vif.driver_cb);
	for(int i = 0; i < `num_of_trx; i++) begin
		drv_trxn = new(); //Creat driver transaction 
		//Get transaction from generator
		mb_gen_drv.get(drv_trxn);

		valid_a = drv_trxn.INP_VALID[0];
		valid_b = drv_trxn.INP_VALID[1];

		@(vif.driver_cb); ////
		if(vif.RESET == 1) begin 
			//@(vif.driver_cb);
			begin	
			vif.driver_cb.CE 	<= 0;
			vif.driver_cb.CIN 	<= 0;
			vif.driver_cb.MODE 	<= 0;
			vif.driver_cb.CMD 	<= 0;
			vif.driver_cb.INP_VALID <= 0;
			vif.driver_cb.OPA 	<= 0;
			vif.driver_cb.OPB 	<= 0;
			mb_drv_ref.put(drv_trxn);
			disp_driver();
			drv_cg.sample();
			end
		end

		else if((both_oprnd()) &&((!valid_a && valid_b) || (valid_a && !valid_b)) )begin
				vif.driver_cb.CE        <= drv_trxn.CE;
				vif.driver_cb.CIN       <= drv_trxn.CIN;
				vif.driver_cb.MODE      <= drv_trxn.MODE;
				vif.driver_cb.CMD       <= drv_trxn.CMD;
				vif.driver_cb.INP_VALID <= drv_trxn.INP_VALID;
				vif.driver_cb.OPA       <= drv_trxn.OPA;
				vif.driver_cb.OPB       <= drv_trxn.OPB;
				mb_drv_ref.put(drv_trxn); 
				disp_driver();	
				drv_cg.sample();	
				drv_trxn.CE.rand_mode(0);
				drv_trxn.CMD.rand_mode(0);
				drv_trxn.MODE.rand_mode(0);
				//repeat(3)@(vif.driver_cb);
				for(int j = 1; j < 16; j++) begin
					void'(drv_trxn.randomize());
					@(vif.driver_cb);
					if(drv_trxn.INP_VALID == 2'b11) begin
						vif.driver_cb.CE        <= drv_trxn.CE;
						vif.driver_cb.CIN       <= drv_trxn.CIN;
						vif.driver_cb.MODE      <= drv_trxn.MODE;
						vif.driver_cb.CMD       <= drv_trxn.CMD;
						vif.driver_cb.INP_VALID <= drv_trxn.INP_VALID;
						vif.driver_cb.OPA       <= drv_trxn.OPA;
						vif.driver_cb.OPB       <= drv_trxn.OPB;
						mb_drv_ref.put(drv_trxn);
						drv_cg.sample();
						//repeat(3)@(vif.driver_cb);
						$display("");
$display("%5t | DRV_11 : CE = %b| MODE = %b| CMD = %b| INP_VALID = %b| OPA = %0d| OPB = %0d| CIN = %b", $time, drv_trxn.CE, drv_trxn.MODE, drv_trxn.CMD, drv_trxn.INP_VALID, drv_trxn.OPA, drv_trxn.OPB, drv_trxn.CIN);
						break;
					end
					else begin //if( drv_trxn.INP_VALID == 2'b11 || j == 15) begin

						vif.driver_cb.CE        <= drv_trxn.CE;
						vif.driver_cb.CIN       <= drv_trxn.CIN;
						vif.driver_cb.MODE      <= drv_trxn.MODE;
						vif.driver_cb.CMD       <= drv_trxn.CMD;
						vif.driver_cb.INP_VALID <= drv_trxn.INP_VALID;
						vif.driver_cb.OPA       <= drv_trxn.OPA;
						vif.driver_cb.OPB       <= drv_trxn.OPB;
						mb_drv_ref.put(drv_trxn);
						drv_cg.sample();
						//repeat(3)@(vif.driver_cb);	
						$display("");
$display("%5t | DRV_1001 : CE = %b| MODE = %b| CMD = %b| INP_VALID = %b| OPA = %0d| OPB = %0d| CIN = %b", $time, drv_trxn.CE, drv_trxn.MODE, drv_trxn.CMD, drv_trxn.INP_VALID, drv_trxn.OPA, drv_trxn.OPB, drv_trxn.CIN);
						repeat(3)@(vif.driver_cb);
					end	
				end //for loop
				drv_trxn.CE.rand_mode(1);
				drv_trxn.CMD.rand_mode(1);
				drv_trxn.MODE.rand_mode(1);
			end //01-10
			
		else begin
				vif.driver_cb.CE        <= drv_trxn.CE;
				vif.driver_cb.CIN       <= drv_trxn.CIN;
				vif.driver_cb.MODE      <= drv_trxn.MODE;
				vif.driver_cb.CMD       <= drv_trxn.CMD;
				vif.driver_cb.INP_VALID <= drv_trxn.INP_VALID;
				vif.driver_cb.OPA	<= drv_trxn.OPA;
				vif.driver_cb.OPB       <= drv_trxn.OPB;
				mb_drv_ref.put(drv_trxn);
				disp_driver();
				drv_cg.sample();
		end
		

		repeat(3)@(vif.driver_cb);
	end
endtask
endclass
