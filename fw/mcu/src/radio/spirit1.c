//
// Created by atmelfan on 2018-11-25.
//

/**
 * Based on mbed-spirit1-example
 * Here: https://github.com/ubirch/mbed-spirit1-example
 */

//#define USE_BASIC_PROTOCOL

#include <stdio.h>
#include "spirit1.h"
#include "SPIRIT1_Library/Inc/SPIRIT_Radio.h"
#include "SPIRIT1_Library/Inc/SPIRIT_Config.h"
#include "../pins.h"
#include "../dumb_delay.h"
#include <libopencm3/stm32/spi.h>
#include <libopencm3/stm32/gpio.h>
#include <SPIRIT1_Util.h>


/**
 * Shit to do:
 *
 * TODO: Add CDMA
 *
 */


/* SPIRIT1 settings */

/* Base frequency used, used as fallback if not set from cmake */
#ifndef REGION_AMERICAS
#   define BASE_FREQUENCY 868000000

#else
#   define BASE_FREQUENCY 915.0e6
#endif

#define MY_ADDRESS 0xAA

#define CHANNEL_SPACE               100000
#define CHANNEL_NUMBER              0
#define DATARATE                    38400
#define FREQ_DEVIATION              20000
#define BANDWIDTH                   100000
#define POWER_INDEX                 7
#define RECEIVE_TIMEOUT             2000.0 /*change the value for required timeout period*/
#define RSSI_THRESHOLD              -120  /* Default RSSI at reception, more than noise floor */
#define CSMA_RSSI_THRESHOLD         -90   /* Higher RSSI to Transmit. If it's lower, the Channel will be seen as busy */

#define SYNC_WORD                   0x88888888
#define LENGTH_WIDTH                7
#define CRC_MODE                    PKT_CRC_MODE_8BITS
#define EN_FEC                      S_DISABLE
#define EN_WHITENING                S_ENABLE
#define MODULATION_SELECT           FSK
#define POWER_DBM                   11.6
#define PREAMBLE_LENGTH             PKT_PREAMBLE_LENGTH_04BYTES
#define SYNC_LENGTH                 PKT_SYNC_LENGTH_4BYTES
#define LENGTH_TYPE                 PKT_LENGTH_VAR
#define CONTROL_LENGTH              PKT_CONTROL_LENGTH_0BYTES

#define EN_AUTOACK                      S_DISABLE
#define EN_PIGGYBACKING             	S_DISABLE
#define MAX_RETRANSMISSIONS         	PKT_DISABLE_RETX

#define EN_ADDRESS                  S_DISABLE
#define EN_FILT_MY_ADDRESS          S_DISABLE
#define EN_FILT_MULTICAST_ADDRESS   S_DISABLE
#define EN_FILT_BROADCAST_ADDRESS   S_DISABLE
#define EN_FILT_SOURCE_ADDRESS      S_DISABLE//S_ENABLE
#define SOURCE_ADDR_MASK            0xf0
#define SOURCE_ADDR_REF             0x37
#define MULTICAST_ADDRESS           0xEE
#define BROADCAST_ADDRESS           0xFF

#define PAYLOAD_LEN                     25 /*20 bytes data+tag+cmd_type+cmd+cmdlen+datalen*/

/*  Radio configuration parameters  */
#define XTAL_OFFSET_PPM             0
#define INFINITE_TIMEOUT            0.0


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
 * Radio initialization crap
 */

SRadioInit xRadioInit = {
    XTAL_OFFSET_PPM,
    BASE_FREQUENCY,
    CHANNEL_SPACE,
    CHANNEL_NUMBER,
    MODULATION_SELECT,
    DATARATE,
    FREQ_DEVIATION,
    BANDWIDTH
};

/* Gpio struct for radio IRQ output */
SGpioInit xGpioIRQ0={
        SPIRIT_GPIO_0,
        SPIRIT_GPIO_MODE_DIGITAL_OUTPUT_LP,
        SPIRIT_GPIO_DIG_OUT_IRQ
};

/* Gpio struct for radio IRQ output */
SGpioInit xGpioIRQ1={
        SPIRIT_GPIO_1,
        SPIRIT_GPIO_MODE_DIGITAL_OUTPUT_LP,
        SPIRIT_GPIO_DIG_OUT_IRQ
};

PktBasicInit xBasicInit={
    PREAMBLE_LENGTH,
    SYNC_LENGTH,
    SYNC_WORD,
    LENGTH_TYPE,
    LENGTH_WIDTH,
    CRC_MODE,
    CONTROL_LENGTH,
    EN_ADDRESS,
    EN_FEC,
    EN_WHITENING
};

PktBasicAddressesInit xAddressInit={
        EN_FILT_MY_ADDRESS,
        MY_ADDRESS,
        EN_FILT_MULTICAST_ADDRESS,
        MULTICAST_ADDRESS,
        EN_FILT_BROADCAST_ADDRESS,
        BROADCAST_ADDRESS
};

SpiritIrqs xIrqStatus;

radio_state current_state;


radio_state radio_current_state() {
    return current_state;
}

/**
 * Initialize radio
 */
void radio_init(){
    /* Config radio GPIOs */
    Spirit1GpioIrqInit(&xGpioIRQ0);
    Spirit1GpioIrqInit(&xGpioIRQ1);

    /* Init radio module with settings*/
    Spirit1RadioInit(&xRadioInit);

    /* Set output power */
    Spirit1SetPower(POWER_INDEX, POWER_DBM);

    /* Configure packet protocol */
    SpiritPktBasicInit(&xBasicInit);

    /* Synchronization Quality Index whatever the hell that is */
    Spirit1EnableSQI();

    /* Signal strength threshold */
    Spirit1SetRssiTH(RSSI_THRESHOLD);

    current_state = RADIO_READY;

}

void radio_send(uint8_t* buffer, uint8_t len){

    /* Set address etc */
    SpiritPktBasicAddressesInit(&xAddressInit);

    /* Disable radio interrupt */
    Spirit1DisableIrq();
    Spirit1EnableTxIrq();

    /* Set length of buffer to be transmitted */
    Spirit1SetPayloadlength(len);

    /* Set RX timeout period, no idea why this is required under TX */
    Spirit1SetRxTimeout(RECEIVE_TIMEOUT);

    /* Clear any shit left in IRQ */
    Spirit1ClearIRQ();

    /* Set address of receiver */
    Spirit1SetDestinationAddress(0x00);

    /* Transer buffer and begin TX */
    Spirit1StartTx(buffer, len);

    // TODO: Make this DMA powered
}

void radio_receive(uint8_t* buffer, uint8_t len){

    /* Init addressing */
    // TODO: This shouldn't be required but who the fuck knows with this piece of shit library
    SpiritPktBasicAddressesInit(&xAddressInit);

    /* Disable all IRQ except RX */
    Spirit1DisableIrq();
    Spirit1EnableRxIrq();

    /* Set max payload length */
    Spirit1SetPayloadlength(PAYLOAD_LEN);

    /* Set timeout period */
    Spirit1SetRxTimeout(RECEIVE_TIMEOUT);

    /* Set destination filter */
    Spirit1SetDestinationAddress(0x00);

    /* Clear any remaining IRQ flags*/
    Spirit1ClearIRQ();

    /* Wait for RX */
    Spirit1StartRx();
}

uint8_t radio_get_data(uint8_t* buffer, uint8_t len){
    Spirit1GetRxPacket(buffer, &len);
    return len;
}



void radio_interrupt(){

    /* Read interrupt flags from radio */
    SpiritIrqGetStatus(&xIrqStatus);

    if(xIrqStatus.IRQ_TX_DATA_SENT){
        if(current_state == RADIO_TRANSMIT)
            current_state = RADIO_READY;
    }

    if(xIrqStatus.IRQ_RX_DATA_READY){
        if(current_state == RADIO_RECEIVE)
            current_state = RADIO_READY;
    }

    /* Restart receive after receive timeout*/
    if (xIrqStatus.IRQ_RX_TIMEOUT) {
        if(current_state == RADIO_RECEIVE)
            current_state = RADIO_READY;
    }
}


#define PACK_STATUS(h, l) (((h) << 8) | (l))

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

    _dumb_delay_us(10);

    /* Send write header and address
     * Meanwhile spirit1 returns its status as two bytes
     */
    uint8_t stath = (uint8_t) spi_xfer(SPI1, WRITE_HEADER);
    uint8_t statl = (uint8_t) spi_xfer(SPI1, address);

    tmpstatus = (uint16_t) PACK_STATUS(stath, statl);

    /* Write n bytes */
    for (int i = 0; i < n_regs; i++)
        spi_send(SPI1, buffer[i]);

    _dumb_delay_us(10);
    
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

    _dumb_delay_us(10);

    /* Send write header and address
     * Meanwhile spirit1 returns its status as two bytes
     */
    uint8_t stath = (uint8_t) spi_xfer(SPI1, READ_HEADER);
    uint8_t statl = (uint8_t) spi_xfer(SPI1, address);

    tmpstatus = (uint16_t) PACK_STATUS(stath, statl);

    /* Read n bytes*/
    for (int i = 0; i < n_regs; i++)
        buffer[i] = (uint8_t) spi_xfer(SPI1, 0x00);

    _dumb_delay_us(10);
    
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

    _dumb_delay_us(10);

    /* Send write header and address
     * Meanwhile spirit1 returns its status as two bytes
     */
    uint8_t stath = (uint8_t) spi_xfer(SPI1, COMMAND_HEADER);
    uint8_t statl = (uint8_t) spi_xfer(SPI1, cmd_code);

    tmpstatus = (uint16_t) PACK_STATUS(stath, statl);

    _dumb_delay_us(10);

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