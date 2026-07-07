`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.07.2026 16:42:22
// Design Name: 
// Module Name: booth_mult
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


module booth_mult(prod, q, m, reset, clk, start, done);
    output reg signed [7:0] prod;
    input signed [3:0] q, m;
    input reset, clk, start;
    output reg done;

    reg signed [3:0] A;
    reg signed [3:0] q_reg;
    reg q_1;
    reg [3:0] count;
    reg signed [3:0] A_temp;
    reg signed [8:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A     <= 4'b0;
            count <= 0;
            prod  <= 8'b0;
            q_reg <= 4'b0;
            done  <= 0;
            q_1   <= 0;
        end
        else begin
            if (start) begin
                A     <= 4'b0;
                q_reg <= q;
                count <= 0;
                q_1   <= 0;
                done  <= 0;
            end
            else begin
                if (count == 4) begin
                    done <= 1;
                    prod <= {A, q_reg};
                end
                else begin
                    case ({q_reg[0], q_1})
                        2'b00: A_temp = A;
                        2'b01: A_temp = A + m;
                        2'b10: A_temp = A - m;
                        2'b11: A_temp = A;
                    endcase

                    shift_reg = {A_temp, q_reg, q_1};
                    {A, q_reg, q_1} <= shift_reg >>> 1;
                    count <= count + 1;
                end
            end
        end
    end
endmodule