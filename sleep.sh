#!/bin/bash
echo "Starting nginx service"
service php8.2-fpm start
service nginx start
echo "Server started"
tail -f /dev/stdout