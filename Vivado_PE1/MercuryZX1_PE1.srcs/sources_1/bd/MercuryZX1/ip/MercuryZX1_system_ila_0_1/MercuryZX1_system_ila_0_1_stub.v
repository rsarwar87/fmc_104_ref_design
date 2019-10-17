// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Wed Oct 16 17:14:48 2019
// Host        : ukaea-fpga running 64-bit KDE neon User Edition 5.16
// Command     : write_verilog -force -mode synth_stub
//               /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/mercury_pe1_fmc104/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_system_ila_0_1/MercuryZX1_system_ila_0_1_stub.v
// Design      : MercuryZX1_system_ila_0_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z030fbg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "bd_8f67,Vivado 2019.1" *)
module MercuryZX1_system_ila_0_1(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[0:0],probe2[0:0],probe3[7:0],probe4[0:0],probe5[0:0],probe6[7:0]" */;
  input clk;
  input [0:0]probe0;
  input [0:0]probe1;
  input [0:0]probe2;
  input [7:0]probe3;
  input [0:0]probe4;
  input [0:0]probe5;
  input [7:0]probe6;
endmodule
