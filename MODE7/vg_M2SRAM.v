`timescale 1ns/1ps

module M2SRAM (
    input  [0:0]  CLK,
    input  [0:0]  WE,
    input  [4:0]  ADDR0,
    input  [4:0]  ADDR1,
    input  [63:0] D0,
    input  [63:0] D1,
    output [63:0] Q0,
    output [63:0] Q1
);

SRAM I_SRAM_0  (.CLK(CLK), .WE(WE), .ADDR(ADDR0),  .D(D0),  .Q(Q0));
SRAM I_SRAM_1  (.CLK(CLK), .WE(WE), .ADDR(ADDR1),  .D(D1),  .Q(Q1));

endmodule

module SRAM (
    input  [0:0]  CLK,
    input  [0:0]  WE,
    input  [4:0]  ADDR,
    input  [63:0] D,
    output [63:0] Q
);

reg [63:0] MEM [0:31];
reg [63:0] T;

always @(posedge CLK) begin
    if(WE) MEM[ADDR] <= D;
    else   T <= MEM[ADDR];
end

assign Q = T;

endmodule