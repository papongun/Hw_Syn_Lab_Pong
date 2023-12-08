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
    output reg [31:0] paddle_1_x,
    output reg [31:0] paddle_1_y,
    output reg [31:0] paddle_2_x,
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
    parameter paddle_speed = 1;
    reg [31:0] counter;
    
    initial begin
        counter <= 0;
        dequeue <= 0;
        paddle_1_x <= 0;
        paddle_1_y <= 0;
        paddle_2_x <= 0;
        paddle_2_y <= 0;
        paddle_width <= 10;
        paddle_height <= 120;
        ball_x <= 300;
        ball_y <= 300;
        ball_rad <= 8;
        score_1 <= 0;
        score_2 <= 0;
    end
    
    // clock divider
    always @ (posedge clk) begin
        counter <= counter + 1;
        if (counter > update_rate) counter <= 0;
    end
    
    // input controller
    always @ (posedge clk or posedge reset) begin
        if (counter > update_rate) begin
            // p1 up
            if (move_signal == 8'h77 && paddle_1_y - paddle_height > paddle_speed) begin
                paddle_1_y <= paddle_1_y - paddle_speed;
            end
            
            // p1 down
            if (move_signal == 8'h73 && paddle_1_y < 640) begin
                paddle_1_y <= paddle_1_y + paddle_speed;
            end
            
            // p2 up
            if (move_signal == 8'h70 && paddle_2_y - paddle_height > paddle_speed) begin
                paddle_2_y <= paddle_2_y - paddle_speed;
            end
            
            // p2 down
            if (move_signal == 8'h6C && paddle_2_y < 640) begin
                paddle_2_y <= paddle_2_y + paddle_speed;
            end
            
            // start ball
            if (move_signal == 8'h20) begin
                
            end
            
            // reset
            if (reset) begin
                ball_x <= 300;
                ball_y <= 300;
                score_1 <= 0;
                score_2 <= 0;
                counter <= 0;
            end
            
            dequeue <= 1;
        end
        else dequeue <= 0;
    end
    
    // running ball
    always @ (posedge clk) begin
        
    end
    
endmodule
