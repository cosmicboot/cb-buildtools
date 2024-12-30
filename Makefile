# Detect if podman or docker is installed
ifeq (, $(shell which podman))
	DOCKER ?= $(shell which docker)
else
	DOCKER ?= $(shell which podman)
endif

UBOOT_VERSION = 2025.01-rc4
QEMU_OPTS = -m 1g -nographic -netdev user,id=net0,tftp=/tftpboot -device e1000,netdev=net0

## U-BOOT
UBOOT_LOCATION = ../u-boot
.PHONY: u-boot
u-boot:
	@rm -rf $(UBOOT_LOCATION) && \
	echo "Downloading U-Boot ${UBOOT_VERSION} to '$(shell readlink -f ${UBOOT_LOCATION})'..." && \
	mkdir -p $(UBOOT_LOCATION) && \
	curl --progress-bar -L "https://ftp.denx.de/pub/u-boot/u-boot-${UBOOT_VERSION}.tar.bz2" | \
	tar -xj --strip-components=1 -C $(UBOOT_LOCATION) && \
	cd $(UBOOT_LOCATION) && \
	git init && \
	git add . && \
	git commit -m "Initial commit" && \
	git tag root && \
	git am ../cb-buildtools/patches/*.patch

.PHONY: patches
patches:
	@rm -rf ../cb-buildtools/patches/*.patch && \
	git -C $(UBOOT_LOCATION) format-patch --output-directory ../cb-buildtools/patches root..HEAD

## ARM
.PHONY: arm-build
arm-build:
	$(DOCKER) build -t cb/buildtools:arm-dev \
		--build-arg CROSS_COMPILE=arm-linux-gnueabihf- \
		--build-arg DEFCONFIG=qemu_arm_defconfig \
		--build-arg VERSION=${UBOOT_VERSION} \
		.

.PHONY: arm-run
arm-run: arm-build
	$(DOCKER) run -it --rm --privileged -v $(shell pwd)/tftpboot:/tftpboot cb/buildtools:arm-dev \
		qemu-system-arm -machine virt ${QEMU_OPTS} -bios /u-boot/u-boot.bin

## AARCH64
.PHONY: aarch64-build
aarch64-build:
	$(DOCKER) build -t cb/buildtools:aarch64-dev \
		--build-arg CROSS_COMPILE=aarch64-linux-gnu- \
		--build-arg DEFCONFIG=qemu_arm64_wasm_defconfig \
		.

.PHONY: aarch64-run
aarch64-run: aarch64-build
	$(DOCKER) run -it --rm --privileged -v $(shell pwd)/tftpboot:/tftpboot cb/buildtools:aarch64-dev \
		qemu-system-aarch64 -machine virt -cpu cortex-a57 ${QEMU_OPTS} -bios /u-boot/u-boot.bin

## X86
.PHONY: build
build:
	$(DOCKER) build -t cb/buildtools:x86_64-dev \
		--build-arg CROSS_COMPILE=x86_64-linux-gnu- \
		--build-arg DEFCONFIG=qemu-x86_wasm_defconfig \
		. 

.PHONY: run
run: build
	$(DOCKER) run -it --rm --privileged -v $(shell pwd)/tftpboot:/tftpboot cb/buildtools:x86_64-dev \
		qemu-system-i386 ${QEMU_OPTS} -machine pc -bios /u-boot/u-boot.rom

.PHONY: shell
shell:
	$(DOCKER) run -it --rm --privileged -v $(shell pwd)/tftpboot:/tftpboot cb/buildtools:x86_64-dev /bin/bash

## Rust
.PHONY: rust
rust:
	cd rust_payload && \
	cargo build --target wasm32-unknown-unknown && \
	cp target/wasm32-unknown-unknown/debug/rustwasm.wasm ../tftpboot/main.wasm