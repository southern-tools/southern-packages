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

# **************** end of script proper ****************