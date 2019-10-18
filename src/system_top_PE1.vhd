---------------------------------------------------------------------------------------------------
-- Project          : Mercury ZX1 Reference Design
-- File description : Top Level
-- File name        : system_top_PE1.vhd
-- Author           : Gian Koeppel
---------------------------------------------------------------------------------------------------
-- Copyright (c) 2017 by Enclustra GmbH, Switzerland. All rights are reserved. 
-- Unauthorized duplication of this document, in whole or in part, by any means is prohibited
-- without the prior written permission of Enclustra GmbH, Switzerland.
-- 
-- Although Enclustra GmbH believes that the information included in this publication is correct
-- as of the date of publication, Enclustra GmbH reserves the right to make changes at any time
-- without notice.
-- 
-- All information in this document may only be published by Enclustra GmbH, Switzerland.
---------------------------------------------------------------------------------------------------
-- Description:
-- This is a top-level file for Mercury ZX1 Reference Design
--    
---------------------------------------------------------------------------------------------------
-- File history:
--
-- Version | Date       | Author           | Remarks
-- ------------------------------------------------------------------------------------------------
-- 1.0     | 02.02.2015 | G. Koeppel       | First released version
-- 2.0     | 20.10.2017 | D. Ungureanu     | Consistency checks
-- 3.0     | 29.11.2017 | D. Duerner       | Add blinking LED
-- 4.0     | 12.03.2018 | R. Locher        | Fixed Led to Gpio assignment
--
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- libraries
---------------------------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library unisim;
    use unisim.vcomponents.all;

---------------------------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------------------------

entity system_top is
	port (
	
		-------------------------------------------------------------------------------------------
		-- processor system
		-------------------------------------------------------------------------------------------
		
		DDR_addr						: inout std_logic_vector ( 14 downto 0 );
		DDR_ba							: inout std_logic_vector ( 2 downto 0 );
		DDR_cas_n						: inout std_logic;
		DDR_ck_n						: inout std_logic;
		DDR_ck_p						: inout std_logic;
		DDR_cke							: inout std_logic;
		DDR_cs_n						: inout std_logic;
		DDR_dm							: inout std_logic_vector ( 3 downto 0 );
		DDR_dq							: inout std_logic_vector ( 31 downto 0 );
		DDR_dqs_n						: inout std_logic_vector ( 3 downto 0 );
		DDR_dqs_p						: inout std_logic_vector ( 3 downto 0 );
		DDR_odt							: inout std_logic;
		DDR_ras_n						: inout std_logic;
		DDR_reset_n						: inout std_logic;
		DDR_we_n						: inout std_logic;

		FIXED_IO_ddr_vrn				: inout std_logic;
		FIXED_IO_ddr_vrp				: inout std_logic;
		FIXED_IO_mio					: inout std_logic_vector ( 53 downto 0 );
		FIXED_IO_ps_clk					: inout std_logic;
		FIXED_IO_ps_porb				: inout std_logic;
		FIXED_IO_ps_srstb				: inout std_logic;
		
		-------------------------------------------------------------------------------------------
		-- io bank 12
		-------------------------------------------------------------------------------------------
		
		IO_MIO40_SDCLK_B12_AA13			: inout std_logic;
		IO_MIO41_SDCMD_B12_AA12			: inout std_logic;
		IO_MIO42_SDD0_B12_AB17			: inout std_logic;
		IO_MIO43_SDD1_B12_AB16			: inout std_logic;
		IO_MIO44_SDD2_B12_AC17			: inout std_logic;
		IO_MIO45_SDD3_B12_AC16			: inout std_logic;
		IO_MIO46_UARTRX_B12_AA15		: inout std_logic;
		IO_MIO47_UARTTX_B12_AA14		: inout std_logic;
		IO_MIO48_B12_Y16				: inout std_logic;
		IO_MIO49_B12_Y15				: inout std_logic;
		IO_MIO50_B12_W16				: inout std_logic;
		IO_MIO51_B12_W15				: inout std_logic;

		DDR3_VSEL						: inout std_logic;
		
		ETH1A_LED_N_PL		: inout std_logic;
		ETH1B_LED_N_PL		: inout std_logic;

		-------------------------------------------------------------------------------------------
		-- io bank 13
		-------------------------------------------------------------------------------------------

		-------------------------------------------------------------------------------------------
		-- io bank 33
		-------------------------------------------------------------------------------------------

		-------------------------------------------------------------------------------------------
		-- io bank 34		
		-------------------------------------------------------------------------------------------				
					
		ETH0_INT_N_PL 					: inout std_logic;
								
		-------------------------------------------------------------------------------------------
		-- DDR3 PL
		-------------------------------------------------------------------------------------------
		DDR3_dq 						: inout std_logic_vector ( 15 downto 0 );
		DDR3_dqs_p 						: inout std_logic_vector ( 1 downto 0 );
		DDR3_dqs_n 						: inout std_logic_vector ( 1 downto 0 );
		DDR3_addr 						: out std_logic_vector ( 13 downto 0 );
		DDR3_ba 						: out std_logic_vector ( 2 downto 0 );
		DDR3_ras_n 						: out std_logic;
		DDR3_cas_n 						: out std_logic;
		DDR3_we_n 						: out std_logic;
		DDR3_reset_n 					: out std_logic;
		DDR3_ck_p 						: out std_logic_vector ( 0 to 0 );
		DDR3_ck_n 						: out std_logic_vector ( 0 to 0 );
		DDR3_cke 						: out std_logic_vector ( 0 to 0 );
		DDR3_dm 						: out std_logic_vector ( 1 downto 0 );
		DDR3_odt 						: out std_logic_vector ( 0 to 0 );
				
		-------------------------------------------------------------------------------------------
		-- i2c							
		-------------------------------------------------------------------------------------------
										
		I2C_INT_N						: inout std_logic;
		I2C_SCL							: inout std_logic;
		I2C_SDA							: inout std_logic;
										
		-------------------------------------------------------------------------------------------
		-- 200mhz clock
		-------------------------------------------------------------------------------------------
		CLK200_P 						: in std_logic;
		CLK200_N 						: in std_logic;
		
		-------------------------------------------------------------------------------------------
		-- led		
		-------------------------------------------------------------------------------------------
        adc_clk_p, adc_clk_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
        cha_n, cha_p : in STD_LOGIC_VECTOR ( 6 downto 0 );
        chc_n, chc_p : in STD_LOGIC_VECTOR ( 6 downto 0 );
        che_n, che_p : in STD_LOGIC_VECTOR ( 6 downto 0 );
        chg_n, chg_p : in STD_LOGIC_VECTOR ( 6 downto 0 );
        
        ad9510_clk, ad9510_csn : out STD_LOGIC;
        ad9510_mosi : out STD_LOGIC;
        VCO_PWR_EN : out std_logic;
        
        
        MGT_RCLK0_PCIE_REFCLK_clk_n : in STD_LOGIC_VECTOR ( 0 to 0 );
        MGT_RCLK0_PCIE_REFCLK_clk_p : in STD_LOGIC_VECTOR ( 0 to 0 );
        PCIE_MGT_rxn : in STD_LOGIC_VECTOR ( 3 downto 0 );
        PCIE_MGT_rxp : in STD_LOGIC_VECTOR ( 3 downto 0 );
        PCIE_MGT_txn : out STD_LOGIC_VECTOR ( 3 downto 0 );
        PCIE_MGT_txp : out STD_LOGIC_VECTOR ( 3 downto 0 );
        PCIE_PERST : in STD_LOGIC;

		Led_N							: out	std_logic_vector(2 downto 0)
	);
end;

---------------------------------------------------------------------------------------------------
-- architecture declaration
---------------------------------------------------------------------------------------------------

architecture rtl of system_top is

	component MercuryZX1 is
		port (
			DDR_cas_n			: inout std_logic;
			DDR_cke				: inout std_logic;
			DDR_ck_n			: inout std_logic;
			DDR_ck_p			: inout std_logic;
			DDR_cs_n			: inout std_logic;
			DDR_reset_n 		: inout std_logic;
			DDR_odt				: inout std_logic;
			DDR_ras_n 			: inout std_logic;
			DDR_we_n 			: inout std_logic;
			DDR_ba 				: inout std_logic_vector ( 2 downto 0 );
			DDR_addr 			: inout std_logic_vector ( 14 downto 0 );
			DDR_dm 				: inout std_logic_vector ( 3 downto 0 );
			DDR_dq 				: inout std_logic_vector ( 31 downto 0 );
			DDR_dqs_n 			: inout std_logic_vector ( 3 downto 0 );
			DDR_dqs_p 			: inout std_logic_vector ( 3 downto 0 );
			FIXED_IO_mio 		: inout std_logic_vector ( 53 downto 0 );
			FIXED_IO_ddr_vrn 	: inout std_logic;
			FIXED_IO_ddr_vrp 	: inout std_logic;
			FIXED_IO_ps_srstb 	: inout std_logic;
			FIXED_IO_ps_clk 	: inout std_logic;
			FIXED_IO_ps_porb 	: inout std_logic;

			SDIO0_CDN           : in  STD_LOGIC;
			SDIO0_WP            : in  STD_LOGIC;			

			IRQ0 				: in std_logic_vector ( 0 to 0 );
            IRQ1                : in std_logic_vector ( 0 to 0 );
    
			IIC_0_sda_i 		: in std_logic;
			IIC_0_sda_o 		: out std_logic;
			IIC_0_sda_t 		: out std_logic;
			IIC_0_scl_i 		: in std_logic;
			IIC_0_scl_o 		: out std_logic;
			IIC_0_scl_t 		: out std_logic;
			gpio_tri_o 			: out std_logic_vector ( 7 downto 0 );
			
			DDR3_dq 			: inout std_logic_vector ( 15 downto 0 );
			DDR3_dqs_p 			: inout std_logic_vector ( 1 downto 0 );
			DDR3_dqs_n 			: inout std_logic_vector ( 1 downto 0 );
			DDR3_addr 			: out std_logic_vector ( 13 downto 0 );
			DDR3_ba 			: out std_logic_vector ( 2 downto 0 );
			DDR3_ras_n 			: out std_logic;
			DDR3_cas_n 			: out std_logic;
			DDR3_we_n 			: out std_logic;
			DDR3_reset_n 		: out std_logic;
			DDR3_ck_p 			: out std_logic_vector ( 0 to 0 );
			DDR3_ck_n 			: out std_logic_vector ( 0 to 0 );
			DDR3_cke 			: out std_logic_vector ( 0 to 0 );
			DDR3_dm 			: out std_logic_vector ( 1 downto 0 );
			DDR3_odt 			: out std_logic_vector ( 0 to 0 );
			
			SYS_CLK_clk_n		: in std_logic;
			SYS_CLK_clk_p		: in std_logic;
			
            
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
            spi_sck_i : in STD_LOGIC;
            spi_sck_o : out STD_LOGIC;
            spi_sdi_i : in STD_LOGIC;
            spi_sdo_i : in STD_LOGIC;
            spi_sdo_o : out STD_LOGIC;
            spi_ss_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
            spi_ss_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
            VCO_PWR_EN : out std_logic;
            
            
            MGT_RCLK0_PCIE_REFCLK_clk_n : in STD_LOGIC_VECTOR ( 0 to 0 );
            MGT_RCLK0_PCIE_REFCLK_clk_p : in STD_LOGIC_VECTOR ( 0 to 0 );
            PCIE_MGT_rxn : in STD_LOGIC_VECTOR ( 3 downto 0 );
            PCIE_MGT_rxp : in STD_LOGIC_VECTOR ( 3 downto 0 );
            PCIE_MGT_txn : out STD_LOGIC_VECTOR ( 3 downto 0 );
            PCIE_MGT_txp : out STD_LOGIC_VECTOR ( 3 downto 0 );
            PCIE_PERST : in STD_LOGIC;
			
			FCLK_CLK1 			: out std_logic;
			ClkAdc : in STD_LOGIC;
			RESET_N 			: out std_logic
		);
	end component MercuryZX1;

  component adc_aquire_data is
    generic (
      RESOLUTION        : integer := 14;
      IDENTIFICATION    : integer := 0;
      CH0_IDELAY    : integer := 0;
      CH1_IDELAY    : integer := 0
    );
  Port ( 
    -- Master Clock/reset
      RESET               : in  std_logic;
      CLOCK               : in  std_logic;
    -- output data
      Ch_0_Data           : out std_logic_vector(RESOLUTION-1 downto 0);
      Ch_0_IsValid        : out std_logic;
    
    
      -- Channel A & B input
      Clk_ADC_p          : in  std_logic;
      Clk_ADC_n          : in  std_logic;
      Ch0_p             : in  std_logic_vector(RESOLUTION/2-1 downto 0);
      ch0_n             : in  std_logic_vector(RESOLUTION/2-1 downto 0);
      
      -- Others Status & Control
      
      ADC_Clk_Out            : out std_logic;
      ADC_0_ERROR            : out std_logic;
      
      INC, DEC               : in  std_logic;
      ADC_0_ERROR_CLR        : in  std_logic
  
    );
  end component adc_aquire_data;
	-----------------------------------------------------------------------------------------------
	-- signals
	-----------------------------------------------------------------------------------------------

	signal Rst_Async_N,Rst_Async				: std_logic;
	signal RstChain					: std_logic_vector (7 downto 0) := (others => '0');
	signal Rst						: std_logic;
	signal Clk, Clk200              : std_logic;

	signal LedCnt					: unsigned (23 downto 0);

	signal Gpio						: std_logic_vector (7 downto 0);
	signal IIC_0_sda_i 				: std_logic;
	signal IIC_0_sda_o 				: std_logic;
	signal IIC_0_sda_t 				: std_logic;
	signal IIC_0_scl_i 				: std_logic;
	signal IIC_0_scl_o 				: std_logic;
	signal IIC_0_scl_t 				: std_logic;
		
	signal IRQ0 					: std_logic_vector (0 to 0);
	signal IRQ1 					: std_logic_vector (0 to 0);

	signal SDIO0_CDN_s      : std_logic := '0';
	signal SDIO0_WP_s       : std_logic := '1';


      signal adc_clock, adc_clk_buf	: std_logic_vector (4 downto 0) := (others => '0') ;
      signal spi_csn			: std_logic_vector (7 downto 0);
      
      signal spi_clk, spi_miso, spit_status, spi_out, spi_mosi, spi_enable0 : std_logic;
      
      type adc_input is array (0 to 4) of std_logic_vector(6 downto 0);
      type adc_output is array (0 to 4) of std_logic_vector(13 downto 0);
      signal adc_data_p : adc_input := (others => (others => '0'));
      signal adc_data_n : adc_input := (others => (others => '0'));
      signal adc_data_out : adc_output := (others => (others => '0'));
      signal adc_valid			: std_logic_vector (3 downto 0);
      signal adc_error			: std_logic_vector (3 downto 0);
      signal adc_err_clr			: std_logic_vector (3 downto 0);
      signal adc_delay_inc			: std_logic_vector (3 downto 0);
      signal adc_delay_dec			: std_logic_vector (3 downto 0);
begin
	
	-----------------------------------------------------------------------------------------------
	-- processor system
	-----------------------------------------------------------------------------------------------
	
  ad9510_csn  <= spi_csn(0);
  ad9510_clk  <= spi_clk     when (spi_csn(0) = '0') else '0';
  ad9510_mosi <= spi_mosi    when (spi_csn(0) = '0') else '0';
  spi_miso <= spi_mosi;
  
  adc_data_n(0) <= cha_n;
  adc_data_n(1) <= chc_n;
  adc_data_n(2) <= che_n;
  adc_data_n(3) <= chg_n;
  adc_data_p(0) <= cha_p;
  adc_data_p(1) <= chc_p;
  adc_data_p(2) <= che_p;
  adc_data_p(3) <= chg_p;
  Rst_Async <= not Rst_Async_N;
  --VCO_PWR_EN  <= '1';
CLK_GEN: for I in 0 to 3 generate
   INX:  adc_aquire_data 
   generic map (
      IDENTIFICATION => I
    )
   port map (
    --  O => adc_clock(I),  -- Buffer output
    --  I => adc_clk_p(I),  -- Diff_p buffer input (connect directly to top-level port)
    --  IB => adc_clk_n(I) -- Diff_n buffer input (connect directly to top-level port)
       RESET           => Rst_Async,
      CLOCK            => Clk200,
    -- output data
      Ch_0_Data        => adc_data_out(I),
      Ch_0_IsValid     => adc_valid(I),
    
    
      Clk_ADC_p       => adc_clk_p(I),
      Clk_ADC_n       => adc_clk_n(I),
      Ch0_p           => adc_data_p(I),
      ch0_n           => adc_data_n(I),
          
      -- output clock
      ADC_Clk_Out     => adc_clock(I),
      
      -- error
      ADC_0_ERROR     => adc_error(I),
      DEC             => adc_delay_dec(I), 
      INC             => adc_delay_inc(I),
      ADC_0_ERROR_CLR => adc_err_clr(I)
      
   );
end generate CLK_GEN;

	i_system : MercuryZX1
		port map (
		ClkAdc => adc_clock(0),
			DDR3_addr			=> DDR3_addr,
			DDR3_ba				=> DDR3_ba,
			DDR3_cas_n 			=> DDR3_cas_n,
			DDR3_ck_n			=> DDR3_ck_n,
			DDR3_ck_p			=> DDR3_ck_p,
			DDR3_cke			=> DDR3_cke,
			DDR3_dm				=> DDR3_dm,
			DDR3_dq				=> DDR3_dq,
			DDR3_dqs_n			=> DDR3_dqs_n,
			DDR3_dqs_p			=> DDR3_dqs_p,
			DDR3_odt			=> DDR3_odt,
			DDR3_ras_n			=> DDR3_ras_n,
			DDR3_reset_n 		=> DDR3_reset_n,
			DDR3_we_n			=> DDR3_we_n,
			
			DDR_addr			=> DDR_addr,
			DDR_ba				=> DDR_ba,
			DDR_cas_n			=> DDR_cas_n,
			DDR_ck_n			=> DDR_ck_n,
			DDR_ck_p			=> DDR_ck_p,
			DDR_cke				=> DDR_cke,
			DDR_cs_n			=> DDR_cs_n,
			DDR_dm				=> DDR_dm,
			DDR_dq				=> DDR_dq,
			DDR_dqs_n			=> DDR_dqs_n,
			DDR_dqs_p			=> DDR_dqs_p,
			DDR_odt				=> DDR_odt,
			DDR_ras_n			=> DDR_ras_n,
			DDR_reset_n 		=> DDR_reset_n,
			DDR_we_n			=> DDR_we_n,
			
			FIXED_IO_ddr_vrn	=> FIXED_IO_ddr_vrn,
			FIXED_IO_ddr_vrp	=> FIXED_IO_ddr_vrp,
			FIXED_IO_mio		=> FIXED_IO_mio,
			FIXED_IO_ps_clk 	=> FIXED_IO_ps_clk,
			FIXED_IO_ps_porb 	=> FIXED_IO_ps_porb,
			FIXED_IO_ps_srstb 	=> FIXED_IO_ps_srstb,
			
			SDIO0_CDN           => SDIO0_CDN_s,
			SDIO0_WP            => SDIO0_WP_s, 

			IRQ0				=> IRQ0,
            IRQ1                => IRQ1,
			
			FCLK_CLK1			=> Clk,
			
			IIC_0_scl_i 		=> iic_0_scl_i,
			IIC_0_scl_o 		=> iic_0_scl_o,
			IIC_0_scl_t 		=> iic_0_scl_t,
			IIC_0_sda_i 		=> iic_0_sda_i,
			IIC_0_sda_o 		=> iic_0_sda_o,
			IIC_0_sda_t 		=> iic_0_sda_t,
			
			RESET_N				=> Rst_Async_N,
			
			SYS_CLK_clk_n		=> CLK200_N,
			SYS_CLK_clk_p		=> CLK200_P,
			
			Clk200 => Clk200,
			adc_clock => adc_clock,
			adc_clear_error(3 downto 0) => adc_err_clr(3 downto 0),
          adc_data_in_a(13 downto 0) => adc_data_out(0),
          adc_data_in_b(13 downto 0) => adc_data_out(1),
          adc_data_in_c(13 downto 0) => adc_data_out(2),
          adc_data_in_d(13 downto 0) => adc_data_out(3),
          adc_delay_dec(3 downto 0) => adc_delay_dec(3 downto 0),
          adc_delay_inc(3 downto 0) => adc_delay_inc(3 downto 0),
          adc_error(3 downto 0) => adc_error(3 downto 0),
          adc_valid(3 downto 0) => adc_valid(3 downto 0),
			
          spi_sck_i => spi_clk,
          spi_sck_o => spi_clk,
          spi_sdi_i => spi_miso,
          spi_sdo_i => spi_mosi,
          spi_sdo_o => spi_mosi,
          spi_ss_i(7 downto 0) => spi_csn(7 downto 0),
          spi_ss_o(7 downto 0) => spi_csn(7 downto 0),
          
            MGT_RCLK0_PCIE_REFCLK_clk_n => MGT_RCLK0_PCIE_REFCLK_clk_n,
            MGT_RCLK0_PCIE_REFCLK_clk_p => MGT_RCLK0_PCIE_REFCLK_clk_p,
            PCIE_MGT_rxn => PCIE_MGT_rxn,
            PCIE_MGT_rxp => PCIE_MGT_rxp,
            PCIE_MGT_txn => PCIE_MGT_txn,
            PCIE_MGT_txp => PCIE_MGT_txp,
            PCIE_PERST   => PCIE_PERST,
			
			VCO_PWR_EN => VCO_PWR_EN,
			gpio_tri_o			=> Gpio
		);
		

	ETH1A_LED_N_PL			<= 'Z';
	ETH1B_LED_N_PL			<= 'Z';
		
	-- tristate buffer for I2C
	I2C_SDA				 	<= IIC_0_sda_o when IIC_0_sda_t = '0' else 'Z';
	IIC_0_sda_i 		 	<= I2C_SDA;
	I2C_SCL				    <= IIC_0_scl_o when IIC_0_scl_t = '0' else 'Z';
	IIC_0_scl_i			 	<= I2C_SCL;
	
	I2C_INT_N			   	<= 'Z';
	
	DDR3_VSEL		        <= 'Z'; -- VCC_DDR3 = 1.5V
	ETH0_INT_N_PL		    <= 'Z';
	
	IRQ0(0)                	<= 	not I2C_INT_N;
	IRQ1(0)                	<= 	not ETH0_INT_N_PL;
	
	-----------------------------------------------------------------------------------------------
	-- reset
	-----------------------------------------------------------------------------------------------
	
	-- synchronize reset
	process (Clk, Rst_Async_N)
	begin
		if Rst_Async_N = '0' then
			RstChain <= (others => '0');
		elsif rising_edge (Clk) then
			RstChain <= '1' & RstChain (RstChain'left downto 1);
		end if;
	end process;
	Rst <= not RstChain (0);
	
	------------------------------------------------------------------------------------------------
    -- Blinking LED counter & LED assignment
    ------------------------------------------------------------------------------------------------
   
	process (Clk)
	begin
		if rising_edge (Clk) then
			if Rst = '1' then
				LedCnt <= (others => '0');
			else
				LedCnt <= LedCnt + 1;
			end if;
		end if;
	end process;
	Led_N(0)		<= not Gpio(0);	
	
	Led_N(1)		<= not LedCnt(LedCnt'high-1); -- 2 times faster
	Led_N(2) 		<= not LedCnt(LedCnt'high);	
		
	-------------------------------------------------------------------------------------------
	-- unused IOs
	-------------------------------------------------------------------------------------------
	
	-- io bank 12
	IO_MIO40_SDCLK_B12_AA13			<= 'Z';
	IO_MIO41_SDCMD_B12_AA12			<= 'Z';
	IO_MIO42_SDD0_B12_AB17			<= 'Z';
	IO_MIO43_SDD1_B12_AB16			<= 'Z';
	IO_MIO44_SDD2_B12_AC17			<= 'Z';
	IO_MIO45_SDD3_B12_AC16			<= 'Z';
	IO_MIO46_UARTRX_B12_AA15		<= 'Z';
	IO_MIO47_UARTTX_B12_AA14		<= 'Z';
	IO_MIO48_B12_Y16				<= 'Z';
	IO_MIO49_B12_Y15				<= 'Z';
	IO_MIO50_B12_W16				<= 'Z';
	IO_MIO51_B12_W15				<= 'Z';
	
end;

---------------------------------------------------------------------------------------------------
-- eof
---------------------------------------------------------------------------------------------------
