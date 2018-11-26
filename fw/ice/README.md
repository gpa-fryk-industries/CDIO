# FPGA Firmware
This folder contains the FPGA HDL code.
The root directory contains core packages, other packages should be sorted by their function into different module folders.
Top level entities is contained within top_<name>/ folders and should contain configuration etc for synthesizing said entity. Top entities should import packages from root and its modules.

## Top entities
Top entities is the entry point for synthesis. 

### top_blinky
Contains simple test entity which toggles the ATT pin.

### top_core
Contains the primary entity. Has ADPCM, VAD, FBI surveillance, buffers etc, the whole deal.

