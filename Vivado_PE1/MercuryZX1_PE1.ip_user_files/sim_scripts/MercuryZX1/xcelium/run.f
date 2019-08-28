-makelib xcelium_lib/xilinx_vip -sv \
  "/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "/opt/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "/opt/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/opt/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/opt/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
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
-endlib
-makelib xcelium_lib/axi_lite_ipif_v3_0_4 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/interrupt_control_v3_1_4 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_gpio_v2_0_21 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/9c6e/hdl/axi_gpio_v2_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/MercuryZX1/ip/MercuryZX1_axi_gpio_0_0/sim/MercuryZX1_axi_gpio_0_0.vhd" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/MercuryZX1/ip/MercuryZX1_proc_sys_reset_0/sim/MercuryZX1_proc_sys_reset_0.vhd" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_vip_v1_1_5 -sv \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/d4a8/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/processing_system7_vip_v1_0_7 -sv \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/8c62/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/MercuryZX1/ip/MercuryZX1_processing_system7_1_0/sim/MercuryZX1_processing_system7_1_0.v" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_19 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/4d88/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_4 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/1f5a/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_4 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_4 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_18 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/5b9c/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_20 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ace7/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/MercuryZX1/ip/MercuryZX1_xbar_0/sim/MercuryZX1_xbar_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
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
-endlib
-makelib xcelium_lib/xlconcat_v2_1_3 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/442e/hdl/xlconcat_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/MercuryZX1/ip/MercuryZX1_xlconcat_0_0/sim/MercuryZX1_xlconcat_0_0.v" \
-endlib
-makelib xcelium_lib/axi_protocol_converter_v2_1_19 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/c83a/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/MercuryZX1/ip/MercuryZX1_auto_pc_2/sim/MercuryZX1_auto_pc_2.v" \
  "../../../bd/MercuryZX1/ip/MercuryZX1_auto_pc_0/sim/MercuryZX1_auto_pc_0.v" \
  "../../../bd/MercuryZX1/ip/MercuryZX1_auto_pc_1/sim/MercuryZX1_auto_pc_1.v" \
-endlib
-makelib xcelium_lib/axi_clock_converter_v2_1_18 \
  "../../../../MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ipshared/ac9d/hdl/axi_clock_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/MercuryZX1/ip/MercuryZX1_auto_cc_0/sim/MercuryZX1_auto_cc_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/MercuryZX1/sim/MercuryZX1.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

