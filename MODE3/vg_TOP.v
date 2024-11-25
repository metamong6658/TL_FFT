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
    output [63:0] Q0,
    output [63:0] Q1,
    output [63:0] Q2,
    output [63:0] Q3
);

wire [0:0] SEL_EXTN;
wire [0:0] SEL_ITR;
wire [1:0] SEL_PERMW;
wire [1:0] SEL_PERMR;
wire [0:0] WE_FSC;
wire [0:0] WE_IOBUF;
wire [1:0] ADDR0_FSC;
wire [1:0] ADDR1_FSC;
wire [1:0] ADDR2_FSC;
wire [1:0] ADDR3_FSC;
wire [1:0] ADDR0_IOBUF;
wire [1:0] ADDR1_IOBUF;
wire [1:0] ADDR2_IOBUF;
wire [1:0] ADDR3_IOBUF;
wire [3:0] EXP1;
wire [3:0] EXP2;
wire [3:0] EXP3;
wire [63:0] TF1;
wire [63:0] TF2;
wire [63:0] TF3;

wire [63:0] Q0_IOBUF;
wire [63:0] Q1_IOBUF;
wire [63:0] Q2_IOBUF;
wire [63:0] Q3_IOBUF;
wire [63:0] Q0_FSC;
wire [63:0] Q1_FSC;
wire [63:0] Q2_FSC;
wire [63:0] Q3_FSC;
wire [63:0] Q0_HRMF;
wire [63:0] Q1_HRMF;
wire [63:0] Q2_HRMF;
wire [63:0] Q3_HRMF;
wire [63:0] Q0_INTERFACE1;
wire [63:0] Q1_INTERFACE1;
wire [63:0] Q2_INTERFACE1;
wire [63:0] Q3_INTERFACE1;
wire [63:0] Q0_INTERFACE2;
wire [63:0] Q1_INTERFACE2;
wire [63:0] Q2_INTERFACE2;
wire [63:0] Q3_INTERFACE2;

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
    .WE_FSC(WE_FSC),
    .WE_IOBUF(WE_IOBUF),
    .ADDR0_FSC(ADDR0_FSC),
    .ADDR1_FSC(ADDR1_FSC),
    .ADDR2_FSC(ADDR2_FSC),
    .ADDR3_FSC(ADDR3_FSC),
    .ADDR0_IOBUF(ADDR0_IOBUF),
    .ADDR1_IOBUF(ADDR1_IOBUF),
    .ADDR2_IOBUF(ADDR2_IOBUF),
    .ADDR3_IOBUF(ADDR3_IOBUF),
    .EXP1(EXP1),
    .EXP2(EXP2),
    .EXP3(EXP3)
);

M4SRAM IOBUF (
    .CLK(CLK),
    .WE(WE_IOBUF),
    .ADDR0(ADDR0_IOBUF),
    .ADDR1(ADDR1_IOBUF),
    .ADDR2(ADDR2_IOBUF),
    .ADDR3(ADDR3_IOBUF),
    .D0(Q0_INTERFACE2),
    .D1(Q1_INTERFACE2),
    .D2(Q2_INTERFACE2),
    .D3(Q3_INTERFACE2),
    .Q0(Q0_IOBUF),
    .Q1(Q1_IOBUF),
    .Q2(Q2_IOBUF),
    .Q3(Q3_IOBUF)
);

M4SRAM FSC (
    .CLK(CLK),
    .WE(WE_FSC),
    .ADDR0(ADDR0_FSC),
    .ADDR1(ADDR1_FSC),
    .ADDR2(ADDR2_FSC),
    .ADDR3(ADDR3_FSC),
    .D0(Q0_INTERFACE2),
    .D1(Q1_INTERFACE2),
    .D2(Q2_INTERFACE2),
    .D3(Q3_INTERFACE2),
    .Q0(Q0_FSC),
    .Q1(Q1_FSC),
    .Q2(Q2_FSC),
    .Q3(Q3_FSC)
);

INTERFACE1 I_INTERFACE1_0 (
    .SEL_ITR(SEL_ITR),
    .SEL_PERMR(SEL_PERMR),
    .D0_IOBUF(Q0_IOBUF),
    .D1_IOBUF(Q1_IOBUF),
    .D2_IOBUF(Q2_IOBUF),
    .D3_IOBUF(Q3_IOBUF),
    .D0_FSC(Q0_FSC),
    .D1_FSC(Q1_FSC),
    .D2_FSC(Q2_FSC),
    .D3_FSC(Q3_FSC),
    .Q0(Q0_INTERFACE1),
    .Q1(Q1_INTERFACE1),
    .Q2(Q2_INTERFACE1),
    .Q3(Q3_INTERFACE1)
);

HRMF I_HRMF_0 (
    // CONTROL
    .CLK(CLK),
    .RSTn(RSTn),
    // INPUT
    .D0(Q0_INTERFACE1),
    .D1(Q1_INTERFACE1),
    .D2(Q2_INTERFACE1),
    .D3(Q3_INTERFACE1),
    .TF1(TF1),
    .TF2(TF2),
    .TF3(TF3),
    // OUTPUT
    .Q0(Q0_HRMF),
    .Q1(Q1_HRMF),
    .Q2(Q2_HRMF),
    .Q3(Q3_HRMF)
);

INTERFACE2 I_INTERFACE2_0 (
    .SEL_EXTN(SEL_EXTN),
    .SEL_PERMW(SEL_PERMW),
    .D0_EXTN(D0),
    .D1_EXTN(D1),
    .D2_EXTN(D2),
    .D3_EXTN(D3),
    .D0_HRMF(Q0_HRMF),
    .D1_HRMF(Q1_HRMF),
    .D2_HRMF(Q2_HRMF),
    .D3_HRMF(Q3_HRMF),
    .Q0(Q0_INTERFACE2),
    .Q1(Q1_INTERFACE2),
    .Q2(Q2_INTERFACE2),
    .Q3(Q3_INTERFACE2)
);

TFROM I_TFROM_0 (
    .CLK(CLK),
    .EXP1(EXP1),
    .EXP2(EXP2),
    .EXP3(EXP3),
    .TF1(TF1),
    .TF2(TF2),
    .TF3(TF3)
);

assign Q0 = Q0_INTERFACE1;
assign Q1 = Q1_INTERFACE1;
assign Q2 = Q2_INTERFACE1;
assign Q3 = Q3_INTERFACE1;

endmodule
