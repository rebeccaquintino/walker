/*
 * File: adder.sv
 * Author: Rebecca Quintino Do Ó
 * File function: Parameterizable full-adder
 * Created: 24/02/2025
 */

module adder #(
    parameter p_WIDTH = 8 // Width of the input/output data (default is 8 bits)
)(
    // Inputs
    input logic [p_WIDTH-1:0] i_DIN0,  // First input data
    input logic [p_WIDTH-1:0] i_DIN1,  // Second input data

    // Outputs
    output logic [p_WIDTH-1:0] o_DOUT, // Output data
    output logic o_OVERFLOW            // Overflow signal
);

    // Internal signal to store the result with an extra bit for overflow
    logic [p_WIDTH:0] w_RESULT; // (p_WIDTH + 1) bits

    // Adder logic
    assign w_RESULT = i_DIN0 + i_DIN1; // Addition with automatic bit extension

    // Output assignment
    assign o_DOUT = w_RESULT[p_WIDTH-1:0]; // Lower p_WIDTH bits for the output
    assign o_OVERFLOW = w_RESULT[p_WIDTH]; // MSB for overflow detection

endmodule