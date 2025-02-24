// File: reg.sv
// Author: Rebecca Quintino Do Ó
// File function: Register with enable and reset
// Created: 24/02/2025

module register #(
    parameter p_WIDTH = 8,          // Width of the register
    parameter p_INIT_DATA = 0       // Initial value of the register
)(
    input logic i_CLK,              // Clock signal
    input logic i_RST,              // Reset signal (active high)
    input logic i_ENABLE,           // Enable signal
    input logic [p_WIDTH-1:0] i_DIN, // Data input
    output logic [p_WIDTH-1:0] o_DOUT // Data output
);

    logic [p_WIDTH-1:0] reg_data;   // Internal signal to store the register value

    // Sequential block for register behavior
    always_ff @(posedge i_CLK or posedge i_RST) begin
        if (i_RST) begin
            // Reset: initialize the register with p_INIT_DATA
            reg_data <= p_INIT_DATA;
        end
        else if (i_ENABLE) begin
            // Enable active: load the value of i_DIN into the register
            reg_data <= i_DIN;
        end
    end

    // Continuous assignment for the output
    assign o_DOUT = reg_data;

endmodule
