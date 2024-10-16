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
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Traffic (
    input logic clk,
    input logic rst,
    input logic TAORB, // traffic on A = 1 or on B = 0
    output logic [5:0] led // light bits
);

    typedef enum logic [1:0] {
        GREENRED = 2'b00,
        YELLOWRED = 2'b01,
        REDGREEN = 2'b10,
        REDYELLOW = 2'b11
    } state_t;

    // State variables
    state_t state_reg, state_next;
    logic val = 0;

    // Sequential logic for state transition
    always_ff @(posedge clk or posedge rst) begin
        if (rst) 
            state_reg <= GREENRED;
        else begin
            state_reg <= state_next;
            val <= ~val; // Flip 'val' every clock cycle
        end
    end

    // Combinational logic for state transition and LED control
    always_comb begin
        // Default assignments
        state_next = state_reg;
        led = 6'b001100;  // Default state: red-yellow-green (A side) and red-yellow-green (B side)

        case (state_reg)
            GREENRED: 
                if (!TAORB) begin
                    state_next = YELLOWRED;
                    led = 6'b010100; // Yellow for A, red for B
                end
            YELLOWRED: begin
                state_next = REDGREEN;
                led = 6'b100001; // Red for A, green for B
            end
            REDGREEN: 
                if (TAORB) begin
                    state_next = REDYELLOW;
                    led = 6'b100010; // Red for A, yellow for B
                end
            REDYELLOW: begin
                state_next = GREENRED;
                led = 6'b001100; // Green for A, red for B
            end
            default: state_next = GREENRED; // Default state to handle any unexpected behavior
        endcase
    end

endmodule
