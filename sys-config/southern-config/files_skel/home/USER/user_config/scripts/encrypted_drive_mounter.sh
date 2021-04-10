#!/bin/bash
# Southern Tools
#
#set -x
#set -e
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
OpenAll(){
	echo -e "*** Opening Luks Container..."
	sudo cryptsetup --key-file $encrypted_drive_key_file luksOpen /dev/disk/by-uuid/$encrypted_drive_uuid $luks_container ;
	echo -e "*** Activating Volume Group..."
	sudo vgchange --activate y $vg_name;
	clear
}
CloseAll(){
	clear
	echo -e "*** Unmounting devices..."
	if CheckMounted $volume_1 "$mountpoint_1"; 
		then
			echo -e "*** Unmounting 1st Device..."
			sudo umount $mountpoint_1;
	fi
	if CheckMounted $volume_2 "$mountpoint_2"; 
		then
			echo -e "*** Unmounting 2nd Device..."
			sudo umount $mountpoint_2;
	fi
	if CheckMounted $volume_3 "$mountpoint_3"; 
		then
			echo -e "*** Unmounting 3rd Device..."
			sudo umount $mountpoint_3;
	fi
	echo -e "*** Deactivating Volume Group..."
	sudo vgchange --activate n $vg_name;
	echo -e "*** Closing Luks Container and exiting..."
	sudo cryptsetup luksClose $luks_container;
}
CheckMounted(){
	findmnt -rno SOURCE,TARGET "$1" >/dev/null;
}


menu_loop (){
	echo -e "*** Block devices infromation:"
	lsblk
	echo -e "\n"
	PS3='Please enter your choice: '
	options=("(un)Mount 1st Device" "(un)Mount 2nd Device" "(un)Mount 3rd Device" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"(un)Mount 1st Device")
			clear
			if CheckMounted $volume_1 "$mountpoint_1"; 
			then
				sudo umount $mountpoint_1
				echo -e "*** Encrypted Drive Mounter ***\n*** 1st Device is now UNMOUNTED.\n"
			else
				sudo mount $volume_1 $mountpoint_1
				echo -e "*** Encrypted Drive Mounter ***\n*** 1st Device is now MOUNTED.\n"
			fi
			menu_loop
			;;
			"(un)Mount 2nd Device")
			clear
			if CheckMounted $volume_2 "$mountpoint_2"; 
			then
				sudo umount $mountpoint_2
				echo -e "*** Encrypted Drive Mounter ***\n*** 2nd Device is now UNMOUNTED.\n"
			else
				sudo mount $volume_2 $mountpoint_2
				echo -e "*** Encrypted Drive Mounter ***\n*** 2nd Device is now MOUNTED.\n"
			fi
			menu_loop
			;;
			"(un)Mount 3rd Device")
			clear
			if CheckMounted $volume_3 "$mountpoint_3"; 
			then
				sudo umount $mountpoint_3
				echo -e "*** Encrypted Drive Mounter ***\n*** 3rd Device is now UNMOUNTED.\n"
			else
				sudo mount $volume_3 $mountpoint_3
				echo -e "*** Encrypted Drive Mounter ***\n*** 3rd Device is now MOUNTED.\n"
			fi
			menu_loop
			;;
			"Quit")
			CloseAll
			sleep 3 && 
			exit
			;;
			*) echo invalid option
			;;
			esac
	done
}

# *************** start of script proper ***************
echo -e "*** Encrypted Drive Mounter ***"
OpenAll
echo -e "*** Encrypted Drive Mounter ***\n***Ready...\n"
menu_loop

# **************** end of script proper ****************
