`timescale 1ns/1ps

module TFROM (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [15:0] EXP0,
    input  [15:0] EXP1,
    input  [15:0] EXP2,
    input  [15:0] EXP3,
    input  [15:0] EXP4,
    input  [15:0] EXP5,
    input  [15:0] EXP6,
    input  [15:0] EXP7,
    input  [15:0] EXP8,
    input  [15:0] EXP9,
    input  [15:0] EXP10,
    input  [15:0] EXP11,
    input  [15:0] EXP12,
    input  [15:0] EXP13,
    input  [15:0] EXP14,
    input  [15:0] EXP15,
    output [63:0] TF0,
    output [63:0] TF1,
    output [63:0] TF2,
    output [63:0] TF3,
    output [63:0] TF4,
    output [63:0] TF5,
    output [63:0] TF6,
    output [63:0] TF7,
    output [63:0] TF8,
    output [63:0] TF9,
    output [63:0] TF10,
    output [63:0] TF11,
    output [63:0] TF12,
    output [63:0] TF13,
    output [63:0] TF14,
    output [63:0] TF15
);

////////////////////// EXPONENT CONVERSION ////////////////////////
// To reduce ROM's overhead, we apply N/8 symmectric conversion. //
// However, ROM's overhead is typically in range 1 - 5 (%),      //
// This is just optimization technique.                          //
// In this case, we mitigate ROM's word size 65536 into 8192.    //
// If you don't want to use N/8 symmetric conversion,            //
// Then, you can change this code like other modes.              //
///////////////////////////////////////////////////////////////////

wire [13:0] TXP  [0:15];
wire [63:0] QROM [0:15];

// EXPCV
EXPCV I_EXPCV_0  (.EXP(EXP0),  .TXP(TXP[0]));
EXPCV I_EXPCV_1  (.EXP(EXP1),  .TXP(TXP[1]));
EXPCV I_EXPCV_2  (.EXP(EXP2),  .TXP(TXP[2]));
EXPCV I_EXPCV_3  (.EXP(EXP3),  .TXP(TXP[3]));
EXPCV I_EXPCV_4  (.EXP(EXP4),  .TXP(TXP[4]));
EXPCV I_EXPCV_5  (.EXP(EXP5),  .TXP(TXP[5]));
EXPCV I_EXPCV_6  (.EXP(EXP6),  .TXP(TXP[6]));
EXPCV I_EXPCV_7  (.EXP(EXP7),  .TXP(TXP[7]));
EXPCV I_EXPCV_8  (.EXP(EXP8),  .TXP(TXP[8]));
EXPCV I_EXPCV_9  (.EXP(EXP9),  .TXP(TXP[9]));
EXPCV I_EXPCV_10 (.EXP(EXP10), .TXP(TXP[10]));
EXPCV I_EXPCV_11 (.EXP(EXP11), .TXP(TXP[11]));
EXPCV I_EXPCV_12 (.EXP(EXP12), .TXP(TXP[12]));
EXPCV I_EXPCV_13 (.EXP(EXP13), .TXP(TXP[13]));
EXPCV I_EXPCV_14 (.EXP(EXP14), .TXP(TXP[14]));
EXPCV I_EXPCV_15 (.EXP(EXP15), .TXP(TXP[15]));

// ROM
ROM I_ROM_U0  (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[0]),  .Q(QROM[0]));
ROM I_ROM_U1  (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[1]),  .Q(QROM[1]));
ROM I_ROM_U2  (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[2]),  .Q(QROM[2]));
ROM I_ROM_U3  (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[3]),  .Q(QROM[3]));
ROM I_ROM_U4  (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[4]),  .Q(QROM[4]));
ROM I_ROM_U5  (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[5]),  .Q(QROM[5]));
ROM I_ROM_U6  (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[6]),  .Q(QROM[6]));
ROM I_ROM_U7  (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[7]),  .Q(QROM[7]));
ROM I_ROM_U8  (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[8]),  .Q(QROM[8]));
ROM I_ROM_U9  (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[9]),  .Q(QROM[9]));
ROM I_ROM_U10 (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[10]), .Q(QROM[10]));
ROM I_ROM_U11 (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[11]), .Q(QROM[11]));
ROM I_ROM_U12 (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[12]), .Q(QROM[12]));
ROM I_ROM_U13 (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[13]), .Q(QROM[13]));
ROM I_ROM_U14 (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[14]), .Q(QROM[14]));
ROM I_ROM_U15 (.CLK(CLK), .RSTn(RSTn), .ADDR(TXP[15]), .Q(QROM[15]));

// TFCV
TFCV I_TFCV_0  (.CLK(CLK), .RSTn(RSTn), .EXP(EXP0[15:13]),  .QROM(QROM[0]),  .TF(TF0));
TFCV I_TFCV_1  (.CLK(CLK), .RSTn(RSTn), .EXP(EXP1[15:13]),  .QROM(QROM[1]),  .TF(TF1));
TFCV I_TFCV_2  (.CLK(CLK), .RSTn(RSTn), .EXP(EXP2[15:13]),  .QROM(QROM[2]),  .TF(TF2));
TFCV I_TFCV_3  (.CLK(CLK), .RSTn(RSTn), .EXP(EXP3[15:13]),  .QROM(QROM[3]),  .TF(TF3));
TFCV I_TFCV_4  (.CLK(CLK), .RSTn(RSTn), .EXP(EXP4[15:13]),  .QROM(QROM[4]),  .TF(TF4));
TFCV I_TFCV_5  (.CLK(CLK), .RSTn(RSTn), .EXP(EXP5[15:13]),  .QROM(QROM[5]),  .TF(TF5));
TFCV I_TFCV_6  (.CLK(CLK), .RSTn(RSTn), .EXP(EXP6[15:13]),  .QROM(QROM[6]),  .TF(TF6));
TFCV I_TFCV_7  (.CLK(CLK), .RSTn(RSTn), .EXP(EXP7[15:13]),  .QROM(QROM[7]),  .TF(TF7));
TFCV I_TFCV_8  (.CLK(CLK), .RSTn(RSTn), .EXP(EXP8[15:13]),  .QROM(QROM[8]),  .TF(TF8));
TFCV I_TFCV_9  (.CLK(CLK), .RSTn(RSTn), .EXP(EXP9[15:13]),  .QROM(QROM[9]),  .TF(TF9));
TFCV I_TFCV_10 (.CLK(CLK), .RSTn(RSTn), .EXP(EXP10[15:13]), .QROM(QROM[10]), .TF(TF10));
TFCV I_TFCV_11 (.CLK(CLK), .RSTn(RSTn), .EXP(EXP11[15:13]), .QROM(QROM[11]), .TF(TF11));
TFCV I_TFCV_12 (.CLK(CLK), .RSTn(RSTn), .EXP(EXP12[15:13]), .QROM(QROM[12]), .TF(TF12));
TFCV I_TFCV_13 (.CLK(CLK), .RSTn(RSTn), .EXP(EXP13[15:13]), .QROM(QROM[13]), .TF(TF13));
TFCV I_TFCV_14 (.CLK(CLK), .RSTn(RSTn), .EXP(EXP14[15:13]), .QROM(QROM[14]), .TF(TF14));
TFCV I_TFCV_15 (.CLK(CLK), .RSTn(RSTn), .EXP(EXP15[15:13]), .QROM(QROM[15]), .TF(TF15));

endmodule

module EXPCV (
    input  [15:0] EXP,
    output [13:0] TXP
);

// BASE LUT
reg  [17:0] LUT;
wire [17:0] TXP_ [1:3];

always @(*) begin
    case (EXP[15:13])
       3'b000 : LUT = 17'd0;
       3'b001 : LUT = 17'd16384;
       3'b010 : LUT = 17'd16384;
       3'b011 : LUT = 17'd32768;
       3'b100 : LUT = 17'd32768;
       3'b101 : LUT = 17'd49152;
       3'b110 : LUT = 17'd49152;
       3'b111 : LUT = 17'd65536;
    endcase
end

assign TXP_[1] = (EXP[13]) ? LUT : EXP;
assign TXP_[2] = (EXP[13]) ? EXP : LUT;
assign TXP_[3] = TXP_[1] - TXP_[2];
assign TXP     = TXP_[3][13:0];

endmodule

module TFCV (
    input  [0:0]   CLK,
    input  [0:0]   RSTn,
    input  [2:0]   EXP,
    input  [63:0]  QROM,
    output [63:0]  TF
);

reg  [2:0]  DXP;
wire [31:0] T [0:3];
wire SEL      [0:2];

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) DXP <= {3{1'b0}};
    else      DXP <= EXP;
end

assign SEL[0] = DXP[1] ^ DXP[0];
assign SEL[1] = DXP[2] ^ DXP[1];
assign SEL[2] = DXP[2];

assign T[0] = SEL[0] ? QROM[31:0] : QROM[63:32];
assign T[1] = ~T[0] + 1'b1;
assign T[2] = SEL[0] ? QROM[63:32] : QROM[31:0];
assign T[3] = ~T[2] + 1'b1;

assign TF[63:32] = SEL[1] ? T[1] : T[0];
assign TF[31:0]  = SEL[2] ? T[3] : T[2];

endmodule

module ROM (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [13:0] ADDR,
    output [63:0] Q
);

reg [63:0] T;
reg MSB;

// INITIALIZATION for ROM modeling
localparam MEM_PATH = "../FILE/TF.hex";
reg [63:0] MEM [0:8191];

initial begin
    $readmemh(MEM_PATH, MEM);
end

// ROM model
always @(posedge CLK) begin
    T <= MEM[ADDR[12:0]];
end

// Timing Control
always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) MSB <= 1'b0;
    else      MSB <= ADDR[13];
end

assign Q = MSB ? 64'h0000b5040000b504 : T;

endmodule
