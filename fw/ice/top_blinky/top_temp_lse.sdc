 create_clock -period 1000.000 -name top|CLK_MCO [ get_nets MIC_CLK_c_c ]
 create_clock -period 1000.000 -name top|SPI_SCK [ get_nets SPI_SCK_c ]
create_clock -period 1000.000000 -name clk500 [get_nets MIC_CLK_c_c]
create_clock -period 1000.000000 -name clk501 [get_nets SPI_SCK_c]
