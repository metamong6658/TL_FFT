`timescale 1ns/1ps

module INTERFACE1 (
    input  [0:0]  SEL_ITR,
    input  [2:0]  SEL_PERMR,
    input  [63:0] D0_IOBUF,
    input  [63:0] D1_IOBUF,
    input  [63:0] D2_IOBUF,
    input  [63:0] D3_IOBUF,
    input  [63:0] D4_IOBUF,
    input  [63:0] D5_IOBUF,
    input  [63:0] D6_IOBUF,
    input  [63:0] D7_IOBUF,
    input  [63:0] D0_FSC,
    input  [63:0] D1_FSC,
    input  [63:0] D2_FSC,
    input  [63:0] D3_FSC,
    input  [63:0] D4_FSC,
    input  [63:0] D5_FSC,
    input  [63:0] D6_FSC,
    input  [63:0] D7_FSC,
    output [63:0] Q0,
    output [63:0] Q1,
    output [63:0] Q2,
    output [63:0] Q3,
    output [63:0] Q4,
    output [63:0] Q5,
    output [63:0] Q6,
    output [63:0] Q7
);

wire [63:0] D [0:7];

assign D[0] = SEL_ITR ? D0_FSC : D0_IOBUF;
assign D[1] = SEL_ITR ? D1_FSC : D1_IOBUF;
assign D[2] = SEL_ITR ? D2_FSC : D2_IOBUF;
assign D[3] = SEL_ITR ? D3_FSC : D3_IOBUF;
assign D[4] = SEL_ITR ? D4_FSC : D4_IOBUF;
assign D[5] = SEL_ITR ? D5_FSC : D5_IOBUF;
assign D[6] = SEL_ITR ? D6_FSC : D6_IOBUF;
assign D[7] = SEL_ITR ? D7_FSC : D7_IOBUF;


PERMR I_PERMR_0 (
    .SEL(SEL_PERMR),
    .D0(D[0]),
    .D1(D[1]),
    .D2(D[2]),
    .D3(D[3]),
    .D4(D[4]),
    .D5(D[5]),
    .D6(D[6]),
    .D7(D[7]),
    .Q0(Q0),
    .Q1(Q1),
    .Q2(Q2),
    .Q3(Q3),
    .Q4(Q4),
    .Q5(Q5),
    .Q6(Q6),
    .Q7(Q7)
);

endmodule

module PERMR (
    input  [2:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    input  [63:0] D2,
    input  [63:0] D3,
    input  [63:0] D4,
    input  [63:0] D5,
    input  [63:0] D6,
    input  [63:0] D7,
    output reg  [63:0] Q0,
    output reg  [63:0] Q1,
    output reg  [63:0] Q2,
    output reg  [63:0] Q3,
    output reg  [63:0] Q4,
    output reg  [63:0] Q5,
    output reg  [63:0] Q6,
    output reg  [63:0] Q7
);

always @(*) begin
    case (SEL)
       3'd0 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D0,D1,D2,D3,D4,D5,D6,D7};
       3'd1 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D1,D2,D3,D4,D5,D6,D7,D0};
       3'd2 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D2,D3,D4,D5,D6,D7,D0,D1};
       3'd3 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D3,D4,D5,D6,D7,D0,D1,D2};
       3'd4 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D4,D5,D6,D7,D0,D1,D2,D3};
       3'd5 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D5,D6,D7,D0,D1,D2,D3,D4};
       3'd6 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D6,D7,D0,D1,D2,D3,D4,D5};
       3'd7 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D7,D0,D1,D2,D3,D4,D5,D6};
    endcase
end

endmodule