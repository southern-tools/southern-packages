#!/bin/bash
# Southern Tools
#
#set -x

# Variables
encrypted_drive_uuid=1d468191-9e63-4527-966f-ad6ffdad1db0
lsblk &&


menu_loop (){
	PS3='Please enter your choice: '
	options=("Open LUKS container" "Close LUKS container" "Mount unit_1" "Unmount unit_1" "Mount unit_2" "Unmount unit_2" "Mount unit_3" "Unmount unit_3" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"Open LUKS container")
			sudo cryptsetup --key-file /root/.user_config/no_share/luks/encrypted_drive.key luksOpen /dev/disk/by-uuid/$encrypted_drive_uuid encrypted_drive ;
			sudo vgchange --available y vg_encrypted ;
			lsblk
			menu_loop
			;;
			"Close LUKS container")
			sudo vgchange --available n vg_encrypted ;
			sudo cryptsetup luksClose encrypted_drive ;
			lsblk
			menu_loop
			;;
			"Mount unit_1")
			sudo mount -t ext4 /dev/mapper/vg_encrypted-unit_1 /mnt/encrypted_unit_1 ;
			lsblk
			menu_loop
			;;
			"Unmount unit_1")
			sudo umount /mnt/encrypted_unit_1 ;
			lsblk
			menu_loop
			;;
			"Mount unit_2")
			sudo mount -t ext4 /dev/mapper/vg_encrypted-unit_2 /mnt/encrypted_unit_2 ;
			lsblk
			menu_loop
			;;
			"Unmount unit_2")
			sudo umount /mnt/encrypted_unit_2 ;
			lsblk
			menu_loop
			;;
			"Mount unit_3")
			sudo mount -t ext4 /dev/mapper/vg_encrypted-unit_3 /mnt/encrypted_unit_3 ;
			lsblk
			menu_loop
			;;
			"Unmount unit_3")
			sudo umount /mnt/encrypted_unit_3 ;
			lsblk
			menu_loop
			;;
			"Quit")
			sudo umount /mnt/encrypted_unit_1 ;
			sudo umount /mnt/encrypted_unit_2 ;
			sudo umount /mnt/encrypted_unit_3 ;
			sudo vgchange --available n vg_encrypted ;
			sudo cryptsetup luksClose encrypted_drive ;
			lsblk
			exit
			;;
			*) echo invalid option
			;;
			esac
	done
}

menu_loop