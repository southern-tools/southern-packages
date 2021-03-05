#!/bin/bash
# Southern Tools
#
#set -x

# !/bin/sh
# extend non-HiDPI external display on DP* above HiDPI internal display eDP*
# see also https://wiki.archlinux.org/index.php/HiDPI
# you may run into https://bugs.freedesktop.org/show_bug.cgi?id=39949
#                  https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/883319

EXT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^eDP | head -n 1`
INT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^DP | head -n 1`

ext_w=`xrandr | sed 's/^'"${EXT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
ext_h=`xrandr | sed 's/^'"${EXT}"' [^0-9]* [0-9]\+x\([0-9]\+\).*$/\1/p;d'`
int_w=`xrandr | sed 's/^'"${INT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
off_w=`echo $(( ($int_w-$ext_w)/2 )) | sed 's/^-//'`

# Automatic
#xrandr --noprimary --output "${INT}" --auto --pos ${off_w}x${ext_h} --scale 1x1 --output "${EXT}" --auto --right-of "${INT}" --scale 2x2 --pos 0x0

# Manual
#xrandr --output "eDP1" --noprimary --mode 3840x2160 --pos 0x0 --output "HDMI1" --mode 1920x1080 --pos 3840x0 --scale 2x2 --right-of "eDP1"

# Intel DDX
xrandr --output "eDP1" --noprimary --mode 3840x2160 --pos 0x0 --output "HDMI1" --mode 1280x720 --pos 3840x0 --scale 2x2 --right-of "eDP1"

# Modesetting DDX
#xrandr --output "eDP-1" --noprimary --mode 3840x2160 --pos 0x0 --output "HDMI-1" --mode 1280x720 --pos 3840x0 --scale 2x2 --right-of "eDP-1"

# Arandr result
#xrandr --output eDP1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --output HDMI1 --mode 1920x1080 --pos 3840x0 --rotate normal --output VIRTUAL1 --off