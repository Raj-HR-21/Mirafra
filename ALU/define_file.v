`define ADD 'b0000
`define SUB 'b0001
`define ADD_CIN 'b0010
`define SUB_CIN 'b0011
`define INC_A 'b0100
`define DEC_A 'b0101
`define INC_B 'b0110
`define DEC_B 'b0111
`define CMP 'b1000
`define MUL1 'b1001 //INC_A * INC_B
`define MUL2 'b1010 //A<<1 * B
`define ADD_SIGNED 'b1011
`define SUB_SIGNED 'b1100

`define AND 'b0000
`define NAND 'b0001
`define OR 'b0010
`define NOR 'b0011
`define XOR 'b0100
`define XNOR 'b0101
`define NOT_A 'b0110
`define NOT_B 'b0111
`define SHR1_A 'b1000
`define SHL1_A 'b1001
`define SHR1_B 'b1010
`define SHL1_B 'b1011
`define ROL_A_B 'b1100
`define ROR_A_B 'b1101