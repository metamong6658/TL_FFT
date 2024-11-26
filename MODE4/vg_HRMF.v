`timescale 1ns/1ps

module HRMF (
    // CONTROL
    input [0:0] CLK,
    input [0:0] RSTn,
    input [2:0] SEL_HRMF,
    // INPUT
    input [63:0] D0,
    input [63:0] D1,
    input [63:0] D2,
    input [63:0] D3,
    input [63:0] D4,
    input [63:0] D5,
    input [63:0] D6,
    input [63:0] D7,
    input [63:0] TF0,
    input [63:0] TF1,
    input [63:0] TF2,
    input [63:0] TF3,
    input [63:0] TF4,
    input [63:0] TF5,
    input [63:0] TF6,
    input [63:0] TF7,
    // OUTPUT
    output [63:0] Q0,
    output [63:0] Q1,
    output [63:0] Q2,
    output [63:0] Q3,
    output [63:0] Q4,
    output [63:0] Q5,
    output [63:0] Q6,
    output [63:0] Q7
);

wire [63:0] X [0:7];
wire [63:0] Y [0:7];
wire [63:0] Z [0:7];
wire [63:0] T [0:7];

// R8BFU
R8BFU I_R8BFU_0 (
    .D0(D0),
    .D1(D1),
    .D2(D2),
    .D3(D3),
    .D4(D4),
    .D5(D5),
    .D6(D6),
    .D7(D7),
    .Q0(X[0]),
    .Q1(X[1]),
    .Q2(X[2]),
    .Q3(X[3]),
    .Q4(X[4]),
    .Q5(X[5]),
    .Q6(X[6]),
    .Q7(X[7])
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
    .D4(X[4]),
    .D5(X[5]),
    .D6(X[6]),
    .D7(X[7]),
    .Q0(Y[0]),
    .Q1(Y[1]),
    .Q2(Y[2]),
    .Q3(Y[3]),
    .Q4(Y[4]),
    .Q5(Y[5]),
    .Q6(Y[6]),
    .Q7(Y[7])
);

// MTU8X8
MTU8X8 I_MTU8X8_0 (
    .CLK(CLK),
    .RSTn(RSTn),
    .SEL(SEL_HRMF),
    .D0(Y[0]),
    .D1(Y[1]),
    .D2(Y[2]),
    .D3(Y[3]),
    .D4(Y[4]),
    .D5(Y[5]),
    .D6(Y[6]),
    .D7(Y[7]),
    .Q0(Z[0]),
    .Q1(Z[1]),
    .Q2(Z[2]),
    .Q3(Z[3]),
    .Q4(Z[4]),
    .Q5(Z[5]),
    .Q6(Z[6]),
    .Q7(Z[7])
);

// R8BFU
R8BFU I_R8BFU_1 (
    .D0(Z[0]),
    .D1(Z[1]),
    .D2(Z[2]),
    .D3(Z[3]),
    .D4(Z[4]),
    .D5(Z[5]),
    .D6(Z[6]),
    .D7(Z[7]),
    .Q0(T[0]),
    .Q1(T[1]),
    .Q2(T[2]),
    .Q3(T[3]),
    .Q4(T[4]),
    .Q5(T[5]),
    .Q6(T[6]),
    .Q7(T[7])
);

// ROTATOR1
ROTATOR1 I_ROTATOR1_0 (
    .D0(T[0]),
    .D1(T[1]),
    .D2(T[2]),
    .D3(T[3]),
    .D4(T[4]),
    .D5(T[5]),
    .D6(T[6]),
    .D7(T[7]),
    .TF0(TF0),
    .TF1(TF1),
    .TF2(TF2),
    .TF3(TF3),
    .TF4(TF4),
    .TF5(TF5),
    .TF6(TF6),
    .TF7(TF7),
    .Q0(Q0),
    .Q1(Q1),
    .Q2(Q2),
    .Q3(Q3),
    .Q4(Q4),
    .Q5(Q5),
    .Q6(Q6),
    .Q7(Q7)
);

endmodule

/////////////////////// BUTTERFLY ///////////////////////
// Radix-8 Butterfly
module R8BFU (
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

// Plea note that R8BFU is implemented using mixed-radix property.
// We factorize 8 into (2 x 2) x 2.Therefore, we utilize even four-level factorization at now.
// However, it's not crucial. You don't need to know that the mixed-radix property.  
// If you want to apply bit-reverse property,
// Then, you should factorize 8 into 2 x 2 x 2.

wire [63:0] T0, T1, T2, T3, T4, T5, T6, T7;
wire [63:0] P3, P5, P7;

R4BFU I_R4BFU_0 (.D0(D0), .D1(D2), .D2(D4), .D3(D6), 
                 .Q0(T0), .Q1(T2), .Q2(T4), .Q3(T6));

R4BFU I_R4BFU_1 (.D0(D1), .D1(D3), .D2(D5), .D3(D7), 
                 .Q0(T1), .Q1(T3), .Q2(T5), .Q3(T7));

CMUL32 I_W8E1_0 (.D0(T3), .D1(64'h0000b5040000b504), .Q(P3));
W4E1   I_W4E1_0 (.D(T5),  .Q(P5));
CMUL32 I_W8E3_0 (.D0(T7), .D1(64'hffff4afc0000b504), .Q(P7));

R2BFU I_R2BFU_0 (.D0(T0), .D1(T1), .Q0(Q0), .Q1(Q4));
R2BFU I_R2BFU_1 (.D0(T2), .D1(P3), .Q0(Q1), .Q1(Q5));
R2BFU I_R2BFU_2 (.D0(T4), .D1(P5), .Q0(Q2), .Q1(Q6));
R2BFU I_R2BFU_3 (.D0(T6), .D1(P7), .Q0(Q3), .Q1(Q7));

endmodule

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
wire [63:0] T3_;

R2BFU I_R2BFU_0 (.D0(D0),.D1(D2),.Q0(T0),.Q1(T2));
R2BFU I_R2BFU_1 (.D0(D1),.D1(D3),.Q0(T1),.Q1(T3));
W4E1   I_W4E1_0 (.D(T3),  .Q(T3_));

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

/////////////////////// MTU ///////////////////////
// 8 x 8 MTU
module MTU8X8 (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [2:0]  SEL,
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

wire [63:0] T [0:7];
wire [63:0] U [0:7];

// STAGE0
MDC4 I_MDC4_0 (
    .D0(D0),
    .D1(D4),
    .Q0(T[0]),
    .Q1(T[4]),
    .SEL(SEL[2]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC4 I_MDC4_1 (
    .D0(D1),
    .D1(D5),
    .Q0(T[1]),
    .Q1(T[5]),
    .SEL(SEL[2]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC4 I_MDC4_2 (
    .D0(D2),
    .D1(D6),
    .Q0(T[2]),
    .Q1(T[6]),
    .SEL(SEL[2]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC4 I_MDC4_3 (
    .D0(D3),
    .D1(D7),
    .Q0(T[3]),
    .Q1(T[7]),
    .SEL(SEL[2]),
    .CLK(CLK),
    .RSTn(RSTn)
);

// STAGE1
MDC2 I_MDC2_0 (
    .D0(T[0]),
    .D1(T[2]),
    .Q0(U[0]),
    .Q1(U[2]),
    .SEL(SEL[1]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC2 I_MDC2_1 (
    .D0(T[1]),
    .D1(T[3]),
    .Q0(U[1]),
    .Q1(U[3]),
    .SEL(SEL[1]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC2 I_MDC2_2 (
    .D0(T[4]),
    .D1(T[6]),
    .Q0(U[4]),
    .Q1(U[6]),
    .SEL(SEL[1]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC2 I_MDC2_3 (
    .D0(T[5]),
    .D1(T[7]),
    .Q0(U[5]),
    .Q1(U[7]),
    .SEL(SEL[1]),
    .CLK(CLK),
    .RSTn(RSTn)
);

// STAGE2
MDC1 I_MDC1_0 (
    .D0(U[0]),
    .D1(U[1]),
    .Q0(Q0),
    .Q1(Q1),
    .SEL(SEL[0]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC1 I_MDC1_1 (
    .D0(U[2]),
    .D1(U[3]),
    .Q0(Q2),
    .Q1(Q3),
    .SEL(SEL[0]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC1 I_MDC1_2 (
    .D0(U[4]),
    .D1(U[5]),
    .Q0(Q4),
    .Q1(Q5),
    .SEL(SEL[0]),
    .CLK(CLK),
    .RSTn(RSTn)
);

MDC1 I_MDC1_3 (
    .D0(U[6]),
    .D1(U[7]),
    .Q0(Q6),
    .Q1(Q7),
    .SEL(SEL[0]),
    .CLK(CLK),
    .RSTn(RSTn)
);

endmodule

/////////////////////// ROTATOR ///////////////////////
// 1st ROT
module ROTATOR0 (
    input  [2:0]  SEL,
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

wire [63:0] X [1:7];
wire [63:0] Y [1:7];
wire [63:0] Z [1:7];
wire [63:0] T [1:7];
wire [63:0] U [1:7];

// p = 0
assign Q0 = D0;

// p = 1
CMUL32 I_W64E1_0 (.D0(D1),   .D1(64'h0000fec400001917), .Q(X[1]));
CMUL32 I_W64E2_0 (.D0(Y[1]), .D1(64'h0000fb14000031f1), .Q(Z[1]));
CMUL32 I_W64E4_0 (.D0(T[1]), .D1(64'h0000ec83000061f7), .Q(U[1]));
assign Y[1] = (SEL[0]) ? X[1] : D1;
assign T[1] = (SEL[1]) ? Z[1] : Y[1];
assign Q1   = (SEL[2]) ? U[1] : T[1];

// p = 2
CMUL32 I_W64E2_1 (.D0(D2),   .D1(64'h0000fb14000031f1), .Q(X[2]));
CMUL32 I_W64E4_1 (.D0(Y[2]), .D1(64'h0000ec83000061f7), .Q(Z[2]));
CMUL32 I_W64E8_0 (.D0(T[2]), .D1(64'h0000b5040000b504), .Q(U[2]));
assign Y[2] = (SEL[0]) ? X[2] : D2;
assign T[2] = (SEL[1]) ? Z[2] : Y[2];
assign Q2   = (SEL[2]) ? U[2] : T[2];

// p = 3
CMUL32 I_W64E3_0  (.D0(D3),   .D1(64'h0000f4fa00004a50), .Q(X[3]));
CMUL32 I_W64E6_0  (.D0(Y[3]), .D1(64'h0000d4db00008e39), .Q(Z[3]));
CMUL32 I_W64E12_0 (.D0(T[3]), .D1(64'h000061f70000ec83), .Q(U[3]));
assign Y[3] = (SEL[0]) ? X[3] : D3;
assign T[3] = (SEL[1]) ? Z[3] : Y[3];
assign Q3   = (SEL[2]) ? U[3] : T[3];

// p = 4
CMUL32 I_W64E4_2  (.D0(D4),   .D1(64'h0000ec83000061f7), .Q(X[4]));
CMUL32 I_W64E8_1  (.D0(Y[4]), .D1(64'h0000b5040000b504), .Q(Z[4]));
W4E1   I_W64E16_0 ( .D(T[4]),                            .Q(U[4]));
assign Y[4] = (SEL[0]) ? X[4] :  D4;
assign T[4] = (SEL[1]) ? Z[4] : Y[4];
assign  Q4  = (SEL[2]) ? U[4] : T[4];

// p = 5
CMUL32 I_W64E5_0  ( .D0(D5),  .D1(64'h0000e1c5000078ad), .Q(X[5]));
CMUL32 I_W64E10_0 (.D0(Y[5]), .D1(64'h00008e390000d4db), .Q(Z[5]));
CMUL32 I_W64E20_0 (.D0(T[5]), .D1(64'hffff9e090000ec83), .Q(U[5]));
assign Y[5] = (SEL[0]) ? X[5] :  D5;
assign T[5] = (SEL[1]) ? Z[5] : Y[5];
assign  Q5  = (SEL[2]) ? U[5] : T[5];

// p = 6
CMUL32 I_W64E6_1  ( .D0(D6),  .D1(64'h0000d4db00008e39), .Q(X[6]));
CMUL32 I_W64E12_1 (.D0(Y[6]), .D1(64'h000061f70000ec83), .Q(Z[6]));
CMUL32 I_W64E24_0 (.D0(T[6]), .D1(64'hffff4afc0000b504), .Q(U[6]));
assign Y[6] = (SEL[0]) ? X[6] :  D6;
assign T[6] = (SEL[1]) ? Z[6] : Y[6];
assign  Q6  = (SEL[2]) ? U[6] : T[6];

// p = 7
CMUL32 I_W64E7_0  ( .D0(D7),  .D1(64'h0000c5e40000a267), .Q(X[7]));
CMUL32 I_W64E14_0 (.D0(Y[7]), .D1(64'h000031f10000fb14), .Q(Z[7]));
CMUL32 I_W64E28_0 (.D0(T[7]), .D1(64'hffff137d000061f7), .Q(U[7]));
assign Y[7] = (SEL[0]) ? X[7] :  D7;
assign T[7] = (SEL[1]) ? Z[7] : Y[7];
assign  Q7  = (SEL[2]) ? U[7] : T[7];

endmodule

// 2nd ROT
module ROTATOR1 (
    input [63:0] D0,
    input [63:0] D1,
    input [63:0] D2,
    input [63:0] D3,
    input [63:0] D4,
    input [63:0] D5,
    input [63:0] D6,
    input [63:0] D7,
    input [63:0] TF0,
    input [63:0] TF1,
    input [63:0] TF2,
    input [63:0] TF3,
    input [63:0] TF4,
    input [63:0] TF5,
    input [63:0] TF6,
    input [63:0] TF7,
    input [63:0] Q0,
    input [63:0] Q1,
    input [63:0] Q2,
    input [63:0] Q3,
    input [63:0] Q4,
    input [63:0] Q5,
    input [63:0] Q6,
    input [63:0] Q7
);

CMUL32 I_CMUL32_0 (.D0(D0),.D1(TF0),.Q(Q0));
CMUL32 I_CMUL32_1 (.D0(D1),.D1(TF1),.Q(Q1));
CMUL32 I_CMUL32_2 (.D0(D2),.D1(TF2),.Q(Q2));
CMUL32 I_CMUL32_3 (.D0(D3),.D1(TF3),.Q(Q3));
CMUL32 I_CMUL32_4 (.D0(D4),.D1(TF4),.Q(Q4));
CMUL32 I_CMUL32_5 (.D0(D5),.D1(TF5),.Q(Q5));
CMUL32 I_CMUL32_6 (.D0(D6),.D1(TF6),.Q(Q6));
CMUL32 I_CMUL32_7 (.D0(D7),.D1(TF7),.Q(Q7));

endmodule

/////////////////////// SUB BLOCK ///////////////////////

// 4D MDC
module MDC4 (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [0:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    output [63:0] Q0,
    output [63:0] Q1
);

reg  [63:0] T  [0:7];
wire [63:0] T_ [0:1];

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) {T[3],T[2],T[1],T[0]} <= {256{1'b0}};
    else      {T[3],T[2],T[1],T[0]} <= {T[2],T[1],T[0],D1};
end

assign T_[0] = SEL ? T[3] : D0;
assign T_[1] = SEL ? D0 : T[3];

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) {T[7],T[6],T[5],T[4]} <= {256{1'b0}};
    else      {T[7],T[6],T[5],T[4]} <= {T[6],T[5],T[4],T_[0]};
end

assign Q0 = T[7];
assign Q1 = T_[1];

endmodule

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
