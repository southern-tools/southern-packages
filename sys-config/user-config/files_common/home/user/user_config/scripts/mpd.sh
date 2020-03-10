#!/bin/bash
# Southern Tools
#
set -x

mpd ~/.user_config/applications/mpd/mpd.conf
i3-msg 'exec --no-startup-id urxvt -e ncmpcpp -c ~/.user_config/applications/ncmpcpp/config && killall mpd && killall ncmpcpp'
