cmake_minimum_required(VERSION 3.7)
project(src C ASM)

set(CMAKE_C_STANDARD 11)

#Parameters
set(OPT -Os)
SET(ASM_OPTIONS "-x assembler-with-cpp")

### Compiler ###
set(CMAKE_C_COMPILER "arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "arm-none-eabi-g++")
set(CMAKE_ASM_COMPILER "arm-none-eabi-gcc")

### LIBOPENCM3 ###
set(LIBOCM3 ../libopencm3)
set(DEVICE stm32l082kbu)
include(libopencm3.cmake)

#flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OCM3_ARCH_FLAGS} ${OPT} -Wall -fdata-sections -ffunction-sections")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -MMD -MP -Wno-strict-aliasing")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OCM3_DEFS}")
SET(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS} ${ASM_OPTIONS}" )

#linker
set(LIBS "-lc -lm -lnosys")
set(LDFLAGS "${OCM3_DEFS} -specs=nano.specs -specs=nosys.specs  -nostartfiles -T ${CMAKE_BINARY_DIR}/generated.ld -L ${LIBS} -Wl,-Map=symbols.map,--cref -Wl,--gc-sections -Wl,--print-memory-usage")

#add linker flags
set( CMAKE_CXX_FLAGS  "${LDFLAGS}" )
set( CMAKE_EXE_LINKER_FLAGS  "${LDFLAGS}" )


### Libs ###
# FDT
add_subdirectory(fdt)
include(fdt/fdt.cmake)
add_fdt_target(config config.dts)

# FPGA
add_subdirectory(fpga)

### Project ###
set(SOURCE_FILES main.c pins.h)
add_executable(src ${SOURCE_FILES})
add_dependencies(src libopencm3)
target_link_libraries(src ${OCM3_LIBS})
target_link_libraries(src fdt config)
target_link_libraries(src fpga)