`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2024 11:11:08 PM
// Design Name: 
// Module Name: halfsecond
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

module halfsecond(
    input logic clk_100MHz,
    input logic reset,
    output logic clk_halfsec
    );
    
    reg [25:0] r_count = 0;
    reg r_half = 0;
    
    always @(posedge clk_100MHz or posedge reset)
        if(reset)
            r_count <= 26'b0;
        else
            if(r_count == 32499999) begin
                r_count <= 26'b0;
                r_half <= ~r_half;
            end
            else r_count <= r_count + 1;
    assign clk_halfsec = r_half;
    
endmodule