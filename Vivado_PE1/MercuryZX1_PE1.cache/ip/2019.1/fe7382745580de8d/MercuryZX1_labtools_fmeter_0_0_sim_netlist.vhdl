-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
-- Date        : Thu Oct 17 12:30:04 2019
-- Host        : ukaea-fpga running 64-bit KDE neon User Edition 5.16
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ MercuryZX1_labtools_fmeter_0_0_sim_netlist.vhdl
-- Design      : MercuryZX1_labtools_fmeter_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z030fbg676-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO is
  port (
    update : out STD_LOGIC;
    F : out STD_LOGIC;
    \bl.DSP48E_2_0\ : out STD_LOGIC;
    refclk : in STD_LOGIC;
    toggle : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO is
  signal CNTR_OUT : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal \F[31]_i_10_n_0\ : STD_LOGIC;
  signal \F[31]_i_11_n_0\ : STD_LOGIC;
  signal \F[31]_i_12_n_0\ : STD_LOGIC;
  signal \F[31]_i_13_n_0\ : STD_LOGIC;
  signal \F[31]_i_14_n_0\ : STD_LOGIC;
  signal \F[31]_i_2_n_0\ : STD_LOGIC;
  signal \F[31]_i_3_n_0\ : STD_LOGIC;
  signal \F[31]_i_4_n_0\ : STD_LOGIC;
  signal \F[31]_i_5_n_0\ : STD_LOGIC;
  signal \F[31]_i_6_n_0\ : STD_LOGIC;
  signal \F[31]_i_7_n_0\ : STD_LOGIC;
  signal \F[31]_i_8_n_0\ : STD_LOGIC;
  signal \F[31]_i_9_n_0\ : STD_LOGIC;
  signal \bl.DSP48E_2_i_1_n_0\ : STD_LOGIC;
  signal update_INST_0_i_1_n_0 : STD_LOGIC;
  signal update_INST_0_i_2_n_0 : STD_LOGIC;
  signal update_INST_0_i_3_n_0 : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \F[31]_i_7\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \F[31]_i_9\ : label is "soft_lutpair0";
  attribute box_type : string;
  attribute box_type of \bl.DSP48E_2\ : label is "PRIMITIVE";
  attribute SOFT_HLUTNM of toggle_i_1 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of update_INST_0 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of update_INST_0_i_2 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of update_INST_0_i_3 : label is "soft_lutpair1";
begin
\F[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000004"
    )
        port map (
      I0 => toggle,
      I1 => CNTR_OUT(0),
      I2 => \F[31]_i_2_n_0\,
      I3 => \F[31]_i_3_n_0\,
      I4 => \F[31]_i_4_n_0\,
      I5 => \F[31]_i_5_n_0\,
      O => F
    );
\F[31]_i_10\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => CNTR_OUT(31),
      I1 => CNTR_OUT(30),
      I2 => CNTR_OUT(33),
      I3 => CNTR_OUT(32),
      O => \F[31]_i_10_n_0\
    );
\F[31]_i_11\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF7F"
    )
        port map (
      I0 => CNTR_OUT(23),
      I1 => CNTR_OUT(22),
      I2 => CNTR_OUT(24),
      I3 => CNTR_OUT(25),
      O => \F[31]_i_11_n_0\
    );
\F[31]_i_12\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => CNTR_OUT(39),
      I1 => CNTR_OUT(38),
      I2 => CNTR_OUT(41),
      I3 => CNTR_OUT(40),
      O => \F[31]_i_12_n_0\
    );
\F[31]_i_13\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => CNTR_OUT(35),
      I1 => CNTR_OUT(34),
      I2 => CNTR_OUT(37),
      I3 => CNTR_OUT(36),
      O => \F[31]_i_13_n_0\
    );
\F[31]_i_14\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => CNTR_OUT(43),
      I1 => CNTR_OUT(42),
      I2 => CNTR_OUT(45),
      I3 => CNTR_OUT(44),
      O => \F[31]_i_14_n_0\
    );
\F[31]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \F[31]_i_6_n_0\,
      I1 => \F[31]_i_7_n_0\,
      I2 => \F[31]_i_8_n_0\,
      I3 => \F[31]_i_9_n_0\,
      O => \F[31]_i_2_n_0\
    );
\F[31]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFEFF"
    )
        port map (
      I0 => CNTR_OUT(28),
      I1 => CNTR_OUT(29),
      I2 => CNTR_OUT(27),
      I3 => CNTR_OUT(26),
      I4 => \F[31]_i_10_n_0\,
      O => \F[31]_i_3_n_0\
    );
\F[31]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFF7FF"
    )
        port map (
      I0 => CNTR_OUT(20),
      I1 => CNTR_OUT(21),
      I2 => CNTR_OUT(19),
      I3 => CNTR_OUT(18),
      I4 => \F[31]_i_11_n_0\,
      O => \F[31]_i_4_n_0\
    );
\F[31]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFEFFFF"
    )
        port map (
      I0 => \F[31]_i_12_n_0\,
      I1 => \F[31]_i_13_n_0\,
      I2 => CNTR_OUT(47),
      I3 => CNTR_OUT(46),
      I4 => CNTR_OUT(1),
      I5 => \F[31]_i_14_n_0\,
      O => \F[31]_i_5_n_0\
    );
\F[31]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFF7"
    )
        port map (
      I0 => CNTR_OUT(7),
      I1 => CNTR_OUT(6),
      I2 => CNTR_OUT(9),
      I3 => CNTR_OUT(8),
      O => \F[31]_i_6_n_0\
    );
\F[31]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => CNTR_OUT(3),
      I1 => CNTR_OUT(2),
      I2 => CNTR_OUT(5),
      I3 => CNTR_OUT(4),
      O => \F[31]_i_7_n_0\
    );
\F[31]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF7F"
    )
        port map (
      I0 => CNTR_OUT(15),
      I1 => CNTR_OUT(14),
      I2 => CNTR_OUT(16),
      I3 => CNTR_OUT(17),
      O => \F[31]_i_8_n_0\
    );
\F[31]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFEF"
    )
        port map (
      I0 => CNTR_OUT(11),
      I1 => CNTR_OUT(10),
      I2 => CNTR_OUT(13),
      I3 => CNTR_OUT(12),
      O => \F[31]_i_9_n_0\
    );
\bl.DSP48E_2\: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 1,
      ADREG => 0,
      ALUMODEREG => 1,
      AREG => 1,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 1,
      BREG => 1,
      B_INPUT => "DIRECT",
      CARRYINREG => 1,
      CARRYINSELREG => 1,
      CREG => 1,
      DREG => 0,
      INMODEREG => 1,
      IS_ALUMODE_INVERTED => B"0000",
      IS_CARRYIN_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_INMODE_INVERTED => B"00000",
      IS_OPMODE_INVERTED => B"0000000",
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 1,
      PATTERN => X"000000000000",
      PREG => 1,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000001",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => '1',
      CEAD => '0',
      CEALUMODE => '1',
      CEB1 => '0',
      CEB2 => '1',
      CEC => '1',
      CECARRYIN => '1',
      CECTRL => '1',
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => '1',
      CLK => refclk,
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(6) => '0',
      OPMODE(5) => \bl.DSP48E_2_i_1_n_0\,
      OPMODE(4 downto 2) => B"000",
      OPMODE(1) => \bl.DSP48E_2_i_1_n_0\,
      OPMODE(0) => \bl.DSP48E_2_i_1_n_0\,
      OVERFLOW => \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\,
      P(47 downto 0) => CNTR_OUT(47 downto 0),
      PATTERNBDETECT => \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => '0',
      RSTALLCARRYIN => '0',
      RSTALUMODE => '0',
      RSTB => '0',
      RSTC => '0',
      RSTCTRL => '0',
      RSTD => '0',
      RSTINMODE => '0',
      RSTM => '0',
      RSTP => '0',
      UNDERFLOW => \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\
    );
\bl.DSP48E_2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => update_INST_0_i_1_n_0,
      I1 => CNTR_OUT(0),
      O => \bl.DSP48E_2_i_1_n_0\
    );
toggle_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => update_INST_0_i_1_n_0,
      I1 => CNTR_OUT(0),
      I2 => toggle,
      O => \bl.DSP48E_2_0\
    );
update_INST_0: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => CNTR_OUT(0),
      I1 => update_INST_0_i_1_n_0,
      O => update
    );
update_INST_0_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \F[31]_i_5_n_0\,
      I1 => \F[31]_i_4_n_0\,
      I2 => \F[31]_i_3_n_0\,
      I3 => update_INST_0_i_2_n_0,
      I4 => update_INST_0_i_3_n_0,
      O => update_INST_0_i_1_n_0
    );
update_INST_0_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFB"
    )
        port map (
      I0 => CNTR_OUT(12),
      I1 => CNTR_OUT(13),
      I2 => CNTR_OUT(10),
      I3 => CNTR_OUT(11),
      I4 => \F[31]_i_8_n_0\,
      O => update_INST_0_i_2_n_0
    );
update_INST_0_i_3: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => CNTR_OUT(4),
      I1 => CNTR_OUT(5),
      I2 => CNTR_OUT(2),
      I3 => CNTR_OUT(3),
      I4 => \F[31]_i_6_n_0\,
      O => update_INST_0_i_3_n_0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0\ is
  port (
    P : out STD_LOGIC_VECTOR ( 31 downto 0 );
    CE : in STD_LOGIC;
    fin : in STD_LOGIC_VECTOR ( 0 to 0 );
    toggle : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0\ : entity is "unimacro_COUNTER_TC_MACRO";
end \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0\;

architecture STRUCTURE of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0\ is
  signal CNTR_OUT : STD_LOGIC_VECTOR ( 47 downto 32 );
  signal \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  attribute box_type : string;
  attribute box_type of \bl.DSP48E_2\ : label is "PRIMITIVE";
begin
\bl.DSP48E_2\: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 1,
      ADREG => 0,
      ALUMODEREG => 1,
      AREG => 1,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 1,
      BREG => 1,
      B_INPUT => "DIRECT",
      CARRYINREG => 1,
      CARRYINSELREG => 1,
      CREG => 1,
      DREG => 0,
      INMODEREG => 1,
      IS_ALUMODE_INVERTED => B"0000",
      IS_CARRYIN_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_INMODE_INVERTED => B"00000",
      IS_OPMODE_INVERTED => B"0000000",
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 1,
      PATTERN => X"000000000000",
      PREG => 1,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000001",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => CE,
      CEAD => '0',
      CEALUMODE => CE,
      CEB1 => '0',
      CEB2 => CE,
      CEC => CE,
      CECARRYIN => CE,
      CECTRL => CE,
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => CE,
      CLK => fin(0),
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(6 downto 0) => B"0100011",
      OVERFLOW => \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\,
      P(47 downto 32) => CNTR_OUT(47 downto 32),
      P(31 downto 0) => P(31 downto 0),
      PATTERNBDETECT => \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => toggle,
      RSTALLCARRYIN => toggle,
      RSTALUMODE => toggle,
      RSTB => toggle,
      RSTC => toggle,
      RSTCTRL => toggle,
      RSTD => toggle,
      RSTINMODE => toggle,
      RSTM => toggle,
      RSTP => toggle,
      UNDERFLOW => \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_0\ is
  port (
    P : out STD_LOGIC_VECTOR ( 31 downto 0 );
    CE : in STD_LOGIC;
    fin : in STD_LOGIC_VECTOR ( 0 to 0 );
    toggle : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_0\ : entity is "unimacro_COUNTER_TC_MACRO";
end \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_0\;

architecture STRUCTURE of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_0\ is
  signal CNTR_OUT : STD_LOGIC_VECTOR ( 47 downto 32 );
  signal \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  attribute box_type : string;
  attribute box_type of \bl.DSP48E_2\ : label is "PRIMITIVE";
begin
\bl.DSP48E_2\: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 1,
      ADREG => 0,
      ALUMODEREG => 1,
      AREG => 1,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 1,
      BREG => 1,
      B_INPUT => "DIRECT",
      CARRYINREG => 1,
      CARRYINSELREG => 1,
      CREG => 1,
      DREG => 0,
      INMODEREG => 1,
      IS_ALUMODE_INVERTED => B"0000",
      IS_CARRYIN_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_INMODE_INVERTED => B"00000",
      IS_OPMODE_INVERTED => B"0000000",
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 1,
      PATTERN => X"000000000000",
      PREG => 1,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000001",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => CE,
      CEAD => '0',
      CEALUMODE => CE,
      CEB1 => '0',
      CEB2 => CE,
      CEC => CE,
      CECARRYIN => CE,
      CECTRL => CE,
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => CE,
      CLK => fin(0),
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(6 downto 0) => B"0100011",
      OVERFLOW => \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\,
      P(47 downto 32) => CNTR_OUT(47 downto 32),
      P(31 downto 0) => P(31 downto 0),
      PATTERNBDETECT => \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => toggle,
      RSTALLCARRYIN => toggle,
      RSTALUMODE => toggle,
      RSTB => toggle,
      RSTC => toggle,
      RSTCTRL => toggle,
      RSTD => toggle,
      RSTINMODE => toggle,
      RSTM => toggle,
      RSTP => toggle,
      UNDERFLOW => \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_1\ is
  port (
    P : out STD_LOGIC_VECTOR ( 31 downto 0 );
    CE : in STD_LOGIC;
    fin : in STD_LOGIC_VECTOR ( 0 to 0 );
    toggle : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_1\ : entity is "unimacro_COUNTER_TC_MACRO";
end \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_1\;

architecture STRUCTURE of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_1\ is
  signal CNTR_OUT : STD_LOGIC_VECTOR ( 47 downto 32 );
  signal \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  attribute box_type : string;
  attribute box_type of \bl.DSP48E_2\ : label is "PRIMITIVE";
begin
\bl.DSP48E_2\: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 1,
      ADREG => 0,
      ALUMODEREG => 1,
      AREG => 1,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 1,
      BREG => 1,
      B_INPUT => "DIRECT",
      CARRYINREG => 1,
      CARRYINSELREG => 1,
      CREG => 1,
      DREG => 0,
      INMODEREG => 1,
      IS_ALUMODE_INVERTED => B"0000",
      IS_CARRYIN_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_INMODE_INVERTED => B"00000",
      IS_OPMODE_INVERTED => B"0000000",
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 1,
      PATTERN => X"000000000000",
      PREG => 1,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000001",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => CE,
      CEAD => '0',
      CEALUMODE => CE,
      CEB1 => '0',
      CEB2 => CE,
      CEC => CE,
      CECARRYIN => CE,
      CECTRL => CE,
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => CE,
      CLK => fin(0),
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(6 downto 0) => B"0100011",
      OVERFLOW => \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\,
      P(47 downto 32) => CNTR_OUT(47 downto 32),
      P(31 downto 0) => P(31 downto 0),
      PATTERNBDETECT => \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => toggle,
      RSTALLCARRYIN => toggle,
      RSTALUMODE => toggle,
      RSTB => toggle,
      RSTC => toggle,
      RSTCTRL => toggle,
      RSTD => toggle,
      RSTINMODE => toggle,
      RSTM => toggle,
      RSTP => toggle,
      UNDERFLOW => \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_2\ is
  port (
    P : out STD_LOGIC_VECTOR ( 31 downto 0 );
    CE : in STD_LOGIC;
    fin : in STD_LOGIC_VECTOR ( 0 to 0 );
    toggle : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_2\ : entity is "unimacro_COUNTER_TC_MACRO";
end \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_2\;

architecture STRUCTURE of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_2\ is
  signal CNTR_OUT : STD_LOGIC_VECTOR ( 47 downto 32 );
  signal \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  attribute box_type : string;
  attribute box_type of \bl.DSP48E_2\ : label is "PRIMITIVE";
begin
\bl.DSP48E_2\: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 1,
      ADREG => 0,
      ALUMODEREG => 1,
      AREG => 1,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 1,
      BREG => 1,
      B_INPUT => "DIRECT",
      CARRYINREG => 1,
      CARRYINSELREG => 1,
      CREG => 1,
      DREG => 0,
      INMODEREG => 1,
      IS_ALUMODE_INVERTED => B"0000",
      IS_CARRYIN_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_INMODE_INVERTED => B"00000",
      IS_OPMODE_INVERTED => B"0000000",
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 1,
      PATTERN => X"000000000000",
      PREG => 1,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000001",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => CE,
      CEAD => '0',
      CEALUMODE => CE,
      CEB1 => '0',
      CEB2 => CE,
      CEC => CE,
      CECARRYIN => CE,
      CECTRL => CE,
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => CE,
      CLK => fin(0),
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(6 downto 0) => B"0100011",
      OVERFLOW => \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\,
      P(47 downto 32) => CNTR_OUT(47 downto 32),
      P(31 downto 0) => P(31 downto 0),
      PATTERNBDETECT => \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => toggle,
      RSTALLCARRYIN => toggle,
      RSTALUMODE => toggle,
      RSTB => toggle,
      RSTC => toggle,
      RSTCTRL => toggle,
      RSTD => toggle,
      RSTINMODE => toggle,
      RSTM => toggle,
      RSTP => toggle,
      UNDERFLOW => \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_3\ is
  port (
    P : out STD_LOGIC_VECTOR ( 31 downto 0 );
    CE : in STD_LOGIC;
    fin : in STD_LOGIC_VECTOR ( 0 to 0 );
    toggle : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_3\ : entity is "unimacro_COUNTER_TC_MACRO";
end \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_3\;

architecture STRUCTURE of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_3\ is
  signal CNTR_OUT : STD_LOGIC_VECTOR ( 47 downto 32 );
  signal \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  attribute box_type : string;
  attribute box_type of \bl.DSP48E_2\ : label is "PRIMITIVE";
begin
\bl.DSP48E_2\: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 1,
      ADREG => 0,
      ALUMODEREG => 1,
      AREG => 1,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 1,
      BREG => 1,
      B_INPUT => "DIRECT",
      CARRYINREG => 1,
      CARRYINSELREG => 1,
      CREG => 1,
      DREG => 0,
      INMODEREG => 1,
      IS_ALUMODE_INVERTED => B"0000",
      IS_CARRYIN_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_INMODE_INVERTED => B"00000",
      IS_OPMODE_INVERTED => B"0000000",
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 1,
      PATTERN => X"000000000000",
      PREG => 1,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000001",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => CE,
      CEAD => '0',
      CEALUMODE => CE,
      CEB1 => '0',
      CEB2 => CE,
      CEC => CE,
      CECARRYIN => CE,
      CECTRL => CE,
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => CE,
      CLK => fin(0),
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(6 downto 0) => B"0100011",
      OVERFLOW => \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\,
      P(47 downto 32) => CNTR_OUT(47 downto 32),
      P(31 downto 0) => P(31 downto 0),
      PATTERNBDETECT => \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => toggle,
      RSTALLCARRYIN => toggle,
      RSTALUMODE => toggle,
      RSTB => toggle,
      RSTC => toggle,
      RSTCTRL => toggle,
      RSTD => toggle,
      RSTINMODE => toggle,
      RSTM => toggle,
      RSTP => toggle,
      UNDERFLOW => \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_4\ is
  port (
    P : out STD_LOGIC_VECTOR ( 31 downto 0 );
    CE : in STD_LOGIC;
    fin : in STD_LOGIC_VECTOR ( 0 to 0 );
    toggle : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_4\ : entity is "unimacro_COUNTER_TC_MACRO";
end \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_4\;

architecture STRUCTURE of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_4\ is
  signal CNTR_OUT : STD_LOGIC_VECTOR ( 47 downto 32 );
  signal \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  attribute box_type : string;
  attribute box_type of \bl.DSP48E_2\ : label is "PRIMITIVE";
begin
\bl.DSP48E_2\: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 1,
      ADREG => 0,
      ALUMODEREG => 1,
      AREG => 1,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 1,
      BREG => 1,
      B_INPUT => "DIRECT",
      CARRYINREG => 1,
      CARRYINSELREG => 1,
      CREG => 1,
      DREG => 0,
      INMODEREG => 1,
      IS_ALUMODE_INVERTED => B"0000",
      IS_CARRYIN_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_INMODE_INVERTED => B"00000",
      IS_OPMODE_INVERTED => B"0000000",
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 1,
      PATTERN => X"000000000000",
      PREG => 1,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000001",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => CE,
      CEAD => '0',
      CEALUMODE => CE,
      CEB1 => '0',
      CEB2 => CE,
      CEC => CE,
      CECARRYIN => CE,
      CECTRL => CE,
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => CE,
      CLK => fin(0),
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(6 downto 0) => B"0100011",
      OVERFLOW => \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\,
      P(47 downto 32) => CNTR_OUT(47 downto 32),
      P(31 downto 0) => P(31 downto 0),
      PATTERNBDETECT => \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => toggle,
      RSTALLCARRYIN => toggle,
      RSTALUMODE => toggle,
      RSTB => toggle,
      RSTC => toggle,
      RSTCTRL => toggle,
      RSTD => toggle,
      RSTINMODE => toggle,
      RSTM => toggle,
      RSTP => toggle,
      UNDERFLOW => \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_5\ is
  port (
    P : out STD_LOGIC_VECTOR ( 31 downto 0 );
    CE : in STD_LOGIC;
    fin : in STD_LOGIC_VECTOR ( 0 to 0 );
    toggle : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_5\ : entity is "unimacro_COUNTER_TC_MACRO";
end \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_5\;

architecture STRUCTURE of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_5\ is
  signal CNTR_OUT : STD_LOGIC_VECTOR ( 47 downto 32 );
  signal \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  attribute box_type : string;
  attribute box_type of \bl.DSP48E_2\ : label is "PRIMITIVE";
begin
\bl.DSP48E_2\: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 1,
      ADREG => 0,
      ALUMODEREG => 1,
      AREG => 1,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 1,
      BREG => 1,
      B_INPUT => "DIRECT",
      CARRYINREG => 1,
      CARRYINSELREG => 1,
      CREG => 1,
      DREG => 0,
      INMODEREG => 1,
      IS_ALUMODE_INVERTED => B"0000",
      IS_CARRYIN_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_INMODE_INVERTED => B"00000",
      IS_OPMODE_INVERTED => B"0000000",
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 1,
      PATTERN => X"000000000000",
      PREG => 1,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000001",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => CE,
      CEAD => '0',
      CEALUMODE => CE,
      CEB1 => '0',
      CEB2 => CE,
      CEC => CE,
      CECARRYIN => CE,
      CECTRL => CE,
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => CE,
      CLK => fin(0),
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(6 downto 0) => B"0100011",
      OVERFLOW => \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\,
      P(47 downto 32) => CNTR_OUT(47 downto 32),
      P(31 downto 0) => P(31 downto 0),
      PATTERNBDETECT => \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => toggle,
      RSTALLCARRYIN => toggle,
      RSTALUMODE => toggle,
      RSTB => toggle,
      RSTC => toggle,
      RSTCTRL => toggle,
      RSTD => toggle,
      RSTINMODE => toggle,
      RSTM => toggle,
      RSTP => toggle,
      UNDERFLOW => \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_6\ is
  port (
    P : out STD_LOGIC_VECTOR ( 31 downto 0 );
    CE : in STD_LOGIC;
    fin : in STD_LOGIC_VECTOR ( 0 to 0 );
    toggle : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_6\ : entity is "unimacro_COUNTER_TC_MACRO";
end \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_6\;

architecture STRUCTURE of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_6\ is
  signal CNTR_OUT : STD_LOGIC_VECTOR ( 47 downto 32 );
  signal \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  attribute box_type : string;
  attribute box_type of \bl.DSP48E_2\ : label is "PRIMITIVE";
begin
\bl.DSP48E_2\: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 1,
      ADREG => 0,
      ALUMODEREG => 1,
      AREG => 1,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 1,
      BREG => 1,
      B_INPUT => "DIRECT",
      CARRYINREG => 1,
      CARRYINSELREG => 1,
      CREG => 1,
      DREG => 0,
      INMODEREG => 1,
      IS_ALUMODE_INVERTED => B"0000",
      IS_CARRYIN_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_INMODE_INVERTED => B"00000",
      IS_OPMODE_INVERTED => B"0000000",
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 1,
      PATTERN => X"000000000000",
      PREG => 1,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000001",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => CE,
      CEAD => '0',
      CEALUMODE => CE,
      CEB1 => '0',
      CEB2 => CE,
      CEC => CE,
      CECARRYIN => CE,
      CECTRL => CE,
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => CE,
      CLK => fin(0),
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(6 downto 0) => B"0100011",
      OVERFLOW => \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\,
      P(47 downto 32) => CNTR_OUT(47 downto 32),
      P(31 downto 0) => P(31 downto 0),
      PATTERNBDETECT => \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => toggle,
      RSTALLCARRYIN => toggle,
      RSTALUMODE => toggle,
      RSTB => toggle,
      RSTC => toggle,
      RSTCTRL => toggle,
      RSTD => toggle,
      RSTINMODE => toggle,
      RSTM => toggle,
      RSTP => toggle,
      UNDERFLOW => \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_7\ is
  port (
    P : out STD_LOGIC_VECTOR ( 31 downto 0 );
    CE : out STD_LOGIC;
    fin : in STD_LOGIC_VECTOR ( 0 to 0 );
    toggle : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_7\ : entity is "unimacro_COUNTER_TC_MACRO";
end \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_7\;

architecture STRUCTURE of \decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_7\ is
  signal \^ce\ : STD_LOGIC;
  signal CNTR_OUT : STD_LOGIC_VECTOR ( 47 downto 32 );
  signal \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  attribute box_type : string;
  attribute box_type of \bl.DSP48E_2\ : label is "PRIMITIVE";
begin
  CE <= \^ce\;
\bl.DSP48E_2\: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 1,
      ADREG => 0,
      ALUMODEREG => 1,
      AREG => 1,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 1,
      BREG => 1,
      B_INPUT => "DIRECT",
      CARRYINREG => 1,
      CARRYINSELREG => 1,
      CREG => 1,
      DREG => 0,
      INMODEREG => 1,
      IS_ALUMODE_INVERTED => B"0000",
      IS_CARRYIN_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_INMODE_INVERTED => B"00000",
      IS_OPMODE_INVERTED => B"0000000",
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 1,
      PATTERN => X"000000000000",
      PREG => 1,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_bl.DSP48E_2_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000001",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_bl.DSP48E_2_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => \^ce\,
      CEAD => '0',
      CEALUMODE => \^ce\,
      CEB1 => '0',
      CEB2 => \^ce\,
      CEC => \^ce\,
      CECARRYIN => \^ce\,
      CECTRL => \^ce\,
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => \^ce\,
      CLK => fin(0),
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(6 downto 0) => B"0100011",
      OVERFLOW => \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED\,
      P(47 downto 32) => CNTR_OUT(47 downto 32),
      P(31 downto 0) => P(31 downto 0),
      PATTERNBDETECT => \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED\,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => \NLW_bl.DSP48E_2_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => toggle,
      RSTALLCARRYIN => toggle,
      RSTALUMODE => toggle,
      RSTB => toggle,
      RSTC => toggle,
      RSTCTRL => toggle,
      RSTD => toggle,
      RSTINMODE => toggle,
      RSTM => toggle,
      RSTP => toggle,
      UNDERFLOW => \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED\
    );
\bl.DSP48E_2_i_1__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => toggle,
      O => \^ce\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_labtools_fmeter is
  port (
    F8 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F7 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F6 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F5 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F4 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F3 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F2 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    update : out STD_LOGIC;
    refclk : in STD_LOGIC;
    fin : in STD_LOGIC_VECTOR ( 8 downto 0 )
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_labtools_fmeter;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_labtools_fmeter is
  signal CE : STD_LOGIC;
  signal CNTR_OUT : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal CNTR_OUT_0 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal CNTR_OUT_1 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal CNTR_OUT_2 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal CNTR_OUT_3 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal CNTR_OUT_4 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal CNTR_OUT_5 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal CNTR_OUT_6 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal CNTR_OUT_7 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal COUNTER_REFCLK_inst_n_2 : STD_LOGIC;
  signal F : STD_LOGIC;
  signal toggle : STD_LOGIC;
begin
COUNTER_REFCLK_inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO
     port map (
      F => F,
      \bl.DSP48E_2_0\ => COUNTER_REFCLK_inst_n_2,
      refclk => refclk,
      toggle => toggle,
      update => update
    );
\FMETER_gen[0].COUNTER_F_inst\: entity work.\decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0\
     port map (
      CE => CE,
      P(31 downto 0) => CNTR_OUT(31 downto 0),
      fin(0) => fin(0),
      toggle => toggle
    );
\FMETER_gen[1].COUNTER_F_inst\: entity work.\decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_0\
     port map (
      CE => CE,
      P(31 downto 0) => CNTR_OUT_0(31 downto 0),
      fin(0) => fin(1),
      toggle => toggle
    );
\FMETER_gen[2].COUNTER_F_inst\: entity work.\decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_1\
     port map (
      CE => CE,
      P(31 downto 0) => CNTR_OUT_1(31 downto 0),
      fin(0) => fin(2),
      toggle => toggle
    );
\FMETER_gen[3].COUNTER_F_inst\: entity work.\decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_2\
     port map (
      CE => CE,
      P(31 downto 0) => CNTR_OUT_2(31 downto 0),
      fin(0) => fin(3),
      toggle => toggle
    );
\FMETER_gen[4].COUNTER_F_inst\: entity work.\decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_3\
     port map (
      CE => CE,
      P(31 downto 0) => CNTR_OUT_3(31 downto 0),
      fin(0) => fin(4),
      toggle => toggle
    );
\FMETER_gen[5].COUNTER_F_inst\: entity work.\decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_4\
     port map (
      CE => CE,
      P(31 downto 0) => CNTR_OUT_4(31 downto 0),
      fin(0) => fin(5),
      toggle => toggle
    );
\FMETER_gen[6].COUNTER_F_inst\: entity work.\decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_5\
     port map (
      CE => CE,
      P(31 downto 0) => CNTR_OUT_5(31 downto 0),
      fin(0) => fin(6),
      toggle => toggle
    );
\FMETER_gen[7].COUNTER_F_inst\: entity work.\decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_6\
     port map (
      CE => CE,
      P(31 downto 0) => CNTR_OUT_6(31 downto 0),
      fin(0) => fin(7),
      toggle => toggle
    );
\FMETER_gen[8].COUNTER_F_inst\: entity work.\decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_unimacro_COUNTER_TC_MACRO__parameterized0_7\
     port map (
      CE => CE,
      P(31 downto 0) => CNTR_OUT_7(31 downto 0),
      fin(0) => fin(8),
      toggle => toggle
    );
\F_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(0),
      Q => F0(0),
      R => '0'
    );
\F_reg[100]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(4),
      Q => F3(4),
      R => '0'
    );
\F_reg[101]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(5),
      Q => F3(5),
      R => '0'
    );
\F_reg[102]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(6),
      Q => F3(6),
      R => '0'
    );
\F_reg[103]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(7),
      Q => F3(7),
      R => '0'
    );
\F_reg[104]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(8),
      Q => F3(8),
      R => '0'
    );
\F_reg[105]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(9),
      Q => F3(9),
      R => '0'
    );
\F_reg[106]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(10),
      Q => F3(10),
      R => '0'
    );
\F_reg[107]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(11),
      Q => F3(11),
      R => '0'
    );
\F_reg[108]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(12),
      Q => F3(12),
      R => '0'
    );
\F_reg[109]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(13),
      Q => F3(13),
      R => '0'
    );
\F_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(10),
      Q => F0(10),
      R => '0'
    );
\F_reg[110]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(14),
      Q => F3(14),
      R => '0'
    );
\F_reg[111]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(15),
      Q => F3(15),
      R => '0'
    );
\F_reg[112]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(16),
      Q => F3(16),
      R => '0'
    );
\F_reg[113]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(17),
      Q => F3(17),
      R => '0'
    );
\F_reg[114]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(18),
      Q => F3(18),
      R => '0'
    );
\F_reg[115]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(19),
      Q => F3(19),
      R => '0'
    );
\F_reg[116]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(20),
      Q => F3(20),
      R => '0'
    );
\F_reg[117]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(21),
      Q => F3(21),
      R => '0'
    );
\F_reg[118]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(22),
      Q => F3(22),
      R => '0'
    );
\F_reg[119]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(23),
      Q => F3(23),
      R => '0'
    );
\F_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(11),
      Q => F0(11),
      R => '0'
    );
\F_reg[120]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(24),
      Q => F3(24),
      R => '0'
    );
\F_reg[121]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(25),
      Q => F3(25),
      R => '0'
    );
\F_reg[122]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(26),
      Q => F3(26),
      R => '0'
    );
\F_reg[123]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(27),
      Q => F3(27),
      R => '0'
    );
\F_reg[124]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(28),
      Q => F3(28),
      R => '0'
    );
\F_reg[125]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(29),
      Q => F3(29),
      R => '0'
    );
\F_reg[126]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(30),
      Q => F3(30),
      R => '0'
    );
\F_reg[127]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(31),
      Q => F3(31),
      R => '0'
    );
\F_reg[128]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(0),
      Q => F4(0),
      R => '0'
    );
\F_reg[129]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(1),
      Q => F4(1),
      R => '0'
    );
\F_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(12),
      Q => F0(12),
      R => '0'
    );
\F_reg[130]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(2),
      Q => F4(2),
      R => '0'
    );
\F_reg[131]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(3),
      Q => F4(3),
      R => '0'
    );
\F_reg[132]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(4),
      Q => F4(4),
      R => '0'
    );
\F_reg[133]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(5),
      Q => F4(5),
      R => '0'
    );
\F_reg[134]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(6),
      Q => F4(6),
      R => '0'
    );
\F_reg[135]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(7),
      Q => F4(7),
      R => '0'
    );
\F_reg[136]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(8),
      Q => F4(8),
      R => '0'
    );
\F_reg[137]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(9),
      Q => F4(9),
      R => '0'
    );
\F_reg[138]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(10),
      Q => F4(10),
      R => '0'
    );
\F_reg[139]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(11),
      Q => F4(11),
      R => '0'
    );
\F_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(13),
      Q => F0(13),
      R => '0'
    );
\F_reg[140]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(12),
      Q => F4(12),
      R => '0'
    );
\F_reg[141]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(13),
      Q => F4(13),
      R => '0'
    );
\F_reg[142]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(14),
      Q => F4(14),
      R => '0'
    );
\F_reg[143]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(15),
      Q => F4(15),
      R => '0'
    );
\F_reg[144]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(16),
      Q => F4(16),
      R => '0'
    );
\F_reg[145]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(17),
      Q => F4(17),
      R => '0'
    );
\F_reg[146]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(18),
      Q => F4(18),
      R => '0'
    );
\F_reg[147]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(19),
      Q => F4(19),
      R => '0'
    );
\F_reg[148]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(20),
      Q => F4(20),
      R => '0'
    );
\F_reg[149]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(21),
      Q => F4(21),
      R => '0'
    );
\F_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(14),
      Q => F0(14),
      R => '0'
    );
\F_reg[150]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(22),
      Q => F4(22),
      R => '0'
    );
\F_reg[151]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(23),
      Q => F4(23),
      R => '0'
    );
\F_reg[152]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(24),
      Q => F4(24),
      R => '0'
    );
\F_reg[153]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(25),
      Q => F4(25),
      R => '0'
    );
\F_reg[154]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(26),
      Q => F4(26),
      R => '0'
    );
\F_reg[155]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(27),
      Q => F4(27),
      R => '0'
    );
\F_reg[156]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(28),
      Q => F4(28),
      R => '0'
    );
\F_reg[157]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(29),
      Q => F4(29),
      R => '0'
    );
\F_reg[158]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(30),
      Q => F4(30),
      R => '0'
    );
\F_reg[159]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_3(31),
      Q => F4(31),
      R => '0'
    );
\F_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(15),
      Q => F0(15),
      R => '0'
    );
\F_reg[160]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(0),
      Q => F5(0),
      R => '0'
    );
\F_reg[161]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(1),
      Q => F5(1),
      R => '0'
    );
\F_reg[162]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(2),
      Q => F5(2),
      R => '0'
    );
\F_reg[163]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(3),
      Q => F5(3),
      R => '0'
    );
\F_reg[164]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(4),
      Q => F5(4),
      R => '0'
    );
\F_reg[165]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(5),
      Q => F5(5),
      R => '0'
    );
\F_reg[166]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(6),
      Q => F5(6),
      R => '0'
    );
\F_reg[167]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(7),
      Q => F5(7),
      R => '0'
    );
\F_reg[168]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(8),
      Q => F5(8),
      R => '0'
    );
\F_reg[169]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(9),
      Q => F5(9),
      R => '0'
    );
\F_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(16),
      Q => F0(16),
      R => '0'
    );
\F_reg[170]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(10),
      Q => F5(10),
      R => '0'
    );
\F_reg[171]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(11),
      Q => F5(11),
      R => '0'
    );
\F_reg[172]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(12),
      Q => F5(12),
      R => '0'
    );
\F_reg[173]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(13),
      Q => F5(13),
      R => '0'
    );
\F_reg[174]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(14),
      Q => F5(14),
      R => '0'
    );
\F_reg[175]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(15),
      Q => F5(15),
      R => '0'
    );
\F_reg[176]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(16),
      Q => F5(16),
      R => '0'
    );
\F_reg[177]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(17),
      Q => F5(17),
      R => '0'
    );
\F_reg[178]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(18),
      Q => F5(18),
      R => '0'
    );
\F_reg[179]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(19),
      Q => F5(19),
      R => '0'
    );
\F_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(17),
      Q => F0(17),
      R => '0'
    );
\F_reg[180]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(20),
      Q => F5(20),
      R => '0'
    );
\F_reg[181]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(21),
      Q => F5(21),
      R => '0'
    );
\F_reg[182]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(22),
      Q => F5(22),
      R => '0'
    );
\F_reg[183]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(23),
      Q => F5(23),
      R => '0'
    );
\F_reg[184]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(24),
      Q => F5(24),
      R => '0'
    );
\F_reg[185]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(25),
      Q => F5(25),
      R => '0'
    );
\F_reg[186]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(26),
      Q => F5(26),
      R => '0'
    );
\F_reg[187]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(27),
      Q => F5(27),
      R => '0'
    );
\F_reg[188]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(28),
      Q => F5(28),
      R => '0'
    );
\F_reg[189]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(29),
      Q => F5(29),
      R => '0'
    );
\F_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(18),
      Q => F0(18),
      R => '0'
    );
\F_reg[190]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(30),
      Q => F5(30),
      R => '0'
    );
\F_reg[191]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_4(31),
      Q => F5(31),
      R => '0'
    );
\F_reg[192]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(0),
      Q => F6(0),
      R => '0'
    );
\F_reg[193]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(1),
      Q => F6(1),
      R => '0'
    );
\F_reg[194]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(2),
      Q => F6(2),
      R => '0'
    );
\F_reg[195]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(3),
      Q => F6(3),
      R => '0'
    );
\F_reg[196]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(4),
      Q => F6(4),
      R => '0'
    );
\F_reg[197]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(5),
      Q => F6(5),
      R => '0'
    );
\F_reg[198]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(6),
      Q => F6(6),
      R => '0'
    );
\F_reg[199]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(7),
      Q => F6(7),
      R => '0'
    );
\F_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(19),
      Q => F0(19),
      R => '0'
    );
\F_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(1),
      Q => F0(1),
      R => '0'
    );
\F_reg[200]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(8),
      Q => F6(8),
      R => '0'
    );
\F_reg[201]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(9),
      Q => F6(9),
      R => '0'
    );
\F_reg[202]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(10),
      Q => F6(10),
      R => '0'
    );
\F_reg[203]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(11),
      Q => F6(11),
      R => '0'
    );
\F_reg[204]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(12),
      Q => F6(12),
      R => '0'
    );
\F_reg[205]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(13),
      Q => F6(13),
      R => '0'
    );
\F_reg[206]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(14),
      Q => F6(14),
      R => '0'
    );
\F_reg[207]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(15),
      Q => F6(15),
      R => '0'
    );
\F_reg[208]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(16),
      Q => F6(16),
      R => '0'
    );
\F_reg[209]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(17),
      Q => F6(17),
      R => '0'
    );
\F_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(20),
      Q => F0(20),
      R => '0'
    );
\F_reg[210]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(18),
      Q => F6(18),
      R => '0'
    );
\F_reg[211]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(19),
      Q => F6(19),
      R => '0'
    );
\F_reg[212]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(20),
      Q => F6(20),
      R => '0'
    );
\F_reg[213]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(21),
      Q => F6(21),
      R => '0'
    );
\F_reg[214]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(22),
      Q => F6(22),
      R => '0'
    );
\F_reg[215]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(23),
      Q => F6(23),
      R => '0'
    );
\F_reg[216]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(24),
      Q => F6(24),
      R => '0'
    );
\F_reg[217]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(25),
      Q => F6(25),
      R => '0'
    );
\F_reg[218]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(26),
      Q => F6(26),
      R => '0'
    );
\F_reg[219]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(27),
      Q => F6(27),
      R => '0'
    );
\F_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(21),
      Q => F0(21),
      R => '0'
    );
\F_reg[220]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(28),
      Q => F6(28),
      R => '0'
    );
\F_reg[221]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(29),
      Q => F6(29),
      R => '0'
    );
\F_reg[222]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(30),
      Q => F6(30),
      R => '0'
    );
\F_reg[223]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_5(31),
      Q => F6(31),
      R => '0'
    );
\F_reg[224]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(0),
      Q => F7(0),
      R => '0'
    );
\F_reg[225]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(1),
      Q => F7(1),
      R => '0'
    );
\F_reg[226]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(2),
      Q => F7(2),
      R => '0'
    );
\F_reg[227]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(3),
      Q => F7(3),
      R => '0'
    );
\F_reg[228]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(4),
      Q => F7(4),
      R => '0'
    );
\F_reg[229]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(5),
      Q => F7(5),
      R => '0'
    );
\F_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(22),
      Q => F0(22),
      R => '0'
    );
\F_reg[230]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(6),
      Q => F7(6),
      R => '0'
    );
\F_reg[231]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(7),
      Q => F7(7),
      R => '0'
    );
\F_reg[232]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(8),
      Q => F7(8),
      R => '0'
    );
\F_reg[233]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(9),
      Q => F7(9),
      R => '0'
    );
\F_reg[234]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(10),
      Q => F7(10),
      R => '0'
    );
\F_reg[235]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(11),
      Q => F7(11),
      R => '0'
    );
\F_reg[236]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(12),
      Q => F7(12),
      R => '0'
    );
\F_reg[237]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(13),
      Q => F7(13),
      R => '0'
    );
\F_reg[238]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(14),
      Q => F7(14),
      R => '0'
    );
\F_reg[239]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(15),
      Q => F7(15),
      R => '0'
    );
\F_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(23),
      Q => F0(23),
      R => '0'
    );
\F_reg[240]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(16),
      Q => F7(16),
      R => '0'
    );
\F_reg[241]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(17),
      Q => F7(17),
      R => '0'
    );
\F_reg[242]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(18),
      Q => F7(18),
      R => '0'
    );
\F_reg[243]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(19),
      Q => F7(19),
      R => '0'
    );
\F_reg[244]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(20),
      Q => F7(20),
      R => '0'
    );
\F_reg[245]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(21),
      Q => F7(21),
      R => '0'
    );
\F_reg[246]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(22),
      Q => F7(22),
      R => '0'
    );
\F_reg[247]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(23),
      Q => F7(23),
      R => '0'
    );
\F_reg[248]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(24),
      Q => F7(24),
      R => '0'
    );
\F_reg[249]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(25),
      Q => F7(25),
      R => '0'
    );
\F_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(24),
      Q => F0(24),
      R => '0'
    );
\F_reg[250]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(26),
      Q => F7(26),
      R => '0'
    );
\F_reg[251]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(27),
      Q => F7(27),
      R => '0'
    );
\F_reg[252]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(28),
      Q => F7(28),
      R => '0'
    );
\F_reg[253]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(29),
      Q => F7(29),
      R => '0'
    );
\F_reg[254]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(30),
      Q => F7(30),
      R => '0'
    );
\F_reg[255]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_6(31),
      Q => F7(31),
      R => '0'
    );
\F_reg[256]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(0),
      Q => F8(0),
      R => '0'
    );
\F_reg[257]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(1),
      Q => F8(1),
      R => '0'
    );
\F_reg[258]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(2),
      Q => F8(2),
      R => '0'
    );
\F_reg[259]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(3),
      Q => F8(3),
      R => '0'
    );
\F_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(25),
      Q => F0(25),
      R => '0'
    );
\F_reg[260]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(4),
      Q => F8(4),
      R => '0'
    );
\F_reg[261]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(5),
      Q => F8(5),
      R => '0'
    );
\F_reg[262]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(6),
      Q => F8(6),
      R => '0'
    );
\F_reg[263]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(7),
      Q => F8(7),
      R => '0'
    );
\F_reg[264]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(8),
      Q => F8(8),
      R => '0'
    );
\F_reg[265]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(9),
      Q => F8(9),
      R => '0'
    );
\F_reg[266]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(10),
      Q => F8(10),
      R => '0'
    );
\F_reg[267]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(11),
      Q => F8(11),
      R => '0'
    );
\F_reg[268]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(12),
      Q => F8(12),
      R => '0'
    );
\F_reg[269]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(13),
      Q => F8(13),
      R => '0'
    );
\F_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(26),
      Q => F0(26),
      R => '0'
    );
\F_reg[270]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(14),
      Q => F8(14),
      R => '0'
    );
\F_reg[271]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(15),
      Q => F8(15),
      R => '0'
    );
\F_reg[272]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(16),
      Q => F8(16),
      R => '0'
    );
\F_reg[273]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(17),
      Q => F8(17),
      R => '0'
    );
\F_reg[274]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(18),
      Q => F8(18),
      R => '0'
    );
\F_reg[275]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(19),
      Q => F8(19),
      R => '0'
    );
\F_reg[276]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(20),
      Q => F8(20),
      R => '0'
    );
\F_reg[277]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(21),
      Q => F8(21),
      R => '0'
    );
\F_reg[278]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(22),
      Q => F8(22),
      R => '0'
    );
\F_reg[279]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(23),
      Q => F8(23),
      R => '0'
    );
\F_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(27),
      Q => F0(27),
      R => '0'
    );
\F_reg[280]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(24),
      Q => F8(24),
      R => '0'
    );
\F_reg[281]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(25),
      Q => F8(25),
      R => '0'
    );
\F_reg[282]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(26),
      Q => F8(26),
      R => '0'
    );
\F_reg[283]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(27),
      Q => F8(27),
      R => '0'
    );
\F_reg[284]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(28),
      Q => F8(28),
      R => '0'
    );
\F_reg[285]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(29),
      Q => F8(29),
      R => '0'
    );
\F_reg[286]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(30),
      Q => F8(30),
      R => '0'
    );
\F_reg[287]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_7(31),
      Q => F8(31),
      R => '0'
    );
\F_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(28),
      Q => F0(28),
      R => '0'
    );
\F_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(29),
      Q => F0(29),
      R => '0'
    );
\F_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(2),
      Q => F0(2),
      R => '0'
    );
\F_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(30),
      Q => F0(30),
      R => '0'
    );
\F_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(31),
      Q => F0(31),
      R => '0'
    );
\F_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(0),
      Q => F1(0),
      R => '0'
    );
\F_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(1),
      Q => F1(1),
      R => '0'
    );
\F_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(2),
      Q => F1(2),
      R => '0'
    );
\F_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(3),
      Q => F1(3),
      R => '0'
    );
\F_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(4),
      Q => F1(4),
      R => '0'
    );
\F_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(5),
      Q => F1(5),
      R => '0'
    );
\F_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(6),
      Q => F1(6),
      R => '0'
    );
\F_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(7),
      Q => F1(7),
      R => '0'
    );
\F_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(3),
      Q => F0(3),
      R => '0'
    );
\F_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(8),
      Q => F1(8),
      R => '0'
    );
\F_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(9),
      Q => F1(9),
      R => '0'
    );
\F_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(10),
      Q => F1(10),
      R => '0'
    );
\F_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(11),
      Q => F1(11),
      R => '0'
    );
\F_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(12),
      Q => F1(12),
      R => '0'
    );
\F_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(13),
      Q => F1(13),
      R => '0'
    );
\F_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(14),
      Q => F1(14),
      R => '0'
    );
\F_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(15),
      Q => F1(15),
      R => '0'
    );
\F_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(16),
      Q => F1(16),
      R => '0'
    );
\F_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(17),
      Q => F1(17),
      R => '0'
    );
\F_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(4),
      Q => F0(4),
      R => '0'
    );
\F_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(18),
      Q => F1(18),
      R => '0'
    );
\F_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(19),
      Q => F1(19),
      R => '0'
    );
\F_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(20),
      Q => F1(20),
      R => '0'
    );
\F_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(21),
      Q => F1(21),
      R => '0'
    );
\F_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(22),
      Q => F1(22),
      R => '0'
    );
\F_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(23),
      Q => F1(23),
      R => '0'
    );
\F_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(24),
      Q => F1(24),
      R => '0'
    );
\F_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(25),
      Q => F1(25),
      R => '0'
    );
\F_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(26),
      Q => F1(26),
      R => '0'
    );
\F_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(27),
      Q => F1(27),
      R => '0'
    );
\F_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(5),
      Q => F0(5),
      R => '0'
    );
\F_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(28),
      Q => F1(28),
      R => '0'
    );
\F_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(29),
      Q => F1(29),
      R => '0'
    );
\F_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(30),
      Q => F1(30),
      R => '0'
    );
\F_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_0(31),
      Q => F1(31),
      R => '0'
    );
\F_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(0),
      Q => F2(0),
      R => '0'
    );
\F_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(1),
      Q => F2(1),
      R => '0'
    );
\F_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(2),
      Q => F2(2),
      R => '0'
    );
\F_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(3),
      Q => F2(3),
      R => '0'
    );
\F_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(4),
      Q => F2(4),
      R => '0'
    );
\F_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(5),
      Q => F2(5),
      R => '0'
    );
\F_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(6),
      Q => F0(6),
      R => '0'
    );
\F_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(6),
      Q => F2(6),
      R => '0'
    );
\F_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(7),
      Q => F2(7),
      R => '0'
    );
\F_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(8),
      Q => F2(8),
      R => '0'
    );
\F_reg[73]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(9),
      Q => F2(9),
      R => '0'
    );
\F_reg[74]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(10),
      Q => F2(10),
      R => '0'
    );
\F_reg[75]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(11),
      Q => F2(11),
      R => '0'
    );
\F_reg[76]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(12),
      Q => F2(12),
      R => '0'
    );
\F_reg[77]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(13),
      Q => F2(13),
      R => '0'
    );
\F_reg[78]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(14),
      Q => F2(14),
      R => '0'
    );
\F_reg[79]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(15),
      Q => F2(15),
      R => '0'
    );
\F_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(7),
      Q => F0(7),
      R => '0'
    );
\F_reg[80]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(16),
      Q => F2(16),
      R => '0'
    );
\F_reg[81]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(17),
      Q => F2(17),
      R => '0'
    );
\F_reg[82]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(18),
      Q => F2(18),
      R => '0'
    );
\F_reg[83]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(19),
      Q => F2(19),
      R => '0'
    );
\F_reg[84]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(20),
      Q => F2(20),
      R => '0'
    );
\F_reg[85]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(21),
      Q => F2(21),
      R => '0'
    );
\F_reg[86]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(22),
      Q => F2(22),
      R => '0'
    );
\F_reg[87]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(23),
      Q => F2(23),
      R => '0'
    );
\F_reg[88]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(24),
      Q => F2(24),
      R => '0'
    );
\F_reg[89]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(25),
      Q => F2(25),
      R => '0'
    );
\F_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(8),
      Q => F0(8),
      R => '0'
    );
\F_reg[90]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(26),
      Q => F2(26),
      R => '0'
    );
\F_reg[91]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(27),
      Q => F2(27),
      R => '0'
    );
\F_reg[92]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(28),
      Q => F2(28),
      R => '0'
    );
\F_reg[93]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(29),
      Q => F2(29),
      R => '0'
    );
\F_reg[94]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(30),
      Q => F2(30),
      R => '0'
    );
\F_reg[95]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_1(31),
      Q => F2(31),
      R => '0'
    );
\F_reg[96]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(0),
      Q => F3(0),
      R => '0'
    );
\F_reg[97]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(1),
      Q => F3(1),
      R => '0'
    );
\F_reg[98]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(2),
      Q => F3(2),
      R => '0'
    );
\F_reg[99]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT_2(3),
      Q => F3(3),
      R => '0'
    );
\F_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => F,
      D => CNTR_OUT(9),
      Q => F0(9),
      R => '0'
    );
toggle_reg: unisim.vcomponents.FDRE
     port map (
      C => refclk,
      CE => '1',
      D => COUNTER_REFCLK_inst_n_2,
      Q => toggle,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    refclk : in STD_LOGIC;
    fin : in STD_LOGIC_VECTOR ( 8 downto 0 );
    F0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F2 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F3 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F4 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F5 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F6 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F7 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    F8 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    update : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "MercuryZX1_labtools_fmeter_0_0,labtools_fmeter,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "labtools_fmeter,Vivado 2019.1";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  attribute x_interface_info : string;
  attribute x_interface_info of refclk : signal is "xilinx.com:signal:clock:1.0 refclk CLK";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of refclk : signal is "XIL_INTERFACENAME refclk, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN MercuryZX1_processing_system7_1_0_FCLK_CLK0, INSERT_VIP 0";
begin
U0: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_labtools_fmeter
     port map (
      F0(31 downto 0) => F0(31 downto 0),
      F1(31 downto 0) => F1(31 downto 0),
      F2(31 downto 0) => F2(31 downto 0),
      F3(31 downto 0) => F3(31 downto 0),
      F4(31 downto 0) => F4(31 downto 0),
      F5(31 downto 0) => F5(31 downto 0),
      F6(31 downto 0) => F6(31 downto 0),
      F7(31 downto 0) => F7(31 downto 0),
      F8(31 downto 0) => F8(31 downto 0),
      fin(8 downto 0) => fin(8 downto 0),
      refclk => refclk,
      update => update
    );
end STRUCTURE;
