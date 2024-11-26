`timescale 1ns/1ps

module MDCFFT (
    // CONTROL
    input [0:0] CLK,
    input [0:0] RSTn,
    input [0:0] SEL_MDCFFT,
    // INPUT
    input [63:0] D0,
    input [63:0] D1,
    input [63:0] TF0,
    input [63:0] TF1,
    // OUTPUT
    output [63:0] Q0,
    output [63:0] Q1
);

wire [63:0] X [0:1];
wire [63:0] Y [0:1];
wire [63:0] Z [0:1];
wire [63:0] T [0:1];

// R2BFU
R2BFU I_R2BFU_0 (
    .D0(D0),
    .D1(D1),
    .Q0(X[0]),
    .Q1(X[1])
);

//////////////////////// ROTATOR ////////////////////////////////
// In our paper, the rotations are not illustrated well.       //
// Actually, our HRMF utilizes special rotation technique.     //
// Except Final high-radix butterfly, we perform rotations     //
// using constant rotators to mitigate complex multipliers and //
// twiddle factor rom's overhead.                              //
/////////////////////////////////////////////////////////////////

// ROTATOR0
ROTATOR0 I_ROTATOR0_0 (
    .SEL(SEL_MDCFFT),
    .D0(X[0]),
    .D1(X[1]),
    .Q0(Y[0]),
    .Q1(Y[1])
);

// 1D MDC
MDC1 I_MDC1_0 (
    .CLK(CLK),
    .RSTn(RSTn),
    .SEL(SEL_MDCFFT),
    .D0(Y[0]),
    .D1(Y[1]),
    .Q0(Z[0]),
    .Q1(Z[1])
);

// R2BFU
R2BFU I_R2BFU_1 (
    .D0(Z[0]),
    .D1(Z[1]),
    .Q0(T[0]),
    .Q1(T[1])
);

// ROTATOR1
ROTATOR1 I_ROTATOR1_0 (
    .D0(T[0]),
    .D1(T[1]),
    .TF0(TF0),
    .TF1(TF1),
    .Q0(Q0),
    .Q1(Q1)
);

endmodule

/////////////////////// BUTTERFLY ///////////////////////
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

/////////////////////// ROTATOR ///////////////////////
// 1st ROT
module ROTATOR0 (
    input  [0:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    output [63:0] Q0,
    output [63:0] Q1
);

wire [63:0] X1;

// p = 0
assign Q0 = D0;

// p = 1
W4E1 I_W4E1_0 (.D(D1), .Q(X1));
assign  Q1  = SEL ? X1 : D1;

endmodule

// 2nd ROT
module ROTATOR1 (
    input  [63:0] D0,
    input  [63:0] D1,
    input  [63:0] TF0,
    input  [63:0] TF1,
    output [63:0] Q0,
    output [63:0] Q1
);

CMUL32 I_CMUL32_0  (.D0(D0), .D1(TF0), .Q(Q0));
CMUL32 I_CMUL32_1  (.D0(D1), .D1(TF1), .Q(Q1));

endmodule

/////////////////////// SUB BLOCK ///////////////////////
// 1D MDC
module MDC1 (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [0:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    output [63:0] Q0,
    output [63:0] Q1
);

reg  [63:0] T  [0:1];
wire [63:0] T_ [0:1];

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) T[0] <= {64{1'b0}};
    else      T[0] <= D1;
end

assign T_[0] = SEL ? T[0] : D0;
assign T_[1] = SEL ? D0 : T[0];

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) T[1] <= {64{1'b0}};
    else      T[1] <= T_[0];
end

assign Q0 = T[1];
assign Q1 = T_[1];

endmodule

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

module W4E1 (
    input  [63:0] D,
    output [63:0] Q
);

assign Q = {D[31:0],~D[63:32]+1'b1};

endmodule
// END
