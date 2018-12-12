
# Radio Support sources
set(SOURCE_FILES
        ${SOURCE_FILES}
        ${CMAKE_CURRENT_SOURCE_DIR}/spirit1.c
        ${CMAKE_CURRENT_SOURCE_DIR}/spirit1.h
        )

file(GLOB SPIRIT1_Lib ${CMAKE_CURRENT_SOURCE_DIR}/SPIRIT1_Library/Src/*.c)

set(RADIO_SOURCE ${SOURCE_FILES} ${SPIRIT1_Lib} PARENT_SCOPE)
