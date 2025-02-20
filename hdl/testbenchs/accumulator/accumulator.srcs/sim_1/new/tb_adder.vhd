library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_adder is
end entity tb_adder;

architecture test of tb_adder is

  -- Signals for Testbench
  signal din0     : std_logic_vector(7 downto 0) := "00000000";
  signal din1     : std_logic_vector(7 downto 0) := "00000000";
  signal dout     : std_logic_vector(7 downto 0);
  signal overflow : std_logic;

  -- Constant for the width of the adder
  constant p_WIDTH     : natural := 8;
  constant p_INCREMENT : natural := 1;

begin

  -- DUT (Device Under Test) Instantiation
  uut: entity work.adder
    generic map (
      p_WIDTH => p_WIDTH
    )
    port map (
      i_DIN0     => din0,
      i_DIN1     => din1,
      o_DOUT     => dout,
      o_OVERFLOW => overflow
    );

  -- Stimulus Process
  stimulus_process: process
  begin
    -- Test 1: Add 0 + 0
    din0 <= "00000000";
    din1 <= "00000000";
    wait for 10 ns;

    -- Test 2: Add 5 + 1
    din0 <= std_logic_vector(to_unsigned(5, p_WIDTH));
    din1 <= std_logic_vector(to_unsigned(p_INCREMENT, p_WIDTH));
    wait for 10 ns;

    -- Test 3: Add 127 + 1 (overflow expected)
    din0 <= std_logic_vector(to_unsigned(127, p_WIDTH));
    din1 <= std_logic_vector(to_unsigned(p_INCREMENT, p_WIDTH));
    wait for 10 ns;

    -- Test 4: Add 200 + 1 (overflow expected)
    din0 <= std_logic_vector(to_unsigned(200, p_WIDTH));
    din1 <= std_logic_vector(to_unsigned(p_INCREMENT, p_WIDTH));
    wait for 10 ns;

    -- Test 5: Add 10 + 1 (no overflow)
    din0 <= std_logic_vector(to_unsigned(255, p_WIDTH));
    din1 <= std_logic_vector(to_unsigned(p_INCREMENT, p_WIDTH));
    wait for 10 ns;

    -- Finish simulation
    wait;
  end process;

end architecture test;
