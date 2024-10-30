`timescale 1ns / 1ps

module Traffic_top (
    input logic clk_100MHz,  // 100 MHz clock input
    input logic reset,       // Reset signal
    input logic TAORB,       // Traffic selector input
    output logic [5:0] led   // LED output to represent traffic lights
);

    // Internal signal for half-second clock
    logic clk_halfsec;

    // Instantiate the halfsecond module to generate a half-second clock
    halfsecond halfsecond_inst (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .clk_halfsec(clk_halfsec)
    );

    // Instantiate the Traffic module, using clk_halfsec as the clock
    Traffic traffic_inst (
        .clk(clk_halfsec),
        .rst(reset),
        .TAORB(TAORB),
        .led(led)
    );

endmodule