`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 01:08:08 AM
// Design Name: 
// Module Name: main
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


module main(
    input clk,
    input RsRx,
    input btnU,
    //input btnD,
    output RsTx,
    output [6:0] seg,
    output [3:0] an,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire Hsync,
    output wire Vsync
    );

    wire received;
    wire [7:0] data_received;
    wire enqueue;
    wire dequeue;
    wire [7:0] queue_out; // output of queue for controll paddle pos
    
    uart keyboardUart(clk, RsRx, RsTx, received, data_received);
    queue signalQueue(clk, btnU, data_received, enqueue, dequeue, queue_out);
    queueController queueController(clk, received, enqueue);
    
    
    wire [19:0] clk_div;
    assign clk_div[0] = clk; // assign clk to clk_div[0]
    generate for(genvar i = 0;i<19;i = i+1) begin // divine clock by 2^19 for 7 segment display
        clockDivider div1(clk_div[i],clk_div[i+1]);
    end endgenerate
    
    wire [15:0] score;
    wire dot;
    assign dot = 1;
    gameLogic game(clk, queue_out, dequeue, score);
    segTDM segment_controller(clk_div[19],queue_out[7:4],queue_out[3:0],score[7:4],score[3:0],seg,an,dot);
    
endmodule
