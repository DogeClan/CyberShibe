# Use the official Debian Bullseye Slim image as the base
FROM debian:bullseye-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# Install necessary packages for building ttyd and other dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    cmake \
    g++ \
    gcc \
    make \
    ninja-build \
    libjson-c-dev \
    libwebsockets-dev \
    sudo \
    python3 \
    python3-pip \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone the ttyd repository
RUN git clone https://github.com/tsl0922/ttyd.git /ttyd

# Change working directory to ttyd
WORKDIR /ttyd

# Build ttyd
RUN mkdir build && cd build && \
    cmake .. && \
    make && \
    make install && \
    cd .. && rm -rf build

# Clone the hackingtool repository
RUN git clone https://github.com/Z4nzu/hackingtool.git /hackingtool

# Set permissions for the cloned hackingtool repository
RUN chmod -R 755 /hackingtool

# Set the working directory to the cloned hackingtool repository
WORKDIR /hackingtool

# Expose the port for ttyd (default is 7681)
EXPOSE 7681

# Create a start script to run the installation script with ttyd
RUN echo '#!/bin/bash\n\
# Start ttyd and execute the installation script within it\n\
ttyd --writable bash -c "sudo bash install.sh; exec bash"' > /start.sh && \
    chmod +x /start.sh

# Set the start script as the CMD entry point
CMD ["/start.sh"]
