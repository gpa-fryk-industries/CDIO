# Firmware
The firmware is split into two different parts, the MCU firmware and the FPGA firmware.

Both of these are contained in their respective directory.


## FPGA configuration
Most FPGA's requires an external memory to configure (this one, iCE40 does have a builtin OTP memory). 
To avoid having this (and not having to program two separate devices during dev) the FPGA is configured by the MCU.

The MCU stores a copy of the FPGA image in its flash memory which is then transferred on boot to the FPGA 
(see Lattice technical note `TN1248` for details). 

If the FPGA is programmed using its OTP memory, the MCU can skip this procedure (by commenting out `config-fpga` in `config.dts`) and possibly be downgraded to save cost.

Note that when updating the FPGA firmware, the resulting binary image `top_bitmap.bin` needs
to be copied into `/fw/mcu/fpga/fpga_conf.bin` where it's then linked into the MCU firmware.