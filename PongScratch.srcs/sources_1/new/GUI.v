`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 02:11:22 PM
// Design Name: 
// Module Name: GUI
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


module GUI(
    input wire clk,
    input sw,
    input [9:0] x,
    input [9:0] y,    
    input videoOn,    
    input [31:0] paddle_1_x,
    input [31:0] paddle_1_y,
    input [31:0] paddle_2_x,
    input [31:0] paddle_2_y,
    input [31:0] paddle_width,
    input [31:0] paddle_height,
    input [31:0] ball_x,
    input [31:0] ball_y,
    input [31:0] ball_rad,
    input [7:0] score_1,
    input [7:0] score_2,
    output wire [11:0] rgb
    ); 
    wire displayLeftPaddle; 
    wire displayRightPaddle;
    wire displayBall; 
    
    wire displayPlayer1Score;
    wire player1FirstDigit; 
    wire player1SecondDigit; 
    wire[11:0] rgbPlayer1Score;
    
    wire displayPlayer2Score;
    wire player2FirstDigit; 
    wire player2SecondDigit; 
    wire[11:0] rgbPlayer2Score;
    
    wire[11:0] rgbLeftPaddle;
    wire[11:0] rgbRightPaddle;
    wire[11:0] rgbBall;
    wire[5:0] outputMux;
    
    reg[11:0] rgbReg; 
    wire[11:0] rgbNext;

    assign displayLeftPaddle = y < paddle_1_y & y > paddle_1_y - paddle_height & x > paddle_1_x & x < paddle_1_x + paddle_width ? 1'b1 : 1'b0; 
    assign rgbLeftPaddle = sw ? 12'b111111001001 : 12'b000000110110; 

    assign displayRightPaddle = y < paddle_2_y & y > paddle_2_y - paddle_height & x > paddle_2_x & x < paddle_2_x + paddle_width ? 1'b1 : 1'b0; 
    assign rgbRightPaddle = sw ? 12'b100111001011 : 12'b011000110100; 

    assign displayBall = (x >= ball_x - ball_rad) && (x <= ball_x + ball_rad) && (y >= ball_y - ball_rad) && (y <= ball_y + ball_rad) ? 1'b1 : 1'b0;
    assign rgbBall = sw ? 12'b100010110100 : 12'b011101001011; 

    assign displayPlayer1Score = x >= 204 & x < 220 & y >= 100 & y < 108; 
    numberToPixel player1FirstDigitConvertor(score_1[7:4], y - 100, x - 204, player1FirstDigit);
    numberToPixel player1SecondDigitConvertor(score_1[3:0], y - 100, x - 212, player1SecondDigit);
    assign rgbPlayer1Score = x >= 212 ? (sw ? (player1SecondDigit ? 12'b111111111111 : 12'b000000000000) : (player1SecondDigit ? 12'b000000000000 : 12'b111111111111))
                                  : (sw ? (player1FirstDigit ? 12'b111111111111 : 12'b000000000000) : (player1FirstDigit ? 12'b000000000000 : 12'b111111111111));

    assign displayPlayer2Score = x >= 420 & x < 436 & y >= 100 & y < 108; 
    numberToPixel player2FirstDigitConvertor(score_2[7:4], y - 100, x - 420, player2FirstDigit);
    numberToPixel player2SecondDigitConvertor(score_2[3:0], y - 100, x - 428, player2SecondDigit);
    assign rgbPlayer2Score = x >= 428 ? (sw ? (player2SecondDigit ? 12'b111111111111 : 12'b000000000000) : (player2SecondDigit ? 12'b000000000000 : 12'b111111111111))
                                  : (sw ? (player2FirstDigit ? 12'b111111111111 : 12'b000000000000) : (player2FirstDigit ? 12'b000000000000 : 12'b111111111111));


    always @(posedge clk) begin 
        rgbReg <= rgbNext;   
    end

    assign outputMux = {videoOn, displayLeftPaddle, displayRightPaddle, displayBall, displayPlayer1Score, displayPlayer2Score}; 
    
    assign rgbNext = outputMux === 6'b100000 ? ( sw ? 12'b000000000000 : 12'b111111111111): 
                    outputMux === 6'b110000 ? rgbLeftPaddle: 
                    outputMux === 6'b110100 ? rgbLeftPaddle: 
                    outputMux === 6'b101000 ? rgbRightPaddle: 
                    outputMux === 6'b101100 ? rgbRightPaddle: 
                    outputMux === 6'b100100 ? rgbBall:
                    outputMux === 6'b100101 ? rgbBall:
                    outputMux === 6'b100110 ? rgbBall:
                    outputMux === 6'b100010 ? rgbPlayer1Score: 
                    outputMux === 6'b100001 ? rgbPlayer2Score:
                    (sw ? 12'b1 : 12'b0);
 
    assign rgb = rgbReg; 


    
endmodule
