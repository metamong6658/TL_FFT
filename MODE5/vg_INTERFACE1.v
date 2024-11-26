`timescale 1ns/1ps

module INTERFACE1 (
    input  [0:0]  SEL_ITR,
    input  [3:0]  SEL_PERMR,
    input  [63:0] D0_IOBUF,
    input  [63:0] D1_IOBUF,
    input  [63:0] D2_IOBUF,
    input  [63:0] D3_IOBUF,
    input  [63:0] D4_IOBUF,
    input  [63:0] D5_IOBUF,
    input  [63:0] D6_IOBUF,
    input  [63:0] D7_IOBUF,
    input  [63:0] D8_IOBUF,
    input  [63:0] D9_IOBUF,
    input  [63:0] D10_IOBUF,
    input  [63:0] D11_IOBUF,
    input  [63:0] D12_IOBUF,
    input  [63:0] D13_IOBUF,
    input  [63:0] D14_IOBUF,
    input  [63:0] D15_IOBUF,
    input  [63:0] D0_FSC,
    input  [63:0] D1_FSC,
    input  [63:0] D2_FSC,
    input  [63:0] D3_FSC,
    input  [63:0] D4_FSC,
    input  [63:0] D5_FSC,
    input  [63:0] D6_FSC,
    input  [63:0] D7_FSC,
    input  [63:0] D8_FSC,
    input  [63:0] D9_FSC,
    input  [63:0] D10_FSC,
    input  [63:0] D11_FSC,
    input  [63:0] D12_FSC,
    input  [63:0] D13_FSC,
    input  [63:0] D14_FSC,
    input  [63:0] D15_FSC,
    output [63:0] Q0,
    output [63:0] Q1,
    output [63:0] Q2,
    output [63:0] Q3,
    output [63:0] Q4,
    output [63:0] Q5,
    output [63:0] Q6,
    output [63:0] Q7,
    output [63:0] Q8,
    output [63:0] Q9,
    output [63:0] Q10,
    output [63:0] Q11,
    output [63:0] Q12,
    output [63:0] Q13,
    output [63:0] Q14,
    output [63:0] Q15
);

wire [63:0] D [0:15];

assign D[0]  = SEL_ITR ? D0_FSC  : D0_IOBUF;
assign D[1]  = SEL_ITR ? D1_FSC  : D1_IOBUF;
assign D[2]  = SEL_ITR ? D2_FSC  : D2_IOBUF;
assign D[3]  = SEL_ITR ? D3_FSC  : D3_IOBUF;
assign D[4]  = SEL_ITR ? D4_FSC  : D4_IOBUF;
assign D[5]  = SEL_ITR ? D5_FSC  : D5_IOBUF;
assign D[6]  = SEL_ITR ? D6_FSC  : D6_IOBUF;
assign D[7]  = SEL_ITR ? D7_FSC  : D7_IOBUF;
assign D[8]  = SEL_ITR ? D8_FSC  : D8_IOBUF;
assign D[9]  = SEL_ITR ? D9_FSC  : D9_IOBUF;
assign D[10] = SEL_ITR ? D10_FSC : D10_IOBUF;
assign D[11] = SEL_ITR ? D11_FSC : D11_IOBUF;
assign D[12] = SEL_ITR ? D12_FSC : D12_IOBUF;
assign D[13] = SEL_ITR ? D13_FSC : D13_IOBUF;
assign D[14] = SEL_ITR ? D14_FSC : D14_IOBUF;
assign D[15] = SEL_ITR ? D15_FSC : D15_IOBUF;


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
    .D8(D[8]),
    .D9(D[9]),
    .D10(D[10]),
    .D11(D[11]),
    .D12(D[12]),
    .D13(D[13]),
    .D14(D[14]),
    .D15(D[15]),
    .Q0(Q0),
    .Q1(Q1),
    .Q2(Q2),
    .Q3(Q3),
    .Q4(Q4),
    .Q5(Q5),
    .Q6(Q6),
    .Q7(Q7),
    .Q8(Q8),
    .Q9(Q9),
    .Q10(Q10),
    .Q11(Q11),
    .Q12(Q12),
    .Q13(Q13),
    .Q14(Q14),
    .Q15(Q15)
);

endmodule

module PERMR (
    input  [3:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    input  [63:0] D2,
    input  [63:0] D3,
    input  [63:0] D4,
    input  [63:0] D5,
    input  [63:0] D6,
    input  [63:0] D7,
    input  [63:0] D8,
    input  [63:0] D9,
    input  [63:0] D10,
    input  [63:0] D11,
    input  [63:0] D12,
    input  [63:0] D13,
    input  [63:0] D14,
    input  [63:0] D15,
    output reg  [63:0] Q0,
    output reg  [63:0] Q1,
    output reg  [63:0] Q2,
    output reg  [63:0] Q3,
    output reg  [63:0] Q4,
    output reg  [63:0] Q5,
    output reg  [63:0] Q6,
    output reg  [63:0] Q7,
    output reg  [63:0] Q8,
    output reg  [63:0] Q9,
    output reg  [63:0] Q10,
    output reg  [63:0] Q11,
    output reg  [63:0] Q12,
    output reg  [63:0] Q13,
    output reg  [63:0] Q14,
    output reg  [63:0] Q15
);

always @(*) begin
    case (SEL)
       4'd0 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15};
       4'd1 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0};
       4'd2 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1};
       4'd3 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2};
       4'd4 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3};
       4'd5 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4};
       4'd6 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5};
       4'd7 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6};
       4'd8 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7};
       4'd9 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8};
       4'd10 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9};
       4'd11 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10};
       4'd12 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11};
       4'd13 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12};
       4'd14 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13};
       4'd15 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14};
    endcase
end

endmodule