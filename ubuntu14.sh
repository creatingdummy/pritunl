#!/bin/bash

# go to root
cd

# Install Pritunl
#!/bin/bash
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list
echo "deb http://repo.pritunl.com/stable/apt trusty main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv EA312927
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv CF8E292A
apt-get --assume-yes update
apt-get --assume-yes install pritunl mongodb-org
service pritunl start


# Enable Firewall
sudo ufw allow 22,80,81,222,443,8080,9700,60000/tcp
sudo ufw allow 22,80,81,222,443,8080,9700,60000/udp
sudo yes | ufw enable

# Change to Time GMT+8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# Install Web Server
apt-get -y install nginx php5-fpm php5-cli
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/zero9911/pritunl/master/conf/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by Fadhil Morshidi </pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/zero9911/pritunl/master/conf/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# Install Vnstat
apt-get -y install vnstat
vnstat -u -i eth0
sudo chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart

# Install Vnstat GUI
cd /home/vps/public_html/
wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# About
clear
echo "Script ini hanya mengandungi :-"
echo "-Pritunl"
echo "-webmin"
echo "-MongoDB"
echo "-Vnstat"
echo "-Web Server"
echo "-Squid Proxy Port 7166,60000"
echo "BY Mr's Dummy"
echo "Script Dummies By Fadhil Morshidi"
echo "TimeZone   :  Malaysia"
echo "Vnstat     :  http://$MYIP:81/vnstat"
echo "Pritunl    :  https://$MYIP"
echo "Sila login ke pritunl untuk proceed step seterusnya"
echo "Sila copy code dibawah untuk Pritunl anda"
pritunl setup-key
rm -f /root/ubuntu14.sh
