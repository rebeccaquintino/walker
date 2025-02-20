library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_accumulator is
end entity tb_accumulator;

architecture behavioral of tb_accumulator is

  -- Component Declaration
  component accumulator is
    generic (
      p_WIDTH     : natural := 8;
      p_INCREMENT : natural := 1;
      p_INIT_DATA : natural := 0
    );
    port (
      i_CLK          : in std_logic;
      i_RST          : in std_logic;
      i_RST_CONTROL  : in std_logic;
      i_ENABLE       : in std_logic;
      o_DOUT         : out std_logic_vector(p_WIDTH - 1 downto 0)
    );
  end component;

  -- Signals for Testbench
  signal clk          : std_logic := '0';
  signal rst          : std_logic := '0';
  signal rst_control  : std_logic := '0';
  signal enable       : std_logic := '0';
  signal dout         : std_logic_vector(7 downto 0);

  constant CLK_PERIOD : time := 10 ns;

begin

  -- DUT (Device Under Test) Instantiation
  uut: accumulator
    generic map (
      p_WIDTH     => 8,
      p_INCREMENT => 1,
      p_INIT_DATA => 0
    )
    port map (
      i_CLK          => clk,
      i_RST          => rst,
      i_RST_CONTROL  => rst_control,
      i_ENABLE       => enable,
      o_DOUT         => dout
    );

  -- Clock Process
  clk_process: process
  begin
    while true loop
      clk <= '0';
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
  end process;

  -- Test Process
stimulus_process: process
begin
  -- Reset the accumulator
  rst <= '1';
  report "Reset active" severity note;
  wait for CLK_PERIOD;
  rst <= '0';
  report "Reset released" severity note;
  wait for CLK_PERIOD;

  -- Apply enable and observe output
  enable <= '1';
  report "Enable active, incrementing..." severity note;
  wait for 5 * CLK_PERIOD;
  enable <= '0';
  report "Enable deactivated" severity note;
  wait for CLK_PERIOD;

  -- Reset the accumulator using control reset
  rst_control <= '1';
  report "Control reset active" severity note;
  wait for CLK_PERIOD;
  rst_control <= '0';
  report "Control reset released" severity note;
  wait for CLK_PERIOD;

  -- Increment again
  enable <= '1';
  report "Enable active again, incrementing..." severity note;
  wait for 5 * CLK_PERIOD;
  enable <= '0';
  report "Test completed" severity note;
  
  -- Reset the accumulator
  rst <= '1';
  report "Reset active" severity note;
  wait for CLK_PERIOD;
  rst <= '0';
  report "Reset released" severity note;
  wait for CLK_PERIOD;

  -- Apply enable and observe output
  enable <= '1';
  report "Enable active, incrementing..." severity note;
  wait for 5 * CLK_PERIOD;
  enable <= '0';
  report "Enable deactivated" severity note;
  wait for CLK_PERIOD;

  -- Reset the accumulator using control reset
  rst_control <= '1';
  report "Control reset active" severity note;
  wait for CLK_PERIOD;
  rst_control <= '0';
  report "Control reset released" severity note;
  wait for CLK_PERIOD;

  -- Increment again
  enable <= '1';
  report "Enable active again, incrementing..." severity note;
  wait for 5 * CLK_PERIOD;
  enable <= '0';
  report "Test completed" severity note;
  
  -- Reset the accumulator
  rst <= '1';
  report "Reset active" severity note;
  wait for CLK_PERIOD;
  rst <= '0';
  report "Reset released" severity note;
  wait for CLK_PERIOD;

  -- Apply enable and observe output
  enable <= '1';
  report "Enable active, incrementing..." severity note;
  wait for 5 * CLK_PERIOD;
  enable <= '0';
  report "Enable deactivated" severity note;
  wait for CLK_PERIOD;

  -- Reset the accumulator using control reset
  rst_control <= '1';
  report "Control reset active" severity note;
  wait for CLK_PERIOD;
  rst_control <= '0';
  report "Control reset released" severity note;
  wait for CLK_PERIOD;

  -- Increment again
  enable <= '1';
  report "Enable active again, incrementing..." severity note;
  wait for 5 * CLK_PERIOD;
  enable <= '0';
  report "Test completed" severity note;
  
  -- Reset the accumulator
  rst <= '1';
  report "Reset active" severity note;
  wait for CLK_PERIOD;
  rst <= '0';
  report "Reset released" severity note;
  wait for CLK_PERIOD;

  -- Apply enable and observe output
  enable <= '1';
  report "Enable active, incrementing..." severity note;
  wait for 5 * CLK_PERIOD;
  enable <= '0';
  report "Enable deactivated" severity note;
  wait for CLK_PERIOD;

  -- Reset the accumulator using control reset
  rst_control <= '1';
  report "Control reset active" severity note;
  wait for CLK_PERIOD;
  rst_control <= '0';
  report "Control reset released" severity note;
  wait for CLK_PERIOD;

  -- Increment again
  enable <= '1';
  report "Enable active again, incrementing..." severity note;
  wait for 5 * CLK_PERIOD;
  enable <= '0';
  report "Test completed" severity note;

  -- Finish simulation
  wait;
end process;


end behavioral;
