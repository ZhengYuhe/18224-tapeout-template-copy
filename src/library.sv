`default_nettype none

module mux
    #(parameter INPUTS=8, WIDTH=4)
    (input  logic [31:0] in,
     input  logic [$clog2(INPUTS)-1:0]      sel,
     output logic [WIDTH-1:0]               out);

    logic [5:0] base, top;
    assign base = {'b0, sel} << 2;
    assign top = base + 'h3;
    assign out = in[top:base];

endmodule: mux

module demux
    #(parameter OUTPUTS=4, WIDTH=0)
    (input  logic [WIDTH-1:0]               in,
     input  logic [$clog2(OUTPUTS)-1:0]     sel,
     output logic [OUTPUTS*WIDTH-1:0] out);
 
    logic [OUTPUTS*WIDTH-1:0] temp;
    assign temp[WIDTH-1:0] = in;
    assign out = temp << (sel * WIDTH);
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
