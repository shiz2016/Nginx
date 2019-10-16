#!/bin/bash

yum -y install gcc      pcre-devel     openssl-devel
yum -y install php      php-fpm        php-mysql 
yum -y install mariadb  mariadb-devel  mariadb-server

tar -xf nginx-1.12.2.tar.gz 
cd nginx-1.12.2
./configure --with-http_ssl_module
make && make install

#path1="/usr/local/nginx/conf/nginx.conf"
#sed -i '17a 	fastcgi_buffers 8 16k;' $path1
#sed -i '18a 	fastcgi_buffer_size 32k;' $path1
#sed -i '19a 	fastcgi_connect_timeout 300;' $path1
#sed -i '20a 	fastcgi_send_timeout 300;' $path1
#sed -i '21a 	fastcgi_read_timeout 300;' $path1
#sed -i '50s/index  index.html/index index.php index.html/' $path1
#sed -i '70,73s/#//;75,76s/#//' $path1
#sed -i 's/fastcgi_params/fastcgi.conf/' $path1

cd .. #返回脚本所在目录
\cp nginx.conf /usr/local/nginx/conf/

ln -s /usr/local/nginx/sbin/nginx /bin/
nginx || nginx -s reload
#echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.local
#chmod +x /etc/rc.local
\cp rc.local /etc/rc.local
systemctl restart mariadb php-fpm
systemctl enable mariadb php-fpm

cp test.php /usr/local/nginx/html
clear 
curl http://192.168.1.222/test.php
sleep 5


yum -y install  net-snmp-devel curl-devel #安装相关依赖包
yum -y install libevent-devel-2.0.21-4.el7.x86_64.rpm
tar -xf zabbix-3.4.4.tar.gz
cd zabbix-3.4.4/
./configure  --enable-server  --enable-proxy --enable-agent --with-mysql=/usr/bin/mysql_config --with-net-snmp --with-libcurl
make install

mysql -e "create database zabbix character set utf8;"
mysql -e "grant all on zabbix.* to zabbix@'localhost' identified by 'zabbix';"
cd database/mysql/
mysql -uzabbix -pzabbix zabbix < schema.sql
mysql -uzabbix -pzabbix zabbix < images.sql
mysql -uzabbix -pzabbix zabbix < data.sql

cd ../../.. #切换至脚本所在目录
cd zabbix-3.4.4/frontends/php/
\cp -r * /usr/local/nginx/html/
chmod -R 777 /usr/local/nginx/html/*

#sed -i '85s/#//' /usr/local/etc/zabbix_server.conf
#sed -i '119s/#//' /usr/local/etc/zabbix_server.conf
#sed -i '119s/$/zabbix/'   /usr/local/etc/zabbix_server.conf

cd ../../.. #切换至脚本所在目录
\cp zabbix_server.conf /usr/local/etc/

useradd -s /sbin/nologin zabbix
zabbix_server 
clear;sleep 3
ss -ntulp |grep zabbix_server
sleep 3

sed -i '93s/$/,192.168.1.222/'  /usr/local/etc/zabbix_agentd.conf
sed -i '134s/$/,192.168.1.222/' /usr/local/etc/zabbix_agentd.conf
sed -i '280s/#//;280s/0/1/'   /usr/local/etc/zabbix_agentd.conf
zabbix_agentd
clear;sleep 3
ss -ntulp |grep zabbix_agentd 
sleep 3

yum -y install  php-gd php-xml
yum -y install php-bcmath
yum -y install php-mbstring
#sed -i '878s#$# Asia/Shanghai#;878s/.//' /etc/php.ini
#sed -i '384s/30/300/' /etc/php.ini
#sed -i '672s/8M/32M/' /etc/php.ini
#sed -i '394s/60/300/' /etc/php.ini
\cp php.ini /etc/
systemctl restart php-fpm





















