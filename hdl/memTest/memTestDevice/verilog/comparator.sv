/*
 * File: comparator.sv
 * Author: Rebecca Quintino Do Ó
 * File function: Compares the input data DIN1 and DIN0, to see if DIN0 is equal to DIN1 or if DIN0 is less than DIN1 or if any data is equal to zero.
 * Created: 24/02/2025
 */

module comparator #(
    parameter int p_WIDTH = 8 // Width of input data
)(
    input  logic [p_WIDTH-1:0] i_DIN0, // First input data
    input  logic [p_WIDTH-1:0] i_DIN1, // Second input data
    output logic o_ZERO,  // Output signal indicating if any input is zero
    output logic o_EQUAL, // Output signal indicating if i_DIN0 == i_DIN1
    output logic o_LESS   // Output signal indicating if i_DIN0 < i_DIN1
);

    // Check if any input is zero
    always_comb begin
        o_ZERO = (|i_DIN0) ? 1'b0 : 1'b1;
    end

    // Check if the inputs are equal
    always_comb begin
        o_EQUAL = (i_DIN0 == i_DIN1) ? 1'b1 : 1'b0;
    end

    // Check if i_DIN0 is less than i_DIN1
    always_comb begin
        o_LESS = (i_DIN0 < i_DIN1) ? 1'b1 : 1'b0;
    end

endmodule
