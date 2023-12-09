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
    wire displayLeftPaddle; // to display player 1's paddle in vga
    wire displayRightPaddle; // to display player 2's paddle in vga
    wire displayBall; // to display ball in vga
    
    wire displayPlayer1Score;
    wire player1FirstDigit; // output player 1's first digit from convertor
    wire player1SecondDigit; // output player 1's second digit from convertor
    wire[11:0] rgbPlayer1Score;
    
    wire displayPlayer2Score;
    wire player2FirstDigit; // output player 1's first digit from convertor
    wire player2SecondDigit; // output player 1's second digit from convertor
    wire[11:0] rgbPlayer2Score;
    
    // Mux to display
    wire[5:0] outputMux;
    
    // RGB buffer
    reg[11:0] rgbReg; 
    wire[11:0] rgbNext;

    // display left paddle object on the screen
    assign displayLeftPaddle = y < paddle_1_y & y > paddle_1_y - paddle_height & x > paddle_1_x & x < paddle_1_x + paddle_width ? 1'b1 : 1'b0; 
    assign rgbLeftPaddle = sw ? 12'b111111111111 : 12'b111010101010; // Use dark mode color if sw is 1, otherwise use light mode color

    // display right paddle object on the screen
    assign displayRightPaddle = y < paddle_2_y & y > paddle_2_y - paddle_height & x > paddle_2_x & x < paddle_2_x + paddle_width ? 1'b1 : 1'b0; 
    assign rgbRightPaddle = sw ? 12'b111111111111 : 12'b111010101010; // Use dark mode color if sw is 1, otherwise use light mode color

    // display ball object on the screen
    assign displayBall = (x - ball_x) * (x - ball_x) + (y - ball_y) * (y - ball_y) <= ball_rad * ball_rad ? 1'b1 : 1'b0; 
    assign rgbBall = sw ? 12'b111111111111 : 12'b000000000000; // Use dark mode color if sw is 1, otherwise use light mode color

    // display player 1 score on the screen
    assign displayPlayer1Score = x >= 204 & x < 220 & y >= 100 & y < 108; 
    numberToPixel player1FirstDigitConvertor(score_1[7:4], y - 100, x - 204, player1FirstDigit);
    numberToPixel player1SecondDigitConvertor(score_1[3:0], y - 100, x - 212, player1SecondDigit);
    assign rgbPlayer1Score = x >= 212 ? player1SecondDigit ? 12'b111111111111 : 12'b000000000000
                                  : player1FirstDigit ? 12'b111111111111 : 12'b000000000000; // color of score: white if that area contain number

    // display player 2 score on the screen
    assign displayPlayer2Score = x >= 420 & x < 436 & y >= 100 & y < 108; 
    numberToPixel player2FirstDigitConvertor(score_2[7:4], y - 100, x - 420, player2FirstDigit);
    numberToPixel player2SecondDigitConvertor(score_2[3:0], y - 100, x - 428, player2SecondDigit);
    assign rgbPlayer2Score = x >= 428 ? player2SecondDigit ? 12'b111010101010 : 12'b000000000000
                                   : player2FirstDigit ? 12'b111010101010 : 12'b000000000000; // color of score: white if that area contain number


    always @(posedge clk) begin 
        rgbReg <= rgbNext;   
    end

    // mux
    assign outputMux = {videoOn, displayLeftPaddle, displayRightPaddle, displayBall, displayPlayer1Score, displayPlayer2Score}; 

    // assign rgbNext from outputMux.
    
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
//                    12'd0;
//                    sw ? 12'b000000000000 : 12'b111111111111;
 
    // output part
    assign rgb = rgbReg; 


    
endmodule
