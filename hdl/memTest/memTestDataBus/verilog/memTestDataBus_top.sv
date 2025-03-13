/*
 * File: memTestDataBus_top.sv
 * Author: Rebecca Quintino Do Ó
 * File function: Top entity to union controller and datapath
 * Created: 15/03/2025
 */

module memTestDataBus_top #(
  parameter DATUM_WIDTH = 8  // size of datum -- default is 8b (char)
)(
  // BASIC INPUTS
  input  logic                      i_clk,
  input  logic                      i_rst_n_async,
  
  // INPUT DATA ---------------------------------------------------
  input  logic                      i_start,
  input  logic [DATUM_WIDTH-1:0]    i_address,
  input  logic [DATUM_WIDTH-1:0]    i_memory_data_read,
  input  logic                      i_memory_write_ready,
  input  logic                      i_memory_read_valid,
  
  // OUTPUT ---------------------------------------------------
  output logic                      o_end,
  // flag to indicate error: 1 to error and 0 to ok
  output logic                      o_error,
  // to get when write data is stored - maybe be a counter of cycles if memory don't have signal of ready
  // it is compatible with the use of I2C or SPI IP
  output logic [DATUM_WIDTH-1:0]    o_memory_data_write
);

  // Internal signals
  logic W_RST_REGS;
  logic W_ENA_REG_PATTERN;
  logic W_ENA_REG_ADDRESS;
  logic W_EQUAL_ZERO_PATTERN;
  logic W_EQUAL_ADDRESS_PATTERN;
  logic W_SEL_MUX_PATTERN_MEMORY;
  logic W_ZERO_SHIFTER;
  logic W_RL_SHIFTER;

  // Instantiate the controller
  memTestDataBus_controller #(
    .DATUM_WIDTH(DATUM_WIDTH)
  ) u_CONTROLLER (
    // BASIC INPUTS
    .i_clk(i_clk),
    .i_rst_n_async(i_rst_n_async),
    
    // INPUT DATA ---------------------------------------------------
    .i_start(i_start),
    .i_memory_write_ready(i_memory_write_ready),
    .i_memory_read_valid(i_memory_read_valid),
    .i_equal_address_pattern(W_EQUAL_ADDRESS_PATTERN),
    .i_equal_pattern_zero(W_EQUAL_ZERO_PATTERN),
    
    // OUTPUT ---------------------------------------------------
    .o_ena_reg_pattern(W_ENA_REG_PATTERN),
    .o_ena_reg_address(W_ENA_REG_ADDRESS),
    .o_rst_reg(W_RST_REGS),
    .o_RL_shifter(W_RL_SHIFTER),
    .o_sel_mux_pattern_memory(W_SEL_MUX_PATTERN_MEMORY),
    .o_error(o_error),
    .o_end(o_end)
  );

  // Instantiate the datapath
  memTestDataBus_datapath #(
    .DATUM_WIDTH(DATUM_WIDTH)
  ) u_DATAPATH (
    // BASIC INPUTS
    .i_clk(i_clk),
    .i_rst_n_async(i_rst_n_async),
    
    .i_memory_data_read(i_memory_data_read),
    .i_ena_reg_pattern(W_ENA_REG_PATTERN),
    .i_ena_reg_address(W_ENA_REG_ADDRESS),
    .i_rst_reg(W_RST_REGS),
    .i_RL_shifter(W_RL_SHIFTER),
    .i_sel_mux_pattern_memory(W_SEL_MUX_PATTERN_MEMORY),
    
    // OUTPUT ---------------------------------------------------
    .o_memory_data_write(o_memory_data_write),
    .o_equal_address_pattern(W_EQUAL_ADDRESS_PATTERN),
    .o_equal_zero_pattern(W_EQUAL_ZERO_PATTERN),
    .o_zero(W_ZERO_SHIFTER)
  );

endmodule