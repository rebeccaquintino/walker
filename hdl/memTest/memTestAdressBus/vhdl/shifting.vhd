-------------------------------------------------------------
-- File: accumulator.vhd
-- Author: Rebecca Quintino Do O
-- File function: shifter and registes in format of shifting
-- Created: 05/08/2023
-- Modified: 05/08/2023
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use work.all;

entity shifting is
   generic (
      p_WIDTH            : natural := 8;
      p_SHIFTER          : natural := 3;
      p_INIT_DATA        : natural := 0
    );
    port ( 
      i_CLK              : in std_logic;
      i_RST              : in std_logic;
      i_RST_CONTROL      : in std_logic;
      i_ENABLE           : in std_logic;
      o_DOUT             : out std_logic_vector(p_WIDTH - 1 downto 0)
    );

end entity shifting;

architecture rtl of reg is
   signal reg            : std_logic_vector(p_WIDTH - 1 downto 0);
   signal w_RST_REGS     : std_logic;
   signal w_DOUT_REG     : std_logic_vector (p_WIDTH  - 1 downto 0);
   signal w_DOUT_SHIFTER : std_logic_vector (p_WIDTH  - 1 downto 0);

 begin

   w_RST_REGS <= i_RST OR i_RST_CONTROL;
   
   u_REG: entity work.reg
        generic map(
         p_WIDTH     => p_WIDTH,
         p_INIT_DATA => p_INIT_DATA 
        )
        port map (
           i_CLK    => i_CLK,
           i_RST    => w_RST_REGS,
           i_ENABLE => i_ENABLE,
           i_DIN    => w_DOUT_SHIFTER,
           o_DOUT   => w_DOUT_REG
        );
 
    u_SHIFTER: entity work.shifter
        generic map(
          p_WIDTH_DATA     => p_WIDTH,
          p_NUMBER_SHIFTER => p_SHIFTER
        )
        port map( 
          i_DIN     => w_DOUT_REG, 
          i_RL      =>  '1',                  
          i_SHIFTER => std_logic_vector(to_unsigned(p_INIT_DATA, p_WIDTH)),
          o_DOUT    =>  w_DOUT_SHIFTER,    
          o_ZERO    =>  open
        );
 
    o_DOUT <= w_DOUT_REG;
   
 end architecture rtl;