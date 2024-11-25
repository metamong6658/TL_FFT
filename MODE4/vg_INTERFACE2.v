`timescale 1ns/1ps

module INTERFACE2 (
    input  [0:0]  SEL_EXTN,
    input  [2:0]  SEL_PERMW,
    input  [63:0] D0_EXTN,
    input  [63:0] D1_EXTN,
    input  [63:0] D2_EXTN,
    input  [63:0] D3_EXTN,
    input  [63:0] D4_EXTN,
    input  [63:0] D5_EXTN,
    input  [63:0] D6_EXTN,
    input  [63:0] D7_EXTN,
    input  [63:0] D0_HRMF,
    input  [63:0] D1_HRMF,
    input  [63:0] D2_HRMF,
    input  [63:0] D3_HRMF,
    input  [63:0] D4_HRMF,
    input  [63:0] D5_HRMF,
    input  [63:0] D6_HRMF,
    input  [63:0] D7_HRMF,
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

assign D[0] = SEL_EXTN ? D0_HRMF : D0_EXTN;
assign D[1] = SEL_EXTN ? D1_HRMF : D1_EXTN;
assign D[2] = SEL_EXTN ? D2_HRMF : D2_EXTN;
assign D[3] = SEL_EXTN ? D3_HRMF : D3_EXTN;
assign D[4] = SEL_EXTN ? D4_HRMF : D4_EXTN;
assign D[5] = SEL_EXTN ? D5_HRMF : D5_EXTN;
assign D[6] = SEL_EXTN ? D6_HRMF : D6_EXTN;
assign D[7] = SEL_EXTN ? D7_HRMF : D7_EXTN;


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

module PERMW (
    input  wire [2:0]  SEL,
    input  wire [63:0] D0,
    input  wire [63:0] D1,
    input  wire [63:0] D2,
    input  wire [63:0] D3,
    input  wire [63:0] D4,
    input  wire [63:0] D5,
    input  wire [63:0] D6,
    input  wire [63:0] D7,
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
       3'd1 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D7,D0,D1,D2,D3,D4,D5,D6};
       3'd2 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D6,D7,D0,D1,D2,D3,D4,D5};
       3'd3 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D5,D6,D7,D0,D1,D2,D3,D4};
       3'd4 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D4,D5,D6,D7,D0,D1,D2,D3};
       3'd5 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D3,D4,D5,D6,D7,D0,D1,D2};
       3'd6 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D2,D3,D4,D5,D6,D7,D0,D1};
       3'd7 : {Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7} = {D1,D2,D3,D4,D5,D6,D7,D0};
    endcase
end

endmodule