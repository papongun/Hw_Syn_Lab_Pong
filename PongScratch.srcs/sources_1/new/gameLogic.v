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
    
    parameter paddle_speed = 16;
    parameter ball_speed = 8;
    reg [19:0] counter;
    reg is_playing;
    reg is_ball_up;
    reg is_ball_right;
    
    initial begin
        counter <= 0;
        dequeue <= 0;
        paddle_1_x <= 20;
        paddle_1_y <= 380;
        paddle_2_x <= 610;
        paddle_2_y <= 380;
        paddle_width <= 10;
        paddle_height <= 120;
        ball_x <= 300;
        ball_y <= 300;
        ball_rad <= 8;
        score_1 <= 0;
        score_2 <= 0;
        is_playing <= 0;
        is_ball_up <= 0;
        is_ball_right <= 0;
    end
    
    always @ (posedge clk) begin
    
        //clock divider
        counter <= counter + 1;
    
        // input controller
        // reset
        if (reset) begin
            ball_x <= 300;
            ball_y <= 300;
            paddle_1_y <= 380;
            paddle_2_y <= 380;
            score_1 <= 0;
            score_2 <= 0;
            counter <= 0;
            dequeue <= 0;
            is_playing <= 0;
            is_ball_up <= 0;
            is_ball_right <= 0;
        end
        
        else if (counter == 20'b11111111111111111111) begin
        
            dequeue <= 1;
            
            // p1 up
            if (move_signal == 8'h77 & paddle_1_y - paddle_height > paddle_speed) begin
                paddle_1_y <= paddle_1_y - paddle_speed;
            end
            
            // p1 down
            else if (move_signal == 8'h73 & paddle_1_y < 480) begin
                paddle_1_y <= paddle_1_y + paddle_speed;
            end
            
            // p2 up
            else if (move_signal == 8'h70 & paddle_2_y - paddle_height > paddle_speed) begin
                paddle_2_y <= paddle_2_y - paddle_speed;
            end
            
            // p2 down
            else if (move_signal == 8'h6C & paddle_2_y < 480) begin
                paddle_2_y <= paddle_2_y + paddle_speed;
            end
            
            // start ball
            else if (move_signal == 8'h20 & !is_playing) begin
                is_playing <= 1;
            end
            
            // playing logic
            if (is_playing) begin
                 
                // move left/right
                if (is_ball_right) begin
                    ball_x <= ball_x + ball_speed;
                end
                else begin
                    ball_x <= ball_x - ball_speed;
                end
                
                // move up/down
                if (is_ball_up) begin
                    ball_y <= ball_y - ball_speed;
                end
                else begin
                    ball_y <= ball_y + ball_speed;
                end
                
                // top/down collide
                if (ball_y < 32) begin
                    is_ball_up <= 0;
                end
                else if (ball_y > 480) begin
                    is_ball_up <= 1;
                end
                
                // paddle collide
                if (ball_x == paddle_1_x + paddle_width & ball_y <= paddle_1_y & ball_y >= paddle_1_y - paddle_height) begin
                    is_ball_right <= 1;
                end
                if (ball_x == paddle_2_x & ball_y <= paddle_2_y & ball_y >= paddle_2_y - paddle_height) begin
                    is_ball_right <= 0;
                end
                
                // left/right out of frame
                if (ball_x < 1) begin
                    if (score_2[3:0] < 9) begin
                        score_2[3:0] <= score_2[3:0] + 1;
                    end
                    else if (score_2[7:4] < 9) begin
                        score_2[3:0] <= 0;
                        score_2[7:4] <= score_2[7:4] + 1;
                    end
                    is_playing <= 0;
                    is_ball_right <= ~is_ball_right;
                    ball_x <= 300;
                    ball_y <= 300;
                end
                else if (ball_x > 640) begin
                    if (score_1[3:0] < 9) begin
                        score_1[3:0] <= score_1[3:0] + 1;
                    end
                    else if (score_1[7:4] < 9) begin
                        score_1[3:0] <= 0;
                        score_1[7:4] <= score_1[7:4] + 1;
                    end
                    is_playing <= 0;
                    is_ball_right <= ~is_ball_right;
                    ball_x <= 300;
                    ball_y <= 300;
                end
                
            end
        end
        
        else begin
            dequeue <= 0;
        end
       
    end
    
    
endmodule
