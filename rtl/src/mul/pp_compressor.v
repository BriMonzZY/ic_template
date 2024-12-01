// By BriMon
// Email: zzybr@qq.com
// 
// partial product compressor Wallace tree
// use for 16x16 multiplier
// to compress 8 partial products into two 32-bit numbers

`include "array_port.vh"

module pp_compressor (
  input [143:0] pp, // 18-bit pp
  output [31:0] ppout1,
  output [29:0] ppout2
);
  // unpack the input array
  wire [17:0] PP [7:0];
  `UNPACK_ARRAY(18, 8, PP, pp);

  wire [19:0] PP1_code;
  wire [18:0] PP2_code;
  wire [18:0] PP3_code;
  wire [18:0] PP4_code;
  wire [18:0] PP5_code;
  wire [18:0] PP6_code;
  wire [18:0] PP7_code;
  wire [18:0] PP8_code;

  // partial product in the first compress
  wire [23:0] PPC1_1;
  wire [22:0] PPC1_2;
  wire [23:0] PPC1_3;
  wire [21:0] PPC1_4;
  // partial product in the second compress
  wire [31:0] PPC2_1;
  wire [29:0] PPC2_2;

  // sign bit endoder
  assign PP1_code = {~PP[0][17],{2{PP[0][17]}},PP[0][16:0]};
  assign PP2_code = {1'b1,~PP[1][17], PP[1][16:0]};
  assign PP3_code = {1'b1,~PP[2][17], PP[2][16:0]};
  assign PP4_code = {1'b1,~PP[3][17], PP[3][16:0]};   
  assign PP5_code = {1'b1,~PP[4][17], PP[4][16:0]};
  assign PP6_code = {1'b1,~PP[5][17], PP[5][16:0]};    
  assign PP7_code = {1'b1,~PP[6][17], PP[6][16:0]};
  assign PP8_code = {1'b1,~PP[7][17], PP[7][16:0]};

  // 第一级压缩产生部分积1(PPC1_1)和部分积2(PPC1_2)时用到的4:2压缩器的进位连线
  wire [14:0] cout_class1_ppc12; 
  // 第一级压缩产生部分积3(PPC1_3)和部分积4(PPC1_4)时用到的4:2压缩器的进位连线
  wire [14:0] cout_class1_ppc34;
  // 第二级压缩4:2压缩器的进位连线
  wire [14:0] cout_class2;

  genvar i;

  /*********************************************** class1_1 **********************************************************************/
  /*******************************************************************************************************************************/
  CSA3_2 csa_3_2_class1_1 (PP1_code[4], PP2_code[4-2], PP3_code[4-4], PPC1_1[4], PPC1_2[4-1]);
  CSA3_2 csa_3_2_class1_2 (PP1_code[5], PP2_code[5-2], PP3_code[5-4], PPC1_1[5], PPC1_2[5-1]);

  CSA5_3 csa_5_3_class1_1 (PP1_code[6], PP2_code[4], PP3_code[2], PP4_code[0], 1'b0, PPC1_1[6], PPC1_2[5], cout_class1_ppc12[0]);
  generate
    for(i=7;i<=19;i=i+1) begin: csa_5_3_class1_inst
      CSA5_3 csa_5_3_class1_i (PP1_code[i], PP2_code[i-2], PP3_code[i-4], PP4_code[i-6], cout_class1_ppc12[i-7], PPC1_1[i], PPC1_2[i-1], cout_class1_ppc12[i-6]);
    end
  endgenerate
  CSA5_3 csa_5_3_class1_19 (1'b0, 1'b1, PP3_code[16], PP4_code[14], cout_class1_ppc12[13], PPC1_1[20], PPC1_2[19], cout_class1_ppc12[14]);

  CSA3_2 csa_3_2_class1_3 (PP3_code[17], PP4_code[15], cout_class1_ppc12[14], PPC1_1[21], PPC1_2[20]);

  assign PPC1_1[22]  = ~PP4_code[16];
  assign PPC1_2[21]  = PP4_code[16];
  assign PPC1_1[23]  = PP4_code[17];
  assign PPC1_1[3:0] = PP1_code[3:0]; 
  assign PPC1_2[22]  = PP4_code[18];
  assign PPC1_2[1:0] = PP2_code[1:0];
  assign PPC1_2[2]   = 1'b0;

  
  /*********************************************** class1_2 **********************************************************************/
  /*******************************************************************************************************************************/
  CSA3_2 csa_3_2_class1_2_1 (PP5_code[4], PP6_code[4-2], PP7_code[4-4], PPC1_3[4], PPC1_4[4-1]);
  CSA3_2 csa_3_2_class1_2_2 (PP5_code[5], PP6_code[5-2], PP7_code[5-4], PPC1_3[5], PPC1_4[5-1]);

  CSA5_3 csa_5_3_class1_2_1 (PP5_code[6], PP6_code[4], PP7_code[2], PP8_code[0], 1'b0, PPC1_3[6], PPC1_4[5], cout_class1_ppc34[0]);
  generate
    for(i=7;i<=17;i=i+1) begin: csa_5_3_class1_2_inst
      CSA5_3 csa_5_3_class1_2_i (PP5_code[i], PP6_code[i-2], PP7_code[i-4], PP8_code[i-6], cout_class1_ppc34[i-7], PPC1_3[i], PPC1_4[i-1], cout_class1_ppc34[i-6]);
    end
  endgenerate
  CSA5_3 csa_5_3_class1_2_17 (1'b1, PP6_code[16], PP7_code[14], PP8_code[12], cout_class1_ppc34[11], PPC1_3[18], PPC1_4[17], cout_class1_ppc34[12]);
  CSA5_3 csa_5_3_class1_2_18 (1'b0, PP6_code[17], PP7_code[15], PP8_code[13], cout_class1_ppc34[12], PPC1_3[19], PPC1_4[18], cout_class1_ppc34[13]);
  CSA5_3 csa_5_3_class1_2_19 (1'b0, 1'b1, PP7_code[16], PP8_code[14], cout_class1_ppc34[13], PPC1_3[20], PPC1_4[19], cout_class1_ppc34[14]);

  CSA3_2 csa_3_2_class1_2_3 (PP7_code[17], PP8_code[15], cout_class1_ppc34[14], PPC1_3[21], PPC1_4[20]);

  assign PPC1_3[22]  = ~PP8_code[16];
  assign PPC1_4[21]  = PP8_code[16];
  assign PPC1_3[23]  = PP8_code[17];
  assign PPC1_3[3:0] = PP5_code[3:0]; 
  assign PPC1_4[1:0] = PP6_code[1:0];
  assign PPC1_4[2]   = 1'b0;


  /*********************************************** class2 **********************************************************************/
  /*******************************************************************************************************************************/
  CSA3_2 csa_3_2_class2_1 (PPC1_1[8], PPC1_2[8-2], PPC1_3[8-8], PPC2_1[8], PPC2_2[7]);
  CSA3_2 csa_3_2_class2_2 (PPC1_1[9], PPC1_2[9-2], PPC1_3[9-8], PPC2_1[9], PPC2_2[8]);
  
  CSA5_3 csa_5_3_class2_1 (PPC1_1[10], PPC1_2[8], PPC1_3[2], PPC1_4[0], 1'b0, PPC2_1[10], PPC2_2[9], cout_class2[0]);
  CSA5_3 csa_5_3_class2_2 (PPC1_1[11], PPC1_2[9], PPC1_3[3], PPC1_4[1], cout_class2[0], PPC2_1[11], PPC2_2[10], cout_class2[1]);
  CSA5_3 csa_5_3_class2_3 (PPC1_1[12], PPC1_2[10], PPC1_3[4], cout_class2[1], 1'b0, PPC2_1[12], PPC2_2[11], cout_class2[2]);
  generate
    for(i=13;i<=23;i=i+1) begin: csa_5_3_class2_inst
      CSA5_3 csa_5_3_class2_i (PPC1_1[i], PPC1_2[i-2], PPC1_3[i-8], PPC1_4[i-10], cout_class2[i-11], PPC2_1[i], PPC2_2[i-1], cout_class2[i-10]);
    end
  endgenerate
  CSA5_3 csa_5_3_class2_23 (1'b0, 1'b1, PPC1_3[16], PPC1_4[14], cout_class2[13], PPC2_1[24], PPC2_2[23], cout_class2[14]);

  CSA3_2 csa_3_2_class2_3 (PPC1_3[17], PPC1_4[15], cout_class2[14], PPC2_1[25], PPC2_2[24]);
    
  generate
    for(i=26;i<=30;i=i+1) begin: csa_2_2_class2_inst
      CSA2_2 csa_2_2_class2_i (PPC1_3[i-8], PPC1_4[i-10], PPC2_1[i], PPC2_2[i-1]);
    end
  endgenerate

  assign PPC2_1[31] = PPC1_4[21] ^ PPC1_3[23];
  assign PPC2_1[7:0] = PPC1_1[7:0]; 
  assign PPC2_2[5:0] = PPC1_2[5:0];
  assign PPC2_2[6] = 1'b0;    
  
  assign ppout1 = PPC2_1;
  assign ppout2 = PPC2_2;

endmodule
