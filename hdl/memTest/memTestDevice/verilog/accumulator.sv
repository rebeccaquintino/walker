/*
 * File: accumulator.sv
 * Author: Rebecca Quintino Do Ó
 * File function: Adder and registers in the format of an accumulator
 * Created: 24/02/2025
 */

module accumulator #(
    parameter p_WIDTH = 8,          // Width of the accumulator (default is 8 bits)
    parameter p_INCREMENT = 1,      // Increment value (default is 1)
    parameter p_INIT_DATA = 0       // Initial value of the accumulator (default is 0)
)(
    // Inputs
    input logic i_CLK,              // Clock signal
    input logic i_RST,              // Reset signal (active high)
    input logic i_RST_CONTROL,      // Control reset signal (active high)
    input logic i_ENABLE,           // Enable signal

    // Outputs
    output logic [p_WIDTH-1:0] o_DOUT // Output data
);

    // Internal signals
    logic [p_WIDTH-1:0] reg_data;   // Internal register to store the accumulator value
    logic w_RST_REGS;               // Combined reset signal
    logic [p_WIDTH-1:0] w_DOUT_ADDER; // Output of the adder
    logic [p_WIDTH-1:0] w_DOUT_REG; // Output of the register

    // Combined reset signal
    assign w_RST_REGS = i_RST | i_RST_CONTROL;

    // Instantiation of the register module
    register #(
        .p_WIDTH(p_WIDTH),
        .p_INIT_DATA(p_INIT_DATA)
    ) u_REG (
        .i_CLK(i_CLK),
        .i_RST(w_RST_REGS),
        .i_ENABLE(i_ENABLE),
        .i_DIN(w_DOUT_ADDER),
        .o_DOUT(w_DOUT_REG)
    );

    // Instantiation of the adder module
    adder #(
        .p_WIDTH(p_WIDTH)
    ) u_ADDER (
        .i_DIN0(w_DOUT_REG),
        .i_DIN1(p_INCREMENT),       // Increment value added to the accumulator
        .o_DOUT(w_DOUT_ADDER),
        .o_OVERFLOW()               // Overflow signal (not used)
    );

    // Output assignment
    assign o_DOUT = w_DOUT_REG;

endmodule
