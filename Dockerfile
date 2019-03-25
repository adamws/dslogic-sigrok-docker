FROM ubuntu:16.04

RUN apt-get update --fix-missing && \
    apt-get install -y git-core gcc g++ make autoconf autoconf-archive \
      automake libtool pkg-config libglib2.0-dev libglibmm-2.4-dev libzip-dev \
      libusb-1.0-0-dev libftdi1-dev sdcc check doxygen python-numpy \
      python-dev python-gi-dev python-setuptools python3-dev \
      swig default-jdk cmake libboost-test-dev libboost-serialization-dev \
      libboost-filesystem-dev libboost-system-dev libqt5svg5-dev qtbase5-dev \
      usbutils udev wget

RUN groupadd -g 1000 sigrok && \
    mkdir /home/sigrok && \
    useradd -d /home/sigrok -r -u 1000 -g sigrok sigrok && \
    chown -R sigrok:sigrok /home/sigrok

USER sigrok

RUN cd $HOME && \
    git clone git://sigrok.org/sigrok-util && \
    cd sigrok-util/cross-compile/linux && \
    ./sigrok-cross-linux

USER root

RUN cd $HOME && \
    cd /home/sigrok/sigrok-util/firmware/dreamsourcelab-dslogic && \
    PREFIX=/home/sigrok/sr ./sigrok-fwextract-dreamsourcelab-dslogic

USER sigrok

RUN cd $HOME && \
    git clone git://sigrok.org/sigrok-dumps

# needed for usb to work, to be investigated:
USER root

WORKDIR /home/sigrok
