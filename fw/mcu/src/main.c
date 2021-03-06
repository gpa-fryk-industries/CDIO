#include <stdio.h>
#include <libopencm3/cm3/nvic.h>
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/usart.h>
#include <libopencm3/stm32/i2c.h>
#include <libopencm3/stm32/spi.h>
#include <libopencm3/stm32/exti.h>
#include <libopencm3/stm32/l0/timer.h>




#include "fdt/fdt_utils.h"
#include "fdt/dtb_parser.h"
#include "fpga/fpga_config.h"
#include "pins.h"
#include "dumb_delay.h"
#include "radio/SPIRIT1_Library/Inc/SPIRIT_Config.h"
#include "radio/spirit1.h"
#include "fpga/fpga.h"

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
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_HIGH, PA_SPI_SCK);
    gpio_clear(GPIOA, PA_SPI_SCK);
    //gpio_set_af(GPIOA, 0, PA_SPI_SCK);

    /* PA_SPI_MOSI pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_PULLDOWN, PA_SPI_MOSI);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_HIGH, PA_SPI_MISO);
    gpio_clear(GPIOA, PA_SPI_MOSI);
    //gpio_set_af(GPIOA, 0, PA_SPI_MOSI);

    /* PA_SPI_MISO pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_INPUT, GPIO_PUPD_PULLDOWN, PA_SPI_MISO);
    //gpio_set_af(GPIOA, 0, PA_SPI_MISO);


    /** FPGA **/
    /* PA_FPGA_CSS pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_PULLDOWN, PA_FPGA_CSS);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_HIGH, PA_FPGA_CSS);
    gpio_clear(GPIOA, PA_FPGA_CSS); /* Select fpga */

    /** RADIO **/
    /* PA_RADIO_CS pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_PULLDOWN, PA_RADIO_CS);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_HIGH, PA_RADIO_CS);
    gpio_set(GPIOA, PA_RADIO_CS); /* Deselect radio */

    /* PA_RADIO_SHD pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, PA_RADIO_SHD);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_HIGH, PA_RADIO_SHD);
    gpio_set(GPIOA, PA_RADIO_SHD); /* Disable radio */
    _dumb_delay_us(100);
    gpio_clear(GPIOA, PA_RADIO_SHD); /* Enable radio */


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

    /* PB_FPGA_RST pin */
    gpio_mode_setup(GPIOB, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, PB_FPGA_RST);
    gpio_set_output_options(GPIOB, GPIO_OTYPE_PP, GPIO_OSPEED_LOW, PB_FPGA_RST);
    gpio_clear(GPIOB, PB_FPGA_RST);

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

/**
 * Initialize hardware SPI for use with FPGA and the Radio.
 * NOTE! Must be done AFTER FPGA initialization due to some weird spi things
 * required by said initialization which is bitbanged.
 */
static void init_spi(){

    /* Reinitialize SPI pins to AF mode */
    /* PA_SPI_SCK pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_PULLDOWN, PA_SPI_SCK);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_HIGH, PA_SPI_SCK);
    gpio_set_af(GPIOA, GPIO_AF0, PA_SPI_SCK);

    /* PA_SPI_MOSI pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_PULLDOWN, PA_SPI_MOSI);
    gpio_set_output_options(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_HIGH, PA_SPI_MISO);
    gpio_set_af(GPIOA, GPIO_AF0, PA_SPI_MOSI);

    /* PA_SPI_MISO pin */
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_PULLDOWN, PA_SPI_MISO);
    gpio_set_af(GPIOA, GPIO_AF0, PA_SPI_MISO);

    /* Enable clock */
    rcc_periph_clock_enable(RCC_SPI1);

    /* Reset SPI, defaults to disabled */
    spi_reset(SPI1);

    /* Init SPI to  */
    spi_init_master(SPI1, SPI_CR1_BAUDRATE_FPCLK_DIV_64, SPI_CR1_CPOL_CLK_TO_0_WHEN_IDLE,
                    SPI_CR1_CPHA_CLK_TRANSITION_1, SPI_CR1_DFF_8BIT, SPI_CR1_MSBFIRST);

    /* We'll control chip select. NSS(internal) needs to be set high because it's to retarded to do it itself */
    spi_enable_software_slave_management(SPI1);
    spi_set_nss_high(SPI1);

    /* Enable SPI */
    spi_enable(SPI1);
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

void init_radio(){
    /* PB_RADIO_TXR pin */
    gpio_mode_setup(GPIOB, GPIO_MODE_INPUT, GPIO_PUPD_PULLUP, PB_RADIO_TXR);

    /* Configure EXTI7 source. */
    nvic_enable_irq(NVIC_EXTI4_15_IRQ);
    exti_select_source(EXTI7, GPIOB);

    /* Interrupt on falling edge */
    exti_set_trigger(EXTI7, EXTI_TRIGGER_FALLING);

    /* Enable interrupt */
    exti_enable_request(EXTI7);
}

void exti4_15_isr(void)
{
    if(exti_get_flag_status(EXTI7)){
        exti_reset_request(EXTI7);

        radio_interrupt();
    }
}


void init_lptim(){

    /* Enable LPTIM1 clock */
    rcc_periph_clock_enable(RCC_LPTIM1);

    /* Reset LPTIM1 to defaults. */
    rcc_periph_reset_pulse(RST_LPTIM1);


    /* Reset count */
    timer_set_counter(LPTIM1_BASE, 0);




    /* Clear current count */
    LPTIM1_CNT = 0;

    /* Prescale with 128 */
    LPTIM1_CFGR |= LPTIM_CFGR_PRESC_128;

    /* Start timer */
    LPTIM1_CR |= LPTIM_CR_ENABLE;

    /* Enable LPTIM1 interrupts. */
    nvic_enable_irq(NVIC_LPTIM1_IRQ);
    nvic_set_priority(NVIC_LPTIM1_IRQ, 1);
}

void lptim1_isr(void){

}

#ifdef ENABLE_SEMIHOSTING
    extern void initialise_monitor_handles(void); /* prototype */
#   warning "Semihosting is ENABLED! Will not run without debugger!"
#endif

int main(){


#ifdef ENABLE_SEMIHOSTING
    initialise_monitor_handles();
#endif


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

    /* Init SPI pins for FPGA configuration */
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

    /* Deselect FPGA and Radio */
    gpio_set(GPIOA, PA_FPGA_CSS);
    gpio_set(GPIOA, PA_RADIO_CS);

    /* Init hw SPI (note: reinitializes some SPI pins, cannot be called before config_fpga()) */
    init_spi();
    spi_set_nss_high(SPI1);

    _dumb_delay_us(100);

    //SpiritSpiCommandStrobes(COMMAND_SRES);

    //SpiritManagementWaExtraCurrent();

    //SpiritRadioSetXtalFrequency(50000000);

    /* Init Radio */
    //radio_init();

    char wtest[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
    char rtest[12];

    //radio_send((uint8_t *) test, 12);
    /* Radio stays in LOCKWON state, try to force it to TX state *
     * Doesn't work for shit...
     */
//    StatusBytes s;
//    do{
//        s = RadioSpiCommandStrobes(COMMAND_TX);
//    }while(s.MC_STATE != MC_STATE_TX);

    fpga_reset();

    /* Loop */
    while(true){

        for (int i = 0; i < 12; ++i) {

            /*  */
            fpga_write((uint8_t *) &wtest[i], 2);
            _dumb_delay_us(10000);

        }



        /*  */
        fpga_read((uint8_t *) &rtest, 12);


    }

    return 0;
}