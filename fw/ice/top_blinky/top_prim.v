// Verilog netlist produced by program LSE :  version Diamond Version 0.0.0
// Netlist written on Mon Nov 26 11:11:46 2018
//
// Verilog Description of module top
//

module top (CLK_MCO, RST, ATT);   // ../top.vhd(4[8:11])
    input CLK_MCO;   // ../top.vhd(6[3:10])
    input RST;   // ../top.vhd(6[12:15])
    output ATT;   // ../top.vhd(7[3:6])
    
    wire CLK_MCO_c /* synthesis is_clock=1, SET_AS_NETWORK=CLK_MCO_c */ ;   // ../top.vhd(6[3:10])
    
    wire GND_net, ATT_c, ATT_N_2, VCC_net;
    
    VCC i13 (.Y(VCC_net));
    SB_DFF test_9 (.Q(ATT_c), .C(CLK_MCO_c), .D(ATT_N_2));   // ../top.vhd(19[3] 21[10])
    SB_GB_IO CLK_MCO_pad (.PACKAGE_PIN(CLK_MCO), .OUTPUT_ENABLE(VCC_net), 
            .GLOBAL_BUFFER_OUTPUT(CLK_MCO_c));   // ../top.vhd(6[3:10])
    defparam CLK_MCO_pad.PIN_TYPE = 6'b000001;
    defparam CLK_MCO_pad.PULLUP = 1'b0;
    defparam CLK_MCO_pad.NEG_TRIGGER = 1'b0;
    defparam CLK_MCO_pad.IO_STANDARD = "SB_LVCMOS";
    GND i20 (.Y(GND_net));
    SB_IO ATT_pad (.PACKAGE_PIN(ATT), .OUTPUT_ENABLE(VCC_net), .D_OUT_0(ATT_c));   // /home/atmelfan/lscc/iCEcube2.2017.08/LSE/userware/unix/SYNTHESIS_HEADERS/sb_ice40.v(502[8:13])
    defparam ATT_pad.PIN_TYPE = 6'b011001;
    defparam ATT_pad.PULLUP = 1'b0;
    defparam ATT_pad.NEG_TRIGGER = 1'b0;
    defparam ATT_pad.IO_STANDARD = "SB_LVCMOS";
    SB_LUT4 ATT_I_0_1_lut (.I0(ATT_c), .I1(GND_net), .I2(GND_net), .I3(GND_net), 
            .O(ATT_N_2));   // ../top.vhd(20[12:20])
    defparam ATT_I_0_1_lut.LUT_INIT = 16'h5555;
    
endmodule
