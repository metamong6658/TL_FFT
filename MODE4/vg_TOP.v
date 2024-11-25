`timescale 1ns/1ps

module TOP (
    // CONTROL
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [0:0]  START,
    output [0:0]  DONE,
    // DATA
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

wire [0:0] SEL_EXTN;
wire [0:0] SEL_ITR;
wire [2:0] SEL_PERMW;
wire [2:0] SEL_PERMR;
wire [2:0] SEL_HRMF;
wire [0:0] WE_FSC;
wire [0:0] WE_IOBUF;
wire [8:0] ADDR0_FSC;
wire [8:0] ADDR1_FSC;
wire [8:0] ADDR2_FSC;
wire [8:0] ADDR3_FSC;
wire [8:0] ADDR4_FSC;
wire [8:0] ADDR5_FSC;
wire [8:0] ADDR6_FSC;
wire [8:0] ADDR7_FSC;
wire [8:0] ADDR0_IOBUF;
wire [8:0] ADDR1_IOBUF;
wire [8:0] ADDR2_IOBUF;
wire [8:0] ADDR3_IOBUF;
wire [8:0] ADDR4_IOBUF;
wire [8:0] ADDR5_IOBUF;
wire [8:0] ADDR6_IOBUF;
wire [8:0] ADDR7_IOBUF;
wire [11:0] EXP0;
wire [11:0] EXP1;
wire [11:0] EXP2;
wire [11:0] EXP3;
wire [11:0] EXP4;
wire [11:0] EXP5;
wire [11:0] EXP6;
wire [11:0] EXP7;
wire [63:0] TF0;
wire [63:0] TF1;
wire [63:0] TF2;
wire [63:0] TF3;
wire [63:0] TF4;
wire [63:0] TF5;
wire [63:0] TF6;
wire [63:0] TF7;

wire [63:0] Q0_IOBUF;
wire [63:0] Q1_IOBUF;
wire [63:0] Q2_IOBUF;
wire [63:0] Q3_IOBUF;
wire [63:0] Q4_IOBUF;
wire [63:0] Q5_IOBUF;
wire [63:0] Q6_IOBUF;
wire [63:0] Q7_IOBUF;
wire [63:0] Q0_FSC;
wire [63:0] Q1_FSC;
wire [63:0] Q2_FSC;
wire [63:0] Q3_FSC;
wire [63:0] Q4_FSC;
wire [63:0] Q5_FSC;
wire [63:0] Q6_FSC;
wire [63:0] Q7_FSC;
wire [63:0] Q0_HRMF;
wire [63:0] Q1_HRMF;
wire [63:0] Q2_HRMF;
wire [63:0] Q3_HRMF;
wire [63:0] Q4_HRMF;
wire [63:0] Q5_HRMF;
wire [63:0] Q6_HRMF;
wire [63:0] Q7_HRMF;
wire [63:0] Q0_INTERFACE1;
wire [63:0] Q1_INTERFACE1;
wire [63:0] Q2_INTERFACE1;
wire [63:0] Q3_INTERFACE1;
wire [63:0] Q4_INTERFACE1;
wire [63:0] Q5_INTERFACE1;
wire [63:0] Q6_INTERFACE1;
wire [63:0] Q7_INTERFACE1;
wire [63:0] Q0_INTERFACE2;
wire [63:0] Q1_INTERFACE2;
wire [63:0] Q2_INTERFACE2;
wire [63:0] Q3_INTERFACE2;
wire [63:0] Q4_INTERFACE2;
wire [63:0] Q5_INTERFACE2;
wire [63:0] Q6_INTERFACE2;
wire [63:0] Q7_INTERFACE2;

// CTRL
CTRL I_CTRL_0 (
    // EXTERNAL I/O
    .CLK(CLK),
    .RSTn(RSTn),
    .START(START),
    .DONE(DONE),
    // INTERNAL I/O
    .SEL_EXTN(SEL_EXTN),
    .SEL_ITR(SEL_ITR),
    .SEL_PERMW(SEL_PERMW),
    .SEL_PERMR(SEL_PERMR),
    .SEL_HRMF(SEL_HRMF),
    .WE_FSC(WE_FSC),
    .WE_IOBUF(WE_IOBUF),
    .ADDR0_FSC(ADDR0_FSC),
    .ADDR1_FSC(ADDR1_FSC),
    .ADDR2_FSC(ADDR2_FSC),
    .ADDR3_FSC(ADDR3_FSC),
    .ADDR4_FSC(ADDR4_FSC),
    .ADDR5_FSC(ADDR5_FSC),
    .ADDR6_FSC(ADDR6_FSC),
    .ADDR7_FSC(ADDR7_FSC),
    .ADDR0_IOBUF(ADDR0_IOBUF),
    .ADDR1_IOBUF(ADDR1_IOBUF),
    .ADDR2_IOBUF(ADDR2_IOBUF),
    .ADDR3_IOBUF(ADDR3_IOBUF),
    .ADDR4_IOBUF(ADDR4_IOBUF),
    .ADDR5_IOBUF(ADDR5_IOBUF),
    .ADDR6_IOBUF(ADDR6_IOBUF),
    .ADDR7_IOBUF(ADDR7_IOBUF),
    .EXP0(EXP0),
    .EXP1(EXP1),
    .EXP2(EXP2),
    .EXP3(EXP3),
    .EXP4(EXP4),
    .EXP5(EXP5),
    .EXP6(EXP6),
    .EXP7(EXP7)
);

M8SRAM IOBUF (
    .CLK(CLK),
    .WE(WE_IOBUF),
    .ADDR0(ADDR0_IOBUF),
    .ADDR1(ADDR1_IOBUF),
    .ADDR2(ADDR2_IOBUF),
    .ADDR3(ADDR3_IOBUF),
    .ADDR4(ADDR4_IOBUF),
    .ADDR5(ADDR5_IOBUF),
    .ADDR6(ADDR6_IOBUF),
    .ADDR7(ADDR7_IOBUF),
    .D0(Q0_INTERFACE2),
    .D1(Q1_INTERFACE2),
    .D2(Q2_INTERFACE2),
    .D3(Q3_INTERFACE2),
    .D4(Q4_INTERFACE2),
    .D5(Q5_INTERFACE2),
    .D6(Q6_INTERFACE2),
    .D7(Q7_INTERFACE2),
    .Q0(Q0_IOBUF),
    .Q1(Q1_IOBUF),
    .Q2(Q2_IOBUF),
    .Q3(Q3_IOBUF),
    .Q4(Q4_IOBUF),
    .Q5(Q5_IOBUF),
    .Q6(Q6_IOBUF),
    .Q7(Q7_IOBUF)
);

M8SRAM FSC (
    .CLK(CLK),
    .WE(WE_FSC),
    .ADDR0(ADDR0_FSC),
    .ADDR1(ADDR1_FSC),
    .ADDR2(ADDR2_FSC),
    .ADDR3(ADDR3_FSC),
    .ADDR4(ADDR4_FSC),
    .ADDR5(ADDR5_FSC),
    .ADDR6(ADDR6_FSC),
    .ADDR7(ADDR7_FSC),
    .D0(Q0_INTERFACE2),
    .D1(Q1_INTERFACE2),
    .D2(Q2_INTERFACE2),
    .D3(Q3_INTERFACE2),
    .D4(Q4_INTERFACE2),
    .D5(Q5_INTERFACE2),
    .D6(Q6_INTERFACE2),
    .D7(Q7_INTERFACE2),
    .Q0(Q0_FSC),
    .Q1(Q1_FSC),
    .Q2(Q2_FSC),
    .Q3(Q3_FSC),
    .Q4(Q4_FSC),
    .Q5(Q5_FSC),
    .Q6(Q6_FSC),
    .Q7(Q7_FSC)
);

INTERFACE1 I_INTERFACE1_0 (
    .SEL_ITR(SEL_ITR),
    .SEL_PERMR(SEL_PERMR),
    .D0_IOBUF(Q0_IOBUF),
    .D1_IOBUF(Q1_IOBUF),
    .D2_IOBUF(Q2_IOBUF),
    .D3_IOBUF(Q3_IOBUF),
    .D4_IOBUF(Q4_IOBUF),
    .D5_IOBUF(Q5_IOBUF),
    .D6_IOBUF(Q6_IOBUF),
    .D7_IOBUF(Q7_IOBUF),
    .D0_FSC(Q0_FSC),
    .D1_FSC(Q1_FSC),
    .D2_FSC(Q2_FSC),
    .D3_FSC(Q3_FSC),
    .D4_FSC(Q4_FSC),
    .D5_FSC(Q5_FSC),
    .D6_FSC(Q6_FSC),
    .D7_FSC(Q7_FSC),
    .Q0(Q0_INTERFACE1),
    .Q1(Q1_INTERFACE1),
    .Q2(Q2_INTERFACE1),
    .Q3(Q3_INTERFACE1),
    .Q4(Q4_INTERFACE1),
    .Q5(Q5_INTERFACE1),
    .Q6(Q6_INTERFACE1),
    .Q7(Q7_INTERFACE1)
);

HRMF I_HRMF_0 (
    // CONTROL
    .CLK(CLK),
    .RSTn(RSTn),
    .SEL_HRMF(SEL_HRMF),
    // INPUT
    .D0(Q0_INTERFACE1),
    .D1(Q1_INTERFACE1),
    .D2(Q2_INTERFACE1),
    .D3(Q3_INTERFACE1),
    .D4(Q4_INTERFACE1),
    .D5(Q5_INTERFACE1),
    .D6(Q6_INTERFACE1),
    .D7(Q7_INTERFACE1),
    .TF0(TF0),
    .TF1(TF1),
    .TF2(TF2),
    .TF3(TF3),
    .TF4(TF4),
    .TF5(TF5),
    .TF6(TF6),
    .TF7(TF7),
    // OUTPUT
    .Q0(Q0_HRMF),
    .Q1(Q1_HRMF),
    .Q2(Q2_HRMF),
    .Q3(Q3_HRMF),
    .Q4(Q4_HRMF),
    .Q5(Q5_HRMF),
    .Q6(Q6_HRMF),
    .Q7(Q7_HRMF)
);

INTERFACE2 I_INTERFACE2_0 (
    .SEL_EXTN(SEL_EXTN),
    .SEL_PERMW(SEL_PERMW),
    .D0_EXTN(D0),
    .D1_EXTN(D1),
    .D2_EXTN(D2),
    .D3_EXTN(D3),
    .D4_EXTN(D4),
    .D5_EXTN(D5),
    .D6_EXTN(D6),
    .D7_EXTN(D7),
    .D0_HRMF(Q0_HRMF),
    .D1_HRMF(Q1_HRMF),
    .D2_HRMF(Q2_HRMF),
    .D3_HRMF(Q3_HRMF),
    .D4_HRMF(Q4_HRMF),
    .D5_HRMF(Q5_HRMF),
    .D6_HRMF(Q6_HRMF),
    .D7_HRMF(Q7_HRMF),
    .Q0(Q0_INTERFACE2),
    .Q1(Q1_INTERFACE2),
    .Q2(Q2_INTERFACE2),
    .Q3(Q3_INTERFACE2),
    .Q4(Q4_INTERFACE2),
    .Q5(Q5_INTERFACE2),
    .Q6(Q6_INTERFACE2),
    .Q7(Q7_INTERFACE2)
);

TFROM I_TFROM_0 (
    .CLK(CLK),
    .EXP0(EXP0),
    .EXP1(EXP1),
    .EXP2(EXP2),
    .EXP3(EXP3),
    .EXP4(EXP4),
    .EXP5(EXP5),
    .EXP6(EXP6),
    .EXP7(EXP7),
    .TF0(TF0),
    .TF1(TF1),
    .TF2(TF2),
    .TF3(TF3),
    .TF4(TF4),
    .TF5(TF5),
    .TF6(TF6),
    .TF7(TF7)
);

assign Q0 = Q0_INTERFACE1;
assign Q1 = Q1_INTERFACE1;
assign Q2 = Q2_INTERFACE1;
assign Q3 = Q3_INTERFACE1;
assign Q4 = Q4_INTERFACE1;
assign Q5 = Q5_INTERFACE1;
assign Q6 = Q6_INTERFACE1;
assign Q7 = Q7_INTERFACE1;

endmodule
