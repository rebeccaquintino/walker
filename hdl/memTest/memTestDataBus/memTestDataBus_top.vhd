-------------------------------------------------------------
-- File: memTestDataBus_top.vhd
-- Author: Felipe Viel
-- File function: top entity to union controller and datapath
-- Created: 07/07/2023
-- Modified: 19/07/2023
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
   signal r_RST_REGS                : std_logic;
   signal r_ENA_REG_PATTERN         : std_logic;
   signal r_ENA_REG_ADDRESS         : std_logic;
   signal r_PATTERN_ZERO            : std_logic;
   signal r_COMPAR_PATTERN_ADDRESS  : std_logic;
   signal r_MUX_SEL           : std_logic;
begin

   u_CONTROLLER: entity work.memTestDataBus_controller
   generic map(
     DATUM_WIDTH           => DATUM_WIDTH
   )
   port map (
     -- BASIC INPUTS
     i_clk                   => i_clk,
     i_rst_n_async           => i_rst_n_async,
     
     -- INPUT DATA ---------------------------------------------------
     i_start                 => i_start,
     i_address               => i_address,
     -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
     -- it is compatible with the use of I2C ou SPI IP
     i_memory_write_ready    => i_memory_write_ready,
     -- to get when read data is ok maybe be a counter of cycles if memory don't have singnal of ready
     -- it is compatible with the use of I2C ou SPI IP
     i_memory_read_valid     => i_memory_read_valid,
     -- if address != 0 pattern then i_compare_address == 1 else 0
     i_compare_address       => r_COMPAR_PATTERN_ADDRESS,
     -- if pattern is 0 then i_pattern_zero == 1 else 0
     i_pattern_zero          => r_PATTERN_ZERO,
     -- OUTPUT ---------------------------------------------------
     -- enable or not write in REG_PATTERN
     o_ena_reg_pattern       => r_ENA_REG_PATTERN,
     -- enable or not write in REG_ADDRESS
     o_ena_reg_address       => r_ENA_REG_ADDRESS,
     -- rst REGISTERS
     o_rst_reg               => r_RST_REGS,
     -- select PATTERN or MEMORY data to store in REG_ADDRESS
     o_sel_reg_address       => r_MUX_SEL,
     -- flag to indicate error: 1 to error and 0 to ok
     o_error                 => o_error,
     -- indicate end of configuration
     o_end                   => o_end
   );

   u_DATAPATH: entity work.memTestDataBus_datapath
   generic map (
     DATUM_WIDTH  => DATUM_WIDTH
   )
   port map (
     -- BASIC INPUTS
     i_clk                   => i_clk,
     i_rst_n_async           => i_rst_n_async,
     
     i_memory_data_read      => i_memory_data_read,
     -- enable or not write in REG_PATTERN
     i_ena_reg_pattern       => r_ENA_REG_PATTERN,
     -- enable or not write in REG_ADDRESS
     i_ena_reg_address       => r_ENA_REG_ADDRESS,
     -- rst REGISTERS
     i_rst_reg               => r_RST_REGS,
     -- sel to store PATTERN or MEMORY in REG_ADDRESS
     i_sel_mux               => r_MUX_SEL,
     
     -- OUTPUT ---------------------------------------------------
     -- to get when write data is stored - maybe be a counter of cycles if memory don't have singnal of ready
     -- it is compatible with the use of I2C ou SPI IP
     o_memory_data_write     => o_memory_data_write,
     -- if address != 0 pattern then i_compare_address == 1 else 0
     o_compare_address       => r_COMPAR_PATTERN_ADDRESS,
     -- if pattern is 0 then i_pattern_zero == 1 else 0
     o_pattern_zero          => r_PATTERN_ZERO
     
   );

   
end rtl;