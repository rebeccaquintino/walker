// File: memTestDevice_datapath.sv
// Author: Felipe Viel
// File function: Processing blocks of memTestDataBus
// Created: 03/07/2023
// Modified: 24/02/2025 by Rebecca Quintino Do O

module memTestDevice_datapath #(
    parameter DATUM_WIDTH                  = 8,   // Size of datum (default is 8 bits)
    parameter WORDS_QTD_MEMORY             = 8,   // Number of words in memory
    parameter WIDTH_ADDRESS_MEMORY         = 32,  // Address width (32 bits)
    parameter p_INCREMENT_ACC              = 1,   // Increment value for accumulator
    parameter p_INIT_DATA_ACC              = 0,   // Initial data for accumulator
    parameter p_INIT_DATA_REG_PATTERN      = 0,   // Initial data for pattern register
    parameter p_INIT_DATA_REG_ANTIPATTERN  = 0    // Initial data for antipattern register
)(
    // BASIC INPUTS
    input  logic i_clk,                          // Clock signal
    input  logic i_rst_n_async,                  // Asynchronous reset (active low)
    
    // INPUT DATA ---------------------------------------------------
    input  logic [DATUM_WIDTH-1:0] i_memory_data_read, // Data read from memory
    input  logic i_ena_reg_pattern,              // Enable for pattern register
    input  logic i_ena_reg_antipattern,          // Enable for antipattern register
    input  logic i_ena_reg_offset,               // Enable for offset register
    input  logic i_rst_reg,                      // Reset for registers
    input  logic i_sel_mux_memory_data_read,     // Select for memory data read mux
    input  logic i_sel_mux_memory_data_write,    // Select for memory data write mux
    
    // OUTPUT ---------------------------------------------------
    output logic [DATUM_WIDTH-1:0] O_memory_data_write, // Data to write to memory
    output logic o_equal_memory_pattern,         // Indicates if memory data equals pattern
    output logic o_less_offset_nwords            // Indicates if offset is less than words
);

    // Internal signals
    logic w_RST_REGS;                            // Combined reset signal
    logic [DATUM_WIDTH-1:0] w_DOUT_ACC_PATTERN;  // Output of pattern accumulator
    logic [DATUM_WIDTH-1:0] w_NOT_DOUT_ACC_PATTERN; // Inverted pattern accumulator output
    logic [DATUM_WIDTH-1:0] w_DOUT_ACC_OFFSET;   // Output of offset accumulator
    logic [DATUM_WIDTH-1:0] w_DOUT_REG_PATTERN;  // Output of pattern register
    logic [DATUM_WIDTH-1:0] w_DOUT_REG_ANTIPATTERN; // Output of antipattern register
    logic [DATUM_WIDTH-1:0] w_DOUT_MUX_MEMORY_DATA_READ; // Output of read data mux
    logic [DATUM_WIDTH-1:0] w_DOUT_MUX_MEMORY_DATA_WRITE; // Output of write data mux

    // Instantiate the pattern accumulator
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

    // Invert the pattern accumulator output
    assign w_NOT_DOUT_ACC_PATTERN = ~w_DOUT_ACC_PATTERN;

    // Combined reset signal for registers
    assign w_RST_REGS = i_rst_reg || i_rst_n_async;

    // Instantiate the offset accumulator
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

    // Instantiate the pattern register
    reg #(
        .p_WIDTH(DATUM_WIDTH),
        .p_INIT_DATA(p_INIT_DATA_REG_PATTERN)
    ) u_REG_PATTERN (
        .i_CLK(i_clk),
        .i_RST(w_RST_REGS),
        .i_ENABLE(i_ena_reg_pattern),
        .i_DIN(w_DOUT_ACC_PATTERN),
        .o_DOUT(w_DOUT_REG_PATTERN)
    );

    // Instantiate the antipattern register
    reg #(
        .p_WIDTH(DATUM_WIDTH),
        .p_INIT_DATA(p_INIT_DATA_REG_ANTIPATTERN)
    ) u_REG_ANTIPATTERN (
        .i_CLK(i_clk),
        .i_RST(w_RST_REGS),
        .i_ENABLE(i_ena_reg_antipattern),
        .i_DIN(w_NOT_DOUT_ACC_PATTERN),
        .o_DOUT(w_DOUT_REG_ANTIPATTERN)
    );

    // Instantiate the mux for memory data read
    mux_2x1 #(
        .p_WIDTH(DATUM_WIDTH)
    ) u_MUX_PATTERN_ANTIPATTERN_RD (
        .i_DIN0(w_DOUT_ACC_PATTERN),
        .i_DIN1(w_DOUT_REG_ANTIPATTERN),
        .i_SEL(i_sel_mux_memory_data_read),
        .o_DOUT(w_DOUT_MUX_MEMORY_DATA_READ)
    );

    // Instantiate the mux for memory data write
    mux_2x1 #(
        .p_WIDTH(DATUM_WIDTH)
    ) u_MUX_PATTERN_MEMORY_WR (
        .i_DIN0(w_DOUT_ACC_PATTERN),
        .i_DIN1(w_DOUT_REG_ANTIPATTERN),
        .i_SEL(i_sel_mux_memory_data_write),
        .o_DOUT(w_DOUT_MUX_MEMORY_DATA_WRITE)
    );

    // Assign the output for memory data write
    assign O_memory_data_write = w_DOUT_MUX_MEMORY_DATA_WRITE;

    // Instantiate the comparator for pattern and memory data
    comparator #(
        .p_WIDTH(DATUM_WIDTH)
    ) u_COMPAR_PATTERN_MEMORY (
        .i_DIN0(w_DOUT_MUX_MEMORY_DATA_READ),
        .i_DIN1(i_memory_data_read),
        .o_ZERO(), // Unused
        .o_EQUAL(o_equal_memory_pattern),
        .o_LESS()  // Unused
    );

    // Instantiate the comparator for offset and words quantity
    comparator #(
        .p_WIDTH(DATUM_WIDTH)
    ) u_COMPAR_OFFSET (
        .i_DIN0(DATUM_WIDTH'(WORDS_QTD_MEMORY)), // Cast to DATUM_WIDTH
        .i_DIN1(w_DOUT_ACC_OFFSET),
        .o_ZERO(), // Unused
        .o_EQUAL(), // Unused
        .o_LESS(o_less_offset_nwords)
    );

endmodule