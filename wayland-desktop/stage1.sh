#!/bin/sh

WAYLAND_VERSION="1.18.0"
WAYLAND_PROTOCOLS_VERSION="1.20"
WESTON_VERSION="9.0.0"
MESA_VERSION="20201029_d8562b74"
WLROOTS_VERSION="0.11.0"
SWAY_VERSION="1.5"
JSON_C_VERSION="json-c-0.15-20200726"
LIBVA_VERSION="2.9.0"

mkdir -p /home/pi/build


# ---- RASPBERRY PI OS PACKAGES ----

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
sudo apt install \
    libdbus-1-dev \
    libffi-dev \
    libglib2.0-dev \
    libjpeg62-turbo-dev \
    libpam0g-dev \
    libsystemd-dev \
    libudev-dev \
    libxml2-dev \
    libzstd-dev

# python
sudo apt install python3 python3-dev
sudo apt install python3-pip python3-pyudev
sudo pip3 install meson Mako


# ---- WAYLAND ----

cd /home/pi/build
tar xf wayland-${WAYLAND_VERSION}.tar.xz
cd wayland-${WAYLAND_VERSION}
meson build/ -Ddocumentation=false
cd build
ninja
sudo ninja install

cd /home/pi/build
tar xf wayland-protocols-${WAYLAND_PROTOCOLS_VERSION}.tar.xz
cd wayland-protocols-${WAYLAND_PROTOCOLS_VERSION}
./configure --prefix=/usr/local
make
sudo make install


# ---- MESA ----

sudo apt install \
    libdrm2 libdrm-dev \
    libunwind8 libunwind-dev \
    libsensors5 libsensors4-dev lm-sensors

sudo apt install \
    libx11-dev libx11-xcb1 libx11-xcb-dev \
    libxdamage1 libxdamage-dev \
    libxext6 libxext-dev \
    libxrandr2 libxrandr-dev \
    libxrender1 libxrender-dev \
    libxshmfence1 libxshmfence-dev \
    libxxf86vm1 libxxf86vm-dev \
    libxcb1 libxcb1-dev \
    libxcb-dri2-0 libxcb-dri2-0-dev \
    libxcb-dri3-0 libxcb-dri3-dev \
    libxcb-glx0 libxcb-glx0-dev \
    libxcb-present0 libxcb-present-dev \
    libxcb-randr0 libxcb-randr0-dev \
    libxcb-render0 libxcb-render0-dev \
    libxcb-shape0 libxcb-shape0-dev \
    libxcb-shm0 libxcb-shm0-dev \
    libxcb-sync1 libxcb-sync-dev \
    libxcb-xfixes0 libxcb-xfixes0-dev

cd /home/pi/build
tar xf mesa-${MESA_VERSION}.tar.gz
mv $(find * -maxdepth 0 -type d -name 'mesa-*') mesa-${MESA_VERSION}
cd mesa-${MESA_VERSION}
meson build/ -Dplatforms=x11,wayland -Ddri-drivers= -Dgallium-drivers=v3d,vc4,kmsro,swrast \
    -Dvulkan-drivers=broadcom -Dbuildtype=release
cd build
ninja
sudo ninja install


# ---- WESTON ----

sudo apt install \
    libcairo2 libcairo2-dev \
    libcolord2 libcolord-dev \
    liblcms2-2 liblcms2-dev \
    libfontconfig1 libfontconfig1-dev fontconfig \
    libinput10 libinput-dev \
    libpango-1.0-0 libpango1.0-dev \
    libpipewire-0.2-1 libpipewire-0.2-dev \
    libpixman-1-0 libpixman-1-dev \
    libwebp6 libwebp-dev \
    libxcursor1 libxcursor-dev \
    libxcb-composite0 libxcb-composite0-dev \
    libxkbcommon0 libxkbcommon-dev

cd /home/pi/build
tar xf libva-${LIBVA_VERSION}.tar.bz2
cd libva-${LIBVA_VERSION}
./configure --prefix=/usr/local
make
sudo make install

cd /home/pi/build
tar xf weston-${WESTON_VERSION}.tar.xz
cd weston-${WESTON_VERSION}
meson build/ -Dbackend-rdp=false -Dremoting=false
cd build
ninja
sudo ninja install


# ---- wlroots ----

sudo apt install \
    libxcb-xinput0 libxcb-xinput-dev \
    libxcb-icccm4 libxcb-icccm4-dev

cd /home/pi/build
tar xf wlroots-${WLROOTS_VERSION}.tar.gz
cd wlroots-${WLROOTS_VERSION}
meson build/ -Dexamples=false
cd build
ninja
sudo ninja install


# ---- sway ----

# sway requirements
sudo apt install \
    libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-dev

cd /home/pi/build
tar xf json-c-${JSON_C_VERSION}.tar.gz
cd json-c-${JSON_C_VERSION}
mkdir build
cd build
../cmake-configure
make
sudo make install

cd /home/pi/build
tar xf sway-${SWAY_VERSION}.tar.gz
cd sway-${SWAY_VERSION}
meson build/
cd build
ninja
sudo ninja install

