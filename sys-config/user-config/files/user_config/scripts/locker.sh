#!/bin/bash
# Southern Tools
#
#set -x
dpms_loop() {
	slock_running=$(pgrep --exact --count slock)
	if [ "$slock_running" -gt "0" ] ; then
		xset dpms force off
	else
		exit ;
	fi
}


slock & sleep 0.1 && dpms_loop
