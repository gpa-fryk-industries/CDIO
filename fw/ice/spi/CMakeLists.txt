cmake_minimum_required(VERSION 3.7)

set(VHD_SOURCE
        spi_reg.vhd
        spi_testbench.vhd
        )

function(add_ghdl_target target)
    add_custom_target(${target} ALL
            COMMAND ghdl -a ${ARGN}
            COMMAND ghdl -e ${target}
            COMMAND ghdl -r ${target} --vcd=${target}.vcd
            DEPENDS ${ARGN}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            )
endfunction()

add_ghdl_target(spi_testbench ${VHD_SOURCE})