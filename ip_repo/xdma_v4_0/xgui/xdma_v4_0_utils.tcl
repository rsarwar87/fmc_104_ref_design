namespace eval xdma_v4_0_utils {

    proc upgrade_from_xdma_v3_1 {xciValues} {
      namespace import ::xcoUpgradeLib::*
      upvar $xciValues valueArray

      namespace forget ::xcoUpgradeLib::*
    }

    proc upgrade_from_xdma_v3_0 {xciValues} {
      namespace import ::xcoUpgradeLib::*
      upvar $xciValues valueArray

      set func_mode       [string compare -nocase [getParameter functional_mode valueArray] "AXI_Bridge"]
      set msi_vectors     [string compare -nocase [getParameter pf0_msi_cap_multimsgcap valueArray] "32_vectors"]
      set zynq_015        [string compare -nocase [getOption device valueArray] "xc7z015"]
      set zynq_015i       [string compare -nocase [getOption device valueArray] "xc7z015i"]
      set zynq_012s       [string compare -nocase [getOption device valueArray] "xc7z012s"]
      set speedgrade1     [string compare -nocase [getOption speedgrade valueArray] "-1"]
      set speedgrade1L    [string compare -nocase [getOption speedgrade valueArray] "-1L"]
      set axi_freq        [string compare -nocase [getParameter axisten_freq valueArray] "250"]
      set axi_width       [string compare -nocase [getParameter axi_data_width valueArray] "64_bit"]
      set link_width4     [string compare -nocase [getParameter pl_link_cap_max_link_width valueArray] "X4"]
      set link_speedgen2  [string compare -nocase [getParameter pl_link_cap_max_link_speed valueArray] "5.0_GT/s"]

      if {$func_mode == 0 && $msi_vectors == 0 } { 
        setParameter pf0_msi_cap_multimsgcap "16_vectors" valueArray
      } 

      if {($zynq_015 == 0  || $zynq_015i == 0 || $zynq_012s == 0) && $axi_freq == 0} { 
        setParameter axisten_freq 125 valueArray
      }
  
      if {($zynq_015 == 0  || $zynq_015i == 0 || $zynq_012s == 0) && $axi_freq == 0 && $axi_width == 0 && $link_width4 == 0 && $link_speedgen2 == 0} { 
        setParameter axi_data_width "128_bit" valueArray
      }

      set virtexup     [string compare -nocase [getOption architecture valueArray] "virtexuplus"]
      set kintexup     [string compare -nocase [getOption architecture valueArray] "kintexuplus"]
      set zynqup       [string compare -nocase [getOption architecture valueArray] "zynquplus"]
      set zynquprfsoc  [string compare -nocase [getOption architecture valueArray] "zynquplusrfsoc"]
      set core_clk     [string compare -nocase [getParameter coreclk_freq valueArray] "250"]
      set link_width   [string compare -nocase [getParameter pl_link_cap_max_link_width valueArray] "X8"]
      set link_speed   [string compare -nocase [getParameter pl_link_cap_max_link_speed valueArray] "8.0_GT/s"]
        
      set link_width_x16   [string compare -nocase [getParameter pl_link_cap_max_link_width valueArray] "X16"]
      set speedgrade1      [string compare -nocase [getOption speedgrade valueArray] "-1"]
      set speedgrade1L     [string compare -nocase [getOption speedgrade valueArray] "-1L"]
      set speedgrade1LV    [string compare -nocase [getOption speedgrade valueArray] "-1LV"]
      set speedgrade2LV    [string compare -nocase [getOption speedgrade valueArray] "-2LV"]

      if {($virtexup == 0 || $kintexup == 0 || $zynqup == 0 || $zynquprfsoc == 0) && $core_clk == 0 && $link_width == 0 && $link_speed == 0} { 
        setParameter coreclk_freq "500" valueArray
      } 

      if {($virtexup == 0 || $kintexup == 0 || $zynqup == 0 || $zynquprfsoc == 0) && $link_width == 0 && $link_speed == 0 && ($speedgrade1 == 0 || $speedgrade1L == 0 || $speedgrade1LV == 0 || $speedgrade2LV == 0)} { 
        setParameter pl_link_cap_max_link_width "X4" valueArray
        setParameter axi_data_width "128_bit" valueArray
      } 

      if {($virtexup == 0 || $kintexup == 0 || $zynqup == 0 || $zynquprfsoc == 0) && $link_width_x16 == 0 && $link_speed == 0 && $speedgrade1 == 0} { 
        setParameter pl_link_cap_max_link_width "X4" valueArray
        setParameter axi_data_width "128_bit" valueArray
      } 

      namespace forget ::xcoUpgradeLib::*
    }

    proc upgrade_from_xdma_v2_0 {xciValues} {
      namespace import ::xcoUpgradeLib::*
      upvar $xciValues valueArray
 
      if {[getParameter INS_LOSS_NYQ valueArray] < 15} { 
        addParameter ins_loss_profile "Chip-to-Chip" valueArray
        setParameter ins_loss_profile "Chip-to-Chip" valueArray
      } elseif {[getParameter INS_LOSS_NYQ valueArray] < 20 } { 
        addParameter ins_loss_profile "Add-in_Card" valueArray
        setParameter ins_loss_profile "Add-in_Card" valueArray
      } elseif {[getParameter INS_LOSS_NYQ valueArray] > 19} {
        addParameter ins_loss_profile "Backplane" valueArray
        setParameter ins_loss_profile "Backplane" valueArray
      }
       
      namespace forget ::xcoUpgradeLib::*
    }

    proc upgrade_from_xdma_v1_0 {xciValues} {
      namespace import ::xcoUpgradeLib::*
      upvar $xciValues valueArray

      if {[getParameter INS_LOSS_NYQ valueArray] < 15} { 
        addParameter ins_loss_profile "Chip-to-Chip" valueArray
        setParameter ins_loss_profile "Chip-to-Chip" valueArray
      } elseif {[getParameter INS_LOSS_NYQ valueArray] < 20 } { 
        addParameter ins_loss_profile "Add-in_Card" valueArray
        setParameter ins_loss_profile "Add-in_Card" valueArray
      } elseif {[getParameter INS_LOSS_NYQ valueArray] > 19} {
        addParameter ins_loss_profile "Backplane" valueArray
        setParameter ins_loss_profile "Backplane" valueArray
      }

      addParameter mcap_enablement None valueArray
      addParameter ext_startup_primitive false valueArray
      removeParameter tandem_mode valueArray
      removeParameter en_ext_startup valueArray

      namespace forget ::xcoUpgradeLib::*
   }
}   
