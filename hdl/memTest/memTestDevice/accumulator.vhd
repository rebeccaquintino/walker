-------------------------------------------------------------
-- File: accumulator.vhd
-- Author: Felipe Viel
-- File function: adder and registes in format of accumulator
-- Created: 31/08/2023
-- Modified: 31/08/2023
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity accumulator is
   generic (
      p_WIDTH     : natural := 8;
      p_INCREMENT : natural := 1;
      p_INIT_DATA : natural := 0
    );
    port (
      i_CLK          : in std_logic;
      i_RST          : in std_logic;
      i_RST_CONTROL  : in std_logic;
      i_ENABLE       : in std_logic;
      o_DOUT         : out std_logic_vector(p_WIDTH - 1 downto 0)
    );

end entity accumulator;

architecture rtl of reg is
   signal reg : std_logic_vector(p_WIDTH - 1 downto 0);
   signal w_RST_REGS          : std_logic;
   signal w_DOUT_REG_PATTERN  : std_logic_vector (DATUM_WIDTH-1 downto 0);

 begin

   w_RST_REGS <= i_RST OR i_RST_CONTROL;
   
   u_REG: entity work.reg
    generic map(
     p_WIDTH     => p_WIDTH,
     p_INIT_DATA => p_INIT_DATA 
    )
    port map (
       i_CLK    => i_CLK,
       i_RST    => w_RST_REGS,
       i_ENABLE => i_ENABLE,
       i_DIN    => w_OUT_ADDER,
       o_DOUT   => w_DOUT_REG
    );
 
    u_ADDER: entity work.adder
    generic map(
     p_WIDTH     => p_WIDTH
    )
    port map (
      i_DIN0     => w_DOUT_REG,
      i_DIN1     => std_logic_vector(to_unsigned(p_INIT_DATA, p_WIDTH)),
      o_DOUT     => w_OUT_ADDER,
      o_OVERFLOW => open
    );
 
    o_DOUT <= w_DOUT_REG;
   
 end architecture rtl;
 
   