/*
 * File: shifter.sv
 * Author: Rebecca Quintino Do Ó
 * File function: Shifter data to left or right and identify zero values after shift
 * Created: 15/03/2025
 */

module shifter #(
  parameter p_WIDTH_DATA     = 8,      // Width of the input/output data
  parameter p_NUMBER_SHIFTER = 3       // Number of bits to shift
)(
  input  logic [p_WIDTH_DATA-1:0]      i_value,    // Input value to be shifted
  input  logic                         i_RL,       // 0 for Right or 1 for Left
  input  logic [p_NUMBER_SHIFTER-1:0]  i_shifter,  // Number of shifts
  output logic [p_WIDTH_DATA-1:0]      o_value,    // Shifted output value
  output logic                         o_zero      // Indicates if the result is zero
);

  logic [p_WIDTH_DATA-1:0] r_value;                // Internal signal for shifted value
  logic [p_WIDTH_DATA-1:0] r_Unsigned_L;           // Left-shifted value
  logic [p_WIDTH_DATA-1:0] r_Unsigned_R;           // Right-shifted value

  // Left Shift
  assign r_Unsigned_L = i_value << i_shifter;

  // Right Shift
  assign r_Unsigned_R = i_value >> i_shifter;

  // Select between left or right shift based on i_RL
  assign r_value = (i_RL == 1'b0) ? r_Unsigned_R : r_Unsigned_L;

  // Output the shifted value
  assign o_VALUE = r_value;

  // Check if the shifted value is zero
  assign o_ZERO = (r_value == 0) ? 1'b1 : 1'b0;

endmodule