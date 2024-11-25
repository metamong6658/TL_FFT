`timescale 1ns/1ps

module INTERFACE2 (
    input  [0:0] SEL_EXTN,
    input  [1:0] SEL_PERMW,
    input  [63:0] D0_EXTN,
    input  [63:0] D1_EXTN,
    input  [63:0] D2_EXTN,
    input  [63:0] D3_EXTN,
    input  [63:0] D0_HRMF,
    input  [63:0] D1_HRMF,
    input  [63:0] D2_HRMF,
    input  [63:0] D3_HRMF,
    output [63:0] Q0,
    output [63:0] Q1,
    output [63:0] Q2,
    output [63:0] Q3
);
    
wire [63:0] D [0:3];

assign D[0] = SEL_EXTN ? D0_HRMF : D0_EXTN;
assign D[1] = SEL_EXTN ? D1_HRMF : D1_EXTN;
assign D[2] = SEL_EXTN ? D2_HRMF : D2_EXTN;
assign D[3] = SEL_EXTN ? D3_HRMF : D3_EXTN;

PERMW I_PERMW_0 (
    .SEL(SEL_PERMW),
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

module PERMW (
    input  wire [1:0]  SEL,
    input  wire [63:0] D0,
    input  wire [63:0] D1,
    input  wire [63:0] D2,
    input  wire [63:0] D3,
    output reg  [63:0] Q0,
    output reg  [63:0] Q1,
    output reg  [63:0] Q2,
    output reg  [63:0] Q3
);

always @(*) begin
    case (SEL)
       2'd0 : {Q0,Q1,Q2,Q3} = {D0,D1,D2,D3};
       2'd1 : {Q0,Q1,Q2,Q3} = {D3,D0,D1,D2};
       2'd2 : {Q0,Q1,Q2,Q3} = {D2,D3,D0,D1};
       2'd3 : {Q0,Q1,Q2,Q3} = {D1,D2,D3,D0};
    endcase
end

endmodule