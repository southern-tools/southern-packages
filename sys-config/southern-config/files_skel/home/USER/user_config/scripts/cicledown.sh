#!/bin/bash
# Southern Tools
#
#set -x

~/.user_config/no_share/overlay_update.sh ;
vdirsyncer sync user_contacts ;
vdirsyncer sync user_calendar ;
sudo genup -n -p;
sudo /etc/cron.daily/rsnapshot.daily
