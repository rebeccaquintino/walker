library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comparator_tb is
end comparator_tb;

architecture behavioral of comparator_tb is
    -- Constants
    constant p_WIDTH : natural := 8;

    -- Signals
    signal i_DIN0  : std_logic_vector(p_WIDTH-1 downto 0);
    signal i_DIN1  : std_logic_vector(p_WIDTH-1 downto 0);
    signal o_ZERO  : std_logic;
    signal o_EQUAL : std_logic;
    signal o_LESS  : std_logic;

    -- Instantiate the Unit Under Test (UUT)
    component comparator
        generic(
            p_WIDTH : natural
        );
        port(
            i_DIN0  : in  std_logic_vector(p_WIDTH-1 downto 0);
            i_DIN1  : in  std_logic_vector(p_WIDTH-1 downto 0);
            o_ZERO  : out std_logic;
            o_EQUAL : out std_logic;
            o_LESS  : out std_logic
        );
    end component;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: comparator
        generic map(
            p_WIDTH => p_WIDTH
        )
        port map(
            i_DIN0  => i_DIN0,
            i_DIN1  => i_DIN1,
            o_ZERO  => o_ZERO,
            o_EQUAL => o_EQUAL,
            o_LESS  => o_LESS
        );

    -- Testbench process
    process
    begin
        -- Test case 1: Both inputs are zero
        i_DIN0 <= "00000000";
        i_DIN1 <= "00000000";
        wait for 10 ns;
        assert o_ZERO = '1' and o_EQUAL = '1' and o_LESS = '0'
            report "Test case 1 failed" severity error;

        -- Test case 2: i_DIN0 is less than i_DIN1
        i_DIN0 <= "00000001";
        i_DIN1 <= "00000010";
        wait for 10 ns;
        assert o_ZERO = '0' and o_EQUAL = '0' and o_LESS = '1'
            report "Test case 2 failed" severity error;

        -- Test case 3: i_DIN0 is equal to i_DIN1
        i_DIN0 <= "10101010";
        i_DIN1 <= "10101010";
        wait for 10 ns;
        assert o_ZERO = '0' and o_EQUAL = '1' and o_LESS = '0'
            report "Test case 3 failed" severity error;

        -- Test case 4: i_DIN0 is greater than i_DIN1
        i_DIN0 <= "11111111";
        i_DIN1 <= "00000001";
        wait for 10 ns;
        assert o_ZERO = '0' and o_EQUAL = '0' and o_LESS = '0'
            report "Test case 4 failed" severity error;

        -- Test case 5: i_DIN0 is zero, i_DIN1 is non-zero
        i_DIN0 <= "00000000";
        i_DIN1 <= "00001111";
        wait for 10 ns;
        assert o_ZERO = '1' and o_EQUAL = '0' and o_LESS = '1'
            report "Test case 5 failed" severity error;

        -- Test case 6: i_DIN1 is zero, i_DIN0 is non-zero
        i_DIN0 <= "00001111";
        i_DIN1 <= "00000000";
        wait for 10 ns;
        assert o_ZERO = '0' and o_EQUAL = '0' and o_LESS = '0'
            report "Test case 6 failed" severity error;

        -- End of test
        wait;
    end process;
end behavioral;