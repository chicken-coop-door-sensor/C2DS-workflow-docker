FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install dependencies
RUN apt-get update && apt-get install -y \
    git wget flex bison gperf python3 python3-pip python3-setuptools cmake \
    ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0 tzdata python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install ESP-IDF
RUN git clone --recursive https://github.com/espressif/esp-idf.git /opt/esp-idf \
    && cd /opt/esp-idf \
    && ./install.sh

# Set environment variables for ESP-IDF
ENV IDF_PATH=/opt/esp-idf
ENV PATH=$IDF_PATH/tools:$IDF_PATH/components/esptool_py/esptool:$PATH

# Create a symbolic link for python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install Python packages
RUN pip3 install --upgrade pip
RUN pip3 install wheel

# Source the export script in the profile
RUN echo ". /opt/esp-idf/export.sh" >> /etc/profile

# Set the working directory
WORKDIR /workspace

# Entry point to use bash
CMD ["bash"]
