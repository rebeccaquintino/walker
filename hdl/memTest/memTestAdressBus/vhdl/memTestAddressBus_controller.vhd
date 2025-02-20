-------------------------------------------------------------
-- File: memTestDataBus_controller.vhd
-- Author: Rebecca Quintino Do Ó
-- File function: 
-- Created: 28/06/2023
-- Modified: 06/07/2023
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memTestAddressBus is
  generic (
    DATUM_WIDTH                         : natural                       := 8  -- size of datum -- default is 8b (char)
  );

  port (
    -- BASIC INPUTS
    i_clk                               : in  std_logic;
    i_rst_n_async                       : in  std_logic;
    
    -- INPUT DATA ---------------------------------------------------
    -- when its start
    i_start                             : in  std_logic;
    --
    i_baseaddr                          : in  std_logic_vector (DATUM_WIDTH-1 downto 0);
    -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_write_ready                : in  std_logic; 
    -- to get when read data is ok maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_read_valid                 : in  std_logic; 
    -- if offset & addrmask != 0 then i_compare_zero == 0 else 1
    i_compare_offset_addrmask_zero      : in  std_logic; 
    -- if testoffset & addrmask != 0 then i_compare_zero == 0 else 1
    i_compare_testoffset_addrmask_zero  : in  std_logic; 
    -- if baseaddr != pattern then i_compare_equal == 0 else 1
    i_compare_baseaddr_pattern_equal    : in  std_logic;
    -- if offset != testoffset then i_compare_equal == 0 else 1
    i_compare_offset_testoffset_equal   : in  std_logic;
    -- if offset is 0 then i_offset_zero == 1 else 0
    i_offset_zero                       : in std_logic;
    -- if address mask is 0 then i_addrmask_zero == 1 else 0
    i_addrmask_zero                     : in std_logic;
    -- if testoffset is 0 then i_offset_zero == 1 else 0
    i_testoffset_zero                   : in std_logic;
    -- if baseaddr is equal to pattern then i_baseaddr_pattern_equal == 1 else 0
    i_baseaddr_pattern_equal            : in std_logic;
    -- if data shifter then i_shifter = 1 else 0
    i_shifter                           : in std_logic;
    -- if data shifter to left then i_shifter_RL = 1 else 0
    i_shifter_RL                        : in std_logic;
    
    -- OUTPUT ---------------------------------------------------
    -- rst REGISTERS
    o_rst_reg                           : out std_logic;
    -- flag to indicate error: 1 to error and 0 to ok
    o_error                             : out std_logic;
    -- flag to indicate end: 1 to end and 0 not end
    o_end                             : out std_logic;
    -- enable or not write in REG_PATTERN
    o_ena_reg_pattern                   : out std_logic;
    -- enable or not write in REG_ANTIPATTERN;
    o_ena_reg_antipattern               : out std_logic;
    -- enable or not write in REG_ADDRESS_MASK
    o_ena_reg_addr_mask                 : out std_logic;
    -- enable or not write in REG_BASE_MASK;
    o_ena_reg_base_addr                 : out std_logic;
    -- enable or not write in REG_OFFSET;
    o_ena_reg_offset                    : out std_logic;
    -- enable or not write in REG_TESTOFFSET;
    o_ena_reg_testoffset                : out std_logic   
  );

end entity memTestAddressBus;

architecture rtl of memTestAddressBus is
  -- states of FSM: the sequence of states is from up to down
  type state_t is (s_idle,
                   s_start,
                   s_write_pattern_memory1,
                   s_write_antipattern_memory1,
                   s_write_pattern_memory2,
                   s_write_antipattern_memory2,
                   s_compare_offset_addmask_zero_loop1,
                   s_save_offset1,
                   s_compare_offset_addmask_zero_loop2,
                   s_compare_baseaddr_pattern_equal_loop1,
                   s_shifter1,
                   s_shifter2,
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
                      i_baseaddr, 
                      i_start, 
                      i_memory_write_ready,
                      i_compare_offset_addrmask_zero,
                      i_compare_testoffset_addrmask_zero,
                      i_compare_baseaddr_pattern_equal,
                      i_compare_offset_testoffset_equal,
                      i_compare_offset_testoffset_equal,
                      i_offset_zero,
                      i_addrmask_zero,
                      i_testoffset_zero,
                      i_baseaddr_pattern_equal,
                      current_state                   
                      ) is
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
      -- RXVALID --------------------------------------------------
      when s_start =>
        next_state <= s_write_pattern_memory1;
      
      when s_write_pattern_memory1 =>  
        next_state <= s_compare_offset_addmask_zero_loop1;
    
      when s_compare_offset_addmask_zero_loop1 => 
        if i_compare_offset_addrmask_zero = '1' then
          next_state <= s_shifter1;
        else
          next_state <= s_write_antipattern_memory1;
        end if;

      when s_shifter1 => 
        next_state <= s_write_pattern_memory1;
 
      when s_write_antipattern_memory1 => 
          next_state <= s_save_offset1;
      
      when s_save_offset1 =>
        next_state <= s_compare_offset_addmask_zero_loop2;
        
      when s_compare_offset_addmask_zero_loop2 =>
        if i_compare_offset_addrmask_zero = '1' then
          next_state <= s_compare_baseaddr_pattern_equal_loop1;
        else
          next_state <= s_idle; -- s_write_pattern_memory2
        end if;
      
      when s_compare_baseaddr_pattern_equal_loop1 =>
        if i_baseaddr_pattern_equal = '1' then
          next_state <= s_shifter2;
        else
          next_state <= s_error;
        end if;
        
      when s_shifter2 => 
        next_state <= s_compare_offset_addmask_zero_loop2;
        
      when s_error => 
        next_state <= s_end;
      
      when s_end =>
        next_state <= s_idle;

      -------------------------------------------------------------
      -------------------------------------------------------------
      when others => next_state <= s_idle;
    end case;
  end process P_NXT_ST;
 -- enable or not write in REG_ERROR
 o_error              <= '1' when (current_state = s_error) else '0';
 -- enable or not write in REG_END
 o_end                <= '1' when (current_state = s_end) else '0'; 
 -- seset registers in RST_REG
 o_rst_reg            <= '1' when (current_state = s_end) else '0'; 
 -- enable or not write in REG_ADDR_MASK
  o_ena_reg_addr_mask <= '1' when (current_state = s_idle or
                                   current_state = s_start or 
                                   current_state = s_compare_offset_addmask_zero_loop1 or
                                   current_state = s_save_offset1 or
                                   current_state = s_compare_offset_addmask_zero_loop2) else '0';               
-- enable or not write in REG_BASE_ADDR
o_ena_reg_base_addr   <= '1' when (current_state = s_idle or
                                   current_state = s_start or 
                                   current_state = s_write_pattern_memory1 or
                                   current_state = s_write_antipattern_memory1 or
                                   current_state = s_save_offset1 or
                                   current_state = s_compare_baseaddr_pattern_equal_loop1) else '0';
-- enable or not write in REG_PATTERN                                    
o_ena_reg_pattern     <= '1' when (current_state = s_idle or
                                   current_state = s_compare_baseaddr_pattern_equal_loop1) else '0';
-- enable or not write in REG_ANTIPATTERN                                   
o_ena_reg_antipattern <= '1' when (current_state = s_idle) else '0';
-- enable or not write in REG_OFFSET                               
o_ena_reg_offset      <= '1' when (current_state = s_start or
                                   current_state = s_compare_offset_addmask_zero_loop1 or
                                   current_state = s_shifter1 or
                                   current_state = s_save_offset1 or
                                   current_state = s_compare_offset_addmask_zero_loop2 or
                                   current_state = s_shifter2) else '0';
-- enable or not write in REG_TESTOFFSET                                   
o_ena_reg_testoffset <= '1' when (current_state = s_write_antipattern_memory1) else '0';
                               
end architecture rtl;
