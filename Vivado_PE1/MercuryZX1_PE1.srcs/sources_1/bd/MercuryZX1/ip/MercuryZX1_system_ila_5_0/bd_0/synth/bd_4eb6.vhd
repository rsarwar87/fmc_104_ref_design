--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Command: generate_target bd_4eb6.bd
--Design : bd_4eb6
--Purpose: IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_4eb6 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 13 downto 0 )
  );
  attribute core_generation_info : string;
  attribute core_generation_info of bd_4eb6 : entity is "bd_4eb6,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=bd_4eb6,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=SBD,synth_mode=Global}";
  attribute hw_handoff : string;
  attribute hw_handoff of bd_4eb6 : entity is "MercuryZX1_system_ila_5_0.hwdef";
end bd_4eb6;

architecture STRUCTURE of bd_4eb6 is
  component bd_4eb6_ila_lib_0 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 13 downto 0 )
  );
  end component bd_4eb6_ila_lib_0;
  signal clk_1 : STD_LOGIC;
  signal probe0_1 : STD_LOGIC_VECTOR ( 13 downto 0 );
  attribute x_interface_info : string;
  attribute x_interface_info of clk : signal is "xilinx.com:signal:clock:1.0 CLK.CLK CLK";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of clk : signal is "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN /clk_wiz_clk_out1, FREQ_HZ 200000000, INSERT_VIP 0, PHASE 0.0";
begin
  clk_1 <= clk;
  probe0_1(13 downto 0) <= probe0(13 downto 0);
ila_lib: component bd_4eb6_ila_lib_0
     port map (
      clk => clk_1,
      probe0(13 downto 0) => probe0_1(13 downto 0)
    );
end STRUCTURE;
