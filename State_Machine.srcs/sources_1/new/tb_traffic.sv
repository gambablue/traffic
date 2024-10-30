`timescale 1ns / 1ps

module tb_traffic;

    // Inputs
    logic clk;
    logic reset;
    logic TA0RB;  // Example input to trigger state changes

    // Outputs
    logic [1:0] current_state;  // Assuming states are represented with 2 bits

    // Instantiate the traffic module (assuming it's instantiated in lfsr_top.sv)
    lfsr_top uut (
        .clk(clk),
        .reset(reset),
        .TA0RB(TA0RB),
        .current_state(current_state)  // Replace with your actual output signals
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 100MHz clock, period = 10ns
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        TA0RB = 0;

        // Wait 100ns for reset to finish
        #100;
        reset = 0;

        // Stimulate the inputs to simulate transitions
        #50 TA0RB = 1;  // Change TA0RB to trigger a transition
        #100 TA0RB = 0; // Change TA0RB again

        // Further stimulus to check all states
        #200 TA0RB = 1;  // Trigger another transition
        #300 TA0RB = 0;

        // Add more stimulus as needed to test different states
        #500;

        // Finish the simulation
        $finish;
    end

    // Monitor the current state and input signals
    initial begin
        $monitor("Time = %0t | clk = %b | reset = %b | TA0RB = %b | State = %b", 
                 $time, clk, reset, TA0RB, current_state);
    end

endmodule
