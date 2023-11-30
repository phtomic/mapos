#!/bin/bash
echo "Starting nginx service"
service php8.2-fpm start
service nginx start
echo "Server started"

if [ ! -d "/www/cfg" ]; then
    mkdir /www/cfg
fi
if [ ! -f "/www/cfg/database.php" ]; then
    cp /www/config/database.php /www/cfg/database.php
fi
if [ ! -f "/www/cfg/config.php" ]; then
    cp /www/config/config.php /www/cfg/config.php
fi
if [ ! -f "/www/cfg/index.php" ]; then
    cp /www/config/index.php /www/cfg/index.php
fi
if [ ! -d "/www/cfg/assets" ]; then
    cp -r /www/config/assets /www/cfg/assets
fi
rm -R /www/config
chmod 777 -R /www/cfg
ln -s /www/cfg /www/config
chmod 777 -R /www/html/application/config
tail -f /dev/stdout