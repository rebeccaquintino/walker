-------------------------------------------------------------
-- File: mux_2x1.vhd
-- Author: Felipe Viel
-- File function: multiplexer 2x1
-- Created: 07/07/2023
-- Modified: 19/07/2023
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux_2x1 is
	generic(
		p_WIDTH  : natural := 8  -- size of datum -- default is 8b (char)
	);
	port (
		i_DIN0   : in std_logic_vector(p_WIDTH-1 downto 0);
		i_DIN1 	: in std_logic_vector(p_WIDTH-1 downto 0);
		i_SEL    : in std_logic;
		o_DOUT   : out std_logic_vector(p_WIDTH-1 downto 0)
	);
end mux_2x1;

architecture behavioral of mux_2x1 is

begin
	
	o_DOUT <= i_DIN0 when i_sel = '0' else i_DIN1;

end behavioral;