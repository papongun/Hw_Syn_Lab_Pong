`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 01:03:23 AM
// Design Name: 
// Module Name: uart
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

module uart (
    input clk,
    input RsRx,
    output RsTx,
    output received,
    output [7:0] data
);
    
    wire baud;
    wire received, sent;
    wire [7:0] data_receive;
    reg [7:0] data_send;
    reg en;
    
    assign data = data_receive;

    baudrate_gen baudgen(baud, clk);
    transmitter t(RsTx, sent, data_send, en, baud);
    receiver r(data_receive, received, RsRx, baud);

    initial begin
        en <= 1;
    end

    reg oldre;

    always @(posedge baud) begin
        if(en == 1) en <= 0;

        if(!oldre && received) begin
            data_send <= data_receive + 1;
            en <= 1;
        end
        
        oldre <= received;
    end

endmodule
