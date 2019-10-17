-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
-- Date        : Thu Oct 17 12:34:28 2019
-- Host        : ukaea-fpga running 64-bit KDE neon User Edition 5.16
-- Command     : write_vhdl -force -mode synth_stub
--               /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/mercury_pe1_fmc104/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_system_ila_2_0/MercuryZX1_system_ila_2_0_stub.vhdl
-- Design      : MercuryZX1_system_ila_2_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z030fbg676-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MercuryZX1_system_ila_2_0 is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 13 downto 0 )
  );

end MercuryZX1_system_ila_2_0;

architecture stub of MercuryZX1_system_ila_2_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[13:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "bd_8f07,Vivado 2019.1";
begin
end;
