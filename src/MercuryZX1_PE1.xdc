# -------------------------------------------------------------------------------------------------
# -- Project          : Mercury ZX1 Reference Design
# -- File description : Pin assignment and timing constraints file for Mercury PE1
# -- File name        : MercuryZX1_PE1.xdc
# -- Author           : Gian Koeppel
# -------------------------------------------------------------------------------------------------
# -- Copyright (c) 2017 by Enclustra GmbH, Switzerland. All rights are reserved.
# -- Unauthorized duplication of this document, in whole or in part, by any means is prohibited
# -- without the prior written permission of Enclustra GmbH, Switzerland.
# --
# -- Although Enclustra GmbH believes that the information included in this publication is correct
# -- as of the date of publication, Enclustra GmbH reserves the right to make changes at any time
# -- without notice.
# --
# -- All information in this document may only be published by Enclustra GmbH, Switzerland.
# -------------------------------------------------------------------------------------------------
# -- Notes:
# -- The IO standards might need to be adapted to your design
# -------------------------------------------------------------------------------------------------
# -- File history:
# --
# -- Version | Date       | Author             | Remarks
# -- ----------------------------------------------------------------------------------------------
# -- 1.0     | 02.02.2015 | G. Koeppel         | First released version
# -- 2.0     | 20.10.2017 | D. Ungureanu       | Consistency checks
# --
# -------------------------------------------------------------------------------------------------

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]

# Add overtemperature power down option
set_property BITSTREAM.CONFIG.OVERTEMPPOWERDOWN ENABLE [current_design]

# Set false path to temperature register synchronizer
# Paths coming from registers on AXI clock to synchronizers (first flop) on MIG DDR controller clock

# #Verilog version
# set_false_path -from # 	[get_pins i_system/xadc_wiz_0/inst/AXI_XADC_CORE_I/temperature_update_inst/temp_out_reg[*]/C ] -to # 	[get_pins i_system/SDRAM/u_MercuryZX1_SDRAM_0_mig/temp_mon_enabled.u_tempmon/device_temp_sync_r1_reg[*]/D ]

#VHDL version
set_false_path -from [get_pins {i_system/xadc_wiz_0/U0/AXI_XADC_CORE_I/temperature_update_inst/temp_out_reg[*]/C}] -to [get_pins {i_system/SDRAM/u_MercuryZX1_SDRAM_0_mig/temp_mon_enabled.u_tempmon/device_temp_sync_r1_reg[*]/D}]


# -------------------------------------------------------------------------------------------------
# bank 12
# -------------------------------------------------------------------------------------------------
set_property PACKAGE_PIN W13 [get_ports I2C_SCL]
set_property PACKAGE_PIN Y13 [get_ports I2C_SDA]
set_property IOSTANDARD LVCMOS25 [get_ports I2C_SCL]
set_property IOSTANDARD LVCMOS25 [get_ports I2C_SDA]

set_property PACKAGE_PIN AA13 [get_ports IO_MIO40_SDCLK_B12_AA13]
set_property PACKAGE_PIN AA12 [get_ports IO_MIO41_SDCMD_B12_AA12]
set_property PACKAGE_PIN AB17 [get_ports IO_MIO42_SDD0_B12_AB17]
set_property PACKAGE_PIN AB16 [get_ports IO_MIO43_SDD1_B12_AB16]
set_property PACKAGE_PIN AC17 [get_ports IO_MIO44_SDD2_B12_AC17]
set_property PACKAGE_PIN AC16 [get_ports IO_MIO45_SDD3_B12_AC16]
set_property PACKAGE_PIN AA15 [get_ports IO_MIO46_UARTRX_B12_AA15]
set_property PACKAGE_PIN AA14 [get_ports IO_MIO47_UARTTX_B12_AA14]
set_property PACKAGE_PIN Y15 [get_ports IO_MIO49_B12_Y15]
set_property PACKAGE_PIN W16 [get_ports IO_MIO50_B12_W16]
set_property PACKAGE_PIN W15 [get_ports IO_MIO51_B12_W15]
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO40_SDCLK_B12_AA13]
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO41_SDCMD_B12_AA12]
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO42_SDD0_B12_AB17]
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO43_SDD1_B12_AB16]
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO44_SDD2_B12_AC17]
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO45_SDD3_B12_AC16]
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO46_UARTRX_B12_AA15]
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO47_UARTTX_B12_AA14]
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO49_B12_Y15]
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO50_B12_W16]
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO51_B12_W15]

set_property PACKAGE_PIN AD10 [get_ports DDR3_VSEL]
set_property IOSTANDARD LVCMOS25 [get_ports DDR3_VSEL]

# -------------------------------------------------------------------------------------------------
# bank 33
# -------------------------------------------------------------------------------------------------
set_property PACKAGE_PIN L5 [get_ports CLK200_P]
set_property PACKAGE_PIN L4 [get_ports CLK200_N]
set_property IOSTANDARD LVDS [get_ports CLK200_N]
set_property IOSTANDARD LVDS [get_ports CLK200_P]

# -------------------------------------------------------------------------------------------------
# bank 34
# -------------------------------------------------------------------------------------------------
set_property PACKAGE_PIN H7 [get_ports {Led_N[0]}]
set_property PACKAGE_PIN H6 [get_ports {Led_N[1]}]
set_property PACKAGE_PIN H9 [get_ports {Led_N[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Led_N[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Led_N[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Led_N[2]}]

set_property PACKAGE_PIN K10 [get_ports I2C_INT_N]
set_property IOSTANDARD LVCMOS18 [get_ports I2C_INT_N]

set_property PACKAGE_PIN G9 [get_ports DDR3_reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports DDR3_reset_n]

set_property PACKAGE_PIN K11 [get_ports ETH0_INT_N_PL]
set_property IOSTANDARD LVCMOS18 [get_ports ETH0_INT_N_PL]

# -------------------------------------------------------------------------------------------------
# fast ethernet
# -------------------------------------------------------------------------------------------------

# set_property PACKAGE_PIN W14 [get_ports ETH1_CLK]
# set_property PACKAGE_PIN W17 [get_ports ETH1_INT_PWDN_N]
# set_property PACKAGE_PIN AD14 [get_ports ETH1_MDC]
# set_property PACKAGE_PIN AD11 [get_ports ETH1_MDIO]
# set_property PACKAGE_PIN AF14 [get_ports ETH1_RESET_N]
# set_property PACKAGE_PIN J11 [get_ports ETH1A_COL_PL]
# set_property PACKAGE_PIN G6 [get_ports ETH1A_CRS_PL]
set_property PACKAGE_PIN J10 [get_ports ETH1A_LED_N_PL]
# set_property PACKAGE_PIN AC13 [get_ports ETH1A_RXCLK]
# set_property PACKAGE_PIN AE12 [get_ports {ETH1A_RXD[0]}]
# set_property PACKAGE_PIN AF12 [get_ports {ETH1A_RXD[1]}]
# set_property PACKAGE_PIN AE11 [get_ports {ETH1A_RXD[2]}]
# set_property PACKAGE_PIN AF10 [get_ports {ETH1A_RXD[3]}]
# set_property PACKAGE_PIN AE13 [get_ports ETH1A_RXDV]
# set_property PACKAGE_PIN AF13 [get_ports ETH1A_RXER]
# set_property PACKAGE_PIN AC12 [get_ports ETH1A_TXCLK]
# set_property PACKAGE_PIN AB12 [get_ports {ETH1A_TXD[0]}]
# set_property PACKAGE_PIN AC11 [get_ports {ETH1A_TXD[1]}]
# set_property PACKAGE_PIN AB11 [get_ports {ETH1A_TXD[2]}]
# set_property PACKAGE_PIN AB10 [get_ports {ETH1A_TXD[3]}]
# set_property PACKAGE_PIN AE10 [get_ports ETH1A_TXEN]
# set_property PACKAGE_PIN H11 [get_ports ETH1B_COL_PL]
# set_property PACKAGE_PIN G5 [get_ports ETH1B_CRS_PL]
set_property PACKAGE_PIN J9 [get_ports ETH1B_LED_N_PL]
# set_property PACKAGE_PIN AC14 [get_ports ETH1B_RXCLK]
# set_property PACKAGE_PIN AF15 [get_ports {ETH1B_RXD[0]}]
# set_property PACKAGE_PIN AE15 [get_ports {ETH1B_RXD[1]}]
# set_property PACKAGE_PIN AD15 [get_ports {ETH1B_RXD[2]}]
# set_property PACKAGE_PIN AE16 [get_ports {ETH1B_RXD[3]}]
# set_property PACKAGE_PIN AD13 [get_ports ETH1B_RXDV]
# set_property PACKAGE_PIN AB14 [get_ports ETH1B_RXER]
# set_property PACKAGE_PIN AB15 [get_ports ETH1B_TXCLK]
# set_property PACKAGE_PIN AD16 [get_ports {ETH1B_TXD[0]}]
# set_property PACKAGE_PIN AE17 [get_ports {ETH1B_TXD[1]}]
# set_property PACKAGE_PIN AA17 [get_ports {ETH1B_TXD[2]}]
# set_property PACKAGE_PIN Y17 [get_ports {ETH1B_TXD[3]}]
# set_property PACKAGE_PIN AF17 [get_ports ETH1B_TXEN]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1_CLK]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1_INT_PWDN_N]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1_MDC]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1_MDIO]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1_RESET_N]
# set_property IOSTANDARD LVCMOS18 [get_ports ETH1A_COL_PL]
# set_property IOSTANDARD LVCMOS18 [get_ports ETH1A_CRS_PL]
set_property IOSTANDARD LVCMOS18 [get_ports ETH1A_LED_N_PL]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1A_RXCLK]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1A_RXD[0]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1A_RXD[1]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1A_RXD[2]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1A_RXD[3]}]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1A_RXDV]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1A_RXER]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1A_TXCLK]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1A_TXD[0]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1A_TXD[1]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1A_TXD[2]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1A_TXD[3]}]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1A_TXEN]
# set_property IOSTANDARD LVCMOS18 [get_ports ETH1B_COL_PL]
# set_property IOSTANDARD LVCMOS18 [get_ports ETH1B_CRS_PL]
set_property IOSTANDARD LVCMOS18 [get_ports ETH1B_LED_N_PL]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1B_RXCLK]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1B_RXD[0]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1B_RXD[1]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1B_RXD[2]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1B_RXD[3]}]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1B_RXDV]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1B_RXER]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1B_TXCLK]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1B_TXD[0]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1B_TXD[1]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1B_TXD[2]}]
# set_property IOSTANDARD LVCMOS25 [get_ports {ETH1B_TXD[3]}]
# set_property IOSTANDARD LVCMOS25 [get_ports ETH1B_TXEN]


# -------------------------------------------------------------------------------------------------
# module internal
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# timing constraints
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# FMC 
# -------------------------------------------------------------------------------------------------
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN G7} [get_ports FMC_CLK0_M2C_P]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN F7} [get_ports FMC_CLK0_M2C_N]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN M6} [get_ports FMC_CLK1_M2C_P]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN M5} [get_ports VCO_PWR_EN]

set_property -dict {PACKAGE_PIN C8} [get_ports adc_clk_p[0]]
set_property -dict {PACKAGE_PIN C7} [get_ports adc_clk_n[0]]
set_property -dict {PACKAGE_PIN D6} [get_ports adc_clk_p[1]]
set_property -dict {PACKAGE_PIN C6} [get_ports adc_clk_n[1]]

set_property -dict {PACKAGE_PIN J4} [get_ports adc_clk_p[2]]
set_property -dict {PACKAGE_PIN J3} [get_ports adc_clk_n[2]]
set_property -dict {PACKAGE_PIN L3} [get_ports adc_clk_p[3]]
set_property -dict {PACKAGE_PIN K3} [get_ports adc_clk_n[3]]


set_property PACKAGE_PIN A2 [get_ports cha_n[2]]
set_property PACKAGE_PIN B2 [get_ports cha_p[2]]
set_property PACKAGE_PIN A5 [get_ports cha_n[1]]
set_property PACKAGE_PIN B6 [get_ports cha_p[1]]
set_property PACKAGE_PIN B4 [get_ports cha_n[0]]
set_property PACKAGE_PIN B5 [get_ports cha_p[0]]
set_property PACKAGE_PIN A3 [get_ports cha_n[4]]
set_property PACKAGE_PIN A4 [get_ports cha_p[4]]
set_property PACKAGE_PIN B1 [get_ports cha_n[3]]
set_property PACKAGE_PIN C2 [get_ports cha_p[3]]
set_property PACKAGE_PIN C3 [get_ports cha_n[5]]
set_property PACKAGE_PIN C4 [get_ports cha_p[5]]
set_property PACKAGE_PIN B9 [get_ports cha_n[6]]
set_property PACKAGE_PIN C9 [get_ports cha_p[6]]


set_property PACKAGE_PIN A7 [get_ports chc_n[3]]
set_property PACKAGE_PIN B7 [get_ports chc_p[3]]
set_property PACKAGE_PIN A8 [get_ports chc_n[2]]
set_property PACKAGE_PIN A9 [get_ports chc_p[2]]
set_property PACKAGE_PIN A10 [get_ports chc_n[0]]
set_property PACKAGE_PIN B10 [get_ports chc_p[0]]
set_property PACKAGE_PIN D8 [get_ports chc_n[1]]
set_property PACKAGE_PIN D9 [get_ports chc_p[1]]
set_property PACKAGE_PIN D5 [get_ports chc_n[4]]
set_property PACKAGE_PIN E6 [get_ports chc_p[4]]
set_property PACKAGE_PIN E5 [get_ports chc_n[6]]
set_property PACKAGE_PIN F5 [get_ports chc_p[6]]
set_property PACKAGE_PIN E8 [get_ports chc_n[5]]
set_property PACKAGE_PIN F9 [get_ports chc_p[5]]


set_property PACKAGE_PIN E7 [get_ports che_n[3]]
set_property PACKAGE_PIN F8 [get_ports che_p[3]]
set_property PACKAGE_PIN D3 [get_ports che_n[1]]
set_property PACKAGE_PIN D4 [get_ports che_p[1]]
set_property PACKAGE_PIN C1 [get_ports che_n[2]]
set_property PACKAGE_PIN D1 [get_ports che_p[2]]
set_property PACKAGE_PIN F2 [get_ports che_n[6]]
set_property PACKAGE_PIN G2 [get_ports che_p[6]]
set_property PACKAGE_PIN E1 [get_ports che_n[4]]
set_property PACKAGE_PIN E2 [get_ports che_p[4]]
set_property PACKAGE_PIN E3 [get_ports che_n[0]]
set_property PACKAGE_PIN F3 [get_ports che_p[0]]
set_property PACKAGE_PIN G1 [get_ports che_n[5]]
set_property PACKAGE_PIN H2 [get_ports che_p[5]]


set_property PACKAGE_PIN F4 [get_ports chg_n[2]]
set_property PACKAGE_PIN G4 [get_ports chg_p[2]]
set_property PACKAGE_PIN K1 [get_ports chg_n[3]]
set_property PACKAGE_PIN K2 [get_ports chg_p[3]]
set_property PACKAGE_PIN H1 [get_ports chg_n[1]]
set_property PACKAGE_PIN J1 [get_ports chg_p[1]]
set_property PACKAGE_PIN H3 [get_ports chg_n[4]]
set_property PACKAGE_PIN H4 [get_ports chg_p[4]]
set_property PACKAGE_PIN L2 [get_ports chg_n[0]]
set_property PACKAGE_PIN M2 [get_ports chg_p[0]]
set_property PACKAGE_PIN M1 [get_ports chg_n[5]]
set_property PACKAGE_PIN N1 [get_ports chg_p[5]]
set_property PACKAGE_PIN N2 [get_ports chg_n[6]]
set_property PACKAGE_PIN N3 [get_ports chg_p[6]]

set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN N4} [get_ports ad9510_clk]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN M4} [get_ports ad9510_mosi]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN K5} [get_ports ad9510_csn]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN J5} [get_ports FMC_LA_N[33]]

# -------------------------------------------------------------------------------------------------
# PE1_SW
# -------------------------------------------------------------------------------------------------
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN W19} [get_ports PE1_SW[3]]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN W18} [get_ports PE1_SW[3]]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN V18} [get_ports PE1_SW[2]]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN V19} [get_ports PE1_SW[1]]


# -------------------------------------------------------------------------------------------------
# PE1_LED
# -------------------------------------------------------------------------------------------------
#set_property -dict {PACKAGE_PIN AA5} [get_ports PE1_LED[3]] # ref clock 2 and 3
#set_property -dict {PACKAGE_PIN AA6} [get_ports PE1_LED[2]]
#set_property -dict {PACKAGE_PIN W5} [get_ports PE1_LED[1]]
#set_property -dict {PACKAGE_PIN W6} [get_ports PE1_LED[0]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN L7} [get_ports PE1_LED[3]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN M7} [get_ports PE1_LED[2]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN H8} [get_ports PE1_LED[1]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN J8} [get_ports PE1_LED[0]]
# -------------------------------------------------------------------------------------------------
# PE1_PB
# -------------------------------------------------------------------------------------------------
set_property -dict {IOSTANDARD LVCMOS25 PACKAGE_PIN Y11} [get_ports PE1_PB[3]]
set_property -dict {IOSTANDARD LVCMOS25 PACKAGE_PIN Y12} [get_ports PE1_PB[2]]
set_property -dict {IOSTANDARD LVCMOS25 PACKAGE_PIN AA10} [get_ports PE1_PB[1]]
set_property -dict {IOSTANDARD LVCMOS25 PACKAGE_PIN Y10} [get_ports PE1_PB[0]]


# -------------------------------------------------------------------------------------------------
# PMOD
# -------------------------------------------------------------------------------------------------

#set_property -dict {PACKAGE_PIN AE5} [get_ports PMOD_A[7]]
#set_property -dict {PACKAGE_PIN AE6} [get_ports PMOD_A[6]]
#set_property -dict {PACKAGE_PIN AF3} [get_ports PMOD_A[5]]
#set_property -dict {PACKAGE_PIN AF4} [get_ports PMOD_A[4]]
#set_property -dict {PACKAGE_PIN AD7} [get_ports PMOD_A[3]]
#set_property -dict {PACKAGE_PIN AD8} [get_ports PMOD_A[2]]
#set_property -dict {PACKAGE_PIN AF7} [get_ports PMOD_A[1]]
#set_property -dict {PACKAGE_PIN AF8} [get_ports PMOD_A[0]]

#set_property -dict {PACKAGE_PIN AD3} [get_ports PMOD_B[7]]
#set_property -dict {PACKAGE_PIN AD4} [get_ports PMOD_B[6]]
#set_property -dict {PACKAGE_PIN AC1} [get_ports PMOD_B[5]]
#set_property -dict {PACKAGE_PIN AC2} [get_ports PMOD_B[4]]
#set_property -dict {PACKAGE_PIN AC5} [get_ports PMOD_B[3]]
#set_property -dict {PACKAGE_PIN AC6} [get_ports PMOD_B[2]]
#set_property -dict {PACKAGE_PIN AE1} [get_ports PMOD_B[1]]
#set_property -dict {PACKAGE_PIN AE2} [get_ports PMOD_B[0]]

#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN G1} [get_ports PMOD_A[7]] -- No Connect
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN H1} [get_ports PMOD_A[6]] -- No Connect
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN N6} [get_ports PMOD_A[5]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN N7} [get_ports PMOD_A[4]]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN G2} [get_ports PMOD_A[3]] -- No Connect
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN G3} [get_ports PMOD_A[2]] -- No Connect
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN K7} [get_ports PMOD_A[1]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN K8} [get_ports PMOD_A[0]]

#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN F4} [get_ports PMOD_B[7]] -- No Connect
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN G4} [get_ports PMOD_B[6]] -- No Connect
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN J6} [get_ports PMOD_B[5]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN K6} [get_ports PMOD_B[4]]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN E3} [get_ports PMOD_B[3]] -- No Connect
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN E4} [get_ports PMOD_B[2]] -- No Connect
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN L8} [get_ports PMOD_B[1]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN M8} [get_ports PMOD_B[0]]

# -------------------------------------------------------------------------------------------------
# Anios 
# -------------------------------------------------------------------------------------------------
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AC21} [get_ports ANIOS_A_CLK[0]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AC22} [get_ports ANIOS_A_CLK[1]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AD24} [get_ports ANIOS_A[23]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AD23} [get_ports ANIOS_A[22]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AB25} [get_ports ANIOS_A[21]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AA25} [get_ports ANIOS_A[20]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AC26} [get_ports ANIOS_A[19]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AB26} [get_ports ANIOS_A[18]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AB24} [get_ports ANIOS_A[17]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AA24} [get_ports ANIOS_A[16]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AD26} [get_ports ANIOS_A[15]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AD25} [get_ports ANIOS_A[14]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AF25} [get_ports ANIOS_A[13]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AF24} [get_ports ANIOS_A[12]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AE26} [get_ports ANIOS_A[11]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AE25} [get_ports ANIOS_A[10]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AA18} [get_ports ANIOS_A[9]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN Y18} [get_ports ANIOS_A[8]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AD19} [get_ports ANIOS_A[7]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AD18} [get_ports ANIOS_A[6]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AE21} [get_ports ANIOS_A[5]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AE20} [get_ports ANIOS_A[4]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AF18} [get_ports ANIOS_A[3]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AE18} [get_ports ANIOS_A[2]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AF20} [get_ports ANIOS_A[1]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AF19} [get_ports ANIOS_A[0]]

set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN Y18} [get_ports ANIOS_B_CLK[0]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN Y19} [get_ports ANIOS_B_CLK[1]]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN Y11} [get_ports ANIOS_B[23]] # shared with Pb 3
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN Y12} [get_ports ANIOS_B[22]] # shared with Pb 2
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AA10} [get_ports ANIOS_B[21]] # shared with Pb 1
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN Y1} [get_ports ANIOS_B[20]] # shared with Pb  0
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN W19} [get_ports ANIOS_B[19]] # shared with Dip 4
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN W18} [get_ports ANIOS_B[18]] # shared with Dip 3
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN V18} [get_ports ANIOS_B[17]] # shared with Dip 2
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN V19} [get_ports ANIOS_B[16]]# shared with Dip 1 
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AA23} [get_ports ANIOS_B[15]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AA22} [get_ports ANIOS_B[14]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AF23} [get_ports ANIOS_B[13]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AE23} [get_ports ANIOS_B[12]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AF22} [get_ports ANIOS_B[11]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AE22} [get_ports ANIOS_B[10]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AH10} [get_ports ANIOS_B[9]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AG10} [get_ports ANIOS_B[8]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN Y20} [get_ports ANIOS_B[7]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN W20} [get_ports ANIOS_B[6]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AB20} [get_ports ANIOS_B[5]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AA20} [get_ports ANIOS_B[4]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AC19} [get_ports ANIOS_B[3]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AC18} [get_ports ANIOS_B[2]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AB19} [get_ports ANIOS_B[1]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AA19} [get_ports ANIOS_B[0]]
# -------------------------------------------------------------------------------------------------
# PCIe
# -------------------------------------------------------------------------------------------------
#----------
# reset
set_property PACKAGE_PIN Y16 [get_ports {PCIE_PERST}]
set_property IOSTANDARD LVCMOS25 [get_ports {PCIE_PERST}]
# Clock
set_property PACKAGE_PIN R6  [get_ports {MGT_RCLK0_PCIE_REFCLK_clk_p[0]}]
set_property PACKAGE_PIN R5  [get_ports {MGT_RCLK0_PCIE_REFCLK_clk_n[0]}]

set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxp[3]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxn[3]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txp[3]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txn[3]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxp[2]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxn[2]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txp[2]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txn[2]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxp[1]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxn[1]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txp[1]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txn[1]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxp[0]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxn[0]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txp[0]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txn[0]}]

set_property PACKAGE_PIN AB4 [get_ports {PCIE_MGT_rxp[0]}]
set_property PACKAGE_PIN Y4  [get_ports {PCIE_MGT_rxp[1]}]
set_property PACKAGE_PIN V4  [get_ports {PCIE_MGT_rxp[2]}]
set_property PACKAGE_PIN T4  [get_ports {PCIE_MGT_rxp[3]}]

set_property PACKAGE_PIN AB3 [get_ports {PCIE_MGT_rxn[0]}]
set_property PACKAGE_PIN Y3  [get_ports {PCIE_MGT_rxn[1]}]
set_property PACKAGE_PIN V3  [get_ports {PCIE_MGT_rxn[2]}]
set_property PACKAGE_PIN T3  [get_ports {PCIE_MGT_rxn[3]}]

set_property PACKAGE_PIN AA2 [get_ports {PCIE_MGT_txp[0]}]
set_property PACKAGE_PIN W2  [get_ports {PCIE_MGT_txp[1]}]
set_property PACKAGE_PIN U2  [get_ports {PCIE_MGT_txp[2]}]
set_property PACKAGE_PIN R2  [get_ports {PCIE_MGT_txp[3]}]

set_property PACKAGE_PIN AA1 [get_ports {PCIE_MGT_txn[0]}]
set_property PACKAGE_PIN W1  [get_ports {PCIE_MGT_txn[1]}]
set_property PACKAGE_PIN U1  [get_ports {PCIE_MGT_txn[2]}]
set_property PACKAGE_PIN R1  [get_ports {PCIE_MGT_txn[3]}]
# -------------------------------------------------------------------------------------------------
# eof
# -------------------------------------------------------------------------------------------------