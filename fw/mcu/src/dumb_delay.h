//
// Created by Gustav Palmqvist on 2018-11-29.
//

#ifndef PROJECT_DUMB_DELAY_H
#define PROJECT_DUMB_DELAY_H

#include <stdint.h>
#ifndef F_CPU
#   define F_CPU 48000000UL
#   warning "Am I supposed to fucking guess what frequency you're running at!?"
#endif

/**
 * NOTE: These functions has absolutely NO accuracy what so ever.
 */

/**
 * A dumb fucking delay, nuff said.
 * @param d, number of cycles to wait
 */
static inline void _dumb_delay_cycles(uint32_t d){
    d /= 3;
    while (d--) {
        asm volatile ("");
    }
}

/**
 * A dumb fucking delay, nuff said.
 * @param d, number of us to wait
 */
static inline void _dumb_delay_us(unsigned long d){
    uint32_t c = d*(F_CPU/1000000UL)/3;
    while (c--) {
        asm volatile ("");
    }
}



#endif //PROJECT_DUMB_DELAY_H
