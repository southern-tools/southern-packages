#!/bin/bash
# Southern Tools
#
#set -x

sudo rc-service bluetooth start
bluetoothctl &&
sudo rc-service bluetooth stop
