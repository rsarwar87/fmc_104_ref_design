----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.07.2019 13:33:37
-- Design Name: 
-- Module Name: adc_aquire_data - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use ieee.std_logic_1164.all;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_misc.all;
  use ieee.std_logic_unsigned.all;
  
library unisim;
  use unisim.vcomponents.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity adc_aquire_data is
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
end adc_aquire_data;

architecture Behavioral of adc_aquire_data is

CONSTANT PATTERN0   : std_logic_vector(15 downto 0) := "0101010101010101";
CONSTANT PATTERN1   : std_logic_vector(15 downto 0) := "1010101010101010";

SIGNAL adc_clock_buf, adc_clock_in, adc_clock_out : std_logic := '0';

signal ch0_ddr      : std_logic_vector(RESOLUTION/2-1 downto 0);  -- Double Data Rate
signal ch0_ddr_dly  : std_logic_vector(RESOLUTION/2-1 downto 0);  -- Double Data Rate, delayed
signal ch0_sdr      : std_logic_vector(RESOLUTION-1 downto 0);    -- Single Data Rate
signal ch0_sdr_se   : std_logic_vector(15 downto 0); -- Single Data Rate, Sign extended
signal ch0_sdr_val, rd  : std_logic;
signal ch0_sdr_mux  : std_logic_vector(15 downto 0); -- Single Data Rate, Sign extended, (Multiplexed)


signal ch_adc_ddr     : std_logic_vector(RESOLUTION-1 downto 0); -- Double Data Rate, A&B muxed
signal ch_adc_ddr_dly : std_logic_vector(RESOLUTION-1 downto 0); -- Double Data Rate, A&B muxed, delayed

signal ce, tmpi, tmpd, pec, pec_out : std_logic_vector (1 downto 0);

signal INC_DELAY, INC_BUF, DEC_DELAY, DEC_BUF : std_logic := '0';
--attribute IODELAY_GROUP : STRING;
--attribute IODELAY_GROUP of <label_name>: label is "<iodelay_group_name>";

begin

onepulse: process(CLOCK) begin
    if (rising_edge(CLOCK)) then
        INC_DELAY <= INC;
        DEC_DELAY <= DEC;        
        INC_BUF <= (INC AND (NOT INC_DELAY));
        DEC_BUF <= (DEC AND (NOT DEC_DELAY));
    end if;
end process;

delayclrl: if IDENTIFICATION=0 generate
   IDELAYCTRL_inst : IDELAYCTRL
   port map (
      RDY => open,       -- 1-bit output: Ready output
      REFCLK => CLOCK, -- 1-bit input: Reference clock input
      RST => RESET        -- 1-bit input: Active high reset input
   );
end generate delayclrl;

ce(0) <= INC_BUF or DEC_BUF;

pec(0) <= ADC_0_ERROR_CLR;

  data_a: for i in 0 to RESOLUTION/2-1 generate

    -- Differantial input buffer
    ibufds_inst : ibufds
    generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "DIFF_HSTL_II_18"
    )
    port map (
      i  => Ch0_p(i),
      ib => Ch0_n(i),
      o  => ch0_ddr(i)
    );
    

    -- Input delay
    idelay_inst : idelaye2
    generic map (
      IDELAY_TYPE           => "VARIABLE",
      IDELAY_VALUE          => CH0_IDELAY,
      HIGH_PERFORMANCE_MODE => "TRUE",
      SIGNAL_PATTERN        => "DATA",
      REFCLK_FREQUENCY      => real(200),
      CINVCTRL_SEL          => "FALSE",
      PIPE_SEL              => "FALSE"
    )
    port map (
      c           => CLOCK,
      regrst      => RESET,
      ld          => RESET,
      ce          => ce(0),
      inc         => INC_BUF,
      cinvctrl    => '0',
      cntvaluein  => conv_std_logic_vector(CH0_IDELAY, 5),            
      idatain     => ch0_ddr(i),
      datain      => '0',
      ldpipeen    => '0',
      dataout     => ch0_ddr_dly(i),
      cntvalueout => open
    );

    -- DDR to SDR
    iddr_inst : iddr
    generic map (
      DDR_CLK_EDGE => "SAME_EDGE_PIPELINED"
    )
    port map (
      q1 => ch0_sdr(2*i),
      q2 => ch0_sdr(2*i+1),
      c  => adc_clock_out,
      ce => '1',
      d  => ch0_ddr_dly(i),
      r  => '0',
      s  => '0'
    );

  end generate data_a;
  


----------------------------------------------------------------------------------------------------
-- Clock input buffers; LVDS mode
----------------------------------------------------------------------------------------------------


  -- Differential input buffer
  ibufds_inst_ab : ibufds
  generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "DIFF_HSTL_II_18"
  )
  port map (
    i  => Clk_ADC_p,
    ib => Clk_ADC_n,
    o  => adc_clock_buf
  );


----------------------------------------------------------------------------------------------------
-- Clock drivers, route on regional clock nets
----------------------------------------------------------------------------------------------------
bufr_ab_inst : bufr
generic map (
  BUFR_DIVIDE => "BYPASS"
)
port map (
  ce => '1',
  clr=> '0',
  i  => adc_clock_buf,
  o  => adc_clock_in
);
bufg_ab_inst : bufg
port map (
  i  => adc_clock_in,
  o  => adc_clock_out
);

ADC_Clk_Out <= adc_clock_out;


----------------------------------------------------------------------------------------------------
-- Pattern check A
----------------------------------------------------------------------------------------------------
process (pec(0), adc_clock_out, RESET)
begin
  if (pec(0) = '1' or RESET = '1') then
    ADC_0_ERROR <= '0';
    pec_out(0) <= '0';
  elsif (rising_edge(adc_clock_out)) then
    if (ch0_sdr /= PATTERN0(RESOLUTION-1 downto 0)
        and ch0_sdr /= PATTERN1(RESOLUTION-1 downto 0)) then
      pec_out(0) <= '1';
    else 
      pec_out(0) <= pec_out(0);
    end if;
    ADC_0_ERROR <= pec_out(0);
  end if;
end process;

----------------------------------------------------------------------------------------------------
-- Register outputs
----------------------------------------------------------------------------------------------------
process (adc_clock_out, RESET)
begin
  if (RESET = '1') then
    Ch_0_Data <= (others => '0');
    Ch_0_IsValid <= '0';
  elsif (rising_edge(adc_clock_out)) then
    Ch_0_Data <= ch0_sdr;
    Ch_0_IsValid <= '1';
  end if;
end process;



end Behavioral;
