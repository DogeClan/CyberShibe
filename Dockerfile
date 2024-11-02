# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and utilities
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    curl \
    python3 \
    python3-pip \
    nodejs \
    npm \
    shellinabox \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone the desired Git repository
RUN git clone https://github.com/Z4nzu/hackingtool.git

# Set permissions for the cloned repo
RUN chmod -R 755 hackingtool

# Set the working directory to the cloned repo
WORKDIR /hackingtool

# Expose ports required by shellinabox
EXPOSE 4200

# Command to run shellinabox and install hacking tool
CMD ["sudo", "bash", "install.sh", "&&", "sudo", "./hackingtool"]
