//
// Created by atmelfan on 11/20/18.
//

#ifndef PROJECT_PINS_H
#define PROJECT_PINS_H

/**
 * FPGA Pins
 */
#define PA_FPGA_CRESET  GPIO0 /*Config reset*/
#define PA_FPGA_CDONE   GPIO1 /*Config done*/
#define PA_FPGA_CSS     GPIO2 /*Config chip select*/
#define PA_FPGA_MINH    GPIO3 /*Master INHibit*/
#define PA_FPGA_ATT     GPIO4 /*ATTention*/
#define PA_FPGA_GCLK    GPIO8 /*Clock*/

#define PB_FPGA_RST     GPIO4 /*Reset*/

/**
 * PMIC pins
 */
#define PB_PMIC_AUX_EN  GPIO5
#define PB_PMIC_VSENS   GPIO1

/**
 * Radio pins
 */
#define PA_RADIO_CS     GPIO9
#define PA_RADIO_SHD    GPIO10

#define PB_RADIO_TXR    GPIO7
#define PB_RADIO_RXC    GPIO6

/**
 * MIC pins
 */
#define PB_MIC_DET      GPIO0

/**
 * SPI pins
 */
#define PA_SPI_SCK      GPIO5
#define PA_SPI_MISO     GPIO6
#define PA_SPI_MOSI     GPIO7


/**
 * Serial pins (CONFLICTS WITH SWD!)
 */
#define PA_SERIAL_RXD GPIO13
#define PA_SERIAL_TXD GPIO14

#endif //PROJECT_PINS_H
