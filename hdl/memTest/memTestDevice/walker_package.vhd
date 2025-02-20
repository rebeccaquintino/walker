-------------------------------------------------------------
-- File: walker_package.vhd
-- Author: Felipe Viel
-- File function: processing blocks of memTestDataBus
-- Created: 31/08/2023
-- Modified: 31/08/2023
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

package PROJECT_PACK is
   constant WORDS_QTD_MEMORY : natural := 524288;
   constant WIDTH_ADDRESS_MEMORY : natural := 19;
end PROJECT_PACK;