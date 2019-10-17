// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Thu Oct 17 12:30:05 2019
// Host        : ukaea-fpga running 64-bit KDE neon User Edition 5.16
// Command     : write_verilog -force -mode synth_stub
//               /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/mercury_pe1_fmc104/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_vio_0_1/MercuryZX1_vio_0_1_stub.v
// Design      : MercuryZX1_vio_0_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z030fbg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.1" *)
module MercuryZX1_vio_0_1(clk, probe_in0, probe_in1, probe_in2, probe_in3, 
  probe_in4, probe_in5, probe_out0, probe_out1, probe_out2)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[13:0],probe_in1[13:0],probe_in2[13:0],probe_in3[13:0],probe_in4[3:0],probe_in5[3:0],probe_out0[3:0],probe_out1[3:0],probe_out2[3:0]" */;
  input clk;
  input [13:0]probe_in0;
  input [13:0]probe_in1;
  input [13:0]probe_in2;
  input [13:0]probe_in3;
  input [3:0]probe_in4;
  input [3:0]probe_in5;
  output [3:0]probe_out0;
  output [3:0]probe_out1;
  output [3:0]probe_out2;
endmodule
