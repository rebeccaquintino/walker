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
use work.walker_package.all;

entity memTestDataBus_datapath is
  generic (
    DATUM_WIDTH             : natural := 8;  -- size of datum -- default is 8b (char)
    p_INCREMENT_ACC         : natural := 1;
    p_INIT_DATA_ACC         : natural := 0;
    p_INIT_DATA_REG_ANTIP   : natural := 0
  );

  port (
    -- BASIC INPUTS
    i_clk                   : in  std_logic;
    i_rst_n_async           : in  std_logic;
    
    -- INPUT DATA ---------------------------------------------------
    i_memory_data_read      : in  std_logic_vector (DATUM_WIDTH-1 downto 0);
    -- enable or not write in REG_PATTERN  inside ACC
    i_ena_reg_pattern       : in std_logic;
    -- enable or not write in REG_ANTIPATTERN inside ACC
    i_ena_reg_antipattern       : in std_logic;
    -- enable or not write in REG_OFFSET
    i_ena_reg_offset       : in std_logic;
    -- rst REGISTERS
    i_rst_reg               : in std_logic;
    -- sel to input PATTERN or ANTIPATTER to compar with data from memory
    i_sel_mux_compar        : in std_logic;
    -- sel to store PATTERN or ANTIPATTER in memory
    i_sel_mux_memory        : in std_logic;
    
    -- OUTPUT ---------------------------------------------------
    -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    o_memory_data_write     : out  std_logic_vector (DATUM_WIDTH-1 downto 0);
    -- if address != 0 pattern then i_compare_address == 1 else 0
    o_equal_patter_mem       : out  std_logic; 
    -- if pattern is 0 then i_pattern_zero == 1 else 0
    o_equal_offset_words          : out std_logic  
);

end entity memTestDataBus_datapath;

architecture rtl of memTestDataBus_datapath is
   signal w_RST_REGS                      : std_logic;
   signal W_DOUT_ACC_PATTER               : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal w_NOT_DOUT_ACC_PATTER           : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal w_DOUT_ACC_OFFSET               : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal w_DOUT_REG_ANTIPATTER           : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal w_DOUT_MUX_PATTERN_ANTIPATTERN  : std_logic_vector (DATUM_WIDTH-1 downto 0);
   signal r_EQUAL_OUT_COMPAR              : std_logic;
   signal r_DOUT_MUX                      : std_logic_vector (DATUM_WIDTH-1 downto 0);


begin
   
   u_ACC_PATTERN: entity work.accumulator 
      generic map(
         p_WIDTH     => DATUM_WIDTH,
         p_INCREMENT => p_INCREMENT_ACC,
         p_INIT_DATA => p_INIT_DATA_ACC
       );
       port map(
         i_CLK          => i_clk,
         i_RST          => i_rst_n_async,
         i_RST_CONTROL  => i_rst_reg,
         i_ENABLE       => i_ena_reg_pattern,
         o_DOUT         => W_DOUT_ACC_PATTER -- in the block diagram is W_DOUT_REG_PATTER
       );

   u_ACC_OFFSET: entity work.accumulator 
      generic map(
         p_WIDTH     => WIDTH_ADDRESS_MEMORY,
         p_INCREMENT => p_INCREMENT_ACC,
         p_INIT_DATA => p_INIT_DATA_ACC
      )
      port map(
         i_CLK          => i_clk,
         i_RST          => i_rst_n_async,
         i_RST_CONTROL  => i_rst_reg,
         i_ENABLE       => i_ena_reg_offset,
         o_DOUT         => w_DOUT_ACC_OFFSET -- in the block diagram is W_DOUT_REG_OFFSET
      );

   w_NOT_DOUT_ACC_PATTER <= not W_DOUT_ACC_PATTER;
   w_RST_REGS <= i_rst_reg OR i_rst_n_async;

   u_REG_ANTIPATTERN: entity work.reg
   generic map(
      p_WIDTH       => DATUM_WIDTH,
      p_INIT_DATA   => p_INIT_DATA_REG_ANTIP -- init patter with fixed 0 in all bits
   )
   port map (
      i_CLK    => i_clk,
      i_RST    => r_RST_REGS,
      i_ENABLE => i_ena_reg_antipattern,
      i_DIN    => w_NOT_DOUT_ACC_PATTER,
      o_DOUT   => w_DOUT_REG_ANTIPATTER
   );

   u_MUX_PATTERN_ANTIPATTERN_RD: entity work.mux_2x1
   generic map(
		p_WIDTH  =>  DATUM_WIDTH -- size of datum -- default is 8b (char)
	)
	port map (
		i_DIN0   => W_DOUT_ACC_PATTER,
		i_DIN1 	=> w_DOUT_REG_ANTIPATTER,
		i_SEL    => i_sel_mux_compar,
		o_DOUT   => w_DOUT_MUX_PATTERN_ANTIPATTERN
	);

   u_COMPAR_PATTERN_MEMORY: entity work.comparador
   generic map(
      p_WIDTH => DATUM_WIDTH
   )
   port map(
      i_DIN0  => w_DOUT_MUX_PATTERN_ANTIPATTERN,
      i_DIN1  => i_memory_data_read,
      o_ZERO  => open,
      o_EQUAL => o_equal_patter_mem
   );


   u_COMPAR_OFFSET: entity work.comparador
   generic map(
      p_WIDTH => WIDTH_ADDRESS_MEMORY
   )
   port map(
      i_DIN0  => std_logic_vector(to_unsigned(WORDS_QTD_MEMORY, WIDTH_ADDRESS_MEMORY)),
      i_DIN1  => w_DOUT_ACC_OFFSET,
      o_ZERO  => open,
      o_EQUAL => o_equal_offset_words
   );

   u_MUX_PATTERN_ANTIPATTERN_MEMORY_WR: entity work.mux_2x1
   generic map(
		p_WIDTH  =>  DATUM_WIDTH -- size of datum -- default is 8b (char)
	)
	port map (
		i_DIN0   => W_DOUT_ACC_PATTER,
		i_DIN1 	=> w_DOUT_REG_ANTIPATTER,
		i_SEL    => i_sel_mux_memory,
		o_DOUT   => o_memory_data_write
	);

end rtl;
   