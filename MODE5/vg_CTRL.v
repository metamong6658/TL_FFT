`timescale 1ns/1ps

module CTRL (
    // EXTERNAL I/O
    input      [0:0]   CLK,
    input      [0:0]   RSTn,
    input      [0:0]   START,
    output     [0:0]   DONE,
    // INTERNAL I/O
    output     [0:0]   SEL_EXTN,
    output     [0:0]   SEL_ITR,
    output     [3:0]   SEL_PERMW, // Right Rotation
    output     [3:0]   SEL_PERMR, // Left  Rotation
    output     [3:0]   SEL_HRMF,
    output reg [0:0]   WE_FSC,
    output reg [0:0]   WE_IOBUF,
    output reg [11:0]  ADDR0_FSC,
    output reg [11:0]  ADDR1_FSC,
    output reg [11:0]  ADDR2_FSC,
    output reg [11:0]  ADDR3_FSC,
    output reg [11:0]  ADDR4_FSC,
    output reg [11:0]  ADDR5_FSC,
    output reg [11:0]  ADDR6_FSC,
    output reg [11:0]  ADDR7_FSC,
    output reg [11:0]  ADDR8_FSC,
    output reg [11:0]  ADDR9_FSC,
    output reg [11:0]  ADDR10_FSC,
    output reg [11:0]  ADDR11_FSC,
    output reg [11:0]  ADDR12_FSC,
    output reg [11:0]  ADDR13_FSC,
    output reg [11:0]  ADDR14_FSC,
    output reg [11:0]  ADDR15_FSC,
    output reg [11:0]  ADDR0_IOBUF,
    output reg [11:0]  ADDR1_IOBUF,
    output reg [11:0]  ADDR2_IOBUF,
    output reg [11:0]  ADDR3_IOBUF,
    output reg [11:0]  ADDR4_IOBUF,
    output reg [11:0]  ADDR5_IOBUF,
    output reg [11:0]  ADDR6_IOBUF,
    output reg [11:0]  ADDR7_IOBUF,
    output reg [11:0]  ADDR8_IOBUF,
    output reg [11:0]  ADDR9_IOBUF,
    output reg [11:0]  ADDR10_IOBUF,
    output reg [11:0]  ADDR11_IOBUF,
    output reg [11:0]  ADDR12_IOBUF,
    output reg [11:0]  ADDR13_IOBUF,
    output reg [11:0]  ADDR14_IOBUF,
    output reg [11:0]  ADDR15_IOBUF,
    output     [15:0]  EXP0,
    output     [15:0]  EXP1,
    output     [15:0]  EXP2,
    output     [15:0]  EXP3,
    output     [15:0]  EXP4,
    output     [15:0]  EXP5,
    output     [15:0]  EXP6,
    output     [15:0]  EXP7,
    output     [15:0]  EXP8,
    output     [15:0]  EXP9,
    output     [15:0]  EXP10,
    output     [15:0]  EXP11,
    output     [15:0]  EXP12,
    output     [15:0]  EXP13,
    output     [15:0]  EXP14,
    output     [15:0]  EXP15
);

// PARAM, REG, WIRE
parameter [2:0] ST_IDLE = 3'b000;
parameter [2:0] ST_INPT = 3'b001;
parameter [2:0] ST_ITR1 = 3'b010;
parameter [2:0] ST_ITR2 = 3'b011;
parameter [2:0] ST_OUPT = 3'b100;
parameter [2:0] ST_STL0 = 3'b101;
parameter [2:0] ST_STL1 = 3'b110;
parameter [2:0] ST_STL2 = 3'b111;

reg [2:0]  STATE;
reg [11:0] CNT;            // MAIN COUNTER
reg [11:0] DNT;            // DELAYED COUNTER
reg [11:0] ENT;            // EXPONENT COUNTER
reg [3:0]  Am      [0:15]; // ADDRESS INDEX
reg [3:0]  Dm      [0:15]; // DELAYED ADDRES INDEX
reg [11:0] IO_ADDR [0:15];
reg [11:0] R_ADDR  [0:15];
reg [11:0] W_ADDR  [0:15];
reg [3:0]  BIr;
reg [0:0]  CLR;

wire [3:0]  C [0:2];
wire [3:0]  D [0:2];
wire [3:0]  E [0:2];
wire [3:0]  BI;
wire [3:0]  BIw;
wire [15:0] n1x;
wire [15:0] n2x;
wire [15:0] n4x;
wire [15:0] n8x;
wire [15:0] n16x;
wire [15:0] EXP0_ [0:5];
wire [0:0]  BUSY;

// FSM
always @(*) begin
    case (STATE)
        ST_IDLE : CLR = 1'b1;
        ST_INPT : CLR = (&CNT);
        ST_ITR1 : CLR = (&DNT);
        ST_ITR2 : CLR = (&DNT);
        ST_OUPT : CLR = (&CNT);
        ST_STL0 : CLR = 1'b1;
        ST_STL1 : CLR = 1'b1;
        ST_STL2 : CLR = 1'b1;
    endcase
end

assign BUSY = (STATE == ST_ITR1) | (STATE == ST_ITR2);

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) begin
        STATE <= ST_IDLE;
    end
    else begin
        case (STATE)
           ST_IDLE : STATE <= START ? ST_INPT : STATE;
           ST_INPT : STATE <= (CLR) ? ST_ITR1 : STATE;
           ST_ITR1 : STATE <= (CLR) ? ST_ITR2 : STATE;
           ST_ITR2 : STATE <= (CLR) ? ST_OUPT : STATE;
           ST_OUPT : STATE <= (CLR) ? ST_STL0 : STATE;
           ST_STL0 : STATE <= ST_STL1;
           ST_STL1 : STATE <= ST_STL2;
           ST_STL2 : STATE <= ST_IDLE;
        endcase
    end
end

// ** TRIGGER ** //
assign DONE = (STATE == ST_OUPT);

// ** COUNTER ** //
always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) CNT <= {12{1'b0}};
    else begin
        case (STATE)
            ST_IDLE : CNT <= {12{1'b0}};  
            ST_INPT : CNT <= (CLR) ? {12{1'b0}} : CNT + 1'b1;
            ST_ITR1 : CNT <= (CLR) ? {12{1'b0}} : CNT + 1'b1;
            ST_ITR2 : CNT <= (CLR) ? {12{1'b0}} : CNT + 1'b1;
            ST_OUPT : CNT <= (CLR) ? {12{1'b0}} : CNT + 1'b1;
            ST_STL0 : CNT <= {12{1'b0}};
            ST_STL1 : CNT <= {12{1'b0}};
            ST_STL2 : CNT <= {12{1'b0}};
        endcase
    end
end

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) DNT <= {12{1'b0}};
    else begin
        if(CLR == 1'b1 || BUSY == 1'b0) DNT <= {12{1'b0}};
        else begin
            if(DNT == 12'd0 && CNT < 12'd16) DNT <= {12{1'b0}};
            else DNT <= DNT + 1'b1;
        end
    end
end

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) ENT <= {12{1'b0}};
    else begin
        if(CLR == 1'b1 || BUSY == 1'b0) ENT <= {12{1'b0}};
        else begin
            if(ENT == 12'd0 && CNT < 12'd15) ENT <= {12{1'b0}};
            else ENT <= ENT + 1'b1; 
        end
    end
end

// ** Modulo 4 numbering ** //
assign {C[2],C[1],C[0]} = CNT;
assign {D[2],D[1],D[0]} = DNT;
assign {E[2],E[1],E[0]} = ENT;

// ** SELECTION ** //
// SEL PERM
assign BI = C[2] + C[1] + C[0];

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) BIr <= {4{1'b0}};
    else      BIr <= BI;
end

assign BIw = D[2] + D[1] + D[0];

assign SEL_PERMW    = (STATE == ST_INPT) ? BI : BIw;
assign SEL_PERMR    = BIr;

// SEL EXTN and ITR
assign SEL_EXTN    = (STATE == ST_INPT) ? 1'b0 : 1'b1;
assign SEL_ITR     = (STATE == ST_ITR2) ? 1'b1 : 1'b0;

// SEL_HRMF
assign SEL_HRMF = BUSY ? C[0] - 1'b1 : {4{1'b0}};

// ** WRITE ENABLE SIGNALS ** //
always @(*) begin
    case (STATE)
        ST_IDLE : WE_IOBUF = 1'b0;
        ST_INPT : WE_IOBUF = 1'b1;
        ST_ITR1 : WE_IOBUF = 1'b0;
        ST_ITR2 : WE_IOBUF = 1'b1;
        ST_OUPT : WE_IOBUF = 1'b0;
        ST_STL0 : WE_IOBUF = 1'b0;
        ST_STL1 : WE_IOBUF = 1'b0;
        ST_STL2 : WE_IOBUF = 1'b0; 
    endcase
end

always @(*) begin
    case (STATE)
        ST_IDLE : WE_FSC = 1'b0;
        ST_INPT : WE_FSC = 1'b0;
        ST_ITR1 : WE_FSC = 1'b1;
        ST_ITR2 : WE_FSC = 1'b0;
        ST_OUPT : WE_FSC = 1'b0;
        ST_STL0 : WE_FSC = 1'b0;
        ST_STL1 : WE_FSC = 1'b0;
        ST_STL2 : WE_FSC = 1'b0;
    endcase    
end

// ** ADDRESS GENERATION ** //
always @(*) begin
    case (BI)
       4'd0  : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15};
       4'd1  : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14};
       4'd2  : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13};
       4'd3  : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12};
       4'd4  : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11};
       4'd5  : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10};
       4'd6  : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9};
       4'd7  : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8};
       4'd8  : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7};
       4'd9  : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6};
       4'd10 : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5};
       4'd11 : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4};
       4'd12 : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3};
       4'd13 : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2};
       4'd14 : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1};
       4'd15 : {Am[0],Am[1],Am[2],Am[3],Am[4],Am[5],Am[6],Am[7],Am[8],Am[9],Am[10],Am[11],Am[12],Am[13],Am[14],Am[15]} = {4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0};
    endcase
end

always @(*) begin
    case (BIw)
       4'd0  : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15};
       4'd1  : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14};
       4'd2  : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13};
       4'd3  : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12};
       4'd4  : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11};
       4'd5  : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10};
       4'd6  : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9};
       4'd7  : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8};
       4'd8  : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7};
       4'd9  : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6};
       4'd10 : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5};
       4'd11 : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3, 4'd4};
       4'd12 : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2, 4'd3};
       4'd13 : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1, 4'd2};
       4'd14 : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0, 4'd1};
       4'd15 : {Dm[0],Dm[1],Dm[2],Dm[3],Dm[4],Dm[5],Dm[6],Dm[7],Dm[8],Dm[9],Dm[10],Dm[11],Dm[12],Dm[13],Dm[14],Dm[15]} = {4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15, 4'd0};    
    endcase
end

always @(*) begin
    case (STATE)
        ST_IDLE : begin
            IO_ADDR[0]  = {12{1'b0}};
            IO_ADDR[1]  = {12{1'b0}};
            IO_ADDR[2]  = {12{1'b0}};
            IO_ADDR[3]  = {12{1'b0}};
            IO_ADDR[4]  = {12{1'b0}};
            IO_ADDR[5]  = {12{1'b0}};
            IO_ADDR[6]  = {12{1'b0}};
            IO_ADDR[7]  = {12{1'b0}};
            IO_ADDR[8]  = {12{1'b0}};
            IO_ADDR[9]  = {12{1'b0}};
            IO_ADDR[10] = {12{1'b0}};
            IO_ADDR[11] = {12{1'b0}};
            IO_ADDR[12] = {12{1'b0}};
            IO_ADDR[13] = {12{1'b0}};
            IO_ADDR[14] = {12{1'b0}};
            IO_ADDR[15] = {12{1'b0}};
        end
        ST_INPT : begin
            IO_ADDR[0]  = {C[2], C[1], C[0]};
            IO_ADDR[1]  = {C[2], C[1], C[0]};
            IO_ADDR[2]  = {C[2], C[1], C[0]};
            IO_ADDR[3]  = {C[2], C[1], C[0]};        
            IO_ADDR[4]  = {C[2], C[1], C[0]};        
            IO_ADDR[5]  = {C[2], C[1], C[0]};        
            IO_ADDR[6]  = {C[2], C[1], C[0]};        
            IO_ADDR[7]  = {C[2], C[1], C[0]};        
            IO_ADDR[8]  = {C[2], C[1], C[0]};        
            IO_ADDR[9]  = {C[2], C[1], C[0]};        
            IO_ADDR[10] = {C[2], C[1], C[0]};        
            IO_ADDR[11] = {C[2], C[1], C[0]};        
            IO_ADDR[12] = {C[2], C[1], C[0]};        
            IO_ADDR[13] = {C[2], C[1], C[0]};        
            IO_ADDR[14] = {C[2], C[1], C[0]};        
            IO_ADDR[15] = {C[2], C[1], C[0]};        
        end
        ST_ITR1 : begin
            IO_ADDR[0]  = {12{1'b0}};
            IO_ADDR[1]  = {12{1'b0}};
            IO_ADDR[2]  = {12{1'b0}};
            IO_ADDR[3]  = {12{1'b0}};
            IO_ADDR[4]  = {12{1'b0}};
            IO_ADDR[5]  = {12{1'b0}};
            IO_ADDR[6]  = {12{1'b0}};
            IO_ADDR[7]  = {12{1'b0}};
            IO_ADDR[8]  = {12{1'b0}};
            IO_ADDR[9]  = {12{1'b0}};
            IO_ADDR[10] = {12{1'b0}};
            IO_ADDR[11] = {12{1'b0}};
            IO_ADDR[12] = {12{1'b0}};
            IO_ADDR[13] = {12{1'b0}};
            IO_ADDR[14] = {12{1'b0}};
            IO_ADDR[15] = {12{1'b0}};
        end
        ST_ITR2 : begin
            IO_ADDR[0]  = {12{1'b0}};
            IO_ADDR[1]  = {12{1'b0}};
            IO_ADDR[2]  = {12{1'b0}};
            IO_ADDR[3]  = {12{1'b0}};
            IO_ADDR[4]  = {12{1'b0}};
            IO_ADDR[5]  = {12{1'b0}};
            IO_ADDR[6]  = {12{1'b0}};
            IO_ADDR[7]  = {12{1'b0}};
            IO_ADDR[8]  = {12{1'b0}};
            IO_ADDR[9]  = {12{1'b0}};
            IO_ADDR[10] = {12{1'b0}};
            IO_ADDR[11] = {12{1'b0}};
            IO_ADDR[12] = {12{1'b0}};
            IO_ADDR[13] = {12{1'b0}};
            IO_ADDR[14] = {12{1'b0}};
            IO_ADDR[15] = {12{1'b0}};
        end
        ST_OUPT : begin
            IO_ADDR[0]  = {C[0], Am[0],  C[2]};
            IO_ADDR[1]  = {C[0], Am[1],  C[2]};
            IO_ADDR[2]  = {C[0], Am[2],  C[2]};
            IO_ADDR[3]  = {C[0], Am[3],  C[2]};        
            IO_ADDR[4]  = {C[0], Am[4],  C[2]};        
            IO_ADDR[5]  = {C[0], Am[5],  C[2]};        
            IO_ADDR[6]  = {C[0], Am[6],  C[2]};        
            IO_ADDR[7]  = {C[0], Am[7],  C[2]};   
            IO_ADDR[8]  = {C[0], Am[8],  C[2]};   
            IO_ADDR[9]  = {C[0], Am[9],  C[2]};   
            IO_ADDR[10] = {C[0], Am[10], C[2]};   
            IO_ADDR[11] = {C[0], Am[11], C[2]};   
            IO_ADDR[12] = {C[0], Am[12], C[2]};   
            IO_ADDR[13] = {C[0], Am[13], C[2]};   
            IO_ADDR[14] = {C[0], Am[14], C[2]};   
            IO_ADDR[15] = {C[0], Am[15], C[2]};   
        end
        ST_STL0 : begin
            IO_ADDR[0]  = {12{1'b0}};
            IO_ADDR[1]  = {12{1'b0}};
            IO_ADDR[2]  = {12{1'b0}};
            IO_ADDR[3]  = {12{1'b0}};
            IO_ADDR[4]  = {12{1'b0}};
            IO_ADDR[5]  = {12{1'b0}};
            IO_ADDR[6]  = {12{1'b0}};
            IO_ADDR[7]  = {12{1'b0}};
            IO_ADDR[8]  = {12{1'b0}};
            IO_ADDR[9]  = {12{1'b0}};
            IO_ADDR[10] = {12{1'b0}};
            IO_ADDR[11] = {12{1'b0}};
            IO_ADDR[12] = {12{1'b0}};
            IO_ADDR[13] = {12{1'b0}};
            IO_ADDR[14] = {12{1'b0}};
            IO_ADDR[15] = {12{1'b0}};
        end
        ST_STL1 : begin
            IO_ADDR[0]  = {12{1'b0}};
            IO_ADDR[1]  = {12{1'b0}};
            IO_ADDR[2]  = {12{1'b0}};
            IO_ADDR[3]  = {12{1'b0}};
            IO_ADDR[4]  = {12{1'b0}};
            IO_ADDR[5]  = {12{1'b0}};
            IO_ADDR[6]  = {12{1'b0}};
            IO_ADDR[7]  = {12{1'b0}};
            IO_ADDR[8]  = {12{1'b0}};
            IO_ADDR[9]  = {12{1'b0}};
            IO_ADDR[10] = {12{1'b0}};
            IO_ADDR[11] = {12{1'b0}};
            IO_ADDR[12] = {12{1'b0}};
            IO_ADDR[13] = {12{1'b0}};
            IO_ADDR[14] = {12{1'b0}};
            IO_ADDR[15] = {12{1'b0}};
        end
        ST_STL2 : begin
            IO_ADDR[0]  = {12{1'b0}};
            IO_ADDR[1]  = {12{1'b0}};
            IO_ADDR[2]  = {12{1'b0}};
            IO_ADDR[3]  = {12{1'b0}};
            IO_ADDR[4]  = {12{1'b0}};
            IO_ADDR[5]  = {12{1'b0}};
            IO_ADDR[6]  = {12{1'b0}};
            IO_ADDR[7]  = {12{1'b0}};
            IO_ADDR[8]  = {12{1'b0}};
            IO_ADDR[9]  = {12{1'b0}};
            IO_ADDR[10] = {12{1'b0}};
            IO_ADDR[11] = {12{1'b0}};
            IO_ADDR[12] = {12{1'b0}};
            IO_ADDR[13] = {12{1'b0}};
            IO_ADDR[14] = {12{1'b0}};
            IO_ADDR[15] = {12{1'b0}};
        end
    endcase
end

always @(*) begin
    case (STATE)
        ST_IDLE : begin
            R_ADDR[0]  = {12{1'b0}};
            R_ADDR[1]  = {12{1'b0}};
            R_ADDR[2]  = {12{1'b0}};
            R_ADDR[3]  = {12{1'b0}};
            R_ADDR[4]  = {12{1'b0}};
            R_ADDR[5]  = {12{1'b0}};
            R_ADDR[6]  = {12{1'b0}};
            R_ADDR[7]  = {12{1'b0}};
            R_ADDR[8]  = {12{1'b0}};
            R_ADDR[9]  = {12{1'b0}};
            R_ADDR[10] = {12{1'b0}};
            R_ADDR[11] = {12{1'b0}};
            R_ADDR[12] = {12{1'b0}};
            R_ADDR[13] = {12{1'b0}};
            R_ADDR[14] = {12{1'b0}};
            R_ADDR[15] = {12{1'b0}};
        end
        ST_INPT : begin
            R_ADDR[0]  = {12{1'b0}};
            R_ADDR[1]  = {12{1'b0}};
            R_ADDR[2]  = {12{1'b0}};
            R_ADDR[3]  = {12{1'b0}};
            R_ADDR[4]  = {12{1'b0}};
            R_ADDR[5]  = {12{1'b0}};
            R_ADDR[6]  = {12{1'b0}};
            R_ADDR[7]  = {12{1'b0}};
            R_ADDR[8]  = {12{1'b0}};
            R_ADDR[9]  = {12{1'b0}};
            R_ADDR[10] = {12{1'b0}};
            R_ADDR[11] = {12{1'b0}};
            R_ADDR[12] = {12{1'b0}};
            R_ADDR[13] = {12{1'b0}};
            R_ADDR[14] = {12{1'b0}};
            R_ADDR[15] = {12{1'b0}};       
        end
        ST_ITR1 : begin
            R_ADDR[0]  = {Am[0],  C[0], C[2]};
            R_ADDR[1]  = {Am[1],  C[0], C[2]};
            R_ADDR[2]  = {Am[2],  C[0], C[2]};
            R_ADDR[3]  = {Am[3],  C[0], C[2]};
            R_ADDR[4]  = {Am[4],  C[0], C[2]};
            R_ADDR[5]  = {Am[5],  C[0], C[2]};
            R_ADDR[6]  = {Am[6],  C[0], C[2]};
            R_ADDR[7]  = {Am[7],  C[0], C[2]};
            R_ADDR[8]  = {Am[8],  C[0], C[2]};
            R_ADDR[9]  = {Am[9],  C[0], C[2]};
            R_ADDR[10] = {Am[10], C[0], C[2]};
            R_ADDR[11] = {Am[11], C[0], C[2]};
            R_ADDR[12] = {Am[12], C[0], C[2]};
            R_ADDR[13] = {Am[13], C[0], C[2]};
            R_ADDR[14] = {Am[14], C[0], C[2]};
            R_ADDR[15] = {Am[15], C[0], C[2]};
        end
        ST_ITR2 : begin
            R_ADDR[0]  = {C[2], C[1], Am[0]};
            R_ADDR[1]  = {C[2], C[1], Am[1]};
            R_ADDR[2]  = {C[2], C[1], Am[2]};
            R_ADDR[3]  = {C[2], C[1], Am[3]};
            R_ADDR[4]  = {C[2], C[1], Am[4]};
            R_ADDR[5]  = {C[2], C[1], Am[5]};
            R_ADDR[6]  = {C[2], C[1], Am[6]};
            R_ADDR[7]  = {C[2], C[1], Am[7]};
            R_ADDR[8]  = {C[2], C[1], Am[8]};
            R_ADDR[9]  = {C[2], C[1], Am[9]};
            R_ADDR[10] = {C[2], C[1], Am[10]};
            R_ADDR[11] = {C[2], C[1], Am[11]};
            R_ADDR[12] = {C[2], C[1], Am[12]};
            R_ADDR[13] = {C[2], C[1], Am[13]};
            R_ADDR[14] = {C[2], C[1], Am[14]};
            R_ADDR[15] = {C[2], C[1], Am[15]};
        end
        ST_OUPT : begin
            R_ADDR[0]  = {12{1'b0}};
            R_ADDR[1]  = {12{1'b0}};
            R_ADDR[2]  = {12{1'b0}};
            R_ADDR[3]  = {12{1'b0}};
            R_ADDR[4]  = {12{1'b0}};
            R_ADDR[5]  = {12{1'b0}};
            R_ADDR[6]  = {12{1'b0}};
            R_ADDR[7]  = {12{1'b0}};
            R_ADDR[8]  = {12{1'b0}};
            R_ADDR[9]  = {12{1'b0}};
            R_ADDR[10] = {12{1'b0}};
            R_ADDR[11] = {12{1'b0}};
            R_ADDR[12] = {12{1'b0}};
            R_ADDR[13] = {12{1'b0}};
            R_ADDR[14] = {12{1'b0}};
            R_ADDR[15] = {12{1'b0}};
        end
        ST_STL0 : begin
            R_ADDR[0]  = {12{1'b0}};
            R_ADDR[1]  = {12{1'b0}};
            R_ADDR[2]  = {12{1'b0}};
            R_ADDR[3]  = {12{1'b0}};
            R_ADDR[4]  = {12{1'b0}};
            R_ADDR[5]  = {12{1'b0}};
            R_ADDR[6]  = {12{1'b0}};
            R_ADDR[7]  = {12{1'b0}};
            R_ADDR[8]  = {12{1'b0}};
            R_ADDR[9]  = {12{1'b0}};
            R_ADDR[10] = {12{1'b0}};
            R_ADDR[11] = {12{1'b0}};
            R_ADDR[12] = {12{1'b0}};
            R_ADDR[13] = {12{1'b0}};
            R_ADDR[14] = {12{1'b0}};
            R_ADDR[15] = {12{1'b0}};
        end
        ST_STL1 : begin
            R_ADDR[0]  = {12{1'b0}};
            R_ADDR[1]  = {12{1'b0}};
            R_ADDR[2]  = {12{1'b0}};
            R_ADDR[3]  = {12{1'b0}};
            R_ADDR[4]  = {12{1'b0}};
            R_ADDR[5]  = {12{1'b0}};
            R_ADDR[6]  = {12{1'b0}};
            R_ADDR[7]  = {12{1'b0}};
            R_ADDR[8]  = {12{1'b0}};
            R_ADDR[9]  = {12{1'b0}};
            R_ADDR[10] = {12{1'b0}};
            R_ADDR[11] = {12{1'b0}};
            R_ADDR[12] = {12{1'b0}};
            R_ADDR[13] = {12{1'b0}};
            R_ADDR[14] = {12{1'b0}};
            R_ADDR[15] = {12{1'b0}};
        end
        ST_STL2 : begin
            R_ADDR[0]  = {12{1'b0}};
            R_ADDR[1]  = {12{1'b0}};
            R_ADDR[2]  = {12{1'b0}};
            R_ADDR[3]  = {12{1'b0}};
            R_ADDR[4]  = {12{1'b0}};
            R_ADDR[5]  = {12{1'b0}};
            R_ADDR[6]  = {12{1'b0}};
            R_ADDR[7]  = {12{1'b0}};
            R_ADDR[8]  = {12{1'b0}};
            R_ADDR[9]  = {12{1'b0}};
            R_ADDR[10] = {12{1'b0}};
            R_ADDR[11] = {12{1'b0}};
            R_ADDR[12] = {12{1'b0}};
            R_ADDR[13] = {12{1'b0}};
            R_ADDR[14] = {12{1'b0}};
            R_ADDR[15] = {12{1'b0}};
        end 
    endcase
end

always @(*) begin
    case (STATE)
        ST_IDLE : begin
            W_ADDR[0]  = {12{1'b0}};
            W_ADDR[1]  = {12{1'b0}};
            W_ADDR[2]  = {12{1'b0}};
            W_ADDR[3]  = {12{1'b0}};
            W_ADDR[4]  = {12{1'b0}};
            W_ADDR[5]  = {12{1'b0}};
            W_ADDR[6]  = {12{1'b0}};
            W_ADDR[7]  = {12{1'b0}};
            W_ADDR[8]  = {12{1'b0}};
            W_ADDR[9]  = {12{1'b0}};
            W_ADDR[10] = {12{1'b0}};
            W_ADDR[11] = {12{1'b0}};
            W_ADDR[12] = {12{1'b0}};
            W_ADDR[13] = {12{1'b0}};
            W_ADDR[14] = {12{1'b0}};
            W_ADDR[15] = {12{1'b0}};
        end
        ST_INPT : begin
            W_ADDR[0]  = {12{1'b0}};
            W_ADDR[1]  = {12{1'b0}};
            W_ADDR[2]  = {12{1'b0}};
            W_ADDR[3]  = {12{1'b0}};
            W_ADDR[4]  = {12{1'b0}};
            W_ADDR[5]  = {12{1'b0}};
            W_ADDR[6]  = {12{1'b0}};
            W_ADDR[7]  = {12{1'b0}};
            W_ADDR[8]  = {12{1'b0}};
            W_ADDR[9]  = {12{1'b0}};
            W_ADDR[10] = {12{1'b0}};
            W_ADDR[11] = {12{1'b0}};
            W_ADDR[12] = {12{1'b0}};
            W_ADDR[13] = {12{1'b0}};
            W_ADDR[14] = {12{1'b0}};
            W_ADDR[15] = {12{1'b0}};        
        end
        ST_ITR1 : begin
            W_ADDR[0]  = {Dm[0],  D[0], D[2]};
            W_ADDR[1]  = {Dm[1],  D[0], D[2]};
            W_ADDR[2]  = {Dm[2],  D[0], D[2]};
            W_ADDR[3]  = {Dm[3],  D[0], D[2]};
            W_ADDR[4]  = {Dm[4],  D[0], D[2]};
            W_ADDR[5]  = {Dm[5],  D[0], D[2]};
            W_ADDR[6]  = {Dm[6],  D[0], D[2]};
            W_ADDR[7]  = {Dm[7],  D[0], D[2]};
            W_ADDR[8]  = {Dm[8],  D[0], D[2]};
            W_ADDR[9]  = {Dm[9],  D[0], D[2]};
            W_ADDR[10] = {Dm[10], D[0], D[2]};
            W_ADDR[11] = {Dm[11], D[0], D[2]};
            W_ADDR[12] = {Dm[12], D[0], D[2]};
            W_ADDR[13] = {Dm[13], D[0], D[2]};
            W_ADDR[14] = {Dm[14], D[0], D[2]};
            W_ADDR[15] = {Dm[15], D[0], D[2]};
        end
        ST_ITR2 : begin
            W_ADDR[0]  = {D[2], D[1], Dm[0]};
            W_ADDR[1]  = {D[2], D[1], Dm[1]};
            W_ADDR[2]  = {D[2], D[1], Dm[2]};
            W_ADDR[3]  = {D[2], D[1], Dm[3]};
            W_ADDR[4]  = {D[2], D[1], Dm[4]};
            W_ADDR[5]  = {D[2], D[1], Dm[5]};
            W_ADDR[6]  = {D[2], D[1], Dm[6]};
            W_ADDR[7]  = {D[2], D[1], Dm[7]};
            W_ADDR[8]  = {D[2], D[1], Dm[8]};
            W_ADDR[9]  = {D[2], D[1], Dm[9]};
            W_ADDR[10] = {D[2], D[1], Dm[10]};
            W_ADDR[11] = {D[2], D[1], Dm[11]};
            W_ADDR[12] = {D[2], D[1], Dm[12]};
            W_ADDR[13] = {D[2], D[1], Dm[13]};
            W_ADDR[14] = {D[2], D[1], Dm[14]};
            W_ADDR[15] = {D[2], D[1], Dm[15]};
        end
        ST_OUPT : begin
            W_ADDR[0]  = {12{1'b0}};
            W_ADDR[1]  = {12{1'b0}};
            W_ADDR[2]  = {12{1'b0}};
            W_ADDR[3]  = {12{1'b0}};
            W_ADDR[4]  = {12{1'b0}};
            W_ADDR[5]  = {12{1'b0}};
            W_ADDR[6]  = {12{1'b0}};
            W_ADDR[7]  = {12{1'b0}};
            W_ADDR[8]  = {12{1'b0}};
            W_ADDR[9]  = {12{1'b0}};
            W_ADDR[10] = {12{1'b0}};
            W_ADDR[11] = {12{1'b0}};
            W_ADDR[12] = {12{1'b0}};
            W_ADDR[13] = {12{1'b0}};
            W_ADDR[14] = {12{1'b0}};
            W_ADDR[15] = {12{1'b0}};
        end
        ST_STL0 : begin
            W_ADDR[0]  = {12{1'b0}};
            W_ADDR[1]  = {12{1'b0}};
            W_ADDR[2]  = {12{1'b0}};
            W_ADDR[3]  = {12{1'b0}};
            W_ADDR[4]  = {12{1'b0}};
            W_ADDR[5]  = {12{1'b0}};
            W_ADDR[6]  = {12{1'b0}};
            W_ADDR[7]  = {12{1'b0}};
            W_ADDR[8]  = {12{1'b0}};
            W_ADDR[9]  = {12{1'b0}};
            W_ADDR[10] = {12{1'b0}};
            W_ADDR[11] = {12{1'b0}};
            W_ADDR[12] = {12{1'b0}};
            W_ADDR[13] = {12{1'b0}};
            W_ADDR[14] = {12{1'b0}};
            W_ADDR[15] = {12{1'b0}};
        end
        ST_STL1 : begin
            W_ADDR[0]  = {12{1'b0}};
            W_ADDR[1]  = {12{1'b0}};
            W_ADDR[2]  = {12{1'b0}};
            W_ADDR[3]  = {12{1'b0}};
            W_ADDR[4]  = {12{1'b0}};
            W_ADDR[5]  = {12{1'b0}};
            W_ADDR[6]  = {12{1'b0}};
            W_ADDR[7]  = {12{1'b0}};
            W_ADDR[8]  = {12{1'b0}};
            W_ADDR[9]  = {12{1'b0}};
            W_ADDR[10] = {12{1'b0}};
            W_ADDR[11] = {12{1'b0}};
            W_ADDR[12] = {12{1'b0}};
            W_ADDR[13] = {12{1'b0}};
            W_ADDR[14] = {12{1'b0}};
            W_ADDR[15] = {12{1'b0}};
        end
        ST_STL2 : begin
            W_ADDR[0]  = {12{1'b0}};
            W_ADDR[1]  = {12{1'b0}};
            W_ADDR[2]  = {12{1'b0}};
            W_ADDR[3]  = {12{1'b0}};
            W_ADDR[4]  = {12{1'b0}};
            W_ADDR[5]  = {12{1'b0}};
            W_ADDR[6]  = {12{1'b0}};
            W_ADDR[7]  = {12{1'b0}};
            W_ADDR[8]  = {12{1'b0}};
            W_ADDR[9]  = {12{1'b0}};
            W_ADDR[10] = {12{1'b0}};
            W_ADDR[11] = {12{1'b0}};
            W_ADDR[12] = {12{1'b0}};
            W_ADDR[13] = {12{1'b0}};
            W_ADDR[14] = {12{1'b0}};
            W_ADDR[15] = {12{1'b0}};
        end    
    endcase
end

always @(*) begin
    case (STATE)
        ST_IDLE : begin
            ADDR0_FSC  = {12{1'b0}};
            ADDR1_FSC  = {12{1'b0}};
            ADDR2_FSC  = {12{1'b0}};
            ADDR3_FSC  = {12{1'b0}};
            ADDR4_FSC  = {12{1'b0}};
            ADDR5_FSC  = {12{1'b0}};
            ADDR6_FSC  = {12{1'b0}};
            ADDR7_FSC  = {12{1'b0}};
            ADDR8_FSC  = {12{1'b0}};
            ADDR9_FSC  = {12{1'b0}};
            ADDR10_FSC = {12{1'b0}};
            ADDR11_FSC = {12{1'b0}};
            ADDR12_FSC = {12{1'b0}};
            ADDR13_FSC = {12{1'b0}};
            ADDR14_FSC = {12{1'b0}};
            ADDR15_FSC = {12{1'b0}};
        end
        ST_INPT : begin
            ADDR0_FSC  = {12{1'b0}};
            ADDR1_FSC  = {12{1'b0}};
            ADDR2_FSC  = {12{1'b0}};
            ADDR3_FSC  = {12{1'b0}};
            ADDR4_FSC  = {12{1'b0}};
            ADDR5_FSC  = {12{1'b0}};
            ADDR6_FSC  = {12{1'b0}};
            ADDR7_FSC  = {12{1'b0}};
            ADDR8_FSC  = {12{1'b0}};
            ADDR9_FSC  = {12{1'b0}};
            ADDR10_FSC = {12{1'b0}};
            ADDR11_FSC = {12{1'b0}};
            ADDR12_FSC = {12{1'b0}};
            ADDR13_FSC = {12{1'b0}};
            ADDR14_FSC = {12{1'b0}};
            ADDR15_FSC = {12{1'b0}};        
        end
        ST_ITR1 : begin
            ADDR0_FSC  = W_ADDR[0];
            ADDR1_FSC  = W_ADDR[1];
            ADDR2_FSC  = W_ADDR[2];
            ADDR3_FSC  = W_ADDR[3];
            ADDR4_FSC  = W_ADDR[4];
            ADDR5_FSC  = W_ADDR[5];
            ADDR6_FSC  = W_ADDR[6];
            ADDR7_FSC  = W_ADDR[7];
            ADDR8_FSC  = W_ADDR[8];
            ADDR9_FSC  = W_ADDR[9];
            ADDR10_FSC = W_ADDR[10];
            ADDR11_FSC = W_ADDR[11];
            ADDR12_FSC = W_ADDR[12];
            ADDR13_FSC = W_ADDR[13];
            ADDR14_FSC = W_ADDR[14];
            ADDR15_FSC = W_ADDR[15];
        end
        ST_ITR2 : begin
            ADDR0_FSC  = R_ADDR[0];
            ADDR1_FSC  = R_ADDR[1];
            ADDR2_FSC  = R_ADDR[2];
            ADDR3_FSC  = R_ADDR[3];
            ADDR4_FSC  = R_ADDR[4];
            ADDR5_FSC  = R_ADDR[5];
            ADDR6_FSC  = R_ADDR[6];
            ADDR7_FSC  = R_ADDR[7];
            ADDR8_FSC  = R_ADDR[8];
            ADDR9_FSC  = R_ADDR[9];
            ADDR10_FSC = R_ADDR[10];
            ADDR11_FSC = R_ADDR[11];
            ADDR12_FSC = R_ADDR[12];
            ADDR13_FSC = R_ADDR[13];
            ADDR14_FSC = R_ADDR[14];
            ADDR15_FSC = R_ADDR[15];
        end
        ST_OUPT : begin
            ADDR0_FSC  = {12{1'b0}};
            ADDR1_FSC  = {12{1'b0}};
            ADDR2_FSC  = {12{1'b0}};
            ADDR3_FSC  = {12{1'b0}};
            ADDR4_FSC  = {12{1'b0}};
            ADDR5_FSC  = {12{1'b0}};
            ADDR6_FSC  = {12{1'b0}};
            ADDR7_FSC  = {12{1'b0}};
            ADDR8_FSC  = {12{1'b0}};
            ADDR9_FSC  = {12{1'b0}};
            ADDR10_FSC = {12{1'b0}};
            ADDR11_FSC = {12{1'b0}};
            ADDR12_FSC = {12{1'b0}};
            ADDR13_FSC = {12{1'b0}};
            ADDR14_FSC = {12{1'b0}};
            ADDR15_FSC = {12{1'b0}};
        end
        ST_STL0 : begin
            ADDR0_FSC  = {12{1'b0}};
            ADDR1_FSC  = {12{1'b0}};
            ADDR2_FSC  = {12{1'b0}};
            ADDR3_FSC  = {12{1'b0}};
            ADDR4_FSC  = {12{1'b0}};
            ADDR5_FSC  = {12{1'b0}};
            ADDR6_FSC  = {12{1'b0}};
            ADDR7_FSC  = {12{1'b0}};
            ADDR8_FSC  = {12{1'b0}};
            ADDR9_FSC  = {12{1'b0}};
            ADDR10_FSC = {12{1'b0}};
            ADDR11_FSC = {12{1'b0}};
            ADDR12_FSC = {12{1'b0}};
            ADDR13_FSC = {12{1'b0}};
            ADDR14_FSC = {12{1'b0}};
            ADDR15_FSC = {12{1'b0}};
        end
        ST_STL1 : begin
            ADDR0_FSC  = {12{1'b0}};
            ADDR1_FSC  = {12{1'b0}};
            ADDR2_FSC  = {12{1'b0}};
            ADDR3_FSC  = {12{1'b0}};
            ADDR4_FSC  = {12{1'b0}};
            ADDR5_FSC  = {12{1'b0}};
            ADDR6_FSC  = {12{1'b0}};
            ADDR7_FSC  = {12{1'b0}};
            ADDR8_FSC  = {12{1'b0}};
            ADDR9_FSC  = {12{1'b0}};
            ADDR10_FSC = {12{1'b0}};
            ADDR11_FSC = {12{1'b0}};
            ADDR12_FSC = {12{1'b0}};
            ADDR13_FSC = {12{1'b0}};
            ADDR14_FSC = {12{1'b0}};
            ADDR15_FSC = {12{1'b0}};
        end
        ST_STL2 : begin
            ADDR0_FSC  = {12{1'b0}};
            ADDR1_FSC  = {12{1'b0}};
            ADDR2_FSC  = {12{1'b0}};
            ADDR3_FSC  = {12{1'b0}};
            ADDR4_FSC  = {12{1'b0}};
            ADDR5_FSC  = {12{1'b0}};
            ADDR6_FSC  = {12{1'b0}};
            ADDR7_FSC  = {12{1'b0}};
            ADDR8_FSC  = {12{1'b0}};
            ADDR9_FSC  = {12{1'b0}};
            ADDR10_FSC = {12{1'b0}};
            ADDR11_FSC = {12{1'b0}};
            ADDR12_FSC = {12{1'b0}};
            ADDR13_FSC = {12{1'b0}};
            ADDR14_FSC = {12{1'b0}};
            ADDR15_FSC = {12{1'b0}};
        end    
    endcase
end

always @(*) begin
    case (STATE)
        ST_IDLE : begin
            ADDR0_IOBUF  = {12{1'b0}};
            ADDR1_IOBUF  = {12{1'b0}};
            ADDR2_IOBUF  = {12{1'b0}};
            ADDR3_IOBUF  = {12{1'b0}};
            ADDR4_IOBUF  = {12{1'b0}};
            ADDR5_IOBUF  = {12{1'b0}};
            ADDR6_IOBUF  = {12{1'b0}};
            ADDR7_IOBUF  = {12{1'b0}};
            ADDR8_IOBUF  = {12{1'b0}};
            ADDR9_IOBUF  = {12{1'b0}};
            ADDR10_IOBUF = {12{1'b0}};
            ADDR11_IOBUF = {12{1'b0}};
            ADDR12_IOBUF = {12{1'b0}};
            ADDR13_IOBUF = {12{1'b0}};
            ADDR14_IOBUF = {12{1'b0}};
            ADDR15_IOBUF = {12{1'b0}};
        end
        ST_INPT : begin
            ADDR0_IOBUF  = IO_ADDR[0];
            ADDR1_IOBUF  = IO_ADDR[1];
            ADDR2_IOBUF  = IO_ADDR[2];
            ADDR3_IOBUF  = IO_ADDR[3];
            ADDR4_IOBUF  = IO_ADDR[4];
            ADDR5_IOBUF  = IO_ADDR[5];
            ADDR6_IOBUF  = IO_ADDR[6];
            ADDR7_IOBUF  = IO_ADDR[7];
            ADDR8_IOBUF  = IO_ADDR[8];
            ADDR9_IOBUF  = IO_ADDR[9];
            ADDR10_IOBUF = IO_ADDR[10];
            ADDR11_IOBUF = IO_ADDR[11];
            ADDR12_IOBUF = IO_ADDR[12];
            ADDR13_IOBUF = IO_ADDR[13];
            ADDR14_IOBUF = IO_ADDR[14];
            ADDR15_IOBUF = IO_ADDR[15];
        end
        ST_ITR1 : begin
            ADDR0_IOBUF  = R_ADDR[0];
            ADDR1_IOBUF  = R_ADDR[1];
            ADDR2_IOBUF  = R_ADDR[2];
            ADDR3_IOBUF  = R_ADDR[3];
            ADDR4_IOBUF  = R_ADDR[4];
            ADDR5_IOBUF  = R_ADDR[5];
            ADDR6_IOBUF  = R_ADDR[6];
            ADDR7_IOBUF  = R_ADDR[7];
            ADDR8_IOBUF  = R_ADDR[8];
            ADDR9_IOBUF  = R_ADDR[9];
            ADDR10_IOBUF = R_ADDR[10];
            ADDR11_IOBUF = R_ADDR[11];
            ADDR12_IOBUF = R_ADDR[12];
            ADDR13_IOBUF = R_ADDR[13];
            ADDR14_IOBUF = R_ADDR[14];
            ADDR15_IOBUF = R_ADDR[15];
        end
        ST_ITR2 : begin
            ADDR0_IOBUF  = W_ADDR[0];
            ADDR1_IOBUF  = W_ADDR[1];
            ADDR2_IOBUF  = W_ADDR[2];
            ADDR3_IOBUF  = W_ADDR[3];
            ADDR4_IOBUF  = W_ADDR[4];
            ADDR5_IOBUF  = W_ADDR[5];
            ADDR6_IOBUF  = W_ADDR[6];
            ADDR7_IOBUF  = W_ADDR[7];
            ADDR8_IOBUF  = W_ADDR[8];
            ADDR9_IOBUF  = W_ADDR[9];
            ADDR10_IOBUF = W_ADDR[10];
            ADDR11_IOBUF = W_ADDR[11];
            ADDR12_IOBUF = W_ADDR[12];
            ADDR13_IOBUF = W_ADDR[13];
            ADDR14_IOBUF = W_ADDR[14];
            ADDR15_IOBUF = W_ADDR[15];
        end
        ST_OUPT : begin
            ADDR0_IOBUF  = IO_ADDR[0];
            ADDR1_IOBUF  = IO_ADDR[1];
            ADDR2_IOBUF  = IO_ADDR[2];
            ADDR3_IOBUF  = IO_ADDR[3];
            ADDR4_IOBUF  = IO_ADDR[4];
            ADDR5_IOBUF  = IO_ADDR[5];
            ADDR6_IOBUF  = IO_ADDR[6];
            ADDR7_IOBUF  = IO_ADDR[7];
            ADDR8_IOBUF  = IO_ADDR[8];
            ADDR9_IOBUF  = IO_ADDR[9];
            ADDR10_IOBUF = IO_ADDR[10];
            ADDR11_IOBUF = IO_ADDR[11];
            ADDR12_IOBUF = IO_ADDR[12];
            ADDR13_IOBUF = IO_ADDR[13];
            ADDR14_IOBUF = IO_ADDR[14];
            ADDR15_IOBUF = IO_ADDR[15];
        end
        ST_STL0 : begin
            ADDR0_IOBUF  = {12{1'b0}};
            ADDR1_IOBUF  = {12{1'b0}};
            ADDR2_IOBUF  = {12{1'b0}};
            ADDR3_IOBUF  = {12{1'b0}};
            ADDR4_IOBUF  = {12{1'b0}};
            ADDR5_IOBUF  = {12{1'b0}};
            ADDR6_IOBUF  = {12{1'b0}};
            ADDR7_IOBUF  = {12{1'b0}};
            ADDR8_IOBUF  = {12{1'b0}};
            ADDR9_IOBUF  = {12{1'b0}};
            ADDR10_IOBUF = {12{1'b0}};
            ADDR11_IOBUF = {12{1'b0}};
            ADDR12_IOBUF = {12{1'b0}};
            ADDR13_IOBUF = {12{1'b0}};
            ADDR14_IOBUF = {12{1'b0}};
            ADDR15_IOBUF = {12{1'b0}};
        end
        ST_STL1 : begin
            ADDR0_IOBUF  = {12{1'b0}};
            ADDR1_IOBUF  = {12{1'b0}};
            ADDR2_IOBUF  = {12{1'b0}};
            ADDR3_IOBUF  = {12{1'b0}};
            ADDR4_IOBUF  = {12{1'b0}};
            ADDR5_IOBUF  = {12{1'b0}};
            ADDR6_IOBUF  = {12{1'b0}};
            ADDR7_IOBUF  = {12{1'b0}};
            ADDR8_IOBUF  = {12{1'b0}};
            ADDR9_IOBUF  = {12{1'b0}};
            ADDR10_IOBUF = {12{1'b0}};
            ADDR11_IOBUF = {12{1'b0}};
            ADDR12_IOBUF = {12{1'b0}};
            ADDR13_IOBUF = {12{1'b0}};
            ADDR14_IOBUF = {12{1'b0}};
            ADDR15_IOBUF = {12{1'b0}};
        end
        ST_STL2 : begin
            ADDR0_IOBUF  = {12{1'b0}};
            ADDR1_IOBUF  = {12{1'b0}};
            ADDR2_IOBUF  = {12{1'b0}};
            ADDR3_IOBUF  = {12{1'b0}};
            ADDR4_IOBUF  = {12{1'b0}};
            ADDR5_IOBUF  = {12{1'b0}};
            ADDR6_IOBUF  = {12{1'b0}};
            ADDR7_IOBUF  = {12{1'b0}};
            ADDR8_IOBUF  = {12{1'b0}};
            ADDR9_IOBUF  = {12{1'b0}};
            ADDR10_IOBUF = {12{1'b0}};
            ADDR11_IOBUF = {12{1'b0}};
            ADDR12_IOBUF = {12{1'b0}};
            ADDR13_IOBUF = {12{1'b0}};
            ADDR14_IOBUF = {12{1'b0}};
            ADDR15_IOBUF = {12{1'b0}};
        end    
    endcase
end

// ** EXPONENT GENERATION ** //
assign n1x  = (STATE == ST_ITR1) ? {8'd0,E[2],E[1]} : {16{1'b0}};
assign n2x  = n1x << 1'b1;
assign n4x  = n2x << 1'b1;
assign n8x  = n4x << 1'b1;
assign n16x = n8x << 1'b1;
assign EXP0_[0] = E[0][0] ? n1x : {16{1'b0}};
assign EXP0_[1] = EXP0_[0] + n2x;
assign EXP0_[2] = E[0][1] ? EXP0_[1] : EXP0_[0];
assign EXP0_[3] = EXP0_[2] + n4x;
assign EXP0_[4] = E[0][2] ? EXP0_[3] : EXP0_[2];
assign EXP0_[5] = EXP0_[4] + n8x;
assign EXP0     = E[0][3] ? EXP0_[5] : EXP0_[4];
assign EXP1     = EXP0  + n16x;
assign EXP2     = EXP1  + n16x;
assign EXP3     = EXP2  + n16x;
assign EXP4     = EXP3  + n16x;
assign EXP5     = EXP4  + n16x;
assign EXP6     = EXP5  + n16x;
assign EXP7     = EXP6  + n16x;
assign EXP8     = EXP7  + n16x;
assign EXP9     = EXP8  + n16x;
assign EXP10    = EXP9  + n16x;
assign EXP11    = EXP10 + n16x;
assign EXP12    = EXP11 + n16x;
assign EXP13    = EXP12 + n16x;
assign EXP14    = EXP13 + n16x;
assign EXP15    = EXP14 + n16x;

endmodule
