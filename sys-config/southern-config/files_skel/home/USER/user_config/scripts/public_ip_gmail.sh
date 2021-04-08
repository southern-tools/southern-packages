#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u
shopt -s nullglob

# ********************** variables ********************* 
source ~/.user_config/no_share/public_ip_gmail_variables
to="$email"
from="$email"
ip_file=~/.user_config/no_share/ip_file
current_ip=$(curl https://api.ipify.org/)

# ***************** functions ****************** 
ManageIpFile(){
	if [ -f $ip_file ];	then
			# Si el archivo $ip_file existe, se definen las variables $known_user y known_ip
			known_user=$(cat $ip_file | cut -d "@" -f 1) && \
			known_ip=$(cat $ip_file | cut -d "@" -f 2)
		else
			# Si no existe $ip_file, crearlo
			echo -e $USER"@"$current_ip > $ip_file && \
			# Definir variables
			known_user=$(cat $ip_file | cut -d "@" -f 1) && \
			known_ip=$(cat $ip_file | cut -d "@" -f 2)
	fi
}

DetectChanges(){
	# Detectar el cambio de IP o Usuario
	if [ $current_ip != $known_ip -o $known_user != $USER ]; then
		# Iniciar el servicio Postfix
		sudo rc-service postfix start && \
		# Sobreescribir $ip_file
		echo -e $USER"@"$current_ip > $ip_file && \
		# Notificar el cambio por correo
		echo "The User or the IP Address at $HOSTNAME has changed:
		$USER"@"$current_ip" | sudo mail -s "SOUTHERN TOOLS NOTIFICATION" ${from} ${to} && \
		logger -t ipcheck -- IP changed to $current_ip && \
		# Detener el servicio Postfix
		sleep 10 && sudo rc-service postfix stop
	fi
}

# *************** start of script proper ***************
ManageIpFile
DetectChanges

# **************** end of script proper ****************
