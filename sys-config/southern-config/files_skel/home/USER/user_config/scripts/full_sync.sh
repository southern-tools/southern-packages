#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u

# *************** start of script proper ***************
/home/samuelle/.user_config/scripts/user_sync.sh ;
sudo genup ;
sudo /etc/cron.daily/rsnapshot.daily ;

# **************** end of script proper ****************
