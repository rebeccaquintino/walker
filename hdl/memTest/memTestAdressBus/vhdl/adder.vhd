------------------------------------------------------------
-- File: reg.vhd
-- Author: Felipe Viel
-- File function: parameterizable full-adder 
-- Created: 08/08/2023
-- Modified: 09/08/2023
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  
use ieee.std_logic_signed.all;

entity adder is
  generic (
    p_WIDTH     : natural := 8
  );
  port (
    i_DIN0     : in std_logic_vector(p_WIDTH - 1 downto 0);
    i_DIN1     : in std_logic_vector(p_WIDTH - 1 downto 0);
    o_DOUT     : out std_logic_vector(p_WIDTH - 1 downto 0);
    o_OVERFLOW : out std_logic
  );
end entity adder;

architecture behavioral of adder is
   signal w_RESULT : std_logic_vector(p_WIDTH downto 0);
begin

   w_RESULT <=  i_DIN0 + i_DIN1;
   o_DOUT <= w_RESULT(p_WIDTH-1 downto 0);
   o_OVERFLOW <= w_RESULT(p_WIDTH);
  
end architecture behavioral;
