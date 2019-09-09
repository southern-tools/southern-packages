#!/bin/bash
# Southern Tools
#
#set -x

# Source ip and mac
source ~/.user_config/no_share/wake_remotes

wakeonlan -i $ip_1 $mac_1
