--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Command: generate_target bd_8f07_wrapper.bd
--Design : bd_8f07_wrapper
--Purpose: IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_8f07_wrapper is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 13 downto 0 )
  );
end bd_8f07_wrapper;

architecture STRUCTURE of bd_8f07_wrapper is
  component bd_8f07 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 13 downto 0 )
  );
  end component bd_8f07;
begin
bd_8f07_i: component bd_8f07
     port map (
      clk => clk,
      probe0(13 downto 0) => probe0(13 downto 0)
    );
end STRUCTURE;
