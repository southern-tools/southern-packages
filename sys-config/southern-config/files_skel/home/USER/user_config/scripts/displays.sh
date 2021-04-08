#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u

# ********************** variables ********************* 
EXT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^eDP | head -n 1`
INT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^DP | head -n 1`

ext_w=`xrandr | sed 's/^'"${EXT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
ext_h=`xrandr | sed 's/^'"${EXT}"' [^0-9]* [0-9]\+x\([0-9]\+\).*$/\1/p;d'`
int_w=`xrandr | sed 's/^'"${INT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
off_w=`echo $(( ($int_w-$ext_w)/2 )) | sed 's/^-//'`

# *************** start of script proper ***************
# Automatic Screen Resolution
#xrandr --noprimary --output "${INT}" --auto --pos ${off_w}x${ext_h} --scale 1x1 --output "${EXT}" --auto --right-of "${INT}" --scale 2x2 --pos 0x0

# Manual Screen Resolution
# Intel DDX
#xrandr --output "eDP1" --noprimary --mode 3840x2160 --pos 0x0 --output "HDMI1" --mode 1920x1080 --pos 3840x0 --scale 2x2 --right-of "eDP1"

xrandr --output "eDP1" --noprimary --mode 3840x2160 --pos 0x0 --output "HDMI1" --mode 1280x720 --pos 3840x0 --scale 2x2 --right-of "eDP1"

# Modesetting DDX
#xrandr --output "eDP-1" --noprimary --mode 3840x2160 --pos 0x0 --output "HDMI-1" --mode 1280x720 --pos 3840x0 --scale 2x2 --right-of "eDP-1"

# Arandr result DEPRECATED
#xrandr --output eDP1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --output HDMI1 --mode 1920x1080 --pos 3840x0 --rotate normal --output VIRTUAL1 --off