#!/bin/bash
# Southern Tools
#
#set -x

# Variables
ip_file=~/.user_config/no_share/ip_file
shared_ip_file=~/Remotes/rclone/dropbox_sync/.synchronize/shared_ip_file
current_ip=$(curl https://api.ipify.org/)

# comprobar existencia de $ip_file
if [ -f $ip_file ];	then
		# Si el archivo $ip_file existe, se definen las variables $known_user y known_ip
		known_user=$(cat $ip_file | cut -d "@" -f 1) && \
		known_ip=$(cat $ip_file | cut -d "@" -f 2)
	else
		# Si no existe $ip_file, crearlo
		echo -e $USER"@"$current_ip > $ip_file && \
		# Copiar a Dropbox
		cp $ip_file $shared_ip_file && \
		# Definir variables
		known_user=$(cat $ip_file | cut -d "@" -f 1) && \
		known_ip=$(cat $ip_file | cut -d "@" -f 2) && \
		# Sincronizar
		alacritty -e rclone sync -v ~/Remotes/dropbox_sync/ dropbox:
fi

# Detectar el cambio de ip o de usuario
if [ $current_ip != $known_ip -o $known_user != $USER ]; then
		# Sobreescribir $ip_file
		echo -e $USER"@"$current_ip > $ip_file && \
		# Copiar a dropbox
		cp $ip_file $shared_ip_file && \
		# Sincronizar
		alacritty -e rclone sync -v ~/Remotes/dropbox_sync/ dropbox:
fi
