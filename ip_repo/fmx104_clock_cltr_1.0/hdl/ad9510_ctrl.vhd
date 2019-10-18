----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2019 10:32:22
-- Design Name: 
-- Module Name: ad9510_ctrl - Behavioral
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

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_misc.all;
  use ieee.std_logic_unsigned.all;
library unisim;
  use unisim.vcomponents.all;
use work.global_defs.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ad9510_ctrl is
    port (
        rst             : in  std_logic;
        clk             : in  std_logic;
        gc_settings     : in  t_ad9510_gc_settings;
        gc_settings_awk : out std_logic;
          -- Sequence interface
        init_ena        : in  std_logic;
        init_done       : out std_logic;
          -- SPI control
        spi_n_dat_oe    : out std_logic;
        spi_n_clk_oe    : out std_logic;
        spi_n_cs        : out std_logic;
        spi_sclk        : out std_logic;
        spi_sdo         : out std_logic;
        spi_sdi         : in  std_logic
    );
end ad9510_ctrl;

architecture Behavioral of ad9510_ctrl is

type sh_states is (idle, instruct, data_io, sh_done, update, update_instruct, update_data_io);
signal sh_state       : sh_states;

signal sclk_prebuf    : std_logic;
signal serial_clk     : std_logic;
signal sclk_ext       : std_logic;

signal done_sclk      : std_logic;
signal init_done_sclk : std_logic;
signal init_done_tmp  : std_logic;
signal init_done_prev : std_logic;

signal init           : std_logic;
signal init_tmp       : std_logic;
signal init_reg       : std_logic;


signal inst_val       : std_logic;
signal inst_reg_val   : std_logic;
signal inst_rw        : std_logic;
signal inst_reg       : std_logic_vector(12 downto 0);
signal data_reg       : std_logic_vector(7 downto 0);

signal sh_counter     : integer;
signal shifting       : std_logic;
signal read_n_write   : std_logic;
signal ncs_int        : std_logic;
signal busy           : std_logic;
signal sdi            : std_logic;

signal auto_update    : std_logic;
signal shift_reg      : std_logic_vector(23 downto 0);
signal init_address   : std_logic_vector(5 downto 0);
signal init_data      : std_logic_vector(15 downto 0);

signal serial_done  : std_logic;
signal serial_done_sig  : std_logic;
signal data_read      : std_logic_vector(7 downto 0);



component ad9510_init_mem is
port (
  clka  : in  std_logic;
  addra : in  std_logic_vector(5 downto 0);
  douta : out std_logic_vector(15 downto 0)
);
end component ad9510_init_mem;

constant ADDR_CTRL    : std_logic_vector(27 downto 0) := x"000005C";
constant ADDR_GLOBAL  : std_logic_vector(27 downto 0) := x"000005B";
constant ADDR_MAX_WR  : std_logic_vector(27 downto 0) := x"000005A";
constant ADDR_MAX_RD  : std_logic_vector(27 downto 0) := x"000005A";
begin
----------------------------------------------------------------------------------------------------
-- Capture data in on rising edge SCLK
-- therefore freeze the signal on the falling edge of serial clock.
----------------------------------------------------------------------------------------------------
process (serial_clk)
begin
  if (falling_edge(serial_clk)) then
    sdi <= spi_sdi;
  end if;
end process;


----------------------------------------------------------------------------------------------------
-- Generate serial clock (max 25MHz)
----------------------------------------------------------------------------------------------------
process (clk)
  -- Divide by 2^4 = 16, CLKmax = 16 x 25MHz = 400MHz
  variable clk_div : std_logic_vector(3 downto 0) := (others => '0');
begin
  if (rising_edge(clk)) then
    clk_div    := clk_div + '1';
    -- The slave samples the data on the rising edge of SCLK.
    -- therefore we make sure the external clock is slightly
    -- after the internal clock.
    sclk_ext    <= clk_div(clk_div'length-1);
    sclk_prebuf <= sclk_ext;
  end if;
end process;

bufg_sclk : bufg
port map (
  i => sclk_prebuf,
  o => serial_clk
);


----------------------------------------------------------------------------------------------------
-- Commect to initialization memory 
----------------------------------------------------------------------------------------------------
ad9510_init_mem_inst : ad9510_init_mem
port map (
  clka  => serial_clk,
  addra => init_address,
  douta => init_data
);


----------------------------------------------------------------------------------------------------
-- AD9510 instruction & data shift register
----------------------------------------------------------------------------------------------------

process (rst, serial_clk)
begin
  if (rst = '1') then

    auto_update    <= '0';
    shift_reg      <= (others => '0');
    init_address   <= (others => '0');
    done_sclk      <= '0';
    init_done_sclk <= '0';
    serial_done  <= '0';
    data_read      <= (others => '0');

  elsif (rising_edge(serial_clk)) then

    if (init_reg = '1' and shifting = '0') then
      auto_update  <= '0';
      shift_reg    <= '0' & "00" & "00000" & init_data(15 downto 0);
      -- Stop when update instruction is reveived (= last instruction)
      if (init_data(15 downto 8) = ADDR_MAX_WR) then
        init_address <= (others => '0');
        done_sclk    <= '1';
      else
        init_address <= init_address + 1;
        done_sclk    <= '0';
      end if;
    elsif (inst_reg_val = '1' and init_reg = '0') then
      auto_update <= gc_settings.auto_update_en;
      shift_reg   <= inst_rw & "00" & inst_reg & data_reg;
    elsif (sh_state = update) then
      shift_reg <= '0' & "00" & "0" & ADDR_MAX_WR(11 downto 0) & x"01";
    elsif (shifting = '1') then
      shift_reg <= shift_reg(shift_reg'length-2 downto 0) & sdi;
    end if;

    if (done_sclk = '0') then
      init_done_sclk <= '0';
    elsif (sh_state = idle) then
      init_done_sclk <= '1';
    end if;

     -- Data read from device
    if (sh_state = sh_done) then
      serial_done <= '1';
    else
      serial_done <= '0';
    end if;
    -- Data read from AD9510
    if (sh_state = sh_done and read_n_write = '1') then
      --data_read     <= shift_reg(8 downto 1); -- at this stage already one bit has shifted in too much
      data_read     <= shift_reg(7 downto 0);
    else
      data_read     <= data_read;
    end if;

  end if;
end process;


----------------------------------------------------------------------------------------------------
-- Shoot commands to the AD9510 state machine
----------------------------------------------------------------------------------------------------

process (rst, clk)
begin
  if (rst = '1') then

    init_done      <= '0';
    init_done_tmp  <= '0';
    init_done_prev <= '0';
    init           <= '0';
    inst_val       <= '0';
    inst_rw        <= '0';
    inst_reg       <= (others=> '0');
    data_reg       <= (others=> '0');
    
  elsif (rising_edge(clk)) then

    init_done      <= init_done_sclk;

    init_done_tmp  <= done_sclk;
    init_done_prev <= init_done_tmp;

    -- Release the init flag on rising edge init done
    if (init_done_tmp = '1' and init_done_prev = '0') then
      init <= '0';
    -- Enable the init flag when enable flag is high, but done flag is low
    elsif (init_ena = '1' and init_done_tmp = '0') then
      init <= '1';
    -- There is one additional status and control register available
    elsif (gc_settings.init = '1') then
      init <= gc_settings.init;
      gc_settings_awk <= '1';
    end if;


    -- Write instruction, only when address is within AD9510 range
    -- TODO: inst_val needs to be transfered to inst_reg_val
    -- TODO: done singnal needs to be transferred
    if (gc_settings.write = '1' and gc_settings.data(15 downto 0) <= ADDR_MAX_WR) then
      inst_val <= '1';
      inst_rw  <= '0'; -- write
      inst_reg <= gc_settings.data(12 downto 0);
      data_reg <= gc_settings.data(7 downto 0);
    -- Read instruction, only when address is within AD9510 range
    -- Not fully implemeted
    elsif (gc_settings.read = '1' and gc_settings.data(15 downto 0) <= ADDR_MAX_RD) then
      inst_val <= '1';
      inst_rw  <= '1'; -- read
      inst_reg <= gc_settings.data(12 downto 0);
      data_reg <= data_reg;
    -- No instruction
    else
      inst_val <= '0';
      inst_rw  <= inst_rw;
      inst_reg <= inst_reg;
      data_reg <= data_reg;
    end if;

  end if;
end process;

----------------------------------------------------------------------------------------------------
-- AD9510 serial interface state-machine
----------------------------------------------------------------------------------------------------

process (rst, serial_clk)
begin
  if (rst = '1') then

    init_tmp     <= '0';
    init_reg     <= '0';
    sh_state     <= idle;
    sh_counter   <= 0;
    shifting     <= '0';
    read_n_write <= '0';
    ncs_int      <= '1';
  elsif (rising_edge(serial_clk)) then

    -- Double synchonise flag from other clock domain
    init_tmp <= init;
    init_reg <= init_tmp;

    -- Main state machine
    case sh_state is

      when idle =>
        sh_counter <= shift_reg'length-data_reg'length-1; --total length minus data bytes;
        -- Accept every instruction
        if (inst_reg_val = '1' or init_reg = '1') then
          shifting     <= '1';
          read_n_write <= inst_rw and not init_reg; -- force write during init
          ncs_int      <= '0';
          sh_state     <= instruct;
        else
          shifting     <= '0';
          ncs_int      <= '1';
        end if;
        
      when instruct =>
        if (sh_counter = 0) then
          sh_counter <= data_reg'length-1;
          sh_state   <= data_io;
        else
          sh_counter <= sh_counter - 1;
        end if;

      when data_io =>
        if (sh_counter = 0) then
          sh_counter <= shift_reg'length-data_reg'length-1; --total length minus data bytes;
          shifting   <= '0';
          ncs_int    <= '1';
          if (read_n_write = '1') then
            sh_state <= sh_done;
          elsif (auto_update = '0') then
            sh_state <= sh_done;
                       
          else
            sh_state <= update;
          end if;
        else
          sh_counter <= sh_counter - 1;
        end if;

      when sh_done =>
        sh_state <= idle;

      when update =>
        sh_counter <= shift_reg'length-8-1; --total length minus one data byte
        shifting   <= '1';
        ncs_int    <= '0';
        sh_state   <= update_instruct;

      when update_instruct =>
        if (sh_counter = 0) then
          sh_counter <= 7;
          sh_state   <= update_data_io;
        else
          sh_counter <= sh_counter - 1;
        end if;

      when update_data_io =>
        if (sh_counter = 0) then
          sh_counter <= shift_reg'length-8-1; --total length minus one data byte
          shifting   <= '0';
          ncs_int    <= '1';
          sh_state <= sh_done;
        else
          sh_counter <= sh_counter - 1;
        end if;

      when others =>
        sh_state <= idle;

    end case;

  end if;
end process;

busy <= '0' when (sh_state = idle and init_reg = '0') else '1';



spi_n_dat_oe <= '1' when (sh_state = data_io and read_n_write = '1') else ncs_int;
spi_n_clk_oe <= ncs_int;
spi_n_cs     <= ncs_int;
spi_sclk     <= not sclk_ext when ncs_int = '0' else '0';
spi_sdo      <= 'Z' when (sh_state = data_io and read_n_write = '1') else shift_reg(shift_reg'length - 1);
end Behavioral;
