`default_nettype none

module mux
    #(parameter INPUTS=0, WIDTH=0)
    (input  logic [INPUTS-1:0][WIDTH-1:0]   in,
     input  logic [$clog2(INPUTS)-1:0]      sel,
     output logic [WIDTH-1:0]               out);

    assign out = in[sel];

endmodule: mux

module demux
    #(parameter OUTPUTS=0, WIDTH=0)
    (input  logic [WIDTH-1:0]               in,
     input  logic [$clog2(OUTPUTS)-1:0]     sel,
     output logic [OUTPUTS-1:0][WIDTH-1:0]  out);
 
    always_comb begin
        for (int i = 0; i < NUM_OUTPUTS; i++) begin
            out[i] = (i == sel) ? in : 'b0;
        end
    end
endmodule: demux


module register
   #(parameter                      WIDTH=0,
     parameter logic [WIDTH-1:0]    RESET_VAL='b0)
    (input  logic               clock, en, reset, clear,
     input  logic [WIDTH-1:0]   D,
     output logic [WIDTH-1:0]   Q);

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            Q <= RESET_VAL;
        else if (clear)
            Q <= RESET_VAL;
        else if (en)
            Q <= D;
     end

endmodule:register