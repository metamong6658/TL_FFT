`timescale 1ns/1ps

module INTERFACE1 (
    input  [0:0]  SEL_ITR,
    input  [1:0]  SEL_PERMR,
    input  [63:0] D0_IOBUF,
    input  [63:0] D1_IOBUF,
    input  [63:0] D2_IOBUF,
    input  [63:0] D3_IOBUF,
    input  [63:0] D0_FSC,
    input  [63:0] D1_FSC,
    input  [63:0] D2_FSC,
    input  [63:0] D3_FSC,
    output [63:0] Q0,
    output [63:0] Q1,
    output [63:0] Q2,
    output [63:0] Q3
);

wire [63:0] D [0:3];

assign D[0] = SEL_ITR ? D0_FSC : D0_IOBUF;
assign D[1] = SEL_ITR ? D1_FSC : D1_IOBUF;
assign D[2] = SEL_ITR ? D2_FSC : D2_IOBUF;
assign D[3] = SEL_ITR ? D3_FSC : D3_IOBUF;

PERMR I_PERMR_0 (
    .SEL(SEL_PERMR),
    .D0(D[0]),
    .D1(D[1]),
    .D2(D[2]),
    .D3(D[3]),
    .Q0(Q0),
    .Q1(Q1),
    .Q2(Q2),
    .Q3(Q3)
);

endmodule

module PERMR (
    input  [1:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    input  [63:0] D2,
    input  [63:0] D3,
    output reg  [63:0] Q0,
    output reg  [63:0] Q1,
    output reg  [63:0] Q2,
    output reg  [63:0] Q3
);

always @(*) begin
    case (SEL)
       2'd0 : {Q0,Q1,Q2,Q3} = {D0,D1,D2,D3};
       2'd1 : {Q0,Q1,Q2,Q3} = {D1,D2,D3,D0};
       2'd2 : {Q0,Q1,Q2,Q3} = {D2,D3,D0,D1};
       2'd3 : {Q0,Q1,Q2,Q3} = {D3,D0,D1,D2};
    endcase
end

endmodule