-------------------------------------------------------------
-- File: memTestDevice_controller.vhd
-- Author: Felipe Viel
-- File function: FSM behavior of memTestDevice
-- Created: 03/08/2023
-- Modified: 10/01/2025 by Rebecca Quintino Do O
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memTestDevice_controller is
  generic (
    DATUM_WIDTH                 : natural := 8  -- size of datum -- default is 8b (char)
  );

  port (
    -- BASIC INPUTS
    i_clk                       : in  std_logic;
    i_rst_n_async               : in  std_logic;
    
    -- INPUT DATA ---------------------------------------------------
    i_start                     : in  std_logic;
    -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_write_ready        : in  std_logic; 
    -- to get when read data is ok maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_read_valid         : in  std_logic; 
    -- return if PATTERN OR ANTIPATTERN is equal to data from memory
    i_equal_memory_pattern      : in  std_logic;
    -- return if OFFSET is less to number of words in memory
    i_less_offset_nwords        : in  std_logic;
     
    -- OUTPUT ---------------------------------------------------
    -- rst REGISTERS async
    o_rst_reg                   : out std_logic;
    -- flag to indicate error: 1 to error and 0 to ok
    o_error                     : out std_logic;
    -- indicate end of configuration
    o_end                       : out std_logic;
    -- enable or not write in REG_BASE_ADDR
    o_ena_reg_base_addr         : out std_logic;
    -- enable or not write in REG_PATTERN
    o_ena_reg_pattern           : out std_logic;
    -- enable or not write in REG_ANTIPATTERN
    o_ena_reg_antipattern       : out std_logic;
    -- enable or not write in REG_OFFSET
    o_ena_reg_offset            : out std_logic;
    -- select PATTERN or ANTIPATTERN data to compare with memory read data
    o_sel_mux_memory_data_read  : out std_logic;
    -- select PATTERN or ANTIPATTERN data to store in memory
    o_sel_mux_memory_data_write : out std_logic
   );

end entity memTestDevice_controller;

architecture rtl of memTestDevice_controller is

  -- states of FSM: the sequence of states is from up to down
  type state_t is (s_idle,
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
                   );
  
  signal current_state    : state_t;
  signal next_state       : state_t;
  

begin  -- architecture rtl

  P_CURR_ST : process (i_clk, i_rst_n_async) is
  begin  -- process P_CURR_ST
    if i_rst_n_async = '0' then             -- asynchronous reset (active low)
      current_state <= s_idle;
    elsif i_clk'event and i_clk = '1' then  -- rising clock edge
      current_state <= next_state;
    end if;
  end process P_CURR_ST;

  P_NXT_ST : process (i_clk, 
                      i_start, 
                      i_memory_write_ready,
                      i_memory_read_valid,
                      i_equal_memory_pattern,
                      i_less_offset_nwords,
                      current_state) is
  begin  -- process P_NXT_ST
    case current_state is
      -- IDLE -----------------------------------------------------
      when s_idle =>
        if i_start = '1' then
          next_state <= s_start;
        else
          next_state <= s_idle;
        end if;
      -------------------------------------------------------------
      when s_start =>
        next_state <= s_save_pattern1;
        
      when s_save_pattern1 =>
        next_state <= s_compare_offset_nwords_loop1;
      
      when s_compare_offset_nwords_loop1 =>
        if i_less_offset_nwords = '1' then
          next_state <= s_save_pattern2;
        else
          next_state <= s_write_memory_pattern;
        end if;
        
      when s_save_pattern2 =>
        next_state <= s_compare_offset_nwords_loop2;
        
      when s_write_memory_pattern =>
       next_state <= s_accumulate_pattern_offset1;
       
      when s_accumulate_pattern_offset1 =>
        next_state <= s_compare_offset_nwords_loop1;
      
      when s_compare_offset_nwords_loop2 =>
        if i_less_offset_nwords = '1' then
          next_state <= s_save_pattern3;
        else
          next_state <= s_equal_memory_pattern;
        end if;
        
      when s_save_pattern3 =>
        next_state <= s_compare_offset_nwords_loop3;
       
      when s_equal_memory_pattern =>
        if i_equal_memory_pattern  = '1' then
          next_state <= s_save_antipattern1;
        else
          next_state <= s_error;
        end if;

      when s_save_antipattern1 =>
        next_state <= s_write_memory_antipattern;
        
      when s_error =>	
         next_state <= s_end;

      when s_write_memory_antipattern =>
      next_state <= s_compare_offset_nwords_loop2;
         
      when s_compare_offset_nwords_loop3 =>
        if i_less_offset_nwords = '1' then
          next_state <= s_end; --NULL
        else
          next_state <= s_save_antipattern2;
        end if;
       
       when s_end =>	
         next_state <= s_idle;
         
       when s_save_antipattern2 =>	
         next_state <= s_equal_memory_antipattern;
         
       when s_equal_memory_antipattern =>
        if i_equal_memory_pattern = '1' then
          next_state <= s_accumulate_pattern_offset2;
        else
          next_state <= s_error;
        end if;
       
        when s_accumulate_pattern_offset2 =>	
          next_state <= s_compare_offset_nwords_loop3;
      
      when others => next_state <= s_idle;
    end case;
  end process P_NXT_ST;

  -- reset registers in RST_REG
  o_rst_reg            <= '1' when (current_state = s_end) else '0';
  
  -- enable or not write in REG_PATTERN
  o_ena_reg_pattern  <=  '1' when (current_state = s_save_pattern1 or 
                                   current_state = s_save_pattern2 or
                                   current_state = s_save_pattern3 or
                                   current_state = s_equal_memory_pattern or
                                   current_state = s_equal_memory_antipattern or 
                                   current_state = s_accumulate_pattern_offset1 or
                                   current_state = s_accumulate_pattern_offset2 or
                                   current_state = s_write_memory_pattern or
                                   current_state = s_write_memory_antipattern)
                             else '0';

  -- enable or not write in REG_ANTIPATTERN
  o_ena_reg_antipattern  <=  '1' when (current_state = s_save_antipattern1 or
                                       current_state = s_save_antipattern2)
                                 else '0';

  -- enable or not write in REG_BASE_ADDR
  o_ena_reg_base_addr   <= '1' when (current_state = s_equal_memory_pattern or
                                     current_state = s_equal_memory_antipattern) 
                               else '0';
  
  -- enable or not write in REG_OFFSET
  o_ena_reg_offset <= '1' when (current_state = s_save_pattern1 or 
                                current_state = s_save_pattern2 or
                                current_state = s_save_pattern3 or
                                current_state = s_accumulate_pattern_offset1 or
                                current_state = s_accumulate_pattern_offset2 or
                                current_state = s_compare_offset_nwords_loop1 or
                                current_state = s_compare_offset_nwords_loop2 or
                                current_state = s_compare_offset_nwords_loop3)
                          else '0';                             

  -- select data to store pattern or antipattern in memory
  o_sel_mux_memory_data_write <= '1' when (current_state =  s_write_memory_pattern or
                                           current_State =  s_write_memory_antipattern) 
                                     else '0';  
  -- selct data in the memory to compare with pattern or antipattern
  o_sel_mux_memory_data_read <= '1' when (current_state = s_equal_memory_pattern or
                                          current_state = s_equal_memory_antipattern)
                                    else '0';
                                 
  -- flag to indicate error: 1 to error and 0 to ok
  o_error            <= '1' when current_state = s_error else '0';
  -- indicate end of verification
  o_end              <= '1' when current_state = s_end else '0';

  
end architecture rtl;