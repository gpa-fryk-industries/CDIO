set(SOURCE_FILES 
        ${SOURCE_FILES}
        ${CMAKE_CURRENT_SOURCE_DIR}/fpga.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fpga.h
        ${CMAKE_CURRENT_SOURCE_DIR}/fpga_config.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fpga_config.h
        )


set(txt ".global FDT_NAME"
        ".section .rodata"
        "FDT_NAME:"
        ".incbin FDT_FILE"
        "1:"
        )
string (REPLACE ";" "\\\\n" txt "${txt}")
add_custom_command(
        OUTPUT fpga_conf.S
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/fpga_conf.bin
        COMMAND echo ${txt} | ${CMAKE_C_COMPILER} -E -o "fpga_conf.S" -DFDT_FILE=\\"${CMAKE_CURRENT_SOURCE_DIR}/fpga_conf.bin\\" -DFDT_NAME=fpga_conf -
)


message(INFO " DTS @ ${CMAKE_CURRENT_BINARY_DIR}/fpga_conf.S")


add_library(fpga ${SOURCE_FILES} ${CMAKE_CURRENT_BINARY_DIR}/fpga_conf.S)