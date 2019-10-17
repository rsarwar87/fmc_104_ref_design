--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
--Date        : Thu Oct 17 12:31:53 2019
--Host        : ukaea-fpga running 64-bit KDE neon User Edition 5.16
--Command     : generate_target MercuryZX1_wrapper.bd
--Design      : MercuryZX1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity MercuryZX1_wrapper is
  port (
    Clk200 : out STD_LOGIC;
    DDR3_addr : out STD_LOGIC_VECTOR ( 13 downto 0 );
    DDR3_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR3_cas_n : out STD_LOGIC;
    DDR3_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_dm : out STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_dq : inout STD_LOGIC_VECTOR ( 15 downto 0 );
    DDR3_dqs_n : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_dqs_p : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_ras_n : out STD_LOGIC;
    DDR3_reset_n : out STD_LOGIC;
    DDR3_we_n : out STD_LOGIC;
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FCLK_CLK1 : out STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    IIC_0_scl_io : inout STD_LOGIC;
    IIC_0_sda_io : inout STD_LOGIC;
    IRQ0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    IRQ1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    RESET_N : out STD_LOGIC;
    SDIO0_CDN : in STD_LOGIC;
    SDIO0_WP : in STD_LOGIC;
    SYS_CLK_clk_n : in STD_LOGIC;
    SYS_CLK_clk_p : in STD_LOGIC;
    VCO_PWR_EN : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_clear_error : out STD_LOGIC_VECTOR ( 3 downto 0 );
    adc_clock : in STD_LOGIC_VECTOR ( 4 downto 0 );
    adc_data_in_a : in STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_data_in_b : in STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_data_in_c : in STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_data_in_d : in STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_delay_dec : out STD_LOGIC_VECTOR ( 3 downto 0 );
    adc_delay_inc : out STD_LOGIC_VECTOR ( 3 downto 0 );
    adc_error : in STD_LOGIC_VECTOR ( 3 downto 0 );
    adc_valid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    gpio_tri_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    spi_sck_i : in STD_LOGIC;
    spi_sck_o : out STD_LOGIC;
    spi_sdi_i : in STD_LOGIC;
    spi_sdo_i : in STD_LOGIC;
    spi_sdo_o : out STD_LOGIC;
    spi_ss_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    spi_ss_o : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
end MercuryZX1_wrapper;

architecture STRUCTURE of MercuryZX1_wrapper is
  component MercuryZX1 is
  port (
    spi_sck_i : in STD_LOGIC;
    spi_sck_o : out STD_LOGIC;
    spi_sdi_i : in STD_LOGIC;
    spi_sdo_i : in STD_LOGIC;
    spi_sdo_o : out STD_LOGIC;
    spi_ss_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    spi_ss_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    Clk200 : out STD_LOGIC;
    adc_clear_error : out STD_LOGIC_VECTOR ( 3 downto 0 );
    adc_clock : in STD_LOGIC_VECTOR ( 4 downto 0 );
    adc_data_in_a : in STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_data_in_b : in STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_data_in_c : in STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_data_in_d : in STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_delay_dec : out STD_LOGIC_VECTOR ( 3 downto 0 );
    adc_delay_inc : out STD_LOGIC_VECTOR ( 3 downto 0 );
    adc_error : in STD_LOGIC_VECTOR ( 3 downto 0 );
    adc_valid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    FCLK_CLK1 : out STD_LOGIC;
    IRQ0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    IRQ1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    RESET_N : out STD_LOGIC;
    SDIO0_CDN : in STD_LOGIC;
    SDIO0_WP : in STD_LOGIC;
    SYS_CLK_clk_p : in STD_LOGIC;
    SYS_CLK_clk_n : in STD_LOGIC;
    gpio_tri_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    DDR3_dq : inout STD_LOGIC_VECTOR ( 15 downto 0 );
    DDR3_dqs_p : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_dqs_n : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_addr : out STD_LOGIC_VECTOR ( 13 downto 0 );
    DDR3_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR3_ras_n : out STD_LOGIC;
    DDR3_cas_n : out STD_LOGIC;
    DDR3_we_n : out STD_LOGIC;
    DDR3_reset_n : out STD_LOGIC;
    DDR3_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_dm : out STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    IIC_0_sda_i : in STD_LOGIC;
    IIC_0_sda_o : out STD_LOGIC;
    IIC_0_sda_t : out STD_LOGIC;
    IIC_0_scl_i : in STD_LOGIC;
    IIC_0_scl_o : out STD_LOGIC;
    IIC_0_scl_t : out STD_LOGIC;
    VCO_PWR_EN : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component MercuryZX1;
  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;
  signal IIC_0_scl_i : STD_LOGIC;
  signal IIC_0_scl_o : STD_LOGIC;
  signal IIC_0_scl_t : STD_LOGIC;
  signal IIC_0_sda_i : STD_LOGIC;
  signal IIC_0_sda_o : STD_LOGIC;
  signal IIC_0_sda_t : STD_LOGIC;
begin
IIC_0_scl_iobuf: component IOBUF
     port map (
      I => IIC_0_scl_o,
      IO => IIC_0_scl_io,
      O => IIC_0_scl_i,
      T => IIC_0_scl_t
    );
IIC_0_sda_iobuf: component IOBUF
     port map (
      I => IIC_0_sda_o,
      IO => IIC_0_sda_io,
      O => IIC_0_sda_i,
      T => IIC_0_sda_t
    );
MercuryZX1_i: component MercuryZX1
     port map (
      Clk200 => Clk200,
      DDR3_addr(13 downto 0) => DDR3_addr(13 downto 0),
      DDR3_ba(2 downto 0) => DDR3_ba(2 downto 0),
      DDR3_cas_n => DDR3_cas_n,
      DDR3_ck_n(0) => DDR3_ck_n(0),
      DDR3_ck_p(0) => DDR3_ck_p(0),
      DDR3_cke(0) => DDR3_cke(0),
      DDR3_dm(1 downto 0) => DDR3_dm(1 downto 0),
      DDR3_dq(15 downto 0) => DDR3_dq(15 downto 0),
      DDR3_dqs_n(1 downto 0) => DDR3_dqs_n(1 downto 0),
      DDR3_dqs_p(1 downto 0) => DDR3_dqs_p(1 downto 0),
      DDR3_odt(0) => DDR3_odt(0),
      DDR3_ras_n => DDR3_ras_n,
      DDR3_reset_n => DDR3_reset_n,
      DDR3_we_n => DDR3_we_n,
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      FCLK_CLK1 => FCLK_CLK1,
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      IIC_0_scl_i => IIC_0_scl_i,
      IIC_0_scl_o => IIC_0_scl_o,
      IIC_0_scl_t => IIC_0_scl_t,
      IIC_0_sda_i => IIC_0_sda_i,
      IIC_0_sda_o => IIC_0_sda_o,
      IIC_0_sda_t => IIC_0_sda_t,
      IRQ0(0) => IRQ0(0),
      IRQ1(0) => IRQ1(0),
      RESET_N => RESET_N,
      SDIO0_CDN => SDIO0_CDN,
      SDIO0_WP => SDIO0_WP,
      SYS_CLK_clk_n => SYS_CLK_clk_n,
      SYS_CLK_clk_p => SYS_CLK_clk_p,
      VCO_PWR_EN(0) => VCO_PWR_EN(0),
      adc_clear_error(3 downto 0) => adc_clear_error(3 downto 0),
      adc_clock(4 downto 0) => adc_clock(4 downto 0),
      adc_data_in_a(13 downto 0) => adc_data_in_a(13 downto 0),
      adc_data_in_b(13 downto 0) => adc_data_in_b(13 downto 0),
      adc_data_in_c(13 downto 0) => adc_data_in_c(13 downto 0),
      adc_data_in_d(13 downto 0) => adc_data_in_d(13 downto 0),
      adc_delay_dec(3 downto 0) => adc_delay_dec(3 downto 0),
      adc_delay_inc(3 downto 0) => adc_delay_inc(3 downto 0),
      adc_error(3 downto 0) => adc_error(3 downto 0),
      adc_valid(3 downto 0) => adc_valid(3 downto 0),
      gpio_tri_o(7 downto 0) => gpio_tri_o(7 downto 0),
      spi_sck_i => spi_sck_i,
      spi_sck_o => spi_sck_o,
      spi_sdi_i => spi_sdi_i,
      spi_sdo_i => spi_sdo_i,
      spi_sdo_o => spi_sdo_o,
      spi_ss_i(7 downto 0) => spi_ss_i(7 downto 0),
      spi_ss_o(7 downto 0) => spi_ss_o(7 downto 0)
    );
end STRUCTURE;
