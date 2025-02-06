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


- Find out where this error occured:
Synchronous Abort" handler, esr 0x96000050, far 0xeee0a010
elr: 0000000000032d94 lr : 000000000002addc (reloc)
elr: 000000007f6d8d94 lr : 000000007f6d0ddc
x0 : 000000006f66e4f0 x1 : 000000006f66e5a0
x2 : 000000007f79ba71 x3 : 0000000000000011
x4 : 000000007f79bb20 x5 : 000000007f79bb20
x6 : 0000000000000024 x7 : 000000007f79bd50
x8 : 000000007f79ba70 x9 : fffffffffffffff0
x10: 000000000000000d x11: 0000000000000006
x12: 0000000000000002 x13: 000000006f565df0
x14: 0000000000000000 x15: 000000006f56510b
x16: 000000007f6b913c x17: 0000000000000000
x18: 000000006f665df0 x19: 000000006f66a820
x20: 00000000000000b1 x21: 0000000000000003
x22: 000000007f79bb10 x23: 000000007f6d0d98
x24: 000000007f7d8bcc x25: 0000000000000000
x26: 0000000000000000 x27: 000000006f694800
x28: 000000006f66e4d0 x29: 000000006f565a40

Code: b2400102 a90206c1 a9009422 f9000c25 (f8246808)