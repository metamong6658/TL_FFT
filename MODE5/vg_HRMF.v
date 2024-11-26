`timescale 1ns/1ps

module HRMF (
    // CONTROL
    input [0:0] CLK,
    input [0:0] RSTn,
    input [3:0] SEL_HRMF,
    // INPUT
    input [63:0] D0,
    input [63:0] D1,
    input [63:0] D2,
    input [63:0] D3,
    input [63:0] D4,
    input [63:0] D5,
    input [63:0] D6,
    input [63:0] D7,
    input [63:0] D8,
    input [63:0] D9,
    input [63:0] D10,
    input [63:0] D11,
    input [63:0] D12,
    input [63:0] D13,
    input [63:0] D14,
    input [63:0] D15,
    input [63:0] TF0,
    input [63:0] TF1,
    input [63:0] TF2,
    input [63:0] TF3,
    input [63:0] TF4,
    input [63:0] TF5,
    input [63:0] TF6,
    input [63:0] TF7,
    input [63:0] TF8,
    input [63:0] TF9,
    input [63:0] TF10,
    input [63:0] TF11,
    input [63:0] TF12,
    input [63:0] TF13,
    input [63:0] TF14,
    input [63:0] TF15,
    // OUTPUT
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

wire [63:0] X [0:15];
wire [63:0] Y [0:15];
wire [63:0] Z [0:15];
wire [63:0] T [0:15];

// R16BFU
R16BFU I_R16BFU_0 (
    .D0(D0),
    .D1(D1),
    .D2(D2),
    .D3(D3),
    .D4(D4),
    .D5(D5),
    .D6(D6),
    .D7(D7),
    .D8(D8),
    .D9(D9),
    .D10(D10),
    .D11(D11),
    .D12(D12),
    .D13(D13),
    .D14(D14),
    .D15(D15),
    .Q0(X[0]),
    .Q1(X[1]),
    .Q2(X[2]),
    .Q3(X[3]),
    .Q4(X[4]),
    .Q5(X[5]),
    .Q6(X[6]),
    .Q7(X[7]),
    .Q8(X[8]),
    .Q9(X[9]),
    .Q10(X[10]),
    .Q11(X[11]),
    .Q12(X[12]),
    .Q13(X[13]),
    .Q14(X[14]),
    .Q15(X[15])
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
    .D8(X[8]),
    .D9(X[9]),
    .D10(X[10]),
    .D11(X[11]),
    .D12(X[12]),
    .D13(X[13]),
    .D14(X[14]),
    .D15(X[15]),
    .Q0(Y[0]),
    .Q1(Y[1]),
    .Q2(Y[2]),
    .Q3(Y[3]),
    .Q4(Y[4]),
    .Q5(Y[5]),
    .Q6(Y[6]),
    .Q7(Y[7]),
    .Q8(Y[8]),
    .Q9(Y[9]),
    .Q10(Y[10]),
    .Q11(Y[11]),
    .Q12(Y[12]),
    .Q13(Y[13]),
    .Q14(Y[14]),
    .Q15(Y[15])
);

// MTU16X16
MTU16X16 I_MTU16X16_0 (
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
    .D8(Y[8]),
    .D9(Y[9]),
    .D10(Y[10]),
    .D11(Y[11]),
    .D12(Y[12]),
    .D13(Y[13]),
    .D14(Y[14]),
    .D15(Y[15]),
    .Q0(Z[0]),
    .Q1(Z[1]),
    .Q2(Z[2]),
    .Q3(Z[3]),
    .Q4(Z[4]),
    .Q5(Z[5]),
    .Q6(Z[6]),
    .Q7(Z[7]),
    .Q8(Z[8]),
    .Q9(Z[9]),
    .Q10(Z[10]),
    .Q11(Z[11]),
    .Q12(Z[12]),
    .Q13(Z[13]),
    .Q14(Z[14]),
    .Q15(Z[15])
);

// R16BFU
R16BFU I_R16BFU_1 (
    .D0(Z[0]),
    .D1(Z[1]),
    .D2(Z[2]),
    .D3(Z[3]),
    .D4(Z[4]),
    .D5(Z[5]),
    .D6(Z[6]),
    .D7(Z[7]),
    .D8(Z[8]),
    .D9(Z[9]),
    .D10(Z[10]),
    .D11(Z[11]),
    .D12(Z[12]),
    .D13(Z[13]),
    .D14(Z[14]),
    .D15(Z[15]),
    .Q0(T[0]),
    .Q1(T[1]),
    .Q2(T[2]),
    .Q3(T[3]),
    .Q4(T[4]),
    .Q5(T[5]),
    .Q6(T[6]),
    .Q7(T[7]),
    .Q8(T[8]),
    .Q9(T[9]),
    .Q10(T[10]),
    .Q11(T[11]),
    .Q12(T[12]),
    .Q13(T[13]),
    .Q14(T[14]),
    .Q15(T[15])
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
    .D8(T[8]),
    .D9(T[9]),
    .D10(T[10]),
    .D11(T[11]),
    .D12(T[12]),
    .D13(T[13]),
    .D14(T[14]),
    .D15(T[15]),
    .TF0(TF0),
    .TF1(TF1),
    .TF2(TF2),
    .TF3(TF3),
    .TF4(TF4),
    .TF5(TF5),
    .TF6(TF6),
    .TF7(TF7),
    .TF8(TF8),
    .TF9(TF9),
    .TF10(TF10),
    .TF11(TF11),
    .TF12(TF12),
    .TF13(TF13),
    .TF14(TF14),
    .TF15(TF15),
    .Q0(Q0),
    .Q1(Q1),
    .Q2(Q2),
    .Q3(Q3),
    .Q4(Q4),
    .Q5(Q5),
    .Q6(Q6),
    .Q7(Q7),
    .Q8(Q8),
    .Q9(Q9),
    .Q10(Q10),
    .Q11(Q11),
    .Q12(Q12),
    .Q13(Q13),
    .Q14(Q14),
    .Q15(Q15)
);

endmodule

/////////////////////// BUTTERFLY ///////////////////////
// Radix-16 Butterfly
module R16BFU (
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

// Plea note that R16BFU is implemented using mixed-radix property.
// We factorize 16 into ((2 x 2) x 2) x 2.Therefore, we utilize even fize-level factorization at now.
// However, it's not crucial. You don't need to know that the mixed-radix property.   
// If you want to apply bit-reverse property,
// Then, you should factorize 16 into 2 x 2 x 2 x 2.

wire [63:0] T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15;
wire [63:0] P3, P5, P7, P9, P11, P13, P15;

R8BFU I_R8BFU_0 (.D0(D0), .D1(D2),  .D2(D4),  .D3(D6),
                 .D4(D8), .D5(D10), .D6(D12), .D7(D14),
                 .Q0(T0), .Q1(T2),  .Q2(T4),  .Q3(T6),
                 .Q4(T8), .Q5(T10), .Q6(T12), .Q7(T14));

R8BFU I_R8BFU_1 (.D0(D1), .D1(D3),  .D2(D5),  .D3(D7),
                 .D4(D9), .D5(D11), .D6(D13), .D7(D15),
                 .Q0(T1), .Q1(T3),  .Q2(T5),  .Q3(T7),
                 .Q4(T9), .Q5(T11), .Q6(T13), .Q7(T15));

CMUL32 I_W16E1_0 (.D0(T3), .D1(64'h0000ec83000061f7), .Q(P3));
CMUL32 I_W16E2_0 (.D0(T5), .D1(64'h0000b5040000b504), .Q(P5));
CMUL32 I_W16E3_0 (.D0(T7), .D1(64'h000061f70000ec83), .Q(P7));
W4E1   I_W16E4_0 ( .D(T9),                            .Q(P9));
CMUL32 I_W16E5_0 (.D0(T11),.D1(64'hffff9e090000ec83), .Q(P11));
CMUL32 I_W16E6_0 (.D0(T13),.D1(64'hffff4afc0000b504), .Q(P13));
CMUL32 I_W16E7_0 (.D0(T15),.D1(64'hffff137d000061f7), .Q(P15));

R2BFU I_R2BFU_0 (.D0(T0),  .D1(T1),  .Q0(Q0), .Q1(Q8));
R2BFU I_R2BFU_1 (.D0(T2),  .D1(P3),  .Q0(Q1), .Q1(Q9));
R2BFU I_R2BFU_2 (.D0(T4),  .D1(P5),  .Q0(Q2), .Q1(Q10));
R2BFU I_R2BFU_3 (.D0(T6),  .D1(P7),  .Q0(Q3), .Q1(Q11));
R2BFU I_R2BFU_4 (.D0(T8),  .D1(P9),  .Q0(Q4), .Q1(Q12));
R2BFU I_R2BFU_5 (.D0(T10), .D1(P11), .Q0(Q5), .Q1(Q13));
R2BFU I_R2BFU_6 (.D0(T12), .D1(P13), .Q0(Q6), .Q1(Q14));
R2BFU I_R2BFU_7 (.D0(T14), .D1(P15), .Q0(Q7), .Q1(Q15));

endmodule

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
// 16 x 16 MTU
module MTU16X16 (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [3:0]  SEL,
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

wire [63:0] T [0:15];
wire [63:0] U [0:15];
wire [63:0] V [0:15];

// STAGE0
MDC8 I_MDC8_0 (.SEL(SEL[3]),.D0(D0),.D1(D8), .Q0(T[0]),.Q1(T[8]), .CLK(CLK),.RSTn(RSTn));
MDC8 I_MDC8_1 (.SEL(SEL[3]),.D0(D1),.D1(D9), .Q0(T[1]),.Q1(T[9]), .CLK(CLK),.RSTn(RSTn));
MDC8 I_MDC8_2 (.SEL(SEL[3]),.D0(D2),.D1(D10),.Q0(T[2]),.Q1(T[10]),.CLK(CLK),.RSTn(RSTn));
MDC8 I_MDC8_3 (.SEL(SEL[3]),.D0(D3),.D1(D11),.Q0(T[3]),.Q1(T[11]),.CLK(CLK),.RSTn(RSTn));
MDC8 I_MDC8_4 (.SEL(SEL[3]),.D0(D4),.D1(D12),.Q0(T[4]),.Q1(T[12]),.CLK(CLK),.RSTn(RSTn));
MDC8 I_MDC8_5 (.SEL(SEL[3]),.D0(D5),.D1(D13),.Q0(T[5]),.Q1(T[13]),.CLK(CLK),.RSTn(RSTn));
MDC8 I_MDC8_6 (.SEL(SEL[3]),.D0(D6),.D1(D14),.Q0(T[6]),.Q1(T[14]),.CLK(CLK),.RSTn(RSTn));
MDC8 I_MDC8_7 (.SEL(SEL[3]),.D0(D7),.D1(D15),.Q0(T[7]),.Q1(T[15]),.CLK(CLK),.RSTn(RSTn));

// STAGE1
MDC4 I_MDC4_0 (.SEL(SEL[2]),.D0(T[0]), .D1(T[4]), .Q0(U[0]), .Q1(U[4]), .CLK(CLK),.RSTn(RSTn));
MDC4 I_MDC4_1 (.SEL(SEL[2]),.D0(T[1]), .D1(T[5]), .Q0(U[1]), .Q1(U[5]), .CLK(CLK),.RSTn(RSTn));
MDC4 I_MDC4_2 (.SEL(SEL[2]),.D0(T[2]), .D1(T[6]), .Q0(U[2]), .Q1(U[6]), .CLK(CLK),.RSTn(RSTn));
MDC4 I_MDC4_3 (.SEL(SEL[2]),.D0(T[3]), .D1(T[7]), .Q0(U[3]), .Q1(U[7]), .CLK(CLK),.RSTn(RSTn));
MDC4 I_MDC4_4 (.SEL(SEL[2]),.D0(T[8]), .D1(T[12]),.Q0(U[8]), .Q1(U[12]),.CLK(CLK),.RSTn(RSTn));
MDC4 I_MDC4_5 (.SEL(SEL[2]),.D0(T[9]), .D1(T[13]),.Q0(U[9]), .Q1(U[13]),.CLK(CLK),.RSTn(RSTn));
MDC4 I_MDC4_6 (.SEL(SEL[2]),.D0(T[10]),.D1(T[14]),.Q0(U[10]),.Q1(U[14]),.CLK(CLK),.RSTn(RSTn));
MDC4 I_MDC4_7 (.SEL(SEL[2]),.D0(T[11]),.D1(T[15]),.Q0(U[11]),.Q1(U[15]),.CLK(CLK),.RSTn(RSTn));

// STAGE2
MDC2 I_MDC2_0 (.SEL(SEL[1]),.D0(U[0]), .D1(U[2]), .Q0(V[0]), .Q1(V[2]), .CLK(CLK),.RSTn(RSTn));
MDC2 I_MDC2_1 (.SEL(SEL[1]),.D0(U[1]), .D1(U[3]), .Q0(V[1]), .Q1(V[3]), .CLK(CLK),.RSTn(RSTn));
MDC2 I_MDC2_2 (.SEL(SEL[1]),.D0(U[4]), .D1(U[6]), .Q0(V[4]), .Q1(V[6]), .CLK(CLK),.RSTn(RSTn));
MDC2 I_MDC2_3 (.SEL(SEL[1]),.D0(U[5]), .D1(U[7]), .Q0(V[5]), .Q1(V[7]), .CLK(CLK),.RSTn(RSTn));
MDC2 I_MDC2_4 (.SEL(SEL[1]),.D0(U[8]), .D1(U[10]),.Q0(V[8]), .Q1(V[10]),.CLK(CLK),.RSTn(RSTn));
MDC2 I_MDC2_5 (.SEL(SEL[1]),.D0(U[9]), .D1(U[11]),.Q0(V[9]), .Q1(V[11]),.CLK(CLK),.RSTn(RSTn));
MDC2 I_MDC2_6 (.SEL(SEL[1]),.D0(U[12]),.D1(U[14]),.Q0(V[12]),.Q1(V[14]),.CLK(CLK),.RSTn(RSTn));
MDC2 I_MDC2_7 (.SEL(SEL[1]),.D0(U[13]),.D1(U[15]),.Q0(V[13]),.Q1(V[15]),.CLK(CLK),.RSTn(RSTn));

// STAGE3
MDC1 I_MDC1_0 (.SEL(SEL[0]),.D0(V[0]), .D1(V[1]), .Q0(Q0), .Q1(Q1), .CLK(CLK),.RSTn(RSTn));
MDC1 I_MDC1_1 (.SEL(SEL[0]),.D0(V[2]), .D1(V[3]), .Q0(Q2), .Q1(Q3), .CLK(CLK),.RSTn(RSTn));
MDC1 I_MDC1_2 (.SEL(SEL[0]),.D0(V[4]), .D1(V[5]), .Q0(Q4), .Q1(Q5), .CLK(CLK),.RSTn(RSTn));
MDC1 I_MDC1_3 (.SEL(SEL[0]),.D0(V[6]), .D1(V[7]), .Q0(Q6), .Q1(Q7), .CLK(CLK),.RSTn(RSTn));
MDC1 I_MDC1_4 (.SEL(SEL[0]),.D0(V[8]), .D1(V[9]), .Q0(Q8), .Q1(Q9), .CLK(CLK),.RSTn(RSTn));
MDC1 I_MDC1_5 (.SEL(SEL[0]),.D0(V[10]),.D1(V[11]),.Q0(Q10),.Q1(Q11),.CLK(CLK),.RSTn(RSTn));
MDC1 I_MDC1_6 (.SEL(SEL[0]),.D0(V[12]),.D1(V[13]),.Q0(Q12),.Q1(Q13),.CLK(CLK),.RSTn(RSTn));
MDC1 I_MDC1_7 (.SEL(SEL[0]),.D0(V[14]),.D1(V[15]),.Q0(Q14),.Q1(Q15),.CLK(CLK),.RSTn(RSTn));

endmodule

/////////////////////// ROTATOR ///////////////////////
// 1st ROT
module ROTATOR0 (
    input  [3:0]  SEL,
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

wire [63:0] X [1:15];
wire [63:0] Y [1:15];
wire [63:0] Z [1:15];
wire [63:0] T [1:15];
wire [63:0] U [1:15];
wire [63:0] V [1:15];
wire [63:0] P [1:15];

// p = 0
assign Q0 = D0;

// p = 1
CMUL32 I_W256E1_0 (.D0(D1),   .D1(64'h0000ffec00000648), .Q(X[1]));
CMUL32 I_W256E2_0 (.D0(Y[1]), .D1(64'h0000ffb100000c8f), .Q(Z[1]));
CMUL32 I_W256E4_0 (.D0(T[1]), .D1(64'h0000fec400001917), .Q(U[1]));
CMUL32 I_W256E8_0 (.D0(V[1]), .D1(64'h0000fb14000031f1), .Q(P[1]));
assign Y[1] = (SEL[0]) ? X[1] :  D1;
assign T[1] = (SEL[1]) ? Z[1] : Y[1];
assign V[1] = (SEL[2]) ? U[1] : T[1];
assign  Q1  = (SEL[3]) ? P[1] : V[1];

// p = 2
CMUL32 I_W256E2_1  ( .D0(D2),  .D1(64'h0000ffb100000c8f), .Q(X[2]));
CMUL32 I_W256E4_1  (.D0(Y[2]), .D1(64'h0000fec400001917), .Q(Z[2]));
CMUL32 I_W256E8_1  (.D0(T[2]), .D1(64'h0000fb14000031f1), .Q(U[2]));
CMUL32 I_W256E16_0 (.D0(V[2]), .D1(64'h0000ec83000061f7), .Q(P[2]));
assign Y[2] = (SEL[0]) ? X[2] :  D2;
assign T[2] = (SEL[1]) ? Z[2] : Y[2];
assign V[2] = (SEL[2]) ? U[2] : T[2];
assign  Q2  = (SEL[3]) ? P[2] : V[2];

// p = 3
CMUL32 I_W256E3_0  ( .D0(D3),  .D1(64'h0000ff4e000012d5), .Q(X[3]));
CMUL32 I_W256E6_0  (.D0(Y[3]), .D1(64'h0000fd3a00002590), .Q(Z[3]));
CMUL32 I_W256E12_0 (.D0(T[3]), .D1(64'h0000f4fa00004a50), .Q(U[3]));
CMUL32 I_W256E24_0 (.D0(V[3]), .D1(64'h0000d4db00008e39), .Q(P[3]));
assign Y[3] = (SEL[0]) ? X[3] :  D3;
assign T[3] = (SEL[1]) ? Z[3] : Y[3];
assign V[3] = (SEL[2]) ? U[3] : T[3];
assign  Q3  = (SEL[3]) ? P[3] : V[3];

// p = 4
CMUL32 I_W256E4_2  ( .D0(D4),  .D1(64'h0000fec400001917), .Q(X[4]));
CMUL32 I_W256E8_2  (.D0(Y[4]), .D1(64'h0000fb14000031f1), .Q(Z[4]));
CMUL32 I_W256E16_1 (.D0(T[4]), .D1(64'h0000ec83000061f7), .Q(U[4]));
CMUL32 I_W256E32_0 (.D0(V[4]), .D1(64'h0000b5040000b504), .Q(P[4]));
assign Y[4] = (SEL[0]) ? X[4] :  D4;
assign T[4] = (SEL[1]) ? Z[4] : Y[4];
assign V[4] = (SEL[2]) ? U[4] : T[4];
assign  Q4  = (SEL[3]) ? P[4] : V[4];

// p = 5
CMUL32 I_W256E5_0  ( .D0(D5),  .D1(64'h0000fe1300001f56), .Q(X[5]));
CMUL32 I_W256E10_0 (.D0(Y[5]), .D1(64'h0000f85300003e33), .Q(Z[5]));
CMUL32 I_W256E20_0 (.D0(T[5]), .D1(64'h0000e1c5000078ad), .Q(U[5]));
CMUL32 I_W256E40_0 (.D0(V[5]), .D1(64'h00008e390000d4db), .Q(P[5]));
assign Y[5] = (SEL[0]) ? X[5] :  D5;
assign T[5] = (SEL[1]) ? Z[5] : Y[5];
assign V[5] = (SEL[2]) ? U[5] : T[5];
assign  Q5  = (SEL[3]) ? P[5] : V[5];

// p = 6
CMUL32 I_W256E6_1  ( .D0(D6),  .D1(64'h0000fd3a00002590), .Q(X[6]));
CMUL32 I_W256E12_1 (.D0(Y[6]), .D1(64'h0000f4fa00004a50), .Q(Z[6]));
CMUL32 I_W256E24_1 (.D0(T[6]), .D1(64'h0000d4db00008e39), .Q(U[6]));
CMUL32 I_W256E48_0 (.D0(V[6]), .D1(64'h000061f70000ec83), .Q(P[6]));
assign Y[6] = (SEL[0]) ? X[6] :  D6;
assign T[6] = (SEL[1]) ? Z[6] : Y[6];
assign V[6] = (SEL[2]) ? U[6] : T[6];
assign  Q6  = (SEL[3]) ? P[6] : V[6];

// p = 7
CMUL32 I_W256E7_0  ( .D0(D7),  .D1(64'h0000fc3b00002bc4), .Q(X[7]));
CMUL32 I_W256E14_0 (.D0(Y[7]), .D1(64'h0000f1090000563e), .Q(Z[7]));
CMUL32 I_W256E28_0 (.D0(T[7]), .D1(64'h0000c5e40000a267), .Q(U[7]));
CMUL32 I_W256E56_0 (.D0(V[7]), .D1(64'h000031f10000fb14), .Q(P[7]));
assign Y[7] = (SEL[0]) ? X[7] :  D7;
assign T[7] = (SEL[1]) ? Z[7] : Y[7];
assign V[7] = (SEL[2]) ? U[7] : T[7];
assign  Q7  = (SEL[3]) ? P[7] : V[7];

// p = 8
CMUL32 I_W256E8_3  ( .D0(D8),  .D1(64'h0000fb14000031f1), .Q(X[8]));
CMUL32 I_W256E16_2 (.D0(Y[8]), .D1(64'h0000ec83000061f7), .Q(Z[8]));
CMUL32 I_W256E32_1 (.D0(T[8]), .D1(64'h0000b5040000b504), .Q(U[8]));
W4E1   I_W256E64_0 ( .D(V[8]),                            .Q(P[8]));
assign Y[8] = (SEL[0]) ? X[8] :  D8;
assign T[8] = (SEL[1]) ? Z[8] : Y[8];
assign V[8] = (SEL[2]) ? U[8] : T[8];
assign  Q8  = (SEL[3]) ? P[8] : V[8];

// p = 9
CMUL32 I_W256E9_0  ( .D0(D9),  .D1(64'h0000f9c700003817), .Q(X[9]));
CMUL32 I_W256E18_0 (.D0(Y[9]), .D1(64'h0000e76b00006d74), .Q(Z[9]));
CMUL32 I_W256E36_0 (.D0(T[9]), .D1(64'h0000a2670000c5e4), .Q(U[9]));
CMUL32 I_W256E72_0 (.D0(V[9]), .D1(64'hffffce0f0000fb14), .Q(P[9]));
assign Y[9] = (SEL[0]) ? X[9] :  D9;
assign T[9] = (SEL[1]) ? Z[9] : Y[9];
assign V[9] = (SEL[2]) ? U[9] : T[9];
assign  Q9  = (SEL[3]) ? P[9] : V[9];

// p = 10
CMUL32 I_W256E10_1 ( .D0(D10),  .D1(64'h0000f85300003e33), .Q(X[10]));
CMUL32 I_W256E20_1 (.D0(Y[10]), .D1(64'h0000e1c5000078ad), .Q(Z[10]));
CMUL32 I_W256E40_1 (.D0(T[10]), .D1(64'h00008e390000d4db), .Q(U[10]));
CMUL32 I_W256E80_0 (.D0(V[10]), .D1(64'hffff9e090000ec83), .Q(P[10]));
assign Y[10] = (SEL[0]) ? X[10] :  D10;
assign T[10] = (SEL[1]) ? Z[10] : Y[10];
assign V[10] = (SEL[2]) ? U[10] : T[10];
assign  Q10  = (SEL[3]) ? P[10] : V[10];

// p = 11
CMUL32 I_W256E11_0 ( .D0(D11),  .D1(64'h0000f6ba00004447), .Q(X[11]));
CMUL32 I_W256E22_0 (.D0(Y[11]), .D1(64'h0000db940000839c), .Q(Z[11]));
CMUL32 I_W256E44_0 (.D0(T[11]), .D1(64'h000078ad0000e1c5), .Q(U[11]));
CMUL32 I_W256E88_0 (.D0(V[11]), .D1(64'hffff71c70000d4db), .Q(P[11]));
assign Y[11] = (SEL[0]) ? X[11] :  D11;
assign T[11] = (SEL[1]) ? Z[11] : Y[11];
assign V[11] = (SEL[2]) ? U[11] : T[11];
assign  Q11  = (SEL[3]) ? P[11] : V[11];

// p = 12
CMUL32 I_W256E12_2 ( .D0(D12),  .D1(64'h0000f4fa00004a50), .Q(X[12]));
CMUL32 I_W256E24_2 (.D0(Y[12]), .D1(64'h0000d4db00008e39), .Q(Z[12]));
CMUL32 I_W256E48_1 (.D0(T[12]), .D1(64'h000061f70000ec83), .Q(U[12]));
CMUL32 I_W256E96_0 (.D0(V[12]), .D1(64'hffff4afc0000b504), .Q(P[12]));
assign Y[12] = (SEL[0]) ? X[12] :  D12;
assign T[12] = (SEL[1]) ? Z[12] : Y[12];
assign V[12] = (SEL[2]) ? U[12] : T[12];
assign  Q12  = (SEL[3]) ? P[12] : V[12];

// p = 13
CMUL32 I_W256E13_0  ( .D0(D13),  .D1(64'h0000f3140000504d), .Q(X[13]));
CMUL32 I_W256E26_0  (.D0(Y[13]), .D1(64'h0000cd9f0000987f), .Q(Z[13]));
CMUL32 I_W256E52_0  (.D0(T[13]), .D1(64'h00004a500000f4fa), .Q(U[13]));
CMUL32 I_W256E104_0 (.D0(V[13]), .D1(64'hffff2b2500008e39), .Q(P[13]));
assign Y[13] = (SEL[0]) ? X[13] :  D13;
assign T[13] = (SEL[1]) ? Z[13] : Y[13];
assign V[13] = (SEL[2]) ? U[13] : T[13];
assign  Q13  = (SEL[3]) ? P[13] : V[13];

// p = 14
CMUL32 I_W256E14_1  ( .D0(D14),  .D1(64'h0000f1090000563e), .Q(X[14]));
CMUL32 I_W256E28_1  (.D0(Y[14]), .D1(64'h0000c5e40000a267), .Q(Z[14]));
CMUL32 I_W256E56_1  (.D0(T[14]), .D1(64'h000031f10000fb14), .Q(U[14]));
CMUL32 I_W256E112_0 (.D0(V[14]), .D1(64'hffff137d000061f7), .Q(P[14]));
assign Y[14] = (SEL[0]) ? X[14] :  D14;
assign T[14] = (SEL[1]) ? Z[14] : Y[14];
assign V[14] = (SEL[2]) ? U[14] : T[14];
assign  Q14  = (SEL[3]) ? P[14] : V[14];

// p = 15
CMUL32 I_W256E15_0  ( .D0(D15),  .D1(64'h0000eed800005c22), .Q(X[15]));
CMUL32 I_W256E30_0  (.D0(Y[15]), .D1(64'h0000bdae0000abeb), .Q(Z[15]));
CMUL32 I_W256E60_0  (.D0(T[15]), .D1(64'h000019170000fec4), .Q(U[15]));
CMUL32 I_W256E120_0 (.D0(V[15]), .D1(64'hffff04ec000031f1), .Q(P[15]));
assign Y[15] = (SEL[0]) ? X[15] :  D15;
assign T[15] = (SEL[1]) ? Z[15] : Y[15];
assign V[15] = (SEL[2]) ? U[15] : T[15];
assign  Q15  = (SEL[3]) ? P[15] : V[15];

endmodule

// 2nd ROT
module ROTATOR1 (
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
    input  [63:0] TF0,
    input  [63:0] TF1,
    input  [63:0] TF2,
    input  [63:0] TF3,
    input  [63:0] TF4,
    input  [63:0] TF5,
    input  [63:0] TF6,
    input  [63:0] TF7,
    input  [63:0] TF8,
    input  [63:0] TF9,
    input  [63:0] TF10,
    input  [63:0] TF11,
    input  [63:0] TF12,
    input  [63:0] TF13,
    input  [63:0] TF14,
    input  [63:0] TF15,
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

CMUL32 I_CMUL32_0  (.D0(D0), .D1(TF0), .Q(Q0));
CMUL32 I_CMUL32_1  (.D0(D1), .D1(TF1), .Q(Q1));
CMUL32 I_CMUL32_2  (.D0(D2), .D1(TF2), .Q(Q2));
CMUL32 I_CMUL32_3  (.D0(D3), .D1(TF3), .Q(Q3));
CMUL32 I_CMUL32_4  (.D0(D4), .D1(TF4), .Q(Q4));
CMUL32 I_CMUL32_5  (.D0(D5), .D1(TF5), .Q(Q5));
CMUL32 I_CMUL32_6  (.D0(D6), .D1(TF6), .Q(Q6));
CMUL32 I_CMUL32_7  (.D0(D7), .D1(TF7), .Q(Q7));
CMUL32 I_CMUL32_8  (.D0(D8), .D1(TF8), .Q(Q8));
CMUL32 I_CMUL32_9  (.D0(D9), .D1(TF9), .Q(Q9));
CMUL32 I_CMUL32_10 (.D0(D10),.D1(TF10),.Q(Q10));
CMUL32 I_CMUL32_11 (.D0(D11),.D1(TF11),.Q(Q11));
CMUL32 I_CMUL32_12 (.D0(D12),.D1(TF12),.Q(Q12));
CMUL32 I_CMUL32_13 (.D0(D13),.D1(TF13),.Q(Q13));
CMUL32 I_CMUL32_14 (.D0(D14),.D1(TF14),.Q(Q14));
CMUL32 I_CMUL32_15 (.D0(D15),.D1(TF15),.Q(Q15));

endmodule

/////////////////////// SUB BLOCK ///////////////////////
// 8D MDC
module MDC8 (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [0:0]  SEL,
    input  [63:0] D0,
    input  [63:0] D1,
    output [63:0] Q0,
    output [63:0] Q1
);

reg  [63:0] T  [0:15];
wire [63:0] T_ [0:1];

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) {T[7],T[6],T[5],T[4],T[3],T[2],T[1],T[0]} <= {512{1'b0}};
    else      {T[7],T[6],T[5],T[4],T[3],T[2],T[1],T[0]} <= {T[6],T[5],T[4],T[3],T[2],T[1],T[0],D1};
end

assign T_[0] = SEL ? T[7] : D0;
assign T_[1] = SEL ? D0 : T[7];

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) {T[15],T[14],T[13],T[12],T[11],T[10],T[9],T[8]} <= {512{1'b0}};
    else      {T[15],T[14],T[13],T[12],T[11],T[10],T[9],T[8]} <= {T[14],T[13],T[12],T[11],T[10],T[9],T[8],T_[0]};
end

assign Q0 = T[15];
assign Q1 = T_[1];

endmodule

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
