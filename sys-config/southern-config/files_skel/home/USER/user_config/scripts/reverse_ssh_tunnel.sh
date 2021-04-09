#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u
#shopt -s nullglob

# ********************** variables ********************* 
link="https://www.dropbox.com/s/34jbyd1ru10ijsi/UserIp?dl=0"
ServerInfo=~/.user_config/no_share/ServerInfo

# ***************** functions ****************** 


GetServerInfo(){
	wget -O $ServerInfo $link
	user=$(cat $ServerInfo | cut -d "@" -f 1)
	server=$(cat $ServerInfo | cut -d "@" -f 2)
}
StartTunnel(){
	if [[ $(rc-status | grep sshd | grep -o "started") == started ]]
		then
			echo yes
			#ssh -f -N -T -R 10000:localhost:22 $user@$server
	  	else
	  		echo no
			#sudo rc-service sshd start
			#ssh  -f -N -T -R 10000:localhost:22 $user@$server
	fi
}

# *************** start of script proper ***************
echo -e "*** Starting Reverse SSH Tunnel..."
GetServerInfo
StartTunnel
echo -e "*** All tasks accomplished.\n*** Exiting..."
# **************** end of script proper ****************

# WORK IN PROGRESS

