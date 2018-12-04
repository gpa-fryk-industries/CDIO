# FPGA Firmware
This directory contains the FPGA HDL code.

The root directory contains core packages, other packages should be sorted by their function into different module folders.
Top level entities is contained within `top_<name>/` directories and should contain configuration etc for synthesizing said entity. Top entities should import packages from root and its modules.

## LSE Synthesizer settings
Always weird, just fuck around with the settings until it works.

## Place & Route settings
### Bitmap
For the MCU->FPGA configuration to work these settings needs to be set:
* warmboot must be **disabled**
* Remove binary header must be **enabled**

If not, the FPGA will shit itself after configuration


## Top entities
Top entities is the entry point for synthesis. 

### - top_blinky
Contains simple test entity which toggles the ATT pin.

### - top_core
Contains the primary entity. Has ADPCM, VAD, FBI surveillance, buffers etc, the whole deal.

