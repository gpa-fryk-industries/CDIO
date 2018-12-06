#include <stdio.h>
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/usart.h>
#include <libopencm3/stm32/i2c.h>

#include "fdt/fdt_utils.h"
#include "fdt/dtb_parser.h"
#include "fpga/fpga_config.h"
#include "pins.h"
#include "dumb_delay.h"

FDT_FILE(config);

bool serial_enabled = false;

extern uint8_t fpga_conf[];
extern uint8_t fpga_conf_end;

/**
 * Initialize clocks
 */
static void init_clocks(void)
{
    /* Set sysclock to internal 16MHz oscillator*/
    rcc_set_sysclk_source(RCC_HSI16);
    RCC_CR &= ~RCC_CR_HSI16DIVEN;

    rcc_periph_clock_enable(RCC_GPIOA);
    //rcc_periph_clock_enable(RCC_AF);


    /* PA_FPGA_GCLK, MCO output */
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, PA_FPGA_GCLK);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_100MHZ, PA_FPGA_GCLK);
    gpio_set_af(GPIOA, GPIO_AF0, PA_FPGA_GCLK);

    /* Configure MCO = sysclk / 4 = 4 MHz */
    //rcc_set_mco(RCC_CFGR_MCO_SYSCLK); //Doesn't work for shit,
    RCC_CFGR |= (RCC_CFGR_MCO_SYSCLK << RCC_CFGR_MCO_SHIFT) | (RCC_CFGR_MCOPRE_DIV1 << 28);

}

/**
 * Initialize gpios (not pins!)
 */
void init_gpio(){
    /* Enable GPIO clocks */

    rcc_periph_clock_enable(RCC_GPIOB);
}

/**
 * Initialize SPI pins and relevant chip select pins
 */
void init_spi_pins(){

    /* PA_SPI_SCK pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_PULLDOWN, PA_SPI_SCK);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_LOW, PA_SPI_SCK);
    gpio_clear(GPIOA, PA_SPI_SCK);
    //gpio_set_af(GPIOA, 0, PA_SPI_SCK);

    /* PA_SPI_MOSI pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_PULLDOWN, PA_SPI_MOSI);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_LOW, PA_SPI_MISO);
    gpio_clear(GPIOA, PA_SPI_MOSI);
    //gpio_set_af(GPIOA, 0, PA_SPI_MOSI);

    /* PA_SPI_MISO pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_INPUT, GPIO_PUPD_PULLDOWN, PA_SPI_MISO);
    //gpio_set_af(GPIOA, 0, PA_SPI_MISO);


    /** FPGA **/
    /* PA_FPGA_CSS pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_PULLDOWN, PA_FPGA_CSS);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_LOW, PA_FPGA_CSS);
    gpio_clear(GPIOA, PA_FPGA_CSS); /* Deselect fpga */

    /** RADIO **/
    /* PA_RADIO_CS pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_PULLDOWN, PA_RADIO_CS);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_LOW, PA_RADIO_CS);
    gpio_set(GPIOA, PA_RADIO_CS); /* Deselect fpga */


}

/**
 * Shift 8bit to FPGA
 * @param b
 */
void fpga_shift8(uint8_t b){

    /* TODO: refactor this shit */
    for (int i = 0; i < 8; ++i) {

        /* Set SCK LOW */
        gpio_clear(GPIOA, PA_SPI_SCK);

        /* Output high bit to MOSI */
        if(b & 0x80)
            gpio_set(GPIOA, PA_SPI_MOSI);
        else
            gpio_clear(GPIOA, PA_SPI_MOSI);

        /* Wait half t_sck */
        _dumb_delay_cycles(8);

        /* Set SCK HIGH */
        gpio_set(GPIOA, PA_SPI_SCK);

        /* Wait half t_sck */

        _dumb_delay_cycles(8);


        /* Shift up by one */
        b <<= 1;
    }
}

bool config_fpga(){
    /* Pull select low */
    gpio_clear(GPIOA, PA_FPGA_CSS);

    /* Generate a creset pulse */
    _dumb_delay_us(20);
    gpio_clear(GPIOA, PA_FPGA_CRESET);
    _dumb_delay_us(20);
    gpio_set(GPIOA, PA_FPGA_CRESET);

    /* Wait atleast 1200us for the FPGA to clear its memory */
    _dumb_delay_us(1200);

    /* Pull CSS high, send 8 dummy bits, pull SCK low*/
    gpio_set(GPIOA, PA_FPGA_CSS);
    fpga_shift8(0x00);
    gpio_clear(GPIOA, PA_FPGA_CSS);

    /* Send configuration image */
    for (unsigned long j = 0; j < (&fpga_conf_end - fpga_conf); ++j) {
        fpga_shift8(((uint8_t*)fpga_conf)[j]);
    }

    /*Send 104 (> 100) dummy clocks */
    gpio_set(GPIOA, PA_FPGA_CSS);
    for (int i = 0; i < 13; ++i) {
        fpga_shift8(0x00);
    }

    bool cdone = (gpio_port_read(GPIOA) & PA_FPGA_CDONE) != 0;

    /* Send 56 clocks */
    for (int i = 0; i < 7; ++i) {
        fpga_shift8(0x00);
    }

    /* CDONE should be high or we've fucked up */
    return cdone;
}

bool init_fpga(bool enable){

    /* PB_PMIC_AUX_EN pin */
    gpio_mode_setup(GPIOB, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, PB_PMIC_AUX_EN);
    gpio_set_output_options(GPIOB, GPIO_OTYPE_PP, GPIO_OSPEED_LOW, PB_PMIC_AUX_EN);
    gpio_clear(GPIOB, PB_PMIC_AUX_EN);

    /* PA_FPGA_CRESET pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, PA_FPGA_CRESET);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_LOW, PA_FPGA_CRESET);
    gpio_clear(GPIOA, PA_FPGA_CRESET);

    /* PA_FPGA_CDONE pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_INPUT, GPIO_PUPD_PULLUP, PA_FPGA_CDONE);

    /* Enable power to FPGA but keep in reset */
    if(enable){
        gpio_set(GPIOB, PB_PMIC_AUX_EN);
    }else{
        gpio_clear(GPIOB, PB_PMIC_AUX_EN);
    }
    gpio_clear(GPIOA, PA_FPGA_CRESET);

    return true;
}

static void init_serial(void)
{
    /* Configure serial data pins*/
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, PA_SERIAL_RXD);
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, PA_SERIAL_TXD);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_HIGH, PA_SERIAL_RXD | PA_SERIAL_TXD);
    gpio_set_af(GPIOA, GPIO_AF1, PA_SERIAL_RXD | PA_SERIAL_TXD);

    /* Serial */
    rcc_periph_clock_enable(RCC_USART1);

    /* Configure USART peripheral, 9800 8N1 */
    usart_set_mode(USART1, USART_MODE_TX_RX);
    usart_set_baudrate(USART1, 9800);
    usart_set_databits(USART1, 8);
    usart_set_parity(USART1, USART_PARITY_NONE);
    usart_set_stopbits(USART1, USART_STOPBITS_1);

    /* Enable */
    usart_enable(USART1);
    serial_enabled = true;
}

int main(){

    init_clocks();

    /* Init GPIOs with clocks */
    init_gpio();

    /* Parse device tree */
    fdt_header_t* fdt = &config;
    fdt_token* root = fdt_get_tokens(fdt);

    /* Check the 'enable-serial' tag and init usart if found */
    if(fdt_node_get_prop(fdt, root, "enable-serial", false)){
        init_serial();
    }

    init_spi_pins();

    /* Check the 'enable-fpga' tag and power-up/configure if found */
    if(fdt_node_get_prop(fdt, root, "enable-fpga", false)){
        init_fpga(true);
        if(fdt_node_get_prop(fdt, root, "config-fpga", false)){
            config_fpga();
        }
    }else{
        init_fpga(false);
    }

    gpio_clear(GPIOA, PA_FPGA_CSS);
    while(true){
        _dumb_delay_us(100);
        fpga_shift8(0xAF);
        _dumb_delay_us(100);
        fpga_shift8(0x00);
    }

    return 0;
}