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

VERSION 0.6
FROM debian:bullseye-slim
WORKDIR /build

format:
    FROM +tools
    COPY . .
    RUN clang-format -i src/*.cpp
    SAVE ARTIFACT src AS LOCAL src

check:
    FROM +tools
    COPY . .
    RUN cmake -DCMAKE_TOOLCHAIN_FILE=cmake/avr8-gnu-toolchain.cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .
    RUN cppcheck -q --enable=all --project=compile_commands.json --suppress=*:/usr/local/arduino/* --error-exitcode=1

build:
    FROM +tools
    COPY . .
    RUN cmake -Bcmake-build-earthly -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=cmake/avr8-gnu-toolchain.cmake .
    RUN cmake --build cmake-build-earthly --target cultivator-hex
    SAVE ARTIFACT cmake-build-earthly AS LOCAL ./cmake-build-earthly

tools:
    FROM +tools-base
    COPY +cppcheck/bin/cppcheck +cppcheck/bin/dmake /usr/local/bin/
    COPY +cppcheck/bin/cfg /usr/local/share/Cppcheck/cfg
    COPY +cppcheck/bin/addons /usr/local/share/Cppcheck/addons
    ARG AVR_GCC_VERSION=3.7.0.1796
    RUN curl -fsL -o avr8-gnu-toolchain-x86_64.tar.gz "https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/avr8-gnu-toolchain-${AVR_GCC_VERSION}-linux.any.x86_64.tar.gz" \
      && mkdir -p /usr/local/avr8-gnu-toolchain \
      && tar xf avr8-gnu-toolchain-x86_64.tar.gz --strip-components=1 -C /usr/local/avr8-gnu-toolchain \
      && rm -f avr8-gnu-toolchain-x86_64.tar.gz
    ENV PATH=$PATH:/usr/local/avr8-gnu-toolchain/bin
    ARG ARDUINO_VERSION=1.8.5
    GIT CLONE --branch=${ARDUINO_VERSION} https://github.com/arduino/ArduinoCore-avr.git /usr/local/arduino
    SAVE IMAGE cultivator-tools:latest

cppcheck:
    FROM +tools-base
    ARG CPPCHECK_VERSION=2.8.2
    RUN curl -fsL -o cppcheck.tar.gz "https://github.com/danmar/cppcheck/archive/refs/tags/${CPPCHECK_VERSION}.tar.gz" \
      && tar xzf cppcheck.tar.gz \
      && mkdir "cppcheck-${CPPCHECK_VERSION}/build"  \
      && cd "cppcheck-${CPPCHECK_VERSION}/build" \
      && cmake .. \
      && cmake --build .
    SAVE ARTIFACT /build/cppcheck-2.8.2/build/bin

tools-base:
    RUN apt update -y \
      && apt install -y curl git cmake ninja-build build-essential clang-format