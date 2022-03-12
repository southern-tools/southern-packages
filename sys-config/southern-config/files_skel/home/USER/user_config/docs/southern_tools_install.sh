# Southern Tools
#
set -x
set -e
set -u
shopt -s nullglob

##### Variables #####
link="https://github.com/southern-tools/user_config.git"
wireless_card="$(ls /sys/class/net | grep wl | cut -d ":" -f1)"
ethernet_card="$(ls /sys/class/net | grep en | cut -d ":" -f1)"
hostname="$(hostname)"
files_skel=$"/var/db/repos/southern-packages/sys-config/southern-config/files_skel"

##### Script #####

# Begining of the script
echo -e "* Welcome, this is the Southern Tools installation script"
echo -e "* First, we need some information to set properly the configurations"
read -p '* Please, enter your user name: ' user_name
read -p '* Please, enter your full name (name and surname): ' user_full_name
read -p '* Please, enter your email address ' user_email
read -p '* Please, enter your email password ' user_email_password


# sudoers instructions
echo -e "* The window manager needs "sudo" for power management so before starting, open a new shell, login as root with \"su -\", execute the command \"visudo\" and append the following lines at the end of the file:\n\n\n\n# Southern Tools\n#\n$user_name ALL=(ALL) ALL\n$user_name ALL=(ALL) NOPASSWD: /usr/sbin/genup, /etc/cron.daily/rsnapshot.daily\n%wheel ALL=(ALL) NOPASSWD: /sbin/halt, /sbin/reboot, /sbin/shutdown\n\n\n\n"

read -rsp $'\n\n\n* Press any key to continue...\n' -n1 key

# Create the folder
mkdir -p ~/.user_config

# Download repo
git clone $link ~/.user_config

# Create "no_share" folder and files
mkdir -p ~/.user_config/no_share
touch ~/.user_config/no_share/aliases
touch ~/.user_config/no_share/ip_file
echo -e "# Southern Tools\n#\n" | tee ~/.user_config/no_share/aliases

# Set executable bit
chmod +x ~/.user_config/desktop_files/*
chmod +x ~/.user_config/dotfiles/*
chmod +x ~/.user_config/scripts/*

# Link desktop files
mkdir -p ~/.local/share/applications/
ln -vsf ~/.user_config/desktop_files/* ~/.local/share/applications/

# Link dotfiles
ln -vsf ~/.user_config/dotfiles/Xresources ~/.Xresources
ln -vsf ~/.user_config/dotfiles/Xresources ~/.Xdefaults
ln -vsf ~/.user_config/dotfiles/bash_profile ~/.bash_profile
ln -vsf ~/.user_config/dotfiles/bashrc ~/.bashrc
ln -vsf ~/.user_config/dotfiles/zshrc ~/.zshrc
ln -vsf ~/.user_config/dotfiles/zprofile ~/.zprofile
ln -vsf ~/.user_config/dotfiles/emacs ~/.emacs
ln -vsf ~/.user_config/dotfiles/rtorrent.rc ~/.rtorrent.rc
ln -vsf ~/.user_config/dotfiles/xinitrc ~/.xinitrc
ln -vsf ~/.user_config/dotfiles/xserverrc ~/.xserverrc

# Udiskie
mkdir -p ~/.config/udiskie/
ln -vsf ~/.user_config/applications/udiskie/config.yml ~/.config/udiskie/config.yml

##### Applications #####



# Setting up configurations for "public_ip_dropbox.sh", rclone need to be configured by the user
mkdir -p ~/Remotes/dropbox_sync
echo -e "* Please, remember to configure 'rclone' with the path '/home/$user_name/Remotes/dropbox_sync'"
# rclone config

# Neomutt configuration
rsync -a ~/.user_config/applications/neomutt/neomutt_gmail_template ~/.user_config/no_share/neomutt_gmail
sed -i "s/USER_FULL_NAME/'$user_full_name'/g" ~/.user_config/no_share/neomutt_gmail
sed -i "s/USER_EMAIL/'$user_email'/g" ~/.user_config/no_share/neomutt_gmail
sed -i "s/USER_EMAIL_PASSWORD/'$user_email_password'/g" ~/.user_config/no_share/neomutt_gmail

# Setting up Alacritty
mkdir -p ~/.config/alacritty/
ln -vsf ~/.user_config/applications/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

# Extensions for vscodium
ln -vsf ~/.user_config/applications/vscodium/product.json ~/.config/VSCodium/product.json

# Setting up zathura
mkdir -p ~/.config/zathura
ln -vsf ~/.user_config/applications/zathura/zathurarc ~/.config/zathura/

# Rtorrent session folder
mkdir -p ~/.config/rtorrent/.session/

# Mpd and ncmpcpp
mkdir -p ~/.config/mpd/playlist
ln -vsf ~/.user_config/applications/mpd/mpd.conf ~/.config/mpd/
#echo -n "# Southern Tools\n#\nuser			"$USER_NAME"\ngroup			"$USER_NAME"" > ~/.user_config/no_share/mpd.conf

# Ranger
mkdir -p ~/.config/ranger
ranger --copy-config=all
sudo mkdir -p /.config/ranger
sudo ranger --copy-config=all

# Redshift
#mkdir -p ~/.config/redshift
#ln -vsf ~/.user_config/applications/redshift/redshift.conf ~/.config/redshift/redshift.conf

# Texstudio (monokai theme and hidpi config)
mkdir -p ~/.config/texstudio
ln -vsf ~/.user_config/applications/texstudio/texstudio.ini ~/.config/texstudio/texstudio.ini

# Sublime_ZK tweaking
# User config
#mkdir -p ~/.config/sublime-text/Packages/User/
# Stop Sublime asking for money 
#ln -vsf ~/.user_config/applications/sublime_text/Preferences.sublime-settings ~/.config/sublime-text/Packages/User/
# Sublime_zk custom template
#ln -vsf ~/.user_config/applications/sublime_text/sublime_zk/sublime_zk.sublime-settings ~/.config/sublime-text/Packages/User/
# Zettelkasten-mode colors DOES NOT WORK ANYMORE
#mkdir -p ~/.config/sublime-text/Packages/sublime_zk
#ln -vsf ~/.user_config/applications/sublime_text/sublime_zk/sublime_zk_results.sublime-settings ~/.config/sublime-text/Packages/sublime_zk/
#ln -vsf ~/.user_config/applications/sublime_text/sublime_zk/sublime_zk_search.sublime-settings ~/.config/sublime-text/Packages/sublime_zk/

# Create misc folders and files
mkdir -p ~/.local/share/fonts

# GTK settings
sudo ln -vsf /usr/share/cursors/xorg-x11 ~/.icons

# Waybar
mkdir -p ~/.config/waybar
ln -vsf ~/.user_config/applications/waybar/config ~/.config/waybar/config
ln -vsf ~/.user_config/applications/waybar/style.css ~/.config/waybar/style.css

# Sway cursors
sudo ln -vsf /usr/share/cursors/xorg-x11/gentoo-silver /usr/share/icons

# GTK2 cursor silver
touch ~/.gtkrc-2.0
sed -i 's/^gtk-theme-name.*$/gtk-theme-name="Adwaita-dark"/' ~/.gtkrc-2.0
sed -i 's/^gtk-icon-theme-name.*$/gtk-icon-theme-name="breeze-dark"/' ~/.gtkrc-2.0
sed -i 's/^gtk-cursor-theme-name.*$/gtk-cursor-theme-name="gentoo-silver"/' ~/.gtkrc-2.0

# GTK3 cursor silver
touch ~/.config/gtk-3.0/settings.ini
sed -i 's/^gtk-theme-name.*$/gtk-theme-name=Adwaita-dark/' ~/.config/gtk-3.0/settings.ini
sed -i 's/^gtk-icon-theme-name.*$/gtk-icon-theme-name=breeze-dark/' ~/.config/gtk-3.0/settings.ini
sed -i 's/^gtk-cursor-theme-name.*$/gtk-cursor-theme-name=gentoo-silver/' ~/.config/gtk-3.0/settings.ini

# Rtorrent magnet links
echo 'x-scheme-handler/magnet=rtorrent.desktop;' | tee -a ~/.config/mimeapps.list

# setting vdirsyncer
mkdir -p ~/.config/vdirsyncer
rsync -a ~/.user_config/applications/vdirsyncer/vdirsyncer_config_template ~/.user_config/no_share/vdirsyncer_config
ln -vsf ~/.user_config/no_share/vdirsyncer_config ~/.config/vdirsyncer/config
# But will not work, it needs configuration!

# setting khard
mkdir -p ~/.config/khard
ln -vsf ~/.user_config/applications/khard/khard.conf ~/.config/khard/

# setting khal
mkdir -p ~/.config/khal
ln -vsf ~/.user_config/applications/khal/config ~/.config/khal/

##### Changes to the system #####





#####################

# INCORPORATING INSTALL STUFF FROM SAKAKI
# Setting openrc
sudo sed -i 's/^rc_parallel=".*$/rc_parallel="YES"/' /etc/rc.conf
sudo sed -i 's/^rc_logger=".*$/rc_logger="YES"/' /etc/rc.conf

#####################
# set ccache
sudo mkdir -p /var/cache/ccache
sudo chown root:portage /var/cache/ccache
sudo chmod 2775 /var/cache/ccache
sudo rsync -a $files_skel/var/cache/ccache/ccache.conf /var/cache/ccache/ccache.conf

# Coloring dispatch-conf
sudo sed -i 's/^diff=".*$/diff="colordiff -Nu '%s' '%s'"/' /etc/dispatch-conf.conf

# Set things at "/etc/portage"
sudo rsync -a --delete $files_skel/etc/portage/ /etc/portage/

# fstab
sudo cat $files_skel/etc/fstab >> /etc/fstab

# Making udevil able to mount devices
sudo chown root:root /usr/bin/udevil
sudo chmod u+s,go-s,ugo+x /usr/bin/udevil

# Setting post boot script
sudo rsync -a $files_skel/local.d/postboot.start /etc/local.d/
sudo chmod -v 755 /etc/local.d/postboot.start

# Setting nano colors
# User
#sudo sed -i 's/^# set linenumbers.*$/set linenumbers/' /etc/nanorc
#sudo sed -i 's/^# set mouse.*$/set mouse/' /etc/nanorc
#sudo sed -i 's/^# set titlecolor bold,lightwhite,blue.*$/set titlecolor bold,lightwhite,blue/' /etc/nanorc
#sudo sed -i 's/^# set statuscolor bold,lightwhite,green.*$/set statuscolor bold,lightwhite,green/' /etc/nanorc
#sudo sed -i 's/^# set errorcolor bold,lightwhite,red.*$/set errorcolor bold,lightwhite,red/' /etc/nanorc
#sudo sed -i 's/^# set selectedcolor lightwhite,magenta.*$/set selectedcolor lightwhite,magenta/' /etc/nanorc
#sudo sed -i 's/^# set stripecolor ,yellow.*$/set stripecolor ,yellow/' /etc/nanorc
#sudo sed -i 's/^# set scrollercolor cyan.*$/set scrollercolor cyan/' /etc/nanorc
#sudo sed -i 's/^# set numbercolor cyan.*$/set numbercolor cyan/' /etc/nanorc
#sudo sed -i 's/^# set keycolor cyan.*$/set keycolor cyan/' /etc/nanorc
#sudo sed -i 's/^# set functioncolor green.*$/set functioncolor green/' /etc/nanorc
# Root
#sudo sed -i 's/^# set titlecolor bold,lightwhite,magenta.*$/set titlecolor bold,lightwhite,magenta/' /etc/nanorc
#sudo sed -i 's/^# set statuscolor bold,lightwhite,magenta.*$/set statuscolor bold,lightwhite,magenta/' /etc/nanorc
#sudo sed -i 's/^# set errorcolor bold,lightwhite,red.*$/set errorcolor bold,lightwhite,red/' /etc/nanorc
#sudo sed -i 's/^# set selectedcolor lightwhite,cyan.*$/set selectedcolor lightwhite,cyan/' /etc/nanorc
#sudo sed -i 's/^# set stripecolor ,yellow.*$/set stripecolor ,yellow/' /etc/nanorc
#sudo sed -i 's/^# set scrollercolor magenta.*$/set scrollercolor magenta/' /etc/nanorc
#sudo sed -i 's/^# set numbercolor magenta.*$/set numbercolor magenta/' /etc/nanorc
#sudo sed -i 's/^# set keycolor lightmagenta.*$/set keycolor lightmagenta/' /etc/nanorc
#sudo sed -i 's/^# set functioncolor magenta.*$/set functioncolor magenta/' /etc/nanorc

# Configure Profile Sync Daemon
sudo sed -i 's/^#USE_OVERLAYFS=".*$/USE_OVERLAYFS="yes"/' /etc/psd.conf
sudo sed -i 's/^USERS=".*$/USERS="'"root $user_name"'"/' /etc/psd.conf

# Setting Prelink
sudo sed -i 's/^PRELINKING.*$/PRELINKING="yes"/' /etc/conf.d/prelink
sudo sed -i 's/^PRELINK_OPTS.*$/PRELINK_OPTS="-amR"/' /etc/conf.d/prelink
sudo prelink -amR

# Setting special paths

# Setting keyboard on the xorg server for spanish
sudo rsync -a $files_skel/etc/X11/xorg.conf.d/00-keyboard.conf /etc/X11/xorg.conf.d/

# Setting libinput ONLY MY DELL, REPLACE THE "INDENTIFIER"
sudo rsync -a $files_skel/etc/X11/xorg.conf.d/40-libinput.conf /etc/X11/xorg.conf.d/

# Setting intel driver tune up as per Sabayon reccomendation
#sudo rsync -a $files_skel/etc/X11/xorg.conf.d/10-intel.conf /etc/X11/xorg.conf.d/

# Setting secure values for the screen locker
sudo rsync -a $files_skel/etc/X11/xorg.conf.d/30-secure-locker.conf /etc/X11/xorg.conf.d/

# Taking the cache to /tmp for SSD performance
sudo rsync -a $files_skel/etc/profile.d/xdg_cache_home.sh /etc/profile.d/
sudo chmod +x /etc/profile.d/xdg_cache_home.sh

# Disable some D-BUS stuff
sudo rsync -a $files_skel/etc/env.d/99user_config /etc/env.d/

# Setting microcode
#sudo cat $files_skel/etc/genkernel.conf >> /etc/genkernel.conf

# Setting up configurations for hotspot.sh
# User interaction
echo '* Setting up hotspot.sh'
read -p 'Enter a name for your hotspot ' hotspot_ssid
read -p 'Enter a password for your hotspot ' hotspot_password
read -p 'Enter the MAC address you want to allow ' accept_mac
echo '* You can modify this configuration editing the files: "/etc/hostapd/user_config.conf" and "/etc/hostapd/user_config_accept.conf"'
# Making sure open-rc recognize the interfaces
sudo ln -vsf /etc/init.d/net.lo /etc/init.d/net.$ethernet_card
sudo ln -vsf /etc/init.d/net.lo /etc/init.d/net.$wireless_card
# telling openrc how to configure the interface for the hotspot
sudo cat $files_skel/etc/conf.d/net > /etc/conf.d/net
sudo sed -i 's/WIRELESS_CARD=/'$wireless_card='/g' /etc/conf.d/net

# Creating Hostapd files
sudo cat $files_skel/etc/dnsmasq.conf >> /etc/dnsmasq.conf
sudo cat $files_skel/etc/hostapd/user_config.conf > /etc/hostapd/user_config.conf
# Setting variables
sudo sed -i 's/^INTERFACES=".*$/INTERFACES="'"$wireless_card"'"/' /etc/conf.d/hostapd
sudo sed -i "s/WIRELESS_CARD/'$wireless_card'/g" /etc/dnsmasq.conf
sudo sed -i "s/^interface=.*$/interface='$wireless_card'/g" /etc/hostapd/hostapd.conf
sudo sed -i "s/HOTSPOT_SSID/'$hotspot_ssid'/g" /etc//hostapd/user_config.conf
sudo sed -i "s/HOTSPOT_PASSWORD/'$hotspot_password'/g" /etc/hostapd/user_config.conf
sudo touch /etc/hostapd/user_config.accept
echo "$accept_mac" | sudo tee -a /etc/hostapd/user_config.accept

# Config wicd nl80211 driver
sudo sed -i 's/^wpa_driver =.*$/wpa_driver = nl80211/' /etc/wicd/manager-settings.conf

# Setting up configurations for "public_ip_gmail.sh" DEPRECATED, USING NEOMUTT NOW
#echo "* Setting up "public_ip_gmail.sh""
#sudo cat $files_skel/etc/postfix/main.cf >> /etc/postfix/main.cf
#sudo rsync -a $files_skel/etc/postfix/sasl_passwd /etc/postfix/
#sudo sed -i "s/USER_EMAIL/'$user_email'/g" /etc/postfix/sasl_passwd
#sudo sed -i "s/USER_EMAIL_PASSWORD/'$user_email_password'/g" /etc/postfix/sasl_passwd
# Make some security adjustments
#sudo postmap /etc/postfix/sasl/sasl_passwd
#sudo chmod 0600 /etc/postfix/sasl_passwd
#sudo chmod 0600 /etc/postfix/sasl_passwd.db

# Some settings for bluetooth
sudo cat $files_skel/etc/bluetooth/main.conf >> /etc/bluetooth/main.conf

# Setting Grub
#sudo mkdir -p /etc/default
#sudo cat $files_skel/etc/default/grub >> /etc/default/grub

#Setting Genkernel
#sudo cat $files_skel/etc/genkernel.conf >> /etc/genkernel.conf
sudo mkdir /real_boot
sudo rsync -a $files_skel/usr/sbin/kernup /usr/sbin/kernup

# Installing Showem
sudo rsync -a $files_skel/usr/sbin/showem /usr/sbin/showem

#Installing Genup script
sudo rsync -a $files_skel/usr/sbin/genup /usr/sbin/genup

# Installing multi_updater.sh script
sudo mkdir -p /etc/genup/updaters.d/
sudo rsync -a $files_skel/etc/genup/updaters.d/multi_updater.sh /etc/genup/updaters.d/
sudo chmod +x /etc/genup/updaters.d/multi_updater.sh

# Automating "genup"
sudo rsync -a $files_skel/etc/cron.daily/genup /etc/cron.daily/
sudo chmod +x /etc/cron.daily/genup

# Setting up "rsnapshot"
sudo mkdir -p /mnt/backup
sudo rsync -a $files_skel/etc/rsnapshot.conf /etc/
#sed -i 's/USER_NAME/'$user_name'/g' ~/rsnapshot.conf
sed -i 's/HOSTNAME/'$hostname'/g' ~/rsnapshot.conf

sudo rsync -a $files_skel/etc/cron.daily/rsnapshot.daily /etc/cron.daily/
sudo chmod +x /etc/cron.daily/rsnapshot.daily

sudo rsync -a $files_skel/etc/cron.weekly/rsnapshot.weekly /etc/cron.weekly/
sudo chmod +x /etc/cron.weekly/rsnapshot.weekly

sudo rsync -a $files_skel/etc/cron.monthly/rsnapshot.monthly /etc/cron.monthly/
sudo chmod +x /etc/cron.monthly/rsnapshot.monthly

# Setting external drive mounting
sudo mkdir -p /mnt/backup
sudo mkdir -p /mnt/encrypted_unit_1
sudo mkdir -p /mnt/encrypted_unit_2
sudo mkdir -p /mnt/encrypted_unit_3
# set permissions for the USER on the encrypted drive (DEPRECATED)
#sudo chown $user_name:$user_name /mnt/encrypted_unit_*

sudo mkdir -p /root/.user_config/no_share/luks/
sudo touch /root/.user_config/no_share/luks/encrypted_drive.key
dd if=/dev/urandom bs=8388607 count=1 of=/root/.user_config/no_share/luks/encrypted_drive.key

read -p '* Please, enter the UUID for your encrypted drive: ' encrypted_drive_uuid
# mount script
#sudo rsync -a $files_skel/etc/local.d/mount_external_drive.start /etc/local.d/
# Set proper UUID for the user's drive on the Rsnapshot cron-jobs
sudo sed -i "s/ENCRYPTED_DRIVE_UUID/$encrypted_drive_uuid/g" /etc/{cron.daily/rsnapshot.daily,cron.weekly/rsnapshot.weekly,cron.monthly/rsnapshot.monthly}
# Set the proper UUID for the user's drive on the mounter script
touch ~/.user_config/no_share/encrypted_drive_variables
echo -e "# Southern Tools\n#\n#\nencrypted_drive_uuid=ENCRYPTED_DRIVE_UUID\nencrypted_drive_key_file=/root/.user_config/no_share/luks/encrypted_drive.key" | tee ~/.user_config/no_share/encrypted_drive_variables
sed -i "s/ENCRYPTED_DRIVE_UUID/$encrypted_drive_uuid/g" ~/.user_config/no_share/encrypted_drive_variables


# Setting defragmentation monthly script
sudo rsync -a $files_skel/etc/cron.monthly/defrag.monthly /etc/cron.monthly/
sudo chmod +x /etc/cron.monthly/defrag.monthly

#
sudo sed -i "s/# periodic_e2scrub=1/periodic_e2scrub=1/g" /etc/e2scrub.conf

# Vulkan driver for amdgpu-pro
sudo rsync -a $files_skel/opt/ /opt/

# modprobe.d contents
# ONLY FOR MY DELL
#sudo rsync -a $files_skel/etc/modprobe.d/blacklist.conf /etc/modprobe.d/

# Sound card
sudo cat $files_skel/etc/modprobe.d/alsa.conf >> /etc/modprobe.d/alsa.conf

# strip down some services (DEPRECATED)
#rc-update del binfmt boot
#rc-update del opentmpfiles-dev sysinit


##### Final message #####
echo -e "* The installation of Southern Tools is done, enjoy your not-so-minimalistic system ;)"
