`timescale 1ns/1ps

module INTERFACE2 (
    input  [0:0]  SEL_EXTN,
    input  [3:0]  SEL_PERMW,
    input  [63:0] D0_EXTN,
    input  [63:0] D1_EXTN,
    input  [63:0] D2_EXTN,
    input  [63:0] D3_EXTN,
    input  [63:0] D4_EXTN,
    input  [63:0] D5_EXTN,
    input  [63:0] D6_EXTN,
    input  [63:0] D7_EXTN,
    input  [63:0] D8_EXTN,
    input  [63:0] D9_EXTN,
    input  [63:0] D10_EXTN,
    input  [63:0] D11_EXTN,
    input  [63:0] D12_EXTN,
    input  [63:0] D13_EXTN,
    input  [63:0] D14_EXTN,
    input  [63:0] D15_EXTN,
    input  [63:0] D0_HRMF,
    input  [63:0] D1_HRMF,
    input  [63:0] D2_HRMF,
    input  [63:0] D3_HRMF,
    input  [63:0] D4_HRMF,
    input  [63:0] D5_HRMF,
    input  [63:0] D6_HRMF,
    input  [63:0] D7_HRMF,
    input  [63:0] D8_HRMF,
    input  [63:0] D9_HRMF,
    input  [63:0] D10_HRMF,
    input  [63:0] D11_HRMF,
    input  [63:0] D12_HRMF,
    input  [63:0] D13_HRMF,
    input  [63:0] D14_HRMF,
    input  [63:0] D15_HRMF,
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

assign D[0]  = SEL_EXTN ? D0_HRMF  : D0_EXTN;
assign D[1]  = SEL_EXTN ? D1_HRMF  : D1_EXTN;
assign D[2]  = SEL_EXTN ? D2_HRMF  : D2_EXTN;
assign D[3]  = SEL_EXTN ? D3_HRMF  : D3_EXTN;
assign D[4]  = SEL_EXTN ? D4_HRMF  : D4_EXTN;
assign D[5]  = SEL_EXTN ? D5_HRMF  : D5_EXTN;
assign D[6]  = SEL_EXTN ? D6_HRMF  : D6_EXTN;
assign D[7]  = SEL_EXTN ? D7_HRMF  : D7_EXTN;
assign D[8]  = SEL_EXTN ? D8_HRMF  : D8_EXTN;
assign D[9]  = SEL_EXTN ? D9_HRMF  : D9_EXTN;
assign D[10] = SEL_EXTN ? D10_HRMF : D10_EXTN;
assign D[11] = SEL_EXTN ? D11_HRMF : D11_EXTN;
assign D[12] = SEL_EXTN ? D12_HRMF : D12_EXTN;
assign D[13] = SEL_EXTN ? D13_HRMF : D13_EXTN;
assign D[14] = SEL_EXTN ? D14_HRMF : D14_EXTN;
assign D[15] = SEL_EXTN ? D15_HRMF : D15_EXTN;

PERMW I_PERMW_0 (
    .SEL(SEL_PERMW),
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

module PERMW (
    input  wire [3:0]  SEL,
    input  wire [63:0] D0,
    input  wire [63:0] D1,
    input  wire [63:0] D2,
    input  wire [63:0] D3,
    input  wire [63:0] D4,
    input  wire [63:0] D5,
    input  wire [63:0] D6,
    input  wire [63:0] D7,
    input  wire [63:0] D8,
    input  wire [63:0] D9,
    input  wire [63:0] D10,
    input  wire [63:0] D11,
    input  wire [63:0] D12,
    input  wire [63:0] D13,
    input  wire [63:0] D14,
    input  wire [63:0] D15,
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
       4'd1 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14};
       4'd2 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13};
       4'd3 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12};
       4'd4 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11};
       4'd5 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10};
       4'd6 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8,D9};
       4'd7 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7,D8};
       4'd8 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6,D7};
       4'd9 :  {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5,D6};
       4'd10 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4,D5};
       4'd11 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3,D4};
       4'd12 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2,D3};
       4'd13 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1,D2};
       4'd14 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0,D1};
       4'd15 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15} = {D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D0};
    endcase
end

endmodule