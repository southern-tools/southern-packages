#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u
shopt -s nullglob

# ********************** variables ********************* 
To=$(neomutt -F ~/.user_config/no_share/neomutt_gmail -Q from | cut -d \" -f 2 | cut -d " " -f 3)
UserIp=~/.user_config/no_share/UserIp
CurrentIp=$(curl -s https://api.ipify.org/)

# ***************** functions ****************** 
CheckUserIp(){
	echo -e "*** Checking stored data..."
	if [ -f $UserIp ]
		then
			StoredUser=$(cat $UserIp | cut -d "@" -f 1)
			StoredIp=$(cat $UserIp | cut -d "@" -f 2)
			echo -e "*** Previous User and IP: $StoredUser"@"$StoredIp"
		else
			echo -e "*** No previous data found.\n *** Storing the variables now..."
			echo -e $USER"@"$CurrentIp > $UserIp
			StoredUser=$(cat $UserIp | cut -d "@" -f 1)
			StoredIp=$(cat $UserIp | cut -d "@" -f 2)
			echo -e "*** New User and IP: $StoredUser"@"$StoredIp"
	fi
}
DetectChangesUserIp(){
	echo -e "*** Detecting changes..."
	if [ $CurrentIp != $StoredIp -o $StoredUser != $USER ]
		then
			echo -e $USER"@"$CurrentIp > $UserIp
			echo -e "*** New User and IP detected: $USER"@"$CurrentIp\n*** Sending email notification..."
			echo "The User and/or the IP Address at $HOSTNAME has changed:
			$USER"@"$CurrentIp" | neomutt -F "~/.user_config/no_share/neomutt_gmail" -s "Public IP Gmail Notification" ${To}
			logger -t ipcheck -- IP changed to $CurrentIp
		else
			echo -e "*** No changes detected."
	fi
}

# *************** start of script proper ***************
echo -e "*** Starting Public IP Gmail..."
CheckUserIp
DetectChangesUserIp
echo -e "*** All tasks accomplished."
# **************** end of script proper ****************
