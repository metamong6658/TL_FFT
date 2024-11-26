`timescale 1ns/1ps
module TB_TOP;

// CONTROL
logic [0:0]  CLK;
logic [0:0]  RSTn;
logic [0:0]  START;
logic [0:0]  DONE;
// DATA
logic [63:0] D0;
logic [63:0] D1;
logic [63:0] D2;
logic [63:0] D3;
logic [63:0] D4;
logic [63:0] D5;
logic [63:0] D6;
logic [63:0] D7;
logic [63:0] D8;
logic [63:0] D9;
logic [63:0] D10;
logic [63:0] D11;
logic [63:0] D12;
logic [63:0] D13;
logic [63:0] D14;
logic [63:0] D15;
logic [63:0] Q0;
logic [63:0] Q1;
logic [63:0] Q2;
logic [63:0] Q3;
logic [63:0] Q4;
logic [63:0] Q5;
logic [63:0] Q6;
logic [63:0] Q7;
logic [63:0] Q8;
logic [63:0] Q9;
logic [63:0] Q10;
logic [63:0] Q11;
logic [63:0] Q12;
logic [63:0] Q13;
logic [63:0] Q14;
logic [63:0] Q15;

TOP DUT (.*);

always #1 CLK <= ~CLK;

localparam FILE_INPT = "../FILE/INPT.hex";
localparam FILE_OUPT = "../FILE/OUPT.hex";
int FILE;

// TEST VECTOR INITIALIZATION
reg  [63:0] INPT [0:65535];
reg  [63:0] OUPT [0:65535];
reg  [1:0]  FSM;
reg  [15:0]  CNTI;
reg  [15:0]  CNTO;
wire [0:0]  FINISH = &FSM;
initial begin
    $readmemh(FILE_INPT, INPT);
end

// TEST FSM
always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) begin
        FSM <= 2'b00;
    end
    else begin
        case (FSM)
           2'b00 : begin
            FSM <= START ? 2'b01 : 2'b00;
           end
           2'b01 : begin
            FSM <= DONE ? 2'b10 : 2'b01;
           end
           2'b10 : begin
            FSM <= DONE ? 2'b10 : 2'b11;
           end
           2'b11 : begin
            FSM <= 2'b00;
           end 
        endcase
    end
end

// TEST INPUT
always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) begin
        CNTI <= '0;
    end
    else begin
        if(FSM == 2'b01) begin
            if(&CNTI) CNTI <= CNTI;
            else      CNTI <= CNTI + 16;
        end
        else CNTI <= '0;
    end
end

assign D0  = INPT[CNTI + 0];
assign D1  = INPT[CNTI + 1];
assign D2  = INPT[CNTI + 2];
assign D3  = INPT[CNTI + 3];
assign D4  = INPT[CNTI + 4];
assign D5  = INPT[CNTI + 5];
assign D6  = INPT[CNTI + 6];
assign D7  = INPT[CNTI + 7];
assign D8  = INPT[CNTI + 8];
assign D9  = INPT[CNTI + 9];
assign D10 = INPT[CNTI + 10];
assign D11 = INPT[CNTI + 11];
assign D12 = INPT[CNTI + 12];
assign D13 = INPT[CNTI + 13];
assign D14 = INPT[CNTI + 14];
assign D15 = INPT[CNTI + 15];

// TEST OUTPUT
always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) CNTO <= '0;
    else begin
        if(FSM == 2'b10) begin
            CNTO <= CNTO + 16;
            OUPT[CNTO + 0]  <= Q0;
            OUPT[CNTO + 1]  <= Q1;
            OUPT[CNTO + 2]  <= Q2;
            OUPT[CNTO + 3]  <= Q3;
            OUPT[CNTO + 4]  <= Q4;
            OUPT[CNTO + 5]  <= Q5;
            OUPT[CNTO + 6]  <= Q6;
            OUPT[CNTO + 7]  <= Q7;
            OUPT[CNTO + 8]  <= Q8;
            OUPT[CNTO + 9]  <= Q9;
            OUPT[CNTO + 10] <= Q10;
            OUPT[CNTO + 11] <= Q11;
            OUPT[CNTO + 12] <= Q12;
            OUPT[CNTO + 13] <= Q13;
            OUPT[CNTO + 14] <= Q14;
            OUPT[CNTO + 15] <= Q15;
        end
        else CNTO <= '0;
    end
end

// TESTBENCH
initial begin
    CLK  <= 1'b0; RSTn <= 1'b0; START <= 1'b0;
    #10;
    RSTn <= 1'b1; START <= 1'b1;
    @(posedge FINISH)
    START <= 1'b0;
    #10;
    // FILE OUTPUT
    FILE = $fopen(FILE_OUPT, "w");
        for (int i = 0; i < 65536; i++) begin
            $fwrite(FILE, "%08x%08x\n", OUPT[i][63:32], OUPT[i][31:0]);
        end
    $fclose(FILE);
    $finish();
end

endmodule
