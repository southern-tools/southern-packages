#!/bin/bash
# Southern Tools
#
#set -x

mpd ~/.user_config/applications/mpd/mpd.conf
swaymsg 'exec alacritty -e ncmpcpp -c ~/.user_config/applications/ncmpcpp/config && killall mpd && killall ncmpcpp'
