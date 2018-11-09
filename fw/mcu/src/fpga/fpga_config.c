//
// Created by atmelfan on 2018-11-10.
//

#include <sched.h>
#include <stdbool.h>
#include "fpga_config.h"


extern uint8_t* fpga_conf;

char get_byte(uint32_t x){
    return fpga_conf[x];
}

bool fpga_configure(){
    return false;
}