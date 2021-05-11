#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "#-#-# This script must be run as root #-#-#" 
   exit 1
fi

echo "#-#-# Update apt #-#-#"
apt -y update

echo "#-#-# Install tor #-#-#"
apt -y install tor

echo "#-#-# Configuring torrc #-#-#"
line="HiddenServiceDir \/var\/lib\/tor\/hidden_service\/"
sed -i "/${line}/ s/# *//" /etc/tor/torrc

line="HiddenServicePort 80 127.0.0.1:80"
sed -i "/${line}/ s/# *//" /etc/tor/torrc

echo "#-#-# Restart tor service #-#-#"
service tor restart

echo "#-#-# Installing nginx #-#-#"
apt install -y nginx

echo "#-#-# Configuring nginx #-#-#"
line="server_tokens off"
sed -i "/${line}/ s/# *//" /etc/nginx/nginx.conf

line2="port_in_redirect off;"
sed -i "/${line}/a ${line2}" /etc/nginx/nginx.conf

line="server_name_in_redirect off"
sed -i "/${line}/ s/# *//" /etc/nginx/nginx.conf

echo "#-#-# Starting nginx #-#-#"
service nginx start

echo "#-#-# Your site is up on: #-#-#"
cat /var/lib/tor/hidden_service/hostname

echo "#-#-# Changing files under /var/www/html/ to expose your website #-#-#"
