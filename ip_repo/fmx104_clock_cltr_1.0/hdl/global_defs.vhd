library ieee;
use ieee.std_logic_1164.all;
 
package global_defs is
 
    type t_ad9510_gc_settings is record    -- clock generator
       init              : std_logic;  
       auto_update_en    : std_logic;                             --Control leftjustify
       vco_pd            : std_logic;                             --Control IDLEAYs
       ref_pd            : std_logic;                             --Pattern Error Clear (write '1' to clear)
       read, write       : std_logic;
       data              : std_logic_vector(31 downto 0);
    end record t_ad9510_gc_settings;
    constant t_ad9510_gc_settings_init : t_ad9510_gc_settings := ( 
                    init => '1', ref_pd => '0', vco_pd => '0',
                    auto_update_en => '0', read => '0', write =>  '0', data => (others => '0')
    );
    
    type t_ads95xx_settings is record    -- clock generator
       init              : std_logic;  
       reset             : std_logic;                             --Pattern Error Clear (write '1' to clear)
       adc_select        : std_logic_vector(3 downto 0);
    end record t_ads95xx_settings;
    constant t_ads95xx_settings_init : t_ads95xx_settings := ( 
                    init => '1', reset => '0', adc_select => (others=> '0')
    );
    
end package global_defs;