#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u

# ***************** functions ****************** 

# *************** start of script proper ***************
vdirsyncer sync user_contacts ;
vdirsyncer sync user_calendar ;
/home/samuelle/.user_config/scripts/update_git_repos.sh ;
sudo genup ;
sudo /etc/cron.daily/rsnapshot.daily ;

# **************** end of script proper ****************
