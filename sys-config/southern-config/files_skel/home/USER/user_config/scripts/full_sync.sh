#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u

# *************** start of script proper ***************
vdirsyncer sync user_contacts ;
vdirsyncer sync user_calendar ;
rclone sync -v ~/Remotes/rclone/dropbox_sync/ dropbox: ;
/home/samuelle/.user_config/scripts/update_git_repos.sh ;
sudo /etc/cron.daily/genup ;
sudo /etc/cron.daily/rsnapshot.daily ;

# **************** end of script proper ****************
