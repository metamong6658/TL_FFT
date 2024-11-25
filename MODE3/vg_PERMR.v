`timescale 1ns/1ps

module PERMR (
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
       2'd1 : {Q0,Q1,Q2,Q3} = {D1,D2,D3,D0};
       2'd2 : {Q0,Q1,Q2,Q3} = {D2,D3,D0,D1};
       2'd3 : {Q0,Q1,Q2,Q3} = {D3,D0,D1,D2};
    endcase
end

endmodule