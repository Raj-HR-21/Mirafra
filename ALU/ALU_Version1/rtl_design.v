//RTL Design
`include "define_file.v"

module alu_rtl_design #(parameter DATA_WIDTH = 8, CMD_WIDTH = 4,RESULT_WIDTH = 2*DATA_WIDTH)
                (CLK, CE, RESET, IN_VALID, MODE, CMD, OPA, OPB, CIN, RESULT, ERR, OFLOW, COUT, E, G, L);

//MODE = 1 : Arithematic
//MODE = 0 : Logical

//Inputs and Outputs
input CLK, CE, RESET, MODE, CIN;
input [1:0]IN_VALID;
input [(CMD_WIDTH-1) : 0]CMD;
input [(DATA_WIDTH-1) : 0]OPA,OPB;
output reg ERR, OFLOW, COUT, G, L, E;
output reg [(RESULT_WIDTH - 1) : 0]RESULT;

//Temp reg
reg [(DATA_WIDTH-1):0]OPA_1, OPB_1;
reg [(CMD_WIDTH-1) : 0]CMD_1;
reg [1:0]IN_VALID_1;
reg CIN_1;
reg MODE_1;

reg ERR_1, OFLOW_1, COUT_1, G_1, L_1, E_1;
reg [(RESULT_WIDTH-1) : 0]RESULT_REG;
reg [(RESULT_WIDTH-1) : 0]RESULT_MUL1, RESULT_MUL2;

localparam rotate_amt = $clog2(DATA_WIDTH);
reg [rotate_amt-1 : 0] OPB_REG;


always@(posedge CLK or posedge RESET) begin
if(RESET) begin
        OPA_1 <= 'b0;
        OPB_1 <= 'b0;
        CIN_1 <= 'b0;
        CMD_1 <= 'b0;
        IN_VALID_1 <= 'b0;
        MODE_1 <= 'b0;
        RESULT_MUL1 <= 'b0;
        RESULT_MUL2 <= 'b0;
        end
else if(CE) begin
        OPA_1 <= OPA;
        OPB_1 <= OPB;
        CIN_1 <= CIN;
        CMD_1 <= CMD;
        IN_VALID_1 <= IN_VALID;
        MODE_1 <= MODE;
        end
else begin
        OPA_1 <= OPA_1;
        OPB_1 <= OPB_1;
        CIN_1 <= CIN_1;
        CMD_1 <= CMD_1;
        IN_VALID_1 <= IN_VALID_1;
        MODE_1 <= MODE_1;
end
end


always@(posedge CLK or posedge RESET) begin
if(RESET) begin
        RESULT <= {RESULT_WIDTH{1'b0}};
        ERR <= 'b0;
        OFLOW <= 'b0;
        COUT <= 'b0;
        G <= 'b0;
        L <= 'b0;
        E <= 'b0;
end //end if(RESET)
else if(CE) begin //RESET=0 //CE=1
                if(CMD_1 == 'b1001 || CMD_1 =='b1010)begin
                        RESULT_MUL2 <= RESULT_MUL1;
                        RESULT <= RESULT_MUL2;
                        end
                else begin
                        RESULT <= RESULT_REG;
                        end
                ERR <= ERR_1;
                OFLOW <= OFLOW_1;
                COUT <= COUT_1;
                G <= G_1;
                L <= L_1;
                E <= E_1;
                end
        else begin
                OPA_1 <= OPA_1;
                OPB_1 <= OPB_1;
                CIN_1 <= CIN_1;
                CMD_1 <= CMD_1;
                IN_VALID_1 <= IN_VALID_1;
                MODE_1 <= MODE_1;

            end
end

always@(*) begin
        RESULT_REG = 'b0;
        ERR_1 = 'b0;
        OFLOW_1 = 'b0;
        COUT_1 = 'b0;
        G_1 = 'b0;
        L_1 = 'b0;
        E_1 = 'b0;
        if(MODE_1) begin //Arithematic
        if(IN_VALID_1 == 'b11) begin
        case(CMD_1)
                `ADD:  begin //ADD
                        RESULT_REG = OPA_1 + OPB_1;
                        COUT_1 = RESULT_REG[DATA_WIDTH] ? 1 : 0;
                        end
                `SUB: begin //SUB
                        RESULT_REG = OPA_1 - OPB_1;
                        OFLOW_1 = (OPA_1 < OPB_1) ? 1 : 0;
                        end
                `ADD_CIN: begin //ADD_CIN
                        RESULT_REG = OPA_1 + OPB_1 + CIN_1;
                        COUT_1 = (RESULT_REG[DATA_WIDTH] == 1)? 1 : 0;
                        end
                `SUB_CIN: begin //SUB_CIN
                        RESULT_REG = OPA_1 - OPB_1 - CIN_1;
                        OFLOW_1 = (OPA_1 < OPB_1) ? 1 : 0;
                        end
                `CMP: begin //CMP
                        RESULT_REG = 'b0;
                        if(OPA_1 > OPB_1) begin
                                G_1 = 1'b1;
                                L_1 = 1'b0;
                                E_1 = 1'b0;
                                end
                        else if(OPA_1 < OPB_1) begin
                                G_1 = 1'b0;
                                L_1 = 1'b1;
                                E_1 = 1'b0;
                                end
                        else begin
                                G_1 = 1'b0;
                                L_1 = 1'b0;
                                E_1 = 1'b1;
                                end
                        end
                `MUL1: begin //INC_A * INC_B
                        RESULT_MUL1 = (OPA_1+1) * (OPB_1+1);
                        OFLOW_1 = (OPA_1=={DATA_WIDTH{1'b1}} && OPB_1=={DATA_WIDTH{1'b1}}) ? 1'b1 : 1'b0;
                        end
                `MUL2: begin //A<<1 * B
                        RESULT_MUL1 = ((OPA_1<<1) * OPB_1);
                        OFLOW_1 = ( (OPA_1 > 128 || OPB_1 == 255) && (OPA_1 == 255 || OPB_1 > 128) );
                        end
                `ADD_SIGNED: begin //Signed_ADD
                        RESULT_REG = $signed(OPA_1) + $signed(OPB_1);
                        G_1 = ($signed(OPA_1) > $signed(OPB_1)) ? 1:0;
                        L_1 = ($signed(OPA_1) < $signed(OPB_1)) ? 1:0;
                        E_1 = ($signed(OPA_1) == $signed(OPB_1)) ? 1:0;
                        OFLOW_1 = ((OPA_1[DATA_WIDTH-1] == OPB_1[DATA_WIDTH-1]) && (RESULT_REG[DATA_WIDTH-1]!=OPA_1[DATA_WIDTH-1])) ? 1'b1 : 1'b0;
                        end
                `SUB_SIGNED: begin //Signed_SUB
                        RESULT_REG = $signed(OPA_1) - $signed(OPB_1);
                        G_1 = ($signed(OPA_1) > $signed(OPB_1)) ? 1:0;
                        L_1 = ($signed(OPA_1) < $signed(OPB_1)) ? 1:0;
                        E_1 = ($signed(OPA_1) == $signed(OPB_1)) ? 1:0;
                        OFLOW_1 = ((OPA_1[DATA_WIDTH-1] != OPB_1[DATA_WIDTH-1]) && (RESULT_REG[DATA_WIDTH-1] !=OPA_1[DATA_WIDTH-1]))? 1'b1 : 1'b0;
                        end

                default: begin
                RESULT_REG = {RESULT_WIDTH{1'b0}};
                ERR_1 = 'b1;
                OFLOW_1 =1 'b0;
                COUT_1 = 'b0;
                G_1 = 'b0;
                L_1 = 'b0;
                E_1 = 'b0;
                end
        endcase
        end //end if(IN_VALID == 'b11)

        else if(IN_VALID_1 == 'b01) begin
        case(CMD_1)
                `INC_A: begin //INC_A
                        if(OPA_1 == {DATA_WIDTH{1'b1}}) begin
                                RESULT_REG = OPA_1 + 1;
                                OFLOW_1 = 'b1;
                                end
                        else begin
                                RESULT_REG = OPA_1 + 1;
                                OFLOW_1 = 'b0;
                                end
                        end
                `DEC_A: begin //DEC_A
                        if(OPA_1 == 0) begin
                                RESULT_REG = OPA_1 - 1;
                                OFLOW_1 = 'b1;
                                end
                        else begin
                                RESULT_REG = OPA_1 - 1;
                                OFLOW_1 = 'b0;
                                end
                        end
                default: begin
                RESULT_REG = {RESULT_WIDTH{1'b0}};
                ERR_1 = 'b1;
                OFLOW_1 = 'b0;
                COUT_1 = 'b0;
                G_1 = 'b0;
                L_1 = 'b0;
                E_1 = 'b0;
                end

        endcase

        end //end if(IN_VALID == 'b01 )

        else if(IN_VALID_1 == 'b10) begin
        case(CMD_1)
                `INC_B: begin //INC_B
                        if(OPB_1 == {DATA_WIDTH{1'b1}}) begin
                                RESULT_REG = OPB_1 + 1;
                                OFLOW_1 = 'b1;
                                end
                        else begin
                                RESULT_REG = OPB_1 + 1;
                                OFLOW_1 = 'b0;
                                end
                        end
                `DEC_B: begin //DEC_B
                        if(OPB_1 == 0) begin
                                RESULT_REG = OPB_1 - 1;
                                OFLOW_1 = 'b1;
                                end
                        else begin
                                RESULT_REG = OPB_1 - 1;
                                OFLOW_1 = 'b0;
                                end
                        end
                default: begin
                RESULT_REG = {RESULT_WIDTH{1'b0}};
                ERR_1 = 'b1;
                OFLOW_1 = 'b0;
                COUT_1 = 'b0;
                G_1 = 'b0;
                L_1 = 'b0;
                E_1 = 'b0;
                end

        endcase

        end //end if(IN_VALID == 'b10 )

        else begin
                RESULT_REG = {RESULT_WIDTH{1'b0}};
                ERR_1 = 'b0;
                OFLOW_1 = 'b0;
                COUT_1 = 'b0;
                G_1 = 'b0;
                L_1 = 'b0;
                E_1 = 'b0;
        end //end else [IN_VALID = 0]
        end //end if(MODE) Arithematic

        else begin //Logical
        if(IN_VALID_1 == 'b11) begin
        case(CMD_1)
                `AND: RESULT_REG = {1'b0, OPA_1 & OPB_1}; //AND
                `NAND: RESULT_REG = {1'b0, ~(OPA_1 & OPB_1)}; //NAND
                `OR: RESULT_REG = {1'b0, OPA_1 | OPB_1}; //OR
                `NOR: RESULT_REG = {1'b0, ~(OPA_1 | OPB_1)}; //NOR
                `XOR: RESULT_REG = {1'b0, OPA_1 ^ OPB_1}; //XOR
                `XNOR: RESULT_REG = {1'b0, ~(OPA_1 ^ OPB_1)}; //XNOR
                `ROL_A_B: begin //ROL_A_B
                        OPB_REG = OPB[rotate_amt-1 :0];
                        RESULT_REG = {1'b0, (OPA_1<<OPB_REG) | (OPA_1>>(DATA_WIDTH - OPB_REG))};
                        ERR_1 =(|(OPB_1[DATA_WIDTH-1 : rotate_amt]))? 1'b1 : 1'b0;

                        end
                `ROR_A_B: begin //ROL_A_B
                        OPB_REG = OPB[rotate_amt-1 :0];
                        RESULT_REG = {1'b0, (OPA_1>>OPB_REG) | (OPA_1<<(DATA_WIDTH - OPB_REG))};
                        ERR_1 =(|(OPB_1[DATA_WIDTH-1 : rotate_amt]))? 1'b1 : 1'b0;
                        end
                default: begin
                        RESULT_REG = {RESULT_WIDTH{1'b0}};
                        ERR_1 = 'b0;
                        OFLOW_1 = 'b0;
                        COUT_1 = 'b0;
                        G_1 = 'b0;
                        L_1 = 'b0;
                        E_1 = 'b0;
                end
        endcase
        end //end if(IN_VALID == 'b11)

        else if(IN_VALID_1 == 'b01 ) begin
        case(CMD_1)
                `NOT_A: RESULT_REG = ~OPA_1; //NOT_A
                `SHR1_B: RESULT_REG = {{(RESULT_WIDTH-DATA_WIDTH){1'b0}}, (OPA_1>>1)} ;//SHR1_A
                `SHL1_A: RESULT_REG = {{(RESULT_WIDTH-DATA_WIDTH){1'b0}}, (OPA_1<<1)} ;//SHL1_A

                default: begin
                        RESULT_REG = {RESULT_WIDTH{1'b0}};
                        ERR_1 = 'b1;
                        OFLOW_1 = 'b0;
                        COUT_1 = 'b0;
                        G_1 = 'b0;
                        L_1 = 'b0;
                        E_1 = 'b0;
                end
        endcase
        end //end if(IN_VALID == 'b01 )

        else if(IN_VALID_1 == 'b10) begin
        case(CMD_1)
                `NOT_B: RESULT_REG = ~OPB_1; //NOT_B
                `SHR1_B: RESULT_REG = {{(RESULT_WIDTH-DATA_WIDTH){1'b0}}, (OPB_1>>1)} ;//SHR1_B
                `SHL1_B: RESULT_REG = {{(RESULT_WIDTH-DATA_WIDTH){1'b0}}, (OPB_1<<1)} ;//SHL1_B

                default: begin
                        RESULT_REG = {RESULT_WIDTH{1'b0}};
                        ERR_1 = 'b1;
                        OFLOW_1 = 'b0;
                        COUT_1 = 'b0;
                        G_1 = 'b0;
                        L_1 = 'b0;
                        E_1 = 'b0;
                end
        endcase

        end //end if(IN_VALID == 'b10 )

        else begin
                        RESULT_REG = {RESULT_WIDTH{1'b0}};
                        ERR_1 = 'b1;
                        OFLOW_1 = 'b0;
                        COUT_1 = 'b0;
                        G_1 = 'b0;
                        L_1 = 'b0;
                        E_1 = 'b0;
        end //end else [IN_VALID = 0]

        end //end Logical



end //end always
endmodule

