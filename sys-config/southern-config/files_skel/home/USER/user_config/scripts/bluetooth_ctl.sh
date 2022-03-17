#!/bin/bash
# Southern Tools
#
#set -x

#sudo rc-service bluetooth start
sudo systemctl bluetooth start
bluetoothctl &&
#sudo rc-service bluetooth stop
sudo systemctl bluetooth stop
