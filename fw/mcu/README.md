# MCU Firmware

## src/
Main code directory

### fpga/
Contains code related to the FPGA

### fdt/
Contains code related to the device tree config file

### radio/
Contains code related to the radio

## Dependencies

### arm-non-eabi-*
Compiler used.

### device-tree-compiler
Used to compile the config.dts file into a flattened device tree binary read by the MCU during runtime. 

### Libopencm3
Open source ARM Cortex-M microcontroller library http://libopencm3.org/.
Included as a submodule in /fw/mcu/libopencm3.

**MUST BE COMPILED AFTER CLONING!**

### SPIRIT1_Library
Low level support library for radio. Located in /fw/mcu/radio/SPIRIT1_Library
Does not need to be compiled, included as-is.

## Compilation

### Install dependencies
All dependencies must be installed and in case of libopencm3, compiled.

### Run cmake
Run `cmake .` in the project root folder (not here). If successfully it should look something like this:
```
INFO * * * Device information * * *
INFO Device:	stm32l082kbu
INFO	family:	stm32l0 (stm32l082kbu)
INFO	cpu:	cortex-m0plus
INFO	fpu:	soft
INFO	flags:	-DSTM32L0 -DSTM32L082KBU
INFO	defs:	-DSTM32L0 -DSTM32L082KBU -D_ROM=128K -D_RAM=20K -D_ROM_OFF=0x08000000 -D_RAM_OFF=0x20000000
INFO libopencm3 libs: opencm3_stm32l0
INFO DTS @ /home/atmelfan/projects/CDIO/fw/mcu/src 
INFO FPGA CONFIGURATION @ /home/atmelfan/projects/CDIO/fw/mcu/src/fpga/fpga_conf.bin
-- Configuring done
-- Generating done
-- Build files have been written to: /home/atmelfan/projects/CDIO/cmake-build-debug
```

If device information is completely or partially empty, libopencm3 has most likely not been compiled properly or at the right location.

The `DTS @ <directory>` message should list the directory of the config.dts file.

The `FPGA CONFIGURATION @ <file>` message should specify the used FPGA configuration image.

### Compile
Run `make all`