library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_tb is
end entity register_tb;

architecture behavioral of register_tb is
    -- Constants
    constant p_WIDTH     : natural := 8;       -- Width of the register
    constant p_INIT_DATA : natural := 0;      -- Initial value of the register

    -- Signals
    signal i_CLK    : std_logic := '0';
    signal i_RST    : std_logic := '0';
    signal i_ENABLE : std_logic := '0';
    signal i_DIN    : std_logic_vector(p_WIDTH - 1 downto 0) := (others => '0');
    signal o_DOUT   : std_logic_vector(p_WIDTH - 1 downto 0);

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

    -- Instantiate the Unit Under Test (UUT)
    component reg
        generic (
            p_WIDTH     : natural;
            p_INIT_DATA : natural
        );
        port (
            i_CLK    : in std_logic;
            i_RST    : in std_logic;
            i_ENABLE : in std_logic;
            i_DIN    : in std_logic_vector(p_WIDTH - 1 downto 0);
            o_DOUT   : out std_logic_vector(p_WIDTH - 1 downto 0)
        );
    end component;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: reg
        generic map (
            p_WIDTH     => p_WIDTH,
            p_INIT_DATA => p_INIT_DATA
        )
        port map (
            i_CLK    => i_CLK,
            i_RST    => i_RST,
            i_ENABLE => i_ENABLE,
            i_DIN    => i_DIN,
            o_DOUT   => o_DOUT
        );

    -- Clock generation
    process
    begin
        i_CLK <= '0';
        wait for CLK_PERIOD / 2;
        i_CLK <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Testbench process
    process
    begin
        -- Test case 1: Reset the register
        i_RST <= '1';
        i_ENABLE <= '0';
        i_DIN <= "10101010";
        wait for CLK_PERIOD;
        assert o_DOUT = std_logic_vector(to_unsigned(p_INIT_DATA, p_WIDTH))
            report "Test case 1 failed: Reset not working" severity error;

        -- Test case 2: Disable the register (no change)
        i_RST <= '0';
        i_ENABLE <= '0';
        i_DIN <= "11110000";
        wait for CLK_PERIOD;
        assert o_DOUT = std_logic_vector(to_unsigned(p_INIT_DATA, p_WIDTH))
            report "Test case 2 failed: Register enabled when it should not be" severity error;

        -- Test case 3: Enable the register and write data
        i_ENABLE <= '1';
        i_DIN <= "11110000";
        wait for CLK_PERIOD;
        assert o_DOUT = "11110000"
            report "Test case 3 failed: Data not written to register" severity error;

        -- Test case 4: Disable the register and try to write new data (no change)
        i_ENABLE <= '0';
        i_DIN <= "10101010";
        wait for CLK_PERIOD;
        assert o_DOUT = "11110000"
            report "Test case 4 failed: Register updated when disabled" severity error;

        -- Test case 5: Reset the register again
        i_RST <= '1';
        wait for CLK_PERIOD;
        assert o_DOUT = std_logic_vector(to_unsigned(p_INIT_DATA, p_WIDTH))
            report "Test case 5 failed: Reset not working" severity error;

        -- End of test
        wait;
    end process;
end architecture behavioral;