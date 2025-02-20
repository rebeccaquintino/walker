library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_reg is
end entity tb_reg;

architecture behavioral of tb_reg is
  -- Sinais para o Testbench
  signal clk     : std_logic := '0';
  signal rst     : std_logic := '0';
  signal enable  : std_logic := '0';
  signal din     : std_logic_vector(7 downto 0) := (others => '0');
  signal dout    : std_logic_vector(7 downto 0);

  constant CLK_PERIOD : time := 10 ns;

begin
  -- Instanciação do Registrador (DUT - Device Under Test)
  uut: entity work.reg
    generic map (
      p_WIDTH     => 8,
      p_INIT_DATA => 0
    )
    port map (
      i_CLK    => clk,
      i_RST    => rst,
      i_ENABLE => enable,
      i_DIN    => din,
      o_DOUT   => dout
    );

  -- Processo de Geração do Clock
  clk_process: process
  begin
    while true loop
      clk <= '0';
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
  end process;

  -- Processo de Estímulos
  stimulus_process: process
  begin
    -- Reset do Registrador
    rst <= '1';
    wait for CLK_PERIOD;
    rst <= '0';
    wait for CLK_PERIOD;

    -- Teste com Habilitação e Dados na Entrada
    enable <= '1';
    din <= "00000001";  -- Aplica o valor 1
    wait for CLK_PERIOD;

    -- Desabilita o Registrador (mantém o último valor)
    enable <= '0';
    din <= "11111111";  -- Aplica o valor 4 (não deve ser registrado)
    wait for CLK_PERIOD;

    -- Reset novamente
    rst <= '1';
    wait for CLK_PERIOD;
    rst <= '0';
    wait for CLK_PERIOD;
    
    -- Teste com Habilitação e Dados na Entrada
    enable <= '1';
    din <= "00000010";  -- Aplica o valor 1
    wait for CLK_PERIOD;
    
    -- Desabilita o Registrador (mantém o último valor)
    enable <= '0';
    din <= "11111111";  -- Aplica o valor 4 (não deve ser registrado)
    wait for CLK_PERIOD;
    
    -- Reset novamente
    rst <= '1';
    wait for CLK_PERIOD;
    rst <= '0';
    wait for CLK_PERIOD;
    
    -- Teste com Habilitação e Dados na Entrada
    enable <= '1';
    din <= "00000011";  -- Aplica o valor 1
    wait for CLK_PERIOD;
    
    -- Desabilita o Registrador (mantém o último valor)
    enable <= '0';
    din <= "11111111";  -- Aplica o valor 4 (não deve ser registrado)
    wait for CLK_PERIOD;
    
    -- Reset novamente
    rst <= '1';
    wait for CLK_PERIOD;
    rst <= '0';
    wait for CLK_PERIOD;


    -- Finaliza a Simulação
    wait;
  end process;

end behavioral;
