# Cosmic Boot Buildtools

This repository handles patching, building and running U-Boot images.


## Building
Run `make build-emulator` and `make run-emulator` to run the image.

Press `ctrl+a` followed by `c` to enter the qemu monitor. Then write `quit` and press enter to exit.

## TODO:

setenv serverip 10.0.2.2; setenv ipaddr 10.0.2.15; setenv netmask 255.255.255.0; tftpboot $loadaddr main.wasm; wasm $loadaddr $filesize                                               

- Fix memory leak when running wasm multiple times
- Ability to TFTP run a WASM app
- Add bindings to malloc
- Add bindings to TCP sockets (see wget_loop in wget.c)