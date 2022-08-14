# Copyright (C) 2022 Damian Peckett <damian@pecke.tt>
# SPDX-License-Identifier: GPL-3.0-or-later
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set(ARDUINO_BOARD_VARIANT uno CACHE STRING "Arduino board variant")

set(ARDUINO_SDK_PATH /usr/local/arduino CACHE STRING "Path to Arduino SDK")
set(ARDUINO_AVR_CORE_PATH ${ARDUINO_SDK_PATH}/cores/arduino)
set(ARDUINO_LIBRARIES_PATH ${ARDUINO_SDK_PATH}/libraries)

add_definitions(-DARDUINO=10607 -DARDUINO_ARCH_AVR)

if (${ARDUINO_BOARD_VARIANT} STREQUAL uno)
    set(ARDUINO_VARIANT_PATH ${ARDUINO_SDK_PATH}/variants/standard)
    add_definitions(-DARDUINO_AVR_UNO -D__AVR_ATmega328P__)
else ()
    message(FATAL_ERROR "Board variants other than uno are not yet implemented")
endif ()

file(GLOB_RECURSE ARDUINO_SRCS
        ${ARDUINO_AVR_CORE_PATH}/*.c ${ARDUINO_AVR_CORE_PATH}/*.cpp ${ARDUINO_AVR_CORE_PATH}/*.S
        ${ARDUINO_LIBRARIES_PATH}/**/*.cpp)

add_library(arduino ${ARDUINO_SRCS})
target_include_directories(arduino PUBLIC
        ${ARDUINO_AVR_CORE_PATH} ${ARDUINO_VARIANT_PATH}
        ${ARDUINO_LIBRARIES_PATH}/EEPROM/src ${ARDUINO_LIBRARIES_PATH}/HID/src
        ${ARDUINO_LIBRARIES_PATH}/SoftwareSerial/src ${ARDUINO_LIBRARIES_PATH}/SPI/src
        ${ARDUINO_LIBRARIES_PATH}/Wire/src)

function(add_executable_arduino NAME)
    add_executable(${NAME} ${ARGN})
    set_target_properties(${NAME} PROPERTIES OUTPUT_NAME "${NAME}.elf")
    set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${NAME}.hex")
    target_link_libraries(${NAME} arduino)

    add_custom_command(
            OUTPUT ${NAME}.hex
            COMMAND ${AVR_STRIP} "${NAME}.elf"
            COMMAND ${AVR_OBJCOPY} -O ihex "${NAME}.elf" "${NAME}.hex"
            COMMAND ${AVR_SIZE} --mcu=${MCU} -C --format=avr "${NAME}.elf"
            DEPENDS ${NAME})
    add_custom_target(${NAME}-hex ALL DEPENDS ${NAME}.hex)
endfunction(add_executable_arduino)