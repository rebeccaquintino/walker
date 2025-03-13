/*
 * File: memTestDataBus_datapath.sv
 * Author: Rebecca Quintino Do Ó
 * File function: Processing blocks of memTestDataBus
 * Created: 15/03/2025
 */

module memTestDataBus_datapath #(
  parameter DATUM_WIDTH = 8  // size of datum -- default is 8b (char)
)(
  // BASIC INPUTS
  input  logic                      i_clk,
  input  logic                      i_rst_n_async,
  
  // INPUT DATA ---------------------------------------------------
  input  logic [DATUM_WIDTH-1:0]    i_memory_data_read,
  input  logic                      i_ena_reg_pattern,
  input  logic                      i_ena_reg_address,
  input  logic                      i_rst_reg,
  input  logic                      i_RL_shifter,
  input  logic                      i_sel_mux_pattern_memory,
  
  // OUTPUT ---------------------------------------------------
  output logic [DATUM_WIDTH-1:0]    o_memory_data_write,
  output logic                      o_equal_address_pattern,
  output logic                      o_equal_zero_pattern,
  output logic                      o_zero
);

  // Internal signals
  logic W_RST_REGS;
  logic [DATUM_WIDTH-1:0] W_DOUT_REG_PATTERN;
  logic [DATUM_WIDTH-1:0] W_DOUT_REG_ADDRESS;
  logic [DATUM_WIDTH-1:0] W_DOUT_SHIFT_PATTERN;
  logic [DATUM_WIDTH-1:0] W_DOUT_MUX_PATTERN_MEMORY;

  // Instantiate REG_PATTERN
  register #(
    .p_WIDTH(DATUM_WIDTH),
    .p_INIT_DATA(0)  // init pattern with fixed 1 in the LSB
  ) u_REG_PATTERN (
    .i_CLK(i_clk),
    .i_RST(W_RST_REGS),
    .i_ENABLE(i_ena_reg_pattern),
    .i_DIN(W_DOUT_SHIFT_PATTERN),
    .o_DOUT(W_DOUT_REG_PATTERN)
  );

  // Instantiate REG_ADDRESS
  register #(
    .p_WIDTH(DATUM_WIDTH),
    .p_INIT_DATA(0)  // init pattern with fixed 0 in all bits
  ) u_REG_ADDRESS (
    .i_CLK(i_clk),
    .i_RST(W_RST_REGS),
    .i_ENABLE(i_ena_reg_address),
    .i_DIN(W_DOUT_MUX_PATTERN_MEMORY),
    .o_DOUT(W_DOUT_REG_ADDRESS)
  );

  // Instantiate SHIFTER
  shifter #(
    .p_WIDTH_DATA(DATUM_WIDTH),
    .p_NUMBER_SHIFTER(3)  // number of bits to shift
  ) u_SHIFTER (
    .i_value(W_DOUT_REG_PATTERN),
    .i_RL(1'b1),  // 1 for left shift
    .i_shifter(3'b001),
    .o_zero(o_zero),
    .o_value(W_DOUT_SHIFT_PATTERN)
  );

  // Instantiate MUX_PATTERN_MEMORY
  mux_2x1 #(
    .p_WIDTH(DATUM_WIDTH)
  ) u_MUX_PATTERN_MEMORY (
    .i_DIN0(W_DOUT_REG_PATTERN),
    .i_DIN1(i_memory_data_read),
    .i_SEL(i_sel_mux_pattern_memory),
    .o_DOUT(W_DOUT_MUX_PATTERN_MEMORY)
  );

  // Instantiate COMPAR_ZERO_PATTERN
  comparator #(
    .p_WIDTH(DATUM_WIDTH)
  ) u_COMPAR_ZERO_PATTERN (
    .i_DIN0(8'b00000000),
    .i_DIN1(W_DOUT_SHIFT_PATTERN),
    .o_ZERO(o_equal_zero_pattern),
    .o_EQUAL(),  // Not used
    .o_LESS()    // Not used
  );

  // Instantiate COMPAR_ADDRESS_PATTERN
  comparator #(
    .p_WIDTH(DATUM_WIDTH)
  ) u_COMPAR_ADDRESS_PATTERN (
    .i_DIN0(W_DOUT_REG_PATTERN),
    .i_DIN1(i_memory_data_read),
    .o_ZERO(),  // Not used
    .o_EQUAL(o_equal_address_pattern),
    .o_LESS()   // Not used
  );

  // Assign outputs
  assign W_RST_REGS = i_rst_reg;
  assign o_memory_data_write = W_DOUT_REG_ADDRESS;

endmodule