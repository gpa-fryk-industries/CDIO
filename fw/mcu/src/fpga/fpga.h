//
// Created by atmelfan on 2018-11-10.
//

#ifndef PROJECT_FPGA_H
#define PROJECT_FPGA_H

#include <stdint.h>

typedef enum {
    FPGA_COMMAND_NOP,
    FPGA_COMMAND_FLUSH_MIC,
    FPGA_COMMAND_FLUSH_CHX,

    /* Sound control */
    FPGA_COMMAND_MUTE, //Mute microphone
    FPGA_COMMAND_, //
} fpga_command_t;

/**
 * Reset the FPGA by strobing RST
 * Note! Only resets app not the FPGA itself!
 */
void fpga_reset();

/**
 * Read buffer from the FPGA
 * @param buffer
 * @param len
 */
uint8_t fpga_read(uint8_t* buffer, uint8_t len);


/**
 * Write buffer to the FPGA
 * @param buffer
 * @param len
 */
uint8_t fpga_write(uint8_t* buffer, uint8_t len);

/**
 * Write command to the FPGA
 * @param cmd
 */
uint8_t fpga_command(uint8_t cmd);

#endif //PROJECT_FPGA_H
