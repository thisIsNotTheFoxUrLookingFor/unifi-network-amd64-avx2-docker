#!/bin/bash
touch /var/spool/cron/crontabs/root
crontab -l > mycron
echo "0 0 * * * /usr/bin/certbot -q renew" >> mycron
crontab mycron
rm mycron
service start cron
wget -O unifi.deb https://unifi-install.foxtrot.blog/unifi
dpkg -i unifi.deb
rm unifi.deb
apt list --installed
if [ -e /config/extras.sh ]
then
    echo "Running extras run script"
    sh /config/extras.sh # create this script file to provision SSL certificates or anything extra you want to do
else
    echo "Nothing further to run"
fi
/etc/init.d/unifi start
while true; do sleep infinity; done
