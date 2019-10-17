-- (c) Copyright 1995-2019 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: trenz.biz:user:labtools_fmeter:1.0
-- IP Revision: 19

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MercuryZX1_labtools_fmeter_0_0 IS
  PORT (
    refclk : IN STD_LOGIC;
    fin : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    F0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    F1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    F2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    F3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    F4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    F5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    F6 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    F7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    F8 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    update : OUT STD_LOGIC
  );
END MercuryZX1_labtools_fmeter_0_0;

ARCHITECTURE MercuryZX1_labtools_fmeter_0_0_arch OF MercuryZX1_labtools_fmeter_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF MercuryZX1_labtools_fmeter_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT labtools_fmeter IS
    GENERIC (
      C_CHANNELS : INTEGER;
      C_NUM_BITS : INTEGER;
      C_MODE : INTEGER;
      C_REFCLK_HZ : INTEGER
    );
    PORT (
      refclk : IN STD_LOGIC;
      fin : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      F0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F6 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F8 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F9 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F10 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F11 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F12 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F13 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F14 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F15 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F16 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F17 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F18 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F19 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F20 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F21 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F22 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F23 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F24 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F25 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F26 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F27 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F28 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F29 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F30 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      F31 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      update : OUT STD_LOGIC
    );
  END COMPONENT labtools_fmeter;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF refclk: SIGNAL IS "XIL_INTERFACENAME refclk, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN MercuryZX1_processing_system7_1_0_FCLK_CLK0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF refclk: SIGNAL IS "xilinx.com:signal:clock:1.0 refclk CLK";
BEGIN
  U0 : labtools_fmeter
    GENERIC MAP (
      C_CHANNELS => 9,
      C_NUM_BITS => 32,
      C_MODE => 0,
      C_REFCLK_HZ => 100000000
    )
    PORT MAP (
      refclk => refclk,
      fin => fin,
      F0 => F0,
      F1 => F1,
      F2 => F2,
      F3 => F3,
      F4 => F4,
      F5 => F5,
      F6 => F6,
      F7 => F7,
      F8 => F8,
      update => update
    );
END MercuryZX1_labtools_fmeter_0_0_arch;
