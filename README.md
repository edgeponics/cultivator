# cultivator

An open source drain-to-waste hydroponics controller. Focused on robustness and ease of use.

## Development

### Prerequisites

* [Earthly](https://earthly.dev/)
* [Docker](https://www.docker.com/)

Earthly is used to provide a reproducible build environment for all developers.

### Format

Use clang-format to ensure sure your changes match the style guidelines.

```shell
earthly +format
```

### Static Analysis

Use cppcheck to statically analyze your changes, this will help catch potential issues.

```shell
earthly +check
```

### Build

You can then use the avr-gcc toolchain to compile and link a hex file for flashing to your Arduino compatible device.

```shell
earthly +build
```

The resulting binary will be written to [cmake-build-earthly/cultivator.hex](./cmake-build-earthly/cultivator.hex).