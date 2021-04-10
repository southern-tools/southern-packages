#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u
shopt -s nullglob

# ********************** variables ********************* 
UserIp=~/.user_config/no_share/UserIp
DropboxFile=~/Remotes/rclone/dropbox_sync/.synchronize/UserIp
CurrentIp=$(curl -s https://api.ipify.org/)

# ***************** functions ****************** 
CheckDropboxFile(){
	echo -e "*** Checking Dropbox data..."
	if [ -f $DropboxFile ]
		then
			ReadDropboxValues
			echo -e "*** Checking local values against Dropbox..."
			if [ $DropboxIp != $StoredIp -o $StoredUser != $DropboxUser ]
				then
					echo -e "*** Local values differ from Dropbox copy."
					PushToDropbox
				else
					echo -e "*** Local values are consistent with Dropbox copy."
			fi
		else
			echo -e "*** Dropbox copy not present."
			PushToDropbox
	fi
}
NewUserIp(){
	echo -e "*** Storing new values..."
	echo -e $USER"@"$CurrentIp > $UserIp
	ReadUserIpValues
}
PushToDropbox(){
	echo -e "*** Pushing to Dropbox: "
	cp -v $UserIp $DropboxFile
	rclone sync -v ~/Remotes/rclone/dropbox_sync/ dropbox:
}
ReadUserIpValues(){
	StoredUser=$(cat $UserIp | cut -d "@" -f 1)
	StoredIp=$(cat $UserIp | cut -d "@" -f 2)
}
ReadDropboxValues(){
	DropboxUser=$(cat $DropboxFile | cut -d "@" -f 1)
	DropboxIp=$(cat $DropboxFile | cut -d "@" -f 2)
}
Wrapper(){
	echo -e "*** Checking previous values..."
	if [ -f $UserIp ]
		then
			ReadUserIpValues
			echo -e "*** Previous User and IP: $StoredUser"@"$StoredIp"
			echo -e "*** Detecting changes..."
			if [ $CurrentIp != $StoredIp -o $StoredUser != $USER ]
				then
					echo -e "*** New User and IP detected: $USER"@"$CurrentIp"
					NewUserIp
					CheckDropboxFile
			else
				echo -e "*** No changes detected."
				CheckDropboxFile
			fi
		else
			echo -e "*** No previous values found."
			NewUserIp
			echo -e "*** New User and IP: $StoredUser"@"$StoredIp"
			CheckDropboxFile
	fi
}

# *************** start of script proper ***************
echo -e "*** Starting Public IP Dropbox..."
Wrapper
echo -e "*** All tasks accomplished."
# **************** end of script proper ****************
