`timescale 1ns/1ps

module MDCFFT (
    // CONTROL
    input [0:0] CLK,
    input [0:0] RSTn,
    input [1:0] SEL_ROT0,
    input [0:0] SEL_MDC0,
    input [0:0] SEL_ROT1,
    input [0:0] SEL_MDC1,
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
wire [63:0] U [0:1];
wire [63:0] V [0:1];
wire [63:0] P [0:1];

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
    .SEL(SEL_ROT0),
    .D0(X[0]),
    .D1(X[1]),
    .Q0(Y[0]),
    .Q1(Y[1])
);

// 1D MDC
MDC1 I_MDC1_0 (
    .CLK(CLK),
    .RSTn(RSTn),
    .SEL(SEL_MDC0),
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
    .SEL(SEL_ROT1),
    .D0(T[0]),
    .D1(T[1]),
    .Q0(U[0]),
    .Q1(U[1])
);

// 2D MDC
MDC2 I_MDC2_0 (
    .CLK(CLK),
    .RSTn(RSTn),
    .SEL(SEL_MDC1),
    .D0(U[0]),
    .D1(U[1]),
    .Q0(V[0]),
    .Q1(V[1])
);

// R2BFU
R2BFU I_R2BFU_2 (
    .D0(V[0]),
    .D1(V[1]),
    .Q0(P[0]),
    .Q1(P[1])
);

// ROTATOR2
ROTATOR2 I_ROTATOR2_0 (
    .D0(P[0]),
    .D1(P[1]),
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
    input  [1:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    output [63:0] Q0,
    output [63:0] Q1
);

wire [63:0] X1, Y1, Z1;

// p = 0
assign Q0 = D0;

// p = 1
CMUL32 I_W8E1_0  (.D0(D1), .D1(64'h0000b5040000b504), .Q(X1));
W4E1   I_W4E1_0  ( .D(Y1),                            .Q(Z1));
assign Y1  = SEL[0] ? X1 : D1; 
assign Q1  = SEL[1] ? Z1 : Y1;

endmodule

// 2nd ROT
module ROTATOR1 (
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

// 3rd ROT
module ROTATOR2 (
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

/////////////////////// MDCs ///////////////////////
// 2D MDC
module MDC2 (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [0:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    output [63:0] Q0,
    output [63:0] Q1
);

reg  [63:0] T  [0:3];
wire [63:0] T_ [0:1];

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) {T[1],T[0]} <= {128{1'b0}};
    else      {T[1],T[0]} <= {T[0],D1};
end

assign T_[0] = SEL ? T[1] : D0;
assign T_[1] = SEL ? D0 : T[1];

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) {T[3],T[2]} <= {128{1'b0}};
    else      {T[3],T[2]} <= {T[2],T_[0]};
end

assign Q0 = T[3];
assign Q1 = T_[1];

endmodule

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

module W4E1 (
    input  [63:0] D,
    output [63:0] Q
);

assign Q = {D[31:0],~D[63:32]+1'b1};

endmodule
// END
