-------------------------------------------------------------
-- File: memTestDataBus_controller.vhd
-- Author: Felipe Viel
-- File function: FSM behavior of memTestDataBus
-- Created: 17/05/2023
-- Modified: 07/05/2023
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memTestDataBus_controller is
  generic (
    DATUM_WIDTH             : natural := 8  -- size of datum -- default is 8b (char)
  );

  port (
    -- BASIC INPUTS
    i_clk                   : in  std_logic;
    i_rst_n_async           : in  std_logic;
    
    -- INPUT DATA ---------------------------------------------------
    i_start                 : in  std_logic;
    i_address               : in  std_logic_vector (DATUM_WIDTH-1 downto 0);
    -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_write_ready    : in  std_logic; 
    -- to get when read data is ok maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_read_valid     : in  std_logic; 
    -- if address != 0 pattern then i_compare_address == 1 else 0
    i_compare_address       : in  std_logic; 
    -- if pattern is 0 then i_pattern_zero == 1 else 0
    i_pattern_zero          : in std_logic;
    -- OUTPUT ---------------------------------------------------
    -- enable or not write in REG_PATTERN
    o_ena_reg_pattern       : out std_logic;
    -- enable or not write in REG_ADDRESS
    o_ena_reg_address       : out std_logic;
    -- rst REGISTERS
    o_rst_reg               : out std_logic;
    -- select PATTERN or MEMORY data to store in REG_ADDRESS
    o_sel_reg_address       : out std_logic;
    -- flag to indicate error: 1 to error and 0 to ok
    o_error                 : out std_logic;
    -- indicate end of configuration
    o_end                   : out std_logic
  );

end entity memTestDataBus_controller;

architecture rtl of memTestDataBus_controller is

  -- states of FSM: the sequence of states is from up to down
  type state_t is (s_idle,
                   s_start,
                   s_save_pattern,
                   s_write_memory,
                   s_write_memory_wait,
                   s_read_memory,
                   s_read_memory_wait,
                   s_compare_address_pattern,
                   s_shift_pattern,
                   s_error_signal,
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

  P_NXT_ST : process (i_clk, i_address, i_start, i_memory_write_ready) is
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
        next_state <= s_save_pattern;

      when s_save_pattern =>
        next_state <= s_write_memory;
      
      when s_write_memory =>  -- maybe is necessary change here to talk with memmory using the necessary signals
        next_state <= s_write_memory_wait;
    
      when s_write_memory_wait => -- maybe is necessary change here to talk with memmory using the necessary signals
        if i_memory_write_ready = '1' then
          next_state <= s_read_memory;
        else
          next_state <= s_write_memory_wait;
        end if;

      when s_read_memory => -- maybe is necessary change here to talk with memmory using the necessary signals
        next_state <= s_read_memory_wait;
 
      when s_read_memory_wait => -- maybe is necessary change here to talk with memmory using the necessary signals
        if i_memory_read_valid = '1' then
          next_state <= s_compare_address_pattern;
        else
          next_state <= s_read_memory_wait;
        end if;
      
      when s_compare_address_pattern =>
        if i_compare_address = '0' then
          next_state <= s_shift_pattern;
        else
          next_state <= s_error_signal;
        end if;
      
      when s_shift_pattern =>
        if i_pattern_zero = '0' then
          next_state <= s_save_pattern;
        else
          next_state <= s_end;
        end if;

      when s_error_signal =>
        next_state <= s_end;

      when s_end =>
        next_state <= s_idle;
      -------------------------------------------------------------
      -------------------------------------------------------------
      when others => next_state <= s_idle;
    end case;
  end process P_NXT_ST;
  
  -- enable or not write in REG_PATTERN
  o_ena_reg_pattern  <= '1' when current_state = s_start else '0';
  -- enable or not write in REG_ADDRESS
  o_ena_reg_address  <= '1' when (current_state = s_start or 
                                  current_state = s_read_memory or 
                                  current_state = s_read_memory_wait or
                                  current_state = s_shift_pattern) 
                            else '0';
  -- rst REGISTERS
  o_rst_reg          <=  '1' when current_state = s_idle else '0';
  -- select data to store in REG_ADDRESS
  o_sel_reg_address  <=  '0' when current_state = s_save_pattern else '1';
  -- flag to indicate error: 1 to error and 0 to ok
  o_error            <= '1' when current_state = s_error_signal else '0';
  -- indicate end of verification
  o_end              <= '1' when current_state = s_end else '0';

  
end architecture rtl;
