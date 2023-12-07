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
    input wire move_signal,
    output reg dequeue,
    output reg [15:0] score_test
    );
    
    parameter update_rate = 100;
    reg [31:0] counter;
    
    initial begin
        counter <= 0;
        score_test <= 0;
        dequeue <= 0;
    end
    
    always @ (posedge clk) begin
        counter <= counter + 1;
        if (counter > update_rate) counter <= 0;
    end
    
//    always @ (posedge clk) begin
//        if (counter >= update_rate) begin
//            if (move_signal == 8'h77) begin
//                score_test <= score_test + 1;
//            end
//            dequeue <= 1;
//        end
//        else dequeue <= 0;
//    end
    
    
endmodule
