# Use an Ubuntu base image
FROM ubuntu:23.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install RetroArch
RUN apt-get update && \
    apt-get install -y \ 
    mesa-utils-extra \
    retroarch \ 
    libretro-core-info \
    libretro-frontend \
    libglu1-mesa  \
    libusb-1.0-0 \ 
    libaio1 \ 
    libaio-dev \
    x11-utils \
    mesa-vulkan-drivers \ 
    libgbm1 \ 
    libgles2-mesa \ 
    libegl1 \ 
    libgl1-mesa-dri \
    dbus-x11 \
    && rm -rf /var/lib/apt/lists/*

# Run RetroArch
CMD ["retroarch"]
