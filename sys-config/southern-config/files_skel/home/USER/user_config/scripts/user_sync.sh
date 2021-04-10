#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u

# *************** start of script proper ***************
echo -e "*** Starting User Sync..."
echo -e "*** Synchronizing contacts..."
vdirsyncer sync user_contacts ;
echo -e "*** Synchronizing calendars..."
vdirsyncer sync user_calendar ;
echo -e "*** Pushing local changes to Dropbox..."
rclone sync -v ~/Remotes/rclone/dropbox_sync/ dropbox: ;
echo -e "*** Updating Git repositories..."
/home/samuelle/.user_config/scripts/update_git_repos.sh ;
echo -e "*** All tasks accomplished."
# **************** end of script proper ****************