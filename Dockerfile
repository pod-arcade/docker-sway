FROM ubuntu:23.10

# Install all necessary packages
RUN apt-get update && \
    apt-get install -y \
    mesa-utils-extra \
    seatd \
    sway \
    swaybg \
    xwayland \
    xauth \
    x11-xserver-utils \
    libpixman-1-dev \
    wayvnc \
    novnc \
    pulseaudio \
    ffmpeg \
    ca-certificates \
    wf-recorder \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Configured seatd-launch to be able to get kbm
RUN chmod +s /usr/bin/seatd-launch

# Add the background image
ADD background.png /etc/sway/background.png
RUN chmod 644 /etc/sway/background.png

# Configure XWayland
COPY Xwayland /etc/sway/Xwayland
RUN chmod +x /etc/sway/Xwayland
ENV WLR_XWAYLAND=/etc/sway/Xwayland

# Configure Pulse Audio
COPY pulseaudio/* /etc/pulse/
COPY wait-for-pulse.sh /

# Add entrypoint
ADD scripts /scripts
ADD entrypoint.sh /entrypoint.sh

USER root
ENTRYPOINT ["/entrypoint.sh"]
