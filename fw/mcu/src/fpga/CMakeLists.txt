# FPGA Configuration image
set(CONFIG_FILE ${CMAKE_CURRENT_SOURCE_DIR}/fpga_conf.bin)


# FPGA Support sources
set(SOURCE_FILES
        ${SOURCE_FILES}
        ${CMAKE_CURRENT_SOURCE_DIR}/fpga.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fpga.h
        ${CMAKE_CURRENT_SOURCE_DIR}/fpga_config.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fpga_config.h
        )
set(FPGA_SOURCE ${SOURCE_FILES} PARENT_SCOPE)

# Link the FPGA configuration image into a library
set(txt ".global FDT_NAME"
        ".global FDT_NAME_END"
        ".section .rodata"
        "FDT_NAME:"
        ".incbin FDT_FILE"
        "FDT_NAME_END:"
        ".previous"
        )
string (REPLACE ";" "\\\\n" txt "${txt}")
add_custom_command(
        OUTPUT fpga_conf.S
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/fpga_conf.bin
        COMMAND echo ${txt} | ${CMAKE_C_COMPILER} -E -o "fpga_conf.S" -DFDT_FILE=\\"${CONFIG_FILE}\\" -DFDT_NAME=fpga_conf -DFDT_NAME_END=fpga_conf_end -
)
message(INFO " FPGA CONFIGURATION @ ${CONFIG_FILE}")
add_library(fpga ${CMAKE_CURRENT_BINARY_DIR}/fpga_conf.S)