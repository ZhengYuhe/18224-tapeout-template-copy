`default_nettype none
module processor(
    input logic[11:0] instruction,
    input logic clock, reset,
    output logic [11:0] result
);
    logic[7:0] ctr_signals_s;
    logic [3:0] input_op0, input_op1;
    logic [1:0] sel_res, sel_pe;
    logic en_PE_ctr, en_PE_out, clear, instr_fault;

    scheduler control_unit(.*);
    
    logic en_PE_0, en_PE_out0, en_PE_1, en_PE_out1, en_PE_2, en_PE_out2, en_PE_3, en_PE_out3;
    logic[7:0]  ctr_signals_0, ctr_signals_1,ctr_signals_2,ctr_signals_3;

    demux #(4, $bits(en_PE_ctr)) en_PE_demux(.out({en_PE_0,en_PE_1,en_PE_2,en_PE_3}), 
                                             .in(en_PE_ctr), .sel(sel_pe));
    
    demux #(4, $bits(en_PE_out)) en_PE_out_demux(.out({en_PE_out0,en_PE_out1,en_PE_out2,en_PE_out3}), 
                                             .in(en_PE_out), .sel(sel_pe));

    demux #(4, $bits(ctr_signals_s)) en_PE_ctr_demux(.out({ctr_signals_0,ctr_signals_1,ctr_signals_2,ctr_signals_3}), 
                                             .in(ctr_signals_s), .sel(sel_pe));


    logic[3:0] PE_out_0,PE_out_1,PE_out_2,PE_out_3;
    logic[3:0] PE_reg_out_0,PE_reg_out_1,PE_reg_out_2,PE_reg_out_3;

    register #($bits(PE_out0), 'h0) PE_out_reg_0(.clock, .reset, .en(en_PE_out0), .clear(1'b0),
                                                 .D(PE_out0), .Q(PE_reg_out_0));
    register #($bits(PE_out1), 'h0) PE_out_reg_1(.clock, .reset, .en(en_PE_out1), .clear(1'b0),
                                                 .D(PE_out1), .Q(PE_reg_out_1));
    register #($bits(PE_out2), 'h0) PE_out_reg_2(.clock, .reset, .en(en_PE_out2), .clear(1'b0),
                                                 .D(PE_out2), .Q(PE_reg_out_2));
    register #($bits(PE_out3), 'h0) PE_out_reg_3(.clock, .reset, .en(en_PE_out3), .clear(1'b0),
                                                 .D(PE_out3), .Q(PE_reg_out_3));

    PE PE0(.ctrl_signals_in(ctr_signals_0), .en(en_PE_0) , .PE_out_a(4'h0), .out(PE_out_0), .*);
    PE PE1(.ctrl_signals_in(ctr_signals_1), .en(en_PE_1) , .PE_out_b(4'h0), .out(PE_out_1), .*);
    PE PE2(.ctrl_signals_in(ctr_signals_2), .en(en_PE_2) , .PE_out_c(4'h0), .out(PE_out_2), .*);
    PE PE3(.ctrl_signals_in(ctr_signals_3), .en(en_PE_3) , .PE_out_d(4'h0), .out(PE_out_3), .*);

    assign result = {8'h0, PE_reg_out_0};


endmodule: processor

module scheduler(
    input logic[11:0] instruction,
    input logic clock, reset,
    output logic[7:0] ctr_signals_s,
    output logic[3:0] input_op0, input_op1, 
    output logic[1:0] sel_res, sel_pe,
    output logic en_PE_ctr, en_PE_out, clear, instr_fault
    
);
    logic [1:0] PE_counter;
    logic [3:0] global_counter;
    logic [11:0] instr_fetched;
    register #($bits(instruction), 'h0) Instuction_Register(.clock, .reset, .en(1'b0), .clear(1'b0), 
                                        .D(instruction), .Q(instr_fetched));
    
    always_ff @(posedge clock, posedge reset) begin
        if (reset) begin
            PE_counter <= 2'b00;
            global_counter <= 3'b000;
        end 
        else begin
            PE_counter <= PE_counter + 1'b1;
            global_counter <= global_counter + 3'b001;
        end
            
    end

    //alu_op_t pe_alu_op;
    //sel_op_t pe_sel_op_imm;
    //assign  pe_alu_op = instruction[1:0];
    //assign  pe_sel_op_imm = 'h7;

    logic [2:0] pe_sel_op0, pe_sel_op1;
    logic [2:0] input_pe_0, input_pe_1;
    logic [1:0] pe_alu_op;
    logic use_imm_0, use_imm_1;

    assign pe_alu_op = instruction[1:0];
    assign ctr_signals_s = {pe_sel_op0,pe_sel_op1,pe_alu_op};

    //immediate as operand
    assign input_op0 = instruction[11:8];
    assign input_op1 = instruction[7:4];

    //other PE result as operand
    assign input_pe_0 = instruction[10:8];
    assign input_pe_1 = instruction[6:4];

    assign sel_res = PE_counter; //depending on global counter compared to PE counter
    assign sel_pe = PE_counter;
    assign en_PE_ctr = 1'b1;
    assign en_PE_out = 1'b0; //depending on global counter compared to PE counter
    
    assign use_imm_0 = instruction[3];
    assign use_imm_1 = instruction[2];

    always_comb begin
        pe_sel_op0 = 3'h7;
        pe_sel_op1 = 3'h7;
        clear = 1'b0;
        instr_fault = 1'b0;
        if (~use_imm_0) begin
            //cannot select PE7's ouput as operand
            if (input_pe_0 < global_counter) begin 
                pe_sel_op0 = input_pe_0;
            end else begin
                clear = 1'b1;
                instr_fault = 1'b1;
            end
        end

        if (~use_imm_1) begin
            //cannot select PE7's ouput as operand 
            if (input_pe_1 < global_counter) begin  
                pe_sel_op1 = input_pe_1;
            end else begin
                clear = 1'b1;
                instr_fault = 1'b1;
            end
        end


    end

endmodule: scheduler
