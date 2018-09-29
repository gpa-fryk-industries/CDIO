cmake_minimum_required(VERSION 3.7)
project(src C ASM)

set(CMAKE_C_STANDARD 11)

### Libraries ###
# FDT
add_subdirectory(fdt)
include(fdt/fdt.cmake)

# BMP
include(gdb.cmake)

### Paramaters ###
set(OPT -Os)

### Compiler ###
set(CMAKE_C_COMPILER "arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "arm-none-eabi-g++")
set(CMAKE_ASM_COMPILER "arm-none-eabi-gcc")

### LIBOPENCM3 ###
set(LIBOCM3 ${CMAKE_SOURCE_DIR}/libopencm3)
set(DEVICE stm32l011f4)

# Needed by Libopencm3 script
find_package( PythonInterp 3 REQUIRED )
find_package( PythonLibs 3 REQUIRED )
find_package(Git)

include(libopencm3.cmake)

### linker ###
set(LIBS "-lc -lm -lnosys")
set(LDFLAGS "${OCM3_DEFS} -flto -specs=nano.specs -specs=nosys.specs  -nostartfiles -T ${CMAKE_BINARY_DIR}/generated.ld -L ${LIBS} -Wl,-Map=symbols.map,--cref -Wl,--gc-sections -Wl,--print-memory-usage")

### Compiler flags ###
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OCM3_ARCH_FLAGS} ${OPT} -Wall -fdata-sections -ffunction-sections")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -MMD -MP -flto -Wno-strict-aliasing")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OCM3_DEFS}")

### Linker flags ###
set( CMAKE_CXX_FLAGS  "${LDFLAGS}" )
set( CMAKE_EXE_LINKER_FLAGS  "${LDFLAGS}" )

### Sources ###
set(SOURCE_FILES main.c)
add_executable(src ${SOURCE_FILES})
add_dependencies(src libopencm3)

add_fdt_target(sys config.dts)

target_link_libraries(src ${OCM3_LIBS})
target_link_libraries(src fdt)
target_link_libraries(src sys)

add_gdb_target(bmp_flash ${CMAKE_CURRENT_BINARY_DIR}/src src)