-------------------------------------------------------------
-- File: reg.vhd
-- Author: Rebecca Quintino Do O
-- File function: parameterizable register
-- Created: 09/06/2023
-- Modified: 11/10/2024 by Rebecca Quintino Do O
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  

entity reg is
  generic (
    p_WIDTH     : natural := 8;
    p_INIT_DATA : natural := 0
  );
  port (
    i_CLK    : in std_logic;
    i_RST    : in std_logic;
    i_ENABLE : in std_logic;
    i_DIN    : in std_logic_vector(p_WIDTH - 1 downto 0);
    o_DOUT   : out std_logic_vector(p_WIDTH - 1 downto 0)
  );
end entity reg;

architecture behavioral of reg is
  signal w_DOUT_REG : std_logic_vector(p_WIDTH - 1 downto 0);

begin

  process (i_CLK, i_RST)
  begin
    if i_RST = '1' then
      w_DOUT_REG <= std_logic_vector(to_unsigned(p_INIT_DATA, p_WIDTH));
    elsif rising_edge(i_CLK) then
      if i_ENABLE = '1' then
        w_DOUT_REG <= i_DIN;
      end if;
    end if;
  end process;

  o_DOUT <= w_DOUT_REG;
  
end behavioral;
