-------------------------------------------------------------
-- File: memTestDataBus_top.vhd
-- Author: Rebecca Quintino Do Ó
-- File function: top entity to union controller and datapath
-- Created: 07/07/2023
-- Modified: 07/03/2025
-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity memTestDataBus_top is
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
end entity memTestDataBus_top;

architecture rtl of memTestDataBus_top is
   signal W_RST_REGS                : std_logic;
   signal W_ENA_REG_PATTERN         : std_logic;
   signal W_ENA_REG_ADDRESS         : std_logic;
   signal W_EQUAL_ZERO_PATTERN      : std_logic;
   signal W_EQUAL_ADDRESS_PATTERN   : std_logic;
   signal W_SEL_MUX_PATTERN_MEMORY  : std_logic;
   signal W_ZERO_SHIFTER            : std_logic;
   signal W_RL_SHIFTER              : std_logic;
begin

   u_CONTROLLER: entity work.memTestDataBus_controller
   generic map(
     DATUM_WIDTH              => DATUM_WIDTH
   )
   port map (
     -- BASIC INPUTS
     i_clk                    => i_clk,
     i_rst_n_async            => i_rst_n_async,
     
     -- INPUT DATA ---------------------------------------------------
     i_start                  => i_start,
     -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
     -- it is compatible with the use of I2C ou SPI IP
     i_memory_write_ready     => i_memory_write_ready,
     -- to get when read data is ok maybe be a counter of cycles if memory don't have singnal of ready
     -- it is compatible with the use of I2C ou SPI IP
     i_memory_read_valid      => i_memory_read_valid,
     -- if address != 0 pattern then i_compare_address == 1 else 0
     i_equal_address_pattern  => W_EQUAL_ADDRESS_PATTERN,
     -- if pattern is 0 then i_pattern_zero == 1 else 0
     i_equal_pattern_zero     => W_EQUAL_ZERO_PATTERN,
     -- OUTPUT ---------------------------------------------------
     -- enable or not write in REG_PATTERN
     o_ena_reg_pattern        => W_ENA_REG_PATTERN,
     -- enable or not write in REG_ADDRESS
     o_ena_reg_address        => W_ENA_REG_ADDRESS,
     -- rst REGISTERS
     o_rst_reg                => W_RST_REGS,
     -- 0 for Right or 1 for left
     o_RL_shifter             => W_RL_SHIFTER,
     -- select PATTERN or MEMORY data to store in REG_ADDRESS
     o_sel_mux_pattern_memory => W_SEL_MUX_PATTERN_MEMORY,
     -- flag to indicate error: 1 to error and 0 to ok
     o_error                  => o_error,
     -- indicate end of configuration
     o_end                    => o_end
   );

   u_DATAPATH: entity work.memTestDataBus_datapath
   generic map (
     DATUM_WIDTH  => DATUM_WIDTH
   )
   port map (
     -- BASIC INPUTS
     i_clk                    => i_clk,
     i_rst_n_async            => i_rst_n_async,
     
     i_memory_data_read       => i_memory_data_read,
     -- enable or not write in REG_PATTERN
     i_ena_reg_pattern        => W_ENA_REG_PATTERN,
     -- enable or not write in REG_ADDRESS
     i_ena_reg_address        => W_ENA_REG_ADDRESS,
     -- rst REGISTERS
     i_rst_reg                => W_RST_REGS,
     -- Define the direction of shifter: 0 for Right or 1 for left
     i_RL_shifter             => W_RL_SHIFTER,
     -- sel to store PATTERN or MEMORY in REG_ADDRESS
     i_sel_mux_pattern_memory => W_SEL_MUX_PATTERN_MEMORY,
     
     -- OUTPUT ---------------------------------------------------
     -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
     -- it is compatible with the use of I2C ou SPI IP
     o_memory_data_write      => o_memory_data_write,
     -- if address != 0 pattern then i_compare_address == 1 else 0
     o_equal_address_pattern  => W_EQUAL_ADDRESS_PATTERN,
     -- if pattern is 0 then i_pattern_zero == 1 else 0
     o_equal_zero_pattern     => W_EQUAL_ZERO_PATTERN,
     -- if only one bit is 1, OR_REDUCE results 1, else, all bits is 0, OR_REDUCE results 0
     o_zero                   => W_ZERO_SHIFTER
     
   );

   
end rtl;