// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Thu Oct 17 12:30:04 2019
// Host        : ukaea-fpga running 64-bit KDE neon User Edition 5.16
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ MercuryZX1_labtools_fmeter_0_0_stub.v
// Design      : MercuryZX1_labtools_fmeter_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z030fbg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "labtools_fmeter,Vivado 2019.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(refclk, fin, F0, F1, F2, F3, F4, F5, F6, F7, F8, update)
/* synthesis syn_black_box black_box_pad_pin="refclk,fin[8:0],F0[31:0],F1[31:0],F2[31:0],F3[31:0],F4[31:0],F5[31:0],F6[31:0],F7[31:0],F8[31:0],update" */;
  input refclk;
  input [8:0]fin;
  output [31:0]F0;
  output [31:0]F1;
  output [31:0]F2;
  output [31:0]F3;
  output [31:0]F4;
  output [31:0]F5;
  output [31:0]F6;
  output [31:0]F7;
  output [31:0]F8;
  output update;
endmodule
