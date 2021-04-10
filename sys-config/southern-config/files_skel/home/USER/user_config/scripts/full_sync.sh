#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u

# *************** start of script proper ***************
echo -e "*** Starting Full System Sync..."
/home/samuelle/.user_config/scripts/user_sync.sh ;
echo -e "*** Updating and Ugrading the system..."
sudo genup ;
echo -e "*** Updating the daily backups..."
sudo /etc/cron.daily/rsnapshot.daily ;
echo -e "*** All tasks accomplished."
# **************** end of script proper ****************
