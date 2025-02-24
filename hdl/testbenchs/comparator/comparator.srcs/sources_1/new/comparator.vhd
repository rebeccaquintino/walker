-------------------------------------------------------------
-- File: comparator.vhd
-- Author: Rebecca Quintino Do O and Felipe Viel
-- File function: compares the input data DIN1 and DIN0, to see if DIN0 is equal to DIN1 or if DIN0 is less than DIN1 or if any data is equal to zero.
-- Created: 17/05/2023
-- Modified: 24/02/2025
-------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;

-- Entity declaration for the comparator
entity comparator is
    generic(
        p_WIDTH: natural := 8  -- Defines the bit width of the input vectors
    );
    
    port (
        i_DIN0  : in std_logic_vector(p_WIDTH-1 downto 0); -- First input vector
        i_DIN1  : in std_logic_vector(p_WIDTH-1 downto 0); -- Second input vector
        o_ZERO  : out std_logic; -- Output signal that indicates if any input is zero
        o_EQUAL : out std_logic; -- Output signal that indicates if i_DIN0 == i_DIN1
        o_LESS  : out std_logic  -- Output signal that indicates if i_DIN0 < i_DIN1
    );
end entity comparator;
 
-- Architecture defining the behavior of the comparator
architecture behavioral of comparator is
begin
    -- Process to check if i_DIN0 is zero
    P_ZERO: process(i_DIN0, i_DIN1)
    begin
        -- If all bits of i_DIN0 are '0', set o_ZERO to '1'.
        -- Otherwise, set o_ZERO to '0'.
        if OR_REDUCE(i_DIN0) = '0' then  
            o_ZERO <= '1';        
        else
            o_ZERO <= '0';       
        end if;   
    end process;

    -- Process to check if both input vectors are equal
    P_EQUAL: process(i_DIN0, i_DIN1)
    begin
        -- If i_DIN0 is equal to i_DIN1, set o_EQUAL to '1'.
        -- Otherwise, set o_EQUAL to '0'.
        if i_DIN0 = i_DIN1 then
            o_EQUAL <= '1';       
        else
            o_EQUAL <= '0';       
        end if; 
    end process;
    
    -- Process to check if i_DIN0 is less than i_DIN1
    P_LESS: process(i_DIN0, i_DIN1)
    begin
        -- If i_DIN0 is less than i_DIN1, set o_LESS to '1'.
        -- Otherwise, set o_LESS to '0'.
        if i_DIN0 < i_DIN1 then
            o_LESS <= '1';       
        else
            o_LESS <= '0';       
        end if; 
    end process;
    
end architecture behavioral;

