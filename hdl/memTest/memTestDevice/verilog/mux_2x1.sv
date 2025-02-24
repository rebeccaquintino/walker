/* 
 * File: mux_2x1.sv
 * Author: Rebecca Quintino Do Ó
 * File function: 2x1 multiplexer
 * Created: 24/02/2025
 */

module mux_2x1 #(
    parameter p_WIDTH = 8 // Width of the input/output data (default is 8 bits)
)(
    // Inputs
    input logic [p_WIDTH-1:0] i_DIN0,  // First input data
    input logic [p_WIDTH-1:0] i_DIN1,  // Second input data
    input logic i_SEL,                 // Select signal

    // Outputs
    output logic [p_WIDTH-1:0] o_DOUT  // Output data
);

    // Multiplexer logic
    assign o_DOUT = (i_SEL == 1'b0) ? i_DIN0 : i_DIN1;

endmodule