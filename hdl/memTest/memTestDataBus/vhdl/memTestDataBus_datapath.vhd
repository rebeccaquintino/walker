-------------------------------------------------------------
-- File: memTestDataBus_datapath.vhd
-- Author: Rebecca Quintino Do Ó
-- File function: processing blocks of memTestDataBus
-- Created: 24/02/2025
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity memTestDataBus_datapath is
  generic (
    DATUM_WIDTH             : natural := 8  -- size of datum -- default is 8b (char)
  );

  port (
    -- BASIC INPUTS
    i_clk                   : in  std_logic;
    i_rst_n_async           : in  std_logic;
    
    -- INPUT DATA ---------------------------------------------------
    i_memory_data_read      : in  std_logic_vector (DATUM_WIDTH-1 downto 0);
    -- enable or not write in REG_PATTERN
    i_ena_reg_pattern       : in std_logic;
    -- rst REGISTERS
    i_rst_reg               : in std_logic;
    -- Define the direction of shifter: 0 for Right or 1 for left
    i_RL_shifter            : in std_logic;
  

    
    -- OUTPUT ---------------------------------------------------
    -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    o_memory_data_write     : out  std_logic_vector (DATUM_WIDTH-1 downto 0);
    -- if address != pattern then o_equal_address_pattern == 0 else 1
    o_equal_address_pattern : out  std_logic; 
    -- if pattern = 0b00000000 then o_equal_zero_pattern == 1 else 0
    o_equal_zero_pattern    : out std_logic;
    -- if only one bit is 1, OR_REDUCE results 1, else, all bits is 0, OR_REDUCE results 0
    o_zero                  : out std_logic   
);

end entity memTestDataBus_datapath;

architecture rtl of memTestDataBus_datapath is
   signal W_RST_REGS           : std_logic;
   signal W_DOUT_REG_PATTERN   : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal W_DOUT_SHIFT_PATTERN : std_logic_vector (DATUM_WIDTH-1 downto 0);


begin
   
   u_REG_PATTERN: entity work.reg
   generic map(
    p_WIDTH     => DATUM_WIDTH,
    p_INIT_DATA => 0 -- init patter with fixed 1 in the LSB
   )
   port map (
      i_CLK    => i_clk,
      i_RST    => W_RST_REGS,
      i_ENABLE => i_ena_reg_pattern,
      i_DIN    => W_DOUT_SHIFT_PATTERN,
      o_DOUT   => W_DOUT_REG_PATTERN
   );

   u_SHIFTER: entity work.shifter 
   generic map(
      p_WIDTH_DATA     => DATUM_WIDTH,
      p_NUMBER_SHIFTER => 3 -- number of bits to shifter number of data bits
   )
   port map( 
      i_value     => W_DOUT_REG_PATTERN,
      i_RL        => '1',
      i_shifter   => "001",
      o_zero      => o_zero, 
      o_value     => W_DOUT_SHIFT_PATTERN
   );

   u_COMPAR_ZERO_PATTERN: entity work.comparator
   generic map(
      p_WIDTH => DATUM_WIDTH
   )
   port map(
      i_DIN0  => "00000000",
      i_DIN1  => W_DOUT_SHIFT_PATTERN,
      o_ZERO  => o_equal_zero_pattern,
      o_EQUAL => open,
      o_LESS => open
   );
   
   u_COMPAR_ADDRESS_PATTERN: entity work.comparator
   generic map(
      p_WIDTH => DATUM_WIDTH
   )
   port map(
      i_DIN0  => w_DOUT_REG_PATTERN,
      i_DIN1  => i_memory_data_read,
      o_ZERO  => open,
      o_EQUAL => o_equal_address_pattern,
      o_LESS => open
   );

end rtl;
   