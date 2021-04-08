#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u
shopt -s nullglob

# ********************** variables ********************* 
source ~/.user_config/no_share/encrypted_drive_variables
mountpoint_1=/mnt/encrypted_unit_1
mountpoint_2=/mnt/encrypted_unit_2
mountpoint_3=/mnt/encrypted_unit_3
luks_container=encrypted_drive
vg_name=vg_encrypted
volume_1=/dev/mapper/vg_encrypted-unit_1
volume_2=/dev/mapper/vg_encrypted-unit_2
volume_3=/dev/mapper/vg_encrypted-unit_3

# ***************** functions ****************** 
menu_loop (){
	lsblk
	PS3='Please enter your choice: '
	options=("Unit_1" "Unit_2" "Unit_3" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"Unit_1")
			clear
			if cat /proc/mounts | grep $mountpoint_1 > /dev/null; 
			then
				sudo umount $mountpoint_1
				echo "*** Unit_1 is now UNMOUNTED ***\n\n\n"
			else
				sudo mount $volume_1 $mountpoint_1
				echo "*** Unit_1 is now MOUNTED ***"
			fi
			menu_loop
			;;
			"Unit_2")
			clear
			if cat /proc/mounts | grep $mountpoint_2 > /dev/null; 
			then
				sudo umount $mountpoint_2
				echo "*** Unit_2 is now UNMOUNTED ***"
			else
				sudo mount $volume_2 $mountpoint_2
				echo "*** Unit_2 is now MOUNTED ***"
			fi
			menu_loop
			;;
			"Unit_3")
			clear
			if cat /proc/mounts | grep $mountpoint_3 > /dev/null; 
			then
				sudo umount $mountpoint_3
				echo "*** Unit_3 is now UNMOUNTED ***"
			else
				sudo mount $volume_3 $mountpoint_3
				echo "*** Unit_3 is now MOUNTED ***"
			fi
			menu_loop
			;;
			"Quit")
			sudo umount $mountpoint_1 ;
			sudo umount $mountpoint_2 ;
			sudo umount $mountpoint_3 ;
			sudo vgchange --activate n $vg_name ;
			sudo cryptsetup luksClose $luks_container ;
			exit
			;;
			*) echo invalid option
			;;
			esac
	done
}

# *************** start of script proper ***************
# Open LUKS and make LVM available
sudo cryptsetup --key-file $encrypted_drive_key_file luksOpen /dev/disk/by-uuid/$encrypted_drive_uuid $luks_container ;
sudo vgchange --activate y $vg_name ;

# Start menu
menu_loop

# **************** end of script proper ****************
