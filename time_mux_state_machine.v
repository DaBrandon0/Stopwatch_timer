`timescale 1ns / 1ps
module timer_state_machine(
    input fastclk,
    input clk,
    input reset,
    input stopstart,
    input [1:0] modesel,
    input [7:0] value,
    output reg[3:0] an,
    output reg[7:0] sseg
    );
    reg [0:0] stopping;
    reg [0:0] current_stopping;
    reg [0:0] resetting;
    reg [0:0] current_resetting;
    reg [1:0] alter;
    reg[2:0] state;
    reg[2:0] next_state;
    reg [15:0] val;
    reg [15:0] val_next;
    wire [7:0] in0, in1, in2, in3;
    hexto7segment c1 (.x(val[15:0]), .r1(in0), .r2(in1), .r3(in2) , .r4(in3));
    
    initial
    begin
        state <= 3'b000;
        alter = 0;
        val = 0;
        val_next = 0;
        stopping = 0;
        resetting = 0;
        current_stopping = 0;
        current_resetting = 0;
        end

    always @(*) begin
        case(state)
            3'b000:
            begin
                if (modesel == 0)
                    next_state = 3'b010;
                else if (modesel == 1)
                    next_state = 3'b001;
                else if (modesel == 2)
                    next_state = 3'b011;
                else if (modesel == 3)       
                    next_state = 3'b001;
            end
            
            3'b001:
            begin
                if (modesel != 1 && modesel != 3)
                    next_state = 3'b000;
                else
                    begin
                    if (stopping == 0)
                        next_state = 3'b001;
                    else if (modesel == 1)
                        next_state = 3'b100;
                    else
                        next_state = 3'b101;
                    end    
                val_next = value[3:0]*100+value[7:4]*1000;
            end
            3'b010:
            begin
                if (modesel != 0)
                    next_state = 3'b000;
                else
                    begin
                    if (stopping)
                        next_state = 3'b100;
                    else
                        next_state = 3'b010;
                    end
                val_next = 0;
            end
            3'b011:
            begin
                if (modesel != 2)
                    next_state = 3'b000;
                else 
                begin
                if (stopping)
                    next_state = 3'b101;
                else
                    next_state = 3'b011;
                end
                val_next = 9999;
            end
            3'b100:
            begin
                if (modesel != 1 && modesel != 0)
                    next_state = 3'b000;
                else if (resetting == 1)
                    begin
                    if (modesel == 1)
                        next_state = 3'b001;
                    else
                        next_state = 3'b010;
                    end
                else if ((modesel == 1||modesel ==0) && (val == 9999 || stopping == 1) && resetting != 1)
                    begin
                    next_state = 3'b110;
                    val_next = val;
                    end
                else 
                    begin
                    next_state = 3'b100;
                    val_next = val + 1;
                    end
                
            end
            3'b101:
            begin
                if (modesel != 2 && modesel != 3)
                    next_state = 3'b000;
                else if (resetting == 1)
                    begin
                    if (modesel == 2)
                        next_state = 3'b011;
                    else
                        next_state = 3'b001;
                    end
                else if ((modesel == 2||modesel ==3) && (val == 0 || stopping == 1) && resetting != 1)
                begin
                    next_state = 3'b110;
                    val_next = val;
                end
                else
                begin
                    next_state = 3'b101;
                    val_next = val - 1;
                end
            end
            3'b110:
            begin
                if (resetting == 1)
                    begin
                    if (modesel == 2)
                        next_state = 3'b011;
                    else if (modesel == 3 || modesel == 1)
                        next_state = 3'b001;
                    else
                        next_state = 3'b010;
                    end
                else if (stopping == 0)
                    next_state = 3'b110;
                else 
                   begin
                   if (modesel == 0 || modesel == 1)
                        next_state = 3'b100;
                   else if (modesel == 2 || modesel == 3)
                        next_state = 3'b101;
                   end
                val_next = val;
            end
            
        endcase
    end
    always @(*) begin
        case(alter)
            2'b00: begin sseg = in0; an = 4'b1110; end 
            2'b01: begin sseg = in1; an = 4'b1101; end
            2'b10: begin sseg = in2; an = 4'b1011; end
            2'b11: begin sseg = in3; an = 4'b0111; end
        endcase 
    end
    
    always @(posedge fastclk) 
    begin
          alter = alter + 1;
    end
    always @(posedge reset or negedge clk) 
    begin
        if(reset)
          current_resetting = reset;
        else
          current_resetting = 0;
    end
    
    
   always @(posedge clk or posedge stopstart) 
   begin
        if (stopstart)
            current_stopping <= 1;
        else
        begin
        resetting <= current_resetting;
        stopping <= current_stopping;
        state <= next_state;
        if (current_stopping)
            val <= val;
        else
            val <= val_next;
        current_stopping = 0;
        end
   end
endmodule
