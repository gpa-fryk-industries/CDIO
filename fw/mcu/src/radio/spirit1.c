//
// Created by atmelfan on 2018-11-25.
//

#include <stdio.h>
#include "spirit1.h"
#include "SPIRIT1_Library/Inc/SPIRIT_Radio.h"
#include "SPIRIT1_Library/Inc/SPIRIT_Config.h"


StatusBytes RadioSpiWriteRegisters(uint8_t address, uint8_t n_regs, uint8_t *buffer) {
    static uint16_t tmpstatus;

    StatusBytes *status = (StatusBytes *) &tmpstatus;


    tmpstatus = (uint16_t) (spirit1.write(WRITE_HEADER) << 8 | spirit1.write(address));

    uint8_t response[n_regs];
    for (int i = 0; i < n_regs; i++) response[i] = (uint8_t) spirit1.write(buffer[i]);



    return *status;
}

StatusBytes RadioSpiReadRegisters(uint8_t address, uint8_t n_regs, uint8_t *buffer) {
    static uint16_t tmpstatus;

    StatusBytes *status = (StatusBytes *) &tmpstatus;

    tmpstatus = (uint16_t) (spirit1.write(READ_HEADER) << 8 | spirit1.write(address));

    for (int i = 0; i < n_regs; i++) buffer[i] = (uint8_t) spirit1.write(0);


    return *status;

}

StatusBytes RadioSpiCommandStrobes(uint8_t cmd_code) {
    static uint16_t tmpstatus;

    StatusBytes *status = (StatusBytes *) &tmpstatus;

    tmpstatus = (uint16_t) (spirit1.write(COMMAND_HEADER) << 8 | spirit1.write(cmd_code));

    return *status;
}

StatusBytes RadioSpiWriteFifo(uint8_t n_regs, uint8_t *buffer) {

    static uint16_t tmpstatus;

    StatusBytes *status = (StatusBytes *) &tmpstatus;

    tmpstatus = (uint16_t) (spirit1.write(WRITE_HEADER) << 8 | spirit1.write(LINEAR_FIFO_ADDRESS));

    uint8_t response[n_regs];
    for (int i = 0; i < n_regs; i++) response[i] = (uint8_t) spirit1.write(buffer[i]);

    return *status;
}

StatusBytes RadioSpiReadFifo(uint8_t n_regs, uint8_t *buffer) {
    static uint16_t tmpstatus;

    StatusBytes *status = (StatusBytes *) &tmpstatus;
    tmpstatus = (uint16_t) (spirit1.write(READ_HEADER) << 8 | spirit1.write(LINEAR_FIFO_ADDRESS));

    //printf("READ %04x=%x (%d)\r\n", LINEAR_FIFO_ADDRESS, status, n_regs);
    for (int i = 0; i < n_regs; i++) buffer[i] = (uint8_t) spirit1.write(0);
    //dbg_dump("READ", buffer, n_regs);

    return *status;
}