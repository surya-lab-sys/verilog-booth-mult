`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.07.2026 16:43:20
// Design Name: 
// Module Name: tb_booth
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module booth;
    reg signed [3:0] q, m;
    reg reset, clk, start;
    wire [7:0] prod;
    wire done;

    booth_mult bm (prod, q, m, reset, clk, start, done);

    initial
        clk = 0;

    always begin
        #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #7 reset = 0;
        q =-2;
        m = -2;
        start = 1;
        #10 start = 0;
        wait (done == 1);
        $display("q=%d, m=%d, product = %d", q, m, $signed(prod));
        $finish;
    end
endmodule
