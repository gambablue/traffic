`timescale 1ns / 1ps

module Traffic_top_tb;
    logic clk_100MHz;
    logic TAORB;
    logic reset;
    logic [5:0] led;

    // Instance of the Traffic_top module
    Traffic_top dut (
        clk_100MHz,  // 100 MHz clock input
        reset,       // Reset signal
        TAORB,       // Traffic selector input
        led   // LED output to represent traffic lights
    );

    // Generate 100MHz clock
    always #5 clk_100MHz = ~clk_100MHz; // 10ns period = 100MHz frequency

    // Testbench logic to simulate the required state transitions at 1Hz clock
    initial begin
        // Initialize signals
        clk_100MHz = 0;
        reset = 1;
        TAORB = 1;

        // Apply reset and release after 100ns
        #100 reset = 0;

        // S0: Green-Red, TAORB = 1 (should stay in S0)
        $display("Starting at State S0 (Green-Red) with TAORB = 1");
        #1000_000 $display("At time %0t ns, State: S0 (Green-Red), TAORB = %b, LED state = %b", $time, TAORB, led);

        // S1: Yellow-Red, TAORB = 1 (should move to S3 after this)
        $display("At State S1 (Yellow-Red) with TAORB = 1");
        #1000_000 $display("At time %0t ns, State: S1 (Yellow-Red), TAORB = %b, LED state = %b", $time, TAORB, led);

        // Stay in S1 and set TAORB = 0 (should move to S2)
        TAORB = 0;
        $display("At State S1 (Yellow-Red) with TAORB = 0 (move to S2)");
        #1000_000 $display("At time %0t ns, State: S2 (Red-Green), TAORB = %b, LED state = %b", $time, TAORB, led);

        // Stay in S2 with TAORB = 0 (should remain in S2)
        $display("At State S2 (Red-Green) with TAORB = 0 (stay in S2)");
        #1000_000 $display("At time %0t ns, State: S2 (Red-Green), TAORB = %b, LED state = %b", $time, TAORB, led);

        // Set TAORB = 1 to move to S3
        TAORB = 1;
        $display("Set TAORB = 1, moving from S2 to S3 (Red-Yellow)");
        #1000_000 $display("At time %0t ns, State: S3 (Red-Yellow), TAORB = %b, LED state = %b", $time, TAORB, led);

        // Stay in S3, and after some time, move back to S0 with TAORB = 1
        $display("After S3, move back to S0 with TAORB = 1");
        #1000_000 $display("At time %0t ns, State: S0 (Green-Red), TAORB = %b, LED state = %b", $time, TAORB, led);

        // End simulation after a full cycle
        #1000_000 $finish;
    end

    // Monitor the LED output to track state changes
    initial begin
        $monitor("At time %0t ns, LED state = %b, TAORB = %b", $time, led, TAORB);
    end
endmodule
