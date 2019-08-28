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
set_property PACKAGE_PIN Y16 [get_ports IO_MIO48_B12_Y16]
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
set_property IOSTANDARD LVCMOS25 [get_ports IO_MIO48_B12_Y16]
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
# eof
# -------------------------------------------------------------------------------------------------