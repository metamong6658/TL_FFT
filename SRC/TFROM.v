`timescale 1ns/1ps

module TFROM (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [7:0]  EXP0,
    input  [7:0]  EXP1,
    input  [7:0]  EXP2,
    input  [7:0]  EXP3,
    output [63:0] TF0,
    output [63:0] TF1,
    output [63:0] TF2,
    output [63:0] TF3
);

wire [5:0] T [0:3];
wire [63:0] QROM [0:3];

// EXPONENT CONVERSION
EXPCV I_EXPCV_0 (
    .e(EXP0),
    .t(T[0])
);
EXPCV I_EXPCV_1 (
    .e(EXP1),
    .t(T[1])
);
EXPCV I_EXPCV_2 (
    .e(EXP2),
    .t(T[2])
);
EXPCV I_EXPCV_3 (
    .e(EXP3),
    .t(T[3])
);

// ROM
ROM I_ROM_U0 (
    .CLK(CLK),
    .RSTn(RSTn),
    .addr(T[0]),
    .dout(QROM[0])
);
ROM I_ROM_U1 (
    .CLK(CLK),
    .RSTn(RSTn),
    .addr(T[1]),
    .dout(QROM[1])
);
ROM I_ROM_U2 (
    .CLK(CLK),
    .RSTn(RSTn),
    .addr(T[2]),
    .dout(QROM[2])
);
ROM I_ROM_U3 (
    .CLK(CLK),
    .RSTn(RSTn),
    .addr(T[3]),
    .dout(QROM[3])
);

// TWIDDLE FACOTR CONVERSION
TFCV I_TFCV_U0 (
    .CLK(CLK),
    .RSTn(RSTn),
    .e(EXP0[7:5]),
    .cos(QROM[0][63:32]),
    .sin(QROM[0][31:0]),
    .re(TF0[63:32]),
    .im(TF0[31:0])
);
TFCV I_TFCV_U1 (
    .CLK(CLK),
    .RSTn(RSTn),
    .e(EXP1[7:5]),
    .cos(QROM[1][63:32]),
    .sin(QROM[1][31:0]),
    .re(TF1[63:32]),
    .im(TF1[31:0])
);
TFCV I_TFCV_U2 (
    .CLK(CLK),
    .RSTn(RSTn),
    .e(EXP2[7:5]),
    .cos(QROM[2][63:32]),
    .sin(QROM[2][31:0]),
    .re(TF2[63:32]),
    .im(TF2[31:0])
);
TFCV I_TFCV_U3 (
    .CLK(CLK),
    .RSTn(RSTn),
    .e(EXP3[7:5]),
    .cos(QROM[3][63:32]),
    .sin(QROM[3][31:0]),
    .re(TF3[63:32]),
    .im(TF3[31:0])
);
endmodule

module EXPCV (
    input  [7:0] e,
    output [5:0] t
);

reg [8:0] n [0:3];

always @(*) begin
    case (e[7:5])
       3'b000 : n[0] = 9'd0;
       3'b001 : n[0] = 9'd64;
       3'b010 : n[0] = 9'd64;
       3'b011 : n[0] = 9'd128;
       3'b100 : n[0] = 9'd128;
       3'b101 : n[0] = 9'd192;
       3'b110 : n[0] = 9'd192;
       3'b111 : n[0] = 9'd256;
    endcase
end

always @(*) n[1] = (e[5]) ? n[0] : e;
always @(*) n[2] = (e[5]) ? e : n[0];
always @(*) n[3] = n[1] - n[2];
assign t =  n[3][5:0];

endmodule

module TFCV (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [2:0]  e,
    input  [31:0] cos,
    input  [31:0] sin,
    output [31:0] re,
    output [31:0] im
);

reg  [2:0]  de;
wire [0:0]  s [0:2];
wire [31:0] n [0:3];
    
always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) de <= 3'b000;
    else      de <= e;
end

assign s[0] = de[1] ^ de[0];
assign s[1] = de[2] ^ de[1];
assign s[2] = de[2];

assign n[0] = (s[0]) ? sin : cos;
assign n[1] = ~n[0] + 1'b1;
assign n[2] = (s[0]) ? cos : sin;
assign n[3] = ~n[2] + 1'b1;

assign re = (s[1]) ? n[1] : n[0];
assign im = (s[2]) ? n[3] : n[2];

endmodule

module ROM (
    input  [0:0]  CLK,
    input  [0:0]  RSTn,
    input  [5:0]  addr,
    output [63:0] dout
);

// INITIALIZATION for ROM modeling
localparam MEM_PATH = "../TF.hex";
reg [63:0] MEM [0:31];
initial begin
    $readmemh(MEM_PATH, MEM);
end

// Timing Control
reg  [0:0]  addr_msb;
reg  [63:0] dout_t;

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) addr_msb <= 1'b0;
    else      addr_msb <= addr[5];
end

// ROM model
always @(posedge CLK) begin
    dout_t <= MEM[addr[4:0]];
end

// Output Selection
assign dout = (addr_msb) ? 64'h0000b5040000b504 : dout_t; 

endmodule