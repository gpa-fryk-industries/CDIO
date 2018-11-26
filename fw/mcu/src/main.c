#include <stdio.h>
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/usart.h>
#include <libopencm3/stm32/i2c.h>

#include "fdt/fdt_utils.h"
#include "fdt/dtb_parser.h"
#include "fpga/fpga_config.h"
#include "pins.h"

FDT_FILE(config);

bool serial_enabled = false;

/* set STM32 to clock by 48MHz from HSI oscillator */
static void clock_setup(void)
{
    rcc_set_sysclk_source(RCC_HSI16);
    rcc_set_mco(RCC_CFGR_MCO_HSI16);
}

void init_gpio(){
    /* Enable GPIO clocks */
    rcc_periph_clock_enable(RCC_GPIOA);
    rcc_periph_clock_enable(RCC_GPIOB);

    /* PB_PMIC_AUX_EN pin */
    gpio_mode_setup(GPIOB, GPIO_MODE_OUTPUT, GPIO_PUPD_PULLDOWN, PB_PMIC_AUX_EN);
    gpio_set_output_options(GPIOB, GPIO_OTYPE_PP, GPIO_OSPEED_LOW, PB_PMIC_AUX_EN);
    gpio_clear(GPIOB, PB_PMIC_AUX_EN);

    /*  */

}

void init_fpga(){
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, PA_FPGA_GCLK);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_100MHZ, PA_FPGA_GCLK);
    gpio_set_af(GPIOA, GPIO_AF0, PA_FPGA_GCLK);

    /* clock output on pin PA8 (allows checking with scope) */
    rcc_set_mco(RCC_CFGR_MCOPRE_DIV1);
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
    /* Init GPIOs with clocks */
    init_gpio();

    /* Parse device tree */
    fdt_header_t* fdt = &config;
    fdt_token* root = fdt_get_tokens(fdt);

    /* Check the 'enable-serial' tag and init usart if found */
    if(fdt_node_get_prop(fdt, root, "enable-serial", false)){
        init_serial();
    }

    /* Check the 'enable-fpga' tag and power-up/configure if found */
    if(fdt_node_get_prop(fdt, root, "enable-fpga", false)){
        gpio_set(GPIOB, PB_PMIC_AUX_EN);
        gpio_set(GPIOB, PA_FPGA_CRESET);
    }else{
        gpio_clear(GPIOB, PB_PMIC_AUX_EN);
        gpio_clear(GPIOB, PA_FPGA_CRESET);
    }

    while(true){
        get_byte(0);
    }

    return 0;
}