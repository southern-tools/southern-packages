#!/bin/bash
# Southern Tools
#
#set -x

# ***************** functions ****************** 
dpms_loop(){
	slock_running=$(pgrep --exact --count slock)
	if [ "$slock_running" -gt "0" ] ; then
		xset dpms force off
	else
		exit ;
	fi
}

# *************** start of script proper ***************
slock & sleep 0.1 && dpms_loop

# **************** end of script proper ****************
