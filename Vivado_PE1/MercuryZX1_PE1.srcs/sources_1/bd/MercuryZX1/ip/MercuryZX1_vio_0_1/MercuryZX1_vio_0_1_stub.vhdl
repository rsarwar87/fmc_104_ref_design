-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
-- Date        : Thu Oct 17 08:08:55 2019
-- Host        : ukaea-fpga running 64-bit KDE neon User Edition 5.16
-- Command     : write_vhdl -force -mode synth_stub
--               /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/mercury_pe1_fmc104/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_vio_0_1/MercuryZX1_vio_0_1_stub.vhdl
-- Design      : MercuryZX1_vio_0_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z030fbg676-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MercuryZX1_vio_0_1 is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 13 downto 0 );
    probe_in1 : in STD_LOGIC_VECTOR ( 13 downto 0 );
    probe_in2 : in STD_LOGIC_VECTOR ( 13 downto 0 );
    probe_in3 : in STD_LOGIC_VECTOR ( 13 downto 0 );
    probe_in4 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe_in5 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe_out0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    probe_out2 : out STD_LOGIC_VECTOR ( 3 downto 0 )
  );

end MercuryZX1_vio_0_1;

architecture stub of MercuryZX1_vio_0_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[13:0],probe_in1[13:0],probe_in2[13:0],probe_in3[13:0],probe_in4[3:0],probe_in5[3:0],probe_out0[3:0],probe_out1[3:0],probe_out2[3:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2019.1";
begin
end;
