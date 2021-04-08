#!/bin/bash
# Southern Tools
#

# ********************** source ip and mac ********************* 
source ~/.user_config/no_share/wake_remotes

# *************** Wake remote ***************
wakeonlan -i $ip_1 $mac_1
