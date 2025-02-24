-------------------------------------------------------------
-- File: memTestDataBus_top.vhd
-- Author: Rebecca Quintino Do O and Felipe Viel
-- File function: compares the input data DIN1 and DIN0, to see if DIN0 is equal to DIN1 or if DIN0 is less than DIN1 or if any data is equal to zero.
-- Created: 17/05/2023
-- Modified: 19/07/2023
-------------------------------------------------------------




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;

entity comparator is
    generic(
        p_WIDTH: natural := 8
    );
    
    port (
        i_DIN0  : in std_logic_vector(p_WIDTH-1 downto 0);
        i_DIN1  : in std_logic_vector(p_WIDTH-1 downto 0);
        o_ZERO  : out std_logic;
        o_EQUAL : out  std_logic;
        o_LESS  : out  std_logic  
    );
end entity comparator;
 
architecture behavioral of comparator is
begin
    P_ZERO: process(i_DIN0, i_DIN1)
    begin -- process P_ZERO
        if AND_REDUCE(i_DIN0) = '0' then
            o_ZERO <= '1';        
        else
            o_ZERO <= '0';       
        end if;   
    end process;

    P_EQUAL: process(i_DIN0, i_DIN1)
    begin -- process P_EQUAL
        if i_DIN0 = i_DIN1 then
            o_EQUAL <= '1';       
        else
            o_EQUAL <= '0';       
        end if; 
    end process;
    
    P_LESS: process(i_DIN0, i_DIN1)
    begin -- process P_LESS
    	if i_DIN0 < i_DIN1 then
            o_LESS <= '1';       
        else
            o_LESS <= '0';       
        end if; 
    end process;
    
end architecture behavioral;
