
# Installera linux fryk...
if(UNIX)
    function(add_gdb_target target source)
        find_program(GDB_EXECUTABLE gdb)
        if (GDB_EXECUTABLE)
            set(GDB_TARGET "/dev/serial/by-id/usb-Black_Sphere_Technologies_Black_Magic_Probe_7AB576B4-if00")
            add_custom_target(${target}
                    COMMAND ${GDB_EXECUTABLE} ${source} -batch -ex "target extended-remote  ${GDB_TARGET}" -x ${CMAKE_CURRENT_SOURCE_DIR}/${target}.cmd
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                    DEPENDS ${ARGN}
                    )
        endif ()
    endfunction()
endif()