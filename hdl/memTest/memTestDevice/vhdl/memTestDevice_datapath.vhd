	-------------------------------------------------------------
-- File: memTestDataBus_datapath.vhd
-- Author: Felipe Viel
-- File function: processing blocks of memTestDataBus
-- Created: 03/07/2023
-- Modified: 10/01/2025 by Rebecca Quintino Do O
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
--use work.walker_package.all;

entity memTestDevice_datapath is
  generic (
    DATUM_WIDTH                   : natural := 8;  -- size of datum -- default is 8b (char)
    WORDS_QTD_MEMORY              : natural := 8;  -- VERIFICAR
    WIDTH_ADDRESS_MEMORY          : natural := 32; -- 32b
    p_INCREMENT_ACC               : natural := 1;
    p_INIT_DATA_ACC               : natural := 0;
    p_INIT_DATA_REG_PATTERN       : natural := 0;
    p_INIT_DATA_REG_ANTIPATTERN   : natural := 0
  );

  port (
    -- BASIC INPUTS
    i_clk                         : in  std_logic;
    i_rst_n_async                 : in  std_logic;
    
    -- INPUT DATA ---------------------------------------------------
    -- to get when read data is ok maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_data_read            : in  std_logic_vector (DATUM_WIDTH-1 downto 0);
    -- enable or not write in REG_PATTERN  inside ACC
    i_ena_reg_pattern             : in std_logic;
    -- enable or not write in REG_ANTIPATTERN inside ACC
    i_ena_reg_antipattern         : in std_logic;
    -- enable or not write in REG_OFFSET
    i_ena_reg_offset              : in std_logic;
    -- rst REGISTERS
    i_rst_reg                     : in std_logic;
    -- sel to input PATTERN or ANTIPATTERN to compare with data from memory
    i_sel_mux_memory_data_read    : in std_logic;
    -- sel to store PATTERN or ANTIPATTERN in memory
    i_sel_mux_memory_data_write   : in std_logic;
    
    -- OUTPUT ---------------------------------------------------
    -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    O_memory_data_write           : out  std_logic_vector (DATUM_WIDTH-1 downto 0);
    -- if address != pattern then == 0 else 1
    o_equal_memory_pattern        : out  std_logic; 
    -- if offset is less than words == 1 else 0
    o_less_offset_nwords          : out std_logic
);

end entity memTestDevice_datapath;

    architecture rtl of memTestDevice_datapath is
   signal w_RST_REGS                   : std_logic;
   signal w_DOUT_ACC_PATTERN           : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal w_NOT_DOUT_ACC_PATTERN       : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal w_DOUT_ACC_OFFSET            : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal w_DOUT_REG_PATTERN           : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal w_DOUT_REG_ANTIPATTERN       : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal w_DOUT_MUX_MEMORY_DATA_READ  : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal w_DOUT_MUX_MEMORY_DATA_WRITE : std_logic_vector (DATUM_WIDTH-1 downto 0);

begin
   
   u_ACC_PATTERN: entity work.accumulator 
      generic map(
         p_WIDTH     => DATUM_WIDTH,
         p_INCREMENT => p_INCREMENT_ACC,
         p_INIT_DATA => p_INIT_DATA_ACC
       )
       port map(
         i_CLK          => i_clk,
         i_RST          => i_rst_n_async,
         i_RST_CONTROL  => i_rst_reg,
         i_ENABLE       => i_ena_reg_pattern,
         o_DOUT         => w_DOUT_ACC_PATTERN 
       );

   w_NOT_DOUT_ACC_PATTERN <= not w_DOUT_ACC_PATTERN;
--   w_RST_REGS <= i_rst_reg OR i_rst_n_async;

   u_ACC_OFFSET: entity work.accumulator 
      generic map(
         p_WIDTH     => DATUM_WIDTH,
         p_INCREMENT => p_INCREMENT_ACC,
         p_INIT_DATA => p_INIT_DATA_ACC
      )
      port map(
         i_CLK          => i_clk,
         i_RST          => i_rst_n_async,
         i_RST_CONTROL  => i_rst_reg,
         i_ENABLE       => i_ena_reg_offset,
         o_DOUT         => w_DOUT_ACC_OFFSET
      );

   u_REG_PATTERN: entity work.reg
   generic map(
      p_WIDTH       => DATUM_WIDTH,
      p_INIT_DATA   => p_INIT_DATA_REG_PATTERN -- init patter with fixed 0 in all bits
   )
   port map (
      i_CLK    => i_clk,
      i_RST    => i_rst_n_async,
      i_ENABLE => i_ena_reg_pattern,
      i_DIN    => w_DOUT_ACC_PATTERN,
      o_DOUT   => w_DOUT_REG_PATTERN
   );

   u_REG_ANTIPATTERN: entity work.reg
   generic map(
      p_WIDTH       => DATUM_WIDTH,
      p_INIT_DATA   => p_INIT_DATA_REG_ANTIPATTERN -- init patter with fixed 0 in all bits
   )
   port map (
      i_CLK    => i_clk,
      i_RST    => i_rst_n_async,
      i_ENABLE => i_ena_reg_antipattern,
      i_DIN    => w_NOT_DOUT_ACC_PATTERN,
      o_DOUT   => w_DOUT_REG_ANTIPATTERN
   );

   u_MUX_PATTERN_ANTIPATTERN_RD: entity work.mux_2x1
   generic map(
		p_WIDTH  =>  DATUM_WIDTH -- size of datum -- default is 8b (char)
	)
	port map (
		i_DIN0   => w_DOUT_ACC_PATTERN,
		i_DIN1   => w_DOUT_REG_ANTIPATTERN,
		i_SEL    => i_sel_mux_memory_data_read,
		o_DOUT   => w_DOUT_MUX_MEMORY_DATA_READ
	);
	

   u_MUX_PATTERN_MEMORY_WR: entity work.mux_2x1
   generic map(
		p_WIDTH  =>  DATUM_WIDTH -- size of datum -- default is 8b (char)
	)
	port map (
		i_DIN0   => w_DOUT_ACC_PATTERN,
		i_DIN1   => w_DOUT_REG_ANTIPATTERN,
		i_SEL    => i_sel_mux_memory_data_write,
		o_DOUT   => w_DOUT_MUX_MEMORY_DATA_WRITE 
	);

   O_memory_data_write <= w_DOUT_MUX_MEMORY_DATA_WRITE;

   u_COMPAR_PATTERN_MEMORY: entity work.comparator
   generic map(
      p_WIDTH => DATUM_WIDTH
   )
   port map(
      i_DIN0  => w_DOUT_MUX_MEMORY_DATA_READ,
      i_DIN1  => i_memory_data_read,
      o_ZERO  => open,
      o_EQUAL => o_equal_memory_pattern,
      o_LESS  => open
   );

   u_COMPAR_OFFSET: entity work.comparator
   generic map(
      p_WIDTH => DATUM_WIDTH
   )
   port map(
      i_DIN0  => std_logic_vector(to_unsigned(WORDS_QTD_MEMORY, DATUM_WIDTH)), -- changed WIDTH_ADDRESS_MEMORY to DATUM_WIDTH
      i_DIN1  => w_DOUT_ACC_OFFSET, -- check if it was started at "00000000"  -- worked in accumulator testbench
      o_ZERO  => open,
      o_EQUAL => open,
      o_LESS  => o_less_offset_nwords
   );



end rtl;
   
