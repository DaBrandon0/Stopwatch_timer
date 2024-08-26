`timescale 1ns / 1ps

module clkdiv(
    input clk,
    input [62:0] divider,
    input reset,
    output clk_out
    );
    
    reg [30:0] COUNT;
    reg dived;
    assign clk_out = dived;
    initial
        COUNT = 0;
    always @(posedge clk)
    begin
    if(reset)
        COUNT = 0;
    else
        COUNT = COUNT + 1;
    if(COUNT == divider)
    begin
        dived = 1;
        COUNT = 0;
    end
    else
        dived = 0;
    end
endmodule