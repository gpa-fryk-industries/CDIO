#include <stdio.h>
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/usart.h>
#include <libopencm3/stm32/i2c.h>

#include "fdt/fdt_utils.h"
#include "fdt/dtb_parser.h"
#include "fpga/fpga_config.h"


#define GPIO_I2C_PORT GPIOA
#define GPIO_I2C_SCL GPIO9
#define GPIO_I2C_SDA GPIO10

#define GPIO_SERIAL_PORT GPIOA
#define GPIO_SERIAL_RXD GPIO13
#define GPIO_SERIAL_TXD GPIO14

#define LED_PORT GPIOA
#define LED_PIN GPIO5

FDT_FILE(config);

void init_gpio(){
    /* Enable GPIO clocks */
    rcc_periph_clock_enable(RCC_GPIOA);
    rcc_periph_clock_enable(RCC_GPIOB);

    /* LED pin */
    gpio_mode_setup(LED_PORT, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, LED_PIN);
    gpio_set_output_options(LED_PORT, GPIO_OTYPE_PP, GPIO_OSPEED_LOW, LED_PIN);
    gpio_clear(LED_PORT, LED_PIN);

}

void init_i2c(){
    /* Configure I2C GPIOs */
    gpio_mode_setup(GPIO_I2C_PORT, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO_I2C_SCL);
    gpio_mode_setup(GPIO_I2C_PORT, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO_I2C_SDA);
    gpio_set_output_options(GPIO_I2C_PORT, GPIO_OTYPE_OD, GPIO_OSPEED_HIGH, GPIO_I2C_SCL | GPIO_I2C_SDA);
    gpio_set_af(GPIO_I2C_PORT, GPIO_AF1, GPIO_I2C_SCL | GPIO_I2C_SDA);

    /* Enable clock */
    rcc_periph_clock_enable(RCC_I2C1);

    /* Configure I2C peripheral */
    i2c_reset(I2C1);

}

static void init_serial(void)
{
    /* Configure serial data pins*/
    gpio_mode_setup(GPIO_SERIAL_PORT, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO_SERIAL_RXD);
    gpio_mode_setup(GPIO_SERIAL_PORT, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO_SERIAL_TXD);
    gpio_set_output_options(GPIO_SERIAL_PORT, GPIO_OTYPE_PP, GPIO_OSPEED_HIGH, GPIO_SERIAL_RXD | GPIO_SERIAL_TXD);
    gpio_set_af(GPIO_SERIAL_PORT, GPIO_AF1, GPIO_SERIAL_RXD | GPIO_SERIAL_TXD);

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

}

int main(){
    /* Init GPIOs with clocks */
    init_gpio();

    /* Init I2C */
    init_i2c();

    /* Init Serial */
    init_serial();

    fdt_header_t* fdt = &config;
    fdt_token* root = fdt_get_tokens(fdt);
    fdt_token* bootmsg = fdt_node_get_prop(fdt, root, "bootmsg", false);


    /* Sanity LED */
    gpio_set(LED_PORT, (uint16_t)get_byte(0));



    while(true){

    }

    return 0;
}