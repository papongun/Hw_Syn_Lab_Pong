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
    
    
    wire dot;
    assign dot = 1;
    
    wire [31:0] paddle_1_x;
    wire [31:0] paddle_1_y;
    wire [31:0] paddle_2_x;
    wire [31:0] paddle_2_y;
    wire [31:0] paddle_width;
    wire [31:0] paddle_height;
    wire [31:0] ball_x;
    wire [31:0] ball_y;
    wire [31:0] ball_rad;
    wire [7:0] score_1;
    wire [7:0] score_2;
    
    gameLogic game(
        clk, 
        btnU, 
        queue_out, 
        dequeue,
        paddle_1_x,
        paddle_1_y,
        paddle_2_x,
        paddle_2_y,
        paddle_width,
        paddle_height,
        ball_x,
        ball_y,
        ball_rad,
        score_1,
        score_2
    );

    wire [11:0] rgb_out;
    wire [9:0] x,y;
    wire video_on;
    GUI gui(
        clk,
        sw[0],
        x,
        y,
        video_on, 
        paddle_1_x,
        paddle_1_y,
        paddle_2_x,
        paddle_2_y,
        paddle_width,
        paddle_height,
        ball_x,
        ball_y,
        ball_rad,
        score_1,
        score_2,
        rgb_out
    );
    
    vga_sync vga_render(.clk(clk), .reset(reset), .hsync(Hsync), .vsync(Vsync),
                                .video_on(video_on), .p_tick(), .x(x), .y(y)); // vga render

    segTDM segment_controller(clk_div[19],paddle_1_y[7:4],paddle_1_y[3:0],paddle_2_y[7:4],paddle_2_y[3:0],seg,an,dot);
    
endmodule
