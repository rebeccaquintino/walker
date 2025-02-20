-------------------------------------------------------------
-- File: memTestDataBus_top.vhd
-- Author: Rebecca Quintino Do Ó and Felipe Viel
-- File function: shifter dadat to left or right and identify zero values after shift
-- Created: 09/06/2023
-- Modified: 19/07/2023
-------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- Needed for shifts
use ieee.std_logic_misc.all;

entity shifter is
    generic(
      p_WIDTH_DATA     : natural     := 8;
      p_NUMBER_SHIFTER : natural     := 3 -- number of bits to shifter number of data bits
    );
    port ( 
      i_DIN            : in  std_logic_vector(p_WIDTH_DATA-1 downto 0);
      i_RL             : in  std_logic ;                             -- 0 for Right or 1 for left
      i_SHIFTER        : in  std_logic_vector(p_NUMBER_SHIFTER-1 downto 0);           -- Here need to be configured in the file by generic parameter
      o_DOUT           : out std_logic_vector(p_WIDTH_DATA-1 downto 0);
      o_ZERO           : out std_logic 
    );
end shifter;
 
architecture behavioral of shifter is
  signal r_DOUT        : std_logic_vector(p_WIDTH_DATA-1 downto 0);
  signal r_UNSIGNED_L  : unsigned(p_WIDTH_DATA-1 downto 0) ;
  signal r_UNSIGNED_R  : unsigned(p_WIDTH_DATA-1 downto 0);
   
begin

    -- Left Shift
    r_UNSIGNED_L <= shift_left(unsigned(i_DIN), to_integer(unsigned(i_SHIFTER))); 
    -- Right Shift
    r_UNSIGNED_R <= shift_right(unsigned(i_DIN), to_integer(unsigned(i_SHIFTER)));

    r_DOUT       <= std_logic_vector(r_UNSIGNED_R) when i_RL = '0' else
                    std_logic_vector(r_UNSIGNED_L); 
    o_DOUT       <= r_DOUT;                             
    
    -- if only one bit is 1, OR_REDUCE results 1, else, all bits is 0, OR_REDUCE results 0
    o_ZERO       <= '1' when OR_REDUCE(r_DOUT) = '0' else '0';
     

end architecture behavioral;

