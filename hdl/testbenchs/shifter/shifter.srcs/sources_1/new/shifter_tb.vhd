library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter_tb is
end shifter_tb;

architecture behavioral of shifter_tb is
    -- Constants
    constant p_WIDTH_DATA     : natural := 8;
    constant p_NUMBER_SHIFTER : natural := 3;

    -- Signals
    signal i_value    : std_logic_vector(p_WIDTH_DATA-1 downto 0);
    signal i_RL       : std_logic;
    signal i_shifter  : std_logic_vector(p_NUMBER_SHIFTER-1 downto 0);
    signal o_value    : std_logic_vector(p_WIDTH_DATA-1 downto 0);
    signal o_zero     : std_logic;

    -- Instantiate the Unit Under Test (UUT)
    component shifter
        generic(
            p_WIDTH_DATA      : natural;
            p_NUMBER_SHIFTER  : natural
        );
        port(
            i_value    : in  std_logic_vector(p_WIDTH_DATA-1 downto 0);
            i_RL       : in  std_logic;
            i_shifter  : in  std_logic_vector(p_NUMBER_SHIFTER-1 downto 0);
            o_value    : out std_logic_vector(p_WIDTH_DATA-1 downto 0);
            o_zero     : out std_logic
        );
    end component;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: shifter
        generic map(
            p_WIDTH_DATA      => p_WIDTH_DATA,
            p_NUMBER_SHIFTER  => p_NUMBER_SHIFTER
        )
        port map(
            i_value    => i_value,
            i_RL       => i_RL,
            i_shifter  => i_shifter,
            o_value    => o_value,
            o_zero     => o_zero
        );

    -- Testbench process
    process
    begin

        -- Test case 1: Shift left by 3 bits
        i_value   <= "00000001";
        i_RL      <= '1';
        i_shifter <= "001"; -- Shift left by 3 bits
        wait for 10 ns;
        assert o_value = "00000010" and o_zero = '0'
            report "Test case 1 failed" severity error;

        -- Test case 2: Shift left by 0 bits (no shift)
        i_value   <= "00000010";
        i_RL      <= '1';
        i_shifter <= "001"; -- Shift left by 0 bits
        wait for 10 ns;
        assert o_value = "00000100" and o_zero = '0'
            report "Test case 2 failed" severity error;

        -- Test case 3: Shift left by 0 bits (no shift)
        i_value   <= "00000100";
        i_RL      <= '1';
        i_shifter <= "001"; -- Shift left by 0 bits
        wait for 10 ns;
        assert o_value = "00001000" and o_zero = '0'
            report "Test case 3 failed" severity error;
        -- End of test
        wait;
    end process;
end behavioral;