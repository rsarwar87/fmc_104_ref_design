# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z030fbg676-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.cache/wt [current_project]
set_property parent.project_path /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/src/system_top_PE1.vhd
add_files /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/MercuryZX1.bd
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/constraints/MercuryZX1_SDRAM_0.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/constraints/MercuryZX1_SDRAM_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_axi_gpio_0_0/MercuryZX1_axi_gpio_0_0_board.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_axi_gpio_0_0/MercuryZX1_axi_gpio_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_axi_gpio_0_0/MercuryZX1_axi_gpio_0_0.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_proc_sys_reset_0/MercuryZX1_proc_sys_reset_0_board.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_proc_sys_reset_0/MercuryZX1_proc_sys_reset_0.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_proc_sys_reset_0/MercuryZX1_proc_sys_reset_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0/MercuryZX1_processing_system7_1_0.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_xbar_0/MercuryZX1_xbar_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_rst_mig_7series_0_100M_0/MercuryZX1_rst_mig_7series_0_100M_0_board.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_rst_mig_7series_0_100M_0/MercuryZX1_rst_mig_7series_0_100M_0.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_rst_mig_7series_0_100M_0/MercuryZX1_rst_mig_7series_0_100M_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/MercuryZX1_xadc_wiz_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/MercuryZX1_xadc_wiz_0_0.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_auto_pc_2/MercuryZX1_auto_pc_2_ooc.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_auto_pc_0/MercuryZX1_auto_pc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_auto_pc_1/MercuryZX1_auto_pc_1_ooc.xdc]
set_property used_in_synthesis false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_auto_cc_0/MercuryZX1_auto_cc_0_clocks.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_auto_cc_0/MercuryZX1_auto_cc_0_clocks.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_auto_cc_0/MercuryZX1_auto_cc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/MercuryZX1_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/src/MercuryZX1_PE1.xdc
set_property used_in_implementation false [get_files /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/ghrd/src/MercuryZX1_PE1.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top system_top -part xc7z030fbg676-2


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef system_top.dcp
create_report "MercuryPE1_synth_synth_report_utilization_0" "report_utilization -file system_top_utilization_synth.rpt -pb system_top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
