#!/bin/bash

##############################################
# this script is run on every boot (as root) #
##############################################

touch /tmp/on_every_boot_lastrun.txt

# remove some cron files
rm -f /etc/cron.daily/apt-compat
rm -f /etc/cron.daily/aptitude
rm -f /etc/cron.daily/man-db
rm -f /etc/cron.weekly/man-db

# mount tmpfs dir
rm -Rf /home/pi/barcode_scan/share/
mkdir -p /home/pi/barcode_scan/share/
mount -t tmpfs -o size=1M tmpfs /home/pi/barcode_scan/share/
chmod a+rwx /home/pi/barcode_scan/share/

# call on_boot script
su - pi bash -c '/home/pi/barcode_scan/scripts/on_boot.sh' > /dev/null 2>&1 &

# higher priority to eth0 (over wlan0)
# this may cause issues ??
## ifmetric wlan0 404

# set timezone automatically
tzupdate
dpkg-reconfigure -f noninteractive tzdata

# start the OS update script in the background
bash /loop_update_os.sh >/dev/null 2>/dev/null &

# mount tox db encrypted storage dir
bash /mount_tox_db.sh

# disable some unused stuff
# systemctl stop tor
# systemctl disable tor
systemctl stop dbus
systemctl stop dbus.socket
systemctl disable dbus.socket
systemctl disable dbus

