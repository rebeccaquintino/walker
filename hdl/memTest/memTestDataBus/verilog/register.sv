/* 
 * File: register.sv
 * Author: Rebecca Quintino Do Ó
 * File function: Register with enable and reset
 * Created: 24/02/2025
 */
 
module register #(
    parameter p_WIDTH = 8,          // Width of the register (default is 8 bits)
    parameter p_INIT_DATA = 0       // Initial value of the register (default is 0)
)(
    // Inputs
    input logic i_CLK,              // Clock signal
    input logic i_RST,              // Reset signal (active high)
    input logic i_ENABLE,           // Enable signal
    input logic [p_WIDTH-1:0] i_DIN, // Input data

    // Outputs
    output logic [p_WIDTH-1:0] o_DOUT // Output data
);

    // Internal register to store the value
    logic [p_WIDTH-1:0] w_DOUT_REG;

    // Register behavior
    always_ff @(posedge i_CLK or posedge i_RST) begin
        if (i_RST) begin
            // Reset: initialize the register with p_INIT_DATA
            w_DOUT_REG <= p_INIT_DATA;
        end
        else if (i_ENABLE) begin
            // Enable active: load the value of i_DIN into the register
            w_DOUT_REG <= i_DIN;
        end
    end

    // Output assignment
    assign o_DOUT = w_DOUT_REG;

endmodule