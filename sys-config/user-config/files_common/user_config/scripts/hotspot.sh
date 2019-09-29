#!/bin/bash
# Southern Tools
#
#set -x

########### Initial wifi interface configuration #############
ip link set $1 down
ip addr flush dev $1
ip link set $1 up
ip addr add 10.0.0.1/24 dev $1

# If you still use ifconfig for some reason, replace the above lines with the following
# ifconfig $1 up 10.0.0.1 netmask 255.255.255.0

sleep 2

########### Start dnsmasq ##########
if [ -z "$(ps -e | grep dnsmasq)" ]
then
 dnsmasq
fi

########### Enable NAT ############
iptables -t nat -A POSTROUTING -o $2 -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $1 -o $2 -j ACCEPT

#nft add table ip nat
#nft add chain ip nat prerouting { type nat hook prerouting priority 0 \; }
#nft add chain ip nat postrouting { type nat hook postrouting priority 100 \; }

# Uncomment the line below if facing problems while sharing PPPoE, see lorenzo's comment for more details
# iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

sysctl -w net.ipv4.ip_forward=1

########## Start hostapd ###########
hostapd -d /etc/hostapd/user_config.conf
killall dnsmasq
