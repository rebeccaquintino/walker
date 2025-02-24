/*
 * File: comparator.sv
 * Author: Rebecca Quintino Do Ó
 * File function: Compares the input data DIN1 and DIN0, to see if DIN0 is equal to DIN1 or if DIN0 is less than DIN1 or if any data is equal to zero.
 * Created: 24/02/2025
 */

module comparator #(
    parameter p_WIDTH = 8  // Defines the bit width of the input vectors
)(
    input  logic [p_WIDTH-1:0] i_DIN0,  // First input vector
    input  logic [p_WIDTH-1:0] i_DIN1,  // Second input vector
    output logic o_ZERO,                // Output signal: '1' if any input is zero, else '0'
    output logic o_EQUAL,               // Output signal: '1' if i_DIN0 == i_DIN1, else '0'
    output logic o_LESS                 // Output signal: '1' if i_DIN0 < i_DIN1, else '0'
);

    // Process to check if i_DIN0 is zero
    always_comb begin
        // If all bits of i_DIN0 are '0', set o_ZERO to '1'.
        // Otherwise, set o_ZERO to '0'.
        o_ZERO = (i_DIN0 == {p_WIDTH{1'b0}}) ? 1'b1 : 1'b0;
    end

    // Process to check if both input vectors are equal
    always_comb begin
        // If i_DIN0 is equal to i_DIN1, set o_EQUAL to '1'.
        // Otherwise, set o_EQUAL to '0'.
        o_EQUAL = (i_DIN0 == i_DIN1) ? 1'b1 : 1'b0;
    end

    // Process to check if i_DIN0 is less than i_DIN1
    always_comb begin
        // If i_DIN0 is less than i_DIN1, set o_LESS to '1'.
        // Otherwise, set o_LESS to '0'.
        o_LESS = (i_DIN0 < i_DIN1) ? 1'b1 : 1'b0;
    end

endmodule
