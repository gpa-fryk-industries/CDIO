//
// Created by atmelfan on 2018-11-25.
//

/**
 * Based on mbed-spirit1-example
 * Here: https://github.com/ubirch/mbed-spirit1-example
 */

#include <stdio.h>
#include "spirit1.h"
#include "SPIRIT1_Library/Inc/SPIRIT_Radio.h"
#include "SPIRIT1_Library/Inc/SPIRIT_Config.h"
#include "../pins.h"
#include <libopencm3/stm32/spi.h>
#include <libopencm3/stm32/gpio.h>


/* list of the command codes of SPIRIT1 */
#define    COMMAND_TX                                          ((uint8_t)(0x60)) /*!< Start to transmit; valid only from READY */
#define    COMMAND_RX                                          ((uint8_t)(0x61)) /*!< Start to receive; valid only from READY */
#define    COMMAND_READY                                       ((uint8_t)(0x62)) /*!< Go to READY; valid only from STANDBY or SLEEP or LOCK */
#define    COMMAND_STANDBY                                     ((uint8_t)(0x63)) /*!< Go to STANDBY; valid only from READY */
#define    COMMAND_SLEEP                                       ((uint8_t)(0x64)) /*!< Go to SLEEP; valid only from READY */
#define    COMMAND_LOCKRX                                      ((uint8_t)(0x65)) /*!< Go to LOCK state by using the RX configuration of the synth; valid only from READY */
#define    COMMAND_LOCKTX                                      ((uint8_t)(0x66)) /*!< Go to LOCK state by using the TX configuration of the synth; valid only from READY */
#define    COMMAND_SABORT                                      ((uint8_t)(0x67)) /*!< Force exit form TX or RX states and go to READY state; valid only from TX or RX */
#define    COMMAND_SRES                                        ((uint8_t)(0x70)) /*!< Reset of all digital part, except SPI registers */
#define    COMMAND_FLUSHRXFIFO                                 ((uint8_t)(0x71)) /*!< Clean the RX FIFO; valid from all states */
#define    COMMAND_FLUSHTXFIFO                                 ((uint8_t)(0x72)) /*!< Clean the TX FIFO; valid from all states */

#define HEADER_WRITE_MASK     0x00 /*!< Write mask for header byte*/
#define HEADER_READ_MASK      0x01 /*!< Read mask for header byte*/
#define HEADER_ADDRESS_MASK   0x00 /*!< Address mask for header byte*/
#define HEADER_COMMAND_MASK   0x80 /*!< Command mask for header byte*/

#define LINEAR_FIFO_ADDRESS 0xFF  /*!< Linear FIFO address*/

#define BUILT_HEADER(add_comm, w_r) (add_comm | w_r)  /*!< macro to build the header byte*/
#define WRITE_HEADER    BUILT_HEADER(HEADER_ADDRESS_MASK, HEADER_WRITE_MASK) /*!< macro to build the write header byte*/
#define READ_HEADER     BUILT_HEADER(HEADER_ADDRESS_MASK, HEADER_READ_MASK)  /*!< macro to build the read header byte*/
#define COMMAND_HEADER BUILT_HEADER(HEADER_COMMAND_MASK, HEADER_WRITE_MASK) /*!< macro to build the command header byte*/

/**
 * Write registers in Radio
 * @param address Address to write to.
 * @param n_regs Number of registers to write
 * @param buffer Register contents
 * @return Current radio status
 */
StatusBytes RadioSpiWriteRegisters(uint8_t address, uint8_t n_regs, uint8_t *buffer) {
    static uint16_t tmpstatus;

    StatusBytes *status = (StatusBytes *) &tmpstatus;

    /* Set CS LOW */
    gpio_clear(GPIOA, PA_RADIO_CS);

    /* Send write header and address
     * Meanwhile spirit1 returns its status as two bytes
     */
    uint8_t stath = (uint8_t) spi_xfer(SPI1, WRITE_HEADER);
    uint8_t statl = (uint8_t) spi_xfer(SPI1, address);

    tmpstatus = (uint16_t) (stath | statl);

    /* Write n bytes */
    for (int i = 0; i < n_regs; i++)
        spi_send(SPI1, buffer[i]);

    /* Set CS HIGH */
    gpio_set(GPIOA, PA_RADIO_CS);


    return *status;
}

/**
 * Read registers in Radio
 * @param address Address to read from.
 * @param n_regs Number of registers to read.
 * @param buffer Register contents
 * @return Current radio status
 */
StatusBytes RadioSpiReadRegisters(uint8_t address, uint8_t n_regs, uint8_t *buffer) {
    static uint16_t tmpstatus;

    StatusBytes *status = (StatusBytes *) &tmpstatus;

    /* Set CS LOW */
    gpio_clear(GPIOA, PA_RADIO_CS);

    /* Send write header and address
     * Meanwhile spirit1 returns its status as two bytes
     */
    uint8_t stath = (uint8_t) spi_xfer(SPI1, READ_HEADER);
    uint8_t statl = (uint8_t) spi_xfer(SPI1, address);

    tmpstatus = (uint16_t) (stath | statl);

    /* Read n bytes*/
    for (int i = 0; i < n_regs; i++)
        buffer[i] = (uint8_t) spi_read(SPI1);

    /* Set CS HIGH */
    gpio_set(GPIOA, PA_RADIO_CS);

    return *status;

}

/**
 * Send command to radio
 * @param cmd_code Command to execute
 * @return Current radio status
 */
StatusBytes RadioSpiCommandStrobes(uint8_t cmd_code) {
    static uint16_t tmpstatus;

    StatusBytes *status = (StatusBytes *) &tmpstatus;


    /* Set CS LOW */
    gpio_clear(GPIOA, PA_RADIO_CS);

    /* Send write header and address
     * Meanwhile spirit1 returns its status as two bytes
     */
    uint8_t stath = (uint8_t) spi_xfer(SPI1, COMMAND_HEADER);
    uint8_t statl = (uint8_t) spi_xfer(SPI1, cmd_code);

    tmpstatus = (uint16_t) (stath | statl);

    /* Set CS HIGH */
    gpio_set(GPIOA, PA_RADIO_CS);

    return *status;
}

/**
 * Write to radio FIFO
 * @param n_regs Number of registers to read.
 * @param buffer Register contents
 * @return Current radio status
 */
StatusBytes RadioSpiWriteFifo(uint8_t n_regs, uint8_t *buffer) {
    return RadioSpiWriteRegisters(LINEAR_FIFO_ADDRESS, n_regs, buffer);
}

/**
 * Read from radio FIFO
 * @param n_regs Number of registers to read.
 * @param buffer Register contents
 * @return Current radio status
 */
StatusBytes RadioSpiReadFifo(uint8_t n_regs, uint8_t *buffer) {
    return RadioSpiReadRegisters(LINEAR_FIFO_ADDRESS, n_regs, buffer);
}