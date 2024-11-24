`timescale 1ns/1ps

module TFROM (
    input  [0:0]  CLK,
    input  [7:0]  EXP0,
    input  [7:0]  EXP1,
    input  [7:0]  EXP2,
    input  [7:0]  EXP3,
    output [63:0] TF0,
    output [63:0] TF1,
    output [63:0] TF2,
    output [63:0] TF3
);

// ROM
ROM I_ROM_U0 (
    .CLK(CLK),
    .ADDR(EXP0),
    .Q(TF0)
);

ROM I_ROM_U1 (
    .CLK(CLK),
    .ADDR(EXP1),
    .Q(TF1)
);

ROM I_ROM_U2 (
    .CLK(CLK),
    .ADDR(EXP2),
    .Q(TF2)
);

ROM I_ROM_U3 (
    .CLK(CLK),
    .ADDR(EXP3),
    .Q(TF3)
);

endmodule

module ROM (
    input  [0:0]  CLK,
    input  [7:0]  ADDR,
    output reg [63:0] Q
);

// INITIALIZATION for ROM modeling
localparam MEM_PATH = "../FILE/TF.hex";
reg [63:0] MEM [0:255];

initial begin
    $readmemh(MEM_PATH, MEM);
end

// ROM model
always @(posedge CLK) begin
    Q <= MEM[ADDR];
end

endmodule