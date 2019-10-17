// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Wed Oct 16 17:31:19 2019
// Host        : ukaea-fpga running 64-bit KDE neon User Edition 5.16
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ MercuryZX1_vio_0_0_stub.v
// Design      : MercuryZX1_vio_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z030fbg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, probe_in0, probe_in1, probe_in2, probe_in3, 
  probe_in4, probe_in5, probe_in6, probe_in7, probe_in8, probe_in9, probe_out0)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[31:0],probe_in1[31:0],probe_in2[31:0],probe_in3[31:0],probe_in4[31:0],probe_in5[31:0],probe_in6[31:0],probe_in7[31:0],probe_in8[31:0],probe_in9[11:0],probe_out0[0:0]" */;
  input clk;
  input [31:0]probe_in0;
  input [31:0]probe_in1;
  input [31:0]probe_in2;
  input [31:0]probe_in3;
  input [31:0]probe_in4;
  input [31:0]probe_in5;
  input [31:0]probe_in6;
  input [31:0]probe_in7;
  input [31:0]probe_in8;
  input [11:0]probe_in9;
  output [0:0]probe_out0;
endmodule
