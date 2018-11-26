 create_clock -period 1000.000 -name top|CLK_MCO [ get_nets CLK_MCO_c ]
create_clock -period 1000.000000 -name clk500 [get_nets CLK_MCO_c]
