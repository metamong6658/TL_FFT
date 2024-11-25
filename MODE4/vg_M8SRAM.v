`timescale 1ns/1ps

module M8SRAM (
    input  [0:0]  CLK,
    input  [0:0]  WE,
    input  [8:0]  ADDR0,
    input  [8:0]  ADDR1,
    input  [8:0]  ADDR2,
    input  [8:0]  ADDR3,
    input  [8:0]  ADDR4,
    input  [8:0]  ADDR5,
    input  [8:0]  ADDR6,
    input  [8:0]  ADDR7,
    input  [63:0] D0,
    input  [63:0] D1,
    input  [63:0] D2,
    input  [63:0] D3,
    input  [63:0] D4,
    input  [63:0] D5,
    input  [63:0] D6,
    input  [63:0] D7,
    output [63:0] Q0,
    output [63:0] Q1,
    output [63:0] Q2,
    output [63:0] Q3,
    output [63:0] Q4,
    output [63:0] Q5,
    output [63:0] Q6,
    output [63:0] Q7
);

SRAM I_SRAM_0 (
    .CLK(CLK),
    .WE(WE),
    .ADDR(ADDR0),
    .D(D0),
    .Q(Q0)
);

SRAM I_SRAM_1 (
    .CLK(CLK),
    .WE(WE),
    .ADDR(ADDR1),
    .D(D1),
    .Q(Q1)
);

SRAM I_SRAM_2 (
    .CLK(CLK),
    .WE(WE),
    .ADDR(ADDR2),
    .D(D2),
    .Q(Q2)
);

SRAM I_SRAM_3 (
    .CLK(CLK),
    .WE(WE),
    .ADDR(ADDR3),
    .D(D3),
    .Q(Q3)
);

SRAM I_SRAM_4 (
    .CLK(CLK),
    .WE(WE),
    .ADDR(ADDR4),
    .D(D4),
    .Q(Q4)
);

SRAM I_SRAM_5 (
    .CLK(CLK),
    .WE(WE),
    .ADDR(ADDR5),
    .D(D5),
    .Q(Q5)
);

SRAM I_SRAM_6 (
    .CLK(CLK),
    .WE(WE),
    .ADDR(ADDR6),
    .D(D6),
    .Q(Q6)
);

SRAM I_SRAM_7 (
    .CLK(CLK),
    .WE(WE),
    .ADDR(ADDR7),
    .D(D7),
    .Q(Q7)
);

endmodule

module SRAM (
    input  [0:0]  CLK,
    input  [0:0]  WE,
    input  [8:0]  ADDR,
    input  [63:0] D,
    output [63:0] Q
);

reg [63:0] MEM [0:511];
reg [63:0] T;

always @(posedge CLK) begin
    if(WE) MEM[ADDR] <= D;
    else   T <= MEM[ADDR];
end

assign Q = T;

endmodule