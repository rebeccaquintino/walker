-------------------------------------------------------------
-- File: memTestDataBus_top.vhd
-- Author: Rebecca Quintino Do Ó and Felipe Viel
-- File function: shifter dadat to left or right and identify zero values after shift
-- Created: 17/05/2023
-- Modified: 19/07/2023
-------------------------------------------------------------




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;

entity comparador is
    generic(
        p_WIDTH: natural := 8
    );
    
    port (
        i_DIN0  : in std_logic_vector(p_WIDTH-1 downto 0);
        i_DIN1  : in std_logic_vector(p_WIDTH-1 downto 0);
        o_ZERO  : out std_logic;
        o_EQUAL : out  std_logic 
    );
end entity comparador;
 

architecture behavioral of comparador is
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
    
end architecture behavioral;
