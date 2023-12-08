`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 02:40:58 AM
// Design Name: 
// Module Name: gameLogic
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


module gameLogic(
    input wire clk,
    input wire reset,
    input wire [7:0] move_signal,
    output reg dequeue,
    output reg [31:0] paddle_1_y,
    output reg [31:0] paddle_2_y,
    output reg [31:0] paddle_width,
    output reg [31:0] paddle_height,
    output reg [31:0] ball_x,
    output reg [31:0] ball_y,
    output reg [31:0] ball_rad,
    output reg [7:0] score_1,
    output reg [7:0] score_2
    );
    
    parameter update_rate = 1000000;
    reg [31:0] counter;
    
    initial begin
        counter <= 0;
        dequeue <= 0;
    end
    
    always @ (posedge clk) begin
        counter <= counter + 1;
        if (counter > update_rate) counter <= 0;
    end
    
    always @ (posedge clk) begin
        if (counter > update_rate) begin
            if (move_signal == 8'h77) begin
                score_test <= score_test + 1;
            end
            dequeue <= 1;
        end
        else dequeue <= 0;
    end
    
    
endmodule
