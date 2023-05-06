`ifndef INTERNAL_DEFINES_VH_
`define INTERNAL_DEFINES_VH_
typedef enum logic [2:0] {
    PE0 = 'h0,
    PE1 = 'h1,
    PE2 = 'h2,
    PE3 = 'h3, 
    PE4 = 'h4,
    PE5 = 'h5,
    PE6 = 'h6,
    IN_OP = 'h7
} sel_op_t;

typedef enum logic [1:0] {
    ALU_AND = 2'b00,
    ALU_OR  = 2'b01,
    ALU_XOR = 2'b10,
    ALU_SLL = 2'b11
} alu_op_t;


typedef struct packed {
    sel_op_t sel_op_0; //select input to first operea
    sel_op_t sel_op_1;
    alu_op_t alu_op;
}ctrl_signals_t;

`endif