`timescale 1ns/1ps

module HRMF (
    // CONTROL
    input [0:0] CLK,
    input [0:0] RSTn,
    // INPUT
    input [63:0] D0,
    input [63:0] D1,
    input [63:0] D2,
    input [63:0] D3,
    input [63:0] TF1,
    input [63:0] TF2,
    input [63:0] TF3,
    // OUTPUT
    output [63:0] Q0,
    output [63:0] Q1,
    output [63:0] Q2,
    output [63:0] Q3
);

wire [63:0] X [0:3];

// R4BFU
R4BFU I_R4BFU_0 (
    .D0(D0),
    .D1(D1),
    .D2(D2),
    .D3(D3),
    .Q0(X[0]),
    .Q1(X[1]),
    .Q2(X[2]),
    .Q3(X[3])
);

//////////////////////// ROTATOR ////////////////////////////////
// In our paper, the rotations are not illustrated well.       //
// Actually, our HRMF utilizes special rotation technique.     //
// Except Final high-radix butterfly, we perform rotations     //
// using constant rotators to mitigate complex multipliers and //
// twiddle factor rom's overhead.                              //
/////////////////////////////////////////////////////////////////

// ROTATOR
ROTATOR I_ROTATOR_0 (
    .D0(X[0]),
    .D1(X[1]),
    .D2(X[2]),
    .D3(X[3]),
    .TF1(TF1),
    .TF2(TF2),
    .TF3(TF3),
    .Q0(Q0),
    .Q1(Q1),
    .Q2(Q2),
    .Q3(Q3)
);

endmodule

/////////////////////// INSTANCE ///////////////////////

// Radix-4 Butterfly
module R4BFU (
    input  [63:0] D0,
    input  [63:0] D1,
    input  [63:0] D2,
    input  [63:0] D3,
    output [63:0] Q0,
    output [63:0] Q1,
    output [63:0] Q2,
    output [63:0] Q3
);

wire [63:0] T0, T1, T2, T3;
R2BFU I_R2BFU_0 (.D0(D0),.D1(D2),.Q0(T0),.Q1(T2));
R2BFU I_R2BFU_1 (.D0(D1),.D1(D3),.Q0(T1),.Q1(T3));

wire [63:0] T3_ = {T3[31:0],~T3[63:32]+1'b1};

// Q1 and Q2 are switchined alongside bit-reverse property
R2BFU I_R2BFU_2 (.D0(T0),.D1(T1), .Q0(Q0),.Q1(Q2));
R2BFU I_R2BFU_3 (.D0(T2),.D1(T3_),.Q0(Q1),.Q1(Q3));

endmodule

// Radix-2 Butterfly
module R2BFU (
    input  [63:0] D0,
    input  [63:0] D1,
    output [63:0] Q0,
    output [63:0] Q1
);

wire [63:0] T1 = {~D1[63:32]+1'b1, ~D1[31:0]+1'b1};

CADD32 I_CADD32_0 (.D0(D0), .D1(D1), .Q(Q0));
CADD32 I_CADD32_1 (.D0(D0), .D1(T1), .Q(Q1));

endmodule

/////////////////////// SUB BLOCK ///////////////////////

// Complex Multiplier
module CMUL32 (
    input  [63:0] D0, // DATA
    input  [63:0] D1, // TWIDDLE FACTOR
    output [63:0] Q
);

// Please note that
// Data is modeled as (REAL) + j(IMAG)
// Twiddle Factor is modeled as (COS) - j(SIN)

wire [31:0] T0, T1, T2, T3;

MUL32 I_MUL32_0 (.D0(D0[63:32]), .D1(D1[63:32]), .Q(T0));
MUL32 I_MUL32_1 (.D0(D0[31:0]),  .D1(D1[31:0]),  .Q(T1));
MUL32 I_MUL32_2 (.D0(D0[31:0]),  .D1(D1[63:32]), .Q(T2));
MUL32 I_MUL32_3 (.D0(D0[63:32]), .D1(D1[31:0]),  .Q(T3));

ADD32 I_ADD32_0 (.D0(T0), .D1(T1),       .Q(Q[63:32]));
ADD32 I_ADD32_1 (.D0(T2), .D1(~T3+1'b1), .Q(Q[31:0]));

endmodule

// Complex Adder
module CADD32 (
    input  [63:0] D0,
    input  [63:0] D1,
    output [63:0] Q
);

ADD32 I_ADD32_0 (.D0(D0[63:32]), .D1(D1[63:32]), .Q(Q[63:32]));
ADD32 I_ADD32_1 (.D0(D0[31:0]),  .D1(D1[31:0]),  .Q(Q[31:0]));

endmodule

// Multipler
module MUL32 (
    input  signed [31:0] D0,
    input  signed [31:0] D1,
    output signed [31:0] Q
);

wire signed [63:0] T = D0 * D1;
assign Q = T[47:16];

endmodule

// Adder
module ADD32 (
    input  [31:0] D0,
    input  [31:0] D1,
    output [31:0] Q
);

assign Q = D0 + D1;

endmodule

module ROTATOR (
    input [63:0] D0,
    input [63:0] D1,
    input [63:0] D2,
    input [63:0] D3,
    input [63:0] TF0,
    input [63:0] TF1,
    input [63:0] TF2,
    input [63:0] TF3,
    input [63:0] Q0,
    input [63:0] Q1,
    input [63:0] Q2,
    input [63:0] Q3
);

assign Q0 = D0;

CMUL32 I_CMUL32_1 (
    .D0(D1),  // DATA
    .D1(TF1), // TWIDDLE FACTOR
    .Q(Q1)
);

CMUL32 I_CMUL32_2 (
    .D0(D2),  // DATA
    .D1(TF2), // TWIDDLE FACTOR
    .Q(Q2)
);

CMUL32 I_CMUL32_3 (
    .D0(D3),  // DATA
    .D1(TF3), // TWIDDLE FACTOR
    .Q(Q3)
);

endmodule

// END