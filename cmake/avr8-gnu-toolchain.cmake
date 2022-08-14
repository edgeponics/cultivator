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

set(MCU atmega328p CACHE STRING "Microcontroller variant")
set(F_CPU 16000000 CACHE STRING "Clock speed (Hz)")

find_program(AVR_CC avr-gcc)
find_program(AVR_CXX avr-g++)
find_program(AVR_AR avr-ar)
find_program(AVR_STRIP avr-strip)
find_program(AVR_OBJCOPY avr-objcopy)
find_program(AVR_OBJDUMP avr-objdump)
find_program(AVR_SIZE avr-size)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)
set(CMAKE_CXX_COMPILER ${AVR_CXX})
set(CMAKE_C_COMPILER ${AVR_CC})
set(CMAKE_ASM_COMPILER ${AVR_CC})

add_definitions(-DF_CPU=${F_CPU}L)

set(COMPILER_FLAGS "-mmcu=${MCU} -ffunction-sections -fdata-sections -Wno-error=narrowing" CACHE STRING "")
set(CMAKE_C_FLAGS "${COMPILER_FLAGS}" CACHE STRING "")
set(CMAKE_C_FLAGS_RELEASE "${COMPILER_FLAGS} -Os")
set(CMAKE_CXX_FLAGS "${COMPILER_FLAGS} -fno-exceptions -fno-threadsafe-statics" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELEASE "-Os")
set(CMAKE_ASM_FLAGS "${COMPILER_FLAGS} -x assembler-with-cpp" CACHE STRING "")
set(CMAKE_EXE_LINKER_FLAGS "-mmcu=${MCU} -Wl,--relax -Wl,--gc-sections -flto" CACHE STRING "")