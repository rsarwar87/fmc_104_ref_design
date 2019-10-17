--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Command: generate_target bd_4eb6_wrapper.bd
--Design : bd_4eb6_wrapper
--Purpose: IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_4eb6_wrapper is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 13 downto 0 )
  );
end bd_4eb6_wrapper;

architecture STRUCTURE of bd_4eb6_wrapper is
  component bd_4eb6 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 13 downto 0 )
  );
  end component bd_4eb6;
begin
bd_4eb6_i: component bd_4eb6
     port map (
      clk => clk,
      probe0(13 downto 0) => probe0(13 downto 0)
    );
end STRUCTURE;
