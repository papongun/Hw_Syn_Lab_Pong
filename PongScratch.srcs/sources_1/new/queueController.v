`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 01:53:52 AM
// Design Name: 
// Module Name: queueController
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


module queueController (
  input wire clk,
  input wire received,
  output reg enqueue
);

  reg old_received;
  
  initial begin
    old_received = 1;
  end
  
  always @ (posedge clk) begin
    if (!old_received & received) enqueue <= 1;
    else enqueue <= 0;
    old_received <= received;
  end

endmodule
