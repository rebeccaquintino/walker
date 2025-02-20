-------------------------------------------------------------
-- File: memTestDataBus_datapath.vhd
-- Author: Felipe Viel
-- File function: processing blocks of memTestDataBus
-- Created: 03/07/2023
-- Modified: 19/07/2023
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
    -- enable or not write in REG_ADDRESS
    i_ena_reg_address       : in std_logic;
    -- rst REGISTERS
    i_rst_reg               : in std_logic;
    -- sel to store PATTERN or MEMORY in REG_ADDRESS
    i_sel_mux               : in std_logic;
    
    -- OUTPUT ---------------------------------------------------
    -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    o_memory_data_write     : out  std_logic_vector (DATUM_WIDTH-1 downto 0);
    -- if address != 0 pattern then i_compare_address == 1 else 0
    o_compare_address       : out  std_logic; 
    -- if pattern is 0 then i_pattern_zero == 1 else 0
    o_pattern_zero          : out std_logic  
);

end entity memTestDataBus_datapath;

architecture rtl of memTestDataBus_datapath is
   signal r_RST_REGS          : std_logic;
   signal r_DOUT_REG_PATTERN  : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal r_DOUT_REG_ADDRESS  : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal r_DATA_OUT_SHIFTER  : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal r_ZERO_OUT_SHIFTER  : std_logic;
   signal r_ZERO_OUT_COMPAR   : std_logic;
   signal r_EQUAL_OUT_COMPAR  : std_logic;
   signal r_DOUT_MUX          : std_logic_vector (DATUM_WIDTH-1 downto 0);


begin
   
   u_REG_PATTERN: entity work.reg
   generic map(
    p_WIDTH     => DATUM_WIDTH,
    p_INIT_DATA => 0 -- init patter with fixed 1 in the LSB
   )
   port map (
      i_CLK    => i_clk,
      i_RST    => r_RST_REGS,
      i_ENABLE => i_ena_reg_pattern,
      i_DIN    => r_DATA_OUT_SHIFTER,
      o_DOUT   => r_DOUT_REG_PATTERN
   );

   u_SHIFTER: entity work.shifter 
   generic map(
      p_WIDTH_DATA     => DATUM_WIDTH,
      p_NUMBER_SHIFTER => 3 -- number of bits to shifter number of data bits
   )
   port map( 
      i_value     => r_DOUT_REG_PATTERN,
      i_RL        => '1',
      i_shifter   => "001",
      o_zero      => r_ZERO_OUT_SHIFTER, 
      o_value     => r_DATA_OUT_SHIFTER
   );

   u_MUX_ADDRESS: entity work.mux_2x1
   generic map(
		p_WIDTH  =>  DATUM_WIDTH -- size of datum -- default is 8b (char)
	)
	port map (
		i_DIN0   => r_DOUT_REG_PATTERN,
		i_DIN1 	=> i_memory_data_read,
		i_SEL    => i_sel_mux,
		o_DOUT   => r_DOUT_MUX
	);

   u_REG_ADDRESS: entity work.reg
   generic map(
    p_WIDTH       => DATUM_WIDTH,
    p_INIT_DATA   => 0 -- init patter with fixed 0 in all bits
   )
   port map (
      i_CLK    => i_clk,
      i_RST    => r_RST_REGS,
      i_ENABLE => i_ena_reg_address,
      i_DIN    => r_DOUT_MUX,
      o_DOUT   => r_DOUT_REG_ADDRESS
   );

   u_COMPAR: entity work.comparador
   generic map(
      p_WIDTH => DATUM_WIDTH
   )
   port map(
      i_DIN0  => r_DOUT_REG_PATTERN,
      i_DIN1  => r_DOUT_REG_ADDRESS,
      o_ZERO  => r_ZERO_OUT_COMPAR,
      o_EQUAL => r_EQUAL_OUT_COMPAR
   );

   o_compare_address   <= r_EQUAL_OUT_COMPAR;
   o_memory_data_write <= r_DOUT_REG_PATTERN;
   o_pattern_zero      <= r_ZERO_OUT_SHIFTER;

end rtl;
   