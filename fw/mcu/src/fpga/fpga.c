//
// Created by atmelfan on 2018-11-10.
//

#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/spi.h>
#include "fpga.h"
#include "../pins.h"
#include "../dumb_delay.h"


void fpga_reset(){
    _dumb_delay_us(20);
    gpio_clear(GPIOB, PB_FPGA_RST);
    _dumb_delay_us(20);
    gpio_set(GPIOB, PB_FPGA_RST);
}

uint8_t fpga_command(uint8_t cmd) {

    /* Select FPGA */
    gpio_clear(GPIOA, PA_FPGA_CSS);

    uint8_t stath = (uint8_t) spi_xfer(SPI1, (uint8_t) (0x80 | cmd));

    /* Deselect FPGA */
    gpio_set(GPIOA, PA_FPGA_CSS);

    return  stath;
}

uint8_t fpga_write(uint8_t* buffer, uint8_t len){
    /* Select FPGA */
    gpio_clear(GPIOA, PA_FPGA_CSS);

    _dumb_delay_us(2);

    uint8_t stath = (uint8_t) spi_xfer(SPI1, 0x80);

    for (int i = 0; i < len; ++i) {
        _dumb_delay_us(2);
        spi_xfer(SPI1, *buffer);
        buffer++;
    }

    _dumb_delay_us(2);

    /* Deselect FPGA */
    gpio_set(GPIOA, PA_FPGA_CSS);

    return  stath;
}

uint8_t fpga_read(uint8_t *buffer, uint8_t len) {
    /* Select FPGA */
    gpio_clear(GPIOA, PA_FPGA_CSS);

    _dumb_delay_us(2);

    uint8_t stath = (uint8_t) spi_xfer(SPI1, 0x00);

    for (int i = 0; i < len; ++i) {
        _dumb_delay_us(2);
        *buffer = spi_xfer(SPI1, 0x00);
        buffer++;
    }

    _dumb_delay_us(2);

    /* Deselect FPGA */
    gpio_set(GPIOA, PA_FPGA_CSS);

    return  stath;
}
