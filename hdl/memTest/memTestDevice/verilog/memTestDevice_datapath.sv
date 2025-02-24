/* 
 * File: memTestDevice_datapath.sv
 * Author: Rebecca Quintino Do Ó
 * File function: Processing blocks of memTestDevice
 * Created: 24/02/2025
 */

module memTestDevice_datapath #(  
    parameter int DATUM_WIDTH = 8,  // Size of datum, default is 8 bits (char)
    parameter int WORDS_QTD_MEMORY = 8,  // Number of words in memory
    parameter int WIDTH_ADDRESS_MEMORY = 32, // Address width, 32-bit
    parameter int p_INCREMENT_ACC = 1,
    parameter int p_INIT_DATA_ACC = 0,
    parameter int p_INIT_DATA_REG_PATTERN = 0,
    parameter int p_INIT_DATA_REG_ANTIPATTERN = 0
)(
    // Basic Inputs
    input logic i_clk,
    input logic i_rst_n_async,
    
    // Input Data
    input logic [DATUM_WIDTH-1:0] i_memory_data_read, // Data read from memory
    input logic i_ena_reg_pattern, // Enable register pattern
    input logic i_ena_reg_antipattern, // Enable register antipattern
    input logic i_ena_reg_offset, // Enable register offset
    input logic i_rst_reg, // Reset registers
    input logic i_sel_mux_memory_data_read, // Select pattern or antipattern for comparison
    input logic i_sel_mux_memory_data_write, // Select pattern or antipattern for writing
    
    // Outputs
    output logic [DATUM_WIDTH-1:0] o_memory_data_write, // Data written to memory
    output logic o_equal_memory_pattern, // Indicates if memory data equals pattern
    output logic o_less_offset_nwords // Indicates if offset is less than number of words
);

// Internal signals
logic [DATUM_WIDTH-1:0] w_DOUT_ACC_PATTERN;
logic [DATUM_WIDTH-1:0] w_NOT_DOUT_ACC_PATTERN;
logic [DATUM_WIDTH-1:0] w_DOUT_ACC_OFFSET;
logic [DATUM_WIDTH-1:0] w_DOUT_REG_PATTERN;
logic [DATUM_WIDTH-1:0] w_DOUT_REG_ANTIPATTERN;
logic [DATUM_WIDTH-1:0] w_DOUT_MUX_MEMORY_DATA_READ;
logic [DATUM_WIDTH-1:0] w_DOUT_MUX_MEMORY_DATA_WRITE;

// Accumulator for Pattern
accumulator #(
    .p_WIDTH(DATUM_WIDTH),
    .p_INCREMENT(p_INCREMENT_ACC),
    .p_INIT_DATA(p_INIT_DATA_ACC)
) u_ACC_PATTERN (
    .i_CLK(i_clk),
    .i_RST(i_rst_n_async),
    .i_RST_CONTROL(i_rst_reg),
    .i_ENABLE(i_ena_reg_pattern),
    .o_DOUT(w_DOUT_ACC_PATTERN)
);

assign w_NOT_DOUT_ACC_PATTERN = ~w_DOUT_ACC_PATTERN;

// Accumulator for Offset
accumulator #(
    .p_WIDTH(DATUM_WIDTH),
    .p_INCREMENT(p_INCREMENT_ACC),
    .p_INIT_DATA(p_INIT_DATA_ACC)
) u_ACC_OFFSET (
    .i_CLK(i_clk),
    .i_RST(i_rst_n_async),
    .i_RST_CONTROL(i_rst_reg),
    .i_ENABLE(i_ena_reg_offset),
    .o_DOUT(w_DOUT_ACC_OFFSET)
);

// Register for Pattern
register #(
    .p_WIDTH(DATUM_WIDTH),
    .p_INIT_DATA(p_INIT_DATA_REG_PATTERN)
) u_REG_PATTERN (
    .i_CLK(i_clk),
    .i_RST(i_rst_n_async),
    .i_ENABLE(i_ena_reg_pattern),
    .i_DIN(w_DOUT_ACC_PATTERN),
    .o_DOUT(w_DOUT_REG_PATTERN)
);

// Register for Antipattern
register #(
    .p_WIDTH(DATUM_WIDTH),
    .p_INIT_DATA(p_INIT_DATA_REG_ANTIPATTERN)
) u_REG_ANTIPATTERN (
    .i_CLK(i_clk),
    .i_RST(i_rst_n_async),
    .i_ENABLE(i_ena_reg_antipattern),
    .i_DIN(w_NOT_DOUT_ACC_PATTERN),
    .o_DOUT(w_DOUT_REG_ANTIPATTERN)
);

// Multiplexer to select Pattern or Antipattern for reading
mux_2x1 #(
    .p_WIDTH(DATUM_WIDTH)
) u_MUX_PATTERN_ANTIPATTERN_RD (
    .i_DIN0(w_DOUT_ACC_PATTERN),
    .i_DIN1(w_DOUT_REG_ANTIPATTERN),
    .i_SEL(i_sel_mux_memory_data_read),
    .o_DOUT(w_DOUT_MUX_MEMORY_DATA_READ)
);

// Multiplexer to select Pattern or Antipattern for writing
mux_2x1 #(
    .p_WIDTH(DATUM_WIDTH)
) u_MUX_PATTERN_MEMORY_WR (
    .i_DIN0(w_DOUT_ACC_PATTERN),
    .i_DIN1(w_DOUT_REG_ANTIPATTERN),
    .i_SEL(i_sel_mux_memory_data_write),
    .o_DOUT(w_DOUT_MUX_MEMORY_DATA_WRITE)
);

assign O_memory_data_write = w_DOUT_MUX_MEMORY_DATA_WRITE;

// Comparator for memory pattern match
comparator #(
    .p_WIDTH(DATUM_WIDTH)
) u_COMPAR_PATTERN_MEMORY (
    .i_DIN0(w_DOUT_MUX_MEMORY_DATA_READ),
    .i_DIN1(i_memory_data_read),
    .o_ZERO(),
    .o_EQUAL(o_equal_memory_pattern),
    .o_LESS()
);

// Comparator for offset and number of words
comparator #(
    .p_WIDTH(DATUM_WIDTH)
) u_COMPAR_OFFSET (
    .i_DIN0(DATUM_WIDTH'(WORDS_QTD_MEMORY)), // Convert constant to vector
    .i_DIN1(w_DOUT_ACC_OFFSET),
    .o_ZERO(),
    .o_EQUAL(),
    .o_LESS(o_less_offset_nwords)
);

endmodule
