`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 01:37:35 AM
// Design Name: 
// Module Name: queue
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


module queue (
  input wire clk,
  input wire rst,
  input wire [7:0] data_in,
  input wire enqueue,
  input wire dequeue,
  output wire [7:0] data_out
);

  reg [7:0] q [0:0]; // Queue with a size of 1 and data size of 8 bits

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      q[0] <= 8'b0; // Reset the queue on positive edge of reset signal
    end else begin
      // Enqueue operation
      if (enqueue) begin
        q[0] <= data_in;
      end

      // Dequeue operation
      if (dequeue) begin
        q[0] <= 8'b0;
      end
    end
  end

  assign data_out = q[0];

endmodule