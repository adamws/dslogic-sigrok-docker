#!/bin/bash

SIGROK_HOME=/home/sigrok

DSLOGIC_USB_INFO=$(lsusb | grep "ID 2a0e:0020")
DSLOGIC_BUS=$(echo $DSLOGIC_USB_INFO | sed 's/Bus \([0-9]*\).*/\1/')
DSLOGIC_DEVICE=$(echo $DSLOGIC_USB_INFO | sed 's/.*Device \([0-9]*\).*/\1/')

docker run --rm --net=host --env="DISPLAY" --env="LD_LIBRARY_PATH=$SIGROK_HOME/sr/lib" \
  --device /dev/bus/usb/${DSLOGIC_BUS}/${DSLOGIC_DEVICE} \
  --volume="$HOME/.Xauthority:$SIGROK_HOME/.Xauthority:rw" \
  dslogic $SIGROK_HOME/sr/bin/pulseview

