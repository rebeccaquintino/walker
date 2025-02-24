/* 
 * File: memTestDevice_top.sv
 * Author: Rebecca Quintino Do Ó
 * File function: top entity to union controller and datapath
 * Created: 24/02/2025
 */

module memTestDevice_top #(
    parameter DATUM_WIDTH = 8 // Width of the data (default is 8 bits)
)(
    // Basic Inputs
    input logic i_clk,                   // Clock signal
    input logic i_rst_n_async,           // Asynchronous reset (active low)

    // Input Data
    input logic i_start,                 // Start signal
    input logic [DATUM_WIDTH-1:0] i_address, // Address input
    input logic [DATUM_WIDTH-1:0] i_memory_data_read, // Data read from memory
    input logic i_memory_write_ready,    // Memory write ready signal
    input logic i_memory_read_valid,     // Memory read valid signal

    // Outputs
    output logic o_end,                  // End of configuration flag
    output logic o_error,                // Error flag
    output logic [DATUM_WIDTH-1:0] o_memory_data_write // Data to write to memory
);

    // Internal signals
    logic r_RST_REGS;                    // Reset registers signal
    logic r_ENA_REG_PATTERN;             // Enable signal for pattern register
    logic r_ENA_REG_ANTIPATTERN;         // Enable signal for antipattern register
    logic r_ENA_REG_BASE_ADDR;           // Enable signal for base address register
    logic r_ENA_REG_OFFSET;              // Enable signal for offset register
    logic r_SEL_MUX_MEMORY_DATA_READ;    // Select signal for memory read mux
    logic r_SEL_MUX_MEMORY_DATA_WRITE;   // Select signal for memory write mux
    logic r_EQUAL_MEMORY_PATTERN;        // Signal indicating if pattern matches memory data
    logic r_LESS_OFFSET_NWORDS;          // Signal indicating if offset is less than word count

    // Instantiation of the controller
    memTestDevice_controller #(
        .DATUM_WIDTH(DATUM_WIDTH)
    ) u_CONTROLLER (
        .i_clk(i_clk),
        .i_rst_n_async(i_rst_n_async),
        .i_start(i_start),
        .i_memory_write_ready(i_memory_write_ready),
        .i_memory_read_valid(i_memory_read_valid),
        .i_equal_memory_pattern(r_EQUAL_MEMORY_PATTERN),
        .i_less_offset_nwords(r_LESS_OFFSET_NWORDS),
        .o_rst_reg(r_RST_REGS),
        .o_error(o_error),
        .o_end(o_end),
        .o_ena_reg_base_addr(r_ENA_REG_BASE_ADDR),
        .o_ena_reg_pattern(r_ENA_REG_PATTERN),
        .o_ena_reg_antipattern(r_ENA_REG_ANTIPATTERN),
        .o_ena_reg_offset(r_ENA_REG_OFFSET),
        .o_sel_mux_memory_data_read(r_SEL_MUX_MEMORY_DATA_READ),
        .o_sel_mux_memory_data_write(r_SEL_MUX_MEMORY_DATA_WRITE)
    );

    // Instantiation of the datapath
    memTestDevice_datapath #(
        .DATUM_WIDTH(DATUM_WIDTH)
    ) u_DATAPATH (
        .i_clk(i_clk),
        .i_rst_n_async(i_rst_n_async),
        .i_memory_data_read(i_memory_data_read),
        .i_ena_reg_pattern(r_ENA_REG_PATTERN),
        .i_ena_reg_antipattern(r_ENA_REG_ANTIPATTERN),
        .i_ena_reg_offset(r_ENA_REG_OFFSET),
        .i_rst_reg(r_RST_REGS),
        .i_sel_mux_memory_data_read(r_SEL_MUX_MEMORY_DATA_READ),
        .i_sel_mux_memory_data_write(r_SEL_MUX_MEMORY_DATA_WRITE),
        .o_memory_data_write(o_memory_data_write),
        .o_equal_memory_pattern(r_EQUAL_MEMORY_PATTERN),
        .o_less_offset_nwords(r_LESS_OFFSET_NWORDS)
    );

endmodule