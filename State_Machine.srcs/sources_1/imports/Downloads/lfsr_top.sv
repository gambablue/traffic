`timescale 1ns / 1ps

module Traffic_top(
    input logic clk_100MHz,
    input logic TAORB, // traffic on A
//    input logic TB, // traffic on B
    input logic reset, // should be zero for normal operation
    output logic [5:0] led
    );
    
    wire w_1Hz;
    
    Traffic r4(
        .clk(w_1Hz),
        .rst(reset),
        .TAORB (TAORB), // traffic on A or B
//        .TB (TB), // traffic on B
        .led (led)//light bits 
    );
    
    
     halfsecond uno(
         .clk_100MHz(clk_100MHz),
         .reset(reset),
         .clk_halfsec(w_1Hz)
     );
    
    // oneHz_gen uno(
    //     .clk_100MHz(clk_100MHz),
    //     .reset(reset),
    //     .clk_1Hz(w_1Hz)
    // );
     
endmodule
