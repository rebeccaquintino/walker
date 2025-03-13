/*
 * File: memTestDataBus_controller.sv
 * Author: Rebecca Quintino Do Ó
 * File function: Controller for memory test data bus
 * Created: 15/03/2025
 */

module memTestDataBus_controller #(
  parameter DATUM_WIDTH = 8  // size of datum -- default is 8b (char)
)(
  // BASIC INPUTS
  input  logic                      i_clk,
  input  logic                      i_rst_n_async,
  
  // INPUT DATA ---------------------------------------------------
  input  logic                      i_start,
  input  logic                      i_memory_write_ready,
  input  logic                      i_memory_read_valid,
  input  logic                      i_equal_address_pattern,
  input  logic                      i_equal_pattern_zero,
  
  // OUTPUT ---------------------------------------------------
  output logic                      o_ena_reg_pattern,
  output logic                      o_ena_reg_address,
  output logic                      o_rst_reg,
  output logic                      o_error,
  output logic                      o_end,
  output logic                      o_RL_shifter,
  output logic                      o_sel_mux_pattern_memory
);

  // States of FSM: the sequence of states is from up to down
  typedef enum logic [3:0] {
    s_idle,
    s_start,
    s_equal_pattern_zero,
    s_save_address,
    s_equal_address_pattern,
    s_shift_pattern,
    s_error,
    s_end
  } state_t;

  state_t current_state;
  state_t next_state;

  // State transition process
  always_ff @(posedge i_clk or negedge i_rst_n_async) begin
    if (!i_rst_n_async) begin
      current_state <= s_idle;
    end else begin
      current_state <= next_state;
    end
  end

  // Next state logic
  always_comb begin
    case (current_state)
      // IDLE -----------------------------------------------------
      s_idle: begin
        if (i_start) begin
          next_state = s_start;
        end else begin
          next_state = s_idle;
        end
      end
      // ----------------------------------------------------------
      s_start: begin
        next_state = s_equal_pattern_zero;
      end

      s_equal_pattern_zero: begin
        if (i_equal_pattern_zero) begin
          next_state = s_save_address;
        end else begin
          next_state = s_end;
        end
      end

      s_save_address: begin
          next_state = s_equal_address_pattern;
      end

      s_equal_address_pattern: begin
        if (i_equal_address_pattern) begin
          next_state = s_shift_pattern;
        end else begin
          next_state = s_error;
        end
      end

      s_shift_pattern: begin
        next_state = s_equal_pattern_zero;
      end

      s_error: begin
        next_state = s_end;
      end

      s_end: begin
        next_state = s_idle;
      end

      default: begin
        next_state = s_idle;
      end
    endcase
  end

  // Output logic
  assign o_ena_reg_pattern = (current_state == s_start || 
                              current_state == s_equal_address_pattern || 
                              current_state == s_shift_pattern || 
                              current_state == s_equal_pattern_zero);

  assign o_ena_reg_address = (current_state == s_start || 
                              current_state == s_save_address || 
                              current_state == s_equal_address_pattern);

  assign o_RL_shifter = (current_state == s_start || 
                         current_state == s_save_address || 
                         current_state == s_equal_address_pattern || 
                         current_state == s_shift_pattern || 
                         current_state == s_equal_pattern_zero || 
                         current_state == s_error || 
                         current_state == s_end || 
                         current_state == s_idle);

  assign o_rst_reg = (current_state == s_idle);

  assign o_sel_mux_pattern_memory = (current_state == s_save_address);

  assign o_error = (current_state == s_error);

  assign o_end = (current_state == s_end);

endmodule