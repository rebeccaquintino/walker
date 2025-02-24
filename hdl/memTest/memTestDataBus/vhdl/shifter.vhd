-------------------------------------------------------------
-- File: shifter.vhd
-- Author: Rebecca Quintino Do Ó and Felipe Viel
-- File function: shifter data to left or right and identify zero values after shift
-- Created: 09/06/2023
-- Modified: 19/07/2023
-------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- Needed for shifts
use ieee.std_logic_misc.all;

entity shifter is
    generic(
      p_WIDTH_DATA      : natural     := 8;
      p_NUMBER_SHIFTER  : natural     := 3 -- number of bits to shifter number of data bits
    );
    port ( 
      i_value                     : in  std_logic_vector(p_WIDTH_DATA-1 downto 0);
      i_RL                        : in  std_logic ;                             -- 0 for Right or 1 for left
      i_shifter                   : in  std_logic_vector(p_NUMBER_SHIFTER-1 downto 0);           -- Here need to be configured in the file by generic parameter
      o_value                     : out std_logic_vector(p_WIDTH_DATA-1 downto 0);
      o_zero                      : out std_logic 
    );
end shifter;
 
architecture behavioral of shifter is
  signal r_value      : std_logic_vector(p_WIDTH_DATA-1 downto 0);
  signal r_Unsigned_L : unsigned(p_WIDTH_DATA-1 downto 0) ;
  signal r_Unsigned_R : unsigned(p_WIDTH_DATA-1 downto 0);
   
begin
    
    
    -- Left Shift
    r_Unsigned_L <= shift_left(unsigned(i_value), to_integer(unsigned(i_shifter))); 
    -- Right Shift
    r_Unsigned_R <= shift_right(unsigned(i_value), to_integer(unsigned(i_shifter)));

    r_value <= std_logic_vector(r_Unsigned_R) when i_RL = '0' else
                std_logic_vector(r_Unsigned_L); 
    o_value <= r_value;                             
    
    -- if only one bit is 1, OR_REDUCE results 1, else, all bits is 0, OR_REDUCE results 0
    o_zero <= '1' when OR_REDUCE(r_value) = '0' else '0';
     

end architecture behavioral;

