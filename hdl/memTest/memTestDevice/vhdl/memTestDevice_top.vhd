-------------------------------------------------------------
-- File: memTestDataBus_top.vhd
-- Author: Felipe Viel
-- File function: top entity to union controller and datapath
-- Created: 07/07/2023
-- Modified: 10/01/2025 by Rebecca Quintino Do O
-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity memTestDevice_top is
  generic (
    DATUM_WIDTH          : natural                       := 8  -- size of datum -- default is 8b (char)
  );

  port (
    -- BASIC INPUTS
    i_clk                   : in  std_logic;
    i_rst_n_async           : in  std_logic;
    
    -- INPUT DATA ---------------------------------------------------
    i_start                 : in  std_logic;
    i_address               : in  std_logic_vector (DATUM_WIDTH-1 downto 0);
    i_memory_data_read      : in  std_logic_vector (DATUM_WIDTH-1 downto 0);
    i_memory_write_ready    : in  std_logic; 
    i_memory_read_valid     : in  std_logic; 
    
    -- OUTPUT ---------------------------------------------------
    o_end                   : out std_logic;
    -- flag to indicate error: 1 to error and 0 to ok
    o_error                 : out std_logic;
    -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    o_memory_data_write     : out  std_logic_vector (DATUM_WIDTH-1 downto 0)
  );
end entity memTestDevice_top;

architecture structural of memTestDevice_top is
  signal r_RST_REGS                  : std_logic;
  signal r_ENA_REG_PATTERN           : std_logic;
  signal r_ENA_REG_ANTIPATTERN       : std_logic;
  signal r_ENA_REG_BASE_ADDR         : std_logic;
  signal r_ENA_REG_OFFSET            : std_logic;
  signal r_SEL_MUX_MEMORY_DATA_READ  : std_logic;
  signal r_SEL_MUX_MEMORY_DATA_WRITE : std_logic;
  signal r_EQUAL_MEMORY_PATTERN      : std_logic;
  signal r_LESS_OFFSET_NWORDS        : std_logic;
begin

   u_CONTROLLER: entity work.memTestDevice_controller
   generic map(
     DATUM_WIDTH           => DATUM_WIDTH
   )
   port map (
     -- BASIC INPUTS
    i_clk                       => i_clk,
    i_rst_n_async               => i_rst_n_async,
    
    -- INPUT DATA ---------------------------------------------------
    i_start                     => i_start,
    -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_write_ready        => i_memory_write_ready,
    -- to get when read data is ok maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_read_valid         => i_memory_read_valid, 
    -- return if PATTERN OR ANTIPATTERN is equal to data from memory
    i_equal_memory_pattern      => r_EQUAL_MEMORY_PATTERN,
    -- return if OFFSET is less to number of words in memory
    i_less_offset_nwords        => r_LESS_OFFSET_NWORDS,
     
    -- OUTPUT ---------------------------------------------------
    -- rst REGISTERS async
    o_rst_reg                   => r_RST_REGS,
    -- flag to indicate error: 1 to error and 0 to ok
    o_error                     => o_error,
    -- indicate end of configuration
    o_end                       => o_end,
    -- enable or not write in REG_BASE_ADDR
    o_ena_reg_base_addr         => r_ENA_REG_BASE_ADDR,
    -- enable or not write in REG_PATTERN
    o_ena_reg_pattern           => r_ENA_REG_PATTERN,
    -- enable or not write in REG_ANTIPATTERN
    o_ena_reg_antipattern       => r_ENA_REG_ANTIPATTERN,
    -- enable or not write in REG_OFFSET
    o_ena_reg_offset            => r_ENA_REG_OFFSET,
    -- select PATTERN or ANTIPATTERN data to compare with memory read data
    o_sel_mux_memory_data_read  => r_SEL_MUX_MEMORY_DATA_READ,
    -- select PATTERN or ANTIPATTERN data to store in memory
    o_sel_mux_memory_data_write => r_SEL_MUX_MEMORY_DATA_WRITE
   );

   u_DATAPATH: entity work.memTestDevice_datapath
   generic map (
     DATUM_WIDTH  => DATUM_WIDTH
   )
   port map (
   
    -- BASIC INPUTS
     i_clk                   => i_clk,
     i_rst_n_async           => i_rst_n_async,
    
    -- INPUT DATA ---------------------------------------------------
    -- to get when read data is ok maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    i_memory_data_read            => i_memory_data_read,
    -- enable or not write in REG_PATTERN  inside ACC
    i_ena_reg_pattern             => r_ENA_REG_PATTERN,
    -- enable or not write in REG_ANTIPATTERN inside ACC
    i_ena_reg_antipattern         => r_ENA_REG_ANTIPATTERN,
    -- enable or not write in REG_OFFSET
    i_ena_reg_offset              => r_ENA_REG_OFFSET,
    -- rst REGISTERS
     i_rst_reg                    => r_RST_REGS,
    -- sel to input PATTERN or ANTIPATTERN to compare with data from memory
    i_sel_mux_memory_data_read    => r_SEL_MUX_MEMORY_DATA_READ,
    -- sel to store PATTERN or ANTIPATTERN in memory
    i_sel_mux_memory_data_write   => r_SEL_MUX_MEMORY_DATA_WRITE,
    
    -- OUTPUT ---------------------------------------------------
    -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
    -- it is compatible with the use of I2C ou SPI IP
    o_memory_data_write           => o_memory_data_write,
    -- if address != pattern then == 0 else 1
    o_equal_memory_pattern        => r_EQUAL_MEMORY_PATTERN, 
    -- if offset is less than words == 1 else 0
    o_less_offset_nwords          => r_LESS_OFFSET_NWORDS
     
   );

   
end structural;