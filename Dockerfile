### BUILD-LAYER ###
FROM debian:bookworm-slim AS builder

# Set the build arguments
ARG VERSION=2025.01-rc4

# Install git
RUN apt-get update && apt-get install -y patch wget bzip2

# Clone the u-boot repository
WORKDIR /u-boot
RUN wget -q "https://ftp.denx.de/pub/u-boot/u-boot-${VERSION}.tar.bz2"
RUN tar -xf "u-boot-${VERSION}.tar.bz2" --strip-components=1

# Install the base dependencies
RUN apt-get install -y \
    bison \ 
    flex \
    make \
    swig \
    libssl-dev \
    libgnutls28-dev \
    python3-dev \
    python3-setuptools

# Install the cross-compilers
RUN apt-get install -y gcc-x86-64-linux-gnu    
RUN apt-get install -y gcc-arm-linux-gnueabihf
RUN apt-get install -y gcc-aarch64-linux-gnu

# Add the patch files and apply them
COPY patches/*.patch /u-boot/patches/ 
RUN for i in patches/*.patch; do patch -p1 --merge < $i; done

# Build u-boot
ARG DEFCONFIG=qemu-x86_defconfig
ARG CROSS_COMPILE=x86_64-linux-gnu-

RUN make CROSS_COMPILE=$CROSS_COMPILE distclean
RUN make CROSS_COMPILE=$CROSS_COMPILE $DEFCONFIG
RUN make CROSS_COMPILE=$CROSS_COMPILE -j4

### EMULATOR-LAYER ###
FROM debian:bookworm-slim AS emulator

# Install qemu
RUN apt-get update && apt-get install -y qemu-system

# Copy the u-boot binary from the builder layer
COPY --from=builder /u-boot/u-boot.bin* /u-boot/u-boot.rom* /u-boot/

