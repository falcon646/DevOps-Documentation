#!/bin/bash
sudo apt update
sudo apt install nginx -y 
sudo systemctl start nginx && systemctl enable nginx
sudo apt install php php-cli php-common php-imap php-fpm php-snmp php-xml php-zip php-mbstring php-curl php-mysqli php-gd php-intl -y
sudo apt install mariadb-server -y
sudo systemctl start mariadb && sudo systemctl enable mariadb