`timescale 1ns / 1ps
module timer_main(
    input clk,
    input reset,
    input stopstart,
    input [1:0] modesel,
    input [7:0] value,
    output [3:0] an,
    output [7:0] sseg
    );
    wire slow_clk;
    wire fastclk;
    
    clkdiv c5 (.clk(clk), .reset(reset), .divider(1000000), .clk_out(slow_clk));
    clkdiv c1 (.clk(clk), .reset(reset),  .divider(2000),.clk_out(fastclk));
    
    timer_state_machine timey(
    .fastclk(fastclk),
    .clk(slow_clk),
    .reset(reset),
    .stopstart(stopstart),
    .modesel(modesel),
    .value(value),
    .an(an),
    .sseg(sseg));
    
endmodule
