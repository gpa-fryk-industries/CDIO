cmake_minimum_required(VERSION 3.7)
project(src C ASM)

set(CMAKE_C_STANDARD 11)

#Parameters
set(OPT -Os)
set(ASM_OPTIONS "-x assembler-with-cpp")
set(ENABLE_SEMIHOSTING OFF)

### Compiler ###
set(CMAKE_C_COMPILER "arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "arm-none-eabi-g++")
set(CMAKE_ASM_COMPILER "arm-none-eabi-gcc")

### LIBOPENCM3 ###
set(LIBOCM3 ${CMAKE_CURRENT_SOURCE_DIR}/../libopencm3)
set(DEVICE stm32l082kbu)
include(libopencm3.cmake)

#flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OCM3_ARCH_FLAGS} ${OPT} -Wall -fdata-sections -ffunction-sections")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -MMD -MP -Wno-strict-aliasing")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OCM3_DEFS}")
SET(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS} ${ASM_OPTIONS}" )

#linker
set(LIBS "-lc -lm -lnosys")

if (ENABLE_SEMIHOSTING)
    message(WARNING " Semihosting is ENABLED! Will not run without debugger!")
    set(LDFLAGS "${OCM3_DEFS} -specs=nano.specs -specs=rdimon.specs  -nostartfiles -T ${CMAKE_BINARY_DIR}/generated.ld -L ${LIBS} -Wl,-Map=symbols.map,--cref -Wl,--gc-sections -Wl,--print-memory-usage")
    add_definitions(-DENABLE_SEMIHOSTING)
else()
    set(LDFLAGS "${OCM3_DEFS} -specs=nano.specs -specs=nosys.specs  -nostartfiles -T ${CMAKE_BINARY_DIR}/generated.ld -L ${LIBS} -Wl,-Map=symbols.map,--cref -Wl,--gc-sections -Wl,--print-memory-usage")
endif ()


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

# Radio
add_subdirectory(radio)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/radio/SPIRIT1_Library/Inc/)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/radio/SPIRIT1_Util/Inc/)


add_definitions(-DF_CPU=16000000UL)

### Project ###
set(SOURCE_FILES main.c pins.h dumb_delay.h)
add_executable(src ${SOURCE_FILES} ${FPGA_SOURCE} ${RADIO_SOURCE})
add_dependencies(src libopencm3)
target_link_libraries(src ${OCM3_LIBS})
target_link_libraries(src fdt config)
target_link_libraries(src fpga)