#!/bin/sh

# upgrade system
sudo apt update
sudo apt --yes upgrade
sudo apt --yes full-upgrade
sudo apt --yes autoremove
sudo apt clean

# build utilities
sudo apt install build-essential
sudo apt install git bison flex ninja-build cmake llvm valgrind

# development headers for already installed software
sudo apt install libsystemd-dev libudev-dev libffi-dev libxml2-dev libzstd-dev libglib2.0-dev

# x11 development (sources: libx11, libxcb, xcb-util-wm)
sudo apt install libx11-dev libx11-xcb1 libx11-xcb-dev libxcb1-dev \
    libxcb-composite0 libxcb-composite0-dev \
    libxcb-render0 libxcb-render0-dev \
    libxcb-shape0 libxcb-shape0-dev \
    libxcb-shm0 libxcb-shm0-dev \
    libxcb-xfixes0 libxcb-xfixes0-dev \
    libxcb-xinput0 libxcb-xinput-dev \
    libxcb-icccm4 libxcb-icccm4-dev

# mesa requirements
sudo apt install \
    libdrm2 libdrm-dev \
    libunwind8 libunwind-dev \
    libsensors5 libsensors4-dev lm-sensors

# wlroots requirements
sudo apt install \
    libinput10 libinput-dev \
    libxkbcommon0 libxkbcommon-dev \
    libpixman-1-0 libpixman-1-dev

# sway requirements
sudo apt install \
    libfontconfig1 libfontconfig1-dev fontconfig \
    libcairo2 libcairo2-dev \
    libpango-1.0-0 libpango1.0-dev \
    libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-dev

# GTK3 toolkit
sudo apt install \
    libgtk-3-0 libgtk-3-dev

# python
sudo apt install python3 python3-dev
sudo apt install python3-pip python3-pyudev
sudo pip3 install meson Mako

# ---- COMPILE FROM SOURCES ----

WAYLAND_VERSION="1.18.0"
cd /home/pi/build
tar xf wayland-${WAYLAND_VERSION}.tar.xz
cd wayland-${WAYLAND_VERSION}
meson build/ -Ddocumentation=false
cd build
ninja
sudo ninja install

WAYLAND_PROTOCOLS_VERSION="1.20"
cd /home/pi/build
tar xf wayland-protocols-${WAYLAND_PROTOCOLS_VERSION}.tar.xz
cd wayland-protocols-${WAYLAND_PROTOCOLS_VERSION}
./configure --prefix=/usr/local
make
sudo make install

MESA_VERSION="20201029_d8562b74"
cd /home/pi/build
tar xf mesa-${MESA_VERSION}.tar.gz
mv $(find * -maxdepth 0 -type d -name 'mesa-*') mesa-${MESA_VERSION}
cd mesa-${MESA_VERSION}
meson build/ -Dplatforms=wayland -Ddri-drivers= -Dgallium-drivers=v3d,vc4,kmsro,swrast -Dvulkan-drivers=broadcom -Dglx=disabled -Dbuildtype=debug
cd build
ninja
sudo ninja install

WLROOTS_VERSION="0.11.0"
cd /home/pi/build
tar xf wlroots-${WLROOTS_VERSION}.tar.gz
cd wlroots-${WLROOTS_VERSION}
meson build/
cd build
ninja
sudo ninja install

JSON_C_VERSION="json-c-0.15-20200726"
cd /home/pi/build
tar xf json-c-${JSON_C_VERSION}.tar.gz
cd json-c-${JSON_C_VERSION}
mkdir build
cd build
../cmake-configure
make
sudo make install

SWAY_VERSION="1.5"
cd /home/pi/build
tar xf sway-${SWAY_VERSION}.tar.gz
cd sway-${SWAY_VERSION}
meson build/
cd build
ninja
sudo ninja install

