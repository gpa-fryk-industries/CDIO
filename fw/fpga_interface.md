# FPGA Interface

## Physical
Pin assignments:

### Control signals
Pin names are written as `[HDL name]/[Schematic name]` when they do not match.

#### MCO_CLK/FPGA_GCLK 

FPGA clock. Is feed from the MCU using its MCO (Mcu Clock Out) functionality. 
Is divided by 2 from the MCU base clock of 4 MHz to 2 MHz. May be turned of in sleep mode.

#### RST/FPGA_RST
Resets the FPGA state. 

**Note** that ths is different from the CRESET pin below which is used to reset FPGA configuration!

#### ATT/FPGA_ATT
Interrupt request from the FPGA

#### MINH/FPGA_MINH
Master Inhibit. Not currently used. 

Reserved to inhibit the FPGA from behaving as master in a dual master system.


### SPI / config signals

#### SPI_SS/FPGA_CSS
SPI slave select. Selects the FPGA in both configuration mode and during normal operation. Active **LOW**.

#### SPI_SI/MOSI
SPI serial input.

#### SPI_SO/MISO
SPI serial output.

#### SPI_SCK/SCK
SPI serial clock.

#### CRESET/FPGA_CRESET
FPGA configuration reset. Resets configuration so that a new can be uploaded to config memory.

#### CDONE/FPGA_CDONE
FPGA configuration done. Indicates that configuration has been completed without error.


### Microphone signals

#### MIC_DAT/PDMD
Mic data. PDM encoded.

#### MIC_CLK/PDMC
Mic clock. Driven at 2 MHz when microphone is enabled.

### Speaker signals

#### SPK_R/PWMR 
Main speaker, right halfbridge PWM. 

#### SPK_L/PWML 
Main speaker, left halfbridge PWM. 


#### SPK_A/PWMA 
Aux speaker PWM. 

## Layout

The FPGA acts as a SPI slave with read/write registers. 

The first byte transferred contains a read or write bit (RW bit) and address. 

[0x00-0x3F - Config registers][0x40-0x7F - Data registers]



### Register read

1. Send address with MSB = 1
2. Read back