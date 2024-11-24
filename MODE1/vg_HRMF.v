`timescale 1ns/1ps

module HRMF (
    // CONTROL
    input [0:0] CLK,
    input [0:0] RSTn,
    input [1:0] SEL_HRMF,
    // INPUT
    input [63:0] D0,
    input [63:0] D1,
    input [63:0] D2,
    input [63:0] D3,
    input [63:0] TF0,
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
wire [63:0] Y [0:3];
wire [63:0] Z [0:3];
wire [63:0] T [0:3];

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

// ROTATOR0
ROTATOR0 I_ROTATOR0_0 (
    .SEL(SEL_HRMF),
    .D0(X[0]),
    .D1(X[1]),
    .D2(X[2]),
    .D3(X[3]),
    .Q0(Y[0]),
    .Q1(Y[1]),
    .Q2(Y[2]),
    .Q3(Y[3])
);

// MTU4X4
MTU4X4 I_MTU4X4_0 (
    .CLK(CLK),
    .RSTn(RSTn),
    .SEL(SEL_HRMF),
    .D0(Y[0]),
    .D1(Y[1]),
    .D2(Y[2]),
    .D3(Y[3]),
    .Q0(Z[0]),
    .Q1(Z[1]),
    .Q2(Z[2]),
    .Q3(Z[3])
);

// R4BFU
R4BFU I_R4BFU_1 (
    .D0(Z[0]),
    .D1(Z[1]),
    .D2(Z[2]),
    .D3(Z[3]),
    .Q0(T[0]),
    .Q1(T[1]),
    .Q2(T[2]),
    .Q3(T[3])
);

// ROTATOR1
ROTATOR1 I_ROTATOR1_0 (
    .D0(T[0]),
    .D1(T[1]),
    .D2(T[2]),
    .D3(T[3]),
    .TF0(TF0),
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

// 4 x 4 MTU
module MTU4X4 (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [1:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    input  [63:0] D2,
    input  [63:0] D3,
    output [63:0] Q0,
    output [63:0] Q1,
    output [63:0] Q2,
    output [63:0] Q3
);

wire [63:0] T [0:3];

MDC2 I_MDC2_0 (
    .D0(D0),
    .D1(D2),
    .Q0(T[0]),
    .Q1(T[2]),
    .SEL(SEL[1]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC2 I_MDC2_1 (
    .D0(D1),
    .D1(D3),
    .Q0(T[1]),
    .Q1(T[3]),
    .SEL(SEL[1]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC1 I_MDC1_0 (
    .D0(T[0]),
    .D1(T[1]),
    .Q0(Q0),
    .Q1(Q1),
    .SEL(SEL[0]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC1 I_MDC1_1 (
    .D0(T[2]),
    .D1(T[3]),
    .Q0(Q2),
    .Q1(Q3),
    .SEL(SEL[0]),
    .CLK(CLK),
    .RSTn(RSTn)
);

endmodule

/////////////////////// SUB BLOCK ///////////////////////

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
wire [63:0] T_ [0:3];

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

module ROTATOR0 (
    input  [1:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    input  [63:0] D2,
    input  [63:0] D3,
    output [63:0] Q0,
    output [63:0] Q1,
    output [63:0] Q2,
    output [63:0] Q3
);

wire [63:0] X [1:3];
wire [63:0] Y [1:3];
wire [63:0] Z [1:3];

// p = 0
assign Q0 = D0;

// p = 1
W16E1 I_W16E1_0 (.D(D1), .Q(X[1])); // W16E1
assign Y[1] = (SEL[0]) ? X[1] : D1;
W8E1 I_W8E1_0 (.D(Y[1]), .Q(Z[1])); // W8E1
assign Q1 = (SEL[1]) ? Z[1] : Y[1];

// p = 2
W8E1 I_W8E1_1 (.D(D2), .Q(X[2])); // W8E1
assign Y[2] = (SEL[0]) ? X[2] : D2;
W4E1 I_W4E1_0 (.D(Y[2]), .Q(Z[2])); // // W4E1
assign Q2 = (SEL[1]) ? Z[2] : Y[2];

// p = 3
W16E3 I_W16E3_0 (.D(D3), .Q(X[3])); // W16E3
assign Y[3] = (SEL[0]) ? X[3] : D3;
W8E3 I_W8E3_0 (.D(Y[3]), .Q(Z[3])); // W8E3
assign Q3 = (SEL[1]) ? Z[3] : Y[3];

endmodule

module ROTATOR1 (
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

CMUL32 I_CMUL32_0 (
    .D0(D0),  // DATA
    .D1(TF0), // TWIDDLE FACTOR
    .Q(Q0)
);

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

module W4E1 (
    input  [63:0] D,
    output [63:0] Q
);

assign Q = {D[31:0],~D[63:32]+1'b1};

endmodule

module W8E1 (
    input  [63:0] D,
    output [63:0] Q
);

CMUL32 I_CMUL32_0 (
    .D0(D), // DATA
    .D1(64'h0000b5040000b504), // TWIDDLE FACTOR
    .Q(Q)
);

endmodule

module W8E3 (
    input  [63:0] D,
    output [63:0] Q
);

CMUL32 I_CMUL32_0 (
    .D0(D), // DATA
    .D1(64'hffff4afc0000b504), // TWIDDLE FACTOR
    .Q(Q)
);

endmodule

module W16E1 (
    input  [63:0] D,
    output [63:0] Q
);

CMUL32 I_CMUL32_0 (
    .D0(D), // DATA
    .D1(64'h0000ec83000061f7), // TWIDDLE FACTOR
    .Q(Q)
);

endmodule

module W16E3 (
    input  signed [63:0] D,
    output signed [63:0] Q
);

CMUL32 I_CMUL32_0 (
    .D0(D), // DATA
    .D1(64'h000061f70000ec83), // TWIDDLE FACTOR
    .Q(Q)
);

endmodule

// END