#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u
shopt -s nullglob

# ********************** variables ********************* 
wireless=$(ls /sys/class/net | grep wl | cut -d ":" -f1)
ethernet=$(ls /sys/class/net | grep en | cut -d ":" -f1)

# ***************** functions ****************** 
MacChanger(){
	PS3='Please enter your choice: '
	options=("Change WiFi MAC" "Restore WiFi MAC" "Change Ethernet MAC" "Restore Ethernet MAC" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"Change WiFi MAC")
			ifconfig $wireless down && sleep 1 && macchanger -r $wireless && sleep 1 && ifconfig $wireless up
			break
			;;
			"Restore WiFi MAC")
			ifconfig $wireless down && sleep 1 && macchanger -p $wireless && sleep 1 && ifconfig $wireless up
			break
			;;
			"Change Ethernet MAC")
			ifconfig $ethernet down && sleep 1 && macchanger -r $ethernet && sleep 1 && ifconfig $ethernet up
			break
			;;
			"Restore Ethernet MAC")
			ifconfig $ethernet down && sleep 1 && macchanger -p $ethernet && sleep 1 && ifconfig $ethernet up
			break
			;;
			"Quit")
			break
			;;
			*) echo invalid option;;
			esac
	done
}

# *************** start of script proper ***************
MacChanger

# **************** end of script proper ****************
