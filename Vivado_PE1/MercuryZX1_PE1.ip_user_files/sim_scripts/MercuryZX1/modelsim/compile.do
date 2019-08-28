vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/axi_lite_ipif_v3_0_4
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/interrupt_control_v3_1_4
vlib modelsim_lib/msim/axi_gpio_v2_0_21
vlib modelsim_lib/msim/proc_sys_reset_v5_0_13
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_vip_v1_1_5
vlib modelsim_lib/msim/processing_system7_vip_v1_0_7
vlib modelsim_lib/msim/generic_baseblocks_v2_1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_19
vlib modelsim_lib/msim/fifo_generator_v13_2_4
vlib modelsim_lib/msim/axi_data_fifo_v2_1_18
vlib modelsim_lib/msim/axi_crossbar_v2_1_20
vlib modelsim_lib/msim/xlconcat_v2_1_3
vlib modelsim_lib/msim/axi_protocol_converter_v2_1_19
vlib modelsim_lib/msim/axi_clock_converter_v2_1_18

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm
vmap axi_lite_ipif_v3_0_4 modelsim_lib/msim/axi_lite_ipif_v3_0_4
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap interrupt_control_v3_1_4 modelsim_lib/msim/interrupt_control_v3_1_4
vmap axi_gpio_v2_0_21 modelsim_lib/msim/axi_gpio_v2_0_21
vmap proc_sys_reset_v5_0_13 modelsim_lib/msim/proc_sys_reset_v5_0_13
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_5 modelsim_lib/msim/axi_vip_v1_1_5
vmap processing_system7_vip_v1_0_7 modelsim_lib/msim/processing_system7_vip_v1_0_7
vmap generic_baseblocks_v2_1_0 modelsim_lib/msim/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_19 modelsim_lib/msim/axi_register_slice_v2_1_19
vmap fifo_generator_v13_2_4 modelsim_lib/msim/fifo_generator_v13_2_4
vmap axi_data_fifo_v2_1_18 modelsim_lib/msim/axi_data_fifo_v2_1_18
vmap axi_crossbar_v2_1_20 modelsim_lib/msim/axi_crossbar_v2_1_20
vmap xlconcat_v2_1_3 modelsim_lib/msim/xlconcat_v2_1_3
vmap axi_protocol_converter_v2_1_19 modelsim_lib/msim/axi_protocol_converter_v2_1_19
vmap axi_clock_converter_v2_1_18 modelsim_lib/msim/axi_clock_converter_v2_1_18

vlog -work xilinx_vip -64 -incr -sv -L axi_vip_v1_1_5 -L processing_system7_vip_v1_0_7 -L xilinx_vip "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_5 -L processing_system7_vip_v1_0_7 -L xilinx_vip "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"/opt/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/opt/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/opt/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/clocking/mig_7series_v4_2_iodelay_ctrl.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/clocking/mig_7series_v4_2_infrastructure.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/clocking/mig_7series_v4_2_tempmon.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/clocking/mig_7series_v4_2_clk_ibuf.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/ip_top/mig_7series_v4_2_mem_intfc.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/ip_top/mig_7series_v4_2_memc_ui_top_axi.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/ui/mig_7series_v4_2_ui_wr_data.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/ui/mig_7series_v4_2_ui_rd_data.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/ui/mig_7series_v4_2_ui_top.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/ui/mig_7series_v4_2_ui_cmd.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_fifo.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_w_upsizer.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_and.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_and.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_w_channel.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel_static.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_upsizer.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wrap_cmd.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_simple_fifo.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_incr_cmd.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_arbiter.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_or.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_aw_channel.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_translator.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_b_channel.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_register_slice.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_command_fifo.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_write.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_ar_channel.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_read.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_addr_decode.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg_bank.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_r_channel.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axic_register_slice.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_top.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_fsm.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_r_upsizer.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_or.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wr_cmd_fsm.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/axi/mig_7series_v4_2_ddr_a_upsizer.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_rank_common.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_rank_cntrl.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_bank_mach.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_rank_mach.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_col_mach.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_bank_cntrl.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_mc.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_arb_select.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_round_robin_arb.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_arb_mux.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_bank_common.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_bank_state.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_bank_compare.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_bank_queue.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/controller/mig_7series_v4_2_arb_row_col.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_buf.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_dec_fix.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/ecc/mig_7series_v4_2_fi_xor.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_gen.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_merge_enc.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_poc_edge_store.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_data.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_poc_tap_base.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_skip_calib_tap.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_prbs_rdlvl.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_poc_top.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal_hr.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_lim.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_tempmon.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_poc_pd.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_cntlr.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_group_io.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_poc_meta.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_lane.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_init.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_of_pre_fifo.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_top.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy_wrapper.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_edge.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_samp.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_mux.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_calib_top.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl_off_delay.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_rdlvl.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_if_post_fifo.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrcal.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_prbs_gen.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_poc_cc.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ck_addr_cmd_delay.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_oclkdelay_cal.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_4lanes.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/MercuryZX1_SDRAM_0_mig_sim.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_SDRAM_0/MercuryZX1_SDRAM_0/user_design/rtl/MercuryZX1_SDRAM_0.v" \

vcom -work axi_lite_ipif_v3_0_4 -64 -93 \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work lib_cdc_v1_0_2 -64 -93 \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work interrupt_control_v3_1_4 -64 -93 \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_gpio_v2_0_21 -64 -93 \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/9c6e/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/MercuryZX1/ip/MercuryZX1_axi_gpio_0_0/sim/MercuryZX1_axi_gpio_0_0.vhd" \

vcom -work proc_sys_reset_v5_0_13 -64 -93 \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/MercuryZX1/ip/MercuryZX1_proc_sys_reset_0/sim/MercuryZX1_proc_sys_reset_0.vhd" \

vlog -work axi_infrastructure_v1_1_0 -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_5 -64 -incr -sv -L axi_vip_v1_1_5 -L processing_system7_vip_v1_0_7 -L xilinx_vip "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/d4a8/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_7 -64 -incr -sv -L axi_vip_v1_1_5 -L processing_system7_vip_v1_0_7 -L xilinx_vip "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0/sim/MercuryZX1_processing_system7_1_0.v" \

vlog -work generic_baseblocks_v2_1_0 -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_19 -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/4d88/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_4 -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/1f5a/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_4 -64 -93 \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_4 -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_18 -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/5b9c/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_20 -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ace7/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xbar_0/sim/MercuryZX1_xbar_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/MercuryZX1/ip/MercuryZX1_rst_mig_7series_0_100M_0/sim/MercuryZX1_rst_mig_7series_0_100M_0.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/proc_common_v3_30_a/hdl/src/vhdl/MercuryZX1_xadc_wiz_0_0_conv_funs_pkg.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/proc_common_v3_30_a/hdl/src/vhdl/MercuryZX1_xadc_wiz_0_0_proc_common_pkg.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/proc_common_v3_30_a/hdl/src/vhdl/MercuryZX1_xadc_wiz_0_0_ipif_pkg.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/proc_common_v3_30_a/hdl/src/vhdl/MercuryZX1_xadc_wiz_0_0_family_support.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/proc_common_v3_30_a/hdl/src/vhdl/MercuryZX1_xadc_wiz_0_0_family.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/proc_common_v3_30_a/hdl/src/vhdl/MercuryZX1_xadc_wiz_0_0_soft_reset.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/proc_common_v3_30_a/hdl/src/vhdl/MercuryZX1_xadc_wiz_0_0_pselect_f.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/MercuryZX1_xadc_wiz_0_0_address_decoder.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/MercuryZX1_xadc_wiz_0_0_slave_attachment.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/interrupt_control_v2_01_a/hdl/src/vhdl/MercuryZX1_xadc_wiz_0_0_interrupt_control.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/MercuryZX1_xadc_wiz_0_0_axi_lite_ipif.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/MercuryZX1_xadc_wiz_0_0_drp_arbiter.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/MercuryZX1_xadc_wiz_0_0_temperature_update.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/MercuryZX1_xadc_wiz_0_0_xadc_core_drp.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/MercuryZX1_xadc_wiz_0_0_axi_xadc.vhd" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xadc_wiz_0_0/MercuryZX1_xadc_wiz_0_0.vhd" \

vlog -work xlconcat_v2_1_3 -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/442e/hdl/xlconcat_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/MercuryZX1/ip/MercuryZX1_xlconcat_0_0/sim/MercuryZX1_xlconcat_0_0.v" \

vlog -work axi_protocol_converter_v2_1_19 -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/c83a/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/MercuryZX1/ip/MercuryZX1_auto_pc_2/sim/MercuryZX1_auto_pc_2.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_auto_pc_0/sim/MercuryZX1_auto_pc_0.v" \
"../../../bd/MercuryZX1/ip/MercuryZX1_auto_pc_1/sim/MercuryZX1_auto_pc_1.v" \

vlog -work axi_clock_converter_v2_1_18 -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ac9d/hdl/axi_clock_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl" "+incdir+../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0" "+incdir+/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/MercuryZX1/ip/MercuryZX1_auto_cc_0/sim/MercuryZX1_auto_cc_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/MercuryZX1/sim/MercuryZX1.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

