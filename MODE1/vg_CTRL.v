`timescale 1ns/1ps

module CTRL (
    // EXTERNAL I/O
    input  [0:0] CLK,
    input  [0:0] RSTn,
    input  [0:0] START,
    output [0:0] DONE,
    // INTERNAL I/O
    output [0:0] SEL_EXTN,
    output [0:0] SEL_ITR,
    output [1:0] SEL_PERMW, // Right Rotation
    output [1:0] SEL_PERMR, // Left  Rotation
    output [1:0] SEL_HRMF,
    output reg [0:0] WE_FSC,
    output reg [0:0] WE_IOBUF,
    output reg [5:0] ADDR0_FSC,
    output reg [5:0] ADDR1_FSC,
    output reg [5:0] ADDR2_FSC,
    output reg [5:0] ADDR3_FSC,
    output reg [5:0] ADDR0_IOBUF,
    output reg [5:0] ADDR1_IOBUF,
    output reg [5:0] ADDR2_IOBUF,
    output reg [5:0] ADDR3_IOBUF,
    output [7:0] EXP0,
    output [7:0] EXP1,
    output [7:0] EXP2,
    output [7:0] EXP3
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

reg [2:0] STATE;
reg [5:0] CNT; // MAIN COUNTER
reg [5:0] DNT; // DELAYED COUNTER
reg [5:0] ENT; // EXPONENT COUNTER
reg [1:0] Am [0:3]; // ADDRESS INDEX
reg [1:0] Dm [0:3]; // DELAYED ADDRES INDEX
reg [5:0] IO_ADDR [0:3];
reg [5:0] R_ADDR  [0:3];
reg [5:0] W_ADDR  [0:3];
reg [1:0] BIr; // Bank Index Read Timing Control
reg [0:0] CLR;
reg [7:0] EXP0_;

wire [1:0] C [0:2];
wire [1:0] D [0:2];
wire [1:0] E [0:2];
wire [1:0] BI;  // Bank Index
wire [1:0] BIw; // Bank Index Write Timing Control
wire [7:0] n1x;
wire [7:0] n2x;
wire [7:0] n3x;
wire [7:0] n4x;
wire [0:0] BUSY;

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
    if(!RSTn) CNT <= {6{1'b0}};
    else begin
        case (STATE)
            ST_IDLE : CNT <= {6{1'b0}};  
            ST_INPT : CNT <= (CLR) ? {6{1'b0}} : CNT + 1'b1;
            ST_ITR1 : CNT <= (CLR) ? {6{1'b0}} : CNT + 1'b1;
            ST_ITR2 : CNT <= (CLR) ? {6{1'b0}} : CNT + 1'b1;
            ST_OUPT : CNT <= (CLR) ? {6{1'b0}} : CNT + 1'b1;
            ST_STL0 : CNT <= {6{1'b0}};
            ST_STL1 : CNT <= {6{1'b0}};
            ST_STL2 : CNT <= {6{1'b0}};
        endcase
    end
end

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) DNT <= {6{1'b0}};
    else begin
        if(CLR == 1'b1 || BUSY == 1'b0) DNT <= {6{1'b0}};
        else begin
            if(DNT == 6'd0 && CNT < 6'd4) DNT <= {6{1'b0}};
            else DNT <= DNT + 1'b1;
        end
    end
end

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) ENT <= {6{1'b0}};
    else begin
        if(CLR == 1'b1 || BUSY == 1'b0) ENT <= {6{1'b0}};
        else begin
            if(ENT == 6'd0 && CNT < 6'd3) ENT <= {6{1'b0}};
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
    if(!RSTn) BIr <= {2{1'b0}};
    else      BIr <= BI;
end

assign BIw = D[2] + D[1] + D[0];

assign SEL_PERMW    = (STATE == ST_INPT) ? BI : BIw;
assign SEL_PERMR    = BIr;

// SEL EXTN and ITR
assign SEL_EXTN    = (STATE == ST_INPT) ? 1'b0 : 1'b1;
assign SEL_ITR     = (STATE == ST_ITR2) ? 1'b1 : 1'b0;

// SEL_HRMF
assign SEL_HRMF = BUSY ? C[0] - 1'b1 : {2{1'b0}};

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
       2'b00 : {Am[0],Am[1],Am[2],Am[3]} = {2'd0, 2'd1, 2'd2, 2'd3};
       2'b01 : {Am[0],Am[1],Am[2],Am[3]} = {2'd3, 2'd0, 2'd1, 2'd2};
       2'b10 : {Am[0],Am[1],Am[2],Am[3]} = {2'd2, 2'd3, 2'd0, 2'd1};
       2'b11 : {Am[0],Am[1],Am[2],Am[3]} = {2'd1, 2'd2, 2'd3, 2'd0};
    endcase
end

always @(*) begin
    case (BIw)
       2'b00 : {Dm[0],Dm[1],Dm[2],Dm[3]} = {2'd0, 2'd1, 2'd2, 2'd3};
       2'b01 : {Dm[0],Dm[1],Dm[2],Dm[3]} = {2'd3, 2'd0, 2'd1, 2'd2};
       2'b10 : {Dm[0],Dm[1],Dm[2],Dm[3]} = {2'd2, 2'd3, 2'd0, 2'd1};
       2'b11 : {Dm[0],Dm[1],Dm[2],Dm[3]} = {2'd1, 2'd2, 2'd3, 2'd0};
    endcase
end

always @(*) begin
    case (STATE)
        ST_IDLE : begin
            IO_ADDR[0] = {6{1'b0}};
            IO_ADDR[1] = {6{1'b0}};
            IO_ADDR[2] = {6{1'b0}};
            IO_ADDR[3] = {6{1'b0}};
        end
        ST_INPT : begin
            IO_ADDR[0] = {C[2], C[1], C[0]};
            IO_ADDR[1] = {C[2], C[1], C[0]};
            IO_ADDR[2] = {C[2], C[1], C[0]};
            IO_ADDR[3] = {C[2], C[1], C[0]};        
        end
        ST_ITR1 : begin
            IO_ADDR[0] = {6{1'b0}};
            IO_ADDR[1] = {6{1'b0}};
            IO_ADDR[2] = {6{1'b0}};
            IO_ADDR[3] = {6{1'b0}};        
        end
        ST_ITR2 : begin
            IO_ADDR[0] = {6{1'b0}};
            IO_ADDR[1] = {6{1'b0}};
            IO_ADDR[2] = {6{1'b0}};
            IO_ADDR[3] = {6{1'b0}};
        end
        ST_OUPT : begin
            IO_ADDR[0] = {C[0], Am[0], C[2]};
            IO_ADDR[1] = {C[0], Am[1], C[2]};
            IO_ADDR[2] = {C[0], Am[2], C[2]};
            IO_ADDR[3] = {C[0], Am[3], C[2]};        
        end
        ST_STL0 : begin
            IO_ADDR[0] = {6{1'b0}};
            IO_ADDR[1] = {6{1'b0}};
            IO_ADDR[2] = {6{1'b0}};
            IO_ADDR[3] = {6{1'b0}};        
        end
        ST_STL1 : begin
            IO_ADDR[0] = {6{1'b0}};
            IO_ADDR[1] = {6{1'b0}};
            IO_ADDR[2] = {6{1'b0}};
            IO_ADDR[3] = {6{1'b0}};        
        end
        ST_STL2 : begin
            IO_ADDR[0] = {6{1'b0}};
            IO_ADDR[1] = {6{1'b0}};
            IO_ADDR[2] = {6{1'b0}};
            IO_ADDR[3] = {6{1'b0}};        
        end
    endcase
end

always @(*) begin
    case (STATE)
        ST_IDLE : begin
            R_ADDR[0] = {6{1'b0}};
            R_ADDR[1] = {6{1'b0}};
            R_ADDR[2] = {6{1'b0}};
            R_ADDR[3] = {6{1'b0}};
        end
        ST_INPT : begin
            R_ADDR[0] = {6{1'b0}};
            R_ADDR[1] = {6{1'b0}};
            R_ADDR[2] = {6{1'b0}};
            R_ADDR[3] = {6{1'b0}};        
        end
        ST_ITR1 : begin
            R_ADDR[0] = {Am[0], C[0], C[2]};
            R_ADDR[1] = {Am[1], C[0], C[2]};
            R_ADDR[2] = {Am[2], C[0], C[2]};
            R_ADDR[3] = {Am[3], C[0], C[2]};
        end
        ST_ITR2 : begin
            R_ADDR[0] = {C[2], C[1], Am[0]};
            R_ADDR[1] = {C[2], C[1], Am[1]};
            R_ADDR[2] = {C[2], C[1], Am[2]};
            R_ADDR[3] = {C[2], C[1], Am[3]};
        end
        ST_OUPT : begin
            R_ADDR[0] = {6{1'b0}};
            R_ADDR[1] = {6{1'b0}};
            R_ADDR[2] = {6{1'b0}};
            R_ADDR[3] = {6{1'b0}};
        end
        ST_STL0 : begin
            R_ADDR[0] = {6{1'b0}};
            R_ADDR[1] = {6{1'b0}};
            R_ADDR[2] = {6{1'b0}};
            R_ADDR[3] = {6{1'b0}};
        end
        ST_STL1 : begin
            R_ADDR[0] = {6{1'b0}};
            R_ADDR[1] = {6{1'b0}};
            R_ADDR[2] = {6{1'b0}};
            R_ADDR[3] = {6{1'b0}};
        end
        ST_STL2 : begin
            R_ADDR[0] = {6{1'b0}};
            R_ADDR[1] = {6{1'b0}};
            R_ADDR[2] = {6{1'b0}};
            R_ADDR[3] = {6{1'b0}};
        end 
    endcase
end

always @(*) begin
    case (STATE)
        ST_IDLE : begin
            W_ADDR[0] = {6{1'b0}};
            W_ADDR[1] = {6{1'b0}};
            W_ADDR[2] = {6{1'b0}};
            W_ADDR[3] = {6{1'b0}};
        end
        ST_INPT : begin
            W_ADDR[0] = {6{1'b0}};
            W_ADDR[1] = {6{1'b0}};
            W_ADDR[2] = {6{1'b0}};
            W_ADDR[3] = {6{1'b0}};        
        end
        ST_ITR1 : begin
            W_ADDR[0] = {Dm[0], D[0], D[2]};
            W_ADDR[1] = {Dm[1], D[0], D[2]};
            W_ADDR[2] = {Dm[2], D[0], D[2]};
            W_ADDR[3] = {Dm[3], D[0], D[2]};
        end
        ST_ITR2 : begin
            W_ADDR[0] = {D[2], D[1], Dm[0]};
            W_ADDR[1] = {D[2], D[1], Dm[1]};
            W_ADDR[2] = {D[2], D[1], Dm[2]};
            W_ADDR[3] = {D[2], D[1], Dm[3]};
        end
        ST_OUPT : begin
            W_ADDR[0] = {6{1'b0}};
            W_ADDR[1] = {6{1'b0}};
            W_ADDR[2] = {6{1'b0}};
            W_ADDR[3] = {6{1'b0}};
        end
        ST_STL0 : begin
            W_ADDR[0] = {6{1'b0}};
            W_ADDR[1] = {6{1'b0}};
            W_ADDR[2] = {6{1'b0}};
            W_ADDR[3] = {6{1'b0}};
        end
        ST_STL1 : begin
            W_ADDR[0] = {6{1'b0}};
            W_ADDR[1] = {6{1'b0}};
            W_ADDR[2] = {6{1'b0}};
            W_ADDR[3] = {6{1'b0}};
        end
        ST_STL2 : begin
            W_ADDR[0] = {6{1'b0}};
            W_ADDR[1] = {6{1'b0}};
            W_ADDR[2] = {6{1'b0}};
            W_ADDR[3] = {6{1'b0}};
        end    
    endcase
end

always @(*) begin
    case (STATE)
        ST_IDLE : begin
            ADDR0_FSC = {6{1'b0}};
            ADDR1_FSC = {6{1'b0}};
            ADDR2_FSC = {6{1'b0}};
            ADDR3_FSC = {6{1'b0}};
        end
        ST_INPT : begin
            ADDR0_FSC = {6{1'b0}};
            ADDR1_FSC = {6{1'b0}};
            ADDR2_FSC = {6{1'b0}};
            ADDR3_FSC = {6{1'b0}};        
        end
        ST_ITR1 : begin
            ADDR0_FSC = W_ADDR[0];
            ADDR1_FSC = W_ADDR[1];
            ADDR2_FSC = W_ADDR[2];
            ADDR3_FSC = W_ADDR[3];
        end
        ST_ITR2 : begin
            ADDR0_FSC = R_ADDR[0];
            ADDR1_FSC = R_ADDR[1];
            ADDR2_FSC = R_ADDR[2];
            ADDR3_FSC = R_ADDR[3];
        end
        ST_OUPT : begin
            ADDR0_FSC = {6{1'b0}};
            ADDR1_FSC = {6{1'b0}};
            ADDR2_FSC = {6{1'b0}};
            ADDR3_FSC = {6{1'b0}};
        end
        ST_STL0 : begin
            ADDR0_FSC = {6{1'b0}};
            ADDR1_FSC = {6{1'b0}};
            ADDR2_FSC = {6{1'b0}};
            ADDR3_FSC = {6{1'b0}};
        end
        ST_STL1 : begin
            ADDR0_FSC = {6{1'b0}};
            ADDR1_FSC = {6{1'b0}};
            ADDR2_FSC = {6{1'b0}};
            ADDR3_FSC = {6{1'b0}};
        end
        ST_STL2 : begin
            ADDR0_FSC = {6{1'b0}};
            ADDR1_FSC = {6{1'b0}};
            ADDR2_FSC = {6{1'b0}};
            ADDR3_FSC = {6{1'b0}};
        end    
    endcase
end

always @(*) begin
    case (STATE)
        ST_IDLE : begin
            ADDR0_IOBUF = {6{1'b0}};
            ADDR1_IOBUF = {6{1'b0}};
            ADDR2_IOBUF = {6{1'b0}};
            ADDR3_IOBUF = {6{1'b0}};
        end
        ST_INPT : begin
            ADDR0_IOBUF = IO_ADDR[0];
            ADDR1_IOBUF = IO_ADDR[1];
            ADDR2_IOBUF = IO_ADDR[2];
            ADDR3_IOBUF = IO_ADDR[3];
        end
        ST_ITR1 : begin
            ADDR0_IOBUF = R_ADDR[0];
            ADDR1_IOBUF = R_ADDR[1];
            ADDR2_IOBUF = R_ADDR[2];
            ADDR3_IOBUF = R_ADDR[3];
        end
        ST_ITR2 : begin
            ADDR0_IOBUF = W_ADDR[0];
            ADDR1_IOBUF = W_ADDR[1];
            ADDR2_IOBUF = W_ADDR[2];
            ADDR3_IOBUF = W_ADDR[3];
        end
        ST_OUPT : begin
            ADDR0_IOBUF = IO_ADDR[0];
            ADDR1_IOBUF = IO_ADDR[1];
            ADDR2_IOBUF = IO_ADDR[2];
            ADDR3_IOBUF = IO_ADDR[3];
        end
        ST_STL0 : begin
            ADDR0_IOBUF = {6{1'b0}};
            ADDR1_IOBUF = {6{1'b0}};
            ADDR2_IOBUF = {6{1'b0}};
            ADDR3_IOBUF = {6{1'b0}};
        end
        ST_STL1 : begin
            ADDR0_IOBUF = {6{1'b0}};
            ADDR1_IOBUF = {6{1'b0}};
            ADDR2_IOBUF = {6{1'b0}};
            ADDR3_IOBUF = {6{1'b0}};
        end
        ST_STL2 : begin
            ADDR0_IOBUF = {6{1'b0}};
            ADDR1_IOBUF = {6{1'b0}};
            ADDR2_IOBUF = {6{1'b0}};
            ADDR3_IOBUF = {6{1'b0}};
        end    
    endcase
end

// ** EXPONENT GENERATION ** //
assign n1x = (STATE == ST_ITR1) ? {4'd0,E[2],E[1]} : {8{1'b0}};
assign n2x = n1x << 1'b1;
assign n3x = n1x + n2x;
assign n4x = n2x << 1'b1;

always @(*) begin
    case (E[0])
       2'd0 : EXP0_ = {8{1'b0}};
       2'd1 : EXP0_ = n1x;
       2'd2 : EXP0_ = n2x;
       2'd3 : EXP0_ = n3x;
    endcase
end

assign EXP0 = EXP0_;
assign EXP1 = EXP0 + n4x;
assign EXP2 = EXP1 + n4x;
assign EXP3 = EXP2 + n4x;

endmodule
