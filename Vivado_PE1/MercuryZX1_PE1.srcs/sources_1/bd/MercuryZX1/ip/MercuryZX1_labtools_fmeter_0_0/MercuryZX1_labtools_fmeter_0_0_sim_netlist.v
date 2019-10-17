// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Wed Oct 16 17:13:11 2019
// Host        : ukaea-fpga running 64-bit KDE neon User Edition 5.16
// Command     : write_verilog -force -mode funcsim
//               /media/2TB/workspace/rsarwar/work/enclastra/pe1_zx1/mercury_pe1_fmc104/Vivado_PE1/MercuryZX1_PE1.srcs/sources_1/bd/MercuryZX1/ip/MercuryZX1_labtools_fmeter_0_0/MercuryZX1_labtools_fmeter_0_0_sim_netlist.v
// Design      : MercuryZX1_labtools_fmeter_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z030fbg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "MercuryZX1_labtools_fmeter_0_0,labtools_fmeter,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "labtools_fmeter,Vivado 2019.1" *) 
(* NotValidForBitStream *)
module MercuryZX1_labtools_fmeter_0_0
   (refclk,
    fin,
    F0,
    F1,
    F2,
    F3,
    F4,
    F5,
    F6,
    F7,
    F8,
    update);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 refclk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME refclk, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN MercuryZX1_processing_system7_1_0_FCLK_CLK0, INSERT_VIP 0" *) input refclk;
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

  wire [31:0]F0;
  wire [31:0]F1;
  wire [31:0]F2;
  wire [31:0]F3;
  wire [31:0]F4;
  wire [31:0]F5;
  wire [31:0]F6;
  wire [31:0]F7;
  wire [31:0]F8;
  wire [8:0]fin;
  wire refclk;
  wire update;

  MercuryZX1_labtools_fmeter_0_0_labtools_fmeter U0
       (.F0(F0),
        .F1(F1),
        .F2(F2),
        .F3(F3),
        .F4(F4),
        .F5(F5),
        .F6(F6),
        .F7(F7),
        .F8(F8),
        .fin(fin),
        .refclk(refclk),
        .update(update));
endmodule

(* ORIG_REF_NAME = "labtools_fmeter" *) 
module MercuryZX1_labtools_fmeter_0_0_labtools_fmeter
   (F8,
    F7,
    F6,
    F5,
    F4,
    F3,
    F2,
    F1,
    F0,
    update,
    refclk,
    fin);
  output [31:0]F8;
  output [31:0]F7;
  output [31:0]F6;
  output [31:0]F5;
  output [31:0]F4;
  output [31:0]F3;
  output [31:0]F2;
  output [31:0]F1;
  output [31:0]F0;
  output update;
  input refclk;
  input [8:0]fin;

  wire CE;
  wire [31:0]CNTR_OUT;
  wire [31:0]CNTR_OUT_0;
  wire [31:0]CNTR_OUT_1;
  wire [31:0]CNTR_OUT_2;
  wire [31:0]CNTR_OUT_3;
  wire [31:0]CNTR_OUT_4;
  wire [31:0]CNTR_OUT_5;
  wire [31:0]CNTR_OUT_6;
  wire [31:0]CNTR_OUT_7;
  wire COUNTER_REFCLK_inst_n_2;
  wire F;
  wire [31:0]F0;
  wire [31:0]F1;
  wire [31:0]F2;
  wire [31:0]F3;
  wire [31:0]F4;
  wire [31:0]F5;
  wire [31:0]F6;
  wire [31:0]F7;
  wire [31:0]F8;
  wire [8:0]fin;
  wire refclk;
  wire toggle;
  wire update;

  MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO COUNTER_REFCLK_inst
       (.F(F),
        .\bl.DSP48E_2_0 (COUNTER_REFCLK_inst_n_2),
        .refclk(refclk),
        .toggle(toggle),
        .update(update));
  MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0 \FMETER_gen[0].COUNTER_F_inst 
       (.CE(CE),
        .P(CNTR_OUT),
        .fin(fin[0]),
        .toggle(toggle));
  MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_0 \FMETER_gen[1].COUNTER_F_inst 
       (.CE(CE),
        .P(CNTR_OUT_0),
        .fin(fin[1]),
        .toggle(toggle));
  MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_1 \FMETER_gen[2].COUNTER_F_inst 
       (.CE(CE),
        .P(CNTR_OUT_1),
        .fin(fin[2]),
        .toggle(toggle));
  MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_2 \FMETER_gen[3].COUNTER_F_inst 
       (.CE(CE),
        .P(CNTR_OUT_2),
        .fin(fin[3]),
        .toggle(toggle));
  MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_3 \FMETER_gen[4].COUNTER_F_inst 
       (.CE(CE),
        .P(CNTR_OUT_3),
        .fin(fin[4]),
        .toggle(toggle));
  MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_4 \FMETER_gen[5].COUNTER_F_inst 
       (.CE(CE),
        .P(CNTR_OUT_4),
        .fin(fin[5]),
        .toggle(toggle));
  MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_5 \FMETER_gen[6].COUNTER_F_inst 
       (.CE(CE),
        .P(CNTR_OUT_5),
        .fin(fin[6]),
        .toggle(toggle));
  MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_6 \FMETER_gen[7].COUNTER_F_inst 
       (.CE(CE),
        .P(CNTR_OUT_6),
        .fin(fin[7]),
        .toggle(toggle));
  MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_7 \FMETER_gen[8].COUNTER_F_inst 
       (.CE(CE),
        .P(CNTR_OUT_7),
        .fin(fin[8]),
        .toggle(toggle));
  FDRE \F_reg[0] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[0]),
        .Q(F0[0]),
        .R(1'b0));
  FDRE \F_reg[100] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[4]),
        .Q(F3[4]),
        .R(1'b0));
  FDRE \F_reg[101] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[5]),
        .Q(F3[5]),
        .R(1'b0));
  FDRE \F_reg[102] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[6]),
        .Q(F3[6]),
        .R(1'b0));
  FDRE \F_reg[103] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[7]),
        .Q(F3[7]),
        .R(1'b0));
  FDRE \F_reg[104] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[8]),
        .Q(F3[8]),
        .R(1'b0));
  FDRE \F_reg[105] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[9]),
        .Q(F3[9]),
        .R(1'b0));
  FDRE \F_reg[106] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[10]),
        .Q(F3[10]),
        .R(1'b0));
  FDRE \F_reg[107] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[11]),
        .Q(F3[11]),
        .R(1'b0));
  FDRE \F_reg[108] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[12]),
        .Q(F3[12]),
        .R(1'b0));
  FDRE \F_reg[109] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[13]),
        .Q(F3[13]),
        .R(1'b0));
  FDRE \F_reg[10] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[10]),
        .Q(F0[10]),
        .R(1'b0));
  FDRE \F_reg[110] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[14]),
        .Q(F3[14]),
        .R(1'b0));
  FDRE \F_reg[111] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[15]),
        .Q(F3[15]),
        .R(1'b0));
  FDRE \F_reg[112] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[16]),
        .Q(F3[16]),
        .R(1'b0));
  FDRE \F_reg[113] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[17]),
        .Q(F3[17]),
        .R(1'b0));
  FDRE \F_reg[114] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[18]),
        .Q(F3[18]),
        .R(1'b0));
  FDRE \F_reg[115] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[19]),
        .Q(F3[19]),
        .R(1'b0));
  FDRE \F_reg[116] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[20]),
        .Q(F3[20]),
        .R(1'b0));
  FDRE \F_reg[117] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[21]),
        .Q(F3[21]),
        .R(1'b0));
  FDRE \F_reg[118] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[22]),
        .Q(F3[22]),
        .R(1'b0));
  FDRE \F_reg[119] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[23]),
        .Q(F3[23]),
        .R(1'b0));
  FDRE \F_reg[11] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[11]),
        .Q(F0[11]),
        .R(1'b0));
  FDRE \F_reg[120] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[24]),
        .Q(F3[24]),
        .R(1'b0));
  FDRE \F_reg[121] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[25]),
        .Q(F3[25]),
        .R(1'b0));
  FDRE \F_reg[122] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[26]),
        .Q(F3[26]),
        .R(1'b0));
  FDRE \F_reg[123] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[27]),
        .Q(F3[27]),
        .R(1'b0));
  FDRE \F_reg[124] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[28]),
        .Q(F3[28]),
        .R(1'b0));
  FDRE \F_reg[125] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[29]),
        .Q(F3[29]),
        .R(1'b0));
  FDRE \F_reg[126] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[30]),
        .Q(F3[30]),
        .R(1'b0));
  FDRE \F_reg[127] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[31]),
        .Q(F3[31]),
        .R(1'b0));
  FDRE \F_reg[128] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[0]),
        .Q(F4[0]),
        .R(1'b0));
  FDRE \F_reg[129] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[1]),
        .Q(F4[1]),
        .R(1'b0));
  FDRE \F_reg[12] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[12]),
        .Q(F0[12]),
        .R(1'b0));
  FDRE \F_reg[130] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[2]),
        .Q(F4[2]),
        .R(1'b0));
  FDRE \F_reg[131] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[3]),
        .Q(F4[3]),
        .R(1'b0));
  FDRE \F_reg[132] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[4]),
        .Q(F4[4]),
        .R(1'b0));
  FDRE \F_reg[133] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[5]),
        .Q(F4[5]),
        .R(1'b0));
  FDRE \F_reg[134] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[6]),
        .Q(F4[6]),
        .R(1'b0));
  FDRE \F_reg[135] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[7]),
        .Q(F4[7]),
        .R(1'b0));
  FDRE \F_reg[136] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[8]),
        .Q(F4[8]),
        .R(1'b0));
  FDRE \F_reg[137] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[9]),
        .Q(F4[9]),
        .R(1'b0));
  FDRE \F_reg[138] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[10]),
        .Q(F4[10]),
        .R(1'b0));
  FDRE \F_reg[139] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[11]),
        .Q(F4[11]),
        .R(1'b0));
  FDRE \F_reg[13] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[13]),
        .Q(F0[13]),
        .R(1'b0));
  FDRE \F_reg[140] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[12]),
        .Q(F4[12]),
        .R(1'b0));
  FDRE \F_reg[141] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[13]),
        .Q(F4[13]),
        .R(1'b0));
  FDRE \F_reg[142] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[14]),
        .Q(F4[14]),
        .R(1'b0));
  FDRE \F_reg[143] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[15]),
        .Q(F4[15]),
        .R(1'b0));
  FDRE \F_reg[144] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[16]),
        .Q(F4[16]),
        .R(1'b0));
  FDRE \F_reg[145] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[17]),
        .Q(F4[17]),
        .R(1'b0));
  FDRE \F_reg[146] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[18]),
        .Q(F4[18]),
        .R(1'b0));
  FDRE \F_reg[147] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[19]),
        .Q(F4[19]),
        .R(1'b0));
  FDRE \F_reg[148] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[20]),
        .Q(F4[20]),
        .R(1'b0));
  FDRE \F_reg[149] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[21]),
        .Q(F4[21]),
        .R(1'b0));
  FDRE \F_reg[14] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[14]),
        .Q(F0[14]),
        .R(1'b0));
  FDRE \F_reg[150] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[22]),
        .Q(F4[22]),
        .R(1'b0));
  FDRE \F_reg[151] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[23]),
        .Q(F4[23]),
        .R(1'b0));
  FDRE \F_reg[152] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[24]),
        .Q(F4[24]),
        .R(1'b0));
  FDRE \F_reg[153] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[25]),
        .Q(F4[25]),
        .R(1'b0));
  FDRE \F_reg[154] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[26]),
        .Q(F4[26]),
        .R(1'b0));
  FDRE \F_reg[155] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[27]),
        .Q(F4[27]),
        .R(1'b0));
  FDRE \F_reg[156] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[28]),
        .Q(F4[28]),
        .R(1'b0));
  FDRE \F_reg[157] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[29]),
        .Q(F4[29]),
        .R(1'b0));
  FDRE \F_reg[158] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[30]),
        .Q(F4[30]),
        .R(1'b0));
  FDRE \F_reg[159] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_3[31]),
        .Q(F4[31]),
        .R(1'b0));
  FDRE \F_reg[15] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[15]),
        .Q(F0[15]),
        .R(1'b0));
  FDRE \F_reg[160] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[0]),
        .Q(F5[0]),
        .R(1'b0));
  FDRE \F_reg[161] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[1]),
        .Q(F5[1]),
        .R(1'b0));
  FDRE \F_reg[162] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[2]),
        .Q(F5[2]),
        .R(1'b0));
  FDRE \F_reg[163] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[3]),
        .Q(F5[3]),
        .R(1'b0));
  FDRE \F_reg[164] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[4]),
        .Q(F5[4]),
        .R(1'b0));
  FDRE \F_reg[165] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[5]),
        .Q(F5[5]),
        .R(1'b0));
  FDRE \F_reg[166] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[6]),
        .Q(F5[6]),
        .R(1'b0));
  FDRE \F_reg[167] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[7]),
        .Q(F5[7]),
        .R(1'b0));
  FDRE \F_reg[168] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[8]),
        .Q(F5[8]),
        .R(1'b0));
  FDRE \F_reg[169] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[9]),
        .Q(F5[9]),
        .R(1'b0));
  FDRE \F_reg[16] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[16]),
        .Q(F0[16]),
        .R(1'b0));
  FDRE \F_reg[170] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[10]),
        .Q(F5[10]),
        .R(1'b0));
  FDRE \F_reg[171] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[11]),
        .Q(F5[11]),
        .R(1'b0));
  FDRE \F_reg[172] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[12]),
        .Q(F5[12]),
        .R(1'b0));
  FDRE \F_reg[173] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[13]),
        .Q(F5[13]),
        .R(1'b0));
  FDRE \F_reg[174] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[14]),
        .Q(F5[14]),
        .R(1'b0));
  FDRE \F_reg[175] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[15]),
        .Q(F5[15]),
        .R(1'b0));
  FDRE \F_reg[176] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[16]),
        .Q(F5[16]),
        .R(1'b0));
  FDRE \F_reg[177] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[17]),
        .Q(F5[17]),
        .R(1'b0));
  FDRE \F_reg[178] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[18]),
        .Q(F5[18]),
        .R(1'b0));
  FDRE \F_reg[179] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[19]),
        .Q(F5[19]),
        .R(1'b0));
  FDRE \F_reg[17] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[17]),
        .Q(F0[17]),
        .R(1'b0));
  FDRE \F_reg[180] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[20]),
        .Q(F5[20]),
        .R(1'b0));
  FDRE \F_reg[181] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[21]),
        .Q(F5[21]),
        .R(1'b0));
  FDRE \F_reg[182] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[22]),
        .Q(F5[22]),
        .R(1'b0));
  FDRE \F_reg[183] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[23]),
        .Q(F5[23]),
        .R(1'b0));
  FDRE \F_reg[184] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[24]),
        .Q(F5[24]),
        .R(1'b0));
  FDRE \F_reg[185] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[25]),
        .Q(F5[25]),
        .R(1'b0));
  FDRE \F_reg[186] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[26]),
        .Q(F5[26]),
        .R(1'b0));
  FDRE \F_reg[187] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[27]),
        .Q(F5[27]),
        .R(1'b0));
  FDRE \F_reg[188] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[28]),
        .Q(F5[28]),
        .R(1'b0));
  FDRE \F_reg[189] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[29]),
        .Q(F5[29]),
        .R(1'b0));
  FDRE \F_reg[18] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[18]),
        .Q(F0[18]),
        .R(1'b0));
  FDRE \F_reg[190] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[30]),
        .Q(F5[30]),
        .R(1'b0));
  FDRE \F_reg[191] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_4[31]),
        .Q(F5[31]),
        .R(1'b0));
  FDRE \F_reg[192] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[0]),
        .Q(F6[0]),
        .R(1'b0));
  FDRE \F_reg[193] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[1]),
        .Q(F6[1]),
        .R(1'b0));
  FDRE \F_reg[194] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[2]),
        .Q(F6[2]),
        .R(1'b0));
  FDRE \F_reg[195] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[3]),
        .Q(F6[3]),
        .R(1'b0));
  FDRE \F_reg[196] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[4]),
        .Q(F6[4]),
        .R(1'b0));
  FDRE \F_reg[197] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[5]),
        .Q(F6[5]),
        .R(1'b0));
  FDRE \F_reg[198] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[6]),
        .Q(F6[6]),
        .R(1'b0));
  FDRE \F_reg[199] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[7]),
        .Q(F6[7]),
        .R(1'b0));
  FDRE \F_reg[19] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[19]),
        .Q(F0[19]),
        .R(1'b0));
  FDRE \F_reg[1] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[1]),
        .Q(F0[1]),
        .R(1'b0));
  FDRE \F_reg[200] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[8]),
        .Q(F6[8]),
        .R(1'b0));
  FDRE \F_reg[201] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[9]),
        .Q(F6[9]),
        .R(1'b0));
  FDRE \F_reg[202] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[10]),
        .Q(F6[10]),
        .R(1'b0));
  FDRE \F_reg[203] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[11]),
        .Q(F6[11]),
        .R(1'b0));
  FDRE \F_reg[204] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[12]),
        .Q(F6[12]),
        .R(1'b0));
  FDRE \F_reg[205] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[13]),
        .Q(F6[13]),
        .R(1'b0));
  FDRE \F_reg[206] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[14]),
        .Q(F6[14]),
        .R(1'b0));
  FDRE \F_reg[207] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[15]),
        .Q(F6[15]),
        .R(1'b0));
  FDRE \F_reg[208] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[16]),
        .Q(F6[16]),
        .R(1'b0));
  FDRE \F_reg[209] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[17]),
        .Q(F6[17]),
        .R(1'b0));
  FDRE \F_reg[20] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[20]),
        .Q(F0[20]),
        .R(1'b0));
  FDRE \F_reg[210] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[18]),
        .Q(F6[18]),
        .R(1'b0));
  FDRE \F_reg[211] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[19]),
        .Q(F6[19]),
        .R(1'b0));
  FDRE \F_reg[212] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[20]),
        .Q(F6[20]),
        .R(1'b0));
  FDRE \F_reg[213] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[21]),
        .Q(F6[21]),
        .R(1'b0));
  FDRE \F_reg[214] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[22]),
        .Q(F6[22]),
        .R(1'b0));
  FDRE \F_reg[215] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[23]),
        .Q(F6[23]),
        .R(1'b0));
  FDRE \F_reg[216] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[24]),
        .Q(F6[24]),
        .R(1'b0));
  FDRE \F_reg[217] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[25]),
        .Q(F6[25]),
        .R(1'b0));
  FDRE \F_reg[218] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[26]),
        .Q(F6[26]),
        .R(1'b0));
  FDRE \F_reg[219] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[27]),
        .Q(F6[27]),
        .R(1'b0));
  FDRE \F_reg[21] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[21]),
        .Q(F0[21]),
        .R(1'b0));
  FDRE \F_reg[220] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[28]),
        .Q(F6[28]),
        .R(1'b0));
  FDRE \F_reg[221] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[29]),
        .Q(F6[29]),
        .R(1'b0));
  FDRE \F_reg[222] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[30]),
        .Q(F6[30]),
        .R(1'b0));
  FDRE \F_reg[223] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_5[31]),
        .Q(F6[31]),
        .R(1'b0));
  FDRE \F_reg[224] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[0]),
        .Q(F7[0]),
        .R(1'b0));
  FDRE \F_reg[225] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[1]),
        .Q(F7[1]),
        .R(1'b0));
  FDRE \F_reg[226] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[2]),
        .Q(F7[2]),
        .R(1'b0));
  FDRE \F_reg[227] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[3]),
        .Q(F7[3]),
        .R(1'b0));
  FDRE \F_reg[228] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[4]),
        .Q(F7[4]),
        .R(1'b0));
  FDRE \F_reg[229] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[5]),
        .Q(F7[5]),
        .R(1'b0));
  FDRE \F_reg[22] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[22]),
        .Q(F0[22]),
        .R(1'b0));
  FDRE \F_reg[230] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[6]),
        .Q(F7[6]),
        .R(1'b0));
  FDRE \F_reg[231] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[7]),
        .Q(F7[7]),
        .R(1'b0));
  FDRE \F_reg[232] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[8]),
        .Q(F7[8]),
        .R(1'b0));
  FDRE \F_reg[233] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[9]),
        .Q(F7[9]),
        .R(1'b0));
  FDRE \F_reg[234] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[10]),
        .Q(F7[10]),
        .R(1'b0));
  FDRE \F_reg[235] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[11]),
        .Q(F7[11]),
        .R(1'b0));
  FDRE \F_reg[236] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[12]),
        .Q(F7[12]),
        .R(1'b0));
  FDRE \F_reg[237] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[13]),
        .Q(F7[13]),
        .R(1'b0));
  FDRE \F_reg[238] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[14]),
        .Q(F7[14]),
        .R(1'b0));
  FDRE \F_reg[239] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[15]),
        .Q(F7[15]),
        .R(1'b0));
  FDRE \F_reg[23] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[23]),
        .Q(F0[23]),
        .R(1'b0));
  FDRE \F_reg[240] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[16]),
        .Q(F7[16]),
        .R(1'b0));
  FDRE \F_reg[241] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[17]),
        .Q(F7[17]),
        .R(1'b0));
  FDRE \F_reg[242] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[18]),
        .Q(F7[18]),
        .R(1'b0));
  FDRE \F_reg[243] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[19]),
        .Q(F7[19]),
        .R(1'b0));
  FDRE \F_reg[244] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[20]),
        .Q(F7[20]),
        .R(1'b0));
  FDRE \F_reg[245] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[21]),
        .Q(F7[21]),
        .R(1'b0));
  FDRE \F_reg[246] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[22]),
        .Q(F7[22]),
        .R(1'b0));
  FDRE \F_reg[247] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[23]),
        .Q(F7[23]),
        .R(1'b0));
  FDRE \F_reg[248] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[24]),
        .Q(F7[24]),
        .R(1'b0));
  FDRE \F_reg[249] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[25]),
        .Q(F7[25]),
        .R(1'b0));
  FDRE \F_reg[24] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[24]),
        .Q(F0[24]),
        .R(1'b0));
  FDRE \F_reg[250] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[26]),
        .Q(F7[26]),
        .R(1'b0));
  FDRE \F_reg[251] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[27]),
        .Q(F7[27]),
        .R(1'b0));
  FDRE \F_reg[252] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[28]),
        .Q(F7[28]),
        .R(1'b0));
  FDRE \F_reg[253] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[29]),
        .Q(F7[29]),
        .R(1'b0));
  FDRE \F_reg[254] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[30]),
        .Q(F7[30]),
        .R(1'b0));
  FDRE \F_reg[255] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_6[31]),
        .Q(F7[31]),
        .R(1'b0));
  FDRE \F_reg[256] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[0]),
        .Q(F8[0]),
        .R(1'b0));
  FDRE \F_reg[257] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[1]),
        .Q(F8[1]),
        .R(1'b0));
  FDRE \F_reg[258] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[2]),
        .Q(F8[2]),
        .R(1'b0));
  FDRE \F_reg[259] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[3]),
        .Q(F8[3]),
        .R(1'b0));
  FDRE \F_reg[25] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[25]),
        .Q(F0[25]),
        .R(1'b0));
  FDRE \F_reg[260] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[4]),
        .Q(F8[4]),
        .R(1'b0));
  FDRE \F_reg[261] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[5]),
        .Q(F8[5]),
        .R(1'b0));
  FDRE \F_reg[262] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[6]),
        .Q(F8[6]),
        .R(1'b0));
  FDRE \F_reg[263] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[7]),
        .Q(F8[7]),
        .R(1'b0));
  FDRE \F_reg[264] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[8]),
        .Q(F8[8]),
        .R(1'b0));
  FDRE \F_reg[265] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[9]),
        .Q(F8[9]),
        .R(1'b0));
  FDRE \F_reg[266] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[10]),
        .Q(F8[10]),
        .R(1'b0));
  FDRE \F_reg[267] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[11]),
        .Q(F8[11]),
        .R(1'b0));
  FDRE \F_reg[268] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[12]),
        .Q(F8[12]),
        .R(1'b0));
  FDRE \F_reg[269] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[13]),
        .Q(F8[13]),
        .R(1'b0));
  FDRE \F_reg[26] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[26]),
        .Q(F0[26]),
        .R(1'b0));
  FDRE \F_reg[270] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[14]),
        .Q(F8[14]),
        .R(1'b0));
  FDRE \F_reg[271] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[15]),
        .Q(F8[15]),
        .R(1'b0));
  FDRE \F_reg[272] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[16]),
        .Q(F8[16]),
        .R(1'b0));
  FDRE \F_reg[273] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[17]),
        .Q(F8[17]),
        .R(1'b0));
  FDRE \F_reg[274] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[18]),
        .Q(F8[18]),
        .R(1'b0));
  FDRE \F_reg[275] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[19]),
        .Q(F8[19]),
        .R(1'b0));
  FDRE \F_reg[276] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[20]),
        .Q(F8[20]),
        .R(1'b0));
  FDRE \F_reg[277] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[21]),
        .Q(F8[21]),
        .R(1'b0));
  FDRE \F_reg[278] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[22]),
        .Q(F8[22]),
        .R(1'b0));
  FDRE \F_reg[279] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[23]),
        .Q(F8[23]),
        .R(1'b0));
  FDRE \F_reg[27] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[27]),
        .Q(F0[27]),
        .R(1'b0));
  FDRE \F_reg[280] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[24]),
        .Q(F8[24]),
        .R(1'b0));
  FDRE \F_reg[281] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[25]),
        .Q(F8[25]),
        .R(1'b0));
  FDRE \F_reg[282] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[26]),
        .Q(F8[26]),
        .R(1'b0));
  FDRE \F_reg[283] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[27]),
        .Q(F8[27]),
        .R(1'b0));
  FDRE \F_reg[284] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[28]),
        .Q(F8[28]),
        .R(1'b0));
  FDRE \F_reg[285] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[29]),
        .Q(F8[29]),
        .R(1'b0));
  FDRE \F_reg[286] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[30]),
        .Q(F8[30]),
        .R(1'b0));
  FDRE \F_reg[287] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_7[31]),
        .Q(F8[31]),
        .R(1'b0));
  FDRE \F_reg[28] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[28]),
        .Q(F0[28]),
        .R(1'b0));
  FDRE \F_reg[29] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[29]),
        .Q(F0[29]),
        .R(1'b0));
  FDRE \F_reg[2] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[2]),
        .Q(F0[2]),
        .R(1'b0));
  FDRE \F_reg[30] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[30]),
        .Q(F0[30]),
        .R(1'b0));
  FDRE \F_reg[31] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[31]),
        .Q(F0[31]),
        .R(1'b0));
  FDRE \F_reg[32] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[0]),
        .Q(F1[0]),
        .R(1'b0));
  FDRE \F_reg[33] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[1]),
        .Q(F1[1]),
        .R(1'b0));
  FDRE \F_reg[34] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[2]),
        .Q(F1[2]),
        .R(1'b0));
  FDRE \F_reg[35] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[3]),
        .Q(F1[3]),
        .R(1'b0));
  FDRE \F_reg[36] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[4]),
        .Q(F1[4]),
        .R(1'b0));
  FDRE \F_reg[37] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[5]),
        .Q(F1[5]),
        .R(1'b0));
  FDRE \F_reg[38] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[6]),
        .Q(F1[6]),
        .R(1'b0));
  FDRE \F_reg[39] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[7]),
        .Q(F1[7]),
        .R(1'b0));
  FDRE \F_reg[3] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[3]),
        .Q(F0[3]),
        .R(1'b0));
  FDRE \F_reg[40] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[8]),
        .Q(F1[8]),
        .R(1'b0));
  FDRE \F_reg[41] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[9]),
        .Q(F1[9]),
        .R(1'b0));
  FDRE \F_reg[42] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[10]),
        .Q(F1[10]),
        .R(1'b0));
  FDRE \F_reg[43] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[11]),
        .Q(F1[11]),
        .R(1'b0));
  FDRE \F_reg[44] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[12]),
        .Q(F1[12]),
        .R(1'b0));
  FDRE \F_reg[45] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[13]),
        .Q(F1[13]),
        .R(1'b0));
  FDRE \F_reg[46] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[14]),
        .Q(F1[14]),
        .R(1'b0));
  FDRE \F_reg[47] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[15]),
        .Q(F1[15]),
        .R(1'b0));
  FDRE \F_reg[48] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[16]),
        .Q(F1[16]),
        .R(1'b0));
  FDRE \F_reg[49] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[17]),
        .Q(F1[17]),
        .R(1'b0));
  FDRE \F_reg[4] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[4]),
        .Q(F0[4]),
        .R(1'b0));
  FDRE \F_reg[50] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[18]),
        .Q(F1[18]),
        .R(1'b0));
  FDRE \F_reg[51] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[19]),
        .Q(F1[19]),
        .R(1'b0));
  FDRE \F_reg[52] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[20]),
        .Q(F1[20]),
        .R(1'b0));
  FDRE \F_reg[53] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[21]),
        .Q(F1[21]),
        .R(1'b0));
  FDRE \F_reg[54] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[22]),
        .Q(F1[22]),
        .R(1'b0));
  FDRE \F_reg[55] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[23]),
        .Q(F1[23]),
        .R(1'b0));
  FDRE \F_reg[56] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[24]),
        .Q(F1[24]),
        .R(1'b0));
  FDRE \F_reg[57] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[25]),
        .Q(F1[25]),
        .R(1'b0));
  FDRE \F_reg[58] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[26]),
        .Q(F1[26]),
        .R(1'b0));
  FDRE \F_reg[59] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[27]),
        .Q(F1[27]),
        .R(1'b0));
  FDRE \F_reg[5] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[5]),
        .Q(F0[5]),
        .R(1'b0));
  FDRE \F_reg[60] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[28]),
        .Q(F1[28]),
        .R(1'b0));
  FDRE \F_reg[61] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[29]),
        .Q(F1[29]),
        .R(1'b0));
  FDRE \F_reg[62] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[30]),
        .Q(F1[30]),
        .R(1'b0));
  FDRE \F_reg[63] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_0[31]),
        .Q(F1[31]),
        .R(1'b0));
  FDRE \F_reg[64] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[0]),
        .Q(F2[0]),
        .R(1'b0));
  FDRE \F_reg[65] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[1]),
        .Q(F2[1]),
        .R(1'b0));
  FDRE \F_reg[66] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[2]),
        .Q(F2[2]),
        .R(1'b0));
  FDRE \F_reg[67] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[3]),
        .Q(F2[3]),
        .R(1'b0));
  FDRE \F_reg[68] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[4]),
        .Q(F2[4]),
        .R(1'b0));
  FDRE \F_reg[69] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[5]),
        .Q(F2[5]),
        .R(1'b0));
  FDRE \F_reg[6] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[6]),
        .Q(F0[6]),
        .R(1'b0));
  FDRE \F_reg[70] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[6]),
        .Q(F2[6]),
        .R(1'b0));
  FDRE \F_reg[71] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[7]),
        .Q(F2[7]),
        .R(1'b0));
  FDRE \F_reg[72] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[8]),
        .Q(F2[8]),
        .R(1'b0));
  FDRE \F_reg[73] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[9]),
        .Q(F2[9]),
        .R(1'b0));
  FDRE \F_reg[74] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[10]),
        .Q(F2[10]),
        .R(1'b0));
  FDRE \F_reg[75] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[11]),
        .Q(F2[11]),
        .R(1'b0));
  FDRE \F_reg[76] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[12]),
        .Q(F2[12]),
        .R(1'b0));
  FDRE \F_reg[77] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[13]),
        .Q(F2[13]),
        .R(1'b0));
  FDRE \F_reg[78] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[14]),
        .Q(F2[14]),
        .R(1'b0));
  FDRE \F_reg[79] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[15]),
        .Q(F2[15]),
        .R(1'b0));
  FDRE \F_reg[7] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[7]),
        .Q(F0[7]),
        .R(1'b0));
  FDRE \F_reg[80] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[16]),
        .Q(F2[16]),
        .R(1'b0));
  FDRE \F_reg[81] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[17]),
        .Q(F2[17]),
        .R(1'b0));
  FDRE \F_reg[82] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[18]),
        .Q(F2[18]),
        .R(1'b0));
  FDRE \F_reg[83] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[19]),
        .Q(F2[19]),
        .R(1'b0));
  FDRE \F_reg[84] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[20]),
        .Q(F2[20]),
        .R(1'b0));
  FDRE \F_reg[85] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[21]),
        .Q(F2[21]),
        .R(1'b0));
  FDRE \F_reg[86] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[22]),
        .Q(F2[22]),
        .R(1'b0));
  FDRE \F_reg[87] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[23]),
        .Q(F2[23]),
        .R(1'b0));
  FDRE \F_reg[88] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[24]),
        .Q(F2[24]),
        .R(1'b0));
  FDRE \F_reg[89] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[25]),
        .Q(F2[25]),
        .R(1'b0));
  FDRE \F_reg[8] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[8]),
        .Q(F0[8]),
        .R(1'b0));
  FDRE \F_reg[90] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[26]),
        .Q(F2[26]),
        .R(1'b0));
  FDRE \F_reg[91] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[27]),
        .Q(F2[27]),
        .R(1'b0));
  FDRE \F_reg[92] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[28]),
        .Q(F2[28]),
        .R(1'b0));
  FDRE \F_reg[93] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[29]),
        .Q(F2[29]),
        .R(1'b0));
  FDRE \F_reg[94] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[30]),
        .Q(F2[30]),
        .R(1'b0));
  FDRE \F_reg[95] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_1[31]),
        .Q(F2[31]),
        .R(1'b0));
  FDRE \F_reg[96] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[0]),
        .Q(F3[0]),
        .R(1'b0));
  FDRE \F_reg[97] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[1]),
        .Q(F3[1]),
        .R(1'b0));
  FDRE \F_reg[98] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[2]),
        .Q(F3[2]),
        .R(1'b0));
  FDRE \F_reg[99] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT_2[3]),
        .Q(F3[3]),
        .R(1'b0));
  FDRE \F_reg[9] 
       (.C(refclk),
        .CE(F),
        .D(CNTR_OUT[9]),
        .Q(F0[9]),
        .R(1'b0));
  FDRE toggle_reg
       (.C(refclk),
        .CE(1'b1),
        .D(COUNTER_REFCLK_inst_n_2),
        .Q(toggle),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "unimacro_COUNTER_TC_MACRO" *) 
module MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO
   (update,
    F,
    \bl.DSP48E_2_0 ,
    refclk,
    toggle);
  output update;
  output F;
  output \bl.DSP48E_2_0 ;
  input refclk;
  input toggle;

  wire [47:0]CNTR_OUT;
  wire F;
  wire \F[31]_i_10_n_0 ;
  wire \F[31]_i_11_n_0 ;
  wire \F[31]_i_12_n_0 ;
  wire \F[31]_i_13_n_0 ;
  wire \F[31]_i_14_n_0 ;
  wire \F[31]_i_2_n_0 ;
  wire \F[31]_i_3_n_0 ;
  wire \F[31]_i_4_n_0 ;
  wire \F[31]_i_5_n_0 ;
  wire \F[31]_i_6_n_0 ;
  wire \F[31]_i_7_n_0 ;
  wire \F[31]_i_8_n_0 ;
  wire \F[31]_i_9_n_0 ;
  wire \bl.DSP48E_2_0 ;
  wire \bl.DSP48E_2_i_1_n_0 ;
  wire refclk;
  wire toggle;
  wire update;
  wire update_INST_0_i_1_n_0;
  wire update_INST_0_i_2_n_0;
  wire update_INST_0_i_3_n_0;
  wire \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ;
  wire [29:0]\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED ;
  wire [17:0]\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED ;
  wire [3:0]\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED ;
  wire [47:0]\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED ;

  LUT6 #(
    .INIT(64'h0000000000000004)) 
    \F[31]_i_1 
       (.I0(toggle),
        .I1(CNTR_OUT[0]),
        .I2(\F[31]_i_2_n_0 ),
        .I3(\F[31]_i_3_n_0 ),
        .I4(\F[31]_i_4_n_0 ),
        .I5(\F[31]_i_5_n_0 ),
        .O(F));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \F[31]_i_10 
       (.I0(CNTR_OUT[31]),
        .I1(CNTR_OUT[30]),
        .I2(CNTR_OUT[33]),
        .I3(CNTR_OUT[32]),
        .O(\F[31]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'hFF7F)) 
    \F[31]_i_11 
       (.I0(CNTR_OUT[23]),
        .I1(CNTR_OUT[22]),
        .I2(CNTR_OUT[24]),
        .I3(CNTR_OUT[25]),
        .O(\F[31]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \F[31]_i_12 
       (.I0(CNTR_OUT[39]),
        .I1(CNTR_OUT[38]),
        .I2(CNTR_OUT[41]),
        .I3(CNTR_OUT[40]),
        .O(\F[31]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \F[31]_i_13 
       (.I0(CNTR_OUT[35]),
        .I1(CNTR_OUT[34]),
        .I2(CNTR_OUT[37]),
        .I3(CNTR_OUT[36]),
        .O(\F[31]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \F[31]_i_14 
       (.I0(CNTR_OUT[43]),
        .I1(CNTR_OUT[42]),
        .I2(CNTR_OUT[45]),
        .I3(CNTR_OUT[44]),
        .O(\F[31]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \F[31]_i_2 
       (.I0(\F[31]_i_6_n_0 ),
        .I1(\F[31]_i_7_n_0 ),
        .I2(\F[31]_i_8_n_0 ),
        .I3(\F[31]_i_9_n_0 ),
        .O(\F[31]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFEFF)) 
    \F[31]_i_3 
       (.I0(CNTR_OUT[28]),
        .I1(CNTR_OUT[29]),
        .I2(CNTR_OUT[27]),
        .I3(CNTR_OUT[26]),
        .I4(\F[31]_i_10_n_0 ),
        .O(\F[31]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFF7FF)) 
    \F[31]_i_4 
       (.I0(CNTR_OUT[20]),
        .I1(CNTR_OUT[21]),
        .I2(CNTR_OUT[19]),
        .I3(CNTR_OUT[18]),
        .I4(\F[31]_i_11_n_0 ),
        .O(\F[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFEFFFF)) 
    \F[31]_i_5 
       (.I0(\F[31]_i_12_n_0 ),
        .I1(\F[31]_i_13_n_0 ),
        .I2(CNTR_OUT[47]),
        .I3(CNTR_OUT[46]),
        .I4(CNTR_OUT[1]),
        .I5(\F[31]_i_14_n_0 ),
        .O(\F[31]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hFFF7)) 
    \F[31]_i_6 
       (.I0(CNTR_OUT[7]),
        .I1(CNTR_OUT[6]),
        .I2(CNTR_OUT[9]),
        .I3(CNTR_OUT[8]),
        .O(\F[31]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    \F[31]_i_7 
       (.I0(CNTR_OUT[3]),
        .I1(CNTR_OUT[2]),
        .I2(CNTR_OUT[5]),
        .I3(CNTR_OUT[4]),
        .O(\F[31]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'hFF7F)) 
    \F[31]_i_8 
       (.I0(CNTR_OUT[15]),
        .I1(CNTR_OUT[14]),
        .I2(CNTR_OUT[16]),
        .I3(CNTR_OUT[17]),
        .O(\F[31]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFFEF)) 
    \F[31]_i_9 
       (.I0(CNTR_OUT[11]),
        .I1(CNTR_OUT[10]),
        .I2(CNTR_OUT[13]),
        .I3(CNTR_OUT[12]),
        .O(\F[31]_i_9_n_0 ));
  (* box_type = "PRIMITIVE" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(0),
    .ALUMODEREG(1),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(1),
    .CARRYINSELREG(1),
    .CREG(1),
    .DREG(0),
    .INMODEREG(1),
    .IS_ALUMODE_INVERTED(4'b0000),
    .IS_CARRYIN_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_INMODE_INVERTED(5'b00000),
    .IS_OPMODE_INVERTED(7'b0000000),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(1),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("NONE"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    \bl.DSP48E_2 
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED [29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED [17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(\NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED [3:0]),
        .CEA1(1'b0),
        .CEA2(1'b1),
        .CEAD(1'b0),
        .CEALUMODE(1'b1),
        .CEB1(1'b0),
        .CEB2(1'b1),
        .CEC(1'b1),
        .CECARRYIN(1'b1),
        .CECTRL(1'b1),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(refclk),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(\NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ),
        .OPMODE({1'b0,\bl.DSP48E_2_i_1_n_0 ,1'b0,1'b0,1'b0,\bl.DSP48E_2_i_1_n_0 ,\bl.DSP48E_2_i_1_n_0 }),
        .OVERFLOW(\NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ),
        .P(CNTR_OUT),
        .PATTERNBDETECT(\NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ),
        .PATTERNDETECT(\NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED [47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(\NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ));
  LUT2 #(
    .INIT(4'hE)) 
    \bl.DSP48E_2_i_1 
       (.I0(update_INST_0_i_1_n_0),
        .I1(CNTR_OUT[0]),
        .O(\bl.DSP48E_2_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    toggle_i_1
       (.I0(update_INST_0_i_1_n_0),
        .I1(CNTR_OUT[0]),
        .I2(toggle),
        .O(\bl.DSP48E_2_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h2)) 
    update_INST_0
       (.I0(CNTR_OUT[0]),
        .I1(update_INST_0_i_1_n_0),
        .O(update));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    update_INST_0_i_1
       (.I0(\F[31]_i_5_n_0 ),
        .I1(\F[31]_i_4_n_0 ),
        .I2(\F[31]_i_3_n_0 ),
        .I3(update_INST_0_i_2_n_0),
        .I4(update_INST_0_i_3_n_0),
        .O(update_INST_0_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFB)) 
    update_INST_0_i_2
       (.I0(CNTR_OUT[12]),
        .I1(CNTR_OUT[13]),
        .I2(CNTR_OUT[10]),
        .I3(CNTR_OUT[11]),
        .I4(\F[31]_i_8_n_0 ),
        .O(update_INST_0_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    update_INST_0_i_3
       (.I0(CNTR_OUT[4]),
        .I1(CNTR_OUT[5]),
        .I2(CNTR_OUT[2]),
        .I3(CNTR_OUT[3]),
        .I4(\F[31]_i_6_n_0 ),
        .O(update_INST_0_i_3_n_0));
endmodule

(* ORIG_REF_NAME = "unimacro_COUNTER_TC_MACRO" *) 
module MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0
   (P,
    CE,
    fin,
    toggle);
  output [31:0]P;
  input CE;
  input [0:0]fin;
  input toggle;

  wire CE;
  wire [47:32]CNTR_OUT;
  wire [31:0]P;
  wire [0:0]fin;
  wire toggle;
  wire \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ;
  wire [29:0]\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED ;
  wire [17:0]\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED ;
  wire [3:0]\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED ;
  wire [47:0]\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(0),
    .ALUMODEREG(1),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(1),
    .CARRYINSELREG(1),
    .CREG(1),
    .DREG(0),
    .INMODEREG(1),
    .IS_ALUMODE_INVERTED(4'b0000),
    .IS_CARRYIN_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_INMODE_INVERTED(5'b00000),
    .IS_OPMODE_INVERTED(7'b0000000),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(1),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("NONE"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    \bl.DSP48E_2 
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED [29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED [17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(\NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED [3:0]),
        .CEA1(1'b0),
        .CEA2(CE),
        .CEAD(1'b0),
        .CEALUMODE(CE),
        .CEB1(1'b0),
        .CEB2(CE),
        .CEC(CE),
        .CECARRYIN(CE),
        .CECTRL(CE),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(CE),
        .CLK(fin),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(\NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ),
        .OPMODE({1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .OVERFLOW(\NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ),
        .P({CNTR_OUT,P}),
        .PATTERNBDETECT(\NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ),
        .PATTERNDETECT(\NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED [47:0]),
        .RSTA(toggle),
        .RSTALLCARRYIN(toggle),
        .RSTALUMODE(toggle),
        .RSTB(toggle),
        .RSTC(toggle),
        .RSTCTRL(toggle),
        .RSTD(toggle),
        .RSTINMODE(toggle),
        .RSTM(toggle),
        .RSTP(toggle),
        .UNDERFLOW(\NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ));
endmodule

(* ORIG_REF_NAME = "unimacro_COUNTER_TC_MACRO" *) 
module MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_0
   (P,
    CE,
    fin,
    toggle);
  output [31:0]P;
  input CE;
  input [0:0]fin;
  input toggle;

  wire CE;
  wire [47:32]CNTR_OUT;
  wire [31:0]P;
  wire [0:0]fin;
  wire toggle;
  wire \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ;
  wire [29:0]\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED ;
  wire [17:0]\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED ;
  wire [3:0]\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED ;
  wire [47:0]\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(0),
    .ALUMODEREG(1),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(1),
    .CARRYINSELREG(1),
    .CREG(1),
    .DREG(0),
    .INMODEREG(1),
    .IS_ALUMODE_INVERTED(4'b0000),
    .IS_CARRYIN_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_INMODE_INVERTED(5'b00000),
    .IS_OPMODE_INVERTED(7'b0000000),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(1),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("NONE"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    \bl.DSP48E_2 
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED [29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED [17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(\NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED [3:0]),
        .CEA1(1'b0),
        .CEA2(CE),
        .CEAD(1'b0),
        .CEALUMODE(CE),
        .CEB1(1'b0),
        .CEB2(CE),
        .CEC(CE),
        .CECARRYIN(CE),
        .CECTRL(CE),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(CE),
        .CLK(fin),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(\NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ),
        .OPMODE({1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .OVERFLOW(\NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ),
        .P({CNTR_OUT,P}),
        .PATTERNBDETECT(\NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ),
        .PATTERNDETECT(\NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED [47:0]),
        .RSTA(toggle),
        .RSTALLCARRYIN(toggle),
        .RSTALUMODE(toggle),
        .RSTB(toggle),
        .RSTC(toggle),
        .RSTCTRL(toggle),
        .RSTD(toggle),
        .RSTINMODE(toggle),
        .RSTM(toggle),
        .RSTP(toggle),
        .UNDERFLOW(\NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ));
endmodule

(* ORIG_REF_NAME = "unimacro_COUNTER_TC_MACRO" *) 
module MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_1
   (P,
    CE,
    fin,
    toggle);
  output [31:0]P;
  input CE;
  input [0:0]fin;
  input toggle;

  wire CE;
  wire [47:32]CNTR_OUT;
  wire [31:0]P;
  wire [0:0]fin;
  wire toggle;
  wire \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ;
  wire [29:0]\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED ;
  wire [17:0]\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED ;
  wire [3:0]\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED ;
  wire [47:0]\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(0),
    .ALUMODEREG(1),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(1),
    .CARRYINSELREG(1),
    .CREG(1),
    .DREG(0),
    .INMODEREG(1),
    .IS_ALUMODE_INVERTED(4'b0000),
    .IS_CARRYIN_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_INMODE_INVERTED(5'b00000),
    .IS_OPMODE_INVERTED(7'b0000000),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(1),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("NONE"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    \bl.DSP48E_2 
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED [29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED [17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(\NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED [3:0]),
        .CEA1(1'b0),
        .CEA2(CE),
        .CEAD(1'b0),
        .CEALUMODE(CE),
        .CEB1(1'b0),
        .CEB2(CE),
        .CEC(CE),
        .CECARRYIN(CE),
        .CECTRL(CE),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(CE),
        .CLK(fin),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(\NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ),
        .OPMODE({1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .OVERFLOW(\NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ),
        .P({CNTR_OUT,P}),
        .PATTERNBDETECT(\NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ),
        .PATTERNDETECT(\NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED [47:0]),
        .RSTA(toggle),
        .RSTALLCARRYIN(toggle),
        .RSTALUMODE(toggle),
        .RSTB(toggle),
        .RSTC(toggle),
        .RSTCTRL(toggle),
        .RSTD(toggle),
        .RSTINMODE(toggle),
        .RSTM(toggle),
        .RSTP(toggle),
        .UNDERFLOW(\NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ));
endmodule

(* ORIG_REF_NAME = "unimacro_COUNTER_TC_MACRO" *) 
module MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_2
   (P,
    CE,
    fin,
    toggle);
  output [31:0]P;
  input CE;
  input [0:0]fin;
  input toggle;

  wire CE;
  wire [47:32]CNTR_OUT;
  wire [31:0]P;
  wire [0:0]fin;
  wire toggle;
  wire \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ;
  wire [29:0]\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED ;
  wire [17:0]\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED ;
  wire [3:0]\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED ;
  wire [47:0]\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(0),
    .ALUMODEREG(1),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(1),
    .CARRYINSELREG(1),
    .CREG(1),
    .DREG(0),
    .INMODEREG(1),
    .IS_ALUMODE_INVERTED(4'b0000),
    .IS_CARRYIN_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_INMODE_INVERTED(5'b00000),
    .IS_OPMODE_INVERTED(7'b0000000),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(1),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("NONE"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    \bl.DSP48E_2 
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED [29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED [17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(\NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED [3:0]),
        .CEA1(1'b0),
        .CEA2(CE),
        .CEAD(1'b0),
        .CEALUMODE(CE),
        .CEB1(1'b0),
        .CEB2(CE),
        .CEC(CE),
        .CECARRYIN(CE),
        .CECTRL(CE),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(CE),
        .CLK(fin),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(\NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ),
        .OPMODE({1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .OVERFLOW(\NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ),
        .P({CNTR_OUT,P}),
        .PATTERNBDETECT(\NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ),
        .PATTERNDETECT(\NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED [47:0]),
        .RSTA(toggle),
        .RSTALLCARRYIN(toggle),
        .RSTALUMODE(toggle),
        .RSTB(toggle),
        .RSTC(toggle),
        .RSTCTRL(toggle),
        .RSTD(toggle),
        .RSTINMODE(toggle),
        .RSTM(toggle),
        .RSTP(toggle),
        .UNDERFLOW(\NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ));
endmodule

(* ORIG_REF_NAME = "unimacro_COUNTER_TC_MACRO" *) 
module MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_3
   (P,
    CE,
    fin,
    toggle);
  output [31:0]P;
  input CE;
  input [0:0]fin;
  input toggle;

  wire CE;
  wire [47:32]CNTR_OUT;
  wire [31:0]P;
  wire [0:0]fin;
  wire toggle;
  wire \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ;
  wire [29:0]\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED ;
  wire [17:0]\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED ;
  wire [3:0]\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED ;
  wire [47:0]\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(0),
    .ALUMODEREG(1),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(1),
    .CARRYINSELREG(1),
    .CREG(1),
    .DREG(0),
    .INMODEREG(1),
    .IS_ALUMODE_INVERTED(4'b0000),
    .IS_CARRYIN_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_INMODE_INVERTED(5'b00000),
    .IS_OPMODE_INVERTED(7'b0000000),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(1),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("NONE"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    \bl.DSP48E_2 
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED [29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED [17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(\NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED [3:0]),
        .CEA1(1'b0),
        .CEA2(CE),
        .CEAD(1'b0),
        .CEALUMODE(CE),
        .CEB1(1'b0),
        .CEB2(CE),
        .CEC(CE),
        .CECARRYIN(CE),
        .CECTRL(CE),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(CE),
        .CLK(fin),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(\NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ),
        .OPMODE({1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .OVERFLOW(\NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ),
        .P({CNTR_OUT,P}),
        .PATTERNBDETECT(\NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ),
        .PATTERNDETECT(\NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED [47:0]),
        .RSTA(toggle),
        .RSTALLCARRYIN(toggle),
        .RSTALUMODE(toggle),
        .RSTB(toggle),
        .RSTC(toggle),
        .RSTCTRL(toggle),
        .RSTD(toggle),
        .RSTINMODE(toggle),
        .RSTM(toggle),
        .RSTP(toggle),
        .UNDERFLOW(\NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ));
endmodule

(* ORIG_REF_NAME = "unimacro_COUNTER_TC_MACRO" *) 
module MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_4
   (P,
    CE,
    fin,
    toggle);
  output [31:0]P;
  input CE;
  input [0:0]fin;
  input toggle;

  wire CE;
  wire [47:32]CNTR_OUT;
  wire [31:0]P;
  wire [0:0]fin;
  wire toggle;
  wire \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ;
  wire [29:0]\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED ;
  wire [17:0]\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED ;
  wire [3:0]\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED ;
  wire [47:0]\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(0),
    .ALUMODEREG(1),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(1),
    .CARRYINSELREG(1),
    .CREG(1),
    .DREG(0),
    .INMODEREG(1),
    .IS_ALUMODE_INVERTED(4'b0000),
    .IS_CARRYIN_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_INMODE_INVERTED(5'b00000),
    .IS_OPMODE_INVERTED(7'b0000000),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(1),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("NONE"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    \bl.DSP48E_2 
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED [29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED [17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(\NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED [3:0]),
        .CEA1(1'b0),
        .CEA2(CE),
        .CEAD(1'b0),
        .CEALUMODE(CE),
        .CEB1(1'b0),
        .CEB2(CE),
        .CEC(CE),
        .CECARRYIN(CE),
        .CECTRL(CE),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(CE),
        .CLK(fin),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(\NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ),
        .OPMODE({1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .OVERFLOW(\NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ),
        .P({CNTR_OUT,P}),
        .PATTERNBDETECT(\NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ),
        .PATTERNDETECT(\NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED [47:0]),
        .RSTA(toggle),
        .RSTALLCARRYIN(toggle),
        .RSTALUMODE(toggle),
        .RSTB(toggle),
        .RSTC(toggle),
        .RSTCTRL(toggle),
        .RSTD(toggle),
        .RSTINMODE(toggle),
        .RSTM(toggle),
        .RSTP(toggle),
        .UNDERFLOW(\NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ));
endmodule

(* ORIG_REF_NAME = "unimacro_COUNTER_TC_MACRO" *) 
module MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_5
   (P,
    CE,
    fin,
    toggle);
  output [31:0]P;
  input CE;
  input [0:0]fin;
  input toggle;

  wire CE;
  wire [47:32]CNTR_OUT;
  wire [31:0]P;
  wire [0:0]fin;
  wire toggle;
  wire \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ;
  wire [29:0]\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED ;
  wire [17:0]\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED ;
  wire [3:0]\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED ;
  wire [47:0]\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(0),
    .ALUMODEREG(1),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(1),
    .CARRYINSELREG(1),
    .CREG(1),
    .DREG(0),
    .INMODEREG(1),
    .IS_ALUMODE_INVERTED(4'b0000),
    .IS_CARRYIN_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_INMODE_INVERTED(5'b00000),
    .IS_OPMODE_INVERTED(7'b0000000),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(1),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("NONE"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    \bl.DSP48E_2 
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED [29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED [17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(\NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED [3:0]),
        .CEA1(1'b0),
        .CEA2(CE),
        .CEAD(1'b0),
        .CEALUMODE(CE),
        .CEB1(1'b0),
        .CEB2(CE),
        .CEC(CE),
        .CECARRYIN(CE),
        .CECTRL(CE),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(CE),
        .CLK(fin),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(\NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ),
        .OPMODE({1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .OVERFLOW(\NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ),
        .P({CNTR_OUT,P}),
        .PATTERNBDETECT(\NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ),
        .PATTERNDETECT(\NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED [47:0]),
        .RSTA(toggle),
        .RSTALLCARRYIN(toggle),
        .RSTALUMODE(toggle),
        .RSTB(toggle),
        .RSTC(toggle),
        .RSTCTRL(toggle),
        .RSTD(toggle),
        .RSTINMODE(toggle),
        .RSTM(toggle),
        .RSTP(toggle),
        .UNDERFLOW(\NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ));
endmodule

(* ORIG_REF_NAME = "unimacro_COUNTER_TC_MACRO" *) 
module MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_6
   (P,
    CE,
    fin,
    toggle);
  output [31:0]P;
  input CE;
  input [0:0]fin;
  input toggle;

  wire CE;
  wire [47:32]CNTR_OUT;
  wire [31:0]P;
  wire [0:0]fin;
  wire toggle;
  wire \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ;
  wire [29:0]\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED ;
  wire [17:0]\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED ;
  wire [3:0]\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED ;
  wire [47:0]\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(0),
    .ALUMODEREG(1),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(1),
    .CARRYINSELREG(1),
    .CREG(1),
    .DREG(0),
    .INMODEREG(1),
    .IS_ALUMODE_INVERTED(4'b0000),
    .IS_CARRYIN_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_INMODE_INVERTED(5'b00000),
    .IS_OPMODE_INVERTED(7'b0000000),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(1),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("NONE"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    \bl.DSP48E_2 
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED [29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED [17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(\NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED [3:0]),
        .CEA1(1'b0),
        .CEA2(CE),
        .CEAD(1'b0),
        .CEALUMODE(CE),
        .CEB1(1'b0),
        .CEB2(CE),
        .CEC(CE),
        .CECARRYIN(CE),
        .CECTRL(CE),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(CE),
        .CLK(fin),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(\NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ),
        .OPMODE({1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .OVERFLOW(\NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ),
        .P({CNTR_OUT,P}),
        .PATTERNBDETECT(\NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ),
        .PATTERNDETECT(\NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED [47:0]),
        .RSTA(toggle),
        .RSTALLCARRYIN(toggle),
        .RSTALUMODE(toggle),
        .RSTB(toggle),
        .RSTC(toggle),
        .RSTCTRL(toggle),
        .RSTD(toggle),
        .RSTINMODE(toggle),
        .RSTM(toggle),
        .RSTP(toggle),
        .UNDERFLOW(\NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ));
endmodule

(* ORIG_REF_NAME = "unimacro_COUNTER_TC_MACRO" *) 
module MercuryZX1_labtools_fmeter_0_0_unimacro_COUNTER_TC_MACRO__parameterized0_7
   (P,
    CE,
    fin,
    toggle);
  output [31:0]P;
  output CE;
  input [0:0]fin;
  input toggle;

  wire CE;
  wire [47:32]CNTR_OUT;
  wire [31:0]P;
  wire [0:0]fin;
  wire toggle;
  wire \NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ;
  wire [29:0]\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED ;
  wire [17:0]\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED ;
  wire [3:0]\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED ;
  wire [47:0]\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(0),
    .ALUMODEREG(1),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(1),
    .CARRYINSELREG(1),
    .CREG(1),
    .DREG(0),
    .INMODEREG(1),
    .IS_ALUMODE_INVERTED(4'b0000),
    .IS_CARRYIN_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_INMODE_INVERTED(5'b00000),
    .IS_OPMODE_INVERTED(7'b0000000),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(1),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("NONE"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    \bl.DSP48E_2 
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(\NLW_bl.DSP48E_2_ACOUT_UNCONNECTED [29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(\NLW_bl.DSP48E_2_BCOUT_UNCONNECTED [17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(\NLW_bl.DSP48E_2_CARRYCASCOUT_UNCONNECTED ),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(\NLW_bl.DSP48E_2_CARRYOUT_UNCONNECTED [3:0]),
        .CEA1(1'b0),
        .CEA2(CE),
        .CEAD(1'b0),
        .CEALUMODE(CE),
        .CEB1(1'b0),
        .CEB2(CE),
        .CEC(CE),
        .CECARRYIN(CE),
        .CECTRL(CE),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(CE),
        .CLK(fin),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(\NLW_bl.DSP48E_2_MULTSIGNOUT_UNCONNECTED ),
        .OPMODE({1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .OVERFLOW(\NLW_bl.DSP48E_2_OVERFLOW_UNCONNECTED ),
        .P({CNTR_OUT,P}),
        .PATTERNBDETECT(\NLW_bl.DSP48E_2_PATTERNBDETECT_UNCONNECTED ),
        .PATTERNDETECT(\NLW_bl.DSP48E_2_PATTERNDETECT_UNCONNECTED ),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(\NLW_bl.DSP48E_2_PCOUT_UNCONNECTED [47:0]),
        .RSTA(toggle),
        .RSTALLCARRYIN(toggle),
        .RSTALUMODE(toggle),
        .RSTB(toggle),
        .RSTC(toggle),
        .RSTCTRL(toggle),
        .RSTD(toggle),
        .RSTINMODE(toggle),
        .RSTM(toggle),
        .RSTP(toggle),
        .UNDERFLOW(\NLW_bl.DSP48E_2_UNDERFLOW_UNCONNECTED ));
  LUT1 #(
    .INIT(2'h1)) 
    \bl.DSP48E_2_i_1__0 
       (.I0(toggle),
        .O(CE));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
