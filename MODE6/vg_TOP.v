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
    output [63:0] Q0,
    output [63:0] Q1
);

wire [0:0] SEL_EXTN;
wire [0:0] SEL_ITR;
wire [0:0] SEL_PERMW;
wire [0:0] SEL_PERMR;
wire [0:0] SEL_MDCFFT;
wire [0:0] WE_FSC;
wire [0:0] WE_IOBUF;
wire [2:0] ADDR0_FSC;
wire [2:0] ADDR1_FSC;
wire [2:0] ADDR0_IOBUF;
wire [2:0] ADDR1_IOBUF;
wire [3:0] EXP0;
wire [3:0] EXP1;
wire [63:0] TF0;
wire [63:0] TF1;
wire [63:0] Q0_IOBUF;
wire [63:0] Q1_IOBUF;
wire [63:0] Q0_FSC;
wire [63:0] Q1_FSC;
wire [63:0] Q0_HRMF;
wire [63:0] Q1_HRMF;
wire [63:0] Q0_INTERFACE1;
wire [63:0] Q1_INTERFACE1;
wire [63:0] Q0_INTERFACE2;
wire [63:0] Q1_INTERFACE2;

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
    .SEL_MDCFFT(SEL_MDCFFT),
    .WE_FSC(WE_FSC),
    .WE_IOBUF(WE_IOBUF),
    .ADDR0_FSC(ADDR0_FSC),
    .ADDR1_FSC(ADDR1_FSC),
    .ADDR0_IOBUF(ADDR0_IOBUF),
    .ADDR1_IOBUF(ADDR1_IOBUF),
    .EXP0(EXP0),
    .EXP1(EXP1)
);

M2SRAM IOBUF (
    .CLK(CLK),
    .WE(WE_IOBUF),
    .ADDR0(ADDR0_IOBUF),
    .ADDR1(ADDR1_IOBUF),
    .D0(Q0_INTERFACE2),
    .D1(Q1_INTERFACE2),
    .Q0(Q0_IOBUF),
    .Q1(Q1_IOBUF)
);

M2SRAM FSC (
    .CLK(CLK),
    .WE(WE_FSC),
    .ADDR0(ADDR0_FSC),
    .ADDR1(ADDR1_FSC),
    .D0(Q0_INTERFACE2),
    .D1(Q1_INTERFACE2),
    .Q0(Q0_FSC),
    .Q1(Q1_FSC)
);

INTERFACE1 I_INTERFACE1_0 (
    .SEL_ITR(SEL_ITR),
    .SEL_PERMR(SEL_PERMR),
    .D0_IOBUF(Q0_IOBUF),
    .D1_IOBUF(Q1_IOBUF),
    .D0_FSC(Q0_FSC),
    .D1_FSC(Q1_FSC),
    .Q0(Q0_INTERFACE1),
    .Q1(Q1_INTERFACE1)
);

MDCFFT I_MDCFFT_0 (
    // CONTROL
    .CLK(CLK),
    .RSTn(RSTn),
    .SEL_MDCFFT(SEL_MDCFFT),
    // INPUT
    .D0(Q0_INTERFACE1),
    .D1(Q1_INTERFACE1),
    .TF0(TF0),
    .TF1(TF1),
    // OUTPUT
    .Q0(Q0_HRMF),
    .Q1(Q1_HRMF)
);

INTERFACE2 I_INTERFACE2_0 (
    .SEL_EXTN(SEL_EXTN),
    .SEL_PERMW(SEL_PERMW),
    .D0_EXTN(D0),
    .D1_EXTN(D1),
    .D0_HRMF(Q0_HRMF),
    .D1_HRMF(Q1_HRMF),
    .Q0(Q0_INTERFACE2),
    .Q1(Q1_INTERFACE2)
);

TFROM I_TFROM_0 (
    .CLK(CLK),
    .EXP0(EXP0),
    .EXP1(EXP1),
    .TF0(TF0),
    .TF1(TF1)
);

assign Q0  = Q0_INTERFACE1;
assign Q1  = Q1_INTERFACE1;

endmodule
