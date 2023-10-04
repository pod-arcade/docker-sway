# Use an Ubuntu base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install RetroArch
RUN apt-get update && \
    apt-get install -y retroarch && \
    rm -rf /var/lib/apt/lists/*

# Run RetroArch
CMD ["retroarch"]
