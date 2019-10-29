package require xilinx::board 1.0
namespace import ::xilinx::board::*

proc update_MODELPARAM_VALUE.IS_BOARD_PROJECT {MODELPARAM_VALUE.IS_BOARD_PROJECT PROJECT_PARAM.BOARD } {
    if {${PROJECT_PARAM.BOARD} ne "" } {
        set_property value 1 ${MODELPARAM_VALUE.IS_BOARD_PROJECT}
    } else {
        set_property value 0 ${MODELPARAM_VALUE.IS_BOARD_PROJECT}
    }
}

proc init_params { IPINST PARAM_VALUE.PCIE_BOARD_INTERFACE PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.enable_gen4 PROJECT_PARAM.SPEEDGRADE PROJECT_PARAM.ARCHITECTURE} {
    set_property preset_proc "PCIE_BOARD_INTERFACE_PRESET" ${PARAM_VALUE.PCIE_BOARD_INTERFACE}
    set c_xfamily        [ getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set speed_grade    ${PROJECT_PARAM.SPEEDGRADE}

    if {$c_xfamily == "virtexuplus" || $c_xfamily == "kintexuplus" || $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
      if {$speed_grade == "-1L" || $speed_grade == "-1LV" || $speed_grade == "-2LV"} { 
        set_property range "2.5_GT/s,5.0_GT/s,8.0_GT/s" ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}
      } elseif {(([get_property value ${PARAM_VALUE.enable_gen4}]) && ($speed_grade == "-2" || $speed_grade == "-3"))} {
        set_property range "2.5_GT/s,5.0_GT/s,8.0_GT/s,16.0_GT/s" ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}
      } else { 
        set_property range "2.5_GT/s,5.0_GT/s,8.0_GT/s" ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}
      }
    }
}

proc init_meta_params {IPINST} {
  add_meta_param $IPINST -name type_ChangeInit -type string -value "0"
}

proc update_type_ChangeInit {IPINST PARAM_VALUE.device_port_type} {
  set value [expr [get_metaparam_value type_ChangeInit] + 1]
  return $value
}

proc PCIE_BOARD_INTERFACE_PRESET {IPINST PRESET_VALUE} {
    if { $PRESET_VALUE == "Custom" } {
        return ""
    }
    set board [::ipxit::get_project_property BOARD]
    set vlnv [get_property ipdef $IPINST]
    set preset_params [board_ip_presets $vlnv $PRESET_VALUE $board "pcie_7x_mgt"]
    if { $preset_params != "" } {
        return $preset_params
    } else {
        return ""
    }
}

proc init_gui {IPINST PROJECT_PARAM.BOARD} {
    ipgui::add_param  $IPINST -parent $IPINST -name Component_Name
    set_property show_ipsymbol true  [ipgui::get_canvasspec -of $IPINST]

    #set board [::ipxit::get_project_property BOARD]
    set board [string toupper ${PROJECT_PARAM.BOARD}]
    set c_board [lindex [split $board : ] 1 ]

    if { ${PROJECT_PARAM.BOARD} != "" } {
        set IS_BOARD_PROJECT 1
    } else {
        set IS_BOARD_PROJECT 0
    }
    set led_pins [list]
    if { $IS_BOARD_PROJECT == 1 } {
        set led_pins [::xilinx::board::get_board_part_led_pins]
    }
    if { [llength $led_pins] >= 3 } {
        puts "writing pins"
    } else {
        puts "not writing pins"
    }

    if {$c_board != "AC701" && $c_board != "VC707" && $c_board != "ZC706"} { 
      add_board_tab $IPINST
    } else { 
      send_msg INFO 1 "Board support is not available yet for the board $c_board" 
    }

    #############
    ############# TAB Basic - To include all Basic parameters 
    #############

    set BASIC  [ipgui::add_page $IPINST -parent $IPINST -name "BASIC" -layout vertical]
    set_property display_name "Basic" $BASIC
     
    set functional_mode [ipgui::add_param  $IPINST -parent $BASIC -name functional_mode -layout horizontal -widget comboBox]
    set_property display_name "Functional Mode" $functional_mode
    set_property tooltip "This parameter is to select the functional mode either DMA or AXI Bridge. Note that the AXI Bridge feature available only for UltraScale Plus family devices. For UltraScale and 7 series Gen3 family devices use the AXI Bridge for PCI Express Gen3 Subsystem IP from Viavdo catalog." $functional_mode

    set en_dma_and_bridge [ipgui::add_param  $IPINST -parent $BASIC -name en_dma_and_bridge -layout horizontal -widget checkBox]
    set_property display_name "" $en_dma_and_bridge
    set_property visible false $en_dma_and_bridge

    set en_mqdma [ipgui::add_param  $IPINST -parent $BASIC -name en_mqdma -layout horizontal -widget checkBox]
    set_property display_name "" $en_mqdma
    set_property visible false $en_mqdma

    set en_bridge [ipgui::add_param  $IPINST -parent $BASIC -name en_bridge -layout horizontal -widget checkBox]
    set_property display_name "" $en_bridge
    set_property visible false $en_bridge

    set mode_selection [ipgui::add_param  $IPINST -parent $BASIC -name mode_selection  -layout horizontal -widget comboBox]
    set_property display_name  "Mode " $mode_selection
    set_property tooltip "This parameter is to select the Basic or Advanced mode user parameter options" $mode_selection

    set split_dma [ ipgui::add_param  $IPINST -parent $BASIC -name "split_dma" ]
    set_property display_name  "Split DMA IP"  $split_dma  
    set_property tooltip  "Enables XDMA only IP delivery without the PCIe IP"  $split_dma  
    set_property visible false $split_dma

    set enable_ccix [ipgui::add_param $IPINST -parent $BASIC -name enable_ccix -widget comboBox] 
    set_property display_name "AXIS CCIX Interface" $enable_ccix
    set_property visible false $enable_ccix

    set enable_gen4 [ipgui::add_param $IPINST -parent $BASIC -name enable_gen4]
    set_property visible false $enable_gen4

    set gen4_eieos_0s7 [ipgui::add_param $IPINST -parent $BASIC -name gen4_eieos_0s7]
    set_property visible false $gen4_eieos_0s7

    set pipe_line_stage [ipgui::add_param  $IPINST -parent $BASIC -name "pipe_line_stage" -layout horizontal -widget comboBox]
    set_property display_name  "Number of Pipeline Stage"  $pipe_line_stage
    set_property tooltip  "Selects the number of pipeline stage on interfaces to be connected with PCIe block (only valid in Split DMA IP)"  $pipe_line_stage
    set_property visible false $pipe_line_stage

    set NEW_PANEL  [ipgui::add_panel $IPINST -parent $BASIC -name "new_panel" -layout horizontal]
    set New_Panel1 [ipgui::add_panel $IPINST -parent $NEW_PANEL -name New_Panel1 -layout vertical]
    set New_Panel2 [ipgui::add_panel $IPINST -parent $NEW_PANEL -name New_Panel2 -layout vertical]

    set DEVICE_PORT_TYPE [ipgui::add_param  $IPINST -parent $New_Panel1 -name "device_port_type" -layout horizontal -widget comboBox]
    set_property display_name "Device / Port Type" $DEVICE_PORT_TYPE
    set_property tooltip "Indicates the type of  PCI Express logical device" $DEVICE_PORT_TYPE
    ipgui::add_row $IPINST -parent $NEW_PANEL
    set PCIE_BLK_LOCN [ipgui::add_param  $IPINST -parent $New_Panel1 -name "pcie_blk_locn" -layout horizontal -widget comboBox]
    set_property display_name  "PCIe Block Location" $PCIE_BLK_LOCN
    set_property tooltip "Selects from the PCIe Blocks available, to enable generation of location specific constraint files and pinouts" $PCIE_BLK_LOCN
    ipgui::add_row $IPINST -parent $BASIC

    set SRIOV_CAP_ENABLE [ipgui::add_param  $IPINST -parent $New_Panel1 -name "SRIOV_CAP_ENABLE" -layout horizontal -widget checkBox]
    set_property display_name "SRIOV Capability" $SRIOV_CAP_ENABLE

    set physical_functions [ipgui::add_group $IPINST -parent $New_Panel2 -name "physical_functions"]
    set_property display_name "Physical Functions" $physical_functions

    
    set tl_pf_enable_reg [ipgui::add_param  $IPINST -parent $physical_functions -name tl_pf_enable_reg -widget comboBox]
    set_property display_name "Total Physical Functions" $tl_pf_enable_reg
    
    set GT_SELECT [ipgui::add_group $IPINST -parent $New_Panel2 -name "GT_SELECT" ]
    set_property display_name "GT Selection" $GT_SELECT
    set en_gt_selection [ipgui::add_param  $IPINST -parent $GT_SELECT -name en_gt_selection -layout horizontal]
    set_property display_name "Enable GT Quad Selection" $en_gt_selection
    set_property tooltip "If checked enables GT selection for different PCIE Blocks" $en_gt_selection

    set select_quad [ipgui::add_param $IPINST -parent $GT_SELECT -name select_quad -widget comboBox]
    set_property display_name "GT Quad" $select_quad
    set_property tooltip "Select different GT Quads depending on the PCIe block location" $select_quad

    set NEW_PANEL_3  [ipgui::add_panel $IPINST -parent $BASIC -name "new_panel_3" -layout horizontal]
    set PCIE_INTERFACE  [ipgui::add_group $IPINST -parent $NEW_PANEL_3 -name "pcie_interface" -layout vertical]
    set_property display_name "PCIe Interface" $PCIE_INTERFACE

    set PL_LINK_CAP_MAX_LINK_WIDTH  [ipgui::add_param  $IPINST -parent $PCIE_INTERFACE -name "pl_link_cap_max_link_width" -layout horizontal -widget comboBox]
    set_property display_name  "Lane Width"  $PL_LINK_CAP_MAX_LINK_WIDTH
    set_property tooltip  "Selects the initial maximum link width of the device"  $PL_LINK_CAP_MAX_LINK_WIDTH

    set PL_LINK_CAP_MAX_LINK_SPEED [ ipgui::add_param  $IPINST -parent $PCIE_INTERFACE -name "pl_link_cap_max_link_speed" -layout horizontal ]
    set_property display_name  "Maximum Link Speed" $PL_LINK_CAP_MAX_LINK_SPEED
    set_property tooltip "Selects the initial Maximum Link Speed" $PL_LINK_CAP_MAX_LINK_SPEED

    set MULT_PF_DES [ ipgui::add_param  $IPINST -parent $PCIE_INTERFACE -name "mult_pf_des" -layout horizontal -widget comboBox]
    set_property display_name  "Multi PF Design Enable"  $MULT_PF_DES
    set_property tooltip  "Enables the preconfigured Multi PF XDMA design"  $MULT_PF_DES
    set_property visible false $MULT_PF_DES
 
    set REF_CLK_FREQ [ ipgui::add_param  $IPINST -parent $PCIE_INTERFACE -name "ref_clk_freq" -layout horizontal -widget comboBox]
    set_property display_name  "Reference Clock Frequency (MHz)"  $REF_CLK_FREQ
    set_property tooltip  "Selects the frequency of the Reference clock provided on sys_clk"  $REF_CLK_FREQ
    
    set dma_reset_source_sel [ipgui::add_param $IPINST -parent $PCIE_INTERFACE -name dma_reset_source_sel -layout horizontal -widget comboBox]
    set_property display_name "Reset Source" $dma_reset_source_sel
    set_property tooltip "Indicates option to select the source of Reset generation among User Reset, Sys Reset and Phy Ready from base IP. Phy_Ready option keeps DMA/Bridge active even when pcie link goes down and also keeps AXI interface active" $dma_reset_source_sel

    set DRP_CLK_SEL [ ipgui::add_param  $IPINST -parent $PCIE_INTERFACE -name "drp_clk_sel" -layout horizontal -widget comboBox]
    set_property display_name  "GT DRP Clock Selection"  $DRP_CLK_SEL
    set_property tooltip  "Internal : Uses Refrence clock as GT DRP clock; External : Uses External free running clock as GT DRP clock"  $DRP_CLK_SEL
    
    set FREE_RUN_FREQ [ ipgui::add_param  $IPINST -parent $PCIE_INTERFACE -name "free_run_freq" -layout horizontal -widget comboBox]
    set_property display_name  "Free Running Clock Frequency (MHz)"  $FREE_RUN_FREQ
    set_property tooltip  "Selects the frequency of the free running clock on board"  $FREE_RUN_FREQ

    set coreclk_freq [ipgui::add_param $IPINST -parent $PCIE_INTERFACE -name "coreclk_freq" -layout horizontal]
    set_property display_name "Core Clock Frequency (MHz)" $coreclk_freq

    set AXI_INTERFACE  [ipgui::add_group $IPINST -parent $NEW_PANEL_3 -name "axi_interface" -layout vertical ]
    set_property display_name "AXI Interface" $AXI_INTERFACE

    set AXIPanel1 [ipgui::add_panel $IPINST -parent $AXI_INTERFACE -name AXIPanel1 -layout vertical]
    ipgui::add_row $IPINST -parent $AXI_INTERFACE

    set AXI_ADDR_WIDTH [ipgui::add_param  $IPINST -parent $AXIPanel1 -name "axi_addr_width" -layout horizontal ]
    set_property display_name  "AXI Address Width" $AXI_ADDR_WIDTH
    set_property tooltip "Selects the AXI Address width (32-64)" $AXI_ADDR_WIDTH

    set AXI_DATA_WIDTH [ipgui::add_param  $IPINST -parent $AXIPanel1 -name "axi_data_width" -layout horizontal]
    set_property display_name  "AXI Data Width" $AXI_DATA_WIDTH
    set_property tooltip  "Select the AXI Data Width" $AXI_DATA_WIDTH

    set AXISTEN_FREQ [ipgui::add_param  $IPINST -parent $AXIPanel1 -name "axisten_freq" -layout horizontal]
    set_property display_name  "AXI Clock Frequency" $AXISTEN_FREQ
    set_property tooltip  "Select the AXI Clock Frequency" $AXISTEN_FREQ

    set xdma_axi_intf_mm [ipgui::add_param  $IPINST -parent $AXIPanel1 -name "xdma_axi_intf_mm" -layout horizontal]
    set_property display_name  "DMA Interface option" $xdma_axi_intf_mm
    set_property tooltip  "DMA interface can be either AXI Memory mapped or AXI Stream interface. If AXI Memory Map is selected all channels will be muxed into one interface. If AXI Stream is selected, each channel selected will get AXI Stream interface" $xdma_axi_intf_mm

    set xdma_axi_intf_mm_mqdma [ipgui::add_group  $IPINST -parent $AXIPanel1 -name "xdma_axi_intf_mm_mqdma" -layout horizontal]
    set_property display_name  "DMA Interface option" $xdma_axi_intf_mm_mqdma
    set en_axi_mm_mqdma [ipgui::add_param $IPINST -parent $xdma_axi_intf_mm_mqdma -name "en_axi_mm_mqdma" -widget checkBox]
    set_property display_name "AXI Memory Mapped" $en_axi_mm_mqdma
    set en_axi_st_mqdma [ipgui::add_param $IPINST -parent $xdma_axi_intf_mm_mqdma -name "en_axi_st_mqdma" -widget checkBox]
    set_property display_name "AXI Stream" $en_axi_st_mqdma

    set xdma_axilite_slave  [ipgui::add_param  $IPINST -parent $AXIPanel1 -name "xdma_axilite_slave" -layout horizontal -widget checkBox]
    set_property display_name "AXI-Lite Slave Interface" $xdma_axilite_slave
    set_property tooltip "User can access DMA registers"  $xdma_axilite_slave

    set EN_AXI_SLAVE_IF [ipgui::add_param  $IPINST -parent $AXIPanel1 -name "en_axi_slave_if" -layout horizontal]
    set_property display_name  "Enable AXI Slave Interface" $EN_AXI_SLAVE_IF
    set_property tooltip  "Enable AXI Slave Interface" $EN_AXI_SLAVE_IF

    set EN_AXI_MASTER_IF [ipgui::add_param  $IPINST -parent $AXIPanel1 -name "en_axi_master_if" -layout horizontal]
    set_property display_name  "Enable AXI Master Interface" $EN_AXI_MASTER_IF
    set_property tooltip  "Enable AXI Master Interface" $EN_AXI_MASTER_IF

    set botompanel [ipgui::add_panel $IPINST -parent $BASIC -name botompanel -layout horizontal]

    set panel1 [ipgui::add_group $IPINST -parent $botompanel -name panel1 -layout vertical]
    set_property display_name "" $panel1

    set pipe_sim [ipgui::add_param  $IPINST -parent $panel1 -name pipe_sim ]
    set_property display_name  "Enable PIPE Simulation " $pipe_sim
    set_property tooltip "When Checked Enables External Pipe Interface " $pipe_sim

    set EN_EXT_CH_GT_DRP [ipgui::add_param  $IPINST -parent $panel1 -name en_ext_ch_gt_drp ]
    set_property display_name "Enable GT Channel DRP Ports" $EN_EXT_CH_GT_DRP
    set_property tooltip  "When checked enables GT Channel DRP ports" $EN_EXT_CH_GT_DRP

    set EN_PCIE_DRP [ipgui::add_param  $IPINST -parent $panel1 -name en_pcie_drp ]
    set_property display_name "Enable PCIe DRP Ports" $EN_PCIE_DRP
    set_property tooltip  "When checked enables PCIe DRP ports" $EN_PCIE_DRP

    set en_transceiver_status_ports [ipgui::add_param  $IPINST -parent $panel1 -name en_transceiver_status_ports ]
    set_property display_name "Additional Transceiver Control and Status Ports" $en_transceiver_status_ports
    set_property tooltip "Indicates that the additional transceiver control and status ports are selected." $en_transceiver_status_ports

    set xlnx_ref_board [ipgui::add_param $IPINST -parent $panel1 -name xlnx_ref_board -widget comboBox]
    set_property display_name "Xilinx Development Board" $xlnx_ref_board
    set_property visible false $xlnx_ref_board

  set enable_more_clk [ipgui::add_param $IPINST -parent $panel1 -name enable_more_clk]
  set_property visible false $enable_more_clk

    set vu9p_board [ipgui::add_param $IPINST -parent $panel1 -name vu9p_board]
    set_property display_name "VU9P_BOARD" $vu9p_board
    set_property tooltip "Reference board with xcvu9p device" $vu9p_board
    set_property visible false $vu9p_board

    set vu9p_tul_ex [ipgui::add_param $IPINST -parent $panel1 -name vu9p_tul_ex]
    set_property display_name "VU9P_TUL_EX" $vu9p_tul_ex
    set_property tooltip "VU9P TUL BOARD" $vu9p_tul_ex
    set_property visible false $vu9p_tul_ex

    set vcu118_board [ipgui::add_param $IPINST -parent $panel1 -name vcu118_board]
    set_property display_name "VU9P_BOARD" $vcu118_board
    set_property tooltip "Reference board for xcvu9p-flga2104 device" $vcu118_board
    set_property visible false $vcu118_board

    set en_coreclk_es1 [ipgui::add_param $IPINST -parent $panel1 -name en_coreclk_es1]
    set_property display_name "Enable Coreclk for ES1" $en_coreclk_es1
    set_property visible false $en_coreclk_es1

    set ADVANCED [ipgui::add_group $IPINST -parent $botompanel -name "ADVANCED"]
    set_property display_name "" $ADVANCED
    ipgui::add_row $IPINST -parent $botompanel
    
    set usr_irq_exdes [ ipgui::add_param  $IPINST -parent $botompanel -name "usr_irq_exdes" ]
    set_property display_name  "XDMA User IRQ Exdes"  $usr_irq_exdes
    set_property tooltip  "Enables XDMA User IRQ Example Design"  $usr_irq_exdes
    set_property visible false $usr_irq_exdes

    set axi_vip_in_exdes [ ipgui::add_param  $IPINST -parent $botompanel -name "axi_vip_in_exdes" ]
    set_property display_name  "AXI VIP in Exdes"  $axi_vip_in_exdes
    set_property tooltip  "AXI VIP in  Example Design"  $axi_vip_in_exdes
    set_property visible false $axi_vip_in_exdes

    set enable_pcie_debug [ ipgui::add_param  $IPINST -parent $botompanel -name "enable_pcie_debug" ]
    set_property display_name  "Enable PCIe Debug Ports"  $enable_pcie_debug
    set_property visible false $enable_pcie_debug
    

    set xdma_non_incremental_exdes [ ipgui::add_param  $IPINST -parent $botompanel -name "xdma_non_incremental_exdes" ]
    set_property display_name  "XDMA User IRQ Exdes"  $xdma_non_incremental_exdes
    set_property tooltip  "Enables XDMA User IRQ Example Design"  $xdma_non_incremental_exdes
    set_property visible false $xdma_non_incremental_exdes

    set SYS_RESET [ipgui::add_group $IPINST -parent $botompanel -name "SYS_RESET"]
    set_property display_name "" $SYS_RESET

    set DEDICATE_PERST [ipgui::add_param  $IPINST -parent $SYS_RESET -name dedicate_perst ]
    set_property display_name  "Use the dedicated PERST routing resources" $DEDICATE_PERST
    set_property tooltip "Use the dedicated PERST routing resources" $DEDICATE_PERST
    set SYS_RESET_POLARITY [ipgui::add_param  $IPINST -parent $SYS_RESET -name sys_reset_polarity  -layout horizontal -widget comboBox]
    set_property display_name  "System Reset polarity" $SYS_RESET_POLARITY
    set_property tooltip "Chose the desired reset polarity. An ACTIVE_LOW reset should be selected to match the PCIe edge connector reset polarity." $SYS_RESET_POLARITY


    set MCAP_ENABLEMENT [ipgui::add_param  $IPINST -parent $SYS_RESET -name mcap_enablement -layout horizontal -widget comboBox]
    set_property display_name  "Tandem Configuration or Partial Reconfiguration" $MCAP_ENABLEMENT
    set_property tooltip "Use this selection to enable the available Tandem configuration or Partial Reconfiguration Options." $MCAP_ENABLEMENT
    set enable_code [ipgui::add_param  $IPINST -parent $SYS_RESET -name enable_code -layout horizontal]
    set_property display_name  "enable_code" $enable_code
    set_property tooltip "Enable expert options." $enable_code
    set_property visible false $enable_code
    set EXT_STARTUP_PRIMITIVE [ipgui::add_param  $IPINST -parent $SYS_RESET -name ext_startup_primitive  ]
    set_property display_name  "Use an external STARTUP primitive" $EXT_STARTUP_PRIMITIVE
    set_property tooltip "If unchecked the STARTUP block will be generated internal to the IP when Tandem modes are selected." $EXT_STARTUP_PRIMITIVE


    set set_finite_credit [ipgui::add_param $IPINST -parent $botompanel -name set_finite_credit -widget checkBox]
    set_property visible false $set_finite_credit

    set tl_credits_cd [ipgui::add_param $IPINST -parent $botompanel -name tl_credits_cd -widget checkBox]
    set_property visible false $tl_credits_cd

    set tl_credits_ch [ipgui::add_param $IPINST -parent $botompanel -name tl_credits_ch -widget checkBox]
    set_property visible false $tl_credits_ch

    #############
    ############# TAB  PCIe ID - Common to both functional modes DMA and AXI Bridge
    #############
    set ID_tab [ipgui::add_page $IPINST -parent $IPINST -name "pcie_id" -layout vertical]
    set_property display_name "PCIe ID " $ID_tab
    set ID_INITIAL_VALUES [ipgui::add_group $IPINST -parent $ID_tab -name "id_initial_values" ]
    set_property display_name "ID Initial Values " $ID_INITIAL_VALUES
    set VENDOR_ID [ipgui::add_param  $IPINST -parent $ID_INITIAL_VALUES -name "vendor_id" -layout horizontal -show_range true]
    set_property display_name "Vendor ID  " $VENDOR_ID
    set PF0_DEVICE_ID [ipgui::add_param  $IPINST -parent $ID_INITIAL_VALUES -name "pf0_device_id" -layout horizontal -show_range true]
    set_property display_name "Device ID" $PF0_DEVICE_ID
    set PF0_REVISION_ID [ipgui::add_param  $IPINST -parent $ID_INITIAL_VALUES -name "pf0_revision_id" -layout horizontal -show_range true]
    set_property display_name "Revision ID" $PF0_REVISION_ID
    set PF0_SUBSYSTEM_VENDOR_ID [ipgui::add_param  $IPINST -parent $ID_INITIAL_VALUES -name "pf0_subsystem_vendor_id" -layout horizontal -show_range true]
    set_property display_name "Subsystem Vendor ID" $PF0_SUBSYSTEM_VENDOR_ID
    set PF0_SUBSYSTEM_ID [ipgui::add_param  $IPINST -parent $ID_INITIAL_VALUES -name "pf0_subsystem_id" -layout horizontal  -show_range true]
    set_property display_name "Subsystem ID" $PF0_SUBSYSTEM_ID

    set CLASS_CODE  [ipgui::add_group $IPINST -parent $ID_tab -name "class_code"  -layout  horizontal ]
    set_property display_name "Class Code" $CLASS_CODE
    set CLASS_CODE_LOOKUP_ASSISTANT $CLASS_CODE
    set_property display_name "Class Code Lookup Assistant" $CLASS_CODE_LOOKUP_ASSISTANT
    ipgui::add_row $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT
    set Use_Class_Code_Lookup_Assistant [ipgui::add_param  $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name "pf0_Use_Class_Code_Lookup_Assistant" -widget checkBox]
    set_property display_name  "Use Class Code Lookup Assistant " $Use_Class_Code_Lookup_Assistant
    ipgui::add_row $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT

    set BASE_CLASS_MENU  [ipgui::add_param  $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name "pf0_base_class_menu"]
    set_property display_name  "Base Class Menu" $BASE_CLASS_MENU
    ipgui::add_row $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT

    set pf0_class_code_base [ipgui::add_param $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name pf0_class_code_base ]
    set_property display_name "Base Class Value" $pf0_class_code_base
    ipgui::add_static_text $IPINST -name pf0_newST1 -parent $CLASS_CODE_LOOKUP_ASSISTANT -text "Base Class Value"
    set Base_Class_Value   [ipgui::add_dynamic_text  $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name "Base_Class_Value" -display_border true -tclproc Base_class_value_text_UPDATE]
    ipgui::add_static_text $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name pf0_base_class_range -text "Range: 00..FF"
    ipgui::add_row $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT

    set PF0_SUB_CLASS_INTERFACE_MENU [ipgui::add_param  $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name pf0_sub_class_interface_menu -widget comboBox ]
    set_property display_name  "Sub Class Interface Menu" $PF0_SUB_CLASS_INTERFACE_MENU
    ipgui::add_row $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT

    set pf0_class_code_sub [ipgui::add_param $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name pf0_class_code_sub]
    set_property display_name "Sub Class Value" $pf0_class_code_sub
    ipgui::add_static_text $IPINST -name pf0_newST2 -parent $CLASS_CODE_LOOKUP_ASSISTANT -text "Sub Class Value"

    set Sub_Class_Value   [ipgui::add_dynamic_text  $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name "Sub_Class_Value"  -display_border true  -tclproc sub_class_value_text_UPDATE]
    ipgui::add_static_text $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name pf0_sub_class_range -text "Range: 00..FF"
    ipgui::add_row $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT

    set pf0_class_code_interface [ipgui::add_param $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name pf0_class_code_interface]
    set_property display_name "Interface Value" $pf0_class_code_interface
    ipgui::add_static_text $IPINST -name pf0_newST3 -parent $CLASS_CODE_LOOKUP_ASSISTANT -text "Interface Value"

    set INTERFACE_VALUE  [ipgui::add_dynamic_text  $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name "interface_value"  -display_border true  -tclproc interface_value_text_UPDATE]
    ipgui::add_static_text $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name pf0_interface_range -text "Range: 00..FF"
    ipgui::add_row $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT

    set pf0_class_code  [ipgui::add_param  $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name "pf0_class_code" ]
    set_property display_name  "Class Code"  $pf0_class_code
    ipgui::add_static_text $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT -name pf0_class_code -text "Range: 000000..FFFFFF"
    ipgui::add_row $IPINST -parent $CLASS_CODE_LOOKUP_ASSISTANT

    #############
    ############# TAB  PCIe ID for PF1 - Visible only when DMA_and_Bridge option is selected and number of PFs selected is 2
    #############
    set ID_tab_PF1 [ipgui::add_page $IPINST -parent $IPINST -name "pcie_id_pf1" -layout vertical]
    set_property display_name "PF1 PCIe ID " $ID_tab_PF1
    set ID_INITIAL_VALUES_PF1 [ipgui::add_group $IPINST -parent $ID_tab_PF1 -name "id_initial_values_pf1" ]
    set_property display_name "ID Initial Values " $ID_INITIAL_VALUES_PF1
    set pf1_vendor_id [ipgui::add_param  $IPINST -parent $ID_INITIAL_VALUES_PF1 -name "pf1_vendor_id" -layout horizontal -show_range true]
    set_property display_name "Vendor ID" $pf1_vendor_id
    set pf1_device_id [ipgui::add_param  $IPINST -parent $ID_INITIAL_VALUES_PF1 -name "pf1_device_id" -layout horizontal -show_range true]
    set_property display_name "Device ID" $pf1_device_id
    set PF1_REVISION_ID [ipgui::add_param  $IPINST -parent $ID_INITIAL_VALUES_PF1 -name "PF1_REVISION_ID" -layout horizontal -show_range true]
    set_property display_name "Revision ID" $PF0_REVISION_ID
    set PF1_SUBSYSTEM_VENDOR_ID [ipgui::add_param  $IPINST -parent $ID_INITIAL_VALUES_PF1 -name "PF1_SUBSYSTEM_VENDOR_ID" -layout horizontal -show_range true]
    set_property display_name "Subsystem Vendor ID" $PF1_SUBSYSTEM_VENDOR_ID
    set PF1_SUBSYSTEM_ID [ipgui::add_param  $IPINST -parent $ID_INITIAL_VALUES_PF1 -name "PF1_SUBSYSTEM_ID" -layout horizontal -show_range true]
    set_property display_name "Subsystem ID" $PF1_SUBSYSTEM_ID

    set CLASS_CODE_PF1 [ipgui::add_group $IPINST -parent $ID_tab_PF1 -name "class_code_pf1" -layout horizontal ]
    set_property display_name "Class Code" $CLASS_CODE_PF1
    set PF1_CLASS_CODE_LOOKUP_ASSISTANT $CLASS_CODE_PF1
    set_property display_name "Class Code Lookup Assistant" $PF1_CLASS_CODE_LOOKUP_ASSISTANT
    ipgui::add_row $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT
    set PF1_Use_Class_Code_Lookup_Assistant [ipgui::add_param  $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name "PF1_Use_Class_Code_Lookup_Assistant" -widget checkBox]
    set_property display_name "Use Class Code Lookup Assistant " $PF1_Use_Class_Code_Lookup_Assistant
    ipgui::add_row $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT

    set PF1_BASE_CLASS_MENU  [ipgui::add_param  $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name "pf1_base_class_menu" ]
    set_property display_name "Base Class Menu" $PF1_BASE_CLASS_MENU
    ipgui::add_row $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT

    set pf1_class_code_base [ipgui::add_param $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name pf1_class_code_base]
    set_property display_name "Base Class Value" $pf1_class_code_base
    ipgui::add_static_text $IPINST -name pf1_newST1 -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -text "PF1 Base Class Value"
    set PF1_Base_Class_Value [ipgui::add_dynamic_text  $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name "PF1_Base_Class_Value" -display_border true -tclproc Base_class_value_text_UPDATE]
    ipgui::add_static_text $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name pf1_base_class_range -text "Range: 00..FF"
    ipgui::add_row $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT

    set PF1_SUB_CLASS_INTERFACE_MENU [ipgui::add_param  $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name pf1_sub_class_interface_menu -widget comboBox ]
    set_property display_name  "Sub Class Interface Menu" $PF1_SUB_CLASS_INTERFACE_MENU
    ipgui::add_row $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT

    set pf1_class_code_sub [ipgui::add_param $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name pf1_class_code_sub]
    set_property display_name "Sub Class Value" $pf1_class_code_sub
    ipgui::add_static_text $IPINST -name pf1_newST2 -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -text "PF1 Sub Class Value"

    set PF1_Sub_Class_Value  [ipgui::add_dynamic_text  $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name "PF1_Sub_Class_Value"  -display_border true -tclproc sub_class_value_text_UPDATE]
    ipgui::add_static_text $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name pf1_sub_class_range -text "Range: 00..FF"
    ipgui::add_row $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT

    set pf1_class_code_interface [ipgui::add_param $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name pf1_class_code_interface]
    set_property display_name "Interface Value" $pf1_class_code_interface
    ipgui::add_static_text $IPINST -name pf1_newST3 -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -text "PF1 Interface Value"

    set PF1_INTERFACE_VALUE  [ipgui::add_dynamic_text  $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name "PF1_interface_value"  -display_border true -tclproc interface_value_text_UPDATE]
    ipgui::add_static_text $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name pf1_interface_range -text "Range: 00..FF"
    ipgui::add_row $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT

    set pf1_class_code  [ipgui::add_param  $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name "pf1_class_code" ]
    set_property display_name  "Class Code"  $pf1_class_code
    ipgui::add_static_text $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT -name pf1_class_code -text "Range: 000000..FFFFFF"
    ipgui::add_row $IPINST -parent $PF1_CLASS_CODE_LOOKUP_ASSISTANT

    ################################################
    #
    ## PCIe ID page for MQDMA mode
    #
    ################################################

    set ID_tab_mqdma [ipgui::add_page $IPINST -parent $IPINST -name ID_tab_mqdma]
    set_property display_name "PF IDs" $ID_tab_mqdma

    set pf0_id_grp [ipgui::add_group $IPINST -parent $ID_tab_mqdma -name pf0_id_grp -layout horizontal]
    set_property display_name "PF - ID Initial Values" $pf0_id_grp

    set pcie_id_if [ipgui::add_param $IPINST -parent $pf0_id_grp -name pcie_id_if]
    set_property display_name "Enable PCIe-ID Interface" $pcie_id_if
    set_property tooltip "If this parameter is selected the pcie id ports cfg_vend_id,cfg_subsys_vend_id,cfg_dev_id_pf*,cfg_rev_id_pf*,cfg_subsys_id_pf* will appear at the boundary of core top and available to be driven by external logic. If unselected they do not appear at the top level and will be driven with the values set at time of customization" $pcie_id_if
  
    ipgui::add_row $IPINST -parent $pf0_id_grp

    set table1 [ipgui::add_table $IPINST  -name "pf_table_id" -rows "5" -columns "6" -parent $pf0_id_grp -table_header true]
  
    ipgui::add_static_text  $IPINST -name r0c1_4 -parent $table1 -text "PF#"
    ipgui::add_static_text  $IPINST -name r0c2_4 -parent $table1 -text "Vendor ID"
    ipgui::add_static_text  $IPINST -name r0c3_4 -parent $table1 -text "Device ID"
    ipgui::add_static_text  $IPINST -name r0c4_4 -parent $table1 -text "Revision ID"
    ipgui::add_static_text  $IPINST -name r0c5_4 -parent $table1 -text "Subsystem Vendor ID"
    ipgui::add_static_text  $IPINST -name r0c6_4 -parent $table1 -text "Subsystem ID"
  
    set_property cell_location 0,0 [ipgui::get_textspec r0c1_4  -of $IPINST]
    set_property cell_location 0,1 [ipgui::get_textspec r0c2_4  -of $IPINST]
    set_property cell_location 0,2 [ipgui::get_textspec r0c3_4  -of $IPINST]
    set_property cell_location 0,3 [ipgui::get_textspec r0c4_4  -of $IPINST]
    set_property cell_location 0,4 [ipgui::get_textspec r0c5_4  -of $IPINST]
    set_property cell_location 0,5 [ipgui::get_textspec r0c6_4  -of $IPINST]
  
    foreach j {0 1 2 3}  { 
      set row_index [expr $j+1]
      ipgui::add_static_text  $IPINST -name pf${j}_id -parent $table1 -text "PF${j}"
      set_property cell_location $row_index,0 [ipgui::get_textspec pf${j}_id -of $IPINST]
  
      set vendor_id [ipgui::add_param $IPINST -parent $table1 -name pf${j}_vendor_id_mqdma]
      ipgui::add_static_text $IPINST -parent $table1 -name vendor_range -text "Range: 0000..FFFF"
      set_property cell_location $row_index,1  $vendor_id

      set device_id [ipgui::add_param $IPINST -parent $table1 -name PF${j}_DEVICE_ID_mqdma]
      ipgui::add_static_text $IPINST -parent $table1 -name device_range -text "Range: 0000..FFFF"
      set_property cell_location $row_index,2 $device_id 
  
      set revision_id [ipgui::add_param $IPINST -parent $table1 -name PF${j}_REVISION_ID_mqdma]
      ipgui::add_static_text $IPINST -parent $table1 -name revision_range -text "Range: 00..FF"
      set_property cell_location $row_index,3 $revision_id 
  
      set subsystem_vendor_id [ipgui::add_param $IPINST -parent $table1 -name PF${j}_SUBSYSTEM_VENDOR_ID_mqdma]
      ipgui::add_static_text $IPINST -parent $table1 -name subsystemven_range -text "Range: 0000..FFFF"
      set_property cell_location $row_index,4 $subsystem_vendor_id

      set subsystem_id [ipgui::add_param $IPINST -parent $table1 -name PF${j}_SUBSYSTEM_ID_mqdma]
      ipgui::add_static_text $IPINST -parent $table1 -name subsys_range -text "Range: 0000..FFFF"
      set_property cell_location $row_index,5 $subsystem_id 
  
      set_property tooltip "This value identifies the vendor of the PCI Express device. Vendor ID values are assigned by the PCI-SIG." $vendor_id
      set_property tooltip "This value identifies the PCI Express device. Device ID values are assigned by the vendor of the PCI Express device."  $device_id
      set_property tooltip "This value is used to identify the revision level of a PCI Express device.  If you should later revise your PCI Express device design, update this field."  $revision_id
      set_property tooltip "This value is used to identify the Subsystem ID of a PCI Express device"  $subsystem_id
      set_property tooltip "This value is used to identify the Subsystem Vendor ID of a PCI Express device" $subsystem_vendor_id
    }
  
    set Class_code_lookup_grp [ipgui::add_group $IPINST -parent $ID_tab_mqdma -name Class_code_lookup_grp -layout horizontal]
    set_property display_name "Class Code" $Class_code_lookup_grp
  
    set table2 [ipgui::add_table $IPINST  -name "pf_table_class_code" -rows "5" -columns "8" -parent $Class_code_lookup_grp -table_header true]
          
    ipgui::add_static_text  $IPINST -name r0c1_2 -parent $table2 -text "PF#"
    ipgui::add_static_text  $IPINST -name r0c2_2 -parent $table2 -text "Use Classcode \n Lookup Assistant"
    ipgui::add_static_text  $IPINST -name r0c3_2 -parent $table2 -text "Base Class \n Menu"
    ipgui::add_static_text  $IPINST -name r0c4_2 -parent $table2 -text "Base Class \n Value"
    ipgui::add_static_text  $IPINST -name r0c5_2 -parent $table2 -text "Subclass \n Interface Menu"
    ipgui::add_static_text  $IPINST -name r0c6_2 -parent $table2 -text "Subclass \n Value"
    ipgui::add_static_text  $IPINST -name r0c7_2 -parent $table2 -text "Interface\n  Value"
    ipgui::add_static_text  $IPINST -name r0c8_2 -parent $table2 -text "Class \n Code"
    
    set_property cell_location 0,0 [ipgui::get_textspec r0c1_2  -of $IPINST]
    set_property cell_location 0,1 [ipgui::get_textspec r0c2_2  -of $IPINST]
    set_property cell_location 0,2 [ipgui::get_textspec r0c3_2  -of $IPINST]
    set_property cell_location 0,3 [ipgui::get_textspec r0c4_2  -of $IPINST]
    set_property cell_location 0,4 [ipgui::get_textspec r0c5_2  -of $IPINST]
    set_property cell_location 0,5 [ipgui::get_textspec r0c6_2  -of $IPINST]
    set_property cell_location 0,6 [ipgui::get_textspec r0c7_2  -of $IPINST]
    set_property cell_location 0,7 [ipgui::get_textspec r0c8_2  -of $IPINST]

    foreach j {0 1 2 3}  { 
      set row_index [expr $j+1]
      ipgui::add_static_text  $IPINST -name pf${j}_num -parent $table2 -text "PF${j}"
      set_property cell_location $row_index,0 [ipgui::get_textspec pf${j}_num -of $IPINST]
  
      set Lookup_asst [ipgui::add_param $IPINST -parent $table2 -name pf${j}_Use_Class_Code_Lookup_Assistant_mqdma -widget checkBox]
      set_property cell_location $row_index,1 $Lookup_asst
  
      set base_class_menu [ipgui::add_param $IPINST -parent $table2 -name pf${j}_base_class_menu_mqdma -widget comboBox]
      set_property cell_location $row_index,2 $base_class_menu
              
      set class_code_base [ipgui::add_param $IPINST -parent $table2 -name pf${j}_class_code_base_mqdma]
      ipgui::add_dynamic_text $IPINST -parent $table2 -name pf${j}_base_class_value_mqdma -tclproc "pf0_base_class_value_updated_mqdma"
      ipgui::add_static_text $IPINST -parent $table2 -name pf${j}_base_class_range_mqdma -text "Range: 00..FF"
      set_property cell_location $row_index,3 $class_code_base
  
      set sub_class_interface_menu [ipgui::add_param $IPINST -parent $table2 -name pf${j}_sub_class_interface_menu_mqdma -widget comboBox]
      set_property cell_location $row_index,4 $sub_class_interface_menu 
    
      set class_code_sub [ipgui::add_param $IPINST -parent $table2 -name pf${j}_class_code_sub_mqdma]
      ipgui::add_dynamic_text $IPINST -parent $table2 -name pf${j}_sub_class_value_mqdma -tclproc "pf0_sub_class_value_updated_mqdma"
      ipgui::add_static_text $IPINST -parent $table2 -name pf${j}_sub_class_range_mqdma -text "Range: 00..FF"
      set_property cell_location $row_index,5 $class_code_sub
      set_property display_name "Sub Class Value" $class_code_sub
      
      set class_code_interface [ipgui::add_param $IPINST -parent $table2 -name pf${j}_class_code_interface_mqdma]
      ipgui::add_dynamic_text $IPINST -parent $table2 -name pf${j}_interface_value_mqdma -tclproc "pf0_interface_value_updated_mqdma"
      ipgui::add_static_text $IPINST -parent $table2 -name pf${j}_interface_range_mqdma -text "Range: 00..FF"
      set_property cell_location $row_index,6 $class_code_interface
      set_property display_name "Interface Value" $class_code_interface
   
      set CLASS_CODE [ipgui::add_param $IPINST -parent $table2 -name pf${j}_class_code_mqdma]
      ipgui::add_static_text $IPINST -parent $table2 -name class_range_mqdma -text "Range: 000000..FFFFFF"
      set_property cell_location $row_index,7 $CLASS_CODE
  
      ###### Tool Tips ######
      set_property tooltip "This value indicates the general function of a device.  There are three fields.  For a list of values, consult the PCI Local Bus Specification, Revision 3.0 and enter values directly or Use LookUp Assistant Below to retrieve values and enter"  $class_code_base
      set_property tooltip "This value indicates the general function of a device.  There are three fields.  For a list of values, consult the PCI Local Bus Specification, Revision 3.0 and enter values directly or Use LookUp Assistant Below to retrieve values and enter"  $class_code_sub
      set_property tooltip "This value indicates the general function of a device.  There are three fields.  For a list of values, consult the PCI Local Bus Specification, Revision 3.0 and enter values directly or Use LookUp Assistant Below to retrieve values and enter"  $class_code_interface
      set_property tooltip "This value indicates the general function of a device.  The value is a concatenation of the Base Class, Sub-Class, and Interface and forms the Device Class Code"  $CLASS_CODE
      set_property tooltip "Provides the list of possible Base Class options."  $base_class_menu
      set_property tooltip "Provides a list of possible Sub-Class / Interface options for the selected Base Class."  $sub_class_interface_menu
    }
  
    #############
    ############# TAB PCIE0 BARS - Visible only in Functional Mode -> DMA
    #############
    set PCIE0_BARS_tab [ipgui::add_page $IPINST -parent $IPINST -name "PCIE0_BARS" -layout vertical]
    set_property display_name "PCIe : BARs " $PCIE0_BARS_tab

    set BAR0_OptionsPanel [ipgui::add_panel $IPINST -parent $PCIE0_BARS_tab  -name BAR0_OptionsPanel  -layout horizontal]
    set pf0_bar0_option_grp_sup [ipgui::add_group $IPINST -parent $BAR0_OptionsPanel -name bar_0_option_grp_sup -header_param axilite_master_en -layout horizontal ]
    set_property display_name "PCIe to AXI Lite Master Interface" [ipgui::get_guiparamspec axilite_master_en  -of $IPINST]
    set_property tooltip "Host access to user logic via AXI-Lite interface" [ipgui::get_guiparamspec axilite_master_en  -of $IPINST]
    ipgui::add_row $IPINST -parent $pf0_bar0_option_grp_sup
    set pf0_bar0_option_grp [ipgui::add_panel $IPINST -parent $pf0_bar0_option_grp_sup  -name pf0_bar0_option_grp -layout horizontal]
    ipgui::add_row $IPINST -parent $pf0_bar0_option_grp
    set axil_master_64bit_en [ipgui::add_param  $IPINST -parent $pf0_bar0_option_grp -name "axil_master_64bit_en" -layout horizontal -widget checkBox]
    set_property display_name "64bit Enable" $axil_master_64bit_en
    set axil_master_prefetchable [ipgui::add_param  $IPINST -parent $pf0_bar0_option_grp -name "axil_master_prefetchable" -layout horizontal -widget checkBox]
    set_property display_name "Prefetchable" $axil_master_prefetchable
    ipgui::add_row $IPINST -parent $pf0_bar0_option_grp
    set axilite_master_size [ipgui::add_param  $IPINST -parent $pf0_bar0_option_grp -name "axilite_master_size" -layout horizontal -widget comboBox]
    set_property display_name  "Size" $axilite_master_size
    set axilite_master_scale [ipgui::add_param  $IPINST -parent $pf0_bar0_option_grp -name "axilite_master_scale" -layout horizontal -widget comboBox]
    set_property display_name  "Scale" $axilite_master_scale
    ipgui::add_row $IPINST -parent $pf0_bar0_option_grp
    ipgui::add_static_text  $IPINST -name "axilite_master_value"  -parent  $pf0_bar0_option_grp  -text  "Value"
    ipgui::add_dynamic_text $IPINST -parent $pf0_bar0_option_grp -name "axilite_master_value_dynamic"   -tclproc DT_pf0_bar_value_axilite_master  -display_border true
    ipgui::add_row $IPINST -parent $pf0_bar0_option_grp

    set BAR1_OptionsPanel [ipgui::add_panel $IPINST -parent $PCIE0_BARS_tab  -name BAR1_OptionsPanel  -layout horizontal]
    set pf0_bar1_option_grp_sup [ipgui::add_group $IPINST -parent $BAR1_OptionsPanel -name bar_1_option_grp_sup -header_param xdma_en -layout horizontal ]
    set_property display_name "PCIe to DMA Interface" [ipgui::get_guiparamspec xdma_en -of $IPINST]
    set_property tooltip "Host access to DMA internal registers" [ipgui::get_guiparamspec xdma_en  -of $IPINST]
    ipgui::add_row $IPINST -parent $pf0_bar1_option_grp_sup
    set pf0_bar1_option_grp [ipgui::add_panel $IPINST -parent $pf0_bar1_option_grp_sup  -name pf0_bar1_option_grp -layout horizontal]
    ipgui::add_row $IPINST -parent $pf0_bar1_option_grp
    set xdma_pcie_64bit_en [ipgui::add_param  $IPINST -parent $pf0_bar1_option_grp -name "xdma_pcie_64bit_en" -layout horizontal -widget checkBox]
    set_property display_name "64bit Enable" $xdma_pcie_64bit_en
    set xdma_pcie_prefetchable [ipgui::add_param  $IPINST -parent $pf0_bar1_option_grp -name "xdma_pcie_prefetchable" -layout horizontal -widget checkBox]
    set_property display_name "Prefetchable" $xdma_pcie_prefetchable
    ipgui::add_row $IPINST -parent $pf0_bar1_option_grp
    set xdma_size [ipgui::add_param  $IPINST -parent $pf0_bar1_option_grp -name "xdma_size" -layout horizontal -widget comboBox]
    set_property display_name  "Size" $xdma_size
    set_property visible false $xdma_size
    set xdma_scale [ipgui::add_param  $IPINST -parent $pf0_bar1_option_grp -name "xdma_scale" -layout horizontal -widget comboBox]
    set_property display_name  "Scale" $xdma_scale
    set_property visible false $xdma_scale
    ipgui::add_row $IPINST -parent $pf0_bar1_option_grp
    set xdma_value [ipgui::add_static_text  $IPINST -name "xdma_value"  -parent  $pf0_bar1_option_grp  -text  "Value" ]
    set_property visible false $xdma_value
    set xdma_value1 [ipgui::add_dynamic_text $IPINST -parent $pf0_bar1_option_grp -name "xdma_value_dynamic"   -tclproc DT_pf0_bar_value_xdma  -display_border true]
    set_property visible false $xdma_value1
    ipgui::add_row $IPINST -parent $pf0_bar1_option_grp

    set BAR2_OptionsPanel [ipgui::add_panel $IPINST -parent $PCIE0_BARS_tab  -name BAR2_OptionsPanel  -layout horizontal]
    set pf0_bar2_option_grp_sup [ipgui::add_group $IPINST -parent $BAR2_OptionsPanel -name bar_2_option_grp_sup -header_param axist_bypass_en -layout horizontal ]
    set_property display_name "PCIe to DMA Bypass Interface" [ipgui::get_guiparamspec axist_bypass_en  -of $IPINST]
    set_property tooltip "Host access to user logic via AXI Memory Map interface" [ipgui::get_guiparamspec axist_bypass_en  -of $IPINST]
    ipgui::add_row $IPINST -parent $pf0_bar2_option_grp_sup
    set pf0_bar2_option_grp [ipgui::add_panel $IPINST -parent $pf0_bar2_option_grp_sup  -name pf0_bar2_option_grp -layout horizontal]
    ipgui::add_row $IPINST -parent $pf0_bar2_option_grp
    set axi_bypass_64bit_en [ipgui::add_param  $IPINST -parent $pf0_bar2_option_grp -name "axi_bypass_64bit_en" -layout horizontal -widget checkBox]
    set_property display_name "64bit Enable" $axi_bypass_64bit_en
    set axi_bypass_prefetchable [ipgui::add_param  $IPINST -parent $pf0_bar2_option_grp -name "axi_bypass_prefetchable" -layout horizontal -widget checkBox]
    set_property display_name "Prefetchable" $axi_bypass_prefetchable
    ipgui::add_row $IPINST -parent $pf0_bar2_option_grp
    set axist_bypass_size [ipgui::add_param  $IPINST -parent $pf0_bar2_option_grp -name "axist_bypass_size" -layout horizontal -widget comboBox]
    set_property display_name  "Size" $axist_bypass_size
    set axist_bypass_scale [ipgui::add_param  $IPINST -parent $pf0_bar2_option_grp -name "axist_bypass_scale" -layout horizontal -widget comboBox]
    set_property display_name  "Scale" $axist_bypass_scale
    ipgui::add_row $IPINST -parent $pf0_bar2_option_grp
    ipgui::add_static_text  $IPINST -name "axist_bypass_value"  -parent  $pf0_bar2_option_grp  -text  "Value"
    ipgui::add_dynamic_text $IPINST -parent $pf0_bar2_option_grp -name "axist_bypass_value_dynamic"   -tclproc DT_pf0_bar_value_axist_bypass -display_border true
    ipgui::add_row $IPINST -parent $pf0_bar2_option_grp

    set  pciebar2axibar_axil_master  [ipgui::add_param  $IPINST -parent $pf0_bar0_option_grp -name "pciebar2axibar_axil_master" -layout horizontal -widget hexEdit]
    set_property display_name "PCIe to AXI Translation" $pciebar2axibar_axil_master
    set_property tooltip "PCIe to AXI Address Translation"  $pciebar2axibar_axil_master
    set  pciebar2axibar_xdma  [ipgui::add_param  $IPINST -parent $pf0_bar1_option_grp -name "pciebar2axibar_xdma" -layout horizontal -widget hexEdit]
    set_property display_name "PCIe to AXI Translation" $pciebar2axibar_xdma
    set_property tooltip "PCIe to AXI Address Translation"  $pciebar2axibar_xdma
    set_property visible false $pciebar2axibar_xdma
    set  pciebar2axibar_axist_bypass  [ipgui::add_param  $IPINST -parent $pf0_bar2_option_grp -name "pciebar2axibar_axist_bypass" -layout horizontal -widget hexEdit]
    set_property display_name "PCIe to AXI Translation" $pciebar2axibar_axist_bypass
    set_property tooltip "PCIe to AXI Address Translation"  $pciebar2axibar_axist_bypass

    set PF_BARs_MQDMA [ipgui::add_page $IPINST -parent $IPINST -name PF_BARs_MQDMA -layout horizontal]
    set_property display_name "PCIe : BARs" $PF_BARs_MQDMA
    set pf0_base_addr_grp_mqdma $PF_BARs_MQDMA
    ipgui::add_static_text $IPINST -parent $pf0_base_addr_grp_mqdma -name pf0_base_add_static_txt_mqdma -text "Base Address Registers (BARs) serve two purposes.  Initially, they serve as a mechanism for the device to request blocks of address space in the system memory\nmap. After the BIOS or OS determines what addresses to assign to the device, the Base Address Registers are programmed with addresses and the device uses \nthis information to perform address decoding."

    foreach j {0 1 2 3} {
      ipgui::add_row $IPINST -parent $pf0_base_addr_grp_mqdma
      if { $j == 1 } {
        ipgui::add_param $IPINST -name copy_pf0 -parent $PF_BARs_MQDMA -display_name "Copy PF0" -widget checkBox
        ipgui::add_row $IPINST -parent $pf0_base_addr_grp_mqdma
      }
      if {$j == 0} {
        set pf0_option_grp_mqdma [ipgui::add_group $IPINST -parent $PF_BARs_MQDMA -name pf${j}_option_grp_mqdma -display_name "PF${j}" -collapsed false]
      } else { 
        set pf0_option_grp_mqdma [ipgui::add_group $IPINST -parent $PF_BARs_MQDMA -name pf${j}_option_grp_mqdma -display_name "PF${j}" -collapsed true]
      }
      set table3 [ipgui::add_table $IPINST  -name pf${j}_table_mqdma -rows "8" -columns "7" -parent $pf0_option_grp_mqdma -table_header true]
      ipgui::add_static_text  $IPINST -name r${j}c1 -parent $table3 -text "Bar"
      ipgui::add_static_text  $IPINST -name r${j}c2 -parent $table3 -text "Type"
      ipgui::add_static_text  $IPINST -name r${j}c3 -parent $table3 -text "64 bit"
      ipgui::add_static_text  $IPINST -name r${j}c4 -parent $table3 -text "Prefetchable"
      ipgui::add_static_text  $IPINST -name r${j}c5 -parent $table3 -text "Size"
      ipgui::add_static_text  $IPINST -name r${j}c6 -parent $table3 -text "Scale"
      ipgui::add_static_text  $IPINST -name r${j}c7 -parent $table3 -text "Value (Hex)"
  
      set_property cell_location 0,0 [ipgui::get_textspec r${j}c1  -of $IPINST]
      set_property cell_location 0,1 [ipgui::get_textspec r${j}c2  -of $IPINST]
      set_property cell_location 0,2 [ipgui::get_textspec r${j}c3  -of $IPINST]
      set_property cell_location 0,3 [ipgui::get_textspec r${j}c4  -of $IPINST]
      set_property cell_location 0,4 [ipgui::get_textspec r${j}c5  -of $IPINST]
      set_property cell_location 0,5 [ipgui::get_textspec r${j}c6  -of $IPINST]
      set_property cell_location 0,6 [ipgui::get_textspec r${j}c7  -of $IPINST]
      ipgui::add_row $IPINST -parent $pf0_base_addr_grp_mqdma
      foreach i {0 1 2 3 4 5} {
        EvalSubstituting { i j } {
          set row_index [expr $i+1]
          set bar_param [ipgui::add_param $IPINST -parent $table3 -name pf$j_bar$i_enabled_mqdma  -widget checkBox]
          set_property cell_location $row_index,0 $bar_param 
          set pf0_bar$i_type [ipgui::add_param $IPINST -parent $table3 -name pf$j_bar$i_type_mqdma -widget comboBox]
          set_property cell_location $row_index,1 $pf0_bar$i_type
          if {$i == 0 || $i == 2 || $i ==4 } {
            set pf0_bar$i_64bit [ipgui::add_param $IPINST -parent $table3 -name pf$j_bar$i_64bit_mqdma -widget checkBox]
            set_property cell_location $row_index,2 $pf0_bar$i_64bit
          } elseif { $i == 1 || $i == 3} {
            set pf0_bar$i_64bit [ipgui::add_param $IPINST -parent $table3 -name pf$j_bar$i_64bit_mqdma -widget checkBox]
            set_property visible false $pf0_bar$i_64bit
            set_property cell_location $row_index,2 $pf0_bar$i_64bit
          }
          if {$i == 0 || $i == 2 || $i ==4 } {
            set pf0_bar$i_prefetchable [ipgui::add_param $IPINST -parent $table3 -name pf$j_bar$i_prefetchable_mqdma -widget checkBox]
            set_property cell_location $row_index,3 $pf0_bar$i_prefetchable
          } else { 
            set pf0_bar$i_prefetchable [ipgui::add_param $IPINST -parent $table3 -name pf$j_bar$i_prefetchable_mqdma -widget checkBox]
            set_property visible false $pf0_bar$i_prefetchable
            set_property cell_location $row_index,3 $pf0_bar$i_prefetchable
          }
          set pf0_bar$i_size [ipgui::add_param $IPINST -parent $table3 -name pf$j_bar$i_size_mqdma -widget comboBox]
          set_property cell_location $row_index,4 $pf0_bar$i_size
          set pf0_bar$i_scale [ipgui::add_param $IPINST -parent $table3 -name pf$j_bar$i_scale_mqdma -widget comboBox]
          set_property cell_location $row_index,5 $pf0_bar$i_scale
          ipgui::add_dynamic_text $IPINST -parent $table3 -name pf$j_Bar$i_Value_mqdma -tclproc "pf$j_Bar$i_Value_updated_mqdma"
          set_property cell_location $row_index,6 [ipgui::get_textspec pf$j_Bar${i}_Value_mqdma -of $IPINST]
          set_property display_border true [ipgui::get_textspec pf$j_Bar${i}_Value_mqdma -of $IPINST]
        } 0
      }

      set Expansion_rom_bar [ipgui::add_param $IPINST -parent $table3 -name pf${j}_expansion_rom_enabled_mqdma  -widget checkBox]
      set_property cell_location 7,0 $Expansion_rom_bar

      set pf0_expansion_rom_type [ipgui::add_param $IPINST -parent $table3 -name pf${j}_expansion_rom_type_mqdma -widget comboBox]
      set_property cell_location 7,1 $pf0_expansion_rom_type

      set pf0_expansion_rom_size [ipgui::add_param $IPINST -parent $table3 -name pf${j}_expansion_rom_size_mqdma -widget comboBox]
      set_property cell_location 7,4 $pf0_expansion_rom_size

      set pf0_expansion_rom_scale [ipgui::add_param $IPINST -parent $table3 -name pf${j}_expansion_rom_scale_mqdma -widget comboBox]
      set_property cell_location 7,5 $pf0_expansion_rom_scale
  
      ipgui::add_dynamic_text $IPINST -parent $table3 -name pf${j}_Expansion_Rom_Bar_Value_mqdma -tclproc "pf0_Expansion_Rom_Bar_Value_updated_mqdma"
      set_property cell_location 7,6 [ipgui::get_textspec pf${j}_Expansion_Rom_Bar_Value_mqdma -of $IPINST] 
      set_property display_border true [ipgui::get_textspec pf${j}_Expansion_Rom_Bar_Value_mqdma -of $IPINST]
  
      ###### Tool Tips PF BAR0######
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar0_type
      set_property tooltip "A BAR that is 64-bit permits much larger address space requests and also provides the BIOS or OS more flexibility in address space assignments. Memory BARs must be 64-bit if they are prefetchable, but legacy devices are exempt from this requirement. I/O BARs must always be 32-bit. Use of this option disables use of the subsequent BAR."  $pf0_bar0_64bit
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar0_prefetchable
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar0_size
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar0_scale

      ###### Tool Tips PF BAR1######
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar1_type
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar1_prefetchable
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar1_size
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar1_scale
  
      ###### Tool Tips PF BAR2######
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar2_type
      set_property tooltip "A BAR that is 64-bit permits much larger address space requests and also provides the BIOS or OS more flexibility in address space assignments. Memory BARs must be 64-bit if they are prefetchable, but legacy devices are exempt from this requirement. I/O BARs must always be 32-bit.  Use of this option disables use of the subsequent BAR."  $pf0_bar2_64bit
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar2_prefetchable
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar2_size
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar2_scale

      ###### Tool Tips PF BAR3######
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar3_type
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar3_prefetchable
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar3_size
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar3_scale

      ###### Tool Tips PF BAR4######
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar4_type
      set_property tooltip "A BAR that is 64-bit permits much larger address space requests and also provides the BIOS or OS more flexibility in address space assignments. Memory BARs must be 64-bit if they are prefetchable, but legacy devices are exempt from this requirement. I/O BARs must always be 32-bit.  Use of this option disables use of the subsequent BAR."  $pf0_bar4_64bit
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar4_prefetchable
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar4_size
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar4_scale

      ###### Tool Tips PF BAR5######
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar5_type
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar5_prefetchable
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar5_scale
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar5_size
  
      ###### Tool Tips PF Expansion R0M######
      set_property tooltip "Enables the Expansion ROM Bar to be used in the design."  $Expansion_rom_bar
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_expansion_rom_size
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_expansion_rom_scale
    }

    #############
    ############# TAB PF BARS - Visible only in Functional Mode -> DMA_and_Bridge depending on # of PFs
    # This needs to be enabled only if the table format is needed. To add tables for more PFs, change the value "j {1}" to "j {1 2 3}" below
    #############

#    set PF_BARs_Tab [ipgui::add_page $IPINST -parent $IPINST -name PF_BARs_tab -layout horizontal]
    #set_property display_name "PF1 BARs" $PF_BARs_Tab
    #set pf1_base_addr_grp $PF_BARs_Tab
    ##ipgui::add_static_text $IPINST -parent $pf1_base_addr_grp -name pf1_base_add_static_txt -text "Base Address Registers (BARs) serve two purposes.  Initially, they serve as a mechanism for the device to request blocks of address space in the system memory\nmap. After the BIOS or OS determines what addresses to assign to the device, the Base Address Registers are programmed with addresses and the device uses \nthis information to perform address decoding."
#
    #foreach j {1} {
      #ipgui::add_row $IPINST -parent $pf1_base_addr_grp
      #if {$j == 1} {
        #set pf1_option_grp [ipgui::add_group $IPINST -parent $PF_BARs_Tab -name pf${j}_option_grp -display_name "PF${j}" -collapsed false]
      #} else { 
        #set pf1_option_grp [ipgui::add_group $IPINST -parent $PF_BARs_Tab -name pf${j}_option_grp -display_name "PF${j}" -collapsed true]
      #}
      #set table [ipgui::add_table $IPINST -name pf${j}_table -rows "7" -columns "8" -parent $pf1_option_grp -table_header true]
#
      #ipgui::add_static_text  $IPINST -name r${j}c1 -parent $table -text "Bar"
      #ipgui::add_static_text  $IPINST -name r${j}c2 -parent $table -text "Type"
      #ipgui::add_static_text  $IPINST -name r${j}c3 -parent $table -text "64 bit"
      #ipgui::add_static_text  $IPINST -name r${j}c4 -parent $table -text "Prefetchable"
      #ipgui::add_static_text  $IPINST -name r${j}c5 -parent $table -text "Size"
      #ipgui::add_static_text  $IPINST -name r${j}c6 -parent $table -text "Scale"
      #ipgui::add_static_text  $IPINST -name r${j}c7 -parent $table -text "Value (Hex)"
      #ipgui::add_static_text  $IPINST -name r${j}c8 -parent $table -text "PCIe to AXI Translation"
#
      #set_property cell_location 0,0 [ipgui::get_textspec r${j}c1  -of $IPINST]
      #set_property cell_location 0,1 [ipgui::get_textspec r${j}c2  -of $IPINST]
      #set_property cell_location 0,2 [ipgui::get_textspec r${j}c3  -of $IPINST]
      #set_property cell_location 0,3 [ipgui::get_textspec r${j}c4  -of $IPINST]
      #set_property cell_location 0,4 [ipgui::get_textspec r${j}c5  -of $IPINST]
      #set_property cell_location 0,5 [ipgui::get_textspec r${j}c6  -of $IPINST]
      #set_property cell_location 0,6 [ipgui::get_textspec r${j}c7  -of $IPINST]
      #set_property cell_location 0,7 [ipgui::get_textspec r${j}c8  -of $IPINST]
      #ipgui::add_row $IPINST -parent $pf1_base_addr_grp
      #foreach i {0 1 2 3 4 5} {
        #EvalSubstituting { i j } {
          #set row_index [expr $i+1]
          #set bar_param [ipgui::add_param $IPINST -parent $table -name pf$j_bar$i_enabled  -widget checkBox]
          #set_property cell_location $row_index,0 $bar_param 
          #set pf1_bar$i_type [ipgui::add_param $IPINST -parent $table -name pf$j_bar$i_type -widget comboBox]
          #set_property cell_location $row_index,1 $pf1_bar$i_type
          #if {$i == 0 || $i == 2 || $i ==4 } {
            #set pf1_bar$i_64bit [ipgui::add_param $IPINST -parent $table -name pf$j_bar$i_64bit -widget checkBox]
            #set_property cell_location $row_index,2 $pf1_bar$i_64bit
          #} elseif { $i == 1 || $i == 3} {
            #set pf1_bar$i_64bit [ipgui::add_param $IPINST -parent $table -name pf$j_bar$i_64bit -widget checkBox]
            #set_property visible false $pf1_bar$i_64bit
            #set_property cell_location $row_index,2 $pf1_bar$i_64bit
          #}
          #if {$i == 0 || $i == 2 || $i ==4 } {
            #set pf1_bar$i_prefetchable [ipgui::add_param $IPINST -parent $table -name pf$j_bar$i_prefetchable -widget checkBox]
            #set_property cell_location $row_index,3 $pf1_bar$i_prefetchable
          #} elseif { $i == 1 || $i == 3 || $i == 5} {
            #set pf1_bar$i_prefetchable [ipgui::add_param $IPINST -parent $table -name pf$j_bar$i_prefetchable -widget checkBox]
            #set_property visible false $pf1_bar$i_prefetchable
            #set_property cell_location $row_index,3 $pf1_bar$i_prefetchable
          #}
          #set pf1_bar$i_scale [ipgui::add_param $IPINST -parent $table -name pf$j_bar$i_size -widget comboBox]
          #set_property cell_location $row_index,4 $pf1_bar$i_scale
          #set pf1_bar$i_size [ipgui::add_param $IPINST -parent $table -name pf$j_bar$i_scale -widget comboBox]
          #set_property cell_location $row_index,5 $pf1_bar$i_size
          #ipgui::add_dynamic_text $IPINST -parent $table -name pf$j_Bar$i_Value -tclproc "DT_pf$j_bar$i_value"
          #set_property cell_location $row_index,6 [ipgui::get_textspec pf$j_Bar${i}_Value -of $IPINST]
          #set_property display_border true [ipgui::get_textspec pf$j_Bar${i}_Value -of $IPINST]
          #set pf1_pciebar2axibar_$i [ipgui::add_param $IPINST -parent $table -name pf$j_pciebar2axibar_$i -widget hexEdit]
          #set_property cell_location $row_index,7 $pf1_pciebar2axibar_$i
        #} 0
#      }

      ###### Tool Tips PF BAR0######
      #set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf1_bar0_type
      #set_property tooltip "A BAR that is 64-bit permits much larger address space requests and also provides the BIOS or OS more flexibility in address space assignments. Memory BARs must be 64-bit if they are prefetchable, but legacy devices are exempt from this requirement. I/O BARs must always be 32-bit. Use of this option disables use of the subsequent BAR."  $pf1_bar0_64bit
      #set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf1_bar0_prefetchable
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar0_size
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar0_scale
    #set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_0
#
      ####### Tool Tips PF BAR1######
      #set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf1_bar1_type
      #set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf1_bar1_prefetchable
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar1_size
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar1_scale
      #set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_1
#
      ####### Tool Tips PF BAR2######
      #set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf1_bar2_type
      #set_property tooltip "A BAR that is 64-bit permits much larger address space requests and also provides the BIOS or OS more flexibility in address space assignments. Memory BARs must be 64-bit if they are prefetchable, but legacy devices are exempt from this requirement. I/O BARs must always be 32-bit.  Use of this option disables use of the subsequent BAR."  $pf1_bar2_64bit
      #set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf1_bar2_prefetchable
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar2_size
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar2_scale
      #set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_2
#
      ####### Tool Tips PF BAR3######
      #set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf1_bar3_type
      #set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf1_bar3_prefetchable
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar3_size
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar3_scale
      #set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_3
#
      ####### Tool Tips PF BAR4######
      #set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf1_bar4_type
      #set_property tooltip "A BAR that is 64-bit permits much larger address space requests and also provides the BIOS or OS more flexibility in address space assignments. Memory BARs must be 64-bit if they are prefetchable, but legacy devices are exempt from this requirement. I/O BARs must always be 32-bit.  Use of this option disables use of the subsequent BAR."  $pf1_bar4_64bit
      #set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf1_bar4_prefetchable
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar4_size
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar4_scale
      #set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_4
#
      ####### Tool Tips PF BAR5######
      #set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf1_bar5_type
      #set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf1_bar5_prefetchable
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar5_scale
      #set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf1_bar5_size
      #set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_5
#
    #}

   #############
   ############# TAB PCIE PF1 BARS - Visible only in Functional Mode -> DMA_and_Bridge depending on the number of PFs selected. 
   # This tab is visible only when 2 PFs are selected
   #############

   set PF_BARs_tab [ipgui::add_page $IPINST -parent $IPINST -name "PF_BARs_tab" -layout horizontal]
   set_property display_name "PF1 BARs" $PF_BARs_tab
   set PF_BAR_PANEL {
     set PF1_BAR<<n>>_OptionsPanel_br [ipgui::add_panel $IPINST -parent $PF_BARs_tab  -name PF1_BAR<<n>>_OptionsPanel_br  -layout horizontal]
     set pf1_bar<<n>>_option_grp_sup_br [ipgui::add_group $IPINST -parent $PF1_BAR<<n>>_OptionsPanel_br -name pf1_bar_<<n>>_option_grp_sup_br -header_param pf1_bar<<n>>_enabled  -layout horizontal ]
     set_property display_name "PF1_BAR<<n>>" [ipgui::get_guiparamspec pf1_bar<<n>>_enabled  -of $IPINST]
     ipgui::add_row $IPINST -parent $pf1_bar<<n>>_option_grp_sup_br 
     set pf1_bar<<n>>_option_grp_br [ipgui::add_panel $IPINST -parent $pf1_bar<<n>>_option_grp_sup_br  -name pf1_bar<<n>>_option_grp_br -layout horizontal]
     set pf1_bar<<n>>_type [ipgui::add_param  $IPINST -parent $pf1_bar<<n>>_option_grp_br -name "pf1_bar<<n>>_type" -layout horizontal -widget comboBox]
     set_property display_name  "Type" $pf1_bar<<n>>_type
     if {<<n>> == 0 || <<n>> == 2 || <<n>> == 4  } {
       set pf1_bar<<n>>_64bit [ipgui::add_param  $IPINST -parent $pf1_bar<<n>>_option_grp_br -name "pf1_bar<<n>>_64bit" -layout horizontal -widget checkBox]
       set_property display_name  "64 Bit " $pf1_bar<<n>>_64bit
       set pf1_bar<<n>>_prefetchable [ipgui::add_param  $IPINST -parent $pf1_bar<<n>>_option_grp_br -name "pf1_bar<<n>>_prefetchable" -layout horizontal -widget checkBox]
       set_property display_name  "Prefetchable " $pf1_bar<<n>>_prefetchable
     }
     ipgui::add_row $IPINST -parent $pf1_bar<<n>>_option_grp_br
     set pf1_bar<<n>>_size [ipgui::add_param  $IPINST -parent $pf1_bar<<n>>_option_grp_br -name "pf1_bar<<n>>_size" -layout horizontal -widget comboBox]
     set_property display_name  "Size" $pf1_bar<<n>>_size
     set pf1_bar<<n>>_scale [ipgui::add_param  $IPINST -parent $pf1_bar<<n>>_option_grp_br -name "pf1_bar<<n>>_scale" -layout horizontal -widget comboBox]
     set_property display_name  "Scale" $pf1_bar<<n>>_scale
     ipgui::add_row $IPINST -parent $pf1_bar<<n>>_option_grp_br
     ipgui::add_static_text  $IPINST -name "pf1_bar<<n>>_value"  -parent  $pf1_bar<<n>>_option_grp_br  -text  "Value"  
     ipgui::add_dynamic_text $IPINST -parent $pf1_bar<<n>>_option_grp_br -name "pf1_bar<<n>>_value_dynamic"  -tclproc DT_pf1_bar_value<<n>>  -display_border true
     ipgui::add_row $IPINST -parent $pf1_bar<<n>>_option_grp_br
   }
	   
   foreach i {0 1 2 3 4 5} {
     set PR [regsub -all <<n>> $PF_BAR_PANEL $i ]
     eval $PR
     if { [ expr $i %2 ] == 1 } {
       ipgui::add_row $IPINST -parent $PF_BARs_tab
     }
   }

   set pf1_pciebar2axibar_0  [ipgui::add_param  $IPINST -parent $pf1_bar0_option_grp_br -name "pf1_pciebar2axibar_0" -layout horizontal -widget hexEdit]
   set_property display_name "PCIe to AXI Translation" $pf1_pciebar2axibar_0
   set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_0

   set pf1_pciebar2axibar_1  [ipgui::add_param  $IPINST -parent $pf1_bar1_option_grp_br -name "pf1_pciebar2axibar_1" -layout horizontal -widget hexEdit]
   set_property display_name "PCIe to AXI Translation" $pf1_pciebar2axibar_1
   set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_1

   set pf1_pciebar2axibar_2  [ipgui::add_param  $IPINST -parent $pf1_bar2_option_grp_br -name "pf1_pciebar2axibar_2" -layout horizontal -widget hexEdit]
   set_property display_name "PCIe to AXI Translation" $pf1_pciebar2axibar_2
   set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_2

   set pf1_pciebar2axibar_3  [ipgui::add_param  $IPINST -parent $pf1_bar3_option_grp_br -name "pf1_pciebar2axibar_3" -layout horizontal -widget hexEdit]
   set_property display_name "PCIe to AXI Translation" $pf1_pciebar2axibar_3
   set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_3

   set pf1_pciebar2axibar_4  [ipgui::add_param  $IPINST -parent $pf1_bar4_option_grp_br -name "pf1_pciebar2axibar_4" -layout horizontal -widget hexEdit]
   set_property display_name "PCIe to AXI Translation" $pf1_pciebar2axibar_4
   set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_4

   set pf1_pciebar2axibar_5  [ipgui::add_param  $IPINST -parent $pf1_bar5_option_grp_br -name "pf1_pciebar2axibar_5" -layout horizontal -widget hexEdit]
   set_property display_name "PCIe to AXI Translation" $pf1_pciebar2axibar_5
   set_property tooltip "PCIe to AXI Address Translation"  $pf1_pciebar2axibar_5

    #############
    ############# TAB PCIE0 BARS - Visible only in Functional Mode -> AXI Bridge 
    #############

    set PCIE0_BARS_tab1 [ipgui::add_page $IPINST -parent $IPINST -name "PCIE0_BARS_BRIDGE" -layout horizontal]
    set_property display_name "PCIe : BARs " $PCIE0_BARS_tab1
    set PCIE0_BAR_PANEL {
      set BAR<<n>>_OptionsPanel_br [ipgui::add_panel $IPINST -parent $PCIE0_BARS_tab1  -name BAR<<n>>_OptionsPanel_br  -layout horizontal]
      set pf0_bar<<n>>_option_grp_sup_br [ipgui::add_group $IPINST -parent $BAR<<n>>_OptionsPanel_br -name bar_<<n>>_option_grp_sup_br -header_param pf0_bar<<n>>_enabled  -layout horizontal ]
      set_property display_name "PF0_BAR<<n>>" [ipgui::get_guiparamspec pf0_bar<<n>>_enabled  -of $IPINST]
      ipgui::add_row $IPINST -parent $pf0_bar<<n>>_option_grp_sup_br 
      set pf0_bar<<n>>_option_grp_br [ipgui::add_panel $IPINST -parent $pf0_bar<<n>>_option_grp_sup_br  -name pf0_bar<<n>>_option_grp_br -layout horizontal]
      set pf0_bar<<n>>_type [ipgui::add_param  $IPINST -parent $pf0_bar<<n>>_option_grp_br -name "pf0_bar<<n>>_type" -layout horizontal -widget comboBox]
      set_property display_name  "Type" $pf0_bar<<n>>_type
      if {<<n>> == 0 || <<n>> == 2 || <<n>> == 4  } {
        set pf0_bar<<n>>_64bit [ipgui::add_param  $IPINST -parent $pf0_bar<<n>>_option_grp_br -name "pf0_bar<<n>>_64bit" -layout horizontal -widget checkBox]
        set_property display_name  "64 Bit " $pf0_bar<<n>>_64bit
        set pf0_bar<<n>>_prefetchable [ipgui::add_param  $IPINST -parent $pf0_bar<<n>>_option_grp_br -name "pf0_bar<<n>>_prefetchable" -layout horizontal -widget checkBox]
        set_property display_name  "Prefetchable " $pf0_bar<<n>>_prefetchable
      }
      ipgui::add_row $IPINST -parent $pf0_bar<<n>>_option_grp_br
      set pf0_bar<<n>>_size [ipgui::add_param  $IPINST -parent $pf0_bar<<n>>_option_grp_br -name "pf0_bar<<n>>_size" -layout horizontal -widget comboBox]
      set_property display_name  "Size" $pf0_bar<<n>>_size
      set_property tooltip "The maximum BAR size depends on 64-bit BAR option and AXI Address Width parameter, whichever smaller" $pf0_bar<<n>>_size
      set pf0_bar<<n>>_scale [ipgui::add_param  $IPINST -parent $pf0_bar<<n>>_option_grp_br -name "pf0_bar<<n>>_scale" -layout horizontal -widget comboBox]
      set_property display_name  "Scale" $pf0_bar<<n>>_scale
      ipgui::add_row $IPINST -parent $pf0_bar<<n>>_option_grp_br
      ipgui::add_static_text  $IPINST -name "pf0_bar<<n>>_value"  -parent  $pf0_bar<<n>>_option_grp_br  -text  "Value"  
      ipgui::add_dynamic_text $IPINST -parent $pf0_bar<<n>>_option_grp_br -name "pf0_bar<<n>>_value_dynamic"  -tclproc DT_pf0_bar_value<<n>>  -display_border true
      ipgui::add_row $IPINST -parent $pf0_bar<<n>>_option_grp_br
    }
	   
    foreach i {0 1 2 3 4 5} {
      set PR [regsub -all <<n>> $PCIE0_BAR_PANEL $i ]
      eval $PR
      if { [ expr $i %2 ] == 1 } {
        ipgui::add_row $IPINST -parent $PCIE0_BARS_tab1
      }
    }

    set  pciebar2axibar_0  [ipgui::add_param  $IPINST -parent $pf0_bar0_option_grp_br -name "pciebar2axibar_0" -layout horizontal -widget hexEdit]
    set_property display_name "PCIe to AXI Translation" $pciebar2axibar_0
    set_property tooltip "PCIe to AXI Address Translation"  $pciebar2axibar_0
    set  pciebar2axibar_1  [ipgui::add_param  $IPINST -parent $pf0_bar1_option_grp_br -name "pciebar2axibar_1" -layout horizontal -widget hexEdit]
    set_property display_name "PCIe to AXI Translation" $pciebar2axibar_1
    set_property tooltip "PCIe to AXI Address Translation"  $pciebar2axibar_1
    set  pciebar2axibar_2  [ipgui::add_param  $IPINST -parent $pf0_bar2_option_grp_br -name "pciebar2axibar_2" -layout horizontal -widget hexEdit]
    set_property display_name "PCIe to AXI Translation" $pciebar2axibar_2
    set_property tooltip "PCIe to AXI Address Translation"  $pciebar2axibar_2
    set  pciebar2axibar_3  [ipgui::add_param  $IPINST -parent $pf0_bar3_option_grp_br -name "pciebar2axibar_3" -layout horizontal -widget hexEdit]
    set_property display_name "PCIe to AXI Translation" $pciebar2axibar_3
    set_property tooltip "PCIe to AXI Address Translation"  $pciebar2axibar_3
    set  pciebar2axibar_4  [ipgui::add_param  $IPINST -parent $pf0_bar4_option_grp_br -name "pciebar2axibar_4" -layout horizontal -widget hexEdit]
    set_property display_name "PCIe to AXI Translation" $pciebar2axibar_4
    set_property tooltip "PCIe to AXI Address Translation"  $pciebar2axibar_4
    set  pciebar2axibar_5  [ipgui::add_param  $IPINST -parent $pf0_bar5_option_grp_br -name "pciebar2axibar_5" -layout horizontal -widget hexEdit]
    set_property display_name "PCIe to AXI Translation" $pciebar2axibar_5
    set_property tooltip "PCIe to AXI Address Translation"  $pciebar2axibar_5

    #####################################################
    #
    # SRIOV Config Page 
    #
    #####################################################
    set sriov_config [ipgui::add_page $IPINST -parent $IPINST -name sriov_config -layout horizontal]
    set_property display_name "SRIOV Config" $sriov_config

    set all_srio_config_grp [ipgui::add_group $IPINST -parent $sriov_config -name all_srio_config_grp -layout horizontal]
    set_property display_name "General SRIOV Config" $all_srio_config_grp

    set SRIOV_FIRST_VF_OFFSET [ipgui::add_param $IPINST -parent $all_srio_config_grp -name SRIOV_FIRST_VF_OFFSET -widget comboBox]
    set_property display_name "First VF Offset" $SRIOV_FIRST_VF_OFFSET
    ipgui::add_row $IPINST -parent $all_srio_config_grp
  
    ipgui::add_row $IPINST -parent $sriov_config
    set pf0_srio_config_grp [ipgui::add_group $IPINST -parent $sriov_config -name pf0_srio_config_grp -layout horizontal]
    set_property display_name "PF0 SRIOV Config" $pf0_srio_config_grp
  
    set pf0_sriov_cap_ver [ipgui::add_param $IPINST -parent $pf0_srio_config_grp -name pf0_sriov_cap_ver -widget textEdit]
    set_property display_name "Cap Version" $pf0_sriov_cap_ver
    ipgui::add_static_text $IPINST -parent $pf0_srio_config_grp -name SRIOV_Cap_Version -text "Range: 0..F"
    ipgui::add_row $IPINST -parent $pf0_srio_config_grp

    set PF0_SRIOV_CAP_INITIAL_VF [ipgui::add_param $IPINST -parent $pf0_srio_config_grp -name PF0_SRIOV_CAP_INITIAL_VF -widget comboBox]
    set_property display_name "Number of PF0 VF's" $PF0_SRIOV_CAP_INITIAL_VF
    ipgui::add_row $IPINST -parent $pf0_srio_config_grp

    set PF0_SRIOV_FUNC_DEP_LINK [ipgui::add_param $IPINST -parent $pf0_srio_config_grp -name PF0_SRIOV_FUNC_DEP_LINK]
    set_property display_name "PF Dependency Link" $PF0_SRIOV_FUNC_DEP_LINK
    ipgui::add_static_text $IPINST -parent $pf0_srio_config_grp -name ST1 -text "Range: 0000..FFFF"
    ipgui::add_row $IPINST -parent $pf0_srio_config_grp

    set PF0_SRIOV_FIRST_VF_OFFSET [ipgui::add_param $IPINST -parent $pf0_srio_config_grp -name PF0_SRIOV_FIRST_VF_OFFSET]
    set_property display_name "First VF Offset" $PF0_SRIOV_FIRST_VF_OFFSET
    ipgui::add_row $IPINST -parent $pf0_srio_config_grp
  
    set PF0_SRIOV_VF_DEVICE_ID [ipgui::add_param $IPINST -parent $pf0_srio_config_grp -name PF0_SRIOV_VF_DEVICE_ID]
    set_property display_name "VF Device ID" $PF0_SRIOV_VF_DEVICE_ID
    ipgui::add_static_text $IPINST -parent $pf0_srio_config_grp -name ST1 -text "Range: 0000..FFFF"
    ipgui::add_row $IPINST -parent $pf0_srio_config_grp
  
    set PF0_SRIOV_SUPPORTED_PAGE_SIZE [ipgui::add_param $IPINST -parent $pf0_srio_config_grp -name PF0_SRIOV_SUPPORTED_PAGE_SIZE]
    set_property display_name "Supported Page Size" $PF0_SRIOV_SUPPORTED_PAGE_SIZE
    ipgui::add_static_text $IPINST -parent $pf0_srio_config_grp -name ST1 -text "Range: 00000000..FFFFFFFF"
    ipgui::add_row $IPINST -parent $pf0_srio_config_grp

    set pf1_sriov_config_grp [ipgui::add_group $IPINST -parent $sriov_config -name pf1_sriov_config_grp -layout horizontal]
    set_property display_name "PF1 SRIOV Config" $pf1_sriov_config_grp

    set PF1_SRIOV_CAP_VER [ipgui::add_param $IPINST -parent $pf1_sriov_config_grp -name PF1_SRIOV_CAP_VER]
    set_property display_name "Cap Version" $PF1_SRIOV_CAP_VER
    ipgui::add_static_text $IPINST -parent $pf1_sriov_config_grp -name SRIOV_Cap_Version -text "Range: 0..F"
    ipgui::add_row $IPINST -parent $pf1_sriov_config_grp
    
    set PF1_SRIOV_CAP_INITIAL_VF [ipgui::add_param $IPINST -parent $pf1_sriov_config_grp -name PF1_SRIOV_CAP_INITIAL_VF -widget comboBox]
    set_property display_name "Number of PF1 VF's" $PF1_SRIOV_CAP_INITIAL_VF
    ipgui::add_row $IPINST -parent $pf1_sriov_config_grp
    
    set PF1_SRIOV_FUNC_DEP_LINK [ipgui::add_param $IPINST -parent $pf1_sriov_config_grp -name PF1_SRIOV_FUNC_DEP_LINK]
    set_property display_name "PF Dependency Link" $PF1_SRIOV_FUNC_DEP_LINK
    ipgui::add_static_text $IPINST -parent $pf1_sriov_config_grp -name ST2 -text "Range: 0000..FFFF"
    ipgui::add_row $IPINST -parent $pf1_sriov_config_grp

    set PF1_SRIOV_FIRST_VF_OFFSET [ipgui::add_param $IPINST -parent $pf1_sriov_config_grp -name PF1_SRIOV_FIRST_VF_OFFSET]
    set_property display_name "First VF Offset" $PF1_SRIOV_FIRST_VF_OFFSET
    ipgui::add_row $IPINST -parent $pf1_sriov_config_grp
  
    set PF1_SRIOV_VF_DEVICE_ID [ipgui::add_param $IPINST -parent $pf1_sriov_config_grp -name PF1_SRIOV_VF_DEVICE_ID]
    set_property display_name "VF Device ID" $PF1_SRIOV_VF_DEVICE_ID
    ipgui::add_static_text $IPINST -parent $pf1_sriov_config_grp -name ST2 -text "Range: 0000..FFFF"
    ipgui::add_row $IPINST -parent $pf1_sriov_config_grp
    
    set PF1_SRIOV_SUPPORTED_PAGE_SIZE [ipgui::add_param $IPINST -parent $pf1_sriov_config_grp -name PF1_SRIOV_SUPPORTED_PAGE_SIZE]
      set_property display_name "Supported Page Size" $PF1_SRIOV_SUPPORTED_PAGE_SIZE
    ipgui::add_static_text $IPINST -parent $pf1_sriov_config_grp -name ST1 -text "Range: 00000000..FFFFFFFF"
    ipgui::add_row $IPINST -parent $pf1_sriov_config_grp
    
    ipgui::add_row $IPINST -parent $sriov_config
      set pf2_sriov_config_grp [ipgui::add_group $IPINST -parent $sriov_config -name pf2_sriov_config_grp -layout horizontal]
    set_property display_name "PF2 SRIOV Config" $pf2_sriov_config_grp
    
    set PF2_SRIOV_CAP_VER [ipgui::add_param $IPINST -parent $pf2_sriov_config_grp -name PF2_SRIOV_CAP_VER]
    set_property display_name "Cap Version" $PF2_SRIOV_CAP_VER
    ipgui::add_static_text $IPINST -parent $pf2_sriov_config_grp -name SRIOV_Cap_Version -text "Range: 0..F"
    ipgui::add_row $IPINST -parent $pf2_sriov_config_grp
    
    set PF2_SRIOV_CAP_INITIAL_VF [ipgui::add_param $IPINST -parent $pf2_sriov_config_grp -name PF2_SRIOV_CAP_INITIAL_VF -widget comboBox]
    set_property display_name "Number of PF2 VF's" $PF2_SRIOV_CAP_INITIAL_VF
    ipgui::add_row $IPINST -parent $pf2_sriov_config_grp
  
    set PF2_SRIOV_FUNC_DEP_LINK [ipgui::add_param $IPINST -parent $pf2_sriov_config_grp -name PF2_SRIOV_FUNC_DEP_LINK]
    set_property display_name "PF2 Dependency Link" $PF2_SRIOV_FUNC_DEP_LINK
    ipgui::add_static_text $IPINST -parent $pf2_sriov_config_grp -name ST2 -text "Range: 0000..FFFF"
    ipgui::add_row $IPINST -parent $pf2_sriov_config_grp
    
    set PF2_SRIOV_FIRST_VF_OFFSET [ipgui::add_param $IPINST -parent $pf2_sriov_config_grp -name PF2_SRIOV_FIRST_VF_OFFSET]
    set_property display_name "First VF Offset" $PF2_SRIOV_FIRST_VF_OFFSET
    ipgui::add_row $IPINST -parent $pf2_sriov_config_grp
    
    set PF2_SRIOV_VF_DEVICE_ID [ipgui::add_param $IPINST -parent $pf2_sriov_config_grp -name PF2_SRIOV_VF_DEVICE_ID]
    set_property display_name "VF Device ID" $PF2_SRIOV_VF_DEVICE_ID
    ipgui::add_static_text $IPINST -parent $pf2_sriov_config_grp -name ST2 -text "Range: 0000..FFFF"
    ipgui::add_row $IPINST -parent $pf2_sriov_config_grp
  
    set PF2_SRIOV_SUPPORTED_PAGE_SIZE [ipgui::add_param $IPINST -parent $pf2_sriov_config_grp -name PF2_SRIOV_SUPPORTED_PAGE_SIZE]
    set_property display_name "Supported Page Size" $PF2_SRIOV_SUPPORTED_PAGE_SIZE
    ipgui::add_static_text $IPINST -parent $pf2_sriov_config_grp -name ST1 -text "Range: 00000000..FFFFFFFF"
    ipgui::add_row $IPINST -parent $pf2_sriov_config_grp
  
    set pf3_sriov_config_grp [ipgui::add_group $IPINST -parent $sriov_config -name pf3_sriov_config_grp -layout horizontal]
    set_property display_name "PF3 SRIOV Config" $pf3_sriov_config_grp
  
    set PF3_SRIOV_CAP_VER [ipgui::add_param $IPINST -parent $pf3_sriov_config_grp -name PF3_SRIOV_CAP_VER]
    set_property display_name "Cap Version" $PF3_SRIOV_CAP_VER
    ipgui::add_static_text $IPINST -parent $pf3_sriov_config_grp -name SRIOV_Cap_Version -text "Range: 0..F"
    ipgui::add_row $IPINST -parent $pf3_sriov_config_grp
  
    set PF3_SRIOV_CAP_INITIAL_VF [ipgui::add_param $IPINST -parent $pf3_sriov_config_grp -name PF3_SRIOV_CAP_INITIAL_VF -widget comboBox]
    set_property display_name "Number of PF3 VF's" $PF3_SRIOV_CAP_INITIAL_VF
    ipgui::add_row $IPINST -parent $pf3_sriov_config_grp
    
    set PF3_SRIOV_FUNC_DEP_LINK [ipgui::add_param $IPINST -parent $pf3_sriov_config_grp -name PF3_SRIOV_FUNC_DEP_LINK]
    set_property display_name "PF Dependency Link" $PF3_SRIOV_FUNC_DEP_LINK
    ipgui::add_static_text $IPINST -parent $pf3_sriov_config_grp -name ST2 -text "Range: 0000..FFFF"
    ipgui::add_row $IPINST -parent $pf3_sriov_config_grp
  
    set PF3_SRIOV_FIRST_VF_OFFSET [ipgui::add_param $IPINST -parent $pf3_sriov_config_grp -name PF3_SRIOV_FIRST_VF_OFFSET]
    set_property display_name "First VF Offset" $PF3_SRIOV_FIRST_VF_OFFSET
    ipgui::add_row $IPINST -parent $pf3_sriov_config_grp
  
    set PF3_SRIOV_VF_DEVICE_ID [ipgui::add_param $IPINST -parent $pf3_sriov_config_grp -name PF3_SRIOV_VF_DEVICE_ID]
    set_property display_name "VF Device ID" $PF3_SRIOV_VF_DEVICE_ID
    ipgui::add_static_text $IPINST -parent $pf3_sriov_config_grp -name ST2 -text "Range: 0000..FFFF"
    ipgui::add_row $IPINST -parent $pf3_sriov_config_grp
  
    set PF3_SRIOV_SUPPORTED_PAGE_SIZE [ipgui::add_param $IPINST -parent $pf3_sriov_config_grp -name PF3_SRIOV_SUPPORTED_PAGE_SIZE]
    set_property display_name "Supported Page Size" $PF3_SRIOV_SUPPORTED_PAGE_SIZE
    ipgui::add_static_text $IPINST -parent $pf3_sriov_config_grp -name ST1 -text "Range: 00000000..FFFFFFFF"
    ipgui::add_row $IPINST -parent $pf3_sriov_config_grp
  
    ###### Tool Tips ######
  
    set_property tooltip "This value specifies the offset of the first PF with at least one enabled VF. When ARI is enabled, allowed value is 'd4 or 'd64 and total Number of VF in all PFs + this field must not be greater than 256. When ARI is disabled, this field will be set to 1 to support 1PF+7VF non-ARI SRIOV configuration only"  $SRIOV_FIRST_VF_OFFSET
    set_property tooltip "This value specifies the SRIOV Capability Version for Physical Function 0.  Bits 19:16 of the SRIOV Extended Capability Header"  $pf0_sriov_cap_ver
    set_property tooltip "Specifies the number of Virtual Functions supported by Physical Function 0. Zero indicates no Virtual Functions are supported"  $PF0_SRIOV_CAP_INITIAL_VF
    set_property tooltip "This value specifies the Physical Function Dependency Link for Physical Function 0"  $PF0_SRIOV_FUNC_DEP_LINK
    #set_property tooltip "This value specifies the first Virtual Function Offset.  The Routing IDs are mapped in the range 64-75"  $PF0_SRIOV_FIRST_VF_OFFSET
    set_property tooltip "This value specifies the PF0_SRIOV_FIRST_VF_OFFSET parameter. This field is 0 when no VF is enabled for this PF. This field will be set to 1 when 1PF+7VF non-ARI SRIOV is selected. Otherwise it's automatically set to the First Enabled PF's VF Offset field specified above"  $PF0_SRIOV_FIRST_VF_OFFSET
    set_property tooltip "This value specifies the Device ID that is presented for every VF attached to Physical Function 0"  $PF0_SRIOV_VF_DEVICE_ID
    set_property tooltip "This value specifies the page sizes supported by PF0.  The PF supports a page size of 2^(N+12) if bit N is set. Default value is 0x553 (4KB, 8KB, 64KB, 256KB, 1MB, 4MB supported page size)"  $PF0_SRIOV_SUPPORTED_PAGE_SIZE
    set_property tooltip "This value specifies the SRIOV Capability Version for Physical Function 1.  Bits 19:16 of the SRIOV Extended Capability Header"  $PF1_SRIOV_CAP_VER
    set_property tooltip "Specifies the number of Virtual Functions supported by Physical Function 1. Zero indicates no Virtual Functions are supported"  $PF1_SRIOV_CAP_INITIAL_VF
    set_property tooltip "This value specifies the Physical Function Dependency Link for Physical Function 1"  $PF1_SRIOV_FUNC_DEP_LINK
    #set_property tooltip "This value specifies the first Virtual Function Offset.  The Routing IDs are mapped in the range 64-75"  $PF1_SRIOV_FIRST_VF_OFFSET
    set_property tooltip "This value specifies the PF1_SRIOV_FIRST_VF_OFFSET parameter. This field is 0 when no VF is enabled for this PF. Otherwise it's automatically set to (First Enabled PF's VF Offset + Number of PF0's VFs)"  $PF1_SRIOV_FIRST_VF_OFFSET
    set_property tooltip "This value specifies the Device ID that is presented for every VF to Physical Function 1"  $PF1_SRIOV_VF_DEVICE_ID
    set_property tooltip "This value specifies the page sizes supported by PF1.  The PF supports a page size of 2^(N+12) if bit N is set. Default value is 0x553 (4KB, 8KB, 64KB, 256KB, 1MB, 4MB supported page size)"  $PF1_SRIOV_SUPPORTED_PAGE_SIZE
    set_property tooltip "This value specifies the SRIOV Capability Version for Physical Function 2.  Bits 19:16 of the SRIOV Extended Capability Header"  $PF2_SRIOV_CAP_VER
    set_property tooltip "Specifies the number of Virtual Functions supported by Physical Function 2. Zero indicates no Virtual Functions are supported"  $PF2_SRIOV_CAP_INITIAL_VF
    set_property tooltip "This value specifies the Physical Function Dependency Link for Physical Function 2"  $PF2_SRIOV_FUNC_DEP_LINK
    #set_property tooltip "This value specifies the first Virtual Function Offset.  The Routing IDs are mapped in the range 64-75"  $PF2_SRIOV_FIRST_VF_OFFSET
    set_property tooltip "This value specifies the PF2_SRIOV_FIRST_VF_OFFSET parameter. This field is 0 when no VF is enabled for this PF. Otherwise it's automatically set to (First Enabled PF's VF Offset + Number of PF0's VFs + Number of PF1's VFs)"  $PF2_SRIOV_FIRST_VF_OFFSET
    set_property tooltip "This value specifies the Device ID that is presented for every VF to Physical Function 2"  $PF2_SRIOV_VF_DEVICE_ID
    set_property tooltip "This value specifies the page sizes supported by PF2.  The PF supports a page size of 2^(N+12) if bit N is set. Default value is 0x553 (4KB, 8KB, 64KB, 256KB, 1MB, 4MB supported page size)"  $PF2_SRIOV_SUPPORTED_PAGE_SIZE
    set_property tooltip "This value specifies the SRIOV Capability Version for Physical Function 3.  Bits 19:16 of the SRIOV Extended Capability Header"  $PF3_SRIOV_CAP_VER
    set_property tooltip "Specifies the number of Virtual Functions supported by Physical Function 3. Zero indicates no Virtual Functions are supported"  $PF3_SRIOV_CAP_INITIAL_VF
    set_property tooltip "This value specifies the Physical Function Dependency Link for Physical Function 3"  $PF3_SRIOV_FUNC_DEP_LINK
    #set_property tooltip "This value specifies the first Virtual Function Offset.  The Routing IDs are mapped in the range 64-75"  $PF3_SRIOV_FIRST_VF_OFFSET
    set_property tooltip "This value specifies the PF3_SRIOV_FIRST_VF_OFFSET parameter. This field is 0 when no VF is enabled for this PF. Otherwise it's automatically set to (First Enabled PF's VF Offset + Number of PF0's VFs + Number of PF1's VFs + Number of PF2's VFs)"  $PF3_SRIOV_FIRST_VF_OFFSET
    set_property tooltip "This value specifies the Device ID that is presented for every VF to Physical Function 3"  $PF3_SRIOV_VF_DEVICE_ID
    set_property tooltip "This value specifies the page sizes supported by PF3.  The PF supports a page size of 2^(N+12) if bit N is set. Default value is 0x553 (4KB, 8KB, 64KB, 256KB, 1MB, 4MB supported page size)"  $PF3_SRIOV_SUPPORTED_PAGE_SIZE

    ####################################################################
    #
    ### SRIOV PF BARs Page
    #
    ####################################################################
    set sriov_bars [ipgui::add_page $IPINST -parent $IPINST -name sriov_bars -layout horizontal]
    set_property display_name "SRIOV VF BARs" $sriov_bars
    set pf0_base_addr_grp $sriov_bars
    ipgui::add_static_text $IPINST -parent $pf0_base_addr_grp -name pf0_base_add_static_txt -text "Base Address Registers (BARs) serve two purposes.  Initially, they serve as a mechanism for the device to request blocks of address space in the system memory\nmap. After the BIOS or OS determines what addresses to assign to the device, the Base Address Registers are programmed with addresses and the device uses \nthis information to perform address decoding."

    foreach j {0 1 2 3} {
      ipgui::add_row $IPINST -parent $pf0_base_addr_grp
      if { $j == 1 } {
        ipgui::add_param $IPINST -name copy_sriov_pf0 -parent $sriov_bars -display_name "Copy PF0" -widget checkBox
        ipgui::add_row $IPINST -parent $pf0_base_addr_grp
      }
      if {$j == 0} { 
        set pf0_option_grp [ipgui::add_group $IPINST -parent $sriov_bars -name pf${j}_sriov_option_grp -display_name "PF${j}" -collapsed false]
      } else { 
        set pf0_option_grp [ipgui::add_group $IPINST -parent $sriov_bars -name pf${j}_sriov_option_grp -display_name "PF${j}" -collapsed true]
      }
      set table4 [ipgui::add_table $IPINST -name pf${j}_sriov_table -rows "7" -columns "7" -parent $pf0_option_grp -table_header true]

      ipgui::add_static_text  $IPINST -name r${j}c1_3 -parent $table4 -text "Bar"
      ipgui::add_static_text  $IPINST -name r${j}c2_3 -parent $table4 -text "Type"
      ipgui::add_static_text  $IPINST -name r${j}c3_3 -parent $table4 -text "64 bit"
      ipgui::add_static_text  $IPINST -name r${j}c4_3 -parent $table4 -text "Prefetchable"
      ipgui::add_static_text  $IPINST -name r${j}c5_3 -parent $table4 -text "Size"
      ipgui::add_static_text  $IPINST -name r${j}c6_3 -parent $table4 -text "Scale"
      ipgui::add_static_text  $IPINST -name r${j}c7_3 -parent $table4 -text "Value (Hex)"

      set_property cell_location 0,0 [ipgui::get_textspec r${j}c1_3  -of $IPINST]
      set_property cell_location 0,1 [ipgui::get_textspec r${j}c2_3  -of $IPINST]
      set_property cell_location 0,2 [ipgui::get_textspec r${j}c3_3  -of $IPINST]
      set_property cell_location 0,3 [ipgui::get_textspec r${j}c4_3  -of $IPINST]
      set_property cell_location 0,4 [ipgui::get_textspec r${j}c5_3  -of $IPINST]
      set_property cell_location 0,5 [ipgui::get_textspec r${j}c6_3  -of $IPINST]
      set_property cell_location 0,6 [ipgui::get_textspec r${j}c7_3  -of $IPINST]
      ipgui::add_row $IPINST -parent $pf0_base_addr_grp
      foreach i {0 1 2 3 4 5} {
        EvalSubstituting { i j } {
          set row_index [expr $i+1]
          set bar_param [ipgui::add_param $IPINST -parent $table4 -name pf$j_sriov_bar$i_enabled  -widget checkBox]
          set_property cell_location $row_index,0 $bar_param 
          set pf0_bar$i_type [ipgui::add_param $IPINST -parent $table4 -name pf$j_sriov_bar$i_type -widget comboBox]
          set_property cell_location $row_index,1 $pf0_bar$i_type
          if {$i == 0 || $i == 2 || $i ==4 } {
            set pf0_bar$i_64bit [ipgui::add_param $IPINST -parent $table4 -name pf$j_sriov_bar$i_64bit -widget checkBox]
            set_property cell_location $row_index,2 $pf0_bar$i_64bit
          } elseif { $i == 1 || $i == 3} {
            set pf0_bar$i_64bit [ipgui::add_param $IPINST -parent $table4 -name pf$j_sriov_bar$i_64bit -widget checkBox]
            set_property visible false $pf0_bar$i_64bit
            # set_property value false $pf0_bar$i_64bit
            set_property cell_location $row_index,2 $pf0_bar$i_64bit
          }
          if {$i == 0 || $i == 2 || $i ==4 } {
            set pf0_bar$i_prefetchable [ipgui::add_param $IPINST -parent $table4 -name pf$j_sriov_bar$i_prefetchable -widget checkBox]
            set_property cell_location $row_index,3 $pf0_bar$i_prefetchable
          } else { 
            set pf0_bar$i_prefetchable [ipgui::add_param $IPINST -parent $table4 -name pf$j_sriov_bar$i_prefetchable -widget checkBox]
            set_property visible false $pf0_bar$i_prefetchable
            set_property cell_location $row_index,3 $pf0_bar$i_prefetchable
          }
          set pf0_bar$i_size [ipgui::add_param $IPINST -parent $table4 -name pf$j_sriov_bar$i_size -widget comboBox]
          set_property cell_location $row_index,4 $pf0_bar$i_size
          set pf0_bar$i_scale [ipgui::add_param $IPINST -parent $table4 -name pf$j_sriov_bar$i_scale -widget comboBox]
          set_property cell_location $row_index,5 $pf0_bar$i_scale
          ipgui::add_dynamic_text $IPINST -parent $table4 -name pf$j_sriov_Bar$i_Value -tclproc "pf0_sriov_Bar$i_Value_updated"
          set_property cell_location $row_index,6 [ipgui::get_textspec pf$j_sriov_Bar${i}_Value -of $IPINST]
          set_property display_border true [ipgui::get_textspec pf$j_sriov_Bar${i}_Value -of $IPINST]
        } 0
      }
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar0_type
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar0_scale
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar0_size
      set_property tooltip "A BAR that is 64-bit permits much larger address space requests and also provides the BIOS or OS more flexibility in address space assignments. Memory BARs must be 64-bit if they are prefetchable, but legacy devices are exempt from this requirement. I/O BARs must always be 32-bit.  Use of this option disables use of the subsequent BAR."  $pf0_bar0_64bit
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar0_prefetchable
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar1_type
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar1_scale
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar1_size
      set_property tooltip "A BAR that is 64-bit permits much larger address space requests and also provides the BIOS or OS more flexibility in address space assignments. Memory BARs must be 64-bit if they are prefetchable, but legacy devices are exempt from this requirement. I/O BARs must always be 32-bit.  Use of this option disables use of the subsequent BAR."  $pf0_bar1_64bit
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar1_prefetchable
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar2_type
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar2_scale
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar2_size
      set_property tooltip "A BAR that is 64-bit permits much larger address space requests and also provides the BIOS or OS more flexibility in address space assignments. Memory BARs must be 64-bit if they are prefetchable, but legacy devices are exempt from this requirement. I/O BARs must always be 32-bit.  Use of this option disables use of the subsequent BAR."  $pf0_bar2_64bit
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar2_prefetchable
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar3_type
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar3_scale
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar3_size
      set_property tooltip "A BAR that is 64-bit permits much larger address space requests and also provides the BIOS or OS more flexibility in address space assignments. Memory BARs must be 64-bit if they are prefetchable, but legacy devices are exempt from this requirement. I/O BARs must always be 32-bit.  Use of this option disables use of the subsequent BAR."  $pf0_bar3_64bit
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar3_prefetchable
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar4_type
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar4_scale
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar4_size
      set_property tooltip "A BAR that is 64-bit permits much larger address space requests and also provides the BIOS or OS more flexibility in address space assignments. Memory BARs must be 64-bit if they are prefetchable, but legacy devices are exempt from this requirement. I/O BARs must always be 32-bit.  Use of this option disables use of the subsequent BAR."  $pf0_bar4_64bit
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar4_prefetchable
      set_property tooltip "A BAR may request either Memory of I/O space. Select the desired type of address space. Most designs use Memory Space. The use of I/O space is discouraged."  $pf0_bar5_type
      set_property tooltip "Selecting this option indicates that the resources accessed in this address space range do not change state when read. For instance, RAM is prefetchable whereas a FIFO generally is not."  $pf0_bar5_prefetchable
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar5_scale
      set_property tooltip "The BAR size indicates how much address space is requested. The minimum size for a Memory BAR is 128 bytes, but sizes smaller than 4 Kbytes are discouraged. In most systems, I/O space is small and fragmented; if you must use an I/O BAR, you are encouraged to use the smallest space possible."  $pf0_bar5_size
    }

    #############
    ############# TAB PCIE MISC
    #############
    set MISC_tab [ipgui::add_page $IPINST -parent $IPINST -name "pcie_misc" -layout vertical]
    set_property display_name "PCIe : MISC" $MISC_tab
    
    set Bar_Indicator_Settings [ipgui::add_group $IPINST -parent $MISC_tab -name "Bar_Indicator_Settings"]
    set_property display_name "Bar Indicator Settings" $Bar_Indicator_Settings
    set_property tooltip "Indicates that BAR to be selected for MSI-X"  $Bar_Indicator_Settings

    set bar_indicator [ipgui::add_param  $IPINST -parent $Bar_Indicator_Settings -name "bar_indicator" -widget comboBox]
    set_property display_name "Bar Indicator" $bar_indicator
    set_property tooltip "Indicates the BAR to be selected for interrupt processing (MSI-X, MSI, legacy) " $bar_indicator

    set bar0_indicator [ipgui::add_param  $IPINST -parent $Bar_Indicator_Settings -name "bar0_indicator" -widget checkBox]
    set_property visible false $bar0_indicator
    set bar1_indicator [ipgui::add_param  $IPINST -parent $Bar_Indicator_Settings -name "bar1_indicator" -widget checkBox]
    set_property visible false $bar1_indicator
    set bar2_indicator [ipgui::add_param  $IPINST -parent $Bar_Indicator_Settings -name "bar2_indicator" -widget checkBox]
    set_property visible false $bar2_indicator
    set bar3_indicator [ipgui::add_param  $IPINST -parent $Bar_Indicator_Settings -name "bar3_indicator" -widget checkBox]
    set_property visible false $bar3_indicator
    set bar4_indicator [ipgui::add_param  $IPINST -parent $Bar_Indicator_Settings -name "bar4_indicator" -widget checkBox]
    set_property visible false $bar4_indicator
    set bar5_indicator [ipgui::add_param  $IPINST -parent $Bar_Indicator_Settings -name "bar5_indicator" -widget checkBox]
    set_property visible false $bar5_indicator
    
    set barlite2 [ipgui::add_param  $IPINST -parent $Bar_Indicator_Settings -name "barlite2" -widget comboBox]
    set_property display_name "BAR LITE2" $barlite2
    set_property visible false $barlite2

    set User_Interrupts_Settings [ipgui::add_group $IPINST -parent $MISC_tab -name "User_Interrupts_Settings"]
    set_property display_name "User Interrupts" $User_Interrupts_Settings
    set xdma_num_usr_irq  [ipgui::add_param  $IPINST -parent $User_Interrupts_Settings -name "xdma_num_usr_irq" -widget comboBox]
    set_property display_name "Number of User Interrupts Request (1-16)" $xdma_num_usr_irq
    set_property tooltip "Indicated number of usert interrupts request" $xdma_num_usr_irq

    set Legacy_Interrupt_Settings [ipgui::add_group $IPINST -parent $MISC_tab -name "Legacy_Interrupt_Settings" ]
    set_property tooltip "Legacy Interrupt Settings" $Legacy_Interrupt_Settings
    set_property display_name "Legacy Interrupt Settings" $Legacy_Interrupt_Settings

    set pf0_interrupt_pin  [ipgui::add_param  $IPINST -parent $Legacy_Interrupt_Settings -name "pf0_interrupt_pin" -widget comboBox]
    set_property display_name "Legacy Interrupt Settings" $pf0_interrupt_pin

    set MSI_CAPABILITIES [ipgui::add_group $IPINST -parent $MISC_tab -name "msi_capabilities" -layout vertical ]
    set_property display_name "MSI Capabilities" $MSI_CAPABILITIES

    set pf0_msi_enabled [ipgui::add_param  $IPINST -parent $MSI_CAPABILITIES -name "pf0_msi_enabled" -layout horizontal -widget checkBox ]
    set_property display_name "Enable MSI Capability Structure" $pf0_msi_enabled
    set_property tooltip "Indicates that the MSI Capability Structure exists" $pf0_msi_enabled

    set pf0_msi_cap_multimsgcap [ipgui::add_param  $IPINST -parent $MSI_CAPABILITIES -name "pf0_msi_cap_multimsgcap" -layout horizontal -widget comboBox]
    set_property display_name "Multiple Message Capability " $pf0_msi_cap_multimsgcap
    set_property tooltip "This field indicates the number of Message-Signaled Interrupt vectors that this endpoint could request. The actual number of vectors that may be created will be set by the host in the Multiple Message Enable field"  $pf0_msi_cap_multimsgcap
    set_property visible true $pf0_msi_cap_multimsgcap

    set MSIX_CAPABILITIES [ipgui::add_group $IPINST -parent $MISC_tab -name "msix_capabilities" -layout vertical]
    set_property display_name "MSI-X Capabilities" $MSIX_CAPABILITIES
    set pf0_msix_enabled [ipgui::add_param  $IPINST -parent $MSIX_CAPABILITIES -name "pf0_msix_enabled" -layout horizontal -widget checkBox]
    set_property display_name "Enable MSI-X Capability Structure  " $pf0_msix_enabled
    set_property tooltip "Indicates that the MSI-X Capability Structure exists" $pf0_msix_enabled

    set pf0_msix_impl_locn [ipgui::add_param  $IPINST -parent $MSIX_CAPABILITIES -name "pf0_msix_impl_locn" -layout horizontal]
    set_property display_name "MSI-X Implementation Location  " $pf0_msix_impl_locn
    set_property tooltip "Indicates whether MSI-X Table Implemented Internally or Externally to the Core" $pf0_msix_impl_locn
    
    set MSI_X_OPTIONS_grp [ipgui::add_group $IPINST -parent $MISC_tab -name "MSI_X_OPTIONS_grp" -layout vertical] 
    set_property display_name "Select MSI-X Options" $MSI_X_OPTIONS_grp
    set MSI_X_OPTIONS [ipgui::add_param $IPINST -parent $MSI_X_OPTIONS_grp -name MSI_X_OPTIONS -widget comboBox]
    set_property display_name "MSI-X Options" $MSI_X_OPTIONS
    
    foreach i {0 1 2 3 } {
      EvalSubstituting { i } {
        set PF$i [ipgui::add_group $IPINST -parent $MISC_tab -name PF$i_msix]
        set_property display_name "PF$i MSI-X Capabilities" $PF$i
        set pf$i_msix_enabled [ipgui::add_param $IPINST -parent $PF$i -name pf$i_msix_enabled_mqdma -widget checkBox]
        set_property display_name "Enable PF$i MSI-X Capability Structure" $pf$i_msix_enabled
        set MSIx_Table_settings_P$i [ipgui::add_group $IPINST -parent $PF$i -name MSIx_Table_settings_P$i -layout horizontal]
        set_property display_name "MSI-X Table Settings" $MSIx_Table_settings_P$i
        set PF$i_MSIX_CAP_TABLE_SIZE [ipgui::add_param $IPINST -parent $MSIx_Table_settings_P$i -name PF$i_MSIX_CAP_TABLE_SIZE_mqdma]
        set_property display_name "Table Size" $PF$i_MSIX_CAP_TABLE_SIZE
        ipgui::add_static_text $IPINST -name ST1 -parent $MSIx_Table_settings_P$i -text "000..7FF"
        ipgui::add_row $IPINST -parent $MSIx_Table_settings_P$i
        set PF$i_MSIX_CAP_TABLE_OFFSET [ipgui::add_param $IPINST -parent $MSIx_Table_settings_P$i -name PF$i_MSIX_CAP_TABLE_OFFSET_mqdma]
        set_property display_name "Table Offset" $PF$i_MSIX_CAP_TABLE_OFFSET
        ipgui::add_static_text $IPINST -name ST1 -parent $MSIx_Table_settings_P$i -text "00000000..1FFFFFFF"
        ipgui::add_row $IPINST -parent $MSIx_Table_settings_P$i
        set PF$i_MSIX_CAP_TABLE_BIR [ipgui::add_param $IPINST -parent $MSIx_Table_settings_P$i -name PF$i_MSIX_CAP_TABLE_BIR_mqdma -widget comboBox]
        set_property display_name "BAR Indicator" $PF$i_MSIX_CAP_TABLE_BIR
        
        set MSIx_Pending_Bit_Array_grp_$i [ipgui::add_group $IPINST -parent $PF$i -name MSIx_Pending_Bit_Array_grp_$i -layout horizontal]
        set_property display_name "MSI-X Pending Bit Array (PBA) Settings" $MSIx_Pending_Bit_Array_grp_$i
        set PF$i_MSIX_CAP_PBA_OFFSET [ipgui::add_param $IPINST -parent $MSIx_Pending_Bit_Array_grp_$i -name PF$i_MSIX_CAP_PBA_OFFSET_mqdma]
        set_property display_name "PBA Offset" $PF$i_MSIX_CAP_PBA_OFFSET
        ipgui::add_static_text $IPINST -name ST1 -parent $MSIx_Pending_Bit_Array_grp_$i -text "00000000..1FFFFFFF"
        ipgui::add_row $IPINST -parent $MSIx_Pending_Bit_Array_grp_$i
        set PF$i_MSIX_CAP_PBA_BIR [ipgui::add_param $IPINST -parent $MSIx_Pending_Bit_Array_grp_$i -name PF$i_MSIX_CAP_PBA_BIR_mqdma -widget comboBox]
        set_property display_name "PBA BAR Indicator" $PF$i_MSIX_CAP_PBA_BIR

        ###### Tool Tips ######
  
        set_property tooltip "Indicates that the MSI-X Capability Structure exists. NOTE: This requires at least one Memory BAR to be configured. When SRIOV Capability is enabled, enabling MSI-X Capability Structure in PF0 will also enable MSI-X Capability Structure in all available PFs and VFs"  $pf$i_msix_enabled
        set_property tooltip "Specifies the MSI-X Table size.  The table must be implemented in user logic"  $PF$i_MSIX_CAP_TABLE_SIZE
        set_property tooltip "Specifies the Offset from the Base Address Register that points to the Base of the MSI-X Table"  $PF$i_MSIX_CAP_TABLE_OFFSET
        set_property tooltip "This field indicates the Base Address Register in the Configuration Space that is used to map the function\u2019s MSI-X Table, onto Memory Space"  $PF$i_MSIX_CAP_TABLE_BIR
        set_property tooltip "Specifies the Offset from the Base Address Register that points to the Base of the MSI-X PBA"  $PF$i_MSIX_CAP_PBA_OFFSET
        set_property tooltip "This field indicates the Base Address Register in the Configuration Space that is used to map the function\u2019s MSI-X PBA, onto Memory Space"  $PF$i_MSIX_CAP_PBA_BIR
      } 0
    }
  
    set MSIx_Table_settings_PF0 [ipgui::add_group $IPINST -parent $MSIX_CAPABILITIES -name MSIx_Table_settings_PF0 -layout horizontal]
    set_property display_name "MSI-X Table Settings" $MSIx_Table_settings_PF0

    set pf0_msix_cap_table_size [ipgui::add_param $IPINST -parent $MSIx_Table_settings_PF0 -name pf0_msix_cap_table_size]
    set_property display_name "Table Size" $pf0_msix_cap_table_size
    ipgui::add_static_text $IPINST -name ST1 -parent $MSIx_Table_settings_PF0 -text "000..7FF"
    ipgui::add_row $IPINST -parent $MSIx_Table_settings_PF0
    set_property tooltip "Specifies the MSI-X Table size.  The table must be implemented in user logic"  $pf0_msix_cap_table_size

    set pf0_msix_cap_table_offset [ipgui::add_param $IPINST -parent $MSIx_Table_settings_PF0 -name pf0_msix_cap_table_offset]
    set_property display_name "Table Offset" $pf0_msix_cap_table_offset
    set_property tooltip "Specifies the Offset from the Base Address Register that points to the Base of the MSI-X Table"  $pf0_msix_cap_table_offset
    ipgui::add_static_text $IPINST -name ST1 -parent $MSIx_Table_settings_PF0 -text "00000000..1FFFFFFF"
    ipgui::add_row $IPINST -parent $MSIx_Table_settings_PF0

    set pf0_msix_cap_table_bir [ipgui::add_param $IPINST -parent $MSIx_Table_settings_PF0 -name pf0_msix_cap_table_bir -widget comboBox]
    set_property display_name "BAR Indicator" $pf0_msix_cap_table_bir
    set_property tooltip "This field indicates the Base Address Register in the Configuration Space that is used to map the function\u2019s MSI-X Table, onto Memory Space"  $pf0_msix_cap_table_bir

    set MSIx_Pending_Bit_Array_grp [ipgui::add_group $IPINST -parent $MSIX_CAPABILITIES -name MSIx_Pending_Bit_Array_grp -layout horizontal]
    set_property display_name "MSI-X Pending Bit Array (PBA) Settings" $MSIx_Pending_Bit_Array_grp
    set pf0_msix_cap_pba_offset [ipgui::add_param $IPINST -parent $MSIx_Pending_Bit_Array_grp -name pf0_msix_cap_pba_offset]
    set_property display_name "PBA Offset" $pf0_msix_cap_pba_offset
    set_property tooltip "Specifies the Offset from the Base Address Register that points to the Base of the MSI-X PBA"  $pf0_msix_cap_pba_offset
    ipgui::add_static_text $IPINST -name ST1 -parent $MSIx_Pending_Bit_Array_grp -text "00000000..1FFFFFFF"
    ipgui::add_row $IPINST -parent $MSIx_Pending_Bit_Array_grp

    set pf0_msix_cap_pba_bir [ipgui::add_param $IPINST -parent $MSIx_Pending_Bit_Array_grp -name pf0_msix_cap_pba_bir -widget comboBox]
    set_property display_name "PBA BAR Indicator" $pf0_msix_cap_pba_bir
    set_property tooltip "This field indicates the Base Address Register in the Configuration Space that is used to map the function\u2019s MSI-X PBA, onto Memory Space"  $pf0_msix_cap_pba_bir

# No longer supported for US/US+ - CR 976128
# TBD for 7-series Gen2 - CR 976529
#    set COMPLETION_TIMEOUT_CONFIGURATION [ipgui::add_group $IPINST -parent $MISC_tab -name "completion_timeout_configuration" ]
#    set_property display_name "Completion Timeout Configuration" $COMPLETION_TIMEOUT_CONFIGURATION
#    set_property tooltip " Select the completion timeout value " $COMPLETION_TIMEOUT_CONFIGURATION
#    set comp_timeout [ipgui::add_param  $IPINST -parent $COMPLETION_TIMEOUT_CONFIGURATION -name "comp_timeout" -layout horizontal -widget comboBox]
#    set_property display_name "Completion Timeout" $comp_timeout

    set MISC_tab1 [ipgui::add_group $IPINST -parent $MISC_tab -name "Miscellaneous"  -layout horizontal]
    set_property display_name "Miscellaneous" $MISC_tab1

    set performance [ipgui::add_param  $IPINST -parent $MISC_tab1 -name "performance" -widget checkBox]
    set_property display_name "Finite Completion Credits" $performance
    set_property tooltip "Optional ability to turn on finite completion credits" $performance

    ipgui::add_row $IPINST -parent $MISC_tab1

    set pcie_extended_tag [ipgui::add_param  $IPINST -parent $MISC_tab1 -name "pcie_extended_tag" -widget checkBox]
    set_property display_name "Extended Tag Field" $pcie_extended_tag
    set_property tooltip "This field indicates the maximum supported size of the Tag field as a Requester. Checked indicates 6-bit Tag field support. Unchecked indicates 5-bit Tag field support." $pcie_extended_tag

    ipgui::add_row $IPINST -parent $MISC_tab1

    set cfg_ext_if [ipgui::add_param  $IPINST -parent $MISC_tab1 -name "cfg_ext_if" -widget checkBox]
    set_property display_name "Config Extended Interface" $cfg_ext_if
    set_property tooltip "When checked enables the extended config interface" $cfg_ext_if
    
    set legacy_cfg_ext_if [ipgui::add_param  $IPINST -parent $MISC_tab1 -name "legacy_cfg_ext_if" -widget checkBox]
    set_property display_name "Legacy Config Extended Interface" $legacy_cfg_ext_if
    set_property tooltip "When checked enables the legacy extended config interface" $legacy_cfg_ext_if

    ipgui::add_row $IPINST -parent $MISC_tab1
    set ext_xvc_vsec_enable [ipgui::add_param $IPINST -parent $MISC_tab1 -name ext_xvc_vsec_enable -widget checkBox]
    set_property display_name "Add the PCIe XVC-VSEC to the Example Design" $ext_xvc_vsec_enable
    set_property tooltip "Adds the PCIe XVC-VSEC to the Example Design when selected. PCIe Extended Configuration Space must be enabled to select this option."  $ext_xvc_vsec_enable

    set acs_ext_cap_enable [ipgui::add_param $IPINST -parent $MISC_tab1 -name acs_ext_cap_enable -widget checkBox]
    set_property display_name "Access Control Services (ACS) Enable" $acs_ext_cap_enable
    set_property tooltip "Adds the PCIe ACS Capability to the Example Design when selected. PCIe Extended Configuration Space must be enabled to select this option."  $acs_ext_cap_enable
    set_property visible false $acs_ext_cap_enable
    ipgui::add_row $IPINST -parent $MISC_tab1

    set cfg_mgmt_if [ipgui::add_param  $IPINST -parent $MISC_tab1 -name cfg_mgmt_if]
    set_property display_name "Configuration Management Interface" $cfg_mgmt_if
    set_property tooltip "If unchecked removes the ports at the core boundary" $cfg_mgmt_if

    set Link_status_reg [ipgui::add_group $IPINST -parent $MISC_tab -name "Link_status_reg"]
    set_property display_name "Link Status Register" $Link_status_reg
    ipgui::add_static_text $IPINST -parent $Link_status_reg -name generate_additional_Link_status_reg_static_text -text "Selects whether the device reference clock is provided by the connector\n(Synchronous) or generated via an onboard PLL(Asynchronous)"
    set pf0_link_status_slot_clock_config [ipgui::add_param $IPINST -parent $Link_status_reg -name pf0_link_status_slot_clock_config -widget checkBox]
    set_property display_name "Enable Slot Clock Configuration" $pf0_link_status_slot_clock_config

    set type1_membase_memlimit_enable [ipgui::add_param $IPINST -parent $MISC_tab -name type1_membase_memlimit_enable]
    set_property display_name "Type1 Config MemBase and MemLimit" $type1_membase_memlimit_enable
    set_property tooltip "Selects Type1 Config MemoryBase & MemoryLimit Register Enablement"  $type1_membase_memlimit_enable
    set_property visible false $type1_membase_memlimit_enable
    set type1_prefetchable_membase_memlimit [ipgui::add_param $IPINST -parent $MISC_tab -name type1_prefetchable_membase_memlimit]
    set_property display_name "Type1 Config Prefetchable MemBase and MemLimit" $type1_prefetchable_membase_memlimit
    set_property tooltip "Selects Type1 Config Prefetchable MemoryBase & MemoryLimit Register Enablement"  $type1_prefetchable_membase_memlimit
    set_property visible false $type1_prefetchable_membase_memlimit
    ipgui::add_row $IPINST -parent $MISC_tab
  
    set l23_entry [ipgui::add_group $IPINST -parent $MISC_tab -name "l23_entry"]
    set_property display_name "Support PM_L23 Entry" $l23_entry
    set_property tooltip "When checked supports PM_L23 Entry. PM_ENABLE_L23_ENTRY attribute will be set to TRUE" $l23_entry 
    set en_l23_entry [ipgui::add_param $IPINST -name en_l23_entry -parent $l23_entry -widget checkBox]
    set_property display_name "Enable PM_L23 Entry" $en_l23_entry
    ########
    ######## TAB AXI: BARs 
    ########

    set AXI_BARS_tab [ipgui::add_page $IPINST -parent $IPINST -name "axi_bars" -layout horizontal ]
    set_property display_name "AXI : BARs" $AXI_BARS_tab
    set num_of_axi_bars [ipgui::add_param  $IPINST -parent $AXI_BARS_tab -name "axibar_num" -layout horizontal -widget comboBox]
    set_property display_name "Number of AXI BARs" $num_of_axi_bars
    ipgui::add_row $IPINST -parent $AXI_BARS_tab
    set AXI_BAR_PANEL {
      set AXI_BAR<<n>>_option_grp [ipgui::add_group $IPINST -parent $AXI_BARS_tab -name bar_<<n>>_option_grp ]
      set_property display_name  "AXI Bar_<<n>> " $AXI_BAR<<n>>_option_grp
      set axibar_<<n>> [ipgui::add_param  $IPINST -parent $AXI_BAR<<n>>_option_grp -name "axibar_<<n>>" ]
      set_property display_name  "Aperture Base Address " $axibar_<<n>>
      set_property tooltip "Aperture Base Address " $axibar_<<n>>
      set axibar_highaddr_<<n>> [ipgui::add_param  $IPINST -parent $AXI_BAR<<n>>_option_grp -name "axibar_highaddr_<<n>>" ]					
      set_property display_name  "Aperture High Address " $axibar_highaddr_<<n>>
      set_property tooltip "Aperture High Address " $axibar_highaddr_<<n>>
      set axibar2pciebar_<<n>> [ipgui::add_param  $IPINST -parent $AXI_BAR<<n>>_option_grp -name "axibar2pciebar_<<n>>" -widget hexEdit]
      set_property display_name  "AXI to PCIe Translation " $axibar2pciebar_<<n>>
      set_property tooltip "AXI to PCIe default address translation" $axibar2pciebar_<<n>>
      # Hide AXI BAR addresses in IPI. Value is propagated from IPI Address Editor
      if {[ipgui::get_xpg_context -of $IPINST] == "xpg_bd"} { 
        set_property visible false $axibar_<<n>>
        set_property visible false $axibar_highaddr_<<n>>
      } else {
        set_property visible true $axibar_<<n>>
        set_property visible true $axibar_highaddr_<<n>>
      }
  
      ipgui::add_row $IPINST -parent $AXI_BAR<<n>>_option_grp
    }

    foreach i {0 1 2 3 4 5} {
      set PR [regsub -all <<n>> $AXI_BAR_PANEL $i ]
      eval $PR
      if { [ expr $i %2 ] == 1 } {
        ipgui::add_row $IPINST -parent $AXI_BARS_tab
      }
    }

    #############
    ############# TAB AXI MISC
    #############

    set AXI_MISC_tab [ipgui::add_page $IPINST -parent $IPINST -name "axi_misc" -layout vertical]
    set_property display_name "AXI : MISC" $AXI_MISC_tab

    #Dynamic Slave Bridge Address Translation
    set DSB_Addr_translation  [ipgui::add_group $IPINST -parent $AXI_MISC_tab -name "Dynamic_Slave Bridge Address Translation" -layout vertical]
    set_property display_name "Dynamic Slave Bridge Address Translation" $DSB_Addr_translation
    set_property tooltip "Enables dynamic address translation such that the AXI-to-PCIe address translation can be modified dynamically through the AXI-Lite interface " $DSB_Addr_translation
    #############
    ###### hidden 

    set Control_Interface_Address_Range [ipgui::add_group $IPINST -parent $AXI_MISC_tab -name "Control_Interface_Address_Range" -layout vertical]
    set_property display_name "Control Interface Address Range (AXI-Lite) " $Control_Interface_Address_Range
    set_property visible false $Control_Interface_Address_Range
    ## hiden 
    #########

    set AXI_Interconnect_Configuration [ipgui::add_group $IPINST -parent $AXI_MISC_tab -name "AXI_Interconnect_Configuration" -layout vertical]
    set_property display_name "AXI Interconnect Configuration" $AXI_Interconnect_Configuration
    set include_baroffset_reg [ipgui::add_param  $IPINST -parent $DSB_Addr_translation -name "include_baroffset_reg" -widget checkBox ]
    set_property display_name "Enable Dynamic Address Translation" $include_baroffset_reg
    #############
    ###### hidden

    set  BASEADDR [ipgui::add_param  $IPINST -parent $Control_Interface_Address_Range -name "BASEADDR" ]					
    set_property display_name  "Aperture baseaddr Address " $BASEADDR	
    set_property visible false $BASEADDR
    ipgui::add_row $IPINST -parent $AXI_MISC_tab
    set HIGHADDR [ipgui::add_param  $IPINST -parent $Control_Interface_Address_Range -name "HIGHADDR" ]					
    set_property display_name  "Aperture High Address " $HIGHADDR
    set_property visible false $HIGHADDR

    ###### hidden
    #############
    ipgui::add_row $IPINST -parent $AXI_MISC_tab
    set s_axi_id_width [ipgui::add_param  $IPINST -parent $AXI_Interconnect_Configuration -name "s_axi_id_width" -widget comboBox]
    set_property display_name "Slave AXI ID Width" $s_axi_id_width

    set m_axi_num_write [ipgui::add_param  $IPINST -parent $AXI_Interconnect_Configuration -name "c_m_axi_num_write" -widget comboBox]
    #set_property display_name "AXI Master outstanding write transactions" $m_axi_num_write
    # Changed display name in 2017.1
    set_property display_name "AXI outstanding transactions" $m_axi_num_write
    #set_property tooltip "Set the number of outstanding write transactions for the AXI Master interface"  $m_axi_num_write
    # Changed in 2017.1
    set_property tooltip "AXI Master outstanding write transactions can only go to max of 4 for 64bit, 8 for 128 bits, 16 for 256, and 32 for 512"  $m_axi_num_write

    set m_axi_num_read [ipgui::add_param  $IPINST -parent $AXI_Interconnect_Configuration -name "c_m_axi_num_read" -widget comboBox ]
    set_property display_name "AXI Master outstanding read transactions" $m_axi_num_read
    set_property tooltip "Set the number of outstanding read transactions for the AXI Master interface" $m_axi_num_read
    # Added in 2017.1
    set_property visible false $m_axi_num_read

    set s_axi_num_write [ipgui::add_param  $IPINST -parent $AXI_Interconnect_Configuration -name "c_s_axi_num_write" -widget comboBox ]
    set_property display_name "AXI Slave outstanding write transactions" $s_axi_num_write
    set_property tooltip "Set the number of outstanding write transactions for the AXI Slave interface" $s_axi_num_write
    # Added in 2017.1
    set_property visible false $s_axi_num_write
    
    set s_axi_num_read [ipgui::add_param  $IPINST -parent $AXI_Interconnect_Configuration -name "c_s_axi_num_read" -widget comboBox ]
    set_property display_name "AXI Slave outstanding read transactions" $s_axi_num_read
    set_property tooltip "Set the number of outstanding read transactions for the AXI Slave interface" $s_axi_num_read
    # Added in 2017.1
    set_property visible false $s_axi_num_read

    set c_s_axi_supports_narrow_burst [ipgui::add_param $IPINST -parent $AXI_Interconnect_Configuration -name "c_s_axi_supports_narrow_burst" -widget checkBox]
    set_property display_name "AXI Slave narrow burst support" $c_s_axi_supports_narrow_burst
    set_property tooltip "When selected, the IP supports narrow burst transfers.  When deselected, no AXI Masters should drive narrow \
    burst and the IP is optimized with that understanding. \nParameter: C_S_AXI_SUPPORTS_NARROW_BURST" $c_s_axi_supports_narrow_burst
    set_property visible false $c_s_axi_supports_narrow_burst

    #############
    ############# TAB PCIe DMA 
    #############
    set xdma_tab [ipgui::add_page $IPINST -parent $IPINST -name "xdma" -layout vertical]
    set_property display_name "PCIe : DMA " $xdma_tab

    set xdma_rnum_chnl  [ipgui::add_param  $IPINST -parent $xdma_tab -name "xdma_rnum_chnl" -widget comboBox]
    set_property display_name "Number of DMA Read Channel (H2C)" $xdma_rnum_chnl
    set_property tooltip "NUM_H2C_CHANNEL" $xdma_rnum_chnl

    set xdma_wnum_chnl  [ipgui::add_param  $IPINST -parent $xdma_tab -name "xdma_wnum_chnl" -widget comboBox]
    set_property display_name "Number of DMA Write Channel (C2H)" $xdma_wnum_chnl
    set_property tooltip "NUM_C2H_CHANNEL" $xdma_wnum_chnl


    set xdma_rnum_rids [ipgui::add_param  $IPINST -parent $xdma_tab -name "xdma_rnum_rids"]
    set_property display_name "Number of Request IDs for Read channel (2,4,8,16,32,64)" $xdma_rnum_rids
    set_property tooltip "The value should be set in powers of two, that is 2, 4, 8, 16, 32, 64" $xdma_rnum_rids

    set xdma_wnum_rids  [ipgui::add_param  $IPINST -parent $xdma_tab -name "xdma_wnum_rids"]
    set_property display_name "Number of Request IDs for Write channel (2,4,8,16,32)" $xdma_wnum_rids
    set_property tooltip "The value should be set in powers of two, that is 2, 4, 8, 16, 32"  $xdma_wnum_rids

    ipgui::add_row $IPINST -parent $xdma_tab

    set dsc_bypass_rd [ipgui::add_param  $IPINST -parent $xdma_tab -name "dsc_bypass_rd" -widget comboBox]
    #set_property display_name "Descriptor Bypass for Read (H2C)" $dsc_bypass_rd
    set_property tooltip "Each binary digit corresponds to a channel. LSB corresponds to Channel 0. Value of 1 in bit position means corresponding channel has descriptor bypass enabled" $dsc_bypass_rd

    set dsc_bypass_wr [ipgui::add_param  $IPINST -parent $xdma_tab -name "dsc_bypass_wr" -widget comboBox]
    #set_property display_name "Descriptor Bypass for Write (C2H)" $dsc_bypass_wr
    set_property tooltip "Each binary digit corresponds to a channel. LSB corresponds to Channel 0. Value of 1 in bit position means corresponding channel has descriptor bypass enabled" $dsc_bypass_wr

    set dsc_bypass_rd_out [ipgui::add_param  $IPINST -parent $xdma_tab -name "dsc_bypass_rd_out" -widget comboBox]
    set_property tooltip "Each binary digit corresponds to a channel. LSB corresponds to Channel 0. Value of 1 in bit position means corresponding channel has descriptor bypass enabled" $dsc_bypass_rd_out
    set_property display_name "Descriptor Bypass-out for Read (H2C)" $dsc_bypass_rd_out

    set dsc_bypass_wr_out [ipgui::add_param  $IPINST -parent $xdma_tab -name "dsc_bypass_wr_out" -widget comboBox]
    set_property tooltip "Each binary digit corresponds to a channel. LSB corresponds to Channel 0. Value of 1 in bit position means corresponding channel has descriptor bypass enabled" $dsc_bypass_wr_out
    set_property display_name "Descriptor Bypass-out for Write (C2H)" $dsc_bypass_wr_out

    set axi_id_width [ipgui::add_param  $IPINST -parent $xdma_tab -name "axi_id_width" -widget comboBox] 
    set_property display_name "AXI ID Width" $axi_id_width
    set_property tooltip "Enables to select C_M_AXI_ID_WIDTH between the values given" $axi_id_width

    set xdma_sts_ports [ipgui::add_param  $IPINST -parent $xdma_tab -name "xdma_sts_ports" -widget checkBox]
    set_property display_name "DMA Status Ports" $xdma_sts_ports
    set_property tooltip "If selected enables C2H and H2C status ports" $xdma_sts_ports

    set en_debug_ports [ipgui::add_param  $IPINST -parent $xdma_tab -name "en_debug_ports" -widget checkBox]
    set_property display_name "Enable Debug Ports" $en_debug_ports
    set_property tooltip "If selected enables debug ports" $en_debug_ports
    
    set parity_settings [ipgui::add_param  $IPINST -parent $xdma_tab -name "parity_settings" -layout horizontal ]
    set_property display_name "Parity Settings" $parity_settings
    set_property tooltip "Enables to select the Parity options. When Check_Parity is selected, DMA checks Parity and generates Parity. When Propagate_Parity is selected, DMA propagates parity to user AXI interface. User is responsible to check and generate parity " $parity_settings


    set num_queues [ipgui::add_param $IPINST -parent $xdma_tab -name "num_queues"]
    set_property  display_name "Number of Queues (upto 2048)" $num_queues 
    set_property  tooltip "Select number of Queues" $num_queues
    #
    #############
    ############# TAB - Debug Options 
    #############
   
    set debug_options_tab [ipgui::add_page $IPINST -name "debug_options_tab"]
    set_property display_name "Debug Options" $debug_options_tab
  
    set enable_jtag_dbg [ipgui::add_param $IPINST -parent $debug_options_tab -name enable_jtag_dbg -widget checkBox]
    set_property display_name "Enable JTAG Debugger." $enable_jtag_dbg
    set_property tooltip "Refer to corresponding PCIe PG’s,for UltraScale refer to PG156, for UltraScale+ refer to PG 213" $enable_jtag_dbg
    ipgui::add_row $IPINST -parent $debug_options_tab

    set enable_ibert [ipgui::add_param $IPINST -parent $debug_options_tab -name enable_ibert -widget checkBox]
    set_property display_name "Enable In System IBERT." $enable_ibert
    set_property tooltip "Refer to corresponding PCIe PG’s,for UltraScale refer to PG156, for UltraScale+ refer to PG 213" $enable_ibert
    ipgui::add_row $IPINST -parent $debug_options_tab

    set en_dbg_descramble [ipgui::add_param $IPINST -parent $debug_options_tab -name en_dbg_descramble -widget checkBox]
    set_property display_name "Enable Descrambler for Gen3 Mode." $en_dbg_descramble
    set_property tooltip "Descrambler to decode PIPE data. Supporting Gen3 mode only and refer PG213 (UltraScale+) and PG156 (UltraScale) for more details."  $en_dbg_descramble

    #############
    ############# TAB Shared Logic
    #############

    set SHARED_LOGIC_PAGE_US [ ipgui::add_page $IPINST  -name "SHARED_LOGIC_PAGE_US"]
    set_property display_name  "Shared Logic" $SHARED_LOGIC_PAGE_US
    set SHARED_LOGIC_GROUP_US [ipgui::add_group $IPINST -parent $SHARED_LOGIC_PAGE_US -name "shared_logic_group_us"]
    set_property display_name "Shared Logic " $SHARED_LOGIC_GROUP_US
    set_property description "Selects GT_COMMON is included in the core or in the example design" $SHARED_LOGIC_GROUP_US
 
    set gtwiz_in_core_us [ipgui::add_param $IPINST -parent $SHARED_LOGIC_PAGE_US -name gtwiz_in_core_us -widget radioGroup]
    set_property display_name "GT Wizard Option" $gtwiz_in_core_us 
    set_property description "Select whether GT Wizard is included in the core itself or in the example design." $gtwiz_in_core_us

    set Shared_Logic  [ipgui::add_param $IPINST -parent $SHARED_LOGIC_GROUP_US -name Shared_Logic -widget radioGroup]
    set_property display_name "Shared Logic GT_COMMON" $Shared_Logic
 
    set shared_logic_info_group_us [ipgui::add_group $IPINST -parent $SHARED_LOGIC_PAGE_US -name "shared_logic_overview" -layout vertical]
    ipgui::add_dynamic_text $IPINST -name label_shared_logic -parent $shared_logic_info_group_us -tclproc DT_Shared_Logic_US
    ipgui::add_image $IPINST -name PixmapAFix2 -parent $shared_logic_info_group_us -width 400 -height 400
 
    set SHARED_LOGIC_PAGE_7x [ ipgui::add_page $IPINST  -name "SHARED_LOGIC_PAGE_7x"]
    set_property display_name  "Shared Logic" $SHARED_LOGIC_PAGE_7x
    set SHARED_LOGIC_GROUP_7x [ipgui::add_group $IPINST -parent $SHARED_LOGIC_PAGE_7x -name "shared_logic_group_7x"]
    set_property display_name "Shared Logic " $SHARED_LOGIC_GROUP_7x
    set_property description "Selects GT_COMMON and Clock(MMCM) is included in the core or in the example design" $SHARED_LOGIC_GROUP_7x
 
    set Shared_Logic_Both  [ipgui::add_param $IPINST -parent $SHARED_LOGIC_GROUP_7x -name Shared_Logic_Both -widget checkBox]
    set_property display_name "Include Shared Logic in core" $Shared_Logic_Both
    set Shared_Logic_Clk  [ipgui::add_param $IPINST -parent $SHARED_LOGIC_GROUP_7x -name Shared_Logic_Clk -widget checkBox]
    set_property display_name "Include Shared Logic (Clocking) in example design" $Shared_Logic_Clk
    set Shared_Logic_Gtc  [ipgui::add_param $IPINST -parent $SHARED_LOGIC_GROUP_7x -name Shared_Logic_Gtc -widget checkBox]
    set_property display_name "Include Shared Logic (Transceiver GT_COMMON) in example design" $Shared_Logic_Gtc

    set shared_logic_info_group_7x [ipgui::add_group $IPINST -parent $SHARED_LOGIC_PAGE_7x -name "shared_logic_overview" -layout vertical]
    ipgui::add_dynamic_text $IPINST -name label_shared_logic -parent $shared_logic_info_group_7x  -tclproc DT_Shared_Logic_7x
    ipgui::add_image $IPINST -name PixmapAFix2_7x -parent $shared_logic_info_group_7x -width 400 -height 400

    set SHARED_LOGIC_PAGE_USP [ ipgui::add_page $IPINST  -name "SHARED_LOGIC_PAGE_USP"]
    set_property display_name  "Shared Logic" $SHARED_LOGIC_PAGE_USP
    set SHARED_LOGIC_GROUP_USP [ipgui::add_group $IPINST -parent $SHARED_LOGIC_PAGE_USP -name "shared_logic_group_usp"]
    set_property display_name "Shared Logic " $SHARED_LOGIC_GROUP_USP
    set_property description "Selects GT_COMMON is included in the core or in the example design" $SHARED_LOGIC_GROUP_USP
 
    set gtwiz_in_core_usp [ipgui::add_param $IPINST -parent $SHARED_LOGIC_PAGE_USP -name gtwiz_in_core_usp -widget radioGroup]
    set_property display_name "GT Wizard Option" $gtwiz_in_core_usp 
    set_property description "Select whether GT Wizard is included in the core itself or in the example design." $gtwiz_in_core_usp

  set gtcom_in_core_usp [ipgui::add_param $IPINST -parent $SHARED_LOGIC_PAGE_USP -name gtcom_in_core_usp -widget radioGroup]
  set_property display_name "GT COMMON Option" $gtcom_in_core_usp
  set_property description "Select whether GT COMMON is included in the core/GT Wizard itself or in the example design." $gtcom_in_core_usp
 
    #############
    ############# TAB GT Settings
    #############
    set GT_Settings_tab [ipgui::add_page $IPINST -parent $IPINST -name "GT_Settings_tab" -layout vertical]
    set_property display_name "GT Settings" $GT_Settings_tab

    set gtpanel [ipgui::add_panel $IPINST -parent $GT_Settings_tab -name gtpanel -layout horizontal]

     set enable_auto_rxeq [ipgui::add_param $IPINST -parent $gtpanel -name enable_auto_rxeq -widget comboBox]
     set_property display_name "Enable Auto RxEq" $enable_auto_rxeq
     set_property tooltip "Selects Receiver Equalization in Auto Mode"  $enable_auto_rxeq
     ipgui::add_row $IPINST -parent $gtpanel

    set plltype [ipgui::add_param $IPINST -parent $gtpanel -name plltype -widget comboBox]
    set_property display_name "PLL Selection" $plltype
    #set_property visible false $plltype
    set_property tooltip "Selects CPLL or QPLL1 for Gen2 line rates"  $plltype
    
    ipgui::add_row $IPINST -parent $gtpanel
    set ins_loss_profile [ipgui::add_param $IPINST -parent $gtpanel -name "ins_loss_profile" -layout horizontal -widget comboBox]
    set_property display_name "Form factor driven Insertion loss adjustment" $ins_loss_profile
    set_property tooltip "Specify Insertion loss profile that should be used for the GT Settings" $ins_loss_profile

    ipgui::add_row $IPINST -parent $gtpanel
    set RX_PPM_OFFSET [ipgui::add_param $IPINST -parent $gtpanel -name RX_PPM_OFFSET]
    set_property display_name "PPM offset between receiver and transmitter" $RX_PPM_OFFSET

    ipgui::add_row $IPINST -parent $gtpanel
    set RX_SSC_PPM [ipgui::add_param $IPINST -parent $gtpanel -name RX_SSC_PPM]
    set_property display_name "Spread spectrum clocking" $RX_SSC_PPM

    ipgui::add_row $IPINST -parent $gtpanel
    set INS_LOSS_NYQ [ipgui::add_param $IPINST -parent $gtpanel -name INS_LOSS_NYQ]
    set_property display_name "Insertion loss at Nyquist (dB)" $INS_LOSS_NYQ

    ipgui::add_row $IPINST -parent $gtpanel
    set PHY_LP_TXPRESET [ipgui::add_param $IPINST -parent $gtpanel -widget comboBox -name PHY_LP_TXPRESET]
    set_property display_name "Link Partner TX Preset" $PHY_LP_TXPRESET
    set_property tooltip "Not advisable to change the default value of 4. Preset value of 5 might work better on some systems." $PHY_LP_TXPRESET
    ipgui::add_row $IPINST -parent $gtpanel

    set rx_detect [ipgui::add_param $IPINST -parent $gtpanel -widget comboBox -name rx_detect -layout horizontal]
    set_property display_name "Receiver Detect" $rx_detect
    set_property tooltip "For Receiver Detect RX Termination info please go to UltraScale GTH UG576 - Chapter 6: Use Model: PCI Express and refer to RX Termination for Receiver Detection section" $rx_detect
}

proc update_PARAM_VALUE.PCIE_BOARD_INTERFACE {IPINST PARAM_VALUE.PCIE_BOARD_INTERFACE PROJECT_PARAM.BOARD} {
    set param_range [get_board_interface_param_range $IPINST -name "PCIE_BOARD_INTERFACE"]
    set_property range $param_range ${PARAM_VALUE.PCIE_BOARD_INTERFACE}
}


# Enabling the pf0_link_status_slot_clock_config parameter for all UltraScale Plus devices from 2017.1 onwards. 
# Hence commented the below proc.
#
#proc update_PARAM_VALUE.pf0_link_status_slot_clock_config {PARAM_VALUE.pf0_link_status_slot_clock_config PROJECT_PARAM.ARCHITECTURE} {
  #set c_xfamily  [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
  #if {$c_xfamily == "virtexuplus" || $c_xfamily == "kintexuplus" || $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc"} { 
    #set_property enabled false  ${PARAM_VALUE.pf0_link_status_slot_clock_config}
  #} else { 
    #set_property enabled true  ${PARAM_VALUE.pf0_link_status_slot_clock_config}
  #}
#
#}

proc update_PARAM_VALUE.dsc_bypass_rd {PARAM_VALUE.dsc_bypass_rd PARAM_VALUE.xdma_rnum_chnl PARAM_VALUE.functional_mode IPINST} {

    set dma_rnum_chnl [get_property value ${PARAM_VALUE.xdma_rnum_chnl}]
    set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

    if {$dma_rnum_chnl == 1} {
        set_property range "0000,0001" ${PARAM_VALUE.dsc_bypass_rd}
    } elseif {$dma_rnum_chnl == 2} {
        set_property range "0000,0001,0010,0011" ${PARAM_VALUE.dsc_bypass_rd}
    } elseif {$dma_rnum_chnl == 3} {
        set_property range "0000,0001,0010,0011,0100,0101,0110,0111" ${PARAM_VALUE.dsc_bypass_rd}
    } elseif {$dma_rnum_chnl == 4} {
        set_property range "0000,0001,0010,0011,0100,0101,0110,0111,1000,1001,1010,1011,1100,1101,1110,1111" ${PARAM_VALUE.dsc_bypass_rd}
    }

}

proc update_PARAM_VALUE.dsc_bypass_rd_out {PARAM_VALUE.dsc_bypass_rd_out PARAM_VALUE.xdma_rnum_chnl} {

    set dma_rnum_chnl [get_property value ${PARAM_VALUE.xdma_rnum_chnl}]

    if {$dma_rnum_chnl == 1} {
        set_property range "0000,0001" ${PARAM_VALUE.dsc_bypass_rd_out}
    } elseif {$dma_rnum_chnl == 2} {
        set_property range "0000,0001,0010,0011" ${PARAM_VALUE.dsc_bypass_rd_out}
    } elseif {$dma_rnum_chnl == 3} {
        set_property range "0000,0001,0010,0011,0100,0101,0110,0111" ${PARAM_VALUE.dsc_bypass_rd_out}
    } elseif {$dma_rnum_chnl == 4} {
        set_property range "0000,0001,0010,0011,0100,0101,0110,0111,1000,1001,1010,1011,1100,1101,1110,1111" ${PARAM_VALUE.dsc_bypass_rd_out}
    }

}

proc update_PARAM_VALUE.xdma_rnum_chnl {PARAM_VALUE.xdma_rnum_chnl PROJECT_PARAM.DEVICE PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.functional_mode} {
  set device           [string toupper ${PROJECT_PARAM.DEVICE}]
  set c_xfamily_gen2   [string toupper ${PROJECT_PARAM.ARCHITECTURE}]
  set func_mode        [get_property value ${PARAM_VALUE.functional_mode}]

  ## If this is for a gen2 device set the max write channels to 2.
  if {$device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $c_xfamily_gen2 == "KINTEX7" || $c_xfamily_gen2 == "QKINTEX7" || $c_xfamily_gen2 == "KINTEX7L" ||  $c_xfamily_gen2 == "QKINTEX7L" || $c_xfamily_gen2 == "ARTIX7" || $c_xfamily_gen2 == "AARTIX7" ||  $c_xfamily_gen2 == "QARTIX7" ||  $c_xfamily_gen2 == "ARTIX7L" || $c_xfamily_gen2 == "ZYNQ" || $c_xfamily_gen2 == "AZYNQ" || $c_xfamily_gen2 == "QZYNQ"} {
    set_property range "1,2" ${PARAM_VALUE.xdma_rnum_chnl}
  } else { 
    if {$func_mode == "MQDMA"} { 
      set_property enabled false ${PARAM_VALUE.xdma_rnum_chnl}
      set_property range "1" ${PARAM_VALUE.xdma_rnum_chnl}
    } else {
      set_property enabled true ${PARAM_VALUE.xdma_rnum_chnl}
      set_property range "1,2,3,4" ${PARAM_VALUE.xdma_rnum_chnl}
    }
  }
}

proc update_PARAM_VALUE.xdma_wnum_chnl {PARAM_VALUE.xdma_wnum_chnl PROJECT_PARAM.DEVICE PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.functional_mode} {
  set device           [string toupper ${PROJECT_PARAM.DEVICE}]
  set c_xfamily_gen2   [string toupper ${PROJECT_PARAM.ARCHITECTURE}]
  set func_mode        [get_property value ${PARAM_VALUE.functional_mode}]

  ## If this is for a gen2 device set the max write channels to 2.
  if {$device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $c_xfamily_gen2 == "KINTEX7" || $c_xfamily_gen2 == "QKINTEX7" || $c_xfamily_gen2 == "KINTEX7L" ||  $c_xfamily_gen2 == "QKINTEX7L" || $c_xfamily_gen2 == "ARTIX7" || $c_xfamily_gen2 == "AARTIX7" ||  $c_xfamily_gen2 == "QARTIX7" ||  $c_xfamily_gen2 == "ARTIX7L" || $c_xfamily_gen2 == "ZYNQ" || $c_xfamily_gen2 == "AZYNQ" || $c_xfamily_gen2 == "QZYNQ"} {
    set_property range "1,2" ${PARAM_VALUE.xdma_wnum_chnl}
  } else {
    if {$func_mode == "MQDMA" } { 
      set_property enabled false ${PARAM_VALUE.xdma_wnum_chnl}
      set_property range "1" ${PARAM_VALUE.xdma_wnum_chnl}
    } else { 
      set_property enabled true ${PARAM_VALUE.xdma_wnum_chnl}
      set_property range "1,2,3,4" ${PARAM_VALUE.xdma_wnum_chnl}
    }
  }
}

proc update_PARAM_VALUE.dsc_bypass_wr {PARAM_VALUE.dsc_bypass_wr PARAM_VALUE.xdma_wnum_chnl } {

    set dma_wnum_chnl [get_property value ${PARAM_VALUE.xdma_wnum_chnl}]

    if {$dma_wnum_chnl == 1} {
        set_property range "0000,0001" ${PARAM_VALUE.dsc_bypass_wr}
    } elseif {$dma_wnum_chnl == 2} {
        set_property range "0000,0001,0010,0011" ${PARAM_VALUE.dsc_bypass_wr}
    } elseif {$dma_wnum_chnl == 3} {
        set_property range "0000,0001,0010,0011,0100,0101,0110,0111" ${PARAM_VALUE.dsc_bypass_wr}
    } elseif {$dma_wnum_chnl == 4} {
        set_property range "0000,0001,0010,0011,0100,0101,0110,0111,1000,1001,1010,1011,1100,1101,1110,1111" ${PARAM_VALUE.dsc_bypass_wr}
    }

}


proc update_PARAM_VALUE.dsc_bypass_wr_out {PARAM_VALUE.dsc_bypass_wr_out PARAM_VALUE.xdma_wnum_chnl} {

    set dma_wnum_chnl [get_property value ${PARAM_VALUE.xdma_wnum_chnl}]

    if {$dma_wnum_chnl == 1} {
        set_property range "0000,0001" ${PARAM_VALUE.dsc_bypass_wr_out}
    } elseif {$dma_wnum_chnl == 2} {
        set_property range "0000,0001,0010,0011" ${PARAM_VALUE.dsc_bypass_wr_out}
    } elseif {$dma_wnum_chnl == 3} {
        set_property range "0000,0001,0010,0011,0100,0101,0110,0111" ${PARAM_VALUE.dsc_bypass_wr_out}
    } elseif {$dma_wnum_chnl == 4} {
        set_property range "0000,0001,0010,0011,0100,0101,0110,0111,1000,1001,1010,1011,1100,1101,1110,1111" ${PARAM_VALUE.dsc_bypass_wr_out}
    }
    
}

proc update_PARAM_VALUE.INS_LOSS_NYQ {PARAM_VALUE.INS_LOSS_NYQ PARAM_VALUE.ins_loss_profile} { 
  
  set ins_loss_profile [get_property value ${PARAM_VALUE.ins_loss_profile}]

  if {$ins_loss_profile eq "Chip-to-Chip"} { 
    set val 5
  } elseif {$ins_loss_profile eq "Add-in_Card"} { 
    set val 15
  } else { 
    set val 20
  }
  set_property value $val ${PARAM_VALUE.INS_LOSS_NYQ}
}


proc update_PARAM_VALUE.SYS_RST_N_BOARD_INTERFACE {IPINST PARAM_VALUE.SYS_RST_N_BOARD_INTERFACE PROJECT_PARAM.BOARD} {
    set param_range [get_board_interface_param_range $IPINST -name "SYS_RST_N_BOARD_INTERFACE" -matchparam "TYPE"]
    set_property range $param_range ${PARAM_VALUE.SYS_RST_N_BOARD_INTERFACE}
}

proc update_PARAM_VALUE.PHY_LP_TXPRESET {PARAM_VALUE.PHY_LP_TXPRESET PROJECT_PARAM.ARCHITECTURE } { 

  set c_xfamily   [string toupper ${PROJECT_PARAM.ARCHITECTURE}]

  if {$c_xfamily == "KINTEXU" || $c_xfamily == "VIRTEXU" || $c_xfamily eq "VIRTEXUPLUS" || $c_xfamily eq "KINTEXUPLUS" || $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"}  { 
    set_property enabled true ${PARAM_VALUE.PHY_LP_TXPRESET}
  } else { 
    set_property enabled false ${PARAM_VALUE.PHY_LP_TXPRESET}
  }

}

proc update_gui_for_PARAM_VALUE.PHY_LP_TXPRESET {IPINST PARAM_VALUE.PHY_LP_TXPRESET PROJECT_PARAM.ARCHITECTURE } { 

  set c_xfamily   [string toupper ${PROJECT_PARAM.ARCHITECTURE}]

  if {$c_xfamily == "KINTEXU" || $c_xfamily == "VIRTEXU" || $c_xfamily eq "VIRTEXUPLUS" || $c_xfamily eq "KINTEXUPLUS" || $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} { 
    set_property visible true  [ipgui::get_guiparamspec PHY_LP_TXPRESET -of $IPINST]
  } else { 
    set_property visible false [ipgui::get_guiparamspec PHY_LP_TXPRESET -of $IPINST]
  }

}

proc update_PARAM_VALUE.cfg_ext_if {PARAM_VALUE.cfg_ext_if PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE PARAM_VALUE.device_port_type } { 
  set c_xfamily [string toupper ${PROJECT_PARAM.ARCHITECTURE}]
  set device    [string toupper ${PROJECT_PARAM.DEVICE}]
  set device_port_type [get_property value ${PARAM_VALUE.device_port_type} ]

  if {$device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $c_xfamily == "KINTEX7" || $c_xfamily == "QKINTEX7" || $c_xfamily == "KINTEX7L" ||  $c_xfamily == "QKINTEX7L" || $c_xfamily == "ARTIX7" || $c_xfamily == "AARTIX7" ||  $c_xfamily == "QARTIX7" ||  $c_xfamily == "ARTIX7L" || $c_xfamily == "ZYNQ" || $c_xfamily == "AZYNQ" || $c_xfamily == "QZYNQ"} {
    set_property enabled false ${PARAM_VALUE.cfg_ext_if}
    set_property value   false ${PARAM_VALUE.cfg_ext_if}
  } else {
    if {$device_port_type ne "Root_Port_of_PCI_Express_Root_Complex"} {
      set_property enabled true ${PARAM_VALUE.cfg_ext_if}
    } else {
      set_property enabled false ${PARAM_VALUE.cfg_ext_if}
      set_property value   false ${PARAM_VALUE.cfg_ext_if}
    }
  }

}

proc update_PARAM_VALUE.ext_xvc_vsec_enable { PARAM_VALUE.ext_xvc_vsec_enable PARAM_VALUE.cfg_ext_if PARAM_VALUE.device_port_type} {
  # Procedure called to update the XVC-VSEC enable checkbox when PCIe Extended Capabilities are enabled.
  if { [get_property value ${PARAM_VALUE.cfg_ext_if}] } {
    set_property enabled true ${PARAM_VALUE.ext_xvc_vsec_enable}
  } else {
    set_property enabled false ${PARAM_VALUE.ext_xvc_vsec_enable}
    set_property value false ${PARAM_VALUE.ext_xvc_vsec_enable}
  }
}

##proc update_PARAM_VALUE.acs_ext_cap_enable { PARAM_VALUE.acs_ext_cap_enable PARAM_VALUE.cfg_ext_if } {
##  if { [get_property value ${PARAM_VALUE.cfg_ext_if}] } {
##      set_property enabled true ${PARAM_VALUE.acs_ext_cap_enable}
##  } else {
##      set_property enabled false ${PARAM_VALUE.acs_ext_cap_enable}
##      set_property value false ${PARAM_VALUE.acs_ext_cap_enable}
##  }
##}

proc update_gui_for_PARAM_VALUE.cfg_ext_if {IPINST PARAM_VALUE.cfg_ext_if PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE PARAM_VALUE.device_port_type} { 
  set c_xfamily [string toupper ${PROJECT_PARAM.ARCHITECTURE}]
  set device    [string toupper ${PROJECT_PARAM.DEVICE}]
  
  if {$device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $c_xfamily == "KINTEX7" || $c_xfamily == "QKINTEX7" || $c_xfamily == "KINTEX7L" ||  $c_xfamily == "QKINTEX7L" || $c_xfamily == "ARTIX7" || $c_xfamily == "AARTIX7" ||  $c_xfamily == "QARTIX7" ||  $c_xfamily == "ARTIX7L" || $c_xfamily == "ZYNQ" || $c_xfamily == "AZYNQ" || $c_xfamily == "QZYNQ"} {
    set_property visible false  [ipgui::get_guiparamspec cfg_ext_if -of $IPINST ]
  } else {
    set_property visible true  [ipgui::get_guiparamspec cfg_ext_if -of $IPINST ]
    if {[get_property value ${PARAM_VALUE.cfg_ext_if}] && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} { 
      set_property visible false [ipgui::get_guiparamspec -name ext_xvc_vsec_enable -of $IPINST]
    } else { 
      set_property visible true [ipgui::get_guiparamspec -name ext_xvc_vsec_enable -of $IPINST]
    }
  }

}

proc update_PARAM_VALUE.parity_settings {PARAM_VALUE.parity_settings PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE} { 
  set c_xfamily [string toupper ${PROJECT_PARAM.ARCHITECTURE}]
  set device    [string toupper ${PROJECT_PARAM.DEVICE}]

  if {$c_xfamily == "QVIRTEX7"  ||  $c_xfamily == "VIRTEX7" || $device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $c_xfamily == "KINTEX7" || $c_xfamily == "QKINTEX7" || $c_xfamily == "KINTEX7L" ||  $c_xfamily == "QKINTEX7L" || $c_xfamily == "ARTIX7" || $c_xfamily == "AARTIX7" ||  $c_xfamily == "QARTIX7" ||  $c_xfamily == "ARTIX7L" || $c_xfamily == "ZYNQ" || $c_xfamily == "AZYNQ" || $c_xfamily == "QZYNQ"} {
    set_property enabled false ${PARAM_VALUE.parity_settings}
    set_property value "None" ${PARAM_VALUE.parity_settings}
  } else { 
    set_property enabled true ${PARAM_VALUE.parity_settings}
  }
}

proc update_gui_for_PARAM_VALUE.parity_settings {IPINST PARAM_VALUE.parity_settings PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE} { 
  set c_xfamily [string toupper ${PROJECT_PARAM.ARCHITECTURE}]
  set device    [string toupper ${PROJECT_PARAM.DEVICE}]

  if {$c_xfamily == "QVIRTEX7"  ||  $c_xfamily == "VIRTEX7" || $device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $c_xfamily == "KINTEX7" || $c_xfamily == "QKINTEX7" || $c_xfamily == "KINTEX7L" ||  $c_xfamily == "QKINTEX7L" || $c_xfamily == "ARTIX7" || $c_xfamily == "AARTIX7" ||  $c_xfamily == "QARTIX7" ||  $c_xfamily == "ARTIX7L" || $c_xfamily == "ZYNQ" || $c_xfamily == "AZYNQ" || $c_xfamily == "QZYNQ"} {
    set_property visible false  [ipgui::get_guiparamspec parity_settings -of $IPINST ]
  } else { 
    set_property visible true  [ipgui::get_guiparamspec parity_settings -of $IPINST ]
  }
} 

proc update_PARAM_VALUE.xdma_axilite_slave {PARAM_VALUE.xdma_axilite_slave PARAM_VALUE.functional_mode} { 

  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  
  if {$func_mode == "AXI_Bridge"} { 
    set_property value true ${PARAM_VALUE.xdma_axilite_slave}
    set_property enabled false ${PARAM_VALUE.xdma_axilite_slave}
  } else { 
    set_property value false ${PARAM_VALUE.xdma_axilite_slave}
    set_property enabled true ${PARAM_VALUE.xdma_axilite_slave}
  }

}

# Added the below proc in 2017.1 but commented for timebeing. 
# This is based on the verification status that all 4 outstanding transactions (msater write, master read, slave write and slave read)
# have been kept as the same value and verified. This might change in future once the verification is complete. 
#
#proc update_PARAM_VALUE.c_m_axi_num_write {PARAM_VALUE.c_m_axi_num_write PARAM_VALUE.axi_data_width PARAM_VALUE.functional_mode} { 

  #set axi_if_width [get_property value ${PARAM_VALUE.axi_data_width}]
  #set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
 # 
  #if {$func_mode == "AXI_Bridge"} { 
    #if {$axi_if_width == "64_bit"} { 
      #set default_val 4
      #set range_list "2,4"
    #} elseif {$axi_if_width == "128_bit"} {
      #set default_val 8
      #set range_list "2,4,8"
    #} elseif {$axi_if_width == "256_bit"} {
      #set default_val 8 
      #set range_list "2,4,8,16"
    #} elseif {$axi_if_width == "512_bit"} {
      #set default_val 8
      #set range_list "2,4,8,16,32"
    #}
  #} else { 
    #set default_val 8
    #set range_list "2,4,8,16,32"
  #}

  #set_property range_value "$default_val,$range_list" ${PARAM_VALUE.c_m_axi_num_write}
#
#} 

proc update_MODELPARAM_VALUE.C_M_AXI_NUM_WRITE {MODELPARAM_VALUE.C_M_AXI_NUM_WRITE PARAM_VALUE.axi_data_width PARAM_VALUE.functional_mode} { 

  set axi_if_width [get_property value ${PARAM_VALUE.axi_data_width}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$axi_if_width == "64_bit"} { 
    set default_val 4
  } elseif {$axi_if_width == "128_bit"} {
    set default_val 8
  } elseif {$axi_if_width == "256_bit"} {
    set default_val 16 
  } elseif {$axi_if_width == "512_bit"} {
    set default_val 32 
  }

  set_property value $default_val ${MODELPARAM_VALUE.C_M_AXI_NUM_WRITE}

}

proc update_MODELPARAM_VALUE.XDMA_RNUM_CHNL {MODELPARAM_VALUE.XDMA_RNUM_CHNL PARAM_VALUE.xdma_rnum_chnl} {
    set_property value [get_property value ${PARAM_VALUE.xdma_rnum_chnl}] ${MODELPARAM_VALUE.XDMA_RNUM_CHNL}
}

proc update_MODELPARAM_VALUE.XDMA_WNUM_CHNL {MODELPARAM_VALUE.XDMA_WNUM_CHNL PARAM_VALUE.xdma_wnum_chnl} {
    set_property value [get_property value ${PARAM_VALUE.xdma_wnum_chnl}] ${MODELPARAM_VALUE.XDMA_WNUM_CHNL}
}

proc update_MODELPARAM_VALUE.XDMA_RNUM_RIDS {MODELPARAM_VALUE.XDMA_RNUM_RIDS PARAM_VALUE.xdma_rnum_rids} {
    set_property value [get_property value ${PARAM_VALUE.xdma_rnum_rids}] ${MODELPARAM_VALUE.XDMA_RNUM_RIDS}
}

proc update_MODELPARAM_VALUE.XDMA_WNUM_RIDS {MODELPARAM_VALUE.XDMA_WNUM_RIDS PARAM_VALUE.xdma_wnum_rids} {
    set_property value [get_property value ${PARAM_VALUE.xdma_wnum_rids}] ${MODELPARAM_VALUE.XDMA_WNUM_RIDS}
}

proc update_MODELPARAM_VALUE.XDMA_AXILITE_SLAVE {MODELPARAM_VALUE.XDMA_AXILITE_SLAVE PARAM_VALUE.xdma_axilite_slave} {
    set_property value [string toupper [get_property value ${PARAM_VALUE.xdma_axilite_slave}]] ${MODELPARAM_VALUE.XDMA_AXILITE_SLAVE}
}

proc update_MODELPARAM_VALUE.XDMA_NUM_USR_IRQ {MODELPARAM_VALUE.XDMA_NUM_USR_IRQ PARAM_VALUE.xdma_num_usr_irq} {
    set_property value [get_property value ${PARAM_VALUE.xdma_num_usr_irq}] ${MODELPARAM_VALUE.XDMA_NUM_USR_IRQ}
}

proc update_MODELPARAM_VALUE.XDMA_AXILITE_MASTER {MODELPARAM_VALUE.XDMA_AXILITE_MASTER PARAM_VALUE.axilite_master_en} {
    set_property value [string toupper [get_property value ${PARAM_VALUE.axilite_master_en}]] ${MODELPARAM_VALUE.XDMA_AXILITE_MASTER}
}

proc update_MODELPARAM_VALUE.XDMA_AXIST_BYPASS {MODELPARAM_VALUE.XDMA_AXIST_BYPASS PARAM_VALUE.axist_bypass_en} {
    set_property value [string toupper [get_property value ${PARAM_VALUE.axist_bypass_en}]] ${MODELPARAM_VALUE.XDMA_AXIST_BYPASS}
}

proc update_MODELPARAM_VALUE.DSC_BYPASS_RD {PARAM_VALUE.dsc_bypass_rd MODELPARAM_VALUE.DSC_BYPASS_RD} {
    set dsc_bypass_rd [get_property value ${PARAM_VALUE.dsc_bypass_rd}]

    switch $dsc_bypass_rd {
        "0000" {set val 0}
        "0001" {set val 1}
        "0010" {set val 2}
        "0011" {set val 3}
        "0100" {set val 4}
        "0101" {set val 5}
        "0110" {set val 6}
        "0111" {set val 7}
        "1000" {set val 8}
        "1001" {set val 9}
        "1010" {set val 10}
        "1011" {set val 11}
        "1100" {set val 12}
        "1101" {set val 13}
        "1110" {set val 14}
        "1111" {set val 15}
    }
    set_property value $val ${MODELPARAM_VALUE.DSC_BYPASS_RD}
}

proc update_MODELPARAM_VALUE.DSC_BYPASS_WR {PARAM_VALUE.dsc_bypass_wr MODELPARAM_VALUE.DSC_BYPASS_WR} {

    set dsc_bypass_wr [get_property value ${PARAM_VALUE.dsc_bypass_wr}]

    switch $dsc_bypass_wr {
        "0000" {set val 0}
        "0001" {set val 1}
        "0010" {set val 2}
        "0011" {set val 3}
        "0100" {set val 4}
        "0101" {set val 5}
        "0110" {set val 6}
        "0111" {set val 7}
        "1000" {set val 8}
        "1001" {set val 9}
        "1010" {set val 10}
        "1011" {set val 11}
        "1100" {set val 12}
        "1101" {set val 13}
        "1110" {set val 14}
        "1111" {set val 15}
    }
    set_property value $val ${MODELPARAM_VALUE.DSC_BYPASS_WR}
}

proc update_MODELPARAM_VALUE.WR_CH0_ENABLED {MODELPARAM_VALUE.WR_CH0_ENABLED PARAM_VALUE.dsc_bypass_wr} {
    set dsc_bypass_wr [get_property value ${PARAM_VALUE.dsc_bypass_wr}]

    if {$dsc_bypass_wr == "0001" || $dsc_bypass_wr == "0011" || $dsc_bypass_wr == "0101" || $dsc_bypass_wr == "0111"
        || $dsc_bypass_wr == "1001" || $dsc_bypass_wr == "1011" || $dsc_bypass_wr == "1101" || $dsc_bypass_wr == "1111"} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }

    set_property value $val ${MODELPARAM_VALUE.WR_CH0_ENABLED}
}

proc update_MODELPARAM_VALUE.WR_CH1_ENABLED {MODELPARAM_VALUE.WR_CH1_ENABLED PARAM_VALUE.dsc_bypass_wr} {
    set dsc_bypass_wr [get_property value ${PARAM_VALUE.dsc_bypass_wr}]

    if {$dsc_bypass_wr == "0010" || $dsc_bypass_wr == "0011" || $dsc_bypass_wr == "0110" || $dsc_bypass_wr == "0111"
        || $dsc_bypass_wr == "1010" || $dsc_bypass_wr == "1011" || $dsc_bypass_wr == "1110" || $dsc_bypass_wr == "1111"} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }

    set_property value $val ${MODELPARAM_VALUE.WR_CH1_ENABLED}
}

proc update_MODELPARAM_VALUE.WR_CH2_ENABLED {MODELPARAM_VALUE.WR_CH2_ENABLED PARAM_VALUE.dsc_bypass_wr} {
    set dsc_bypass_wr [get_property value ${PARAM_VALUE.dsc_bypass_wr}]

    if {$dsc_bypass_wr == "0100" || $dsc_bypass_wr == "0101" || $dsc_bypass_wr == "0110" || $dsc_bypass_wr == "0111"
        || $dsc_bypass_wr == "1100" || $dsc_bypass_wr == "1101" || $dsc_bypass_wr == "1110" || $dsc_bypass_wr == "1111"} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }

    set_property value $val ${MODELPARAM_VALUE.WR_CH2_ENABLED}
}

proc update_MODELPARAM_VALUE.WR_CH3_ENABLED {MODELPARAM_VALUE.WR_CH3_ENABLED PARAM_VALUE.dsc_bypass_wr} {
    set dsc_bypass_wr [get_property value ${PARAM_VALUE.dsc_bypass_wr}]

    if {$dsc_bypass_wr == "1000" || $dsc_bypass_wr == "1001" || $dsc_bypass_wr == "1010" || $dsc_bypass_wr == "1011"
        || $dsc_bypass_wr == "1100" || $dsc_bypass_wr == "1101" || $dsc_bypass_wr == "1110" || $dsc_bypass_wr == "1111"} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }

    set_property value $val ${MODELPARAM_VALUE.WR_CH3_ENABLED}
}

## Procedure to set the parameters indicate which Read Channel is enabled.
proc update_MODELPARAM_VALUE.RD_CH0_ENABLED {MODELPARAM_VALUE.RD_CH0_ENABLED PARAM_VALUE.dsc_bypass_rd} {
    set dsc_bypass_rd [get_property value ${PARAM_VALUE.dsc_bypass_rd}]

    if {$dsc_bypass_rd == "0001" || $dsc_bypass_rd == "0011" || $dsc_bypass_rd == "0101" || $dsc_bypass_rd == "0111"
        || $dsc_bypass_rd == "1001" || $dsc_bypass_rd == "1011" || $dsc_bypass_rd == "1101" || $dsc_bypass_rd == "1111"} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }

    set_property value $val ${MODELPARAM_VALUE.RD_CH0_ENABLED}
}

proc update_MODELPARAM_VALUE.RD_CH1_ENABLED {MODELPARAM_VALUE.RD_CH1_ENABLED PARAM_VALUE.dsc_bypass_rd} {
    set dsc_bypass_rd [get_property value ${PARAM_VALUE.dsc_bypass_rd}]

    if {$dsc_bypass_rd == "0010" || $dsc_bypass_rd == "0011" || $dsc_bypass_rd == "0110" || $dsc_bypass_rd == "0111"
        || $dsc_bypass_rd == "1010" || $dsc_bypass_rd == "1011" || $dsc_bypass_rd == "1110" || $dsc_bypass_rd == "1111"} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }

    set_property value $val ${MODELPARAM_VALUE.RD_CH1_ENABLED}
}

proc update_MODELPARAM_VALUE.RD_CH2_ENABLED {MODELPARAM_VALUE.RD_CH2_ENABLED PARAM_VALUE.dsc_bypass_rd} {
    set dsc_bypass_rd [get_property value ${PARAM_VALUE.dsc_bypass_rd}]

    if {$dsc_bypass_rd == "0100" || $dsc_bypass_rd == "0101" || $dsc_bypass_rd == "0110" || $dsc_bypass_rd == "0111"
        || $dsc_bypass_rd == "1100" || $dsc_bypass_rd == "1101" || $dsc_bypass_rd == "1110" || $dsc_bypass_rd == "1111"} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }

    set_property value $val ${MODELPARAM_VALUE.RD_CH2_ENABLED}
}

proc update_MODELPARAM_VALUE.RD_CH3_ENABLED {MODELPARAM_VALUE.RD_CH3_ENABLED PARAM_VALUE.dsc_bypass_rd} {
    set dsc_bypass_rd [get_property value ${PARAM_VALUE.dsc_bypass_rd}]

    if {$dsc_bypass_rd == "1000" || $dsc_bypass_rd == "1001" || $dsc_bypass_rd == "1010" || $dsc_bypass_rd == "1011"
        || $dsc_bypass_rd == "1100" || $dsc_bypass_rd == "1101" || $dsc_bypass_rd == "1110" || $dsc_bypass_rd == "1111"} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }

    set_property value $val ${MODELPARAM_VALUE.RD_CH3_ENABLED}
}

proc update_MODELPARAM_VALUE.XDMA_STS_PORTS {MODELPARAM_VALUE.XDMA_STS_PORTS PARAM_VALUE.xdma_sts_ports} {
    set_property value [string toupper [get_property value ${PARAM_VALUE.xdma_sts_ports}]] ${MODELPARAM_VALUE.XDMA_STS_PORTS}
}

proc update_MODELPARAM_VALUE.C_METERING_ON {MODELPARAM_VALUE.C_METERING_ON PARAM_VALUE.performance} {
    set performance [get_property value ${PARAM_VALUE.performance}]

    if {$performance == "true"} {
        set val 0
    } else {
        set val 1
    }

    set_property value $val ${MODELPARAM_VALUE.C_METERING_ON}
}


proc update_MODELPARAM_VALUE.RX_DETECT {MODELPARAM_VALUE.RX_DETECT PARAM_VALUE.rx_detect} {

    set rx_detect [get_property value ${PARAM_VALUE.rx_detect}]

    if {$rx_detect eq "Default"} {
        set val 0
    } elseif {$rx_detect eq "Falling_Edge"} {
        set val 1
    }

    set_property value $val ${MODELPARAM_VALUE.RX_DETECT}
}

proc DT_Shared_Logic {PARAM_VALUE.Shared_Logic PARAM_VALUE.Shared_Logic_Both PARAM_VALUE.Shared_Logic_Clk PARAM_VALUE.Shared_Logic_Gtc PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.plltype} {
    set c_xfamily  [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set Plltype [ get_property value ${PARAM_VALUE.plltype}]

    if {($c_xfamily == "virtexuplus" || $c_xfamily == "kintexuplus" || $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm")} {
        if {[get_property value ${PARAM_VALUE.Shared_Logic}] == 0} {
            set    text "Include Shared Logic in example design\n"
            append text "- For users who want the Shared Logic outside the core.\n"
            append text "- For users who want to edit the Shared Logic or use their own.\n"
            append text "- For users who want one core with Shared Logic to drive multiple cores without Shared Logic.\n\n"
        } else {
            set    text "Include Shared Logic in core\n"
            append text "- For users who want a complete single solution.\n"
            append text "- For users who want one core with Shared Logic to drive multiple cores without Shared Logic.\n\n\n"
        }
    } elseif {($c_xfamily == "kintexu" || $c_xfamily == "virtexu")} {
        if {$Plltype == "CPLL"} {
            set    text "CPLL is selected and Sharing Option is invalid\n"
            append text "- GT_COMMON Sharing is available for Gen2 and Gen3 Speeds.\n"
        } elseif {[get_property value ${PARAM_VALUE.Shared_Logic}] == 0} {
            set    text "Include GT_COMMON Shared Logic in example design\n"
            append text "- For users who want the Shared Logic outside the core.\n"
            append text "- For users who want to edit the Shared Logic or use their own.\n"
            append text "- For users who want one core with Shared Logic to drive multiple cores without Shared Logic.\n\n"
        } else {
            set    text "Include GT_COMMON Shared Logic in core\n"
            append text "- For users who want a complete single solution.\n"
            append text "- For users who want one core with Shared Logic to drive multiple cores without Shared Logic.\n\n\n"
        }
    } else {
        if {([get_property value ${PARAM_VALUE.Shared_Logic_Both}] eq "false") && ([get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] eq "false") && ([get_property value ${PARAM_VALUE.Shared_Logic_Clk}] eq "false")} {
            set    text "Core with No Shared Logic\n"
            append text "- The CLOCKING and GT_COMMON used by this core are located in this IP core, and not available for sharing with other IP core\n"
        } elseif {[get_property value ${PARAM_VALUE.Shared_Logic_Both}] eq "true"} {
            set    text "Core with internal CLOCKING and GT_COMMON\n"
            append text "- The CLOCKING and GT_COMMON used by this IP core are located in this IP core, and are available for sharing with other IP cores\n"
            append text "- Please consult the product guide for information on the additional ports that are generated on this IP core to facilitate sharing\n\n\n"
        } elseif {([get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] eq "true") && ([get_property value ${PARAM_VALUE.Shared_Logic_Clk}] eq "true")} {
            set    text "Core with external CLOCKING and GT_COMMON\n"
            append text "- The CLOCKING and GT_COMMON used by this core are located in its Example Design,\n"
            append text "  and are available for sharing with other IP cores\n\n\n"
        } elseif {[get_property value ${PARAM_VALUE.Shared_Logic_Clk}] eq "true"} {
            set    text "Core with external CLOCKING and internal GT_COMMON\n"
            append text "- CLOCKING used by this core is located in its Example Design and is available for sharing with other IP cores\n"
            append text "- GT_COMMON is internal and not available to share\n"
            append text "- This option was also available with previous versions of the core\n\n\n"
        } elseif {[get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] eq "true"} {
            set    text "Core with external GT_COMMON and internal CLOCKING\n"
            append text "- GT_COMMON used by this  core is located in its Example Design and are available for sharing with other IP cores\n"
            append text "- CLOCKING is internal and not available to share\n\n\n"
        } else {
            set    text "Core with external CLOCKING and internal GT_COMMON\n"
            append text "- CLOCKING used by this  core is located in its Example Design and is available for sharing with other IP cores\n"
            append text "- GT_COMMON is internal and not available to share\n"
            append text "- This option was also available with previous versions of the core\n\n\n"
        }
    }
    return $text
}

proc update_PARAM_VALUE.pf0_class_code {PARAM_VALUE.pf0_class_code PARAM_VALUE.pf0_class_code_interface PARAM_VALUE.pf0_class_code_sub PARAM_VALUE.pf0_class_code_base} {
    set pf ${PARAM_VALUE.pf0_class_code}
    set value1 [expr "0x[get_property value ${PARAM_VALUE.pf0_class_code_interface}] | 0x[get_property value ${PARAM_VALUE.pf0_class_code_sub}]00 | 0x[get_property value ${PARAM_VALUE.pf0_class_code_base}]0000" ]
    set_property value "[format %06X $value1]" ${PARAM_VALUE.pf0_class_code}
    set_property enabled FALSE ${PARAM_VALUE.pf0_class_code}
}

proc update_PARAM_VALUE.pf1_class_code {PARAM_VALUE.pf1_class_code PARAM_VALUE.pf1_class_code_interface PARAM_VALUE.pf1_class_code_sub PARAM_VALUE.pf1_class_code_base} {
    set pf ${PARAM_VALUE.pf1_class_code}
    set value1 [expr "0x[get_property value ${PARAM_VALUE.pf1_class_code_interface}] | 0x[get_property value ${PARAM_VALUE.pf1_class_code_sub}]00 | 0x[get_property value ${PARAM_VALUE.pf1_class_code_base}]0000" ]
    set_property value "[format %06X $value1]" ${PARAM_VALUE.pf1_class_code}
    set_property enabled FALSE ${PARAM_VALUE.pf1_class_code}
}

proc update_PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED {PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH PARAM_VALUE.enable_gen4 PROJECT_PARAM.SPEEDGRADE PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.SILICON_REVISION PROJECT_PARAM.DEVICE PARAM_VALUE.split_dma} {
    set PL_LINK_CAP_MAX_LINK_SPEED ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}
    set PL_LINK_CAP_MAX_LINK_WIDTH [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}]
    set c_xfamily                  [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set c_xdevice                  ${PROJECT_PARAM.DEVICE}
    set speed                      [string toupper ${PROJECT_PARAM.SPEEDGRADE}]
    set silicon_rev                [string toupper ${PROJECT_PARAM.SILICON_REVISION}]
    set device                     [string toupper $c_xdevice]
    set c_xfamily_gen2             [string toupper ${PROJECT_PARAM.ARCHITECTURE}]
    set split_dma                  [get_property value ${PARAM_VALUE.split_dma}]

    if {$c_xfamily == "virtexuplus" || $c_xfamily == "kintexuplus" || $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
      if {($PL_LINK_CAP_MAX_LINK_WIDTH eq "X16" && ($speed == "-1" || $speed == "-1LV" || $speed == "-2LV" || $speed == "-1L")) ||  ($PL_LINK_CAP_MAX_LINK_WIDTH eq "X8" && ($speed == "-1LV" || $speed == "-1L") )  } { 
        set_property range "2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
      } elseif {$PL_LINK_CAP_MAX_LINK_WIDTH eq "X16" && ($device == "XAZU4EV" || $device == "XAZU5EV" || $device == "XCZU4EV" || $device == "XCZU5EV" || $device == "XCZU4CG" || $device == "XCZU4EG" || $device == "XCZU5CG" || $device == "XCZU5EG")} { 
        set_property range "2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
      } elseif {$PL_LINK_CAP_MAX_LINK_WIDTH ne "X16" && [get_property value ${PARAM_VALUE.enable_gen4}]} { 
        set_property range "2.5_GT/s,5.0_GT/s,8.0_GT/s,16.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
      } else {
        set_property range "2.5_GT/s,5.0_GT/s,8.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
	if { $split_dma } {
          set_property range "8.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
	}
      }
    } elseif {$c_xfamily == "kintexu" || $c_xfamily == "virtexu"} {
      if {($speed == "-1" || $speed == "-1L" ||  $speed == "-1LV" || $speed == "-1H" || $speed == "-1HV")} {
        if {($device == "XCVU095" && $silicon_rev == "ES1") || (($device == "XCKU060" || $device == "XQKU060") && $silicon_rev == "ES2") || ($device == "XCKU115" && $silicon_rev == "ES2") || ($device == "XCVU440" && $silicon_rev == "ES2")} {
          set_property range "2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
        } else {
          if {$PL_LINK_CAP_MAX_LINK_WIDTH ne "X8"} {
            set_property range "2.5_GT/s,5.0_GT/s,8.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
          } else {
            set_property range "2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
          }
        }
      } else {
        set_property range "2.5_GT/s,5.0_GT/s,8.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
      }
    ## If this is for a gen2 device Disable Gen3
    } elseif {$c_xfamily_gen2 == "ARTIX7"} { 
      if {([string tolower "$speed"] == "-1") || ([string tolower "$speed"] == "-1i") || ([string tolower "$speed"] == "-1m") || ([string tolower "$speed"] == "-1q") || ([string tolower "$speed"] == "-1l") || ([string tolower "$speed"] == "-1il")} {
        set_property range_value "2.5_GT/s,2.5_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
      } else {
        if {$device == "XC7A15TL" || $device == "XC7A35TL" || $device == "XC7A50TL" || $device == "XC7A75TL" || $device == "XC7A100TL" || $device == "XC7A200TL"} { 
          set_property range_value "2.5_GT/s,2.5_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
        } else { 
          set_property range_value "2.5_GT/s,2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
        }
      }
    } elseif {$c_xfamily_gen2 == "KINTEX7"} { 
      if {([string tolower "$speed"] == "-1") || ([string tolower "$speed"] == "-1i") || ([string tolower "$speed"] == "-1m") || ([string tolower "$speed"] == "-1ml") } {
        if {$PL_LINK_CAP_MAX_LINK_WIDTH == "X8"} {
          set_property range_value "2.5_GT/s,2.5_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
	} else {
	  set_property range_value "2.5_GT/s,2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
	}
      } else {
        if {$device == "XC7K70TL" || $device == "XC7K160TL" || $device == "XC7K325TL" || $device == "XC7K355TL" || $device == "XC7K410TL" || $device == "XC7K420TL" || $device == "XC7K480TL" || $device == "XQ7K325TL" || $device == "XQ7K410TL"} { 
          set_property range_value "2.5_GT/s,2.5_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
        } else {
	  set_property range_value "2.5_GT/s,2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
	}
      }
    } elseif {$c_xfamily_gen2 == "VIRTEX7" && ($device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T")} { 
      if {([string tolower "$speed"] == "-1") || ([string tolower "$speed"] == "-1i") || ([string tolower "$speed"] == "-1m")} {
	if {$PL_LINK_CAP_MAX_LINK_WIDTH == "X8"} {
	  set_property range_value "2.5_GT/s,2.5_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
	} else {
	  set_property range_value "2.5_GT/s,2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
	}
      } else {
	set_property range_value "2.5_GT/s,2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
      }
    } elseif {$c_xfamily_gen2 == "ZYNQ"} { 
      if {([string tolower "$speed"] == "-1") || ([string tolower "$speed"] == "-1i") || ([string tolower "$speed"] == "-1q") || ([string tolower "$speed"] == "-1l") || ([string tolower "$speed"] == "-1ql")} {
        if {$PL_LINK_CAP_MAX_LINK_WIDTH == "X8"} {
	  set_property range_value "2.5_GT/s,2.5_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
	} elseif {($device == "XC7Z015" || $device == "XC7Z015I")} { 
	  set_property range_value "2.5_GT/s,2.5_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
	} else {
	  set_property range_value "2.5_GT/s,2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
        }
      } else {
        set_property range_value "2.5_GT/s,2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
      }
    } else {
      if {($speed == "-1") || ($speed == "-1L") || ($speed == "-1I") || ($speed == "-1M")} {
         set_property range "2.5_GT/s,5.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
      } else {
        set_property range "2.5_GT/s,5.0_GT/s,8.0_GT/s" $PL_LINK_CAP_MAX_LINK_SPEED
      }
    }
}

proc update_PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH {PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE PROJECT_PARAM.PART PROJECT_PARAM.SPEEDGRADE PARAM_VALUE.en_gt_selection PARAM_VALUE.pcie_blk_locn PARAM_VALUE.select_quad PARAM_VALUE.PCIE_BOARD_INTERFACE PARAM_VALUE.vu9p_board PARAM_VALUE.split_dma} {
    set c_xdevice      ${PROJECT_PARAM.DEVICE}
    set c_xpackage      [ getpackage_name ${PROJECT_PARAM.PART} ${PROJECT_PARAM.SPEEDGRADE} ${PROJECT_PARAM.DEVICE}]
    set device [string toupper $c_xdevice]
    set pkg [string toupper $c_xpackage]
    set c_xfamily        [ getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set fmly [string toupper $c_xfamily]
    set PL_LINK_CAP_MAX_LINK_WIDTH ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}
    set speed_grade [string toupper ${PROJECT_PARAM.SPEEDGRADE}]
    set en_gt_selection [get_property value ${PARAM_VALUE.en_gt_selection}]
    set pcie_blk [get_property value ${PARAM_VALUE.pcie_blk_locn}]
    set select_quad [get_property value ${PARAM_VALUE.select_quad}]
    set vu9p_board [get_property value ${PARAM_VALUE.vu9p_board}]
    set split_dma  [get_property value ${PARAM_VALUE.split_dma}]

    set boardIfName [get_property value ${PARAM_VALUE.PCIE_BOARD_INTERFACE}]

    if {$boardIfName ne "Custom"} {
        set_property enabled false $PL_LINK_CAP_MAX_LINK_WIDTH
    } else {
        set_property enabled true $PL_LINK_CAP_MAX_LINK_WIDTH
     ##   set_property value [get_property default_value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}] $PL_LINK_CAP_MAX_LINK_WIDTH
    }
    if {($fmly eq "VIRTEXUPLUS") || ($fmly eq "KINTEXUPLUS") || ($fmly eq "ZYNQUPLUS") || ($fmly eq "ZYNQUPLUSRFSOC") || ($fmly eq "VIRTEXUPLUSHBM")} {
      if {$en_gt_selection == "true"} {
        ## Following GT Quads/devices/packages should allow only X1,X2,X4,X8 range
        if {($device == "XCVU3P" && $pkg == "FFVC1517" && ($select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225")) 
          || (($device == "XCVU5P" || $device == "XCVU7P") && $pkg == "FLVA2104" && ($select_quad == "GTY_Quad_127" || $select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_132" || $select_quad == "GTY_Quad_131" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_233" || $select_quad == "GTY_Quad_232")) 
          || (($device == "XCVU5P" || $device == "XCVU7P") && $pkg == "FLVB2104" && ($select_quad == "GTY_Quad_127" || $select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_131" || $select_quad == "GTY_Quad_130" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_231" || $select_quad == "GTY_Quad_230"))
          || (($device == "XCVU5P" || $device == "XCVU7P") && $pkg == "FLVC2104" && ($select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_131" || $select_quad == "GTY_Quad_130" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_231" || $select_quad == "GTY_Quad_230"))
          || ($device == "XCVU9P" && $pkg == "FLGA2104" && ($select_quad == "GTY_Quad_127" || $select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_122" || $select_quad == "GTY_Quad_121" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_233" || $select_quad == "GTY_Quad_232")) 
          || ($device == "XCVU9P" && $pkg == "FLGB2104" && ($select_quad == "GTY_Quad_122" || $select_quad == "GTY_Quad_121" || $select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_231" || $select_quad == "GTY_Quad_230"))
          || ($device == "XCVU9P" && $pkg == "FLGC2104" && ($select_quad == "GTY_Quad_122" || $select_quad == "GTY_Quad_121" || $select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_131" || $select_quad == "GTY_Quad_130" || $select_quad == "GTY_Quad_222" || $select_quad == "GTY_Quad_221" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_231" || $select_quad == "GTY_Quad_230"))
          || ($device == "XCVU9P" && $pkg == "FLGA2577" && ($select_quad == "GTY_Quad_121" || $select_quad == "GTY_Quad_120" || $select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_131" || $select_quad == "GTY_Quad_130" || $select_quad == "GTY_Quad_221" || $select_quad == "GTY_Quad_220" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_231" || $select_quad == "GTY_Quad_230"))
          || ($device == "XCVU9P" && $pkg == "FSGD2104" && ($select_quad == "GTY_Quad_122" || $select_quad == "GTY_Quad_121" || $select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_231" || $select_quad == "GTY_Quad_230"))
          || ($device == "XCVU11P" && ($pkg == "FLGA2577" || $pkg == "FLGC2104") && ($select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_230" || $select_quad == "GTY_Quad_229" || $select_quad == "GTY_Quad_234" || $select_quad == "GTY_Quad_233"))
          || ($device == "XCVU11P" && ($pkg == "FLGB2104" || $pkg == "FLGF1924") && ($select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_230" || $select_quad == "GTY_Quad_229" || $select_quad == "GTY_Quad_233"))
          || ($device == "XCVU11P" && $pkg == "FSGD2104" && ($select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_230" || $select_quad == "GTY_Quad_229" || $select_quad == "GTY_Quad_233"))
          || ($device == "XCVU13P" && $pkg == "FHGA2104" && ($select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_231" || $select_quad == "GTY_Quad_230"))
          || ($device == "XCVU13P" && ($pkg == "FHGB2104" || $pkg == "FIGD2104" ) && ($select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_230" || $select_quad == "GTY_Quad_229" || $select_quad == "GTY_Quad_233"))
          || ($device == "XCVU13P" && $pkg == "FHGC2104" && ($select_quad == "GTY_Quad_223" || $select_quad == "GTY_Quad_222" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_230" || $select_quad == "GTY_Quad_229" || $select_quad == "GTY_Quad_233"))
          || ($device == "XCVU13P" && $pkg == "FLGA2577" && ($select_quad == "GTY_Quad_222" || $select_quad == "GTY_Quad_221" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_230" || $select_quad == "GTY_Quad_229" || $select_quad == "GTY_Quad_234" || $select_quad == "GTY_Quad_233"))
          || ($device == "XCKU11P" && $pkg == "FFVE1517" && (($select_quad == "GTY_Quad_130" && $pcie_blk == "X0Y3") || $select_quad == "GTY_Quad_129" || $select_quad == "GTY_Quad_128" || $select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225" || ($select_quad == "GTH_Quad_227" && $pcie_blk == "X1Y1")))
          || (($device == "XCKU11P" || $device == "XCKU15P") && $pkg == "FFVA1156" && ($select_quad == "GTY_Quad_130" || $select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225" || ($select_quad == "GTH_Quad_227" && $pcie_blk == "X1Y1")))
          || ($device == "XCKU11P" && $pkg == "FFVD900" && ($select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225"))
          || ($device == "XCKU15P" && $pkg == "FFVE1517" && ($select_quad == "GTY_Quad_131" || ($select_quad == "GTY_Quad_130" && $pcie_blk == "X0Y3") || $select_quad == "GTY_Quad_129" || $select_quad == "GTY_Quad_128" || $select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225" || ($select_quad == "GTH_Quad_227" && ($pcie_blk == "X1Y1" || $pcie_blk == "X1Y2")) || ($select_quad == "GTH_Quad_229" && $pcie_blk == "X1Y2") || ($select_quad == "GTH_Quad_228" && $pcie_blk == "X1Y2") || ($select_quad == "GTH_Quad_230"))) 
          || ($device == "XCKU15P"  && ($pkg == "FFVA1760" || $pkg == "FFVE1760") && ($select_quad == "GTY_Quad_131" || ($select_quad == "GTY_Quad_130" && $pcie_blk == "X0Y3") || $select_quad == "GTY_Quad_129" || $select_quad == "GTY_Quad_128" || $select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225" || ($select_quad == "GTH_Quad_227" && ($pcie_blk == "X1Y1" || $pcie_blk == "X1Y2")) || ($select_quad == "GTH_Quad_229" && $pcie_blk == "X1Y2") || ($select_quad == "GTH_Quad_228" && $pcie_blk == "X1Y2") || ($select_quad == "GTH_Quad_230")))
          || (($device == "XCKU3P" || $device == "XCKU5P") && ($pkg == "FFVA676" || $pkg == "FFVB676" || $pkg == "FFVD900" || $pkg == "SFVB784") && ($select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225"))
          || (($device == "XCZU11EG" || $device == "XCZU17EG" || $device == "XCZU19EG") && $pkg == "FFVC1760" && ($select_quad == "GTY_Quad_130" || $select_quad == "GTY_Quad_129" || $select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225" || ($select_quad == "GTH_Quad_227" && ($pcie_blk == "X1Y1" || $pcie_blk == "X1Y2")) || ($select_quad == "GTH_Quad_229" && $pcie_blk == "X1Y2") || ($select_quad == "GTH_Quad_228" && $pcie_blk == "X1Y2")))
          || (($device == "XCZU17EG" || $device == "XCZU19EG") && $pkg == "FFVE1924" && ($select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225" || ($select_quad == "GTH_Quad_227" && ($pcie_blk == "X1Y1" || $pcie_blk == "X1Y2")) || ($select_quad == "GTH_Quad_229" && $pcie_blk == "X1Y2") || ($select_quad == "GTH_Quad_228" && $pcie_blk == "X1Y2"))) 
          || (($device == "XCZU19EG" || $device == "XCZU11EG" || $device == "XCZU17EG") && ($pkg == "FFVB1517" || $pkg == "FFVC1156") && ($select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225") || ($select_quad == "GTH_Quad_227" && $pcie_blk == "X1Y2"))
          || ($device == "XCZU11EG" && $pkg == "FFVF1517" && ($select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225" || ($select_quad == "GTH_Quad_227" && $pcie_blk == "X1Y1")))
          || (($device == "XCZU19EG" || $device == "XCZU17EG") && $pkg == "FFVD1760" && ($select_quad == "GTY_Quad_130" || $select_quad == "GTY_Quad_129" || $select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225" || ($select_quad == "GTH_Quad_227" && ($pcie_blk == "X1Y1" || $pcie_blk == "X1Y2")) || ($select_quad == "GTH_Quad_229" && $pcie_blk == "X1Y2") || ($select_quad == "GTH_Quad_228" && $pcie_blk == "X1Y2") ))
          || (($device == "XCZU4EV" || $device == "XCZU5EV") && $pkg == "FBVB900" && ($select_quad == "GTH_Quad_225" || $select_quad == "GTH_Quad_224"))
          || (($device == "XCZU4CG" || $device == "XCZU4EG" || $device == "XCZU5CG" || $device == "XCZU5EG") && $pkg == "FBVB900" && ($select_quad == "GTH_Quad_225" || $select_quad == "GTH_Quad_224"))
          || ($device == "XCZU7EV" && $pkg == "FBVB900" && ($select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225"))
          || (($device == "XCZU7CG" || $device == "XCZU7EG") && $pkg == "FBVB900" && ($select_quad == "GTH_Quad_226" || $select_quad == "GTH_Quad_225"))
          || ($device == "XCZU7EV" && ($pkg == "FFVC1156" || $pkg == "FFVF1517") && ($select_quad == "GTH_Quad_225" || $select_quad == "GTH_Quad_224")) 
          || (($device == "XCZU7CG" || $device == "XCZU7EG" ) && ($pkg == "FFVC1156" || $pkg == "FFVF1517") && ($select_quad == "GTH_Quad_225" || $select_quad == "GTH_Quad_224")) 
          || ($device == "XCZU21DR" && $pkg == "FFVD1156" && ($select_quad == "GTY_Quad_130" || $select_quad == "GTY_Quad_129"))
          || (($device == "XCZU28DR" || $device == "XCZU27DR") && $pkg == "FFVE1156" && ($select_quad == "GTY_Quad_129"))
          || ($device == "XCZU25DR" && ($pkg == "FFVE1156" || $pkg == "FFVG1517") && ($select_quad == "GTY_Quad_129"))
          || (($device == "XCZU28DR" || $device == "XCZU27DR") && $pkg == "FFVG1517" && ($select_quad == "GTY_Quad_130" || $select_quad == "GTY_Quad_129"))
          || ($device == "XCZU29DR" && $pkg == "FFVF1760" && ($select_quad == "GTY_Quad_130" || $select_quad == "GTY_Quad_129")) 
          || ($device == "XCVU37P" && $pkg == "FSVH2892" && ($select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_230" || $select_quad == "GTY_Quad_229" || $select_quad == "GTY_Quad_234" || $select_quad == "GTY_Quad_233"))
          || ($device == "XCVU31P" && $pkg == "FSVH1924" && ($select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225"))
          || ($device == "XCVU35P" && ($pkg == "FSVH2892" || $pkg == "FSVH2104") && ($select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" || $select_quad == "GTY_Quad_230" || $select_quad == "GTY_Quad_229" || $select_quad == "GTY_Quad_234" || $select_quad == "GTY_Quad_233"))
          || ($device == "XCVU33P" && ($pkg == "FSVH2104") && ($select_quad == "GTY_Quad_126" || $select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_226" || $select_quad == "GTY_Quad_225" ))
          || ($split_dma)
          } {
          set enable_upto_x8 1
          set enable_upto_x4 0
         ## Following GT Quads/devices/packages should allow only X1,X2,X4 range
         } elseif {($device == "XCVU3P" && $pkg == "FFVC1517" && $select_quad == "GTY_Quad_224") 
           || (($device == "XCVU5P" || $device == "XCVU7P") && $pkg == "FLVA2104" && ($select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_130" || $select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_231"))
           || (($device == "XCVU5P" || $device == "XCVU7P") && $pkg == "FLVB2104" && ($select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_229"))
           || (($device == "XCVU5P" || $device == "XCVU7P") && $pkg == "FLVC2104" && ($select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_229"))
           || ($device == "XCVU9P" && $pkg == "FLGA2104" && ($select_quad == "GTY_Quad_125" || $select_quad == "GTY_Quad_120" || $select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_231"))
           || ($device == "XCVU9P" && $pkg == "FLGB2104" && ($select_quad == "GTY_Quad_120" || ($select_quad == "GTY_Quad_224"  && $vu9p_board == "false") || $select_quad == "GTY_Quad_229"))
           || ($device == "XCVU9P" && $pkg == "FLGC2104" && ($select_quad == "GTY_Quad_120" || $select_quad == "GTY_Quad_220" || $select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_229")) 
           || ($device == "XCVU9P" && $pkg == "FLGA2577" && ($select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_229" || $select_quad == "GTY_Quad_219"))
           || ($device == "XCVU9P" && $pkg == "FSGD2104" && ($select_quad == "GTY_Quad_120" || $select_quad == "GTY_Quad_124" || $select_quad == "GTY_Quad_131" || $select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_229"))
           || ($device == "XCVU11P"  && ($select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_228" || $select_quad == "GTY_Quad_232"))
           || ($device == "XCVU11P" && $pkg == "FSGD2104" && ($select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_228" || $select_quad == "GTY_Quad_232"))
           || ($device == "XCVU13P" && $pkg == "FHGA2104" && ($select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_229"))
           || ($device == "XCVU13P" && ($pkg == "FHGB2104" || $pkg == "FIGD2104") && ($select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_228" || $select_quad == "GTY_Quad_232"))
           || ($device == "XCVU13P" && $pkg == "FHGC2104" && ($select_quad == "GTY_Quad_221" || $select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_228" || $select_quad == "GTY_Quad_232"))
           || ($device == "XCVU13P" && $pkg == "FLGA2577" && ($select_quad == "GTY_Quad_220" || $select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_228" || $select_quad == "GTY_Quad_232"))
           || ($device == "XCKU11P" && $pkg == "FFVE1517" && ($select_quad == "GTY_Quad_127" || $select_quad == "GTH_Quad_224"))
           || (($device == "XCKU11P"  || $device == "XCKU15P") && $pkg == "FFVA1156" && ($select_quad == "GTY_Quad_129" || $select_quad == "GTH_Quad_224"))
           || ($device == "XCKU11P" && $pkg == "FFVD900" && $select_quad == "GTH_Quad_224")
           || ($device == "XCKU15P" && ($pkg == "FFVE1517" || $pkg == "FFVA1760" || $pkg == "FFVE1760") && ($select_quad == "GTY_Quad_127" || $select_quad == "GTH_Quad_224"))
           || (($device == "XCKU3P" || $device == "XCKU5P") && ($pkg == "FFVA676" || $pkg == "FFVB676" || $pkg == "FFVD900" || $pkg == "SFVB784") && $select_quad == "GTY_Quad_224")
           || (($device == "XCZU11EG" || $device == "XCZU17EG" || $device == "XCZU19EG") && $pkg == "FFVC1760" && ($select_quad == "GTY_Quad_128" || $select_quad == "GTH_Quad_224"))
           || (($device == "XCZU17EG" || $device == "XCZU19EG") && $pkg == "FFVE1924" && $select_quad == "GTH_Quad_224") 
           || (($device == "XCZU19EG" || $device == "XCZU17EG" || $device == "XCZU11EG" ) && $pkg == "FFVB1517" && $select_quad == "GTH_Quad_224")
           || ($device == "XCZU11EG" && ($pkg == "FFVC1156" || $pkg == "FFVF1517") && $select_quad == "GTH_Quad_224")
           || (($device == "XCZU19EG" || $device == "XCZU17EG") && $pkg == "FFVD1760" && ($select_quad == "GTY_Quad_128" || $select_quad == "GTH_Quad_224"))
           || (($device == "XCZU4EV" || $device == "XCZU5EV") && $pkg == "FBVB900" && $select_quad == "GTH_Quad_223")
           || (($device == "XCZU4CG" || $device == "XCZU4EG" || $device == "XCZU5CG" || $device == "XCZU5EG") && $pkg == "FBVB900" && $select_quad == "GTH_Quad_223")
           || ($device == "XCZU7EV" && $pkg == "FBVB900" && $select_quad == "GTH_Quad_224")
           || (($device == "XCZU7CG" || $device == "XCZU7EG")  && $pkg == "FBVB900" && $select_quad == "GTH_Quad_224")
           || (($device == "XCZU4EV" || $device == "XCZU5EV") && $pkg == "SFVC784" && $select_quad == "GTH_Quad_224")
           || (($device == "XAZU4EV" || $device == "XAZU5EV") && $pkg == "SFVC784" && $select_quad == "GTH_Quad_224")
           || (($device == "XCZU4CG" || $device == "XCZU4EG" || $device == "XCZU5CG" || $device == "XCZU5EG") && $pkg == "SFVC784" && $select_quad == "GTH_Quad_224")
           || ($device == "XCZU7EV" && ($pkg == "FFVC1156" || $pkg == "FFVF1517") && $select_quad == "GTH_Quad_223")
           || (($device == "XCZU7CG" || $device == "XCZU7EG") && ($pkg == "FFVC1156" || $pkg == "FFVF1517") && $select_quad == "GTH_Quad_223")
           || ($device == "XCZU21DR" && $pkg == "FFVD1156" && ($select_quad == "GTY_Quad_128"))
           || (($device == "XCZU28DR" || $device == "XCZU27DR") && $pkg == "FFVE1156" && ($select_quad == "GTY_Quad_128"))
           || ($device == "XCZU25DR" && ($pkg == "FFVE1156" || $pkg == "FFVG1517") && ($select_quad == "GTY_Quad_128"))
           || (($device == "XCZU28DR" || $device == "XCZU27DR" ) && $pkg == "FFVG1517" && ($select_quad == "GTY_Quad_128"))
           || ($device == "XCZU29DR" && $pkg == "FFVF1760" && ($select_quad == "GTY_Quad_128")) 
           || ($device == "XCVU37P" && $pkg == "FSVH2892" && ($select_quad == "GTY_Quad_124" || $select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_228" || $select_quad == "GTY_Quad_232")) 
           || ($device == "XCVU31P" && $pkg == "FSVH1924" && ($select_quad == "GTY_Quad_124" || $select_quad == "GTY_Quad_224")) 
           || ($device == "XCVU35P" && ($pkg == "FSVH2892" || $pkg == "FSVH2104") && ($select_quad == "GTY_Quad_124" || $select_quad == "GTY_Quad_224" || $select_quad == "GTY_Quad_228")) 
           || ($device == "XCVU33P" && ($pkg == "FSVH2104") && ($select_quad == "GTY_Quad_124" || $select_quad == "GTY_Quad_224")) 
           || ($split_dma)
           } {
           set enable_upto_x4 1
           set enable_upto_x8 0
         } else {
           set enable_upto_x8 0
           set enable_upto_x4 0
         }

         if {$enable_upto_x4 == 1} {
           set_property range "X1,X2,X4" $PL_LINK_CAP_MAX_LINK_WIDTH
         } elseif {$enable_upto_x8 == 1} {
           set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
         } else { 
           set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
         }
      } else {
        if {$pkg == "SFVC784" && ($device == "XAZU4EV" || $device == "XAZU5EV" || $device == "XCZU4EV" || $device == "XCZU5EV" || $device == "XCZU4CG" || $device == "XCZU4EG" || $device == "XCZU5CG" || $device == "XCZU5EG")} {
          set_property range "X1,X2,X4" $PL_LINK_CAP_MAX_LINK_WIDTH
        } else {
          if {$pkg == "FFVC1760" && ($device == "XCZU17EG" || $device == "XCZU19EG" || $device == "XCZU11EG")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVE1924" && ($device == "XCZU17EG" || $device == "XCZU19EG")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FBVB900" && ($device == "XCZU4EV" || $device == "XCZU5EV" || $device == "XCZU7EV" || $device == "XCZU4CG" || $device == "XCZU4EG" || $device == "XCZU5CG" || $device == "XCZU5EG" || $device == "XCZU7CG" || $device == "XCZU7EG")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "SFVC784" && ($device == "XAZU4EV" || $device == "XAZU5EV" || $device == "XCZU4EV" || $device == "XCZU5EV" || $device == "XCZU4CG" || $device == "XCZU4EG" || $device == "XCZU5CG" || $device == "XCZU5EG")} {
            set_property range "X1,X2,X4" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVC1156" && ($device == "XCZU7EV" || $device == "XCZU11EG")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVC1156" && ($device == "XCZU7CG" || $device == "XCZU7EG")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVF1517" && ($device == "XCZU7EV" || $device == "XCZU11EG")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVF1517" && ($device == "XCZU7CG" || $device == "XCZU7EG")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVB1517" && ($device == "XCZU11EG" || $device == "XCZU17EG" || $device == "XCZU19EG")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVD1760" && ($device == "XCZU17EG" || $device == "XCZU19EG")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVE1517" && ($device == "XCKU11P" || $device == "XCKU15P")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVA676" && ($device == "XCKU3P" || $device == "XCKU5P")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVB676" && ($device == "XCKU3P" || $device == "XCKU5P")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVD900" && ($device == "XCKU3P" || $device == "XCKU5P" || $device == "XCKU11P")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "SFVB784" && ($device == "XCKU3P" || $device == "XCKU5P")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVA1156" && ($device == "XCKU11P" || $device == "XCKU15P")} {
            if {$pcie_blk == "X0Y2" || $pcie_blk == "X0Y3"} {
              set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
            } else {
              set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
            }
          } elseif {($pkg == "FFVA1760" || $pkg == "FFVE1760") && $device == "XCKU15P"} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVC1517" && $device == "XCVU3P"} {
	      if {$split_dma } {
                set_property range "X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      } else {
                set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      }
          } elseif {$pkg == "FLVA2104" && $device == "XCVU5P"} {
            if {$pcie_blk == "X0Y1" || $pcie_blk == "X0Y3" || $pcie_blk == "X1Y2"} {
              set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
            } elseif {$pcie_blk == "X1Y0"} {
              set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
            }
          } elseif {$pkg == "FLVA2104" && $device == "XCVU7P"} {
            if {$pcie_blk == "X0Y1" || $pcie_blk == "X0Y3" || $pcie_blk == "X1Y2"} {
              set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
            } elseif {$pcie_blk == "X1Y0"} {
              set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
            }
          } elseif {$pkg == "FLGA2104" && $device == "XCVU9P"} {
            if {$pcie_blk == "X0Y1" || $pcie_blk == "X0Y3" || $pcie_blk == "X1Y4"} {
              set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
            } elseif {$pcie_blk == "X1Y2"} {
	      if {$split_dma } {
                set_property range "X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      } else {
                set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      }
            }
          } elseif {$pkg == "FSGD2104" && $device == "XCVU9P"} {
            if {$pcie_blk == "X0Y5"} { 
              set_property range "X1,X2,X4" $PL_LINK_CAP_MAX_LINK_WIDTH
            } else { 
	      if {$split_dma } {
                set_property range "X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      } else {
                set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      }
            }
          } elseif {$pkg == "FLVB2104" && ($device == "XCVU5P" || $device == "XCVU7P")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FLGB2104" && $device == "XCVU9P"} {
	      if {$split_dma } {
                set_property range "X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      } else {
                set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      }
          } elseif {$pkg == "FLVC2104" && ($device == "XCVU5P" || $device == "XCVU7P")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FLGC2104" && $device == "XCVU9P"} {
            if {$pcie_blk == "X0Y1" || $pcie_blk == "X1Y0"} {
              set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
            } elseif {$pcie_blk == "X0Y3" || $pcie_blk == "X0Y5" || $pcie_blk == "X1Y2" || $pcie_blk == "X1Y4"} {
	      if {$split_dma } {
                set_property range "X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      } else {
                set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      }
            }
          } elseif {$pkg == "FLGA2577" && ($device == "XCVU9P" || $device == "XCVU11P")} {
	      if {$split_dma } {
                set_property range "X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      } else {
                set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      }
          } elseif {$pkg == "FLGC2104" && $device == "XCVU11P"} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {($pkg == "FLGB2104" || $pkg == "FLGF1924" || $pkg == "FSGD2104") && $device == "XCVU11P"} {
            if {$pcie_blk == "X0Y2"} {
              set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
            } else {
              set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
            }
          } elseif {$pkg == "FHGA2104" && $device == "XCVU13P"} {
            if {$pcie_blk == "X0Y2"} {
              set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
            } else {
	      if {$split_dma } {
                set_property range "X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      } else {
                set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      }
            }
          } elseif {($pkg == "FHGB2104" || $pkg == "FIGD2104") && $device == "XCVU13P"} {
            if {$pcie_blk == "X0Y3"} {
              set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
            } else {
	      if {$split_dma } {
                set_property range "X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      } else {
                set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      }
            }
          } elseif {$pkg == "FHGC2104" && $device == "XCVU13P"} {
            if {$pcie_blk == "X0Y0" || $pcie_blk == "X0Y3"} {
              set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
            } else {
	      if {$split_dma } {
                set_property range "X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      } else {
                set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	      }
            }
          } elseif {$pkg == "FLGA2577" && $device == "XCVU13P"} {
	    if {$split_dma } {
              set_property range "X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	    } else {
              set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
	    }
          } elseif {$pkg == "FFVE1156" && ($device == "XCZU28DR" || $device == "XCZU25DR" || $device == "XCZU27DR")} {
            set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {$pkg == "FFVG1517" && $device == "XCZU25DR"} {
            set_property range "X1,X2,X4,X8" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {($pkg == "FFVD1156" && $device == "XCZU21DR") || ($pkg == "FFVG1517" && ($device == "XCZU28DR" || $device == "XCZU27DR")) || ($pkg == "FFVF1760" && $device == "XCZU29DR")} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } elseif {(($pkg == "FSVH1924" && $device == "XCVU31P") || ($pkg == "FSVH2892" && $device == "XCVU37P") || ($pkg == "FSVH2892"  && $device == "XCVU35P") || ($pkg == "FSVH2104" && $device == "XCVU35P") || ($pkg == "FSVH2104" && $device == "XCVU33P"))} {
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          } else { 
            set_property range "X1,X2,X4,X8,X16" $PL_LINK_CAP_MAX_LINK_WIDTH
          }
        }
      }
    } elseif {$fmly eq "VIRTEXU" || $fmly eq "KINTEXU"} {
      if {$en_gt_selection == "false"} {
        if {(($pkg == "FFVA1156" || $pkg == "RFA1156") && $pcie_blk == "X0Y2" && ($device == "XCKU040" || $device == "XQKU040" || $device == "XCKU060" || $device == "XQKU060" || $device == "XCKU095" || $device == "XQKU095")) || ($pkg == "FFVA1517" && $device == "XCKU060" && $pcie_blk == "X0Y2") || ($pkg == "FLVA1517" &&  $pcie_blk == "X0Y2" && ($device == "XCKU085" || $device == "XCKU115")) || ($pkg == "FLVA2104" && ($pcie_blk == "X0Y3" || $pcie_blk == "X0Y4" || $pcie_blk == "X0Y5") && $device == "XCKU115") || ($pkg == "FLVB1760" && ($pcie_blk == "X0Y2" || $pcie_blk == "X0Y5" || $pcie_blk == "X0Y4") && ($device == "XCKU085" || $device == "XCKU115")) || ($pkg == "FLVD1924" && ($pcie_blk == "X0Y3" || $pcie_blk == "X0Y5" || $pcie_blk == "X0Y4") && $device == "XCKU115") || (($pkg == "FLVF1924" || $pkg == "FLVD1517" || $pkg == "FLVB2104" || $pkg == "RLF1924" || $pkg == "RLD1517") && ($pcie_blk == "X0Y2" || $pcie_blk == "X0Y5") && ($device == "XCKU085" || $device == "XCKU115" || $device == "XQKU115")) || (($pkg == "FFVD1924" || $pkg == "FFVA2104") && $pcie_blk == "X0Y3" && ($device == "XCVU080" || $device == "XCVU095")) || ($pkg == "FLVA2104" && $pcie_blk == "X0Y3" && $device == "XCVU125") || ($pkg == "FLGB2377" && ($pcie_blk == "X0Y1" || $pcie_blk == "X0Y3" || $pcie_blk == "X0Y5") && $device == "XCVU440") || (($device == "XCKU095" || $device == "XCVU080" || $device == "XCVU095") && $pkg == "FFVC1517" && $pcie_blk == "X0Y2") || ($pkg == "FLGC2104" && $pcie_blk == "X0Y1" && $device == "XCVU190")} {
          set_property range "X1,X2,X4" ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}
        } else {
          set_property range "X1,X2,X4,X8" ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}
        }
      } else {
        if {($select_quad == "GTH_Quad_219") || ($select_quad == "GTH_Quad_224") || (($device == "XCKU085" || $device == "XCKU115" || $device == "XQKU115") && ($pkg == "FLVA1517" || $pkg == "FLVF1924" || $pkg == "FLVD1517" || $pkg == "RLF1924" || $pkg == "RLD1517" || $pkg == "FLVB2104") && ($select_quad == "GTH_Quad_229")) || (($device == "XCKU085" || $device == "XCKU115") && ($pkg == "FLVB1760") && ($select_quad == "GTH_Quad_230")) || ($device == "XCKU115" && $pkg == "FLVD1924" && $select_quad == "GTH_Quad_231") || ($device == "XCKU115" && ($pkg == "FLVA2104") && ($select_quad == "GTH_Quad_231")) || ($select_quad == "GTH_Quad_221") || ($select_quad == "GTH_Quad_220" && $pkg == "FLGC2104") || ($select_quad == "GTH_Quad_219" && ($pkg == "FLGA2577" || $pkg == "FLGA2892")) || ($device == "XCVU125" && $pkg == "FLVB1760" && $pcie_blk == "X0Y2" && $select_quad == "GTH_Quad_230") || ($device == "XCVU125" && ($pkg == "FLVB2104" || $pkg == "FLVC2104" || $pkg == "FLVD1517") && $pcie_blk == "X0Y2" && $select_quad == "GTH_Quad_229") || ($select_quad == "GTH_Quad_229" && (($pcie_blk == "X0Y4" && $device == "XCVU190" && ($pkg == "FLGA2577" || $pkg == "FLGB2104" || $pkg == "FLGC2104")) || ($pcie_blk == "X0Y3" && $device == "XCVU160" && ($pkg == "FLGB2104" || $pkg == "FLGC2104")) || ($pcie_blk == "X0Y4" && $device == "XCVU440" && $pkg == "FLGA2892"))) || ($device == "XCVU440" && $pkg == "FLGB2377" && $pcie_blk == "X0Y4" && $select_quad == "GTH_Quad_231") || ($device == "XCVU125" && $pkg == "FLVA2104" && $pcie_blk == "X0Y2" && $select_quad == "GTH_Quad_231") || (($device == "XCKU095" || $device == "XQKU095") && ($pkg == "FFVA1156" || $pkg == "RFA1156") && $pcie_blk == "X0Y2" && $select_quad == "GTH_Quad_228")} {
          set_property range "X1,X2,X4" ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}
        } else {
          set_property range "X1,X2,X4,X8" ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}
        }
      }
    } elseif {(((($pkg == "FBG484") || ($pkg == "FBV484") || ($pkg == "SBG324")) && ($fmly == "KINTEX7")) || ($fmly == "ARTIX7" || $device == "XC7Z030" || $device == "XC7Z030I" || $device == "XQ7Z030" || $device == "XA7Z030" || $device == "XC7Z015" || $device == "XC7Z015I"))} {
      if {($fmly == "ARTIX7") && (($pkg == "CPG236") || (($device == "XC7A12T" || $device == "XC7A12TI") && ($pkg == "CSG325")))} { 
        set_property range "X1,X2" ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}
      } else { 
        set_property range "X1,X2,X4" ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}
      }
    } else { 
      set_property range "X1,X2,X4,X8" ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}
    }
}

proc update_PARAM_VALUE.dedicate_perst {PARAM_VALUE.dedicate_perst PROJECT_PARAM.DEVICE PARAM_VALUE.pcie_blk_locn PARAM_VALUE.device_port_type} {

    set c_xdevice      ${PROJECT_PARAM.DEVICE}
    set dedicate_perst ${PARAM_VALUE.dedicate_perst}
    set device         [string toupper $c_xdevice]

    set pcie_blk [get_property value ${PARAM_VALUE.pcie_blk_locn}]
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type} ]

    if {$pcie_blk == "X0Y0" && ($device_port_type ne "Root_Port_of_PCI_Express_Root_Complex")} {
        if {$device == "XCVU160" ||  $device == "XCVU190" || $device == "XCVU440"} {
            set_property value false $dedicate_perst
            set_property enabled false $dedicate_perst
        } else {
            set_property enabled true $dedicate_perst
            set_property value true $dedicate_perst
        }
    } elseif {$pcie_blk == "X0Y2" && ($device_port_type ne "Root_Port_of_PCI_Express_Root_Complex")} {
        if {$device == "XCVU160" || $device == "XCVU190" || $device == "XCVU440" } {
            set_property value true $dedicate_perst
            set_property enabled true $dedicate_perst
        } else {
            set_property enabled false $dedicate_perst
            set_property value false $dedicate_perst
        }
    } else {
        set_property value false $dedicate_perst
        set_property enabled false $dedicate_perst
    }
}

proc update_PARAM_VALUE.pf0_base_class_menu {PARAM_VALUE.pf0_base_class_menu PARAM_VALUE.device_port_type} {
  set device_port_type [get_property value ${PARAM_VALUE.device_port_type} ]
  set pf [get_property value ${PARAM_VALUE.pf0_base_class_menu}]

  if {$device_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property range_value "Bridge_device,Bridge_device" ${PARAM_VALUE.pf0_base_class_menu}
  } else {
    set_property range_value "Simple_communication_controllers,Simple_communication_controllers,Device_was_built_before_Class_Code_definitions_were_finalized,Mass_storage_controller,Network_controller,Display_controller,Multimedia_device,Memory_controller,Base_system_peripherals,Input_devices,Docking_stations,Processors,Serial_bus_controllers,Wireless_controller,Intelligent_I/O_controllers,Satellite_communication_controllers" ${PARAM_VALUE.pf0_base_class_menu}
  }
}

proc update_PARAM_VALUE.pf1_base_class_menu {PARAM_VALUE.pf1_base_class_menu PARAM_VALUE.device_port_type} {
  set device_port_type [get_property value ${PARAM_VALUE.device_port_type} ]
  set pf [get_property value ${PARAM_VALUE.pf1_base_class_menu}]

  if {$device_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property range_value "Bridge_device,Bridge_device" ${PARAM_VALUE.pf1_base_class_menu}
  } else {
    set_property range_value "Simple_communication_controllers,Simple_communication_controllers,Device_was_built_before_Class_Code_definitions_were_finalized,Mass_storage_controller,Network_controller,Display_controller,Multimedia_device,Memory_controller,Base_system_peripherals,Input_devices,Docking_stations,Processors,Serial_bus_controllers,Wireless_controller,Intelligent_I/O_controllers,Satellite_communication_controllers" ${PARAM_VALUE.pf1_base_class_menu}
  }
}

proc update_PARAM_VALUE.pf0_class_code_base {PARAM_VALUE.pf0_Use_Class_Code_Lookup_Assistant PARAM_VALUE.pf0_class_code_base  PARAM_VALUE.pf0_base_class_menu PARAM_VALUE.device_port_type} {
  
  set device_port_type [get_property value ${PARAM_VALUE.device_port_type} ]
  set val_base [regsub "h" [Base_class_value_text_UPDATE  ${PARAM_VALUE.pf0_base_class_menu}]  ""]

  if {[get_property value ${PARAM_VALUE.pf0_Use_Class_Code_Lookup_Assistant}]} {
    set_property enabled false ${PARAM_VALUE.pf0_class_code_base}
  } else {
    if {$device_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} { 
      set_property enabled false ${PARAM_VALUE.pf0_class_code_base}
    } else { 
      set_property  enabled true  ${PARAM_VALUE.pf0_class_code_base}
    }
  }
  set_property   value   $val_base ${PARAM_VALUE.pf0_class_code_base}
}

proc update_PARAM_VALUE.pf1_class_code_base {PARAM_VALUE.PF1_Use_Class_Code_Lookup_Assistant PARAM_VALUE.pf1_class_code_base PARAM_VALUE.pf1_base_class_menu PARAM_VALUE.device_port_type} {
  
  set device_port_type [get_property value ${PARAM_VALUE.device_port_type} ]
  set val_base [regsub "h" [PF1_Base_class_value_text_UPDATE  ${PARAM_VALUE.pf1_base_class_menu}]  ""]

  if {[get_property value ${PARAM_VALUE.PF1_Use_Class_Code_Lookup_Assistant}]} {
    set_property enabled false ${PARAM_VALUE.pf1_class_code_base}
  } else {
    if {$device_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} { 
      set_property enabled false ${PARAM_VALUE.pf1_class_code_base}
    } else { 
      set_property  enabled true  ${PARAM_VALUE.pf1_class_code_base}
    }
  }
  set_property   value   $val_base ${PARAM_VALUE.pf1_class_code_base}
}

proc update_PARAM_VALUE.pf0_class_code_sub {PARAM_VALUE.pf0_Use_Class_Code_Lookup_Assistant PARAM_VALUE.pf0_class_code_sub PARAM_VALUE.pf0_sub_class_interface_menu PARAM_VALUE.pf0_base_class_menu} {
    set val_sub [regsub "h" [sub_class_value_text_UPDATE  ${PARAM_VALUE.pf0_base_class_menu} ${PARAM_VALUE.pf0_sub_class_interface_menu}] "" ]
    if {[get_property value ${PARAM_VALUE.pf0_Use_Class_Code_Lookup_Assistant}]} {
        set_property  enabled false ${PARAM_VALUE.pf0_class_code_sub}
    } else {
        set_property  enabled true  ${PARAM_VALUE.pf0_class_code_sub}
    }
    set_property  value $val_sub ${PARAM_VALUE.pf0_class_code_sub}
}

proc update_PARAM_VALUE.pf1_class_code_sub {PARAM_VALUE.PF1_Use_Class_Code_Lookup_Assistant PARAM_VALUE.pf1_class_code_sub PARAM_VALUE.pf1_sub_class_interface_menu PARAM_VALUE.pf1_base_class_menu} {
    set val_sub [regsub "h" [PF1_sub_class_value_text_UPDATE  ${PARAM_VALUE.pf1_base_class_menu} ${PARAM_VALUE.pf1_sub_class_interface_menu}] "" ]
    if {[get_property value ${PARAM_VALUE.PF1_Use_Class_Code_Lookup_Assistant}]} {
        set_property  enabled false ${PARAM_VALUE.pf1_class_code_sub}
    } else {
        set_property  enabled true  ${PARAM_VALUE.pf1_class_code_sub}
    }
    set_property  value $val_sub ${PARAM_VALUE.pf1_class_code_sub}
}

proc update_PARAM_VALUE.pf0_class_code_interface {PARAM_VALUE.pf0_Use_Class_Code_Lookup_Assistant PARAM_VALUE.pf0_class_code_interface PARAM_VALUE.pf0_sub_class_interface_menu PARAM_VALUE.pf0_base_class_menu} {
    set k [interface_value_text_UPDATE  ${PARAM_VALUE.pf0_base_class_menu} ${PARAM_VALUE.pf0_sub_class_interface_menu} ]
    set val_interface [ regsub "h" $k ""  ]
    if {[get_property value ${PARAM_VALUE.pf0_Use_Class_Code_Lookup_Assistant}]} {
        set_property  enabled false ${PARAM_VALUE.pf0_class_code_interface}
    } else {
        set_property  enabled true  ${PARAM_VALUE.pf0_class_code_interface}
    }
    set_property  value  $val_interface ${PARAM_VALUE.pf0_class_code_interface}
}

proc update_PARAM_VALUE.pf1_class_code_interface {PARAM_VALUE.PF1_Use_Class_Code_Lookup_Assistant PARAM_VALUE.pf1_class_code_interface PARAM_VALUE.pf1_sub_class_interface_menu PARAM_VALUE.pf1_base_class_menu} {
    set k [PF1_interface_value_text_UPDATE  ${PARAM_VALUE.pf1_base_class_menu} ${PARAM_VALUE.pf1_sub_class_interface_menu} ]
    set val_interface [ regsub "h" $k ""  ]
    if {[get_property value ${PARAM_VALUE.PF1_Use_Class_Code_Lookup_Assistant}]} {
        set_property  enabled false ${PARAM_VALUE.pf1_class_code_interface}
    } else {
        set_property  enabled true  ${PARAM_VALUE.pf1_class_code_interface}
    }
    set_property  value  $val_interface ${PARAM_VALUE.pf1_class_code_interface}
}
##proc update_gui_for_PARAM_VALUE.mcap_enablement {IPINST PARAM_VALUE.mcap_enablement PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE PARAM_VALUE.mode_selection PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED} { 
##  set mcap_en      [get_property value ${PARAM_VALUE.mcap_enablement}]
##  set mode         [get_property value ${PARAM_VALUE.mode_selection}]
##  set lnk_speed    [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}]
##  set c_xfamily    [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
##  set family       [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
##  set c_xdevice    ${PROJECT_PARAM.DEVICE}
##  set device       [string toupper $c_xdevice]
##
##  if {$mode == "Basic"} {
##    set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_US -of $IPINST]
##  } else { 
##    if {$mcap_en eq "None" && $lnk_speed ne "2.5_GT/s" && ($c_xfamily == "virtexu" ||  $c_xfamily == "kintexu")} { 
##      set_property visible true [ipgui::get_pagespec  SHARED_LOGIC_PAGE_US -of $IPINST]
##    } else { 
##      set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_US -of $IPINST]
##    }
##  }
##}
##
##proc update_gui_for_PARAM_VALUE.plltype {IPINST PARAM_VALUE.plltype PROJECT_PARAM.ARCHITECTURE } { 
##  set Plltype     [get_property value ${PARAM_VALUE.plltype}]
##  set c_xfamily   [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
##
##  if {($c_xfamily == "kintexu" || $c_xfamily == "virtexu")} {
##     if {$Plltype == "CPLL"} {
##        set_property visible false [ipgui::get_groupspec shared_logic_info_group_us -of $IPINST ]
##     } else {        
##        set_property visible true [ipgui::get_groupspec shared_logic_info_group_us -of $IPINST ]
##     }
##   }
##
##}

proc update_PARAM_VALUE.type1_membase_memlimit_enable { PARAM_VALUE.type1_membase_memlimit_enable PARAM_VALUE.device_port_type PROJECT_PARAM.ARCHITECTURE } {
    set c_xfamily      [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    if {[get_property value ${PARAM_VALUE.device_port_type} ] == "Root_Port_of_PCI_Express_Root_Complex" && ($c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm")} {
        set_property enabled true ${PARAM_VALUE.type1_membase_memlimit_enable}
        set_property range "Disabled,Enabled" ${PARAM_VALUE.type1_membase_memlimit_enable}
        set_property value "Enabled" ${PARAM_VALUE.type1_membase_memlimit_enable}
    } else {
        set_property range "Disabled,Enabled" ${PARAM_VALUE.type1_membase_memlimit_enable}
        set_property value "Disabled" ${PARAM_VALUE.type1_membase_memlimit_enable}
        set_property enabled false ${PARAM_VALUE.type1_membase_memlimit_enable}
    }
}
proc update_PARAM_VALUE.type1_prefetchable_membase_memlimit { PARAM_VALUE.type1_prefetchable_membase_memlimit PARAM_VALUE.device_port_type PROJECT_PARAM.ARCHITECTURE } {
    set c_xfamily      [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    if {[get_property value ${PARAM_VALUE.device_port_type} ] == "Root_Port_of_PCI_Express_Root_Complex" && ($c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm")} {
        set_property enabled true ${PARAM_VALUE.type1_prefetchable_membase_memlimit}
        set_property range "Disabled,32bit_Enabled,64bit_Enabled" ${PARAM_VALUE.type1_prefetchable_membase_memlimit}
        set_property value "64bit_Enabled" ${PARAM_VALUE.type1_prefetchable_membase_memlimit}
    } else {
        set_property range "Disabled,32bit_Enabled,64bit_Enabled" ${PARAM_VALUE.type1_prefetchable_membase_memlimit}
        set_property value "Disabled" ${PARAM_VALUE.type1_prefetchable_membase_memlimit}
        set_property enabled false ${PARAM_VALUE.type1_prefetchable_membase_memlimit}
    }
}
proc update_gui_for_PARAM_VALUE.enable_ibert {IPINST PARAM_VALUE.enable_ibert PROJECT_PARAM.ARCHITECTURE } {
  set c_xfamily      [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]

    if {$c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
      set_property visible true [ipgui::get_guiparamspec enable_ibert -of $IPINST]
    } elseif {$c_xfamily == "virtexu" ||  $c_xfamily == "kintexu"} {
      set_property visible true [ipgui::get_guiparamspec enable_ibert -of $IPINST]
    } else {
      set_property visible false [ipgui::get_guiparamspec enable_ibert -of $IPINST]
    }
}

proc update_gui_for_PARAM_VALUE.en_dbg_descramble {IPINST PARAM_VALUE.en_dbg_descramble PROJECT_PARAM.ARCHITECTURE } {
  set c_xfamily      [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]

    if {$c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
      set_property visible true [ipgui::get_guiparamspec en_dbg_descramble -of $IPINST]
    } elseif {$c_xfamily == "virtexu" ||  $c_xfamily == "kintexu"} {
      set_property visible true [ipgui::get_guiparamspec en_dbg_descramble -of $IPINST]
    } else {
      set_property visible false [ipgui::get_guiparamspec en_dbg_descramble -of $IPINST]
    }
}

proc update_PARAM_VALUE.en_dbg_descramble {PARAM_VALUE.en_dbg_descramble PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED} {

  if {[get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] eq "8.0_GT/s"} {
    set_property enabled true ${PARAM_VALUE.en_dbg_descramble}
  } else {
    set_property enabled false ${PARAM_VALUE.en_dbg_descramble}
    set_property value false ${PARAM_VALUE.en_dbg_descramble}
  }

}

##proc update_PARAM_VALUE.enable_ibert {PARAM_VALUE.enable_ibert PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED} {
##
##  if {[get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] eq "8.0_GT/s"} {
##      set_property enabled true ${PARAM_VALUE.enable_ibert}
##  } else {
##      set_property enabled false ${PARAM_VALUE.enable_ibert}
##      set_property value false ${PARAM_VALUE.enable_ibert}
##  }
##
##} 

proc update_gui_for_PARAM_VALUE.mode_selection {IPINST PARAM_VALUE.mode_selection PARAM_VALUE.enable_auto_rxeq PARAM_VALUE.plltype PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.SILICON_REVISION PROJECT_PARAM.DEVICE PARAM_VALUE.device_port_type PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH PROJECT_PARAM.SPEEDGRADE PARAM_VALUE.functional_mode PARAM_VALUE.en_coreclk_es1 PARAM_VALUE.split_dma PARAM_VALUE.pipe_line_stage} {
    set mode           [get_property value ${PARAM_VALUE.mode_selection}]
    set c_xfamily      [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set silicon_rev    [string toupper ${PROJECT_PARAM.SILICON_REVISION}]
    set family         [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    set speed_grade    ${PROJECT_PARAM.SPEEDGRADE}
    set c_xdevice      ${PROJECT_PARAM.DEVICE}
    set device         [string toupper $c_xdevice]
    set dev_port_type  [get_property value ${PARAM_VALUE.device_port_type}]
    set link_speed     [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}]
    set link_width     [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}]
    set Plltype        [get_property value ${PARAM_VALUE.plltype}]
    set func_mode      [get_property value ${PARAM_VALUE.functional_mode}]
    set en_coreclk     [get_property value ${PARAM_VALUE.en_coreclk_es1}]
    set split_dma      [get_property value ${PARAM_VALUE.split_dma}]
    set pipe_line_stage [get_property value ${PARAM_VALUE.pipe_line_stage}]
    set pf0_msix_grp     [ipgui::get_groupspec PF0_msix -of $IPINST]
    set pf1_msix_grp     [ipgui::get_groupspec PF1_msix -of $IPINST]
    set pf2_msix_grp     [ipgui::get_groupspec PF2_msix -of $IPINST]
    set pf3_msix_grp     [ipgui::get_groupspec PF3_msix -of $IPINST]

    if {$mode == "Basic"} {
      set_property visible false [ipgui::get_groupspec  ADVANCED -of $IPINST ]
      set_property visible false [ipgui::get_groupspec  SYS_RESET -of $IPINST ]
      set_property visible false [ipgui::get_guiparamspec dma_reset_source_sel -of $IPINST ]
      set_property visible false [ipgui::get_groupspec  GT_SELECT -of $IPINST ]
      set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_7x -of $IPINST]
      set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_US -of $IPINST]
      set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_USP -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec performance -of $IPINST]
      set_property visible false [ipgui::get_pagespec  GT_Settings_tab -of $IPINST ]
      set_property visible false [ipgui::get_guiparamspec rx_detect -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec mcap_enablement -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec ext_startup_primitive -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec INS_LOSS_NYQ -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec RX_PPM_OFFSET -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec RX_SSC_PPM -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec en_debug_ports -of $IPINST]
      set_property visible false [ipgui::get_groupspec MSIx_Table_settings_PF0 -of $IPINST]
      set_property visible false [ipgui::get_groupspec MSIx_Pending_Bit_Array_grp -of $IPINST]
      set_property visible false [ipgui::get_pagespec debug_options_tab -of $IPINST]
      set_property visible true [ipgui::get_groupspec Link_status_reg -of $IPINST]
      set_property visible true [ipgui::get_guiparamspec pf0_link_status_slot_clock_config -of $IPINST]
      set_property visible false [ipgui::get_groupspec l23_entry -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec split_dma -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec pipe_line_stage -of $IPINST]
      set_property visible false $pf0_msix_grp
      set_property visible false $pf1_msix_grp
      set_property visible false $pf2_msix_grp
      set_property visible false $pf3_msix_grp
      if { $split_dma } {
        set_property visible false [ipgui::get_groupspec  panel1 -of $IPINST ]
      } else { 
        set_property visible true  [ipgui::get_groupspec  panel1 -of $IPINST ]
      }
      if {$func_mode == "MQDMA" } { 
        set_property visible true [ipgui::get_groupspec xdma_axi_intf_mm_mqdma -of $IPINST]
        set_property visible true [ipgui::get_guiparamspec -name num_queues -of $IPINST]
        set_property visible true [ipgui::get_guiparamspec -name dsc_bypass_wr_out -of $IPINST]
        set_property visible true [ipgui::get_guiparamspec -name dsc_bypass_rd_out -of $IPINST]
        set_property visible true [ipgui::get_groupspec xdma_axi_intf_mm_mqdma -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec xdma_axi_intf_mm -of $IPINST]
        set_property visible false [ipgui::get_groupspec physical_functions -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec tl_pf_enable_reg -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec SRIOV_CAP_ENABLE -of $IPINST]
        set_property visible false [ipgui::get_groupspec MSI_X_OPTIONS_grp -of $IPINST]
      }
    } else {
      set_property visible true  [ipgui::get_groupspec  ADVANCED -of $IPINST ]
      set_property visible true  [ipgui::get_guiparamspec performance -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec INS_LOSS_NYQ -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec RX_PPM_OFFSET -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec RX_SSC_PPM -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec en_debug_ports -of $IPINST]
      set_property visible false [ipgui::get_groupspec MSIx_Table_settings_PF0 -of $IPINST]
      set_property visible false [ipgui::get_groupspec MSIx_Pending_Bit_Array_grp -of $IPINST]
      if {$func_mode == "MQDMA" } { 
        set_property visible true [ipgui::get_groupspec physical_functions -of $IPINST]
        set_property visible true [ipgui::get_guiparamspec tl_pf_enable_reg -of $IPINST]
        set_property visible true [ipgui::get_guiparamspec SRIOV_CAP_ENABLE -of $IPINST]
        set_property visible true [ipgui::get_groupspec MSI_X_OPTIONS_grp -of $IPINST]
        if {[get_property value ${PARAM_VALUE.MSI_X_OPTIONS}] == "None"} { 
          set_property visible false $pf0_msix_grp
          set_property visible false $pf1_msix_grp
          set_property visible false $pf2_msix_grp
          set_property visible false $pf3_msix_grp
        } else { 
          set_property visible true  $pf0_msix_grp
        }
      } else { 
        if {$func_mode != "DMA_and_Bridge" } { 
        set_property visible false [ipgui::get_groupspec physical_functions -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec tl_pf_enable_reg -of $IPINST]
	}
        set_property visible false [ipgui::get_guiparamspec SRIOV_CAP_ENABLE -of $IPINST]
        set_property visible false [ipgui::get_groupspec MSI_X_OPTIONS_grp -of $IPINST]
        set_property visible false $pf0_msix_grp
        set_property visible false $pf1_msix_grp
        set_property visible false $pf2_msix_grp
        set_property visible false $pf3_msix_grp
      }
      if {$dev_port_type == "Root_Port_of_PCI_Express_Root_Complex" } { 
        set_property visible true [ipgui::get_groupspec l23_entry -of $IPINST]
        set_property visible true [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
      } else { 
        set_property visible false [ipgui::get_groupspec l23_entry -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
        if {$func_mode == "AXI_Bridge" } { 
          set_property visible true [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
        } else { 
          set_property visible false [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
        }
      }
      if {$c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
        set_property visible true [ipgui::get_groupspec  GT_SELECT -of $IPINST ]
        set_property visible true [ipgui::get_guiparamspec mcap_enablement -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec dedicate_perst -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec ext_startup_primitive -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec rx_detect -of $IPINST]
        set_property visible true [ipgui::get_guiparamspec enable_auto_rxeq -of $IPINST]
        set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_7x -of $IPINST]
        set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_US -of $IPINST]
        set_property visible true  [ipgui::get_guiparamspec dma_reset_source_sel -of $IPINST ]
	if { $split_dma } {
          set_property visible false [ipgui::get_groupspec  panel1 -of $IPINST ]
          set_property visible false [ipgui::get_groupspec  SYS_RESET -of $IPINST ]
          set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_USP -of $IPINST]
          set_property visible false [ipgui::get_pagespec  GT_Settings_tab -of $IPINST ]
          set_property visible false [ipgui::get_pagespec debug_options_tab -of $IPINST]
        } else { 
          set_property visible true  [ipgui::get_groupspec  panel1 -of $IPINST ]
          set_property visible true  [ipgui::get_groupspec  SYS_RESET -of $IPINST ]
          set_property visible true  [ipgui::get_pagespec  SHARED_LOGIC_PAGE_USP -of $IPINST]
          set_property visible true  [ipgui::get_pagespec  GT_Settings_tab -of $IPINST ]
          set_property visible true  [ipgui::get_pagespec debug_options_tab -of $IPINST]
        }
        if {$link_speed == "8.0_GT/s" && $link_width == "X8"} { 
          if {$speed_grade == "-1LV" || $speed_grade == "-1L"} { 
            set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST]
          } else { 
            if {$en_coreclk && $silicon_rev eq "ES1"} {
              set_property visible true [ipgui::get_guiparamspec coreclk_freq -of $IPINST]
            } else { 
              set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST]
            }
          } 
        } else { 
          set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST]
        }
      } elseif {$c_xfamily == "virtexu" ||  $c_xfamily == "kintexu"} {
        set_property visible true [ipgui::get_groupspec  panel1 -of $IPINST ]
        set_property visible true [ipgui::get_groupspec  GT_SELECT -of $IPINST ]
        set_property visible true [ipgui::get_groupspec  SYS_RESET -of $IPINST ]
        set_property visible true [ipgui::get_pagespec  GT_Settings_tab -of $IPINST ]
        set_property visible true [ipgui::get_guiparamspec mcap_enablement -of $IPINST]
        set_property visible true [ipgui::get_guiparamspec ext_startup_primitive -of $IPINST]
        set_property visible true [ipgui::get_guiparamspec coreclk_freq -of $IPINST]
        set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_7x -of $IPINST]
        set_property visible true [ipgui::get_pagespec  SHARED_LOGIC_PAGE_US -of $IPINST]
        set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_USP -of $IPINST]
        set_property visible true [ipgui::get_guiparamspec enable_auto_rxeq -of $IPINST]
        set_property visible true [ipgui::get_pagespec debug_options_tab -of $IPINST]
        set_property visible true  [ipgui::get_guiparamspec dma_reset_source_sel -of $IPINST ]
        if {$silicon_rev eq "ES1" || $silicon_rev eq "ES2" } {
          set_property visible false [ipgui::get_guiparamspec rx_detect -of $IPINST]
        } else {
          set_property visible true [ipgui::get_guiparamspec rx_detect -of $IPINST]
        }
        #if {($c_xfamily == "kintexu" || $c_xfamily == "virtexu")} {
        #   if {$Plltype == "CPLL"} {
        #      set_property visible false [ipgui::get_groupspec shared_logic_info_group_us -of $IPINST ]
        #   } else {        
        #      set_property visible true [ipgui::get_groupspec shared_logic_info_group_us -of $IPINST ]
        #   }
        #}
        set_property visible false [ipgui::get_guiparamspec split_dma -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec pipe_line_stage -of $IPINST]
      } else {
        set_property visible true [ipgui::get_groupspec  panel1 -of $IPINST ]
        set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec enable_auto_rxeq -of $IPINST]
        if {$device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $family == "KINTEX7" || $family == "QKINTEX7" || $family == "KINTEX7L" ||  $family == "QKINTEX7L" || $family == "ARTIX7" || $family == "AARTIX7" ||  $family == "QARTIX7" ||  $family == "ARTIX7L" || $family == "ZYNQ" || $family == "AZYNQ" || $family == "QZYNQ"} {
           set_property visible false [ipgui::get_pagespec debug_options_tab -of $IPINST]
        } else { 
           set_property visible true [ipgui::get_pagespec debug_options_tab -of $IPINST]
        }
        set_property visible false [ipgui::get_groupspec  GT_SELECT -of $IPINST ]
        set_property visible false [ipgui::get_groupspec  SYS_RESET -of $IPINST ]
        set_property visible false [ipgui::get_pagespec  GT_Settings_tab -of $IPINST ]
        set_property visible false [ipgui::get_guiparamspec rx_detect -of $IPINST]
        if {$device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $family == "KINTEX7" || $family == "QKINTEX7" || $family == "KINTEX7L" ||  $family == "QKINTEX7L" || $family == "ARTIX7" || $family == "AARTIX7" ||  $family == "QARTIX7" ||  $family == "ARTIX7L" || $family == "ZYNQ" || $family == "AZYNQ" || $family == "QZYNQ"} {
        set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_7x -of $IPINST]
        } else { 
          set_property visible true [ipgui::get_pagespec  SHARED_LOGIC_PAGE_7x -of $IPINST]
        }
        set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_US -of $IPINST]
        set_property visible false [ipgui::get_pagespec  SHARED_LOGIC_PAGE_USP -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec dma_reset_source_sel -of $IPINST ]
        set_property visible false [ipgui::get_guiparamspec split_dma -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec pipe_line_stage -of $IPINST]
      }
   }
}

proc update_MODELPARAM_VALUE.ULTRASCALE {MODELPARAM_VALUE.ULTRASCALE PROJECT_PARAM.ARCHITECTURE } {

    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXU"  ||  $c_xfamily eq "KINTEXU"} {
        set val  true
    } else {
        set val  false
    }
    set_property value  [string toupper $val] ${MODELPARAM_VALUE.ULTRASCALE}
}

proc update_MODELPARAM_VALUE.ULTRASCALE_PLUS {MODELPARAM_VALUE.ULTRASCALE_PLUS PROJECT_PARAM.ARCHITECTURE } {

    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXUPLUS"  ||  $c_xfamily eq "KINTEXUPLUS" ||  $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
        set val  true
    } else {
        set val  false
    }
    set_property value  [string toupper $val] ${MODELPARAM_VALUE.ULTRASCALE_PLUS}
}

proc update_MODELPARAM_VALUE.V7_GEN3 {MODELPARAM_VALUE.V7_GEN3 PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE } {
     set family  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    set c_xdevice      ${PROJECT_PARAM.DEVICE}
    set device         [string toupper $c_xdevice]
     if {$family eq "QVIRTEX7"  ||  $family eq "VIRTEX7"} {
     	 if {$device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $family == "KINTEX7" || $family == "QKINTEX7" || $family == "KINTEX7L" ||  $family == "QKINTEX7L" || $family == "ARTIX7" || $family == "AARTIX7" ||  $family == "QARTIX7" ||  $family == "ARTIX7L" || $family == "ZYNQ" || $family == "AZYNQ" || $family == "QZYNQ"} {
	 		set val false
	} else	{	
			set val  true
	}
     } else {
			set val  false
     }
	set_property value  [string toupper $val] ${MODELPARAM_VALUE.V7_GEN3}

}

proc update_MODELPARAM_VALUE.MSI_ENABLED {MODELPARAM_VALUE.MSI_ENABLED PARAM_VALUE.pf0_msi_enabled } {
    set msi_enabled  [get_property value  ${PARAM_VALUE.pf0_msi_enabled} ]
    if {$msi_enabled } {
        set val  true
    } else {
        set val  false
    }
    set_property value  [string toupper $val] ${MODELPARAM_VALUE.MSI_ENABLED}
}

proc update_MODELPARAM_VALUE.MSIX_ENABLED {PARAM_VALUE.pf0_msix_enabled MODELPARAM_VALUE.MSIX_ENABLED} {
    set msix_enabled [get_property value ${PARAM_VALUE.pf0_msix_enabled}]
    if {$msix_enabled eq "true"} {
        set val "true"
    } else {
        set val "false"
    }
    set_property value [string toupper $val] ${MODELPARAM_VALUE.MSIX_ENABLED}
}

proc update_MODELPARAM_VALUE.DEV_PORT_TYPE {MODELPARAM_VALUE.DEV_PORT_TYPE PARAM_VALUE.device_port_type} {
    set dev_port_type [get_property value ${PARAM_VALUE.device_port_type}]

    if {$dev_port_type eq "PCI_Express_Endpoint_device"} {
        set val 0
    } elseif {$dev_port_type eq "Legacy_PCI_Express_Endpoint_device"} {
        set val 1
    } elseif {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex" } {
        set val 2
    }
    set_property value $val ${MODELPARAM_VALUE.DEV_PORT_TYPE}
}

proc update_MODELPARAM_VALUE.VU9P_BOARD {MODELPARAM_VALUE.VU9P_BOARD PARAM_VALUE.vu9p_board}  {
 
  set c_vu9p_board [get_property value ${PARAM_VALUE.vu9p_board}]
  if { $c_vu9p_board == "true"} { 
    set val "TRUE"
  } else { 
    set val "FALSE"
  }  

  set_property value $val ${MODELPARAM_VALUE.VU9P_BOARD}
  
}

proc update_MODELPARAM_VALUE.VU9P_TUL_EX {MODELPARAM_VALUE.VU9P_TUL_EX PARAM_VALUE.vu9p_tul_ex}  {

  set c_vu9p_tul_ex [get_property value ${PARAM_VALUE.vu9p_tul_ex}]
  if { $c_vu9p_tul_ex == "true" } { 
    set val "TRUE"
  } else { 
    set val "FALSE"
  }  

  set_property value $val ${MODELPARAM_VALUE.VU9P_TUL_EX}
}

proc update_MODELPARAM_VALUE.VCU118_BOARD {MODELPARAM_VALUE.VCU118_BOARD PARAM_VALUE.vcu118_board PROJECT_PARAM.DEVICE PROJECT_PARAM.SPEEDGRADE PROJECT_PARAM.PART PARAM_VALUE.xlnx_ref_board}  {

  set c_xdevice      ${PROJECT_PARAM.DEVICE}
  set c_xpackage     [getpackage_name ${PROJECT_PARAM.PART} ${PROJECT_PARAM.SPEEDGRADE} ${PROJECT_PARAM.DEVICE}]
  set device         [string toupper $c_xdevice]
  set pkg            [string toupper $c_xpackage]
  set xlnx_ref_board [get_property value ${PARAM_VALUE.xlnx_ref_board}]

  if {([get_property value ${PARAM_VALUE.vcu118_board}] && $device == "XCVU9P" && $pkg == "FLGA2104") || $xlnx_ref_board eq "VCU118" || $xlnx_ref_board eq "VCU118_ES1"} { 
    set val "TRUE"
  } else { 
    set val "FALSE"
  }  

  set_property value $val ${MODELPARAM_VALUE.VCU118_BOARD}
  
}
 
proc update_MODELPARAM_VALUE.ENABLE_JTAG_DBG {MODELPARAM_VALUE.ENABLE_JTAG_DBG PARAM_VALUE.enable_jtag_dbg } {
  if { [get_property value ${PARAM_VALUE.enable_jtag_dbg}] } {
    set val "TRUE"
  } else {
    set val "FALSE"
  }
  set_property value $val ${MODELPARAM_VALUE.ENABLE_JTAG_DBG}
}

proc update_MODELPARAM_VALUE.ENABLE_IBERT {MODELPARAM_VALUE.ENABLE_IBERT PARAM_VALUE.enable_ibert } {
  if { [get_property value ${PARAM_VALUE.enable_ibert}] } {
    set val "TRUE"
  } else {
    set val "FALSE"
  }
  set_property value $val ${MODELPARAM_VALUE.ENABLE_IBERT}
}

proc update_MODELPARAM_VALUE.DMA_EN {MODELPARAM_VALUE.DMA_EN PARAM_VALUE.functional_mode} { 
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode == "AXI_Bridge" } { 
    set val 0
  } elseif {$func_mode == "DMA" || $func_mode == "DMA_and_Bridge"} { 
    set val 1
  } else { 
    set val 2
  }
  set_property value $val ${MODELPARAM_VALUE.DMA_EN}
}


proc update_MODELPARAM_VALUE.FUNC_MODE {MODELPARAM_VALUE.FUNC_MODE PARAM_VALUE.functional_mode} { 
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode == "AXI_Bridge" } { 
    set val 0
  } elseif {$func_mode == "DMA" || $func_mode == "MQDMA"} { 
    set val 1
  } else { 
    set val 2
  }
  set_property value $val ${MODELPARAM_VALUE.FUNC_MODE}
}


proc update_MODELPARAM_VALUE.PF1_ENABLED {MODELPARAM_VALUE.PF1_ENABLED PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.functional_mode} { 

  set pf1_sel [get_property value ${PARAM_VALUE.tl_pf_enable_reg}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$pf1_sel == 2 && $func_mode == "DMA_and_Bridge"} { 
    set val 1
  } else { 
    set val 0
  }

  set_property value $val ${MODELPARAM_VALUE.PF1_ENABLED}
}

proc update_MODELPARAM_VALUE.C_MSIX_INT_TABLE_EN {MODELPARAM_VALUE.C_MSIX_INT_TABLE_EN PARAM_VALUE.pf0_msix_impl_locn PARAM_VALUE.pf0_msix_enabled} { 

  set msix_en        [get_property value ${PARAM_VALUE.pf0_msix_enabled}]
  set msix_impl_locn [get_property value ${PARAM_VALUE.pf0_msix_impl_locn}]

  if {$msix_en} { 
    if {$msix_impl_locn == "External"} { 
      set val 0
    } else { 
      set val 1
    }
  } else { 
    set val 0
  }

  set_property value $val ${MODELPARAM_VALUE.C_MSIX_INT_TABLE_EN}
   
}


proc update_MODELPARAM_VALUE.MM_SLAVE_EN {MODELPARAM_VALUE.MM_SLAVE_EN PARAM_VALUE.functional_mode PARAM_VALUE.mult_pf_des} { 
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]

  if {$mult_pf_des_val} { 
    set val 1
  } elseif {$func_mode == "DMA" || $func_mode == "MQDMA"} { 
    set val 0
  } else { 
    set val 1
  }
  set_property value $val ${MODELPARAM_VALUE.MM_SLAVE_EN}
}

set axi_model_proc {
  proc update_MODELPARAM_VALUE.<<mp>>  { MODELPARAM_VALUE.<<mp>>  PARAM_VALUE.<<p>> } {
    set_property value  [get_property value   ${PARAM_VALUE.<<p>>}] ${MODELPARAM_VALUE.<<mp>>}
  }
}

foreach {param  model_param } {AXIBAR_<<n>> C_AXIBAR_<<n>> AXIBAR_HIGHADDR_<<n>> C_AXIBAR_HIGHADDR_<<n>>  axibar2pciebar_<<n>> C_AXIBAR2PCIEBAR_<<n>>} {
  foreach i {0 1 2 3 4 5} {
    set axi_model_proc_p  [regsub -all <<p>> $axi_model_proc $param ] 
    set axi_model_proc_mp [regsub -all <<mp>> $axi_model_proc_p $model_param ]
    set axi_model_proc_n  [regsub -all <<n>> $axi_model_proc_mp $i ] 
    eval $axi_model_proc_n
    }
}

proc update_MODELPARAM_VALUE.C_AXIBAR_NUM {MODELPARAM_VALUE.C_AXIBAR_NUM PARAM_VALUE.axibar_num} {
    set_property value [get_property value ${PARAM_VALUE.axibar_num}] ${MODELPARAM_VALUE.C_AXIBAR_NUM}
}

proc update_MODELPARAM_VALUE.EN_AXI_SLAVE_IF {MODELPARAM_VALUE.EN_AXI_SLAVE_IF PARAM_VALUE.en_axi_slave_if} { 
  set_property value [string toupper [get_property value ${PARAM_VALUE.en_axi_slave_if}]] ${MODELPARAM_VALUE.EN_AXI_SLAVE_IF}
} 

proc update_MODELPARAM_VALUE.EN_AXI_MASTER_IF {MODELPARAM_VALUE.EN_AXI_MASTER_IF PARAM_VALUE.en_axi_master_if} { 
  set_property value [string toupper [get_property value ${PARAM_VALUE.en_axi_master_if}]] ${MODELPARAM_VALUE.EN_AXI_MASTER_IF}
} 

proc update_MODELPARAM_VALUE.C_INCLUDE_BAROFFSET_REG { MODELPARAM_VALUE.C_INCLUDE_BAROFFSET_REG PARAM_VALUE.include_baroffset_reg } {
  set include_baroffset_reg [ get_property value ${PARAM_VALUE.include_baroffset_reg} ]
  if {$include_baroffset_reg} {
    set_property value  1 ${MODELPARAM_VALUE.C_INCLUDE_BAROFFSET_REG}
  } else { 
    set_property value  0 ${MODELPARAM_VALUE.C_INCLUDE_BAROFFSET_REG}
  } 
}

proc update_PARAM_VALUE.pf0_msix_impl_locn {PARAM_VALUE.pf0_msix_impl_locn PARAM_VALUE.pf0_msix_enabled} { 
  
  set msix_en [get_property value ${PARAM_VALUE.pf0_msix_enabled}]

  if {$msix_en} { 
    set_property enabled true ${PARAM_VALUE.pf0_msix_impl_locn}
  } else { 
    set_property enabled false ${PARAM_VALUE.pf0_msix_impl_locn}
  }

}

proc update_MODELPARAM_VALUE.MSIX_IMPL_EXT {PARAM_VALUE.pf0_msix_impl_locn MODELPARAM_VALUE.MSIX_IMPL_EXT} {
  set msix_locn [get_property value ${PARAM_VALUE.pf0_msix_impl_locn}]
  if {$msix_locn eq "External"} {
    set val "true"
  } else {
    set val "false"
  }
  set_property value [string toupper $val] ${MODELPARAM_VALUE.MSIX_IMPL_EXT} 
}

proc update_PARAM_VALUE.mult_pf_des {PARAM_VALUE.mult_pf_des PARAM_VALUE.split_dma} {
  set split_dma_val   [get_property value ${PARAM_VALUE.split_dma}]

  if {$split_dma_val} {
    set_property enabled false ${PARAM_VALUE.mult_pf_des}
    set_property value true ${PARAM_VALUE.mult_pf_des}
  } else {
    set_property enabled true ${PARAM_VALUE.mult_pf_des}
    set_property value false ${PARAM_VALUE.mult_pf_des}
  }
}

proc update_PARAM_VALUE.functional_mode {PARAM_VALUE.functional_mode PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.mult_pf_des PARAM_VALUE.en_dma_and_bridge PARAM_VALUE.en_bridge PARAM_VALUE.en_mqdma} { 

  set c_xfamily         [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
  set fmly              [string toupper $c_xfamily]
  set mult_pf_des_val   [get_property value ${PARAM_VALUE.mult_pf_des}]
  set en_dma_and_bridge [get_property value ${PARAM_VALUE.en_dma_and_bridge}]
  set en_bridge         [get_property value ${PARAM_VALUE.en_bridge}]
  set en_mqdma          [get_property value ${PARAM_VALUE.en_mqdma}]

  if {$fmly == "VIRTEXUPLUS" ||  $fmly == "KINTEXUPLUS" ||  $fmly == "ZYNQUPLUS" || $fmly == "ZYNQUPLUSRFSOC" || $fmly == "VIRTEXUPLUSHBM" || $fmly == "VIRTEXU" ||  $fmly == "KINTEXU"} { 
    if {$mult_pf_des_val} { 
      set_property enabled false ${PARAM_VALUE.functional_mode}
      set_property range_value "DMA,DMA" ${PARAM_VALUE.functional_mode}
    } elseif {$en_dma_and_bridge} { 
      if {$c_xfamily == "virtexu" ||  $c_xfamily == "kintexu"} { 
        set_property enabled true ${PARAM_VALUE.functional_mode}
        set_property range_value "DMA,DMA,DMA_and_Bridge" ${PARAM_VALUE.functional_mode}
      } else { 
        set_property enabled true ${PARAM_VALUE.functional_mode}
        set_property range_value "DMA,DMA,AXI_Bridge,DMA_and_Bridge" ${PARAM_VALUE.functional_mode}
      }
    } elseif {$en_bridge && ($c_xfamily == "virtexu" ||  $c_xfamily == "kintexu")} {
        set_property enabled true ${PARAM_VALUE.functional_mode}
        set_property range_value "DMA,DMA,AXI_Bridge" ${PARAM_VALUE.functional_mode}
    } elseif {$en_mqdma && ($c_xfamily != "virtexu" ||  $c_xfamily != "kintexu")} {
      set_property enabled true ${PARAM_VALUE.functional_mode}
      set_property range_value "DMA,DMA,AXI_Bridge,MQDMA" ${PARAM_VALUE.functional_mode}
    } else {
      if {$c_xfamily == "virtexu" ||  $c_xfamily == "kintexu"} { 
        set_property enabled true ${PARAM_VALUE.functional_mode}
        set_property range_value "DMA,DMA" ${PARAM_VALUE.functional_mode}
      } else { 
        set_property enabled true ${PARAM_VALUE.functional_mode}
        set_property range_value "DMA,DMA,AXI_Bridge" ${PARAM_VALUE.functional_mode}
      }
    }
  } else { 
    set_property enabled false ${PARAM_VALUE.functional_mode}
  }
}

proc update_gui_for_PARAM_VALUE.en_axi_slave_if {PARAM_VALUE.en_axi_slave_if PARAM_VALUE.functional_mode IPINST} { 

  set en_axi_slave     [get_property value ${PARAM_VALUE.en_axi_slave_if}]
  set func_mode        [get_property value ${PARAM_VALUE.functional_mode}]

  if {($func_mode == "AXI_Bridge" || $func_mode == "DMA_and_Bridge") && $en_axi_slave == "true"} { 
    set_property visible true  [ipgui::get_pagespec axi_bars -of $IPINST]
  } else { 
    set_property visible false [ipgui::get_pagespec axi_bars -of $IPINST]
  }
}

proc update_PARAM_VALUE.tl_pf_enable_reg {PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.functional_mode} { 

  set functional_mode  [get_property value ${PARAM_VALUE.functional_mode}]

  if {$functional_mode == "MQDMA"} { 
    set_property enabled true  ${PARAM_VALUE.tl_pf_enable_reg}
    set_property range_value "1,1,2" ${PARAM_VALUE.tl_pf_enable_reg}
  } else { 
    set_property enabled true  ${PARAM_VALUE.tl_pf_enable_reg}
    set_property range_value "1,1,2" ${PARAM_VALUE.tl_pf_enable_reg}
  }
  
}

proc update_PARAM_VALUE.SRIOV_CAP_ENABLE {PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.functional_mode} { 
  set functional_mode  [get_property value ${PARAM_VALUE.functional_mode}]
  if {$functional_mode == "MQDMA"} { 
    set_property enabled true ${PARAM_VALUE.SRIOV_CAP_ENABLE}
    set_property value false ${PARAM_VALUE.SRIOV_CAP_ENABLE}
  } else { 
    set_property enabled false ${PARAM_VALUE.SRIOV_CAP_ENABLE}
    set_property value [get_property default_value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] ${PARAM_VALUE.SRIOV_CAP_ENABLE}
  }
}

proc update_PARAM_VALUE.MSI_X_OPTIONS {PARAM_VALUE.MSI_X_OPTIONS PARAM_VALUE.functional_mode PARAM_VALUE.mode_selection PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.device_port_type} { 
  set functional_mode  [get_property value ${PARAM_VALUE.functional_mode}]
  if {$functional_mode == "MQDMA"} { 
    if {[get_property value ${PARAM_VALUE.mode_selection}] == "Basic"} {
    } else {
      if {[get_property value ${PARAM_VALUE.device_port_type}] == "Root_Port_of_PCI_Express_Root_Complex"} {
        set_property range_value "None,None" ${PARAM_VALUE.MSI_X_OPTIONS}
        set_property enabled false ${PARAM_VALUE.MSI_X_OPTIONS} 
      } else {
        if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}]} {
          set_property range_value "MSI-X_External,MSI-X_External,MSI-X_Internal,MSI-X_AXI4-Stream,None" ${PARAM_VALUE.MSI_X_OPTIONS}
          set_property enabled true  ${PARAM_VALUE.MSI_X_OPTIONS}
        } else {
          set_property range_value "None,None,MSI-X_External,MSI-X_Internal,MSI-X_AXI4-Stream" ${PARAM_VALUE.MSI_X_OPTIONS} 
          set_property enabled true ${PARAM_VALUE.MSI_X_OPTIONS} 
        }
      }
    }
  } else { 
    set_property enabled false ${PARAM_VALUE.MSI_X_OPTIONS}
    set_property value [get_property default_value ${PARAM_VALUE.MSI_X_OPTIONS}] ${PARAM_VALUE.MSI_X_OPTIONS}
  }
}

proc update_gui_for_PARAM_VALUE.MSI_X_OPTIONS {PARAM_VALUE.MSI_X_OPTIONS PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.mode_selection IPINST} {
  set tl_pf_enable_reg [get_property value ${PARAM_VALUE.tl_pf_enable_reg}]
  set msix_options     [get_property value ${PARAM_VALUE.MSI_X_OPTIONS}]
  set mode             [get_property value ${PARAM_VALUE.mode_selection}]
  set pf0_msix_grp     [ipgui::get_groupspec PF0_msix -of $IPINST]
  set pf1_msix_grp     [ipgui::get_groupspec PF1_msix -of $IPINST]
  set pf2_msix_grp     [ipgui::get_groupspec PF2_msix -of $IPINST]
  set pf3_msix_grp     [ipgui::get_groupspec PF3_msix -of $IPINST]

  if {$msix_options ==  "None"} { 
    set_property visible false $pf0_msix_grp
    set_property visible false $pf1_msix_grp
    set_property visible false $pf2_msix_grp
    set_property visible false $pf3_msix_grp
  } else { 
    if {$tl_pf_enable_reg == 1} { 
      set_property visible true $pf0_msix_grp
      set_property visible false $pf1_msix_grp
      set_property visible false $pf2_msix_grp
      set_property visible false $pf3_msix_grp
    } elseif {$tl_pf_enable_reg == 2} { 
      set_property visible true $pf0_msix_grp
      set_property visible true $pf1_msix_grp
      set_property visible false $pf2_msix_grp
      set_property visible false $pf3_msix_grp
    } elseif {$tl_pf_enable_reg == 3} { 
      set_property visible true $pf0_msix_grp
      set_property visible true $pf1_msix_grp
      set_property visible true $pf2_msix_grp
      set_property visible false $pf3_msix_grp
    } elseif {$tl_pf_enable_reg == 4} { 
      set_property visible true $pf0_msix_grp
      set_property visible true $pf1_msix_grp
      set_property visible true $pf2_msix_grp
      set_property visible true $pf3_msix_grp
    }
  } 

}

proc update_gui_for_PARAM_VALUE.SRIOV_CAP_ENABLE {IPINST PARAM_VALUE.SRIOV_CAP_ENABLE} { 

  set sriov_en [get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}]


  if {$sriov_en} { 
    set_property visible true [ipgui::get_pagespec -name sriov_config -of $IPINST]
    set_property visible true [ipgui::get_pagespec -name sriov_bars -of $IPINST]
  } else {
    set_property visible false [ipgui::get_pagespec -name sriov_config -of $IPINST]
    set_property visible false [ipgui::get_pagespec -name sriov_bars -of $IPINST]
  }
  
}

proc update_gui_for_PARAM_VALUE.tl_pf_enable_reg {PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.functional_mode IPINST} { 
  set num_pf           [get_property value ${PARAM_VALUE.tl_pf_enable_reg}]
  set functional_mode  [get_property value ${PARAM_VALUE.functional_mode}]
  set pf1_grp          [ipgui::get_groupspec -name pf1_option_grp_mqdma -of $IPINST]
  set pf2_grp          [ipgui::get_groupspec -name pf2_option_grp_mqdma -of $IPINST]
  set pf3_grp          [ipgui::get_groupspec -name pf3_option_grp_mqdma -of $IPINST]
  set copy_pf0         [ipgui::get_guiparamspec copy_pf0 -of $IPINST]
  set SRIOV_PF1        [ipgui::get_groupspec -name pf1_sriov_option_grp -of $IPINST]
  set SRIOV_PF2        [ipgui::get_groupspec -name pf2_sriov_option_grp -of $IPINST]
  set SRIOV_PF3        [ipgui::get_groupspec -name pf3_sriov_option_grp -of $IPINST]
  set SRIOV_PF1_CFG    [ipgui::get_groupspec -name pf1_sriov_config_grp -of $IPINST]
  set SRIOV_PF2_CFG    [ipgui::get_groupspec -name pf2_sriov_config_grp -of $IPINST]
  set SRIOV_PF3_CFG    [ipgui::get_groupspec -name pf3_sriov_config_grp -of $IPINST]
  set copy_sriov_pf0   [ipgui::get_guiparamspec copy_sriov_pf0 -of $IPINST]
  set pf0_msix_grp     [ipgui::get_groupspec PF0_msix -of $IPINST]
  set pf1_msix_grp     [ipgui::get_groupspec PF1_msix -of $IPINST]
  set pf2_msix_grp     [ipgui::get_groupspec PF2_msix -of $IPINST]
  set pf3_msix_grp     [ipgui::get_groupspec PF3_msix -of $IPINST]

  if {$num_pf == 2 && $functional_mode == "DMA_and_Bridge" } { 
    set_property visible true [ipgui::get_pagespec PF_BARs_tab -of $IPINST]
    set_property visible true  [ipgui::get_pagespec pcie_id_pf1 -of $IPINST]
  } else { 
    set_property visible false [ipgui::get_pagespec PF_BARs_tab -of $IPINST]
    set_property visible false [ipgui::get_pagespec pcie_id_pf1 -of $IPINST]
    if {$num_pf == 4} {
      set_property hidden_rows "" [ipgui::get_tablespec pf_table_class_code -of $IPINST]
      set_property hidden_rows "" [ipgui::get_tablespec pf_table_id -of $IPINST]
      set_property visible true   $copy_pf0
      set_property visible true   $pf1_grp
      set_property visible true   $pf2_grp
      set_property visible true   $pf3_grp
      set_property visible true   $SRIOV_PF1
      set_property visible true   $SRIOV_PF2
      set_property visible true   $SRIOV_PF3
      set_property visible true   $SRIOV_PF1_CFG
      set_property visible true   $SRIOV_PF2_CFG
      set_property visible true   $SRIOV_PF3_CFG
      set_property visible true   $copy_sriov_pf0
      set_property visible true   $pf0_msix_grp
      set_property visible true   $pf1_msix_grp
      set_property visible true   $pf2_msix_grp
      set_property visible true   $pf3_msix_grp
    } elseif {$num_pf == 3 } { 
      set_property hidden_rows "4" [ipgui::get_tablespec pf_table_class_code -of $IPINST]
      set_property hidden_rows "4" [ipgui::get_tablespec pf_table_id -of $IPINST]
      set_property visible true  $copy_pf0
      set_property visible true  $pf1_grp
      set_property visible true  $pf2_grp
      set_property visible false $pf3_grp
      set_property visible true  $SRIOV_PF1
      set_property visible true  $SRIOV_PF2
      set_property visible false $SRIOV_PF3
      set_property visible true  $SRIOV_PF1_CFG
      set_property visible true  $SRIOV_PF2_CFG
      set_property visible false $SRIOV_PF3_CFG
      set_property visible true  $copy_sriov_pf0
      set_property visible true  $pf0_msix_grp
      set_property visible true  $pf1_msix_grp
      set_property visible true  $pf2_msix_grp
      set_property visible false $pf3_msix_grp
    } elseif {$num_pf == 2 } { 
      set_property hidden_rows "3,4" [ipgui::get_tablespec pf_table_class_code -of $IPINST]
      set_property hidden_rows "3,4" [ipgui::get_tablespec pf_table_id -of $IPINST]
      set_property visible true  $copy_pf0
      set_property visible true  $pf1_grp
      set_property visible false $pf2_grp
      set_property visible false $pf3_grp
      set_property visible true  $SRIOV_PF1
      set_property visible false $SRIOV_PF2
      set_property visible false $SRIOV_PF3
      set_property visible true  $SRIOV_PF1_CFG
      set_property visible false $SRIOV_PF2_CFG
      set_property visible false $SRIOV_PF3_CFG
      set_property visible true  $copy_sriov_pf0
      set_property visible true  $pf0_msix_grp
      set_property visible true  $pf1_msix_grp
      set_property visible false $pf2_msix_grp
      set_property visible false $pf3_msix_grp
    } elseif {$num_pf == 1 } { 
      set_property hidden_rows "2,3,4" [ipgui::get_tablespec pf_table_class_code -of $IPINST]
      set_property hidden_rows "2,3,4" [ipgui::get_tablespec pf_table_id -of $IPINST]
      set_property visible false  $copy_pf0
      set_property visible false  $pf1_grp
      set_property visible false  $pf2_grp
      set_property visible false  $pf3_grp
      set_property visible false  $SRIOV_PF1
      set_property visible false  $SRIOV_PF2
      set_property visible false  $SRIOV_PF3
      set_property visible false  $SRIOV_PF1_CFG
      set_property visible false  $SRIOV_PF2_CFG
      set_property visible false  $SRIOV_PF3_CFG
      set_property visible false  $copy_sriov_pf0
      if {$functional_mode == "MQDMA"} { 
        set_property visible true   $pf0_msix_grp
      } else { 
        set_property visible false   $pf0_msix_grp
      }
      set_property visible false  $pf1_msix_grp
      set_property visible false  $pf2_msix_grp
      set_property visible false  $pf3_msix_grp
    }
  }

}

proc update_gui_for_PARAM_VALUE.functional_mode {IPINST PARAM_VALUE.functional_mode PARAM_VALUE.en_axi_slave_if PARAM_VALUE.mult_pf_des PARAM_VALUE.device_port_type PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.mode_selection PARAM_VALUE.SRIOV_CAP_ENABLE} { 
  set functional_mode  [get_property value ${PARAM_VALUE.functional_mode}]
  set en_axi_slave     [get_property value ${PARAM_VALUE.en_axi_slave_if}]
  set mult_pf_des_val  [get_property value ${PARAM_VALUE.mult_pf_des}]
  set dev_port_type    [get_property value ${PARAM_VALUE.device_port_type}]
  set num_pf           [get_property value ${PARAM_VALUE.tl_pf_enable_reg}]
  set mode             [get_property value ${PARAM_VALUE.mode_selection}]
  set sriov_cap_en     [get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}]
  set pf1_grp          [ipgui::get_groupspec -name pf1_option_grp_mqdma -of $IPINST]
  set pf2_grp          [ipgui::get_groupspec -name pf2_option_grp_mqdma -of $IPINST]
  set pf3_grp          [ipgui::get_groupspec -name pf3_option_grp_mqdma -of $IPINST]
  set copy_pf0         [ipgui::get_guiparamspec copy_pf0 -of $IPINST]
  set SRIOV_PF1        [ipgui::get_groupspec -name pf1_sriov_option_grp -of $IPINST]
  set SRIOV_PF2        [ipgui::get_groupspec -name pf2_sriov_option_grp -of $IPINST]
  set SRIOV_PF3        [ipgui::get_groupspec -name pf3_sriov_option_grp -of $IPINST]
  set SRIOV_PF1_CFG    [ipgui::get_groupspec -name pf1_sriov_config_grp -of $IPINST]
  set SRIOV_PF2_CFG    [ipgui::get_groupspec -name pf2_sriov_config_grp -of $IPINST]
  set SRIOV_PF3_CFG    [ipgui::get_groupspec -name pf3_sriov_config_grp -of $IPINST]
  set copy_sriov_pf0   [ipgui::get_guiparamspec copy_sriov_pf0 -of $IPINST]
  set pf0_msix_grp     [ipgui::get_groupspec PF0_msix -of $IPINST]
  set pf1_msix_grp     [ipgui::get_groupspec PF1_msix -of $IPINST]
  set pf2_msix_grp     [ipgui::get_groupspec PF2_msix -of $IPINST]
  set pf3_msix_grp     [ipgui::get_groupspec PF3_msix -of $IPINST]
   
  if {$functional_mode == "DMA"} { 
    if {$mult_pf_des_val } { 
      if {$en_axi_slave == "true"} { 
        set_property visible true  [ipgui::get_pagespec axi_bars -of $IPINST]
      } else { 
        set_property visible false  [ipgui::get_pagespec axi_bars -of $IPINST]
      }
    } 
    set_property display_name "Descriptor Bypass for Read (H2C)" [ipgui::get_guiparamspec -name dsc_bypass_rd -of $IPINST]
    set_property display_name "Descriptor Bypass for Write (C2H)" [ipgui::get_guiparamspec -name dsc_bypass_wr -of $IPINST]
    set_property visible true  [ipgui::get_pagespec axi_misc -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec en_axi_slave_if -of $IPINST]
    set_property visible true  [ipgui::get_pagespec xdma -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec xdma_axi_intf_mm -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec performance -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec pcie_extended_tag -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec cfg_mgmt_if -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec xdma_axilite_slave -of $IPINST] 
    set_property visible true  [ipgui::get_guiparamspec parity_settings -of $IPINST] 
    set_property visible true  [ipgui::get_pagespec PCIE0_BARS -of $IPINST]
    set_property visible true  [ipgui::get_pagespec pcie_id -of $IPINST]
    set_property visible false [ipgui::get_pagespec PF_BARs_MQDMA -of $IPINST]
    set_property visible false [ipgui::get_pagespec ID_tab_mqdma -of $IPINST]
    set_property visible false [ipgui::get_pagespec PF_BARs_tab -of $IPINST]
    set_property visible false [ipgui::get_pagespec pcie_id_pf1 -of $IPINST]
    set_property visible false [ipgui::get_pagespec PCIE0_BARS_BRIDGE -of $IPINST]
    set_property visible false [ipgui::get_groupspec Bar_Indicator_Settings -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec en_axi_master_if -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
    set_property visible false [ipgui::get_pagespec axi_misc -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec en_axi_slave_if -of $IPINST]
    set_property visible false [ipgui::get_pagespec axi_bars -of $IPINST]
    set_property visible false [ipgui::get_groupspec l23_entry -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
    set_property visible false [ipgui::get_groupspec physical_functions -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec tl_pf_enable_reg -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec SRIOV_CAP_ENABLE -of $IPINST]
    set_property visible false [ipgui::get_pagespec -name sriov_config -of $IPINST]
    set_property visible false [ipgui::get_pagespec -name sriov_bars -of $IPINST]
    set_property visible false [ipgui::get_groupspec MSI_X_OPTIONS_grp -of $IPINST]
    set_property visible false  $pf0_msix_grp
    set_property visible false  $pf1_msix_grp
    set_property visible false  $pf2_msix_grp
    set_property visible false  $pf3_msix_grp
    set_property visible false [ipgui::get_guiparamspec -name dsc_bypass_wr_out -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec -name dsc_bypass_rd_out -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec -name num_queues -of $IPINST]
    set_property visible false [ipgui::get_groupspec xdma_axi_intf_mm_mqdma -of $IPINST]
  } elseif {$functional_mode == "AXI_Bridge"} { 
    if {$mode == "Basic" } { 
     set_property visible false [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
    } else { 
     set_property visible true  [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
    }
    if {$en_axi_slave == "true"} { 
      set_property visible true  [ipgui::get_pagespec axi_bars -of $IPINST]
    } else { 
      set_property visible false  [ipgui::get_pagespec axi_bars -of $IPINST]
    }
    if {$dev_port_type == "Root_Port_of_PCI_Express_Root_Complex" } { 
      set_property visible true [ipgui::get_groupspec l23_entry -of $IPINST]
      set_property visible true [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
      set_property visible fasle [ipgui::get_guiparamspec cfg_ext_if -of $IPINST]
      set_property visible fasle [ipgui::get_guiparamspec ext_xvc_vsec_enable -of $IPINST]
    } else { 
      set_property visible false [ipgui::get_groupspec l23_entry -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
      set_property visible true [ipgui::get_guiparamspec cfg_ext_if -of $IPINST]
      set_property visible true [ipgui::get_guiparamspec ext_xvc_vsec_enable -of $IPINST]
    }
    set_property visible true  [ipgui::get_pagespec pcie_id -of $IPINST]
    set_property visible true  [ipgui::get_pagespec PCIE0_BARS_BRIDGE -of $IPINST]
    set_property visible true  [ipgui::get_groupspec Bar_Indicator_Settings -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec en_axi_master_if -of $IPINST] 
    set_property visible true  [ipgui::get_pagespec axi_misc -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec en_axi_slave_if -of $IPINST]
    set_property visible false [ipgui::get_pagespec PF_BARs_MQDMA -of $IPINST]
    set_property visible false [ipgui::get_pagespec ID_tab_mqdma -of $IPINST]
    set_property visible false [ipgui::get_pagespec PCIE0_BARS -of $IPINST]
    set_property visible false [ipgui::get_pagespec xdma -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec xdma_axi_intf_mm -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec performance -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec pcie_extended_tag -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec cfg_mgmt_if -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec xdma_axilite_slave -of $IPINST]
    set_property visible false [ipgui::get_groupspec physical_functions -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec tl_pf_enable_reg -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec SRIOV_CAP_ENABLE -of $IPINST]
    set_property visible false [ipgui::get_pagespec -name sriov_config -of $IPINST]
    set_property visible false [ipgui::get_pagespec -name sriov_bars -of $IPINST]
    set_property visible false [ipgui::get_groupspec MSI_X_OPTIONS_grp -of $IPINST]
    set_property visible false [ipgui::get_groupspec xdma_axi_intf_mm_mqdma -of $IPINST]
    set_property visible false  $pf0_msix_grp
    set_property visible false  $pf1_msix_grp
    set_property visible false  $pf2_msix_grp
    set_property visible false  $pf3_msix_grp
  } elseif {$functional_mode == "DMA_and_Bridge"} { 
    if {$num_pf == 2 } { 
      set_property visible true [ipgui::get_pagespec PF_BARs_tab -of $IPINST]
      set_property visible true  [ipgui::get_pagespec pcie_id_pf1 -of $IPINST]
    } else { 
      set_property visible false [ipgui::get_pagespec PF_BARs_tab -of $IPINST]
      set_property visible false [ipgui::get_pagespec pcie_id_pf1 -of $IPINST]
    }
    if {$en_axi_slave == "true"} { 
      set_property visible true  [ipgui::get_pagespec axi_bars -of $IPINST]
    } else { 
      set_property visible false  [ipgui::get_pagespec axi_bars -of $IPINST]
    }
    if {$dev_port_type == "Root_Port_of_PCI_Express_Root_Complex" } { 
      set_property visible true [ipgui::get_groupspec l23_entry -of $IPINST]
      set_property visible true [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
      set_property visible fasle [ipgui::get_guiparamspec cfg_ext_if -of $IPINST]
      set_property visible fasle [ipgui::get_guiparamspec ext_xvc_vsec_enable -of $IPINST]
    } else { 
      set_property visible false [ipgui::get_groupspec l23_entry -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
      set_property visible true [ipgui::get_guiparamspec cfg_ext_if -of $IPINST]
      set_property visible true [ipgui::get_guiparamspec ext_xvc_vsec_enable -of $IPINST]
    }
    set_property visible true  [ipgui::get_pagespec axi_misc -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec en_axi_slave_if -of $IPINST]
    set_property visible true  [ipgui::get_pagespec PCIE0_BARS -of $IPINST]
    set_property visible true  [ipgui::get_pagespec pcie_id -of $IPINST]
    set_property visible true  [ipgui::get_pagespec PCIE0_BARS_BRIDGE -of $IPINST]
    set_property visible true  [ipgui::get_pagespec xdma -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec xdma_axi_intf_mm -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec performance -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec pcie_extended_tag -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec cfg_mgmt_if -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec xdma_axilite_slave -of $IPINST]
    set_property visible true  [ipgui::get_groupspec physical_functions -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec tl_pf_enable_reg -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec SRIOV_CAP_ENABLE -of $IPINST]
    set_property visible false [ipgui::get_pagespec PF_BARs_MQDMA -of $IPINST]
    set_property visible false [ipgui::get_pagespec ID_tab_mqdma -of $IPINST]
    set_property visible false [ipgui::get_groupspec Bar_Indicator_Settings -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec en_axi_master_if -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
    set_property visible false [ipgui::get_pagespec -name sriov_config -of $IPINST]
    set_property visible false [ipgui::get_pagespec -name sriov_bars -of $IPINST]
    set_property visible false [ipgui::get_groupspec MSI_X_OPTIONS_grp -of $IPINST]
    set_property visible false  $pf0_msix_grp
    set_property visible false  $pf1_msix_grp
    set_property visible false  $pf2_msix_grp
    set_property visible false  $pf3_msix_grp
    set_property display_name "Descriptor Bypass for Read (H2C)" [ipgui::get_guiparamspec -name dsc_bypass_rd -of $IPINST]
    set_property display_name "Descriptor Bypass for Write (C2H)" [ipgui::get_guiparamspec -name dsc_bypass_wr -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec parity_settings -of $IPINST] 
    set_property visible false [ipgui::get_guiparamspec -name num_queues -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec -name dsc_bypass_wr_out -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec -name dsc_bypass_rd_out -of $IPINST]
    set_property visible false [ipgui::get_groupspec xdma_axi_intf_mm_mqdma -of $IPINST]
  } elseif {$functional_mode == "MQDMA" } { 
    set_property visible true  [ipgui::get_pagespec PF_BARs_MQDMA -of $IPINST]
    set_property visible true  [ipgui::get_pagespec ID_tab_mqdma -of $IPINST]
    set_property visible true  [ipgui::get_pagespec xdma -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec performance -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec pcie_extended_tag -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec cfg_mgmt_if -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec xdma_axilite_slave -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec xdma_axi_intf_mm -of $IPINST]
    set_property visible false [ipgui::get_groupspec msix_capabilities -of $IPINST]
    set_property visible false [ipgui::get_groupspec Legacy_Interrupt_Settings -of $IPINST]
    set_property visible false [ipgui::get_groupspec msi_capabilities -of $IPINST]
    set_property visible false [ipgui::get_pagespec PCIE0_BARS -of $IPINST]
    set_property visible false [ipgui::get_pagespec pcie_id -of $IPINST]
    set_property visible false [ipgui::get_pagespec PCIE0_BARS_BRIDGE -of $IPINST]
    set_property visible false [ipgui::get_pagespec PF_BARs_tab -of $IPINST]
    set_property visible false [ipgui::get_pagespec pcie_id_pf1 -of $IPINST]
    set_property visible false [ipgui::get_groupspec Bar_Indicator_Settings -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec en_axi_master_if -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
    set_property visible false [ipgui::get_pagespec axi_misc -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec en_axi_slave_if -of $IPINST]
    set_property visible false [ipgui::get_pagespec axi_bars -of $IPINST]
    set_property visible false [ipgui::get_groupspec l23_entry -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec parity_settings -of $IPINST] 
    set_property visible true [ipgui::get_guiparamspec -name num_queues -of $IPINST]
    set_property visible true [ipgui::get_guiparamspec -name dsc_bypass_wr_out -of $IPINST]
    set_property visible true [ipgui::get_guiparamspec -name dsc_bypass_rd_out -of $IPINST]
    set_property display_name "Descriptor Bypass-in for Read (H2C)" [ipgui::get_guiparamspec -name dsc_bypass_rd -of $IPINST]
    set_property display_name "Descriptor Bypass-in for Write (C2H)" [ipgui::get_guiparamspec -name dsc_bypass_wr -of $IPINST]
    set_property visible true  [ipgui::get_groupspec xdma_axi_intf_mm_mqdma -of $IPINST]
    if {$mode == "Basic"} { 
      set_property visible false [ipgui::get_groupspec physical_functions -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec tl_pf_enable_reg -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec SRIOV_CAP_ENABLE -of $IPINST]
      set_property visible false [ipgui::get_groupspec MSI_X_OPTIONS_grp -of $IPINST]
    } else { 
      set_property visible true [ipgui::get_groupspec physical_functions -of $IPINST]
      set_property visible true [ipgui::get_guiparamspec tl_pf_enable_reg -of $IPINST]
      set_property visible true [ipgui::get_guiparamspec SRIOV_CAP_ENABLE -of $IPINST]
      set_property visible true [ipgui::get_groupspec MSI_X_OPTIONS_grp -of $IPINST]
      if {$num_pf == 4} {
        set_property hidden_rows "" [ipgui::get_tablespec pf_table_class_code -of $IPINST]
        set_property hidden_rows "" [ipgui::get_tablespec pf_table_id -of $IPINST]
        set_property visible true   $copy_pf0
        set_property visible true   $pf1_drp
        set_property visible true   $pf2_drp
        set_property visible true   $pf3_drp
        set_property visible true   $SRIOV_PF1
        set_property visible true   $SRIOV_PF2
        set_property visible true   $SRIOV_PF3
        set_property visible true   $SRIOV_PF1_CFG
        set_property visible true   $SRIOV_PF2_CFG
        set_property visible true   $SRIOV_PF3_CFG
        set_property visible true   $copy_sriov_pf0
        if {get_property value ${PARAM_VALUE.MSI_X_OPTIONS}] == "None" } { 
          set_property visible false   $pf1_msix_grp
          set_property visible false   $pf2_msix_grp
          set_property visible false   $pf3_msix_grp
        } else { 
          set_property visible true   $pf1_msix_grp
          set_property visible true   $pf2_msix_grp
          set_property visible true   $pf3_msix_grp
        }
      } elseif {$num_pf == 3 } { 
        set_property hidden_rows "4" [ipgui::get_tablespec pf_table_class_code -of $IPINST]
        set_property hidden_rows "4" [ipgui::get_tablespec pf_table_id -of $IPINST]
        set_property visible true   $copy_pf0
        set_property visible true   $pf1_drp
        set_property visible true   $pf2_drp
        set_property visible false  $pf3_drp
        set_property visible true   $SRIOV_PF1
        set_property visible true   $SRIOV_PF2
        set_property visible false  $SRIOV_PF3
        set_property visible true   $SRIOV_PF1_CFG
        set_property visible true   $SRIOV_PF2_CFG
        set_property visible false  $SRIOV_PF3_CFG
        set_property visible true   $copy_sriov_pf0
        if {get_property value ${PARAM_VALUE.MSI_X_OPTIONS}] == "None" } { 
          set_property visible false   $pf1_msix_grp
          set_property visible false   $pf2_msix_grp
          set_property visible false   $pf3_msix_grp
        } else { 
        set_property visible true   $pf1_msix_grp
        set_property visible true   $pf2_msix_grp
        set_property visible false  $pf3_msix_grp
        }
      } elseif {$num_pf == 2 } { 
        set_property hidden_rows "3,4" [ipgui::get_tablespec pf_table_class_code -of $IPINST]
        set_property hidden_rows "3,4" [ipgui::get_tablespec pf_table_id -of $IPINST]
        set_property visible true  $copy_pf0
        set_property visible true  $pf1_drp
        set_property visible false $pf2_drp
        set_property visible false $pf3_drp
        set_property visible true  $SRIOV_PF1
        set_property visible false $SRIOV_PF2
        set_property visible false $SRIOV_PF3
        set_property visible true  $SRIOV_PF1_CFG
        set_property visible false $SRIOV_PF2_CFG
        set_property visible false $SRIOV_PF3_CFG
        set_property visible true  $copy_sriov_pf0
        if {get_property value ${PARAM_VALUE.MSI_X_OPTIONS}] == "None" } { 
          set_property visible false   $pf1_msix_grp
          set_property visible false   $pf2_msix_grp
          set_property visible false   $pf3_msix_grp
        } else { 
        set_property visible true  $pf1_msix_grp
        set_property visible false $pf2_msix_grp
        set_property visible false $pf3_msix_grp
        }
      } elseif {$num_pf == 1 } { 
        set_property hidden_rows "2,3,4" [ipgui::get_tablespec pf_table_class_code -of $IPINST]
        set_property hidden_rows "2,3,4" [ipgui::get_tablespec pf_table_id -of $IPINST]
        set_property visible false  $copy_pf0
        set_property visible false  $pf1_drp
        set_property visible false  $pf2_drp
        set_property visible false  $pf3_drp
        set_property visible false  $SRIOV_PF1
        set_property visible false  $SRIOV_PF2
        set_property visible false  $SRIOV_PF3
        set_property visible false  $SRIOV_PF1_CFG
        set_property visible false  $SRIOV_PF2_CFG
        set_property visible false  $SRIOV_PF3_CFG
        set_property visible false  $copy_sriov_pf0
        if {get_property value ${PARAM_VALUE.MSI_X_OPTIONS}] == "None" } { 
          set_property visible false   $pf1_msix_grp
          set_property visible false   $pf2_msix_grp
          set_property visible false   $pf3_msix_grp
        } else { 
        set_property visible false  $pf1_msix_grp
        set_property visible false  $pf2_msix_grp
        set_property visible false  $pf3_msix_grp
        }
      }
    }
    if {$sriov_cap_en} { 
      set_property visible true [ipgui::get_pagespec -name sriov_config -of $IPINST]
      set_property visible true [ipgui::get_pagespec -name sriov_bars -of $IPINST]
    } else { 
      set_property visible false [ipgui::get_pagespec -name sriov_config -of $IPINST]
      set_property visible false [ipgui::get_pagespec -name sriov_bars -of $IPINST]
    }
  } 
}

proc update_PARAM_VALUE.device_port_type {PARAM_VALUE.device_port_type PARAM_VALUE.functional_mode} { 

  set functional_mode  [get_property value ${PARAM_VALUE.functional_mode}]

  if {$functional_mode == "AXI_Bridge" || $functional_mode == "DMA_and_Bridge"} { 
    set_property range "PCI_Express_Endpoint_device,Root_Port_of_PCI_Express_Root_Complex" ${PARAM_VALUE.device_port_type}
    set_property enabled true ${PARAM_VALUE.device_port_type}
  } else { 
    set_property range "PCI_Express_Endpoint_device,PCI_Express_Endpoint_device" ${PARAM_VALUE.device_port_type}
    set_property enabled false ${PARAM_VALUE.device_port_type}
  }
}

proc update_PARAM_VALUE.axi_addr_width {PARAM_VALUE.axi_addr_width PARAM_VALUE.functional_mode} { 
  set functional_mode  [get_property value ${PARAM_VALUE.functional_mode}]

  if {$functional_mode == "AXI_Bridge"} { 
    set_property enabled true ${PARAM_VALUE.axi_addr_width}
    set_property value 32 ${PARAM_VALUE.axi_addr_width}
  } else { 
    set_property enabled false ${PARAM_VALUE.axi_addr_width}
    set_property value [get_property default_value ${PARAM_VALUE.axi_addr_width}] ${PARAM_VALUE.axi_addr_width}
  }

}

proc update_PARAM_VALUE.s_axi_id_width {PARAM_VALUE.s_axi_id_width PARAM_VALUE.mult_pf_des PARAM_VALUE.functional_mode} {
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set mult_pf_des_val [get_property value  ${PARAM_VALUE.mult_pf_des}] 

   if {$mult_pf_des_val } {
     set range_list "5,6,7,8,9,10,11,12,13,14,15,16"
     set default_val 5 
  } else {
     set range_list "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31"
     set default_val 4 
  }
    set_property range_value "$default_val,$range_list"  ${PARAM_VALUE.s_axi_id_width}
}

proc update_PARAM_VALUE.axi_id_width {PARAM_VALUE.axi_id_width PARAM_VALUE.mult_pf_des} {
  set mult_pf_des_val [get_property value  ${PARAM_VALUE.mult_pf_des}] 
  if {$mult_pf_des_val } {
     set range_list "2, 4, 5"
     set default_val 4 
  } else {
     set range_list "2, 4"
     set default_val 4 
  }
    set_property range_value "$default_val,$range_list"  ${PARAM_VALUE.axi_id_width}
}

proc update_PARAM_VALUE.c_s_axi_num_read {PARAM_VALUE.c_s_axi_num_read PARAM_VALUE.en_axi_slave_if PARAM_VALUE.mult_pf_des} {
  set en_slave [get_property value  ${PARAM_VALUE.en_axi_slave_if}] 
  set mult_pf_des_val [get_property value  ${PARAM_VALUE.mult_pf_des}] 

  if {$mult_pf_des_val } {
    set_property enabled true ${PARAM_VALUE.c_s_axi_num_read}
    set range_list "8, 32"
    set default_val 32 
  } elseif {$en_slave } {
    set range_list "2,4,8,16,32"
    set default_val 8  
    set_property enabled false ${PARAM_VALUE.c_s_axi_num_read}
  } else {
    set range_list "2,4,8,16,32"
    set default_val 8  
    set_property enabled true  ${PARAM_VALUE.c_s_axi_num_read}
  }
    set_property range_value "$default_val,$range_list"  ${PARAM_VALUE.c_s_axi_num_read}
}

proc update_PARAM_VALUE.legacy_cfg_ext_if {PARAM_VALUE.legacy_cfg_ext_if PARAM_VALUE.mult_pf_des PROJECT_PARAM.ARCHITECTURE } {
  set mult_pf_des_val [get_property value  ${PARAM_VALUE.mult_pf_des}] 
  set c_xfamily       [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]

  if { ($c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm") && ($mult_pf_des_val)} {
    set_property enabled true ${PARAM_VALUE.legacy_cfg_ext_if}
    set_property value false ${PARAM_VALUE.legacy_cfg_ext_if}
  } else {
    set_property enabled false ${PARAM_VALUE.legacy_cfg_ext_if}
    set_property value false ${PARAM_VALUE.legacy_cfg_ext_if}
  }
}

proc update_gui_for_PARAM_VALUE.legacy_cfg_ext_if {PARAM_VALUE.legacy_cfg_ext_if PARAM_VALUE.mult_pf_des PROJECT_PARAM.ARCHITECTURE IPINST} {
  set mult_pf_des_val [get_property value  ${PARAM_VALUE.mult_pf_des}] 
  set c_xfamily       [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]

  if { ($c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm") && ($mult_pf_des_val)} {
    set_property visible true [ipgui::get_guiparamspec legacy_cfg_ext_if -of $IPINST ]
  } else {
    set_property visible false [ipgui::get_guiparamspec legacy_cfg_ext_if -of $IPINST ]
  }
}

proc update_PARAM_VALUE.split_dma {PARAM_VALUE.split_dma PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE } {
  set c_xfamily             [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
  set c_xdevice             ${PROJECT_PARAM.DEVICE}
  set device                [string toupper $c_xdevice]

  if { ($c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm") } {
    if {(($device == "XCVU9P" ) || ($device == "XCVU3P") || ($device == "XCVU13P"))} { 
       set_property enabled true  ${PARAM_VALUE.split_dma}
    } else { 
       set_property enabled false ${PARAM_VALUE.split_dma}
      # set_property value false  ${PARAM_VALUE.split_dma}
    }
  } else { 
       set_property enabled false ${PARAM_VALUE.split_dma}
      # set_property value false  ${PARAM_VALUE.split_dma}
  }
}

proc update_PARAM_VALUE.pipe_line_stage {PARAM_VALUE.pipe_line_stage PARAM_VALUE.split_dma } {
  set split_dma_val    [get_property value ${PARAM_VALUE.split_dma}]

    if { $split_dma_val} { 
       set_property enabled true  ${PARAM_VALUE.pipe_line_stage}
    } else { 
       set_property enabled false ${PARAM_VALUE.pipe_line_stage}
    }
}

proc update_PARAM_VALUE.HIGHADDR {PARAM_VALUE.HIGHADDR PARAM_VALUE.device_port_type} { 

  set port_type [get_property value ${PARAM_VALUE.device_port_type}]

  if {$port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property value 0x001FFFFF ${PARAM_VALUE.HIGHADDR}
  } else {
    set_property value 0x00001FFF ${PARAM_VALUE.HIGHADDR} 
  }

}

proc update_PARAM_VALUE.BASEADDR {PARAM_VALUE.BASEADDR PARAM_VALUE.device_port_type} { 

  set port_type [get_property value ${PARAM_VALUE.device_port_type}]

  if {$port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property value 0x00000000 ${PARAM_VALUE.BASEADDR} 
  } else {
    set_property value 0x00001000 ${PARAM_VALUE.BASEADDR} 
  }

}

proc update_PARAM_VALUE.pf0_msix_enabled {PARAM_VALUE.pf0_msix_enabled  PARAM_VALUE.functional_mode PARAM_VALUE.device_port_type} { 
  set functional_mode  [get_property value ${PARAM_VALUE.functional_mode}]
  set port_type [get_property value ${PARAM_VALUE.device_port_type} ] 

  if {$functional_mode == "AXI_Bridge" || $functional_mode == "DMA_and_Bridge"} { 
    if {$port_type eq "Root_Port_of_PCI_Express_Root_Complex"} { 
      set_property value false  ${PARAM_VALUE.pf0_msix_enabled}
      set_property enabled false  ${PARAM_VALUE.pf0_msix_enabled}
    } else { 
      set_property value false  ${PARAM_VALUE.pf0_msix_enabled}
      set_property enabled true  ${PARAM_VALUE.pf0_msix_enabled}
    }
  } else { 
    set_property value false ${PARAM_VALUE.pf0_msix_enabled}
    set_property enabled true  ${PARAM_VALUE.pf0_msix_enabled}
  }
}

proc update_PARAM_VALUE.comp_timeout {PARAM_VALUE.comp_timeout PARAM_VALUE.functional_mode} { 
  set functional_mode  [get_property value ${PARAM_VALUE.functional_mode}]

  if {$functional_mode == "AXI_Bridge" || $functional_mode == "DMA_and_Bridge"} {
    # Changed the default value for AXI_Bridge and DMA_and_Bridge in 2017.1. 
    #set_property value "50us" ${PARAM_VALUE.comp_timeout}
    set_property value "50ms" ${PARAM_VALUE.comp_timeout}
  } else { 
    set_property value "50ms" ${PARAM_VALUE.comp_timeout}
  }
  
}

proc update_gui_for_PARAM_VALUE.Shared_Logic {IPINST PARAM_VALUE.plltype PARAM_VALUE.Shared_Logic PARAM_VALUE.Shared_Logic_Both PARAM_VALUE.Shared_Logic_Clk PARAM_VALUE.Shared_Logic_Gtc PROJECT_PARAM.ARCHITECTURE} {
    set shared_logic [get_property value ${PARAM_VALUE.Shared_Logic} ]
    set Shared_Logic_Both [get_property value ${PARAM_VALUE.Shared_Logic_Both} ]
    set Shared_Logic_Clk  [get_property value ${PARAM_VALUE.Shared_Logic_Clk} ]
    set Shared_Logic_Gtc  [get_property value ${PARAM_VALUE.Shared_Logic_Gtc} ]
    set Plltype           [get_property value ${PARAM_VALUE.plltype}]
    set c_xfamily         [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]

    if {$c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
        if {$shared_logic == 0} {
            set image_path "xgui/without_shared_logic.png"
        } else {
            set image_path "xgui/with_shared_logic.png"
        }
    } elseif {!($c_xfamily == "kintexu" || $c_xfamily == "virtexu")} {
        if {($Shared_Logic_Both == "true") && ($Shared_Logic_Gtc == "false") && ($Shared_Logic_Clk == "false")} {
            set image_path "xgui/Shared_Logic_In_Core.png"
        } elseif {($Shared_Logic_Both == "false") && ($Shared_Logic_Gtc == "false") && ($Shared_Logic_Clk == "false")} {
            set image_path "xgui/No_Shared_Logic.png"
        } elseif {($Shared_Logic_Both == "false") && ($Shared_Logic_Gtc == "true") && ($Shared_Logic_Clk == "false")} {
            set image_path "xgui/Ext_GT_Common_Mode.png"
        } elseif {($Shared_Logic_Both == "false") && ($Shared_Logic_Gtc == "false") && ($Shared_Logic_Clk == "false")} {
            set image_path "xgui/Ext_Clock_Mode.png"
        } elseif {($Shared_Logic_Both == "false") && ($Shared_Logic_Gtc == "true") && ($Shared_Logic_Clk == "true")} {
            set image_path "xgui/Ext_Clk_Ext_GT_common.png"
        }

    } else {
        if {$shared_logic == 0} {
            set image_path "xgui/without_shared_logic.png"
        } else {
            set image_path "xgui/with_shared_logic.png"
        }
    }
  set_property load_image $image_path [ipgui::get_imagespec PixmapAFix2 -of $IPINST]
}

proc update_gui_for_PARAM_VALUE.pf0_Use_Class_Code_Lookup_Assistant {IPINST PARAM_VALUE.pf0_Use_Class_Code_Lookup_Assistant} {

    if {[get_property value ${PARAM_VALUE.pf0_Use_Class_Code_Lookup_Assistant}]} {
        set visible_text  "true"
        set visible_param  "false"
    } else  {
        set  visible_param "true"
        set  visible_text  "false"
    }
    foreach para { pf0_class_code_base pf0_class_code_sub pf0_class_code_interface} {
        set_property visible $visible_param [ipgui::get_guiparamspec -name "$para" -of $IPINST ]
    }

    foreach text_par {pf0_newST1 Base_Class_Value pf0_newST2 Sub_Class_Value pf0_newST3 interface_value} {
        set_property visible $visible_text [ipgui::get_textspec -name "$text_par" -of $IPINST ]
    }
}

proc update_gui_for_PARAM_VALUE.PF1_Use_Class_Code_Lookup_Assistant {IPINST PARAM_VALUE.PF1_Use_Class_Code_Lookup_Assistant} {

    if {[get_property value ${PARAM_VALUE.PF1_Use_Class_Code_Lookup_Assistant}]} {
        set visible_text  "true"
        set visible_param  "false"
    } else  {
        set  visible_param "true"
        set  visible_text  "false"
    }
    foreach para { pf1_class_code_base pf1_class_code_sub pf1_class_code_interface} {
        set_property visible $visible_param [ipgui::get_guiparamspec -name "$para" -of $IPINST ]
    }

    foreach text_par {pf1_newST1 PF1_Base_Class_Value pf1_newST2 PF1_Sub_Class_Value pf1_newST3 PF1_interface_value} {
        set_property visible $visible_text [ipgui::get_textspec -name "$text_par" -of $IPINST ]
    }
}
proc getParentDeviceName {c_family} {
    set c_family [string tolower $c_family]
    if {[string equal -nocase $c_family "artix7"]
        || [string equal -nocase $c_family "artix7l"]
        || [string equal -nocase $c_family "qartix7l"]
        || [string equal -nocase $c_family "qartix7"]
        || [string equal -nocase $c_family "aartix7"]} {
        set c_family "artix7"
    } elseif {[string equal -nocase $c_family "kintex7"]
        || [string equal -nocase $c_family "kintex7l"]
        || [string equal -nocase $c_family "qkintex7l"]
        || [string equal -nocase $c_family "qkintex7"]} {
        set c_family "kintex7"
    } elseif {[string equal -nocase $c_family "virtex7"]
        || [string equal -nocase $c_family "virtex7l"]
        || [string equal -nocase $c_family "qvirtex7l"]
        || [string equal -nocase $c_family "qvirtex7"]} {
        set c_family "virtex7"
    } elseif {[string equal -nocase $c_family "zynq"]
        || [string equal -nocase $c_family "azynq"]
        || [string equal -nocase $c_family "qzynq"]} {
        set c_family "zynq"
    } elseif {[string equal -nocase $c_family "virtexu"]
        || [string equal -nocase $c_family "kintexu"]
        || [string equal -nocase $c_family "artixu"]} {
        set c_family "virtexu"
    }
    return $c_family
}

proc update_PARAM_VALUE.pf0_msi_cap_multimsgcap {PARAM_VALUE.pf0_msi_cap_multimsgcap PARAM_VALUE.pf0_msi_enabled PARAM_VALUE.functional_mode}  {
  set en_multimsgcap [get_property value  ${PARAM_VALUE.pf0_msi_enabled}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$en_multimsgcap } {
    if {$func_mode == "AXI_Bridge"} { 
      set_property range_value "1_vector,1_vector,2_vectors,4_vectors,8_vectors,16_vectors" ${PARAM_VALUE.pf0_msi_cap_multimsgcap}
    } else { 
      set_property range_value "1_vector,1_vector,2_vectors,4_vectors,8_vectors,16_vectors,32_vectors" ${PARAM_VALUE.pf0_msi_cap_multimsgcap}
    }
    set_property enabled true ${PARAM_VALUE.pf0_msi_cap_multimsgcap}
  } else {
    set_property enabled false  ${PARAM_VALUE.pf0_msi_cap_multimsgcap}
    set_property value [get_property default_value ${PARAM_VALUE.pf0_msi_cap_multimsgcap}] ${PARAM_VALUE.pf0_msi_cap_multimsgcap}
  }
}

proc update_PARAM_VALUE.pf0_msix_cap_table_size {PARAM_VALUE.pf0_msix_cap_table_size PARAM_VALUE.pf0_msix_enabled} {

    set pf0_msix_enabled [get_property value ${PARAM_VALUE.pf0_msix_enabled}]

    if {$pf0_msix_enabled == true} {
      set_property enabled true ${PARAM_VALUE.pf0_msix_cap_table_size}
      set_property value 01F ${PARAM_VALUE.pf0_msix_cap_table_size}
    } else {
      set_property enabled false ${PARAM_VALUE.pf0_msix_cap_table_size}
      set_property value 000 ${PARAM_VALUE.pf0_msix_cap_table_size}
    }
}

proc update_PARAM_VALUE.pf0_msix_cap_table_offset {PARAM_VALUE.pf0_msix_cap_table_offset PARAM_VALUE.pf0_msix_enabled} {

    set pf0_msix_enabled [get_property value ${PARAM_VALUE.pf0_msix_enabled}]

    if {$pf0_msix_enabled == true} {
      set_property enabled true ${PARAM_VALUE.pf0_msix_cap_table_offset}
      set_property value "00008000" ${PARAM_VALUE.pf0_msix_cap_table_offset}
    } else {
      set_property enabled false  ${PARAM_VALUE.pf0_msix_cap_table_offset}
      set_property value "00000000" ${PARAM_VALUE.pf0_msix_cap_table_offset}
    }
}

proc update_PARAM_VALUE.pf0_msix_cap_pba_offset {PARAM_VALUE.pf0_msix_cap_pba_offset PARAM_VALUE.pf0_msix_enabled} {

    set pf0_msix_enabled [get_property value ${PARAM_VALUE.pf0_msix_enabled}]

    if {$pf0_msix_enabled == true} {
      set_property enabled true ${PARAM_VALUE.pf0_msix_cap_pba_offset}
      set_property value "00008FE0" ${PARAM_VALUE.pf0_msix_cap_pba_offset}
    } else {
      set_property enabled false ${PARAM_VALUE.pf0_msix_cap_pba_offset}
      set_property value "00000000" ${PARAM_VALUE.pf0_msix_cap_pba_offset}
    }
}

proc validate_PARAM_VALUE.en_axi_master_if {PARAM_VALUE.en_axi_master_if PARAM_VALUE.en_axi_slave_if} { 

  set master_en [get_property value ${PARAM_VALUE.en_axi_master_if}]
  set slave_en [get_property value ${PARAM_VALUE.en_axi_slave_if}]

  if {!$master_en && !$slave_en } { 
    set_property errmsg "Invalid configuration - Both AXI Master and AXI Slave should not be disabled" ${PARAM_VALUE.en_axi_master_if}
    return false 
  } 
  return true 

} 

proc validate_PARAM_VALUE.num_queues {PARAM_VALUE.num_queues} {
    return [RangeCheck4HexDec  0000 2048 ${PARAM_VALUE.num_queues}]
}

proc validate_PARAM_VALUE.pf0_msix_cap_table_size  {PARAM_VALUE.pf0_msix_cap_table_size } {
    return [RangeCheck4HexDec  000 7FF ${PARAM_VALUE.pf0_msix_cap_table_size}]
}

proc validate_PARAM_VALUE.pf0_msix_cap_table_offset {PARAM_VALUE.pf0_msix_cap_table_offset} {
    return [RangeCheck4HexDec 00000000 1FFFFFFF ${PARAM_VALUE.pf0_msix_cap_table_offset}]
}

proc validate_PARAM_VALUE.pf0_msix_cap_pba_offset {PARAM_VALUE.pf0_msix_cap_pba_offset} {
    return [RangeCheck4HexDec 00000000 1FFFFFFF ${PARAM_VALUE.pf0_msix_cap_pba_offset}]
}

proc update_gui_for_PARAM_VALUE.device_port_type {PARAM_VALUE.device_port_type IPINST PARAM_VALUE.functional_mode PARAM_VALUE.mode_selection PARAM_VALUE.type1_membase_memlimit_enable PARAM_VALUE.type1_prefetchable_membase_memlimit PROJECT_PARAM.ARCHITECTURE} { 
  set port_type [get_property value ${PARAM_VALUE.device_port_type}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set mode      [get_property value ${PARAM_VALUE.mode_selection}]
  set c_xfamily      [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]

  if {$port_type == "Root_Port_of_PCI_Express_Root_Complex" } { 
    set_property visible false [ipgui::get_groupspec Bar_Indicator_Settings -of $IPINST ]
    set_property visible false [ipgui::get_groupspec User_Interrupts_Settings -of $IPINST]
    set_property visible false [ipgui::get_groupspec Legacy_Interrupt_Settings -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec pf0_msi_cap_multimsgcap -of $IPINST]
    set_property visible false [ipgui::get_groupspec msix_capabilities -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
    set_property visible false [ipgui::get_groupspec  bar_1_option_grp_sup_br -of $IPINST]
    set_property visible false [ipgui::get_groupspec  bar_2_option_grp_sup_br -of $IPINST]
    set_property visible false [ipgui::get_groupspec  bar_3_option_grp_sup_br -of $IPINST]
    set_property visible false [ipgui::get_groupspec  bar_4_option_grp_sup_br -of $IPINST]
    set_property visible false [ipgui::get_groupspec  bar_5_option_grp_sup_br -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec pf0_bar1_enabled -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec pf0_bar2_enabled -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec pf0_bar3_enabled -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec pf0_bar4_enabled -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec pf0_bar5_enabled -of $IPINST]
    set_property visible fasle [ipgui::get_guiparamspec cfg_ext_if -of $IPINST]
    set_property visible fasle [ipgui::get_guiparamspec ext_xvc_vsec_enable -of $IPINST]
    if {($c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm")} {
        #set_property visible true [ipgui::get_guiparamspec -name type1_membase_memlimit_enable -of $IPINST]
        #set_property visible true [ipgui::get_guiparamspec -name type1_prefetchable_membase_memlimit -of $IPINST]
    } else {
        set_property visible false [ipgui::get_guiparamspec -name type1_membase_memlimit_enable -of $IPINST]
        set_property visible false [ipgui::get_guiparamspec -name type1_prefetchable_membase_memlimit -of $IPINST]
    }
    if {$mode == "Basic" } { 
      set_property visible false [ipgui::get_groupspec l23_entry -of $IPINST]
      set_property visible false [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
    } else { 
      set_property visible true [ipgui::get_groupspec l23_entry -of $IPINST]
      set_property visible true [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
    }
  } else { 
    if {$func_mode == "AXI_Bridge"} { 
      set_property visible true  [ipgui::get_groupspec Bar_Indicator_Settings -of $IPINST ]
      if {$mode == "Basic" } { 
        set_property visible false [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
      } else { 
        set_property visible true [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
      }
    } else { 
      set_property visible false  [ipgui::get_groupspec Bar_Indicator_Settings -of $IPINST ]
      set_property visible false [ipgui::get_guiparamspec pf0_msix_impl_locn -of $IPINST]
    }
    set_property visible true  [ipgui::get_groupspec User_Interrupts_Settings -of $IPINST]
    set_property visible true  [ipgui::get_groupspec Legacy_Interrupt_Settings -of $IPINST]
    set_property visible true  [ipgui::get_guiparamspec pf0_msi_cap_multimsgcap -of $IPINST]
    set_property visible true  [ipgui::get_groupspec msix_capabilities -of $IPINST]
    set_property visible true [ipgui::get_groupspec  bar_1_option_grp_sup_br -of $IPINST]
    set_property visible true [ipgui::get_groupspec  bar_2_option_grp_sup_br -of $IPINST]
    set_property visible true [ipgui::get_groupspec  bar_3_option_grp_sup_br -of $IPINST]
    set_property visible true [ipgui::get_groupspec  bar_4_option_grp_sup_br -of $IPINST]
    set_property visible true [ipgui::get_groupspec  bar_5_option_grp_sup_br -of $IPINST]
    set_property visible true [ipgui::get_guiparamspec pf0_bar1_enabled -of $IPINST]
    set_property visible true [ipgui::get_guiparamspec pf0_bar2_enabled -of $IPINST]
    set_property visible true [ipgui::get_guiparamspec pf0_bar3_enabled -of $IPINST]
    set_property visible true [ipgui::get_guiparamspec pf0_bar4_enabled -of $IPINST]
    set_property visible true [ipgui::get_guiparamspec pf0_bar5_enabled -of $IPINST]
    set_property visible false [ipgui::get_groupspec l23_entry -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec en_l23_entry -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec -name type1_membase_memlimit_enable -of $IPINST]
    set_property visible false [ipgui::get_guiparamspec -name type1_prefetchable_membase_memlimit -of $IPINST]
  }
  
}

proc update_PARAM_VALUE.bar_indicator {PARAM_VALUE.bar_indicator PARAM_VALUE.pf0_bar0_enabled PARAM_VALUE.pf0_bar1_enabled PARAM_VALUE.pf0_bar2_enabled PARAM_VALUE.pf0_bar3_enabled PARAM_VALUE.pf0_bar4_enabled PARAM_VALUE.pf0_bar5_enabled  PARAM_VALUE.pf0_bar0_type PARAM_VALUE.pf0_bar1_type PARAM_VALUE.pf0_bar2_type PARAM_VALUE.pf0_bar3_type PARAM_VALUE.pf0_bar4_type PARAM_VALUE.pf0_bar5_type PARAM_VALUE.pf0_bar0_64bit PARAM_VALUE.pf0_bar1_64bit PARAM_VALUE.pf0_bar2_64bit PARAM_VALUE.pf0_bar3_64bit PARAM_VALUE.pf0_bar4_64bit PARAM_VALUE.pf0_msix_impl_locn PARAM_VALUE.pf0_msix_enabled} { 

  set bar_indicator ${PARAM_VALUE.bar_indicator} 
  set msix_locn [get_property value ${PARAM_VALUE.pf0_msix_impl_locn}]
  set msix_enabled [get_property value ${PARAM_VALUE.pf0_msix_enabled}]

  if {$msix_enabled} { 
    if {$msix_locn == "External" } { 
      set_property enabled false ${PARAM_VALUE.bar_indicator}
    } else { 
      set_property enabled true ${PARAM_VALUE.bar_indicator}
    }
  } else { 
    set_property enabled false ${PARAM_VALUE.bar_indicator}
  }

  set allowed {}

  if {[get_property value ${PARAM_VALUE.pf0_bar0_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar0_type}] eq "Memory"} {
    if {[get_property value ${PARAM_VALUE.pf0_bar0_64bit}] == false} {
      lappend allowed "BAR_0"
    } else {
      lappend allowed "BAR_1:0"
    }
  }
    
  if {[get_property value ${PARAM_VALUE.pf0_bar1_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar1_type}] eq "Memory"} {
    lappend allowed "BAR_1"
  }

  if {[get_property value ${PARAM_VALUE.pf0_bar2_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar2_type}] eq "Memory"} {
    if {[get_property value ${PARAM_VALUE.pf0_bar2_64bit}] == false} {
      lappend allowed "BAR_2"
    } else {
      lappend allowed "BAR_3:2"
    }
  }

  if {[get_property value ${PARAM_VALUE.pf0_bar3_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar3_type}] eq "Memory"} {
      lappend allowed "BAR_3"
  }

  if {[get_property value ${PARAM_VALUE.pf0_bar4_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar4_type}] eq "Memory"} {
    if {[get_property value ${PARAM_VALUE.pf0_bar4_64bit}] == false} {
      lappend allowed "BAR_4"
    } else {
      lappend allowed "BAR_5:4"
    }
  }

  if {[get_property value ${PARAM_VALUE.pf0_bar5_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar5_type}] eq "Memory"} {
    lappend allowed "BAR_5"
  }
  if {$allowed eq {}} {
    set allowed "BAR_0"
  }
  
  set_property range [join $allowed ","] $bar_indicator
} 

proc update_PARAM_VALUE.bar0_indicator {PARAM_VALUE.bar0_indicator PARAM_VALUE.bar_indicator PARAM_VALUE.pf0_msix_impl_locn} { 
  set bar_indicator [get_property value ${PARAM_VALUE.bar_indicator}]
  set msix_impl     [get_property value ${PARAM_VALUE.pf0_msix_impl_locn}]

  if {$msix_impl == "External"} { 
    set val 0
  } else { 
    if {($bar_indicator == "BAR_0" || $bar_indicator == "BAR_1:0")} {
      set val 1
    } else { 
      set val 0
    }
  }
  set_property value $val ${PARAM_VALUE.bar0_indicator}
}

proc update_PARAM_VALUE.bar1_indicator {PARAM_VALUE.bar1_indicator PARAM_VALUE.bar_indicator PARAM_VALUE.pf0_msix_impl_locn} { 
  set bar_indicator [get_property value ${PARAM_VALUE.bar_indicator}]
  set msix_impl     [get_property value ${PARAM_VALUE.pf0_msix_impl_locn}]

  if {$msix_impl == "External"} { 
    set val 0
  } else { 
    if {$bar_indicator == "BAR_1"} {
      set val 1
    } else { 
      set val 0
    }
  }
  set_property value $val ${PARAM_VALUE.bar1_indicator}
}

proc update_PARAM_VALUE.bar2_indicator {PARAM_VALUE.bar2_indicator PARAM_VALUE.bar_indicator PARAM_VALUE.pf0_msix_impl_locn} { 
  set bar_indicator [get_property value ${PARAM_VALUE.bar_indicator}]
  set msix_impl     [get_property value ${PARAM_VALUE.pf0_msix_impl_locn}]

  if {$msix_impl == "External"} { 
    set val 0
  } else { 
    if {($bar_indicator == "BAR_2" || $bar_indicator == "BAR_3:2")} {
      set val 1
    } else { 
      set val 0
    }
  }
  set_property value $val ${PARAM_VALUE.bar2_indicator}
}

proc update_PARAM_VALUE.bar3_indicator {PARAM_VALUE.bar3_indicator PARAM_VALUE.bar_indicator PARAM_VALUE.pf0_msix_impl_locn} { 
  set bar_indicator [get_property value ${PARAM_VALUE.bar_indicator}]
  set msix_impl     [get_property value ${PARAM_VALUE.pf0_msix_impl_locn}]

  if {$msix_impl == "External"} { 
    set val 0
  } else { 
    if {$bar_indicator == "BAR_3" && $msix_impl == "Internal"} {
      set val 1
    } else { 
      set val 0
    }
  }
  set_property value $val ${PARAM_VALUE.bar3_indicator}
}

proc update_PARAM_VALUE.bar4_indicator {PARAM_VALUE.bar4_indicator PARAM_VALUE.bar_indicator PARAM_VALUE.pf0_msix_impl_locn} { 
  set bar_indicator [get_property value ${PARAM_VALUE.bar_indicator}]
  set msix_impl     [get_property value ${PARAM_VALUE.pf0_msix_impl_locn}]

  if {$msix_impl == "External"} { 
    set val 0
  } else { 
    if {($bar_indicator == "BAR_4" || $bar_indicator == "BAR_5:4") && $msix_impl == "Internal"} {
      set val 1
    } else { 
      set val 0
    }
  }
  set_property value $val ${PARAM_VALUE.bar4_indicator}
}

proc update_PARAM_VALUE.bar5_indicator {PARAM_VALUE.bar5_indicator PARAM_VALUE.bar_indicator PARAM_VALUE.pf0_msix_impl_locn} { 
  set bar_indicator [get_property value ${PARAM_VALUE.bar_indicator}]
  set msix_impl     [get_property value ${PARAM_VALUE.pf0_msix_impl_locn}]

  if {$msix_impl == "External"} { 
    set val 0
  } else { 
    if {$bar_indicator == "BAR_5" && $msix_impl == "Internal"} {
      set val 1
    } else { 
      set val 0
    }
  }
  set_property value $val ${PARAM_VALUE.bar5_indicator}
}

proc update_MODELPARAM_VALUE.BARLITE1 {MODELPARAM_VALUE.BARLITE1 PARAM_VALUE.bar_indicator PARAM_VALUE.functional_mode PARAM_VALUE.axilite_master_en PARAM_VALUE.xdma_en PARAM_VALUE.xdma_pcie_64bit_en PARAM_VALUE.axil_master_64bit_en} { 

  set bar_indicator [get_property value ${PARAM_VALUE.bar_indicator}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set xdma_en [get_property value ${PARAM_VALUE.xdma_en}]
  set axilite_master_en [get_property value ${PARAM_VALUE.axilite_master_en}]
  set xdma_64bit_en [get_property value ${PARAM_VALUE.xdma_pcie_64bit_en}]
  set axil_64bit_en [get_property value ${PARAM_VALUE.axil_master_64bit_en}]

  if {$func_mode == "AXI_Bridge"} { 
    if {$bar_indicator == "BAR_0" || $bar_indicator == "BAR_1:0" } { 
      set val 0
    } elseif {$bar_indicator == "BAR_1"} { 
      set val 1
    } elseif {$bar_indicator == "BAR_2" || $bar_indicator == "BAR_3:2"} { 
      set val 2
    } elseif {$bar_indicator == "BAR_3"} { 
      set val 3
    } elseif {$bar_indicator == "BAR_4" || $bar_indicator == "BAR_5:4"} { 
      set val 4
    } elseif {$bar_indicator == "BAR_5"} { 
      set val 5
    }
  } else { 
    if {$axilite_master_en == "false"} { 
      set val 0
    } else { 
      if {($xdma_en || $axilite_master_en) && ($xdma_64bit_en || $axil_64bit_en)} { 
        set val 2
      } else { 
        set val 1
      } 
    }
  }

  set_property value $val ${MODELPARAM_VALUE.BARLITE1}

  #if {$func_mode == "AXI_Bridge"} { 
    #set_property value 7 ${MODELPARAM_VALUE.BARLITE1}
  #} else { 
    #set_property value $val ${MODELPARAM_VALUE.BARLITE1}
  #}

}

proc update_MODELPARAM_VALUE.BARLITE2 {MODELPARAM_VALUE.BARLITE2 PARAM_VALUE.barlite2} { 
    set val [get_property value ${PARAM_VALUE.barlite2}]
    set_property value $val ${MODELPARAM_VALUE.BARLITE2}
}

proc update_PARAM_VALUE.pf0_msix_cap_table_bir {IPINST PARAM_VALUE.pf0_msix_cap_table_bir PARAM_VALUE.pf0_msix_enabled PARAM_VALUE.axilite_master_en PARAM_VALUE.xdma_en PARAM_VALUE.axist_bypass_en PARAM_VALUE.axil_master_64bit_en PARAM_VALUE.xdma_pcie_64bit_en PARAM_VALUE.functional_mode PARAM_VALUE.pf0_bar0_enabled PARAM_VALUE.pf0_bar1_enabled PARAM_VALUE.pf0_bar2_enabled PARAM_VALUE.pf0_bar3_enabled PARAM_VALUE.pf0_bar4_enabled PARAM_VALUE.pf0_bar5_enabled  PARAM_VALUE.pf0_bar0_type PARAM_VALUE.pf0_bar1_type PARAM_VALUE.pf0_bar2_type PARAM_VALUE.pf0_bar3_type PARAM_VALUE.pf0_bar4_type PARAM_VALUE.pf0_bar5_type PARAM_VALUE.pf0_bar0_64bit PARAM_VALUE.pf0_bar1_64bit PARAM_VALUE.pf0_bar2_64bit PARAM_VALUE.pf0_bar3_64bit PARAM_VALUE.pf0_bar4_64bit} {

    set cap_tabl_bir ${PARAM_VALUE.pf0_msix_cap_table_bir}
    set pf0_msix_enabled [get_property value ${PARAM_VALUE.pf0_msix_enabled}]
    set_property enabled $pf0_msix_enabled $cap_tabl_bir
    
    set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
    set allowed {}

    if {$func_mode == "AXI_Bridge"} { 
      if {[get_property value ${PARAM_VALUE.pf0_bar0_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar0_type}] eq "Memory"} {
        if {[get_property value ${PARAM_VALUE.pf0_bar0_64bit}] == false} {
          lappend allowed "BAR_0"
        } else {
          lappend allowed "BAR_1:0"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf0_bar1_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar1_type}] eq "Memory"} {
        if {[get_property value ${PARAM_VALUE.pf0_bar1_64bit}] == false} {
          lappend allowed "BAR_1"
        } else {
          lappend allowed "BAR_2:1"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf0_bar2_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar2_type}] eq "Memory"} {
        if {[get_property value ${PARAM_VALUE.pf0_bar2_64bit}] == false} {
          lappend allowed "BAR_2"
        } else {
          lappend allowed "BAR_3:2"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf0_bar3_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar3_type}] eq "Memory"} {
        if {[get_property value ${PARAM_VALUE.pf0_bar3_64bit}] == false} {
          lappend allowed "BAR_3"
        } else {
         lappend allowed "BAR_4:3"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf0_bar4_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar4_type}] eq "Memory"} {
        if {[get_property value ${PARAM_VALUE.pf0_bar4_64bit}] == false} {
          lappend allowed "BAR_4"
        } else {
          lappend allowed "BAR_5:4"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf0_bar5_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar5_type}] eq "Memory"} {
        lappend allowed "BAR_5"
      }
      if {$allowed eq {}} {
        set allowed "BAR_0"
      }
    } else { 
      if {[get_property value ${PARAM_VALUE.axilite_master_en}] == true} {
        if {[get_property value ${PARAM_VALUE.axil_master_64bit_en}] == true} {     #AXI-Lite 64 bit
            if {[get_property value ${PARAM_VALUE.xdma_pcie_64bit_en}] == true} {
                  lappend allowed "BAR_3:2"
            } else {
                  lappend allowed "BAR_2"
            }
        } else {                                                                    #AXI-Lite 32 bit
          if {[get_property value ${PARAM_VALUE.xdma_pcie_64bit_en}] == true} {
               lappend allowed "BAR_3:2"
            } else {
                  lappend allowed "BAR_1"
            } 
        }
      } else {
        if {[get_property value ${PARAM_VALUE.xdma_pcie_64bit_en}] == true} {
              lappend allowed "BAR_1:0"
        } else {
             lappend allowed "BAR_0"
        }
      }

      if {$allowed eq {}} {
        set allowed "BAR_0"
      }
    }
    set_property range [join $allowed ","] $cap_tabl_bir
}

proc update_PARAM_VALUE.axilite_master_en {PARAM_VALUE.axilite_master_en PARAM_VALUE.mult_pf_des PARAM_VALUE.usr_irq_exdes} {
  set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]
  set usr_irq_exdes_val [get_property value ${PARAM_VALUE.usr_irq_exdes}]
  if {$mult_pf_des_val} { 
    ##set_property enabled false ${PARAM_VALUE.axilite_master_en}
    ##set_property value true ${PARAM_VALUE.axilite_master_en} 
    set_property enabled true ${PARAM_VALUE.axilite_master_en}
    set_property value true ${PARAM_VALUE.axilite_master_en} 
  } elseif {$usr_irq_exdes_val} { 
    set_property enabled false ${PARAM_VALUE.axilite_master_en}
    set_property value true ${PARAM_VALUE.axilite_master_en} 
  } else { 
    set_property enabled true ${PARAM_VALUE.axilite_master_en}
    set_property value false ${PARAM_VALUE.axilite_master_en} 
  }
}
proc update_PARAM_VALUE.axil_master_64bit_en {PARAM_VALUE.axil_master_64bit_en PARAM_VALUE.axilite_master_en PARAM_VALUE.mult_pf_des} { 
  
  set axilite_master_en [get_property value ${PARAM_VALUE.axilite_master_en}]
  set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]
 
  if {$axilite_master_en == true} { 
    if {$mult_pf_des_val} { 
      ##set_property enabled false ${PARAM_VALUE.axil_master_64bit_en}
      ##set_property value false ${PARAM_VALUE.axil_master_64bit_en}
      set_property enabled true ${PARAM_VALUE.axil_master_64bit_en}
      set_property value true ${PARAM_VALUE.axil_master_64bit_en}
    } else { 
      set_property enabled true ${PARAM_VALUE.axil_master_64bit_en}
    }
  } else { 
    set_property enabled false ${PARAM_VALUE.axil_master_64bit_en}
    set_property value false ${PARAM_VALUE.axil_master_64bit_en}
  }

}

proc update_PARAM_VALUE.axil_master_prefetchable {PARAM_VALUE.axil_master_64bit_en PARAM_VALUE.axil_master_prefetchable} { 

  set axil_master_64bit_en [get_property value ${PARAM_VALUE.axil_master_64bit_en}]
  
  if {$axil_master_64bit_en == true } { 
    set_property enabled true ${PARAM_VALUE.axil_master_prefetchable}
  } else { 
    set_property enabled false ${PARAM_VALUE.axil_master_prefetchable}
    set_property value false ${PARAM_VALUE.axil_master_prefetchable} 
  }

}

proc update_PARAM_VALUE.xdma_pcie_64bit_en {PARAM_VALUE.xdma_pcie_64bit_en PARAM_VALUE.xdma_en PARAM_VALUE.mult_pf_des} { 
  
  set xdma_en [get_property value ${PARAM_VALUE.xdma_en}]
  set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]
 
  if {$xdma_en == true} {
    if {$mult_pf_des_val} { 
      ##set_property enabled false ${PARAM_VALUE.xdma_pcie_64bit_en}
      set_property enabled true ${PARAM_VALUE.xdma_pcie_64bit_en}
      set_property value true ${PARAM_VALUE.xdma_pcie_64bit_en}
    } else {
      set_property enabled true ${PARAM_VALUE.xdma_pcie_64bit_en}
    }
  } else { 
    set_property enabled false ${PARAM_VALUE.xdma_pcie_64bit_en}
    set_property value false ${PARAM_VALUE.xdma_pcie_64bit_en}
  }

}

proc update_PARAM_VALUE.xdma_pcie_prefetchable {PARAM_VALUE.xdma_pcie_prefetchable PARAM_VALUE.xdma_pcie_64bit_en PARAM_VALUE.mult_pf_des} { 

  set xdma_pcie_64bit_en [get_property value ${PARAM_VALUE.xdma_pcie_64bit_en}]
  set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]

  if {$xdma_pcie_64bit_en == true } { 
    set_property enabled true ${PARAM_VALUE.xdma_pcie_prefetchable}
    if {$mult_pf_des_val} { 
      ##set_property value true ${PARAM_VALUE.xdma_pcie_prefetchable}
      set_property value false ${PARAM_VALUE.xdma_pcie_prefetchable}
    }
  } else { 
    set_property enabled false ${PARAM_VALUE.xdma_pcie_prefetchable}
    set_property value false ${PARAM_VALUE.xdma_pcie_prefetchable}
  }

}

proc update_PARAM_VALUE.axi_bypass_64bit_en {PARAM_VALUE.axi_bypass_64bit_en PARAM_VALUE.axist_bypass_en PARAM_VALUE.mult_pf_des} { 
  
  set axist_bypass_en [get_property value ${PARAM_VALUE.axist_bypass_en}]
  set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]
 
  if {$axist_bypass_en == true} { 
    if {$mult_pf_des_val} { 
      ##set_property enabled false ${PARAM_VALUE.axi_bypass_64bit_en}
      ##set_property value true ${PARAM_VALUE.axi_bypass_64bit_en}
      set_property enabled true ${PARAM_VALUE.axi_bypass_64bit_en}
      set_property value true ${PARAM_VALUE.axi_bypass_64bit_en}
    } else { 
      set_property enabled true ${PARAM_VALUE.axi_bypass_64bit_en}
    }
  } else { 
    set_property enabled false ${PARAM_VALUE.axi_bypass_64bit_en}
    set_property value false ${PARAM_VALUE.axi_bypass_64bit_en}
  }
}

proc update_PARAM_VALUE.axi_bypass_prefetchable {PARAM_VALUE.axi_bypass_prefetchable PARAM_VALUE.axi_bypass_64bit_en PARAM_VALUE.mult_pf_des} { 

  set axi_bypass_64bit_en [get_property value ${PARAM_VALUE.axi_bypass_64bit_en}]
  set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]

  if {$axi_bypass_64bit_en == true} { 
    set_property enabled true ${PARAM_VALUE.axi_bypass_prefetchable}
    if {$mult_pf_des_val} { 
      ##set_property value true ${PARAM_VALUE.axi_bypass_prefetchable}
      set_property value false ${PARAM_VALUE.axi_bypass_prefetchable}
    }
  } else { 
    set_property enabled false ${PARAM_VALUE.axi_bypass_prefetchable}
    set_property value false ${PARAM_VALUE.axi_bypass_prefetchable}
  }
}

proc update_PARAM_VALUE.pf0_msix_cap_pba_bir {PARAM_VALUE.pf0_msix_cap_pba_bir PARAM_VALUE.pf0_msix_enabled PARAM_VALUE.axilite_master_en PARAM_VALUE.xdma_en PARAM_VALUE.axist_bypass_en PARAM_VALUE.axil_master_64bit_en PARAM_VALUE.xdma_pcie_64bit_en PARAM_VALUE.functional_mode PARAM_VALUE.pf0_bar0_enabled PARAM_VALUE.pf0_bar1_enabled PARAM_VALUE.pf0_bar2_enabled PARAM_VALUE.pf0_bar3_enabled PARAM_VALUE.pf0_bar4_enabled PARAM_VALUE.pf0_bar5_enabled PARAM_VALUE.pf0_bar0_type PARAM_VALUE.pf0_bar1_type PARAM_VALUE.pf0_bar2_type PARAM_VALUE.pf0_bar3_type PARAM_VALUE.pf0_bar4_type PARAM_VALUE.pf0_bar5_type PARAM_VALUE.pf0_bar0_64bit PARAM_VALUE.pf0_bar1_64bit PARAM_VALUE.pf0_bar2_64bit PARAM_VALUE.pf0_bar3_64bit PARAM_VALUE.pf0_bar4_64bit} {

    set cap_pba_bir ${PARAM_VALUE.pf0_msix_cap_pba_bir}
    set pf0_msix_enabled [get_property value ${PARAM_VALUE.pf0_msix_enabled}]
    set_property enabled $pf0_msix_enabled $cap_pba_bir
    
    set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
    set allowed {}

    if {$func_mode == "AXI_Bridge" || $func_mode == "DMA_and_Bridge"} { 
      if {[get_property value ${PARAM_VALUE.pf0_bar0_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar0_type}] eq "Memory"} {
	if {[get_property value ${PARAM_VALUE.pf0_bar0_64bit}] == false} {
	  lappend allowed "BAR_0"
	} else {
	  lappend allowed "BAR_1:0"
	}
      }
      if {[get_property value ${PARAM_VALUE.pf0_bar1_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar1_type}] eq "Memory"} {
        if {[get_property value ${PARAM_VALUE.pf0_bar1_64bit}] == false} {
          lappend allowed "BAR_1"
        } else {
          lappend allowed "BAR_2:1"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf0_bar2_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar2_type}] eq "Memory"} {
        if {[get_property value ${PARAM_VALUE.pf0_bar2_64bit}] == false} {
          lappend allowed "BAR_2"
        } else {
          lappend allowed "BAR_3:2"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf0_bar3_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar3_type}] eq "Memory"} {
        if {[get_property value ${PARAM_VALUE.pf0_bar3_64bit}] == false} {
          lappend allowed "BAR_3"
        } else {
          lappend allowed "BAR_4:3"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf0_bar4_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar4_type}] eq "Memory"} {
        if {[get_property value ${PARAM_VALUE.pf0_bar4_64bit}] == false} {
          lappend allowed "BAR_4"
        } else {
          lappend allowed "BAR_5:4"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf0_bar5_enabled}] == true && [get_property value ${PARAM_VALUE.pf0_bar5_type}] eq "Memory"} {
        lappend allowed "BAR_5"
      }
      if {$allowed eq {}} {
        set allowed "BAR_0"
      }
    } else {  
      if {[get_property value ${PARAM_VALUE.axilite_master_en}] == true} {
        if {[get_property value ${PARAM_VALUE.axil_master_64bit_en}] == true} {     #AXI-Lite 64 bit
          if {[get_property value ${PARAM_VALUE.xdma_pcie_64bit_en}] == true} {
            lappend allowed "BAR_3:2"
          } else {
            lappend allowed "BAR_2"
          }
        } else {                                                                    #AXI-Lite 32 bit
          if {[get_property value ${PARAM_VALUE.xdma_pcie_64bit_en}] == true} {
            lappend allowed "BAR_3:2"
          } else {
            lappend allowed "BAR_1"
          } 
        }
      } else {
        if {[get_property value ${PARAM_VALUE.xdma_pcie_64bit_en}] == true} {
          lappend allowed "BAR_1:0"
        } else {
          lappend allowed "BAR_0"
        }
      }
      if {$allowed eq {}} {
        set allowed "BAR_0"
      }
    }
    set_property range [join $allowed ","] $cap_pba_bir
}

proc update_PARAM_VALUE.pcie_blk_locn { PROJECT_PARAM.ARCHITECTURE  PROJECT_PARAM.DEVICE PROJECT_PARAM.SPEEDGRADE PROJECT_PARAM.PART  PARAM_VALUE.device_port_type PARAM_VALUE.mode_selection PARAM_VALUE.pcie_blk_locn PARAM_VALUE.PCIE_BOARD_INTERFACE PARAM_VALUE.en_gt_selection PARAM_VALUE.vu9p_board PARAM_VALUE.vcu118_board PARAM_VALUE.xlnx_ref_board } {
    set pcie_blk_locn ${PARAM_VALUE.pcie_blk_locn}
    set en_gt_selection [get_property value ${PARAM_VALUE.en_gt_selection}]

    set vu9p_board [get_property value ${PARAM_VALUE.vu9p_board}]
    set vcu118_board [get_property value ${PARAM_VALUE.vcu118_board}]

    set boardIfName [get_property value ${PARAM_VALUE.PCIE_BOARD_INTERFACE}]


    if { $boardIfName ne "Custom" } {
      set board_pcie_block [get_interface_property $boardIfName PARAM.BLOCK_LOCATION]
      if {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "ZCU117" && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
        set pcie_blk_locn_LIST {X1Y0}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "ZCU117" && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
        set pcie_blk_locn_LIST {X0Y3}
        set pcie_blk_locn_Defaultvalue X0Y3
      } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU117" && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
        set pcie_blk_locn_LIST {X1Y0}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU117" && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
        set pcie_blk_locn_LIST {X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y1
      } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "ZCU106" && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
        set pcie_blk_locn_LIST {X0Y0}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "ZCU106" && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
        set pcie_blk_locn_LIST {X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y1
      } elseif {([get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118" || [get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118_ES1") && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
        set pcie_blk_locn_LIST {X1Y2}
        set pcie_blk_locn_Defaultvalue X1Y2
      } elseif {([get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118" || [get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118_ES1") && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
        set pcie_blk_locn_LIST {X0Y3}
        set pcie_blk_locn_Defaultvalue X0Y3
      } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "KCU116" && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
        set pcie_blk_locn_LIST {X0Y0}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "KCU116" && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
        set pcie_blk_locn_LIST {X0Y0}
        set pcie_blk_locn_Defaultvalue X0Y0
      } else { 
        set pcie_blk_locn_LIST $board_pcie_block
        set pcie_blk_locn_Defaultvalue $board_pcie_block
        set_property value $board_pcie_block $pcie_blk_locn
      }
      set_property range_value "$pcie_blk_locn_Defaultvalue,[regsub -all " " $pcie_blk_locn_LIST ","]" $pcie_blk_locn
      set_property enabled FALSE $pcie_blk_locn
      return
    }

    set c_xfamily        [ getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set c_xpackage      [ getpackage_name ${PROJECT_PARAM.PART} ${PROJECT_PARAM.SPEEDGRADE} ${PROJECT_PARAM.DEVICE}]
    set c_xspeedgrade     ${PROJECT_PARAM.SPEEDGRADE}
    set part            ${PROJECT_PARAM.PART}
    set c_xdevice         ${PROJECT_PARAM.DEVICE}
    set device [string toupper $c_xdevice]
    set pkg [string toupper $c_xpackage]
    set fmly [string toupper $c_xfamily]

    set pcie_blk_locn_Defaultvalue X0Y0
    set pcie_blk_locn_LIST {X0Y0}
    set str1 [string toupper [get_property value  ${PARAM_VALUE.device_port_type}] ]

    if {($fmly eq "VIRTEXUPLUS") || ($fmly eq "KINTEXUPLUS") || ($fmly eq "ZYNQUPLUS") || ($fmly eq "ZYNQUPLUSRFSOC") || ($fmly eq "VIRTEXUPLUSHBM")} {
      if {$pkg == "FFVC1760" && $device == "XCZU11EG"} {
        set_property enabled true $pcie_blk_locn
	set pcie_blk_locn_LIST {X0Y2 X0Y3 X1Y0 X1Y1}
	set pcie_blk_locn_Defaultvalue X0Y2
      } elseif {$pkg == "FFVC1760" && $device == "XCZU17EG"} {
        set_property enabled true $pcie_blk_locn
	set pcie_blk_locn_LIST {X0Y2 X0Y3 X1Y0 X1Y1 X1Y2}
	set pcie_blk_locn_Defaultvalue X0Y2
      } elseif {$pkg == "FFVC1760" && $device == "XCZU19EG"} {
         if {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "ZCU117" && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
           set pcie_blk_locn_LIST {X1Y0}
           set pcie_blk_locn_Defaultvalue X1Y0
         } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "ZCU117" && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
           set pcie_blk_locn_LIST {X0Y3}
           set pcie_blk_locn_Defaultvalue X0Y3
         } else { 
           set_property enabled true $pcie_blk_locn
	         set pcie_blk_locn_LIST {X0Y2 X0Y3 X1Y0 X1Y1 X1Y2}
	         set pcie_blk_locn_Defaultvalue X0Y2
         }
      } elseif {$pkg == "FFVE1924" && $device == "XCZU17EG"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1 X1Y2}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {$pkg == "FFVE1924" && $device == "XCZU19EG"} {
        set pcie_blk_locn_LIST {X1Y0 X1Y1 X1Y2}
        set pcie_blk_locn_Defaultvalue X1Y0
        set_property enabled true $pcie_blk_locn
      } elseif {$pkg == "FFVB1517" && $device == "XCZU19EG"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1 X1Y2}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {$pkg == "FBVB900" && $device == "XCZU4EV"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0 X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "FBVB900" && ($device == "XCZU4CG" || $device == "XCZU4EG" || $device == "XCZU5CG" || $device == "XCZU5EG")} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0 X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "FBVB900" && $device == "XCZU5EV"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0 X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "FBVB900" && $device == "XCZU7EV"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0 X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "FBVB900" && ($device == "XCZU7CG" || $device == "XCZU7EG")} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0 X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "SFVC784" && ($device == "XAZU4EV" || $device == "XAZU5EV" || $device == "XCZU4EV" || $device == "XCZU5EV")} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0 X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "SFVC784" && ($device == "XCZU4CG" || $device == "XCZU4EG" || $device == "XCZU5CG" || $device == "XCZU5EG")} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0 X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "FFVC1156" && $device == "XCZU7EV"} {
        if {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "ZCU106" && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
          set pcie_blk_locn_LIST {X0Y0}
          set pcie_blk_locn_Defaultvalue X0Y0
        } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "ZCU106" && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
          set pcie_blk_locn_LIST {X0Y1}
          set pcie_blk_locn_Defaultvalue X0Y1
        } else {
          set_property enabled true $pcie_blk_locn
          set pcie_blk_locn_LIST {X0Y0 X0Y1}
          set pcie_blk_locn_Defaultvalue X0Y0
        }
      } elseif {$pkg == "FFVC1156" && ($device == "XCZU7CG" || $device == "XCZU7EG")} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0 X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "FFVC1156" && $device == "XCZU11EG"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {$pkg == "FFVF1517" && $device == "XCZU7EV"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0 X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "FFVF1517" && ($device == "XCZU7CG" || $device == "XCZU7EG")} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0 X0Y1}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "FFVF1517" && $device == "XCZU11EG"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {$pkg == "FFVB1517" && $device == "XCZU11EG"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {$pkg == "FFVB1517" && $device == "XCZU17EG"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1 X1Y2}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {$pkg == "FFVD1760" && $device == "XCZU17EG"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1 X1Y2 X0Y2 X0Y3}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {$pkg == "FFVD1760" && $device == "XCZU19EG"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1 X1Y2 X0Y2 X0Y3}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {($pkg == "FFVD1156" && $device == "XCZU21DR") || ($pkg == "FFVE1156" && ($device == "XCZU28DR" || $device == "XCZU27DR")) || ($pkg == "FFVG1517" && ($device == "XCZU28DR" || $device == "XCZU27DR")) || ($pkg == "FFVF1760" && $device == "XCZU29DR")} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y1 X0Y0}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {($pkg == "FFVE1156" || $pkg == "FFVG1517") && $device == "XCZU25DR"} { 
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "FFVE1517" && $device == "XCKU11P"} {
        set pcie_blk_locn_LIST {X0Y2 X0Y3 X1Y0 X1Y1}
        set pcie_blk_locn_Defaultvalue X0Y2
        set_property enabled true $pcie_blk_locn
      } elseif {$pkg == "FFVE1517" && $device == "XCKU15P"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y2 X0Y3 X1Y0 X1Y1 X1Y2}
        set pcie_blk_locn_Defaultvalue X0Y2
      } elseif {($pkg == "FFVA676" && ($device == "XCKU3P" || $device == "XCKU5P")) || ($pkg == "FFVB676" && ($device == "XCKU3P" || $device == "XCKU5P")) } {
        if {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "KCU116" && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
          set pcie_blk_locn_LIST {X0Y0}
          set pcie_blk_locn_Defaultvalue X0Y0
        } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "KCU116" && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
          set pcie_blk_locn_LIST {X0Y0}
          set pcie_blk_locn_Defaultvalue X0Y0
        } else {
          set_property enabled true $pcie_blk_locn
          set pcie_blk_locn_LIST {X0Y0}
          set pcie_blk_locn_Defaultvalue X0Y0
        }
      } elseif {($pkg == "FFVD900" && ($device == "XCKU3P" || $device == "XCKU5P")) || ($pkg == "SFVB784" && ($device == "XCKU3P" || $device == "XCKU5P")) } {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X0Y0}
        set pcie_blk_locn_Defaultvalue X0Y0
      } elseif {$pkg == "FFVD900" && $device == "XCKU11P"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {$pkg == "FFVA1156" && $device == "XCKU11P"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1 X0Y2 X0Y3}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {$pkg == "FFVA1156" && $device == "XCKU15P"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1 X1Y2 X0Y2 X0Y3}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {($pkg == "FFVA1760" && $device == "XCKU15P") || ($pkg == "FFVE1760" && $device == "XCKU15P")} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_LIST {X1Y0 X1Y1 X1Y2 X0Y2 X0Y3}
        set pcie_blk_locn_Defaultvalue X1Y0
      } elseif {$pkg == "FFVC1517" && $device == "XCVU3P"} {
          if {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU117" && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
            set pcie_blk_locn_LIST {X1Y0}
            set pcie_blk_locn_Defaultvalue X1Y0
          } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU117" && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
            set pcie_blk_locn_LIST {X0Y1}
            set pcie_blk_locn_Defaultvalue X0Y1
          } else {
            set pcie_blk_locn_LIST {X0Y1 X1Y0}
            set pcie_blk_locn_Defaultvalue X1Y0
            set_property enabled true $pcie_blk_locn
          }
      } elseif {$pkg == "FLVA2104" && $device == "XCVU5P"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_Defaultvalue X0Y1
        set pcie_blk_locn_LIST {X0Y1 X0Y3 X1Y0 X1Y2}
      } elseif {$pkg == "FLVA2104" && $device == "XCVU7P"} {
        set_property enabled true $pcie_blk_locn
        set pcie_blk_locn_Defaultvalue X0Y1
        set pcie_blk_locn_LIST {X0Y1 X0Y3 X1Y0 X1Y2}
      } elseif {$pkg == "FLGA2104" && $device == "XCVU9P"} {
        if {([get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118" || [get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118_ES1") && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
          set pcie_blk_locn_LIST {X1Y2}
          set pcie_blk_locn_Defaultvalue X1Y2
        } elseif {([get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118" || [get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118_ES1") && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
          set pcie_blk_locn_LIST {X0Y3}
          set pcie_blk_locn_Defaultvalue X0Y3
        } elseif {$vcu118_board == "true"} {
          set pcie_blk_locn_LIST {X0Y1 X0Y3 X1Y2 X1Y4}
          set pcie_blk_locn_Defaultvalue X1Y2
          set_property enabled false $pcie_blk_locn
        } else { 
          set_property enabled true $pcie_blk_locn
          set pcie_blk_locn_LIST {X0Y1 X0Y3 X1Y2 X1Y4}
          set pcie_blk_locn_Defaultvalue X0Y1
        }
      } elseif {$pkg == "FLVB2104" && $device == "XCVU5P"} {
        set pcie_blk_locn_LIST {X0Y1 X0Y3 X1Y2 X1Y0}
        set pcie_blk_locn_Defaultvalue X0Y1
        set_property enabled true $pcie_blk_locn
      } elseif {$pkg == "FLVB2104" && $device == "XCVU7P"} {
        set pcie_blk_locn_LIST {X0Y1 X0Y3 X1Y2 X1Y0}
        set pcie_blk_locn_Defaultvalue X0Y1
        set_property enabled true $pcie_blk_locn
      } elseif {$pkg == "FLGB2104" && $device == "XCVU9P"} {
        if {$vu9p_board == "true"} { 
          set pcie_blk_locn_LIST {X0Y1 X0Y3 X1Y2 X1Y4}
          set pcie_blk_locn_Defaultvalue X1Y2
          set_property enabled false $pcie_blk_locn
        } else { 
          set_property enabled true $pcie_blk_locn
          set pcie_blk_locn_LIST {X0Y1 X0Y3 X1Y2 X1Y4}
          set pcie_blk_locn_Defaultvalue X0Y1
        }
      } elseif {$pkg == "FLVC2104" && $device == "XCVU5P"} {
        set pcie_blk_locn_LIST {X0Y1 X0Y3 X1Y2 X1Y0}
        set pcie_blk_locn_Defaultvalue X0Y1
        set_property enabled true $pcie_blk_locn
      } elseif {$pkg == "FLVC2104" && $device == "XCVU7P"} {
        set pcie_blk_locn_LIST {X0Y1 X0Y3 X1Y2 X1Y0}
        set pcie_blk_locn_Defaultvalue X0Y1
        set_property enabled true $pcie_blk_locn
      } elseif {$pkg == "FLGC2104" && $device == "XCVU9P"} {
        set pcie_blk_locn_LIST {X0Y1 X0Y3 X0Y5 X1Y2 X1Y0 X1Y4}
        set pcie_blk_locn_Defaultvalue X0Y1
        set_property enabled true $pcie_blk_locn
      } elseif {$pkg == "FLGA2577" && $device == "XCVU9P"} {
        set pcie_blk_locn_LIST {X0Y1 X0Y3 X0Y5 X1Y2 X1Y0 X1Y4}
        set pcie_blk_locn_Defaultvalue X0Y1
        set_property enabled true $pcie_blk_locn
      } elseif {$pkg == "FSGD2104" && $device == "XCVU9P"} {
        set pcie_blk_locn_LIST {X0Y1 X0Y3 X0Y5 X1Y2 X1Y4}
        set pcie_blk_locn_Defaultvalue X0Y1
      } elseif {$device == "XCVU11P" && ($pkg == "FLGA2577" || $pkg == "FLGB2104" || $pkg == "FLGC2104" || $pkg == "FLGF1924" || $pkg == "FSGD2104")} {
        set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
        set pcie_blk_locn_Defaultvalue X0Y0
        set_property enabled true $pcie_blk_locn
      } elseif {$device == "XCVU13P"} {
        set_property enabled true $pcie_blk_locn
        if {$pkg == "FHGA2104"} {
          set pcie_blk_locn_LIST {X0Y1 X0Y2}
          set pcie_blk_locn_Defaultvalue X0Y1
        } elseif {$pkg == "FHGB2104" || $pkg == "FIGD2104"} {
          set pcie_blk_locn_LIST {X0Y1 X0Y2 X0Y3}
          set pcie_blk_locn_Defaultvalue X0Y1
        } else { 
          set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3}
          set pcie_blk_locn_Defaultvalue X0Y1
        }
      } elseif {$device == "XCVU37P"} { 
        if {$pkg == "FSVH2892"} { 
          set pcie_blk_locn_Defaultvalue PCIE4C_X0Y0
          set pcie_blk_locn_LIST {PCIE4C_X0Y0 PCIE4C_X0Y1 PCIE4C_X1Y0 PCIE4C_X1Y1 PCIE4_X0Y0 PCIE4_X0Y1}
        }
      } elseif {$device == "XCVU31P"} { 
        if {$pkg == "FSVH1924"} { 
          set pcie_blk_locn_Defaultvalue PCIE4C_X0Y0
          set pcie_blk_locn_LIST {PCIE4C_X0Y0 PCIE4C_X0Y1 PCIE4C_X1Y0 PCIE4C_X1Y1}
        }
      } elseif {$device == "XCVU35P"} { 
        if {$pkg == "FSVH2104" || $pkg == "FSVH2892"} { 
          set pcie_blk_locn_Defaultvalue PCIE4C_X0Y0
          set pcie_blk_locn_LIST {PCIE4C_X0Y0 PCIE4C_X0Y1 PCIE4C_X1Y0 PCIE4C_X1Y1 PCIE4_X0Y0}
        }
      } elseif {$device == "XCVU33P"} { 
        if {$pkg == "FSVH2104"} { 
          set pcie_blk_locn_Defaultvalue PCIE4C_X0Y0
          set pcie_blk_locn_LIST {PCIE4C_X0Y0 PCIE4C_X0Y1 PCIE4C_X1Y0 PCIE4C_X1Y1}
        }
      }
    } elseif {($fmly eq "VIRTEXU") || ($fmly eq "KINTEXU")} {
        if {$device == "XCKU025"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            set pcie_blk_locn_LIST {X0Y0}
        } elseif {$device == "XCKU035"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            if {$en_gt_selection == "true"}  {
                if {$pkg == "SFVA784"} {
                    set pcie_blk_locn_LIST {X0Y0}
                } else {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
                }
            } else {
                if {$pkg == "SFVA784"} {
                    set pcie_blk_locn_LIST {X0Y0}
                } else {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1}
                }
            }
        } elseif {$device == "XCKU040" || $device == "XQKU040"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            if {$pkg == "FFVA1156" || $pkg == "RFA1156"} {
                set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
            } elseif {$pkg == "SFVA784"} {
                set pcie_blk_locn_LIST {X0Y0}
            } else  {
                if {$en_gt_selection == "true"}  {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
                } else {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1}
                }
            }
        } elseif {$device == "XCKU060" || $device == "XQKU060"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
        } elseif {$device == "XCKU095" || $device == "XQKU095"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            if {$pkg == "FFVC1517"} {
                if {$en_gt_selection == "true"} {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3}
                } else {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
                }
            } elseif {$pkg == "FFVA1156" || $pkg == "RFA1156"} {
                set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
            } else {
                set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3}
            }
        } elseif {$device == "XCKU085"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3 X0Y4}
        } elseif {$device == "XCKU115" || $device == "XQKU115"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            if {$pkg == "FLVB1760" || $pkg == "FLVF1924" || $pkg == "FLVD1517" || $pkg == "FLVB2104" || $pkg == "RLF1924" || $pkg == "RLD1517"} {
                set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3 X0Y4 X0Y5}
            } elseif {$pkg == "FLVD1924" || $pkg == "FLVA2104"} {
                if {$en_gt_selection == "true"}  {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3 X0Y4 X0Y5}
                } else {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y3 X0Y4 X0Y5}
                }
            } else {
                if {$en_gt_selection == "true"}  {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3 X0Y4 X0Y5}
                } else {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3 X0Y4}
                }
            }
        } elseif {$device == "XCVU065"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            set pcie_blk_locn_LIST {X0Y0 X0Y1}
        } elseif {$device == "XCVU080"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            if {$pkg == "FFVC1517"} {
                if {$en_gt_selection == "true"} {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3}
                } else {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
                }
            } else {
                set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3}
            }
        } elseif {$device == "XCVU095"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            if {$pkg == "FFVC1517"} {
                if {$en_gt_selection == "true"} {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3}
                } else {
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
                }
            } else {
                set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3}
            }
        } elseif {$device == "XCVU125"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3}
        } elseif {$device == "XCVU160" || $device == "XCVU190"} {
            if { $device == "XCVU160"} {
                set_property enabled true $pcie_blk_locn
                if {$pkg == "FLGB2104"} {
                    set pcie_blk_locn_Defaultvalue X0Y1
                    set pcie_blk_locn_LIST {X0Y1 X0Y2 X0Y3 X0Y4}
                } else {
                    set pcie_blk_locn_Defaultvalue X0Y0
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3 X0Y4}
                }
            } elseif {$device == "XCVU190"} {
                set_property enabled true $pcie_blk_locn
                if {$pkg == "FLGB2104"} {
                    set pcie_blk_locn_Defaultvalue X0Y2
                    set pcie_blk_locn_LIST {X0Y2 X0Y3 X0Y4 X0Y5}
                } else {
                    set pcie_blk_locn_Defaultvalue X0Y0
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3 X0Y4 X0Y5}
                }
            }
        } elseif {$device == "XCVU440"} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3 X0Y4 X0Y5}
        } else {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            set pcie_blk_locn_LIST {X0Y0}
        }
    } else {
        if {(($device == "XC7VX330T") && (($pkg == "FFG1157") || ($pkg == "FFG1761") || ($pkg == "FFV1157") || ($pkg == "FFV1761"))) || (($device == "XQ7VX330T") && (($pkg == "RF1157") || ($pkg == "RF1761")))} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            set pcie_blk_locn_LIST {X0Y0 X0Y1}
        } elseif {($device == "XC7VX415T") && (($pkg == "FFG1157") || ($pkg == "FFG1158") || ($pkg == "FFG1927") || ($pkg == "FFV1157") || ($pkg == "FFV1158") || ($pkg == "FFV1927"))} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            set pcie_blk_locn_LIST {X0Y0 X0Y1}
        } elseif {($device == "XC7VX550T") && (($pkg == "FFG1927") || ($pkg == "FFG1158"))} {
            set_property enabled true $pcie_blk_locn
            if {($pkg == "FFG1158")} {
                set pcie_blk_locn_Defaultvalue X0Y1
                set pcie_blk_locn_LIST {X0Y1 X0Y2}
            } else {
                set pcie_blk_locn_Defaultvalue X0Y0
                set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
            }
        } elseif {($device == "XC7VX690T") || ($device == "XQ7VX690T")} {
            switch $pkg {
                "FFG1157" {
                    set_property enabled true $pcie_blk_locn
                    set pcie_blk_locn_Defaultvalue X0Y1
                    set pcie_blk_locn_LIST {X0Y1 X0Y2}
                }
                "RF1157" {
                    set_property enabled true $pcie_blk_locn
                    set pcie_blk_locn_Defaultvalue X0Y1
                    set pcie_blk_locn_LIST {X0Y1 X0Y2}
                }
                "FFG1158" {
                    set_property enabled true $pcie_blk_locn
                    set pcie_blk_locn_Defaultvalue X0Y1
                    set pcie_blk_locn_LIST {X0Y1 X0Y2}
                }
                "FFG1761" {
                    set_property enabled true $pcie_blk_locn
                    set pcie_blk_locn_Defaultvalue X0Y0
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
                }
                "RF1761" {
                    set_property enabled true $pcie_blk_locn
                    set pcie_blk_locn_Defaultvalue X0Y0
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
                }
                "RF1158" {
                    set_property enabled true $pcie_blk_locn
                    set pcie_blk_locn_Defaultvalue X0Y1
                    set pcie_blk_locn_LIST {X0Y1 X0Y2}
                }
                "FFG1926" {
                    set_property enabled true $pcie_blk_locn
                    set pcie_blk_locn_Defaultvalue X0Y0
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
                }
                "FFG1927" {
                    set_property enabled true $pcie_blk_locn
                    set pcie_blk_locn_Defaultvalue X0Y0
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
                }
                "FFG1930" {
                    set_property enabled true $pcie_blk_locn
                    set pcie_blk_locn_Defaultvalue X0Y1
                    set pcie_blk_locn_LIST {X0Y1 X0Y2}
                }
                "RF1930" {
                    set_property enabled true $pcie_blk_locn
                    set pcie_blk_locn_Defaultvalue X0Y1
                    set pcie_blk_locn_LIST {X0Y1 X0Y2}
                }
            }
        } elseif {(($device == "XC7VX980T") && (($pkg == "FFG1926") || ($pkg == "FFG1928") || ($pkg == "FFG1930"))) || (($device == "XQ7VX980T") && ($pkg == "RF1930"))} {
            set_property enabled true $pcie_blk_locn
            if {($pkg == "FFG1930") || ($pkg == "RF1930")} {
                set pcie_blk_locn_Defaultvalue X0Y1
                set pcie_blk_locn_LIST {X0Y1 X0Y2}
            } else {
                set pcie_blk_locn_Defaultvalue X0Y0
                set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
            }
        } elseif {($device == "XC7VX1140T") && (($pkg == "FLG1926") || ($pkg == "FLG1928") || ($pkg == "FLG1930"))} {
            set_property enabled true $pcie_blk_locn
            if {($pkg == "FLG1928")} {
                set pcie_blk_locn_Defaultvalue X0Y0
                set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2 X0Y3}
            } elseif { ($pkg == "FLG1930")} {
                set pcie_blk_locn_Defaultvalue X0Y1
                set pcie_blk_locn_LIST {X0Y1 X0Y2}
            } else {
                set pcie_blk_locn_Defaultvalue X0Y0
                set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
            }
        } elseif {($device == "XC7VH290T") && (($pkg == "HCG1155"))} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_Defaultvalue X0Y0
            set pcie_blk_locn_LIST {X0Y0}
        } elseif {($device == "XC7VH580T") && (($pkg == "HCG1155") || ($pkg == "HCG1931") || ($pkg == "FLG1155") || ($pkg == "FLG1931")  || ($pkg == "HCG1932"))} {
            set_property enabled true $pcie_blk_locn
            if {($pkg == "HCG1155") || ($pkg == "FLG1155")} {
                set pcie_blk_locn_Defaultvalue X0Y0
                set pcie_blk_locn_LIST {X0Y0}
            } else {
                set pcie_blk_locn_Defaultvalue X0Y0
                set pcie_blk_locn_LIST {X0Y0 X0Y1}
            }
        } elseif {($device == "XC7VH870T") && (($pkg == "HCG1931") || ($pkg == "HCG1932") || ($pkg == "FLG1932")) } {
            set_property enabled true $pcie_blk_locn
                if {($pkg == "HCG1931")} {
                    set pcie_blk_locn_Defaultvalue X0Y1
                    set pcie_blk_locn_LIST {X0Y1 X0Y2}
                } else {
                    set pcie_blk_locn_Defaultvalue X0Y0
                    set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
                }
        } elseif {($fmly eq "KINTEX7") || ($fmly eq"ARTIX7") || ($fmly eq "ZYNQ")} {
            set_property enabled true $pcie_blk_locn
            set pcie_blk_locn_LIST {X0Y0}
            set pcie_blk_locn_Defaultvalue X0Y0
        } elseif {($device == "XC7VX485T") || ($device == "XQ7VX485T")} {
		if {($pkg == "FFG1157") || ($pkg == "FFG1761") || ($pkg == "FFG1930") || ($pkg == "RF1761") || ($pkg == "RF1930")} {
            			set_property enabled true $pcie_blk_locn
            			set pcie_blk_locn_LIST {X1Y0 X1Y1}
            			set pcie_blk_locn_Defaultvalue X1Y0
		} elseif {($pkg == "FFG1158") || ($pkg == "FFG1927")} {
            			set_property enabled true $pcie_blk_locn
            			set pcie_blk_locn_LIST {X1Y0 X0Y1 X1Y0 X1Y1}
            			set pcie_blk_locn_Defaultvalue X0Y0
		}
	} elseif {($device == "XC7V585T") || ($device == "XQ7V585T")} {
		if {($pkg == "FFG1157") || ($pkg == "RF1157")} {
            			set_property enabled true $pcie_blk_locn
            			set pcie_blk_locn_LIST {X0Y1 X0Y2}
            			set pcie_blk_locn_Defaultvalue X0Y1
		} elseif {($pkg == "FFG1761") || ($pkg == "RF1761")} {
            			set_property enabled true $pcie_blk_locn
            			set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
            			set pcie_blk_locn_Defaultvalue X0Y0
		}
	} elseif {($device == "XC7V2000T")} {
		if {($pkg == "FHG1761")} {
            			set_property enabled true $pcie_blk_locn
            			set pcie_blk_locn_LIST {X0Y0 X0Y1 X0Y2}
            			set pcie_blk_locn_Defaultvalue X0Y0
		} elseif {($pkg == "FLG1925")} {
            			set_property enabled true $pcie_blk_locn
            			set pcie_blk_locn_LIST {X0Y0 X0Y1}
            			set pcie_blk_locn_Defaultvalue X0Y0
        	}
	}
    }
    set_property range_value "$pcie_blk_locn_Defaultvalue,[regsub -all " " $pcie_blk_locn_LIST ","]" $pcie_blk_locn
}
 ;#end updateOf_pcie_blk_locn

proc update_PARAM_VALUE.en_gt_selection { PARAM_VALUE.en_gt_selection PARAM_VALUE.xlnx_ref_board} {
  set en_gt_selection ${PARAM_VALUE.en_gt_selection}
  set ref_board [get_property value ${PARAM_VALUE.xlnx_ref_board}]
 
  if {$ref_board == "VCU1262"} { 
    set_property enabled false $en_gt_selection
  } else { 
    set_property enabled true $en_gt_selection
  }
}

proc update_PARAM_VALUE.xlnx_ref_board {PARAM_VALUE.xlnx_ref_board PARAM_VALUE.vcu118_board PROJECT_PARAM.BOARD } {

  set c_vcu118_board [get_property value ${PARAM_VALUE.vcu118_board}]
  set c_xlnx_ref_board [get_property range_value ${PARAM_VALUE.xlnx_ref_board}]
  set is_board [::ipxit::get_project_property BOARD]
  #set c_board  		[string range $is_board 11 [expr [string first ":" $is_board] + 6]]
  set c_board [lindex [split $is_board : ] 1 ]
  set ref_board [string toupper $c_board]

  set default_ref_board None
  set ref_board_list {None}

  if {${PROJECT_PARAM.BOARD} ne "" } {
    #set_property value $ref_board ${PARAM_VALUE.xlnx_ref_board}
    set default_ref_board $ref_board
    set ref_board_list $ref_board
  } elseif {$c_vcu118_board} {
    #set_property value "VCU118" ${PARAM_VALUE.xlnx_ref_board}
    set default_ref_board VCU118
    set ref_board_list {VCU118}
  } else {
    #set_property value $c_xlnx_ref_board ${PARAM_VALUE.xlnx_ref_board}
    set default_ref_board $c_xlnx_ref_board
    set ref_board_list $c_xlnx_ref_board
  }

  set_property range_value "$default_ref_board,[regsub -all  " " $ref_board_list ","]" ${PARAM_VALUE.xlnx_ref_board}
}

proc update_PARAM_VALUE.vu9p_board {PARAM_VALUE.vu9p_board PROJECT_PARAM.BOARD  PARAM_VALUE.vu9p_tul_ex } {

  set c_vu9p_board [get_property value ${PARAM_VALUE.vu9p_board}]
  set c_vu9p_tul_ex [get_property value ${PARAM_VALUE.vu9p_tul_ex}]
  set is_board [::ipxit::get_project_property BOARD]
  set c_board [lindex [split $is_board : ] 1 ]
  set ref_board [string toupper $c_board]

    if { $c_vu9p_board == "true" || $c_vu9p_tul_ex == "true" } {
       set_property value "true" ${PARAM_VALUE.vu9p_board}
    } else {
       set_property value "false" ${PARAM_VALUE.vu9p_board}
    }
}


proc update_PARAM_VALUE.vu9p_tul_ex {PARAM_VALUE.vu9p_tul_ex } {

  set c_vu9p_tul_ex [get_property value ${PARAM_VALUE.vu9p_tul_ex}]

    if {$c_vu9p_tul_ex} {
       set_property value "true" ${PARAM_VALUE.vu9p_tul_ex}
    } else {
       set_property value "false" ${PARAM_VALUE.vu9p_tul_ex}
    }
}

##proc update_PARAM_VALUE.vcu118_board {PARAM_VALUE.vcu118_board } {
##
##  set c_vcu118_board [get_property value ${PARAM_VALUE.vcu118_board}]
##
##    if {$c_vcu118_board} {
##       set_property value "TRUE" ${PARAM_VALUE.vcu118_board}
##    } else {
##       set_property value "FALSE" ${PARAM_VALUE.vcu118_board}
##    }
##}

proc update_PARAM_VALUE.select_quad {PARAM_VALUE.select_quad PARAM_VALUE.xlnx_ref_board PARAM_VALUE.device_port_type PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE PROJECT_PARAM.PART PROJECT_PARAM.SPEEDGRADE PARAM_VALUE.pcie_blk_locn PARAM_VALUE.en_gt_selection} {
  set c_xdevice      ${PROJECT_PARAM.DEVICE}
  set c_xpackage      [ getpackage_name ${PROJECT_PARAM.PART} ${PROJECT_PARAM.SPEEDGRADE} ${PROJECT_PARAM.DEVICE}]
  set device [string toupper $c_xdevice]
  set pkg [string toupper $c_xpackage]
  set c_xfamily        [ getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
  set en_gt_selection [get_property value ${PARAM_VALUE.en_gt_selection}]
  set pcie_blk_locn [get_property value ${PARAM_VALUE.pcie_blk_locn}]
  set select_quad ${PARAM_VALUE.select_quad}
  set fmly [string toupper $c_xfamily]
  set select_quad_Defaultvalue "GTH_Quad_128"
  set select_quad_LIST {GTH_Quad_128}

   if {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "ZCU106" && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
        set select_quad_Defaultvalue "GTH_Quad_226"
        set select_quad_LIST {GTH_Quad_227 GTH_Quad_226}
   } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "ZCU106" && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
        set select_quad_Defaultvalue "GTH_Quad_224"
        set select_quad_LIST {GTH_Quad_224}
   } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "KCU116" && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
        set select_quad_Defaultvalue "GTY_Quad_227"
        set select_quad_LIST {GTY_Quad_227}
   } elseif {[get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "KCU116" && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
        set select_quad_Defaultvalue "GTY_Quad_225"
        set select_quad_LIST {GTY_Quad_225}
  } elseif {([get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118" || [get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118_ES1") && [get_property value ${PARAM_VALUE.device_port_type}] ne "Root_Port_of_PCI_Express_Root_Complex"} {
        set select_quad_Defaultvalue "GTY_Quad_227"
        set select_quad_LIST {GTY_Quad_227}
  } elseif {([get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118" || [get_property value ${PARAM_VALUE.xlnx_ref_board}] eq "VCU118_ES1") && [get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
        set select_quad_Defaultvalue "GTY_Quad_127"
        set select_quad_LIST {GTY_Quad_127}
  } elseif {($fmly eq "VIRTEXUPLUS") || ($fmly eq "KINTEXUPLUS") || ($fmly eq "ZYNQUPLUS") || ($fmly eq "ZYNQUPLUSRFSOC") || ($fmly eq "VIRTEXUPLUSHBM")} {
    if {$device == "XCVU3P"} { 
      if {$pcie_blk_locn == "X0Y1"} {
        set select_quad_Defaultvalue "GTY_Quad_128"
	set select_quad_LIST {GTY_Quad_128 GTY_Quad_127 GTY_Quad_126 GTY_Quad_125}
      } elseif {$pcie_blk_locn == "X1Y0"} { 
        set select_quad_Defaultvalue "GTY_Quad_227"
	set select_quad_LIST {GTY_Quad_228 GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
      }
    } elseif {$device == "XCVU5P" || $device == "XCVU7P"} {
      if {$pkg == "FLVA2104"} { 
        if {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_127"
	  set select_quad_LIST {GTY_Quad_127 GTY_Quad_126 GTY_Quad_125}
        } elseif {$pcie_blk_locn == "X0Y3"} { 
          set select_quad_Defaultvalue "GTY_Quad_132"
	  set select_quad_LIST {GTY_Quad_132 GTY_Quad_131 GTY_Quad_130}
        } elseif {$pcie_blk_locn == "X1Y0"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_233"
	  set select_quad_LIST {GTY_Quad_233 GTY_Quad_232 GTY_Quad_231}
        }
      } elseif {$pkg == "FLVB2104"} {
        if {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_128"
	  set select_quad_LIST {GTY_Quad_128 GTY_Quad_127 GTY_Quad_126 GTY_Quad_125}
        } elseif {$pcie_blk_locn == "X0Y3"} { 
          set select_quad_Defaultvalue "GTY_Quad_133"
	  set select_quad_LIST {GTY_Quad_133 GTY_Quad_132 GTY_Quad_131 GTY_Quad_130}
        } elseif {$pcie_blk_locn == "X1Y0"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_228 GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_232"
	  set select_quad_LIST {GTY_Quad_233 GTY_Quad_232 GTY_Quad_231 GTY_Quad_230 GTY_Quad_229}
        }
      } elseif {$pkg == "FLVC2104"} {
        if {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_128"
	  set select_quad_LIST {GTY_Quad_128 GTY_Quad_127 GTY_Quad_126 GTY_Quad_125}
        } elseif {$pcie_blk_locn == "X0Y3"} { 
          set select_quad_Defaultvalue "GTY_Quad_133"
	  set select_quad_LIST {GTY_Quad_133 GTY_Quad_132 GTY_Quad_131 GTY_Quad_130}
        } elseif {$pcie_blk_locn == "X1Y0"} { 
          set select_quad_Defaultvalue "GTY_Quad_228"
	  set select_quad_LIST {GTY_Quad_228 GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_232"
	  set select_quad_LIST {GTY_Quad_233 GTY_Quad_232 GTY_Quad_231 GTY_Quad_230 GTY_Quad_229}
        }
      }
    } elseif {$device == "XCVU9P"} {
      if {$pkg == "FLGA2104"} { 
        if {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_122"
	  set select_quad_LIST {GTY_Quad_122 GTY_Quad_121 GTY_Quad_120}
        } elseif {$pcie_blk_locn == "X0Y3"} { 
          set select_quad_Defaultvalue "GTY_Quad_127"
	  set select_quad_LIST {GTY_Quad_127 GTY_Quad_126 GTY_Quad_125}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_227,GTY_Quad_226,GTY_Quad_225,GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y4"} { 
          set select_quad_Defaultvalue "GTY_Quad_233"
	  set select_quad_LIST {GTY_Quad_233 GTY_Quad_232 GTY_Quad_231}
        }
      } elseif {$pkg == "FLGB2104"} {
        if {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_123"
	  set select_quad_LIST {GTY_Quad_123 GTY_Quad_122 GTY_Quad_121 GTY_Quad_120}
        } elseif {$pcie_blk_locn == "X0Y3"} { 
          set select_quad_Defaultvalue "GTY_Quad_128"
	  set select_quad_LIST {GTY_Quad_128 GTY_Quad_127 GTY_Quad_126 GTY_Quad_125}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_228 GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y4"} { 
          set select_quad_Defaultvalue "GTY_Quad_233"
	  set select_quad_LIST {GTY_Quad_233 GTY_Quad_232 GTY_Quad_231 GTY_Quad_230 GTY_Quad_229}
        }
      } elseif {$pkg == "FLGC2104"} {
        if {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_122"
	  set select_quad_LIST {GTY_Quad_122 GTY_Quad_121 GTY_Quad_120}
        } elseif {$pcie_blk_locn == "X0Y3"} { 
          set select_quad_Defaultvalue "GTY_Quad_128"
	  set select_quad_LIST {GTY_Quad_128 GTY_Quad_127 GTY_Quad_126 GTY_Quad_125}
        } elseif {$pcie_blk_locn == "X0Y5"} { 
          set select_quad_Defaultvalue "GTY_Quad_133"
	  set select_quad_LIST {GTY_Quad_133 GTY_Quad_132 GTY_Quad_131 GTY_Quad_130}
        } elseif {$pcie_blk_locn == "X1Y0"} { 
          set select_quad_Defaultvalue "GTY_Quad_222"
	  set select_quad_LIST {GTY_Quad_222 GTY_Quad_221 GTY_Quad_220}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_228 GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y4"} { 
          set select_quad_Defaultvalue "GTY_Quad_232"
	  set select_quad_LIST {GTY_Quad_233 GTY_Quad_232 GTY_Quad_231 GTY_Quad_230 GTY_Quad_229}
        }
      } elseif {$pkg == "FLGA2577"} {
        if {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_123"
	  set select_quad_LIST {GTY_Quad_123 GTY_Quad_122 GTY_Quad_121 GTY_Quad_120}
        } elseif {$pcie_blk_locn == "X0Y3"} { 
          set select_quad_Defaultvalue "GTY_Quad_128"
	  set select_quad_LIST {GTY_Quad_128 GTY_Quad_127 GTY_Quad_126 GTY_Quad_125}
        } elseif {$pcie_blk_locn == "X0Y5"} { 
          set select_quad_Defaultvalue "GTY_Quad_133"
	  set select_quad_LIST {GTY_Quad_133 GTY_Quad_132 GTY_Quad_131 GTY_Quad_130}
        } elseif {$pcie_blk_locn == "X1Y0"} { 
          set select_quad_Defaultvalue "GTY_Quad_222"
	  set select_quad_LIST {GTY_Quad_223 GTY_Quad_222 GTY_Quad_221 GTY_Quad_220 GTY_Quad_219}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_228 GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y4"} { 
          set select_quad_Defaultvalue "GTY_Quad_232"
	  set select_quad_LIST {GTY_Quad_233 GTY_Quad_232 GTY_Quad_231 GTY_Quad_230 GTY_Quad_229}
        }
      } elseif {$pkg == "FSGD2104" } { 
        if {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_123"
          set select_quad_LIST {GTY_Quad_123 GTY_Quad_122 GTY_Quad_121 GTY_Quad_120}
        } elseif {$pcie_blk_locn == "X0Y3"} { 
          set select_quad_Defaultvalue "GTY_Quad_127"
          set select_quad_LIST {GTY_Quad_127 GTY_Quad_126 GTY_Quad_125 GTY_Quad_124}
        } elseif {$pcie_blk_locn == "X0Y5"} { 
          set select_quad_Defaultvalue "GTY_Quad_131"
          set select_quad_LIST {GTY_Quad_131}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
          set select_quad_LIST {GTY_Quad_228 GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y4"} { 
          set select_quad_Defaultvalue "GTY_Quad_232"
          set select_quad_LIST {GTY_Quad_233 GTY_Quad_232 GTY_Quad_231 GTY_Quad_230 GTY_Quad_229}
        }
      }
    } elseif {$device == "XCVU11P"} { 
      if {$pkg == "FLGA2577" || $pkg == "FLGC2104"} { 
        if {$pcie_blk_locn == "X0Y0"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_231"
	  set select_quad_LIST {GTY_Quad_231 GTY_Quad_230 GTY_Quad_229 GTY_Quad_228}
        } elseif {$pcie_blk_locn == "X0Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_235"
	  set select_quad_LIST {GTY_Quad_235 GTY_Quad_234 GTY_Quad_233 GTY_Quad_232}
        }
      } elseif {$pkg == "FLGB2104" || $pkg == "FLGF1924" ||  $pkg == "FSGD2104"} { 
        if {$pcie_blk_locn == "X0Y0"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_231"
	  set select_quad_LIST {GTY_Quad_231 GTY_Quad_230 GTY_Quad_229 GTY_Quad_228}
        } elseif {$pcie_blk_locn == "X0Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_233"
	  set select_quad_LIST {GTY_Quad_233 GTY_Quad_232}
        }
      }
    } elseif {$device == "XCVU13P"} {
      if {$pkg == "FHGA2104"} { 
        if {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_231"
	  set select_quad_LIST {GTY_Quad_231 GTY_Quad_230 GTY_Quad_229}
        }
      } elseif {$pkg == "FHGB2104" || $pkg == "FIGD2104"} { 
        if {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTY_Quad_231"
	  set select_quad_LIST {GTY_Quad_231 GTY_Quad_230 GTY_Quad_229 GTY_Quad_228}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTY_Quad_233"
	  set select_quad_LIST {GTY_Quad_233 GTY_Quad_232}
        }
      } elseif {$pkg == "FHGC2104"} { 
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTY_Quad_223"
	  set select_quad_LIST {GTY_Quad_223 GTY_Quad_222 GTY_Quad_221}
        } elseif {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTY_Quad_231"
	  set select_quad_LIST {GTY_Quad_231 GTY_Quad_230 GTY_Quad_229 GTY_Quad_228}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTY_Quad_233"
	  set select_quad_LIST {GTY_Quad_233 GTY_Quad_232}
        }
      } elseif {$pkg == "FLGA2577"} { 
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTY_Quad_223"
	  set select_quad_LIST {GTY_Quad_223 GTY_Quad_222 GTY_Quad_221 GTY_Quad_220}
        } elseif {$pcie_blk_locn == "X0Y1"} { 
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTY_Quad_231"
	  set select_quad_LIST {GTY_Quad_231 GTY_Quad_230 GTY_Quad_229 GTY_Quad_228}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTY_Quad_235"
	  set select_quad_LIST {GTY_Quad_235 GTY_Quad_234 GTY_Quad_233 GTY_Quad_232}
        }
      }
    } elseif {$device == "XCZU11EG" || $device == "XCZU17EG" || $device == "XCZU19EG"} {
      if {$pkg == "FFVC1760"} { 
        if {$pcie_blk_locn == "X0Y3"} { 
          set select_quad_Defaultvalue "GTY_Quad_131"
	  set select_quad_LIST {GTY_Quad_131 GTY_Quad_130 GTY_Quad_129 GTY_Quad_128}
        } elseif  {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTY_Quad_130"
	  set select_quad_LIST {GTY_Quad_130 GTY_Quad_129 GTY_Quad_128}
        } elseif  {$pcie_blk_locn == "X1Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
        } elseif  {$pcie_blk_locn == "X1Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_229"
	  set select_quad_LIST {GTH_Quad_230 GTH_Quad_229 GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTH_Quad_230"
	  set select_quad_LIST {GTH_Quad_231 GTH_Quad_230 GTH_Quad_229 GTH_Quad_228 GTH_Quad_227}
        }
      } elseif {$pkg == "FFVB1517"} { 
        if {$pcie_blk_locn == "X1Y0"} { 
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y1"} { 
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227}
        }
      } elseif {$pkg == "FFVC1156"} { 
        if {$pcie_blk_locn == "X1Y0"} { 
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
        } elseif  {$pcie_blk_locn == "X1Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
	  set select_quad_LIST {GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        }
      } elseif {$pkg == "FFVF1517"} { 
        if {$pcie_blk_locn == "X1Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
        } elseif  {$pcie_blk_locn == "X1Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_229"
	  set select_quad_LIST {GTH_Quad_229 GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        }
      } elseif {$pkg == "FFVE1924"} { 
        if {$pcie_blk_locn == "X1Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
        } elseif  {$pcie_blk_locn == "X1Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_229"
	  set select_quad_LIST {GTH_Quad_229 GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif  {$pcie_blk_locn == "X1Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_230"
	  set select_quad_LIST {GTH_Quad_230 GTH_Quad_229 GTH_Quad_228 GTH_Quad_227}
        }
      } elseif {$pkg == "FFVD1760"} { 
        if {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTY_Quad_132"
	  set select_quad_LIST {GTY_Quad_132 GTY_Quad_131 GTY_Quad_130 GTY_Quad_129}
        } elseif  {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTY_Quad_130"
	  set select_quad_LIST {GTY_Quad_130 GTY_Quad_129 GTY_Quad_128}
        } elseif  {$pcie_blk_locn == "X1Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
        } elseif  {$pcie_blk_locn == "X1Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_229"
	  set select_quad_LIST {GTH_Quad_229 GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif  {$pcie_blk_locn == "X1Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_230"
	  set select_quad_LIST {GTH_Quad_230 GTH_Quad_229 GTH_Quad_228 GTH_Quad_227}
        }
     }
    } elseif {$device == "XCKU11P" || $device == "XCKU15P"} { 
      if {$pkg == "FFVE1517"} { 
        if {$pcie_blk_locn == "X0Y3" && $device == "XCKU11P"} {
          set select_quad_Defaultvalue "GTY_Quad_131"
	  set select_quad_LIST {GTY_Quad_131 GTY_Quad_130 GTY_Quad_129 GTY_Quad_128}
        } elseif {$pcie_blk_locn == "X0Y3" && $device == "XCKU15P"} { 
          set select_quad_Defaultvalue "GTY_Quad_132"
	  set select_quad_LIST {GTY_Quad_132 GTY_Quad_131 GTY_Quad_130 GTY_Quad_129}
        } elseif {$pcie_blk_locn == "X0Y2"} { 
          set select_quad_Defaultvalue "GTY_Quad_130"
	  set select_quad_LIST {GTY_Quad_130 GTY_Quad_129 GTY_Quad_128 GTY_Quad_127}
        } elseif {$pcie_blk_locn == "X1Y0"} { 
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y1"} { 
          set select_quad_Defaultvalue "GTH_Quad_229"
	  set select_quad_LIST {GTH_Quad_229 GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X1Y2" && $device == "XCKU11P"} { 
          set select_quad_Defaultvalue "GTH_Quad_230"
	  set select_quad_LIST {GTH_Quad_230 GTH_Quad_229 GTH_Quad_228 GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X1Y2" && $device == "XCKU15P"} { 
          set select_quad_Defaultvalue "GTH_Quad_231"
	  set select_quad_LIST {GTH_Quad_231 GTH_Quad_230 GTH_Quad_229 GTH_Quad_228}
        }
      } elseif {$pkg == "FFVA1156"} {
        if {$pcie_blk_locn == "X0Y3" || $pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTY_Quad_130"
	  set select_quad_LIST {GTY_Quad_130 GTY_Quad_129}
        } elseif {$pcie_blk_locn == "X1Y0"} { 
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y1"} { 
          set select_quad_Defaultvalue "GTH_Quad_228"
	  set select_quad_LIST {GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTH_Quad_228"
	  set select_quad_LIST {GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        }
      } elseif {$pkg == "FFVD900"} {
        if {$pcie_blk_locn == "X1Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226}
        }
      } elseif {$pkg == "FFVA1760" || $pkg == "FFVE1760" } {
        if {$pcie_blk_locn == "X0Y3"} { 
          set select_quad_Defaultvalue "GTY_Quad_132"
	  set select_quad_LIST {GTY_Quad_132 GTY_Quad_131 GTY_Quad_130 GTY_Quad_129}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTY_Quad_130"
	  set select_quad_LIST {GTY_Quad_130 GTY_Quad_129 GTY_Quad_128 GTY_Quad_127}
        } elseif {$pcie_blk_locn == "X1Y0"} { 
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X1Y1"} { 
          set select_quad_Defaultvalue "GTH_Quad_229"
	  set select_quad_LIST {GTH_Quad_229 GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X1Y2"} { 
          set select_quad_Defaultvalue "GTH_Quad_231"
	  set select_quad_LIST {GTH_Quad_231 GTH_Quad_230 GTH_Quad_229 GTH_Quad_228}
        }
      }
    } elseif {($device == "XCZU4EV" || $device == "XCZU5EV" || $device == "XCZU7EV") && $pkg == "FBVB900"} { 
      if {$pcie_blk_locn == "X0Y0" || $pcie_blk_locn == "X0Y1"} {
        if {$device == "XCZU7EV"} { 
          set select_quad_Defaultvalue "GTH_Quad_227"
	  set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
        } else {
          set select_quad_Defaultvalue "GTH_Quad_226"
	  set select_quad_LIST {GTH_Quad_226 GTH_Quad_225 GTH_Quad_224 GTH_Quad_223}
        }
      }  
    } elseif {($device == "XAZU4EV" || $device == "XAZU5EV" || $device == "XCZU4EV" || $device == "XCZU5EV") && $pkg == "SFVC784" } { 
      if {$pcie_blk_locn == "X0Y0" || $pcie_blk_locn == "X0Y1" } {
        set select_quad_Defaultvalue "GTH_Quad_224"
	set select_quad_LIST {GTH_Quad_224}
      }
    } elseif {$device == "XCZU7EV" && $pkg == "FFVC1156"} { 
      if {$pcie_blk_locn == "X0Y0"} {
        set select_quad_Defaultvalue "GTH_Quad_226"
	set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224 GTH_Quad_223}
      } elseif  {$pcie_blk_locn == "X0Y1"} { 
        set select_quad_Defaultvalue "GTH_Quad_226"
	set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224 GTH_Quad_223}
      }
    } elseif {$device == "XCZU7EV" && $pkg == "FFVF1517"} {
      if {$pcie_blk_locn == "X0Y0"} {
        set select_quad_Defaultvalue "GTH_Quad_226"
	set select_quad_LIST {GTH_Quad_226 GTH_Quad_225 GTH_Quad_224 GTH_Quad_223}
      } elseif  {$pcie_blk_locn == "X0Y1"} { 
        set select_quad_Defaultvalue "GTH_Quad_226"
	set select_quad_LIST {GTH_Quad_226 GTH_Quad_225 GTH_Quad_224 GTH_Quad_223}
      }
   } elseif {($device == "XCZU4CG" || $device == "XCZU4EG" || $device == "XCZU5CG" || $device == "XCZU5EG") && $pkg == "FBVB900"} { 
      if {$pcie_blk_locn == "X0Y0" || $pcie_blk_locn == "X0Y1"} {
        set select_quad_Defaultvalue "GTH_Quad_226"
        set select_quad_LIST {GTH_Quad_226 GTH_Quad_225 GTH_Quad_224 GTH_Quad_223}
      }  
    } elseif {($device == "XCZU4CG" || $device == "XCZU4EG" || $device == "XCZU5CG" || $device == "XCZU5EG") && $pkg == "SFVC784" } { 
      if {$pcie_blk_locn == "X0Y0" || $pcie_blk_locn == "X0Y1" } {
        set select_quad_Defaultvalue "GTH_Quad_224"
        set select_quad_LIST {GTH_Quad_224}
      }
    } elseif {($device == "XCZU7CG" || $device == "XCZU7EG") && $pkg == "FBVB900"} { 
      if {$pcie_blk_locn == "X0Y0" || $pcie_blk_locn == "X0Y1"} {
        set select_quad_Defaultvalue "GTH_Quad_227"
        set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224}
      }
    } elseif {($device == "XCZU7CG" || $device == "XCZU7EG") && $pkg == "FFVC1156"} { 
      if {$pcie_blk_locn == "X0Y0"} {
        set select_quad_Defaultvalue "GTH_Quad_226"
        set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224 GTH_Quad_223}
      } elseif  {$pcie_blk_locn == "X0Y1"} { 
        set select_quad_Defaultvalue "GTH_Quad_226"
        set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224 GTH_Quad_223}
      }
    } elseif {($device == "XCZU7CG" || $device == "XCZU7EG") && $pkg == "FFVF1517"} {
      if {$pcie_blk_locn == "X0Y0"} {
        set select_quad_Defaultvalue "GTH_Quad_226"
        set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224 GTH_Quad_223}
      } elseif  {$pcie_blk_locn == "X0Y1"} { 
        set select_quad_Defaultvalue "GTH_Quad_226"
        set select_quad_LIST {GTH_Quad_227 GTH_Quad_226 GTH_Quad_225 GTH_Quad_224 GTH_Quad_223}
      }
    } elseif {$device == "XCKU3P" || $device == "XCKU5P"} { 
      if {$pkg == "FFVA676" || $pkg == "FFVB676" || $pkg == "FFVD900" || $pkg == "SFVB784"} { 
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTY_Quad_227"
	  set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        }
      } 
    } elseif {($device == "XCZU21DR" && $pkg == "FFVD1156") || (($device == "XCZU28DR" || $device == "XCZU27DR") && $pkg == "FFVG1517") || ($device == "XCZU29DR" && $pkg == "FFVF1760")} { 
      if {$pcie_blk_locn == "X0Y1" || $pcie_blk_locn == "X0Y0"} {
        set select_quad_Defaultvalue "GTY_Quad_131"
        set select_quad_LIST {GTY_Quad_131 GTY_Quad_130 GTY_Quad_129 GTY_Quad_128}
      }
    } elseif {(($device == "XCZU28DR" || $device == "XCZU27DR") && $pkg == "FFVE1156") || ($device == "XCZU25DR" && ($pkg == "FFVE1156" || $pkg == "FFVG1517"))} { 
      if {$pcie_blk_locn == "X0Y1" || $pcie_blk_locn == "X0Y0"} {
        set select_quad_Defaultvalue "GTY_Quad_129"
        set select_quad_LIST {GTY_Quad_129 GTY_Quad_128}
      }
    } elseif {$device == "XCVU37P" && $pkg == "FSVH2892"  } { 
      if {$pcie_blk_locn == "PCIE4C_X0Y0" || $pcie_blk_locn == "PCIE4C_X0Y1" } { 
        set select_quad_Defaultvalue "GTY_Quad_127"
        set select_quad_LIST {GTY_Quad_127 GTY_Quad_126 GTY_Quad_125 GTY_Quad_124}
      } elseif {$pcie_blk_locn == "PCIE4C_X1Y0" || $pcie_blk_locn == "PCIE4C_X1Y1"} { 
        set select_quad_Defaultvalue "GTY_Quad_227"
        set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
      } elseif {$pcie_blk_locn == "PCIE4_X0Y0"} { 
        set select_quad_Defaultvalue "GTY_Quad_231"
        set select_quad_LIST {GTY_Quad_231 GTY_Quad_230 GTY_Quad_229 GTY_Quad_228}
      } elseif {$pcie_blk_locn == "PCIE4_X0Y1"} { 
        set select_quad_Defaultvalue "GTY_Quad_235"
        set select_quad_LIST {GTY_Quad_235 GTY_Quad_234 GTY_Quad_233 GTY_Quad_232}
      }
    } elseif {$device == "XCVU31P" && $pkg == "FSVH1924"  } { 
      if {$pcie_blk_locn == "PCIE4C_X0Y0" || $pcie_blk_locn == "PCIE4C_X0Y1" } { 
        set select_quad_Defaultvalue "GTY_Quad_127"
        set select_quad_LIST {GTY_Quad_127 GTY_Quad_126 GTY_Quad_125 GTY_Quad_124}
      } elseif {$pcie_blk_locn == "PCIE4C_X1Y0" || $pcie_blk_locn == "PCIE4C_X1Y1"} { 
        set select_quad_Defaultvalue "GTY_Quad_227"
        set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
      }
    } elseif {$device == "XCVU35P"} { 
      if {$pkg == "FSVH2104" || $pkg == "FSVH2892"} {
        if {$pcie_blk_locn == "PCIE4C_X0Y0" || $pcie_blk_locn == "PCIE4C_X0Y1" } { 
          set select_quad_Defaultvalue "GTY_Quad_127"
          set select_quad_LIST {GTY_Quad_127 GTY_Quad_126 GTY_Quad_125 GTY_Quad_124}
        } elseif {$pcie_blk_locn == "PCIE4C_X1Y0" || $pcie_blk_locn == "PCIE4C_X1Y1"} {
          set select_quad_Defaultvalue "GTY_Quad_227"
          set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } elseif {$pcie_blk_locn == "PCIE4_X0Y0"} { 
          set select_quad_Defaultvalue "GTY_Quad_231"
          set select_quad_LIST {GTY_Quad_231 GTY_Quad_230 GTY_Quad_229 GTY_Quad_228}
        } 
      } else { 
      }
    } elseif {$device == "XCVU33P"} { 
      if {$pkg == "FSVH2104"} {
        if {$pcie_blk_locn == "PCIE4C_X0Y0" || $pcie_blk_locn == "PCIE4C_X0Y1" } { 
          set select_quad_Defaultvalue "GTY_Quad_127"
          set select_quad_LIST {GTY_Quad_127 GTY_Quad_126 GTY_Quad_125 GTY_Quad_124}
        } elseif {$pcie_blk_locn == "PCIE4C_X1Y0" || $pcie_blk_locn == "PCIE4C_X1Y1"} {
          set select_quad_Defaultvalue "GTY_Quad_227"
          set select_quad_LIST {GTY_Quad_227 GTY_Quad_226 GTY_Quad_225 GTY_Quad_224}
        } 
      } else { 
      }
    }
  } else {
    if {$device == "XCKU025"} {
      if {$pcie_blk_locn == "X0Y0"} {
        set select_quad_Defaultvalue "GTH_Quad_225"
        set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
      }
    } elseif {$device == "XCKU035"} {
      if {$pcie_blk_locn == "X0Y0"} {
        set select_quad_Defaultvalue "GTH_Quad_225"
        set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
      } elseif {$pcie_blk_locn == "X0Y1"} {
        set select_quad_Defaultvalue "GTH_Quad_227"
        set select_quad_LIST {GTH_Quad_227 GTH_Quad_226}
      } elseif {$pcie_blk_locn == "X0Y2"} {
        set select_quad_Defaultvalue "GTH_Quad_227"
        set select_quad_LIST {GTH_Quad_227}
      }
    } elseif {$device == "XCKU040" || $device == "XQKU040"} {
      if {$pkg == "FBVA676" || $pkg == "FBVA900" || $pkg == "SFVA784" || $pkg == "RBA676"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_227}
        }
      } elseif {$pkg == "FFVA1156" || $pkg == "RFA1156" } {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
        }
      }
    } elseif {$device == "XCKU060" || $device == "XQKU060"} {
      if {$pcie_blk_locn == "X0Y0"} {
        set select_quad_Defaultvalue "GTH_Quad_225"
        set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
      } elseif {$pcie_blk_locn == "X0Y1"} {
        set select_quad_Defaultvalue "GTH_Quad_227"
        set select_quad_LIST {GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
      } elseif {$pcie_blk_locn == "X0Y2"} {
        set select_quad_Defaultvalue "GTH_Quad_228"
        set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
      }
    } elseif {$device == "XCKU095" || $device == "XQKU095"} {
      if {$pkg == "FFVB1760"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_229 GTH_Quad_228 GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_229"
          set select_quad_LIST {GTH_Quad_230 GTH_Quad_229 GTH_Quad_228}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTH_Quad_231"
          set select_quad_LIST {GTH_Quad_231 GTH_Quad_230}
        }
      } elseif {$pkg == "FFVB2104"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_229 GTH_Quad_228 GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_229"
          set select_quad_LIST {GTH_Quad_230 GTH_Quad_229 GTH_Quad_228}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTH_Quad_231"
          set select_quad_LIST {GTH_Quad_231 GTH_Quad_230}
        }
      } elseif {$pkg == "FFVC1517"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X0Y2" || $pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_228}
        }
      } elseif {$pkg == "FFVA1156" || $pkg == "RFA1156"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_228}
        }
      }
    } elseif {$device == "XCKU085"} {
      if {$pkg == "FLVA1517"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTH_Quad_230"
          set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
        } elseif {$pcie_blk_locn == "X0Y4"} {
          set select_quad_Defaultvalue "GTH_Quad_232"
          set select_quad_LIST {GTH_Quad_232 GTH_Quad_231}
        }
      } elseif {$pkg == "FLVB1760"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTH_Quad_230"
          set select_quad_LIST {GTH_Quad_230}
        } elseif {$pcie_blk_locn == "X0Y4"} {
          set select_quad_Defaultvalue "GTH_Quad_232"
          set select_quad_LIST {GTH_Quad_232 GTH_Quad_231}
        }
      } elseif {$pkg == "FLVF1924"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTH_Quad_230"
          set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
        } elseif {$pcie_blk_locn == "X0Y4"} {
          set select_quad_Defaultvalue "GTH_Quad_232"
          set select_quad_LIST {GTH_Quad_232 GTH_Quad_231}
        }
      }
    } elseif {$device == "XCKU115" || $device == "XQKU115"  } {
      if {$pkg == "FLVA1517"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTH_Quad_230"
          set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
        } elseif {$pcie_blk_locn == "X0Y4"} {
          set select_quad_Defaultvalue "GTH_Quad_232"
          set select_quad_LIST {GTH_Quad_232 GTH_Quad_231}
        } elseif {$pcie_blk_locn == "X0Y5"} {
          set select_quad_Defaultvalue "GTH_Quad_232"
          set select_quad_LIST {GTH_Quad_232}
        }
      } elseif {$pkg == "FLVB1760"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTH_Quad_230"
          set select_quad_LIST {GTH_Quad_230}
        } elseif {$pcie_blk_locn == "X0Y4"} {
          set select_quad_Defaultvalue "GTH_Quad_232"
          set select_quad_LIST {GTH_Quad_233 GTH_Quad_232 GTH_Quad_231}
        } elseif {$pcie_blk_locn == "X0Y5"} {
          set select_quad_Defaultvalue "GTH_Quad_233"
          set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
        }
      } elseif {$pkg == "FLVD1924"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTH_Quad_231"
          set select_quad_LIST {GTH_Quad_231}
        } elseif {$pcie_blk_locn == "X0Y4"} {
          set select_quad_Defaultvalue "GTH_Quad_232"
          set select_quad_LIST {GTH_Quad_233 GTH_Quad_232 GTH_Quad_231}
        } elseif {$pcie_blk_locn == "X0Y5"} {
          set select_quad_Defaultvalue "GTH_Quad_233"
          set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
        }
      } elseif {$pkg == "FLVF1924" || $pkg == "FLVD1517" || $pkg == "FLVB2104" || $pkg == "RLF1924" || $pkg == "RLD1517"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_228"
          set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTH_Quad_230"
          set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
        } elseif {$pcie_blk_locn == "X0Y4"} {
          set select_quad_Defaultvalue "GTH_Quad_232"
          set select_quad_LIST {GTH_Quad_233 GTH_Quad_232 GTH_Quad_231}
        } elseif {$pcie_blk_locn == "X0Y5"} {
          set select_quad_Defaultvalue "GTH_Quad_233"
          set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
        }
      } elseif {$pkg == "FLVA2104"} {
        if {$pcie_blk_locn == "X0Y0"} {
          set select_quad_Defaultvalue "GTH_Quad_225"
          set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
        } elseif {$pcie_blk_locn == "X0Y1"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_227 GTH_Quad_226}
        } elseif {$pcie_blk_locn == "X0Y2"} {
          set select_quad_Defaultvalue "GTH_Quad_227"
          set select_quad_LIST {GTH_Quad_227}
        } elseif {$pcie_blk_locn == "X0Y3"} {
          set select_quad_Defaultvalue "GTH_Quad_231"
          set select_quad_LIST {GTH_Quad_231}
        } elseif {$pcie_blk_locn == "X0Y4"} {
          set select_quad_Defaultvalue "GTH_Quad_232"
          set select_quad_LIST {GTH_Quad_233 GTH_Quad_232 GTH_Quad_231}
        } elseif {$pcie_blk_locn == "X0Y5"} {
          set select_quad_Defaultvalue "GTH_Quad_233"
          set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
        }
      }
    } elseif {$device == "XCVU065"} {
      if {$pcie_blk_locn == "X0Y0"} {
        set select_quad_Defaultvalue "GTH_Quad_225"
        set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
      } elseif {$pcie_blk_locn == "X0Y1"} {
        set select_quad_Defaultvalue "GTH_Quad_228"
        set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
      }
     } elseif {$device == "XCVU080" || $device == "XCVU095"} {
       if {$pkg == "FFVA1760" || $pkg == "FFVB1517" || $pkg == "FFVE1924" || $pkg == "FFVJ1924" || $pkg == "FFVB2104" || $pkg == "FFVB1760" || $pkg == "FFVC2104" || $pkg == "FFVD1517"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_229 GTH_Quad_228 GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_229"
           set select_quad_LIST {GTH_Quad_230 GTH_Quad_229 GTH_Quad_228}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_231"
           set select_quad_LIST {GTH_Quad_231 GTH_Quad_230}
         }
       } elseif {$pkg == "FFVC1517"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y2" || $pcie_blk_locn == "X0Y3" } {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_228}
         }
       } elseif {$pkg == "FFVD1924"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_229 GTH_Quad_228 GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_229"
           set select_quad_LIST {GTH_Quad_230 GTH_Quad_229 GTH_Quad_228}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_230"
           set select_quad_LIST {GTH_Quad_230}
         }
       } elseif {$pkg == "FFVA2104"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_229 GTH_Quad_228 GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_229"
           set select_quad_LIST {GTH_Quad_230 GTH_Quad_229 GTH_Quad_228}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_230"
           set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
         }
       }
     } elseif {$device == "XCVU125"} {
       if {$pkg == "FLVB1760"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_230"
           set select_quad_LIST {GTH_Quad_230}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_233"
           set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
         }
       } elseif {$pkg == "FLVA2104"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_227"
           set select_quad_LIST {GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_231"
           set select_quad_LIST {GTH_Quad_231}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_233"
           set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
         }
       } elseif {$pkg == "FLVB2104" || $pkg == "FLVC2104" || $pkg == "FLVD1517"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_230"
           set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_233"
           set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
         }
       }
     } elseif {$device == "XCVU160" || $device == "XCVU190"} {
       if {$pkg == "FLGA2577"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_220"
           set select_quad_LIST {GTH_Quad_220 GTH_Quad_219}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_223"
           set select_quad_LIST {GTH_Quad_223 GTH_Quad_222}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y4"} {
           set select_quad_Defaultvalue "GTH_Quad_230"
           set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
         } elseif {$pcie_blk_locn == "X0Y5"} {
           set select_quad_Defaultvalue "GTH_Quad_233"
           set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
         }
       } elseif {$pkg == "FLGB2104"  && $device == "XCVU160"} {
         if {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_230"
           set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
         } elseif {$pcie_blk_locn == "X0Y4"} {
           set select_quad_Defaultvalue "GTH_Quad_233"
           set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
         }
       } elseif {$pkg == "FLGB2104" && $device == "XCVU190"} {
         if {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y4"} {
           set select_quad_Defaultvalue "GTH_Quad_230"
           set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
         } elseif {$pcie_blk_locn == "X0Y5"} {
           set select_quad_Defaultvalue "GTH_Quad_233"
           set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
         }
       } elseif {$pkg == "FLGC2104" && $device == "XCVU160"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_222"
           set select_quad_LIST {GTH_Quad_222}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_230"
           set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
         } elseif {$pcie_blk_locn == "X0Y4"} {
           set select_quad_Defaultvalue "GTH_Quad_233"
           set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
         }
       } elseif {$pkg == "FLGC2104" && $device == "XCVU190"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_220"
           set select_quad_LIST {GTH_Quad_220}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_222"
           set select_quad_LIST {GTH_Quad_222}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_228"
           set select_quad_LIST {GTH_Quad_228 GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y4"} {
           set select_quad_Defaultvalue "GTH_Quad_230"
           set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
         } elseif {$pcie_blk_locn == "X0Y5"} {
           set select_quad_Defaultvalue "GTH_Quad_233"
           set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
         }
       }
     } elseif {$device == "XCVU440"} {
       if {$pkg == "FLGA2892"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_220"
           set select_quad_LIST {GTH_Quad_220 GTH_Quad_219}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_222"
           set select_quad_LIST {GTH_Quad_222}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_227"
           set select_quad_LIST {GTH_Quad_227}
         } elseif {$pcie_blk_locn == "X0Y4"} {
           set select_quad_Defaultvalue "GTH_Quad_230"
           set select_quad_LIST {GTH_Quad_230 GTH_Quad_229}
         } elseif {$pcie_blk_locn == "X0Y5"} {
           set select_quad_Defaultvalue "GTH_Quad_232"
           set select_quad_LIST {GTH_Quad_232}
         }
       } elseif {$pkg == "FLGB2377"} {
         if {$pcie_blk_locn == "X0Y0"} {
           set select_quad_Defaultvalue "GTH_Quad_221"
           set select_quad_LIST {GTH_Quad_221}
         } elseif {$pcie_blk_locn == "X0Y1"} {
           set select_quad_Defaultvalue "GTH_Quad_223"
           set select_quad_LIST {GTH_Quad_223 GTH_Quad_222}
         } elseif {$pcie_blk_locn == "X0Y2"} {
           set select_quad_Defaultvalue "GTH_Quad_225"
           set select_quad_LIST {GTH_Quad_225 GTH_Quad_224}
         } elseif {$pcie_blk_locn == "X0Y3"} {
           set select_quad_Defaultvalue "GTH_Quad_226"
           set select_quad_LIST {GTH_Quad_226}
         } elseif {$pcie_blk_locn == "X0Y4"} {
           set select_quad_Defaultvalue "GTH_Quad_231"
           set select_quad_LIST {GTH_Quad_231}
         } elseif {$pcie_blk_locn == "X0Y5"} {
           set select_quad_Defaultvalue "GTH_Quad_233"
           set select_quad_LIST {GTH_Quad_233 GTH_Quad_232}
         }
       }
     }
   }

   set select_quad_LIST [join $select_quad_LIST]
   set select_quad_LIST [regsub -all " " $select_quad_LIST ","]
   set_property range_value "$select_quad_Defaultvalue,$select_quad_LIST" ${PARAM_VALUE.select_quad}

   if {$en_gt_selection == false} {
     set_property enabled false ${PARAM_VALUE.select_quad}
   } else {
     set_property enabled true ${PARAM_VALUE.select_quad}
   }
}


proc update_PARAM_VALUE.enable_ccix {PARAM_VALUE.enable_ccix PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED} {
      set en_ccix [get_property value ${PARAM_VALUE.enable_ccix}]

       if {[get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}] eq "X8" && [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] eq "8.0_GT/s"} {
            set_property value $en_ccix ${PARAM_VALUE.enable_ccix}
       } elseif {[get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}] eq "X16" && [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] eq "8.0_GT/s"} {
            set_property value $en_ccix ${PARAM_VALUE.enable_ccix}
       } elseif {[get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}] eq "X4" && [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] eq "16.0_GT/s"} {
            set_property value $en_ccix ${PARAM_VALUE.enable_ccix}
       } elseif {[get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}] eq "X8" && [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] eq "16.0_GT/s"} {
            set_property value $en_ccix ${PARAM_VALUE.enable_ccix}
       } else { 
            set_property value FALSE ${PARAM_VALUE.enable_ccix}
       }
}


##################
# Model param Update
##################
proc update_MODELPARAM_VALUE.PIPE_SIM {MODELPARAM_VALUE.PIPE_SIM PARAM_VALUE.pipe_sim PARAM_VALUE.Shared_Logic_Both} {
  set en_pipe_sim [get_property value ${PARAM_VALUE.pipe_sim}]
  set Shared_Logic_Both [get_property value ${PARAM_VALUE.Shared_Logic_Both} ]

  if {$en_pipe_sim eq "true" && $Shared_Logic_Both eq "false"} {
    set_property value TRUE ${MODELPARAM_VALUE.PIPE_SIM}
  } else {
    set_property value FALSE ${MODELPARAM_VALUE.PIPE_SIM}
  }
}

proc update_MODELPARAM_VALUE.EN_TRANSCEIVER_STATUS_PORTS {MODELPARAM_VALUE.EN_TRANSCEIVER_STATUS_PORTS PARAM_VALUE.en_transceiver_status_ports} {
 set en_debug_ports [get_property value ${PARAM_VALUE.en_transceiver_status_ports}]
   if {$en_debug_ports eq "true"} {
    set_property value TRUE ${MODELPARAM_VALUE.EN_TRANSCEIVER_STATUS_PORTS}
   } else {
    set_property value FALSE ${MODELPARAM_VALUE.EN_TRANSCEIVER_STATUS_PORTS}
   }
}

proc update_MODELPARAM_VALUE.CFG_MGMT_IF {MODELPARAM_VALUE.CFG_MGMT_IF PARAM_VALUE.cfg_mgmt_if} {
 set en_cfg_mgmt_if [get_property value ${PARAM_VALUE.cfg_mgmt_if}]
   if {$en_cfg_mgmt_if eq "true"} {
    set_property value TRUE ${MODELPARAM_VALUE.CFG_MGMT_IF}
   } else {
    set_property value FALSE ${MODELPARAM_VALUE.CFG_MGMT_IF}
   }
}

proc update_MODELPARAM_VALUE.RQ_SEQ_NUM_IGNORE {PROJECT_PARAM.ARCHITECTURE MODELPARAM_VALUE.RQ_SEQ_NUM_IGNORE PROJECT_PARAM.SILICON_REVISION PARAM_VALUE.coreclk_freq PARAM_VALUE.axisten_freq} { 
  set silicon_rev [string toupper ${PROJECT_PARAM.SILICON_REVISION}]
  set core_clk    [get_property value ${PARAM_VALUE.coreclk_freq}]
  set axi_freq    [get_property value ${PARAM_VALUE.axisten_freq}]
  set c_xfamily   [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]

  if {$c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} { 
    if {($silicon_rev != "ES1") && ($silicon_rev != "EVAL")} { 
        set val 0
    } else {
      ## As of now only EVAL, ES1, ES2 versions are supported, this loop will be executed for ES1 and EVAL devices.
      ## In future if any new revision comes, will need to add logic for that.
      if {($axi_freq == "250" && ($core_clk == "500" || $core_clk == "250"))} { 
	  set val 0
      } else { 
	  set val 1
      }
    }
  } else { 
      set val 0
  }

  set_property value $val ${MODELPARAM_VALUE.RQ_SEQ_NUM_IGNORE}
}

proc  update_MODELPARAM_VALUE.CFG_EXT_IF {MODELPARAM_VALUE.CFG_EXT_IF PARAM_VALUE.cfg_ext_if} { 
  set en_cfg_ext_if [get_property value ${PARAM_VALUE.cfg_ext_if}]

  if {$en_cfg_ext_if == "true"} { 
    set val "TRUE"
  } else { 
    set val "FALSE"
  }
  set_property value $val ${MODELPARAM_VALUE.CFG_EXT_IF}
}

proc  update_MODELPARAM_VALUE.LEGACY_CFG_EXT_IF {MODELPARAM_VALUE.LEGACY_CFG_EXT_IF PARAM_VALUE.legacy_cfg_ext_if} { 
  set en_legacy_cfg_ext_if [get_property value ${PARAM_VALUE.legacy_cfg_ext_if}]

  if {$en_legacy_cfg_ext_if == "true"} { 
    set val "TRUE"
  } else { 
    set val "FALSE"
  }
  set_property value $val ${MODELPARAM_VALUE.LEGACY_CFG_EXT_IF}
}

proc update_MODELPARAM_VALUE.EXT_XVC_VSEC_ENABLE {MODELPARAM_VALUE.EXT_XVC_VSEC_ENABLE PARAM_VALUE.ext_xvc_vsec_enable }  {
  set_property value [string toupper [get_property value ${PARAM_VALUE.ext_xvc_vsec_enable}]] ${MODELPARAM_VALUE.EXT_XVC_VSEC_ENABLE}
}

proc update_MODELPARAM_VALUE.ACS_EXT_CAP_ENABLE {MODELPARAM_VALUE.ACS_EXT_CAP_ENABLE PARAM_VALUE.acs_ext_cap_enable }  {
  set_property value [string toupper [get_property value ${PARAM_VALUE.acs_ext_cap_enable}]] ${MODELPARAM_VALUE.ACS_EXT_CAP_ENABLE}
}

proc  update_MODELPARAM_VALUE.EN_DEBUG_PORTS {MODELPARAM_VALUE.EN_DEBUG_PORTS PARAM_VALUE.en_debug_ports} { 

  set en_dbg_ports [get_property value ${PARAM_VALUE.en_debug_ports}]

  if {$en_dbg_ports == "true"} { 
    set val "TRUE"
  } else {
    set val "FALSE"
  }
  set_property value $val ${MODELPARAM_VALUE.EN_DEBUG_PORTS}

}

proc update_MODELPARAM_VALUE.C_PARITY_CHECK {MODELPARAM_VALUE.C_PARITY_CHECK PARAM_VALUE.parity_settings} { 
  set parity_set [get_property value ${PARAM_VALUE.parity_settings}]
  if {$parity_set == "Check_Parity" || $parity_set == "Propagate_Parity"} { 
    set val 1
  } else { 
    set val 0
  }
  set_property value $val ${MODELPARAM_VALUE.C_PARITY_CHECK}
}

proc update_MODELPARAM_VALUE.C_PARITY_GEN {MODELPARAM_VALUE.C_PARITY_GEN PARAM_VALUE.parity_settings} { 
  set parity_set [get_property value ${PARAM_VALUE.parity_settings}]
  if {$parity_set == "Check_Parity" || $parity_set == "Propagate_Parity"} { 
    set val 1
  } else { 
    set val 0
  }
  set_property value $val ${MODELPARAM_VALUE.C_PARITY_GEN}
}

proc update_MODELPARAM_VALUE.C_PARITY_PROP {MODELPARAM_VALUE.C_PARITY_PROP PARAM_VALUE.parity_settings} { 
  set parity_set [get_property value ${PARAM_VALUE.parity_settings}]
  if {$parity_set == "Propagate_Parity" } { 
    set val 1
  } else { 
    set val 0
  }
  set_property value $val ${MODELPARAM_VALUE.C_PARITY_PROP}

}


proc update_MODELPARAM_VALUE.C_M_AXI_ID_WIDTH {MODELPARAM_VALUE.C_M_AXI_ID_WIDTH PARAM_VALUE.axi_id_width} { 
  set id_width [get_property value ${PARAM_VALUE.axi_id_width}]
  set_property value $id_width ${MODELPARAM_VALUE.C_M_AXI_ID_WIDTH}
}


####
proc update_MODELPARAM_VALUE.PCIE_BLK_LOCN {PARAM_VALUE.pcie_blk_locn MODELPARAM_VALUE.PCIE_BLK_LOCN } {
    set xcoValue [get_property value ${PARAM_VALUE.pcie_blk_locn}  ]
    switch $xcoValue {
        "X0Y0" {
            set val 0
        }
        "PCIE4C_X0Y0" {
            set val 0
        }
        "PCIE4_X0Y0" {
            set val 0
        }
        "X0Y1" {
            set val 1
        }
        "PCIE4C_X0Y1" {
            set val 1
        }
        "PCIE4_X0Y1" {
            set val 1
        }
        "X0Y2" {
            set val 2
        }
        "X0Y3" {
            set val 3
        }
        "X0Y4" {
            set val 4
        }
        "X0Y5" {
            set val 5
        }
        "X1Y0" {
            set val 6
        }
        "PCIE4C_X1Y0" {
            set val 6
        }
        "PCIE4_X1Y0" {
            set val 6
        }
        "X1Y1" {
            set val 7
        }
        "PCIE4C_X1Y1" {
            set val 7
        }
        "PCIE4_X1Y1" {
            set val 7
        }
        "X1Y2" {
            set val 8
        }
        "X1Y3" {
            set val 9
        }
        "X1Y4" {
            set val 10
        }
        "X1Y5" {
            set val 11
        }
    }
    set_property value $val ${MODELPARAM_VALUE.PCIE_BLK_LOCN}
}

proc update_MODELPARAM_VALUE.PCIE_BLK_TYPE {PARAM_VALUE.pcie_blk_locn MODELPARAM_VALUE.PCIE_BLK_TYPE} { 

  set pcie_blk [get_property value ${PARAM_VALUE.pcie_blk_locn}]

  if {$pcie_blk == "PCIE4C_X0Y0" || $pcie_blk == "PCIE4C_X0Y1" || $pcie_blk == "PCIE4C_X1Y0" || $pcie_blk == "PCIE4C_X1Y1"} { 
    set val 1
  } else { 
    set val 0
  }

  set_property value $val ${MODELPARAM_VALUE.PCIE_BLK_TYPE}

} 

 proc update_MODELPARAM_VALUE.CCIX_ENABLE {MODELPARAM_VALUE.CCIX_ENABLE PARAM_VALUE.enable_ccix} { 
   set_property value [get_property value ${PARAM_VALUE.enable_ccix}] ${MODELPARAM_VALUE.CCIX_ENABLE}
 }

 proc update_MODELPARAM_VALUE.RUNBIT_FIX {MODELPARAM_VALUE.RUNBIT_FIX PARAM_VALUE.runbit_fix} { 
   set_property value [get_property value ${PARAM_VALUE.runbit_fix}] ${MODELPARAM_VALUE.RUNBIT_FIX}
 } 

##################
proc update_MODELPARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED {MODELPARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.pl_link_cap_max_link_speed} {
    set xcoValue [get_property value ${PARAM_VALUE.pl_link_cap_max_link_speed} ]
        switch $xcoValue {
            "2.5_GT/s" {
                set val 1
            }
            "5.0_GT/s" {
                set val 2
            }
            "8.0_GT/s" {
                set val 4
            }
            "16.0_GT/s" {
                set val 8
            }
      }
    set_property value $val ${MODELPARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}
}

proc update_MODELPARAM_VALUE.SPLIT_DMA { MODELPARAM_VALUE.SPLIT_DMA PARAM_VALUE.split_dma } {
  set_property value [string toupper [get_property value ${PARAM_VALUE.split_dma}]] ${MODELPARAM_VALUE.SPLIT_DMA}
}
proc update_MODELPARAM_VALUE.USR_IRQ_EXDES { MODELPARAM_VALUE.USR_IRQ_EXDES PARAM_VALUE.usr_irq_exdes } {
  set_property value [string toupper [get_property value ${PARAM_VALUE.usr_irq_exdes}]] ${MODELPARAM_VALUE.USR_IRQ_EXDES}
}
proc update_MODELPARAM_VALUE.AXI_VIP_IN_EXDES { MODELPARAM_VALUE.AXI_VIP_IN_EXDES PARAM_VALUE.axi_vip_in_exdes } {
  set_property value [string toupper [get_property value ${PARAM_VALUE.axi_vip_in_exdes}]] ${MODELPARAM_VALUE.AXI_VIP_IN_EXDES}
}  
proc update_MODELPARAM_VALUE.EN_PCIE_DEBUG_PORTS { MODELPARAM_VALUE.EN_PCIE_DEBUG_PORTS PARAM_VALUE.enable_pcie_debug } {
  set_property value [string toupper [get_property value ${PARAM_VALUE.enable_pcie_debug}]] ${MODELPARAM_VALUE.EN_PCIE_DEBUG_PORTS}
}  
proc update_MODELPARAM_VALUE.XDMA_NON_INCREMENTAL_EXDES { MODELPARAM_VALUE.XDMA_NON_INCREMENTAL_EXDES PARAM_VALUE.xdma_non_incremental_exdes} {
  set_property value [string toupper [get_property value ${PARAM_VALUE.xdma_non_incremental_exdes}]] ${MODELPARAM_VALUE.XDMA_NON_INCREMENTAL_EXDES}
}

proc update_MODELPARAM_VALUE.XDMA_ST_INFINITE_DESC_EXDES { MODELPARAM_VALUE.XDMA_ST_INFINITE_DESC_EXDES PARAM_VALUE.xdma_st_infinite_desc_exdes} {
  set_property value [string toupper [get_property value ${PARAM_VALUE.xdma_st_infinite_desc_exdes}]] ${MODELPARAM_VALUE.XDMA_ST_INFINITE_DESC_EXDES}
}
proc update_MODELPARAM_VALUE.PIPE_LINE_STAGE {MODELPARAM_VALUE.PIPE_LINE_STAGE PARAM_VALUE.pipe_line_stage} { 
  set val [get_property value ${PARAM_VALUE.pipe_line_stage}]
  set_property value $val ${MODELPARAM_VALUE.PIPE_LINE_STAGE}
}

proc update_MODELPARAM_VALUE.MULT_PF_DES { MODELPARAM_VALUE.MULT_PF_DES PARAM_VALUE.mult_pf_des } {
  set_property value [string toupper [get_property value ${PARAM_VALUE.mult_pf_des}]] ${MODELPARAM_VALUE.MULT_PF_DES}
}

proc update_MODELPARAM_VALUE.REF_CLK_FREQ { MODELPARAM_VALUE.REF_CLK_FREQ PARAM_VALUE.ref_clk_freq } {
    set xcoValue [get_property value ${PARAM_VALUE.ref_clk_freq} ]
        switch $xcoValue {
            "100_MHz" {
                set val 0
            }
            "125_MHz" {
                set val 1
            }
            "250_MHz" {
                set val 2
            }
        }
    set_property value  $val ${MODELPARAM_VALUE.REF_CLK_FREQ}
}

proc update_MODELPARAM_VALUE.DRP_CLK_SEL { MODELPARAM_VALUE.DRP_CLK_SEL PARAM_VALUE.drp_clk_sel } {
    set xcoValue [get_property value ${PARAM_VALUE.drp_clk_sel} ]
        switch $xcoValue {
            "Internal" {
                set val 0
            }
            "External" {
                set val 1
            }
        }
    set_property value  $val ${MODELPARAM_VALUE.DRP_CLK_SEL}
}
proc update_MODELPARAM_VALUE.FREE_RUN_FREQ { MODELPARAM_VALUE.FREE_RUN_FREQ PARAM_VALUE.free_run_freq } {
    set xcoValue [get_property value ${PARAM_VALUE.free_run_freq} ]
        switch $xcoValue {
            "100_MHz" {
                set val 0
            }
            "125_MHz" {
                set val 1
            }
        }
    set_property value  $val ${MODELPARAM_VALUE.FREE_RUN_FREQ}
}

proc update_PARAM_VALUE.axisten_freq {PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH PARAM_VALUE.axisten_freq PARAM_VALUE.axi_data_width PROJECT_PARAM.SPEEDGRADE PROJECT_PARAM.DEVICE} {
    set LINK_SPEED       [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}]
    set LINK_WIDTH       [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}]
    set axi_width        [get_property value ${PARAM_VALUE.axi_data_width}]
    set c_xspeedgrade    ${PROJECT_PARAM.SPEEDGRADE}
    set c_xfamily        [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set device           [string toupper ${PROJECT_PARAM.DEVICE}]

    set range_list_list "62.5 , 125"

    if {$c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
      if { $LINK_SPEED == "2.5_GT/s" } {
        if { $LINK_WIDTH == "X1" || $LINK_WIDTH == "X2" } {
          set range_list "62.5, 125, 250" 
          set default_val 250 
        } elseif {$LINK_WIDTH == "X4"} {
          set range_list "125, 250" 
          set default_val 125 
        } elseif {$LINK_WIDTH == "X8"} {
          if { $axi_width == "64_bit" } {
            set range_list "250" 
            set default_val 250 
          } else { 
            set range_list "125" 
            set default_val 125 
          }
        } else { 
            set range_list "250" 
            set default_val 250 
        }
      } elseif { $LINK_SPEED == "5.0_GT/s" } {
        if { $LINK_WIDTH == "X1"} { 
          set range_list "62.5, 125, 250" 
          set default_val 125  
        } elseif { $LINK_WIDTH == "X2"} { 
          set range_list "125, 250" 
          set default_val 125 
        } elseif { $LINK_WIDTH == "X4"} {
          if { $axi_width == "64_bit" } {
            set range_list "250" 
            set default_val 250 
          } else { 
            set range_list "125" 
            set default_val 125 
          }
        } elseif { $LINK_WIDTH == "X8"} {
          if { $axi_width == "128_bit" } {
            set range_list "250" 
            set default_val 250 
          } else { 
            set range_list "125" 
            set default_val 125 
          }
        } else {
          set range_list "250" 
          set default_val 250 
        }
      } elseif { $LINK_SPEED == "8.0_GT/s" } {
        if { $LINK_WIDTH == "X1"} { 
          set range_list "125, 250" 
          set default_val 125 
        } elseif { $LINK_WIDTH == "X2"} { 
          if { $axi_width == "64_bit" } {
            set range_list "250" 
            set default_val 250 
          } elseif { $axi_width == "128_bit" } {
            set range_list "125" 
            set default_val 125 
          }
        } elseif { $LINK_WIDTH == "X4"} { 
          if { $axi_width == "128_bit" } {
            set range_list "250" 
            set default_val 250 
          } elseif { $axi_width == "256_bit" } {
            set range_list "125" 
            set default_val 125 
          }
        } elseif { $LINK_WIDTH == "X8"} { 
          set range_list "250" 
          set default_val 250 
        } else { 
          set range_list "250" 
          set default_val 250 
        }
      } else { 
        if { $LINK_WIDTH == "X1"} { 
          if { $axi_width == "64_bit" } {
          set range_list "250" 
          set default_val 250 
          } elseif { $axi_width == "128_bit" } {
            set range_list "125" 
            set default_val 125 
          }
        } elseif { $LINK_WIDTH == "X2"} { 
          if { $axi_width == "128_bit" } {
            set range_list "250" 
            set default_val 250 
          } elseif { $axi_width == "256_bit" } {
            set range_list "125" 
            set default_val 125 
          }
        } elseif { $LINK_WIDTH == "X4"} { 
          set range_list "250" 
          set default_val 250 
        } else { 
          set range_list "250" 
          set default_val 250 
        }
      }
    } elseif {$c_xfamily == "kintex7" || ($c_xfamily == "virtex7" && ($device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T")) || $c_xfamily == "artix7" || $c_xfamily == "zynq"} {
      if {$LINK_WIDTH == "X1"} {  
        if {$c_xfamily == "artix7" && ($c_xspeedgrade == "-1" || $c_xspeedgrade == "-1i" || $c_xspeedgrade == "-1il" || $c_xspeedgrade == "-1m" || $c_xspeedgrade == "-1q" || $c_xspeedgrade == "-1l")} {  
	  set range_list  "62.5, 125"
	  set default_val  62.5
        } elseif {($device == "XC7Z015" || $device == "XC7Z015I" || $device == "XC7Z012S")} { 
	  set range_list  "62.5, 125"
	  set default_val 62.5
        } elseif {$LINK_SPEED == "2.5_GT/s"} {
	  set range_list "62.5, 125, 250"
	  set default_val 62.5
	} else {
	  set range_list "62.5, 125, 250"
	  set default_val 62.5
	}
      } elseif {$LINK_WIDTH == "X2"} {
        if {$c_xfamily == "artix7" && ($c_xspeedgrade == "-1" || $c_xspeedgrade == "-1i" || $c_xspeedgrade == "-1il" || $c_xspeedgrade == "-1m" || $c_xspeedgrade == "-1q" || $c_xspeedgrade == "-1l")} {  
	  set range_list "62.5, 125"
	  set default_val 62.5
        } elseif {($device == "XC7Z015" || $device == "XC7Z015I" || $device == "XC7Z012S")} { 
          if {$LINK_SPEED == "2.5_GT/s"} { 
	    set range_list "62.5, 125"
	    set default_val 62.5
          } else { 
	    set range_list "125"
	    set default_val 125 
          }
        } elseif {$LINK_SPEED == "2.5_GT/s"} {
	  set range_list "62.5, 125, 250"
          set default_val 62.5
	} else {
	  set range_list "125, 250"
	  set default_val 125
	}
      } elseif {$LINK_WIDTH == "X4"} {
        if {$c_xfamily == "artix7" && ($c_xspeedgrade == "-1" || $c_xspeedgrade == "-1i" || $c_xspeedgrade == "-1il" || $c_xspeedgrade == "-1m" || $c_xspeedgrade == "-1q" || $c_xspeedgrade == "-1l")} {  
          set range_list "125"
	  set default_val 125
        } elseif {($device == "XC7Z015" || $device == "XC7Z015I" || $device == "XC7Z012S")} { 
	  set range_list "125"
	  set default_val 125 
        } elseif {$LINK_SPEED == "2.5_GT/s"} {
	  set range_list "125, 250"
	  set default_val 125
	} else {
	  if {$axi_width == "64_bit" } {
	    set range_list "250"
	    set default_val 250
	  } else {
	    set range_list "125"
	    set default_val 125
	  }
	}
      } elseif {$LINK_WIDTH == "X8"} {
        if {$LINK_SPEED == "2.5_GT/s"} {
	  if {$axi_width == "64_bit" } {
	    set range_list "250"
	    set default_val 250
	  } else {
	    set range_list "125"
	    set default_val 125
	  }
        } else {
	  set range_list "250"
	  set default_val 250
        }
      }
    } else { 
      if {$LINK_SPEED eq "2.5_GT/s" } {
        switch $LINK_WIDTH {
           "X1" {
               set range_list "62.5,125,250"
               set default_val 62.5
           }
           "X2" {
               set range_list "62.5,125,250"
               set default_val 62.5
           }
           "X4" {
               set range_list "125,250"
               set default_val 125
           }
           "X8" {
             if { $c_xspeedgrade == "-1" || $c_xspeedgrade == "-1L" || $c_xspeedgrade == "-1LV" || $c_xspeedgrade == "-1H" || $c_xspeedgrade == "-1HV"} {
               set range_list "125"
               set default_val 125
             } else {
               if {$axi_width == "64_bit"} {
                 set range_list "250"
                 set default_val 250
               } else {
                 set range_list "125"
                 set default_val 125
               }
            }
          }
        }
      } elseif {$LINK_SPEED eq "5.0_GT/s" } {
        switch $LINK_WIDTH {
           "X1" {
               set range_list "62.5,125,250"
               set default_val 62.5
           }
           "X2" {
               set range_list "125,250"
               set default_val 125
           }
           "X4" {
              if {$c_xspeedgrade == "-1" || $c_xspeedgrade == "-1L" || $c_xspeedgrade == "-1LV" || $c_xspeedgrade == "-1H" || $c_xspeedgrade == "-1HV"} {
                set range_list "125"
                set default_val 125
              } else {
                if {$axi_width == "64_bit"} {
                  set range_list "250"
                  set default_val 250
                } else {
                  set range_list "125"
                  set default_val 125
                }
              }
            }
            "X8" {
                if {$c_xspeedgrade == "-1" || $c_xspeedgrade == "-1L" || $c_xspeedgrade == "-1LV" || $c_xspeedgrade == "-1H" || $c_xspeedgrade == "-1HV"} {
                  set range_list "125"
                  set default_val 125
                } else {
                  if {$axi_width == "128_bit"} {
                    set range_list "250"
                    set default_val 250
                  } else {
                    set range_list "125"
                    set default_val 125
                  }
               }
            }
          }
      } elseif {$LINK_SPEED eq "8.0_GT/s" } {
        switch $LINK_WIDTH {
           "X1" {
               if {$c_xspeedgrade == "-1" || $c_xspeedgrade == "-1L" || $c_xspeedgrade == "-1LV" || $c_xspeedgrade == "-1H" || $c_xspeedgrade == "-1HV"} {
                 set range_list "125"
                 set default_val 125
               } else {
                 set range_list "125, 250"
                 set default_val 125
               }
           }
           "X2" {
               if {$c_xspeedgrade == "-1" || $c_xspeedgrade == "-1L" || $c_xspeedgrade == "-1LV" || $c_xspeedgrade == "-1H" || $c_xspeedgrade == "-1HV" } {
                 set range_list "125"
                 set default_val 125
               } else {
                 if {$axi_width == "64_bit"} {
                   set range_list "250"
                   set default_val 250
                 } else {
                   set range_list "125"
                   set default_val 125
                 }
               }
            }
            "X4" {
                if {$c_xspeedgrade == "-1" || $c_xspeedgrade == "-1L" || $c_xspeedgrade == "-1LV" || $c_xspeedgrade == "-1H" || $c_xspeedgrade == "-1HV" } {
                  set range_list "125"
                  set default_val 125
                } else {
                  if {$axi_width == "128_bit"} {
                    set range_list "250"
                    set default_val 250
                  } else {
                    set range_list "125"
                    set default_val 125
                  }
               }
            }
            "X8" {
               set range_list "250"
               set default_val 250
            }
          }
        }
    }
    set_property range_value "$default_val,$range_list"  ${PARAM_VALUE.axisten_freq}
}

proc update_gui_for_PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED {PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.SPEEDGRADE PROJECT_PARAM.SILICON_REVISION PROJECT_PARAM.DEVICE PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH IPINST PARAM_VALUE.coreclk_freq PARAM_VALUE.mode_selection PROJECT_PARAM.PART PARAM_VALUE.en_coreclk_es1} {
    set LINK_SPEED  [string toupper [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] ]
    set LINK_WIDTH  [string toupper [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}] ]
    set speed_grade ${PROJECT_PARAM.SPEEDGRADE}
    set silicon_rev [string toupper ${PROJECT_PARAM.SILICON_REVISION}]
    set c_xdevice   ${PROJECT_PARAM.DEVICE}
    set device      [string toupper $c_xdevice]
    set c_xfamily   [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set mode        [get_property value ${PARAM_VALUE.mode_selection}]
    set c_xpackage  [getpackage_name ${PROJECT_PARAM.PART} ${PROJECT_PARAM.SPEEDGRADE} ${PROJECT_PARAM.DEVICE}]
    set pkg [string toupper $c_xpackage]
    set en_coreclk  [get_property value ${PARAM_VALUE.en_coreclk_es1}]

    if {$c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
      if {$LINK_SPEED eq "2.5_GT/S" || $LINK_SPEED eq "5.0_GT/S"} {
        set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
      } elseif {$LINK_SPEED eq "8.0_GT/S"} {
        if {$mode == "Basic"} { 
          set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
        } else { 
          if {$LINK_WIDTH eq "X8"} {
            if {($speed_grade == "-1LV" || $speed_grade == "-1L")} {
              set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
            } else { 
              if {$en_coreclk && $silicon_rev == "ES1"} { 
                set_property visible true [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
              } else { 
                set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
              }
            }
          } else { 
            set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
          }
        }
      } else {
        set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
      }
    } elseif {($c_xfamily == "kintexu" || $c_xfamily == "virtexu")} {
        if {($speed_grade == "-1" || $speed_grade == "-1L" || $speed_grade == "-1LV" || $speed_grade == "-1H" || $speed_grade == "-1HV") && (($device == "XCVU095" && $silicon_rev == "ES1") || (($device == "XCKU060" || $device == "XQKU060" ) && $silicon_rev == "ES2") || ($device == "XCKU115" && $silicon_rev == "ES2"))} {
            set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
        } elseif {$LINK_SPEED eq "8.0_GT/S"} {
            if {($speed_grade == "-2" || $speed_grade == "-3") && $LINK_WIDTH eq "X8"} {
                set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
            } elseif {($speed_grade == "-2" || $speed_grade == "-3") && $LINK_WIDTH ne "X8" && $mode eq "Advanced"} {
                set_property visible true  [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
            } elseif {($speed_grade == "-1" || $speed_grade == "-1L" || $speed_grade == "-1LV" || $speed_grade == "-1H" || $speed_grade == "-1HV") && $LINK_WIDTH ne "X8"} {
                set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
            }
        } else {
            set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
        }
    } else  {
        set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
    }

}

proc update_gui_for_PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH {PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.SPEEDGRADE PROJECT_PARAM.SILICON_REVISION PROJECT_PARAM.DEVICE PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH IPINST PARAM_VALUE.coreclk_freq PARAM_VALUE.mode_selection PROJECT_PARAM.PART PARAM_VALUE.en_coreclk_es1} {
    set LINK_SPEED  [string toupper [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] ]
    set LINK_WIDTH  [string toupper [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}] ]
    set speed_grade ${PROJECT_PARAM.SPEEDGRADE}
    set silicon_rev [string toupper ${PROJECT_PARAM.SILICON_REVISION}]
    set c_xdevice   ${PROJECT_PARAM.DEVICE}
    set device      [string toupper $c_xdevice]
    set c_xfamily   [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set mode        [get_property value ${PARAM_VALUE.mode_selection}]
    set c_xpackage  [getpackage_name ${PROJECT_PARAM.PART} ${PROJECT_PARAM.SPEEDGRADE} ${PROJECT_PARAM.DEVICE}]
    set pkg         [string toupper $c_xpackage]
    set en_coreclk  [get_property value ${PARAM_VALUE.en_coreclk_es1}]

    if {$c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
      if {$LINK_SPEED eq "2.5_GT/S" || $LINK_SPEED eq "5.0_GT/S"} {
        set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
      } elseif {$LINK_SPEED eq "8.0_GT/S"} {
        if {$mode == "Basic"} { 
          set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
        } else { 
          if {$LINK_WIDTH eq "X8"} {
            if {($speed_grade == "-1LV" || $speed_grade == "-1L")} {
              set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
            } else { 
              if {$en_coreclk && $silicon_rev == "ES1"} { 
                set_property visible true [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
              } else {
                set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
              }
            } 
          } elseif {$LINK_WIDTH eq "X16"} {
            set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
          }
        }
      } else {
        set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
      }
    } elseif {($c_xfamily == "kintexu" || $c_xfamily == "virtexu")} {
        if {($speed_grade == "-1" || $speed_grade == "-1L" || $speed_grade == "-1LV" || $speed_grade == "-1H" || $speed_grade == "-1HV") && (($device == "XCVU095" && $silicon_rev == "ES1") || (($device == "XCKU060" || $device == "XQKU060") && $silicon_rev == "ES2") || ($device == "XCKU115" && $silicon_rev == "ES2"))} {
            set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
        } elseif {$LINK_SPEED eq "8.0_GT/S"} {
            if {($speed_grade == "-2" || $speed_grade == "-3") && $LINK_WIDTH eq "X8"} {
                set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
            } elseif {($speed_grade == "-2" || $speed_grade == "-3") && $LINK_WIDTH ne "X8" && $mode eq "Advanced"} {
                set_property visible true  [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
            } elseif {($speed_grade == "-1" || $speed_grade == "-1L" || $speed_grade == "-1LV" || $speed_grade == "-1H" || $speed_grade == "-1HV") && $LINK_WIDTH ne "X8"} {
                set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
            }
        } else {
            set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
        }
    } else  {
        set_property visible false [ipgui::get_guiparamspec coreclk_freq -of $IPINST ]
    }
}

proc update_gui_for_PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED {PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED  PARAM_VALUE.plltype IPINST} { 
  set link_speed [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}]

  if {$link_speed == "5.0_GT/s" } { 
    set_property visible true [ipgui::get_guiparamspec plltype -of $IPINST ]
  } else { 
    set_property visible false [ipgui::get_guiparamspec plltype -of $IPINST ]
  }
}

proc update_PARAM_VALUE.drp_clk_sel {PARAM_VALUE.drp_clk_sel  PARAM_VALUE.mult_pf_des PARAM_VALUE.enable_ibert IPINST PROJECT_PARAM.ARCHITECTURE} { 
  set mult_pf_des_val  [get_property value ${PARAM_VALUE.mult_pf_des}]
  set c_gt_drp_clk_src [get_property value ${PARAM_VALUE.drp_clk_sel}] 
  set c_xfamily        [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
  
  if { ($c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm") && ($mult_pf_des_val)} {
    if { [get_property value ${PARAM_VALUE.enable_ibert}] } {
      set_property enabled false ${PARAM_VALUE.drp_clk_sel}
      set_property value "External" ${PARAM_VALUE.drp_clk_sel}
    } else {
      set_property enabled true ${PARAM_VALUE.drp_clk_sel}
      set_property value "Internal" ${PARAM_VALUE.drp_clk_sel}
    }
  } else {
    set_property enabled false ${PARAM_VALUE.drp_clk_sel}
    set_property value "Internal" ${PARAM_VALUE.drp_clk_sel}
  }

}

proc update_gui_for_PARAM_VALUE.mult_pf_des {PARAM_VALUE.mult_pf_des PARAM_VALUE.drp_clk_sel PARAM_VALUE.split_dma PROJECT_PARAM.ARCHITECTURE IPINST} { 
  set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]
  set split_dma_val   [get_property value ${PARAM_VALUE.split_dma}]
  set c_xfamily       [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]

  if { ($c_xfamily == "virtexuplus" ||  $c_xfamily == "kintexuplus" ||  $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm") && ($mult_pf_des_val) && (!$split_dma_val) } {
    set_property visible true [ipgui::get_guiparamspec drp_clk_sel -of $IPINST ]
  } else {
    set_property visible false [ipgui::get_guiparamspec drp_clk_sel -of $IPINST ]
  }

}

proc update_gui_for_PARAM_VALUE.drp_clk_sel {PARAM_VALUE.drp_clk_sel PARAM_VALUE.free_run_freq PARAM_VALUE.mult_pf_des IPINST} { 
  set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]
  set clk_sel [get_property value ${PARAM_VALUE.drp_clk_sel}]

  if { $mult_pf_des_val } { 
    if { $clk_sel == "External" } { 
      set_property visible true [ipgui::get_guiparamspec free_run_freq -of $IPINST ]
    } else { 
      set_property visible false [ipgui::get_guiparamspec free_run_freq -of $IPINST ]
    }
  } else { 
    set_property visible false [ipgui::get_guiparamspec free_run_freq -of $IPINST ]
  }
}

proc update_PARAM_VALUE.plltype { PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.plltype } {
    set LINK_SPEED [string toupper [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] ]
    if {$LINK_SPEED eq "2.5_GT/S" } {
        set range_list "CPLL"
        set default_val CPLL
        set_property enabled false ${PARAM_VALUE.plltype}
    } elseif {$LINK_SPEED eq "5.0_GT/S" } {
        set range_list "CPLL , QPLL1"
        set default_val QPLL1
        set_property enabled true ${PARAM_VALUE.plltype}
    } elseif {$LINK_SPEED eq "8.0_GT/S" } {
        set range_list "QPLL1 , QPLL0"
        set default_val QPLL1
        set_property enabled true ${PARAM_VALUE.plltype}
    } else {
        set range_list "QPLL0"
        set default_val QPLL0
        set_property enabled false ${PARAM_VALUE.plltype}
    }
    set_property range_value "$default_val,$range_list"  ${PARAM_VALUE.plltype}
}

###############################################################################################################################################
# Starting 2017.1 release for UltraScale Plus devices the option of selecting coreclock between 250Mhz and 500MHz for x8g3 configuration 
# has been removed and the parameter is made invisible for all link width and link speed configurations for all speedgrades. 
# i.e, -1, -2, -3, -1L, -1LV, -2, -2LV. 
# for x8g3 and x16g3 coreclk_freq is set to 500MHz. For all other configurations, coreclk_freq is set to 250Mhz.
# For -2, -2L and -3 supported configurations are x1/x2/x4/x8/x16 - Gen1/Gen2/Gen3. Coreclk freq is 500MHz for x8Gen3 and x16Gen3.
# And Coreclk is 250Mhz for x1/x2/x4/x8/x16 Gen1/Gen2
# For -1,-1L, -1LV and -2LV supported configurations are x1/x2/x4/x8/x16 - Gen1/Gen2 - Coreclk 250Mhz. and x1/x2/x4 for Gen3 - Coreclk 250Mhz. 
# Added support to set coreclk_freq to 250Mhz in case of x8g3 for ES1 devices for the speedgrades -2, -3 and -2L
# CCIX_EN for x8g3 requires 250MHz core_clk 
###############################################################################################################################################

proc update_PARAM_VALUE.coreclk_freq {PARAM_VALUE.coreclk_freq PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.SPEEDGRADE PROJECT_PARAM.SILICON_REVISION PROJECT_PARAM.DEVICE PROJECT_PARAM.PART PARAM_VALUE.en_coreclk_es1 PARAM_VALUE.enable_ccix} {
    set LINK_SPEED     [string toupper [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] ]
    set LINK_WIDTH     [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}]
    set speed_grade    ${PROJECT_PARAM.SPEEDGRADE}
    set silicon_rev    [string toupper ${PROJECT_PARAM.SILICON_REVISION}]
    set c_xdevice      ${PROJECT_PARAM.DEVICE}
    set device         [string toupper $c_xdevice]
    set c_xfamily      [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set enable_coreclk false
    set c_xpackage     [getpackage_name ${PROJECT_PARAM.PART} ${PROJECT_PARAM.SPEEDGRADE} ${PROJECT_PARAM.DEVICE}]
    set pkg            [string toupper $c_xpackage]
    set en_coreclk     [get_property value ${PARAM_VALUE.en_coreclk_es1}]
    set ccix_en        [get_property value ${PARAM_VALUE.enable_ccix}]

    if {$c_xfamily == "virtexuplus" || $c_xfamily == "kintexuplus" || $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
      if {$LINK_SPEED eq "2.5_GT/S" || $LINK_SPEED eq "5.0_GT/S"} {
        set range_list "250"
        set default_val 250
        set enable_coreclk false
      } elseif {$LINK_SPEED eq "8.0_GT/S"} {
        if {$LINK_WIDTH eq "X8"} {
          if { ( $en_coreclk && $silicon_rev == "ES1" && ($speed_grade == "-2" || $speed_grade == "-2L" || $speed_grade == "-3") ) || $speed_grade == "-2LV" || $speed_grade == "-1" ||$ccix_en} { 
            set range_list "250"
            set default_val 250 
            set enable_coreclk false 
          } else { 
            set range_list "500"
            set default_val 500 
            set enable_coreclk false
          }
        } elseif {$LINK_WIDTH eq "X16" } { 
          set range_list "500"
          set default_val 500 
          set enable_coreclk false
        } else {
          set range_list "250"
          set default_val 250
          set enable_coreclk false
        }
      } else {
        if {$LINK_WIDTH eq "X8"} {
          set range_list "500"
          set default_val 500
        } else {
          set range_list "250"
          set default_val 250
        }
        set enable_coreclk false
      }
      set_property range_value "$default_val,$range_list" ${PARAM_VALUE.coreclk_freq}
      set_property enabled $enable_coreclk ${PARAM_VALUE.coreclk_freq}
    } elseif {$c_xfamily == "kintexu" || $c_xfamily == "virtexu"} {
        if {($speed_grade == "-1" || $speed_grade == "-1L" || $speed_grade == "-1LV" || $speed_grade == "-1H" || $speed_grade == "-1HV") && (($device == "XCVU095" && $silicon_rev == "ES1") || (($device == "XCKU060" || $device == "XQKU060") && $silicon_rev == "ES2") || ($device == "XCKU115" && $silicon_rev == "ES2"))} {
            set range_list "250"
            set default_val 250
            set enable_coreclk false
        } elseif {$LINK_SPEED eq "8.0_GT/S" } {
            if {($speed_grade == "-2" || $speed_grade == "-3") && $LINK_WIDTH eq "X8"} {
                set range_list "500"
                set default_val 500
                set enable_coreclk false
            } elseif {($speed_grade == "-2" || $speed_grade == "-3") && $LINK_WIDTH ne "X8"} {
                set range_list "250,500"
                set default_val 500 
                set enable_coreclk true
            } elseif {($speed_grade == "-1" || $speed_grade == "-1L" || $speed_grade == "-1LV" || $speed_grade == "-1H" || $speed_grade == "-1HV") && $LINK_WIDTH ne "X8"} {
                set range_list "250"
                set default_val 250
                set enable_coreclk false
            } else {
                set range_list "250"
                set default_val 250
                set enable_coreclk false
            }
        } else {
            set range_list "250"
            set default_val 250
            set enable_coreclk false
        }
        set_property range_value "$default_val,$range_list" ${PARAM_VALUE.coreclk_freq}
        set_property enabled $enable_coreclk ${PARAM_VALUE.coreclk_freq}
    }
}

proc update_PARAM_VALUE.pf0_device_id {PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH PARAM_VALUE.pf0_device_id PARAM_VALUE.device_port_type PROJECT_PARAM.ARCHITECTURE} {
    set c_xfamily        [ getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set PF ${PARAM_VALUE.pf0_device_id}
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type} ]
    set LINK_SPEED [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}]
    set LINK_WIDTH [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}]
    set speed_val 3
    set width 8
    # Assigning the default values
    set port [ expr {$device_port_type eq "Root_Port_of_PCI_Express_Root_Complex" }]
    switch $LINK_SPEED {
        "2.5_GT/s" {set speed_val 1}
        "5.0_GT/s" {set speed_val 2}
        "8.0_GT/s" {set speed_val 3}
        "16.0_GT/s" {set speed_val 4}
    }

    switch $LINK_WIDTH {
        "X1"  { set width 1}
        "X2"  { set width 2}
        "X4"  { set width 4}
        "X8"  { set width 8}
        "X16" { set width F}
    }
    if {$c_xfamily == "virtexuplus" || $c_xfamily == "kintexuplus" || $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
        set_property value  "9${port}${speed_val}${width}" $PF
    } elseif {$c_xfamily == "kintexu" || $c_xfamily == "virtexu"} {
        set_property value  "8${port}${speed_val}${width}" $PF
    } else {
        set_property value  "7${port}${speed_val}${width}" $PF
    }
}

proc update_PARAM_VALUE.axi_data_width {PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH  PROJECT_PARAM.SPEEDGRADE PARAM_VALUE.axi_data_width} {
    set LINK_SPEED     [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}]
    set LINK_WIDTH     [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}]
    set c_xfamily      [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set c_xfamily_gen2 [string toupper ${PROJECT_PARAM.ARCHITECTURE}]
    set device    [string toupper ${PROJECT_PARAM.DEVICE}]
    set c_xspeedgrade  ${PROJECT_PARAM.SPEEDGRADE}
    set range_list     "256_bit"
    set default_val    256_bit

    if {$c_xfamily == "virtexuplus" || $c_xfamily == "kintexuplus" || $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
      if {$LINK_SPEED eq "2.5_GT/s"} {
        if {$LINK_WIDTH == "X16"} {
          set range_list "128_bit" 
          set default_val 128_bit 
        } elseif {$LINK_WIDTH == "X8"} {
          set range_list "64_bit,128_bit" 
          set default_val 64_bit 
        } else {
          set range_list "64_bit" 
          set default_val 64_bit 
        }
      } elseif {$LINK_SPEED == "5.0_GT/s"} {
        if {$LINK_WIDTH == "X16"} {
          set range_list "256_bit" 
          set default_val 256_bit 
        } elseif {$LINK_WIDTH == "X8"} {
          set range_list "128_bit,256_bit" 
          set default_val 128_bit 
        } elseif {$LINK_WIDTH == "X4"} {
          set range_list "64_bit,128_bit" 
          set default_val 64_bit 
        } else {
          set range_list "64_bit" 
          set default_val 64_bit 
        }
      } elseif {$LINK_SPEED == "8.0_GT/s"} {
        if {$LINK_WIDTH == "X16"} {
	  set range_list "512_bit" 
	  set default_val 512_bit 
        } elseif {$LINK_WIDTH == "X8"} {
          set range_list "256_bit" 
          set default_val 256_bit 
        } elseif {$LINK_WIDTH == "X4"} {
          set range_list "128_bit,256_bit" 
          set default_val 128_bit 
        } elseif {$LINK_WIDTH == "X2"} {
          set range_list "64_bit,128_bit" 
          set default_val 64_bit 
        } else { 
          set range_list "64_bit" 
          set default_val 64_bit 
        }
      } elseif {$LINK_SPEED == "16.0_GT/s"} {
        if {$LINK_WIDTH == "X8"} {
	  set range_list "512_bit" 
	  set default_val 512_bit 
        } elseif {$LINK_WIDTH == "X4"} {
          set range_list "256_bit" 
          set default_val 256_bit 
        } elseif {$LINK_WIDTH == "X2"} {
          set range_list "128_bit,256_bit" 
          set default_val 128_bit 
        } else { 
          set range_list "64_bit,128_bit" 
          set default_val 64_bit 
        }
      }
    } else { 
      if {$LINK_SPEED eq "2.5_GT/s" } {
        if {$LINK_WIDTH == "X8"} {
          if {$device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $c_xfamily_gen2 == "KINTEX7" || $c_xfamily_gen2 == "QKINTEX7" || $c_xfamily_gen2 == "KINTEX7L" ||  $c_xfamily_gen2 == "QKINTEX7L" || $c_xfamily_gen2 == "ARTIX7" || $c_xfamily_gen2 == "AARTIX7" ||  $c_xfamily_gen2 == "QARTIX7" ||  $c_xfamily_gen2 == "ARTIX7L" || $c_xfamily_gen2 == "ZYNQ" || $c_xfamily_gen2 == "AZYNQ" || $c_xfamily_gen2 == "QZYNQ"} { 
            set range_list "64_bit,128_bit"
            set default_val 128_bit
          } elseif {$c_xspeedgrade == "-1L" || $c_xspeedgrade == "-1" || $c_xspeedgrade == "-1LV" || $c_xspeedgrade == "-1H" || $c_xspeedgrade == "-1HV"} {
            set range_list "128_bit"
            set default_val 128_bit
          } else {
            set range_list "64_bit,128_bit"
            set default_val 128_bit
          }
        } else {
            set range_list "64_bit"
            set default_val 64_bit
        }
      } elseif {$LINK_SPEED eq "5.0_GT/s" } {
        switch $LINK_WIDTH {
           "X1" {
               set range_list "64_bit"
               set default_val 64_bit
           }
           "X2" {
              set range_list "64_bit"
              set default_val 64_bit
           }
           "X4" {
               if {$device == "XC7Z015" || $device == "XC7Z015I" || $device == "XC7Z12S"} { 
                 set range_list "128_bit"
                 set default_val 128_bit
               } elseif {$device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $c_xfamily_gen2 == "KINTEX7" || $c_xfamily_gen2 == "QKINTEX7" || $c_xfamily_gen2 == "KINTEX7L" ||  $c_xfamily_gen2 == "QKINTEX7L" || $c_xfamily_gen2 == "ARTIX7" || $c_xfamily_gen2 == "AARTIX7" ||  $c_xfamily_gen2 == "QARTIX7" ||  $c_xfamily_gen2 == "ARTIX7L" || $c_xfamily_gen2 == "ZYNQ" || $c_xfamily_gen2 == "AZYNQ" || $c_xfamily_gen2 == "QZYNQ"} { 
                 set range_list "64_bit,128_bit"
                 set default_val 128_bit
               } elseif {$c_xspeedgrade == "-1L" || $c_xspeedgrade == "-1" || $c_xspeedgrade == "-1LV" || $c_xspeedgrade == "-1H" || $c_xspeedgrade == "-1HV"} {
                 set range_list "128_bit"
                 set default_val 128_bit
               } else {
                 set range_list "64_bit,128_bit"
                 set default_val 128_bit
               }
           }
           "X8" {
               ## Disable 256-bit if it is gen2x8
               if {$device == "XC7VX485T" || $device == "XC7V585T" || $device == "XC7V2000T" || $device == "XQ7V585T" || $device == "XQ7VX485T" || $c_xfamily_gen2 == "KINTEX7" || $c_xfamily_gen2 == "QKINTEX7" || $c_xfamily_gen2 == "KINTEX7L" ||  $c_xfamily_gen2 == "QKINTEX7L" || $c_xfamily_gen2 == "ARTIX7" || $c_xfamily_gen2 == "AARTIX7" ||  $c_xfamily_gen2 == "QARTIX7" ||  $c_xfamily_gen2 == "ARTIX7L" || $c_xfamily_gen2 == "ZYNQ" || $c_xfamily_gen2 == "AZYNQ" || $c_xfamily_gen2 == "QZYNQ"} {
                 set range_list "128_bit"
                 set default_val 128_bit
               ## Disable 128-bit for certain speedgrades
               } elseif {$c_xspeedgrade == "-1L" || $c_xspeedgrade == "-1" || $c_xspeedgrade == "-1LV" || $c_xspeedgrade == "-1H" || $c_xspeedgrade == "-1HV"} {
                 set range_list "256_bit"
                 set default_val 256_bit
               } else {
                 set range_list "128_bit,256_bit"
                 set default_val 256_bit
               }
           }
        }
      } elseif {$LINK_SPEED eq "8.0_GT/s" } {
        switch $LINK_WIDTH {
           "X1" {set range_list "64_bit"
               set default_val 64_bit
           }
           "X2" {
               if {$c_xspeedgrade == "-1L" || $c_xspeedgrade == "-1" || $c_xspeedgrade == "-1LV" || $c_xspeedgrade == "-1H" || $c_xspeedgrade == "-1HV"} {
                 set range_list "128_bit"
                 set default_val 128_bit
               } else {
                 set range_list "64_bit,128_bit"
                 set default_val 128_bit
               }
           }
           "X4" {
               if {$c_xspeedgrade == "-1L" || $c_xspeedgrade == "-1" || $c_xspeedgrade == "-1LV" || $c_xspeedgrade == "-1H" || $c_xspeedgrade == "-1HV"} {
                 set range_list "256_bit"
                 set default_val 256_bit
               } else {
                 set range_list "128_bit,256_bit"
                 set default_val 256_bit
               }
           }
           "X8" {set range_list "256_bit"
               set default_val 256_bit
           }
        }
      }
    }
    set_property range_value "$default_val,$range_list"  ${PARAM_VALUE.axi_data_width}
}

proc get_base_class_hex_values { base_class_text_value  } {
    array set Base_Classes {
        "Device_was_built_before_Class_Code_definitions_were_finalized" "00h"
        "Mass_storage_controller" "01h"
        "Network_controller" "02h"
        "Display_controller" "03h"
        "Multimedia_device" "04h"
        "Memory_controller" "05h"
        "Bridge_device" "06h"
        "Simple_communication_controllers" "07h"
        "Base_system_peripherals" "08h"
        "Input_devices" "09h"
        "Docking_stations" "0Ah"
        "Processors" "0Bh"
        "Serial_bus_controllers" "0Ch"
        "Wireless_controller" "0Dh"
        "Intelligent_I/O_controllers" "0Eh"
        "Satellite_communication_controllers" "0Fh"
        "Encryption/Decryption_controllers" "10h"
        "Data_acquisition_and_signal_processing_controllers" "11h"
        "Reserved" "12h"
        "Device_does_not_fit_in_any_defined_classes" "FFh"
    }
    set hex_val  [lindex [array get Base_Classes $base_class_text_value ] 1 ]
    return $hex_val
}

proc cal_using_base_class  {base_class_text_value parameter  value } {
    set base_class_hex_value [get_base_class_hex_values $base_class_text_value]
    set sub_int_array_name "Sub_Interfaces_$base_class_hex_value"
    array set Sub_Interfaces_00h {
        "All_currently_implemented_devices_except_VGA-compatible_devices" {00h 00h}
        "VGA-compatible_devices" {01h 00h}
    }
    array set Sub_Interfaces_01h {
        "SCSI_bus_controller" {00h 00h}
        "IDE_controller" {01h 00h}
        "Floppy_disk_controller" {02h 00h}
        "IPI_bus_controller" {03h 00h}
        "RAID_controller" {04h 00h}
	"ATA_controller_with_ADMA_Interface_Single_Stepping" {05h 20h}
	"ATA_controller_with_ADMA_Interface_Continuous_Operation" {05h 30h}
	"Serial_ATA_controller_Vendor_Specific_Interface" {06h 00h}
	"Serial_ATA_controller_AHCI_1.0_Interface" {06h 01h}
	"Serial_Attached_SCSI(SAS)_Controller" {07h 00h}
        "Other_mass_storage_controller" {80h 00h}
    }
    array set Sub_Interfaces_02h {
        "Ethernet_controller" {00h 00h}
        "Token_Ring_controller" {01h 00h}
        "FDDI_controller" {02h 00h}
        "ATM_controller" {03h 00h}
        "ISDN_controller" {04h 00h}
	"WorldFip_controller" {05h 00h}
	"PICMG_2.14_Multi_Computing" {06h 00h}
        "Other_network_controller" {80h 00h}
    }
    array set Sub_Interfaces_03h {
        "VGA_compatible_controller" {00h 00h}
        "8514_compatible_controller" {00h 01h}
        "XGA_controller" {01h 00h}
        "3D_controller" {02h 00h}
        "Other_display_controller" {80h 00h}
    }
    array set Sub_Interfaces_04h {
        "Video_device" {00h 00h}
        "Audio_device" {01h 00h}
        "Computer_telephony_device" {02h 00h}
        "Other_multimedia_device" {80h 00h}
    }
    array set Sub_Interfaces_05h {
        "RAM" {00h 00h}
        "Flash" {01h 00h}
        "Other_memory_controller" {80h 00h}
    }
    array set Sub_Interfaces_06h {
        "Host_bridge" {00h 00h}
        "ISA_bridge" {01h 00h}
        "EISA_bridge" {02h 00h}
        "MCA_bridge" {03h 00h}
        "PCI_to_PCI_bridge" {04h 00h}
        "Subtractive_Decode_PCI_to_PCI_bridge" {04h 01h}
        "PCMCIA_bridge" {05h 00h}
        "NuBus_bridge" {06h 00h}
        "CardBus_bridge" {07h 00h}
	"RACEway_bridge_Transparent_mode" {08h 00h}
	"RACEway_bridge_Endpoint_mode" {08h 01h}
        "Semi_transparent_PCI_to_PCI_bridge_with_the_primary_PCI_bus_side_facing_the_system_host_processor" {09h 40h}
        "Semi_transparent_PCI_to_PCI_bridge_with_the_secondary_PCI_bus_side_facing_the_system_host_processor" {09h 80h}
        "InfiniBand_to_PCI_host_bridge" {0Ah 00h}
        "Other_bridge_device" {80h 00h}
    }
    array set Sub_Interfaces_07h {
        "Generic_XT_compatible_serial_controller" {00h 00h}
        "16450_compatible_serial_controller" {00h 01h}
        "16550_compatible_serial_controller" {00h 02h}
        "16650_compatible_serial_controller" {00h 03h}
        "16750_compatible_serial_controller" {00h 04h}
        "16850_compatible_serial_controller" {00h 05h}
        "16950_compatible_serial_controller" {00h 06h}
        "Parallel_port" {01h 00h}
        "Bi_directional_parallel_port" {01h 01h}
        "ECP_1.X_compliant_parallel_port" {01h 02h}
        "IEEE_1284_controller" {01h 03h}
        "IEEE_1284_target_device" {01h FEh}
        "Multiport_serial_controller" {02h 00h}
        "Generic_modem" {03h 00h}
        "Hayes_compatible_modem_with_16450_compatible_interface" {03h 01h}
        "Hayes_compatible_modem_with_16550_compatible_interface" {03h 02h}
        "Hayes_compatible_modem_with_16650_compatible_interface" {03h 03h}
        "Hayes_compatible_modem_with_16750_compatible_interface" {03h 04h}
	"GPIB(IEEE_488.1/2)_controller" {04h 00h}
	"Smart_Card" {05h 00h}
        "Other_communications_device" {80h 00h}
    }
    array set Sub_Interfaces_08h {
        "Generic_8259_PIC" {00h 00h}
        "ISA_PIC" {00h 01h}
        "EISA_PIC" {00h 02h}
        "I/O_APIC_interrupt_controller" {00h 10h}
        "I/Ox_APIC_interrupt_controller" {00h 20h}
        "Generic_8237_DMA_controller" {01h 00h}
        "ISA_DMA_controller" {01h 01h}
        "EISA_DMA_controller" {01h 02h}
        "Generic_8254_system_timer" {02h 00h}
        "ISA_system_timer" {02h 01h}
        "EISA_system_two_timers" {02h 02h}
        "Generic_RTC_controller" {03h 00h}
        "ISA_RTC_controller" {03h 01h}
        "Generic_PCI_Hot_Plug_controller" {04h 00h}
	"SD_Host_controller" {05h 00h}
        "Other_system_peripheral" {80h 00h}
    }
    array set Sub_Interfaces_09h {
        "Keyboard_controller" {00h 00h}
        "Digitizer_pen" {01h 00h}
        "Mouse_controller" {02h 00h}
        "Scanner_controller" {03h 00h}
        "Gameport_controller_generic" {04h 00h}
        "Gameport_controller" {04h 10h}
        "Other_input_controller" {80h 00h}
    }
    array set Sub_Interfaces_0Ah {
        "Generic_docking_station" {00h 00h}
        "Other_type_of_docking_station" {80h 00h}
    }
    array set Sub_Interfaces_0Bh {
        "386" {00h 00h}
        "486" {01h 00h}
        "Pentium" {02h 00h}
        "Alpha" {10h 00h}
        "PowerPC" {20h 00h}
        "MIPS" {30h 00h}
        "Co_processor" {40h 00h}
    }
    array set Sub_Interfaces_0Ch {
        "IEEE_1394_FireWire" {00h 00h}
        "IEEE_1394_following_the_1394_OpenHCI_specification" {00h 10h}
        "ACCESS_bus" {01h 00h}
        "SSA" {02h 00h}
        "Universal_Serial_Bus_following_the_Universal_Host_Controller_specification" {03h 00h}
        "Universal_Serial_Bus_following_the_Open_Host_Controller_specification" {03h 10h}
        "Universal_Serial_Bus_with_no_specific_programming_interface" {03h 80h}
        "USB_device_not_host_controller" {03h FEh}
        "Fibre_Channel" {04h 00h}
        "System_Management_Bus" {05h 00h}
	"InfiniBand" {06h 00h}
	"IPMI_SMIC_Interface" {07h 00h}
	"IPMI_Kybd_Controller_Style_Interface" {07h 01h}
	"IPMI_Block_Transfer_Interface" {07h 02h}
	"SERCOS_Interface_Standard(IEC_61491)" {08h 00h}
	"CANbus" {09h 00h}
    }
    array set Sub_Interfaces_0Dh {
        "iRDA_compatible_controller" {00h 00h}
        "Consumer_IR_controller" {01h 00h}
        "RF_controller" {10h 00h}
	"Bluetooth" {11h 00h}
	"Broadband" {12h 00h}
	"Ethernet(802.11a-5_GHz)" {20h 00h}
	"Ethernet(802.11b-2.4_GHz)" {21h 00h}
        "Other_type_of_wireless_controller" {80h 00h}
    }
    array set Sub_Interfaces_0Eh {
        "Message_FIFO_at_offset_040h" {00h 00h}
        "Intelligent_I/O_I2O_Architecture_Specification_1.0" {00h 01h}
    }
    array set Sub_Interfaces_0Fh {
        "TV" {01h 00h}
        "Audio" {02h 00h}
        "Voice" {03h 00h}
        "Data" {04h 00h}
    }
    array set Sub_Interfaces_10h {
        "Network_and_computing_en/decryption" {00h 00h}
        "Entertainment_en/decryption" {10h 00h}
        "Other_en/decryption" {80h 00h}
    }
    array set Sub_Interfaces_11h {
        "DPIO_modules" {00h 00h}
        "Performance_counters" {01h 00h}
        "Communications_synchronization_plus_time_and_frequency_test/measurement" {10h 00h}
        "Management_card" {20h 00h}
        "Other_data_acquisition/signal_processing_controllers" {80h 00h}
    }
    array set Sub_Interfaces_12h {
        "Unknown" {xx xx}
    }
    array set Sub_Interfaces_FFh {
        "Unknown" {xx xx}
    }
    set sub_interface_list [join [ lsort -unique [array names $sub_int_array_name ] ] , ]

    if {$parameter eq  "pf0_sub_class_interface_menu" || $parameter eq "pf1_sub_class_interface_menu"  } {
        return $sub_interface_list
    } else {
    set sub_val_list  ""
    set int_val_list ""
    set list_values  [array get $sub_int_array_name  $value]
    lappend  sub_val_list [lindex [lindex $list_values 1] 0]
    lappend  int_val_list [lindex [lindex $list_values 1] 1]
    if {$parameter eq  "sub_class_value" } {
        return $sub_val_list
    } elseif {$parameter eq  "interface_value"} {
        return $int_val_list
    }
  }
}

proc update_PARAM_VALUE.pf0_sub_class_interface_menu {PARAM_VALUE.pf0_sub_class_interface_menu PARAM_VALUE.pf0_base_class_menu} {
    set base_class_text_value [get_property value  ${PARAM_VALUE.pf0_base_class_menu}]
    set subclass_memu_value_list [ cal_using_base_class  $base_class_text_value pf0_sub_class_interface_menu  0 ]
    set_property range $subclass_memu_value_list  ${PARAM_VALUE.pf0_sub_class_interface_menu}
}

proc update_PARAM_VALUE.pf1_sub_class_interface_menu {PARAM_VALUE.pf1_sub_class_interface_menu PARAM_VALUE.pf1_base_class_menu} {
    set base_class_text_value [get_property value  ${PARAM_VALUE.pf1_base_class_menu}]
    set subclass_memu_value_list [ cal_using_base_class  $base_class_text_value pf1_sub_class_interface_menu  0 ]
    set_property range $subclass_memu_value_list  ${PARAM_VALUE.pf1_sub_class_interface_menu}
}

proc update_PARAM_VALUE.sys_reset_polarity { PARAM_VALUE.sys_reset_polarity PROJECT_PARAM.ARCHITECTURE} {

  set c_xfamily  [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
  if {$c_xfamily == "virtexuplus" || $c_xfamily == "kintexuplus" || $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
    set_property enabled true ${PARAM_VALUE.sys_reset_polarity}
  } elseif {$c_xfamily == "virtexu" || $c_xfamily == "kintexu"} {
    set_property enabled true ${PARAM_VALUE.sys_reset_polarity}
  } else  {
    set_property enabled false ${PARAM_VALUE.sys_reset_polarity}
    set_property value "ACTIVE_LOW"  ${PARAM_VALUE.sys_reset_polarity}
  }

}

proc update_PARAM_VALUE.dma_reset_source_sel {PARAM_VALUE.dma_reset_source_sel PROJECT_PARAM.ARCHITECTURE} { 
  set c_xfamily  [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]

  if {$c_xfamily == "virtexuplus" || $c_xfamily == "kintexuplus" || $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm" || $c_xfamily == "virtexu" || $c_xfamily == "kintexu"} {
    set_property enabled true ${PARAM_VALUE.dma_reset_source_sel}
    set_property range_value "User_Reset,User_Reset,Phy_Ready" ${PARAM_VALUE.dma_reset_source_sel} 
  } else { 
    set_property enabled true ${PARAM_VALUE.dma_reset_source_sel}
    set_property range_value "User_Reset,User_Reset" ${PARAM_VALUE.dma_reset_source_sel} 
    set_property enabled false ${PARAM_VALUE.dma_reset_source_sel}
  }

} 

proc update_PARAM_VALUE.mcap_enablement {PARAM_VALUE.mcap_enablement PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE  PARAM_VALUE.device_port_type PARAM_VALUE.pcie_blk_locn PARAM_VALUE.enable_code} {
    set c_xfamily        [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set c_xdevice        ${PROJECT_PARAM.DEVICE}
    set device           [string toupper $c_xdevice]
    set pcie_blk_locn    [get_property value ${PARAM_VALUE.pcie_blk_locn}]
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type}]
    set enable_code [string toupper [get_property value ${PARAM_VALUE.enable_code}]]
    set mcap_enablement ${PARAM_VALUE.mcap_enablement}

    if {$c_xfamily == "virtexuplus" || $c_xfamily == "kintexuplus" || $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
        if {[get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
          ## Disable if in Root Mode
          set_property enabled false $mcap_enablement
          set_property range_value "None,None" $mcap_enablement
        } elseif {($device == "XCVU13P") && ($pcie_blk_locn == "X0Y1")} { 
	  set_property enabled true $mcap_enablement
          set_property range_value "None,None,Tandem_PROM,Tandem_PCIe,Tandem_PCIe_with_Field_Updates,PR_over_PCIe" $mcap_enablement
        } elseif {($device == "XCKU15P" || $device == "XCVU7P" || $device == "XCZU19EG" ) && ($pcie_blk_locn == "X1Y0")} { 
          # Enable for PCIe X1Y0 location
	  set_property enabled true $mcap_enablement
          set_property range_value "None,None,Tandem_PROM,Tandem_PCIe,Tandem_PCIe_with_Field_Updates,PR_over_PCIe" $mcap_enablement
        } elseif {($device == "XCVU3P") && ($pcie_blk_locn == "X1Y0")} { 
          # Enable for PCIe X1Y0 location
	  set_property enabled true $mcap_enablement
          set_property range_value "None,None,Tandem_PROM,Tandem_PCIe,Tandem_PCIe_with_Field_Updates,PR_over_PCIe" $mcap_enablement
        } elseif {($device == "XCVU9P") && ($pcie_blk_locn == "X1Y2")} {
          # Enable for PCIe X1Y2 location
	  set_property enabled true $mcap_enablement
          set_property range_value "None,None,Tandem_PROM,Tandem_PCIe,Tandem_PCIe_with_Field_Updates,PR_over_PCIe" $mcap_enablement
        } else {
          ## Otherwise disable and set to None
          set_property enabled false $mcap_enablement
          set_property range "None,None"  $mcap_enablement
        }
    } elseif {$c_xfamily == "virtexu" || $c_xfamily == "kintexu"} {
    if {$device_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
        set_property enabled false ${PARAM_VALUE.mcap_enablement}
        set_property range "None,Tandem,Tandem_with_Field_Updates,PR_over_PCIe"  ${PARAM_VALUE.mcap_enablement}
    } elseif {($device == "XCKU025" || $device == "XCKU035" || $device == "XCKU040" || $device == "XCKU060" || $device == "XCKU085" || $device == "XCKU095" || $device == "XCKU115" || $device == "XCVU065" || $device == "XCVU080" || $device == "XCVU095" || $device == "XCVU125") && ($pcie_blk_locn == "X0Y0")} {
        set_property enabled true ${PARAM_VALUE.mcap_enablement}
        set_property range "None,Tandem,Tandem_with_Field_Updates,PR_over_PCIe"  ${PARAM_VALUE.mcap_enablement}
    } elseif {($device == "XCVU160") && ($pcie_blk_locn == "X0Y1")} {
        set_property enabled true ${PARAM_VALUE.mcap_enablement}
        set_property range "None,Tandem,Tandem_with_Field_Updates,PR_over_PCIe"  ${PARAM_VALUE.mcap_enablement}
    } elseif {($device == "XCVU190" || $device == "XCVU440") && ($pcie_blk_locn == "X0Y2")} {
        set_property enabled true ${PARAM_VALUE.mcap_enablement}
        set_property range "None,Tandem,Tandem_with_Field_Updates,PR_over_PCIe"  ${PARAM_VALUE.mcap_enablement}
    } else {
        set_property enabled false ${PARAM_VALUE.mcap_enablement}
        set_property range "None,Tandem,Tandem_with_Field_Updates,PR_over_PCIe"  ${PARAM_VALUE.mcap_enablement}
    }
    } else  {
        if {$device_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
            set_property enabled false ${PARAM_VALUE.mcap_enablement}
            set_property range "None,None"  ${PARAM_VALUE.mcap_enablement}
        } elseif {($device == "XC7VX415T") || ($device == "XC7VX550T") || ($device == "XC7VX690T") || ($device == "XQ7VX690T") || ($device == "XC7VX330T") || ($device == "XC7VX980T") } {
            set_property enabled false ${PARAM_VALUE.mcap_enablement}
            set_property range "None,Tandem_PROM_(Refer_PG023),Tandem_PCIe_(Refer_PG023)"  ${PARAM_VALUE.mcap_enablement}
        } else {
            set_property enabled false ${PARAM_VALUE.mcap_enablement}
            set_property range "None,Tandem_PROM_(Refer_PG023),Tandem_PCIe_(Refer_PG023)"  ${PARAM_VALUE.mcap_enablement}
        }
    }
}

proc update_PARAM_VALUE.enable_code { PARAM_VALUE.enable_code PARAM_VALUE.device_port_type} {
  # Procedure called to update enable_code when any of the dependent parameters in the arguments change
  set enable_code ${PARAM_VALUE.enable_code}

  if {[get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
      set_property enabled false $enable_code
      set_property value "0000" $enable_code
  } else {
      set_property enabled TRUE $enable_code
  } 
}

proc Base_class_value_text_UPDATE {PARAM_VALUE.pf0_base_class_menu } {

    set base_class_text_value [get_property value  ${PARAM_VALUE.pf0_base_class_menu}]
    set base_class_hex_value [get_base_class_hex_values $base_class_text_value]
    return $base_class_hex_value

}

proc interface_value_text_UPDATE  {PARAM_VALUE.pf0_base_class_menu PARAM_VALUE.pf0_sub_class_interface_menu } {

    set base_class_text_value [get_property value  ${PARAM_VALUE.pf0_base_class_menu}]
    set sub_class_interface_menu [get_property value  ${PARAM_VALUE.pf0_sub_class_interface_menu}]
    set interface_value [ cal_using_base_class  $base_class_text_value interface_value  $sub_class_interface_menu ]

    return "$interface_value"
}

proc sub_class_value_text_UPDATE  {PARAM_VALUE.pf0_base_class_menu PARAM_VALUE.pf0_sub_class_interface_menu } {

    set base_class_text_value [get_property value  ${PARAM_VALUE.pf0_base_class_menu}]
    set sub_class_interface_menu [get_property value  ${PARAM_VALUE.pf0_sub_class_interface_menu}]
    set sub_class_value [ cal_using_base_class  $base_class_text_value sub_class_value  $sub_class_interface_menu  ]

    return "$sub_class_value"
}

proc PF1_Base_class_value_text_UPDATE {PARAM_VALUE.pf1_base_class_menu } {

    set base_class_text_value [get_property value  ${PARAM_VALUE.pf1_base_class_menu}]
    set base_class_hex_value [get_base_class_hex_values $base_class_text_value]
    return $base_class_hex_value

}

proc PF1_interface_value_text_UPDATE  {PARAM_VALUE.pf1_base_class_menu PARAM_VALUE.pf1_sub_class_interface_menu } {

    set base_class_text_value [get_property value  ${PARAM_VALUE.pf1_base_class_menu}]
    set sub_class_interface_menu [get_property value  ${PARAM_VALUE.pf1_sub_class_interface_menu}]
    set interface_value [ cal_using_base_class  $base_class_text_value interface_value  $sub_class_interface_menu ]

    return "$interface_value"
}

proc PF1_sub_class_value_text_UPDATE  {PARAM_VALUE.pf1_base_class_menu PARAM_VALUE.pf1_sub_class_interface_menu } {

    set base_class_text_value [get_property value  ${PARAM_VALUE.pf1_base_class_menu}]
    set sub_class_interface_menu [get_property value  ${PARAM_VALUE.pf1_sub_class_interface_menu}]
    set sub_class_value [ cal_using_base_class  $base_class_text_value sub_class_value  $sub_class_interface_menu  ]

    return "$sub_class_value"
}



######################################
## PCIE0_BAR_PANE procs
########################################
proc populate_A { size scale en_64 val n}    {

    set powerof2   [expr int ( (log( $size))/ log(2) )]
    set bit_list_64 [split $val ""]

    if {$en_64 } {
        set loop_bits     60
    } else {
        set loop_bits    28
    }

    switch $scale {
        "Bytes"      { set scale_X  0  }
        "Kilobytes"  { set scale_X  10 }
        "Megabytes"  { set scale_X  20 }
        "Gigabytes"  { set scale_X  30 }
        "Terabytes"  { set scale_X  40 }
        "Petabytes"  { set scale_X  50 }
        "Exabytes"   { set scale_X  60 }
        default  { set scale_X  10 }
    }

    set val_size_scale  [expr   $scale_X +  $powerof2 - 4]

    for {set i 0  } { $i  < $loop_bits } {incr i } {
        if { $i < $val_size_scale } {
            set append_bit 0
        } else {
            set append_bit 1
        }
        set bit_list_64 [linsert $bit_list_64 0  $append_bit ]
    }

    if { $en_64 } {
        if {$n == 0} {
            set bit_strem_32 [join [lrange $bit_list_64 32 63 ] ""]
        } else {
            set bit_strem_32  [join [lrange $bit_list_64  0 31 ] ""]
        }
    } else {
        set bit_strem_32 [join  $bit_list_64 ""]
    }
    set hex_val [ipgen::number_utils::bin2hex $bit_strem_32 ]
    return [format %08s $hex_val]
 }

#####################################
## EVEN
####################33

proc update_PARAM_VALUE.pciebar2axibar_axil_master {PARAM_VALUE.axilite_master_en PARAM_VALUE.pciebar2axibar_axil_master} {
    set_property enabled [get_property value ${PARAM_VALUE.axilite_master_en}]  ${PARAM_VALUE.pciebar2axibar_axil_master}
}

proc update_PARAM_VALUE.pciebar2axibar_axist_bypass {PARAM_VALUE.axist_bypass_en PARAM_VALUE.pciebar2axibar_axist_bypass} {
    set_property enabled [get_property value ${PARAM_VALUE.axist_bypass_en}]  ${PARAM_VALUE.pciebar2axibar_axist_bypass}
}

proc update_PARAM_VALUE.axilite_master_size {PARAM_VALUE.axilite_master_en PARAM_VALUE.axilite_master_size PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.axilite_master_scale PARAM_VALUE.axil_master_64bit_en PARAM_VALUE.mult_pf_des} {

    set enable_val [get_property value ${PARAM_VALUE.axilite_master_en}]
    set val_scale [get_property value ${PARAM_VALUE.axilite_master_scale}]
    set enable_64bit [get_property value ${PARAM_VALUE.axil_master_64bit_en}]
    set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXUPLUS"  ||  $c_xfamily eq "KINTEXUPLUS" ||  $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
        set is_usplus "TRUE"
    } else {
        set is_usplus "FALSE"
    }

# AXI Lite doesn't support 32-bit AXI Address, therefore limit to BAR Size addressable with 32-bit only even when 64-bit PCIe BAR is enabled
#    set curr_range [get_size_range $enable_val $enable_64bit $val_scale $is_usplus ]
    set curr_range [get_size_range $enable_val $enable_64bit $val_scale $is_usplus ]
    if {$enable_val } {
        set_property enabled true ${PARAM_VALUE.axilite_master_size}
        set_property range $curr_range ${PARAM_VALUE.axilite_master_size}
    if {$mult_pf_des_val } {
          ##set_property value 32 ${PARAM_VALUE.axilite_master_size}
          ##set_property enabled false ${PARAM_VALUE.axilite_master_size}
    }
    } else {
        set_property enabled false ${PARAM_VALUE.axilite_master_size}
        set_property range $curr_range ${PARAM_VALUE.axilite_master_size}
    }
}

proc update_PARAM_VALUE.axilite_master_scale {PARAM_VALUE.axilite_master_en PARAM_VALUE.axilite_master_scale PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.axil_master_64bit_en PARAM_VALUE.mult_pf_des} {
    set enable_val [get_property value ${PARAM_VALUE.axilite_master_en}]
    set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]
    set enable_64bit [get_property value ${PARAM_VALUE.axil_master_64bit_en}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXUPLUS"  ||  $c_xfamily eq "KINTEXUPLUS" ||  $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
		set is_usplus "TRUE"
	} else {
		set is_usplus "FALSE"
	}
	if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
		set_property range "Kilobytes,Megabytes,Gigabytes,Terabytes,Petabytes,Exabytes" ${PARAM_VALUE.axilite_master_scale}
	} else {
		set_property range "Kilobytes,Megabytes,Gigabytes" ${PARAM_VALUE.axilite_master_scale}
	}
    if {$enable_val } {
          set_property enabled true ${PARAM_VALUE.axilite_master_scale}
	if {$mult_pf_des_val } {
          ##set_property enabled false ${PARAM_VALUE.axilite_master_scale}
	}
    } else {
        set_property enabled false ${PARAM_VALUE.axilite_master_scale}
    }
}

proc validate_PARAM_VALUE.axilite_master_en  { PARAM_VALUE.axilite_master_en PARAM_VALUE.xdma_en PARAM_VALUE.axist_bypass_en } {

    set en_0 [get_property value ${PARAM_VALUE.axilite_master_en}]
    set en_1 [get_property value ${PARAM_VALUE.xdma_en}]
    set en_2 [get_property value ${PARAM_VALUE.axist_bypass_en}]

    if {(!$en_0) && (!$en_1) && (!$en_2)} {
        set_property errmsg "Invalid configuration at least one PCIE bar has to be enabled " ${PARAM_VALUE.axilite_master_en}
        return false
    }
    return true
}

proc update_PARAM_VALUE.axist_bypass_en {PARAM_VALUE.axist_bypass_en PARAM_VALUE.mult_pf_des PARAM_VALUE.en_dma_and_bridge } {
    set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]
    set en_dma_and_bridge [get_property value ${PARAM_VALUE.en_dma_and_bridge}]
    if {$mult_pf_des_val || $en_dma_and_bridge } {
        ##set_property enabled false ${PARAM_VALUE.axist_bypass_en}
        ##set_property value true ${PARAM_VALUE.axist_bypass_en}
        set_property enabled false ${PARAM_VALUE.axist_bypass_en}
        set_property value true ${PARAM_VALUE.axist_bypass_en}
    } else {
        set_property enabled true ${PARAM_VALUE.axist_bypass_en}
        set_property value false ${PARAM_VALUE.axist_bypass_en}
    }
}

proc update_PARAM_VALUE.axist_bypass_size {PARAM_VALUE.axist_bypass_en PARAM_VALUE.axist_bypass_size PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.axist_bypass_scale PARAM_VALUE.axi_bypass_64bit_en PARAM_VALUE.mult_pf_des} {

    set enable_val [get_property value ${PARAM_VALUE.axist_bypass_en}]
    set val_scale [get_property value ${PARAM_VALUE.axist_bypass_scale}]
    set enable_64bit [get_property value ${PARAM_VALUE.axi_bypass_64bit_en}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXUPLUS"  ||  $c_xfamily eq "KINTEXUPLUS" ||  $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
        set is_usplus "TRUE"
    } else {
        set is_usplus "FALSE"
    }
    set curr_range [get_size_range $enable_val $enable_64bit $val_scale $is_usplus]
    set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]

    if {$mult_pf_des_val } {
        set_property enabled true ${PARAM_VALUE.axist_bypass_size}
        set_property range $curr_range ${PARAM_VALUE.axist_bypass_size}
	##set_property value 128 ${PARAM_VALUE.axist_bypass_size} 
    } elseif {$enable_val } {
        set_property enabled true ${PARAM_VALUE.axist_bypass_size}
        set_property range $curr_range ${PARAM_VALUE.axist_bypass_size}
    } else {
        set_property enabled false ${PARAM_VALUE.axist_bypass_size}
        set_property range $curr_range ${PARAM_VALUE.axist_bypass_size}
    }
}

proc update_PARAM_VALUE.axist_bypass_scale {PARAM_VALUE.axist_bypass_en PARAM_VALUE.axi_bypass_64bit_en PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.axist_bypass_scale PARAM_VALUE.mult_pf_des} {
    set enable_val [get_property value ${PARAM_VALUE.axist_bypass_en}]
    set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]
    set enable_64bit [get_property value ${PARAM_VALUE.axi_bypass_64bit_en}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXUPLUS"  ||  $c_xfamily eq "KINTEXUPLUS" ||  $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
        set is_usplus "TRUE"
    } else {
        set is_usplus "FALSE"
    }
    if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
        set_property range "Kilobytes,Megabytes,Gigabytes,Terabytes,Petabytes,Exabytes" ${PARAM_VALUE.axist_bypass_scale}
    } else {
        set_property range "Kilobytes,Megabytes,Gigabytes" ${PARAM_VALUE.axist_bypass_scale}
    }
    if {$mult_pf_des_val } {
        set_property enabled true ${PARAM_VALUE.axist_bypass_scale}
        #set_property value "Gigabytes" ${PARAM_VALUE.axist_bypass_scale}
    } elseif {$enable_val } {
        set_property enabled true ${PARAM_VALUE.axist_bypass_scale}
    } else {
        set_property enabled false ${PARAM_VALUE.axist_bypass_scale}
    }
}

set AXI_BAR_PANEL_updates {

  ######### axi_validation procs
  proc validate_PARAM_VALUE.axibar_<<n>>  {PARAM_VALUE.axibar_<<n>> } {
    return [RangeCheck4HexDec  0 FFFFFFFFFFFFFFFF ${PARAM_VALUE.axibar_<<n>>}]
  }
		
  proc validate_PARAM_VALUE.axibar_highaddr_<<n>> {PARAM_VALUE.axibar_highaddr_<<n>> } {
    return [RangeCheck4HexDec  0 FFFFFFFFFFFFFFFF ${PARAM_VALUE.axibar_highaddr_<<n>>}]
  }
		
  proc validate_PARAM_VALUE.axibar2pciebar_<<n>> {PARAM_VALUE.axibar2pciebar_<<n>> PARAM_VALUE.axibar_highaddr_<<n>>  PARAM_VALUE.axibar_<<n>>} {
    set max [get_property value ${PARAM_VALUE.axibar_highaddr_<<n>>}]
    set min [get_property value ${PARAM_VALUE.axibar_<<n>>} ]
    set MinValue $min
    set MaxValue $max
    if {[string toupper [string range  $MinValue  1 1] ]eq "X" } { 
      set MinValue [string range $MinValue  2 end]
    } 
    if {[string toupper [string range  $MaxValue  1 1] ]eq "X" } { 
      set MaxValue [string range $MaxValue  2 end]
    }  
    set diff [expr [ipgen::number_utils::hex2dec $MaxValue ] - [ipgen::number_utils::hex2dec  $MinValue ] ]
    if {$diff < 0 } { set diff [expr $diff * -1 ] } 
      set n_bits [string length [string trimleft  [ipgen::number_utils::dec2bin  $diff ] "0" ] ] 
      set val [get_property value ${PARAM_VALUE.axibar2pciebar_<<n>>}]
      if {[string toupper [string range  $val  1 1] ]eq "X" } { 
        set val [string range $val  2 end]
      } 
      set val_bin [ipgen::number_utils::hex2bin $val]  
      #send_msg INFO 912 "msg n_bits:  $n_bits MinValue : $MinValue /MaxValue : $MaxValue diff $diff    val $val"
      if { $n_bits != 0 } { 
        set val_lower_n  [ipgen::number_utils::bin2dec [ expr [string range  $val_bin end-[expr $n_bits -1] end] ] ]
      }  
      if { $n_bits != 0 } { 
	if {$val_lower_n == 0  } {
	  return [RangeCheck4HexDec 0 FFFFFFFFFFFFFFFF ${PARAM_VALUE.axibar2pciebar_<<n>>} ]
	} else  {
	  set_property errmsg "Entered  Hexadecimal value $val must have lower $n_bits should be 0 " ${PARAM_VALUE.axibar2pciebar_<<n>>} 
	  return false 
	} 
      } else { 
	return [RangeCheck4HexDec 0 FFFFFFFFFFFFFFFF ${PARAM_VALUE.axibar2pciebar_<<n>>} ]
      } 
      return true	 
  }
			 
  proc update_PARAM_VALUE.axibar_<<n>> {PARAM_VALUE.AXIBAR_NUM PARAM_VALUE.axibar_<<n>>} {
    set panel_val [get_property value ${PARAM_VALUE.AXIBAR_NUM}]
    if {$panel_val > <<n>> } { 
      set_property enabled true ${PARAM_VALUE.axibar_<<n>>}
    } else { 
      set_property enabled false ${PARAM_VALUE.axibar_<<n>>}
    }
  }

  proc update_PARAM_VALUE.axibar_highaddr_<<n>> {PARAM_VALUE.AXIBAR_NUM PARAM_VALUE.axibar_highaddr_<<n>> } {
    set panel_val [get_property value ${PARAM_VALUE.AXIBAR_NUM}]
    if {$panel_val > <<n>> } { 
      set_property enabled true ${PARAM_VALUE.axibar_highaddr_<<n>>}
    } else { 
      set_property enabled false ${PARAM_VALUE.axibar_highaddr_<<n>>} 
    }
  }

  proc update_PARAM_VALUE.axibar2pciebar_<<n>> {PARAM_VALUE.AXIBAR_NUM PARAM_VALUE.axibar2pciebar_<<n>>} {
    set panel_val [get_property value ${PARAM_VALUE.AXIBAR_NUM}]
    if {$panel_val > <<n>>} { 
      set_property enabled true ${PARAM_VALUE.axibar2pciebar_<<n>>}
    } else { 
      set_property enabled false ${PARAM_VALUE.axibar2pciebar_<<n>>}
    }
  }
}

foreach i {0 1 2 3 4 5} {
  set PR [regsub -all <<n>> $AXI_BAR_PANEL_updates $i ]
  eval $PR
}

#####################################  		
## EVEN
####################33	
set PCIE_BAR_PANEL_EVEN_updates {

  proc update_PARAM_VALUE.pciebar2axibar_<<n>> {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pciebar2axibar_<<n>>} {
    set_property enabled  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}]  ${PARAM_VALUE.pciebar2axibar_<<n>>}
  }

  proc validate_PARAM_VALUE.pciebar2axibar_<<n>>  {PARAM_VALUE.pciebar2axibar_<<n>> PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_64bit PARAM_VALUE.pf0_bar<<n>>_scale PARAM_VALUE.pf0_bar<<n>>_size } { 
	       
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}] 
    set enable_64bit [get_property value ${PARAM_VALUE.pf0_bar<<n>>_64bit}]
    set size  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_size}]
    set scale [get_property value ${PARAM_VALUE.pf0_bar<<n>>_scale}]
    set val 0000
    set val_hex_32_0  [populate_A $size $scale $enable_64bit $val 0 ]
    set val_hex_32_1  [populate_A $size $scale $enable_64bit $val 1 ]

    if {$enable_64bit} {
      set v_64 [join "$val_hex_32_1 $val_hex_32_0" "" ]
    } else {
      set val_hex_32_null "00000000"
      set v_64 [join "$val_hex_32_null $val_hex_32_0"  "" ]
    }
    #send_msg INFO 99123 "enable_val $enable_val enable_64bit $enable_64bit size $size $scale  val $val val_hex_32_0 $val_hex_32_0 val_hex_32_1 $val_hex_32_1 "

    #set low_nib
    set val_curr [get_property value  ${PARAM_VALUE.pciebar2axibar_<<n>>} ]
    set val_lower_n  [ipgen::number_utils::hex2dec  [string range $val_curr end-3 end ]  ]
    if {([get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}]) && ($val_lower_n != 0 ) && (($scale  eq "Megabytes" )  || ($scale  eq  "Gigabytes" ))}    {
      set_property errmsg "Entered  Hexadecimal value must have lower 4 digits as 0  " ${PARAM_VALUE.pciebar2axibar_<<n>>}
      return  false 
    } elseif {[get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}] } { 
      return [RangeCheck4HexDec  0 $v_64 ${PARAM_VALUE.pciebar2axibar_<<n>>}] 
    } else {
      return true
    }
  }

  proc update_PARAM_VALUE.pf0_bar<<n>>_type {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_type} {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}]
    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf0_bar<<n>>_type}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf0_bar<<n>>_type} 
    }
  }
			 
  proc update_PARAM_VALUE.pf0_bar<<n>>_64bit {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_64bit PARAM_VALUE.pf0_bar<<n>>_type } {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}]
    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf0_bar<<n>>_64bit}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf0_bar<<n>>_64bit} 
      set_property value false ${PARAM_VALUE.pf0_bar<<n>>_64bit} 
    }
  }
			 
  proc update_PARAM_VALUE.pf0_bar<<n>>_prefetchable {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_prefetchable PARAM_VALUE.pf0_bar<<n>>_type PARAM_VALUE.pf0_bar<<n>>_64bit} {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}]
    set bar_type [get_property value ${PARAM_VALUE.pf0_bar<<n>>_type}]
    set enable_64bit [get_property value ${PARAM_VALUE.pf0_bar<<n>>_64bit}]

    if {$enable_val &&($bar_type eq "Memory")&& $enable_64bit} { 
      set_property enabled true ${PARAM_VALUE.pf0_bar<<n>>_prefetchable}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf0_bar<<n>>_prefetchable} 
      set_property value false ${PARAM_VALUE.pf0_bar<<n>>_prefetchable} 
    }
  }

  proc update_PARAM_VALUE.pf0_bar<<n>>_size {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_size PARAM_VALUE.pf0_bar<<n>>_scale PARAM_VALUE.pf0_bar<<n>>_64bit PARAM_VALUE.pf0_bar<<n>>_type PARAM_VALUE.bar<<n>>_indicator PARAM_VALUE.axi_addr_width PROJECT_PARAM.ARCHITECTURE} {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}] 
    set val_scale [get_property value ${PARAM_VALUE.pf0_bar<<n>>_scale}]
    set enable_64bit [get_property value ${PARAM_VALUE.pf0_bar<<n>>_64bit}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_type}] 
    set bar_indicator [get_property value ${PARAM_VALUE.bar<<n>>_indicator}]
    set axi_addr_width [get_property value ${PARAM_VALUE.axi_addr_width}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXUPLUS"  ||  $c_xfamily eq "KINTEXUPLUS" ||  $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
        set is_usplus "TRUE"
    } else {
        set is_usplus "FALSE"
    }

    set curr_range [get_size_range_br $enable_val $enable_64bit $bar_Type $val_scale $bar_indicator $axi_addr_width $is_usplus]

    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf0_bar<<n>>_size}
      set_property range_value $curr_range ${PARAM_VALUE.pf0_bar<<n>>_size}
      #set_property range $curr_range ${PARAM_VALUE.pf0_bar<<n>>_size}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf0_bar<<n>>_size} 
      set_property range_value $curr_range ${PARAM_VALUE.pf0_bar<<n>>_size}
      #set_property range $curr_range ${PARAM_VALUE.pf0_bar<<n>>_size}
    }
  }

  proc update_PARAM_VALUE.pf0_bar<<n>>_scale {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_scale PARAM_VALUE.pf0_bar<<n>>_64bit PARAM_VALUE.axi_addr_width PROJECT_PARAM.ARCHITECTURE} {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}]
    set enable_64bit [get_property value ${PARAM_VALUE.pf0_bar<<n>>_64bit}]
    set axi_addr_width [get_property value ${PARAM_VALUE.axi_addr_width}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXUPLUS"  ||  $c_xfamily eq "KINTEXUPLUS" ||  $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
        set is_usplus "TRUE"
    } else {
        set is_usplus "FALSE"
    }
    if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
        if {$axi_addr_width >= 40 && $axi_addr_width < 50} {
            set_property range "Kilobytes,Megabytes,Gigabytes,Terabytes" ${PARAM_VALUE.pf0_bar<<n>>_scale}
        } elseif {$axi_addr_width >= 50 && $axi_addr_width < 60} {
            set_property range "Kilobytes,Megabytes,Gigabytes,Terabytes,Petabytes" ${PARAM_VALUE.pf0_bar<<n>>_scale}
        } elseif {$axi_addr_width >= 60} {
            set_property range "Kilobytes,Megabytes,Gigabytes,Terabytes,Petabytes,Exabytes" ${PARAM_VALUE.pf0_bar<<n>>_scale}
        } else {
            set_property range "Kilobytes,Megabytes,Gigabytes" ${PARAM_VALUE.pf0_bar<<n>>_scale}
        }
    } else {
        set_property range "Kilobytes,Megabytes,Gigabytes" ${PARAM_VALUE.pf0_bar<<n>>_scale}
    }
    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf0_bar<<n>>_scale}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf0_bar<<n>>_scale} 
    }
  }
			
  proc DT_pf0_bar_value<<n>> { PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_type PARAM_VALUE.pf0_bar<<n>>_64bit PARAM_VALUE.pf0_bar<<n>>_prefetchable PARAM_VALUE.pf0_bar<<n>>_scale PARAM_VALUE.pf0_bar<<n>>_size} {
			
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}] 
    set enable_64bit [get_property value ${PARAM_VALUE.pf0_bar<<n>>_64bit}]
    set prefetchable  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_prefetchable}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_type}] 
    set size  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_size}]
    set scale [get_property value ${PARAM_VALUE.pf0_bar<<n>>_scale}]
    set val  "FFFFF000"
				
    if {$enable_val } { 
      switch $bar_Type {
        "IO" {
          set val  "0001"
        }
        "Memory"	{
          if {!$enable_64bit } {
            set val  "0000"
          } elseif {$enable_64bit && (!$prefetchable)} {
            set val  "0100"
          } elseif {$enable_64bit && $prefetchable} {
            set val  "1100"
          } else { 
            set val  "0000" 			
          }
        }							
      }
    } else { 
      set val  "0000" 
    }
          if {$enable_64bit } {
              set val_hex_64_0  [populate_A $size $scale $enable_64bit $val 0 ]
              set val_hex_64_1  [populate_A $size $scale $enable_64bit $val 1 ]
              set v_64 [join "$val_hex_64_1 $val_hex_64_0" "" ]
	  } else {
              set v_64  [populate_A $size $scale $enable_64bit $val 0 ]
	  }
    send_msg INFO 1 " Val_hex_64:$v_64"
      return $v_64

  }
			
  proc update_MODELPARAM_VALUE.PF0_BAR<<n>>_CONTROL {MODELPARAM_VALUE.PF0_BAR<<n>>_CONTROL PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_type PARAM_VALUE.pf0_bar<<n>>_type PARAM_VALUE.pf0_bar<<n>>_64bit PARAM_VALUE.pf0_bar<<n>>_prefetchable} {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}] 
    set enable_64bit [get_property value ${PARAM_VALUE.pf0_bar<<n>>_64bit}]
    set prefetchable  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_prefetchable}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_type}] 
    set val  "000"

    if {$enable_val } { 
      switch $bar_Type {
        "IO" {
          set val  0x0
        }
        "Memory"	{
          if {$enable_64bit && ($prefetchable)} {
            set val 0x7
          } elseif {$enable_64bit && (!$prefetchable)} {
            set val 0x6
          } elseif { (!$enable_64bit) && (!$prefetchable)} {
            set val 0x4
          } else { 
            set val 0x5 
          }
        }										
      }
    } else { 
      set val  0x0
    }
    set_property value  $val ${MODELPARAM_VALUE.PF0_BAR<<n>>_CONTROL}
  }	 
		
  proc validate_PARAM_VALUE.pf0_bar<<n>>_enabled  { PARAM_VALUE.pf0_bar0_enabled PARAM_VALUE.pf0_bar1_enabled PARAM_VALUE.pf0_bar2_enabled PARAM_VALUE.pf0_bar3_enabled PARAM_VALUE.pf0_bar4_enabled PARAM_VALUE.pf0_bar5_enabled PARAM_VALUE.device_port_type  } {

    set dev_port_type [get_property value ${PARAM_VALUE.device_port_type} ]
    # RP is allowed to have no BAR enabled
    if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
      return true 
    } else {
      set en_0 [get_property value ${PARAM_VALUE.pf0_bar0_enabled}] 
      set en_1 [get_property value ${PARAM_VALUE.pf0_bar1_enabled}] 
      set en_2 [get_property value ${PARAM_VALUE.pf0_bar2_enabled}] 
      set en_3 [get_property value ${PARAM_VALUE.pf0_bar3_enabled}] 
      set en_4 [get_property value ${PARAM_VALUE.pf0_bar4_enabled}] 
      set en_5 [get_property value ${PARAM_VALUE.pf0_bar5_enabled}] 
      if {(!$en_0) && (!$en_1) && (!$en_2) && (!$en_3) && (!$en_4) && (!$en_5)} {
        set_property errmsg " invalid configuration at least one PCIE bar has to be enabled " ${PARAM_VALUE.pf0_bar<<n>>_enabled}
        return false 
      }
      return true  		
   }
  }
}

##########
## ODD	
#####################################  			
set PCIE_BAR_PANEL_ODD_updates {
				 
  proc update_PARAM_VALUE.pciebar2axibar_<<n>> {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pciebar2axibar_<<n>>} {
    set_property enabled  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}]  ${PARAM_VALUE.pciebar2axibar_<<n>>}
  }

  proc validate_PARAM_VALUE.pciebar2axibar_<<n>>  {PARAM_VALUE.pciebar2axibar_<<n>> PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_scale PARAM_VALUE.pf0_bar<<n>>_size } { 
													 
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}] 
    set enable_64bit 0
    set size  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_size}]
    set scale [get_property value ${PARAM_VALUE.pf0_bar<<n>>_scale}]
    set val 0000 
		    	
    set val_hex_32_0  [populate_A $size $scale $enable_64bit $val 0 ]
    set val_hex_32_null "00000000"
    set v_64 [join "$val_hex_32_null $val_hex_32_0"  "" ]
    
    if { $enable_val } { 
      return [RangeCheck4HexDec  0 $v_64 ${PARAM_VALUE.pciebar2axibar_<<n>>}] 
    } else {
      return true
    }
  }

  proc update_PARAM_VALUE.pf0_bar<<n>>_type {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_type} {
				
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}]
    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf0_bar<<n>>_type}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf0_bar<<n>>_type} 
    }
  }
			 
  proc update_PARAM_VALUE.pf0_bar<<n>>_prefetchable {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_prefetchable PARAM_VALUE.pf0_bar<<n>>_type } {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}]
    set bar_type [get_property value ${PARAM_VALUE.pf0_bar<<n>>_type}]

    if {$enable_val &&($bar_type eq "Memory")} { 
      set_property enabled true ${PARAM_VALUE.pf0_bar<<n>>_prefetchable}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf0_bar<<n>>_prefetchable} 
      set_property value false ${PARAM_VALUE.pf0_bar<<n>>_prefetchable} 
    }
  }

  proc update_PARAM_VALUE.pf0_bar<<n>>_size {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_size PARAM_VALUE.pf0_bar<<n>>_scale  PARAM_VALUE.pf0_bar<<n>>_type PARAM_VALUE.bar<<n>>_indicator PARAM_VALUE.axi_addr_width PROJECT_PARAM.ARCHITECTURE} {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}] 
    set val_scale [get_property value ${PARAM_VALUE.pf0_bar<<n>>_scale}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_type}] 
    set bar_indicator [get_property value ${PARAM_VALUE.bar<<n>>_indicator}]
    set axi_addr_width [get_property value ${PARAM_VALUE.axi_addr_width}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXUPLUS"  ||  $c_xfamily eq "KINTEXUPLUS" ||  $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
        set is_usplus "TRUE"
    } else {
        set is_usplus "FALSE"
    }

    set curr_range [get_size_range_br $enable_val 0 $bar_Type $val_scale $bar_indicator $axi_addr_width $is_usplus]

    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf0_bar<<n>>_size}
      set_property range_value $curr_range ${PARAM_VALUE.pf0_bar<<n>>_size}
      #set_property range $curr_range ${PARAM_VALUE.pf0_bar<<n>>_size}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf0_bar<<n>>_size} 
      set_property range_value $curr_range ${PARAM_VALUE.pf0_bar<<n>>_size}
      #set_property range $curr_range ${PARAM_VALUE.pf0_bar<<n>>_size}
    }
  }
			 
  proc update_PARAM_VALUE.pf0_bar<<n>>_scale {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_scale} {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}]
    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf0_bar<<n>>_scale}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf0_bar<<n>>_scale} 
    }
  }
			
  proc update_MODELPARAM_VALUE.PF0_BAR<<n>>_CONTROL {MODELPARAM_VALUE.PF0_BAR<<n>>_CONTROL PARAM_VALUE.pf0_bar<<n>>_enabled  PARAM_VALUE.pf0_bar<<n>>_type PARAM_VALUE.pf0_bar<<n>>_prefetchable} {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}] 
    set enable_64bit  0
    set prefetchable  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_prefetchable}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_type}] 
    set val  "000"
    
    if {$enable_val } { 
      switch $bar_Type {
        "IO" {
          set val  0x0
        }
        "Memory"	{
          if {$enable_64bit && ($prefetchable)} {
            set val 0x7
          } elseif {$enable_64bit && (!$prefetchable)} {
            set val 0x6
          } elseif { (!$enable_64bit) && (!$prefetchable)} {
            set val 0x4
          } else { 
            set val 0x5 
          }
        }										
      }
    } else { 
      set val  0x0
    }
    set_property value  $val ${MODELPARAM_VALUE.PF0_BAR<<n>>_CONTROL}
  }	
		
  proc validate_PARAM_VALUE.pf0_bar<<n>>_enabled {PARAM_VALUE.pf0_bar0_enabled PARAM_VALUE.pf0_bar1_enabled PARAM_VALUE.pf0_bar2_enabled PARAM_VALUE.pf0_bar3_enabled PARAM_VALUE.pf0_bar4_enabled PARAM_VALUE.pf0_bar5_enabled PARAM_VALUE.device_port_type} {

    set dev_port_type [get_property value ${PARAM_VALUE.device_port_type}]
			# RP is allowed to have no BAR enabled
    if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
      return true 
    } else {
      set en_0 [get_property value ${PARAM_VALUE.pf0_bar0_enabled}] 
      set en_1 [get_property value ${PARAM_VALUE.pf0_bar1_enabled}] 
      set en_2 [get_property value ${PARAM_VALUE.pf0_bar2_enabled}] 
      set en_3 [get_property value ${PARAM_VALUE.pf0_bar3_enabled}] 
      set en_4 [get_property value ${PARAM_VALUE.pf0_bar4_enabled}] 
      set en_5 [get_property value ${PARAM_VALUE.pf0_bar5_enabled}]
      if {(!$en_0) && (!$en_1) && (!$en_2) && (!$en_3) && (!$en_4) && (!$en_5)} {
        set_property errmsg " invalid configuration at least one PCIE bar has to be enabled " ${PARAM_VALUE.pf0_bar<<n>>_enabled}
        return false 
      }
      return true
    }
  }
}

foreach i {0 2 4} {
  set j [expr $i + 1 ]
  set PR_EVEN [ regsub -all <<n>> $PCIE_BAR_PANEL_EVEN_updates $i ]
  set PR_ODD  [ regsub -all <<n>> $PCIE_BAR_PANEL_ODD_updates $j  ]
  eval $PR_EVEN
  eval $PR_ODD
}

proc update_PARAM_VALUE.pf0_bar5_enabled {PARAM_VALUE.pf0_bar5_enabled PARAM_VALUE.device_port_type} {
  set enable_val [get_property value ${PARAM_VALUE.pf0_bar5_enabled}]
  set dev_port_type [get_property value ${PARAM_VALUE.device_port_type} ]

  if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property enabled false ${PARAM_VALUE.pf0_bar5_enabled}
    set_property value false ${PARAM_VALUE.pf0_bar5_enabled}
  }
}

proc update_PARAM_VALUE.pf0_bar3_enabled {PARAM_VALUE.pf0_bar3_enabled PARAM_VALUE.device_port_type} {
  set enable_val [get_property value ${PARAM_VALUE.pf0_bar3_enabled}]
  set dev_port_type [get_property value ${PARAM_VALUE.device_port_type} ]

  if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property enabled false ${PARAM_VALUE.pf0_bar3_enabled}
    set_property value false ${PARAM_VALUE.pf0_bar3_enabled}
  }
}

proc update_PARAM_VALUE.pf0_bar2_enabled {PARAM_VALUE.pf0_bar2_enabled PARAM_VALUE.pf0_bar1_enabled PARAM_VALUE.pf0_bar0_64bit PARAM_VALUE.pf0_bar0_enabled PARAM_VALUE.device_port_type } {
  set enable_val [get_property value ${PARAM_VALUE.pf0_bar2_enabled}]
  set enable_m1_val [get_property value ${PARAM_VALUE.pf0_bar1_enabled}]
  set enable_64bit [get_property value ${PARAM_VALUE.pf0_bar0_64bit}]
  set enable_m2_val [get_property value ${PARAM_VALUE.pf0_bar0_enabled}]
  set dev_port_type [get_property value ${PARAM_VALUE.device_port_type} ]

  if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property enabled false ${PARAM_VALUE.pf0_bar2_enabled}
    set_property value false ${PARAM_VALUE.pf0_bar2_enabled}
  } else { 
    if {($enable_m1_val ) || ($enable_64bit && $enable_m2_val ) } { 
      set_property enabled true ${PARAM_VALUE.pf0_bar2_enabled}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf0_bar2_enabled}
      set_property value false ${PARAM_VALUE.pf0_bar2_enabled}
    }
  }
}
 
proc update_PARAM_VALUE.pf0_bar4_enabled {PARAM_VALUE.pf0_bar4_enabled PARAM_VALUE.pf0_bar3_enabled PARAM_VALUE.pf0_bar2_64bit PARAM_VALUE.pf0_bar2_enabled PARAM_VALUE.device_port_type   } {
  set enable_val [get_property value ${PARAM_VALUE.pf0_bar4_enabled}]
  set enable_m1_val [get_property value ${PARAM_VALUE.pf0_bar3_enabled}]
  set enable_64bit [get_property value ${PARAM_VALUE.pf0_bar2_64bit}]
  set enable_m2_val [get_property value ${PARAM_VALUE.pf0_bar2_enabled}]
  set dev_port_type [get_property value ${PARAM_VALUE.device_port_type} ]
  
  if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property enabled false ${PARAM_VALUE.pf0_bar4_enabled}
    set_property value false ${PARAM_VALUE.pf0_bar4_enabled}
  } else { 
    if {($enable_m1_val ) || ($enable_64bit && $enable_m2_val )  } { 
      set_property enabled true ${PARAM_VALUE.pf0_bar4_enabled}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf0_bar4_enabled}
      set_property value false ${PARAM_VALUE.pf0_bar4_enabled}
    }
  }
}

set enable_PF0_BARS {
  proc update_PARAM_VALUE.pf0_bar<<n>>_enabled {PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<nm1>>_enabled PARAM_VALUE.pf0_bar<<nm1>>_64bit PARAM_VALUE.en_axi_master_if} {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}]
    set enable_m1_val [get_property value ${PARAM_VALUE.pf0_bar<<nm1>>_enabled}]
    set enable_64bit [get_property value ${PARAM_VALUE.pf0_bar<<nm1>>_64bit}]
    set en_axi_master [get_property value ${PARAM_VALUE.en_axi_master_if}]

    if {$en_axi_master == "false" && <<n>> != 0} { 
      set_property enabled false ${PARAM_VALUE.pf0_bar<<n>>_enabled} 
      set_property value [get_property default_value ${PARAM_VALUE.pf0_bar<<n>>_enabled}] ${PARAM_VALUE.pf0_bar<<n>>_enabled}
    } else { 
      if {$enable_m1_val && !($enable_64bit)} { 
        set_property enabled true ${PARAM_VALUE.pf0_bar<<n>>_enabled}
      } else { 
        set_property enabled false ${PARAM_VALUE.pf0_bar<<n>>_enabled}
        set_property value false ${PARAM_VALUE.pf0_bar<<n>>_enabled}
      }
    }
  }

  proc DT_pf0_bar_value<<n>> { PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_type PARAM_VALUE.pf0_bar<<nm1>>_64bit PARAM_VALUE.pf0_bar<<n>>_prefetchable PARAM_VALUE.pf0_bar<<n>>_scale PARAM_VALUE.pf0_bar<<n>>_size PARAM_VALUE.pf0_bar<<nm1>>_enabled PARAM_VALUE.pf0_bar<<nm1>>_type  PARAM_VALUE.pf0_bar<<nm1>>_prefetchable PARAM_VALUE.pf0_bar<<nm1>>_scale PARAM_VALUE.pf0_bar<<nm1>>_size} {
						
    set enable_64bit [get_property value ${PARAM_VALUE.pf0_bar<<nm1>>_64bit}]
    if {$enable_64bit} {
      set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<nm1>>_enabled}] 
      set prefetchable  [get_property value ${PARAM_VALUE.pf0_bar<<nm1>>_prefetchable}]
      set bar_Type  [get_property value ${PARAM_VALUE.pf0_bar<<nm1>>_type}] 
      set size  [get_property value ${PARAM_VALUE.pf0_bar<<nm1>>_size}]
      set scale [get_property value ${PARAM_VALUE.pf0_bar<<nm1>>_scale}]
    } else {
      set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}] 
      set prefetchable  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_prefetchable}]
      set bar_Type  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_type}] 
      set size  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_size}]
      set scale [get_property value ${PARAM_VALUE.pf0_bar<<n>>_scale}]
    }
    set val  "FFFFF000"

    if {$enable_val } { 
      switch $bar_Type {
        "IO" {
          set val  "0001"
        }
        "Memory"	{
          if {!$enable_64bit } {
            set val  "0000"
          } elseif {$enable_64bit && (!$prefetchable)} {
            set val  "0100"
          } elseif {$enable_64bit && $prefetchable} {
            set val  "1100"
          } else { 
            set val  "0000" 			
          }
        }							
      }
    } else { 
      set val  "0000" 
    }

          if {$enable_64bit } {
              set val_hex_64_0  [populate_A $size $scale $enable_64bit $val 0 ]
              set val_hex_64_1  [populate_A $size $scale $enable_64bit $val 1 ]
              set v_64 [join "$val_hex_64_1 $val_hex_64_0" "" ]
	  } else {
              set v_64  [populate_A $size $scale $enable_64bit $val 1 ]
	  }
    send_msg INFO 1 " Val_hex_64:$v_64"
      return $v_64    

  }
}

foreach j { 1  3  5} {
  set mn1 [expr $j - 1 ]
  set PR [regsub -all <<n>> $enable_PF0_BARS $j ]
  set PR1 [regsub -all <<nm1>> $PR $mn1 ]
  eval $PR1
}

proc get_size_range_br1 {enable_val enable_64bit bar_Type val_scale axi_addr_width is_usplus} {
  # - Bytes         - Kilobytes         - Megabytes        - Gigabytes
  set range_list "2"
  switch $val_scale {
    "Bytes" {
      switch $bar_Type {
        "I/O" {
          set range_list "16, 32, 64, 128, 256, 512"
          set default_val 16
        }
        "Memory" {
          if {$enable_64bit} {
            set range_list "128, 256, 512"
            set default_val 128 
          } else {
            set range_list "128, 256, 512"
            set default_val 128 
          }
        }
      }
    }
    "Kilobytes" {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
          set default_val 1 
        }
        "Memory" {
           if {$enable_64bit} {
               set range_list  "4, 8, 16, 32, 64, 128, 256, 512"
               set default_val 4 
           } else {
               set range_list  "4, 8, 16, 32, 64, 128, 256, 512"
               set default_val 4 
           }
        }
      }
    }
    "Megabytes" {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
          set default_val 1
        }
        "Memory" {
          if {$enable_64bit} {
            set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
            set default_val 64				
          } else {
           set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
           set default_val 1 
          }			
        }
      }
    }
    "Gigabytes"  {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2"
          set default_val 1
        }
        "Memory" {
          if {$enable_64bit} {
            if {$axi_addr_width <= 32} {
              set range_list "1, 2, 4"
              set default_val 1
            } elseif {$axi_addr_width <= 33} {
              set range_list "1, 2, 4, 8"
              set default_val 1
            } elseif {$axi_addr_width <= 34} {
              set range_list "1, 2, 4, 8, 16"
              set default_val 1
            } elseif {$axi_addr_width <= 35} {
              set range_list "1, 2, 4, 8, 16, 32"
              set default_val 1
            } elseif {$axi_addr_width <= 36} {
              set range_list "1, 2, 4, 8, 16, 32, 64"
              set default_val 1
            } elseif {$axi_addr_width <= 37} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128"
              set default_val 1
            } elseif {$axi_addr_width <= 38 && $is_usplus == "TRUE"} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256"
              set default_val 1
            } elseif {$axi_addr_width <= 39 && $is_usplus == "TRUE"} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
              set default_val 1
            } else {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256"
              set default_val 1
            }
          } else {
            set range_list "1, 2"
            set default_val 1
          }				
        }
      }
    }
    "Terabytes"  {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2"
          set default_val 1
        }
        "Memory" {
          if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
            if {$axi_addr_width <= 40} {
              set range_list "1"
              set default_val 1
            } elseif {$axi_addr_width <= 41} {
              set range_list "1, 2"
              set default_val 1
            } elseif {$axi_addr_width <= 42} {
              set range_list "1, 2, 4"
              set default_val 1
            } elseif {$axi_addr_width <= 43} {
              set range_list "1, 2, 4, 8"
              set default_val 1
            } elseif {$axi_addr_width <= 44} {
              set range_list "1, 2, 4, 8, 16"
              set default_val 1
            } elseif {$axi_addr_width <= 45} {
              set range_list "1, 2, 4, 8, 16, 32"
              set default_val 1
            } elseif {$axi_addr_width <= 46} {
              set range_list "1, 2, 4, 8, 16, 32, 64"
              set default_val 1
            } elseif {$axi_addr_width <= 47} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128"
              set default_val 1
            } elseif {$axi_addr_width <= 48} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256"
              set default_val 1
            } else {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
              set default_val 1
            }
          } else {
            set range_list "1"
            set default_val 1
          }				
        }
      }
    }
    "Petabytes"  {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2"
          set default_val 1
        }
        "Memory" {
          if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
            if {$axi_addr_width <= 50} {
              set range_list "1"
              set default_val 1
            } elseif {$axi_addr_width <= 51} {
              set range_list "1, 2"
              set default_val 1
            } elseif {$axi_addr_width <= 52} {
              set range_list "1, 2, 4"
              set default_val 1
            } elseif {$axi_addr_width <= 53} {
              set range_list "1, 2, 4, 8"
              set default_val 1
            } elseif {$axi_addr_width <= 54} {
              set range_list "1, 2, 4, 8, 16"
              set default_val 1
            } elseif {$axi_addr_width <= 55} {
              set range_list "1, 2, 4, 8, 16, 32"
              set default_val 1
            } elseif {$axi_addr_width <= 56} {
              set range_list "1, 2, 4, 8, 16, 32, 64"
              set default_val 1
            } elseif {$axi_addr_width <= 57} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128"
              set default_val 1
            } elseif {$axi_addr_width <= 58} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256"
              set default_val 1
            } else {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
              set default_val 1
            }
          } else {
            set range_list "1"
            set default_val 1
          }				
        }
      }
    }
    "Exabytes"  {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2"
          set default_val 1
        }
        "Memory" {
          if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
            if {$axi_addr_width <= 60} {
              set range_list "1"
              set default_val 1
            } elseif {$axi_addr_width <= 61} {
              set range_list "1, 2"
              set default_val 1
            } elseif {$axi_addr_width <= 62} {
              set range_list "1, 2, 4"
              set default_val 1
            } else {
              set range_list "1, 2, 4, 8"
              set default_val 1
            }
          } else {
            set range_list "1"
            set default_val 1
          }				
        }
      }
    }
   }
   return "$default_val,$range_list"
}
		   
proc get_size_range_br {enable_val enable_64bit bar_Type val_scale bar_indicator axi_addr_width is_usplus} {
  # - Bytes         - Kilobytes         - Megabytes        - Gigabytes
  set range_list "2"
  switch $val_scale {
    "Bytes" {
      switch $bar_Type {
        "I/O" {
          set range_list "16, 32, 64, 128, 256, 512"
          set default_val 16
        }
        "Memory" {
          if {$enable_64bit} {
            set range_list "128, 256, 512"
            set default_val 128 
          } else {
            set range_list "128, 256, 512"
            set default_val 128 
          }
        }
      }
    }
    "Kilobytes" {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
          set default_val 1 
        }
        "Memory" {
           if {$enable_64bit} {
             if {$bar_indicator} { 
               set range_list  "128, 256, 512"
               set default_val 128 
             } else { 
               set range_list  "4, 8, 16, 32, 64, 128, 256, 512"
               set default_val 4 
             }
           } else {
             if {$bar_indicator} { 
               set range_list  "128, 256, 512"
               set default_val 128 
             } else { 
               set range_list  "4, 8, 16, 32, 64, 128, 256, 512"
               set default_val 4 
             }
           }
        }
      }
    }
    "Megabytes" {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
          set default_val 1
        }
        "Memory" {
          if {$enable_64bit} {
            set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
            set default_val 64				
          } else {
           set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
           set default_val 1 
          }			
        }
      }
    }
    "Gigabytes"  {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2"
          set default_val 1
        }
        "Memory" {
          if {$enable_64bit} {
            if {$axi_addr_width <= 32} {
              set range_list "1, 2, 4"
              set default_val 1
            } elseif {$axi_addr_width <= 33} {
              set range_list "1, 2, 4, 8"
              set default_val 1
            } elseif {$axi_addr_width <= 34} {
              set range_list "1, 2, 4, 8, 16"
              set default_val 1
            } elseif {$axi_addr_width <= 35} {
              set range_list "1, 2, 4, 8, 16, 32"
              set default_val 1
            } elseif {$axi_addr_width <= 36} {
              set range_list "1, 2, 4, 8, 16, 32, 64"
              set default_val 1
            } elseif {$axi_addr_width <= 37} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128"
              set default_val 1
            } elseif {$axi_addr_width <= 38 && $is_usplus == "TRUE"} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256"
              set default_val 1
            } elseif {$is_usplus == "TRUE"} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
              set default_val 1
            } else {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256"
              set default_val 1
            }
          } else {
            set range_list "1, 2"
            set default_val 1
          }				
        }
      }
    }
    "Terabytes"  {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2"
          set default_val 1
        }
        "Memory" {
          if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
            if {$axi_addr_width <= 40} {
              set range_list "1"
              set default_val 1
            } elseif {$axi_addr_width <= 41} {
              set range_list "1, 2"
              set default_val 1
            } elseif {$axi_addr_width <= 42} {
              set range_list "1, 2, 4"
              set default_val 1
            } elseif {$axi_addr_width <= 43} {
              set range_list "1, 2, 4, 8"
              set default_val 1
            } elseif {$axi_addr_width <= 44} {
              set range_list "1, 2, 4, 8, 16"
              set default_val 1
            } elseif {$axi_addr_width <= 45} {
              set range_list "1, 2, 4, 8, 16, 32"
              set default_val 1
            } elseif {$axi_addr_width <= 46} {
              set range_list "1, 2, 4, 8, 16, 32, 64"
              set default_val 1
            } elseif {$axi_addr_width <= 47} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128"
              set default_val 1
            } elseif {$axi_addr_width <= 48} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256"
              set default_val 1
            } else {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
              set default_val 1
            }
          } else {
            set range_list "1"
            set default_val 1
          }				
        }
      }
    }
    "Petabytes"  {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2"
          set default_val 1
        }
        "Memory" {
          if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
            if {$axi_addr_width <= 50} {
              set range_list "1"
              set default_val 1
            } elseif {$axi_addr_width <= 51} {
              set range_list "1, 2"
              set default_val 1
            } elseif {$axi_addr_width <= 52} {
              set range_list "1, 2, 4"
              set default_val 1
            } elseif {$axi_addr_width <= 53} {
              set range_list "1, 2, 4, 8"
              set default_val 1
            } elseif {$axi_addr_width <= 54} {
              set range_list "1, 2, 4, 8, 16"
              set default_val 1
            } elseif {$axi_addr_width <= 55} {
              set range_list "1, 2, 4, 8, 16, 32"
              set default_val 1
            } elseif {$axi_addr_width <= 56} {
              set range_list "1, 2, 4, 8, 16, 32, 64"
              set default_val 1
            } elseif {$axi_addr_width <= 57} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128"
              set default_val 1
            } elseif {$axi_addr_width <= 58} {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256"
              set default_val 1
            } else {
              set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
              set default_val 1
            }
          } else {
            set range_list "1"
            set default_val 1
          }				
        }
      }
    }
    "Exabytes"  {
      switch $bar_Type {
        "I/O" {
          set range_list "1, 2"
          set default_val 1
        }
        "Memory" {
          if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
            if {$axi_addr_width <= 60} {
              set range_list "1"
              set default_val 1
            } elseif {$axi_addr_width <= 61} {
              set range_list "1, 2"
              set default_val 1
            } elseif {$axi_addr_width <= 62} {
              set range_list "1, 2, 4"
              set default_val 1
            } else {
              set range_list "1, 2, 4, 8"
              set default_val 1
            }
          } else {
            set range_list "1"
            set default_val 1
          }				
        }
      }
    }
   }
   return "$default_val,$range_list"
   #return $range_list
}

set aperture_proc {
  proc update_MODELPARAM_VALUE.PF0_BAR<<n>>_APERTURE_SIZE {MODELPARAM_VALUE.PF0_BAR<<n>>_APERTURE_SIZE PARAM_VALUE.pf0_bar<<n>>_enabled PARAM_VALUE.pf0_bar<<n>>_type PARAM_VALUE.pf0_bar<<n>>_scale PARAM_VALUE.pf0_bar<<n>>_size PARAM_VALUE.device_port_type} {
    set enable_val [get_property value ${PARAM_VALUE.pf0_bar<<n>>_enabled}] 
    set val_scale [get_property value ${PARAM_VALUE.pf0_bar<<n>>_scale}]
    set val_size  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_size}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf0_bar<<n>>_type}] 
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type}]
    if { [expr <<n>> %2 ] == 0} {
      set value [get_aperture_value $enable_val $val_size $val_scale $device_port_type]
    } else {
      set value [get_aperture_value  $enable_val $val_size $val_scale $device_port_type]
    }
    set_property value  $value  ${MODELPARAM_VALUE.PF0_BAR<<n>>_APERTURE_SIZE}
  }
}		

foreach i {0 1 2 3 4 5} {
  set aperture_proc_1 [regsub -all <<n>> $aperture_proc $i ] 
  eval $aperture_proc_1
}

set pf1_aperture_proc {
  proc update_MODELPARAM_VALUE.PF1_BAR<<n>>_APERTURE_SIZE {MODELPARAM_VALUE.PF1_BAR<<n>>_APERTURE_SIZE PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_type PARAM_VALUE.pf1_bar<<n>>_scale PARAM_VALUE.pf1_bar<<n>>_size PARAM_VALUE.device_port_type} {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] 
    set val_scale [get_property value ${PARAM_VALUE.pf1_bar<<n>>_scale}]
    set val_size  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_size}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_type}] 
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type}]
    if { [expr <<n>> %2 ] == 0} {
      set value	[get_aperture_value $enable_val $val_size $val_scale $device_port_type]
    } else {
      set value [get_aperture_value  $enable_val $val_size $val_scale $device_port_type]
    }
    set_property value  $value  ${MODELPARAM_VALUE.PF1_BAR<<n>>_APERTURE_SIZE}
  }
}		

foreach i {0 1 2 3 4 5} {
  set pf1_aperture_proc_1 [regsub -all <<n>> $pf1_aperture_proc $i ] 
  eval $aperture_proc_1
}


#########
# Procedure to update PF1 BAR Panel Parameters
#########
#

#####################################  		
## PF1 EVEN
####################33	
set PCIE_PF1_BAR_PANEL_EVEN_updates {

  proc update_PARAM_VALUE.pf1_pciebar2axibar_<<n>> {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_pciebar2axibar_<<n>>} {
    set_property enabled  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}]  ${PARAM_VALUE.pf1_pciebar2axibar_<<n>>}
  }

  proc validate_PARAM_VALUE.pf1_pciebar2axibar_<<n>>  {PARAM_VALUE.pf1_pciebar2axibar_<<n>> PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_64bit PARAM_VALUE.pf1_bar<<n>>_scale PARAM_VALUE.pf1_bar<<n>>_size } { 
	       
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] 
    set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar<<n>>_64bit}]
    set size  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_size}]
    set scale [get_property value ${PARAM_VALUE.pf1_bar<<n>>_scale}]
    set val 0000
    set val_hex_32_0  [populate_A $size $scale $enable_64bit $val 0 ]
    set val_hex_32_1  [populate_A $size $scale $enable_64bit $val 1 ]

    if {$enable_64bit} {
      set v_64 [join "$val_hex_32_1 $val_hex_32_0" "" ]
    } else {
      set val_hex_32_null "00000000"
      set v_64 [join "$val_hex_32_null $val_hex_32_0"  "" ]
    }

    #set low_nib
    set val_curr [get_property value  ${PARAM_VALUE.pf1_pciebar2axibar_<<n>>} ]
    set val_lower_n  [ipgen::number_utils::hex2dec  [string range $val_curr end-3 end ]  ]
    if {([get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}]) && ($val_lower_n != 0 ) && (($scale  eq "Megabytes" )  || ($scale  eq  "Gigabytes" ))}    {
      set_property errmsg "Entered  Hexadecimal value must have lower 4 digits as 0  " ${PARAM_VALUE.pf1_pciebar2axibar_<<n>>}
      return  false 
    } elseif {[get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] } { 
      return [RangeCheck4HexDec  0 $v_64 ${PARAM_VALUE.pf1_pciebar2axibar_<<n>>}] 
    } else {
      return true
    }
  }

  proc update_PARAM_VALUE.pf1_bar<<n>>_type {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_type} {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}]
    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf1_bar<<n>>_type}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf1_bar<<n>>_type} 
    }
  }
			 
  proc update_PARAM_VALUE.pf1_bar<<n>>_64bit {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_64bit PARAM_VALUE.pf1_bar<<n>>_type } {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}]
    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf1_bar<<n>>_64bit}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf1_bar<<n>>_64bit} 
      set_property value false ${PARAM_VALUE.pf1_bar<<n>>_64bit} 
    }
  }
			 
  proc update_PARAM_VALUE.pf1_bar<<n>>_prefetchable {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_prefetchable PARAM_VALUE.pf1_bar<<n>>_type PARAM_VALUE.pf1_bar<<n>>_64bit} {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}]
    set bar_type [get_property value ${PARAM_VALUE.pf1_bar<<n>>_type}]
    set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar<<n>>_64bit}]

    if {$enable_val &&($bar_type eq "Memory")&& $enable_64bit} { 
      set_property enabled true ${PARAM_VALUE.pf1_bar<<n>>_prefetchable}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf1_bar<<n>>_prefetchable} 
      set_property value false ${PARAM_VALUE.pf1_bar<<n>>_prefetchable} 
    }
  }

  proc update_PARAM_VALUE.pf1_bar<<n>>_size {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_size PARAM_VALUE.pf1_bar<<n>>_scale PARAM_VALUE.pf1_bar<<n>>_64bit PARAM_VALUE.pf1_bar<<n>>_type PARAM_VALUE.axi_addr_width PROJECT_PARAM.ARCHITECTURE} {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] 
    set val_scale [get_property value ${PARAM_VALUE.pf1_bar<<n>>_scale}]
    set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar<<n>>_64bit}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_type}] 
    set axi_addr_width [get_property value ${PARAM_VALUE.axi_addr_width}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXUPLUS"  ||  $c_xfamily eq "KINTEXUPLUS" ||  $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
        set is_usplus "TRUE"
    } else {
        set is_usplus "FALSE"
    }

    set curr_range [get_size_range_br1 $enable_val $enable_64bit $bar_Type $val_scale $axi_addr_width $is_usplus]
				 
    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf1_bar<<n>>_size}
      set_property range $curr_range ${PARAM_VALUE.pf1_bar<<n>>_size}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf1_bar<<n>>_size} 
      set_property range $curr_range ${PARAM_VALUE.pf1_bar<<n>>_size}
    }
  }
			 
  proc update_PARAM_VALUE.pf1_bar<<n>>_scale {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_scale PARAM_VALUE.pf1_bar<<n>>_64bit PARAM_VALUE.axi_addr_width PROJECT_PARAM.ARCHITECTURE} {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}]
    set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar<<n>>_64bit}]
    set axi_addr_width [get_property value ${PARAM_VALUE.axi_addr_width}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXUPLUS"  ||  $c_xfamily eq "KINTEXUPLUS" ||  $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
        set is_usplus "TRUE"
    } else {
        set is_usplus "FALSE"
    }
    if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
        if {$axi_addr_width >= 40 && $axi_addr_width < 50} {
            set_property range "Kilobytes,Megabytes,Gigabytes,Terabytes" ${PARAM_VALUE.pf1_bar<<n>>_scale}
        } elseif {$axi_addr_width >= 50 && $axi_addr_width < 60} {
            set_property range "Kilobytes,Megabytes,Gigabytes,Terabytes,Petabytes" ${PARAM_VALUE.pf1_bar<<n>>_scale}
        } elseif {$axi_addr_width >= 60} {
            set_property range "Kilobytes,Megabytes,Gigabytes,Terabytes,Petabytes,Exabytes" ${PARAM_VALUE.pf1_bar<<n>>_scale}
        } else {
            set_property range "Kilobytes,Megabytes,Gigabytes" ${PARAM_VALUE.pf1_bar<<n>>_scale}
        }
    } else {
        set_property range "Kilobytes,Megabytes,Gigabytes" ${PARAM_VALUE.pf1_bar<<n>>_scale}
    }
    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf1_bar<<n>>_scale}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf1_bar<<n>>_scale} 
    }
  }
			
  #proc DT_pf1_bar<<n>>_value { PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_type PARAM_VALUE.pf1_bar<<n>>_64bit PARAM_VALUE.pf1_bar<<n>>_prefetchable PARAM_VALUE.pf1_bar<<n>>_scale PARAM_VALUE.pf1_bar<<n>>_size} {
			
    #set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] 
    #set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar<<n>>_64bit}]
    #set prefetchable  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_prefetchable}]
    #set bar_Type  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_type}] 
    #set size  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_size}]
    #set scale [get_property value ${PARAM_VALUE.pf1_bar<<n>>_scale}]
    #set val  "FFFFF000"
				
    #if {$enable_val } { 
      #switch $bar_Type {
        #"IO" {
          #set val  "0001"
        #}
        #"Memory"	{
          #if {!$enable_64bit } {
            #set val  "0000"
          #} elseif {$enable_64bit && (!$prefetchable)} {
            #set val  "0100"
          #} elseif {$enable_64bit && $prefetchable} {
            #set val  "1100"
          #} else { 
            #set val  "0000" 			
          #}
      #  }							
      #}
    #} else { 
      #set val  "0000" 
    #}
    #set val_hex_64  [populate_A $size $scale $enable_64bit $val 0 ]
    #return $val_hex_64
 # }
  
  proc DT_pf1_bar_value<<n>> { PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_type PARAM_VALUE.pf1_bar<<n>>_64bit PARAM_VALUE.pf1_bar<<n>>_prefetchable PARAM_VALUE.pf1_bar<<n>>_scale PARAM_VALUE.pf1_bar<<n>>_size} {
			
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] 
    set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar<<n>>_64bit}]
    set prefetchable  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_prefetchable}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_type}] 
    set size  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_size}]
    set scale [get_property value ${PARAM_VALUE.pf1_bar<<n>>_scale}]
    set val  "FFFFF000"
				
    if {$enable_val } { 
      switch $bar_Type {
        "IO" {
          set val  "0001"
        }
        "Memory"	{
          if {!$enable_64bit } {
            set val  "0000"
          } elseif {$enable_64bit && (!$prefetchable)} {
            set val  "0100"
          } elseif {$enable_64bit && $prefetchable} {
            set val  "1100"
          } else { 
            set val  "0000" 			
          }
        }							
      }
    } else { 
      set val  "0000" 
    }

    
              if {$enable_64bit } {
              set val_hex_64_0  [populate_A $size $scale $enable_64bit $val 0 ]
              set val_hex_64_1  [populate_A $size $scale $enable_64bit $val 1 ]
              set v_64 [join "$val_hex_64_1 $val_hex_64_0" "" ]
	  } else {
              set v_64  [populate_A $size $scale $enable_64bit $val 0 ]
	  }
      return $v_64
  }

  proc update_MODELPARAM_VALUE.PF1_BAR<<n>>_CONTROL {MODELPARAM_VALUE.PF1_BAR<<n>>_CONTROL PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_type PARAM_VALUE.pf1_bar<<n>>_type PARAM_VALUE.pf1_bar<<n>>_64bit PARAM_VALUE.pf1_bar<<n>>_prefetchable} {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] 
    set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar<<n>>_64bit}]
    set prefetchable  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_prefetchable}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_type}] 
    set val  "000"

    if {$enable_val } { 
      switch $bar_Type {
        "IO" {
          set val  0x0
        }
        "Memory"	{
          if {$enable_64bit && ($prefetchable)} {
            set val 0x7
          } elseif {$enable_64bit && (!$prefetchable)} {
            set val 0x6
          } elseif { (!$enable_64bit) && (!$prefetchable)} {
            set val 0x4
          } else { 
            set val 0x5 
          }
        }										
      }
    } else { 
      set val  0x0
    }
    set_property value  $val ${MODELPARAM_VALUE.PF1_BAR<<n>>_CONTROL}
  }
			
  proc validate_PARAM_VALUE.pf1_bar<<n>>_enabled  { PARAM_VALUE.pf1_bar0_enabled PARAM_VALUE.pf1_bar1_enabled PARAM_VALUE.pf1_bar2_enabled PARAM_VALUE.pf1_bar3_enabled PARAM_VALUE.pf1_bar4_enabled PARAM_VALUE.pf1_bar5_enabled PARAM_VALUE.device_port_type  } {

    set dev_port_type [get_property value ${PARAM_VALUE.device_port_type} ]
    # RP is allowed to have no BAR enabled
    if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
      return true 
    } else {
      set en_0 [get_property value ${PARAM_VALUE.pf1_bar0_enabled}] 
      set en_1 [get_property value ${PARAM_VALUE.pf1_bar1_enabled}] 
      set en_2 [get_property value ${PARAM_VALUE.pf1_bar2_enabled}] 
      set en_3 [get_property value ${PARAM_VALUE.pf1_bar3_enabled}] 
      set en_4 [get_property value ${PARAM_VALUE.pf1_bar4_enabled}] 
      set en_5 [get_property value ${PARAM_VALUE.pf1_bar5_enabled}] 
      if {(!$en_0) && (!$en_1) && (!$en_2) && (!$en_3) && (!$en_4) && (!$en_5)} {
        set_property errmsg " invalid configuration at least one PCIE bar has to be enabled " ${PARAM_VALUE.pf1_bar<<n>>_enabled}
        return false 
      }
      return true  		
   }
  }
}

##########
## PF1 ODD	
#####################################  			
set PCIE_PF1_BAR_PANEL_ODD_updates {
				 
  proc update_PARAM_VALUE.pf1_pciebar2axibar_<<n>> {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_pciebar2axibar_<<n>>} {
    set_property enabled  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}]  ${PARAM_VALUE.pf1_pciebar2axibar_<<n>>}
  }

  proc validate_PARAM_VALUE.pf1_pciebar2axibar_<<n>>  {PARAM_VALUE.pf1_pciebar2axibar_<<n>> PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_scale PARAM_VALUE.pf1_bar<<n>>_size } { 
													 
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] 
    set enable_64bit 0
    set size  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_size}]
    set scale [get_property value ${PARAM_VALUE.pf1_bar<<n>>_scale}]
    set val 0000 
		    	
    set val_hex_32_0  [populate_A $size $scale $enable_64bit $val 0 ]
    set val_hex_32_null "00000000"
    set v_64 [join "$val_hex_32_null $val_hex_32_0"  "" ]
    
    if { $enable_val } { 
      return [RangeCheck4HexDec  0 $v_64 ${PARAM_VALUE.pf1_pciebar2axibar_<<n>>}] 
    } else {
      return true
    }
  }

  proc update_PARAM_VALUE.pf1_bar<<n>>_type {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_type} {
				
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}]
    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf1_bar<<n>>_type}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf1_bar<<n>>_type} 
    }
  }
			 
  proc update_PARAM_VALUE.pf1_bar<<n>>_prefetchable {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_prefetchable PARAM_VALUE.pf1_bar<<n>>_type } {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}]
    set bar_type [get_property value ${PARAM_VALUE.pf1_bar<<n>>_type}]

    if {$enable_val &&($bar_type eq "Memory")} { 
      set_property enabled true ${PARAM_VALUE.pf1_bar<<n>>_prefetchable}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf1_bar<<n>>_prefetchable} 
      set_property value false ${PARAM_VALUE.pf1_bar<<n>>_prefetchable} 
    }
  }
			 
  proc update_PARAM_VALUE.pf1_bar<<n>>_size {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_size PARAM_VALUE.pf1_bar<<n>>_scale  PARAM_VALUE.pf1_bar<<n>>_type PARAM_VALUE.axi_addr_width PROJECT_PARAM.ARCHITECTURE} {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] 
    set val_scale [get_property value ${PARAM_VALUE.pf1_bar<<n>>_scale}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_type}] 
    set axi_addr_width [get_property value ${PARAM_VALUE.axi_addr_width}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {$c_xfamily eq "VIRTEXUPLUS"  ||  $c_xfamily eq "KINTEXUPLUS" ||  $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
        set is_usplus "TRUE"
    } else {
        set is_usplus "FALSE"
    }

    set curr_range [get_size_range_br1 $enable_val 0 $bar_Type $val_scale $axi_addr_width $is_usplus]

    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf1_bar<<n>>_size}
      set_property range $curr_range ${PARAM_VALUE.pf1_bar<<n>>_size}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf1_bar<<n>>_size} 
      set_property range $curr_range ${PARAM_VALUE.pf1_bar<<n>>_size}
    }
  }
			 
  proc update_PARAM_VALUE.pf1_bar<<n>>_scale {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_scale} {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}]
    if {$enable_val } { 
      set_property enabled true ${PARAM_VALUE.pf1_bar<<n>>_scale}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf1_bar<<n>>_scale} 
    }
  }
			
  proc update_MODELPARAM_VALUE.PF1_BAR<<n>>_CONTROL {MODELPARAM_VALUE.PF1_BAR<<n>>_CONTROL PARAM_VALUE.pf1_bar<<n>>_enabled  PARAM_VALUE.pf1_bar<<n>>_type PARAM_VALUE.pf1_bar<<n>>_prefetchable} {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] 
    set enable_64bit  0
    set prefetchable  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_prefetchable}]
    set bar_Type  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_type}] 
    set val  "000"
    
    if {$enable_val } { 
      switch $bar_Type {
        "IO" {
          set val  0x0
        }
        "Memory"	{
          if {$enable_64bit && ($prefetchable)} {
            set val 0x7
          } elseif {$enable_64bit && (!$prefetchable)} {
            set val 0x6
          } elseif { (!$enable_64bit) && (!$prefetchable)} {
            set val 0x4
          } else { 
            set val 0x5 
          }
        }										
      }
    } else { 
      set val  0x0
    }
    set_property value  $val ${MODELPARAM_VALUE.PF1_BAR<<n>>_CONTROL}
  }

  proc validate_PARAM_VALUE.pf1_bar<<n>>_enabled {PARAM_VALUE.pf1_bar0_enabled PARAM_VALUE.pf1_bar1_enabled PARAM_VALUE.pf1_bar2_enabled PARAM_VALUE.pf1_bar3_enabled PARAM_VALUE.pf1_bar4_enabled PARAM_VALUE.pf1_bar5_enabled PARAM_VALUE.device_port_type} {

    set dev_port_type [get_property value ${PARAM_VALUE.device_port_type}]
			# RP is allowed to have no BAR enabled
    if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
      return true 
    } else {
      set en_0 [get_property value ${PARAM_VALUE.pf1_bar0_enabled}] 
      set en_1 [get_property value ${PARAM_VALUE.pf1_bar1_enabled}] 
      set en_2 [get_property value ${PARAM_VALUE.pf1_bar2_enabled}] 
      set en_3 [get_property value ${PARAM_VALUE.pf1_bar3_enabled}] 
      set en_4 [get_property value ${PARAM_VALUE.pf1_bar4_enabled}] 
      set en_5 [get_property value ${PARAM_VALUE.pf1_bar5_enabled}]
      if {(!$en_0) && (!$en_1) && (!$en_2) && (!$en_3) && (!$en_4) && (!$en_5)} {
        set_property errmsg " invalid configuration at least one PCIE bar has to be enabled " ${PARAM_VALUE.pf1_bar<<n>>_enabled}
        return false 
      }
      return true
    }
  }
}

foreach i {0 2 4} {
  set j [expr $i + 1 ]
  set PR_EVEN [ regsub -all <<n>> $PCIE_PF1_BAR_PANEL_EVEN_updates $i ]
  set PR_ODD  [ regsub -all <<n>> $PCIE_PF1_BAR_PANEL_ODD_updates $j  ]
  eval $PR_EVEN
  eval $PR_ODD
}

proc update_PARAM_VALUE.pf1_bar5_enabled {PARAM_VALUE.pf1_bar5_enabled PARAM_VALUE.device_port_type} {
  set enable_val [get_property value ${PARAM_VALUE.pf1_bar5_enabled}]
  set dev_port_type [get_property value ${PARAM_VALUE.device_port_type} ]

  if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property enabled false ${PARAM_VALUE.pf1_bar5_enabled}
    set_property value false ${PARAM_VALUE.pf1_bar5_enabled}
  }
}

proc update_PARAM_VALUE.pf1_bar3_enabled {PARAM_VALUE.pf1_bar3_enabled PARAM_VALUE.device_port_type} {
  set enable_val [get_property value ${PARAM_VALUE.pf1_bar3_enabled}]
  set dev_port_type [get_property value ${PARAM_VALUE.device_port_type} ]

  if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property enabled false ${PARAM_VALUE.pf1_bar3_enabled}
    set_property value false ${PARAM_VALUE.pf1_bar3_enabled}
  }
}

proc update_PARAM_VALUE.pf1_bar2_enabled {PARAM_VALUE.pf1_bar2_enabled PARAM_VALUE.pf1_bar1_enabled PARAM_VALUE.pf1_bar0_64bit PARAM_VALUE.pf1_bar0_enabled PARAM_VALUE.device_port_type } {
  set enable_val [get_property value ${PARAM_VALUE.pf1_bar2_enabled}]
  set enable_m1_val [get_property value ${PARAM_VALUE.pf1_bar1_enabled}]
  set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar0_64bit}]
  set enable_m2_val [get_property value ${PARAM_VALUE.pf1_bar0_enabled}]
  set dev_port_type [get_property value ${PARAM_VALUE.device_port_type} ]

  if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property enabled false ${PARAM_VALUE.pf1_bar2_enabled}
    set_property value false ${PARAM_VALUE.pf1_bar2_enabled}
  } else { 
    if {($enable_m1_val ) || ($enable_64bit && $enable_m2_val ) } { 
      set_property enabled true ${PARAM_VALUE.pf1_bar2_enabled}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf1_bar2_enabled}
      set_property value false ${PARAM_VALUE.pf1_bar2_enabled}
    }
  }
}
 
proc update_PARAM_VALUE.pf1_bar4_enabled {PARAM_VALUE.pf1_bar4_enabled PARAM_VALUE.pf1_bar3_enabled PARAM_VALUE.pf1_bar2_64bit PARAM_VALUE.pf1_bar2_enabled PARAM_VALUE.device_port_type   } {
  set enable_val [get_property value ${PARAM_VALUE.pf1_bar4_enabled}]
  set enable_m1_val [get_property value ${PARAM_VALUE.pf1_bar3_enabled}]
  set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar2_64bit}]
  set enable_m2_val [get_property value ${PARAM_VALUE.pf1_bar2_enabled}]
  set dev_port_type [get_property value ${PARAM_VALUE.device_port_type} ]
  
  if {$dev_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property enabled false ${PARAM_VALUE.pf1_bar4_enabled}
    set_property value false ${PARAM_VALUE.pf1_bar4_enabled}
  } else { 
    if {($enable_m1_val ) || ($enable_64bit && $enable_m2_val )  } { 
      set_property enabled true ${PARAM_VALUE.pf1_bar4_enabled}
    } else { 
      set_property enabled false ${PARAM_VALUE.pf1_bar4_enabled}
      set_property value false ${PARAM_VALUE.pf1_bar4_enabled}
    }
  }
}

set enable_PF1_BARS {
  proc update_PARAM_VALUE.pf1_bar<<n>>_enabled {PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<nm1>>_enabled PARAM_VALUE.pf1_bar<<nm1>>_64bit PARAM_VALUE.en_axi_master_if} {
    set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}]
    set enable_m1_val [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_enabled}]
    set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_64bit}]
    set en_axi_master [get_property value ${PARAM_VALUE.en_axi_master_if}]

    if {$en_axi_master == "false" && <<n>> != 0} { 
      set_property enabled false ${PARAM_VALUE.pf1_bar<<n>>_enabled} 
      set_property value [get_property default_value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] ${PARAM_VALUE.pf1_bar<<n>>_enabled}
    } else { 
      if {$enable_m1_val && !($enable_64bit)} { 
        set_property enabled true ${PARAM_VALUE.pf1_bar<<n>>_enabled}
      } else { 
        set_property enabled false ${PARAM_VALUE.pf1_bar<<n>>_enabled}
        set_property value false ${PARAM_VALUE.pf1_bar<<n>>_enabled}
      }
    }
  }

  #proc DT_pf1_bar<<n>>_value { PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_type PARAM_VALUE.pf1_bar<<nm1>>_64bit PARAM_VALUE.pf1_bar<<n>>_prefetchable PARAM_VALUE.pf1_bar<<n>>_scale PARAM_VALUE.pf1_bar<<n>>_size PARAM_VALUE.pf1_bar<<nm1>>_enabled PARAM_VALUE.pf1_bar<<nm1>>_type  PARAM_VALUE.pf1_bar<<nm1>>_prefetchable PARAM_VALUE.pf1_bar<<nm1>>_scale PARAM_VALUE.pf1_bar<<nm1>>_size} {
						
    #set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_64bit}]
    #if {$enable_64bit} {
      #set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_enabled}] 
      #set prefetchable  [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_prefetchable}]
      #set bar_Type  [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_type}] 
      #set size  [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_size}]
      #set scale [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_scale}]
    #} else {
      #set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] 
      #set prefetchable  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_prefetchable}]
      #set bar_Type  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_type}] 
      #set size  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_size}]
      #set scale [get_property value ${PARAM_VALUE.pf1_bar<<n>>_scale}]
    #}
    #set val  "FFFFF000"
#
    #if {$enable_val } { 
      #switch $bar_Type {
        #"IO" {
          #set val  "0001"
        #}
        #"Memory"	{
          #if {!$enable_64bit } {
            #set val  "0000"
          #} elseif {$enable_64bit && (!$prefetchable)} {
            #set val  "0100"
          #} elseif {$enable_64bit && $prefetchable} {
            #set val  "1100"
          #} else { 
            #set val  "0000" 			
          #}
        #}							
      #}
    #} else { 
      #set val  "0000" 
    #}
    #set val_hex_64  [populate_A $size $scale $enable_64bit $val 1 ]

    #return $val_hex_64
  #}

    proc DT_pf1_bar_value<<n>> { PARAM_VALUE.pf1_bar<<n>>_enabled PARAM_VALUE.pf1_bar<<n>>_type PARAM_VALUE.pf1_bar<<nm1>>_64bit PARAM_VALUE.pf1_bar<<n>>_prefetchable PARAM_VALUE.pf1_bar<<n>>_scale PARAM_VALUE.pf1_bar<<n>>_size PARAM_VALUE.pf1_bar<<nm1>>_enabled PARAM_VALUE.pf1_bar<<nm1>>_type  PARAM_VALUE.pf1_bar<<nm1>>_prefetchable PARAM_VALUE.pf1_bar<<nm1>>_scale PARAM_VALUE.pf1_bar<<nm1>>_size} {
						
    set enable_64bit [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_64bit}]
    if {$enable_64bit} {
      set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_enabled}] 
      set prefetchable  [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_prefetchable}]
      set bar_Type  [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_type}] 
      set size  [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_size}]
      set scale [get_property value ${PARAM_VALUE.pf1_bar<<nm1>>_scale}]
    } else {
      set enable_val [get_property value ${PARAM_VALUE.pf1_bar<<n>>_enabled}] 
      set prefetchable  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_prefetchable}]
      set bar_Type  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_type}] 
      set size  [get_property value ${PARAM_VALUE.pf1_bar<<n>>_size}]
      set scale [get_property value ${PARAM_VALUE.pf1_bar<<n>>_scale}]
    }
    set val  "FFFFF000"

    if {$enable_val } { 
      switch $bar_Type {
        "IO" {
          set val  "0001"
        }
        "Memory"	{
          if {!$enable_64bit } {
            set val  "0000"
          } elseif {$enable_64bit && (!$prefetchable)} {
            set val  "0100"
          } elseif {$enable_64bit && $prefetchable} {
            set val  "1100"
          } else { 
            set val  "0000" 			
          }
        }							
      }
    } else { 
      set val  "0000" 
    }


              if {$enable_64bit } {
              set val_hex_64_0  [populate_A $size $scale $enable_64bit $val 0 ]
              set val_hex_64_1  [populate_A $size $scale $enable_64bit $val 1 ]
              set v_64 [join "$val_hex_64_1 $val_hex_64_0" "" ]
	  } else {
              set v_64  [populate_A $size $scale $enable_64bit $val 1 ]
	  }
      return $v_64
  }

}

foreach j { 1  3  5} {
  set mn1 [expr $j - 1 ]
  set PR [regsub -all <<n>> $enable_PF1_BARS $j ]
  set PR1 [regsub -all <<nm1>> $PR $mn1 ]
  eval $PR1
}
############################################################################################

proc update_MODELPARAM_VALUE.PCIEBAR_NUM  { PARAM_VALUE.pf0_bar0_enabled PARAM_VALUE.pf0_bar1_enabled PARAM_VALUE.pf0_bar2_enabled PARAM_VALUE.pf0_bar3_enabled PARAM_VALUE.pf0_bar4_enabled PARAM_VALUE.pf0_bar5_enabled PARAM_VALUE.pf0_bar0_64bit PARAM_VALUE.pf0_bar2_64bit PARAM_VALUE.pf0_bar4_64bit MODELPARAM_VALUE.PCIEBAR_NUM PARAM_VALUE.functional_mode} {
									   
  set enable_val_0 [get_property value ${PARAM_VALUE.pf0_bar0_enabled}] 
  set enable_val_1 [get_property value ${PARAM_VALUE.pf0_bar1_enabled}] 
  set enable_val_2 [get_property value ${PARAM_VALUE.pf0_bar2_enabled}] 
  set enable_val_3 [get_property value ${PARAM_VALUE.pf0_bar3_enabled}] 
  set enable_val_4 [get_property value ${PARAM_VALUE.pf0_bar4_enabled}] 
  set enable_val_5 [get_property value ${PARAM_VALUE.pf0_bar5_enabled}] 
  
  set enable_64bit_0 [get_property value ${PARAM_VALUE.pf0_bar0_64bit}]
  set enable_64bit_2 [get_property value ${PARAM_VALUE.pf0_bar2_64bit}]
  set enable_64bit_4 [get_property value ${PARAM_VALUE.pf0_bar4_64bit}]
  set pciebar_num  0 
  set functional_mode [get_property value ${PARAM_VALUE.functional_mode}]

				 
  if {$functional_mode == "DMA" || $functional_mode == "DMA_and_Bridge" || $functional_mode == "MQDMA"} { 
     set pciebar_num 6
  } else {
    if {$enable_val_5} {  
    set pciebar_num 6
  } elseif {$enable_val_4} {
    if {$enable_64bit_4} {
      set pciebar_num 6
    } else {
      set pciebar_num 5
    }
  } elseif {$enable_val_3} {  
    set pciebar_num 4
  } elseif {$enable_val_2} {
    if {$enable_64bit_2} {
      set pciebar_num 4
    } else {
      set pciebar_num 3
    }
  } elseif {$enable_val_1} {  
    set pciebar_num 2 
  } elseif {$enable_val_0 } {
    if {$enable_64bit_0} {
      set pciebar_num 2
    } else {
      set pciebar_num 1
    }
  } 	
  }				
  set_property value $pciebar_num ${MODELPARAM_VALUE.PCIEBAR_NUM}
}

proc validate_PARAM_VALUE.pciebar2axibar_axil_master {PARAM_VALUE.pciebar2axibar_axil_master PARAM_VALUE.axilite_master_en PARAM_VALUE.axi_addr_width PARAM_VALUE.axilite_master_scale PARAM_VALUE.axilite_master_size } {

    set enable_val [get_property value ${PARAM_VALUE.axilite_master_en}]
# AXI Lite doesn't support 32-bit AXI Address, therefore limit address translation to 32-bit only even when 64-bit PCIe BAR is enabled
#    set enable_64bit_addr [get_property value ${PARAM_VALUE.axi_addr_width}]
    set enable_64bit_addr false
    set size  [get_property value ${PARAM_VALUE.axilite_master_size}]
    set scale [get_property value ${PARAM_VALUE.axilite_master_scale}]
    set val 0000
    set val_hex_32_0  [populate_A $size $scale $enable_64bit_addr $val 0 ]
    set val_hex_32_1  [populate_A $size $scale $enable_64bit_addr $val 1 ]

    if {$enable_64bit_addr} {
        set v_64 [join "$val_hex_32_1 $val_hex_32_0" "" ]
    } else {
        set val_hex_32_null "00000000"
        set v_64 [join "$val_hex_32_null $val_hex_32_0"  "" ]
    }
    #send_msg INFO 99123 "enable_val $enable_val enable_64bit_addr $enable_64bit_addr size $size $scale  val $val val_hex_32_0 $val_hex_32_0 val_hex_32_1 $val_hex_32_1 "
    set val_curr [get_property value  ${PARAM_VALUE.pciebar2axibar_axil_master} ]
    set val_lower_n  [ipgen::number_utils::hex2dec  [string range $val_curr end-3 end ]  ]
    if { ([get_property value ${PARAM_VALUE.axilite_master_en}]) && ($val_lower_n != 0 ) && (($scale  eq "Megabytes" )  || ($scale  eq  "Gigabytes" ))}    {
        set_property errmsg "Entered  Hexadecimal value must have lower 4 digits as 0  " ${PARAM_VALUE.pciebar2axibar_axil_master}
        return  false
    } elseif {[get_property value ${PARAM_VALUE.axilite_master_en}] } {
        return [RangeCheck4HexDec  0 $v_64 ${PARAM_VALUE.pciebar2axibar_axil_master}]
    } else {
        return true
    }
}

proc validate_PARAM_VALUE.pciebar2axibar_axist_bypass  {PARAM_VALUE.pciebar2axibar_axist_bypass PARAM_VALUE.axist_bypass_en PARAM_VALUE.axi_addr_width PARAM_VALUE.axist_bypass_scale PARAM_VALUE.axist_bypass_size } {

    set enable_val [get_property value ${PARAM_VALUE.axist_bypass_en}]
    set enable_64bit_addr [get_property value ${PARAM_VALUE.axi_addr_width}]
    set size  [get_property value ${PARAM_VALUE.axist_bypass_size}]
    set scale [get_property value ${PARAM_VALUE.axist_bypass_scale}]
    set val 0000
    set val_hex_32_0  [populate_A $size $scale $enable_64bit_addr $val 0 ]
    set val_hex_32_1  [populate_A $size $scale $enable_64bit_addr $val 1 ]

    if {$enable_64bit_addr == 64} {
        set v_64 [join "$val_hex_32_1 $val_hex_32_0" "" ]
    } else {
        set val_hex_32_null "00000000"
        set v_64 [join "$val_hex_32_null $val_hex_32_0"  "" ]
    }
    #send_msg INFO 99123 "enable_val $enable_val enable_64bit_addr $enable_64bit_addr size $size $scale  val $val val_hex_32_0 $val_hex_32_0 val_hex_32_1 $val_hex_32_1 "
    #set low_nib
    set val_curr [get_property value  ${PARAM_VALUE.pciebar2axibar_axist_bypass} ]
    set val_lower_n  [ipgen::number_utils::hex2dec  [string range $val_curr end-3 end ]  ]
    if {([get_property value ${PARAM_VALUE.axist_bypass_en}]) && ($val_lower_n != 0 ) && (($scale  eq "Megabytes" )  || ($scale  eq  "Gigabytes" ))}    {
        set_property errmsg "Entered  Hexadecimal value must have lower 4 digits as 0  " ${PARAM_VALUE.pciebar2axibar_axist_bypass}
        return  false
    } elseif {[get_property value ${PARAM_VALUE.axist_bypass_en}] } {
        return [RangeCheck4HexDec  0 $v_64 ${PARAM_VALUE.pciebar2axibar_axist_bypass}]
    } else {
        return true
    }
}

proc DT_pf0_bar_value_axist_bypass {PARAM_VALUE.axist_bypass_en PARAM_VALUE.axi_bypass_64bit_en PARAM_VALUE.axist_bypass_scale PARAM_VALUE.axist_bypass_size } {

    set enable_val [get_property value ${PARAM_VALUE.axist_bypass_en}]
    set enable_64bit [get_property value ${PARAM_VALUE.axi_bypass_64bit_en}]

    set size  [get_property value ${PARAM_VALUE.axist_bypass_size}]
    set scale [get_property value ${PARAM_VALUE.axist_bypass_scale}]
    set val  "FFFFF000"

    if {$enable_val } {
        if {$enable_64bit } {
            set val  "0100"
        } else {
            set val  "0000"
        }
    } else {
        set val  "0000"
    }
              if {$enable_64bit } {
              set val_hex_64_0  [populate_A $size $scale $enable_64bit $val 0 ]
              set val_hex_64_1  [populate_A $size $scale $enable_64bit $val 1 ]
              set v_64 [join "$val_hex_64_1 $val_hex_64_0" "" ]
	  } else {
              set v_64  [populate_A $size $scale $enable_64bit $val 0 ]
	  }
      return $v_64
}

proc DT_pf0_bar_value_axilite_master { PARAM_VALUE.axilite_master_en PARAM_VALUE.axil_master_64bit_en PARAM_VALUE.axilite_master_scale PARAM_VALUE.axilite_master_size } {

    set enable_val [get_property value ${PARAM_VALUE.axilite_master_en}]
    set enable_64bit [get_property value ${PARAM_VALUE.axil_master_64bit_en}]
    set size  [get_property value ${PARAM_VALUE.axilite_master_size}]
    set scale [get_property value ${PARAM_VALUE.axilite_master_scale}]
    set val  "FFFFF000"

    if {$enable_val } {
        if {$enable_64bit } {
            set val  "0100"
        } else {
            set val  "0000"
        }
    } else {
        set val  "0000"
    }

              if {$enable_64bit } {
              set val_hex_64_0  [populate_A $size $scale $enable_64bit $val 0 ]
              set val_hex_64_1  [populate_A $size $scale $enable_64bit $val 1 ]
              set v_64 [join "$val_hex_64_1 $val_hex_64_0" "" ]
	  } else {
              set v_64  [populate_A $size $scale $enable_64bit $val 0 ]
	  }
      return $v_64
}

proc update_MODELPARAM_VALUE.AXILITE_MASTER_CONTROL {MODELPARAM_VALUE.AXILITE_MASTER_CONTROL PARAM_VALUE.axilite_master_en PARAM_VALUE.axil_master_64bit_en} {
    set enable_val [get_property value ${PARAM_VALUE.axilite_master_en}]
    set enable_64bit [get_property value ${PARAM_VALUE.axil_master_64bit_en}]
    set val  "000"

    if {$enable_val } {
        if {$enable_64bit } {
            set val 0x5
        } else {
            set val 0x4
        }
    } else {
        set val  0x0
    }
    set_property value  $val ${MODELPARAM_VALUE.AXILITE_MASTER_CONTROL}
}

proc update_MODELPARAM_VALUE.XDMA_CONTROL {MODELPARAM_VALUE.XDMA_CONTROL PARAM_VALUE.xdma_en PARAM_VALUE.xdma_pcie_64bit_en PARAM_VALUE.axil_master_64bit_en PARAM_VALUE.axilite_master_en} {
    set enable_val        [get_property value ${PARAM_VALUE.xdma_en}]
    set enable_64bit      [get_property value ${PARAM_VALUE.xdma_pcie_64bit_en}]
    set val  "000"

    if {$enable_val} {
      if {$enable_64bit } { 
        set val 0x5
      } else {
        set val 0x4
      }
    } else {
        set val  0x0
    }
    set_property value  $val ${MODELPARAM_VALUE.XDMA_CONTROL}
}

proc update_MODELPARAM_VALUE.AXIST_BYPASS_CONTROL {MODELPARAM_VALUE.AXIST_BYPASS_CONTROL PARAM_VALUE.axist_bypass_en PARAM_VALUE.axi_bypass_64bit_en} {
    set enable_val [get_property value ${PARAM_VALUE.axist_bypass_en}]
    set enable_64bit [get_property value ${PARAM_VALUE.axi_bypass_64bit_en}]
    set val  "000"

    if {$enable_val } {
        if {$enable_64bit } {
            set val 0x5
        } else {
            set val 0x4
        }
    } else {
        set val  0x0
    }
    set_property value  $val ${MODELPARAM_VALUE.AXIST_BYPASS_CONTROL}
}

proc update_MODELPARAM_VALUE.XDMA_PCIE_64BIT_EN {MODELPARAM_VALUE.XDMA_PCIE_64BIT_EN PARAM_VALUE.xdma_pcie_64bit_en} {
    set_property value ${PARAM_VALUE.xdma_pcie_64bit_en} ${MODELPARAM_VALUE.XDMA_PCIE_64BIT_EN}
}

proc get_size_range {enable_val enable_64bit val_scale is_usplus} {
    # - Bytes         - Kilobytes         - Megabytes        - Gigabytes
    set range_list "2"

    switch $val_scale {
        "Bytes" {
            if {$enable_64bit} {
                set range_list "128, 256, 512"
            } else {
                set range_list "128, 256, 512"
            }
        }
        "Kilobytes" {
            if {$enable_64bit} {
                set range_list  "4, 8, 16, 32, 64, 128, 256, 512"
            } else {
                set range_list  "4, 8, 16, 32, 64, 128, 256, 512"
            }
        }
        "Megabytes" {
            if {$enable_64bit} {
                set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
            } else {
                set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
            }
         }
         "Gigabytes" {
            if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
                set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
            } else {
                set range_list "1, 2"
            }
         }
         "Terabytes" {
            if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
                set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
            } else {
                set range_list "1, 2"
            }
         }
         "Petabytes" {
            if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
                set range_list "1, 2, 4, 8, 16, 32, 64, 128, 256, 512"
            } else {
                set range_list "1, 2"
            }
         }
         "Exabytes" {
            if {$enable_64bit == "true" && $is_usplus == "TRUE"} {
                set range_list "1, 2, 4, 8"
            } else {
                set range_list "1, 2"
            }
         }
    }
    return $range_list
}

proc update_PARAM_VALUE.pf0_subsystem_id {PARAM_VALUE.pf0_subsystem_id PARAM_VALUE.device_port_type} {
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type} ]

    if {$device_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
        set_property enabled false ${PARAM_VALUE.pf0_subsystem_id}
    } else {
        set_property enabled true  ${PARAM_VALUE.pf0_subsystem_id}
    }
}

proc update_PARAM_VALUE.pf0_subsystem_vendor_id {PARAM_VALUE.pf0_subsystem_vendor_id PARAM_VALUE.device_port_type} {
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type} ]

    if {$device_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
        set_property enabled false ${PARAM_VALUE.pf0_subsystem_vendor_id}
    } else {
        set_property enabled true  ${PARAM_VALUE.pf0_subsystem_vendor_id}
    }
}

set parameterized_proc {
    proc update_MODELPARAM_VALUE.<<mp>>  { MODELPARAM_VALUE.<<mp>>  PARAM_VALUE.<<p>> } {
        set_property value  [get_property value   ${PARAM_VALUE.<<p>>}]  ${MODELPARAM_VALUE.<<mp>>}
    }
}

proc update_PARAM_VALUE.ext_startup_primitive {PARAM_VALUE.ext_startup_primitive PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.mcap_enablement} {
    set c_xfamily        [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set mcap_enablement      [get_property value ${PARAM_VALUE.mcap_enablement}]

    if {$c_xfamily == "kintexu" || $c_xfamily == "virtexu" } {
        if {$mcap_enablement == "None" || $mcap_enablement == "PR_over_PCIe"} {
            set_property value false ${PARAM_VALUE.ext_startup_primitive}
            set_property enabled false ${PARAM_VALUE.ext_startup_primitive}
        } else {
            set_property enabled true ${PARAM_VALUE.ext_startup_primitive}
        }
    } elseif {$c_xfamily == "virtexuplus" || $c_xfamily == "kintexuplus" || $c_xfamily == "zynquplus" || $c_xfamily == "zynquplusrfsoc" || $c_xfamily == "virtexuplushbm"} {
        set_property value false ${PARAM_VALUE.ext_startup_primitive}
        set_property enabled false ${PARAM_VALUE.ext_startup_primitive}
    } else {
        set_property value false ${PARAM_VALUE.ext_startup_primitive}
        set_property enabled false ${PARAM_VALUE.ext_startup_primitive}
    }
}

proc update_PARAM_VALUE.en_ext_ch_gt_drp {PARAM_VALUE.en_ext_ch_gt_drp PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.enable_ibert PARAM_VALUE.rx_detect} {
    set c_xfamily        [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
    set xcoValue [get_property value ${PARAM_VALUE.rx_detect}]

    if {$c_xfamily == "kintexu" || $c_xfamily == "virtexu" } {
        switch $xcoValue {
	      "Default" {
            if { [get_property value ${PARAM_VALUE.enable_ibert}] } {
              set_property enabled FALSE  ${PARAM_VALUE.en_ext_ch_gt_drp}
              set_property value FALSE  ${PARAM_VALUE.en_ext_ch_gt_drp}
            } else {
              set_property enabled TRUE  ${PARAM_VALUE.en_ext_ch_gt_drp}
              set_property value FALSE  ${PARAM_VALUE.en_ext_ch_gt_drp}
            }
	      }
        "Falling_Edge" {
          set_property enabled FALSE  ${PARAM_VALUE.en_ext_ch_gt_drp}
          set_property value FALSE  ${PARAM_VALUE.en_ext_ch_gt_drp}
          }
        }
     } else {
          set_property enabled TRUE  ${PARAM_VALUE.en_ext_ch_gt_drp}
     }
} 

proc update_PARAM_VALUE.gtcom_in_core_usp {PARAM_VALUE.gtcom_in_core_usp PARAM_VALUE.plltype PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.gtwiz_in_core_usp IPINST} {			

	if { [get_property value ${PARAM_VALUE.gtwiz_in_core_usp}] } {
	 set_property range "0,1,2" ${PARAM_VALUE.gtcom_in_core_usp} 
	 
     if {[get_property value ${PARAM_VALUE.plltype}] eq "CPLL" && [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] eq "5.0_GT/s"} {
		 set_property enabled false ${PARAM_VALUE.gtcom_in_core_usp}         
         set_property value 2 ${PARAM_VALUE.gtcom_in_core_usp}		 
     } elseif {[get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] eq "2.5_GT/s"} {         
         set_property enabled false ${PARAM_VALUE.gtcom_in_core_usp}
		 set_property value 2 ${PARAM_VALUE.gtcom_in_core_usp}		 
     } else {
         set_property enabled true ${PARAM_VALUE.gtcom_in_core_usp}
     }
  } else {	 	
	 set_property range "0,1" ${PARAM_VALUE.gtcom_in_core_usp} 
		
     if {[get_property value ${PARAM_VALUE.plltype}] eq "CPLL" && [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] eq "5.0_GT/s"} {         
		 set_property enabled false ${PARAM_VALUE.gtcom_in_core_usp}
         set_property value 1 ${PARAM_VALUE.gtcom_in_core_usp}		 
     } elseif {[get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] eq "2.5_GT/s"} {         
         set_property enabled false ${PARAM_VALUE.gtcom_in_core_usp}
		 set_property value 1 ${PARAM_VALUE.gtcom_in_core_usp}		 
     } else {
		 set_property enabled true ${PARAM_VALUE.gtcom_in_core_usp}
         set_property value 1 ${PARAM_VALUE.gtcom_in_core_usp}         
     }
  }

}


# changed in 2017.1. Refer the below proc for the chages. DO NOT DELETE this proc in comments

#foreach {param model_param} { s_axi_id_width C_S_AXI_ID_WIDTH c_s_axi_num_read C_S_AXI_NUM_READ c_s_axi_num_write  C_S_AXI_NUM_WRITE  c_m_axi_num_read C_M_AXI_NUM_READ c_m_axi_num_write C_M_AXI_NUM_WRITE en_ext_ch_gt_drp EXT_CH_GT_DRP dedicate_perst DEDICATE_PERST AXI_ADDR_WIDTH AXI_ADDR_WIDTH ext_startup_primitive EXT_STARTUP_PRIMITIVE en_pcie_drp PCIE3_DRP} {
    #set parameterized_proc_p  [regsub -all <<p>> $parameterized_proc $param ]
    #set  parameterized_proc_mp [regsub -all <<mp>> $parameterized_proc_p $model_param ]
    #eval $parameterized_proc_mp
#}

# C_S_AXI_NUM_WRITE, C_S_AXI_NUM_READ and C_M_AXI_NUM_READ are also derived from user parameter c_m_axi_num_write value now

foreach {param model_param} { s_axi_id_width C_S_AXI_ID_WIDTH c_m_axi_num_write C_M_AXI_NUM_READ c_m_axi_num_write C_S_AXI_NUM_WRITE c_m_axi_num_write C_S_AXI_NUM_READ en_ext_ch_gt_drp EXT_CH_GT_DRP dedicate_perst DEDICATE_PERST AXI_ADDR_WIDTH AXI_ADDR_WIDTH ext_startup_primitive EXT_STARTUP_PRIMITIVE en_pcie_drp PCIE3_DRP} {
    set parameterized_proc_p  [regsub -all <<p>> $parameterized_proc $param ]
    set  parameterized_proc_mp [regsub -all <<mp>> $parameterized_proc_p $model_param ]
    eval $parameterized_proc_mp
}

set parameterized_hex_proc {
    proc update_MODELPARAM_VALUE.<<mp>>  { MODELPARAM_VALUE.<<mp>>  PARAM_VALUE.<<p>> } {
        set paramValue [get_property value   ${PARAM_VALUE.<<p>>} ]
        if {[string toupper [string range  "$paramValue"  1 1] ] ne "X" } {
            set paramValue "0x$paramValue"
        }
        set_property value  "$paramValue" ${MODELPARAM_VALUE.<<mp>>}
    }
}

foreach {param model_param} {pf0_subsystem_id PF0_SUBSYSTEM_ID pf0_subsystem_vendor_id PF0_SUBSYSTEM_VENDOR_ID vendor_id PF0_VENDOR_ID pf0_revision_id PF0_REVISION_ID pf0_device_id PF0_DEVICE_ID pf0_class_code PF0_CLASS_CODE PF1_SUBSYSTEM_ID PF1_SUBSYSTEM_ID PF1_SUBSYSTEM_VENDOR_ID PF1_SUBSYSTEM_VENDOR_ID pf1_vendor_id PF1_VENDOR_ID PF1_REVISION_id PF1_REVISION_ID pf1_device_id PF1_DEVICE_ID pf1_class_code PF1_CLASS_CODE BASEADDR C_BASEADDR HIGHADDR C_HIGHADDR pciebar2axibar_3 C_PCIEBAR2AXIBAR_3 pciebar2axibar_4 C_PCIEBAR2AXIBAR_4 pciebar2axibar_5 C_PCIEBAR2AXIBAR_5 pf1_pciebar2axibar_0 PF1_PCIEBAR2AXIBAR_0 pf1_pciebar2axibar_1 PF1_PCIEBAR2AXIBAR_1 pf1_pciebar2axibar_2 PF1_PCIEBAR2AXIBAR_2 pf1_pciebar2axibar_3 PF1_PCIEBAR2AXIBAR_3 pf1_pciebar2axibar_4 PF1_PCIEBAR2AXIBAR_4 pf1_pciebar2axibar_5 PF1_PCIEBAR2AXIBAR_5} {
    set parameterized_hex_proc_p  [regsub -all <<p>> $parameterized_hex_proc $param ]
    set  parameterized_hex_proc_mp [regsub -all <<mp>> $parameterized_hex_proc_p $model_param ]
    eval $parameterized_hex_proc_mp
}

proc update_MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_0 {MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_0 PARAM_VALUE.pciebar2axibar_axil_master PARAM_VALUE.pciebar2axibar_0 PARAM_VALUE.functional_mode} { 
  set functional_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set val1 [get_property value ${PARAM_VALUE.pciebar2axibar_axil_master}]
  set val2 [get_property value ${PARAM_VALUE.pciebar2axibar_0}]


  if {$functional_mode == "DMA" || $functional_mode == "MQDMA"} { 
    if {[string toupper [string range "$val1" 1 1] ] ne "X" } { 
      set val1 "0x$val1"
    } 
    set_property value "$val1" ${MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_0}
  } else { 
  if {[string toupper [string range "$val2" 1 1] ] ne "X" } { 
    set val2 "0x$val2"
  } 
    set_property value "$val2" ${MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_0}
  }
}

proc update_MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_1 {MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_1 PARAM_VALUE.pciebar2axibar_xdma PARAM_VALUE.pciebar2axibar_1 PARAM_VALUE.functional_mode} {
  set functional_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set val1 [get_property value ${PARAM_VALUE.pciebar2axibar_xdma}]
  set val2 [get_property value ${PARAM_VALUE.pciebar2axibar_1}]

  if {$functional_mode == "DMA" || $functional_mode == "MQDMA"} { 
  if {[string toupper [string range "$val1" 1 1] ] ne "X" } { 
    set val1 "0x$val1"
  } 
    set_property value "$val1" ${MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_1}
  } else { 
  if {[string toupper [string range "$val2" 1 1] ] ne "X" } { 
    set val2 "0x$val2"
  } 
    set_property value "$val2" ${MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_1}
  }

}

proc update_MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_2 {MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_2 PARAM_VALUE.pciebar2axibar_axist_bypass PARAM_VALUE.pciebar2axibar_2 PARAM_VALUE.functional_mode} {
  set functional_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set val1 [get_property value ${PARAM_VALUE.pciebar2axibar_axist_bypass}]
  set val2 [get_property value ${PARAM_VALUE.pciebar2axibar_2}]

  if {$functional_mode == "DMA" || $functional_mode == "MQDMA"} { 
  if {[string toupper [string range "$val1" 1 1] ] ne "X" } { 
    set val1 "0x$val1"
  } 
    set_property value "$val1" ${MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_2}
  } else { 
  if {[string toupper [string range "$val2" 1 1] ] ne "X" } { 
    set val2 "0x$val2"
  } 
    set_property value "$val2" ${MODELPARAM_VALUE.C_PCIEBAR2AXIBAR_2}
  }

}

proc update_MODELPARAM_VALUE.MCAP_ENABLEMENT  { MODELPARAM_VALUE.MCAP_ENABLEMENT  PARAM_VALUE.mcap_enablement } {
    set xcoValue [get_property value ${PARAM_VALUE.mcap_enablement}]
    set mcap_enablement_val XXXX
    switch $xcoValue {
        "None" {
            set mcap_enablement_val NONE
        }
        "Tandem" {
            set mcap_enablement_val TANDEM
        }
        "Tandem_with_Field_Updates" {
            set mcap_enablement_val TANDEM_FIELD_UPDATES
        }
        "PR_over_PCIe" {
            set mcap_enablement_val PR
        }
        "Tandem_PROM" {
            set mcap_enablement_val TANDEM_PROM
        }
        "Tandem_PCIe" {
            set mcap_enablement_val TANDEM_PCIE
        }
        "Tandem_PCIe_with_Field_Updates" {
            set mcap_enablement_val TANDEM_PCIE_FIELD_UPDATES
        }
    }
    set_property value $mcap_enablement_val ${MODELPARAM_VALUE.MCAP_ENABLEMENT}
}

proc update_MODELPARAM_VALUE.DMA_RESET_SOURCE_SEL {MODELPARAM_VALUE.DMA_RESET_SOURCE_SEL PARAM_VALUE.dma_reset_source_sel} {

  set rst_source [get_property value ${PARAM_VALUE.dma_reset_source_sel}]

  if {$rst_source == "User_Reset" } { 
    set val 0
  } elseif {$rst_source == "Phy_Ready" } { 
    set val 1
  } else {
    set val 2
  }

  set_property value $val ${MODELPARAM_VALUE.DMA_RESET_SOURCE_SEL}
}


proc update_MODELPARAM_VALUE.AXILITE_MASTER_APERTURE_SIZE {MODELPARAM_VALUE.AXILITE_MASTER_APERTURE_SIZE PARAM_VALUE.axilite_master_en  PARAM_VALUE.axilite_master_scale PARAM_VALUE.axilite_master_size PARAM_VALUE.device_port_type} {
    set enable_val [get_property value ${PARAM_VALUE.axilite_master_en}]
    set val_scale [get_property value ${PARAM_VALUE.axilite_master_scale}]
    set val_size  [get_property value ${PARAM_VALUE.axilite_master_size}]
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type}]

    set value [ get_aperture_value  $enable_val $val_size $val_scale $device_port_type]
    set_property value  $value  ${MODELPARAM_VALUE.AXILITE_MASTER_APERTURE_SIZE}
}

proc update_MODELPARAM_VALUE.XDMA_APERTURE_SIZE {MODELPARAM_VALUE.XDMA_APERTURE_SIZE PARAM_VALUE.xdma_scale PARAM_VALUE.xdma_size PARAM_VALUE.device_port_type} {
    set val_scale [get_property value ${PARAM_VALUE.xdma_scale}]
    set val_size  [get_property value ${PARAM_VALUE.xdma_size}]
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type}]
    set value    [get_aperture_value  1 $val_size $val_scale $device_port_type]
    set_property value  $value  ${MODELPARAM_VALUE.XDMA_APERTURE_SIZE}
}

proc update_MODELPARAM_VALUE.AXIST_BYPASS_APERTURE_SIZE {MODELPARAM_VALUE.AXIST_BYPASS_APERTURE_SIZE PARAM_VALUE.axist_bypass_en  PARAM_VALUE.axist_bypass_scale PARAM_VALUE.axist_bypass_size PARAM_VALUE.device_port_type} {
    set enable_val [get_property value ${PARAM_VALUE.axist_bypass_en}]
    set val_scale [get_property value ${PARAM_VALUE.axist_bypass_scale}]
    set val_size  [get_property value ${PARAM_VALUE.axist_bypass_size}]
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type}]

    set value [ get_aperture_value  $enable_val $val_size $val_scale $device_port_type]
    set_property value  $value  ${MODELPARAM_VALUE.AXIST_BYPASS_APERTURE_SIZE}
}

proc update_MODELPARAM_VALUE.XDMA_AXI_INTF_MM {PARAM_VALUE.xdma_axi_intf_mm MODELPARAM_VALUE.XDMA_AXI_INTF_MM} {
    set xdma_axi_intf_mm [get_property value ${PARAM_VALUE.xdma_axi_intf_mm}]

    switch $xdma_axi_intf_mm {
        "AXI_Memory_Mapped" {set val 1 }
        "AXI_Stream" {set val 0}
    }
    set_property value $val ${MODELPARAM_VALUE.XDMA_AXI_INTF_MM}
}

proc update_MODELPARAM_VALUE.AXI_DATA_WIDTH {MODELPARAM_VALUE.AXI_DATA_WIDTH PARAM_VALUE.axi_data_width } {

    set AXI_DWIDTH [get_property value ${PARAM_VALUE.axi_data_width}]
    switch $AXI_DWIDTH {
        "64_bit"  {set val 64}
        "128_bit" {set val 128}
        "256_bit" {set val 256}
        "512_bit" {set val 512}
    }
    set_property value $val ${MODELPARAM_VALUE.AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH {MODELPARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH PARAM_VALUE.pl_link_cap_max_link_width } {
    set LINK_WIDTH [get_property value ${PARAM_VALUE.pl_link_cap_max_link_width}]
    switch $LINK_WIDTH {
        "X1" {set val 1}
        "X2" {set val 2}
        "X4" {set val 4}
        "X8" {set val 8}
        "X16" {set val 16}
    }
    set_property value $val ${MODELPARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}
}

proc update_MODELPARAM_VALUE.PL_UPSTREAM_FACING  { MODELPARAM_VALUE.PL_UPSTREAM_FACING  PARAM_VALUE.device_port_type } {
    set device_port_type [ get_property value ${PARAM_VALUE.device_port_type} ]
    if {$device_port_type eq "PCI_Express_Endpoint_device"} {
        set_property value  true ${MODELPARAM_VALUE.PL_UPSTREAM_FACING}
    } else {
        set_property value  false ${MODELPARAM_VALUE.PL_UPSTREAM_FACING}
    }
}

proc update_MODELPARAM_VALUE.TL_LEGACY_MODE_ENABLE  { MODELPARAM_VALUE.TL_LEGACY_MODE_ENABLE  PARAM_VALUE.device_port_type } {
    set device_port_type [ get_property value ${PARAM_VALUE.device_port_type} ]
    if {$device_port_type eq "PCI_Express_Endpoint_device"} {
        set_property value  false ${MODELPARAM_VALUE.TL_LEGACY_MODE_ENABLE}
    } else {
        set_property value  true ${MODELPARAM_VALUE.TL_LEGACY_MODE_ENABLE}
    }
}

proc update_MODELPARAM_VALUE.PLL_TYPE {MODELPARAM_VALUE.PLL_TYPE PARAM_VALUE.plltype} {
    set val [ get_property value ${PARAM_VALUE.plltype}]
    switch $val {
        "CPLL"  {set simVal 0}
        "QPLL0" {set simVal 1}
        "QPLL1" {set simVal 2}
    }
    set_property value $simVal ${MODELPARAM_VALUE.PLL_TYPE}
}

proc update_MODELPARAM_VALUE.SHARED_LOGIC_BOTH {MODELPARAM_VALUE.SHARED_LOGIC_BOTH PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.Shared_Logic_Both} {
    set val [ get_property value ${PARAM_VALUE.Shared_Logic_Both}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {!($c_xfamily eq "VIRTEXU"  ||  $c_xfamily eq "KINTEXU") && $val eq "true"} {
        set_property value  true ${MODELPARAM_VALUE.SHARED_LOGIC_BOTH}
    } else {
        set_property value  false ${MODELPARAM_VALUE.SHARED_LOGIC_BOTH}
    }
}

proc update_MODELPARAM_VALUE.SHARED_LOGIC_CLK {MODELPARAM_VALUE.SHARED_LOGIC_CLK PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.Shared_Logic_Clk} {
    set val [ get_property value ${PARAM_VALUE.Shared_Logic_Clk}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {!($c_xfamily eq "VIRTEXU"  ||  $c_xfamily eq "KINTEXU") && $val eq "true"} {
    set_property value  true ${MODELPARAM_VALUE.SHARED_LOGIC_CLK}
    } else {
    set_property value  false ${MODELPARAM_VALUE.SHARED_LOGIC_CLK}
    }

}

proc update_MODELPARAM_VALUE.SHARED_LOGIC_GTC {MODELPARAM_VALUE.SHARED_LOGIC_GTC PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.Shared_Logic_Gtc} {
    set val [ get_property value ${PARAM_VALUE.Shared_Logic_Gtc}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    if {!($c_xfamily eq "VIRTEXU"  ||  $c_xfamily eq "KINTEXU") && $val eq "true"} {
        set_property value  true ${MODELPARAM_VALUE.SHARED_LOGIC_GTC}
    } else {
        set_property value  false ${MODELPARAM_VALUE.SHARED_LOGIC_GTC}
    }
}

proc update_MODELPARAM_VALUE.SHARED_LOGIC {MODELPARAM_VALUE.SHARED_LOGIC PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.Shared_Logic} {
    set val [ get_property value ${PARAM_VALUE.Shared_Logic}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]

    if {($c_xfamily eq "VIRTEXU"  ||  $c_xfamily eq "KINTEXU") && ($val == 1)} {
        set simVal 1
    } elseif {$c_xfamily eq "VIRTEXUPLUS" || $c_xfamily eq "KINTEXUPLUS" || $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
        set simVal 1
    } else {
        set simVal 0
    }
    set_property value $simVal ${MODELPARAM_VALUE.SHARED_LOGIC}
}

proc update_MODELPARAM_VALUE.CORE_CLK_FREQ {MODELPARAM_VALUE.CORE_CLK_FREQ PARAM_VALUE.coreclk_freq} {
    set val [ get_property value ${PARAM_VALUE.coreclk_freq}]
    set simVal 1

    if { $val == "250" } {
        set simVal 1
    } elseif { $val == "500" } {
        set simVal 2
    }
    set_property value $simVal ${MODELPARAM_VALUE.CORE_CLK_FREQ}
}

proc update_MODELPARAM_VALUE.XDMA_NUM_PCIE_TAG {PARAM_VALUE.pcie_extended_tag MODELPARAM_VALUE.XDMA_NUM_PCIE_TAG PROJECT_PARAM.ARCHITECTURE} {
   set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE}]
   set ext_tag    [get_property value ${PARAM_VALUE.pcie_extended_tag}]

   if {$ext_tag == "true"} { 
     if {$c_xfamily eq "VIRTEXU" || $c_xfamily eq "KINTEXU" || $c_xfamily eq "VIRTEX7" } {
       set val 64
     } elseif {$c_xfamily eq "VIRTEXUPLUS" || $c_xfamily eq "KINTEXUPLUS" || $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC" || $c_xfamily eq "VIRTEXUPLUSHBM"} {
       set val 256
     } else { 
       set val 64
     }
   } else {
     set val 32
   }
   set_property value $val ${MODELPARAM_VALUE.XDMA_NUM_PCIE_TAG}
}

proc update_MODELPARAM_VALUE.USER_CLK_FREQ {MODELPARAM_VALUE.USER_CLK_FREQ PARAM_VALUE.axisten_freq PARAM_VALUE.axi_data_width PROJECT_PARAM.ARCHITECTURE} {
    set val [ get_property value ${PARAM_VALUE.axisten_freq}]
    set axi_width [get_property value ${PARAM_VALUE.axi_data_width}]
    set c_xfamily  [string toupper ${PROJECT_PARAM.ARCHITECTURE} ]
    set simVal 1

  if {$c_xfamily eq "VIRTEXUPLUS" || $c_xfamily eq "KINTEXUPLUS" || $c_xfamily eq "ZYNQUPLUS" || $c_xfamily eq "ZYNQUPLUSRFSOC"} { 

    if { $val == "62.5" } {
        set simVal 0
    } elseif { $val == "125" } {
        set simVal 1
    } elseif { $val == "250" } {
        if {$axi_width == "512_bit"} { 
          set simVal 3
        } else { 
          set simVal 2
        }
    }

  } else { 

    if { $val == "62.5" } {
        set simVal 1
    } elseif { $val == "125" } {
        set simVal 2
    } elseif { $val == "250" } {
        set simVal 3
    }

  }

    set_property value $simVal ${MODELPARAM_VALUE.USER_CLK_FREQ}
}


proc update_MODELPARAM_VALUE.PF0_INTERRUPT_PIN {MODELPARAM_VALUE.PF0_INTERRUPT_PIN PARAM_VALUE.pf0_interrupt_pin } {
    set pf0_interrupt_pin [get_property value ${PARAM_VALUE.pf0_interrupt_pin}]
    set xcoValue 0
    switch $pf0_interrupt_pin {
        "None" {set xcoValue 0}
        "INTA" {set xcoValue 1}
        "INTB" {set xcoValue 2}
        "INTC" {set xcoValue 3}
        "INTD" {set xcoValue 4}
    }
    set_property value $xcoValue ${MODELPARAM_VALUE.PF0_INTERRUPT_PIN}
}

proc update_MODELPARAM_VALUE.C_COMP_TIMEOUT {MODELPARAM_VALUE.C_COMP_TIMEOUT PARAM_VALUE.comp_timeout} {
    set comp_timeout [get_property value ${PARAM_VALUE.comp_timeout}]
    
    set val 0
    switch $comp_timeout {
        "50us" {set val 0 }
        "50ms" {set val 1 }
    }
    set_property value $val ${MODELPARAM_VALUE.C_COMP_TIMEOUT}
}

proc update_MODELPARAM_VALUE.C_TIMEOUT0_SEL {MODELPARAM_VALUE.C_TIMEOUT0_SEL PARAM_VALUE.timeout0_sel} {
    set_property value [get_property value ${PARAM_VALUE.timeout0_sel}] ${MODELPARAM_VALUE.C_TIMEOUT0_SEL}
}

proc update_MODELPARAM_VALUE.C_TIMEOUT1_SEL {MODELPARAM_VALUE.C_TIMEOUT1_SEL PARAM_VALUE.timeout1_sel} {
    set_property value [get_property value ${PARAM_VALUE.timeout1_sel}] ${MODELPARAM_VALUE.C_TIMEOUT1_SEL}
}

proc update_MODELPARAM_VALUE.C_TIMEOUT_MULT {MODELPARAM_VALUE.C_TIMEOUT_MULT PARAM_VALUE.timeout_mult} {
    set_property value [get_property value ${PARAM_VALUE.timeout_mult}] ${MODELPARAM_VALUE.C_TIMEOUT_MULT}
}

proc update_MODELPARAM_VALUE.C_OLD_BRIDGE_TIMEOUT {MODELPARAM_VALUE.C_OLD_BRIDGE_TIMEOUT PARAM_VALUE.old_bridge_timeout} {
    set old_bridge_timeout [get_property value ${PARAM_VALUE.old_bridge_timeout}]

    if {$old_bridge_timeout} {
        set val 1    
    } else {
        set val 0
    }
    set_property value $val ${MODELPARAM_VALUE.C_OLD_BRIDGE_TIMEOUT}
}

proc update_MODELPARAM_VALUE.DISABLE_BRAM_PIPELINE {MODELPARAM_VALUE.DISABLE_BRAM_PIPELINE PARAM_VALUE.disable_bram_pipeline} {
   set_property value [string toupper [get_property value ${PARAM_VALUE.disable_bram_pipeline}]] ${MODELPARAM_VALUE.DISABLE_BRAM_PIPELINE}
}
proc update_MODELPARAM_VALUE.DISABLE_EQ_SYNCHRONIZER {MODELPARAM_VALUE.DISABLE_EQ_SYNCHRONIZER PARAM_VALUE.disable_eq_synchronizer} {
   set_property value [string toupper [get_property value ${PARAM_VALUE.disable_eq_synchronizer}] ] ${MODELPARAM_VALUE.DISABLE_EQ_SYNCHRONIZER}
}
proc update_MODELPARAM_VALUE.C_ENABLE_RESOURCE_REDUCTION {MODELPARAM_VALUE.C_ENABLE_RESOURCE_REDUCTION PARAM_VALUE.enable_resource_reduction} {
   set_property value [string toupper [get_property value ${PARAM_VALUE.enable_resource_reduction}] ] ${MODELPARAM_VALUE.C_ENABLE_RESOURCE_REDUCTION}
}
proc update_MODELPARAM_VALUE.PF0_MSI_CAP_MULTIMSGCAP {MODELPARAM_VALUE.PF0_MSI_CAP_MULTIMSGCAP PARAM_VALUE.pf0_msi_cap_multimsgcap } {
    set pf0_msi_cap_multimsgcap [get_property value ${PARAM_VALUE.pf0_msi_cap_multimsgcap}]
    set val 0
    switch $pf0_msi_cap_multimsgcap {
        "1_vector"   { set val 0 }
        "2_vectors"  { set val 1 }
        "4_vectors"  { set val 2 }
        "8_vectors"  { set val 3 }
        "16_vectors" { set val 4 }
        "32_vectors" { set val 5 }
    }
    set_property value $val ${MODELPARAM_VALUE.PF0_MSI_CAP_MULTIMSGCAP}
}

proc update_MODELPARAM_VALUE.SYS_RESET_POLARITY  { MODELPARAM_VALUE.SYS_RESET_POLARITY  PARAM_VALUE.sys_reset_polarity } {
    set sys_reset_polarity [ get_property value ${PARAM_VALUE.sys_reset_polarity} ]
    if {$sys_reset_polarity eq "ACTIVE_HIGH"} {
        set_property value  1 ${MODELPARAM_VALUE.SYS_RESET_POLARITY}
    } else {
        set_property value  0 ${MODELPARAM_VALUE.SYS_RESET_POLARITY}
    }
}

proc RangeCheck4HexDec { MinValue MaxValue PARAM_HANDLE} {
    set paramValue [get_property value  ${PARAM_HANDLE} ]
    if {[string toupper [string range  $paramValue  1 1] ]eq "X" } {
        set paramValue [string range $paramValue  2 end]
    }
    if {[string toupper [string range  $MinValue  1 1] ]eq "X" } {
        set MinValue [string range $MinValue  2 end]
    }
    if {[string toupper [string range  $MaxValue  1 1] ]eq "X" } {
        set MaxValue [string range $MaxValue  2 end]
    }
    #send_msg INFO 123 " m:$MinValue M:$MinValue H:$PARAM_HANDLE V:$paramValue"

    if {[regexp -all {[a-fA-F0-9]} $paramValue] != [ string length $paramValue ]} {
        set_property errmsg "Entered invalid Hexadecimal value $paramValue" ${PARAM_HANDLE}
        return false
    }
    if {$paramValue  == ""} {
        set_property errmsg "Entered invalid Hexadecimal value $paramValue" ${PARAM_HANDLE}
        return false
    }

    if {[expr 0x$MaxValue ] < [expr 0x$paramValue ] ||  [expr 0x$paramValue ] < [expr 0x$MinValue]} {
        set_property errmsg "Entered  Hexadecimal value $paramValue is out of range." ${PARAM_HANDLE}
        return false
    }

    if {[string length $MaxValue]<[string length $paramValue]} {
        set_property errmsg "Entered  Hexadecimal value $paramValue is out of range." ${PARAM_HANDLE}
        return false
    }
    return true
}

set val_set {
    proc validate_PARAM_VALUE.<<PARAM>> { PARAM_VALUE.<<PARAM>> } {
        return [RangeCheck4HexDec  <<min>> <<max>> ${PARAM_VALUE.<<PARAM>>} ]
    }
}

foreach {param range} {pf0_device_id "0000,FFFF" vendor_id "0000,FFFF" pf0_revision_id "00,FF"  pf0_subsystem_vendor_id "0000,FFFF"  pf0_subsystem_id "0000,FFFF" pf0_class_code "000000,FFFFFF" pf0_class_code_interface "00,FF"  pf0_class_code_base "00,FF"  pf0_class_code_sub "00,FF" pf1_device_id "0000,FFFF" pf1_vendor_id "0000,FFFF" PF1_REVISION_ID "00,FF"  PF1_SUBSYSTEM_VENDOR_ID "0000,FFFF"  PF1_SUBSYSTEM_ID "0000,FFFF" pf1_class_code "000000,FFFFFF" pf1_class_code_interface "00,FF"  pf1_class_code_base "00,FF"  pf1_class_code_sub "00,FF" } {
    set min [lindex [split $range , ] 0 ]
    set max [lindex [split $range , ] 1 ]
    set val_set_1   [regsub -all <<min>> $val_set $min ]
    set val_set_2   [regsub -all <<PARAM>> $val_set_1 $param ]
    set  val_set_3 [regsub -all <<max>> $val_set_2 $max ]
    eval $val_set_3
}

proc get_aperture_value {enable_val val_size  val_scale device_port_type} {
    # - Bytes         - Kilobytes         - Megabytes        - Gigabytes
    set range_list "2"
    if {$device_port_type ne "Root_Port_of_PCI_Express_Root_Complex"} {
        switch $val_size {
            1 {
                switch $val_scale {
                    "Bytes"      { set value  "NA" }
                    "Kilobytes"  { set value  "03" }
                    "Megabytes"  { set value  "0D" }
                    "Gigabytes"  { set value  "17" }
                    "Terabytes"  { set value  "21" }
                    "Petabytes"  { set value  "2B" }
                    "Exabytes"   { set value  "35" }
                }
            }
            2 {
                switch $val_scale {
                    "Bytes"      { set value  "NA" }
                    "Kilobytes"  { set value  "04" }
                    "Megabytes"  { set value  "0E" }
                    "Gigabytes"  { set value  "18" }
                    "Terabytes"  { set value  "22" }
                    "Petabytes"  { set value  "2C" }
                    "Exabytes"   { set value  "36" }
                }
            }
            4 {
                switch $val_scale {
                    "Bytes"      { set value  "NA" }
                    "Kilobytes"  { set value  "05" }
                    "Megabytes"  { set value  "0F" }
                    "Gigabytes"  { set value  "19" }
                    "Terabytes"  { set value  "23" }
                    "Petabytes"  { set value  "2D" }
                    "Exabytes"   { set value  "37" }
                }
            }
            8 {
                switch $val_scale {
                    "Bytes"      { set value  "NA" }
                    "Kilobytes"  { set value  "06" }
                    "Megabytes"  { set value  "10" }
                    "Gigabytes"  { set value  "1A" }
                    "Terabytes"  { set value  "24" }
                    "Petabytes"  { set value  "2E" }
                    "Exabytes"   { set value  "38" }
                }
            }
            16 {
                switch $val_scale {
                    "Bytes"      { set value  "NA" }
                    "Kilobytes"  { set value  "07" }
                    "Megabytes"  { set value  "11" }
                    "Gigabytes"  { set value  "1B" }
                    "Terabytes"  { set value  "25" }
                    "Petabytes"  { set value  "2F" }
                    "Exabytes"   { set value  "39" }
                }
            }
            32 {
                switch $val_scale {
                    "Bytes"      { set value  "NA" }
                    "Kilobytes"  { set value  "08" }
                    "Megabytes"  { set value  "12" }
                    "Gigabytes"  { set value  "1C" }
                    "Terabytes"  { set value  "26" }
                    "Petabytes"  { set value  "30" }
                    "Exabytes"   { set value  "3A" }
                }
            }
            64 {
                switch $val_scale {
                    "Bytes"      { set value  "NA" }
                    "Kilobytes"  { set value  "09" }
                    "Megabytes"  { set value  "13" }
                    "Gigabytes"  { set value  "1D" }
                    "Terabytes"  { set value  "27" }
                    "Petabytes"  { set value  "31" }
                    "Exabytes"   { set value  "3B" }
                }
            }
            128 {
                switch $val_scale {
                    "Bytes"      { set value  "00" }
                    "Kilobytes"  { set value  "0A" }
                    "Megabytes"  { set value  "14" }
                    "Gigabytes"  { set value  "1E" }
                    "Terabytes"  { set value  "28" }
                    "Petabytes"  { set value  "32" }
                    "Exabytes"   { set value  "3C" }
                }
            }
            256 {
                switch $val_scale {
                    "Bytes"      { set value  "01" }
                    "Kilobytes"  { set value  "0B" }
                    "Megabytes"  { set value  "15" }
                    "Gigabytes"  { set value  "1F" }
                    "Terabytes"  { set value  "29" }
                    "Petabytes"  { set value  "33" }
                    "Exabytes"   { set value  "3D" }
                }
           }
           512 {
                switch $val_scale {
                    "Bytes"      { set value  "02" }
                    "Kilobytes"  { set value  "0C" }
                    "Megabytes"  { set value  "16" }
                    "Gigabytes"  { set value  "20" }
                    "Terabytes"  { set value  "2A" }
                    "Petabytes"  { set value  "34" }
                    "Exabytes"   { set value  "3E" }
                }
            }
        }
    } else {
        switch $val_size {
            1 {
                switch $val_scale {
                    "Bytes"      { set value  "NA" }
                    "Kilobytes"  { set value  "08" }
                    "Megabytes"  { set value  "12" }
                    "Gigabytes"  { set value  "1C" }
                    "Terabytes"  { set value  "26" }
                    "Petabytes"  { set value  "30" }
                    "Exabytes"   { set value  "3A" }
                }
            }
            2 {
                switch $val_scale {
                    "Bytes"      { set value  "NA" }
                    "Kilobytes"  { set value  "09" }
                    "Megabytes"  { set value  "13" }
                    "Gigabytes"  { set value  "1D" }
                    "Terabytes"  { set value  "27" }
                    "Petabytes"  { set value  "31" }
                    "Exabytes"   { set value  "3B" }
                }
            }
            4 {
                switch $val_scale {
                    "Bytes"      { set value  "00" }
                    "Kilobytes"  { set value  "0A" }
                    "Megabytes"  { set value  "14" }
                    "Gigabytes"  { set value  "1E" }
                    "Terabytes"  { set value  "28" }
                    "Petabytes"  { set value  "32" }
                    "Exabytes"   { set value  "3C" }
                }
            }
            8 {
                switch $val_scale {
                    "Bytes"      { set value  "01" }
                    "Kilobytes"  { set value  "0B" }
                    "Megabytes"  { set value  "15" }
                    "Gigabytes"  { set value  "1F" }
                    "Terabytes"  { set value  "29" }
                    "Petabytes"  { set value  "33" }
                    "Exabytes"   { set value  "3D" }
                }
            }
            16 {
                switch $val_scale {
                    "Bytes"      { set value  "02" }
                    "Kilobytes"  { set value  "0C" }
                    "Megabytes"  { set value  "16" }
                    "Gigabytes"  { set value  "20" }
                    "Terabytes"  { set value  "2A" }
                    "Petabytes"  { set value  "34" }
                    "Exabytes"   { set value  "3E" }
                }
            }
            32 {
                switch $val_scale {
                    "Bytes"      { set value  "03" }
                    "Kilobytes"  { set value  "0D" }
                    "Megabytes"  { set value  "17" }
                    "Gigabytes"  { set value  "21" }
                    "Terabytes"  { set value  "2B" }
                    "Petabytes"  { set value  "35" }
                    "Exabytes"   { set value  "3F" }
                }
            }
            64 {
                switch $val_scale {
                    "Bytes"      { set value  "04" }
                    "Kilobytes"  { set value  "0E" }
                    "Megabytes"  { set value  "18" }
                    "Gigabytes"  { set value  "22" }
                    "Terabytes"  { set value  "2C" }
                    "Petabytes"  { set value  "36" }
                    "Exabytes"   { set value  "40" }
                }
            }
            128 {
                switch $val_scale {
                    "Bytes"      { set value  "05" }
                    "Kilobytes"  { set value  "0F" }
                    "Megabytes"  { set value  "19" }
                    "Gigabytes"  { set value  "23" }
                    "Terabytes"  { set value  "2D" }
                    "Petabytes"  { set value  "37" }
                    "Exabytes"   { set value  "41" }
                }
            }
            256 {
                switch $val_scale {
                    "Bytes"      { set value  "06" }
                    "Kilobytes"  { set value  "10" }
                    "Megabytes"  { set value  "1A" }
                    "Gigabytes"  { set value  "24" }
                    "Terabytes"  { set value  "2E" }
                    "Petabytes"  { set value  "38" }
                    "Exabytes"   { set value  "42" }
                }
            }
            512 {
                switch $val_scale {
                    "Bytes"      { set value  "07" }
                    "Kilobytes"  { set value  "11" }
                    "Megabytes"  { set value  "1B" }
                    "Gigabytes"  { set value  "25" }
                    "Terabytes"  { set value  "2F" }
                    "Petabytes"  { set value  "39" }
                    "Exabytes"   { set value  "43" }
                }
            }
        }
    }
    return 0x$value
}

proc update_MODELPARAM_VALUE.EN_WCHNL_0 {PARAM_VALUE.xdma_wnum_chnl MODELPARAM_VALUE.EN_WCHNL_0} {
    set num_wchnl_en [get_property value ${PARAM_VALUE.xdma_wnum_chnl}]

    if {$num_wchnl_en >= 1} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_WCHNL_0}
}

proc update_MODELPARAM_VALUE.EN_WCHNL_1 {PARAM_VALUE.xdma_wnum_chnl MODELPARAM_VALUE.EN_WCHNL_1} {
    set num_wchnl_en [get_property value ${PARAM_VALUE.xdma_wnum_chnl}]

    if {$num_wchnl_en >= 2} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_WCHNL_1}
}

proc update_MODELPARAM_VALUE.EN_WCHNL_2 {PARAM_VALUE.xdma_wnum_chnl MODELPARAM_VALUE.EN_WCHNL_2} {
    set num_wchnl_en [get_property value ${PARAM_VALUE.xdma_wnum_chnl}]

    if {$num_wchnl_en >= 3} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_WCHNL_2}
}

proc update_MODELPARAM_VALUE.EN_WCHNL_3 {PARAM_VALUE.xdma_wnum_chnl MODELPARAM_VALUE.EN_WCHNL_3} {
    set num_wchnl_en [get_property value ${PARAM_VALUE.xdma_wnum_chnl}]

    if {$num_wchnl_en >= 4} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
   set_property value $val ${MODELPARAM_VALUE.EN_WCHNL_3}
}

proc update_MODELPARAM_VALUE.EN_WCHNL_4 {PARAM_VALUE.xdma_wnum_chnl MODELPARAM_VALUE.EN_WCHNL_4} {
    set num_wchnl_en [get_property value ${PARAM_VALUE.xdma_wnum_chnl}]

    if {$num_wchnl_en >= 5} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_WCHNL_4}
}

proc update_MODELPARAM_VALUE.EN_WCHNL_5 {PARAM_VALUE.xdma_wnum_chnl MODELPARAM_VALUE.EN_WCHNL_5} {
    set num_wchnl_en [get_property value ${PARAM_VALUE.xdma_wnum_chnl}]

    if {$num_wchnl_en >= 6} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_WCHNL_5}
}

proc update_MODELPARAM_VALUE.EN_WCHNL_6 {PARAM_VALUE.xdma_wnum_chnl MODELPARAM_VALUE.EN_WCHNL_6} {
    set num_wchnl_en [get_property value ${PARAM_VALUE.xdma_wnum_chnl}]

    if {$num_wchnl_en >= 7} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_WCHNL_6}
}

proc update_MODELPARAM_VALUE.EN_WCHNL_7 {PARAM_VALUE.xdma_wnum_chnl MODELPARAM_VALUE.EN_WCHNL_7} {
    set num_wchnl_en [get_property value ${PARAM_VALUE.xdma_wnum_chnl}]

    if {$num_wchnl_en >= 8} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_WCHNL_7}
}

proc update_MODELPARAM_VALUE.EN_RCHNL_0 {PARAM_VALUE.xdma_rnum_chnl MODELPARAM_VALUE.EN_RCHNL_0} {
    set num_rchnl_en [get_property value ${PARAM_VALUE.xdma_rnum_chnl}]

    if {$num_rchnl_en >= 1} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_RCHNL_0}
}

proc update_MODELPARAM_VALUE.EN_RCHNL_1 {PARAM_VALUE.xdma_rnum_chnl MODELPARAM_VALUE.EN_RCHNL_1} {
    set num_rchnl_en [get_property value ${PARAM_VALUE.xdma_rnum_chnl}]

    if {$num_rchnl_en >= 2} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_RCHNL_1}
}

proc update_MODELPARAM_VALUE.EN_RCHNL_2 {PARAM_VALUE.xdma_rnum_chnl MODELPARAM_VALUE.EN_RCHNL_2} {
    set num_rchnl_en [get_property value ${PARAM_VALUE.xdma_rnum_chnl}]

    if {$num_rchnl_en >= 3} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_RCHNL_2}
}

proc update_MODELPARAM_VALUE.EN_RCHNL_3 {PARAM_VALUE.xdma_rnum_chnl MODELPARAM_VALUE.EN_RCHNL_3} {
    set num_rchnl_en [get_property value ${PARAM_VALUE.xdma_rnum_chnl}]

    if {$num_rchnl_en >= 4} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_RCHNL_3}
}

proc update_MODELPARAM_VALUE.EN_RCHNL_4 {PARAM_VALUE.xdma_rnum_chnl MODELPARAM_VALUE.EN_RCHNL_4} {
    set num_rchnl_en [get_property value ${PARAM_VALUE.xdma_rnum_chnl}]

    if {$num_rchnl_en >= 5} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_RCHNL_4}
}

proc update_MODELPARAM_VALUE.EN_RCHNL_5 {PARAM_VALUE.xdma_rnum_chnl MODELPARAM_VALUE.EN_RCHNL_5} {
    set num_rchnl_en [get_property value ${PARAM_VALUE.xdma_rnum_chnl}]

    if {$num_rchnl_en >= 6} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_RCHNL_5}
}

proc update_MODELPARAM_VALUE.EN_RCHNL_6 {PARAM_VALUE.xdma_rnum_chnl MODELPARAM_VALUE.EN_RCHNL_6} {
    set num_rchnl_en [get_property value ${PARAM_VALUE.xdma_rnum_chnl}]

    if {$num_rchnl_en >= 7} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_RCHNL_6}
}

proc update_MODELPARAM_VALUE.EN_RCHNL_7 {PARAM_VALUE.xdma_rnum_chnl MODELPARAM_VALUE.EN_RCHNL_7} {
    set num_rchnl_en [get_property value ${PARAM_VALUE.xdma_rnum_chnl}]

    if {$num_rchnl_en >= 8} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_RCHNL_7}
}

proc update_MODELPARAM_VALUE.XDMA_DSC_BYPASS {PARAM_VALUE.xdma_dsc_bypass MODELPARAM_VALUE.XDMA_DSC_BYPASS} {
    set xdma_dsc_bypass [get_property value ${PARAM_VALUE.xdma_dsc_bypass}]

    if {$xdma_dsc_bypass == "true"} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.XDMA_DSC_BYPASS}
}

proc update_MODELPARAM_VALUE.EN_GT_SELECTION {PARAM_VALUE.en_gt_selection MODELPARAM_VALUE.EN_GT_SELECTION} {
    set en_gt_selection [get_property value ${PARAM_VALUE.en_gt_selection}]

    if {$en_gt_selection == "true"} {
        set val "TRUE"
    } else {
        set val "FALSE"
    }
    set_property value $val ${MODELPARAM_VALUE.EN_GT_SELECTION}
}

proc update_MODELPARAM_VALUE.SELECT_QUAD {PARAM_VALUE.select_quad MODELPARAM_VALUE.SELECT_QUAD} {
    set val [get_property value ${PARAM_VALUE.select_quad}]

    set_property value $val ${MODELPARAM_VALUE.SELECT_QUAD}
}

proc DT_Shared_Logic_US {IPINST PARAM_VALUE.mode_selection PARAM_VALUE.Shared_Logic PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.plltype PARAM_VALUE.gtwiz_in_core_us} {  
  set c_xfamily    [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
  set mode         [get_property value ${PARAM_VALUE.mode_selection}] 
  set shared_logic [get_property value ${PARAM_VALUE.Shared_Logic}] 
  set Plltype      [get_property value ${PARAM_VALUE.plltype}]
  set c_gtwiz_in_core [get_property value ${PARAM_VALUE.gtwiz_in_core_us}]

    if {($c_xfamily == "kintexu" || $c_xfamily == "virtexu")} { 
      if {$c_gtwiz_in_core} {
        if {$Plltype == "CPLL"} {
          set image_path "xgui/with_shared_logic.png" 
        } elseif {$shared_logic == 0} {
          set image_path "xgui/without_shared_logic.png" 
        } else { 
          set image_path "xgui/with_shared_logic.png" 
        }
    } else { 
        if {$Plltype == "CPLL"} {
          set image_path "xgui/without_shared_logic.png" 
        } elseif {$shared_logic == 0} {
          set image_path "xgui/without_shared_logic.png" 
        } else { 
          set image_path "xgui/without_shared_logic.png" 
        }
    }
    set_property load_image $image_path [ipgui::get_imagespec PixmapAFix2 -of $IPINST]
  }

  if {($c_xfamily == "kintexu" || $c_xfamily == "virtexu")} { 
    if {$c_gtwiz_in_core} {
       if {$Plltype == "CPLL"} {
         set    text "CPLL is selected and GT COMMON Sharing Option is invalid.\n"        
         append text "- GT_COMMON Sharing is available for Gen2 and Gen3 Speeds.\n"        
         append text "- GT WIZARD IP is inside the PCIe IP.\n\n"        
       } elseif {[get_property value ${PARAM_VALUE.Shared_Logic}] == 0} {
         set    text "Include GT_COMMON Shared Logic in example design\n"        
         append text "- For users who want the Shared Logic outside the core.\n"        
         append text "- For users who want to edit the Shared Logic or use their own.\n"        
         append text "- For users who want one core with Shared Logic to drive multiple cores without Shared Logic.\n"    
         append text "- GT WIZARD IP is inside the PCIe IP.\n\n"        
       } else {        
         set    text "Include GT_COMMON Shared Logic in core\n"        
         append text "- For users who want a complete single solution.\n"        
         append text "- For users who want one core with Shared Logic to drive multiple cores without Shared Logic.\n"
         append text "- GT WIZARD IP is inside the PCIe IP.\n\n"        
       }
    } else { 
       if {$Plltype == "CPLL"} {
         set    text "CPLL is selected and GT COMMON Sharing Option is invalid.\n"        
         append text "- GT_COMMON Sharing is available for Gen2 and Gen3 Speeds.\n"        
         append text "- GT WIZARD IP is in example design.\n\n"        
       } elseif {[get_property value ${PARAM_VALUE.Shared_Logic}] == 0} {
         set    text "Include GT_COMMON Shared Logic in example design\n"        
         append text "- For users who want the Shared Logic outside the core.\n"        
         append text "- For users who want to edit the Shared Logic or use their own.\n"        
         append text "- For users who want one core with Shared Logic to drive multiple cores without Shared Logic.\n"    
         append text "- GT WIZARD IP is in example design.\n\n"        
       } else {        
         set    text "Include GT_COMMON Shared Logic in core\n"        
         append text "- For users who want a complete single solution.\n"        
         append text "- For users who want one core with Shared Logic to drive multiple cores without Shared Logic.\n"
         append text "- GT WIZARD IP is in example design.\n\n"        
       }
    }
    return $text
  }    
}

proc DT_Shared_Logic_7x {IPINST PROJECT_PARAM.ARCHITECTURE PARAM_VALUE.mode_selection PARAM_VALUE.Shared_Logic_Both PARAM_VALUE.Shared_Logic_Clk PARAM_VALUE.Shared_Logic_Gtc} {  
  set c_xfamily                [getParentDeviceName ${PROJECT_PARAM.ARCHITECTURE}]
  set mode [get_property value ${PARAM_VALUE.mode_selection}] 
  set Shared_Logic_Both        [get_property value ${PARAM_VALUE.Shared_Logic_Both}] 
  set Shared_Logic_Clk         [get_property value ${PARAM_VALUE.Shared_Logic_Clk}] 
  set Shared_Logic_Gtc         [get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] 

  if {($c_xfamily ne "kintexu") && ($c_xfamily ne "virtexu")} { 
    if {([get_property value ${PARAM_VALUE.Shared_Logic_Both}] eq "true") && ([get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] eq "false") && ([get_property value ${PARAM_VALUE.Shared_Logic_Clk}] eq "false")} {
      set image_path "xgui/Shared_Logic_In_Core.png" 
    } elseif {([get_property value ${PARAM_VALUE.Shared_Logic_Both}] eq "false") && ([get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] eq "false") && ([get_property value ${PARAM_VALUE.Shared_Logic_Clk}] eq "false")} {
      set image_path "xgui/No_Shared_Logic.png" 
    } elseif {([get_property value ${PARAM_VALUE.Shared_Logic_Both}] eq "false") && ([get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] eq "true") && ([get_property value ${PARAM_VALUE.Shared_Logic_Clk}] eq "false")} {
      set image_path "xgui/Ext_GT_Common_Mode.png" 
    } elseif {([get_property value ${PARAM_VALUE.Shared_Logic_Both}] eq "false") && ([get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] eq "false") && ([get_property value ${PARAM_VALUE.Shared_Logic_Clk}] eq "true")} {
      set image_path "xgui/Ext_Clock_Mode.png" 
    } elseif {([get_property value ${PARAM_VALUE.Shared_Logic_Both}] eq "false") && ([get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] eq "true") && ([get_property value ${PARAM_VALUE.Shared_Logic_Clk}] eq "true")} {
      set image_path "xgui/Ext_Clk_Ext_GT_common.png" 
    }
    set_property load_image $image_path [ipgui::get_imagespec PixmapAFix2_7x -of $IPINST]
  }

  if {($c_xfamily ne "kintexu") && ($c_xfamily ne "virtexu")} { 
    if {([get_property value ${PARAM_VALUE.Shared_Logic_Both}] eq "false") && ([get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] eq "false") && ([get_property value ${PARAM_VALUE.Shared_Logic_Clk}] eq "false")} {
      set    text "Core with No Shared Logic\n"        
      append text "- The CLOCKING and GT_COMMON used by this core are located in this IP core, and not available for sharing with other IP core\n"        
    } elseif {[get_property value ${PARAM_VALUE.Shared_Logic_Both}] eq "true"} {
      set    text "Core with internal CLOCKING and GT_COMMON\n"        
      append text "- The CLOCKING and GT_COMMON used by this IP core are located in this IP core, and are available for sharing with other IP cores\n"        
      append text "- Please consult the product guide for information on the additional ports that are generated on this IP core to facilitate sharing\n\n\n"    
    } elseif {([get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] eq "true") && ([get_property value ${PARAM_VALUE.Shared_Logic_Clk}] eq "true")} {
      set    text "Core with external CLOCKING and GT_COMMON\n"        
      append text "- The CLOCKING and GT_COMMON used by this core are located in its Example Design,\n" 
      append text "  and are available for sharing with other IP cores\n\n\n"        
    } elseif {[get_property value ${PARAM_VALUE.Shared_Logic_Clk}] eq "true"} {
      set    text "Core with external CLOCKING and internal GT_COMMON\n"        
      append text "- CLOCKING used by this  core is located in its Example Design and is available for sharing with other IP cores\n"        
      append text "- GT_COMMON is internal and not available to share\n\n\n"        
    } elseif {[get_property value ${PARAM_VALUE.Shared_Logic_Gtc}] eq "true"} {
      set    text "Core with external GT_COMMON and internal CLOCKING\n"        
      append text "- GT_COMMON used by this  core is located in its Example Design and are available for sharing with other IP cores\n"        
      append text "- CLOCKING is internal and not available to share\n\n\n"
    } else {
      set    text "Core with external CLOCKING and internal GT_COMMON\n"        
      append text "- CLOCKING used by this  core is located in its Example Design and is available for sharing with other IP cores\n"        
      append text "- GT_COMMON is internal and not available to share\n\n\n"        
    }    
    return $text
  }    
}

proc update_PARAM_VALUE.Shared_Logic { PARAM_VALUE.Shared_Logic PARAM_VALUE.plltype PARAM_VALUE.gtwiz_in_core_us} {
  set Plltype [ get_property value ${PARAM_VALUE.plltype}]

  if {$Plltype eq "CPLL" } {
    set_property enabled false ${PARAM_VALUE.Shared_Logic}
    set_property value   1     ${PARAM_VALUE.Shared_Logic}
  } else { 
	  if { [get_property value ${PARAM_VALUE.gtwiz_in_core_us}] } {
       set_property enabled true ${PARAM_VALUE.Shared_Logic}
    } else {
       set_property enabled false ${PARAM_VALUE.Shared_Logic}
       set_property value   1     ${PARAM_VALUE.Shared_Logic}
    }
  }
}

proc validate_PARAM_VALUE.Shared_Logic_Both { PARAM_VALUE.Shared_Logic_Both PARAM_VALUE.Shared_Logic_Clk PARAM_VALUE.Shared_Logic_Gtc} {
  set Shared_Logic_Both [get_property value ${PARAM_VALUE.Shared_Logic_Both} ] 
  set Shared_Logic_Clk [get_property value ${PARAM_VALUE.Shared_Logic_Clk} ] 
  set Shared_Logic_Gtc [get_property value ${PARAM_VALUE.Shared_Logic_Gtc} ] 

  if {($Shared_Logic_Clk == "true" || $Shared_Logic_Gtc == "true") && ($Shared_Logic_Both == "true") } { 
    set_property errmsg "Include Shared logic in Core option is exclusive with other two options. Uncheck both the parameters Include Shared Logic (Clocking) in example design and(or) Include Shared Logic (Transceiver GT_COMMON) in example design (if one or both of them checked) to select this option" ${PARAM_VALUE.Shared_Logic_Both} 
    return false
  } else {  
    return true 
  }

}

proc update_MODELPARAM_VALUE.AXI_ACLK_LOOPBACK {MODELPARAM_VALUE.AXI_ACLK_LOOPBACK PARAM_VALUE.axi_aclk_loopback} {
  set aclk_loopback  [get_property value  ${PARAM_VALUE.axi_aclk_loopback} ]
  if {$aclk_loopback} {
    set val  true
  } else {
    set val  false
  }
  set_property value [string toupper $val] ${MODELPARAM_VALUE.AXI_ACLK_LOOPBACK}
}

proc update_MODELPARAM_VALUE.GTWIZ_IN_CORE {MODELPARAM_VALUE.GTWIZ_IN_CORE PARAM_VALUE.gtwiz_in_core_us PARAM_VALUE.gtwiz_in_core_usp} {

	if { [get_property value ${PARAM_VALUE.gtwiz_in_core_us}]  && [get_property value ${PARAM_VALUE.gtwiz_in_core_usp}]} {
		set val 1 
	} else {
		set val 0 
	}
	set_property value $val ${MODELPARAM_VALUE.GTWIZ_IN_CORE}    
}

proc update_MODELPARAM_VALUE.xlnx_ref_board {MODELPARAM_VALUE.xlnx_ref_board PARAM_VALUE.xlnx_ref_board} {
  set xcoValue [get_property value ${PARAM_VALUE.xlnx_ref_board} ]
  set_property value $xcoValue ${MODELPARAM_VALUE.xlnx_ref_board}
}

proc update_MODELPARAM_VALUE.EXT_SYS_CLK_BUFG {MODELPARAM_VALUE.EXT_SYS_CLK_BUFG PARAM_VALUE.ext_sys_clk_bufg} { 
  set_property value [string toupper [get_property value ${PARAM_VALUE.ext_sys_clk_bufg}]] ${MODELPARAM_VALUE.EXT_SYS_CLK_BUFG}
}

proc update_MODELPARAM_VALUE.GTCOM_IN_CORE {MODELPARAM_VALUE.GTCOM_IN_CORE PARAM_VALUE.gtcom_in_core_usp} { 
  set_property value [get_property value ${PARAM_VALUE.gtcom_in_core_usp}] ${MODELPARAM_VALUE.GTCOM_IN_CORE}
}

#####################################################################
#
###     Procedures to update the parameters used in MQDMA feature
#       Belongs to PF BARs page and SRIOV BARs page
# 
####################################################################

set procedure_type {

   proc update_PARAM_VALUE.pf<<j>>_expansion_rom_enabled_mqdma {PARAM_VALUE.pf<<j>>_expansion_rom_enabled_mqdma PARAM_VALUE.pf0_expansion_rom_enabled_mqdma PARAM_VALUE.copy_pf0 IPINST} {
    #set enabled ${PARAM_VALUE.pf<<j>>_expansion_rom_enabled_mqdma}
    set enabled [ipgui::get_paramspec -name pf<<j>>_expansion_rom_enabled_mqdma -of $IPINST]
    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]
    if {[get_property value ${PARAM_VALUE.copy_pf0}] == false} {
      set value [get_property default_value [ipgui::get_paramspec -name pf<<j>>_expansion_rom_enabled_mqdma -of $IPINST]] 
      set_property value $value [ipgui::get_paramspec -name pf<<j>>_expansion_rom_enabled_mqdma -of $IPINST]    
    }

    # set_property range "false,true" $enabled
    set_property enabled true $enabled

    if {$copyPf0 == true && <<j>> != 0 } { 
      set_property enabled false $enabled
      set_property value [get_property value ${PARAM_VALUE.pf0_expansion_rom_enabled_mqdma}] $enabled
    } 

  }

  proc update_PARAM_VALUE.pf<<j>>_expansion_rom_scale_mqdma { PARAM_VALUE.pf<<j>>_expansion_rom_scale_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma PARAM_VALUE.pf0_expansion_rom_scale_mqdma PARAM_VALUE.pf<<j>>_expansion_rom_enabled_mqdma PARAM_VALUE.copy_pf0 PROJECT_PARAM.ARCHITECTURE IPINST} {
    

    if {[get_property value ${PARAM_VALUE.copy_pf0}] == false} {
          set range "Bytes,Kilobytes,Megabytes" 
          set value "Kilobytes"
          set_property range_value $value,$range [ipgui::get_paramspec pf<<j>>_expansion_rom_scale_mqdma -of $IPINST]    
    }

    set pf [ipgui::get_paramspec -name pf<<j>>_expansion_rom_scale_mqdma -of $IPINST]
    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]

    set_property enabled [get_property value [ipgui::get_paramspec -name pf<<j>>_expansion_rom_enabled_mqdma -of $IPINST]] $pf

    if {$copyPf0 == true && <<j>> != 0 } {
      set_property enabled false $pf 
      set_property value [get_property value ${PARAM_VALUE.pf0_expansion_rom_scale_mqdma}] $pf
    }
  }

  proc update_PARAM_VALUE.pf<<j>>_expansion_rom_type_mqdma {PARAM_VALUE.pf<<j>>_expansion_rom_type_mqdma PARAM_VALUE.device_port_type PARAM_VALUE.pf<<j>>_expansion_rom_enabled_mqdma PARAM_VALUE.pf0_expansion_rom_type_mqdma PARAM_VALUE.copy_pf0 IPINST} { 
    if {[get_property value ${PARAM_VALUE.copy_pf0}] == false} {
      set_property range [get_property default_range [ipgui::get_paramspec pf<<j>>_expansion_rom_type_mqdma -of $IPINST]] [ipgui::get_paramspec pf<<j>>_expansion_rom_type_mqdma -of $IPINST]
      set_property value [get_property default_value [ipgui::get_paramspec pf<<j>>_expansion_rom_type_mqdma -of $IPINST]] [ipgui::get_paramspec pf<<j>>_expansion_rom_type_mqdma -of $IPINST]
    }

    set Enabled_Bar [get_property value ${PARAM_VALUE.pf<<j>>_expansion_rom_enabled_mqdma}]

    if {$Enabled_Bar == true} {
      set_property enabled $Enabled_Bar ${PARAM_VALUE.pf<<j>>_expansion_rom_type_mqdma}
      if {[get_property value ${PARAM_VALUE.device_port_type}] == "PCI_Express_Endpoint_device" } {
        set_property range_value "Bypass_AXI_Master,Bypass_AXI_Master" [ipgui::get_paramspec pf<<j>>_expansion_rom_type_mqdma -of $IPINST]
      } else {
        if {([get_property value ${PARAM_VALUE.device_port_type}] == "Root_Port_of_PCI_Express_Root_Complex") && <<i>> == 0 && <<j>> != 0} {
          set_property range "Memory" [ipgui::get_paramspec pf<<j>>_expansion_rom_type_mqdma -of $IPINST]
        } else {
          set_property range "Memory,IO" [ipgui::get_paramspec pf<<j>>_expansion_rom_type_mqdma -of $IPINST]
        }
      }
    } else {
      set_property enabled false ${PARAM_VALUE.pf<<j>>_expansion_rom_type_mqdma}
      set_property range_value "N/A,N/A" [ipgui::get_paramspec pf<<j>>_expansion_rom_type_mqdma -of $IPINST]
    }

    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]
    if {$copyPf0 == true && <<j>> != 0 } {
      set_property enabled false ${PARAM_VALUE.pf<<j>>_expansion_rom_type_mqdma}
      set_property range_value [get_property value ${PARAM_VALUE.pf0_expansion_rom_type_mqdma}],[get_property value ${PARAM_VALUE.pf0_expansion_rom_type_mqdma}] ${PARAM_VALUE.pf<<j>>_expansion_rom_type_mqdma}
    }
  }

  proc update_PARAM_VALUE.pf<<j>>_expansion_rom_size_mqdma { PARAM_VALUE.pf<<j>>_expansion_rom_size_mqdma PARAM_VALUE.pf<<j>>_expansion_rom_enabled_mqdma PARAM_VALUE.pf<<j>>_expansion_rom_scale_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma PARAM_VALUE.device_port_type PARAM_VALUE.copy_pf0 PARAM_VALUE.pf0_expansion_rom_size_mqdma IPINST} {
    if {[get_property value ${PARAM_VALUE.copy_pf0}] == false} {
          set range [get_property default_range [ipgui::get_paramspec pf<<j>>_expansion_rom_size_mqdma -of $IPINST]] 
          set value [get_property default_value [ipgui::get_paramspec pf<<j>>_expansion_rom_size_mqdma -of $IPINST]] 
          set_property range_value $range,$value [ipgui::get_paramspec pf<<j>>_expansion_rom_size_mqdma -of $IPINST]   
    }

    set pf [ipgui::get_paramspec -name pf<<j>>_expansion_rom_size_mqdma -of $IPINST]
    set_property enabled [get_property value [ipgui::get_paramspec -name pf<<j>>_expansion_rom_enabled_mqdma -of $IPINST]] $pf

    set value1 [get_property value [ipgui::get_paramspec -name pf<<j>>_expansion_rom_size_mqdma -of $IPINST]]
    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]

    list allowed {}
    if {[get_property value [ipgui::get_paramspec -name pf<<j>>_expansion_rom_scale_mqdma -of $IPINST]] eq "Bytes"} {
      set allowed {256 512}
    } elseif {[get_property value [ipgui::get_paramspec -name pf<<j>>_expansion_rom_scale_mqdma -of $IPINST]] eq "Kilobytes"} {
      set allowed {1 2 4 8 16 32 64 128 256 512}
    } else {
      set allowed {1 2 4 8 16}
    }

    set temp_val [lindex $allowed 1]
    set rangevals [join $allowed ","]
    set_property range_value "$temp_val,$rangevals" $pf
     
    if {$value1 < [lindex $allowed 0]} {
      set_property value [lindex $allowed 0] $pf
    } elseif {$value1 > [lindex $allowed end]} {
      set_property value [lindex $allowed end] $pf
    } else {
      set_property value $value1 $pf
    }
     
    if {$copyPf0 == true && <<j>> != 0} {
      set_property enabled false $pf 
      set_property value [get_property value ${PARAM_VALUE.pf0_expansion_rom_size_mqdma}] $pf
    } 
  }
}

foreach j {0 1 2 3} {
  for { set i 0} {$i < 6} {incr i} {
    set OutString [regsub -all "<<j>>" $procedure_type $j]
    set OutString2 [regsub -all "<<i>>" $OutString $i]

    uplevel 0 $OutString2
  }
}


set UpdateOfBarType {
  proc update_PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma { PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma PARAM_VALUE.device_port_type PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma PARAM_VALUE.pf0_bar<<i>>_type_mqdma PARAM_VALUE.copy_pf0 PROJECT_PARAM.ARCHITECTURE IPINST} {
    if {[get_property value ${PARAM_VALUE.copy_pf0}] == false} {
      set_property range [get_property default_range [ipgui::get_paramspec pf<<j>>_bar<<i>>_type_mqdma -of $IPINST]] [ipgui::get_paramspec pf<<j>>_bar<<i>>_type_mqdma -of $IPINST]
      set_property value [get_property default_value [ipgui::get_paramspec pf<<j>>_bar<<i>>_type_mqdma -of $IPINST]] [ipgui::get_paramspec pf<<j>>_bar<<i>>_type_mqdma -of $IPINST]
    }

    set Enabled_Bar [get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma}]

    if {$Enabled_Bar == true} {
      set_property enabled $Enabled_Bar ${PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma}
      # set_property enabled $Enabled_Bar ${PARAM_VALUE.pf<<j>>_bar<<i>>_type}
      if {[get_property value ${PARAM_VALUE.device_port_type}] == "PCI_Express_Endpoint_device" } {
        if {<<i>> == 0 } { 
          set_property range_value "DMA,AXI_Lite_Master,DMA" [ipgui::get_paramspec pf<<j>>_bar<<i>>_type_mqdma -of $IPINST]
        } else { 
          set_property range_value "AXI_Lite_Master,AXI_Lite_Master,DMA" [ipgui::get_paramspec pf<<j>>_bar<<i>>_type_mqdma -of $IPINST]
        }
      } else {
        # set_property range_value "Memory,Memory,IO" [ipgui::get_paramspec pf<<j>>_bar<<i>>_type -of $IPINST]
        if {([get_property value ${PARAM_VALUE.device_port_type}] == "Root_Port_of_PCI_Express_Root_Complex") && <<i>> == 0 && <<j>> != 0} {
          set_property range "Memory" [ipgui::get_paramspec pf<<j>>_bar<<i>>_type_mqdma -of $IPINST]
        } else {
          set_property range "Memory,IO" [ipgui::get_paramspec pf<<j>>_bar<<i>>_type_mqdma -of $IPINST]
        }
      }
    } else {
      set_property enabled false ${PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma}
      set_property range_value "N/A,N/A" [ipgui::get_paramspec pf<<j>>_bar<<i>>_type_mqdma -of $IPINST]
    }

    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]
    if {$copyPf0 == true && <<j>> != 0 } {
      set_property enabled false ${PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma}
      set_property range_value [get_property value ${PARAM_VALUE.pf0_bar<<i>>_type_mqdma}],[get_property value ${PARAM_VALUE.pf0_bar<<i>>_type_mqdma}] ${PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma}
    }
  }

  proc update_PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_type {PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_type PARAM_VALUE.pf0_sriov_bar<<i>>_type PARAM_VALUE.device_port_type PARAM_VALUE.copy_sriov_pf0 PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled IPINST} {
    set bar_type [ipgui::get_paramspec pf<<j>>_sriov_bar<<i>>_type -of $IPINST]

    if {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled}] == true} {
      set_property enabled true $bar_type
      if {[get_property value ${PARAM_VALUE.device_port_type}] == "PCI_Express_Endpoint_device"} {
        if {<<i>> == 0 } { 
         set_property range_value "DMA,AXI_Lite_Master,DMA" $bar_type
        } else { 
         set_property range_value "AXI_Lite_Master,AXI_Lite_Master,DMA" $bar_type
        }
      } else {
        if {([get_property value ${PARAM_VALUE.device_port_type}] == "Root_Port_of_PCI_Express_Root_Complex") && <<i>> == 0 && <<j>> != 0} {
          set_property range "Memory" $bar_type
        } else {
          set_property range "Memory" $bar_type
        }
      }
      if {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_type}] == "N/A"} {
        set_property value "N/A" $bar_type
      }
    } else {
      set_property enabled false $bar_type
      set_property range_value "N/A,N/A" $bar_type
    }
    set copyPf0 [get_property value ${PARAM_VALUE.copy_sriov_pf0}]
    if {$copyPf0 == true && <<i>> != 0} {
      set_property enabled false $bar_type 
      set_property range_value [get_property value ${PARAM_VALUE.pf0_sriov_bar<<i>>_type}],[get_property value ${PARAM_VALUE.pf0_sriov_bar<<i>>_type}] $bar_type
    }
  }
}

foreach j {0 1 2 3 } {
  for { set i 0} {$i < 6} {incr i} {
    set OutString [regsub -all "<<j>>" $UpdateOfBarType $j]
    set OutString2 [regsub -all "<<i>>" $OutString $i]

    uplevel 0 $OutString2
  }
}

set Procedure_Scale {  
  proc update_PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma {PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_64bit_mqdma PARAM_VALUE.pf0_bar<<i>>_scale_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma PARAM_VALUE.copy_pf0   IPINST} {
    if {[get_property value ${PARAM_VALUE.copy_pf0}] == false} {
      set range "Bytes,Kilobytes,Megabytes" 
      set value "Kilobytes"
      set_property range_value $value,$range ${PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma}
    }

    set value [get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma}]
    set bar_size ${PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma}

    set_property enabled [get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma}] $bar_size
    if {([get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_64bit_mqdma}] == false) || [get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma}] == "IO"} {
      set_property range_value "Bytes,Bytes,Kilobytes,Megabytes,Gigabytes" $bar_size
      if {[lsearch {Bytes Kilobytes Megabytes Gigabytes} $value] == -1} {
        set value Gigabytes
      }
      } else {
      set_property range "Bytes,Kilobytes,Megabytes,Gigabytes,Terabytes,Petabytes,Exabytes" $bar_size
    }

    set_property value $value $bar_size
    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]
    if {$copyPf0 == true && <<j>> != 0} {
      set_property enabled false $bar_size
      set_property range_value [get_property value ${PARAM_VALUE.pf0_bar<<i>>_scale_mqdma}],[get_property value ${PARAM_VALUE.pf0_bar<<i>>_scale_mqdma}] $bar_size
    }
  } 

  proc update_PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_scale {PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_scale PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_64bit PARAM_VALUE.pf0_sriov_bar<<i>>_scale PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_type PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled  PARAM_VALUE.copy_sriov_pf0 IPINST} {
    set value [get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_scale}]
    set bar_size ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_scale}

    set_property enabled [get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled}] $bar_size
    if {(<<i>> != 5 && ([get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_64bit}] == false) || [get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_type}] == "IO")} {
      set_property range_value "Bytes,Bytes,Kilobytes,Megabytes,Gigabytes" $bar_size
      if {[lsearch {Bytes Kilobytes Megabytes Gigabytes} $value] == -1} {
        set value Gigabytes
      }
    } elseif {<<i>> == 5} {
      set_property range_value "Bytes,Bytes,Kilobytes,Megabytes,Gigabytes" $bar_size
    } else {
      set_property range "Bytes,Kilobytes,Megabytes,Gigabytes,Terabytes,Petabytes,Exabytes" $bar_size
    }

    set_property value $value $bar_size
    set copyPf0 [get_property value ${PARAM_VALUE.copy_sriov_pf0}]
    if {$copyPf0 == true && <<j>> != 0} {
      set_property enabled false $bar_size
      set_property range_value [get_property value ${PARAM_VALUE.pf0_sriov_bar<<i>>_scale}],[get_property value ${PARAM_VALUE.pf0_sriov_bar<<i>>_scale}] $bar_size
    } 
  }
}

foreach j {0 1 2 3} {
  for { set i 0} {$i < 5} {incr i} {
    set OutString [regsub -all "<<j>>" $Procedure_Scale $j]
    set OutString2 [regsub -all "<<i>>" $OutString $i]

    uplevel 0 $OutString2
  }
}

set procedure_type2 {

  ### Procedure for 64bit parameter
  proc update_PARAM_VALUE.pf<<j>>_bar<<i>>_64bit_mqdma {PARAM_VALUE.pf<<j>>_bar<<i>>_64bit_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma PARAM_VALUE.pf0_bar<<i>>_64bit_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma PARAM_VALUE.device_port_type PARAM_VALUE.copy_pf0 IPINST} {
    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]
    set en_64bit [ipgui::get_paramspec -name pf<<j>>_bar<<i>>_64bit_mqdma -of $IPINST]

    if {$copyPf0 == true && <<j>> != 0} { 
      set_property enabled false $en_64bit
      set_property value [get_property value ${PARAM_VALUE.pf0_bar<<i>>_64bit_mqdma}] $en_64bit
    } else {
      set_property value [get_property default_value ${PARAM_VALUE.pf<<j>>_bar<<i>>_64bit_mqdma}] $en_64bit
      if {<<i>> == 1} {
        set rprc [expr {[get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"}]
      } else {
        set rprc 0
      }
  
      if {[get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma}] && [get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma}] ne "IO" && !$rprc} {
        set_property enabled true [ipgui::get_paramspec -name pf<<j>>_bar<<i>>_64bit_mqdma -of $IPINST]
      } else {
        set_property enabled false $en_64bit
        set_property value false $en_64bit 
      }
    }
  }

  ### Procedure for Prefetchable parameter
  proc update_PARAM_VALUE.pf<<j>>_bar<<i>>_prefetchable_mqdma {PARAM_VALUE.pf<<j>>_bar<<i>>_prefetchable_mqdma PARAM_VALUE.pf0_bar<<i>>_prefetchable_mqdma PARAM_VALUE.copy_pf0 PARAM_VALUE.device_port_type PARAM_VALUE.pf<<j>>_bar<<i>>_64bit_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma IPINST } {
    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]
    set prefetch_en [ipgui::get_paramspec pf<<j>>_bar<<i>>_prefetchable_mqdma -of $IPINST]

    if {$copyPf0 == true && <<j>> != 0} {
      set_property enabled false [ipgui::get_paramspec $prefetch_en -of $IPINST] 
      set_property value [get_property value ${PARAM_VALUE.pf0_bar<<i>>_prefetchable_mqdma}] $prefetch_en 
    } else {
      set_property value [get_property default_value $prefetch_en] $prefetch_en

      if {<<i>> != 5 } {
        set value [expr { ([get_property value [ipgui::get_paramspec -name pf<<j>>_bar<<i>>_64bit_mqdma -of $IPINST]] == false)?1:0 }]
      } else {
        set value 1
      }

      if {<<i>> == 1} {
        set rprc [expr {[get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"}]
      } else {
        set rprc 0
      }

      if {$rprc || [get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma}] == false || ([get_property value  [ipgui::get_paramspec -name pf<<j>>_bar<<i>>_type_mqdma -of $IPINST] ] ne "AXI_Lite_Master" && [get_property value  [ipgui::get_paramspec -name pf<<j>>_bar<<i>>_type_mqdma -of $IPINST] ] ne "DMA") 
        || ($value && [get_property value ${PARAM_VALUE.device_port_type}  ] ne "Legacy_PCI_Express_Endpoint_device")} {
        set_property enabled false [ipgui::get_paramspec -name pf<<j>>_bar<<i>>_prefetchable_mqdma -of $IPINST]
        set_property value false [ipgui::get_paramspec -name pf<<j>>_bar<<i>>_prefetchable_mqdma -of $IPINST]
      } else {
        set_property enabled true ${PARAM_VALUE.pf<<j>>_bar<<i>>_prefetchable_mqdma} 
      }
    }
  }
 
   ### Procedure for 64bit parameter for sriov
  proc update_PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_64bit {PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_64bit PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled PARAM_VALUE.pf0_sriov_bar<<i>>_64bit PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_type PARAM_VALUE.device_port_type PARAM_VALUE.copy_sriov_pf0 IPINST} {
    set copyPf0 [get_property value ${PARAM_VALUE.copy_sriov_pf0}]
    set en_64bit [ipgui::get_paramspec -name pf<<j>>_sriov_bar<<i>>_64bit -of $IPINST]

    if {$copyPf0 == true && <<j>> != 0} { 
      set_property enabled false $en_64bit
      set_property value [get_property value ${PARAM_VALUE.pf0_sriov_bar<<i>>_64bit}] $en_64bit
    } else {
      set_property value [get_property default_value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_64bit}] $en_64bit
      if {<<i>> == 1} {
        set rprc [expr {[get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"}]
      } else {
        set rprc 0
      }
  
      if {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled}] && [get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_type}] ne "IO" && !$rprc} {
        set_property enabled true [ipgui::get_paramspec -name pf<<j>>_sriov_bar<<i>>_64bit -of $IPINST]
      } else {
        set_property enabled false $en_64bit
        set_property value false $en_64bit 
      }
    }
  }

  ### Procedure for Prefetchable parameter for sriov
  proc update_PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_prefetchable {PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_prefetchable PARAM_VALUE.pf0_sriov_bar<<i>>_prefetchable PARAM_VALUE.copy_sriov_pf0 PARAM_VALUE.device_port_type PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_64bit PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_type IPINST } {
    set copyPf0 [get_property value ${PARAM_VALUE.copy_sriov_pf0}]
    set prefetch_en [ipgui::get_paramspec pf<<j>>_sriov_bar<<i>>_prefetchable -of $IPINST]

    if {$copyPf0 == true && <<j>> != 0} {
      set_property enabled false [ipgui::get_paramspec $prefetch_en -of $IPINST] 
      set_property value [get_property value ${PARAM_VALUE.pf0_sriov_bar<<i>>_prefetchable}] $prefetch_en 
    } else {
      set_property value [get_property default_value $prefetch_en] $prefetch_en

      if {<<i>> != 5 } {
        set value [expr { ([get_property value [ipgui::get_paramspec -name pf<<j>>_sriov_bar<<i>>_64bit -of $IPINST]] == false)?1:0 }]
      } else {
        set value 1
      }

      if {<<i>> == 1} {
        set rprc [expr {[get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"}]
      } else {
        set rprc 0
      }

      if {$rprc || [get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled}] == false || [get_property value [ipgui::get_paramspec -name pf<<j>>_sriov_bar<<i>>_type -of $IPINST]] ne "AXI_Lite_Master" 
        || ($value && [get_property value ${PARAM_VALUE.device_port_type}  ] ne "Legacy_PCI_Express_Endpoint_device")} {
        set_property enabled false [ipgui::get_paramspec $prefetch_en -of $IPINST]
        set_property value false [ipgui::get_paramspec $prefetch_en -of $IPINST]
      } else {
        set_property enabled true ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_prefetchable} 
      }
    }
  }

  proc update_PARAM_VALUE.pf<<j>>_bar<<i>>_size_mqdma {PARAM_VALUE.pf<<j>>_bar<<i>>_size_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma PARAM_VALUE.pf0_bar<<i>>_size_mqdma PARAM_VALUE.copy_pf0 PARAM_VALUE.device_port_type PARAM_VALUE.pf<<j>>_bar<<i>>_64bit_mqdma  IPINST} {
    set bar_size [ipgui::get_paramspec -name pf<<j>>_bar<<i>>_size_mqdma -of $IPINST]
    set value [get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_size_mqdma}]
    set allowed {1 2 4 8 16 32 64 128 256 512}
    set Enabled_Bar [get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma}]
    set_property enabled $Enabled_Bar $bar_size 
                
    if {[get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma}] eq "IO"} {
      if {[get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma}] eq "Bytes"} {
        set allowed {16 32 64 128 256 512}
      } elseif {[get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma}] eq "Gigabytes"} {
        if {<<i>> != 5 } {
          if {[get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_64bit_mqdma}] == true} {
            if {[get_property value ${PARAM_VALUE.device_port_type} ] == "Root_Port_of_PCI_Express_Root_Complex"} {
              allowed {1 2 4 8}
            } else {
              set allowed {1 2 4 8 16 32 64 128 256}
            }
          } else {
            set allowed {1 2}
          }
        } else {
          set allowed {1 2}
        }
      }
    } else {
      if {[get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_type_mqdma}] eq "DMA"} {
        if {[get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma}] eq "Bytes"} {
          if {[get_property value ${PARAM_VALUE.device_port_type}] == "Root_Port_of_PCI_Express_Root_Complex"} {
            set allowed {4 8 16 32 64 128 256 512}
          } else {
            set allowed {128 256 512}
          }
        } else {
          if { <<i>> != 5 } {
            if {[get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_64bit_mqdma}] == true} {
              if {[get_property value  ${PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma}] eq "Exabytes"} {
                if {[get_property value ${PARAM_VALUE.device_port_type} ] == "Root_Port_of_PCI_Express_Root_Complex"} {
                  set allowed {1 2 4 8}
                } else {
                  set allowed {1 2 4 8}
                }
              } else {
                set allowed {1 2 4 8 16 32 64 128 256 512}
              }
            } else {
              if {[get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma}] eq "Gigabytes"} {
                if {[get_property value ${PARAM_VALUE.device_port_type} ] == "Root_Port_of_PCI_Express_Root_Complex"} {
                  set allowed {1 2}
                } else {
                  set allowed {1 2}
                }
              }
            }
          } else {
              if {[get_property value ${PARAM_VALUE.pf<<j>>_bar<<i>>_scale_mqdma}] eq "Gigabytes"} {
                set allowed {1 2}
              } else {
                set allowed {1 2 4 8 16 32 64 128 256 512}                  
              }
          }
        }
      } else {
        set value "128" 
      }
    }
    if {([expr [get_metaparam_value type_ChangeInit]] == 1) && <<i>> == 0 && <<j>> == 0 } {
      set value "128"
    }
    if {[get_property value ${PARAM_VALUE.copy_pf0}] == false} {
      set range [get_property default_range [ipgui::get_paramspec pf<<j>>_bar<<i>>_size_mqdma -of $IPINST]] 
      set value [get_property default_value [ipgui::get_paramspec pf<<j>>_bar<<i>>_size_mqdma -of $IPINST]] 
      set_property range_value $range,$value [ipgui::get_paramspec pf<<j>>_bar<<i>>_size_mqdma -of $IPINST]   
    }
    # Needs to be changed 2 For one see scratchpad
    # set_property enabled $Enabled_Bar ${PARAM_VALUE.pf<<j>>_bar<<i>>_enabled}
    set defaultval [lindex $allowed 0]
    set allowed1 [join $allowed "," ]

    set_property range "$allowed1" $bar_size
    if {$value < [lindex $allowed 0]} {
      set value [lindex $allowed 0]
    } elseif {$value > [lindex $allowed end]} {
      set value [lindex $allowed end]
    } else {
      set value $value
    }
    set_property value $value $bar_size
    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]
    if {<<j>> != 0} {
      if {$copyPf0 == true} { 
        set_property enabled false $bar_size
        set_property range_value [get_property value ${PARAM_VALUE.pf0_bar<<i>>_size_mqdma}],[get_property value ${PARAM_VALUE.pf0_bar<<i>>_size_mqdma}] $bar_size 
      } 
    }
  }

  proc update_PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_size {PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_size PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_scale PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_type PARAM_VALUE.copy_sriov_pf0 PARAM_VALUE.device_port_type PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_64bit IPINST } {
    set bar_size ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_size}
    set value [get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_size}]
    set allowed {1 2 4 8 16 32 64 128 256 512}
  
    set Enabled_bar [get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled}]
    set_property enabled $Enabled_bar $bar_size 

    if {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_type}] eq "IO"} {
      if {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_scale}] eq "Bytes"} {
        set allowed {16 32 64 128 256 512}
      } elseif {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_scale}] eq "Gigabytes"} {
        if {<<i>> != 5 } {
          if {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_64bit}] == true} {
            set allowed {1 2 4 8 16 32 64 128 256}
          } else {
            set allowed {1 2}
          }
        } else {
          set allowed {1 2}
        }
      }
    } elseif {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_type}] eq "Bypass_AXI_Master" } {
      if {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_scale}] eq "Bytes"} {
        set allowed {128 256 512}
      } elseif {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_scale}] eq "Gigabytes"} {
        if {<<i>> != 5 } {
          if {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_64bit}] == true} {
            set allowed {1 2 4 8 16 32 64 128 256}
          } else {
            set allowed {1 2}
          }
        } else {
          set allowed {1 2}
        }
      }
    }
    set defaultval [lindex $allowed 0]
    set allowed1 [join $allowed "," ]

    set_property range "$allowed1" $bar_size
    if {$value < [lindex $allowed 0]} {
      set value [lindex $allowed 0]
    } elseif {$value > [lindex $allowed end]} {
      set value [lindex $allowed end]
    } else {
      set value $value
    }
    #MArk for review
    set Enabled_sriov_bar [get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled} ]
    set_property enabled $Enabled_sriov_bar $bar_size 
    set_property value $value $bar_size                
    set copyPf0 [get_property value ${PARAM_VALUE.copy_sriov_pf0}]
    if {$copyPf0 == true && <<j>> != 0} { 
      set_property enabled false $bar_size 
      set_property range_value [get_property value [ipgui::get_paramspec -name pf0_sriov_bar<<i>>_size -of $IPINST]],[get_property value [ipgui::get_paramspec -name pf0_sriov_bar<<i>>_size -of $IPINST]] $bar_size 
    } 
  }


}

foreach j {0 1 2 3} {
  for { set i 0} {$i < 5} {incr i} {
    set OutString [regsub -all "<<j>>" $procedure_type2 $j]
    set OutString2 [regsub -all "<<i>>" $OutString $i]

    uplevel 0 $OutString2
  }
}

set updateOfLastScale {
  proc update_PARAM_VALUE.pf<<i>>_bar5_scale_mqdma {PARAM_VALUE.pf<<i>>_bar5_scale_mqdma PARAM_VALUE.pf0_bar5_scale_mqdma PARAM_VALUE.pf<<i>>_bar5_scale_mqdma PARAM_VALUE.pf<<i>>_bar5_type_mqdma PARAM_VALUE.pf<<i>>_bar5_enabled_mqdma PARAM_VALUE.pf<<i>>_bar5_enabled_mqdma PARAM_VALUE.copy_pf0 IPINST} {
    set value [get_property value ${PARAM_VALUE.pf<<i>>_bar5_scale_mqdma}]
    set bar_size ${PARAM_VALUE.pf<<i>>_bar5_scale_mqdma}
    set_property enabled [get_property value ${PARAM_VALUE.pf<<i>>_bar5_enabled_mqdma}] $bar_size

    set_property range "Bytes,Kilobytes,Megabytes,Gigabytes" $bar_size
    set_property value $value $bar_size

    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]
    if {$copyPf0 == true && <<i>> != 0} { 
      set_property enabled false $bar_size 
      set_property range_value [get_property value ${PARAM_VALUE.pf0_bar5_scale_mqdma}],[get_property value ${PARAM_VALUE.pf0_bar5_scale_mqdma}] $bar_size 
    } 
  }

  proc update_PARAM_VALUE.pf<<i>>_sriov_bar5_scale {PARAM_VALUE.pf<<i>>_sriov_bar5_scale PARAM_VALUE.pf0_sriov_bar5_scale PARAM_VALUE.pf<<i>>_sriov_bar5_scale PARAM_VALUE.pf<<i>>_sriov_bar5_type PARAM_VALUE.pf<<i>>_sriov_bar5_enabled PARAM_VALUE.copy_sriov_pf0 IPINST} {
    set value [get_property value ${PARAM_VALUE.pf<<i>>_sriov_bar5_scale}]
    set bar_size ${PARAM_VALUE.pf<<i>>_sriov_bar5_scale}

    set_property enabled [get_property value ${PARAM_VALUE.pf<<i>>_sriov_bar5_enabled}] $bar_size

    set_property range "Bytes,Kilobytes,Megabytes,Gigabytes" $bar_size
    set_property value $value $bar_size

    set copyPf0 [get_property value ${PARAM_VALUE.copy_sriov_pf0}]
    if {$copyPf0 == true && <<i>> != 0} { 
      set_property enabled false $bar_size 
      set_property range_value [get_property value ${PARAM_VALUE.pf0_sriov_bar5_scale}],[get_property value ${PARAM_VALUE.pf0_sriov_bar5_scale}] $bar_size 
    } 
  }

  proc update_PARAM_VALUE.pf<<i>>_bar5_size_mqdma {PARAM_VALUE.pf<<i>>_bar5_size_mqdma PARAM_VALUE.pf0_bar5_size_mqdma PARAM_VALUE.pf<<i>>_bar5_enabled_mqdma PARAM_VALUE.pf<<i>>_bar5_scale_mqdma PARAM_VALUE.pf<<i>>_bar5_type_mqdma PARAM_VALUE.pf<<i>>_bar5_size_mqdma PARAM_VALUE.copy_pf0 PARAM_VALUE.device_port_type IPINST} {
    set bar_size [ipgui::get_paramspec -name pf<<i>>_bar5_size_mqdma -of $IPINST]
    set value [get_property value [ipgui::get_paramspec -name pf<<i>>_bar5_size_mqdma -of $IPINST]]
    set allowed {1 2 4 8 16 32 64 128 256 512}

    set Enabled_bar [get_property value [ipgui::get_paramspec -name pf<<i>>_bar5_enabled_mqdma -of $IPINST] ]
    set_property enabled $Enabled_bar $bar_size 

    if {[get_property value [ipgui::get_paramspec -name pf<<i>>_bar5_type_mqdma -of $IPINST]] eq "IO"} {
      set_property enabled $Enabled_bar $bar_size 
      if {[get_property value [ipgui::get_paramspec -name pf<<i>>_bar5_scale_mqdma -of $IPINST]] eq "Bytes"} {
        set allowed {16 32 64 128 256 512}
      } elseif {[get_property value [ipgui::get_paramspec -name pf<<i>>_bar5_scale_mqdma -of $IPINST]] eq "Gigabytes"} {
        if {<<i>> != 5 } {
          if {[get_property value [ipgui::get_paramspec -name pf<<i>>_bar5_64bit_mqdma -of $IPINST]] == true} {
            if {[get_property value ${PARAM_VALUE.device_port_type} ] == "Root_Port_of_PCI_Express_Root_Complex"} {
                allowed {1 2 4 8}
            } else {
                set allowed {1 2 4 8 16 32 64 128 256}
            }
          } else {
            set allowed {1 2}
          }
        } else {
          set allowed {1 2}
        }
      }
    } else {
      if {([get_property value [ipgui::get_paramspec -name pf<<i>>_bar5_type_mqdma -of $IPINST]] eq "AXI_Lite_Master") || ([get_property value [ipgui::get_paramspec -name pf<<i>>_bar5_type_mqdma -of $IPINST]] eq "DMA")} {
        if {[get_property value [ipgui::get_paramspec -name pf<<i>>_bar5_scale_mqdma -of $IPINST]] eq "Bytes"} {
          if {[get_property value ${PARAM_VALUE.device_port_type}] == "Root_Port_of_PCI_Express_Root_Complex"} {
            set allowed {4 8 16 32 64 128 256 512}
          } else {
            set allowed {128 256 512}
          }
        } else {

              if {[get_property value [ipgui::get_paramspec -name pf<<i>>_bar5_scale_mqdma -of $IPINST]] eq "Gigabytes"} {
                set allowed {1 2}
              } else {
                set allowed {1 2 4 8 16 32 64 128 256 512}
              }
        }
      } else {
        set value "128" 
      }
    }

    if {[get_property value ${PARAM_VALUE.copy_pf0}] == false} {
      set range [get_property default_range [ipgui::get_paramspec pf<<i>>_bar5_size_mqdma -of $IPINST]] 
      set value [get_property default_value [ipgui::get_paramspec pf<<i>>_bar5_size_mqdma -of $IPINST]] 
      set_property range_value $range,$value [ipgui::get_paramspec pf<<i>>_bar5_size_mqdma -of $IPINST]   
    }
    set defaultval [lindex $allowed 0]
    set allowed1 [join $allowed "," ]

    set_property range "$allowed1" $bar_size
    if {$value < [lindex $allowed 0]} {
      set value [lindex $allowed 0]
    } elseif {$value > [lindex $allowed end]} {
      set value [lindex $allowed end]
    } else {
      set value $value
    }
    #MArk for review

    set Enabled_bar [get_property value [ipgui::get_paramspec -name pf<<i>>_bar5_enabled_mqdma -of $IPINST] ]
    set_property enabled $Enabled_bar $bar_size 
    set_property value $value $bar_size                
    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]
    if {$copyPf0 == true && <<i>> != 0} { 
      set_property enabled false $bar_size 
      set_property range_value [get_property value ${PARAM_VALUE.pf0_bar5_size_mqdma}],[get_property value ${PARAM_VALUE.pf0_bar5_size_mqdma}] ${PARAM_VALUE.pf<<i>>_bar5_size_mqdma} 
    } 
  }

  proc update_PARAM_VALUE.pf<<i>>_sriov_bar5_size {PARAM_VALUE.pf<<i>>_sriov_bar5_size PARAM_VALUE.pf0_sriov_bar5_size PARAM_VALUE.pf<<i>>_sriov_bar5_enabled PARAM_VALUE.pf<<i>>_sriov_bar5_enabled PARAM_VALUE.pf<<i>>_sriov_bar5_type PARAM_VALUE.pf<<i>>_sriov_bar5_scale PARAM_VALUE.pf<<i>>_sriov_bar5_type PARAM_VALUE.pf0_sriov_bar5_size PARAM_VALUE.copy_sriov_pf0 PARAM_VALUE.device_port_type IPINST} {
    set bar_size [ipgui::get_paramspec -name pf<<i>>_sriov_bar5_size -of $IPINST]
    set value [get_property value [ipgui::get_paramspec -name pf<<i>>_sriov_bar5_size -of $IPINST]]
    set allowed {1 2 4 8 16 32 64 128 256 512}
                
    if {[get_property value [ipgui::get_paramspec -name pf<<i>>_sriov_bar5_type -of $IPINST]] eq "IO"} {
      if {[get_property value [ipgui::get_paramspec -name pf<<i>>_sriov_bar5_scale -of $IPINST]] eq "Bytes"} {
        set allowed {16 32 64 128 256 512}
      } elseif {[get_property value [ipgui::get_paramspec -name pf<<i>>_sriov_bar5_scale -of $IPINST]] eq "Gigabytes"} {
        set allowed {1 2}
      }
    } elseif {([get_property value [ipgui::get_paramspec -name pf<<i>>_sriov_bar5_type -of $IPINST]] eq "AXI_Lite_Master") || ([get_property value [ipgui::get_paramspec -name pf<<i>>_sriov_bar5_type -of $IPINST]] eq "DMA") } {
      if {[get_property value ${PARAM_VALUE.pf<<i>>_sriov_bar5_scale}] eq "Bytes"} {
        set allowed {128 256 512}
      } elseif {[get_property value ${PARAM_VALUE.pf<<i>>_sriov_bar5_scale}] eq "Gigabytes"} {
        set allowed {1 2}
      }
    }
    set defaultval [lindex $allowed 0]
    set allowed1 [join $allowed "," ]

    set_property range "$allowed1" $bar_size
    if {$value < [lindex $allowed 0]} {
      set value [lindex $allowed 0]
    } elseif {$value > [lindex $allowed end]} {
      set value [lindex $allowed end]
    } else {
      set value $value
    }
    #MArk for review
    set Enabled_sriov_bar [get_property value [ipgui::get_paramspec -name pf<<i>>_sriov_bar5_enabled -of $IPINST] ]
    set_property enabled $Enabled_sriov_bar $bar_size 
    set_property value $value $bar_size                
    set copyPf0 [get_property value ${PARAM_VALUE.copy_sriov_pf0}]
    if {$copyPf0 == true && <<i>> != 0} { 
      set_property enabled false $bar_size 
      set_property range_value [get_property value ${PARAM_VALUE.pf0_sriov_bar5_size}],[get_property value ${PARAM_VALUE.pf0_sriov_bar5_size}] $bar_size 
    } 
  }
}

foreach i {0 1 2 3} {
  set OutString [regsub -all "<<i>>" $updateOfLastScale $i]
  uplevel 0 $OutString
}

###############################################################
# Procedures for bar_enabled parameters for PF and SRIOV PFs
# #############################################################
set procedure_type71 {
  proc update_PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma {PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma PARAM_VALUE.pf0_bar<<i>>_enabled_mqdma PARAM_VALUE.device_port_type PARAM_VALUE.pf<<j>>_bar<<k>>_64bit_mqdma PARAM_VALUE.copy_pf0 IPINST} {
    set bar_enabled [ipgui::get_paramspec pf<<j>>_bar<<i>>_enabled_mqdma -of $IPINST]
    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type}]
    
    if {$copyPf0 == true && <<j>> != 0} { 
      set_property value [get_property value [ipgui::get_paramspec -name pf0_bar<<i>>_enabled_mqdma -of $IPINST ]] $bar_enabled
      set_property enabled false $bar_enabled 
    } else {
      set_property enabled true $bar_enabled 
      set_property value [get_property value [ipgui::get_paramspec -name pf<<j>>_bar<<i>>_enabled_mqdma -of $IPINST ]] $bar_enabled
    
      if { <<k>> != 1 } {
        if {$device_port_type == "Root_Port_of_PCI_Express_Root_Complex"} {
          set rprc 1
        } else {
          set rprc 0
        }
      } else {
        set rprc 0
      }
      if {[get_property value ${PARAM_VALUE.pf<<j>>_bar<<k>>_64bit_mqdma}  ] || $rprc} {
        set_property enabled false $bar_enabled
        set_property value false $bar_enabled
      } else {
        set_property enabled true $bar_enabled
      }
    }
  }

  proc update_PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled {PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled PARAM_VALUE.pf0_sriov_bar<<i>>_enabled PARAM_VALUE.device_port_type PARAM_VALUE.pf<<j>>_sriov_bar<<k>>_64bit PARAM_VALUE.copy_sriov_pf0 IPINST} {
    set bar_enabled [ipgui::get_paramspec -name pf<<j>>_sriov_bar<<i>>_enabled -of $IPINST]
    set copyPf0 [get_property value ${PARAM_VALUE.copy_sriov_pf0}]
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type}]
    
    if {$copyPf0 == true && <<j>> != 0} { 
      set_property value [get_property value [ipgui::get_paramspec -name pf0_sriov_bar<<i>>_enabled -of $IPINST ]] $bar_enabled
      set_property enabled false $bar_enabled 
    } else {
      set_property enabled true $bar_enabled 
      set_property value [get_property value [ipgui::get_paramspec -name pf<<j>>_sriov_bar<<i>>_enabled -of $IPINST ]] $bar_enabled
    
      if { <<k>> != 1 } {
        if {$device_port_type == "Root_Port_of_PCI_Express_Root_Complex"} {
          set rprc 1
        } else {
          set rprc 0
        }
      } else {
        set rprc 0
      }
      if {[get_property value ${PARAM_VALUE.pf<<j>>_sriov_bar<<k>>_64bit}  ] || $rprc} {
        set_property enabled false $bar_enabled
        set_property value false $bar_enabled
      } else {
        set_property enabled true $bar_enabled
      }
    }
  }
}   


foreach j {0 1 2 3} {
    foreach i {1 3 5} {
        set OutString [regsub -all "<<j>>" $procedure_type71 $j]
        set OutString2 [regsub -all "<<i>>" $OutString $i]
        set k [expr $i - 1]
        set OutString3 [regsub -all "<<k>>" $OutString2 $k]
        uplevel 0 $OutString3
  }
}


set procedure_type72 {
  proc update_PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma {PARAM_VALUE.pf<<j>>_bar<<i>>_enabled_mqdma PARAM_VALUE.pf0_bar<<i>>_enabled_mqdma PARAM_VALUE.device_port_type PARAM_VALUE.copy_pf0 IPINST PROJECT_PARAM.ARCHITECTURE} {
    set bar_enabled [ipgui::get_paramspec pf<<j>>_bar<<i>>_enabled_mqdma -of $IPINST]
    set copyPf0 [get_property value ${PARAM_VALUE.copy_pf0}]
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type}]
    
    if {$copyPf0 == true && <<j>> != 0} { 

      set_property value [get_property value [ipgui::get_paramspec -name pf0_bar<<i>>_enabled_mqdma -of $IPINST ]] $bar_enabled
      set_property enabled false $bar_enabled 
    } else {
      set_property enabled true $bar_enabled 
      set_property value [get_property value [ipgui::get_paramspec -name pf<<j>>_bar<<i>>_enabled_mqdma -of $IPINST ]] $bar_enabled
    
      if { <<k>> != 1 } {
        if {$device_port_type == "Root_Port_of_PCI_Express_Root_Complex"} {
          set rprc 1
        } else {
          set rprc 0
        }
      } else {
        set rprc 0
      }
        
    }
  }

  proc update_PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled {PARAM_VALUE.pf<<j>>_sriov_bar<<i>>_enabled PARAM_VALUE.pf0_sriov_bar<<i>>_enabled PARAM_VALUE.device_port_type PARAM_VALUE.copy_sriov_pf0 IPINST} {
    set bar_enabled [ipgui::get_paramspec -name pf<<j>>_sriov_bar<<i>>_enabled -of $IPINST]
    set copyPf0 [get_property value ${PARAM_VALUE.copy_sriov_pf0}]
    set device_port_type [get_property value ${PARAM_VALUE.device_port_type}]
    
    if {$copyPf0 == true && <<j>> != 0} { 
      set_property value [get_property value [ipgui::get_paramspec -name pf0_sriov_bar<<i>>_enabled -of $IPINST ]] $bar_enabled
      set_property enabled false $bar_enabled 
    } else {
      set_property enabled true $bar_enabled 
      set_property value [get_property value [ipgui::get_paramspec -name pf<<j>>_sriov_bar<<i>>_enabled -of $IPINST ]] $bar_enabled
    
      if { <<k>> != 1 } {
        if {$device_port_type == "Root_Port_of_PCI_Express_Root_Complex"} {
          set rprc 1
        } else {
          set rprc 0
        }
      } else {
        set rprc 0
      }
    }
  }
}   


foreach j {0 1 2 3} {
    foreach i {0 2 4} {
        set OutString [regsub -all "<<j>>" $procedure_type72 $j]
        set OutString2 [regsub -all "<<i>>" $OutString $i]
        set k [expr $i - 1]
        set OutString3 [regsub -all "<<k>>" $OutString2 $k]
        uplevel 0 $OutString3
  }
}

foreach i {0 1 2 3} {
  EvalSubstituting {i} {
    proc pf$i_Expansion_Rom_Bar_Value_updated_mqdma {IPINST PARAM_VALUE.pf$i_expansion_rom_enabled_mqdma} {
      if { [get_property value ${PARAM_VALUE.pf$i_expansion_rom_enabled_mqdma}  ] } {
        set size [lsearch {Bytes Kilobytes Megabytes Gigabytes Terabytes Petabytes Exabytes} [get_property value ${PARAM_VALUE.pf$i_expansion_rom_scale_mqdma}]]
        set size [expr "($size*10)+[lsearch {1 2 4 8 16 32 64 128 256 512} [get_property value ${PARAM_VALUE.pf$i_expansion_rom_size_mqdma}]]"]
        set value [expr "(0xFFFFFFFF << $size) & 0xFFFFFFF0 | 1"]
        return "[format %08X $value]"
      } else {
        return "00000000"
      }
    } ;# end pf$i_Expansion_Rom_Bar_Value_updated
  } 0
}

set dynamic_textValues {
 
  proc pf<<k>>_Bar<<i>>_Value_updated_mqdma {IPINST PARAM_VALUE.device_port_type PARAM_VALUE.pf<<k>>_bar<<i>>_type_mqdma PARAM_VALUE.pf<<k>>_bar<<i>>_prefetchable_mqdma PARAM_VALUE.pf<<k>>_bar<<i>>_64bit_mqdma PARAM_VALUE.pf<<k>>_bar<<i>>_scale_mqdma PARAM_VALUE.pf<<k>>_bar<<j>>_scale_mqdma PARAM_VALUE.pf<<k>>_bar<<j>>_size_mqdma PARAM_VALUE.pf<<k>>_bar<<j>>_64bit_mqdma PARAM_VALUE.pf<<k>>_bar<<i>>_enabled_mqdma PARAM_VALUE.pf<<k>>_bar<<i>>_size_mqdma} {

    set Bar_Enabled ${PARAM_VALUE.pf<<k>>_bar<<i>>_enabled_mqdma}
    set Bar_Type ${PARAM_VALUE.pf<<k>>_bar<<i>>_type_mqdma}
    set Bar_64bit ${PARAM_VALUE.pf<<k>>_bar<<i>>_64bit_mqdma}
    set Barj_64bit 0
    if { <<i>> != 0} {
      set Barj_64bit ${PARAM_VALUE.pf<<k>>_bar<<j>>_64bit_mqdma}
    }
    set Bar_Prefetchable ${PARAM_VALUE.pf<<k>>_bar<<i>>_prefetchable_mqdma}
    set Bar_Scale ${PARAM_VALUE.pf<<k>>_bar<<i>>_scale_mqdma}
    set Bar_Size ${PARAM_VALUE.pf<<k>>_bar<<i>>_size_mqdma}

    if {[expr {[get_property value   ${PARAM_VALUE.device_port_type}  ] eq "Root_Port_of_PCI_Express_Root_Complex"}]} {
      if { <<i>> == 2 } {
        return "00FF00FF"
      } elseif { <<i>> == 4} {
        return "FF00FF00"
      } 
    }

    set value [expr {(([get_property value   $Bar_Type  ] eq "IO")?1:0) | (([get_property value   $Bar_Prefetchable  ] == true)?8:0) } ]

    set value 0

    set size [lsearch {Bytes Kilobytes Megabytes Gigabytes Terabytes Petabytes Exabytes} [get_property value   $Bar_Scale  ]]
    set size [expr "($size*10)+[lsearch {1 2 4 8 16 32 64 128 256 512} [get_property value   $Bar_Size  ]]"]
    set value [expr "(0xFFFFFFFF << $size) & 0xFFFFFFF0 | $value"]

    if { <<i>> != 0 } {
      if {[get_property value   $Barj_64bit  ] == true} {
        set size [lsearch {Bytes Kilobytes Megabytes Gigabytes Terabytes Petabytes Exabytes} [get_property value   ${PARAM_VALUE.pf<<k>>_bar<<j>>_scale_mqdma}  ]]
        set size [expr "($size*10)+[lsearch {1 2 4 8 16 32 64 128 256 512} [get_property value ${PARAM_VALUE.pf<<k>>_bar<<j>>_size_mqdma} ]]"]

        if { $size<=31 } {
          return "FFFFFFFF"
        } else {
          set value [expr "(0xFFFFFFFF << ($size-32)) & 0xFFFFFFFF"]
          return "[format %08X $value]"
        }
      }
    }

    if { [get_property value   $Bar_Enabled  ] == true } {
      return "[format %08X $value]"
    } else {
      return "00000000"
    }
  }

  proc pf<<k>>_sriov_Bar<<i>>_Value_updated {IPINST PARAM_VALUE.device_port_type PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_type PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_prefetchable PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_64bit PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_scale PARAM_VALUE.pf<<k>>_sriov_bar<<j>>_scale PARAM_VALUE.pf<<k>>_sriov_bar<<j>>_size PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_size PARAM_VALUE.pf<<k>>_sriov_bar<<j>>_64bit PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_enabled } {

    set Bar_Size ${PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_size} 
    set Bar_Enabled ${PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_enabled}
    set Bar_Type ${PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_type}
    set Bar_64bit ${PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_64bit}
    set Barj_64bit 0
    if { <<i>> != 0} {
      set Barj_64bit ${PARAM_VALUE.pf<<k>>_sriov_bar<<j>>_64bit}
    }
    set Bar_Prefetchable ${PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_prefetchable}
    set Bar_Scale ${PARAM_VALUE.pf<<k>>_sriov_bar<<i>>_scale}


    if {[expr {[get_property value   ${PARAM_VALUE.device_port_type}  ] eq "Root_Port_of_PCI_Express_Root_Complex"}]} {
      if { <<i>> == 2 } {
        return "00FF00FF"
      } elseif { <<i>> == 4} {
        return "FF00FF00"
      }
    }

    set value [expr {(([get_property value   $Bar_Type  ] eq "IO")?1:0) | (([get_property value   $Bar_Prefetchable  ] == true)?8:0) } ]
    if { <<i>> != 5} {
      set value [expr { $value | (([get_property value   $Bar_64bit  ] == true)?4:0) } ]
    }
    set size [lsearch {Bytes Kilobytes Megabytes Gigabytes Terabytes Petabytes Exabytes} [get_property value   $Bar_Scale  ]]
    set size [expr "($size*10)+[lsearch {1 2 4 8 16 32 64 128 256 512} [get_property value   $Bar_Size  ]]"]


    if {[get_property value   $Bar_64bit  ] != true} {
#         send_msg INFO 1 "value1= $value" 
      if { [get_property value   $Bar_Enabled  ] == true } {
      set value [expr "(0xFFFFFFFF << $size) & 0xFFFFFFF0 | $value"]
        return "[format %08X $value]"
      } else {
        return "00000000"
      }
    } else {
      if { [get_property value   $Bar_Enabled  ] == true } {
          set value [expr "(0xFFFFFFFFFFFFFFFF << $size) & 0xFFFFFFFFFFFFFFF0 | $value"]
#         send_msg INFO 1 "value2= $value" 
          return "[format %16X $value]"
	} else {
          return "0000000000000000"
	}
    }

  }
}

foreach k {0 1 2 3} {
  foreach i {0 1 2 3 4} {
    set OutString2 [regsub -all "<<i>>" $dynamic_textValues $i]
    set OutString [regsub -all "<<j>>" $OutString2 $j]
    set OutString3 [regsub -all "<<k>>" $OutString $k]
    uplevel 0 $OutString3
  }
}


foreach i { 0 1 2 3 } {
  EvalSubstituting {i} {
    proc validate_PARAM_VALUE.pf$i_bar5_enabled_mqdma {IPINST PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf$i_bar0_enabled_mqdma PARAM_VALUE.pf$i_bar1_enabled_mqdma PARAM_VALUE.pf$i_bar2_enabled_mqdma PARAM_VALUE.pf$i_bar3_enabled_mqdma  PARAM_VALUE.pf$i_bar4_enabled_mqdma PARAM_VALUE.pf$i_bar5_enabled_mqdma } {

      # global pf$i_BarN_Warning
      if {$i ==1 && [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 2 } {
        if {[get_property value ${PARAM_VALUE.pf$i_bar0_enabled_mqdma}] == false &&
            [get_property value ${PARAM_VALUE.pf$i_bar1_enabled_mqdma}] == false &&
            [get_property value ${PARAM_VALUE.pf$i_bar2_enabled_mqdma}] == false &&
            [get_property value ${PARAM_VALUE.pf$i_bar3_enabled_mqdma}] == false &&
            [get_property value ${PARAM_VALUE.pf$i_bar4_enabled_mqdma}] == false &&
            [get_property value ${PARAM_VALUE.pf$i_bar5_enabled_mqdma}] == false} {
          set_property errmsg  "At least one Bar must be selected"  [ipgui::get_paramspec pf$i_bar5_enabled_mqdma -of $IPINST ]
          return false
        }
      }
      return true
    }

    proc validate_PARAM_VALUE.pf$i_sriov_bar5_enabled {PARAM_VALUE.pf$i_sriov_bar0_enabled PARAM_VALUE.pf$i_sriov_bar1_enabled PARAM_VALUE.pf$i_sriov_bar2_enabled PARAM_VALUE.pf$i_sriov_bar3_enabled PARAM_VALUE.pf$i_sriov_bar4_enabled PARAM_VALUE.pf$i_sriov_bar5_enabled  IPINST} {

      if {[get_property value ${PARAM_VALUE.pf$i_sriov_bar0_enabled}] == false &&
          [get_property value ${PARAM_VALUE.pf$i_sriov_bar1_enabled}] == false &&
          [get_property value ${PARAM_VALUE.pf$i_sriov_bar2_enabled}] == false &&
          [get_property value ${PARAM_VALUE.pf$i_sriov_bar3_enabled}] == false &&
          [get_property value ${PARAM_VALUE.pf$i_sriov_bar4_enabled}] == false &&
          [get_property value ${PARAM_VALUE.pf$i_sriov_bar5_enabled}] == false} {

        set_property errmsg  "At least one Bar must be selected"  [ipgui::get_paramspec pf$i_sriov_bar5_enabled -of $IPINST ]
        return false
      }
      return true
    }
  } 0
}
####################################
# ### PCIE ID Value updates 
####################################

foreach i {1 2 3} {
  EvalSubstituting {i} {
    proc update_PARAM_VALUE.pf$i_vendor_id_mqdma {IPINST PARAM_VALUE.pf0_vendor_id_mqdma} { 
      set pf$i_vendor_id [ipgui::get_paramspec -name pf$i_vendor_id_mqdma -of $IPINST]
      set vendor_id [get_property value ${PARAM_VALUE.pf0_vendor_id_mqdma}]
    
      set_property value $vendor_id $pf$i_vendor_id
      set_property enabled false $pf$i_vendor_id
    }
  } 0
}

foreach i {1 2 3} {
  EvalSubstituting {i} {
    proc update_PARAM_VALUE.PF$i_SUBSYSTEM_VENDOR_ID_mqdma {IPINST PARAM_VALUE.PF0_SUBSYSTEM_VENDOR_ID_mqdma} { 
      set PF$i_SUBSYSTEM_VENDOR_ID [ipgui::get_paramspec -name PF$i_SUBSYSTEM_VENDOR_ID_mqdma -of $IPINST]
      set pf0_subsystem_vendor_id [get_property value ${PARAM_VALUE.PF0_SUBSYSTEM_VENDOR_ID_mqdma}]
    
      set_property value $pf0_subsystem_vendor_id $PF$i_SUBSYSTEM_VENDOR_ID
      set_property enabled false $PF$i_SUBSYSTEM_VENDOR_ID
    }
  } 0
}
set procedure_type4 {
  proc update_PARAM_VALUE.PF<<i>>_DEVICE_ID_mqdma {PARAM_VALUE.PF<<i>>_DEVICE_ID_mqdma PARAM_VALUE.device_port_type PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH PARAM_VALUE.tl_pf_enable_reg IPINST } {
    set PF [ipgui::get_paramspec -name PF<<i>>_DEVICE_ID_mqdma -of $IPINST]
    # Assigning the default values
    set port [expr {[get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"}]
    set speed_val 3
    set width 8

    if {[get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] == "2.5_GT/s"} {
      set speed_val 1
    } elseif {[get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] == "5.0_GT/s"} {
      set speed_val 2
    } elseif {[get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_SPEED}] == "8.0_GT/s"} {
      set speed_val 3
    } else {
      set speed_val 4
    }

    switch [get_property value ${PARAM_VALUE.PL_LINK_CAP_MAX_LINK_WIDTH}] {
     "X1" { set width 1}
     "X2" { set width 2}
     "X4" { set width 4}
     "X8" { set width 8}
     "X16" { set width F}
    }
    set_property value  "9${port}${speed_val}${width}" $PF

    if {<<i>> == 1 && [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 1 } {
      set_property value [get_property default_value $PF] $PF
    } elseif {<<i>> == 2 && [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 2 } {
      set_property value [get_property default_value $PF] $PF
    } elseif {<<i>> == 3 && [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 } {
      set_property value [get_property default_value $PF] $PF
    }
  };#end updateOf_PF$i_DEVICE_ID

  proc update_PARAM_VALUE.pf<<i>>_class_code_base_mqdma {PARAM_VALUE.pf<<i>>_class_code_base_mqdma PARAM_VALUE.device_port_type IPINST} {
    set pf [ipgui::get_paramspec -name pf<<i>>_class_code_base_mqdma -of $IPINST]

    if {[get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
     set_property enabled false $pf
     set_property value "06" $pf
    } else {
     set_property enabled true $pf
    }
  } ;#end updateOf_pf<<i>>_class_code_base


  proc update_PARAM_VALUE.pf<<i>>_class_code_mqdma {PARAM_VALUE.pf<<i>>_class_code_mqdma PARAM_VALUE.pf<<i>>_class_code_sub_mqdma PARAM_VALUE.pf<<i>>_class_code_interface_mqdma PARAM_VALUE.pf<<i>>_class_code_base_mqdma  IPINST} {
    set pf [ipgui::get_paramspec -name pf<<i>>_class_code_mqdma -of $IPINST]
    set value1 [expr "0x[get_property value ${PARAM_VALUE.pf<<i>>_class_code_interface_mqdma}] | 0x[get_property value ${PARAM_VALUE.pf<<i>>_class_code_sub_mqdma}]00 | 0x[get_property value ${PARAM_VALUE.pf<<i>>_class_code_base_mqdma}]0000" ]
    set_property value "[format %06X $value1]" $pf
    #set_property value $value1 $pf ;#[format %06X $value1] $pf
    set_property enabled false $pf
  }


  proc update_PARAM_VALUE.pf<<i>>_base_class_menu_mqdma {PARAM_VALUE.pf<<i>>_base_class_menu_mqdma PARAM_VALUE.device_port_type  IPINST} {
    set pf [ipgui::get_paramspec -name pf<<i>>_base_class_menu_mqdma -of $IPINST]
    array set Base_Classes {
      "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
      "Mass_storage_controller" "01"
      "Network_controller" "02"
      "Display_controller" "03"
      "Multimedia_device" "04"
      "Memory_controller" "05"
      "Bridge_device" "06"
      "Simple_communication_controllers" "07"
      "Base_system_peripherals" "08"
      "Input_devices" "09"
      "Docking_stations" "0A"
      "Processors" "0B"
      "Serial_bus_controllers" "0C"
      "Wireless_controller" "0D"
      "Intelligent_I/O_controllers" "0E"
      "Satellite_communication_controllers" "0F"
      "Encryption/Decryption_controllers" "10"
      "Data_acquisition_and_signal_processing_controllers" "11"
      "Device_does_not_fit_in_any_defined_classes" "FF"
    }

    if {[get_property value ${PARAM_VALUE.device_port_type}] eq "Root_Port_of_PCI_Express_Root_Complex"} {
      set_property range_value "Bridge_device,Bridge_device" $pf
    } else {
      set rangelist [array names Base_Classes]
      set rangelist [regsub -all " " $rangelist ","]
      set index [lsearch $rangelist "Bridge_device"]
      if {${index}!= -1} {
        set rangelist [lreplace $rangelist ${index} ${index}]
      }
      set_property range_value "Memory_controller,$rangelist" $pf            
    }
  } ;#end updateOf_pf<<i>>_base_class_menu


  proc update_PARAM_VALUE.pf<<i>>_sub_class_interface_menu_mqdma {PARAM_VALUE.pf<<i>>_sub_class_interface_menu_mqdma PARAM_VALUE.pf<<i>>_base_class_menu_mqdma  IPINST} {        
    set pf [ipgui::get_paramspec -name pf<<i>>_sub_class_interface_menu_mqdma -of $IPINST]
    array set Base_Classes {
      "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
      "Mass_storage_controller" "01"
      "Network_controller" "02"
      "Display_controller" "03"
      "Multimedia_device" "04"
      "Memory_controller" "05"
      "Bridge_device" "06"
      "Simple_communication_controllers" "07"
      "Base_system_peripherals" "08"
      "Input_devices" "09"
      "Docking_stations" "0A"
      "Processors" "0B"
      "Serial_bus_controllers" "0C"
      "Wireless_controller" "0D"
      "Intelligent_I/O_controllers" "0E"
      "Satellite_communication_controllers" "0F"
      "Encryption/Decryption_controllers" "10"
      "Data_acquisition_and_signal_processing_controllers" "11"
      "Device_does_not_fit_in_any_defined_classes" "FF"
    }
    set base_name [get_property value ${PARAM_VALUE.pf<<i>>_base_class_menu_mqdma}]
    set base_code $Base_Classes($base_name)
    variable Sub_Interfaces_${base_code}h
    set Sub_Interface_List [array names Sub_Interfaces_${base_code}h]
    set Sub_Interface_List [regsub -all " " $Sub_Interface_List ","]
    set_property range "$Sub_Interface_List" $pf
  } ;#end updateOf_pf$i_sub_class_interface_menu
}

for {set i 0} {$i < 4} {incr i} {
   set OutString [regsub -all "<<i>>" $procedure_type4 $i]
   uplevel 0 $OutString
}

set procedure_type5 {
  proc update_PARAM_VALUE.pf<<i>>_class_code_base_mqdma {PARAM_VALUE.pf<<i>>_class_code_base_mqdma PARAM_VALUE.pf<<i>>_base_class_menu_mqdma PARAM_VALUE.pf<<i>>_Use_Class_Code_Lookup_Assistant_mqdma IPINST} {
    array set Base_Classes {
      "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
      "Mass_storage_controller" "01"
      "Network_controller" "02"
      "Display_controller" "03"
      "Multimedia_device" "04"
      "Memory_controller" "05"
      "Bridge_device" "06"
      "Simple_communication_controllers" "07"
      "Base_system_peripherals" "08"
      "Input_devices" "09"
      "Docking_stations" "0A"
      "Processors" "0B"
      "Serial_bus_controllers" "0C"
      "Wireless_controller" "0D"
      "Intelligent_I/O_controllers" "0E"
      "Satellite_communication_controllers" "0F"
      "Encryption/Decryption_controllers" "10"
      "Data_acquisition_and_signal_processing_controllers" "11"
      "Device_does_not_fit_in_any_defined_classes" "FF"
    }
    set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf<<i>>_base_class_menu_mqdma}])
    set_property value ${base_code} [ipgui::get_paramspec -name pf<<i>>_class_code_base_mqdma -of $IPINST]
    if { [get_property value ${PARAM_VALUE.pf<<i>>_Use_Class_Code_Lookup_Assistant_mqdma}] == true } {
      set_property enabled false [ipgui::get_paramspec -name pf<<i>>_class_code_base_mqdma -of $IPINST]
    } else {
      set_property enabled true [ipgui::get_paramspec -name pf<<i>>_class_code_base_mqdma -of $IPINST]
    }
  }
      
  proc update_PARAM_VALUE.pf<<i>>_base_class_range_mqdma {PARAM_VALUE.pf<<i>>_base_class_range_mqdma PARAM_VALUE.pf<<i>>_base_class_menu_mqdma PARAM_VALUE.pf<<i>>_Use_Class_Code_Lookup_Assistant_mqdma} {
    if { [get_property value ${PARAM_VALUE.pf<<i>>_Use_Class_Code_Lookup_Assistant_mqdma}] == true } {
      set_property enabled false [ipgui::get_paramspec -name pf<<i>>_base_class_range_mqdma -of $IPINST]
    }
  }

  proc update_PARAM_VALUE.pf<<i>>_base_class_value_mqdma {PARAM_VALUE.pf<<i>>_base_class_value_mqdma PARAM_VALUE.pf<<i>>_base_class_menu_mqdma PARAM_VALUE.pf<<i>>_Use_Class_Code_Lookup_Assistant_mqdma} {
    if { [get_property value ${PARAM_VALUE.pf<<i>>_Use_Class_Code_Lookup_Assistant_mqdma}] == true } {
      set_property enabled true [ipgui::get_paramspec -name pf<<i>>_base_class_value_mqdma -of $IPINST]
    } else {
      set_property enabled true [ipgui::get_paramspec -name pf<<i>>_base_class_value_mqdma -of $IPINST]
    }
  }
              
  proc update_PARAM_VALUE.pf<<i>>_class_code_sub_mqma {PARAM_VALUE.pf<<i>>_class_code_sub_mqma PARAM_VALUE.pf<<i>>_base_class_menu_mqma PARAM_VALUE.pf<<i>>_sub_class_interface_menu_mqma PARAM_VALUE.PF<<i>>_Use_Class_Code_Lookup_Assistant_mqma} {
    array set Base_Classes {
      "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
      "Mass_storage_controller" "01"
      "Network_controller" "02"
      "Display_controller" "03"
      "Multimedia_device" "04"
      "Memory_controller" "05"
      "Bridge_device" "06"
      "Simple_communication_controllers" "07"
      "Base_system_peripherals" "08"
      "Input_devices" "09"
      "Docking_stations" "0A"
      "Processors" "0B"
      "Serial_bus_controllers" "0C"
      "Wireless_controller" "0D"
      "Intelligent_I/O_controllers" "0E"
      "Satellite_communication_controllers" "0F"
      "Encryption/Decryption_controllers" "10"
      "Data_acquisition_and_signal_processing_controllers" "11"
      "Device_does_not_fit_in_any_defined_classes" "FF"
    }
    set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf<<i>>_base_class_menu_mqma}])
    variable Sub_Interfaces_${base_code}h
    set sub_int [set Sub_Interfaces_${base_code}h([get_property value ${PARAM_VALUE.pf<<i>>_sub_class_interface_menu_mqma}])]
    set subint0  [lindex $sub_int 0]
    set_property value [string range $subint0 0 [expr [string length $subint0] - 2 ]] ${PARAM_VALUE.pf<<i>>_class_code_sub_mqma}
    if { [get_property value ${PARAM_VALUE.PF<<i>>_Use_Class_Code_Lookup_Assistant_mqma}] == true } {
      set_property enabled false ${PARAM_VALUE.pf<<i>>_class_code_sub_mqma}
    } else {
      set_property enabled true ${PARAM_VALUE.pf<<i>>_class_code_sub_mqma}
    }
  }

  proc update_PARAM_VALUE.pf<<i>>_class_code_interface_mqma {PARAM_VALUE.pf<<i>>_class_code_interface_mqma PARAM_VALUE.pf<<i>>_base_class_menu_mqma PARAM_VALUE.pf<<i>>_sub_class_interface_menu_mqma PARAM_VALUE.PF<<i>>_Use_Class_Code_Lookup_Assistant_mqma} {
    array set Base_Classes {
      "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
      "Mass_storage_controller" "01"
      "Network_controller" "02"
      "Display_controller" "03"
      "Multimedia_device" "04"
      "Memory_controller" "05"
      "Bridge_device" "06"
      "Simple_communication_controllers" "07"
      "Base_system_peripherals" "08"
      "Input_devices" "09"
      "Docking_stations" "0A"
      "Processors" "0B"
      "Serial_bus_controllers" "0C"
      "Wireless_controller" "0D"
      "Intelligent_I/O_controllers" "0E"
      "Satellite_communication_controllers" "0F"
      "Encryption/Decryption_controllers" "10"
      "Data_acquisition_and_signal_processing_controllers" "11"
      "Device_does_not_fit_in_any_defined_classes" "FF"
    }
    set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf<<i>>_base_class_menu_mqma}])
    variable Sub_Interfaces_${base_code}h
    set sub_int [set Sub_Interfaces_${base_code}h([get_property value ${PARAM_VALUE.pf<<i>>_sub_class_interface_menu_mqma}])]
    set subint1  [lindex $sub_int 1]
    set subint0  [lindex $sub_int 0]
    set_property value [string range $subint1 0 [expr [string length $subint0] - 2 ]] ${PARAM_VALUE.pf<<i>>_class_code_interface_mqma}
    if { [get_property value ${PARAM_VALUE.PF<<i>>_Use_Class_Code_Lookup_Assistant_mqma}] == true } {
      set_property enabled false ${PARAM_VALUE.pf<<i>>_class_code_interface_mqma}
    } else {
      set_property enabled true ${PARAM_VALUE.pf<<i>>_class_code_interface_mqma}
    }
  }

  proc update_gui_for_PARAM_VALUE.pf<<i>>_Use_Class_Code_Lookup_Assistant_mqma {PARAM_VALUE.PF<<i>>_Use_Class_Code_Lookup_Assistant_mqma IPINST PARAM_VALUE.pf<<i>>_class_code_interface_mqma PARAM_VALUE.pf<<i>>_base_class_menu_mqma IPINST} {
    if { [get_property value ${PARAM_VALUE.PF<<i>>_Use_Class_Code_Lookup_Assistant_mqma}] == "true" } {
      set_property visible false [ipgui::get_textspec -name pf<<i>>_base_class_range_mqma -of $IPINST]
      set_property visible true [ipgui::get_textspec -name pf<<i>>_base_class_value_mqma -of $IPINST]
      set_property visible false [ipgui::get_textspec -name pf<<i>>_sub_class_range_mqma -of $IPINST]
      set_property visible true [ipgui::get_textspec -name pf<<i>>_sub_class_value_mqma -of $IPINST]
      set_property visible false [ipgui::get_textspec -name pf<<i>>_interface_range_mqma -of $IPINST]
      set_property visible true [ipgui::get_textspec -name pf<<i>>_interface_value_mqma -of $IPINST]
    } else {
      set_property visible true [ipgui::get_textspec -name pf<<i>>_base_class_range_mqma -of $IPINST]
      set_property visible false [ipgui::get_textspec -name pf<<i>>_base_class_value_mqma -of $IPINST]
      set_property visible true [ipgui::get_textspec -name pf<<i>>_sub_class_range_mqma -of $IPINST]
      set_property visible false [ipgui::get_textspec -name pf<<i>>_sub_class_value_mqma -of $IPINST]
      set_property visible true [ipgui::get_textspec -name pf<<i>>_interface_range_mqma -of $IPINST]
      set_property visible false [ipgui::get_textspec -name pf<<i>>_interface_value_mqma -of $IPINST]
    }
  }
}

foreach i {0 1 2 3} {
  set OutString [regsub -all "<<i>>" $procedure_type5 $i]
  uplevel 0 $OutString
}



proc pf0_base_class_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma PARAM_VALUE.pf0_sub_class_interface_menu_mqdma} {
array set Base_Classes {
  "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
  "Mass_storage_controller" "01"
  "Network_controller" "02"
  "Display_controller" "03"
  "Multimedia_device" "04"
  "Memory_controller" "05"
  "Bridge_device" "06"
  "Simple_communication_controllers" "07"
  "Base_system_peripherals" "08"
  "Input_devices" "09"
  "Docking_stations" "0A"
  "Processors" "0B"
  "Serial_bus_controllers" "0C"
  "Wireless_controller" "0D"
  "Intelligent_I/O_controllers" "0E"
  "Satellite_communication_controllers" "0F"
  "Encryption/Decryption_controllers" "10"
  "Data_acquisition_and_signal_processing_controllers" "11"
  "Device_does_not_fit_in_any_defined_classes" "FF"
}
  set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
  return "<b>${base_code}h</b>"
}

proc pf0_sub_class_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma PARAM_VALUE.pf0_sub_class_interface_menu_mqdma} {
  array set Base_Classes {
    "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
    "Mass_storage_controller" "01"
    "Network_controller" "02"
    "Display_controller" "03"
    "Multimedia_device" "04"
    "Memory_controller" "05"
    "Bridge_device" "06"
    "Simple_communication_controllers" "07"
    "Base_system_peripherals" "08"
    "Input_devices" "09"
    "Docking_stations" "0A"
    "Processors" "0B"
    "Serial_bus_controllers" "0C"
    "Wireless_controller" "0D"
    "Intelligent_I/O_controllers" "0E"
    "Satellite_communication_controllers" "0F"
    "Encryption/Decryption_controllers" "10"
    "Data_acquisition_and_signal_processing_controllers" "11"
    "Device_does_not_fit_in_any_defined_classes" "FF"
  }
  set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
  variable Sub_Interfaces_${base_code}h
  set sub_int [set Sub_Interfaces_${base_code}h([get_property value ${PARAM_VALUE.pf0_sub_class_interface_menu_mqdma}])]
  return "<b>[lindex $sub_int 0]</b>"
}

proc pf0_interface_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma PARAM_VALUE.pf0_sub_class_interface_menu_mqdma} {
  array set Base_Classes {
    "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
    "Mass_storage_controller" "01"
    "Network_controller" "02"
    "Display_controller" "03"
    "Multimedia_device" "04"
    "Memory_controller" "05"
    "Bridge_device" "06"
    "Simple_communication_controllers" "07"
    "Base_system_peripherals" "08"
    "Input_devices" "09"
    "Docking_stations" "0A"
    "Processors" "0B"
    "Serial_bus_controllers" "0C"
    "Wireless_controller" "0D"
    "Intelligent_I/O_controllers" "0E"
    "Satellite_communication_controllers" "0F"
    "Encryption/Decryption_controllers" "10"
    "Data_acquisition_and_signal_processing_controllers" "11"
    "Device_does_not_fit_in_any_defined_classes" "FF"
  }
  set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
  variable Sub_Interfaces_${base_code}h
  set sub_int [set Sub_Interfaces_${base_code}h([get_property value ${PARAM_VALUE.pf0_sub_class_interface_menu_mqdma}])]
  return "<b>[lindex $sub_int 1]</b>"
}

proc validate_PARAM_VALUE.pf0_vendor_id_mqdma {PARAM_VALUE.pf0_vendor_id_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf0_vendor_id_mqdma}]  0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.pf1_vendor_id_mqdma {PARAM_VALUE.pf1_vendor_id_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf1_vendor_id_mqdma}]  0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.pf2_vendor_id_mqdma {PARAM_VALUE.pf2_vendor_id_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf2_vendor_id_mqdma}]  0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.pf3_vendor_id_mqdma {PARAM_VALUE.pf3_vendor_id_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf3_vendor_id_mqdma}]  0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.PF0_DEVICE_ID_mqdma {PARAM_VALUE.PF0_DEVICE_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF0_DEVICE_ID_mqdma}] 0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.PF1_DEVICE_ID_mqdma {PARAM_VALUE.PF1_DEVICE_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF1_DEVICE_ID_mqdma}] 0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.PF2_DEVICE_ID_mqdma {PARAM_VALUE.PF2_DEVICE_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF2_DEVICE_ID_mqdma}] 0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.PF3_DEVICE_ID_mqdma {PARAM_VALUE.PF3_DEVICE_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF3_DEVICE_ID_mqdma}] 0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.PF0_SUBSYSTEM_ID_mqdma {PARAM_VALUE.PF0_SUBSYSTEM_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF0_SUBSYSTEM_ID_mqdma}] 0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.PF0_SUBSYSTEM_VENDOR_ID_mqdma {PARAM_VALUE.PF0_SUBSYSTEM_VENDOR_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF0_SUBSYSTEM_VENDOR_ID_mqdma}] 0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.PF1_SUBSYSTEM_ID_mqdma {PARAM_VALUE.PF1_SUBSYSTEM_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF1_SUBSYSTEM_ID_mqdma}] 0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.PF2_SUBSYSTEM_ID_mqdma {PARAM_VALUE.PF2_SUBSYSTEM_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF2_SUBSYSTEM_ID_mqdma}] 0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.PF3_SUBSYSTEM_ID_mqdma {PARAM_VALUE.PF3_SUBSYSTEM_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF3_SUBSYSTEM_ID_mqdma}] 0000 FFFF $IPINST]
}

proc validate_PARAM_VALUE.PF0_REVISION_ID_mqdma {PARAM_VALUE.PF0_REVISION_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF0_REVISION_ID_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.PF1_REVISION_ID_mqdma {PARAM_VALUE.PF1_REVISION_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF1_REVISION_ID_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.PF2_REVISION_ID_mqdma {PARAM_VALUE.PF2_REVISION_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF2_REVISION_ID_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.PF3_REVISION_ID_mqdma {PARAM_VALUE.PF3_REVISION_ID_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.PF3_REVISION_ID_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf0_class_code_base_mqdma {PARAM_VALUE.pf0_class_code_base_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf0_class_code_base_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf1_class_code_base_mqdma {PARAM_VALUE.pf1_class_code_base_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf1_class_code_base_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf2_class_code_base_mqdma {PARAM_VALUE.pf2_class_code_base_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf2_class_code_base_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf3_class_code_base_mqdma {PARAM_VALUE.pf3_class_code_base_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf3_class_code_base_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf0_class_code_sub_mqdma {PARAM_VALUE.pf0_class_code_sub_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf0_class_code_sub_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf1_class_code_sub_mqdma {PARAM_VALUE.pf1_class_code_sub_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf1_class_code_sub_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf2_class_code_sub_mqdma {PARAM_VALUE.pf2_class_code_sub_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf2_class_code_sub_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf3_class_code_sub_mqdma {PARAM_VALUE.pf3_class_code_sub_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf3_class_code_sub_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf0_class_code_interface_mqdma {PARAM_VALUE.pf0_class_code_interface_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf0_class_code_interface_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf1_class_code_interface_mqdma {PARAM_VALUE.pf1_class_code_interface_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf1_class_code_interface_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf2_class_code_interface_mqdma {PARAM_VALUE.pf2_class_code_interface_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf2_class_code_interface_mqdma}] 00 FF $IPINST]
}

proc validate_PARAM_VALUE.pf3_class_code_interface_mqdma {PARAM_VALUE.pf3_class_code_interface_mqdma IPINST} {
  return [RangeCheck4HexDec_1 [get_property value ${PARAM_VALUE.pf3_class_code_interface_mqdma}] 00 FF $IPINST]
}


#####Utility procs
proc RangeCheck4HexDec_1 {param MinValue MaxValue IPINST} {

  set paramValue $param
  if { [regexp -all {[a-fA-F0-9]} $paramValue] != [ string length $paramValue ]} {
    set_property errmsg "Entered invalid Hexadecimal value $paramValue" [ipgui::get_paramspec $param  -of $IPINST ]
    return false
  }
  if {$paramValue  == ""} {
   set_property errmsg "Entered invalid Hexadecimal value $paramValue" [ipgui::get_paramspec $param -of $IPINST ]
   return false
  }

  if {[expr 0x$MaxValue ] < [expr 0x$paramValue ] ||  [expr 0x$paramValue ] < [expr 0x$MinValue]} {
    set_property errmsg "Entered  Hexadecimal value $paramValue is out of range." [ipgui::get_paramspec $param  -of $IPINST ]
    return false
  }
  return true
}

proc pf1_base_class_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma} {
  array set Base_Classes {
    "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
    "Mass_storage_controller" "01"
    "Network_controller" "02"
    "Display_controller" "03"
    "Multimedia_device" "04"
    "Memory_controller" "05"
    "Bridge_device" "06"
    "Simple_communication_controllers" "07"
    "Base_system_peripherals" "08"
    "Input_devices" "09"
    "Docking_stations" "0A"
    "Processors" "0B"
    "Serial_bus_controllers" "0C"
    "Wireless_controller" "0D"
    "Intelligent_I/O_controllers" "0E"
    "Satellite_communication_controllers" "0F"
    "Encryption/Decryption_controllers" "10"
    "Data_acquisition_and_signal_processing_controllers" "11"
    "Device_does_not_fit_in_any_defined_classes" "FF"
  }
    set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
    return "<b>${base_code}h</b>"
  }

  proc pf2_base_class_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma} {
  array set Base_Classes {
    "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
    "Mass_storage_controller" "01"
    "Network_controller" "02"
    "Display_controller" "03"
    "Multimedia_device" "04"
    "Memory_controller" "05"
    "Bridge_device" "06"
    "Simple_communication_controllers" "07"
    "Base_system_peripherals" "08"
    "Input_devices" "09"
    "Docking_stations" "0A"
    "Processors" "0B"
    "Serial_bus_controllers" "0C"
    "Wireless_controller" "0D"
    "Intelligent_I/O_controllers" "0E"
    "Satellite_communication_controllers" "0F"
    "Encryption/Decryption_controllers" "10"
    "Data_acquisition_and_signal_processing_controllers" "11"
    "Device_does_not_fit_in_any_defined_classes" "FF"
  }
    set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
    return "<b>${base_code}h</b>"
  }

  proc pf3_base_class_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma} {
  array set Base_Classes {
    "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
    "Mass_storage_controller" "01"
    "Network_controller" "02"
    "Display_controller" "03"
    "Multimedia_device" "04"
    "Memory_controller" "05"
    "Bridge_device" "06"
    "Simple_communication_controllers" "07"
    "Base_system_peripherals" "08"
    "Input_devices" "09"
    "Docking_stations" "0A"
    "Processors" "0B"
    "Serial_bus_controllers" "0C"
    "Wireless_controller" "0D"
    "Intelligent_I/O_controllers" "0E"
    "Satellite_communication_controllers" "0F"
    "Encryption/Decryption_controllers" "10"
    "Data_acquisition_and_signal_processing_controllers" "11"
    "Device_does_not_fit_in_any_defined_classes" "FF"
  }
    set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
    return "<b>${base_code}h</b>"
  }

  proc pf1_sub_class_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma PARAM_VALUE.pf0_sub_class_interface_menu_mqdma} {
  array set Base_Classes {
    "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
    "Mass_storage_controller" "01"
    "Network_controller" "02"
    "Display_controller" "03"
    "Multimedia_device" "04"
    "Memory_controller" "05"
    "Bridge_device" "06"
    "Simple_communication_controllers" "07"
    "Base_system_peripherals" "08"
    "Input_devices" "09"
    "Docking_stations" "0A"
    "Processors" "0B"
    "Serial_bus_controllers" "0C"
    "Wireless_controller" "0D"
    "Intelligent_I/O_controllers" "0E"
    "Satellite_communication_controllers" "0F"
    "Encryption/Decryption_controllers" "10"
    "Data_acquisition_and_signal_processing_controllers" "11"
    "Device_does_not_fit_in_any_defined_classes" "FF"
  }
    set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
    variable Sub_Interfaces_${base_code}h
    set sub_int [set Sub_Interfaces_${base_code}h([get_property value ${PARAM_VALUE.pf0_sub_class_interface_menu_mqdma}])]
    return "<b>[lindex $sub_int 0]</b>"
  }

  proc pf2_sub_class_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma PARAM_VALUE.pf0_sub_class_interface_menu_mqdma} {
  array set Base_Classes {
    "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
    "Mass_storage_controller" "01"
    "Network_controller" "02"
    "Display_controller" "03"
    "Multimedia_device" "04"
    "Memory_controller" "05"
    "Bridge_device" "06"
    "Simple_communication_controllers" "07"
    "Base_system_peripherals" "08"
    "Input_devices" "09"
    "Docking_stations" "0A"
    "Processors" "0B"
    "Serial_bus_controllers" "0C"
    "Wireless_controller" "0D"
    "Intelligent_I/O_controllers" "0E"
    "Satellite_communication_controllers" "0F"
    "Encryption/Decryption_controllers" "10"
    "Data_acquisition_and_signal_processing_controllers" "11"
    "Device_does_not_fit_in_any_defined_classes" "FF"
  }
    set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
    variable Sub_Interfaces_${base_code}h
    set sub_int [set Sub_Interfaces_${base_code}h([get_property value ${PARAM_VALUE.pf0_sub_class_interface_menu_mqdma}])]
    return "<b>[lindex $sub_int 0]</b>"
  }

  proc pf3_sub_class_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma PARAM_VALUE.pf0_sub_class_interface_menu_mqdma} {
  array set Base_Classes {
    "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
    "Mass_storage_controller" "01"
    "Network_controller" "02"
    "Display_controller" "03"
    "Multimedia_device" "04"
    "Memory_controller" "05"
    "Bridge_device" "06"
    "Simple_communication_controllers" "07"
    "Base_system_peripherals" "08"
    "Input_devices" "09"
    "Docking_stations" "0A"
    "Processors" "0B"
    "Serial_bus_controllers" "0C"
    "Wireless_controller" "0D"
    "Intelligent_I/O_controllers" "0E"
    "Satellite_communication_controllers" "0F"
    "Encryption/Decryption_controllers" "10"
    "Data_acquisition_and_signal_processing_controllers" "11"
    "Device_does_not_fit_in_any_defined_classes" "FF"
  }
    set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
    variable Sub_Interfaces_${base_code}h
    set sub_int [set Sub_Interfaces_${base_code}h([get_property value ${PARAM_VALUE.pf0_sub_class_interface_menu_mqdma}])]
    return "<b>[lindex $sub_int 0]</b>"
  }


  proc pf1_interface_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma PARAM_VALUE.pf0_sub_class_interface_menu_mqdma} {
  array set Base_Classes {
    "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
    "Mass_storage_controller" "01"
    "Network_controller" "02"
    "Display_controller" "03"
    "Multimedia_device" "04"
    "Memory_controller" "05"
    "Bridge_device" "06"
    "Simple_communication_controllers" "07"
    "Base_system_peripherals" "08"
    "Input_devices" "09"
    "Docking_stations" "0A"
    "Processors" "0B"
    "Serial_bus_controllers" "0C"
    "Wireless_controller" "0D"
    "Intelligent_I/O_controllers" "0E"
    "Satellite_communication_controllers" "0F"
    "Encryption/Decryption_controllers" "10"
    "Data_acquisition_and_signal_processing_controllers" "11"
    "Device_does_not_fit_in_any_defined_classes" "FF"
  }
    set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
    variable Sub_Interfaces_${base_code}h
    set sub_int [set Sub_Interfaces_${base_code}h([get_property value ${PARAM_VALUE.pf0_sub_class_interface_menu_mqdma}])]
    return "<b>[lindex $sub_int 1]</b>"
  }

  proc pf2_interface_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma PARAM_VALUE.pf0_sub_class_interface_menu_mqdma} {
  array set Base_Classes {
    "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
    "Mass_storage_controller" "01"
    "Network_controller" "02"
    "Display_controller" "03"
    "Multimedia_device" "04"
    "Memory_controller" "05"
    "Bridge_device" "06"
    "Simple_communication_controllers" "07"
    "Base_system_peripherals" "08"
    "Input_devices" "09"
    "Docking_stations" "0A"
    "Processors" "0B"
    "Serial_bus_controllers" "0C"
    "Wireless_controller" "0D"
    "Intelligent_I/O_controllers" "0E"
    "Satellite_communication_controllers" "0F"
    "Encryption/Decryption_controllers" "10"
    "Data_acquisition_and_signal_processing_controllers" "11"
    "Device_does_not_fit_in_any_defined_classes" "FF"
  }
    set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
    variable Sub_Interfaces_${base_code}h
    set sub_int [set Sub_Interfaces_${base_code}h([get_property value ${PARAM_VALUE.pf0_sub_class_interface_menu_mqdma}])]
    return "<b>[lindex $sub_int 1]</b>"
  }

  proc pf3_interface_value_updated_mqdma {IPINST PARAM_VALUE.pf0_base_class_menu_mqdma PARAM_VALUE.pf0_sub_class_interface_menu_mqdma} {
  array set Base_Classes {
    "Device_was_built_before_Class_Code_definitions_were_finalized" "00"
    "Mass_storage_controller" "01"
    "Network_controller" "02"
    "Display_controller" "03"
    "Multimedia_device" "04"
    "Memory_controller" "05"
    "Bridge_device" "06"
    "Simple_communication_controllers" "07"
    "Base_system_peripherals" "08"
    "Input_devices" "09"
    "Docking_stations" "0A"
    "Processors" "0B"
    "Serial_bus_controllers" "0C"
    "Wireless_controller" "0D"
    "Intelligent_I/O_controllers" "0E"
    "Satellite_communication_controllers" "0F"
    "Encryption/Decryption_controllers" "10"
    "Data_acquisition_and_signal_processing_controllers" "11"
    "Device_does_not_fit_in_any_defined_classes" "FF"
  }
  set base_code $Base_Classes([get_property value ${PARAM_VALUE.pf0_base_class_menu_mqdma}])
  variable Sub_Interfaces_${base_code}h
  set sub_int [set Sub_Interfaces_${base_code}h([get_property value ${PARAM_VALUE.pf0_sub_class_interface_menu_mqdma}])]
  return "<b>[lindex $sub_int 1]</b>"
}

##############################################################
# Procedures for parameters in SRIOV CONFIG Page
##############################################################
proc update_PARAM_VALUE.SRIOV_FIRST_VF_OFFSET { PARAM_VALUE.SRIOV_FIRST_VF_OFFSET PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF3_SRIOV_CAP_INITIAL_VF PARAM_VALUE.pf0_ari_enabled } {
  set SRIOV_FIRST_VF_OFFSET ${PARAM_VALUE.SRIOV_FIRST_VF_OFFSET}
  set pf0 [get_property value ${PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF}]
  set pf1 [get_property value ${PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF}]
  set pf2 [get_property value ${PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF}]
  set pf3 [get_property value ${PARAM_VALUE.PF3_SRIOV_CAP_INITIAL_VF}]
  set val [expr {$pf0 + $pf1 + $pf2 + $pf3}]

  if { [get_property value ${PARAM_VALUE.pf0_ari_enabled} ] == false } {
    # Support First VF Offset of 1 only for 1PF 7VF non-ARI special use case
    set_property range_value 1,1 $SRIOV_FIRST_VF_OFFSET
  } elseif { $val > 192 } {
    # Total First VF Offset + Total VF must not > 256
    set_property range_value 4,4 $SRIOV_FIRST_VF_OFFSET
  } else {
    # Allowed First VF Offset when ARI is enabled
    if { [get_property value $SRIOV_FIRST_VF_OFFSET] == 1 } {
      set_property range_value 4,4,64 $SRIOV_FIRST_VF_OFFSET
    } else {
      set_property range_value [get_property value $SRIOV_FIRST_VF_OFFSET],4,64 $SRIOV_FIRST_VF_OFFSET
    }
  }
}

proc update_PARAM_VALUE.PF0_SRIOV_FIRST_VF_OFFSET { PARAM_VALUE.PF0_SRIOV_FIRST_VF_OFFSET PARAM_VALUE.SRIOV_FIRST_VF_OFFSET PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF } {
  # Procedure called to update PF0_SRIOV_FIRST_VF_OFFSET when any of the dependent parameters in the arguments change
  set PF0_SRIOV_FIRST_VF_OFFSET ${PARAM_VALUE.PF0_SRIOV_FIRST_VF_OFFSET}

  if { ! [get_property value ${PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF}] } {
    # No VF Enabled
    set_property value 0 $PF0_SRIOV_FIRST_VF_OFFSET
  } else {
    set_property value [get_property value ${PARAM_VALUE.SRIOV_FIRST_VF_OFFSET}] $PF0_SRIOV_FIRST_VF_OFFSET
  } 
}

proc validate_PARAM_VALUE.PF0_SRIOV_FIRST_VF_OFFSET { PARAM_VALUE.PF0_SRIOV_FIRST_VF_OFFSET } {
  # Procedure called to validate PF0_SRIOV_FIRST_VF_OFFSET
  return true
}

proc update_PARAM_VALUE.PF1_SRIOV_FIRST_VF_OFFSET { PARAM_VALUE.PF1_SRIOV_FIRST_VF_OFFSET PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF PARAM_VALUE.SRIOV_FIRST_VF_OFFSET } {
  # Procedure called to update PF1_SRIOV_FIRST_VF_OFFSET when any of the dependent parameters in the arguments change
  set PF1_SRIOV_FIRST_VF_OFFSET ${PARAM_VALUE.PF1_SRIOV_FIRST_VF_OFFSET}

  if { ! [get_property value ${PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF}] } {
    # No VF Enabled
    set_property value 0 $PF1_SRIOV_FIRST_VF_OFFSET
  } else {
    set sfvo [get_property value ${PARAM_VALUE.SRIOV_FIRST_VF_OFFSET}]
    set pf0  [get_property value ${PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF}]
    set val  [expr {$sfvo + $pf0}]
    set_property value $val $PF1_SRIOV_FIRST_VF_OFFSET
  } 
}

proc validate_PARAM_VALUE.PF1_SRIOV_FIRST_VF_OFFSET { PARAM_VALUE.PF1_SRIOV_FIRST_VF_OFFSET } {
  # Procedure called to validate PF1_SRIOV_FIRST_VF_OFFSET
  return true
}

proc update_PARAM_VALUE.PF2_SRIOV_FIRST_VF_OFFSET { PARAM_VALUE.PF2_SRIOV_FIRST_VF_OFFSET PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF PARAM_VALUE.SRIOV_FIRST_VF_OFFSET } {
  # Procedure called to update PF2_SRIOV_FIRST_VF_OFFSET when any of the dependent parameters in the arguments change
  set PF2_SRIOV_FIRST_VF_OFFSET ${PARAM_VALUE.PF2_SRIOV_FIRST_VF_OFFSET}

  if { ! [get_property value ${PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF}] } {
    # No VF Enabled
    set_property value 0 $PF2_SRIOV_FIRST_VF_OFFSET
  } else {
    set sfvo [get_property value ${PARAM_VALUE.SRIOV_FIRST_VF_OFFSET}]
    set pf0  [get_property value ${PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF}]
    set pf1  [get_property value ${PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF}]
    set val  [expr {$sfvo + $pf0 + $pf1}]
    set_property value $val $PF2_SRIOV_FIRST_VF_OFFSET
  } 
}

proc validate_PARAM_VALUE.PF2_SRIOV_FIRST_VF_OFFSET { PARAM_VALUE.PF2_SRIOV_FIRST_VF_OFFSET } {
  # Procedure called to validate PF2_SRIOV_FIRST_VF_OFFSET
  return true
}

proc update_PARAM_VALUE.PF3_SRIOV_FIRST_VF_OFFSET { PARAM_VALUE.PF3_SRIOV_FIRST_VF_OFFSET PARAM_VALUE.PF3_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF PARAM_VALUE.SRIOV_FIRST_VF_OFFSET } {
  # Procedure called to update PF3_SRIOV_FIRST_VF_OFFSET when any of the dependent parameters in the arguments change
  set PF3_SRIOV_FIRST_VF_OFFSET ${PARAM_VALUE.PF3_SRIOV_FIRST_VF_OFFSET}

  if {![get_property value ${PARAM_VALUE.PF3_SRIOV_CAP_INITIAL_VF}] } {
    # No VF Enabled
    set_property value 0 $PF3_SRIOV_FIRST_VF_OFFSET
  } else {
    set sfvo [get_property value ${PARAM_VALUE.SRIOV_FIRST_VF_OFFSET}]
    set pf0  [get_property value ${PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF}]
    set pf1  [get_property value ${PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF}]
    set pf2  [get_property value ${PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF}]
    set val  [expr {$sfvo + $pf0 + $pf1 + $pf2}]
    set_property value $val $PF3_SRIOV_FIRST_VF_OFFSET
  } 
}

proc validate_PARAM_VALUE.PF3_SRIOV_FIRST_VF_OFFSET { PARAM_VALUE.PF3_SRIOV_FIRST_VF_OFFSET } {
  # Procedure called to validate PF3_SRIOV_FIRST_VF_OFFSET
  return true
}

proc update_PARAM_VALUE.PF0_SRIOV_VF_DEVICE_ID { PARAM_VALUE.PF0_SRIOV_VF_DEVICE_ID } {
  # Procedure called to update PF0_SRIOV_VF_DEVICE_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PF0_SRIOV_VF_DEVICE_ID { PARAM_VALUE.PF0_SRIOV_VF_DEVICE_ID } {
  # Procedure called to validate PF0_SRIOV_VF_DEVICE_ID
  return true
}

proc update_PARAM_VALUE.PF1_SRIOV_VF_DEVICE_ID { PARAM_VALUE.PF1_SRIOV_VF_DEVICE_ID PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg } {
  # Procedure called to update PF1_SRIOV_VF_DEVICE_ID when any of the dependent parameters in the arguments change
  set PF1_SRIOV_VF_DEVICE_ID ${PARAM_VALUE.PF1_SRIOV_VF_DEVICE_ID}

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && ([get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 2 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4)} {
    set_property enabled true $PF1_SRIOV_VF_DEVICE_ID
  } else {
    set_property enabled false $PF1_SRIOV_VF_DEVICE_ID
    set_property value [get_property default_value $PF1_SRIOV_VF_DEVICE_ID] $PF1_SRIOV_VF_DEVICE_ID
  } 
}

proc validate_PARAM_VALUE.PF1_SRIOV_VF_DEVICE_ID { PARAM_VALUE.PF1_SRIOV_VF_DEVICE_ID } {
  # Procedure called to validate PF1_SRIOV_VF_DEVICE_ID
  return true
}

proc update_PARAM_VALUE.PF2_SRIOV_VF_DEVICE_ID { PARAM_VALUE.PF2_SRIOV_VF_DEVICE_ID PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.tl_pf_enable_reg } {
  # Procedure called to update PF2_SRIOV_VF_DEVICE_ID when any of the dependent parameters in the arguments change
  set PF2_SRIOV_VF_DEVICE_ID ${PARAM_VALUE.PF2_SRIOV_VF_DEVICE_ID}

  if {[get_property value  ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && ([get_property value  ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value  ${PARAM_VALUE.tl_pf_enable_reg}] == 4)} {
    set_property enabled true $PF2_SRIOV_VF_DEVICE_ID
  } else {
    set_property enabled false $PF2_SRIOV_VF_DEVICE_ID
    set_property value [get_property default_value $PF2_SRIOV_VF_DEVICE_ID] $PF2_SRIOV_VF_DEVICE_ID
  } 
}

proc validate_PARAM_VALUE.PF2_SRIOV_VF_DEVICE_ID { PARAM_VALUE.PF2_SRIOV_VF_DEVICE_ID } {
  # Procedure called to validate PF2_SRIOV_VF_DEVICE_ID
  return true
}

proc update_PARAM_VALUE.PF3_SRIOV_VF_DEVICE_ID { PARAM_VALUE.PF3_SRIOV_VF_DEVICE_ID PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg} {
  # Procedure called to update PF3_SRIOV_VF_DEVICE_ID when any of the dependent parameters in the arguments change
  set PF3_SRIOV_VF_DEVICE_ID ${PARAM_VALUE.PF3_SRIOV_VF_DEVICE_ID}

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4} {
    set_property enabled true $PF3_SRIOV_VF_DEVICE_ID
  } else {
    set_property enabled false $PF3_SRIOV_VF_DEVICE_ID
    set_property value [get_property default_value $PF3_SRIOV_VF_DEVICE_ID] $PF3_SRIOV_VF_DEVICE_ID
  } 
}

proc update_PARAM_VALUE.PF1_SRIOV_CAP_VER { PARAM_VALUE.PF1_SRIOV_CAP_VER PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.tl_pf_enable_reg } {
  # Procedure called to update PF1_SRIOV_CAP_VER when any of the dependent parameters in the arguments change
  set PF1_SRIOV_CAP_VER ${PARAM_VALUE.PF1_SRIOV_CAP_VER}

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && ([get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 2 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4)} {
    set_property enabled true  $PF1_SRIOV_CAP_VER
  } else {
    set_property enabled false $PF1_SRIOV_CAP_VER
    set_property value [get_property default_value $PF1_SRIOV_CAP_VER] $PF1_SRIOV_CAP_VER
  } 
}

proc validate_PARAM_VALUE.PF1_SRIOV_CAP_VER { PARAM_VALUE.PF1_SRIOV_CAP_VER } {
  # Procedure called to validate PF1_SRIOV_CAP_VER
  return true
}

proc update_PARAM_VALUE.PF2_SRIOV_CAP_VER { PARAM_VALUE.PF2_SRIOV_CAP_VER PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.tl_pf_enable_reg } {
  # Procedure called to update PF2_SRIOV_CAP_VER when any of the dependent parameters in the arguments change
  set PF2_SRIOV_CAP_VER ${PARAM_VALUE.PF2_SRIOV_CAP_VER}

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && ([get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4)} {
    set_property enabled true  $PF2_SRIOV_CAP_VER
  } else {
    set_property enabled false $PF2_SRIOV_CAP_VER
    set_property value [get_property default_value $PF2_SRIOV_CAP_VER] $PF2_SRIOV_CAP_VER
  } 
}

proc validate_PARAM_VALUE.PF2_SRIOV_CAP_VER { PARAM_VALUE.PF2_SRIOV_CAP_VER } {
  # Procedure called to validate PF2_SRIOV_CAP_VER
  return true
}

proc update_PARAM_VALUE.PF3_SRIOV_CAP_VER { PARAM_VALUE.PF3_SRIOV_CAP_VER PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg } {
  # Procedure called to update PF3_SRIOV_CAP_VER when any of the dependent parameters in the arguments change
  set PF3_SRIOV_CAP_VER ${PARAM_VALUE.PF3_SRIOV_CAP_VER}

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4} {
    set_property enabled true $PF3_SRIOV_CAP_VER
  } else {
    set_property enabled false $PF3_SRIOV_CAP_VER
    set_property value [get_property default_value $PF3_SRIOV_CAP_VER] $PF3_SRIOV_CAP_VER
  } 
}

proc validate_PARAM_VALUE.PF3_SRIOV_CAP_VER { PARAM_VALUE.PF3_SRIOV_CAP_VER } {
  # Procedure called to validate PF3_SRIOV_CAP_VER
  return true
}

proc update_PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF { PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf0_ari_enabled IPINST } {
  set PF0_SRIOV_CAP_INITIAL_VF ${PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF}

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true } {
    set_property enabled true $PF0_SRIOV_CAP_INITIAL_VF
    if { [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 2 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4} {
      set_property range_value 4,0,4,8,12,16 $PF0_SRIOV_CAP_INITIAL_VF
    } else {
      # Support First VF Offset of 1 only for 1PF 7VF non-ARI special use case
      if {[get_property value ${PARAM_VALUE.pf0_ari_enabled} ] == false } {
        set_property range_value 7,7 $PF0_SRIOV_CAP_INITIAL_VF
      } else {
        set_property range_value 4,4,8,12,16 $PF0_SRIOV_CAP_INITIAL_VF
      }
    }
  } else {
    set_property enabled false $PF0_SRIOV_CAP_INITIAL_VF  
    set_property range_value 0,0,4,8,12,16 $PF0_SRIOV_CAP_INITIAL_VF
  }
}

proc update_PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF { PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg  } {
  # Procedure called to update PF1_SRIOV_CAP_INITIAL_VF when any of the dependent parameters in the arguments change
  set PF1_SRIOV_CAP_INITIAL_VF ${PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF}
  set num_pf [get_property value ${PARAM_VALUE.tl_pf_enable_reg}]
  set pf0 [get_property value ${PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF}]
  set pf1 [get_property value ${PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF}]

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && ($num_pf == 2 || $num_pf == 3 || $num_pf == 4)} {
    set rangelist "0 4 8 12 16"
    set_property enabled true $PF1_SRIOV_CAP_INITIAL_VF

    if { [expr {$pf0 + $pf1}] > 252 } {
        #set index [expr {252 - $pf0}]
        set index [expr {[llength $rangelist] - $pf0/4 -1}]
        set rangelist [lrange $rangelist 0 $index]
        set rangelist [join $rangelist ","]
        set_property range_value "0,$rangelist" $PF1_SRIOV_CAP_INITIAL_VF
    } elseif { $num_pf == 2 && $pf0 == 0 } {
      set_property range "4,8,12,16" $PF1_SRIOV_CAP_INITIAL_VF
    } else {
       #set index [expr {252 - $pf0}]
       set index [expr {[llength $rangelist] - $pf0/4 -1}]
       set rangelist [lrange $rangelist 0 $index]
       set rangelist [join $rangelist ","]  
       set_property range_value "$pf1,$rangelist" $PF1_SRIOV_CAP_INITIAL_VF
    }
  } else {
    set_property enabled false $PF1_SRIOV_CAP_INITIAL_VF
    set_property range_value "0,0" $PF1_SRIOV_CAP_INITIAL_VF
  } 
}

proc update_PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF { PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF } {
  # Procedure called to update PF2_SRIOV_CAP_INITIAL_VF when any of the dependent parameters in the arguments change
  set PF2_SRIOV_CAP_INITIAL_VF ${PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF}
  set num_pf [get_property value ${PARAM_VALUE.tl_pf_enable_reg}]
  set pf0 [get_property value ${PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF}]
  set pf1 [get_property value ${PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF}]
  set pf2 [get_property value ${PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF}]

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && ($num_pf == 3 || $num_pf == 4)} {
    set rangelist "0 4 8 12 16"
    set_property enabled true $PF2_SRIOV_CAP_INITIAL_VF

    if { [expr {$pf0 + $pf1 + $pf2}] > 252 } {
        #set index [expr {252 - $pf0 - $pf1}]
       set index [expr {[llength $rangelist] - ($pf0+$pf1)/4 -1}]
        set rangelist [lrange $rangelist 0 $index]
        set rangelist [join $rangelist ","]
        set_property range_value "0,$rangelist" $PF2_SRIOV_CAP_INITIAL_VF
    } elseif { $num_pf == 3 && $pf0 == 0 && $pf1 == 0} {
      set_property range "4,8,12,16" $PF2_SRIOV_CAP_INITIAL_VF
    } else {
       #set index [expr {252 - $pf0 - $pf1}]
       set index [expr {[llength $rangelist] - ($pf0+$pf1)/4 -1}]
       set rangelist [lrange $rangelist 0 $index]
       set rangelist [join $rangelist ","]  
       set_property range_value $pf2,$rangelist $PF2_SRIOV_CAP_INITIAL_VF
    }
  } else {
    set_property enabled false $PF2_SRIOV_CAP_INITIAL_VF
    set_property range_value "0,0" $PF2_SRIOV_CAP_INITIAL_VF
  } 
}

proc update_PARAM_VALUE.PF3_SRIOV_CAP_INITIAL_VF { PARAM_VALUE.PF3_SRIOV_CAP_INITIAL_VF PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF } {
  # Procedure called to update PF3_SRIOV_CAP_INITIAL_VF when any of the dependent parameters in the arguments change
  set PF3_SRIOV_CAP_INITIAL_VF ${PARAM_VALUE.PF3_SRIOV_CAP_INITIAL_VF}
  set num_pf [get_property value ${PARAM_VALUE.tl_pf_enable_reg}]
  set pf0 [get_property value ${PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF}]
  set pf1 [get_property value ${PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF}]
  set pf2 [get_property value ${PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF}]
  set pf3 [get_property value ${PARAM_VALUE.PF3_SRIOV_CAP_INITIAL_VF}]

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && $num_pf == 4} {
    set rangelist "0 4 8 12 16"
    set_property enabled true $PF3_SRIOV_CAP_INITIAL_VF

    if { [expr {$pf0 + $pf1 + $pf2 + $pf3}] > 252 } {
        #set index [expr {252 - $pf0 - $pf1 - $pf2}]
       set index [expr {[llength $rangelist] - ($pf0+$pf1+$pf2)/4 -1}]
        set rangelist [lrange $rangelist 0 $index]
        set rangelist [join $rangelist ","]
        set_property range_value "0,$rangelist" $PF3_SRIOV_CAP_INITIAL_VF
    } elseif { $pf0 == 0 && $pf1 == 0 && $pf2 == 0} {
      set_property range "4,8,12,16" $PF3_SRIOV_CAP_INITIAL_VF
    } else {
       #set index [expr {252 - $pf0 - $pf1 - $pf2}]
       set index [expr {[llength $rangelist] - ($pf0+$pf1+$pf2)/4 -1}]
       set rangelist [lrange $rangelist 0 $index]
       set rangelist [join $rangelist ","]  
       set_property range_value $pf3,$rangelist $PF3_SRIOV_CAP_INITIAL_VF
    }
  } else {
    set_property enabled false $PF3_SRIOV_CAP_INITIAL_VF
    set_property range_value "0,0" $PF3_SRIOV_CAP_INITIAL_VF
  } 
}

proc update_PARAM_VALUE.PF1_SRIOV_FUNC_DEP_LINK { PARAM_VALUE.PF1_SRIOV_FUNC_DEP_LINK PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.tl_pf_enable_reg } {
  # Procedure called to update PF1_SRIOV_FUNC_DEP_LINK when any of the dependent parameters in the arguments change
   set PF1_SRIOV_FUNC_DEP_LINK ${PARAM_VALUE.PF1_SRIOV_FUNC_DEP_LINK}

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && ([get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 2 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4)} {
    set_property enabled true $PF1_SRIOV_FUNC_DEP_LINK
  } else {
    set_property enabled false $PF1_SRIOV_FUNC_DEP_LINK
    set_property value [get_property value $PF1_SRIOV_FUNC_DEP_LINK] $PF1_SRIOV_FUNC_DEP_LINK
  } 
}

proc update_PARAM_VALUE.PF2_SRIOV_FUNC_DEP_LINK { PARAM_VALUE.PF2_SRIOV_FUNC_DEP_LINK PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.tl_pf_enable_reg } {
  # Procedure called to update PF2_SRIOV_FUNC_DEP_LINK when any of the dependent parameters in the arguments change
   set PF2_SRIOV_FUNC_DEP_LINK ${PARAM_VALUE.PF2_SRIOV_FUNC_DEP_LINK}

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && ([get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4)} {
    set_property enabled true $PF2_SRIOV_FUNC_DEP_LINK
  } else {
    set_property enabled false $PF2_SRIOV_FUNC_DEP_LINK
    set_property value [get_property value $PF2_SRIOV_FUNC_DEP_LINK] $PF2_SRIOV_FUNC_DEP_LINK
  } 
}

proc update_PARAM_VALUE.PF3_SRIOV_FUNC_DEP_LINK { PARAM_VALUE.PF3_SRIOV_FUNC_DEP_LINK PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg } {
  # Procedure called to update PF3_SRIOV_FUNC_DEP_LINK when any of the dependent parameters in the arguments change
  set PF3_SRIOV_FUNC_DEP_LINK ${PARAM_VALUE.PF3_SRIOV_FUNC_DEP_LINK}

  if {[get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true && [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4} {
    set_property enabled true $PF3_SRIOV_FUNC_DEP_LINK
  } else {
    set_property enabled false $PF3_SRIOV_FUNC_DEP_LINK
    set_property value [get_property value $PF3_SRIOV_FUNC_DEP_LINK] $PF3_SRIOV_FUNC_DEP_LINK
  } 
}

proc update_PARAM_VALUE.pf0_ari_enabled {PARAM_VALUE.pf0_ari_enabled PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.tl_pf_enable_reg} {
  set c_pf0_ari_enabled ${PARAM_VALUE.pf0_ari_enabled}

  if {[get_property value  ${PARAM_VALUE.SRIOV_CAP_ENABLE}]} {
    set_property value true $c_pf0_ari_enabled
  } else {
    set_property value false $c_pf0_ari_enabled
  }

  if {[get_property value  ${PARAM_VALUE.SRIOV_CAP_ENABLE}] && [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] != 1} {
    set_property enabled false $c_pf0_ari_enabled
  } else {
    set_property enabled true $c_pf0_ari_enabled
  }
}

proc ConvertDecToHex { hex } {
  return [::ipgen::number_utils::dec2hex $hex]
}


#########################################################################
############ Procedure for MSIX parameters in MQDMA mode
#########################################################################
#

proc update_PARAM_VALUE.pf0_msix_enabled_mqdma {PARAM_VALUE.pf0_msix_enabled_mqdma PARAM_VALUE.pf0_bar0_enabled_mqdma PARAM_VALUE.pf0_bar1_enabled_mqdma  PARAM_VALUE.pf0_bar2_enabled_mqdma  PARAM_VALUE.pf0_bar3_enabled_mqdma  PARAM_VALUE.pf0_bar4_enabled_mqdma  PARAM_VALUE.pf0_bar5_enabled_mqdma PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.MSI_X_OPTIONS } {
   #Procedure called to update pf0_msix_enabled when any of the dependent parameters in the arguments change
  if {([get_property value ${PARAM_VALUE.pf0_bar0_enabled_mqdma}] == true) || ([get_property value  ${PARAM_VALUE.pf0_bar1_enabled_mqdma}] == true ) || ([get_property value  ${PARAM_VALUE.pf0_bar2_enabled_mqdma}] == true ) || ([get_property value  ${PARAM_VALUE.pf0_bar3_enabled_mqdma}] == true ) || ([get_property value  ${PARAM_VALUE.pf0_bar4_enabled_mqdma}] == true ) || ([get_property value  ${PARAM_VALUE.pf0_bar5_enabled_mqdma }] == true )} {
    if {([get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true || [get_property value ${PARAM_VALUE.MSI_X_OPTIONS}] != "None")} {
      set_property enabled true ${PARAM_VALUE.pf0_msix_enabled_mqdma}
      set_property value true ${PARAM_VALUE.pf0_msix_enabled_mqdma}
    } else { 
      set_property enabled true ${PARAM_VALUE.pf0_msix_enabled_mqdma}
      set_property value false ${PARAM_VALUE.pf0_msix_enabled_mqdma}
    }
  } else {
    set_property enabled false ${PARAM_VALUE.pf0_msix_enabled_mqdma}
    set_property value false ${PARAM_VALUE.pf0_msix_enabled_mqdma}
  } 
}

proc update_PARAM_VALUE.pf1_msix_enabled_mqdma { PARAM_VALUE.pf1_msix_enabled_mqdma PARAM_VALUE.pf0_msix_enabled_mqdma PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf1_bar0_enabled_mqdma PARAM_VALUE.pf1_bar1_enabled_mqdma PARAM_VALUE.pf1_bar2_enabled_mqdma PARAM_VALUE.pf1_bar3_enabled_mqdma PARAM_VALUE.pf1_bar4_enabled_mqdma PARAM_VALUE.pf1_bar5_enabled_mqdma PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.MSI_X_OPTIONS IPINST } {
  # Procedure called to update pf1_msix_enabled when any of the dependent parameters in the arguments change
  #
  if {[get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 2 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4 } {
    if {([get_property value   ${PARAM_VALUE.pf1_bar0_enabled_mqdma}] == true )
      || ([get_property value   ${PARAM_VALUE.pf1_bar1_enabled_mqdma}] == true )
      || ([get_property value   ${PARAM_VALUE.pf1_bar2_enabled_mqdma}] == true )
      || ([get_property value   ${PARAM_VALUE.pf1_bar3_enabled_mqdma}] == true )
      || ([get_property value   ${PARAM_VALUE.pf1_bar4_enabled_mqdma}] == true )
      || ([get_property value   ${PARAM_VALUE.pf1_bar5_enabled_mqdma}] == true )} {
     if {([get_property value ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true || [get_property value ${PARAM_VALUE.MSI_X_OPTIONS}] != "None")} {
        if {[get_property value  ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true} {
          set_property value [get_property value ${PARAM_VALUE.pf0_msix_enabled_mqdma}] ${PARAM_VALUE.pf1_msix_enabled_mqdma}
          set_property enabled false ${PARAM_VALUE.pf1_msix_enabled_mqdma}
        } else {
          set_property value true ${PARAM_VALUE.pf1_msix_enabled_mqdma}
          set_property enabled true ${PARAM_VALUE.pf1_msix_enabled_mqdma}
        }
      } else { 
        set_property enabled true ${PARAM_VALUE.pf1_msix_enabled_mqdma}
        set_property value false ${PARAM_VALUE.pf1_msix_enabled_mqdma}
      }
    } else {
      set_property enabled false ${PARAM_VALUE.pf1_msix_enabled_mqdma}
      set_property value false ${PARAM_VALUE.pf1_msix_enabled_mqdma}
    }
  } else {
    set_property value false ${PARAM_VALUE.pf1_msix_enabled_mqdma}
  } 
}

proc update_gui_for_PARAM_VALUE.pf1_msix_enabled_mqdma { PARAM_VALUE.pf1_msix_enabled_mqdma IPINST PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf1_bar0_enabled_mqdma PARAM_VALUE.pf1_bar1_enabled_mqdma PARAM_VALUE.pf1_bar2_enabled_mqdma PARAM_VALUE.pf1_bar3_enabled_mqdma PARAM_VALUE.pf1_bar4_enabled_mqdma PARAM_VALUE.pf1_bar5_enabled_mqdma PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.MSI_X_OPTIONS } {
  # Procedure called to update pf1_msix_enabled when any of the dependent parameters in the arguments change
  #
  if {[get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 2 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4 } {
    set_property visible true [ipgui::get_guiparamspec pf1_msix_enabled_mqdma -of $IPINST]
  } else {
    set_property visible false [ipgui::get_guiparamspec pf1_msix_enabled_mqdma -of $IPINST]
  } 
}

proc update_PARAM_VALUE.pf2_msix_enabled_mqdma { PARAM_VALUE.pf2_msix_enabled_mqdma PARAM_VALUE.pf0_msix_enabled_mqdma PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf2_bar0_enabled_mqdma PARAM_VALUE.pf2_bar1_enabled_mqdma PARAM_VALUE.pf2_bar2_enabled_mqdma PARAM_VALUE.pf2_bar3_enabled_mqdma PARAM_VALUE.pf2_bar4_enabled_mqdma PARAM_VALUE.pf2_bar5_enabled_mqdma PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.MSI_X_OPTIONS } {
  # Procedure called to update pf2_msix_enabled when any of the dependent parameters in the arguments change
  if {[get_property value  ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value  ${PARAM_VALUE.tl_pf_enable_reg}] == 4 } {
    if {([get_property value    ${PARAM_VALUE.pf2_bar0_enabled_mqdma}  ] == true )
      || ([get_property value    ${PARAM_VALUE.pf2_bar1_enabled_mqdma}  ] == true )
      || ([get_property value    ${PARAM_VALUE.pf2_bar2_enabled_mqdma}  ] == true )
      || ([get_property value    ${PARAM_VALUE.pf2_bar3_enabled_mqdma}  ] == true )
      || ([get_property value    ${PARAM_VALUE.pf2_bar4_enabled_mqdma}  ] == true )
      || ([get_property value    ${PARAM_VALUE.pf2_bar5_enabled_mqdma}  ] == true )} {
      if {([get_property value  ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true || [get_property value  ${PARAM_VALUE.MSI_X_OPTIONS}] != "None")} {
        if {[get_property value  ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true} {
          set_property value [get_property value ${PARAM_VALUE.pf0_msix_enabled_mqdma}] ${PARAM_VALUE.pf2_msix_enabled_mqdma}
          set_property enabled false ${PARAM_VALUE.pf2_msix_enabled_mqdma}
        } else {
          set_property value true ${PARAM_VALUE.pf2_msix_enabled_mqdma}
          set_property enabled true ${PARAM_VALUE.pf2_msix_enabled_mqdma}
        }
      } else { 
        set_property enabled true ${PARAM_VALUE.pf2_msix_enabled_mqdma}
        set_property value false ${PARAM_VALUE.pf2_msix_enabled_mqdma}
      }
    } else {
      set_property enabled false ${PARAM_VALUE.pf2_msix_enabled_mqdma}
      set_property value false ${PARAM_VALUE.pf2_msix_enabled_mqdma}
    }
  } else {
    set_property value false ${PARAM_VALUE.pf2_msix_enabled_mqdma}
  } 
}

proc update_gui_for_PARAM_VALUE.pf2_msix_enabled_mqdma { PARAM_VALUE.pf2_msix_enabled_mqdma IPINST PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf2_bar0_enabled_mqdma PARAM_VALUE.pf2_bar1_enabled_mqdma PARAM_VALUE.pf2_bar2_enabled_mqdma PARAM_VALUE.pf2_bar3_enabled_mqdma PARAM_VALUE.pf2_bar4_enabled_mqdma PARAM_VALUE.pf2_bar5_enabled_mqdma PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.MSI_X_OPTIONS } {
  # Procedure called to update pf2_msix_enabled when any of the dependent parameters in the arguments change
  #
  if { [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4 } {
    set_property visible true [ipgui::get_guiparamspec pf2_msix_enabled_mqdma -of $IPINST]
  } else {
    set_property visible false [ipgui::get_guiparamspec pf2_msix_enabled_mqdma -of $IPINST]
  }
}

proc update_PARAM_VALUE.pf3_msix_enabled_mqdma { PARAM_VALUE.pf3_msix_enabled_mqdma PARAM_VALUE.pf0_msix_enabled_mqdma PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf3_bar0_enabled_mqdma PARAM_VALUE.pf3_bar1_enabled_mqdma PARAM_VALUE.pf3_bar2_enabled_mqdma PARAM_VALUE.pf3_bar3_enabled_mqdma PARAM_VALUE.pf3_bar4_enabled_mqdma PARAM_VALUE.pf3_bar5_enabled_mqdma PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.MSI_X_OPTIONS } {
  # Procedure called to update pf3_msix_enabled when any of the dependent parameters in the arguments change
  if {[get_property value  ${PARAM_VALUE.tl_pf_enable_reg}] == 4} {
    if {([get_property value    ${PARAM_VALUE.pf3_bar0_enabled_mqdma}  ] == true )
      || ([get_property value    ${PARAM_VALUE.pf3_bar1_enabled_mqdma}  ] == true )
      || ([get_property value    ${PARAM_VALUE.pf3_bar2_enabled_mqdma}  ] == true )
      || ([get_property value    ${PARAM_VALUE.pf3_bar3_enabled_mqdma}  ] == true )
      || ([get_property value    ${PARAM_VALUE.pf3_bar4_enabled_mqdma}  ] == true )
      || ([get_property value    ${PARAM_VALUE.pf3_bar5_enabled_mqdma}  ] == true )} {
      if {([get_property value  ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true || [get_property value  ${PARAM_VALUE.MSI_X_OPTIONS}] != "None")} {
        if {[get_property value  ${PARAM_VALUE.SRIOV_CAP_ENABLE}] == true} {
          set_property value [get_property value ${PARAM_VALUE.pf0_msix_enabled_mqdma}] ${PARAM_VALUE.pf3_msix_enabled_mqdma}
          set_property enabled false ${PARAM_VALUE.pf3_msix_enabled_mqdma}
        } else {
          set_property value true ${PARAM_VALUE.pf3_msix_enabled_mqdma}
          set_property enabled true ${PARAM_VALUE.pf3_msix_enabled_mqdma}
        }
      } else { 
        set_property enabled true ${PARAM_VALUE.pf3_msix_enabled_mqdma}
        set_property value false ${PARAM_VALUE.pf3_msix_enabled_mqdma}
      }
    } else {
      set_property enabled false ${PARAM_VALUE.pf3_msix_enabled_mqdma}
      set_property value false ${PARAM_VALUE.pf3_msix_enabled_mqdma}
    }
  } else {
    set_property value false ${PARAM_VALUE.pf3_msix_enabled_mqdma}
  } 
}

proc update_gui_for_PARAM_VALUE.pf3_msix_enabled_mqdma { PARAM_VALUE.pf3_msix_enabled_mqdma PARAM_VALUE.tl_pf_enable_reg IPINST PARAM_VALUE.pf3_bar0_enabled_mqdma PARAM_VALUE.pf3_bar1_enabled_mqdma PARAM_VALUE.pf3_bar2_enabled_mqdma PARAM_VALUE.pf3_bar3_enabled_mqdma PARAM_VALUE.pf3_bar4_enabled_mqdma PARAM_VALUE.pf3_bar5_enabled_mqdma PARAM_VALUE.SRIOV_CAP_ENABLE PARAM_VALUE.MSI_X_OPTIONS } {
  # Procedure called to update pf3_msix_enabled when any of the dependent parameters in the arguments change
  if {[get_property value  ${PARAM_VALUE.tl_pf_enable_reg}] == 4} {
    set_property visible true [ipgui::get_guiparamspec pf3_msix_enabled_mqdma -of $IPINST]
  } else {
    set_property visible false [ipgui::get_guiparamspec pf3_msix_enabled_mqdma -of $IPINST]
  } 
}

foreach i {0 1 2 3} {
  EvalSubstituting { i } {
    proc update_PARAM_VALUE.PF$i_MSIX_CAP_TABLE_BIR_mqdma { PARAM_VALUE.PF$i_MSIX_CAP_TABLE_BIR_mqdma PARAM_VALUE.PF3_MSIX_CAP_TABLE_BIR_mqdma  PARAM_VALUE.pf$i_msix_enabled_mqdma PARAM_VALUE.pf$i_bar0_enabled_mqdma PARAM_VALUE.pf$i_bar0_type_mqdma PARAM_VALUE.pf$i_bar0_64bit_mqdma PARAM_VALUE.pf$i_bar1_enabled_mqdma PARAM_VALUE.pf$i_bar1_type_mqdma PARAM_VALUE.pf$i_bar1_64bit_mqdma PARAM_VALUE.pf$i_bar2_enabled_mqdma PARAM_VALUE.pf$i_bar2_type_mqdma PARAM_VALUE.pf$i_bar2_64bit_mqdma PARAM_VALUE.pf$i_bar3_enabled_mqdma PARAM_VALUE.pf$i_bar3_type_mqdma PARAM_VALUE.pf$i_bar3_64bit_mqdma PARAM_VALUE.pf$i_bar4_enabled_mqdma PARAM_VALUE.pf$i_bar4_type_mqdma PARAM_VALUE.pf$i_bar4_64bit_mqdma PARAM_VALUE.pf$i_bar5_enabled_mqdma PARAM_VALUE.pf$i_bar5_type_mqdma IPINST} {
      set cap_tabl_bir_handle ${PARAM_VALUE.PF$i_MSIX_CAP_TABLE_BIR_mqdma}
      set_property enabled [get_property value ${PARAM_VALUE.pf$i_msix_enabled_mqdma}] $cap_tabl_bir_handle
      set allowed {}
      if {[get_property value ${PARAM_VALUE.pf$i_bar0_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
        if {[get_property value ${PARAM_VALUE.pf$i_bar0_64bit_mqdma}] == false} {
          lappend allowed "BAR_0"
        } else {
          lappend allowed "BAR_1:0"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf$i_bar1_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar1_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
        if {[get_property value ${PARAM_VALUE.pf$i_bar1_64bit_mqdma}] == false} {
          lappend allowed "BAR_1"
        } else {
          lappend allowed "BAR_2:1"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf$i_bar2_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar2_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
  if {[get_property value ${PARAM_VALUE.pf$i_bar2_64bit_mqdma}] == false} {
    lappend allowed "BAR_2"
  } else {
    lappend allowed "BAR_3:2"
  }
      }
      if {[get_property value ${PARAM_VALUE.pf$i_bar3_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar3_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
        if {[get_property value ${PARAM_VALUE.pf$i_bar3_64bit_mqdma}] == false} {
          lappend allowed "BAR_3"
  } else {
    lappend allowed "BAR_4:3"
  }
      }
      if {[get_property value ${PARAM_VALUE.pf$i_bar4_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar4_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
  if {[get_property value ${PARAM_VALUE.pf$i_bar4_64bit_mqdma}] == false} {
    lappend allowed "BAR_4"
  } else {
    lappend allowed "BAR_5:4"
  }
      }
      if {[get_property value ${PARAM_VALUE.pf$i_bar5_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar5_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
  lappend allowed "BAR_5"
      }
      if {$allowed eq {}} {
  set allowed "BAR_0"
      }
      set_property range [join $allowed ","] $cap_tabl_bir_handle
    }

    proc update_PARAM_VALUE.PF$i_MSIX_CAP_PBA_BIR_mqdma {PARAM_VALUE.PF$i_MSIX_CAP_PBA_BIR_mqdma PARAM_VALUE.pf$i_bar0_enabled_mqdma PARAM_VALUE.pf$i_msix_enabled_mqdma PARAM_VALUE.pf$i_bar0_type_mqdma PARAM_VALUE.pf$i_bar0_64bit_mqdma PARAM_VALUE.pf$i_bar1_enabled_mqdma PARAM_VALUE.pf$i_bar1_type_mqdma PARAM_VALUE.pf$i_bar1_64bit_mqdma PARAM_VALUE.pf$i_bar2_enabled_mqdma PARAM_VALUE.pf$i_bar2_type_mqdma PARAM_VALUE.pf$i_bar2_64bit_mqdma PARAM_VALUE.pf$i_bar3_enabled_mqdma PARAM_VALUE.pf$i_bar3_type_mqdma PARAM_VALUE.pf$i_bar3_64bit_mqdma PARAM_VALUE.pf$i_bar4_enabled_mqdma PARAM_VALUE.pf$i_bar4_type_mqdma PARAM_VALUE.pf$i_bar4_64bit_mqdma PARAM_VALUE.pf$i_bar5_enabled_mqdma PARAM_VALUE.pf$i_bar5_type_mqdma IPINST} {
      set cap_pba_bir_handle ${PARAM_VALUE.PF$i_MSIX_CAP_PBA_BIR_mqdma}
      set_property enabled [get_property value ${PARAM_VALUE.pf$i_msix_enabled_mqdma}] $cap_pba_bir_handle

      set allowed {}
      if {[get_property value ${PARAM_VALUE.pf$i_bar0_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
        if {[get_property value ${PARAM_VALUE.pf$i_bar0_64bit_mqdma}] == false} {
          lappend allowed "BAR_0"
        } else {
          lappend allowed "BAR_1:0"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf$i_bar1_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar1_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
        if {[get_property value ${PARAM_VALUE.pf$i_bar1_64bit_mqdma}] == false} {
          lappend allowed "BAR_1"
        } else {
          lappend allowed "BAR_2:1"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf$i_bar2_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar2_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
        if {[get_property value ${PARAM_VALUE.pf$i_bar2_64bit_mqdma}] == false} {
          lappend allowed "BAR_2"
        } else {
          lappend allowed "BAR_3:2"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf$i_bar3_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar3_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
        if {[get_property value ${PARAM_VALUE.pf$i_bar3_64bit_mqdma}] == false} {
          lappend allowed "BAR_3"
        } else {
          lappend allowed "BAR_4:3"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf$i_bar4_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar4_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
        if {[get_property value ${PARAM_VALUE.pf$i_bar4_64bit_mqdma}] == false} {
          lappend allowed "BAR_4"
        } else {
          lappend allowed "BAR_5:4"
        }
      }
      if {[get_property value ${PARAM_VALUE.pf$i_bar5_enabled_mqdma}] == true && ([get_property value ${PARAM_VALUE.pf$i_bar5_type_mqdma}] eq "AXI_Lite_Master" || [get_property value ${PARAM_VALUE.pf$i_bar0_type_mqdma}] eq "DMA")} {
        lappend allowed "BAR_5"
      }
      if {$allowed eq {}} {
        set allowed "BAR_0"
      }
      set_property range [join $allowed ","] $cap_pba_bir_handle
    }
  } 0
}

proc update_PARAM_VALUE.PF0_MSIX_CAP_TABLE_SIZE_mqdma { PARAM_VALUE.PF0_MSIX_CAP_TABLE_SIZE_mqdma PARAM_VALUE.pf0_msix_enabled_mqdma } {
  # Procedure called to update PF0_MSIX_CAP_TABLE_SIZE when any of the dependent parameters in the arguments change
  #
    if { [get_property value ${PARAM_VALUE.pf0_msix_enabled_mqdma}] == true } {
    set_property enabled true ${PARAM_VALUE.PF0_MSIX_CAP_TABLE_SIZE_mqdma}
    set_property value 001 ${PARAM_VALUE.PF0_MSIX_CAP_TABLE_SIZE_mqdma}
   } else {
    set_property enabled false ${PARAM_VALUE.PF0_MSIX_CAP_TABLE_SIZE_mqdma}
    set_property value 000 ${PARAM_VALUE.PF0_MSIX_CAP_TABLE_SIZE_mqdma}
   } 
}

proc update_PARAM_VALUE.PF1_MSIX_CAP_TABLE_SIZE_mqdma { PARAM_VALUE.PF1_MSIX_CAP_TABLE_SIZE_mqdma PARAM_VALUE.pf1_msix_enabled_mqdma PARAM_VALUE.tl_pf_enable_reg } {
  # Procedure called to update PF1_MSIX_CAP_TABLE_SIZE when any of the dependent parameters in the arguments change
  
  if { [get_property value ${PARAM_VALUE.pf1_msix_enabled_mqdma}  ] == true } {
    set_property enabled true ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_SIZE_mqdma}
    set_property value 001 ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_SIZE_mqdma}
   } else {
    set_property enabled false ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_SIZE_mqdma}
    set_property value 000 ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_SIZE_mqdma}
   }

  if {( [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 2 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4)  && [get_property value ${PARAM_VALUE.pf1_msix_enabled_mqdma}  ] == true} {
    set_property enabled true ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_SIZE_mqdma}
    set_property value 001 ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_SIZE_mqdma}
   } else {
    set_property enabled false ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_SIZE_mqdma}
    set_property value 000 ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_SIZE_mqdma}
   }
 
}

proc update_PARAM_VALUE.PF2_MSIX_CAP_TABLE_SIZE_mqdma { PARAM_VALUE.PF2_MSIX_CAP_TABLE_SIZE_mqdma PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf2_msix_enabled_mqdma } {
  # Procedure called to update PF2_MSIX_CAP_TABLE_SIZE when any of the dependent parameters in the arguments change
    if { ([get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4) && [get_property value ${PARAM_VALUE.pf2_msix_enabled}  ] == true } {
    set_property enabled true ${PARAM_VALUE.PF2_MSIX_CAP_TABLE_SIZE_mqdma}
    set_property value 001 ${PARAM_VALUE.PF2_MSIX_CAP_TABLE_SIZE_mqdma}
   } else {
    set_property enabled false ${PARAM_VALUE.PF2_MSIX_CAP_TABLE_SIZE_mqdma}
    set_property value 000 ${PARAM_VALUE.PF2_MSIX_CAP_TABLE_SIZE_mqdma}
   }
 
}

proc update_PARAM_VALUE.PF3_MSIX_CAP_TABLE_SIZE_mqdma { PARAM_VALUE.PF3_MSIX_CAP_TABLE_SIZE_mqdma PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf3_msix_enabled_mqdma } {
  # Procedure called to update PF3_MSIX_CAP_TABLE_SIZE when any of the dependent parameters in the arguments change
    if { [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4 && [get_property value ${PARAM_VALUE.pf3_msix_enabled}] == true } {
    set_property enabled true ${PARAM_VALUE.PF3_MSIX_CAP_TABLE_SIZE_mqdma}
    set_property value 001 ${PARAM_VALUE.PF3_MSIX_CAP_TABLE_SIZE_mqdma}
   } else {
    set_property enabled false ${PARAM_VALUE.PF3_MSIX_CAP_TABLE_SIZE_mqdma}
    set_property value 000 ${PARAM_VALUE.PF3_MSIX_CAP_TABLE_SIZE_mqdma}
   } 
}

proc update_PARAM_VALUE.PF0_MSIX_CAP_TABLE_OFFSET_mqdma { PARAM_VALUE.PF0_MSIX_CAP_TABLE_OFFSET_mqdma PARAM_VALUE.pf0_msix_enabled_mqdma } {
  # Procedure called to update PF0_MSIX_CAP_TABLE_OFFSET when any of the dependent parameters in the arguments change
    if { [get_property value ${PARAM_VALUE.pf0_msix_enabled_mqdma}] == true } {
    set_property enabled true ${PARAM_VALUE.PF0_MSIX_CAP_TABLE_OFFSET_mqdma}
    set_property value "00000040" ${PARAM_VALUE.PF0_MSIX_CAP_TABLE_OFFSET_mqdma}
   } else {
    set_property enabled false  ${PARAM_VALUE.PF0_MSIX_CAP_TABLE_OFFSET_mqdma}
    set_property value "00000000" ${PARAM_VALUE.PF0_MSIX_CAP_TABLE_OFFSET_mqdma}
   }
 
}

proc update_PARAM_VALUE.PF1_MSIX_CAP_TABLE_OFFSET_mqdma { PARAM_VALUE.PF1_MSIX_CAP_TABLE_OFFSET_mqdma PARAM_VALUE.pf1_msix_enabled_mqdma PARAM_VALUE.tl_pf_enable_reg } {
  # Procedure called to update PF1_MSIX_CAP_TABLE_OFFSET when any of the dependent parameters in the arguments change
  
  if { [get_property value ${PARAM_VALUE.pf1_msix_enabled_mqdma}  ] == true } {
    set_property enabled true ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_OFFSET_mqdma}
    set_property value "00000040" ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_OFFSET_mqdma}
   } else {
    set_property enabled false  ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_OFFSET_mqdma}
    set_property value "00000000" ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_OFFSET_mqdma}
   } 

  if {( [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 2 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4)  && [get_property value ${PARAM_VALUE.pf1_msix_enabled_mqdma}  ] == true} {
    set_property enabled true ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_OFFSET_mqdma}
    set_property value "00000040" ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_OFFSET_mqdma}
  } else {
    set_property enabled false  ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_OFFSET_mqdma}
    set_property value "00000000" ${PARAM_VALUE.PF1_MSIX_CAP_TABLE_OFFSET_mqdma}
  }
}

proc update_PARAM_VALUE.PF2_MSIX_CAP_TABLE_OFFSET_mqdma { PARAM_VALUE.PF2_MSIX_CAP_TABLE_OFFSET_mqdma PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf2_msix_enabled_mqdma } {
  # Procedure called to update PF2_MSIX_CAP_TABLE_OFFSET when any of the dependent parameters in the arguments change
    if { ([get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4) && [get_property value ${PARAM_VALUE.pf2_msix_enabled_mqdma}  ] == true } {
    set_property enabled true ${PARAM_VALUE.PF2_MSIX_CAP_TABLE_OFFSET_mqdma}
    set_property value "00000040" ${PARAM_VALUE.PF2_MSIX_CAP_TABLE_OFFSET_mqdma}
   } else {
    set_property enabled false  ${PARAM_VALUE.PF2_MSIX_CAP_TABLE_OFFSET_mqdma}
    set_property value "00000000" ${PARAM_VALUE.PF2_MSIX_CAP_TABLE_OFFSET_mqdma}
   } 
}


proc update_PARAM_VALUE.PF3_MSIX_CAP_TABLE_OFFSET_mqdma { PARAM_VALUE.PF3_MSIX_CAP_TABLE_OFFSET_mqdma PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf3_msix_enabled_mqdma } {
  # Procedure called to update PF3_MSIX_CAP_TABLE_OFFSET when any of the dependent parameters in the arguments change
  if { [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4 && [get_property value ${PARAM_VALUE.pf3_msix_enabled_mqdma}] == true } {
    set_property enabled true ${PARAM_VALUE.PF3_MSIX_CAP_TABLE_OFFSET_mqdma}
    set_property value "00000040" ${PARAM_VALUE.PF3_MSIX_CAP_TABLE_OFFSET_mqdma}
 } else {
    set_property enabled false  ${PARAM_VALUE.PF3_MSIX_CAP_TABLE_OFFSET_mqdma}
    set_property value "00000000" ${PARAM_VALUE.PF3_MSIX_CAP_TABLE_OFFSET_mqdma}
  } 
}

proc update_PARAM_VALUE.PF0_MSIX_CAP_PBA_OFFSET_mqdma { PARAM_VALUE.PF0_MSIX_CAP_PBA_OFFSET_mqdma PARAM_VALUE.pf0_msix_enabled_mqdma} {
  # Procedure called to update PF0_MSIX_CAP_PBA_OFFSET when any of the dependent parameters in the arguments change
  if { [get_property value ${PARAM_VALUE.pf0_msix_enabled_mqdma}] == true } {
    set_property enabled true ${PARAM_VALUE.PF0_MSIX_CAP_PBA_OFFSET_mqdma}
    set_property value "00000050" ${PARAM_VALUE.PF0_MSIX_CAP_PBA_OFFSET_mqdma}
  } else {
    set_property enabled false ${PARAM_VALUE.PF0_MSIX_CAP_PBA_OFFSET_mqdma}
    set_property value "00000000" ${PARAM_VALUE.PF0_MSIX_CAP_PBA_OFFSET_mqdma}
  } 
}

proc update_PARAM_VALUE.PF1_MSIX_CAP_PBA_OFFSET_mqdma { PARAM_VALUE.PF1_MSIX_CAP_PBA_OFFSET_mqdma PARAM_VALUE.pf1_msix_enabled_mqdma PARAM_VALUE.tl_pf_enable_reg } {
  # Procedure called to update PF1_MSIX_CAP_PBA_OFFSET when any of the dependent parameters in the arguments change
   if { [get_property value ${PARAM_VALUE.pf1_msix_enabled_mqdma}  ] == true } {
    set_property enabled true ${PARAM_VALUE.PF1_MSIX_CAP_PBA_OFFSET_mqdma}
    set_property value "00000050" ${PARAM_VALUE.PF1_MSIX_CAP_PBA_OFFSET_mqdma}
   } else {
    set_property enabled false ${PARAM_VALUE.PF1_MSIX_CAP_PBA_OFFSET_mqdma}
    set_property value "00000000" ${PARAM_VALUE.PF1_MSIX_CAP_PBA_OFFSET_mqdma}
   }

  if {( [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 2 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4)  && [get_property value ${PARAM_VALUE.pf1_msix_enabled_mqdma}  ] == true} {
    set_property enabled true ${PARAM_VALUE.PF1_MSIX_CAP_PBA_OFFSET_mqdma}
    set_property value "00000050" ${PARAM_VALUE.PF1_MSIX_CAP_PBA_OFFSET_mqdma}
  } else {
    set_property enabled false ${PARAM_VALUE.PF1_MSIX_CAP_PBA_OFFSET_mqdma}
    set_property value "00000000" ${PARAM_VALUE.PF1_MSIX_CAP_PBA_OFFSET_mqdma}
  }

}

proc update_PARAM_VALUE.PF2_MSIX_CAP_PBA_OFFSET_mqdma { PARAM_VALUE.PF2_MSIX_CAP_PBA_OFFSET_mqdma PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf2_msix_enabled_mqdma } {
  # Procedure called to update PF2_MSIX_CAP_PBA_OFFSET when any of the dependent parameters in the arguments change
   if { ([get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 3 || [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4) && [get_property value ${PARAM_VALUE.pf2_msix_enabled}  ] == true } {
    set_property enabled true ${PARAM_VALUE.PF2_MSIX_CAP_PBA_OFFSET_mqdma}
    set_property value "00000050" ${PARAM_VALUE.PF2_MSIX_CAP_PBA_OFFSET_mqdma}
   } else {
    set_property enabled false ${PARAM_VALUE.PF2_MSIX_CAP_PBA_OFFSET_mqdma}
    set_property value "00000000" ${PARAM_VALUE.PF2_MSIX_CAP_PBA_OFFSET_mqdma}
   } 
}

proc update_PARAM_VALUE.PF3_MSIX_CAP_PBA_OFFSET_mqdma { PARAM_VALUE.PF3_MSIX_CAP_PBA_OFFSET_mqdma PARAM_VALUE.tl_pf_enable_reg PARAM_VALUE.pf3_msix_enabled_mqdma } {
  # Procedure called to update PF3_MSIX_CAP_PBA_OFFSET when any of the dependent parameters in the arguments change
    if { [get_property value ${PARAM_VALUE.tl_pf_enable_reg}] == 4 && [get_property value ${PARAM_VALUE.pf3_msix_enabled}] == true } {
    set_property enabled true ${PARAM_VALUE.PF3_MSIX_CAP_PBA_OFFSET_mqdma}
    set_property value "00000050" ${PARAM_VALUE.PF3_MSIX_CAP_PBA_OFFSET_mqdma}
   } else {
    set_property enabled false ${PARAM_VALUE.PF3_MSIX_CAP_PBA_OFFSET_mqdma}
    set_property value "00000000" ${PARAM_VALUE.PF3_MSIX_CAP_PBA_OFFSET_mqdma}
   } 
}

#################################################
#### MODEL PARAMETERs used in MQDMA Mode 
#################################################

proc update_MODELPARAM_VALUE.MULTQ_EN {MODELPARAM_VALUE.MULTQ_EN PARAM_VALUE.functional_mode} { 
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode == "MQDMA" } { 
    set val 1
  } else { 
    set val 0
  }
  set_property value $val ${MODELPARAM_VALUE.MULTQ_EN}
}

proc update_MODELPARAM_VALUE.DMA_MM {MODELPARAM_VALUE.DMA_MM PARAM_VALUE.en_axi_mm_mqdma PARAM_VALUE.en_axi_st_mqdma PARAM_VALUE.functional_mode PARAM_VALUE.xdma_axi_intf_mm} { 

  set en_axi_mm [get_property value ${PARAM_VALUE.en_axi_mm_mqdma}]
  set en_axi_st [get_property value ${PARAM_VALUE.en_axi_st_mqdma}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set xdma_axi_intf_mm [get_property value ${PARAM_VALUE.xdma_axi_intf_mm}]

  if {$func_mode == "DMA" && $xdma_axi_intf_mm == "AXI_Memory_Mapped"} { 
    set val 1 
  } elseif {$func_mode == "MQDMA" && (($en_axi_mm == "true" && $en_axi_st == "true") || ($en_axi_mm == "true"))} { 
    set val 1 
  } else { 
    set val 0 
  }
  
  set_property value $val ${MODELPARAM_VALUE.DMA_MM}
}

proc update_MODELPARAM_VALUE.DMA_ST {MODELPARAM_VALUE.DMA_ST PARAM_VALUE.en_axi_mm_mqdma PARAM_VALUE.en_axi_st_mqdma PARAM_VALUE.functional_mode PARAM_VALUE.xdma_axi_intf_mm} { 
  set en_axi_mm [get_property value ${PARAM_VALUE.en_axi_mm_mqdma}]
  set en_axi_st [get_property value ${PARAM_VALUE.en_axi_st_mqdma}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set xdma_axi_intf_mm [get_property value ${PARAM_VALUE.xdma_axi_intf_mm}]

  if {$func_mode == "DMA" && $xdma_axi_intf_mm == "AXI_Stream"} { 
    set val 1 
  } elseif {$func_mode == "MQDMA" && (($en_axi_mm == "true" && $en_axi_st == "true") || ($en_axi_st == "true"))} { 
    set val 1 
  } else { 
    set val 0 
  }
  
  set_property value $val ${MODELPARAM_VALUE.DMA_ST}
} 

proc update_MODELPARAM_VALUE.C_PCIE_PFS_SUPPORTED {MODELPARAM_VALUE.C_PCIE_PFS_SUPPORTED PARAM_VALUE.functional_mode} { 
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode == "MQDMA"} { 
    set val 2
  } else {
    set val 0
  }

  set_property value $val ${MODELPARAM_VALUE.C_PCIE_PFS_SUPPORTED}

}


proc update_MODELPARAM_VALUE.C_SRIOV_EN {MODELPARAM_VALUE.C_SRIOV_EN PARAM_VALUE.functional_mode} { 
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode == "MQDMA"} { 
    set val 1
  } else {
    set val 0
  }

  set_property value $val ${MODELPARAM_VALUE.C_SRIOV_EN}
}

proc update_MODELPARAM_VALUE.BARLITE_EXT_PF0 {MODELPARAM_VALUE.BARLITE_EXT_PF0 PARAM_VALUE.pf0_bar0_type_mqdma PARAM_VALUE.pf0_bar1_type_mqdma PARAM_VALUE.pf0_bar2_type_mqdma PARAM_VALUE.pf0_bar3_type_mqdma PARAM_VALUE.pf0_bar4_type_mqdma PARAM_VALUE.pf0_bar5_type_mqdma PARAM_VALUE.functional_mode PARAM_VALUE.axilite_master_en } { 
  set bar0_type [get_property value ${PARAM_VALUE.pf0_bar0_type_mqdma}]
  set bar1_type [get_property value ${PARAM_VALUE.pf0_bar1_type_mqdma}]
  set bar2_type [get_property value ${PARAM_VALUE.pf0_bar2_type_mqdma}]
  set bar3_type [get_property value ${PARAM_VALUE.pf0_bar3_type_mqdma}]
  set bar4_type [get_property value ${PARAM_VALUE.pf0_bar4_type_mqdma}]
  set bar5_type [get_property value ${PARAM_VALUE.pf0_bar5_type_mqdma}]

  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set axilite_master_en [get_property value ${PARAM_VALUE.axilite_master_en}]
  
  if {($func_mode == "DMA" || $func_mode == "DMA_and_Bridge") && $axilite_master_en} {
    set_property value 0x01 ${MODELPARAM_VALUE.BARLITE_EXT_PF0}
  } elseif {$func_mode == "MQDMA" && $bar0_type == "AXI_Lite_Master"} {
    set_property value 0x01 ${MODELPARAM_VALUE.BARLITE_EXT_PF0}
  } elseif {$func_mode == "MQDMA" && $bar1_type == "AXI_Lite_Master" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.BARLITE_EXT_PF0}
  } elseif {$func_mode == "MQDMA" && $bar2_type == "AXI_Lite_Master" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.BARLITE_EXT_PF0}
  } elseif {$func_mode == "MQDMA" && $bar3_type == "AXI_Lite_Master" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.BARLITE_EXT_PF0}
  } elseif {$func_mode == "MQDMA" && $bar4_type == "AXI_Lite_Master" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.BARLITE_EXT_PF0}
  } elseif {$func_mode == "MQDMA" && $bar5_type == "AXI_Lite_Master" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.BARLITE_EXT_PF0}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_EXT_PF0}
  }
}

proc update_MODELPARAM_VALUE.BARLITE_EXT_PF1 {MODELPARAM_VALUE.BARLITE_EXT_PF1 PARAM_VALUE.pf1_bar0_type_mqdma PARAM_VALUE.pf1_bar1_type_mqdma PARAM_VALUE.pf1_bar2_type_mqdma PARAM_VALUE.pf1_bar3_type_mqdma PARAM_VALUE.pf1_bar4_type_mqdma PARAM_VALUE.pf1_bar5_type_mqdma PARAM_VALUE.functional_mode PARAM_VALUE.axilite_master_en PARAM_VALUE.mult_pf_des} {
  set bar0_type [get_property value ${PARAM_VALUE.pf1_bar0_type_mqdma}]
  set bar1_type [get_property value ${PARAM_VALUE.pf1_bar1_type_mqdma}]
  set bar2_type [get_property value ${PARAM_VALUE.pf1_bar2_type_mqdma}]
  set bar3_type [get_property value ${PARAM_VALUE.pf1_bar3_type_mqdma}]
  set bar4_type [get_property value ${PARAM_VALUE.pf1_bar4_type_mqdma}]
  set bar5_type [get_property value ${PARAM_VALUE.pf1_bar5_type_mqdma}]

  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set mult_pf_des_val [get_property value ${PARAM_VALUE.mult_pf_des}]

  if {($func_mode == "DMA" && $mult_pf_des_val) || ($func_mode == "DMA_and_Bridge")} {
    set_property value 0x3F ${MODELPARAM_VALUE.BARLITE_EXT_PF1}
  } elseif {$func_mode == "MQDMA" && $bar0_type == "AXI_Lite_Master"} {
    set_property value 0x01 ${MODELPARAM_VALUE.BARLITE_EXT_PF1}
  } elseif {$func_mode == "MQDMA" && $bar1_type == "AXI_Lite_Master" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.BARLITE_EXT_PF1}
  } elseif {$func_mode == "MQDMA" && $bar2_type == "AXI_Lite_Master" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.BARLITE_EXT_PF1}
  } elseif {$func_mode == "MQDMA" && $bar3_type == "AXI_Lite_Master" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.BARLITE_EXT_PF1}
  } elseif {$func_mode == "MQDMA" && $bar4_type == "AXI_Lite_Master" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.BARLITE_EXT_PF1}
  } elseif {$func_mode == "MQDMA" && $bar5_type == "AXI_Lite_Master" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.BARLITE_EXT_PF1}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_EXT_PF1}
  }
}

proc update_MODELPARAM_VALUE.BARLITE_EXT_PF2 {MODELPARAM_VALUE.BARLITE_EXT_PF2 PARAM_VALUE.pf2_bar0_type_mqdma PARAM_VALUE.pf2_bar1_type_mqdma PARAM_VALUE.pf2_bar2_type_mqdma PARAM_VALUE.pf2_bar3_type_mqdma PARAM_VALUE.pf2_bar4_type_mqdma PARAM_VALUE.pf2_bar5_type_mqdma PARAM_VALUE.functional_mode PARAM_VALUE.axilite_master_en } { 
  set bar0_type [get_property value ${PARAM_VALUE.pf2_bar0_type_mqdma}]
  set bar1_type [get_property value ${PARAM_VALUE.pf2_bar1_type_mqdma}]
  set bar2_type [get_property value ${PARAM_VALUE.pf2_bar2_type_mqdma}]
  set bar3_type [get_property value ${PARAM_VALUE.pf2_bar3_type_mqdma}]
  set bar4_type [get_property value ${PARAM_VALUE.pf2_bar4_type_mqdma}]
  set bar5_type [get_property value ${PARAM_VALUE.pf2_bar5_type_mqdma}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode == "MQDMA" && $bar0_type == "AXI_Lite_Master"} {
    set_property value 0x01 ${MODELPARAM_VALUE.BARLITE_EXT_PF2}
  } elseif {$func_mode == "MQDMA" && $bar1_type == "AXI_Lite_Master" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.BARLITE_EXT_PF2}
  } elseif {$func_mode == "MQDMA" && $bar2_type == "AXI_Lite_Master" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.BARLITE_EXT_PF2}
  } elseif {$func_mode == "MQDMA" && $bar3_type == "AXI_Lite_Master" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.BARLITE_EXT_PF2}
  } elseif {$func_mode == "MQDMA" && $bar4_type == "AXI_Lite_Master" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.BARLITE_EXT_PF2}
  } elseif {$func_mode == "MQDMA" && $bar5_type == "AXI_Lite_Master" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.BARLITE_EXT_PF2}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_EXT_PF2}
  }
}

proc update_MODELPARAM_VALUE.BARLITE_EXT_PF3 {MODELPARAM_VALUE.BARLITE_EXT_PF3 PARAM_VALUE.pf3_bar0_type_mqdma PARAM_VALUE.pf3_bar1_type_mqdma PARAM_VALUE.pf3_bar2_type_mqdma PARAM_VALUE.pf3_bar3_type_mqdma PARAM_VALUE.pf3_bar4_type_mqdma PARAM_VALUE.pf3_bar5_type_mqdma PARAM_VALUE.functional_mode PARAM_VALUE.axilite_master_en } { 
  set bar0_type [get_property value ${PARAM_VALUE.pf3_bar0_type_mqdma}]
  set bar1_type [get_property value ${PARAM_VALUE.pf3_bar1_type_mqdma}]
  set bar2_type [get_property value ${PARAM_VALUE.pf3_bar2_type_mqdma}]
  set bar3_type [get_property value ${PARAM_VALUE.pf3_bar3_type_mqdma}]
  set bar4_type [get_property value ${PARAM_VALUE.pf3_bar4_type_mqdma}]
  set bar5_type [get_property value ${PARAM_VALUE.pf3_bar5_type_mqdma}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode == "MQDMA" && $bar0_type == "AXI_Lite_Master"} {
    set_property value 0x01 ${MODELPARAM_VALUE.BARLITE_EXT_PF3}
  } elseif {$func_mode == "MQDMA" && $bar1_type == "AXI_Lite_Master" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.BARLITE_EXT_PF3}
  } elseif {$func_mode == "MQDMA" && $bar2_type == "AXI_Lite_Master" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.BARLITE_EXT_PF3}
  } elseif {$func_mode == "MQDMA" && $bar3_type == "AXI_Lite_Master" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.BARLITE_EXT_PF3}
  } elseif {$func_mode == "MQDMA" && $bar4_type == "AXI_Lite_Master" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.BARLITE_EXT_PF3}
  } elseif {$func_mode == "MQDMA" && $bar5_type == "AXI_Lite_Master" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.BARLITE_EXT_PF3}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_EXT_PF3}
  }
}

proc update_MODELPARAM_VALUE.BARLITE_INT_PF0 {MODELPARAM_VALUE.BARLITE_INT_PF0 PARAM_VALUE.pf0_bar0_type_mqdma PARAM_VALUE.pf0_bar1_type_mqdma PARAM_VALUE.pf0_bar2_type_mqdma PARAM_VALUE.pf0_bar3_type_mqdma PARAM_VALUE.pf0_bar4_type_mqdma PARAM_VALUE.pf0_bar5_type_mqdma PARAM_VALUE.functional_mode PARAM_VALUE.axilite_master_en PARAM_VALUE.xdma_en PARAM_VALUE.xdma_pcie_64bit_en PARAM_VALUE.axil_master_64bit_en} { 

  set bar0_type [get_property value ${PARAM_VALUE.pf0_bar0_type_mqdma}]
  set bar1_type [get_property value ${PARAM_VALUE.pf0_bar1_type_mqdma}]
  set bar2_type [get_property value ${PARAM_VALUE.pf0_bar2_type_mqdma}]
  set bar3_type [get_property value ${PARAM_VALUE.pf0_bar3_type_mqdma}]
  set bar4_type [get_property value ${PARAM_VALUE.pf0_bar4_type_mqdma}]
  set bar5_type [get_property value ${PARAM_VALUE.pf0_bar5_type_mqdma}]

  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  set xdma_en [get_property value ${PARAM_VALUE.xdma_en}]
  set axilite_master_en [get_property value ${PARAM_VALUE.axilite_master_en}]
  set xdma_64bit_en [get_property value ${PARAM_VALUE.xdma_pcie_64bit_en}]
  set axil_64bit_en [get_property value ${PARAM_VALUE.axil_master_64bit_en}]

  if {($func_mode == "DMA" || $func_mode == "DMA_and_Bridge")} {
    if {$axilite_master_en == "false"} { 
      set_property value 0x01 ${MODELPARAM_VALUE.BARLITE_INT_PF0}
    } elseif {($xdma_64bit_en || $axil_64bit_en)} { 
      set_property value 0x04 ${MODELPARAM_VALUE.BARLITE_INT_PF0}
    } else {
      set_property value 0x02 ${MODELPARAM_VALUE.BARLITE_INT_PF0}
    }
  } elseif { $func_mode == "MQDMA"} {
    if {$bar0_type == "DMA"} {
      set_property value 0x01 ${MODELPARAM_VALUE.BARLITE_INT_PF0}
    } elseif {$bar1_type == "DMA" } { 
      set_property value 0x02 ${MODELPARAM_VALUE.BARLITE_INT_PF0}
    } elseif {$bar2_type == "DMA" } { 
      set_property value 0x04 ${MODELPARAM_VALUE.BARLITE_INT_PF0}
    } elseif {$bar3_type == "DMA" } { 
      set_property value 0x08 ${MODELPARAM_VALUE.BARLITE_INT_PF0}
    } elseif {$bar4_type == "DMA" } { 
      set_property value 0x10 ${MODELPARAM_VALUE.BARLITE_INT_PF0}
    } elseif {$bar5_type == "DMA" } { 
      set_property value 0x20 ${MODELPARAM_VALUE.BARLITE_INT_PF0}
    } else {
      set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_INT_PF0}
    }
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_INT_PF0}
  }
}

proc update_MODELPARAM_VALUE.BARLITE_INT_PF1 {MODELPARAM_VALUE.BARLITE_INT_PF1 PARAM_VALUE.pf1_bar0_type_mqdma PARAM_VALUE.pf1_bar1_type_mqdma PARAM_VALUE.pf1_bar2_type_mqdma PARAM_VALUE.pf1_bar3_type_mqdma PARAM_VALUE.pf1_bar4_type_mqdma PARAM_VALUE.pf1_bar5_type_mqdma PARAM_VALUE.functional_mode} { 

  set bar0_type [get_property value ${PARAM_VALUE.pf1_bar0_type_mqdma}]
  set bar1_type [get_property value ${PARAM_VALUE.pf1_bar1_type_mqdma}]
  set bar2_type [get_property value ${PARAM_VALUE.pf1_bar2_type_mqdma}]
  set bar3_type [get_property value ${PARAM_VALUE.pf1_bar3_type_mqdma}]
  set bar4_type [get_property value ${PARAM_VALUE.pf1_bar4_type_mqdma}]
  set bar5_type [get_property value ${PARAM_VALUE.pf1_bar5_type_mqdma}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode != "MQDMA"} {
    set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_INT_PF1}
  } elseif {$bar0_type == "DMA"} {
    set_property value 0x01 ${MODELPARAM_VALUE.BARLITE_INT_PF1}
  } elseif {$bar1_type == "DMA" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.BARLITE_INT_PF1}
  } elseif {$bar2_type == "DMA" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.BARLITE_INT_PF1}
  } elseif {$bar3_type == "DMA" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.BARLITE_INT_PF1}
  } elseif {$bar4_type == "DMA" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.BARLITE_INT_PF1}
  } elseif {$bar5_type == "DMA" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.BARLITE_INT_PF1}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_INT_PF1}
  }
}

proc update_MODELPARAM_VALUE.BARLITE_INT_PF2 {MODELPARAM_VALUE.BARLITE_INT_PF2 PARAM_VALUE.pf2_bar0_type_mqdma PARAM_VALUE.pf2_bar1_type_mqdma PARAM_VALUE.pf2_bar2_type_mqdma PARAM_VALUE.pf2_bar3_type_mqdma PARAM_VALUE.pf2_bar4_type_mqdma PARAM_VALUE.pf2_bar5_type_mqdma PARAM_VALUE.functional_mode} { 

  set bar0_type [get_property value ${PARAM_VALUE.pf2_bar0_type_mqdma}]
  set bar1_type [get_property value ${PARAM_VALUE.pf2_bar1_type_mqdma}]
  set bar2_type [get_property value ${PARAM_VALUE.pf2_bar2_type_mqdma}]
  set bar3_type [get_property value ${PARAM_VALUE.pf2_bar3_type_mqdma}]
  set bar4_type [get_property value ${PARAM_VALUE.pf2_bar4_type_mqdma}]
  set bar5_type [get_property value ${PARAM_VALUE.pf2_bar5_type_mqdma}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode != "MQDMA"} {
    set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_INT_PF2}
  } elseif {$bar0_type == "DMA"} {
    set_property value 0x01 ${MODELPARAM_VALUE.BARLITE_INT_PF2}
  } elseif {$bar1_type == "DMA" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.BARLITE_INT_PF2}
  } elseif {$bar2_type == "DMA" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.BARLITE_INT_PF2}
  } elseif {$bar3_type == "DMA" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.BARLITE_INT_PF2}
  } elseif {$bar4_type == "DMA" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.BARLITE_INT_PF2}
  } elseif {$bar5_type == "DMA" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.BARLITE_INT_PF2}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_INT_PF2}
  }
}

proc update_MODELPARAM_VALUE.BARLITE_INT_PF3 {MODELPARAM_VALUE.BARLITE_INT_PF3 PARAM_VALUE.pf3_bar0_type_mqdma PARAM_VALUE.pf3_bar1_type_mqdma PARAM_VALUE.pf3_bar2_type_mqdma PARAM_VALUE.pf3_bar3_type_mqdma PARAM_VALUE.pf3_bar4_type_mqdma PARAM_VALUE.pf3_bar5_type_mqdma PARAM_VALUE.functional_mode} { 

  set bar0_type [get_property value ${PARAM_VALUE.pf3_bar0_type_mqdma}]
  set bar1_type [get_property value ${PARAM_VALUE.pf3_bar1_type_mqdma}]
  set bar2_type [get_property value ${PARAM_VALUE.pf3_bar2_type_mqdma}]
  set bar3_type [get_property value ${PARAM_VALUE.pf3_bar3_type_mqdma}]
  set bar4_type [get_property value ${PARAM_VALUE.pf3_bar4_type_mqdma}]
  set bar5_type [get_property value ${PARAM_VALUE.pf3_bar5_type_mqdma}]
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode != "MQDMA"} {
    set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_INT_PF3}
  } elseif {$bar0_type == "DMA"} {
    set_property value 0x01 ${MODELPARAM_VALUE.BARLITE_INT_PF3}
  } elseif {$bar1_type == "DMA" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.BARLITE_INT_PF3}
  } elseif {$bar2_type == "DMA" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.BARLITE_INT_PF3}
  } elseif {$bar3_type == "DMA" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.BARLITE_INT_PF3}
  } elseif {$bar4_type == "DMA" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.BARLITE_INT_PF3}
  } elseif {$bar5_type == "DMA" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.BARLITE_INT_PF3}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.BARLITE_INT_PF3}
  }
}

proc update_MODELPARAM_VALUE.NUM_VFS_PF0 {MODELPARAM_VALUE.NUM_VFS_PF0 PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF} { 
  set num_vfs [get_property value ${PARAM_VALUE.PF0_SRIOV_CAP_INITIAL_VF}]
  set_property value $num_vfs ${MODELPARAM_VALUE.NUM_VFS_PF0} 
}

proc update_MODELPARAM_VALUE.NUM_VFS_PF1 {MODELPARAM_VALUE.NUM_VFS_PF1 PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF} { 
  set num_vfs [get_property value ${PARAM_VALUE.PF1_SRIOV_CAP_INITIAL_VF}]
  set_property value $num_vfs ${MODELPARAM_VALUE.NUM_VFS_PF1} 
}

proc update_MODELPARAM_VALUE.NUM_VFS_PF2 {MODELPARAM_VALUE.NUM_VFS_PF2 PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF} { 
  set num_vfs [get_property value ${PARAM_VALUE.PF2_SRIOV_CAP_INITIAL_VF}]
  set_property value $num_vfs ${MODELPARAM_VALUE.NUM_VFS_PF2} 
}

proc update_MODELPARAM_VALUE.NUM_VFS_PF3 {MODELPARAM_VALUE.NUM_VFS_PF3 PARAM_VALUE.PF3_SRIOV_CAP_INITIAL_VF} { 
  set num_vfs [get_property value ${PARAM_VALUE.PF3_SRIOV_CAP_INITIAL_VF}]
  set_property value $num_vfs ${MODELPARAM_VALUE.NUM_VFS_PF3} 
}


proc update_MODELPARAM_VALUE.FIRSTVF_OFFSET_PF0 {MODELPARAM_VALUE.FIRSTVF_OFFSET_PF0 PARAM_VALUE.PF0_SRIOV_FIRST_VF_OFFSET} { 
  set vf_offset [get_property value ${PARAM_VALUE.PF0_SRIOV_FIRST_VF_OFFSET}]
  set_property value $vf_offset ${MODELPARAM_VALUE.FIRSTVF_OFFSET_PF0}
}

proc update_MODELPARAM_VALUE.FIRSTVF_OFFSET_PF1 {MODELPARAM_VALUE.FIRSTVF_OFFSET_PF1 PARAM_VALUE.PF1_SRIOV_FIRST_VF_OFFSET} { 
  set vf_offset [get_property value ${PARAM_VALUE.PF1_SRIOV_FIRST_VF_OFFSET}]
  set_property value $vf_offset ${MODELPARAM_VALUE.FIRSTVF_OFFSET_PF1}
}

proc update_MODELPARAM_VALUE.FIRSTVF_OFFSET_PF2 {MODELPARAM_VALUE.FIRSTVF_OFFSET_PF2 PARAM_VALUE.PF2_SRIOV_FIRST_VF_OFFSET} { 
  set vf_offset [get_property value ${PARAM_VALUE.PF2_SRIOV_FIRST_VF_OFFSET}]
  set_property value $vf_offset ${MODELPARAM_VALUE.FIRSTVF_OFFSET_PF2}
}

proc update_MODELPARAM_VALUE.FIRSTVF_OFFSET_PF3 {MODELPARAM_VALUE.FIRSTVF_OFFSET_PF3 PARAM_VALUE.PF3_SRIOV_FIRST_VF_OFFSET} { 
  set vf_offset [get_property value ${PARAM_VALUE.PF3_SRIOV_FIRST_VF_OFFSET}]
  set_property value $vf_offset ${MODELPARAM_VALUE.FIRSTVF_OFFSET_PF3}
}

proc update_MODELPARAM_VALUE.VF_BARLITE_EXT_PF0 {MODELPARAM_VALUE.VF_BARLITE_EXT_PF0 PARAM_VALUE.pf0_sriov_bar0_type PARAM_VALUE.pf0_sriov_bar1_type PARAM_VALUE.pf0_sriov_bar2_type PARAM_VALUE.pf0_sriov_bar3_type PARAM_VALUE.pf0_sriov_bar4_type PARAM_VALUE.pf0_sriov_bar5_type} { 
  set bar0_type [get_property value ${PARAM_VALUE.pf0_sriov_bar0_type}]
  set bar1_type [get_property value ${PARAM_VALUE.pf0_sriov_bar1_type}]
  set bar2_type [get_property value ${PARAM_VALUE.pf0_sriov_bar2_type}]
  set bar3_type [get_property value ${PARAM_VALUE.pf0_sriov_bar3_type}]
  set bar4_type [get_property value ${PARAM_VALUE.pf0_sriov_bar4_type}]
  set bar5_type [get_property value ${PARAM_VALUE.pf0_sriov_bar5_type}]

  if {$bar0_type == "AXI_Lite_Master"} {
    set_property value 0x01 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF0}
  } elseif {$bar1_type == "AXI_Lite_Master" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF0}
  } elseif {$bar2_type == "AXI_Lite_Master" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF0}
  } elseif {$bar3_type == "AXI_Lite_Master" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF0}
  } elseif {$bar4_type == "AXI_Lite_Master" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF0}
  } elseif {$bar5_type == "AXI_Lite_Master" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF0}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF0}
  }
}

proc update_MODELPARAM_VALUE.VF_BARLITE_EXT_PF1 {MODELPARAM_VALUE.VF_BARLITE_EXT_PF1 PARAM_VALUE.pf1_sriov_bar0_type PARAM_VALUE.pf1_sriov_bar1_type PARAM_VALUE.pf1_sriov_bar2_type PARAM_VALUE.pf1_sriov_bar3_type PARAM_VALUE.pf1_sriov_bar4_type PARAM_VALUE.pf1_sriov_bar5_type} { 
  set bar0_type [get_property value ${PARAM_VALUE.pf1_sriov_bar0_type}]
  set bar1_type [get_property value ${PARAM_VALUE.pf1_sriov_bar1_type}]
  set bar2_type [get_property value ${PARAM_VALUE.pf1_sriov_bar2_type}]
  set bar3_type [get_property value ${PARAM_VALUE.pf1_sriov_bar3_type}]
  set bar4_type [get_property value ${PARAM_VALUE.pf1_sriov_bar4_type}]
  set bar5_type [get_property value ${PARAM_VALUE.pf1_sriov_bar5_type}]

  if {$bar0_type == "AXI_Lite_Master"} {
    set_property value 0x01 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF1}
  } elseif {$bar1_type == "AXI_Lite_Master" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF1}
  } elseif {$bar2_type == "AXI_Lite_Master" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF1}
  } elseif {$bar3_type == "AXI_Lite_Master" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF1}
  } elseif {$bar4_type == "AXI_Lite_Master" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF1}
  } elseif {$bar5_type == "AXI_Lite_Master" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF1}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF1}
  }
}

proc update_MODELPARAM_VALUE.VF_BARLITE_EXT_PF2 {MODELPARAM_VALUE.VF_BARLITE_EXT_PF2 PARAM_VALUE.pf2_sriov_bar0_type PARAM_VALUE.pf2_sriov_bar1_type PARAM_VALUE.pf2_sriov_bar2_type PARAM_VALUE.pf2_sriov_bar3_type PARAM_VALUE.pf2_sriov_bar4_type PARAM_VALUE.pf2_sriov_bar5_type} { 
  set bar0_type [get_property value ${PARAM_VALUE.pf2_sriov_bar0_type}]
  set bar1_type [get_property value ${PARAM_VALUE.pf2_sriov_bar1_type}]
  set bar2_type [get_property value ${PARAM_VALUE.pf2_sriov_bar2_type}]
  set bar3_type [get_property value ${PARAM_VALUE.pf2_sriov_bar3_type}]
  set bar4_type [get_property value ${PARAM_VALUE.pf2_sriov_bar4_type}]
  set bar5_type [get_property value ${PARAM_VALUE.pf2_sriov_bar5_type}]

  if {$bar0_type == "AXI_Lite_Master"} {
    set_property value 0x01 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF2}
  } elseif {$bar1_type == "AXI_Lite_Master" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF2}
  } elseif {$bar2_type == "AXI_Lite_Master" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF2}
  } elseif {$bar3_type == "AXI_Lite_Master" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF2}
  } elseif {$bar4_type == "AXI_Lite_Master" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF2}
  } elseif {$bar5_type == "AXI_Lite_Master" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF2}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF2}
  }
}

proc update_MODELPARAM_VALUE.VF_BARLITE_EXT_PF3 {MODELPARAM_VALUE.VF_BARLITE_EXT_PF3 PARAM_VALUE.pf3_sriov_bar0_type PARAM_VALUE.pf3_sriov_bar1_type PARAM_VALUE.pf3_sriov_bar2_type PARAM_VALUE.pf3_sriov_bar3_type PARAM_VALUE.pf3_sriov_bar4_type PARAM_VALUE.pf3_sriov_bar5_type} { 
  set bar0_type [get_property value ${PARAM_VALUE.pf3_sriov_bar0_type}]
  set bar1_type [get_property value ${PARAM_VALUE.pf3_sriov_bar1_type}]
  set bar2_type [get_property value ${PARAM_VALUE.pf3_sriov_bar2_type}]
  set bar3_type [get_property value ${PARAM_VALUE.pf3_sriov_bar3_type}]
  set bar4_type [get_property value ${PARAM_VALUE.pf3_sriov_bar4_type}]
  set bar5_type [get_property value ${PARAM_VALUE.pf3_sriov_bar5_type}]

  if {$bar0_type == "AXI_Lite_Master"} {
    set_property value 0x01 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF3}
  } elseif {$bar1_type == "AXI_Lite_Master" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF3}
  } elseif {$bar2_type == "AXI_Lite_Master" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF3}
  } elseif {$bar3_type == "AXI_Lite_Master" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF3}
  } elseif {$bar4_type == "AXI_Lite_Master" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF3}
  } elseif {$bar5_type == "AXI_Lite_Master" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF3}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.VF_BARLITE_EXT_PF3}
  }
}

proc update_MODELPARAM_VALUE.VF_BARLITE_INT_PF0 {MODELPARAM_VALUE.VF_BARLITE_INT_PF0 PARAM_VALUE.pf0_sriov_bar0_type PARAM_VALUE.pf0_sriov_bar1_type PARAM_VALUE.pf0_sriov_bar2_type PARAM_VALUE.pf0_sriov_bar3_type PARAM_VALUE.pf0_sriov_bar4_type PARAM_VALUE.pf0_sriov_bar5_type} { 

  set bar0_type [get_property value ${PARAM_VALUE.pf0_sriov_bar0_type}]
  set bar1_type [get_property value ${PARAM_VALUE.pf0_sriov_bar1_type}]
  set bar2_type [get_property value ${PARAM_VALUE.pf0_sriov_bar2_type}]
  set bar3_type [get_property value ${PARAM_VALUE.pf0_sriov_bar3_type}]
  set bar4_type [get_property value ${PARAM_VALUE.pf0_sriov_bar4_type}]
  set bar5_type [get_property value ${PARAM_VALUE.pf0_sriov_bar5_type}]

  if {$bar0_type == "DMA"} {
    set_property value 0x01 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF0}
  } elseif {$bar1_type == "DMA" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF0}
  } elseif {$bar2_type == "DMA" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF0}
  } elseif {$bar3_type == "DMA" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF0}
  } elseif {$bar4_type == "DMA" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF0}
  } elseif {$bar5_type == "DMA" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF0}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF0}
  }
}

proc update_MODELPARAM_VALUE.VF_BARLITE_INT_PF1 {MODELPARAM_VALUE.VF_BARLITE_INT_PF1 PARAM_VALUE.pf1_sriov_bar0_type PARAM_VALUE.pf1_sriov_bar1_type PARAM_VALUE.pf1_sriov_bar2_type PARAM_VALUE.pf1_sriov_bar3_type PARAM_VALUE.pf1_sriov_bar4_type PARAM_VALUE.pf1_sriov_bar5_type} { 

  set bar0_type [get_property value ${PARAM_VALUE.pf1_sriov_bar0_type}]
  set bar1_type [get_property value ${PARAM_VALUE.pf1_sriov_bar1_type}]
  set bar2_type [get_property value ${PARAM_VALUE.pf1_sriov_bar2_type}]
  set bar3_type [get_property value ${PARAM_VALUE.pf1_sriov_bar3_type}]
  set bar4_type [get_property value ${PARAM_VALUE.pf1_sriov_bar4_type}]
  set bar5_type [get_property value ${PARAM_VALUE.pf1_sriov_bar5_type}]

  if {$bar0_type == "DMA"} {
    set_property value 0x01 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF1}
  } elseif {$bar1_type == "DMA" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF1}
  } elseif {$bar2_type == "DMA" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF1}
  } elseif {$bar3_type == "DMA" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF1}
  } elseif {$bar4_type == "DMA" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF1}
  } elseif {$bar5_type == "DMA" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF1}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF1}
  }
}

proc update_MODELPARAM_VALUE.VF_BARLITE_INT_PF2 {MODELPARAM_VALUE.VF_BARLITE_INT_PF2 PARAM_VALUE.pf2_sriov_bar0_type PARAM_VALUE.pf2_sriov_bar1_type PARAM_VALUE.pf2_sriov_bar2_type PARAM_VALUE.pf2_sriov_bar3_type PARAM_VALUE.pf2_sriov_bar4_type PARAM_VALUE.pf2_sriov_bar5_type} { 

  set bar0_type [get_property value ${PARAM_VALUE.pf2_sriov_bar0_type}]
  set bar1_type [get_property value ${PARAM_VALUE.pf2_sriov_bar1_type}]
  set bar2_type [get_property value ${PARAM_VALUE.pf2_sriov_bar2_type}]
  set bar3_type [get_property value ${PARAM_VALUE.pf2_sriov_bar3_type}]
  set bar4_type [get_property value ${PARAM_VALUE.pf2_sriov_bar4_type}]
  set bar5_type [get_property value ${PARAM_VALUE.pf2_sriov_bar5_type}]

  if {$bar0_type == "DMA"} {
    set_property value 0x01 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF2}
  } elseif {$bar1_type == "DMA" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF2}
  } elseif {$bar2_type == "DMA" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF2}
  } elseif {$bar3_type == "DMA" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF2}
  } elseif {$bar4_type == "DMA" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF2}
  } elseif {$bar5_type == "DMA" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF2}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF2}
  }
}

proc update_MODELPARAM_VALUE.VF_BARLITE_INT_PF3 {MODELPARAM_VALUE.VF_BARLITE_INT_PF3 PARAM_VALUE.pf3_sriov_bar0_type PARAM_VALUE.pf3_sriov_bar1_type PARAM_VALUE.pf3_sriov_bar2_type PARAM_VALUE.pf3_sriov_bar3_type PARAM_VALUE.pf3_sriov_bar4_type PARAM_VALUE.pf3_sriov_bar5_type} { 

  set bar0_type [get_property value ${PARAM_VALUE.pf3_sriov_bar0_type}]
  set bar1_type [get_property value ${PARAM_VALUE.pf3_sriov_bar1_type}]
  set bar2_type [get_property value ${PARAM_VALUE.pf3_sriov_bar2_type}]
  set bar3_type [get_property value ${PARAM_VALUE.pf3_sriov_bar3_type}]
  set bar4_type [get_property value ${PARAM_VALUE.pf3_sriov_bar4_type}]
  set bar5_type [get_property value ${PARAM_VALUE.pf3_sriov_bar5_type}]

  if {$bar0_type == "DMA"} {
    set_property value 0x01 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF3}
  } elseif {$bar1_type == "DMA" } { 
    set_property value 0x02 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF3}
  } elseif {$bar2_type == "DMA" } { 
    set_property value 0x04 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF3}
  } elseif {$bar3_type == "DMA" } { 
    set_property value 0x08 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF3}
  } elseif {$bar4_type == "DMA" } { 
    set_property value 0x10 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF3}
  } elseif {$bar5_type == "DMA" } { 
    set_property value 0x20 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF3}
  } else {
    set_property value 0x00 ${MODELPARAM_VALUE.VF_BARLITE_INT_PF3}
  }
}

proc update_MODELPARAM_VALUE.C_H2C_NUM_CHNL {MODELPARAM_VALUE.C_H2C_NUM_CHNL PARAM_VALUE.functional_mode PARAM_VALUE.xdma_rnum_chnl} { 
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  if {$func_mode == "MQDMA" } { 
    set_property value 4 ${MODELPARAM_VALUE.C_H2C_NUM_CHNL}
  } else { 
    set_property value [get_property value ${PARAM_VALUE.xdma_rnum_chnl}] ${MODELPARAM_VALUE.C_H2C_NUM_CHNL}
  }
} 


proc update_MODELPARAM_VALUE.C_C2H_NUM_CHNL {MODELPARAM_VALUE.C_C2H_NUM_CHNL PARAM_VALUE.functional_mode PARAM_VALUE.xdma_wnum_chnl} { 
  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]
  if {$func_mode == "MQDMA" } { 
    set_property value 4 ${MODELPARAM_VALUE.C_C2H_NUM_CHNL}
  } else { 
    set_property value [get_property value ${PARAM_VALUE.xdma_wnum_chnl}] ${MODELPARAM_VALUE.C_C2H_NUM_CHNL}
  }
} 

proc update_MODELPARAM_VALUE.H2C_XDMA_CHNL {MODELPARAM_VALUE.H2C_XDMA_CHNL PARAM_VALUE.functional_mode} { 

  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode == "MQDMA"} { 
    set_property value 0x01 ${MODELPARAM_VALUE.H2C_XDMA_CHNL}
  } else { 
    set_property value 0x0F ${MODELPARAM_VALUE.H2C_XDMA_CHNL}
  }

}

proc update_MODELPARAM_VALUE.C2H_XDMA_CHNL {MODELPARAM_VALUE.C2H_XDMA_CHNL PARAM_VALUE.functional_mode} { 

  set func_mode [get_property value ${PARAM_VALUE.functional_mode}]

  if {$func_mode == "MQDMA"} { 
    set_property value 0x01 ${MODELPARAM_VALUE.C2H_XDMA_CHNL}
  } else { 
    set_property value 0x0F ${MODELPARAM_VALUE.C2H_XDMA_CHNL}
  }

}

proc update_MODELPARAM_VALUE.AXISTEN_IF_ENABLE_MSG_ROUTE {MODELPARAM_VALUE.AXISTEN_IF_ENABLE_MSG_ROUTE PARAM_VALUE.axisten_if_enable_msg_route PARAM_VALUE.device_port_type} { 
  set device_port_type [get_property value ${PARAM_VALUE.device_port_type}]
  if {$device_port_type eq "Root_Port_of_PCI_Express_Root_Complex"} {
    set_property value 0x[string toupper [get_property value ${PARAM_VALUE.axisten_if_enable_msg_route}]] ${MODELPARAM_VALUE.AXISTEN_IF_ENABLE_MSG_ROUTE}
  } else { 
    set_property value 0x00000 ${MODELPARAM_VALUE.AXISTEN_IF_ENABLE_MSG_ROUTE}
  }
}

proc update_MODELPARAM_VALUE.ENABLE_MORE {MODELPARAM_VALUE.ENABLE_MORE PARAM_VALUE.enable_more_clk } {
  set_property value [string toupper [get_property value ${PARAM_VALUE.enable_more_clk}]] ${MODELPARAM_VALUE.ENABLE_MORE}
}

proc update_MODELPARAM_VALUE.C_ATS_ENABLE {MODELPARAM_VALUE.C_ATS_ENABLE PARAM_VALUE.c_ats_enable } {
  set_property value [string toupper [get_property value ${PARAM_VALUE.c_ats_enable}]] ${MODELPARAM_VALUE.C_ATS_ENABLE}
}

proc update_MODELPARAM_VALUE.C_PRI_ENABLE {MODELPARAM_VALUE.C_PRI_ENABLE PARAM_VALUE.c_pri_enable } {
  set_property value [string toupper [get_property value ${PARAM_VALUE.c_pri_enable}]] ${MODELPARAM_VALUE.C_PRI_ENABLE}
}

proc update_MODELPARAM_VALUE.C_ATS_CAP_NEXTPTR {MODELPARAM_VALUE.C_ATS_CAP_NEXTPTR PARAM_VALUE.c_pri_enable PARAM_VALUE.cfg_ext_if} {
     set pri_enable  [get_property value  ${PARAM_VALUE.c_pri_enable} ]
	 set cfg_extenable  [get_property value  ${PARAM_VALUE.cfg_ext_if} ]
     if {$pri_enable} {
                        set val 0x490
     } elseif {$cfg_extenable} {
					    set val 0x4A0
	 } else {
                        set val 0x000
     }
        set_property value $val ${MODELPARAM_VALUE.C_ATS_CAP_NEXTPTR}
}

proc update_MODELPARAM_VALUE.C_PR_CAP_NEXTPTR  {MODELPARAM_VALUE.C_PR_CAP_NEXTPTR PARAM_VALUE.cfg_ext_if} {
     set cfg_extenable  [get_property value  ${PARAM_VALUE.cfg_ext_if} ]
     if {$cfg_extenable} {
                        set val 0x4A0
     } else {
                        set val 0x000
     }
        set_property value $val ${MODELPARAM_VALUE.C_PR_CAP_NEXTPTR}
}

proc update_MODELPARAM_VALUE.GEN4_EIEOS_0S7 {MODELPARAM_VALUE.GEN4_EIEOS_0S7 PARAM_VALUE.gen4_eieos_0s7} {

  if { [get_property value ${PARAM_VALUE.gen4_eieos_0s7}]} {
     set val "TRUE"
  } else {
     set val "FALSE"
  }
  set_property value $val ${MODELPARAM_VALUE.GEN4_EIEOS_0S7}
} 

proc update_MODELPARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST {MODELPARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST PARAM_VALUE.c_s_axi_supports_narrow_burst} {
     set narrow_burst  [get_property value ${PARAM_VALUE.c_s_axi_supports_narrow_burst} ]
     if {$narrow_burst} {
			set val  1
     } else {
			set val  0
     }
     set_property value $val ${MODELPARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST}
}

