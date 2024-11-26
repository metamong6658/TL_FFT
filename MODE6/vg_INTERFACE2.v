`timescale 1ns/1ps

module INTERFACE2 (
    input  [0:0]  SEL_EXTN,
    input  [0:0]  SEL_PERMW,
    input  [63:0] D0_EXTN,
    input  [63:0] D1_EXTN,
    input  [63:0] D0_HRMF,
    input  [63:0] D1_HRMF,
    output [63:0] Q0,
    output [63:0] Q1
);
    
wire [63:0] D [0:1];

assign D[0]  = SEL_EXTN ? D0_HRMF  : D0_EXTN;
assign D[1]  = SEL_EXTN ? D1_HRMF  : D1_EXTN;

PERMW I_PERMW_0 (
    .SEL(SEL_PERMW),
    .D0(D[0]),
    .D1(D[1]),
    .Q0(Q0),
    .Q1(Q1)
);

endmodule

module PERMW (
    input  [0:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    output reg  [63:0] Q0,
    output reg  [63:0] Q1
);

always @(*) begin
    case (SEL)
       1'd0 :  {Q0,Q1} = {D0,D1};
       1'd1 :  {Q0,Q1} = {D1,D0};
    endcase
end

endmodule