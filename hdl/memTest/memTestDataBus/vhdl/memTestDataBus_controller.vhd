-------------------------------------------------------------
-- File: memTestDataBus_controller.vhd
-- Author: Rebecca Quintino Do Ó 
-- File function: FSM behavior of memTestDataBus
-- Created: 26/02/2025
-- Modified: 07/03/2025
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
    -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_write_ready    : in  std_logic; 
    -- to get when read data is ok maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_read_valid     : in  std_logic; 
    -- if address != 0 pattern then i_compare_address == 1 else 0
    i_equal_address_pattern : in  std_logic; 
    -- if pattern is 0 then i_pattern_zero == 1 else 0
    i_equal_pattern_zero    : in std_logic;
    
    -- OUTPUT ---------------------------------------------------
    -- enable or not write in REG_PATTERN
    o_ena_reg_pattern        : out std_logic;
    -- enable or not write in REG_ADDRESS   
    o_ena_reg_address        : out std_logic;
    -- rst REGISTERS
    o_rst_reg                : out std_logic;
    -- flag to indicate error: 1 to error and 0 to ok
    o_error                  : out std_logic;
    -- indicate end of configuration
    o_end                    : out std_logic;
    -- 0 for Right or 1 for left
    o_RL_shifter             : out std_logic;
    -- select to store PATTERN or MEMORY in REG_ADDRESS
    o_sel_mux_pattern_memory : out std_logic
  );

end entity memTestDataBus_controller;

architecture rtl of memTestDataBus_controller is

  -- states of FSM: the sequence of states is from up to down
  type state_t is (s_idle,
                   s_start,
                   s_read_address1,
                   s_equal_pattern_zero,
                   s_save_address,
                   s_read_address2,
                   s_equal_address_pattern,
                   s_shift_pattern,
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
                      i_equal_address_pattern,
                      i_equal_pattern_zero) is
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
        next_state <= s_save_address;
    
      when s_read_address1 => -- maybe is necessary change here to talk with memmory using the necessary signals
        if i_memory_write_ready = '1' then
          next_state <= s_equal_pattern_zero; --s_read_memory;
        else
          next_state <= s_read_address1;
        end if;
        
      when s_equal_pattern_zero => 
        if i_equal_pattern_zero = '1' then
          next_state <= s_save_address;
        else
          next_state <= s_end; --NULL
        end if; 

      when s_save_address => -- maybe is necessary change here to talk with memmory using the necessary signals
        if i_memory_read_valid = '1' then
          next_state <= s_read_address2;
        else
          next_state <= s_save_address;
        end if; 
        
      when s_read_address2 => -- maybe is necessary change here to talk with memmory using the necessary signals
        if i_memory_read_valid = '1' then
          next_state <= s_equal_address_pattern ;
        else
          next_state <= s_read_address2;
        end if; 
    
      when s_equal_address_pattern => 
        if i_equal_address_pattern = '1' then
          next_state <= s_shift_pattern;
        else
          next_state <= s_error;
        end if;

      when s_shift_pattern => 
        next_state <= s_equal_pattern_zero;
 
      

      when s_error =>
        next_state <= s_end;

      when s_end =>
        next_state <= s_idle;
      -------------------------------------------------------------
      -------------------------------------------------------------
      when others => next_state <= s_idle;
    end case;
  end process P_NXT_ST;
  
  -- enable or not write in REG_PATTERN
  o_ena_reg_pattern  <= '1' when (current_state = s_start or
                                  current_state = s_equal_address_pattern or
                                  current_state = s_shift_pattern or
                                  current_state = s_equal_pattern_zero) 
                            else '0';
  -- enable or not write in REG_ADDRESS
  o_ena_reg_address <= '1' when (current_state = s_start or
                                 current_state = s_read_address1 or
                                 current_state = s_save_address or  
                                 current_state = s_read_address2 or
                                 current_state = s_equal_address_pattern) 
                           else '0';
  -- 0 for Right or 1 for left
  o_RL_shifter <= '1' when (current_state = s_start or 
                            current_state = s_save_address or 
                            current_state = s_equal_address_pattern or
                            current_state = s_shift_pattern or
                            current_state = s_equal_pattern_zero or
                            current_state = s_error or
                            current_state = s_end or
                            current_state = s_idle) 
                      else '0';
  -- rst REGISTERS
  o_rst_reg                <= '1' when current_state = s_idle else '0';
  -- select data to store in REG_ADDRESS
  o_sel_mux_pattern_memory <= '1' when current_state = s_save_address else '0';
  -- flag to indicate error: 1 to error and 0 to ok
  o_error                  <= '1' when current_state = s_error else '0';
  -- indicate end of verification
  o_end                    <= '1' when current_state = s_end else '0';

  
end architecture rtl;
