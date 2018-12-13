//
// Created by atmelfan on 2018-11-25.
//

#ifndef PROJECT_SPIRIT1_H
#define PROJECT_SPIRIT1_H

#include <stdint.h>

typedef enum {
    RADIO_READY = 0,
    RADIO_TRANSMIT,
    RADIO_RECEIVE
} radio_state;

/**
 * Get current state of the radio
 * @return
 */
radio_state radio_current_state();

/**
 * Initialize radio
 */
void radio_init();

/**
 * Start sending data.
 * @param buffer
 * @param len
 */
void radio_send(uint8_t* buffer, uint8_t len);

/**
 * Listen after data
 * @param buffer
 * @param len
 */
void radio_receive(uint8_t* buffer, uint8_t len);

/**
 * Get received data.
 * @param buffer
 * @param len
 * @return
 */
uint8_t radio_get_data(uint8_t* buffer, uint8_t len);

/**
 * Radio interrupt handler
 * Should be called when the radio asserts its nIRQ pin (if available).
 */
void radio_interrupt();






#endif //PROJECT_SPIRIT1_H
