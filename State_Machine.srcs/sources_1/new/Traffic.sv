`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2024 05:28:25 PM
// Design Name: 
// Module Name: Traffic
// Project Name: 
// Target Device: BASYS3
// Tool Versions: 
// Description: Traffic light controller
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Traffic (
    input logic clk,  // Clock signal
    input logic rst,  // Reset signal
    input logic TAORB, // Traffic on A (1) or on B (0)
    output logic [5:0] led // Light bits
);

    // State encoding
    typedef enum logic [1:0] {
        GREENRED = 2'b00,  // Green for A, Red for B
        YELLOWRED = 2'b01, // Yellow for A, Red for B
        REDGREEN = 2'b10,  // Red for A, Green for B
        REDYELLOW = 2'b11  // Red for A, Yellow for B
    } state_t;

    // State variables
    state_t state_reg, state_next;
    logic val = 0;

    // Sequential logic for state transition
    always_ff @(posedge clk or posedge rst) begin
        if (rst) 
            state_reg <= GREENRED;  // Reset to initial state
        else begin
            state_reg <= state_next;
            val <= ~val; // Flip 'val' every clock cycle (may not be used)
        end
    end

    // Combinational logic for state transition and LED control
    always_comb begin
        // Default assignments
        state_next = state_reg;
        led = 6'b001100;  // Default state: Green for A, Red for B

        case (state_reg)
            GREENRED: begin
                if (!TAORB) begin
                    state_next = YELLOWRED;
                    led = 6'b010100; // Yellow for A, Red for B
                end
                else begin
                    state_next = GREENRED;
                    led = 6'b001100; // Green for A, Red for B (stay in GREENRED)
                end
            end
            YELLOWRED: begin
                state_next = REDGREEN;
                led = 6'b100001; // Red for A, Green for B
            end
            REDGREEN: begin
                if (TAORB) begin
                    state_next = REDYELLOW;
                    led = 6'b100010; // Red for A, Yellow for B
                end
                else begin
                    state_next = REDGREEN;
                    led = 6'b100001; // Red for A, Green for B (stay in REDGREEN)
                end
            end
            REDYELLOW: begin
                state_next = GREENRED;
                led = 6'b001100; // Green for A, Red for B
            end
            default: state_next = GREENRED; // Default state in case of invalid behavior
        endcase
    end
endmodule