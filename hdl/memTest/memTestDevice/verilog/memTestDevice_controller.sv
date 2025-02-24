/* 
 * File: memTestDevice_controller.sv
 * Author: Rebecca Quintino Do Ó
 * File function: FSM behavior of memTestDevice
 * Created: 24/02/2025
 */

module memTestDevice_controller #(
    parameter DATUM_WIDTH = 8 // Width of the data (default is 8 bits)
)(
    // Basic Inputs
    input logic i_clk,                       // Clock signal
    input logic i_rst_n_async,               // Asynchronous reset (active low)

    // Input Data
    input logic i_start,                     // Start signal
    input logic i_memory_write_ready,        // Memory write ready signal
    input logic i_memory_read_valid,         // Memory read valid signal
    input logic i_equal_memory_pattern,      // Equal memory pattern signal
    input logic i_less_offset_nwords,        // Less offset number of words signal

    // Outputs
    output logic o_rst_reg,                  // Reset registers signal
    output logic o_error,                    // Error flag
    output logic o_end,                      // End of configuration flag
    output logic o_ena_reg_base_addr,        // Enable register base address
    output logic o_ena_reg_pattern,          // Enable register pattern
    output logic o_ena_reg_antipattern,      // Enable register antipattern
    output logic o_ena_reg_offset,           // Enable register offset
    output logic o_sel_mux_memory_data_read, // Select mux for memory data read
    output logic o_sel_mux_memory_data_write // Select mux for memory data write
);

    // FSM states
    typedef enum logic [4:0] {
        s_idle,
        s_start,
        s_save_pattern1,
        s_save_pattern2,
        s_save_pattern3,
        s_save_antipattern1,
        s_save_antipattern2,
        s_compare_offset_nwords_loop1,
        s_compare_offset_nwords_loop2,
        s_compare_offset_nwords_loop3,
        s_write_memory_pattern,
        s_write_memory_antipattern,
        s_accumulate_pattern_offset1,
        s_accumulate_pattern_offset2,
        s_equal_memory_pattern,
        s_equal_memory_antipattern,
        s_error,
        s_end
    } state_t;

    state_t current_state, next_state;

    // Current state logic
    always_ff @(posedge i_clk or negedge i_rst_n_async) begin
        if (!i_rst_n_async) begin
            current_state <= s_idle; // Reset to idle state
        end
        else begin
            current_state <= next_state; // Update current state
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state; // Default to current state
        case (current_state)
            s_idle: next_state = (i_start) ? s_start : s_idle;
            s_start: next_state = s_save_pattern1;
            s_save_pattern1: next_state = s_compare_offset_nwords_loop1;
            s_compare_offset_nwords_loop1: next_state = (i_less_offset_nwords) ? s_save_pattern2 : s_write_memory_pattern;
            s_save_pattern2: next_state = s_compare_offset_nwords_loop2;
            s_write_memory_pattern: next_state = s_accumulate_pattern_offset1;
            s_accumulate_pattern_offset1: next_state = s_compare_offset_nwords_loop1;
            s_compare_offset_nwords_loop2: next_state = (i_less_offset_nwords) ? s_save_pattern3 : s_equal_memory_pattern;
            s_save_pattern3: next_state = s_compare_offset_nwords_loop3;
            s_equal_memory_pattern: next_state = (i_equal_memory_pattern) ? s_save_antipattern1 : s_error;
            s_save_antipattern1: next_state = s_write_memory_antipattern;
            s_error: next_state = s_end;
            s_write_memory_antipattern: next_state = s_compare_offset_nwords_loop2;
            s_compare_offset_nwords_loop3: next_state = (i_less_offset_nwords) ? s_end : s_save_antipattern2;
            s_end: next_state = s_idle;
            s_save_antipattern2: next_state = s_equal_memory_antipattern;
            s_equal_memory_antipattern: next_state = (i_equal_memory_pattern) ? s_accumulate_pattern_offset2 : s_error;
            s_accumulate_pattern_offset2: next_state = s_compare_offset_nwords_loop3;
            default: next_state = s_idle;
        endcase
    end

    // Output logic
    assign o_rst_reg = (current_state == s_end); // Reset registers at end state

    assign o_ena_reg_pattern = (current_state inside {
        s_save_pattern1, s_save_pattern2, s_save_pattern3,
        s_equal_memory_pattern, s_equal_memory_antipattern,
        s_accumulate_pattern_offset1, s_accumulate_pattern_offset2,
        s_write_memory_pattern, s_write_memory_antipattern
    });

    assign o_ena_reg_antipattern = (current_state inside {
        s_save_antipattern1, s_save_antipattern2
    });

    assign o_ena_reg_base_addr = (current_state inside {
        s_equal_memory_pattern, s_equal_memory_antipattern
    });

    assign o_ena_reg_offset = (current_state inside {
        s_save_pattern1, s_save_pattern2, s_save_pattern3,
        s_accumulate_pattern_offset1, s_accumulate_pattern_offset2,
        s_compare_offset_nwords_loop1, s_compare_offset_nwords_loop2,
        s_compare_offset_nwords_loop3
    });

    assign o_sel_mux_memory_data_write = (current_state inside {
        s_write_memory_pattern, s_write_memory_antipattern
    });

    assign o_sel_mux_memory_data_read = (current_state inside {
        s_equal_memory_pattern, s_equal_memory_antipattern
    });

    assign o_error = (current_state == s_error); // Error flag
    assign o_end = (current_state == s_end);     // End of configuration flag

endmodule