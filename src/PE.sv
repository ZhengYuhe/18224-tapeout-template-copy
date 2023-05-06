`default_nettype none
module PE(
    input  logic         clock, en, reset,
    input  logic[7:0]    ctrl_signals_in,
    input  logic [3:0]   PE_out_a,PE_out_b,PE_out_c,PE_out_d, 
    input  logic [3:0]   in_op_0, in_op_1,
    input  logic [3:0]   PE_reg_out_0,PE_reg_out_1,PE_reg_out_2,
    output logic [3:0]   out
);

    logic[7:0] ctrl_signals;
    logic [3:0] operand0, operand1, alu_src0, alu_src1;
    logic [3:0] sel_op_0, sel_op_1;
    logic [1:0] alu_op;

    assign alu_op = ctrl_signals[1:0];
    assign sel_op_1 = ctrl_signals[4:2];
    assign sel_op_0 = ctrl_signals[7:5];


    register #($bits(ctrl_signals), 'h0) Ctrl_Register(.clock, .reset, .en, .clear(1'b0), 
                                        .D(ctrl_signals_in), .Q(ctrl_signals));
    mux #(8, $bits(in_op_0)) alu_src0_mux(.in({PE_out_a,PE_out_b,PE_out_c,PE_out_d, PE_reg_out_0,PE_reg_out1,PE_reg_out2, in_op_0}), 
                                          .sel(sel_op_0), .out(operand0));
    mux #(8, $bits(in_op_1)) alu_src1_mux(.in({PE_out_a,PE_out_b,PE_out_c,PE_out_d, PE_reg_out_0,PE_reg_out1,PE_reg_out2, in_op_1}), 
                                          .sel(sel_op_1), .out(operand1));
    
    register #($bits(operand0), 'h0) alu_sr0_reg(.clock, .reset, .en, .clear(1'b0),
                                                 .D(operand0), .Q(alu_src0));
    register #($bits(operand0), 'h0) alu_sr1_reg(.clock, .reset, .en, .clear(1'b0),
                                                 .D(operand1), .Q(alu_src1));
                                                 
    alu ALU(.alu_src0, .alu_src1, .alu_op(alu_op), .alu_out(out));

endmodule: PE


module alu (
    input  logic [3:0]    alu_src0,
    input  logic [3:0]    alu_src1,
    input  logic [1:0]    alu_op,
    output logic [3:0]    alu_out
);
    logic [1:0] left_shift_by;
    assign left_shift_by = alu_src2[1:0];
    always_comb begin
        unique case (alu_op)
            2'b00: alu_out = alu_src1 | alu_src2; 
            2'b01: alu_out = alu_src1 & alu_src2;
            2'b10: alu_out = alu_src1 ^ alu_src2;
            2'b11: alu_out = alu_src1 << left_shift_by;
            default: alu_out = 4'b0000;
        endcase
    end
endmodule: alu
