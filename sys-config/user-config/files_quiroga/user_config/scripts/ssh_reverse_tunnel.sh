#!/bin/bash
# Southern Tools
#
#set -x

# Script para crear un tunel inverso destination > source
# Dependencias: openssh, wget
# Opcionales: sshpass

set -x

# Variables
link=https://www.dropbox.com/s/il87h7h4drgjyi4/ip_file?dl=0
server_ip_file=~/.user_config/data/server_ip

# Crear carpeta y descargar fichero
mkdir -p ~/.user_config/data && \
wget -O $server_ip_file $link && \

# definir usuario y servidor
user=$(cat $server_ip_file | cut -d "@" -f 1)
server=$(cat $server_ip_file | cut -d "@" -f 2)

# Comprobar estado del servicio ssh
if [[ $(rc-status | grep sshd | grep -o "started") == started ]]
	then
		# iniciar tunel inverso ssh
		ssh -f -N -T -R 10000:localhost:22 $user@$server
  	else
  		# primero iniciar el  servicio sshd
		sudo rc-service sshd start && \
		# ahora sí iniciar tunel inverso ssh
		ssh  -f -N -T -R 10000:localhost:22 $user@$server
fi
