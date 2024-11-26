`timescale 1ns/1ps

module INTERFACE1 (
    input  [0:0]  SEL_ITR,
    input  [0:0]  SEL_PERMR,
    input  [63:0] D0_IOBUF,
    input  [63:0] D1_IOBUF,
    input  [63:0] D0_FSC,
    input  [63:0] D1_FSC,
    output [63:0] Q0,
    output [63:0] Q1
);

wire [63:0] D [0:1];

assign D[0]  = SEL_ITR ? D0_FSC  : D0_IOBUF;
assign D[1]  = SEL_ITR ? D1_FSC  : D1_IOBUF;

PERMR I_PERMR_0 (
    .SEL(SEL_PERMR),
    .D0(D[0]),
    .D1(D[1]),
    .Q0(Q0),
    .Q1(Q1)
);

endmodule

module PERMR (
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