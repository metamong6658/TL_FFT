`timescale 1ns/1ps

module TFROM (
    input  [0:0]  CLK,
    input  [11:0] EXP0,
    input  [11:0] EXP1,
    input  [11:0] EXP2,
    input  [11:0] EXP3,
    input  [11:0] EXP4,
    input  [11:0] EXP5,
    input  [11:0] EXP6,
    input  [11:0] EXP7,
    output [63:0] TF0,
    output [63:0] TF1,
    output [63:0] TF2,
    output [63:0] TF3,
    output [63:0] TF4,
    output [63:0] TF5,
    output [63:0] TF6,
    output [63:0] TF7
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

ROM I_ROM_U4 (
    .CLK(CLK),
    .ADDR(EXP4),
    .Q(TF4)
);

ROM I_ROM_U5 (
    .CLK(CLK),
    .ADDR(EXP5),
    .Q(TF5)
);

ROM I_ROM_U6 (
    .CLK(CLK),
    .ADDR(EXP6),
    .Q(TF6)
);

ROM I_ROM_U7 (
    .CLK(CLK),
    .ADDR(EXP7),
    .Q(TF7)
);

endmodule

module ROM (
    input  [0:0]  CLK,
    input  [11:0] ADDR,
    output reg [63:0] Q
);

// INITIALIZATION for ROM modeling
localparam MEM_PATH = "../FILE/TF.hex";
reg [63:0] MEM [0:4095];

initial begin
    $readmemh(MEM_PATH, MEM);
end

// ROM model
always @(posedge CLK) begin
    Q <= MEM[ADDR];
end

endmodule