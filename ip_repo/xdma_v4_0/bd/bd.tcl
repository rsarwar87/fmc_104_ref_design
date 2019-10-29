proc init { cell_name undefined_params } {
  bd::mark_propagate_only [get_bd_cells $cell_name] {s_axi_id_width}
}

proc propagate { cell_name  other_params } { 

  set ip [get_bd_cells $cell_name]
  set functional_mode [get_property CONFIG.functional_mode $ip]
  set mult_pf_des [get_property CONFIG.mult_pf_des $ip]
  if { [get_property CONFIG.en_axi_slave_if $ip] == "true" && ($functional_mode == "AXI_Bridge" || $functional_mode == "DMA_and_Bridge" || $mult_pf_des == "true") } { 
    set si [get_bd_intf_pins $cell_name/S_AXI_B]
  } else {
    set si [get_bd_intf_pins $cell_name/S_AXI]
  }

  if { [::bd::utils::not_empty $si] } {
    set p {ID_WIDTH} 
    set si_v [get_property CONFIG.ID_WIDTH $si]
    set ip_v [get_property CONFIG.s_axi_id_width $ip]

    if {$si_v > 0} {
      set_property CONFIG.s_axi_id_width $si_v $ip
    } else {
      bd::send_msg -of $ip -type INFO -msg_id 3 -text " Preserving $p <$ip_v> "
    }

#    set value [get_property CONFIG.SUPPORTS_NARROW_BURST $si]
#    if { $value == 0 } {
#      set_property CONFIG.c_s_axi_supports_narrow_burst false $ip
#    } else {
#      set_property CONFIG.c_s_axi_supports_narrow_burst true $ip
#    }

  } else {
  }
}

proc set_base_high {cell_name} {
  set ::env(IPI_SET_BASE_HIGH) FALSE
  set cfg_type [get_property CONFIG.device_port_type [get_bd_cells $cell_name]]
  # base/high parameter
  set dDefValues [dict create \
  BAR0 [list 0x20000000 0x2FFFFFFF] \
  BAR1 [list 0x30000000 0x3FFFFFFF] \
  BAR2 [list 0x40000000 0x4FFFFFFF] \
  BAR3 [list 0x50000000 0x5FFFFFFF] \
  BAR4 [list 0x60000000 0x6FFFFFFF] \
  BAR5 [list 0x70000000 0x7FFFFFFF]]
  if {$cfg_type == "PCI_Express_Endpoint_device"} {
    dict append $dDefValues CTL0 [list 0x00001000 0x00001FFF]
  } else {
    dict append $dDefValues CTL0 [list 0x00000000 0x001FFFFF]
  }
  # Get slave interfaces and slave segments
  set vSlvBifs [get_bd_intf_pins -of_objects [get_bd_cells $cell_name] -quiet -filter {Mode == "Slave" && Name =~ "S_AXI*" && Name != "S_AXI"}]
  set nSlvBifs [llength $vSlvBifs]
  #Get the slave segments related to the bifs
  set vSlvSegs [get_bd_addr_segs -of_objects $vSlvBifs]
  set nSlvSegs [llength $vSlvSegs]
  
  foreach slvSeg $vSlvSegs {
        #Get the name of the slave seg.
        set sSlvSeg [get_property name $slvSeg]

        set vDefValues [expr [dict exists $dDefValues $sSlvSeg] ? {[dict get $dDefValues $sSlvSeg]} : {[list 0xFFFFFFF 0x00000000]}]
        ::bd::addr::cfg_base_high_of_slv [get_bd_cells $cell_name] $slvSeg [lindex $vDefValues 0] [lindex $vDefValues 1] 
   }
}

proc post_propagate { cell_name undefined_params } {
  set ip [get_bd_cells $cell_name]
  set functional_mode [get_property CONFIG.functional_mode $ip]
  set mult_pf_des [get_property CONFIG.mult_pf_des $ip]
  if { [get_property CONFIG.en_axi_slave_if $ip] == "true" && ($functional_mode == "AXI_Bridge" || $functional_mode == "DMA_and_Bridge" || $mult_pf_des == "true") } { 
    set_base_high $cell_name
  }
}

proc post_config_ip {cell_name otherInfo} {
  set ip [get_bd_cells $cell_name]
  set F true	  
  set lane [get_property CONFIG.pl_link_cap_max_link_width $ip]
  set speed [get_property CONFIG.pl_link_cap_max_link_speed $ip]
  set width [get_property CONFIG.axi_data_width $ip]
  set functional_mode [get_property CONFIG.functional_mode $ip]
  set split_dma [get_property CONFIG.split_dma $ip]
  set ccix_en [get_property CONFIG.enable_ccix $ip]
  set num_of_sc [get_property CONFIG.C_NUM_OF_SC $ip]
  set pcie_blk [get_property CONFIG.pcie_blk_locn $ip]

  set axisten_freq [get_property CONFIG.axisten_freq $ip]
  set ref_clk_freq [get_property CONFIG.ref_clk_freq $ip]

  if {$ref_clk_freq == "100_MHz"} { 
     set refclk_freq 100
  } elseif {$ref_clk_freq == "125_MHz"} {
     set refclk_freq 125
  } elseif {$ref_clk_freq == "250_MHz"} {
     set refclk_freq 250
  }
  set New_Freq_Axi [expr int([expr $axisten_freq * 1000000 ])]
  set New_Freq_Refclk [expr int([expr $refclk_freq * 1000000 ])]
  if {$functional_mode == "AXI_Bridge"} {
      set clks [get_property CONFIG.axi_aclk_loopback $ip]	    
      if {$clks == $F} {
        set_property CONFIG.FREQ_HZ $New_Freq_Axi [get_bd_pins $cell_name/axi_ctl_aclk]
	set_property CONFIG.ASSOCIATED_BUSIF M_AXI_B:S_AXI_B [get_bd_pins $cell_name/axi_aclk]
        set_property CONFIG.ASSOCIATED_RESET axi_aresetn [get_bd_pins $cell_name/axi_aclk]
      } else {
        set_property CONFIG.ASSOCIATED_BUSIF M_AXI_B:S_AXI_B:S_AXI_LITE [get_bd_pins $cell_name/axi_aclk]
        set_property CONFIG.ASSOCIATED_RESET axi_aresetn:axi_ctl_aresetn [get_bd_pins $cell_name/axi_aclk]
      }
  }
  if {$ccix_en == "TRUE"} {
        set current_associated_bus [get_property CONFIG.ASSOCIATED_BUSIF [get_bd_pins $cell_name/axi_aclk]]
        set_property CONFIG.ASSOCIATED_BUSIF $current_associated_bus:cxs_rx:cxs_tx:sc0_ats_m_axis_cq:sc0_ats_m_axis_rc:sc0_ats_s_axis_cc:sc0_ats_s_axis_rq:s_axil_ats [get_bd_pins $cell_name/axi_aclk]
	if {$num_of_sc == 2} {
          set current_associated_bus [get_property CONFIG.ASSOCIATED_BUSIF [get_bd_pins $cell_name/axi_aclk]]
          set_property CONFIG.ASSOCIATED_BUSIF $current_associated_bus:sc1_ats_m_axis_cq:sc1_ats_m_axis_rc:sc1_ats_s_axis_cc:sc1_ats_s_axis_rq [get_bd_pins $cell_name/axi_aclk]
        }
        ##if {$width == "512_bit"} { 
        ##  set current_associated_bus [get_property CONFIG.ASSOCIATED_BUSIF [get_bd_pins $cell_name/axi_aclk]]
        ##  set_property CONFIG.ASSOCIATED_BUSIF $current_associated_bus:cxs_rx:cxs_tx [get_bd_pins $cell_name/axi_aclk]
        ##} else {
        ##  set_property CONFIG.ASSOCIATED_BUSIF cxs_rx:cxs_tx [get_bd_pins $cell_name/core_clk]
        ##} 
        ##set_property CONFIG.ASSOCIATED_BUSIF cxs_rx:cxs_tx [get_bd_pins $cell_name/ccix_user_clk]
  }
  set_property CONFIG.FREQ_HZ $New_Freq_Axi [get_bd_pins $cell_name/axi_aclk]
  if {!$split_dma} {
    set_property CONFIG.FREQ_HZ $New_Freq_Refclk [get_bd_pins $cell_name/sys_clk]
  }
  
  if { [get_property CONFIG.sys_reset_polarity $ip] == "ACTIVE_LOW"} {
    set_property CONFIG.POLARITY "ACTIVE_LOW" [get_bd_pins $ip/sys_rst_n]
  } else {
    set_property CONFIG.POLARITY "ACTIVE_HIGH" [get_bd_pins $ip/sys_rst_n]
  }
  if { [get_property CONFIG.xdma_axi_intf_mm $ip] == "AXI_Memory_Mapped" && $functional_mode == "DMA"} {
    #Set Number of Threads equal to the AXI ID
    set mi [get_bd_intf_pins $cell_name/M_AXI]

    # C2H
    set_property CONFIG.NUM_READ_THREADS [get_property CONFIG.xdma_wnum_chnl $ip] $mi
    # H2C
    set_property CONFIG.NUM_WRITE_THREADS [get_property CONFIG.xdma_rnum_chnl $ip] $mi

    set_property CONFIG.NUM_READ_OUTSTANDING [get_property CONFIG.xdma_rnum_rids $ip] $mi
    set_property CONFIG.NUM_WRITE_OUTSTANDING [get_property CONFIG.xdma_wnum_rids $ip] $mi
  } elseif {$functional_mode == "AXI_Bridge"} {
    set mi [get_bd_intf_pins $cell_name/M_AXI_B]
    set_property CONFIG.NUM_READ_THREADS 1 $mi
    set_property CONFIG.NUM_WRITE_THREADS 1 $mi
  }

  if {[get_property CONFIG.en_axi_master_if $ip] == "true" && $functional_mode == "AXI_Bridge"} { 
    set mib [get_bd_intf_pins $cell_name/M_AXI_B]


    if {$width == "64_bit"} { 
      set_property CONFIG.NUM_WRITE_OUTSTANDING 4 $mib
    } elseif {$width == "128_bit"} { 
      set_property CONFIG.NUM_WRITE_OUTSTANDING 8 $mib
    } elseif {$width == "256_bit"} { 
      set_property CONFIG.NUM_WRITE_OUTSTANDING 16 $mib
    } elseif {$width == "512_bit"} { 
      set_property CONFIG.NUM_WRITE_OUTSTANDING 32 $mib
    } else {
      set_property CONFIG.NUM_WRITE_OUTSTANDING 4 $mib
    }

    set_property CONFIG.NUM_READ_OUTSTANDING [get_property CONFIG.c_m_axi_num_write $ip] $mib

  }
 
  set mult_pf_des [get_property CONFIG.mult_pf_des $ip]
  if {[get_property CONFIG.en_axi_slave_if $ip] == "true" && ($functional_mode == "AXI_Bridge" || $functional_mode == "DMA_and_Bridge" || $mult_pf_des == "true" ) } {
    set sib [get_bd_intf_pins $cell_name/S_AXI_B]
    set_property CONFIG.NUM_WRITE_OUTSTANDING [get_property CONFIG.c_m_axi_num_write $ip] $sib
    set_property CONFIG.NUM_READ_OUTSTANDING  [get_property CONFIG.c_m_axi_num_write $ip] $sib
  }
  
}
