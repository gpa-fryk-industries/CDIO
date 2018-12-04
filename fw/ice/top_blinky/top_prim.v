// Verilog netlist produced by program LSE :  version Diamond Version 0.0.0
// Netlist written on Tue Dec  4 17:41:04 2018
//
// Verilog Description of module top
//

module top (CLK_MCO, RST, MINH, ATT, SPI_SO, SPI_SCK, SPI_SS, 
            SPI_SI, MIC_DAT, MIC_CLK, SPK_R, SPK_L, SPK_A);   // ../top.vhd(4[8:11])
    input CLK_MCO;   // ../top.vhd(7[3:10])
    input RST;   // ../top.vhd(7[12:15])
    input MINH;   // ../top.vhd(7[17:21])
    output ATT;   // ../top.vhd(8[3:6])
    output SPI_SO;   // ../top.vhd(11[3:9])
    input SPI_SCK;   // ../top.vhd(12[3:10])
    input SPI_SS;   // ../top.vhd(13[3:9])
    input SPI_SI;   // ../top.vhd(14[3:9])
    input MIC_DAT;   // ../top.vhd(17[3:10])
    output MIC_CLK;   // ../top.vhd(18[3:10])
    output SPK_R;   // ../top.vhd(21[3:8])
    output SPK_L;   // ../top.vhd(21[10:15])
    output SPK_A;   // ../top.vhd(21[17:22])
    
    wire MIC_CLK_c_c /* synthesis is_clock=1, SET_AS_NETWORK=MIC_CLK_c_c */ ;   // ../top.vhd(7[3:10])
    wire SPI_SCK_c /* synthesis is_clock=1, SET_AS_NETWORK=SPI_SCK_c */ ;   // ../top.vhd(12[3:10])
    
    wire GND_net, RST_c, ATT_c, SPI_SS_c, SPI_SI_c;
    wire [7:0]spi_reg;   // ../top.vhd(29[9:16])
    
    wire ATT_N_14, RST_N_10, SPI_SS_N_12, n59, n58, n57, n56, 
        n55, n54, SPI_SO_N_15, VCC_net;
    
    VCC i34 (.Y(VCC_net));
    SB_LUT4 RST_I_0_2_lut (.I0(RST_c), .I1(SPI_SS_c), .I2(GND_net), .I3(GND_net), 
            .O(SPI_SO_N_15));   // ../top.vhd(59[3] 80[10])
    defparam RST_I_0_2_lut.LUT_INIT = 16'h2222;
    GND i1 (.Y(GND_net));
    SB_IO SPI_SO_pad (.PACKAGE_PIN(SPI_SO), .OUTPUT_ENABLE(SPI_SO_N_15), 
          .D_OUT_0(spi_reg[7]));   // /home/atmelfan/lscc/iCEcube2.2017.08/LSE/userware/unix/SYNTHESIS_HEADERS/sb_ice40.v(502[8:13])
    defparam SPI_SO_pad.PIN_TYPE = 6'b101001;
    defparam SPI_SO_pad.PULLUP = 1'b0;
    defparam SPI_SO_pad.NEG_TRIGGER = 1'b0;
    defparam SPI_SO_pad.IO_STANDARD = "SB_LVCMOS";
    SB_DFF div2_25 (.Q(ATT_c), .C(MIC_CLK_c_c), .D(ATT_N_14));   // ../top.vhd(38[3] 40[10])
    SB_IO ATT_pad (.PACKAGE_PIN(ATT), .OUTPUT_ENABLE(VCC_net), .D_OUT_0(ATT_c));   // /home/atmelfan/lscc/iCEcube2.2017.08/LSE/userware/unix/SYNTHESIS_HEADERS/sb_ice40.v(502[8:13])
    defparam ATT_pad.PIN_TYPE = 6'b011001;
    defparam ATT_pad.PULLUP = 1'b0;
    defparam ATT_pad.NEG_TRIGGER = 1'b0;
    defparam ATT_pad.IO_STANDARD = "SB_LVCMOS";
    SB_IO MIC_CLK_pad (.PACKAGE_PIN(MIC_CLK), .OUTPUT_ENABLE(VCC_net), .D_OUT_0(MIC_CLK_c_c));   // /home/atmelfan/lscc/iCEcube2.2017.08/LSE/userware/unix/SYNTHESIS_HEADERS/sb_ice40.v(502[8:13])
    defparam MIC_CLK_pad.PIN_TYPE = 6'b011001;
    defparam MIC_CLK_pad.PULLUP = 1'b0;
    defparam MIC_CLK_pad.NEG_TRIGGER = 1'b0;
    defparam MIC_CLK_pad.IO_STANDARD = "SB_LVCMOS";
    SB_IO SPK_R_pad (.PACKAGE_PIN(SPK_R), .OUTPUT_ENABLE(VCC_net), .D_OUT_0(GND_net));   // /home/atmelfan/lscc/iCEcube2.2017.08/LSE/userware/unix/SYNTHESIS_HEADERS/sb_ice40.v(502[8:13])
    defparam SPK_R_pad.PIN_TYPE = 6'b011001;
    defparam SPK_R_pad.PULLUP = 1'b0;
    defparam SPK_R_pad.NEG_TRIGGER = 1'b0;
    defparam SPK_R_pad.IO_STANDARD = "SB_LVCMOS";
    SB_IO SPK_L_pad (.PACKAGE_PIN(SPK_L), .OUTPUT_ENABLE(VCC_net), .D_OUT_0(GND_net));   // /home/atmelfan/lscc/iCEcube2.2017.08/LSE/userware/unix/SYNTHESIS_HEADERS/sb_ice40.v(502[8:13])
    defparam SPK_L_pad.PIN_TYPE = 6'b011001;
    defparam SPK_L_pad.PULLUP = 1'b0;
    defparam SPK_L_pad.NEG_TRIGGER = 1'b0;
    defparam SPK_L_pad.IO_STANDARD = "SB_LVCMOS";
    SB_IO SPK_A_pad (.PACKAGE_PIN(SPK_A), .OUTPUT_ENABLE(VCC_net), .D_OUT_0(GND_net));   // /home/atmelfan/lscc/iCEcube2.2017.08/LSE/userware/unix/SYNTHESIS_HEADERS/sb_ice40.v(502[8:13])
    defparam SPK_A_pad.PIN_TYPE = 6'b011001;
    defparam SPK_A_pad.PULLUP = 1'b0;
    defparam SPK_A_pad.NEG_TRIGGER = 1'b0;
    defparam SPK_A_pad.IO_STANDARD = "SB_LVCMOS";
    SB_GB_IO MIC_CLK_c_pad (.PACKAGE_PIN(CLK_MCO), .OUTPUT_ENABLE(VCC_net), 
            .GLOBAL_BUFFER_OUTPUT(MIC_CLK_c_c));   // ../top.vhd(7[3:10])
    defparam MIC_CLK_c_pad.PIN_TYPE = 6'b000001;
    defparam MIC_CLK_c_pad.PULLUP = 1'b0;
    defparam MIC_CLK_c_pad.NEG_TRIGGER = 1'b0;
    defparam MIC_CLK_c_pad.IO_STANDARD = "SB_LVCMOS";
    SB_IO RST_pad (.PACKAGE_PIN(RST), .OUTPUT_ENABLE(VCC_net), .D_IN_0(RST_c));   // /home/atmelfan/lscc/iCEcube2.2017.08/LSE/userware/unix/SYNTHESIS_HEADERS/sb_ice40.v(502[8:13])
    defparam RST_pad.PIN_TYPE = 6'b000001;
    defparam RST_pad.PULLUP = 1'b0;
    defparam RST_pad.NEG_TRIGGER = 1'b0;
    defparam RST_pad.IO_STANDARD = "SB_LVCMOS";
    SB_GB_IO SPI_SCK_pad (.PACKAGE_PIN(SPI_SCK), .OUTPUT_ENABLE(VCC_net), 
            .GLOBAL_BUFFER_OUTPUT(SPI_SCK_c));   // ../top.vhd(12[3:10])
    defparam SPI_SCK_pad.PIN_TYPE = 6'b000001;
    defparam SPI_SCK_pad.PULLUP = 1'b0;
    defparam SPI_SCK_pad.NEG_TRIGGER = 1'b0;
    defparam SPI_SCK_pad.IO_STANDARD = "SB_LVCMOS";
    SB_IO SPI_SS_pad (.PACKAGE_PIN(SPI_SS), .OUTPUT_ENABLE(VCC_net), .D_IN_0(SPI_SS_c));   // /home/atmelfan/lscc/iCEcube2.2017.08/LSE/userware/unix/SYNTHESIS_HEADERS/sb_ice40.v(502[8:13])
    defparam SPI_SS_pad.PIN_TYPE = 6'b000001;
    defparam SPI_SS_pad.PULLUP = 1'b0;
    defparam SPI_SS_pad.NEG_TRIGGER = 1'b0;
    defparam SPI_SS_pad.IO_STANDARD = "SB_LVCMOS";
    SB_IO SPI_SI_pad (.PACKAGE_PIN(SPI_SI), .OUTPUT_ENABLE(VCC_net), .D_IN_0(SPI_SI_c));   // /home/atmelfan/lscc/iCEcube2.2017.08/LSE/userware/unix/SYNTHESIS_HEADERS/sb_ice40.v(502[8:13])
    defparam SPI_SI_pad.PIN_TYPE = 6'b000001;
    defparam SPI_SI_pad.PULLUP = 1'b0;
    defparam SPI_SI_pad.NEG_TRIGGER = 1'b0;
    defparam SPI_SI_pad.IO_STANDARD = "SB_LVCMOS";
    SB_LUT4 i48_3_lut_3_lut (.I0(spi_reg[2]), .I1(spi_reg[1]), .I2(SPI_SS_c), 
            .I3(GND_net), .O(n54));   // ../top.vhd(68[4] 71[11])
    defparam i48_3_lut_3_lut.LUT_INIT = 16'hacac;
    SB_LUT4 i49_3_lut_3_lut (.I0(spi_reg[1]), .I1(spi_reg[0]), .I2(SPI_SS_c), 
            .I3(GND_net), .O(n55));   // ../top.vhd(68[4] 71[11])
    defparam i49_3_lut_3_lut.LUT_INIT = 16'hacac;
    SB_LUT4 i50_3_lut_3_lut (.I0(spi_reg[3]), .I1(spi_reg[2]), .I2(SPI_SS_c), 
            .I3(GND_net), .O(n56));   // ../top.vhd(68[4] 71[11])
    defparam i50_3_lut_3_lut.LUT_INIT = 16'hacac;
    SB_LUT4 i51_3_lut_3_lut (.I0(spi_reg[4]), .I1(spi_reg[3]), .I2(SPI_SS_c), 
            .I3(GND_net), .O(n57));   // ../top.vhd(68[4] 71[11])
    defparam i51_3_lut_3_lut.LUT_INIT = 16'hacac;
    SB_DFFER spi_reg_i0_i0 (.Q(spi_reg[0]), .C(SPI_SCK_c), .E(SPI_SS_N_12), 
            .D(SPI_SI_c), .R(RST_N_10));   // ../top.vhd(68[4] 71[11])
    SB_LUT4 ATT_I_0_1_lut (.I0(ATT_c), .I1(GND_net), .I2(GND_net), .I3(GND_net), 
            .O(ATT_N_14));   // ../top.vhd(39[12:20])
    defparam ATT_I_0_1_lut.LUT_INIT = 16'h5555;
    SB_DFFR spi_reg_i0_i6 (.Q(spi_reg[6]), .C(SPI_SCK_c), .D(n59), .R(RST_N_10));   // ../top.vhd(68[4] 71[11])
    SB_DFFR spi_reg_i0_i5 (.Q(spi_reg[5]), .C(SPI_SCK_c), .D(n58), .R(RST_N_10));   // ../top.vhd(68[4] 71[11])
    SB_DFFR spi_reg_i0_i4 (.Q(spi_reg[4]), .C(SPI_SCK_c), .D(n57), .R(RST_N_10));   // ../top.vhd(68[4] 71[11])
    SB_DFFR spi_reg_i0_i3 (.Q(spi_reg[3]), .C(SPI_SCK_c), .D(n56), .R(RST_N_10));   // ../top.vhd(68[4] 71[11])
    SB_DFFR spi_reg_i0_i1 (.Q(spi_reg[1]), .C(SPI_SCK_c), .D(n55), .R(RST_N_10));   // ../top.vhd(68[4] 71[11])
    SB_DFFR spi_reg_i0_i2 (.Q(spi_reg[2]), .C(SPI_SCK_c), .D(n54), .R(RST_N_10));   // ../top.vhd(68[4] 71[11])
    SB_DFFER spi_reg_i0_i7 (.Q(spi_reg[7]), .C(SPI_SCK_c), .E(SPI_SS_N_12), 
            .D(spi_reg[6]), .R(RST_N_10));   // ../top.vhd(68[4] 71[11])
    SB_LUT4 i52_3_lut_3_lut (.I0(spi_reg[5]), .I1(spi_reg[4]), .I2(SPI_SS_c), 
            .I3(GND_net), .O(n58));   // ../top.vhd(68[4] 71[11])
    defparam i52_3_lut_3_lut.LUT_INIT = 16'hacac;
    SB_LUT4 i53_3_lut_3_lut (.I0(spi_reg[6]), .I1(spi_reg[5]), .I2(SPI_SS_c), 
            .I3(GND_net), .O(n59));   // ../top.vhd(68[4] 71[11])
    defparam i53_3_lut_3_lut.LUT_INIT = 16'hacac;
    SB_LUT4 SPI_SS_I_0_1_lut (.I0(SPI_SS_c), .I1(GND_net), .I2(GND_net), 
            .I3(GND_net), .O(SPI_SS_N_12));   // ../top.vhd(66[9:21])
    defparam SPI_SS_I_0_1_lut.LUT_INIT = 16'h5555;
    SB_LUT4 RST_I_0_28_1_lut (.I0(RST_c), .I1(GND_net), .I2(GND_net), 
            .I3(GND_net), .O(RST_N_10));   // ../top.vhd(59[6:15])
    defparam RST_I_0_28_1_lut.LUT_INIT = 16'h5555;
    
endmodule
