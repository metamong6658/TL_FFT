`timescale 1ns/1ps

module TFROM (
    input  [0:0]  CLK,
    input  [5:0]  EXP0,
    input  [5:0]  EXP1,
    output [63:0] TF0,
    output [63:0] TF1
);

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

endmodule

module ROM (
    input  [0:0]  CLK,
    input  [5:0]  ADDR,
    output reg [63:0] Q
);

// INITIALIZATION for ROM modeling
localparam MEM_PATH = "../FILE/TF.hex";
reg [63:0] MEM [0:63];

initial begin
    $readmemh(MEM_PATH, MEM);
end

// ROM model
always @(posedge CLK) begin
    Q <= MEM[ADDR];
end

endmodule
