`timescale 1ns/1ps

module M16SRAM (
    input  [0:0]  CLK,
    input  [0:0]  WE,
    input  [11:0] ADDR0,
    input  [11:0] ADDR1,
    input  [11:0] ADDR2,
    input  [11:0] ADDR3,
    input  [11:0] ADDR4,
    input  [11:0] ADDR5,
    input  [11:0] ADDR6,
    input  [11:0] ADDR7,
    input  [11:0] ADDR8,
    input  [11:0] ADDR9,
    input  [11:0] ADDR10,
    input  [11:0] ADDR11,
    input  [11:0] ADDR12,
    input  [11:0] ADDR13,
    input  [11:0] ADDR14,
    input  [11:0] ADDR15,
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

SRAM I_SRAM_0  (.CLK(CLK), .WE(WE), .ADDR(ADDR0),  .D(D0),  .Q(Q0));
SRAM I_SRAM_1  (.CLK(CLK), .WE(WE), .ADDR(ADDR1),  .D(D1),  .Q(Q1));
SRAM I_SRAM_2  (.CLK(CLK), .WE(WE), .ADDR(ADDR2),  .D(D2),  .Q(Q2));
SRAM I_SRAM_3  (.CLK(CLK), .WE(WE), .ADDR(ADDR3),  .D(D3),  .Q(Q3));
SRAM I_SRAM_4  (.CLK(CLK), .WE(WE), .ADDR(ADDR4),  .D(D4),  .Q(Q4));
SRAM I_SRAM_5  (.CLK(CLK), .WE(WE), .ADDR(ADDR5),  .D(D5),  .Q(Q5));
SRAM I_SRAM_6  (.CLK(CLK), .WE(WE), .ADDR(ADDR6),  .D(D6),  .Q(Q6));
SRAM I_SRAM_7  (.CLK(CLK), .WE(WE), .ADDR(ADDR7),  .D(D7),  .Q(Q7));
SRAM I_SRAM_8  (.CLK(CLK), .WE(WE), .ADDR(ADDR8),  .D(D8),  .Q(Q8));
SRAM I_SRAM_9  (.CLK(CLK), .WE(WE), .ADDR(ADDR9),  .D(D9),  .Q(Q9));
SRAM I_SRAM_10 (.CLK(CLK), .WE(WE), .ADDR(ADDR10), .D(D10), .Q(Q10));
SRAM I_SRAM_11 (.CLK(CLK), .WE(WE), .ADDR(ADDR11), .D(D11), .Q(Q11));
SRAM I_SRAM_12 (.CLK(CLK), .WE(WE), .ADDR(ADDR12), .D(D12), .Q(Q12));
SRAM I_SRAM_13 (.CLK(CLK), .WE(WE), .ADDR(ADDR13), .D(D13), .Q(Q13));
SRAM I_SRAM_14 (.CLK(CLK), .WE(WE), .ADDR(ADDR14), .D(D14), .Q(Q14));
SRAM I_SRAM_15 (.CLK(CLK), .WE(WE), .ADDR(ADDR15), .D(D15), .Q(Q15));

endmodule

module SRAM (
    input  [0:0]  CLK,
    input  [0:0]  WE,
    input  [11:0] ADDR,
    input  [63:0] D,
    output [63:0] Q
);

reg [63:0] MEM [0:4095];
reg [63:0] T;

always @(posedge CLK) begin
    if(WE) MEM[ADDR] <= D;
    else   T <= MEM[ADDR];
end

assign Q = T;

endmodule