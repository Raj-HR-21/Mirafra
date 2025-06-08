`include "rtl_design.v"
`define PASS 1'b1
`define FAIL 1'b0
`define no_of_testcases 190

module testbench #(parameter DATA_WIDTH = 8, CMD_WIDTH = 4,RESULT_WIDTH = 2*DATA_WIDTH);

parameter EXP_DATA_WIDTH = RESULT_WIDTH + 6;

reg [56:0] curr_test_case = 57'b0;
reg [56:0] stimulus_mem [0 : `no_of_testcases-1];
reg [79:0] response_packet; // Stimulus data with dut result_data

//Declaration of inputs and stimulus
integer i,j;
event fetch_stimulus;
reg CLK, CE, RESET;
reg [DATA_WIDTH-1 : 0]OPA, OPB;
reg CIN;
reg [CMD_WIDTH-1 : 0] CMD;
reg [1:0]IN_VALID;
reg MODE;
reg [7:0]Feature_ID;
//reg [2:0]Comp_EGL;
reg [RESULT_WIDTH-1 : 0]Exp_res;
reg Exp_cout, Exp_err, Exp_oflow;
//reg Exp_g, Exp_l, Exp_e;
reg [2:0]Exp_egl;
reg [1:0]resrv_bit;
//DUT outputs
wire ERR, OFLOW, COUT, G, L, E;
wire [RESULT_WIDTH-1 : 0]RESULT;
wire [2:0]EGL;
wire [21 : 0]Exp_data;
reg [21 : 0]Exact_data; //  dut result_data

task read_stimulus();
begin
        #10 $readmemb("stimulus.txt", stimulus_mem);
end
endtask

alu_rtl_design #(DATA_WIDTH, CMD_WIDTH,RESULT_WIDTH) dut(.CLK(CLK), .CE(CE), .RESET(RESET), .IN_VALID(IN_VALID), .MODE(MODE), .CMD(CMD), .OPA(OPA), .OPB(OPB), .CIN(CIN), .RESULT(RESULT), .ERR(ERR), .OFLOW(OFLOW), .COUT(COUT), .E(EGL[0]), .G(EGL[1]), .L(EGL[2]));

//Stimulus generation
integer stim_mem_ptr=0, stim_stimulus_mem_ptr=0, pointer=0;

always@(fetch_stimulus) begin
        curr_test_case = stimulus_mem[stim_mem_ptr];
        $display("\nstimulus_mem data = %0b ",stimulus_mem[stim_mem_ptr]);
        $display ("packet data = %0b ",curr_test_case);
        stim_mem_ptr = stim_mem_ptr + 1;
end

//clock Gen
initial begin
CLK=0;
forever  #10 CLK = ~CLK;
end

//DUT RESET
task dut_reset();
begin
RESET = 1; CE = 1;
#40 RESET = 0;

#5000  RESET = 1;
#40 RESET = 0;
end
endtask

initial begin
$dumpfile("alu_wave.vcd");
$dumpvars(0, testbench);
end

//Global initialization
task global_init();
begin
        curr_test_case = 57'b0;
        response_packet = 80'b0;
        stim_mem_ptr = 0;
end
endtask

//Drive module
task driver();
begin
        ->fetch_stimulus;
        @(posedge CLK);
        Feature_ID = curr_test_case[56:49];
        resrv_bit = curr_test_case[48:47];
        OPA = curr_test_case[46:39];
        OPB = curr_test_case[38:31];
        CMD = curr_test_case[30:27];
        CIN = curr_test_case[26];
        CE = curr_test_case[25];
        MODE = curr_test_case[24];
        IN_VALID = curr_test_case[23:22];
        if(MODE==1 && (CMD == 'b1001 || CMD == 'b1010))begin
                        Exp_res = curr_test_case[21:6];
        end else begin
                Exp_res = curr_test_case[14:6];
        end
        Exp_cout = curr_test_case[5];
        Exp_egl = curr_test_case[4:2];
        Exp_oflow = curr_test_case[1];
        Exp_err = curr_test_case[0];
$display("DRIVER : \nFeature_ID = %8b, resrv_bit = %2b, \nOPA = %b, OPB = %b, CMD = %b, CIN = %1b, CE = %1b, MODE = %1b, IN_VALID = %2b,\nExp_res = %b, Exp_cout = %1b, Exp_egl = %3b, Exp_oflow = %1b, Exp_err = %1b",Feature_ID,resrv_bit,OPA,OPB,CMD,CIN,CE,MODE,IN_VALID,Exp_res,Exp_cout,Exp_egl,Exp_oflow,Exp_err );

end
endtask

//Monitor module
task monitor();
begin
        repeat(3) @(posedge CLK);
        #5;
        response_packet[79] = 0;
        if(MODE == 1 && (CMD == 'b1001 || CMD == 'b1010))
                response_packet[78:63]=RESULT;
        else begin
                response_packet[78:72]='b0;
                response_packet[71:63] = RESULT;
                end
        response_packet[62] = COUT;
        response_packet[61:59] = {EGL};
        response_packet[58] = OFLOW;
        response_packet[57] = ERR;
        response_packet[56:0] = curr_test_case;
        $display("Monitor : \nAt time[%0t] RESULT = %b, COUT = %1b, EGL = %3b, OFLOW = %1b, ERR = %1b\n", $time, RESULT,COUT,{EGL},OFLOW,ERR);
        $display("--------------------------------------------------------------");
        Exact_data = {RESULT,COUT,{EGL},OFLOW,ERR};
end
endtask

assign Exp_data = {Exp_res,Exp_cout,Exp_egl,Exp_oflow, Exp_err};

//Scoreboard

reg [38:0] scb_stimulus_mem [0 : `no_of_testcases-1];

task scoreboard();
reg [7:0]Feature_ID;
reg [8 : 0]Exp_res;
reg [14:0]Response_data;
begin
        Feature_ID = curr_test_case[56:49];
        Exp_res = curr_test_case[14:6];
        Response_data = response_packet[71:57];
        $display("Expected result = %b, Response_data = %b",Exp_res,Response_data);
        if(Exp_data === Exact_data)
                scb_stimulus_mem[stim_stimulus_mem_ptr] = {1'b0, Feature_ID, Exp_res, Response_data, CMD, 1'b0, `PASS};
        else
                scb_stimulus_mem[stim_stimulus_mem_ptr] = {1'b0, Feature_ID, Exp_res, Response_data, CMD, 1'b0, `FAIL};

        stim_stimulus_mem_ptr = stim_stimulus_mem_ptr + 1;
end
endtask

task gen_report();
integer file_id, pointer;
reg [38:0]status;
reg [3:0]cmd;
begin
        cmd = CMD;
        file_id = $fopen("result.txt","w");
        for(pointer = 0; pointer <=`no_of_testcases-1; pointer = pointer + 1) begin
                status = scb_stimulus_mem[pointer];
                if(status[0])
                        $fdisplay(file_id,"F_ID %8b [%d]: PASS", status[37:30], status[37:30]);
                else
                        $fdisplay(file_id,"F_ID %8b [%d]: FAIL : CMD = %d", status[37:30],status[37:30], status[5:2]);
        end
        $fclose(file_id);

end
endtask

initial begin
        #10;
        global_init();
        dut_reset();
        read_stimulus();
        for(j = 0; j <= `no_of_testcases-1; j = j + 1) begin
                fork
                        driver();
                        monitor();
                        scoreboard();
                join
        end
        gen_report();
        //$fclose(0);
        #300 $finish;
end

endmodule

